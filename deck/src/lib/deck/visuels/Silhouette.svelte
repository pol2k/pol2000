<script>
  /**
   * La silhouette d'un jeu de données: quatre colonnes nommées (des noms de
   * variables réels de l'Étude électorale canadienne 2025), des lignes qui
   * descendent hors cadre. Les barres sont des traits, pas des valeurs — on
   * montre la forme d'une table, pas son contenu.
   */
  const colonnes = [
    ['cps25_lr_scale_bef_1', 'gauche-droite, 0 à 10'],
    ['cps25_education', 'scolarité'],
    ['cps25_age_in_years', 'âge'],
    ['cps25_income', 'revenu']
  ];
  const LIGNES = 11;
  // Largeurs de barre déterministes (aucun aléa: le rendu est reproductible).
  const largeur = (l, c) => 28 + ((l * 7 + c * 13) % 5) * 9;
</script>

<div class="silhouette" role="img" aria-label="La forme d'une table de données: quatre colonnes nommées, des milliers de lignes.">
  <div class="entete">
    {#each colonnes as [nom, sens]}
      <div><code>{nom}</code><span>{sens}</span></div>
    {/each}
  </div>
  {#each Array.from({ length: LIGNES }) as _, l}
    <div class="ligne" class:une={l === 3} style="opacity: {l < 8 ? 1 : 1 - (l - 7) * 0.3}">
      {#each colonnes as _, c}
        <div><i style="width: {largeur(l, c)}%"></i></div>
      {/each}
    </div>
  {/each}
  <p class="suite">… des milliers de lignes. Une par personne sondée.</p>
</div>

<style>
  .silhouette { border: 2px solid var(--dk-encre); padding: 0.6em 0.8em 0.5em; }
  .entete, .ligne { display: grid; grid-template-columns: 1.6fr 1fr 1fr 1fr; gap: 0.8em; }
  .entete { border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.4em; margin-bottom: 0.4em; }
  .entete div { display: flex; flex-direction: column; gap: 0.1em; }
  .entete code { font-size: 0.72em; font-weight: 600; color: var(--dk-accent); }
  .entete span { font-size: 0.58em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }
  .ligne { padding: 0.22em 0; border-bottom: 1px solid var(--dk-filet); }
  .ligne i { display: block; height: 0.5em; background: var(--dk-gris-2); }
  .ligne.une i { background: var(--dk-encre); }
  .ligne.une { background: var(--dk-fond-2); }
  .suite { margin: 0.5em 0 0; font-size: 0.72em; color: var(--dk-gris); }
</style>
