<script>
  import { base } from '$app/paths';

  /**
   * Ce qu'un modèle consomme, dit en choses qu'on connaît.
   *
   * Aucune unité électrique: « 70 MW » ne parle à personne dans une salle de
   * sciences sociales. Le même fait devient un nombre de foyers, un délai de
   * construction, un compte de turbines, un volume d'eau.
   *
   * Le nombre de foyers reste calculé depuis deux chiffres officiels — la
   * fiche technique du H100 et la consommation résidentielle moyenne
   * d'Hydro-Québec — mais on n'affiche que le résultat.
   */
  const GPU = 100000;
  const FOYERS = Math.round((GPU * 700 * 8760) / 1000 / 17600);
  const esp = (v) => Math.round(v).toLocaleString('fr-CA').replace(/ |,/g, ' ');

  const FAITS = [
    { v: esp(GPU), u: 'GPU', d: 'dans un seul bâtiment, à Memphis' },
    { v: esp(FOYERS), u: 'foyers', d: 'autant d’électricité que ce nombre de foyers québécois, sur une année' },
    { v: '35', u: 'turbines', d: 'à gaz brûlées sur place pour l’alimenter' },
    { v: '700 000', u: 'litres', d: 'd’eau douce évaporés pour entraîner GPT-3' }
  ];
</script>

<div class="ctr">
  <figure class="photo">
    <img src="{base}/img/centre-donnees.jpg" alt="Une rangée de baies de serveurs dans un centre de données" />
  </figure>

  <ul class="faits">
    {#each FAITS as f}
      <li>
        <span class="v">{f.v}</span>
        <span class="u">{f.u}</span>
        <span class="d">{f.d}</span>
      </li>
    {/each}
  </ul>
</div>

<style>
  .ctr {
    display: grid;
    grid-template-columns: 0.5fr 1fr;
    gap: 1.2em;
    width: 100%;
    align-items: center;
  }
  .photo {
    margin: 0;
  }
  .photo img {
    display: block;
    width: 100%;
    height: auto;
    border: 2px solid var(--dk-encre);
  }

  .faits {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.42em;
  }
  /* Le nombre d'abord, l'unité ensuite, l'explication après: on lit la
     grandeur avant de lire la phrase. */
  .faits li {
    display: grid;
    grid-template-columns: 7.2em 5em 1fr;
    gap: 0.6em;
    align-items: baseline;
    border-left: 3px solid var(--dk-accent);
    padding-left: 0.7em;
  }
  .v {
    font-size: 1.2em;
    white-space: nowrap;
    font-weight: 600;
    line-height: 1;
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
    text-align: right;
  }
  .u {
    font-size: 0.58em;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .d {
    font-size: 0.64em;
    line-height: 1.35;
    color: var(--dk-encre);
  }
</style>
