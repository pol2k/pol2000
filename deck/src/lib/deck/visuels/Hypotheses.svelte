<script>
  /**
   * L'hypothèse et sa nulle, en trois temps: les points seuls; H1 — la
   * droite qui monte se trace; H0 — le nuage plat s'installe à côté. Puis la
   * phrase qui compte: on ne prouve jamais H1, on demande aux données de
   * rejeter H0. Points fixes, schématiques.
   */
  import { brancherTemps } from '../temps.js';
  const H1 = [[30,120],[55,112],[80,98],[105,104],[130,86],[155,78],[180,66],[205,72],[230,52],[255,44],[270,36]];
  const H0 = [[30,84],[55,66],[80,98],[105,58],[130,92],[155,72],[180,100],[205,62],[230,88],[255,70],[270,94]];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel hyp" bind:this={hote}>
  <div class="deux">
    <div class="panneau" class:vu={e >= 1}>
      <span class="et acc">H₁ · L'HYPOTHÈSE</span>
      <svg viewBox="0 0 300 160">
        <line x1="20" y1="140" x2="290" y2="140" class="axe" /><line x1="20" y1="140" x2="20" y2="20" class="axe" />
        {#each H1 as [x, y], i}<circle cx={x} cy={y} r="5" class="pt" style="transition-delay: {i * 50}ms" class:vu={e >= 1} />{/each}
        <line x1="28" y1="122" x2="280" y2="36" class="droite" class:vu={e >= 1} />
        <text x="290" y="156" class="lib">âge</text><text x="10" y="16" class="lib g">vote</text>
      </svg>
      <p>Plus on est âgé, plus on vote.</p>
    </div>
    <div class="panneau nul" class:vu={e >= 2}>
      <span class="et">H₀ · L'HYPOTHÈSE NULLE</span>
      <svg viewBox="0 0 300 160">
        <line x1="20" y1="140" x2="290" y2="140" class="axe" /><line x1="20" y1="140" x2="20" y2="20" class="axe" />
        {#each H0 as [x, y], i}<circle cx={x} cy={y} r="5" class="pt" style="transition-delay: {i * 50}ms" class:vu={e >= 2} />{/each}
        <line x1="28" y1="80" x2="280" y2="80" class="droite plate" class:vu={e >= 2} />
        <text x="290" y="156" class="lib">âge</text><text x="10" y="16" class="lib g">vote</text>
      </svg>
      <p>L'âge ne change rien.</p>
    </div>
  </div>
  <p class="cle" class:vu={e === 3}>On ne prouve jamais H₁. On demande aux données de <strong>rejeter H₀</strong>. <span>Séance 5.</span></p>
</div>

<style>
  .hyp { display: flex; flex-direction: column; gap: 0.8em; }
  .deux { display: grid; grid-template-columns: 1fr 1fr; gap: 1.4em; }
  .panneau { border: 3px solid var(--dk-accent); padding: 0.8em 1em; display: flex; flex-direction: column; gap: 0.3em; opacity: 0.2; transition: opacity 0.5s; }
  .panneau.vu { opacity: 1; }
  .panneau.nul { border-color: var(--dk-gris); border-style: dashed; }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .et.acc { color: var(--dk-accent); }
  .panneau svg { width: 100%; height: auto; }
  .panneau p { margin: 0; font-size: 1.05em; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .pt { fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s; }
  .pt.vu { opacity: 1; }
  .droite { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 300; stroke-dashoffset: 300; transition: stroke-dashoffset 1s 0.5s ease-out; }
  .droite.vu { stroke-dashoffset: 0; }
  .droite.plate { stroke: var(--dk-gris); }
  .lib { font-family: var(--dk-mono); font-size: 13px; text-anchor: end; fill: var(--dk-gris); }
  .lib.g { text-anchor: start; }
  .cle { margin: 0; font-size: 1.2em; opacity: 0; transition: opacity 0.5s; }
  .cle.vu { opacity: 1; }
  .cle span { color: var(--dk-gris); font-size: 0.8em; margin-left: 0.6em; }
</style>
