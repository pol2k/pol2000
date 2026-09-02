<script>
  /**
   * Les trois temps du cours, chacun réduit à son glyphe: un histogramme
   * (décrire), un nuage avec sa droite (relier), un graphe orienté (causer).
   * Les formes sont schématiques et fixes.
   */
  let { actif = 0 } = $props(); // 0 = tous, 1..3 = un seul en évidence
</script>

<div class="parcours" role="img" aria-label="Trois temps: décrire, relier, causer.">
  <div class="temps" class:pale={actif && actif !== 1}>
    <svg viewBox="0 0 200 140">
      {#each [30, 70, 120, 95, 55, 25] as h, i}
        <rect x={20 + i * 28} y={130 - h} width="22" height={h} class="plein" />
      {/each}
      <line x1="14" y1="130" x2="190" y2="130" class="trait" />
    </svg>
    <span class="num">1</span>
    <strong>Décrire</strong>
    <small>une variable</small>
  </div>
  <div class="fleche">→</div>
  <div class="temps" class:pale={actif && actif !== 2}>
    <svg viewBox="0 0 200 140">
      {#each [[30,100],[52,92],[68,78],[85,84],[100,66],[118,60],[135,48],[150,52],[168,32],[180,40],[60,60],[125,80]] as [x, y]}
        <circle cx={x} cy={y} r="5" class="plein" />
      {/each}
      <line x1="20" y1="104" x2="190" y2="30" class="droite" />
    </svg>
    <span class="num">2</span>
    <strong>Relier</strong>
    <small>deux, puis plusieurs</small>
  </div>
  <div class="fleche">→</div>
  <div class="temps" class:pale={actif && actif !== 3}>
    <svg viewBox="0 0 200 140">
      <defs><marker id="pc" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0L10 5L0 10z" class="pointe" /></marker></defs>
      <circle cx="40" cy="105" r="18" class="noeud" /><text x="40" y="111" class="lettre">X</text>
      <circle cx="160" cy="105" r="18" class="noeud" /><text x="160" y="111" class="lettre">Y</text>
      <circle cx="100" cy="32" r="18" class="noeud z" /><text x="100" y="38" class="lettre">Z</text>
      <line x1="60" y1="105" x2="138" y2="105" class="arc" marker-end="url(#pc)" />
      <line x1="88" y1="48" x2="52" y2="88" class="arc" marker-end="url(#pc)" />
      <line x1="112" y1="48" x2="148" y2="88" class="arc" marker-end="url(#pc)" />
    </svg>
    <span class="num">3</span>
    <strong>Causer</strong>
    <small>ou seulement corréler ?</small>
  </div>
</div>

<style>
  .parcours { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.7em; align-items: stretch; }
  .temps { border: 2px solid var(--dk-encre); padding: 0.6em 0.7em 0.7em; display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto auto; column-gap: 0.5em; align-items: baseline; transition: opacity 0.2s; }
  .temps.pale { opacity: 0.28; }
  .temps svg { grid-column: 1 / -1; width: 100%; height: auto; margin-bottom: 0.4em; }
  .num { font-family: var(--dk-mono); font-weight: 600; color: var(--dk-accent); font-size: 1.4em; grid-row: 2 / 4; }
  .temps strong { font-size: 1.25em; }
  .temps small { font-size: 0.72em; color: var(--dk-gris); }
  .fleche { align-self: center; font-size: 2.2em; color: var(--dk-accent); }
  .plein { fill: var(--dk-encre); }
  .trait { stroke: var(--dk-encre); stroke-width: 3; }
  .droite { stroke: var(--dk-accent); stroke-width: 4; }
  .noeud { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .noeud.z { stroke: var(--dk-accent); stroke-dasharray: 5 4; }
  .lettre { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .arc { stroke: var(--dk-encre); stroke-width: 3; }
  .pointe { fill: var(--dk-encre); }
</style>
