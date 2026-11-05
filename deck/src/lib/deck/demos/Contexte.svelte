<script>
  /**
   * Ce qui part réellement vers le serveur, à chaque fois.
   *
   * À gauche, le clavardage: la requête grossit à chaque tour, parce qu'elle
   * embarque tout l'échange précédent — et parfois des conversations
   * antérieures. Le même document n'y reçoit donc jamais deux fois la même
   * réponse.
   *
   * À droite, l'API: trois requêtes de forme identique, chacune contenant la
   * consigne et un document, rien d'autre.
   *
   * C'est la taille des piles qui porte l'argument. Aucun texte ne dit
   * « le contexte s'accumule »: on le voit.
   */
  const CLAVARDAGE = [
    ['système', 'msg 1'],
    ['système', 'msg 1', 'réponse 1', 'msg 2'],
    ['système', 'msg 1', 'réponse 1', 'msg 2', 'réponse 2', 'msg 3']
  ];
  const API = [
    ['consigne', 'document 1'],
    ['consigne', 'document 2'],
    ['consigne', 'document 3']
  ];
</script>

<div class="ctx">
  <section class="col">
    <h3>DANS UNE FENÊTRE DE CLAVARDAGE</h3>
    <p class="sous">la requête grossit à chaque tour</p>

    <div class="anterieur">conversations d'avant · parfois embarquées aussi</div>

    <ol class="pile">
      {#each CLAVARDAGE as req, i}
        <li>
          <span class="no">appel {i + 1}</span>
          <span class="req">
            {#each req as bloc, k}
              <span class="bl" class:doc={k === req.length - 1}>{bloc}</span>
            {/each}
          </span>
        </li>
      {/each}
    </ol>

    <p class="verdict">La réponse dépend de tout ce qui précède.</p>
  </section>

  <section class="col droite">
    <h3>PAR L'API</h3>
    <p class="sous">chaque appel repart à neuf</p>

    <div class="anterieur vide">rien d'antérieur n'entre</div>

    <ol class="pile">
      {#each API as req, i}
        <li>
          <span class="no">appel {i + 1}</span>
          <span class="req">
            {#each req as bloc, k}
              <span class="bl" class:doc={k === req.length - 1}>{bloc}</span>
            {/each}
          </span>
        </li>
      {/each}
    </ol>

    <p class="verdict fort">Trois appels de même forme, trois réponses comparables.</p>
  </section>
</div>

<style>
  .ctx {
    display: grid;
    grid-template-columns: 1.25fr 1fr;
    gap: 1.2em;
    width: 100%;
  }
  .col {
    display: flex;
    flex-direction: column;
    gap: 0.3em;
    min-width: 0;
  }

  h3 {
    margin: 0;
    font-size: 0.6em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .col.droite h3 {
    color: var(--dk-accent);
  }
  .sous {
    margin: 0 0 0.2em;
    font-size: 0.58em;
    color: var(--dk-gris-2);
  }

  /* Ce qui vient d'avant: présent à gauche, absent à droite. */
  .anterieur {
    border: 1px dashed var(--dk-gris-2);
    padding: 0.25em 0.5em;
    font-size: 0.54em;
    color: var(--dk-gris);
    margin-bottom: 0.35em;
  }
  .anterieur.vide {
    border-style: dashed;
    color: var(--dk-gris-2);
    opacity: 0.5;
  }

  .pile {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .pile li {
    display: grid;
    grid-template-columns: 4.6em 1fr;
    gap: 0.5em;
    align-items: center;
  }
  .no {
    font-size: 0.56em;
    letter-spacing: 0.1em;
    color: var(--dk-gris-2);
    text-align: right;
  }
  .req {
    display: flex;
    flex-wrap: wrap;
    gap: 0.15em;
  }
  .bl {
    font-size: 0.54em;
    padding: 0.18em 0.4em;
    border: 1px solid var(--dk-filet);
    color: var(--dk-gris);
    white-space: nowrap;
  }
  /* Le document du tour: c'est la seule chose qu'on voulait envoyer. */
  .bl.doc {
    border-color: var(--dk-accent);
    color: var(--dk-accent);
    font-weight: 600;
  }

  .verdict {
    margin: 0.45em 0 0;
    font-size: 0.62em;
    color: var(--dk-gris);
  }
  .verdict.fort {
    color: var(--dk-accent);
    font-weight: 600;
  }
</style>
