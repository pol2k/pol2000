<script>
  /**
   * « Deux écarts types » : placée après « L'écart type et la cloche » et
   * avant « La marge d'erreur ». La marge d'erreur repose sur deux écarts
   * types qu'il faut séparer : celui des individus (une personne, un.e
   * répondant.e varient beaucoup) et celui des moyennes (la moyenne d'une
   * classe de 50, de 50 répondant.e.s, d'un sondage de 1 000 varie très peu).
   * Pas de pommes ici : la pomicultrice vient plus loin dans la séance.
   * Un tableau, une rangée par exemple fil rouge. Quatre temps.
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
   *      47 points. Un sondage de 1 000 varie de 1,8 point (plus que
   *      47 / racine(1 000), parce que seul.e.s celles et ceux qui déclarent
   *      un vote comptent : environ 700 sur 1 000).
   *   3  La colonne des moyennes s'encadre en rouge, celle des individus
   *      pâlit, et la phrase : la marge d'erreur utilise l'écart type des
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
   *     outils/seance5_budget.R.
   * Arrondis : à l'unité pour la taille (au pouce) et le vote (au point) des
   * individus, au dixième ailleurs (17,5 ans, comme sur la diapo « L'écart
   * type »).
   */
  import { brancherTemps } from '../temps.js';
  import { POPULATION, CLASSES } from '$lib/data/seance5_tailles.js';
  import { POP, DISTRIBUTIONS } from '$lib/data/seance5.js';
  import { BUDGET, MILLE } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
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
      quoi: `une classe de ${f(CLASSES.n)}`
    },
    {
      nom: 'âge',
      source: 'CES 2025',
      ind: `${f(POP.ecartType, 1)}${N}ans`,
      qui: 'un.e répondant.e',
      moy: `${f(AGE_50.ecartTypeDesMoyennes, 1)}${N}ans`,
      quoi: `la moyenne de ${f(AGE_50.n)} répondant.e.s`
    },
    {
      nom: 'vote',
      source: 'conservateur, CES 2025',
      ind: `${f(UN_VOTE)} ${point(UN_VOTE)}`,
      qui: `un.e répondant.e${N}: 0 ou 100`,
      moy: `${f(POINTS, 1)} ${point(POINTS)}`,
      quoi: `un sondage de ${f(BUDGET.n)}`
    }
  ];

  // Les colonnes : les noms à gauche, les individus au centre, les moyennes à droite.
  const XN = 60, XA = 470, XB = 790;
  const Y0 = 92, H = 104;

  const ARIA =
    `Deux écarts types. La taille${N}: une personne, écart type de ${RANGEES[0].ind}. ` +
    `La moyenne d’une classe de ${f(CLASSES.n)}${N}: ${RANGEES[0].moy}. ` +
    `L’âge dans l’Étude électorale canadienne 2025${N}: un.e répondant.e, ${RANGEES[1].ind}, la moyenne de ${f(AGE_50.n)} répondant.e.s, ${RANGEES[1].moy}. ` +
    `Un sondage${N}: un.e répondant.e vote conservateur ou non, 0 ou 100, écart type de ${RANGEES[2].ind}. ` +
    `Un sondage de ${f(BUDGET.n)} varie de ${RANGEES[2].moy}. ` +
    `La marge d’erreur utilise l’écart type des moyennes${N}: environ deux fois cet écart, 19 fois sur 20.`;
</script>

<div class="visuel deux-ecarts" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label={ARIA}>
    <!-- 3 : la colonne des moyennes, encadrée. -->
    <rect x={XB - 165} y="22" width="330" height={Y0 + 3 * H - 22} class="de-cadre" class:de-vu={e >= 3} />

    <!-- Les en-têtes. -->
    <g class:de-pale={e >= 3} class="de-col">
      <text x={XA} y="58" class="de-tete">écart type des individus</text>
    </g>
    <text x={XB} y="58" class="de-tete de-rouge">écart type des moyennes</text>
    <line x1={XN} y1={Y0 - 14} x2="955" y2={Y0 - 14} class="de-filet" />

    <!-- Une rangée par exemple. -->
    {#each RANGEES as r, i}
      {@const y = Y0 + i * H}
      <g class="de-rangee" class:de-vu={e >= i}>
        <text x={XN} y={y + 48} class="de-nom">{r.nom}</text>
        <text x={XN} y={y + 76} class="de-source">{r.source}</text>
        <g class="de-col" class:de-pale={e >= 3}>
          <text x={XA} y={y + 52} class="de-nombre">{r.ind}</text>
          <text x={XA} y={y + 82} class="de-qui">{r.qui}</text>
        </g>
        <g class="de-moy">
          <text x={XB} y={y + 52} class="de-nombre de-rouge">{r.moy}</text>
          <text x={XB} y={y + 82} class="de-qui">{r.quoi}</text>
        </g>
        {#if i < RANGEES.length - 1}
          <line x1={XN} y1={y + H - 4} x2="955" y2={y + H - 4} class="de-filet de-mince" />
        {/if}
      </g>
    {/each}

    <!-- 3 : la phrase. -->
    <g class="de-fin" class:de-vu={e >= 3}>
      <text x="500" y="452" class="de-phrase">La marge d’erreur utilise l’écart type des moyennes&#8239;:</text>
      <text x="500" y="488" class="de-phrase de-rouge">environ deux fois cet écart, 19 fois sur 20.</text>
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

  .de-fin { opacity: 0; transition: opacity 0.2s; }
  .de-fin.de-vu { opacity: 1; transition: opacity 0.4s 0.5s; }
  .de-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-phrase.de-rouge { fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .de-rangee, .de-rangee.de-vu, .de-moy, .de-rangee.de-vu .de-moy, .de-col,
    .de-cadre, .de-cadre.de-vu, .de-fin, .de-fin.de-vu { transition: none; }
  }
</style>
