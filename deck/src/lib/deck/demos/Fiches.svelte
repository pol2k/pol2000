<script>
  import { FOURNISSEURS } from '$lib/data/config.js';

  /**
   * « Ce que l'API rend possible », montré au lieu d'être énuméré: deux fiches
   * de méthodologie, la même dans les deux cas, l'une qu'on ne peut pas
   * remplir et l'autre qu'on remplit entièrement.
   *
   * L'asymétrie se lit d'un coup d'œil — c'est elle qui porte l'argument, pas
   * les six mots qu'on lisait avant.
   *
   * Chaque valeur de droite vient d'ailleurs dans le cours: le modèle de
   * config.js, la température enseignée, la taille réelle du corpus, la
   * fonction de journalisation du matériel. Rien n'est inventé pour la figure.
   */
  const MODELE = FOURNISSEURS.gemini.modele;

  const CHAMPS = [
    { l: 'modèle', v: MODELE },
    { l: 'température', v: '0' },
    { l: 'prompt', v: 'enregistré dans un script' },
    { l: 'données', v: 'sauvegardées et accessibles' },
    { l: 'log', v: 'un fichier par exécution' },
    { l: 'coût', v: 'au jeton, par appel' }
  ];
</script>

<div class="fi">
  <div class="fi-p">
    <span class="fi-n">PAR CLAVARDAGE</span>
    <dl>
      {#each CHAMPS as c}
        <div class="fi-r">
          <dt>{c.l}</dt>
          <dd class="blanc"></dd>
        </div>
      {/each}
    </dl>
    <p class="fi-b">aucune de ces valeurs n'est exposée</p>
  </div>

  <div class="fi-p plein">
    <span class="fi-n">PAR L'API</span>
    <dl>
      {#each CHAMPS as c}
        <div class="fi-r">
          <dt>{c.l}</dt>
          <dd>{c.v}</dd>
        </div>
      {/each}
    </dl>
    <p class="fi-b fort">tout cela s'écrit dans votre méthodologie</p>
  </div>
</div>

<style>
  .fi {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.1em;
    width: 100%;
  }

  .fi-p {
    border: 2px solid var(--dk-filet);
    padding: 0.7em 0.9em 0.8em;
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }
  .fi-p.plein {
    border-color: var(--dk-accent);
  }

  .fi-n {
    font-size: 0.62em;
    letter-spacing: 0.16em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .fi-p.plein .fi-n {
    color: var(--dk-accent);
  }

  dl {
    margin: 0;
    display: flex;
    flex-direction: column;
    gap: 0.32em;
  }
  .fi-r {
    display: grid;
    grid-template-columns: 8.2em 1fr;
    gap: 0.6em;
    align-items: baseline;
  }
  dt {
    font-size: 0.68em;
    color: var(--dk-gris);
  }
  dd {
    margin: 0;
    font-size: 0.68em;
    color: var(--dk-accent);
    font-weight: 600;
    overflow-wrap: anywhere;
  }
  /* Un champ qu'on ne peut pas remplir: le trait reste, la valeur manque.
     C'est le vide qui fait l'argument, pas une croix qu'on aurait dessinée. */
  dd.blanc {
    border-bottom: 1px dashed var(--dk-gris-2);
    height: 0.95em;
  }

  .fi-b {
    margin: 0.15em 0 0;
    font-size: 0.6em;
    color: var(--dk-gris-2);
    line-height: 1.35;
  }
  .fi-b.fort {
    color: var(--dk-accent);
  }
</style>
