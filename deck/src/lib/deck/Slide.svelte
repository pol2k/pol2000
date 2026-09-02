<script>
  // d = facteur d'échelle propre à la diapo, mesuré par outils/ajuster.mjs.
  // bandeau / droite = repères de section, toujours au même endroit.
  let { fond = 'papier', d = 1, bandeau = '', droite = '', children } = $props();
</script>

<section class="diapo {fond === 'encre' ? 'encre' : ''} {fond === 'terminal' ? 'terminal' : ''}" style={d === 1 ? undefined : `--d: ${d}`}>
  <div class="diapo-bandeau">
    <span>{bandeau}</span>
    <span class="droite">{droite}</span>
  </div>
  <div class="diapo-in">{@render children()}</div>
</section>
