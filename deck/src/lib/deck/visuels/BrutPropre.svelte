<script>
  /**
   * Les mêmes six personnes, avant et après le ménage. BRUT et PROPRE
   * (outils/seance4_data.R) : les trois premières lignes de l'Étude, puis la
   * première qui répond -99 à l'échelle gauche-droite, la première « ne sait
   * pas » à la satisfaction, la première sans intention de vote. Les deux
   * tableaux s'empilent, pleine largeur; leurs colonnes se répondent une à
   * une. Les valeurs s'écrivent comme R les imprime (0.67, NA). Trois temps.
   *
   *   0  Le brut : des noms de code, des codes, des -99.
   *   1  Le propre apparaît dessous : des noms clairs, des mots, des NA.
   *   2  Les trous s'allument des deux côtés : ce qui devient NA.
   */
  import { brancherTemps } from '../temps.js';
  import { BRUT, PROPRE } from '$lib/data/seance4.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les noms longs ne se coupent qu'après un « _ ».
  const morceaux = (c) => c.split(/(?<=_)/);
  const texte = (v) => (v === null ? 'NA' : String(v));
  // Une case devient un trou si la même case du propre est NA.
  const trou = (i, j) => PROPRE.rows[i][j] === null;
</script>

<div class="visuel brut-propre" bind:this={hote}>
  <code class="nom">df_raw</code>
  <table>
    <thead><tr>{#each BRUT.cols as c}<th>{#each morceaux(c) as m, k}{#if k}<wbr />{/if}{m}{/each}</th>{/each}</tr></thead>
    <tbody>
      {#each BRUT.rows as r, i}
        <tr>{#each r as v, j}<td class:neg={v === -99} class:na={v === null} class:trou={e >= 2 && trou(i, j)}>{texte(v)}</td>{/each}</tr>
      {/each}
    </tbody>
  </table>

  <code class="nom rouge" class:cache={e < 1}>df_clean</code>
  <table class:cache={e < 1}>
    <thead><tr>{#each PROPRE.cols as c}<th>{#each morceaux(c) as m, k}{#if k}<wbr />{/if}{m}{/each}</th>{/each}</tr></thead>
    <tbody>
      {#each PROPRE.rows as r}
        <tr>{#each r as v}<td class:na={v === null} class:trou={e >= 2 && v === null}>{texte(v)}</td>{/each}</tr>
      {/each}
    </tbody>
  </table>

  <p class="source">Six vraies personnes de l’Étude électorale canadienne 2025</p>
</div>

<style>
  .brut-propre { display: grid; grid-template-columns: auto 1fr; gap: 0.35em 0.8em; align-items: start; width: 100%; }
  .nom { font-family: var(--dk-mono); font-size: 0.9em; font-weight: 600; padding-top: 0.25em; text-align: right; transition: opacity 0.4s; }
  .nom.rouge { color: var(--dk-accent); }
  .cache { visibility: hidden; opacity: 0; }
  table { width: 100%; border-collapse: collapse; border: 3px solid var(--dk-encre); font-size: 0.85em; transition: opacity 0.4s; }
  table + .nom { margin-top: 0.3em; }
  .brut-propre th { text-align: left; vertical-align: bottom; padding: 0.15em 0.5em; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.9em; line-height: 1.2; text-transform: none; letter-spacing: 0; }
  td { padding: 0.12em 0.5em; border-bottom: 1px solid var(--dk-filet); font-variant-numeric: tabular-nums; white-space: nowrap; line-height: 1.3; transition: background 0.3s, color 0.3s; }
  td.neg { color: var(--dk-accent); font-weight: 600; }
  td.na { color: var(--dk-gris-2); }
  td.trou { background: var(--dk-accent); color: var(--dk-fond); font-weight: 600; }
  .source { grid-column: 1 / -1; margin: 0.1em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @media (prefers-reduced-motion: reduce) { .nom, table, td { transition: none; } }
</style>
