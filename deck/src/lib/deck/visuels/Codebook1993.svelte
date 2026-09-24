<script>
  /**
   * Des codes illisibles : un extrait brut de l'Étude électorale canadienne
   * de 1993, tel que le montrait le cours 4 de FAS1001, et ce que le
   * codebook dit de la colonne CPSG1. Trois temps.
   *
   *   0  Le tableau seul : des noms et des chiffres sans sens.
   *   1  La colonne CPSG1 s'allume.
   *   2  La légende du codebook arrive : 1, 3, 5, 7 ont un sens; les 7
   *      de la colonne passent au rouge avec « très opposé ».
   *
   * Tableau grand et gras, lisible du fond de la salle : la page du codebook
   * elle-même est montrée sur la diapo d'avant (le PDF) et celle d'après
   * (l'entrée cpsg1). Le tableau vient de la diapo de FAS1001 (fichier
   * CES-E-1993_F1, questions de la campagne); les sens viennent du codebook
   * de 1993, p. 37. Rien n'est inventé.
   */
  import { brancherTemps } from '../temps.js';

  const COLS = ['CPSIGEN', 'CPSA3', 'CPSG1', 'CPSO11', 'CPSA2'];
  const ROWS = [[5, 1, 7, 1, 1], [5, 2, 5, 1, 1], [5, 99, 7, 1, 1], [1, 2, 7, 1, 1], [5, 1, 3, 1, 1], [1, 2, 5, 1, 1]];
  const SENS = [[1, 'très favorable'], [3, 'plutôt favorable'], [5, 'plutôt opposé'], [7, 'très opposé']];
  const G = 2; // la colonne CPSG1

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel cb93" bind:this={hote}>
  <table>
    <thead><tr>{#each COLS as c, j}<th class:g={j === G && e >= 1}>{c}</th>{/each}</tr></thead>
    <tbody>
      {#each ROWS as r}
        <tr>
          {#each r as v, j}
            <td class:g={j === G && e >= 1} class:sept={j === G && v === 7 && e >= 2}>{v}</td>
          {/each}
        </tr>
      {/each}
    </tbody>
  </table>

  <div class="droite">
    {#if e < 2}
      <p class="question">Que veut dire 7&#8239;?</p>
    {:else}
      <div class="legende">
        <span class="et">CPSG1 · LA TPS · CODEBOOK</span>
        <ul>
          {#each SENS as [c, s], i}
            <li class:sept={c === 7} style="--i: {i}"><b>{c}</b><span>{s}</span></li>
          {/each}
        </ul>
      </div>
    {/if}
  </div>

  <p class="source">Étude électorale canadienne 1993 · données brutes et codebook</p>
</div>

<style>
  .cb93 { display: grid; grid-template-columns: auto 1fr; gap: 0.6em 1.6em; align-items: center; }
  table { border-collapse: collapse; border: 3px solid var(--dk-encre); font-size: 1.75em; font-weight: 600; background: #fff; }
  th { padding: 0.4em 0.55em; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.5em; letter-spacing: 0.04em; transition: background 0.3s; }
  th.g { background: var(--dk-accent); }
  td { padding: 0.08em 0.5em; line-height: 1.25; border-bottom: 2px solid var(--dk-filet); text-align: center; font-variant-numeric: tabular-nums; transition: background 0.3s, color 0.3s; }
  tbody tr:last-child td { border-bottom: 0; }
  td.g { background: color-mix(in srgb, var(--dk-accent) 12%, #fff); color: var(--dk-accent); }
  td.sept { background: var(--dk-accent); color: #fff; }
  .droite { min-width: 0; }
  .question { margin: 0; font-size: 1.8em; font-weight: 600; color: var(--dk-accent); animation: fondu 0.4s both; }
  .legende { display: flex; flex-direction: column; gap: 0.5em; }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .legende ul { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.25em; border-top: 2px solid var(--dk-encre); }
  .legende li { display: grid; grid-template-columns: 1.3em 1fr; gap: 0.5em; align-items: baseline; font-size: 1.3em; line-height: 1.3; padding: 0.12em 0.3em; border-bottom: 2px solid var(--dk-filet); animation: fondu 0.4s both; animation-delay: calc(var(--i) * 0.12s); }
  .legende b { font-weight: 600; font-variant-numeric: tabular-nums; }
  .legende li.sept { background: var(--dk-accent); color: var(--dk-fond); font-weight: 600; border-bottom-color: var(--dk-accent); }
  .source { grid-column: 1 / -1; justify-self: end; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .question, .legende li { animation: none; } }
</style>
