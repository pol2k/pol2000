<script>
  /**
   * Installer une fois, charger à chaque fois. L'image : acheter l'outil,
   * puis le sortir du tiroir. Les deux commandes sont copiables ; c'est
   * précisément là qu'une faute de frappe coûte une demi-heure.
   */
  import Picto from '../Picto.svelte';
  import Copier from '../Copier.svelte';
</script>

<div class="visuel packages">
  <div class="etape">
    <span class="pic"><Picto nom="boite" taille="3em" /></span>
    <span class="et">UNE FOIS</span>
    <strong>Installer</strong>
    <div class="cmd"><code>install.packages("tidyverse")</code><span class="btn"><Copier texte={'install.packages("tidyverse")'} /></span></div>
  </div>
  <div class="fl">puis</div>
  <div class="etape">
    <span class="pic"><Picto nom="prise" taille="3em" /></span>
    <span class="et">CHAQUE SESSION</span>
    <strong>Charger</strong>
    <div class="cmd"><code>library(tidyverse)</code><span class="btn"><Copier texte={'library(tidyverse)'} /></span></div>
  </div>
</div>

<style>
  .packages { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.2em; align-items: stretch; }
  .etape { border: 2px solid var(--dk-encre); padding: 1.1em 1.1em 1em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; }
  .etape:last-child { border: 3px solid var(--dk-accent); }
  .pic { color: var(--dk-accent); margin-bottom: 0.2em; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .etape strong { font-size: 1.5em; }
  .cmd { position: relative; margin: 0.4em 0 0.5em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.5em 5em 0.5em 0.9em; width: 100%; box-sizing: border-box; text-align: left; }
  .cmd code { background: none; padding: 0; font-size: 1em; }
  .btn { position: absolute; top: 0.4em; right: 0.4em; line-height: 1; }
  .fl { align-self: center; font-size: 1em; color: var(--dk-accent); font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; }
</style>
