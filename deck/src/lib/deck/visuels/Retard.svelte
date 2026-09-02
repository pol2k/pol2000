<script>
  /**
   * Ce qu'il reste d'une note selon le jour de remise: 100, 90, 80, 70, 0.
   * La politique du plan de cours, dessinée plutôt qu'énoncée.
   */
  const J = [
    ['à temps', 100], ['+1 jour', 90], ['+2 jours', 80], ['+3 jours', 70], ['+4 jours', 0]
  ];
</script>

<div class="retard" role="img" aria-label="Note conservée selon le retard: 100, 90, 80, 70 pour cent, puis zéro.">
  {#each J as [l, v], i}
    <div class="col">
      <div class="colonne"><div class="plein" class:zero={v === 0} style="height: {v}%"></div></div>
      <strong class:zero={v === 0}>{v === 0 ? '0' : v + ' %'}</strong>
      <span>{l}</span>
    </div>
  {/each}
</div>

<style>
  .retard { display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.8em; align-items: end; }
  .col { display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  .colonne { width: 100%; height: 9em; display: flex; align-items: flex-end; border-bottom: 3px solid var(--dk-encre); }
  .plein { width: 100%; background: var(--dk-encre); }
  .plein.zero { height: 4px !important; background: var(--dk-accent); }
  .col strong { font-family: var(--dk-mono); font-size: 1.3em; }
  .col strong.zero { color: var(--dk-accent); }
  .col span { font-size: 0.7em; color: var(--dk-gris); }
</style>
