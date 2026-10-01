<script>
  /**
   * Le monde à 100 g, construit panier par panier, pour une seule question :
   * si ses pommes étaient ordinaires, un panier comme le sien serait-il rare ?
   * Une idée par temps, une phrase en haut (qui change à chaque temps), le
   * dessin au milieu, le verdict en bas. Tout vient de PANIERS
   * (src/lib/data/seance5_normale.js, simulation d'outils/seance5_normale.R,
   * pommes fictives, dit à l'écran) et de POMMES (src/lib/data/seance5.js :
   * 50 pommes par panier, 100 g, 105 g).
   *
   * C'est le monde à 100 g, pas « le monde de H0 » : depuis le 1er octobre
   * 2026, H0 dit « 100 g ou moins », et la diapo d'avant (PourquoiH0)
   * explique pourquoi on ne construit que celui-là.
   *
   * Avec panier = 105 (la diapo principale), cinq temps :
   *   0  « Imaginons des pommes ordinaires » : l'axe des poids et la ligne
   *      pointillée de 100 g, vides.
   *   1  Un panier de 50 pommes tombe sur l'axe, à son poids moyen :
   *      PANIERS.moyennes[0] (100,7 g).
   *   2  Un autre panier, un autre poids : PANIERS.moyennes[1] (97,3 g). Le
   *      premier pâlit.
   *   3  Mille paniers : les deux paniers s'effacent, les bâtons montent en
   *      trois secondes (requestAnimationFrame), une cloche autour de 100 g.
   *      L'état final est fixé : dès le temps 4, ou après trois secondes, les
   *      1 000 paniers sont tous là, toujours les mêmes.
   *   4  Son panier, 105 g, en rouge; les bâtons de 105 g ou plus passent au
   *      rouge; le compte, PANIERS.auMoins105 (27) sur 1 000.
   *   5  Le verdict : « Si ses pommes étaient ordinaires, un panier comme le
   *      sien arriverait environ 3 fois sur 100. C'est rare : on rejette
   *      H0. » La phrase du haut tire la leçon de la diapo PourquoiH0.
   * Avec panier = 102 (la diapo « et si »), le monde est déjà construit,
   * trois temps (ramenés à 3, 4 et 5 ci-dessus) :
   *   0  Les 1 000 paniers, la cloche.
   *   1  Un panier de 102 g, et le compte, PANIERS.auMoins102 (217) sur 1 000.
   *   2  « … environ 22 fois sur 100. Ce n'est pas rare : on ne rejette pas
   *      H0. » En haut : on ne peut pas conclure, et ça ne prouve pas que ses
   *      pommes sont ordinaires (Arel-Bundock 2021, p. 75).
   *
   * « Environ k fois sur 100 » est le compte sur 1 000 divisé par 10 et
   * arrondi : un seul chiffre à l'écran, celui de la simulation. Le seuil
   * de « rare » (moins de 50 sur 1 000) reste dans le code, pas à l'écran.
   *
   * Remanié le 1er octobre 2026 : le professeur ne comprenait pas l'ancienne
   * version (dix paniers d'un coup, un titre long, un verdict technique).
   */
  import { brancherTemps } from '../temps.js';
  import { PANIERS } from '$lib/data/seance5_normale.js';
  import { POMMES } from '$lib/data/seance5.js';
  let { panier = POMMES.moyenne } = $props();
  const rapide = panier !== POMMES.moyenne;
  let e = $state(0);
  let hote = $state(null);
  const TOTAL = rapide ? 2 : 5;
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const N = '\u202f';
  // Les temps, ramenés à ceux de la diapo principale.
  const T = $derived(rapide ? e + 3 : e);

  const G0 = 90, G1 = 110, X0 = 70, X1 = 930, BASE = 350, HAUT = 200;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const B = PANIERS.bornes, M = PANIERS.moyennes;
  const L = x(B[1]) - x(B[0]);
  const tranche = (m) => Math.min(B.length - 2, Math.max(0, Math.floor((m - B[0]) / (B[1] - B[0]))));
  const MAX = Math.max(...PANIERS.effectifs);
  const H0 = POMMES.h0, NB_POMMES = POMMES.n, TOUS = f(PANIERS.n);

  // 1 et 2 : deux paniers, dessinés, posés sur l'axe à leur poids moyen.
  // Cinq rangées de dix pommes : POMMES.n = 50.
  const POMMES_PANIER = Array.from({ length: NB_POMMES }, (_, i) => ({ dx: ((i % 10) - 4.5) * 5, dy: -6 - Math.floor(i / 10) * 5.4 }));
  const DEUX = [0, 1].map((i) => ({ i, m: M[i], cx: x(M[i]) }));

  // 3 : les mille paniers arrivent en trois secondes; état final déterministe.
  const DUREE = 3000;
  let t = $state(0);
  $effect(() => {
    if (T !== 3 || rapide) return;
    t = 0;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const combien = $derived(T < 3 ? 0 : T > 3 || rapide ? M.length : Math.min(M.length, Math.round((t / DUREE) * M.length)));
  const COMPTES = $derived.by(() => {
    const c = new Array(B.length - 1).fill(0);
    for (let i = 0; i < combien; i++) c[tranche(M[i])]++;
    return c;
  });

  const XP = x(panier);
  const nb = panier === POMMES.moyenne ? PANIERS.auMoins105 : PANIERS.auMoins102;
  const sur100 = Math.round(nb / 10);
  const rare = nb < 50;

  // La phrase du haut, une par temps : [principale, secondaire].
  const PHRASES = rapide
    ? {
        3: [`Le même monde${N}: des pommes ordinaires.`, `${TOUS} paniers, une cloche autour de ${H0} g`],
        4: [`Un panier de ${panier} g.`, `Combien de paniers ordinaires pèsent autant${N}?`],
        5: ['On ne peut pas conclure.', 'Ça ne prouve pas que ses pommes sont ordinaires.']
      }
    : {
        0: ['Imaginons des pommes ordinaires.', `${H0} g en moyenne${N}: le monde à ${H0} g`],
        1: [`On remplit un panier de ${NB_POMMES} pommes.`, `Il pèse ${f(M[0], 1)} g en moyenne.`],
        2: [`Un autre panier${N}: un autre poids.`, `Celui-ci pèse ${f(M[1], 1)} g.`],
        3: [`On remplit ${TOUS} paniers.`, `Ils s’empilent en cloche autour de ${H0} g.`],
        4: [`Son panier pèse ${panier} g.`, `Combien de paniers ordinaires pèsent autant${N}?`],
        5: ['H0 explique très mal son panier.', 'Ça donne du poids à H1.']
      };
  const phrase = $derived(PHRASES[T]);
  const VERDICT = rare
    ? [`Si ses pommes étaient ordinaires, un panier comme le sien`, `arriverait environ ${sur100} fois sur 100.`, `C’est rare${N}: on rejette H0.`]
    : [`Si ses pommes étaient ordinaires, un panier de ${panier} g ou plus`, `arriverait environ ${sur100} fois sur 100.`, `Ce n’est pas rare${N}: on ne rejette pas H0.`];
</script>

<div class="visuel paniers-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 510" role="img" aria-label="Simulation, pommes fictives. Des pommes ordinaires, {H0} g en moyenne. On remplit {TOUS} paniers de {NB_POMMES} pommes. Ils forment une cloche autour de {H0} g. {f(nb)} paniers sur {TOUS} pèsent {panier} g ou plus. {VERDICT.join(' ')}">
    <text x="990" y="22" class="ph-note">simulation · pommes fictives</text>

    <!-- La phrase du temps. -->
    {#key T}
      <g class="ph-phrase">
        <text x="40" y="54" class="ph-titre">{phrase[0]}</text>
        <text x="40" y="86" class="ph-sous" class:ph-rouge-t={T === 5 && rare}>{phrase[1]}</text>
      </g>
    {/key}

    <!-- 3 : mille paniers. -->
    {#each COMPTES as c, j}
      {@const h = (c / MAX) * HAUT}
      <rect x={x(B[j]) + 1} y={BASE - h} width={L - 2} height={h} class="ph-baton" class:ph-rouge={T >= 4 && B[j] >= panier - 1e-9} />
    {/each}

    <!-- L'axe, et 100 g. -->
    <line x1={x(H0)} y1="112" x2={x(H0)} y2={BASE} class="ph-h0" />
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ph-axe" />
    {#each [90, 95, 100, 105, 110] as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 8} class="ph-axe" />
      <text x={x(g)} y={BASE + 30} class="ph-tick" class:ph-cent={g === H0}>{g} g</text>
    {/each}
    <text x={X1} y={BASE + 54} class="ph-tick ph-fin">poids moyen du panier</text>

    <!-- 1 et 2 : deux paniers, dessinés. -->
    {#each DEUX as d}
      <g class="ph-panier ph-etape" class:ph-vu={T >= d.i + 1 && T <= 2} class:ph-ancien={T === 2 && d.i === 0}>
        {#each POMMES_PANIER as p}
          <circle cx={d.cx + p.dx} cy={BASE + p.dy} r="2.3" class="ph-pomme" />
        {/each}
        <path d="M {d.cx - 32} {BASE - 34} L {d.cx - 25} {BASE} L {d.cx + 25} {BASE} L {d.cx + 32} {BASE - 34}" class="ph-osier" />
        <text x={d.cx} y={BASE - 48} class="ph-poids">{f(d.m, 1)} g</text>
      </g>
    {/each}

    <!-- 4 : son panier, et le compte. -->
    <g class="ph-etape" class:ph-vu={T >= 4}>
      <line x1={XP} y1="120" x2={XP} y2={BASE} class="ph-notre" />
      <circle cx={XP} cy={BASE} r="9" class="ph-point" />
      <text x={XP + 14} y="146" class="ph-lab">{rare ? 'son panier' : 'un panier'}&#8239;: {panier} g</text>
      <text x={XP + 14} y="180" class="ph-compte">{f(nb)} sur {TOUS}</text>
      <text x={XP + 14} y="206" class="ph-lab-s">pèsent {panier} g ou plus</text>
    </g>

    <!-- 5 : le verdict. -->
    <g class="ph-etape" class:ph-vu={T >= 5}>
      <text x="500" y="440" class="ph-verdict">{VERDICT[0]}</text>
      <text x="500" y="470" class="ph-verdict">{VERDICT[1]}</text>
      <text x="500" y="502" class="ph-verdict ph-fort" class:ph-rouge-t={rare}>{VERDICT[2]}</text>
    </g>
  </svg>
</div>

<style>
  .paniers-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ph-note { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .ph-phrase { animation: ph-fondu 0.5s ease-out both; }
  @keyframes ph-fondu { from { opacity: 0; } to { opacity: 1; } }
  .ph-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .ph-sous { font-size: 21px; fill: var(--dk-gris); }
  .ph-pomme { fill: var(--dk-gris); }
  .ph-osier { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .ph-poids { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }
  .ph-panier { transition: opacity 0.4s; }
  .ph-panier.ph-vu.ph-ancien { opacity: 0.3; }
  .ph-baton { fill: var(--dk-encre); transition: fill 0.4s; }
  .ph-baton.ph-rouge { fill: var(--dk-accent); }
  .ph-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ph-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ph-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ph-cent { font-weight: 600; fill: var(--dk-encre); }
  .ph-fin { text-anchor: end; }
  .ph-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .ph-point { fill: var(--dk-accent); }
  .ph-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .ph-compte { font-size: 30px; font-weight: 600; fill: var(--dk-accent); }
  .ph-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .ph-verdict { font-size: 23px; text-anchor: middle; fill: var(--dk-encre); }
  .ph-fort { font-weight: 600; }
  .ph-rouge-t { fill: var(--dk-accent); }
  .ph-etape { opacity: 0; transition: opacity 0.2s; }
  .ph-etape.ph-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ph-phrase { animation: none; }
    .ph-etape, .ph-etape.ph-vu, .ph-panier, .ph-baton { transition: none; }
  }
</style>
