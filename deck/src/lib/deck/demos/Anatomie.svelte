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
    { n: 'RÔLE', t: 'Tu aides un.e étudiant.e de premier cycle qui débute en R, dans Positron.' },
    { n: 'TÂCHE', t: 'Voici mon code et le message d’erreur. Explique la cause, puis corrige.' },
    { n: 'CONTRAINTES', t: 'Change le moins de lignes possible. Ne réécris pas le reste.' },
    { n: 'FORMAT', t: 'La cause en une phrase, puis le code corrigé, seul.' }
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
