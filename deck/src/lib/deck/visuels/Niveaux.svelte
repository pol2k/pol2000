<script>
  /**
   * Trois niveaux de mesure, trois formes: des boîtes éparses sans ordre
   * (nominal), des marches inégales (ordinal), une règle graduée (intervalle
   * / ratio). Ce que chaque forme autorise se lit sans phrase.
   */
</script>

<div class="visuel niveaux" role="img" aria-label="Nominal: des catégories sans ordre. Ordinal: un ordre, des écarts inégaux. Intervalle ou ratio: une règle à écarts égaux.">
  <div class="niv">
    <svg viewBox="0 0 300 170">
      <rect x="20" y="30" width="80" height="34" class="boite" /><text x="60" y="53" class="lib">PLQ</text>
      <rect x="180" y="20" width="80" height="34" class="boite" /><text x="220" y="43" class="lib">CAQ</text>
      <rect x="110" y="95" width="80" height="34" class="boite" /><text x="150" y="118" class="lib">QS</text>
      <rect x="205" y="120" width="80" height="34" class="boite" /><text x="245" y="143" class="lib">PQ</text>
      <rect x="15" y="115" width="80" height="34" class="boite" /><text x="55" y="138" class="lib">PCQ</text>
    </svg>
    <strong>Nominal</strong>
    <span>des catégories. Aucun ordre.</span>
    <em>le parti</em>
  </div>
  <div class="niv">
    <svg viewBox="0 0 300 170">
      <path d="M 20 150 H 100 V 118 H 180 V 40 H 280" class="marche" />
      <text x="52" y="140" class="lib">secondaire</text>
      <text x="140" y="108" class="lib">collégial</text>
      <text x="230" y="30" class="lib">universitaire</text>
      <line x1="100" y1="150" x2="100" y2="118" class="ecart" /><text x="122" y="138" class="petit">petit</text>
      <line x1="180" y1="118" x2="180" y2="40" class="ecart" /><text x="192" y="84" class="petit">grand ?</text>
    </svg>
    <strong>Ordinal</strong>
    <span>un ordre. Des écarts inégaux.</span>
    <em>la scolarité</em>
  </div>
  <div class="niv">
    <svg viewBox="0 0 300 170">
      <line x1="20" y1="100" x2="280" y2="100" class="regle" />
      {#each Array.from({ length: 11 }) as _, i}
        <line x1={20 + i * 26} y1={i % 5 === 0 ? 78 : 88} x2={20 + i * 26} y2="100" class="regle" />
      {/each}
      <text x="20" y="130" class="lib g">18</text>
      <text x="150" y="130" class="lib">…</text>
      <text x="280" y="130" class="lib d">98</text>
      <text x="150" y="60" class="petit">un an = un an, partout</text>
    </svg>
    <strong>Intervalle · ratio</strong>
    <span>un ordre <em>et</em> des écarts égaux. On calcule.</span>
    <em>l'âge · le revenu · 0–10</em>
  </div>
</div>

<style>
  .niveaux { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; }
  .niv { border: 2px solid var(--dk-encre); padding: 0.5em 0.7em 0.6em; display: flex; flex-direction: column; gap: 0.15em; }
  .niv svg { width: 100%; height: auto; margin-bottom: 0.3em; }
  .niv strong { font-size: 1.1em; }
  .niv span { font-size: 0.72em; color: var(--dk-gris); }
  .niv > em { font-size: 0.72em; color: var(--dk-accent); font-style: normal; font-weight: 600; }
  .boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; }
  .lib { font-family: var(--dk-mono); font-size: 14px; text-anchor: middle; fill: var(--dk-encre); font-weight: 600; }
  .lib.g { text-anchor: start; } .lib.d { text-anchor: end; }
  .marche { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .ecart { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 4 3; }
  .petit { font-family: var(--dk-mono); font-size: 12px; fill: var(--dk-accent); text-anchor: middle; }
  .regle { stroke: var(--dk-encre); stroke-width: 3; }
</style>
