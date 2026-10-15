<script>
  /**
   * L'erreur type, entre parenthèses sous le coefficient. À gauche, le
   * tableau d'article (TabPublie). À droite, une règle des pentes : 0 (aucun
   * lien) et notre pente, +0,203. Rien de nouveau, on relie le tableau aux
   * diapos d'avant (erreur type, intervalle de confiance, t).
   *
   *   0  La règle : 0 et notre pente.
   *   1  (0,032) : une erreur type de chaque côté de la pente, de combien
   *      elle bougerait d'un sondage à l'autre.
   *   2  L'intervalle de confiance à 95 % (bornes de confint(), NOTRE.coefs[1]
   *      bas et haut) : environ deux erreurs types de chaque côté.
   *   3  De la pente à 0, on compte les erreurs types : 6,3. C'est le t que
   *      R imprime (t value), absent du tableau d'article.
   *
   * Nombres : NOTRE.coefs[1] (b, se, t, bas, haut) dans src/lib/data/seance7.js.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 3) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const C = NOTRE.coefs[1];
  // La règle couvre 0 et l'intervalle de confiance, avec un peu d'air.
  const D0 = -0.05, D1 = 0.3, X0 = 40, X1 = 620, YA = 210;
  const GRAD = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3];
  const x = (v) => X0 + ((v - D0) / (D1 - D0)) * (X1 - X0);
  // Les marches d'une erreur type, de la pente vers 0.
  const N_ET = Math.floor(Math.abs(C.b) / C.se);
  const PAS = Array.from({ length: N_ET }, (_, k) => C.b + Math.sign(-C.b) * k * C.se);
  const BX = `b-${VARS.x.nom}`, SX = `se-${VARS.x.nom}`;
  const ON = [[BX], [SX], [SX, BX], [SX, BX]];
  const DIT = [
    '',
    `(${f(C.se)}) : l’écart typique d’un sondage à l’autre`,
    'environ 2 erreurs types de chaque côté : l’intervalle à 95 %',
    `0 est à ${f(Math.abs(C.t), 1)} erreurs types : c’est le t de R`
  ];
</script>

<div class="visuel tab-et" bind:this={hote}>
  <div class="tet-tab"><TabPublie on={ON[e]} /></div>

  <div class="tet-fig">
    <svg viewBox="0 0 660 290" role="img" aria-label="Une règle des pentes. Notre pente, {f(C.b)}, et son erreur type, {f(C.se)}. L’intervalle de confiance à 95 % va de {f(C.bas)} à {f(C.haut)}. Zéro est à {f(Math.abs(C.t), 1)} erreurs types de la pente.">
      <!-- La règle. -->
      <line x1={X0} y1={YA} x2={X1} y2={YA} class="tet-axe" />
      {#each GRAD as v}
        <line x1={x(v)} y1={YA} x2={x(v)} y2={YA + 8} class="tet-axe" />
        <text x={x(v)} y={YA + 32} class="tet-tick">{f(v, v ? 2 : 0)}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={YA + 66} class="tet-titre">la pente (de 0 à 1)</text>

      <!-- 0 : aucun lien. -->
      <line x1={x(0)} y1={YA} x2={x(0)} y2="40" class="tet-zero" />
      <text x={x(0)} y="28" class="tet-lib tet-encre">0 = aucun lien</text>

      <!-- 3 · Les erreurs types comptées jusqu'à 0. -->
      <g class="tet-compte" class:tet-vu={e >= 3}>
        {#each PAS as v, k}
          <rect x={Math.min(x(v), x(v + C.se))} y={YA - 58} width={Math.abs(x(v + C.se) - x(v)) - 3} height="20" class="tet-case" style="transition-delay: {k * 60}ms" />
        {/each}
        <text x={(x(C.b) + x(0)) / 2} y={YA - 72} class="tet-lib">{f(Math.abs(C.t), 1)} erreurs types</text>
      </g>

      <!-- 2 · L'intervalle de confiance. -->
      <g class="tet-ic" class:tet-vu={e >= 2}>
        <line x1={x(C.bas)} y1={YA - 20} x2={x(C.haut)} y2={YA - 20} class="tet-ic-l" />
        <line x1={x(C.bas)} y1={YA - 30} x2={x(C.bas)} y2={YA - 10} class="tet-ic-l" />
        <line x1={x(C.haut)} y1={YA - 30} x2={x(C.haut)} y2={YA - 10} class="tet-ic-l" />
        <text x={x(C.bas) - 10} y={YA - 14} class="tet-borne tet-fin-g">{f(C.bas)}</text>
        <text x={x(C.haut) + 10} y={YA - 14} class="tet-borne tet-fin-d">{f(C.haut)}</text>
      </g>

      <!-- 1 · Une erreur type de chaque côté. -->
      <g class="tet-un" class:tet-vu={e >= 1}>
        <rect x={x(C.b - C.se)} y={YA - 9} width={x(C.b + C.se) - x(C.b - C.se)} height="18" class="tet-se" />
      </g>

      <!-- La pente. -->
      <circle cx={x(C.b)} cy={YA} r="9" class="tet-pt" />
      <text x={x(C.b)} y="28" class="tet-lib">{f(C.b)}</text>
      <line x1={x(C.b)} y1="40" x2={x(C.b)} y2={YA - 12} class="tet-fil" />
    </svg>
    <p class="tet-dit" class:tet-vu={e > 0}>{DIT[e] || ' '}</p>
  </div>
</div>

<style>
  .tab-et { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tet-tab { font-size: 0.92em; }
  .tet-fig { display: flex; flex-direction: column; gap: 0.4em; }
  svg { width: 100%; height: auto; display: block; }
  .tet-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tet-tick { font-family: var(--dk-mono); font-size: 19px; fill: var(--dk-gris); text-anchor: middle; }
  .tet-titre { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; letter-spacing: 0.06em; fill: var(--dk-encre); text-anchor: middle; }
  .tet-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 6 5; }
  .tet-lib { font-family: var(--dk-mono); font-size: 22px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .tet-encre { fill: var(--dk-encre); font-weight: 600; }
  .tet-fil { stroke: var(--dk-accent); stroke-width: 2; }
  .tet-pt { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }

  .tet-un, .tet-ic { opacity: 0; transition: opacity 0.4s; }
  .tet-un.tet-vu, .tet-ic.tet-vu { opacity: 1; }
  .tet-se { fill: rgba(198, 16, 46, 0.22); stroke: var(--dk-accent); stroke-width: 2; }
  .tet-ic-l { stroke: var(--dk-encre); stroke-width: 3; }
  .tet-borne { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; fill: var(--dk-encre); }
  .tet-fin-g { text-anchor: end; }
  .tet-fin-d { text-anchor: start; }

  .tet-case { fill: none; stroke: var(--dk-accent); stroke-width: 2; opacity: 0; transition: opacity 0.2s; }
  .tet-compte .tet-lib { opacity: 0; transition: opacity 0.3s 0.6s; }
  .tet-compte.tet-vu .tet-case, .tet-compte.tet-vu .tet-lib { opacity: 1; }

  .tet-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.3s; }
  .tet-dit.tet-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .tet-un, .tet-ic, .tet-case, .tet-compte .tet-lib, .tet-dit { transition: none; }
  }
</style>
