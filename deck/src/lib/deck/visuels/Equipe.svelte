<script>
  /**
   * L'équipe du cours et le canal qui la relie. Un seul mot par personne:
   * son rôle. Les noms viennent de l'enseignant.
   */
</script>

<svg viewBox="0 0 1080 330" class="visuel equipe" role="img" aria-label="L'enseignant, deux auxiliaires et un tuteur, tous reliés par Slack.">
  <!-- le canal -->
  <rect x="330" y="120" width="300" height="70" class="canal" />
  <text x="480" y="152" class="canal-t">SLACK</text>
  <text x="480" y="176" class="canal-s">le canal du cours</text>

  <!-- l'enseignant -->
  <g transform="translate(120 155)">
    <circle r="46" class="p prof" />
    <text y="-58" class="role">ENSEIGNANT</text>
    <text y="76" class="nom">Laurence-Olivier</text>
    <text y="98" class="nom">M. Foisy</text>
  </g>
  <line x1="170" y1="155" x2="326" y2="155" class="lien" />

  <!-- auxiliaires + tuteur -->
  <g transform="translate(760 60)">
    <circle r="34" class="p" />
    <text x="48" y="-4" class="role g">AUXILIAIRE</text>
    <text x="48" y="18" class="nom g">Jules Piral</text>
  </g>
  <g transform="translate(760 165)">
    <circle r="34" class="p" />
    <text x="48" y="-4" class="role g">AUXILIAIRE</text>
    <text x="48" y="18" class="nom g">Marc-Antoine Dupuis</text>
  </g>
  <g transform="translate(760 270)">
    <circle r="34" class="p tut" />
    <text x="48" y="-4" class="role g">TUTEUR</text>
    <text x="48" y="18" class="nom g">Adam Ménard</text>
  </g>
  <line x1="634" y1="140" x2="722" y2="70" class="lien" />
  <line x1="634" y1="160" x2="722" y2="165" class="lien" />
  <line x1="634" y1="180" x2="722" y2="260" class="lien" />

  <!-- vous -->
  <g transform="translate(480 268)">
    <text class="vous">VOUS</text>
  </g>
  <line x1="480" y1="194" x2="480" y2="240" class="lien" />
</svg>

<style>
  .equipe { width: 100%; height: auto; max-height: 58vh; display: block; }
  .canal { fill: var(--dk-accent); }
  .canal-t { font-family: var(--dk-mono); font-size: 26px; font-weight: 600; letter-spacing: 0.2em; text-anchor: middle; fill: var(--dk-fond); }
  .canal-s { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-fond); opacity: 0.9; }
  .p { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .p.prof { stroke-width: 6; }
  .p.tut { stroke-dasharray: 7 5; }
  .role { font-family: var(--dk-mono); font-size: 15px; letter-spacing: 0.16em; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .nom { font-family: var(--dk-mono); font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .role.g, .nom.g { text-anchor: start; }
  .lien { stroke: var(--dk-encre); stroke-width: 3; }
  .vous { font-family: var(--dk-mono); font-size: 30px; font-weight: 600; letter-spacing: 0.2em; text-anchor: middle; fill: var(--dk-encre); }
</style>
