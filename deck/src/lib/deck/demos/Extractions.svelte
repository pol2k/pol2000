<script>
  import d from './extractions.json';

  /**
   * Le même avis, six questions différentes. On ne change pas de donnée, on
   * change de consigne — et c'est ce qui distingue un LLM d'un dictionnaire
   * de sentiment, qui ne sait faire qu'une chose.
   *
   * Les six sorties sont de vrais appels, temperature 0, sortie JSON forcée.
   * Aucune n'est écrite à la main.
   */
  const compact = (t) => {
    try {
      return JSON.stringify(JSON.parse(t));
    } catch {
      return t.replace(/\s+/g, ' ');
    }
  };
  const TITRES = {
    sentiment: 'Le ton',
    complexite: 'La complexité du texte',
    fautes: 'Les fautes',
    themes: 'Les thèmes',
    retour: "L'intention de revenir",
    registre: 'Le registre'
  };
</script>

<div class="ext">
  <p class="avis">« {d.avis} »</p>

  <div class="grille">
    {#each d.taches as t}
      <div class="carte">
        <span class="titre">{TITRES[t.cle]}</span>
        <code class="rep">{compact(t.reponse)}</code>
      </div>
    {/each}
  </div>

  <p class="note">
    Une seule donnée, six questions. Le dictionnaire n'en savait poser qu'une.
  </p>
</div>

<style>
  .ext {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }
  .avis {
    margin: 0;
    font-size: 0.66em;
    line-height: 1.4;
    color: var(--dk-gris);
    border-left: 3px solid var(--dk-filet);
    padding-left: 0.7em;
  }

  .grille {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.4em;
  }
  .carte {
    border: 2px solid var(--dk-filet);
    padding: 0.35em 0.6em 0.45em;
    display: flex;
    flex-direction: column;
    gap: 0.1em;
    min-width: 0;
  }
  .titre {
    font-size: 0.58em;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    font-weight: 600;
    color: var(--dk-gris);
  }
  /* La sortie brute, telle qu'elle revient: c'est du JSON, pas une phrase. */
  .rep {
    font-family: var(--dk-mono);
    font-size: 0.62em;
    color: var(--dk-accent);
    overflow-wrap: anywhere;
  }

  .note {
    margin: 0;
    font-size: 0.66em;
    font-weight: 600;
    color: var(--dk-encre);
  }
</style>
