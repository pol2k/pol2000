<script>
  /**
   * Trois échantillons de 50, trois moyennes. Un axe d'âge, de 15 à 100 ans.
   *
   *   0  L'âge moyen des N répondant.e.s de l'Étude électorale canadienne
   *      2025 (POP.moyenne, sans pondération) : une ligne pointillée.
   *   1  Le premier échantillon : ses 50 âges, un point chacun, sur sa
   *      rangée (un petit décalage vertical fixe pour qu'ils ne se cachent
   *      pas), et un trait rouge à sa moyenne.
   *   2  Le deuxième.
   *   3  Le troisième.
   *
   * Les âges et les moyennes viennent de TROIS (src/lib/data/seance5.js,
   * graine 3 dans outils/seance5_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, TROIS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const x = (v) => 210 + ((v - 15) / 85) * 760;
  const RANG = [115, 200, 285];
  const AXE = 345;
  // Décalage vertical fixe, de -10 à +10.
  const saut = (i) => (((i * 37) % 11) - 5) * 2;
  const XP = x(POP.moyenne);
</script>

<div class="visuel trois-tirages" bind:this={hote}>
  <svg viewBox="0 0 1000 410" role="img" aria-label="L’âge moyen des {f(POP.n)} répondant.e.s est de {f(POP.moyenne, 1)} ans. Trois échantillons aléatoires de {TROIS[0].ages.length} personnes donnent trois moyennes : {TROIS.map((t) => f(t.moyenne, 1) + ' ans').join(', ')}.">
    <!-- La vraie moyenne. -->
    <line x1={XP} y1="50" x2={XP} y2={AXE} class="tt-pop" />
    <text x={XP} y="34" class="tt-pop-t">les {f(POP.n)}&#8239;: {f(POP.moyenne, 1)} ans</text>

    <!-- L'axe des âges. -->
    <line x1={x(15)} y1={AXE} x2={x(100)} y2={AXE} class="tt-axe" />
    {#each [20, 30, 40, 50, 60, 70, 80, 90, 100] as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 7} class="tt-axe" />
      <text x={x(t)} y={AXE + 27} class="tt-tick">{t}</text>
    {/each}
    <text x={x(100)} y={AXE + 54} class="tt-tick tt-fin">âge (ans)</text>

    <!-- Les trois échantillons. -->
    {#each TROIS as t, k}
      {#if e >= k + 1}
        {@const y = RANG[k]}
        {@const xm = x(t.moyenne)}
        {@const aGauche = t.moyenne < POP.moyenne}
        <text x="40" y={y + 6} class="tt-nom">échantillon {k + 1}</text>
        {#each t.ages as a, i}
          <circle cx={x(a)} cy={y + saut(i)} r="5.5" class="tt-pt" style="animation-delay: {i * 12}ms" />
        {/each}
        <line x1={xm} y1={y - 30} x2={xm} y2={y + 30} class="tt-moy" />
        <text x={aGauche ? xm - 12 : xm + 12} y={y - 16} class="tt-moy-t" class:tt-fin={aGauche}>{f(t.moyenne, 1)} ans</text>
      {/if}
    {/each}
  </svg>
</div>

<style>
  .trois-tirages { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .tt-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .tt-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .tt-fin { text-anchor: end; }
  .tt-pop { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .tt-pop-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tt-nom { font-size: 18px; fill: var(--dk-gris); animation: tt-fondu 0.3s ease-out both; }
  .tt-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 1.5; transform-box: fill-box; transform-origin: center; animation: tt-pop 0.35s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  .tt-moy { stroke: var(--dk-accent); stroke-width: 5; transform-box: fill-box; transform-origin: center; animation: tt-trait 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) 0.75s both; }
  .tt-moy-t { font-size: 22px; font-weight: 600; fill: var(--dk-accent); animation: tt-fondu 0.4s ease-out 1s both; }
  @keyframes tt-pop { from { transform: scale(0); } to { transform: scale(1); } }
  @keyframes tt-trait { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  @keyframes tt-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .tt-nom, .tt-pt, .tt-moy, .tt-moy-t { animation: none; }
  }
</style>
