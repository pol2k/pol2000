<script>
  /**
   * Quatre paliers d'exposition, dessinés comme un escalier qui descend.
   *
   * La liste précédente disait la même chose mais ne la montrait pas: on
   * lisait quatre lignes sans voir qu'elles formaient une échelle. Ici la
   * hauteur de chaque colonne EST le degré d'exposition, et « descendre d'un
   * cran » devient littéral.
   *
   * Les règles de l'API viennent de la documentation d'OpenAI, relevée le
   * 24 août 2026.
   */
  const PALIERS = [
    {
      n: 'CLAVARDAGE\nGRAND PUBLIC',
      h: 100,
      r: 'Vos conversations peuvent servir à entraîner le modèle, sauf refus explicite dans les réglages.'
    },
    {
      n: 'PAR L’API',
      h: 58,
      r: 'Pas d’entraînement sur vos données. Un log de 30 jours pour la surveillance des abus.'
    },
    {
      n: 'API,\nRÉTENTION NULLE',
      h: 26,
      r: 'Le log lui-même est supprimé. Sur approbation préalable du fournisseur.'
    },
    {
      n: 'MODÈLE OUVERT,\nCHEZ VOUS',
      h: 4,
      r: 'Rien ne sort. Aucune requête, aucun log, aucun tiers.'
    }
  ];
</script>

<div class="don">
  <div class="escalier">
    <span class="axe">CE QUI SORT DE CHEZ VOUS</span>
    <div class="cols">
      {#each PALIERS as p, i}
        <div class="col" class:sur={i === 0} class:sous={i === PALIERS.length - 1}>
          <div class="fut">
            <span class="bloc" style="height: {p.h}%"></span>
          </div>
          <span class="nom">{p.n}</span>
          <span class="regle">{p.r}</span>
        </div>
      {/each}
    </div>
  </div>

</div>

<style>
  .don {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.7em;
  }
  .escalier {
    display: flex;
    flex-direction: column;
    gap: 0.25em;
  }
  .axe {
    font-size: 0.55em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-gris);
  }

  .cols {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.7em;
    align-items: end;
  }
  .col {
    display: flex;
    flex-direction: column;
    gap: 0.25em;
    min-width: 0;
  }

  /* La hauteur du bloc est le degré d'exposition: l'escalier descend, et
     c'est le dessin qui porte l'argument. */
  .fut {
    height: 6.2em;
    display: flex;
    align-items: flex-end;
    border-bottom: 2px solid var(--dk-encre);
  }
  /* Gris pour l'exposition, accent pour le palier qu'on vise: la doctrine du
     deck exclut les aplats sombres, et le noir écrasait la diapositive. */
  .bloc {
    display: block;
    width: 100%;
    background: var(--dk-gris-2);
  }
  .col.sous .bloc {
    background: var(--dk-accent);
  }

  .nom {
    font-size: 0.56em;
    letter-spacing: 0.1em;
    font-weight: 600;
    color: var(--dk-encre);
    white-space: pre-line;
    line-height: 1.25;
  }
  .col.sous .nom {
    color: var(--dk-accent);
  }
  .regle {
    font-size: 0.58em;
    line-height: 1.4;
    color: var(--dk-gris);
  }

  .note {
    margin: 0;
    font-size: 0.7em;
    color: var(--dk-gris);
  }
  .note strong {
    color: var(--dk-encre);
  }
</style>
