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
   *   1  La colonne Std. Error s'encadre en rouge, jusqu'à la ligne de
   *      scolarite : l'erreur type selon R, 0,032.
   *   2  Une flèche descend de la colonne vers le premier nombre : un seul
   *      sondage, 0,032 (NOTRE.coefs[1].se, le 0.03212 de la ligne
   *      scolarite). À côté, 1 000 sondages, 0,033 (MILLE.ecart_type_hasard,
   *      l'écart type des 1 000 pentes, la règle rouge de la diapo
   *      précédente « L'erreur type »). Presque pareil. Trois décimales
   *      sur les deux diapos.
   *   3  La phrase à retenir : avec un seul sondage, R retrouve presque
   *      pile la dispersion des 1 000. Pas de formule sur la diapo (elle
   *      est dans les notes de l'enseignant) : chaque nombre de la diapo se
   *      lit dans la sortie de R ou sur la diapo précédente.
   *
   * Les colonnes de la sortie sont repérées par leur position dans le texte
   * de R (police à chasse fixe : chaque caractère fait 0,6 em de large).
   *
   * Sources : SUMMARY, CODE_LM, CODE_SUMMARY, NOTRE, MILLE
   * (src/lib/data/seance7.js, outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { SUMMARY, CODE_LM, CODE_SUMMARY, NOTRE, MILLE } from '$lib/data/seance7.js';
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
  const XG = col(COL_D) + ((COL_F - COL_D) * CW) / 2, XD = 800;

  const ARIA =
    `La sortie de summary() pour notre sondage. La colonne Std. Error donne l’erreur type de la pente de scolarite : 0.03212, soit ${f(SE, 3)}. ` +
    `Avec un seul sondage, R trouve ${f(SE, 3)}. Avec ${f(1000)} sondages, l’écart type des pentes est ${f(ET, 3)}. Presque pareil. ` +
    `Avec un seul sondage, R retrouve presque pile la dispersion des ${f(1000)}.`;
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
      <text x={XG} y="300" class="us-lab">l’erreur type, selon R</text>
    </g>

    <!-- 2 : de la colonne au nombre, puis les 1 000 sondages. -->
    <g class="us-etape" class:us-vu={e >= 2}>
      <line x1={XG} y1="314" x2={XG} y2="346" class="us-fleche" />
      <path d="M {XG - 8} 338 L {XG} 352 L {XG + 8} 338 Z" class="us-pointe" />
      <text x={XG} y="410" class="us-gros us-rouge">{f(SE, 3)}</text>
      <text x={XG} y="446" class="us-qui">un seul sondage</text>
      <text x={(XG + XD) / 2} y="400" class="us-pareil">≈</text>
      <text x={XD} y="410" class="us-gros">{f(ET, 3)}</text>
      <text x={XD} y="446" class="us-qui">{f(1000)} sondages</text>
      <text x={XD} y="472" class="us-note">l’écart type des pentes</text>
    </g>

    <!-- 3 : la phrase à retenir. -->
    <g class="us-etape" class:us-vu={e >= 3}>
      <text x="500" y="526" class="us-comment">Avec un seul sondage, R retrouve presque pile la dispersion des {f(1000)}.</text>
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
  .us-note { font-size: 19px; text-anchor: middle; fill: var(--dk-gris); }
  .us-fleche { stroke: var(--dk-accent); stroke-width: 3; }
  .us-pointe { fill: var(--dk-accent); }

  .us-etape { opacity: 0; transition: opacity 0.2s; }
  .us-etape.us-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .us-etape, .us-etape.us-vu, .us-cadre { transition: none; }
  }
</style>
