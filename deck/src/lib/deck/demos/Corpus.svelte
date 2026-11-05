<script>
  import donnees from './corpus.json';

  /**
   * Une barre par source, groupées par nature.
   *
   * Chaque source a sa ligne: son nom entier, sa part et son fait — tout
   * lisible depuis le fond de la salle, sans rien survoler.
   *
   * Les entêtes de groupe sont retirées à la demande de Laurence-Olivier. Les
   * quatre natures restent lisibles par la teinte des barres, qui décroît du
   * web vers l'académique.
   *
   * Les parts viennent du tableau 1 de Touvron et al. 2023; le fait sur C4 de
   * Dodge et al. 2021.
   */
  const G = donnees.groupes;
  const MAX = 67;
  const virgule = (v) => String(v).replace('.', ',');
  const TEINTE = { WEB: 1, RÉFÉRENCE: 0.58, CODE: 0.42, ACADÉMIQUE: 0.28 };
</script>

<div class="cps">
  {#each G as g}
    <div class="grp">
      {#each g.sources as s}
        <div class="ligne">
          <span class="nom">{s.nom}</span>
          <span class="piste">
            <span class="barre" style="width: {(s.part / MAX) * 100}%; --t: {TEINTE[g.nom]}"></span>
          </span>
          <span class="pc">{virgule(s.part)} %</span>
          <span class="fait">{s.court}</span>
        </div>
      {/each}
    </div>
  {/each}
</div>

<style>
  .cps {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.12em;
  }
  .grp {
    display: flex;
    flex-direction: column;
    gap: 0.12em;
  }

  .ligne {
    display: grid;
    grid-template-columns: 8.6em 11em 3.4em 1fr;
    gap: 0.7em;
    align-items: center;
    padding: 0.1em 0;
  }
  .nom {
    font-size: 0.64em;
    font-weight: 600;
    color: var(--dk-encre);
    white-space: nowrap;
  }
  .piste {
    display: block;
    height: 0.85em;
    background: var(--dk-fond-2);
  }
  .barre {
    display: block;
    height: 100%;
    background: color-mix(in srgb, var(--dk-accent) calc(var(--t) * 100%), var(--dk-fond));
  }
  .pc {
    font-size: 0.62em;
    font-weight: 600;
    color: var(--dk-encre);
    text-align: right;
    font-variant-numeric: tabular-nums;
  }
  .fait {
    font-size: 0.58em;
    color: var(--dk-gris);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
