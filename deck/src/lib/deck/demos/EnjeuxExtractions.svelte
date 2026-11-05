<script>
  import d from './enjeux-extractions.json';

  /**
   * La même réponse de la CES 2025, six consignes différentes. On ne change
   * pas de donnée, on change de consigne, et c'est ce qui distingue un LLM
   * d'un dictionnaire de mots-clés, qui ne sait poser qu'une question.
   *
   * Les six sorties viennent de Claude (Anthropic), dans Claude Code, le
   * 5 novembre 2026, au format JSON demandé. Elles sont lues dans
   * enjeux-extractions.json (outils/seance9_enjeux.R vérifie que la réponse
   * est bien celle de la ligne indiquée). Aucune n'est retouchée.
   */
  const compact = (t) => {
    try {
      return JSON.stringify(JSON.parse(t));
    } catch {
      return t.replace(/\s+/g, ' ');
    }
  };
</script>

<div class="ext">
  <div class="rep-cell">
    <span class="li">ligne {d.ligne} · {d.langue}</span>
    <p class="avis">« {d.texte} »</p>
  </div>

  <div class="grille">
    {#each d.taches as t}
      <div class="carte">
        <span class="titre">{t.titre}</span>
        <code class="rep">{compact(t.reponse)}</code>
      </div>
    {/each}
  </div>

  <p class="note">Une seule réponse, six questions. Le dictionnaire n’en savait poser qu’une.</p>
</div>

<style>
  .ext {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }
  .rep-cell {
    border-left: 3px solid var(--dk-filet);
    padding-left: 0.7em;
    display: flex;
    flex-direction: column;
    gap: 0.15em;
  }
  .li {
    font-size: 0.55em;
    color: var(--dk-gris-2);
    font-variant-numeric: tabular-nums;
  }
  .avis {
    margin: 0;
    font-size: 0.66em;
    line-height: 1.4;
    color: var(--dk-gris);
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
  /* La sortie brute, telle qu'elle revient : c'est du JSON, pas une phrase. */
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
