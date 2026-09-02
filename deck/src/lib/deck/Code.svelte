<script>
  import { surlignerR } from './surligner.js';
  import Copier from './Copier.svelte';

  // brut : le bloc n'est pas du R. La coloration traiterait la prose
  // française comme du code — nombres, deux-points et tirets colorés au
  // hasard. Par défaut inchangé, donc les autres decks ne bougent pas.
  let { src, titre = '', petit = false, brut = false } = $props();
</script>

<figure class="bloc-code" class:petit>
  {#if titre}<figcaption>{titre}</figcaption>{/if}
  <div class="enveloppe">
    <pre><code>{#if brut}{src.trim()}{:else}{@html surlignerR(src.trim())}{/if}</code></pre>
    <Copier texte={src} />
  </div>
</figure>
