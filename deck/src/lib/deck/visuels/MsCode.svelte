<script>
  /**
   * Un bloc de code R pour les diapos modelsummary : papier grisé, filet
   * d'encre, règle rouge à gauche (comme Console.svelte), coloré par
   * surlignerR. Les lignes nouvelles (prop `nouveau`, leurs numéros à partir
   * de 0) passent au rouge, gras, avec une marque dans la marge : on voit
   * ce que le clic a ajouté. Le bouton « copier » donne tout le bloc.
   *
   * Composant muet : il ne compte pas les clics, la diapo le fait.
   *
   *   code     — le code, tel quel (src/lib/data/seance7_ms.js)
   *   nouveau  — numéros des lignes à mettre en évidence
   *   etiquette — petit titre au-dessus, facultatif
   */
  import { surlignerR } from '../surligner.js';
  import Copier from '../Copier.svelte';
  let { code = '', nouveau = [], etiquette = '' } = $props();
  const lignes = $derived(code.split('\n'));
</script>

<div class="ms-code">
  {#if etiquette}<p class="mc-etiq">{etiquette}</p>{/if}
  <div class="mc-corps">
    <Copier texte={code} />
    {#each lignes as l, i}
      <pre class="mc-l" class:mc-neuf={nouveau.includes(i)}>{@html surlignerR(l) || ' '}</pre>
    {/each}
  </div>
</div>

<style>
  .ms-code { display: flex; flex-direction: column; gap: 0.3em; min-width: 0; }
  .mc-etiq { margin: 0; font-size: 0.6em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .mc-corps { position: relative; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.34em solid var(--dk-accent); padding: 0.55em 2.6em 0.6em 0.9em; }
  .mc-corps :global(.copier) { position: absolute; top: 0.5em; right: 0.5em; }
  .mc-l { position: relative; margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.45; white-space: pre; color: var(--dk-encre); transition: color 0.3s; }
  /* La ligne ajoutée : une marque rouge dans la marge, le texte en gras. */
  .mc-neuf { font-weight: 700; }
  .mc-neuf::before { content: ''; position: absolute; left: -0.62em; top: 0.2em; bottom: 0.2em; width: 0.22em; background: var(--dk-accent); animation: mc-entre 0.4s both; }
  @keyframes mc-entre { from { transform: scaleY(0); } to { transform: none; } }
  @media (prefers-reduced-motion: reduce) { .mc-neuf::before { animation: none; } }
</style>
