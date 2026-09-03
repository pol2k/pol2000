<script>
  /**
   * L'unité d'analyse, montrée plutôt que dite: une table dont on voit les
   * lignes. À chaque clic, l'unité change — et la table entière change avec
   * elle: ce qu'est une ligne, ce que sont les colonnes. Les valeurs sont
   * illustratives (formes et échelles plausibles), pas des mesures.
   */
  import { brancherTemps } from '../temps.js';
  const TABLES = [
    { unite: 'une personne', ex: 'un sondage', cols: ['répondant.e', 'âge', 'scolarité', 'a voté'],
      rows: [['#001', '34', 'universitaire', 'oui'], ['#002', '61', 'collégial', 'oui'], ['#003', '22', 'secondaire', 'non'], ['#004', '47', 'universitaire', 'oui']] },
    { unite: 'un pays, une année', ex: 'des données comparées', cols: ['pays', 'année', 'PIB / hab.', 'démocratie (0–10)'],
      rows: [['Canada', '2022', '52 000 $', '9,2'], ['Canada', '2023', '53 000 $', '9,1'], ['Brésil', '2022', '9 000 $', '6,8'], ['Brésil', '2023', '9 500 $', '6,9']] },
    { unite: 'un parti, une élection', ex: 'des résultats électoraux', cols: ['parti', 'élection', 'candidat.e.s', '% des voix'],
      rows: [['CAQ', '2022', '125', '41'], ['PLQ', '2022', '125', '14'], ['QS', '2022', '125', '15'], ['PQ', '2022', '125', '15']] },
    { unite: 'un discours, un tweet', ex: 'des textes', cols: ['texte', 'auteur', 'mots', 'ton'],
      rows: [['tweet 1', 'député.e A', '38', 'négatif'], ['tweet 2', 'député.e A', '21', 'positif'], ['discours 1', 'ministre B', '2 140', 'neutre'], ['tweet 3', 'député.e C', '44', 'négatif']] }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TABLES.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const t = $derived(TABLES[e]);
</script>

<div class="visuel unites" bind:this={hote}>
  <div class="haut">
    <span class="et">UNE LIGNE =</span>
    <strong>{t.unite}</strong>
    <span class="ex">{t.ex}</span>
    <span class="compte">exemples illustratifs · {e + 1} / {TABLES.length}</span>
  </div>
  {#key e}
  <table>
    <thead><tr><th class="n"></th>{#each t.cols as c, i}<th class:acc={i === t.cols.length - 1}>{c}</th>{/each}</tr></thead>
    <tbody>
      {#each t.rows as r, k}
        <tr class="ligne" style="animation-delay: {k * 90}ms"><td class="n">{k + 1}</td>{#each r as v, i}<td class:acc={i === r.length - 1}>{v}</td>{/each}</tr>
      {/each}
      <tr class="suite"><td class="n">…</td><td colspan="4">et des centaines, des milliers d'autres lignes</td></tr>
    </tbody>
  </table>
  {/key}
  <div class="bas">
    <span class="fleche">←</span><span>chaque <strong>ligne</strong> est une unité</span>
    <span class="sep"></span>
    <span>chaque <strong>colonne</strong> est une variable</span><span class="fleche">↑</span>
  </div>
</div>

<style>
  .unites { display: flex; flex-direction: column; gap: 0.7em; }
  .haut { display: flex; align-items: baseline; gap: 0.8em; }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .haut strong { font-size: 1.5em; color: var(--dk-accent); }
  .ex { font-size: 0.8em; color: var(--dk-gris); }
  .compte { margin-left: auto; font-size: 0.7em; color: var(--dk-gris-2); }
  table { width: 100%; border-collapse: collapse; font-size: 0.95em; border: 3px solid var(--dk-encre); }
  th { text-align: left; padding: 0.45em 0.8em; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.8em; letter-spacing: 0.06em; }
  th.acc { color: var(--dk-accent-clair); }
  td { padding: 0.45em 0.8em; border-bottom: 1px solid var(--dk-filet); font-variant-numeric: tabular-nums; }
  td.acc { color: var(--dk-accent); font-weight: 600; }
  .n { width: 2.4em; color: var(--dk-gris-2); text-align: right; }
  .ligne { animation: entre 0.4s both; }
  @keyframes entre { from { opacity: 0; transform: translateX(-0.4em); } to { opacity: 1; transform: none; } }
  .suite td { color: var(--dk-gris); border-bottom: 0; }
  .bas { display: flex; gap: 0.6em; align-items: center; font-size: 0.85em; color: var(--dk-gris); }
  .bas strong { color: var(--dk-encre); }
  .fleche { color: var(--dk-accent); font-size: 1.3em; }
  .sep { flex: 1; }
</style>
