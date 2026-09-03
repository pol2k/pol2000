<script>
  /**
   * Les examens: sur papier, cahier ouvert, sans écran — exprès. Une feuille
   * et un crayon, un cahier de notes coché, un portable barré. À droite, les
   * trois examens du plan de cours.
   */
</script>

<div class="visuel examens">
  <svg viewBox="0 0 520 370" role="img" aria-label="Une feuille d'examen et un crayon, un cahier de notes permis, un ordinateur barré.">
    <!-- feuille -->
    <rect x="40" y="40" width="200" height="270" class="feuille" />
    {#each [90, 120, 150, 180, 210, 240] as y}<line x1="65" y1={y} x2={y === 240 ? 150 : 215} y2={y} class="ligne" />{/each}
    <!-- crayon -->
    <g transform="translate(150 250) rotate(-35)">
      <rect x="-8" y="-70" width="16" height="110" class="crayon" /><path d="M -8 40 L 0 62 L 8 40 Z" class="mine" /><rect x="-8" y="-82" width="16" height="12" class="gomme" />
    </g>
    <!-- cahier: permis -->
    <g transform="translate(300 60)">
      <rect x="0" y="0" width="150" height="110" class="cahier" />
      <line x1="30" y1="0" x2="30" y2="110" class="reliure" />
      {#each [30, 55, 80] as y}<line x1="45" y1={y} x2="130" y2={y} class="ligne" />{/each}
      <text x="75" y="134" class="lib">VOS NOTES</text>
      <text x="152" y="18" class="ok">✓</text>
    </g>
    <!-- portable: interdit -->
    <g transform="translate(300 225)">
      <rect x="15" y="0" width="120" height="76" rx="4" class="ecran" />
      <rect x="0" y="80" width="150" height="10" class="base" />
      <text x="75" y="120" class="lib">ÉCRAN</text>
      <line x1="10" y1="-6" x2="140" y2="96" class="barre" /><line x1="140" y1="-6" x2="10" y2="96" class="barre" />
    </g>
  </svg>
  <div class="liste">
    <div class="ex"><span class="n">1</span><div><strong>Chez vous, sur R</strong><small>24 sept. → dim. 4 oct. · l'outil, c'est l'ordinateur</small></div></div>
    <div class="ex papier"><span class="n">2</span><div><strong>En classe, sur papier</strong><small>jeu. 12 nov. · 17h20 · 1 h · cahier ouvert</small></div></div>
    <div class="ex papier"><span class="n">3</span><div><strong>En classe, sur papier</strong><small>jeu. 10 déc. · 17h20 · 1 h · cahier ouvert</small></div></div>
  </div>
</div>

<style>
  .examens { display: grid; grid-template-columns: 1.1fr 1fr; gap: 2em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 58vh; }
  .feuille { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .ligne { stroke: var(--dk-gris-2); stroke-width: 4; stroke-linecap: round; }
  .crayon { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .mine { fill: var(--dk-encre); } .gomme { fill: var(--dk-accent); }
  .cahier { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .reliure { stroke: var(--dk-encre); stroke-width: 4; }
  .ok { font-family: var(--dk-mono); font-size: 40px; font-weight: 600; fill: var(--dk-encre); }
  .ecran { fill: var(--dk-fond-2); stroke: var(--dk-gris); stroke-width: 4; }
  .base { fill: var(--dk-gris); }
  .barre { stroke: var(--dk-accent); stroke-width: 7; stroke-linecap: round; }
  .lib { font-family: var(--dk-mono); font-size: 14px; letter-spacing: 0.16em; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .liste { display: flex; flex-direction: column; gap: 0.7em; }
  .ex { display: grid; grid-template-columns: auto 1fr; gap: 0.8em; align-items: center; border: 2px solid var(--dk-encre); padding: 0.6em 0.9em; }
  .ex.papier { border-color: var(--dk-accent); border-width: 3px; }
  .ex .n { font-family: var(--dk-mono); font-size: 1.8em; font-weight: 600; color: var(--dk-accent); }
  .ex strong { display: block; font-size: 1em; }
  .ex small { display: block; font-size: 0.7em; color: var(--dk-gris); margin-top: 0.15em; }
</style>
