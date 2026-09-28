<script>
  /**
   * Aujourd'hui, séance 5 : la séance sur une ligne, de gauche à droite, en
   * cinq stations. Chacune porte un petit pictogramme dessiné ici, sans autre
   * texte que son nom.
   *
   *   l'inférence          quelques carrés dans un grand champ en pointillé
   *                        (un échantillon dans sa population);
   *   le test d'hypothèse  une courbe en cloche dont une queue est ombrée;
   *   la pause             un trou dans la ligne;
   *   ggplot2              trois couches plates empilées;
   *   en direct dans R     le chevron « > » d'une console.
   *
   * Pas de clic. À l'arrivée, la ligne se trace et les stations apparaissent
   * l'une après l'autre, de gauche à droite. Aucun nombre : rien à sourcer.
   */
  const YR = 185; // la ligne
  const YP = 100; // le centre des pictogrammes

  // La cloche : une courbe normale dessinée sur 120 unités de large.
  const cloche = (x) => 38 - 76 * Math.exp(-0.5 * (x / 20) ** 2);
  const XS = Array.from({ length: 41 }, (_, i) => -60 + i * 3);
  const COURBE = 'M ' + XS.map((x) => `${x} ${cloche(x).toFixed(1)}`).join(' L ');
  const QUEUE = 'M 27 38 ' + XS.filter((x) => x >= 27).map((x) => `L ${x} ${cloche(x).toFixed(1)}`).join(' ') + ' L 60 38 Z';

  // L'échantillon dans le champ : des positions fixes.
  const PETITS = [[-42, -28], [-14, -20], [18, -32], [30, 2], [-30, 8], [2, 18], [-8, -4]];

  const STATIONS = [
    { x: 110, lignes: ['L’inférence'], picto: 'inf' },
    { x: 320, lignes: ['Le test', 'd’hypothèse'], picto: 'test' },
    { x: 680, lignes: ['ggplot2'], picto: 'gg' },
    { x: 890, lignes: ['En direct', 'dans R'], picto: 'r' }
  ];
  // Ordre d'apparition : la pause s'intercale entre le test et ggplot2.
  const rangDe = (i) => (i < 2 ? i : i + 1);
</script>

<div class="visuel aujourdhui5">
  <svg viewBox="0 0 1000 300" role="img" aria-label="La séance en cinq temps, de gauche à droite : l’inférence, le test d’hypothèse, la pause, ggplot2, puis en direct dans R.">
    <!-- La ligne, coupée par la pause. -->
    <path d="M 40 {YR} H 458" pathLength="1" class="aj-rail" />
    <path d="M 542 {YR} H 958" pathLength="1" class="aj-rail aj-rail-2" />
    <path d="M 944 {YR - 9} L 960 {YR} L 944 {YR + 9}" class="aj-bout" />

    <!-- La pause : un trou dans la ligne. -->
    <g class="aj-st" style="--d: 2">
      <text x="500" y={YR + 6} class="aj-pause">pause</text>
    </g>

    {#each STATIONS as s, i}
      <g class="aj-st" style="--d: {rangDe(i)}">
        <g transform="translate({s.x} {YP})">
          {#if s.picto === 'inf'}
            <rect x="-60" y="-44" width="120" height="88" class="aj-champ" />
            {#each PETITS as [px, py]}
              <rect x={px} y={py} width="13" height="13" class="aj-plein" />
            {/each}
          {:else if s.picto === 'test'}
            <path d={QUEUE} class="aj-queue" />
            <path d={COURBE} class="aj-trait" />
            <line x1="-64" y1="38" x2="64" y2="38" class="aj-trait" />
          {:else if s.picto === 'gg'}
            {#each [30, 0, -30] as dy}
              <path d="M 0 {dy - 16} L 58 {dy} L 0 {dy + 16} L -58 {dy} Z" class="aj-couche" />
            {/each}
          {:else}
            <rect x="-60" y="-42" width="120" height="84" class="aj-console" />
            <path d="M -36 -18 L -12 0 L -36 18" class="aj-chevron" />
            <rect x="0" y="10" width="26" height="8" class="aj-plein aj-curseur" />
          {/if}
        </g>
        <rect x={s.x - 8} y={YR - 8} width="16" height="16" class="aj-noeud" class:aj-premier={i === 0} />
        {#each s.lignes as l, k}
          <text x={s.x} y={233 + k * 28} class="aj-nom">{l}</text>
        {/each}
      </g>
    {/each}
  </svg>
</div>

<style>
  .aujourdhui5 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }

  .aj-rail { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; animation: aj-trace 0.6s ease-out forwards; }
  .aj-rail-2 { animation-delay: 0.45s; }
  .aj-bout { fill: none; stroke: var(--dk-encre); stroke-width: 3; opacity: 0; animation: aj-fondu 0.3s ease-out 0.95s forwards; }
  .aj-pause { font-size: 18px; text-anchor: middle; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  .aj-st { opacity: 0; animation: aj-monte 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: calc(var(--d) * 0.18s + 0.1s); }
  .aj-nom { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .aj-noeud { fill: var(--dk-encre); }
  .aj-noeud.aj-premier { fill: var(--dk-accent); }

  .aj-champ { fill: none; stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 7 5; }
  .aj-plein { fill: var(--dk-encre); }
  .aj-trait { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .aj-queue { fill: var(--dk-gris-2); }
  .aj-couche { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .aj-console { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .aj-chevron { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-linejoin: miter; }
  .aj-curseur { animation: aj-clignote 1.1s steps(1) infinite; }

  @keyframes aj-trace { to { stroke-dashoffset: 0; } }
  @keyframes aj-fondu { to { opacity: 1; } }
  @keyframes aj-monte { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: none; } }
  @keyframes aj-clignote { 50% { opacity: 0; } }

  @media (prefers-reduced-motion: reduce) {
    .aj-rail { animation: none; stroke-dashoffset: 0; }
    .aj-bout, .aj-st { animation: none; opacity: 1; }
    .aj-curseur { animation: none; }
  }
</style>
