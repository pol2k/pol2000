<script>
  /**
   * Une séance, une diapo: le numéro, le titre du plan de cours, la date, une
   * phrase — et un glyphe dessiné pour ce qu'on y fait. Quatorze glyphes,
   * tous schématiques. Les dates et titres viennent du plan de cours A26.
   */
  let { n, titre, date, quoi, note = '' } = $props();
</script>

<div class="visuel seance">
  <div class="texte">
    <span class="num">{String(n).padStart(2, '0')}</span>
    <span class="date">{date}</span>
    <h2>{titre}</h2>
    <p class="quoi">{quoi}</p>
    {#if note}<p class="note">{note}</p>{/if}
  </div>
  <svg viewBox="0 0 400 320" class="glyphe" role="img" aria-label="Glyphe de la séance {n}">
    {#if n === 1}
      <circle cx="200" cy="150" r="110" class="c" />
      <text x="200" y="196" class="grand">?</text>
      {#each [0, 1, 2, 3, 4, 5, 6, 7] as k}
        <circle cx={200 + 140 * Math.cos((k / 8) * 2 * Math.PI)} cy={150 + 140 * Math.sin((k / 8) * 2 * Math.PI)} r="6" class="pt" />
      {/each}
    {:else if n === 2}
      <rect x="30" y="40" width="340" height="230" class="fen" />
      <rect x="30" y="40" width="340" height="28" class="barre" />
      <circle cx="48" cy="54" r="5" class="bouton" /><circle cx="66" cy="54" r="5" class="bouton" /><circle cx="84" cy="54" r="5" class="bouton" />
      <text x="52" y="120" class="code">&gt; 1 + 1</text>
      <text x="52" y="160" class="code sortie">[1] 2</text>
      <text x="52" y="220" class="code">&gt; <tspan class="curseur">█</tspan></text>
    {:else if n === 3}
      {#each [40, 90, 150, 200, 140, 80, 40, 20] as h, k}
        <rect x={50 + k * 38} y={250 - h} width="30" height={h} class="plein" />
      {/each}
      <line x1="40" y1="250" x2="370" y2="250" class="l" />
      <line x1="196" y1="50" x2="196" y2="250" class="moy" />
      <text x="204" y="66" class="lib">moyenne</text>
    {:else if n === 4}
      <g class="sale">
        {#each [0, 1, 2, 3] as r}{#each [0, 1, 2] as c}
          <rect x={30 + c * 40 + ((r * 7 + c * 3) % 3) * 4} y={60 + r * 44} width="34" height="30" class="cell" style="transform: rotate({((r + c) % 3) - 1}deg)" />
        {/each}{/each}
        <text x="90" y="252" class="lib centre">en désordre</text>
      </g>
      <path d="M 165 150 L 230 150" class="fleche" marker-end="url(#fl)" />
      <g class="propre">
        {#each [0, 1, 2, 3] as r}{#each [0, 1, 2] as c}
          <rect x={250 + c * 40} y={60 + r * 44} width="34" height="30" class="cell ok" />
        {/each}{/each}
        <text x="310" y="252" class="lib centre">une ligne, une personne</text>
      </g>
    {:else if n === 5}
      {#each Array.from({ length: 60 }) as _, k}
        <circle cx={40 + ((k * 37) % 170)} cy={60 + ((k * 53) % 200)} r={k % 9 === 0 ? 7 : 3.5} class={k % 9 === 0 ? 'pt' : 'pale'} />
      {/each}
      <path d="M 225 160 L 265 160" class="fleche" marker-end="url(#fl)" />
      <path d="M 280 250 C 300 250, 310 100, 330 100 S 360 250, 380 250" class="l courbe" />
      <text x="330" y="280" class="lib centre">de l'échantillon à tous</text>
    {:else if n === 6}
      <circle cx="120" cy="120" r="34" class="c" /><circle cx="280" cy="120" r="34" class="c" />
      <path d="M 70 240 q 50 -70 100 0" class="l" /><path d="M 230 240 q 50 -70 100 0" class="l" />
      <path d="M 160 150 h 80" class="fleche" marker-end="url(#fl)" marker-start="url(#fl)" />
      <text x="200" y="290" class="lib centre">vous, moi, les auxiliaires</text>
    {:else if n === 7}
      {#each [[60,230],[95,205],[130,215],[160,180],[195,190],[230,150],[260,165],[295,120],[330,135],[360,95]] as [x, y]}
        <circle cx={x} cy={y} r="6" class="pt" />
      {/each}
      <line x1="45" y1="245" x2="375" y2="85" class="moy" />
      <line x1="40" y1="260" x2="380" y2="260" class="l" /><line x1="40" y1="260" x2="40" y2="60" class="l" />
    {:else if n === 8}
      <rect x="70" y="50" width="180" height="230" class="fen" />
      {#each [90, 120, 150, 180, 210] as y}<line x1="95" y1={y} x2={y === 210 ? 160 : 225} y2={y} class="ligne" />{/each}
      <circle cx="310" cy="110" r="46" class="c" /><line x1="310" y1="110" x2="310" y2="80" class="l" /><line x1="310" y1="110" x2="332" y2="118" class="l" />
      <text x="310" y="200" class="lib centre">1 h · papier</text>
      <text x="310" y="228" class="lib centre pale-t">puis atelier</text>
    {:else if n === 9}
      <circle cx="320" cy="160" r="30" class="c" /><text x="320" y="167" class="lettre">Y</text>
      <circle cx="80" cy="80" r="26" class="c" /><text x="80" y="87" class="lettre">X₁</text>
      <circle cx="80" cy="160" r="26" class="c" /><text x="80" y="167" class="lettre">X₂</text>
      <circle cx="80" cy="240" r="26" class="c" /><text x="80" y="247" class="lettre">X₃</text>
      <path d="M 108 88 L 288 150" class="fleche" marker-end="url(#fl)" /><path d="M 108 160 L 288 160" class="fleche" marker-end="url(#fl)" /><path d="M 108 232 L 288 170" class="fleche" marker-end="url(#fl)" />
    {:else if n === 10}
      <text x="110" y="120" class="code grand-code">lm()</text>
      <path d="M 60 140 q 40 30 100 0" class="l" />
      <text x="110" y="200" class="lib centre">à la main</text>
      <rect x="240" y="70" width="130" height="90" rx="8" class="fen" />
      <circle cx="285" cy="110" r="9" class="pt" /><circle cx="325" cy="110" r="9" class="pt" />
      <path d="M 280 135 q 25 18 50 0" class="l" />
      <text x="305" y="200" class="lib centre">puis avec l'IA</text>
      <text x="305" y="224" class="lib centre pale-t">et on vérifie</text>
    {:else if n === 11}
      <circle cx="90" cy="230" r="30" class="c" /><text x="90" y="237" class="lettre">X</text>
      <circle cx="310" cy="230" r="30" class="c" /><text x="310" y="237" class="lettre">Y</text>
      <circle cx="200" cy="80" r="30" class="c z" /><text x="200" y="87" class="lettre">Z</text>
      <path d="M 122 230 L 276 230" class="fleche" marker-end="url(#fl)" />
      <path d="M 180 106 L 112 200" class="fleche" marker-end="url(#fl)" /><path d="M 220 106 L 288 200" class="fleche" marker-end="url(#fl)" />
    {:else if n === 12}
      <g><circle cx="120" cy="110" r="30" class="c" /><line x1="120" y1="140" x2="120" y2="210" class="l" /><line x1="90" y1="170" x2="150" y2="170" class="l" /><line x1="120" y1="210" x2="95" y2="260" class="l" /><line x1="120" y1="210" x2="145" y2="260" class="l" /><text x="120" y="295" class="lib centre">a voté</text></g>
      <g class="fantome"><circle cx="280" cy="110" r="30" class="c" /><line x1="280" y1="140" x2="280" y2="210" class="l" /><line x1="250" y1="170" x2="310" y2="170" class="l" /><line x1="280" y1="210" x2="255" y2="260" class="l" /><line x1="280" y1="210" x2="305" y2="260" class="l" /><text x="280" y="295" class="lib centre">et si… ?</text></g>
      <line x1="200" y1="60" x2="200" y2="270" class="moy" />
    {:else if n === 13}
      <line x1="60" y1="200" x2="340" y2="200" class="l" />
      <path d="M 200 60 L 200 200" class="l" />
      <g style="transform-origin: 200px 200px; transform: rotate(-12deg)">
        <line x1="70" y1="200" x2="330" y2="200" class="moy" />
        <rect x="60" y="176" width="40" height="24" class="plein" /><rect x="300" y="176" width="40" height="24" class="plein" />
      </g>
      <text x="200" y="260" class="lib centre">ce qui penche sans qu'on le voie</text>
    {:else}
      <circle cx="200" cy="80" r="36" class="c" /><text x="200" y="90" class="lettre">P/F</text>
      <path d="M 180 120 L 110 170" class="fleche" marker-end="url(#fl)" /><path d="M 220 120 L 290 170" class="fleche" marker-end="url(#fl)" />
      {#each [0, 1, 2, 3, 4, 5] as k}
        <circle cx={70 + (k % 3) * 28} cy={200 + Math.floor(k / 3) * 28} r="9" class="pt" />
        <circle cx={250 + (k % 3) * 28} cy={200 + Math.floor(k / 3) * 28} r="9" class="pale" />
      {/each}
      <text x="98" y="270" class="lib centre">traité</text><text x="278" y="270" class="lib centre">témoin</text>
    {/if}
    <defs><marker id="fl" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0L10 5L0 10z" class="pointe" /></marker></defs>
  </svg>
</div>

<style>
  .seance { display: grid; grid-template-columns: 1.1fr 1fr; gap: 2em; align-items: center; }
  .texte { display: flex; flex-direction: column; gap: 0.3em; }
  .num { font-family: var(--dk-mono); font-size: 4.2em; line-height: 1; font-weight: 600; color: var(--dk-accent); }
  .date { font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .texte h2 { margin: 0.1em 0 0.2em; font-size: 1.6em; line-height: 1.15; }
  .quoi { margin: 0; font-size: 1.05em; line-height: 1.45; max-width: 22em; }
  .note { margin: 0.5em 0 0; font-size: 0.78em; color: var(--dk-accent); font-weight: 600; }
  .glyphe { width: 100%; height: auto; max-height: 64vh; }
  .c { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .c.z { stroke: var(--dk-accent); stroke-dasharray: 7 5; }
  .l { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linecap: round; }
  .l.courbe { stroke: var(--dk-accent); }
  .moy { stroke: var(--dk-accent); stroke-width: 5; stroke-linecap: round; }
  .fleche { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .pointe { fill: var(--dk-accent); }
  .pt { fill: var(--dk-accent); }
  .pale { fill: var(--dk-gris-2); }
  .plein { fill: var(--dk-encre); }
  .fen { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .barre { fill: var(--dk-encre); }
  .bouton { fill: var(--dk-fond); }
  .ligne { stroke: var(--dk-gris-2); stroke-width: 5; stroke-linecap: round; }
  .code { font-family: var(--dk-mono); font-size: 26px; fill: var(--dk-encre); }
  .code.sortie { fill: var(--dk-accent); }
  .grand-code { font-size: 54px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .curseur { animation: clignote 1s steps(1) infinite; }
  @keyframes clignote { 50% { opacity: 0; } }
  .grand { font-family: var(--dk-mono); font-size: 150px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .lettre { font-family: var(--dk-mono); font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .lib { font-family: var(--dk-mono); font-size: 16px; fill: var(--dk-gris); }
  .lib.centre { text-anchor: middle; }
  .pale-t { fill: var(--dk-gris-2); }
  .cell { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-width: 3; transform-box: fill-box; transform-origin: center; }
  .cell.ok { stroke: var(--dk-encre); fill: var(--dk-fond-2); }
  .fantome { opacity: 0.35; }
  .fantome .c, .fantome .l { stroke-dasharray: 6 5; }
</style>
