<script>
  /**
   * Le tableau 1 de Blais et Gélineau (2007, p. 431), recopié et traduit :
   * la satisfaction envers la démocratie (de 0 à 1), avant et après
   * l'élection de 1997, chez les mêmes personnes (CES 1997).
   *
   *   0  le tableau entier;
   *   1  avant : les futurs gagnants sont déjà plus satisfaits;
   *   2  la différence : tout le monde monte après l'élection.
   *
   * Les chiffres viennent de BG (src/lib/data/seance8.js), recopiés de
   * l'article dans outils/seance8_data.R.
   */
  import { brancherTemps } from '../temps.js';
  import { BG } from '$lib/data/seance8.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const T = BG.tableau1;
  const f = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const DITS = ['', 'Avant même l’élection, les futurs gagnants sont plus satisfaits.', 'Après l’élection, tout le monde est plus satisfait. Une « lune de miel » pour la démocratie.'];
</script>

<div class="visuel m8gl" bind:this={hote}>
  <table class:e1={e === 1} class:e2={e >= 2}>
    <thead><tr><th></th>{#each T as g}<th class:cle={g.cle === 'gagnant' || g.cle === 'perdant'}>{g.groupe}</th>{/each}</tr></thead>
    <tbody>
      <tr class="avant"><td>Avant</td>{#each T as g}<td class:g={g.cle === 'gagnant'} class:p={g.cle === 'perdant'}>{f(g.avant)}</td>{/each}</tr>
      <tr class="apres"><td>Après</td>{#each T as g}<td>{f(g.apres)}</td>{/each}</tr>
      <tr class="diff"><td>Différence</td>{#each T as g}<td>{g.diff}</td>{/each}</tr>
      <tr class="n"><td>N</td>{#each T as g}<td>{g.n}</td>{/each}</tr>
    </tbody>
  </table>
  <p class="source">Blais et Gélineau (2007), tableau 1, p. 431 · CES 1997 · satisfaction de 0 (pas du tout) à 1 (très satisfait)</p>
  <div class="dits">
    {#each DITS as d, i}{#if i}<p class="dit" class:vu={e === i}>{d}</p>{/if}{/each}
  </div>
</div>

<style>
  .m8gl { max-width: 66em; margin: 0.4em auto 0; display: flex; flex-direction: column; gap: 0.8em; }
  table { border-collapse: collapse; width: 100%; font-size: 0.95em; table-layout: fixed; }
  th { font-size: 0.68em; font-weight: 600; color: var(--dk-gris); text-align: right; vertical-align: bottom; padding: 0.3em 0.5em; border-bottom: 2px solid var(--dk-encre); line-height: 1.3; }
  th:first-child { width: 8em; }
  th.cle { color: var(--dk-encre); }
  td { text-align: right; padding: 0.4em 0.5em; border-bottom: 1px solid var(--dk-filet); font-variant-numeric: tabular-nums; transition: color 0.3s, background 0.3s; }
  td:first-child { text-align: left; font-weight: 600; }
  .n td { color: var(--dk-gris); font-size: 0.85em; border-bottom: none; }
  .e1 .avant td.g, .e1 .avant td.p { color: var(--dk-accent); font-weight: 700; background: var(--dk-fond-2); }
  .e1 .avant { outline: 3px solid var(--dk-accent); }
  .e2 .diff td:not(:first-child) { color: var(--dk-accent); font-weight: 700; }
  .e2 .diff { outline: 3px solid var(--dk-accent); }
  .source { margin: 0; color: var(--dk-gris); font-size: 0.72em; }
  .dits { display: grid; }
  .dit { grid-area: 1 / 1; margin: 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.15em; opacity: 0; transition: opacity 0.4s; }
  .dit.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { td, .dit { transition: none; } }
</style>
