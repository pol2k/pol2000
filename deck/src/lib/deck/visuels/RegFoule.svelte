<script>
  /**
   * La foule des 19 736 : chaque personne de la population d'exercice qui a
   * répondu aux deux questions (scolarité, 5 niveaux, et intérêt, 11
   * valeurs, tout de 0 à 1) est un petit carré. Les carrés sont dessinés
   * sur un canevas (19 736 éléments SVG seraient trop lourds) et glissent
   * d'une disposition à l'autre avec requestAnimationFrame. Les axes sont en
   * SVG dessous, les moyennes et la droite en SVG dessus.
   *
   * Pas d'état propre : le parent donne `etape`.
   *   0  Les axes seuls.
   *   1  Les 19 736 tombent à leur position exacte. Elles s'empilent : on ne
   *      voit que 55 points (5 niveaux × 11 valeurs).
   *   2  Elles s'écartent : chacune prend une place à elle dans un rectangle
   *      autour de sa case. La foule apparaît, plus dense là où il y a du
   *      monde.
   *   3  Elles se regroupent : dans chaque case, une barre de carrés serrés
   *      dont la largeur suit le nombre de personnes. On voit où sont les
   *      gens.
   *   4  Les cinq moyennes, des points rouges dont la taille suit le nombre
   *      de personnes du niveau (POP.moyennes). La foule pâlit.
   *   5  La droite de la population (POP.b0, POP.b1).
   *
   * Personne n'est inventé : les 19 736 carrés sont exactement les comptes
   * de POP.cases (outils/seance7_data.R), case par case. Seule la place
   * d'un carré dans sa case est fabriquée, pour le dessin : un tirage
   * pseudo-aléatoire à graine fixe (mulberry32, graine 2025), donc le même
   * à chaque fois, sans Math.random.
   */
  import { onMount } from 'svelte';
  import { POP, VARS } from '$lib/data/seance7.js';

  let { etape = 0 } = $props();

  // Repères (viewBox 820 × 540), les mêmes que RegBulles.
  const W = 820, H = 540;
  const X0 = 214, X1 = 768, Y0 = 430, Y1 = 50;
  const sx = (v) => X0 + v * (X1 - X0);
  const sy = (v) => Y0 - v * (Y0 - Y1);
  const AXE_X = Y0 + 26, AXE_Y = X0 - 64;

  const virgule = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  const NX = VARS.x.niveaux.map((t) => {
    const s = t.toLowerCase();
    const i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return j > 0 ? [s.slice(0, j), s.slice(j + 1)] : [s, ''];
  });
  const BORNES = VARS.y.bornes.map((t) => { const s = t.toLowerCase(); const j = s.indexOf(' '); return [s.slice(0, j), s.slice(j + 1)]; });
  const TICKS = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const MAXM = Math.max(...POP.moyennes.map((m) => m.n));
  const rayonM = (n) => Math.max(6, 16 * Math.sqrt(n / MAXM));
  const prevu = (x) => POP.b0 + POP.b1 * x;

  // ---- Les trois dispositions, calculées une fois.
  const N = POP.cases.reduce((s, c) => s + c.n, 0); // 19 736
  const MAXC = Math.max(...POP.cases.map((c) => c.n));
  const EX = new Float32Array(N), EY = new Float32Array(N); // exacte
  const DX = new Float32Array(N), DY = new Float32Array(N); // écartée
  const GX = new Float32Array(N), GY = new Float32Array(N); // regroupée
  const DEMI_L = 58, DEMI_H = 15; // le rectangle autour de chaque case
  const BANDE = 30, LARGE = 124; // la barre la plus large, en unités du dessin
  const PAS = Math.sqrt((BANDE * LARGE) / MAXC); // même densité partout
  const RANGS = Math.floor(BANDE / PAS);
  // Un générateur à graine fixe : le même dessin à chaque chargement.
  function mulberry32(a) {
    return () => {
      a |= 0; a = (a + 0x6d2b79f5) | 0;
      let t = Math.imul(a ^ (a >>> 15), 1 | a);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
  const alea = mulberry32(2025);
  {
    let i = 0;
    for (const c of POP.cases) {
      const cx = sx(c.x), cy = sy(c.y);
      const debut = i;
      const u = new Float32Array(c.n);
      for (let k = 0; k < c.n; k++, i++) {
        EX[i] = cx; EY[i] = cy;
        u[k] = alea();
        const v = alea();
        DX[i] = cx + (u[k] * 2 - 1) * DEMI_L;
        DY[i] = cy + (v * 2 - 1) * DEMI_H;
      }
      // Regroupées : on range de gauche à droite dans l'ordre où elles
      // étaient écartées, pour que le geste soit lisible.
      const ordre = [...u.keys()].sort((a, b) => u[a] - u[b]);
      const cols = Math.ceil(c.n / RANGS);
      ordre.forEach((k, rang) => {
        const col = Math.floor(rang / RANGS), ligne = rang % RANGS;
        GX[debut + k] = cx + (col - (cols - 1) / 2) * PAS;
        GY[debut + k] = cy + (ligne - (RANGS - 1) / 2) * PAS;
      });
    }
  }
  // Taille d'un carré et opacité pour chaque étape.
  const TAILLE = [6, 6, 1.7, PAS, PAS, PAS]; // regroupées : des barres pleines
  const ALPHA = [0, 0.5, 0.55, 0.8, 0.22, 0.22];

  // ---- Le canevas.
  let hote = $state(null);
  let toile = $state(null);
  let ctx = null;
  const PX = new Float32Array(N), PY = new Float32Array(N); // positions affichées
  const FX = new Float32Array(N), FY = new Float32Array(N); // départ d'un trajet
  let taille = TAILLE[0], alpha = 0, t0 = 0, de = { taille, alpha }, vers = 0, anim = 0;
  const DUREE = 1100, DECALAGE = 350;
  const lisse = (t) => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);
  const cible = (k) => (k <= 1 ? [EX, EY] : k === 2 ? [DX, DY] : [GX, GY]);
  const lent = () => !window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // On écrit les pixels nous-mêmes (une image, une seule copie par trame) :
  // 19 736 appels à fillRect par trame, c'est trop lent pour un vieux
  // portable de projection. Chaque pixel garde sa couverture (0 à 1); la
  // couleur est l'encre du deck.
  let echelle = 1, ox = 0, oy = 0, image = null, couv = null, rgb = [12, 14, 15];

  function dimensionner() {
    if (!toile || !hote) return;
    const r = toile.getBoundingClientRect();
    const dpr = window.devicePixelRatio || 1;
    toile.width = Math.max(1, Math.round(r.width * dpr));
    toile.height = Math.max(1, Math.round(r.height * dpr));
    // Même placement que le SVG (preserveAspectRatio « meet », centré).
    const e = Math.min(r.width / W, r.height / H);
    echelle = e * dpr;
    ox = ((r.width - W * e) / 2) * dpr;
    oy = ((r.height - H * e) / 2) * dpr;
    ctx = toile.getContext('2d');
    image = ctx.createImageData(toile.width, toile.height);
    couv = new Float32Array(toile.width * toile.height);
    dessiner();
  }

  function dessiner() {
    if (!ctx || !image) return;
    const L = toile.width, Hh = toile.height;
    couv.fill(0);
    if (alpha > 0) {
      const c = Math.max(1, taille * echelle);
      const d = c / 2;
      for (let i = 0; i < N; i++) {
        const cx = PX[i] * echelle + ox, cy = PY[i] * echelle + oy;
        const x0 = Math.max(0, Math.round(cx - d)), y0 = Math.max(0, Math.round(cy - d));
        const x1 = Math.min(L, Math.max(x0 + 1, Math.round(cx + d))), y1 = Math.min(Hh, Math.max(y0 + 1, Math.round(cy + d)));
        for (let y = y0; y < y1; y++) {
          let k = y * L + x0;
          for (let x = x0; x < x1; x++, k++) couv[k] += alpha * (1 - couv[k]);
        }
      }
    }
    const px = image.data;
    for (let k = 0, j = 0; k < couv.length; k++, j += 4) {
      px[j] = rgb[0]; px[j + 1] = rgb[1]; px[j + 2] = rgb[2]; px[j + 3] = couv[k] * 255;
    }
    ctx.putImageData(image, 0, 0);
  }

  function aller(k) {
    const [TX, TY] = cible(k);
    if (!lent()) {
      PX.set(TX); PY.set(TY); taille = TAILLE[k]; alpha = ALPHA[k]; vers = k;
      dessiner();
      return;
    }
    FX.set(PX); FY.set(PY);
    // Arrivée : les carrés tombent d'un peu plus haut.
    if (vers === 0 && k >= 1) { FX.set(TX); for (let i = 0; i < N; i++) FY[i] = TY[i] - 60; }
    de = { taille, alpha };
    vers = k;
    t0 = performance.now();
    cancelAnimationFrame(anim);
    anim = requestAnimationFrame(pas);
  }

  function pas(now) {
    const [TX, TY] = cible(vers);
    const t = Math.min(1, (now - t0) / (DUREE + DECALAGE));
    const g = lisse(Math.min(1, (now - t0) / DUREE));
    taille = de.taille + (TAILLE[vers] - de.taille) * g;
    alpha = de.alpha + (ALPHA[vers] - de.alpha) * g;
    for (let i = 0; i < N; i++) {
      // Chacun part un peu après le précédent, sur DECALAGE ms en tout.
      const r = Math.min(1, Math.max(0, (now - t0 - (i % 97) / 97 * DECALAGE) / DUREE));
      const s = lisse(r);
      PX[i] = FX[i] + (TX[i] - FX[i]) * s;
      PY[i] = FY[i] + (TY[i] - FY[i]) * s;
    }
    dessiner();
    if (t < 1) anim = requestAnimationFrame(pas);
  }

  onMount(() => {
    const hex = getComputedStyle(hote).getPropertyValue('--dk-encre').trim();
    if (/^#[0-9a-f]{6}$/i.test(hex)) rgb = [1, 3, 5].map((k) => parseInt(hex.slice(k, k + 2), 16));
    PX.set(EX); PY.set(EY);
    const ro = new ResizeObserver(dimensionner);
    ro.observe(toile);
    dimensionner();
    return () => { ro.disconnect(); cancelAnimationFrame(anim); };
  });

  let precedente = 0;
  $effect(() => {
    const k = etape;
    if (!ctx) return;
    if (k !== precedente) { precedente = k; aller(k); }
  });
</script>

<div class="rf" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" class="fond" role="img"
    aria-label="Les 19 736 répondant.e.s de la CES 2025, une par point : l’intérêt pour la politique selon la scolarité. Empilées, elles ne font que 55 points. Écartées puis regroupées, on voit où sont les gens. Les cinq moyennes montent d’un niveau à l’autre, et la droite passe presque sur elles.">
    <line x1={AXE_Y} y1={AXE_X} x2={X1 + 30} y2={AXE_X} class="axe" />
    <line x1={AXE_Y} y1={AXE_X} x2={AXE_Y} y2={Y1 - 24} class="axe" />
    {#each VARS.x.valeurs as v, i}
      <line x1={sx(v)} y1={AXE_X} x2={sx(v)} y2={AXE_X + 7} class="axe" />
      <text x={sx(v)} y={AXE_X + 27} class="val">{virgule(v)}</text>
      <text x={sx(v)} y={AXE_X + 48} class="niv">{NX[i][0]}</text>
      <text x={sx(v)} y={AXE_X + 66} class="niv">{NX[i][1]}</text>
    {/each}
    {#each TICKS as v}
      <line x1={AXE_Y - 7} y1={sy(v)} x2={AXE_Y} y2={sy(v)} class="axe" />
      <text x={AXE_Y - 13} y={sy(v) + 6} class="val d">{virgule(v)}</text>
    {/each}
    <text x={AXE_Y - 52} y={sy(1) - 2} class="niv d">{BORNES[1][0]}</text>
    <text x={AXE_Y - 52} y={sy(1) + 15} class="niv d">{BORNES[1][1]}</text>
    <text x={AXE_Y - 52} y={sy(0) - 2} class="niv d">{BORNES[0][0]}</text>
    <text x={AXE_Y - 52} y={sy(0) + 15} class="niv d">{BORNES[0][1]}</text>
    <text x={(X0 + X1) / 2} y="534" class="titre-axe">scolarité</text>
    <text x={AXE_Y - 13} y="16" class="titre-axe d">intérêt</text>
  </svg>

  <canvas bind:this={toile} aria-hidden="true"></canvas>

  <svg viewBox="0 0 {W} {H}" class="dessus" aria-hidden="true">
    <path d="M {sx(0)} {sy(prevu(0))} L {sx(1)} {sy(prevu(1))}" pathLength="1" class="droite" class:vu={etape >= 5} />
    {#each POP.moyennes as m, i}
      <circle cx={sx(m.x)} cy={sy(m.moyenne)} r={rayonM(m.n)} class="moy" class:vu={etape >= 4} style="--k: {i}" />
    {/each}
  </svg>
</div>

<style>
  .rf { position: relative; width: 100%; }
  .fond { width: 100%; height: auto; display: block; max-height: 66vh; }
  canvas, .dessus { position: absolute; inset: 0; width: 100%; height: 100%; display: block; pointer-events: none; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .val { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .niv { font-size: 15px; text-anchor: middle; fill: var(--dk-encre); }
  .val.d, .niv.d { text-anchor: end; }
  .titre-axe { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .titre-axe.d { text-anchor: end; }

  .moy { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2.5; opacity: 0; transform-box: fill-box; transform-origin: center; transform: scale(0.2);
    transition: opacity 0.3s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); transition-delay: calc(var(--k) * 90ms); }
  .moy.vu { opacity: 1; transform: none; }
  .droite { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .droite.vu { stroke-dashoffset: 0; }

  @media (prefers-reduced-motion: reduce) {
    .moy, .droite { transition: none; }
  }
</style>
