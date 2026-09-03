<script>
  /**
   * Deux rangées de cas. En haut, la valeur change d'un cas à l'autre: une
   * variable. En bas, elle est la même partout: une constante — il n'y a rien
   * à expliquer.
   */
  const H = [40, 72, 22, 58, 90, 35, 66, 48, 80, 28, 60, 44];
</script>

<div class="visuel varie" role="img" aria-label="Une rangée de barres de hauteurs différentes: une variable. Une rangée de barres identiques: une constante.">
  <div class="rangee">
    <span class="et acc">VARIABLE</span>
    <div class="cas">{#each H as h}<i style="height: {h}%"></i>{/each}</div>
    <span class="ex">la province, dans un sondage pancanadien</span>
  </div>
  <div class="rangee">
    <span class="et">CONSTANTE</span>
    <div class="cas plat">{#each H as _}<i style="height: 55%"></i>{/each}</div>
    <span class="ex">« inscrit.e à Laval », dans un sondage mené à Laval</span>
  </div>
</div>

<style>
  .varie { display: flex; flex-direction: column; gap: 1.2em; }
  .rangee { display: grid; grid-template-columns: 7em 1fr; grid-template-rows: auto auto; column-gap: 1em; align-items: end; }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); grid-row: 1 / 3; align-self: center; }
  .et.acc { color: var(--dk-accent); }
  .cas { display: flex; gap: 0.5em; height: 5em; align-items: flex-end; border-bottom: 3px solid var(--dk-encre); }
  .cas i { flex: 1; background: var(--dk-encre); }
  .cas.plat i { background: var(--dk-gris-2); }
  .ex { font-size: 0.7em; color: var(--dk-gris); margin-top: 0.3em; }
</style>
