<script>
  /**
   * hist(df$cps25_age_in_years), tel que R le dessine : les bornes (de cinq
   * ans en cinq ans) et les effectifs viennent de hist() lui-même
   * (src/lib/data/ces2025.js, généré par outils/ces_data.R). La moyenne est
   * posée dessus au second temps, pour lier le chiffre à la forme.
   */
  import { brancherTemps } from '../temps.js';
  import { HIST_AGE, MOY_AGE } from '$lib/data/ces2025.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const X0 = 90, X1 = 740, Y0 = 380, Y1 = 30;
  const [b0, b1] = [HIST_AGE.bornes[0], HIST_AGE.bornes[HIST_AGE.bornes.length - 1]];
  const max = Math.max(...HIST_AGE.effectifs);
  const x = (v) => X0 + ((v - b0) / (b1 - b0)) * (X1 - X0);
  const y = (n) => Y0 - (n / max) * (Y0 - Y1);
  // Dix-sept barres : on n'écrit l'effectif que sur celles qui ont la place.
  const moy = MOY_AGE.toLocaleString('fr-CA', { maximumFractionDigits: 1 });
  const graduations = [0, 500, 1000, 1500, 2000];
</script>

<div class="visuel histo" bind:this={hote}>
  <pre class="code">hist(df$cps25_age_in_years)
<span class:on={e >= 1}>mean(df$cps25_age_in_years)
<i>[1] 49.71511</i></span></pre>
  <svg viewBox="0 0 780 430" role="img" aria-label="Histogramme de l'âge des 20 180 répondant.e.s de l'Étude électorale canadienne 2025 : de 18 à 96 ans, en tranches de cinq ans, une répartition presque plate de 25 à 70 ans.">
    {#each graduations as g}
      <line x1={X0 - 8} y1={y(g)} x2={X0} y2={y(g)} class="axe" /><text x={X0 - 14} y={y(g) + 5} class="tick d">{g}</text>
    {/each}
    <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="axe" /><line x1={X0} y1={Y0} x2={X0} y2={Y1} class="axe" />
    {#each HIST_AGE.effectifs as n, i}
      <rect x={x(HIST_AGE.bornes[i])} y={y(n)} width={x(HIST_AGE.bornes[i + 1]) - x(HIST_AGE.bornes[i])} height={Y0 - y(n)} class="barre" style="animation-delay: {i * 50}ms" />
      {#if n >= 100}<text x={(x(HIST_AGE.bornes[i]) + x(HIST_AGE.bornes[i + 1])) / 2} y={y(n) - 7} class="n">{n}</text>{/if}
    {/each}
    {#each HIST_AGE.bornes as b}
      {#if b % 10 === 0}<line x1={x(b)} y1={Y0} x2={x(b)} y2={Y0 + 8} class="axe" /><text x={x(b)} y={Y0 + 26} class="tick">{b}</text>{/if}
    {/each}
    <text x={(X0 + X1) / 2} y="422" class="lab">df$cps25_age_in_years</text>
    <text transform="translate(22 {(Y0 + Y1) / 2}) rotate(-90)" class="lab">Frequency</text>
    <g class="moy" class:vu={e >= 1}>
      <!-- L'étiquette vit au-dessus des barres : dix-sept effectifs occupent déjà le haut du dessin. -->
      <line x1={x(MOY_AGE)} y1={Y0} x2={x(MOY_AGE)} y2={Y1 - 12} />
      <text x={x(MOY_AGE) + 10} y={Y1 - 16}>moyenne · {moy} ans</text>
    </g>
  </svg>
</div>

<style>
  .histo { display: grid; grid-template-columns: 1fr 1.6fr; gap: 1.4em; align-items: center; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 0.9em; line-height: 1.7; border: 3px solid var(--dk-encre); padding: 0.7em 0.9em; white-space: pre; }
  .code span { color: var(--dk-gris-2); transition: color 0.3s; }
  .code span.on { color: var(--dk-encre); }
  .code i { font-style: normal; color: var(--dk-gris); }
  .code span.on i { color: var(--dk-accent); font-weight: 600; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .barre { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 2; animation: monte 0.5s both; transform-origin: bottom; transform-box: fill-box; }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .n { font-family: var(--dk-mono); font-size: 11px; text-anchor: middle; fill: var(--dk-gris); }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .lab { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }
  .moy { opacity: 0; transition: opacity 0.4s; }
  .moy.vu { opacity: 1; }
  .moy line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 8; }
  .moy text { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-accent); }
</style>
