<script>
  /**
   * Les deux nombres du haut du tableau dessinent la droite. À gauche, le
   * tableau d'article (TabPublie). À droite, le nuage de notre sondage (les
   * 783 personnes, très pâles : gauche_droite est un entier, `jx` l'étale de
   * ± 0,3 pour le dessin seulement) et la droite de R.
   *
   *   0  Le nuage seul.
   *   1  La constante, 79,81 : la note que la droite prédit à 0 (tout à
   *      gauche). Un point sur l'axe vertical.
   *   2  Le signe : la droite part de ce point et descend. Négatif = plus on
   *      va à droite, plus la note baisse.
   *   3  La taille : un cran vers la droite (de 4 à 5), 5,05 points de moins.
   *   4  De 0 à 10 : dix marches, 50,5 points de moins.
   *
   * Nombres : NOTRE.coefs et NOTRE.points dans src/lib/data/seance7.js
   * (outils/seance7_data.R). Les marches sont calculées depuis la pente.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const B0 = NOTRE.coefs[0].b, B1 = NOTRE.coefs[1].b;
  const X0 = 86, X1 = 606, Y0 = 372, Y1 = 34;
  const x = (v) => X0 + (v / 10) * (X1 - X0);
  const y = (v) => Y0 - (v / 100) * (Y0 - Y1);
  const yd = (v) => y(B0 + B1 * v);
  const PTS = NOTRE.points;
  // La marche du temps 3 : de 4 à 5.
  const M = 4;
  const MARCHES = Array.from({ length: 10 }, (_, k) => k);
  const ON = [[], ['b-(Intercept)'], ['b-gauche_droite'], ['b-gauche_droite'], ['b-gauche_droite']];
  const DIT = [
    '',
    `à 0, la droite prédit ${f(B0, 2)}`,
    B1 < 0 ? 'négatif : plus à droite, moins de sympathie' : 'positif : plus à droite, plus de sympathie',
    `un cran vers la droite, ${f(Math.abs(B1), 2)} points de ${B1 < 0 ? 'moins' : 'plus'}`,
    `de 0 à 10 : ${f(Math.abs(10 * B1), 1)} points de ${B1 < 0 ? 'moins' : 'plus'}`
  ];
</script>

<div class="visuel tab-droite" bind:this={hote}>
  <div class="td-tab"><TabPublie on={ON[e]} /></div>

  <div class="td-fig">
    <svg viewBox="0 0 640 430" role="img" aria-label="Le nuage des {PTS.length} personnes de notre sondage et la droite de R. À 0, tout à gauche, la droite prédit une note de {f(B0, 1)} sur 100. Elle descend de {f(Math.abs(B1), 2)} points à chaque cran vers la droite, soit {f(Math.abs(10 * B1), 1)} points de 0 à 10.">
      <!-- Le nuage, très pâle : le décor. -->
      {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.y)} r="2.4" class="td-pt" />{/each}

      <!-- Les axes. -->
      <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="td-axe" />
      <line x1={X0} y1={Y0} x2={X0} y2={Y1} class="td-axe" />
      {#each [0, 2, 4, 6, 8, 10] as v}
        <line x1={x(v)} y1={Y0} x2={x(v)} y2={Y0 + 7} class="td-axe" />
        <text x={x(v)} y={Y0 + 26} class="td-tick">{v}</text>
      {/each}
      {#each [0, 50, 100] as v}
        <line x1={X0 - 7} y1={y(v)} x2={X0} y2={y(v)} class="td-axe" />
        <text x={X0 - 12} y={y(v) + 6} class="td-tick td-g">{v}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={Y0 + 52} class="td-titre-axe">position gauche-droite</text>
      <text x={X0} y={Y1 - 14} class="td-titre-axe td-g0">note de Carney</text>

      <!-- 2 · La droite, qui se dessine depuis la constante. -->
      <line x1={x(0)} y1={yd(0)} x2={x(10)} y2={yd(10)} class="td-droite" class:td-vu={e >= 2} pathLength="1" />

      <!-- 4 · Les dix marches. -->
      <g class="td-marches" class:td-vu={e >= 4}>
        {#each MARCHES as k}
          <path d="M{x(k)} {yd(k)} V{yd(k + 1)} H{x(k + 1)}" class="td-marche" style="transition-delay: {k * 70}ms" />
        {/each}
      </g>

      <!-- 3 · Une marche, de 4 à 5, sous la droite : on descend, puis on avance d'un cran. -->
      <g class="td-une" class:td-vu={e === 3}>
        <line x1={x(M)} y1={yd(M)} x2={x(M)} y2={yd(M + 1)} class="td-pas td-chute" />
        <line x1={x(M)} y1={yd(M + 1)} x2={x(M + 1)} y2={yd(M + 1)} class="td-pas" />
        <text x={x(M) - 12} y={yd(M + 1) + 8} class="td-lib td-fin">{f(B1, 2)}</text>
        <text x={(x(M) + x(M + 1)) / 2} y={yd(M + 1) + 30} class="td-lib td-encre">+1</text>
      </g>

      <!-- 1 · La constante : le point à 0. -->
      <g class="td-const" class:td-vu={e >= 1}>
        <circle cx={x(0)} cy={yd(0)} r="8" class="td-c" />
        <text x={x(0) + 18} y={yd(0) - 16} class="td-lib td-g0" class:td-pale={e >= 2}>{f(B0, 2)}</text>
      </g>
    </svg>
    <p class="td-dit" class:td-vu={e > 0}>{DIT[e] || ' '}</p>
  </div>
</div>

<style>
  .tab-droite { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .td-tab { font-size: 0.92em; }
  .td-fig { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; display: block; max-height: 62vh; }
  .td-pt { fill: var(--dk-encre); opacity: 0.09; }
  .td-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .td-tick { font-family: var(--dk-mono); font-size: 19px; fill: var(--dk-gris); text-anchor: middle; }
  .td-g { text-anchor: end; }
  .td-titre-axe { font-family: var(--dk-mono); font-size: 18px; letter-spacing: 0.08em; fill: var(--dk-encre); text-anchor: middle; font-weight: 600; }
  .td-g0 { text-anchor: start; }

  .td-droite { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .td-droite.td-vu { stroke-dashoffset: 0; }

  .td-const { opacity: 0; transition: opacity 0.35s; }
  .td-const.td-vu { opacity: 1; }
  .td-c { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .td-lib { font-family: var(--dk-mono); font-size: 26px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; }
  .td-pale { opacity: 0.75; }
  .td-lib.td-g0 { text-anchor: start; }
  .td-lib.td-fin { text-anchor: end; }
  .td-lib.td-encre { fill: var(--dk-encre); }

  .td-une { opacity: 0; transition: opacity 0.35s; }
  .td-une.td-vu { opacity: 1; }
  .td-pas { stroke: var(--dk-encre); stroke-width: 3.5; }
  .td-chute { stroke: var(--dk-accent); stroke-width: 5; }

  .td-marche { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; opacity: 0; transition: opacity 0.25s; }
  .td-marches.td-vu .td-marche { opacity: 1; }

  .td-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.3s; }
  .td-dit.td-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .td-droite, .td-const, .td-une, .td-marche, .td-dit { transition: none; }
  }
</style>
