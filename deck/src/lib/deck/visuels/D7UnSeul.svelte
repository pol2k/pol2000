<script>
  /**
   * « Et avec un seul sondage ? », séance 7. Dans la vraie vie, on n'a
   * qu'un sondage, pas mille. R estime quand même l'erreur type, avec ce
   * seul sondage, et il tombe presque pile sur l'écart type des 1 000
   * pentes.
   *
   *   0  La console : le code et les trois lignes du tableau des
   *      coefficients de summary(), telles que R les imprime (SUMMARY,
   *      CODE_LM, CODE_SUMMARY). L'habillage reprend celui de Console.svelte.
   *   1  La colonne Std. Error s'encadre en rouge, jusqu'à 0.04416 sur la
   *      ligne de populisme : l'erreur type selon R, 0,044.
   *   2  Les deux nombres côte à côte : un seul sondage (NOTRE.coefs[1].se,
   *      0,044) et 1 000 sondages (MILLE.ecart_type_hasard, 0,045). Presque
   *      pareil. Trois décimales, comme à la diapo « L'erreur type ».
   *   3  Comment R fait : il lit les trois ingrédients dans notre sondage.
   *      NOTRE.n_modele (564 personnes), NOTRE.sigma (l'erreur typique,
   *      0,29 sur une échelle de 0 à 1, le « Residual standard error » de R),
   *      NOTRE.ecart_x (l'écart type du populisme, 0,27). Pas de formule à
   *      la diapo : elle est dans les notes de l'enseignant.
   *
   * Les colonnes de la sortie sont repérées par leur position dans le texte
   * de R (police à chasse fixe : chaque caractère fait 0,6 em de large).
   *
   * Sources : SUMMARY, CODE_LM, CODE_SUMMARY, NOTRE, MILLE
   * (src/lib/data/seance7.js, outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, SUMMARY, CODE_LM, CODE_SUMMARY, NOTRE, MILLE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');

  // Les trois lignes du tableau des coefficients, telles quelles.
  const LIGNES = SUMMARY.split('\n');
  const iTete = LIGNES.findIndex((l) => l.includes('Std. Error'));
  const TABLE = LIGNES.slice(iTete, iTete + 3).map((l) => l.replace(/\s+$/, ''));
  const COL_D = TABLE[0].indexOf('Std. Error');
  const COL_F = COL_D + 'Std. Error'.length;

  const FS = 23, CW = FS * 0.6, BX = 60, TX = 96;
  const YC = [70, 108], YT = [168, 204, 240];
  const col = (k) => TX + k * CW;

  const SE = NOTRE.coefs[1].se, ET = MILLE.ecart_type_hasard;
  const ING = [
    { n: f(NOTRE.n_modele), l: 'personnes' },
    { n: f(NOTRE.sigma, 2), l: 'erreur typique' },
    { n: f(NOTRE.ecart_x, 2), l: `écart type du ${VARS.x.nom}` }
  ];

  const ARIA =
    `La sortie de summary() pour notre sondage. La colonne Std. Error donne l’erreur type de la pente : ${f(SE, 3)}. ` +
    `Avec un seul sondage, R trouve ${f(SE, 3)}. Avec 1 000 sondages, l’écart type des pentes est ${f(ET, 3)}. Presque pareil. ` +
    `R lit les trois ingrédients dans notre sondage : ${ING.map((i) => `${i.l} ${i.n}`).join(', ')}.`;
</script>

<div class="visuel d7-un-seul" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={ARIA}>
    <!-- 0 : la console. -->
    <rect x={BX} y="30" width="880" height="236" class="us-corps" />
    <rect x={BX} y="30" width="9" height="236" class="us-bord" />
    <text x={TX - 22} y={YC[0]} class="us-code us-prompt">&gt;</text>
    <text x={TX} y={YC[0]} class="us-code">{CODE_LM}</text>
    <text x={TX - 22} y={YC[1]} class="us-code us-prompt">&gt;</text>
    <text x={TX} y={YC[1]} class="us-code">{CODE_SUMMARY}</text>
    <text x={TX} y="138" class="us-code us-sortie">…</text>
    {#each TABLE as l, i}
      <text x={TX} y={YT[i]} class="us-code us-sortie" class:us-cle={i === 2}>{l}</text>
    {/each}

    <!-- 1 : la colonne Std. Error. -->
    <rect x={col(COL_D) - 5} y={YT[0] - 26} width={(COL_F - COL_D) * CW + 10} height={YT[2] - YT[0] + 38}
          class="us-cadre" class:us-vu={e >= 1} />
    <g class="us-etape" class:us-vu={e >= 1}>
      <text x={col(COL_D) + ((COL_F - COL_D) * CW) / 2} y="300" class="us-lab">l’erreur type, selon R</text>
    </g>

    <!-- 2 : les deux nombres. -->
    <g class="us-etape" class:us-vu={e >= 2}>
      <text x="270" y="356" class="us-qui">un seul sondage</text>
      <text x="270" y="414" class="us-gros us-rouge">{f(SE, 3)}</text>
      <text x="500" y="400" class="us-pareil">≈</text>
      <text x="730" y="356" class="us-qui">{f(1000)} sondages</text>
      <text x="730" y="414" class="us-gros">{f(ET, 3)}</text>
    </g>

    <!-- 3 : les trois ingrédients, lus dans notre sondage. -->
    <g class="us-etape" class:us-vu={e >= 3}>
      <text x="500" y="460" class="us-comment">R lit les trois ingrédients dans notre sondage{NN}:</text>
      {#each ING as g, i}
        <text x={180 + i * 320} y="506" class="us-ing-n">{g.n}</text>
        <text x={180 + i * 320} y="532" class="us-ing">{g.l}</text>
      {/each}
    </g>
  </svg>
</div>

<style>
  .d7-un-seul { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .us-corps { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .us-bord { fill: var(--dk-accent); }
  .us-code { font-size: 23px; white-space: pre; fill: var(--dk-encre); }
  .us-prompt { fill: var(--dk-accent); font-weight: 600; }
  .us-sortie { fill: var(--dk-gris); }
  .us-cle { fill: var(--dk-encre); font-weight: 600; }

  .us-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 4; opacity: 0; transition: opacity 0.3s; }
  .us-cadre.us-vu { opacity: 1; }
  .us-lab { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }

  .us-qui { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .us-gros { font-size: 56px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .us-rouge { fill: var(--dk-accent); }
  .us-pareil { font-size: 48px; text-anchor: middle; fill: var(--dk-gris); }

  .us-comment { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .us-ing { font-size: 19px; text-anchor: middle; fill: var(--dk-gris); }
  .us-ing-n { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }

  .us-etape { opacity: 0; transition: opacity 0.2s; }
  .us-etape.us-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .us-etape, .us-etape.us-vu, .us-cadre { transition: none; }
  }
</style>
