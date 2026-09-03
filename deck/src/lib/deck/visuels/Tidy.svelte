<script>
  /**
   * Les données bien rangées (tidy): lignes = observations, colonnes =
   * variables, cellules = valeurs, et le tout = l'objet d'étude. Quatre temps,
   * chacun allume une partie de la même table. Les lignes sont les vraies
   * premières lignes de l'Étude électorale canadienne 2025.
   */
  import { brancherTemps } from '../temps.js';
  const COLS = ['âge', 'scolarité', 'revenu', 'intention de vote'];
  const ROWS = [[69, 9, 6, 2], [61, 9, 6, 3], [54, 11, 6, 1], [28, 9, 4, 2], [63, 8, 3, 1]];
  const LEG = [
    ['UN JEU DE DONNÉES', "Toujours la même forme. C'est ce qu'on veut, chaque fois."],
    ['LES LIGNES', 'Une ligne, une observation. Ici, une personne sondée.'],
    ['LES COLONNES', 'Une colonne, une variable. Ce qu\'on a mesuré chez chacune.'],
    ['LES CELLULES', 'Une cellule, une valeur. Une seule.'],
    ["L'OBJET D'ÉTUDE", 'Le jeu de données entier. C\'est lui qu\'on décrit, qu\'on relie, qu\'on interroge.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tidy" bind:this={hote}>
  <div class="scene" class:l={e === 1} class:c={e === 2} class:v={e === 3} class:t={e === 4}>
    <div class="etq-l">observations</div>
    <div class="etq-c">variables</div>
    <table>
      <thead><tr><th class="n"></th>{#each COLS as c}<th>{c}</th>{/each}</tr></thead>
      <tbody>
        {#each ROWS as r, i}
          <tr><td class="n">{i + 1}</td>{#each r as v}<td><span>{v}</span></td>{/each}</tr>
        {/each}
        <tr class="suite"><td class="n">…</td><td colspan="4">20 180 lignes</td></tr>
      </tbody>
    </table>
  </div>
  {#key e}
  <div class="legende">
    <span class="et">{LEG[e][0]}</span>
    <p>{LEG[e][1]}</p>
  </div>
  {/key}
</div>

<style>
  .tidy { display: grid; grid-template-columns: 1.4fr 1fr; gap: 2em; align-items: center; }
  .scene { position: relative; padding: 1.6em 0 0 5.4em; }
  .etq-l { position: absolute; left: 0; top: 50%; transform: rotate(-90deg) translate(-50%, 0); transform-origin: left top; font-size: 0.62em; letter-spacing: 0.18em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris-2); transition: color 0.3s; }
  .etq-c { position: absolute; left: 5.4em; top: 0; font-size: 0.62em; letter-spacing: 0.18em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris-2); transition: color 0.3s; }
  .l .etq-l, .c .etq-c { color: var(--dk-accent); }
  table { width: 100%; border-collapse: collapse; font-size: 1em; border: 3px solid var(--dk-encre); transition: box-shadow 0.4s; }
  .t table { box-shadow: 0 0 0 6px var(--dk-accent); }
  th { text-align: left; padding: 0.45em 0.8em; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.78em; letter-spacing: 0.06em; transition: background 0.3s, color 0.3s; }
  .c th:not(.n) { background: var(--dk-accent); }
  td { padding: 0.5em 0.8em; border-bottom: 1px solid var(--dk-filet); font-variant-numeric: tabular-nums; transition: background 0.3s; }
  .n { width: 2.4em; color: var(--dk-gris-2); text-align: right; }
  .l tbody tr:not(.suite) td { background: var(--dk-accent-clair); }
  .l tbody tr:nth-child(odd):not(.suite) td { background: #ffd54a; }
  .c tbody td:not(.n) { box-shadow: inset 3px 0 0 var(--dk-accent); }
  td span { display: inline-block; padding: 0.1em 0.35em; transition: outline 0.3s; }
  .v td span { outline: 2px solid var(--dk-accent); }
  .suite td { color: var(--dk-gris); border-bottom: 0; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.35em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
