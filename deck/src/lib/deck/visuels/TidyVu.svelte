<script>
  /**
   * Un tableau, vu de près (séance 4). Même idée que Tidy.svelte (séance 1),
   * redessinée pour qu'on s'en souvienne : chaque temps balaie sa structure.
   *
   *   0  Le tableau : cinq vraies personnes, quatre variables.
   *   1  Une bande rouge balaie la première ligne : une observation.
   *   2  Une bande rouge descend la colonne de l'âge : une variable.
   *   3  La cellule au croisement bat, et sa copie sort du tableau : une valeur.
   *   4  Le cadre se dessine autour du tout : l'objet d'étude.
   *   5  Récapitulatif : les quatre ensemble.
   *
   * Les lignes sont les cinq premières de l'Étude électorale canadienne 2025
   * (cps25_age_in_years, cps25_education, cps25_income, cps25_votechoice),
   * relues avec Rscript/haven le 24 septembre 2026 dans ces2025.dta : aucune
   * valeur n'est inventée. Le revenu n'est exporté par aucun module généré,
   * d'où ce tableau littéral. Attention : Tidy.svelte (séance 1) inverse le
   * vote des lignes 3 et 4 (1 et 2 au lieu de 2 et 1).
   */
  import { brancherTemps } from '../temps.js';
  import { DIMENSIONS } from '$lib/data/seance4.js';

  const COLS = ['âge', 'scolarité', 'revenu', 'intention de vote'];
  const ROWS = [[69, 9, 6, 2], [61, 9, 6, 3], [54, 11, 6, 2], [28, 9, 4, 1], [63, 8, 3, 1]];
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const N = milliers(DIMENSIONS.brut[0]);

  // Géométrie (unités du viewBox). Colonne 0 = numéro de ligne.
  const LARG = [70, 150, 200, 170, 300];
  const X0 = 24, Y0 = 16, HT = 70, HL = 72, HS = 56;
  const XS = LARG.reduce((a, w) => [...a, a[a.length - 1] + w], [X0]);
  const X1 = XS[XS.length - 1];
  const yL = (i) => Y0 + HT + i * HL; // haut de la ligne i
  const YS = yL(ROWS.length); // haut de la ligne « ⋮ »
  const Y1 = YS + HS;
  const LI = 0; // la ligne choisie
  const CO = 1; // la colonne choisie (âge)
  const cx = (j) => (XS[j] + XS[j + 1]) / 2;
  const cy = (i) => yL(i) + HL / 2;

  // La copie de la cellule, une fois sortie du tableau.
  const XR = X1 + 90; // début des étiquettes de droite
  const XC = XR, YC = 196, K = 1.4;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const ligne = $derived(e === 1 || e === 5);
  const colonne = $derived(e === 2 || e === 5);
  const cellule = $derived(e === 3 || e === 5);
  const tout = $derived(e === 4 || e === 5);
  // Le délai de chaque texte suit le passage de la bande (balayage ou chute).
  const dLigne = (j) => `${(0.55 * (XS[j] - X0)) / (X1 - X0)}s`;
  const dCol = (i) => `${(0.55 * (i < 0 ? 0 : yL(i) - Y0)) / (Y1 - Y0)}s`;
</script>

<div class="visuel tidyvu" bind:this={hote}>
  <svg viewBox="0 0 1600 660" role="img" aria-label="Les cinq premières lignes de l'Étude électorale canadienne 2025 : âge, scolarité, revenu et intention de vote. Une ligne est une observation, une personne. Une colonne est une variable, ici l'âge. Une cellule est une valeur, ici 69 ans. Le tableau entier, {N} personnes, est l'objet d'étude.">
    <!-- le fond : en-tête, filets -->
    <rect x={X0} y={Y0} width={X1 - X0} height={HT} class="tete" />
    {#each ROWS as _, i}
      <line x1={X0} y1={yL(i + 1)} x2={X1} y2={yL(i + 1)} class="filet" />
    {/each}
    {#each XS.slice(1, -1) as x}
      <line x1={x} y1={Y0 + HT} x2={x} y2={Y1} class="filet" />
    {/each}

    <!-- les bandes -->
    <rect x={X0} y={yL(LI)} width={X1 - X0} height={HL} class="bande b-ligne" class:on={ligne} />
    <rect x={XS[CO]} y={Y0} width={LARG[CO]} height={Y1 - Y0} class="bande b-col" class:on={colonne} />
    {#key cellule}
      <rect x={XS[CO]} y={yL(LI)} width={LARG[CO]} height={HL} class="b-cel" class:on={cellule} />
    {/key}

    <!-- les textes -->
    {#each COLS as c, j}
      <text x={cx(j + 1)} y={Y0 + HT / 2 + 8} class="th">{c}</text>
    {/each}
    {#each ROWS as r, i}
      <g class="rang" style="animation-delay: {150 + i * 90}ms">
        <text x={cx(0)} y={cy(i) + 10} class="n" class:clair={ligne && i === LI} style="--d: {dLigne(0)}">{i + 1}</text>
        {#each r as v, j}
          {@const sur = (ligne && i === LI) || (colonne && j + 1 === CO) || (cellule && i === LI && j + 1 === CO)}
          <text x={cx(j + 1)} y={cy(i) + 10} class="td" class:clair={sur} class:gros={cellule && i === LI && j + 1 === CO}
            style="--d: {cellule && i === LI && j + 1 === CO ? '0s' : colonne && j + 1 === CO ? dCol(i) : dLigne(j + 1)}">{v}</text>
        {/each}
      </g>
    {/each}
    {#each XS.slice(0, -1) as _, j}
      <text x={cx(j)} y={YS + HS / 2 + 9} class="suite" class:clair={colonne && j === CO} style="--d: {dCol(ROWS.length)}">⋮</text>
    {/each}

    <!-- le contour, puis le cadre qui se dessine -->
    <rect x={X0} y={Y0} width={X1 - X0} height={Y1 - Y0} class="contour" />
    <rect x={X0 - 12} y={Y0 - 12} width={X1 - X0 + 24} height={Y1 - Y0 + 24} pathLength="1" class="cadre" class:on={tout} />

    <!-- les étiquettes -->
    <g class="etq" class:on={ligne}>
      <line x1={X1 + 18} y1={cy(LI)} x2={XR - 14} y2={cy(LI)} pathLength="1" class="lien" />
      <text x={XR} y={cy(LI) - 4} class="t1">une ligne <tspan class="eg">=</tspan> <tspan class="r">une observation</tspan></text>
      <text x={XR} y={cy(LI) + 30} class="t2">ici, une personne sondée</text>
    </g>

    <g class="etq" class:on={colonne}>
      <line x1={cx(CO)} y1={Y1 + 14} x2={cx(CO)} y2={Y1 + 46} pathLength="1" class="lien" />
      <text x={XS[CO]} y={Y1 + 86} class="t1">une colonne <tspan class="eg">=</tspan> <tspan class="r">une variable</tspan></text>
      <text x={XS[CO]} y={Y1 + 120} class="t2">ici, l'âge</text>
    </g>

    <!-- la copie de la cellule sort du tableau et grossit -->
    <g class="copie" class:on={cellule}
      style="transform: translate({cellule ? XC : XS[CO]}px, {cellule ? YC : yL(LI)}px) scale({cellule ? K : 1})">
      <rect x="0" y="0" width={LARG[CO]} height={HL} class="c-fond" />
      <text x={LARG[CO] / 2} y={HL / 2 + 11} class="c-val">{ROWS[LI][CO - 1]}</text>
    </g>
    <g class="etq e-cel" class:on={cellule}>
      <text x={XC} y={YC + HL * K + 44} class="t1">une cellule <tspan class="eg">=</tspan> <tspan class="r">une valeur</tspan></text>
      <text x={XC} y={YC + HL * K + 78} class="t2">ici, 69 ans</text>
    </g>

    <g class="etq e-tout" class:on={tout}>
      <line x1={X1 + 18} y1={YS + HS / 2} x2={XR - 14} y2={YS + HS / 2} pathLength="1" class="lien" />
      <text x={XR} y={YS + HS / 2 - 4} class="t1">le tableau <tspan class="eg">=</tspan> <tspan class="r">l'objet d'étude</tspan></text>
      <text x={XR} y={YS + HS / 2 + 30} class="t2">les {N} personnes</text>
    </g>
  </svg>
  <p class="source">Étude électorale canadienne 2025 · les cinq premières lignes</p>
</div>

<style>
  .tidyvu { display: flex; flex-direction: column; gap: 0.2em; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .tete { fill: var(--dk-encre); }
  .filet { stroke: var(--dk-filet); stroke-width: 1.5; }
  .contour { fill: none; stroke: var(--dk-encre); stroke-width: 4; }

  .th { font-size: 24px; font-weight: 600; letter-spacing: 0.04em; text-anchor: middle; fill: var(--dk-fond); }
  .td { font-size: 32px; text-anchor: middle; fill: var(--dk-encre); font-variant-numeric: tabular-nums;
        transition: fill 0.15s var(--d, 0s), font-weight 0.15s var(--d, 0s); }
  .n { font-size: 26px; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.15s var(--d, 0s); }
  .suite { font-size: 28px; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.15s var(--d, 0s); }
  .clair { fill: var(--dk-fond); font-weight: 600; }
  .gros { font-weight: 700; }

  /* Les lignes entrent une à une. */
  .rang { animation: entre 0.45s both; }
  @keyframes entre { from { opacity: 0; transform: translateX(-24px); } to { opacity: 1; transform: none; } }

  /* Les bandes : la ligne se balaie de gauche à droite, la colonne tombe. */
  .bande { fill: var(--dk-accent); transform-box: fill-box; transition: transform 0.55s cubic-bezier(0.65, 0, 0.35, 1); }
  .b-ligne { transform-origin: left center; transform: scaleX(0); }
  .b-col { transform-origin: center top; transform: scaleY(0); }
  .bande.on { transform: none; }

  /* La cellule : un carré d'encre qui bat deux fois. */
  .b-cel { fill: var(--dk-encre); opacity: 0; transform-box: fill-box; transform-origin: center; }
  .b-cel.on { opacity: 1; animation: bat 0.5s 0.1s 2 ease-in-out; }
  @keyframes bat { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.18); } }

  /* Le cadre se dessine autour du tout. */
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 1; stroke-dashoffset: 1;
           transition: stroke-dashoffset 1s cubic-bezier(0.65, 0, 0.35, 1); }
  .cadre.on { stroke-dashoffset: 0; }

  /* La copie de la cellule. */
  .copie { opacity: 0; transform-box: view-box; transform-origin: 0 0;
           transition: transform 0.8s cubic-bezier(0.34, 1.25, 0.64, 1) 0.35s, opacity 0.2s 0.35s; }
  .copie.on { opacity: 1; }
  .c-fond { fill: var(--dk-encre); }
  .c-val { font-size: 34px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }

  /* Les étiquettes et leurs liens. */
  .etq { opacity: 0; transform: translateY(10px); transition: opacity 0.35s, transform 0.35s; }
  .etq.on { opacity: 1; transform: none; transition-delay: 0.45s; }
  .e-cel.on { transition-delay: 0.9s; }
  .e-tout.on { transition-delay: 0.8s; }
  .lien { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.4s; }
  .etq.on .lien { stroke-dashoffset: 0; transition-delay: 0.45s; }
  .t1 { font-size: 30px; font-weight: 600; fill: var(--dk-encre); }
  .t1 .eg { fill: var(--dk-gris-2); font-weight: 400; }
  .t1 .r { fill: var(--dk-accent); }
  .t2 { font-size: 23px; fill: var(--dk-gris); }

  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .rang, .b-cel.on { animation: none; }
    .bande, .cadre, .copie, .etq, .lien, .td, .n, .suite { transition: none; }
  }
</style>
