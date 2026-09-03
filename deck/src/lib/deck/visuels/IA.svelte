<script>
  /**
   * L'IA: pour faire mieux, pas pour en faire moins. Deux chemins partent du
   * même point; l'un monte vers un travail net, l'autre descend vers un
   * travail mou — et la paresse se voit. Deux temps: les chemins, puis le
   * verdict.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel ia" bind:this={hote}>
  <svg viewBox="0 0 1000 400" role="img" aria-label="Deux chemins partent de « IA »: vers un travail meilleur, ou vers une vie plus facile et un travail mou.">
    <defs><marker id="fia" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0L10 5L0 10z" class="pointe" /></marker></defs>
    <!-- point de départ -->
    <rect x="60" y="165" width="130" height="70" class="depart" />
    <text x="125" y="208" class="dep-t">IA</text>

    <!-- chemin du haut: meilleur -->
    <path d="M 190 190 C 330 190, 380 90, 520 90 L 640 90" class="chemin haut" marker-end="url(#fia)" />
    <text x="400" y="66" class="lib haut">faire mieux</text>
    <g class="doc bon" transform="translate(680 40)">
      <rect x="0" y="0" width="170" height="110" />
      {#each [22, 42, 62, 82] as y}<line x1="18" y1={y} x2={y === 82 ? 100 : 150} y2={y} class="ligne nette" />{/each}
      <text x="85" y="140" class="verdict bon" class:vu={e === 1}>l'effort se voit</text>
    </g>

    <!-- chemin du bas: plus facile -->
    <path d="M 190 210 C 330 210, 380 310, 520 310 L 640 310" class="chemin bas" marker-end="url(#fia)" />
    <text x="400" y="360" class="lib bas">en faire moins</text>
    <g class="doc mou" transform="translate(680 260)">
      <rect x="0" y="0" width="170" height="110" />
      {#each [22, 42, 62, 82] as y, k}<path d="M 18 {y} q 20 {k % 2 ? 6 : -6} 40 0 t 40 0 t 40 0" class="ligne molle" />{/each}
      <text x="85" y="140" class="verdict mauvais" class:vu={e === 1}>la paresse aussi</text>
    </g>
  </svg>
  <div class="regle" class:vu={e === 1}>
    <strong>L'IA pour faire mieux, pas pour en faire moins.</strong>
    <span>Un travail paresseux avec l'IA se repère en dix secondes. L'effort compte dans la note. Son absence aussi.</span>
  </div>
</div>

<style>
  .ia { display: flex; flex-direction: column; gap: 0.6em; }
  svg { width: 100%; height: auto; max-height: 56vh; }
  .depart { fill: var(--dk-encre); }
  .dep-t { font-family: var(--dk-mono); font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .chemin { fill: none; stroke-width: 5; stroke-linecap: round; }
  .chemin.haut { stroke: var(--dk-accent); }
  .chemin.bas { stroke: var(--dk-gris-2); stroke-dasharray: 12 10; }
  .pointe { fill: var(--dk-gris); }
  .lib { font-family: var(--dk-mono); font-size: 20px; font-weight: 600; text-anchor: middle; }
  .lib.haut { fill: var(--dk-accent); } .lib.bas { fill: var(--dk-gris); }
  .doc rect { fill: var(--dk-fond); stroke-width: 4; }
  .doc.bon rect { stroke: var(--dk-accent); }
  .doc.mou rect { stroke: var(--dk-gris-2); stroke-dasharray: 8 6; }
  .ligne { fill: none; stroke-width: 5; stroke-linecap: round; }
  .ligne.nette { stroke: var(--dk-encre); }
  .ligne.molle { stroke: var(--dk-gris-2); }
  .verdict { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; text-anchor: middle; opacity: 0; transition: opacity 0.5s; }
  .verdict.vu { opacity: 1; }
  .verdict.bon { fill: var(--dk-accent); } .verdict.mauvais { fill: var(--dk-gris); }
  .regle { border-left: 6px solid var(--dk-accent); padding: 0.5em 1em; display: flex; flex-direction: column; gap: 0.2em; opacity: 0.25; transition: opacity 0.5s; }
  .regle.vu { opacity: 1; }
  .regle strong { font-size: 1.25em; }
  .regle span { font-size: 0.85em; color: var(--dk-gris); }
</style>
