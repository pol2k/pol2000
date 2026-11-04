<script>
  /**
   * Ce qui sépare une base de données d'un modèle n'est pas la qualité des
   * réponses: c'est le nombre de sorties possibles.
   *
   * Une base a deux issues, dont « rien trouvé ». Un modèle n'en a qu'une. Le
   * dessin montre la branche manquante — c'est l'absence qui fait l'argument,
   * et une liste à puces ne peut pas montrer une absence.
   */
</script>

<div class="con">
  <section class="col">
    <h3>UNE BASE DE DONNÉES</h3>
    <div class="req">une requête</div>
    <div class="fl">↓</div>
    <ul class="issues">
      <li><span class="et">trouvé</span><span class="res">le fait, à l'identique</span></li>
      <li><span class="et">rien trouvé</span><span class="res">« je n'ai pas »</span></li>
    </ul>
    <p class="bilan">Deux issues possibles.</p>
  </section>

  <section class="col cible">
    <h3>UN MODÈLE DE LANGAGE</h3>
    <div class="req">une requête</div>
    <div class="fl">↓</div>
    <ul class="issues">
      <li><span class="et">toujours</span><span class="res">quelque chose de plausible</span></li>
      <li class="absente"><span class="et">—</span><span class="res">cette branche n'existe pas</span></li>
    </ul>
    <p class="bilan fort">Une seule issue possible.</p>
  </section>
</div>

<style>
  .con {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.4em;
    width: 100%;
  }
  .col {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 0.25em;
  }
  h3 {
    margin: 0;
    font-size: 0.6em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .col.cible h3 {
    color: var(--dk-accent);
  }

  .req {
    border: 2px solid var(--dk-filet);
    padding: 0.3em 0.7em;
    font-size: 0.62em;
    color: var(--dk-gris);
  }
  .fl {
    color: var(--dk-gris-2);
    font-size: 0.75em;
    line-height: 1;
    margin-left: 1.2em;
  }

  .issues {
    list-style: none;
    margin: 0;
    padding: 0;
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .issues li {
    display: grid;
    grid-template-columns: 7.5em 1fr;
    gap: 0.6em;
    align-items: baseline;
    border-left: 3px solid var(--dk-encre);
    padding: 0.22em 0 0.22em 0.6em;
  }
  .col.cible .issues li {
    border-left-color: var(--dk-accent);
  }
  /* La branche que le modèle n'a pas: en pointillé et effacée. C'est elle
     qu'on veut qu'ils remarquent. */
  .issues li.absente {
    border-left-style: dashed;
    border-left-color: var(--dk-gris-2);
    opacity: 0.45;
  }
  .et {
    font-size: 0.6em;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .res {
    font-size: 0.66em;
    color: var(--dk-encre);
  }
  .issues li.absente .res {
    font-style: italic;
    color: var(--dk-gris);
  }

  .bilan {
    margin: 0.35em 0 0;
    font-size: 0.66em;
    color: var(--dk-gris);
  }
  .bilan.fort {
    color: var(--dk-accent);
    font-weight: 600;
  }
</style>
