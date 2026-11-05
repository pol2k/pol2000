<script>
  /**
   * Les quatre parties d'un prompt, montrées sur un vrai prompt plutôt
   * qu'énumérées à côté.
   *
   * Chaque bande porte son étiquette à gauche et son contenu à droite: on voit
   * que les quatre sont présentes, et où. Une liste de règles ne montre jamais
   * à quoi ressemble le résultat.
   */
  const PARTIES = [
    {
      n: 'RÔLE',
      t: 'Tu codes des avis de restaurant pour une recherche en sciences sociales.'
    },
    {
      n: 'TÂCHE',
      t: "Attribue la note en étoiles que l'auteur a le plus vraisemblablement laissée."
    },
    {
      n: 'CONTRAINTES',
      t: 'Fonde-toi sur le jugement global, pas sur le nombre de mots positifs.'
    },
    { n: 'FORMAT', t: 'Réponds selon le schéma fourni.' }
  ];
</script>

<div class="ana">
  {#each PARTIES as p, i}
    <div class="bande">
      <span class="nom" style="--i: {i}">{p.n}</span>
      <span class="txt">{p.t}</span>
    </div>
  {/each}
</div>

<style>
  .ana {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .bande {
    display: grid;
    grid-template-columns: 8.5em 1fr;
    gap: 0.8em;
    align-items: baseline;
    border-left: 3px solid var(--dk-accent);
    padding: 0.35em 0 0.35em 0.8em;
  }
  .nom {
    font-size: 0.6em;
    letter-spacing: 0.16em;
    font-weight: 600;
    color: var(--dk-accent);
    /* Chaque partie s'éclaircit un peu: l'ordre se voit sans être numéroté. */
    opacity: calc(1 - var(--i) * 0.14);
  }
  .txt {
    font-size: 0.72em;
    line-height: 1.4;
    color: var(--dk-encre);
  }
</style>
