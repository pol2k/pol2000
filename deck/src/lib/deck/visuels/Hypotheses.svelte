<script>
  /**
   * Deux esquisses: à gauche, ce que H1 prédit (les points montent avec X);
   * à droite, H0 (aucune relation, un nuage plat). Points fixes, schématiques.
   */
  const H1 = [[30,120],[55,112],[80,98],[105,104],[130,86],[155,78],[180,66],[205,72],[230,52],[255,44],[270,36]];
  const H0 = [[30,84],[55,66],[80,98],[105,58],[130,92],[155,72],[180,100],[205,62],[230,88],[255,70],[270,94]];
</script>

<div class="visuel hyp" role="img" aria-label="H1: les points montent avec X. H0: un nuage plat, aucune relation.">
  <div class="panneau">
    <span class="et acc">H₁ · L'HYPOTHÈSE</span>
    <svg viewBox="0 0 300 160">
      <line x1="20" y1="140" x2="290" y2="140" class="axe" /><line x1="20" y1="140" x2="20" y2="20" class="axe" />
      {#each H1 as [x, y]}<circle cx={x} cy={y} r="5" class="pt" />{/each}
      <line x1="28" y1="122" x2="280" y2="36" class="droite" />
      <text x="290" y="156" class="lib">âge</text><text x="10" y="16" class="lib g">vote</text>
    </svg>
    <p>Plus on est âgé, plus on vote.</p>
  </div>
  <div class="panneau nul">
    <span class="et">H₀ · L'HYPOTHÈSE NULLE</span>
    <svg viewBox="0 0 300 160">
      <line x1="20" y1="140" x2="290" y2="140" class="axe" /><line x1="20" y1="140" x2="20" y2="20" class="axe" />
      {#each H0 as [x, y]}<circle cx={x} cy={y} r="5" class="pt" />{/each}
      <line x1="28" y1="80" x2="280" y2="80" class="droite plate" />
      <text x="290" y="156" class="lib">âge</text><text x="10" y="16" class="lib g">vote</text>
    </svg>
    <p>L'âge ne change rien.</p>
  </div>
</div>

<style>
  .hyp { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .panneau { border: 3px solid var(--dk-accent); padding: 0.6em 0.8em 0.6em; display: flex; flex-direction: column; gap: 0.3em; }
  .panneau.nul { border-color: var(--dk-gris); border-style: dashed; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .et.acc { color: var(--dk-accent); }
  .panneau svg { width: 100%; height: auto; }
  .panneau p { margin: 0; font-size: 0.95em; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .pt { fill: var(--dk-encre); }
  .droite { stroke: var(--dk-accent); stroke-width: 4; }
  .droite.plate { stroke: var(--dk-gris); stroke-dasharray: 8 6; }
  .lib { font-family: var(--dk-mono); font-size: 13px; text-anchor: end; fill: var(--dk-gris); }
  .lib.g { text-anchor: start; }
</style>
