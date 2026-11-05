<script>
  /**
   * LM Arena: comment un classement de modèles se fabrique, et ce qu'il
   * mesure vraiment.
   *
   * Le dessin suit la procédure: une question, deux réponses anonymes, un
   * vote, et seulement après on découvre qui était qui. C'est l'anonymat qui
   * fait la validité du dispositif, donc il doit se voir.
   *
   * La réserve compte autant que la méthode: le classement mesure une
   * préférence humaine sur des questions quelconques, pas la justesse sur
   * VOTRE tâche.
   */
  const ETAPES = [
    { n: '1', t: 'Vous posez une question', d: 'la vôtre, n’importe laquelle' },
    { n: '2', t: 'Deux modèles répondent', d: 'anonymes, tirés au hasard' },
    { n: '3', t: 'Vous votez', d: 'A, B, égalité, ou les deux mauvais' },
    { n: '4', t: 'Les noms sont révélés', d: 'après le vote, jamais avant' }
  ];
</script>

<div class="arn">
  <ol class="etapes">
    {#each ETAPES as e}
      <li>
        <span class="n">{e.n}</span>
        <span class="t">{e.t}</span>
        <span class="d">{e.d}</span>
      </li>
    {/each}
  </ol>

  <div class="duel">
    <div class="rep">
      <span class="etq">MODÈLE A</span>
      <span class="anon">?</span>
    </div>
    <span class="vs">contre</span>
    <div class="rep">
      <span class="etq">MODÈLE B</span>
      <span class="anon">?</span>
    </div>
  </div>

  <div class="bas">
    <div class="bloc">
      <span class="tete">CE QUE ÇA DONNE</span>
      <p>
        Un classement à la Elo, calculé sur des centaines de milliers de duels. Plus de
        <strong>240 000 votes</strong> dès la publication de la méthode.
      </p>
    </div>
    <div class="bloc reserve">
      <span class="tete">CE QUE ÇA NE DIT PAS</span>
      <p>
        Ce que le public <strong>préfère</strong> sur des questions quelconques. Pas la justesse sur
        votre corpus, ni sur votre tâche. Un modèle premier au classement peut être mauvais chez vous.
      </p>
    </div>
  </div>
</div>

<style>
  .arn {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.6em;
  }

  .etapes {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.6em;
  }
  .etapes li {
    display: flex;
    flex-direction: column;
    gap: 0.05em;
    border-top: 2px solid var(--dk-accent);
    padding-top: 0.3em;
  }
  .n {
    font-size: 0.9em;
    font-weight: 600;
    line-height: 1;
    color: var(--dk-accent);
  }
  .t {
    font-size: 0.64em;
    font-weight: 600;
    color: var(--dk-encre);
  }
  .d {
    font-size: 0.58em;
    color: var(--dk-gris);
  }

  /* Le duel: deux réponses sans nom. L'anonymat est le dispositif. */
  .duel {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.1em;
  }
  .rep {
    flex: 1;
    border: 2px solid var(--dk-filet);
    padding: 0.4em 0.7em 0.5em;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.1em;
  }
  .etq {
    font-size: 0.54em;
    letter-spacing: 0.16em;
    color: var(--dk-gris);
  }
  .anon {
    font-size: 1.5em;
    font-weight: 600;
    color: var(--dk-accent);
    line-height: 1;
  }
  .vs {
    font-size: 0.6em;
    color: var(--dk-gris-2);
  }

  .bas {
    display: grid;
    grid-template-columns: 1fr 1.25fr;
    gap: 1.1em;
  }
  .bloc {
    border-left: 3px solid var(--dk-accent);
    padding-left: 0.7em;
    display: flex;
    flex-direction: column;
    gap: 0.1em;
  }
  .bloc.reserve {
    border-left-color: var(--dk-encre);
  }
  .tete {
    font-size: 0.56em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-accent);
  }
  .bloc.reserve .tete {
    color: var(--dk-encre);
  }
  .bloc p {
    margin: 0;
    font-size: 0.63em;
    line-height: 1.4;
    color: var(--dk-gris);
  }
  .bloc p strong {
    color: var(--dk-encre);
  }
</style>
