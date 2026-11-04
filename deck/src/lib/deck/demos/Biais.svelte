<script>
  /**
   * Les biais, en une seule diapositive plutôt qu'en trois.
   *
   * Trois diapositives séparées laissaient croire à trois problèmes distincts.
   * Il n'y en a qu'un: le biais entre à trois endroits d'une même chaîne, et
   * aucune étape suivante ne le corrige. C'est l'accumulation qui compte, et
   * elle ne se voit que si les trois entrées sont sur le même dessin.
   *
   * Les traits d'injection s'épaississent le long de la chaîne: ce qui sort
   * porte les trois, pas le dernier.
   */
  const ETAPES = [
    {
      id: 'corpus',
      nom: 'CORPUS',
      entre: 'ce qu’on a ramassé',
      quoi: 'Deux tiers du corpus sont un balayage du web'
    },
    {
      id: 'balisage',
      nom: 'BALISAGE',
      entre: 'qui a annoté',
      quoi: 'Des humains écrivent les réponses exemplaires, puis les classent'
    },
    {
      id: 'entrainement',
      nom: 'ENTRAÎNEMENT',
      entre: 'ce qu’on récompense',
      quoi: 'L’optimisation retient la régularité majoritaire'
    }
  ];
</script>

<div class="bia">
  <div class="chaine">
    {#each ETAPES as e, i}
      <div class="bloc">
        <span class="entre">{e.entre}</span>
        <span class="fleche-bas" style="--e: {i + 1}">↓</span>
        <div class="boite">{e.nom}</div>
        <p class="quoi">{e.quoi}</p>
      </div>
      <span class="vers">▸</span>
    {/each}
    <div class="bloc sortie">
      <span class="entre">&nbsp;</span>
      <span class="fleche-bas vide">&nbsp;</span>
      <div class="boite plein">MODÈLE</div>
      <p class="quoi fort">Il porte les trois.</p>
    </div>
  </div>

  <p class="note">Aucune étape suivante ne corrige la précédente.</p>
</div>

<style>
  .bia {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.5em;
  }
  .chaine {
    display: flex;
    align-items: stretch;
    gap: 0.35em;
  }
  .bloc {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.12em;
    min-width: 0;
  }
  .bloc.sortie {
    flex: 0.85;
  }

  .entre {
    font-size: 0.54em;
    letter-spacing: 0.08em;
    color: var(--dk-gris);
    text-align: center;
    min-height: 1.4em;
  }
  /* Le trait d'injection s'épaissit d'une étape à l'autre: ce qui entre plus
     tard s'ajoute, il ne remplace pas. */
  .fleche-bas {
    color: var(--dk-accent);
    line-height: 1;
    font-size: calc(0.7em + var(--e, 1) * 0.12em);
  }
  .fleche-bas.vide {
    color: transparent;
  }

  .boite {
    width: 100%;
    border: 2px solid var(--dk-encre);
    padding: 0.4em 0.3em;
    text-align: center;
    font-size: 0.6em;
    letter-spacing: 0.1em;
    font-weight: 600;
  }
  .boite.plein {
    background: var(--dk-accent);
    border-color: var(--dk-accent);
    color: var(--dk-fond);
  }

  .quoi {
    margin: 0.25em 0 0;
    font-size: 0.56em;
    line-height: 1.35;
    color: var(--dk-gris);
    text-align: center;
  }
  .quoi.fort {
    color: var(--dk-accent);
    font-weight: 600;
  }

  .vers {
    align-self: center;
    color: var(--dk-gris-2);
    font-size: 0.7em;
    margin-top: 1.2em;
  }
  .vers:last-of-type {
    color: var(--dk-accent);
  }

  .note {
    margin: 0;
    font-size: 0.66em;
    color: var(--dk-encre);
    text-align: center;
  }
</style>
