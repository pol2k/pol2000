<script>
  /**
   * « Deux écarts types » : placée après « L'écart type et la cloche » et
   * avant « La marge d'erreur ». La marge d'erreur repose sur deux écarts
   * types qu'il faut séparer : celui des individus (une personne, un.e
   * répondant.e varient beaucoup) et celui des moyennes (la moyenne d'une
   * classe de 50, de 50 répondant.e.s, d'un sondage de 1 000 varie très peu).
   * Pas de pommes ici : la pomicultrice vient plus loin dans la séance.
   * Un tableau, une rangée par exemple fil rouge. Cinq temps.
   *
   *   0  Les deux en-têtes et la rangée de la taille, en pouces (au Québec,
   *      une taille se dit en pieds et pouces) : 4 po pour une personne,
   *      0,5 po pour la moyenne d'une classe de 50.
   *   1  La rangée de l'âge (CES 2025, déjà vu à « L'écart type ») :
   *      17,5 ans pour un.e répondant.e, 2,6 ans pour la moyenne de 50.
   *   2  La rangée du sondage : un.e répondant.e vote conservateur ou non,
   *      soit 100 ou 0 sur une échelle de 0 à 100. L'écart type de ce vote
   *      0 ou 1, en points, est racine(vrai × (1 − vrai)) × 100, avec
   *      vrai = BUDGET.vrai (la part conservatrice de la CES 2025) : environ
   *      47 points. Pour une variable oui ou non, cet écart type mesure à
   *      quel point les gens sont partagés : 0 si tout le monde répond
   *      pareil, 50 au maximum, quand c'est moitié-moitié. D'où la légende
   *      « très partagés (max. 50) » sous le 47 (l'ancienne légende
   *      « un.e répondant.e : 0 ou 100 » restait incomprise). La flèche
   *      « ÷ √682 ≈ 26 » et la cellule des moyennes ne changent pas.
   *      Un sondage de 1 000 varie de 1,8 point (plus que
   *      47 / racine(1 000), parce que seul.e.s celles et ceux qui déclarent
   *      un vote comptent : HASARD.declares, 682 sur 1 000 dans notre sondage).
   *   3  Le lien entre les deux colonnes : une flèche par rangée, de l'écart
   *      des individus à celui des moyennes, marquée « ÷ √50 ≈ 7 » (classes
   *      et groupes de 50) et « ÷ √682 ≈ 26 » (les votes déclarés de notre
   *      sondage). Les racines se calculent ici (Math.sqrt), arrondies à
   *      l'unité, à partir des tailles des groupes dans les données. Puis la
   *      phrase : plus le groupe est grand, plus sa moyenne est stable, on
   *      divise par la racine du nombre. Les quotients ne tombent pas pile
   *      (4 / 7 ≈ 0,57, 17,5 / 7 ≈ 2,5) : les écarts des moyennes viennent de
   *      tirages simulés, d'où « ≈ ».
   *   4  La colonne des moyennes s'encadre en rouge, celle des individus
   *      pâlit, et la conclusion : la marge d'erreur utilise l'écart type des
   *      moyennes, environ deux fois cet écart, 19 fois sur 20.
   *
   * Dans chaque rangée, le nombre des moyennes arrive un temps après celui
   * des individus, pour qu'on voie le premier avant le second.
   *
   * Ne jamais écrire « 2 × 1,8 » à l'écran : 3,6, alors que la diapo
   * suivante (MargeErreur) montre ± 3,4 points (1,96 × l'écart type exact).
   * D'où « environ deux fois ».
   *
   * Sources, toutes générées par R :
   *   la taille : POPULATION.ecartType (les adultes de NHANES) et
   *     CLASSES.ecartType (1 000 classes de 50), en pouces,
   *     src/lib/data/seance5_tailles.js, outils/seance5_tailles.R;
   *   l'âge : POP.ecartType (les 20 180 répondant.e.s de la CES 2025) et
   *     ecartTypeDesMoyennes de l'entrée à 50 de DISTRIBUTIONS (1 000
   *     échantillons de 50), src/lib/data/seance5.js, outils/seance5_data.R;
   *   le sondage : BUDGET.vrai (l'écart type d'un.e répondant.e se calcule
   *     ici, en JS, à partir de cette part) et MILLE.hasard.ecartType (la part
   *     conservatrice de 1 000 sondages de 1 000 tirés au hasard dans la
   *     CES 2025), en points, src/lib/data/seance5_budget.js,
   *     outils/seance5_budget.R. HASARD.declares (les votes déclarés de
   *     notre sondage de 1 000) donne la racine de la rangée du vote.
   * Arrondis : à l'unité pour la taille (au pouce) et le vote (au point) des
   * individus, au dixième ailleurs (17,5 ans, comme sur la diapo « L'écart
   * type »).
   */
  import { brancherTemps } from '../temps.js';
  import { POPULATION, CLASSES } from '$lib/data/seance5_tailles.js';
  import { POP, DISTRIBUTIONS } from '$lib/data/seance5.js';
  import { BUDGET, MILLE, HASARD } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, N);
  const POINTS = MILLE.hasard.ecartType * 100;
  // Un.e répondant.e : 100 (vote conservateur) ou 0. Écart type de ce vote, en points.
  const UN_VOTE = Math.sqrt(BUDGET.vrai * (1 - BUDGET.vrai)) * 100;
  const AGE_50 = DISTRIBUTIONS.find((d) => d.n === 50);
  const point = (v) => (Math.round(v * 10) / 10 < 2 ? 'point' : 'points');

  const RANGEES = [
    {
      nom: 'taille',
      source: 'NHANES, adultes',
      ind: `${f(POPULATION.ecartType)}${N}po`,
      qui: 'une personne',
      moy: `${f(CLASSES.ecartType, 1)}${N}po`,
      quoi: `une classe de ${f(CLASSES.n)}`,
      groupe: CLASSES.n,
      note: ''
    },
    {
      nom: 'âge',
      source: 'CES 2025',
      ind: `${f(POP.ecartType, 1)}${N}ans`,
      qui: 'un.e répondant.e',
      moy: `${f(AGE_50.ecartTypeDesMoyennes, 1)}${N}ans`,
      quoi: `la moyenne de ${f(AGE_50.n)} répondant.e.s`,
      groupe: AGE_50.n,
      note: ''
    },
    {
      nom: 'vote',
      source: 'conservateur, CES 2025',
      ind: `${f(UN_VOTE)} ${point(UN_VOTE)}`,
      qui: 'très partagés (max. 50)',
      moy: `${f(POINTS, 1)} ${point(POINTS)}`,
      quoi: `un sondage de ${f(BUDGET.n)}`,
      groupe: HASARD.declares,
      note: 'votes déclarés'
    }
  ];

  // La racine de la taille du groupe, arrondie à l'unité : « ÷ √50 ≈ 7 ».
  for (const r of RANGEES) r.diviser = `÷${N}√${f(r.groupe)}${N}≈${N}${f(Math.round(Math.sqrt(r.groupe)))}`;

  // Les colonnes : les noms à gauche, les individus, la flèche, les moyennes à droite.
  const XN = 40, XA = 430, XF = 676, XB = 935;
  const LB = 170; // demi-largeur du cadre des moyennes
  const F0 = 598, F1 = XB - LB - 12; // la flèche
  const Y0 = 92, H = 98;
  const L = XB + LB; // bord droit du tableau

  const ARIA =
    `Deux écarts types. La taille${N}: une personne, écart type de ${RANGEES[0].ind}. ` +
    `La moyenne d’une classe de ${f(CLASSES.n)}${N}: ${RANGEES[0].moy}. ` +
    `L’âge dans l’Étude électorale canadienne 2025${N}: un.e répondant.e, ${RANGEES[1].ind}, la moyenne de ${f(AGE_50.n)} répondant.e.s, ${RANGEES[1].moy}. ` +
    `Un sondage${N}: chaque répondant.e vote conservateur (100) ou non (0). L’écart type des individus, ${RANGEES[2].ind}, dit à quel point les gens sont partagés, de 0 si tout le monde répond pareil à 50 quand c’est moitié-moitié${N}: ils sont très partagés. ` +
    `Un sondage de ${f(BUDGET.n)} varie de ${RANGEES[2].moy}. ` +
    `De la première colonne à la seconde, on divise par la racine du nombre${N}: ` +
    `${RANGEES[0].diviser} pour la taille et l’âge, ${RANGEES[2].diviser} pour les ${f(HASARD.declares)} votes déclarés. ` +
    `Plus le groupe est grand, plus sa moyenne est stable${N}: on divise par la racine du nombre. ` +
    `La marge d’erreur utilise l’écart type des moyennes${N}: environ deux fois cet écart, 19 fois sur 20.`;
</script>

<div class="visuel deux-ecarts" bind:this={hote}>
  <svg viewBox="0 0 1150 516" role="img" aria-label={ARIA}>
    <defs>
      <marker id="de-pointe" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto">
        <path d="M0 0 L10 5 L0 10 Z" class="de-pointe" />
      </marker>
    </defs>

    <!-- 4 : la colonne des moyennes, encadrée. -->
    <rect x={XB - LB} y="22" width={2 * LB} height={Y0 + 3 * H - 22} class="de-cadre" class:de-vu={e >= 4} />

    <!-- Les en-têtes. -->
    <g class:de-pale={e >= 4} class="de-col">
      <text x={XA} y="58" class="de-tete">écart type des individus</text>
    </g>
    <text x={XB} y="58" class="de-tete de-rouge">écart type des moyennes</text>
    <line x1={XN} y1={Y0 - 14} x2={L} y2={Y0 - 14} class="de-filet" />

    <!-- Une rangée par exemple. -->
    {#each RANGEES as r, i}
      {@const y = Y0 + i * H}
      <g class="de-rangee" class:de-vu={e >= i}>
        <text x={XN} y={y + 48} class="de-nom">{r.nom}</text>
        <text x={XN} y={y + 76} class="de-source">{r.source}</text>
        <g class="de-col" class:de-pale={e >= 4}>
          <text x={XA} y={y + 52} class="de-nombre">{r.ind}</text>
          <text x={XA} y={y + 82} class="de-qui">{r.qui}</text>
        </g>
        <g class="de-moy">
          <text x={XB} y={y + 52} class="de-nombre de-rouge">{r.moy}</text>
          <text x={XB} y={y + 82} class="de-qui">{r.quoi}</text>
        </g>
        {#if i < RANGEES.length - 1}
          <line x1={XN} y1={y + H - 4} x2={L} y2={y + H - 4} class="de-filet de-mince" />
        {/if}
      </g>

      <!-- 3 : la flèche entre les deux colonnes. -->
      <g class="de-lien" class:de-vu={e >= 3} style="--de-delai: {0.3 * i}s">
        <text x={XF} y={y + 30} class="de-diviser">{r.diviser}</text>
        <line x1={F0} y1={y + 40} x2={F1} y2={y + 40} class="de-fleche" marker-end="url(#de-pointe)" />
        {#if r.note}<text x={XF} y={y + 66} class="de-note">{r.note}</text>{/if}
      </g>
    {/each}

    <!-- 3 : la règle. -->
    <text x={L / 2 + XN / 2} y="426" class="de-regle" class:de-vu={e >= 3}>Plus le groupe est grand, plus sa moyenne est stable&#8239;: on divise par la racine du nombre.</text>

    <!-- 4 : la conclusion. -->
    <g class="de-fin" class:de-vu={e >= 4}>
      <text x={L / 2 + XN / 2} y="470" class="de-phrase">La marge d’erreur utilise l’écart type des moyennes&#8239;:</text>
      <text x={L / 2 + XN / 2} y="504" class="de-phrase de-rouge">environ deux fois cet écart, 19 fois sur 20.</text>
    </g>
  </svg>
</div>

<style>
  .deux-ecarts { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .de-tete { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-filet { stroke: var(--dk-encre); stroke-width: 2; }
  .de-filet.de-mince { stroke: var(--dk-gris-2); }

  .de-nom { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .de-source { font-size: 18px; fill: var(--dk-gris); }
  .de-nombre { font-size: 40px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-qui { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .de-rouge { fill: var(--dk-accent); }

  .de-rangee { opacity: 0; transition: opacity 0.2s; }
  .de-rangee.de-vu { opacity: 1; transition: opacity 0.4s; }
  .de-moy { opacity: 0; transition: opacity 0.2s; }
  .de-rangee.de-vu .de-moy { opacity: 1; transition: opacity 0.4s 0.9s; }

  .de-col { transition: opacity 0.4s; }
  .de-col.de-pale { opacity: 0.35; }

  .de-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 3; opacity: 0; transition: opacity 0.2s; }
  .de-cadre.de-vu { opacity: 1; transition: opacity 0.4s; }

  .de-lien { opacity: 0; transition: opacity 0.2s; }
  .de-lien.de-vu { opacity: 1; transition: opacity 0.4s var(--de-delai); }
  .de-diviser { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-note { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .de-fleche { stroke: var(--dk-encre); stroke-width: 2; }
  .de-pointe { fill: var(--dk-encre); }

  .de-regle { font-size: 19px; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .de-regle.de-vu { opacity: 1; transition: opacity 0.4s 0.9s; }

  .de-fin { opacity: 0; transition: opacity 0.2s; }
  .de-fin.de-vu { opacity: 1; transition: opacity 0.4s 0.5s; }
  .de-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-phrase.de-rouge { fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .de-rangee, .de-rangee.de-vu, .de-moy, .de-rangee.de-vu .de-moy, .de-col,
    .de-cadre, .de-cadre.de-vu, .de-fin, .de-fin.de-vu,
    .de-lien, .de-lien.de-vu, .de-regle, .de-regle.de-vu { transition: none; }
  }
</style>
