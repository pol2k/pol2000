<script>
  // Une seule famille sur tout le site et dans les decks: IBM Plex Mono.
  import '@fontsource/ibm-plex-mono/400.css';
  import '@fontsource/ibm-plex-mono/500.css';
  import '@fontsource/ibm-plex-mono/600.css';
  import '@fontsource/ibm-plex-mono/400-italic.css';
  import '$lib/styles/tokens.css';
  import '$lib/styles/base.css';

  let { children } = $props();
</script>

{@render children()}
