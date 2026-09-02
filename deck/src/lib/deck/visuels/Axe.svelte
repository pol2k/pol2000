<script>
  /**
   * L'axe gauche-droite de 0 à 10, et une personne diplômée dont on ne sait
   * pas où elle tombe. Deux forces tirent en sens contraire; une troisième
   * variable rôde. Rien n'est mesuré ici: la position est un point
   * d'interrogation, volontairement.
   */
</script>

<svg viewBox="0 0 960 360" class="axe" role="img" aria-label="Un axe gauche-droite de 0 à 10; une personne diplômée placée sur un point d'interrogation, tirée vers la gauche par les idées et vers la droite par le revenu; l'âge en embuscade.">
  <!-- axe -->
  <line x1="80" y1="250" x2="880" y2="250" class="trait" />
  {#each Array.from({ length: 11 }) as _, i}
    <line x1={80 + i * 80} y1="240" x2={80 + i * 80} y2="260" class="trait" />
    <text x={80 + i * 80} y="290" class="tick">{i}</text>
  {/each}
  <text x="80" y="330" class="pole">GAUCHE</text>
  <text x="880" y="330" class="pole fin">DROITE</text>

  <!-- la personne -->
  <g transform="translate(480 158)">
    <circle cx="0" cy="-58" r="22" class="tete" />
    <path d="M -30 -36 H 30 L 24 -44 H -24 Z" class="toque" />
    <line x1="0" y1="-36" x2="0" y2="30" class="corps" />
    <line x1="-34" y1="-10" x2="34" y2="-10" class="corps" />
    <line x1="0" y1="30" x2="-24" y2="80" class="corps" />
    <line x1="0" y1="30" x2="24" y2="80" class="corps" />
    <text x="62" y="-4" class="q">?</text>
  </g>

  <!-- forces -->
  <g class="force">
    <line x1="430" y1="60" x2="250" y2="60" marker-end="url(#fl)" />
    <text x="340" y="42" class="et">LES IDÉES</text>
  </g>
  <g class="force">
    <line x1="530" y1="60" x2="710" y2="60" marker-end="url(#fl)" />
    <text x="620" y="42" class="et">LE REVENU</text>
  </g>

  <!-- l'âge -->
  <g class="age">
    <rect x="720" y="120" width="170" height="50" />
    <text x="805" y="152" class="et">ET L'ÂGE ?</text>
  </g>

  <defs>
    <marker id="fl" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M 0 0 L 10 5 L 0 10 z" class="pointe" />
    </marker>
  </defs>
</svg>

<style>
  .axe { width: 100%; height: auto; max-height: 62vh; display: block; }
  .trait { stroke: var(--dk-encre); stroke-width: 3; }
  .tick { font-family: var(--dk-mono); font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }
  .pole { font-family: var(--dk-mono); font-size: 20px; letter-spacing: 0.16em; fill: var(--dk-encre); font-weight: 600; }
  .pole.fin { text-anchor: end; }
  .tete { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .toque { fill: var(--dk-encre); }
  .corps { stroke: var(--dk-encre); stroke-width: 4; stroke-linecap: round; }
  .q { font-family: var(--dk-mono); font-size: 64px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .force line { stroke: var(--dk-accent); stroke-width: 4; }
  .pointe { fill: var(--dk-accent); }
  .et { font-family: var(--dk-mono); font-size: 18px; letter-spacing: 0.16em; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .age rect { fill: none; stroke: var(--dk-gris); stroke-width: 3; stroke-dasharray: 8 6; }
  .age .et { fill: var(--dk-gris); }
</style>
