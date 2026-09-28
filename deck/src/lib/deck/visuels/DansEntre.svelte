<script>
  /**
   * Dans l'échantillon, entre les échantillons. Quatre échantillons de cinq
   * âges tirés parmi les répondant.e.s de l'Étude électorale canadienne 2025
   * (DANS_ENTRE, outils/seance5_data.R). Deux temps.
   *
   *   0  Quatre rangées sur un même axe des âges : cinq points chacune, une
   *      bande pâle d'un écart type de chaque côté de la moyenne de la rangée
   *      (moyenne ± écart type, comme à la séance 3), un trait rouge à la
   *      moyenne, et l'écart type de la rangée à droite (« dans »).
   *   1  Les quatre moyennes descendent sur un axe à part, « les 4 moyennes ».
   *      Leur bande, de la même façon : la moyenne des quatre moyennes ± leur
   *      écart type (DANS_ENTRE.ecartTypeEntre, « entre »). Une légende :
   *      la variance échantillonnale, Arel-Bundock (2021, p. 64-65).
   *
   * Toutes les valeurs viennent de DANS_ENTRE. La moyenne des quatre moyennes
   * ne sert qu'à placer la bande du bas.
   */
  import { brancherTemps } from '../temps.js';
  import { DANS_ENTRE } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const ECH = DANS_ENTRE.echantillons;
  const TAILLE = ECH[0].ages.length;
  const fr1 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });

  // Un seul axe des âges, de 15 à 80 ans, pour les rangées et pour le bas.
  const A0 = 15, A1 = 80, X0 = 70, X1 = 740;
  const x = (v) => X0 + ((v - A0) / (A1 - A0)) * (X1 - X0);
  const RANGS = [58, 108, 158, 208];
  const AXE = 244;
  const BAS = 352;
  const TICKS = [20, 30, 40, 50, 60, 70, 80];
  const MM = ECH.reduce((s, q) => s + q.moyenne, 0) / ECH.length;
  const ENTRE = DANS_ENTRE.ecartTypeEntre;
  const liste = (a) => a.slice(0, -1).join(', ') + ' et ' + a[a.length - 1];
</script>

<div class="visuel dans-entre" bind:this={hote}>
  <svg viewBox="0 0 1000 430" role="img" aria-label="Quatre échantillons de {TAILLE} âges sur un même axe. Dans chaque échantillon, l’écart type vaut {liste(ECH.map((q) => fr1(q.ecartType)))} ans. Les quatre moyennes, {liste(ECH.map((q) => fr1(q.moyenne)))} ans, descendent sur un axe à part. Leur écart type, entre les échantillons, n’est que de {fr1(ENTRE)} ans.">
    <text x={X0} y="22" class="dse-petit">{ECH.length} échantillons de {TAILLE}</text>
    <text x="990" y="22" class="dse-src">Arel-Bundock (2021, p. 64-65)</text>

    <!-- Les quatre rangées. -->
    {#each ECH as q, k}
      {@const r = RANGS[k]}
      <g class="dse-rang" class:dse-pale={e >= 1}>
        <rect x={x(q.moyenne - q.ecartType)} y={r - 12} width={x(q.moyenne + q.ecartType) - x(q.moyenne - q.ecartType)} height="24" class="dse-bande" />
        {#each q.ages as a, j}
          <circle cx={x(a)} cy={r} r="7" class="dse-pt" style="animation-delay: {k * 120 + j * 40}ms" />
        {/each}
        <line x1={x(q.moyenne)} y1={r - 18} x2={x(q.moyenne)} y2={r + 18} class="dse-moy" />
        <text x="770" y={r + 7} class="dse-dans">dans&#8239;: {fr1(q.ecartType)} ans</text>
      </g>
    {/each}

    <!-- L'axe des âges, commun aux rangées. -->
    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="dse-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 7} class="dse-axe" />
      <text x={x(t)} y={AXE + 26} class="dse-tick">{t}</text>
    {/each}
    <text x={X1 + 12} y={AXE + 6} class="dse-unite">ans</text>

    <!-- Temps 1 : l'axe des moyennes, leur bande, leur écart type. -->
    <g class="dse-etape" class:dse-vu={e >= 1}>
      <text x={X0} y={BAS - 30} class="dse-lab">les {ECH.length} moyennes</text>
      <rect x={x(MM - ENTRE)} y={BAS - 12} width={x(MM + ENTRE) - x(MM - ENTRE)} height="24" class="dse-bande-r" />
      <line x1={X0} y1={BAS} x2={X1} y2={BAS} class="dse-axe" />
      {#each TICKS as t}
        <line x1={x(t)} y1={BAS} x2={x(t)} y2={BAS + 7} class="dse-axe" />
        <text x={x(t)} y={BAS + 26} class="dse-tick">{t}</text>
      {/each}
      <text x="770" y={BAS + 7} class="dse-entre">entre&#8239;: {fr1(ENTRE)} ans</text>
      <text x={X0} y="418" class="dse-cap">La variance échantillonnale&#8239;: l’écart entre les moyennes.</text>
    </g>

    <!-- Les moyennes qui descendent. -->
    {#each ECH as q, k}
      <g class="dse-chute" style="transform: translateY({e >= 1 ? BAS - RANGS[k] : 0}px); transition-delay: {e >= 1 ? 150 + k * 110 : 0}ms">
        <line x1={x(q.moyenne)} y1={RANGS[k] - 18} x2={x(q.moyenne)} y2={RANGS[k] + 18} class="dse-moy" />
      </g>
    {/each}
  </svg>
</div>

<style>
  .dans-entre { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .dse-petit { font-size: 18px; fill: var(--dk-gris); }
  .dse-src { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .dse-rang { transition: opacity 0.4s; }
  .dse-rang.dse-pale { opacity: 0.55; }
  .dse-bande { fill: var(--dk-fond-2); stroke: var(--dk-filet); stroke-width: 2; }
  .dse-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2; transform-box: fill-box; transform-origin: center; animation: dse-pop 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  @keyframes dse-pop { from { transform: scale(0); } to { transform: scale(1); } }
  .dse-moy { stroke: var(--dk-accent); stroke-width: 5; }
  .dse-dans { font-size: 22px; fill: var(--dk-encre); }
  .dse-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .dse-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .dse-unite { font-size: 18px; fill: var(--dk-gris); }
  .dse-lab { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .dse-bande-r { fill: var(--dk-accent); fill-opacity: 0.18; stroke: var(--dk-accent); stroke-width: 2; }
  .dse-entre { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }
  .dse-cap { font-size: 20px; fill: var(--dk-encre); }
  .dse-etape { opacity: 0; transition: opacity 0.3s; }
  .dse-etape.dse-vu { opacity: 1; transition: opacity 0.5s 0.3s; }
  .dse-chute { transition: transform 0.7s cubic-bezier(0.34, 1.3, 0.64, 1); }

  @media (prefers-reduced-motion: reduce) {
    .dse-pt { animation: none; }
    .dse-rang, .dse-etape, .dse-etape.dse-vu, .dse-chute { transition: none; }
  }
</style>
