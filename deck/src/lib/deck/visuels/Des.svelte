<script>
  /**
   * Un dé, lancé encore et encore : ce qu'est une barre d'histogramme. À
   * gauche, le dé et le compteur de lancers. À droite, un axe de 1 à 6 :
   * chaque lancer y dépose un carré au-dessus de sa face. Les carrés
   * s'empilent, et une pile, c'est une barre.
   *
   *   0  Je lance un dé : un lancer, un carré.
   *   1  Je recommence : neuf autres lancers tombent un à un (environ 2 s).
   *      Après 10 lancers, les piles sont inégales.
   *   2  1 000 fois : l'avance rapide (environ 2 s). Les piles montent, les
   *      carrés rapetissent pour tenir dans le cadre et deviennent des
   *      barres. Chaque face sort à peu près aussi souvent : c'est plat.
   *
   * Chaque animation a une fin fixe : au temps suivant, ou une fois la durée
   * écoulée, l'image est toujours la même (les 10 premiers lancers, puis les
   * effectifs de R). Avec « réduire les animations », on saute à la fin.
   *
   * Tout vient de src/lib/data/seance5_des.js (outils/seance5_des.R) : les
   * faces de chaque lancer, dans l'ordre, et les effectifs des 1 000.
   */
  import { brancherTemps } from '../temps.js';
  import { DES } from '$lib/data/seance5_des.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const SERIE = DES.find((d) => d.des === 1);
  const N = SERIE.n;
  const FACES = [...SERIE.faces].map(Number);
  const DEBUT = 10; // les lancers rejoués un à un avant l'avance rapide

  // Géométrie : le dé à gauche, l'axe des faces à droite.
  const X0 = 360, CASE = 103, COTE = 60, PAS_MAX = 64;
  const BASE = 410, HAUT = 300, Y_CHUTE = 36;
  const xFace = (f) => X0 + (f - 0.5) * CASE;
  const DE = { x: 100, y: 140, c: 130 };

  // Les points d'une face : positions en tiers de la face (−1, 0, 1).
  const POINTS = {
    1: [[0, 0]],
    2: [[-1, -1], [1, 1]],
    3: [[-1, -1], [0, 0], [1, 1]],
    4: [[-1, -1], [1, -1], [-1, 1], [1, 1]],
    5: [[-1, -1], [1, -1], [0, 0], [-1, 1], [1, 1]],
    6: [[-1, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [1, 1]]
  };

  // Le temps : 1 = les lancers 2 à 10 tombent un à un, 2 = l'avance rapide.
  const INTERVALLE = 250, CHUTE = 250;
  const DUREE = { 1: (DEBUT - 2) * INTERVALLE + CHUTE, 2: 2000 };
  let t = $state(0);
  let tPour = $state(-1); // le temps à qui appartient t (évite un éclair de l'image finale)
  $effect(() => {
    if (!DUREE[e]) return;
    const fin = DUREE[e];
    tPour = e;
    t = 0;
    if (typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches) {
      t = fin;
      return;
    }
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = Math.min(fin, now - debut);
      if (t < fin) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const tt = $derived(tPour === e ? t : 0);
  const fini = $derived(e === 0 || (DUREE[e] && tt >= DUREE[e]));

  // Combien de lancers sont partis, combien sont posés, et celui qui tombe.
  const etat = $derived.by(() => {
    if (e === 0) return { partis: 1, poses: 1, chute: null };
    if (e === 1) {
      if (fini) return { partis: DEBUT, poses: DEBUT, chute: null };
      let partis = 1, poses = 1, chute = null;
      for (let i = 1; i < DEBUT; i++) {
        const depart = (i - 1) * INTERVALLE;
        if (tt >= depart) partis = i + 1;
        if (tt >= depart + CHUTE) poses = i + 1;
        else if (tt >= depart) chute = { i, u: (tt - depart) / CHUTE };
      }
      return { partis, poses, chute };
    }
    // L'avance rapide : de 10 à 1 000 lancers, de plus en plus vite.
    const n = fini ? N : Math.min(N, Math.max(DEBUT, Math.round(DEBUT * (N / DEBUT) ** (tt / DUREE[2]))));
    return { partis: n, poses: n, chute: null };
  });

  // Les piles : combien de carrés au-dessus de chaque face (les effectifs de R à la fin).
  const piles = $derived.by(() => {
    if (e === 2 && fini) return SERIE.effectifs;
    const c = [0, 0, 0, 0, 0, 0];
    for (let i = 0; i < etat.partis; i++) c[FACES[i] - 1]++;
    if (etat.chute) c[FACES[etat.chute.i] - 1]--;
    return c;
  });
  // La hauteur d'un carré : 64 tant que tout tient, puis de moins en moins.
  const pas = $derived(Math.min(PAS_MAX, HAUT / Math.max(1, ...piles, etat.chute ? piles[FACES[etat.chute.i] - 1] + 1 : 0)));
  const jeu = $derived(pas >= 20 ? 4 : pas >= 8 ? 2 : 0);

  // Le carré qui tombe : du haut du cadre jusqu'au sommet de sa pile.
  const chute = $derived.by(() => {
    if (!etat.chute) return null;
    const f = FACES[etat.chute.i];
    const yFin = BASE - (piles[f - 1] + 1) * pas;
    const u = etat.chute.u;
    return { x: xFace(f) - COTE / 2, y: Y_CHUTE + (yFin - Y_CHUTE) * u * u, h: pas - jeu };
  });
  // Le dernier carré posé est en rouge, tant qu'on compte un à un.
  const dernier = $derived(e < 2 && !etat.chute ? FACES[etat.poses - 1] : 0);

  const face = $derived(FACES[etat.partis - 1]);
  const points = $derived(POINTS[face].map(([dx, dy]) => ({ cx: DE.x + DE.c / 2 + dx * DE.c * 0.27, cy: DE.y + DE.c / 2 + dy * DE.c * 0.27 })));

  const milliers = (n) => String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
  const compteur = $derived(`${milliers(etat.partis)} ${etat.partis > 1 ? 'lancers' : 'lancer'}`);
  const LEGENDES = ['Je lance un dé.', 'Je recommence.', '1 000 fois.'];

  // Après 10 lancers : les faces qui ne sont pas encore sorties.
  const ABSENTES = [1, 2, 3, 4, 5, 6].filter((f) => !FACES.slice(0, DEBUT).includes(f));
  const APRES_DIX = ABSENTES.length
    ? `Après ${DEBUT} lancers, pas encore un seul ${ABSENTES.join(' ni un seul ')}.`
    : `Après ${DEBUT} lancers, des piles inégales.`;
  const phrase = $derived(
    e === 1 && fini ? APRES_DIX : e === 2 && fini ? 'Chaque face sort à peu près aussi souvent : c’est plat.' : ''
  );
</script>

<div class="visuel des" bind:this={hote}>
  <svg viewBox="0 0 1000 530" role="img" aria-label="Je lance un dé et je pose un carré au-dessus de la face obtenue. Je recommence : les carrés s’empilent, une pile par face. Après 1 000 lancers, les six piles ont à peu près la même hauteur : un dé seul donne un histogramme plat.">
    <text x="980" y="22" class="de-note">simulation</text>
    <!-- Le dé, la légende du temps et le compteur. -->
    <text x="40" y="80" class="de-legende">{LEGENDES[e]}</text>
    <rect x={DE.x} y={DE.y} width={DE.c} height={DE.c} class="de-face" />
    {#each points as pt}
      <circle cx={pt.cx} cy={pt.cy} r={DE.c * 0.085} class="de-point" />
    {/each}
    <text x={DE.x + DE.c / 2} y="330" class="de-compteur">{compteur}</text>

    <!-- Les piles. -->
    {#each piles as c, k}
      {#if jeu > 0}
        {#each { length: c } as _, j}
          <rect x={xFace(k + 1) - COTE / 2} y={BASE - (j + 1) * pas} width={COTE} height={pas - jeu} class="de-carre" class:de-rouge={dernier === k + 1 && j === c - 1} />
        {/each}
      {:else}
        <rect x={xFace(k + 1) - COTE / 2} y={BASE - c * pas} width={COTE} height={c * pas} class="de-carre" />
      {/if}
      {#if e === 2 && fini}
        <text x={xFace(k + 1)} y={BASE - c * pas - 12} class="de-effectif">{c}</text>
      {/if}
    {/each}
    {#if chute}
      <rect x={chute.x} y={chute.y} width={COTE} height={chute.h} class="de-carre de-rouge" />
    {/if}

    <!-- L'axe des faces. -->
    <line x1={X0} y1={BASE} x2={X0 + 6 * CASE} y2={BASE} class="de-sol" />
    {#each [1, 2, 3, 4, 5, 6] as f}
      <text x={xFace(f)} y={BASE + 32} class="de-grad">{f}</text>
    {/each}
    <text x={X0 + 3 * CASE} y={BASE + 62} class="de-axe">la face du dé</text>

    {#key phrase}
      <text x="500" y="516" class="de-phrase">{phrase}</text>
    {/key}
  </svg>
</div>

<style>
  .des { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .de-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .de-legende { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .de-face { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .de-point { fill: var(--dk-encre); }
  .de-compteur { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .de-carre { fill: var(--dk-encre); }
  .de-carre.de-rouge { fill: var(--dk-accent); }
  .de-effectif { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .de-sol { stroke: var(--dk-encre); stroke-width: 2; }
  .de-grad { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .de-axe { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .de-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); animation: de-entree 0.5s; }
  @keyframes de-entree { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .de-phrase { animation: none; }
  }
</style>
