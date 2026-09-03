<script>
  /**
   * Une variable varie. Douze cas; au premier temps leurs valeurs diffèrent
   * (les barres montent chacune à sa hauteur); au second, la même valeur
   * partout — une constante, et rien à expliquer. Hauteurs fixes,
   * schématiques.
   */
  import { brancherTemps } from '../temps.js';
  const H = [40, 72, 22, 58, 90, 35, 66, 48, 80, 28, 60, 44];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel varie" bind:this={hote}>
  <div class="scene">
    <div class="cas">
      {#each H as h, i}
        <div class="col"><i style="height: {e === 0 ? 4 : e === 1 ? h : 55}%; transition-delay: {i * 40}ms"></i><span>{i + 1}</span></div>
      {/each}
    </div>
    <div class="axe"></div>
  </div>
  <div class="legende">
    <div class:vu={e === 0}><strong>Douze cas.</strong> Douze personnes sondées, par exemple.</div>
    <div class:vu={e === 1}><span class="et acc">VARIABLE</span><strong>La valeur change d'un cas à l'autre.</strong> La province, dans un sondage pancanadien.</div>
    <div class:vu={e === 2}><span class="et">CONSTANTE</span><strong>La même valeur partout.</strong> « Inscrit.e à Laval », dans un sondage mené à Laval. Il n'y a rien à expliquer.</div>
  </div>
</div>

<style>
  .varie { display: flex; flex-direction: column; gap: 1em; }
  .scene { position: relative; }
  .cas { display: flex; gap: 0.7em; height: 13em; align-items: flex-end; padding: 0 0.4em; }
  .col { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; height: 100%; gap: 0.3em; }
  .col i { display: block; width: 100%; background: var(--dk-encre); transition: height 0.7s cubic-bezier(0.65, 0, 0.25, 1); }
  .col span { font-family: var(--dk-mono); font-size: 0.7em; color: var(--dk-gris); }
  .axe { height: 4px; background: var(--dk-encre); }
  .legende { position: relative; min-height: 3.4em; }
  .legende > div { position: absolute; inset: 0; opacity: 0; transition: opacity 0.4s; font-size: 1.05em; line-height: 1.4; }
  .legende > div.vu { opacity: 1; }
  .et { display: inline-block; font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); margin-right: 0.8em; vertical-align: middle; }
  .et.acc { color: var(--dk-accent); }
</style>
