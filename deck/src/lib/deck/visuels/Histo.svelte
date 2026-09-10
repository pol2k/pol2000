<script>
  /**
   * hist(df$Fertility), tel que R le dessine : les bornes et les effectifs
   * viennent de hist() lui-même (src/lib/data/swiss.js). La moyenne est
   * posée dessus au second temps, pour lier le chiffre à la forme.
   */
  import { brancherTemps } from '../temps.js';
  import { HIST, MOY_FERTILITE } from '$lib/data/swiss.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const X0 = 80, X1 = 740, Y0 = 380, Y1 = 30;
  const [b0, b1] = [HIST.bornes[0], HIST.bornes[HIST.bornes.length - 1]];
  const max = Math.max(...HIST.effectifs);
  const x = (v) => X0 + ((v - b0) / (b1 - b0)) * (X1 - X0);
  const y = (n) => Y0 - (n / max) * (Y0 - Y1);
  const moy = MOY_FERTILITE.toLocaleString('fr-CA', { maximumFractionDigits: 1 });
</script>

<div class="visuel histo" bind:this={hote}>
  <pre class="code">hist(df$Fertility)
<span class:on={e >= 1}>mean(df$Fertility)
<i>[1] 70.14255</i></span></pre>
  <svg viewBox="0 0 780 430" role="img" aria-label="Histogramme de l'indice de fécondité de 47 provinces suisses : la plupart entre 60 et 80.">
    <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="axe" /><line x1={X0} y1={Y0} x2={X0} y2={Y1} class="axe" />
    {#each HIST.effectifs as n, i}
      <rect x={x(HIST.bornes[i])} y={y(n)} width={x(HIST.bornes[i + 1]) - x(HIST.bornes[i])} height={Y0 - y(n)} class="barre" style="animation-delay: {i * 90}ms" />
      <text x={(x(HIST.bornes[i]) + x(HIST.bornes[i + 1])) / 2} y={y(n) - 8} class="n">{n}</text>
    {/each}
    {#each HIST.bornes as b}
      <text x={x(b)} y={Y0 + 24} class="tick">{b}</text>
    {/each}
    <text x={(X0 + X1) / 2} y="422" class="lab">df$Fertility</text>
    <text transform="translate(24 {(Y0 + Y1) / 2}) rotate(-90)" class="lab">Frequency</text>
    <g class="moy" class:vu={e >= 1}>
      <line x1={x(MOY_FERTILITE)} y1={Y0} x2={x(MOY_FERTILITE)} y2={Y1 + 10} />
      <text x={x(MOY_FERTILITE) + 10} y={Y1 + 24}>moyenne · {moy}</text>
    </g>
  </svg>
</div>

<style>
  .histo { display: grid; grid-template-columns: 1fr 1.6fr; gap: 1.4em; align-items: center; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.7; border: 3px solid var(--dk-encre); padding: 0.7em 0.9em; white-space: pre; }
  .code span { color: var(--dk-gris-2); transition: color 0.3s; }
  .code span.on { color: var(--dk-encre); }
  .code i { font-style: normal; color: var(--dk-gris); }
  .code span.on i { color: var(--dk-accent); font-weight: 600; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .barre { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 2; animation: monte 0.5s both; transform-origin: bottom; transform-box: fill-box; }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .n { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .lab { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }
  .moy { opacity: 0; transition: opacity 0.4s; }
  .moy.vu { opacity: 1; }
  .moy line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 8; }
  .moy text { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-accent); }
</style>
