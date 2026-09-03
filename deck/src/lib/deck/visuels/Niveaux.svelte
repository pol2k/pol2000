<script>
  /**
   * Trois niveaux de mesure, trois formes, trois temps. Nominal: des boîtes
   * éparses qu'aucun ordre ne relie. Ordinal: des marches, dans l'ordre, mais
   * d'inégales hauteurs. Intervalle / ratio: une règle à écarts égaux, sur
   * laquelle on calcule. Chaque clic éclaire un panneau et sa règle: ce que
   * ce niveau permet.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const on = (i) => e === 0 || e === i;
</script>

<div class="visuel niveaux" bind:this={hote}>
  <div class="niv" class:on={on(1)} class:seul={e === 1}>
    <svg viewBox="0 0 360 200">
      <g class="boites">
        <rect x="20" y="30" width="90" height="40" class="boite" style="--d: 0ms" /><text x="65" y="56" class="lib">PLQ</text>
        <rect x="230" y="18" width="90" height="40" class="boite" style="--d: 120ms" /><text x="275" y="44" class="lib">CAQ</text>
        <rect x="130" y="100" width="90" height="40" class="boite" style="--d: 240ms" /><text x="175" y="126" class="lib">QS</text>
        <rect x="250" y="135" width="90" height="40" class="boite" style="--d: 360ms" /><text x="295" y="161" class="lib">PQ</text>
        <rect x="15" y="130" width="90" height="40" class="boite" style="--d: 480ms" /><text x="60" y="156" class="lib">PCQ</text>
      </g>
    </svg>
    <strong>Nominal</strong>
    <span>Des catégories. Aucun ordre.</span>
    <em>le parti</em>
    <small class="permis">On compte. On ne classe pas, on ne moyenne pas.</small>
  </div>
  <div class="niv" class:on={on(2)} class:seul={e === 2}>
    <svg viewBox="0 0 360 200">
      <path d="M 20 175 H 120 V 135 H 220 V 40 H 340" class="marche" />
      <text x="70" y="194" class="lib">secondaire</text>
      <text x="170" y="123" class="lib">collégial</text>
      <text x="280" y="28" class="lib">universitaire</text>
      <line x1="120" y1="175" x2="120" y2="135" class="ecart" /><text x="132" y="162" class="petit">petit</text>
      <line x1="220" y1="135" x2="220" y2="40" class="ecart" /><text x="232" y="95" class="petit">grand ?</text>
    </svg>
    <strong>Ordinal</strong>
    <span>Un ordre. Des écarts inégaux.</span>
    <em>la scolarité</em>
    <small class="permis">On classe. La médiane a un sens; la moyenne, pas vraiment.</small>
  </div>
  <div class="niv" class:on={on(3)} class:seul={e === 3}>
    <svg viewBox="0 0 360 200">
      <line x1="20" y1="110" x2="340" y2="110" class="regle" />
      {#each Array.from({ length: 11 }) as _, i}
        <line x1={20 + i * 32} y1={i % 5 === 0 ? 82 : 94} x2={20 + i * 32} y2="110" class="regle" />
      {/each}
      <text x="20" y="145" class="lib g">18</text><text x="180" y="145" class="lib">…</text><text x="340" y="145" class="lib d">98</text>
      <text x="180" y="60" class="petit">un an = un an, partout</text>
      <text x="180" y="185" class="somme">moyenne · écart-type · différence</text>
    </svg>
    <strong>Intervalle · ratio</strong>
    <span>Un ordre <em>et</em> des écarts égaux.</span>
    <em>l'âge · le revenu · 0–10</em>
    <small class="permis">On calcule tout.</small>
  </div>
</div>

<style>
  .niveaux { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.1em; align-items: stretch; }
  .niv { border: 3px solid var(--dk-encre); padding: 0.8em 1em 0.9em; display: flex; flex-direction: column; gap: 0.2em; opacity: 0.22; transition: opacity 0.45s, border-color 0.45s, transform 0.45s; }
  .niv.on { opacity: 1; }
  .niv.seul { border-color: var(--dk-accent); transform: translateY(-0.3em); }
  .niv svg { width: 100%; height: auto; margin-bottom: 0.4em; }
  .niv strong { font-size: 1.35em; }
  .niv > span { font-size: 0.82em; color: var(--dk-gris); }
  .niv > em { font-size: 0.82em; color: var(--dk-accent); font-style: normal; font-weight: 600; }
  .permis { margin-top: 0.5em; font-size: 0.74em; border-top: 2px solid var(--dk-filet); padding-top: 0.4em; color: var(--dk-encre); }
  .boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .seul .boite { animation: flotte 2.6s ease-in-out infinite; animation-delay: var(--d); transform-box: fill-box; transform-origin: center; }
  @keyframes flotte { 50% { transform: translateY(-5px); } }
  .lib { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-encre); font-weight: 600; }
  .lib.g { text-anchor: start; } .lib.d { text-anchor: end; }
  .marche { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-linejoin: round; }
  .ecart { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 5 4; }
  .petit { font-family: var(--dk-mono); font-size: 14px; fill: var(--dk-accent); text-anchor: middle; }
  .regle { stroke: var(--dk-encre); stroke-width: 4; }
  .somme { font-family: var(--dk-mono); font-size: 14px; fill: var(--dk-gris); text-anchor: middle; }
</style>
