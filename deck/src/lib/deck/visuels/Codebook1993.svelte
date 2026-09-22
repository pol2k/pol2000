<script>
  /**
   * Des codes illisibles : un extrait brut de l'Étude électorale canadienne
   * de 1993, tel que le montrait le cours 4 de FAS1001, et la page du
   * codebook qui le déchiffre. Trois temps.
   *
   *   0  Le tableau seul : des noms et des chiffres sans sens.
   *   1  La colonne CPSG1 s'allume ; la page du codebook arrive à côté.
   *   2  Chaque 7 de la colonne reçoit son sens : « très opposé ».
   *
   * Le tableau et la page viennent de la diapo de FAS1001 (fichier
   * CES-E-1993_F1, questions de la campagne); rien n'est inventé.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  const COLS = ['CPSIGEN', 'CPSA3', 'CPSG1', 'CPSO11', 'CPSA2'];
  const ROWS = [[5, 1, 7, 1, 1], [5, 2, 5, 1, 1], [5, 99, 7, 1, 1], [1, 2, 7, 1, 1], [5, 1, 3, 1, 1], [1, 2, 5, 1, 1]];
  const SENS = { 1: 'très favorable', 3: 'plutôt favorable', 5: 'plutôt opposé', 7: 'très opposé' };
  const G = 2; // la colonne CPSG1

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel cb93" class:ouvert={e >= 1} bind:this={hote}>
  <div class="gauche">
    <table>
      <thead><tr>{#each COLS as c, j}<th class:g={j === G && e >= 1}>{c}</th>{/each}</tr></thead>
      <tbody>
        {#each ROWS as r}
          <tr>
            {#each r as v, j}
              <td class:g={j === G && e >= 1} class:sept={j === G && v === 7 && e >= 2}>
                <span>{v}</span>
                {#if j === G && e >= 2}<em>{SENS[v]}</em>{/if}
              </td>
            {/each}
          </tr>
        {/each}
      </tbody>
    </table>
    {#if e === 0}<p class="question">Que veut dire 7 ?</p>{/if}
  </div>

  {#if e >= 1}
    <figure class="page">
      <img src="{base}/img/codebook-ces1993.png" alt="Page du codebook de l'Étude électorale canadienne de 1993, question cpsg1 sur la TPS : 1 très favorable, 3 plutôt favorable, 5 plutôt opposé, 7 très opposé, 8 ne sait pas, 9 refus." />
    </figure>
  {/if}

  <p class="source">Étude électorale canadienne 1993 · données brutes et codebook</p>
</div>

<style>
  .cb93 { display: grid; grid-template-columns: 1fr; gap: 0.5em 1.6em; align-items: center; justify-items: center; }
  .cb93.ouvert { grid-template-columns: 1.05fr 1fr; justify-items: stretch; }
  .gauche { display: flex; flex-direction: column; gap: 0.8em; align-items: flex-start; }
  table { border-collapse: collapse; border: 3px solid var(--dk-encre); font-size: 1.05em; }
  th { padding: 0.4em 0.7em; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.72em; letter-spacing: 0.05em; transition: background 0.3s; }
  th.g { background: var(--dk-accent); }
  td { padding: 0.35em 0.7em; border-bottom: 1px solid var(--dk-filet); text-align: center; font-variant-numeric: tabular-nums; transition: background 0.3s; white-space: nowrap; }
  td.g { background: var(--dk-fond-2); box-shadow: inset 3px 0 0 var(--dk-accent), inset -3px 0 0 var(--dk-accent); font-weight: 600; }
  td.sept span { color: var(--dk-accent); }
  td em { display: block; font-style: normal; font-size: 0.5em; font-weight: 600; letter-spacing: 0.04em; color: var(--dk-gris); animation: fondu 0.4s both; }
  td.sept em { color: var(--dk-accent); }
  .question { margin: 0; font-size: 1.5em; font-weight: 600; color: var(--dk-accent); animation: fondu 0.4s both; }
  .page { margin: 0; animation: fondu 0.5s both; }
  .page img { display: block; width: 100%; max-height: 56vh; object-fit: contain; object-position: left top; border: 3px solid var(--dk-encre); background: #fff; }
  .source { grid-column: 1 / -1; justify-self: end; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .page, td em, .question { animation: none; } }
</style>
