<script>
  /**
   * Un logo d'entreprise ou de projet, dans une tuile.
   *
   * Les marques sont récupérées à la source — l'avatar public de
   * l'organisation sur GitHub — et jamais redessinées: une approximation de
   * mémoire serait fausse.
   *
   * Elles sont hétérogènes par nature: fonds noirs, blancs, très colorés. La
   * tuile bordée les contient et les met au même poids, au lieu d'un mur de
   * commanditaires. On ne les recolore pas: une marque désaturée cesse d'être
   * reconnaissable, et c'est la reconnaissance qu'on cherche ici.
   */
  import { base } from '$app/paths';

  let { nom, alt = '', taille = '1.7em' } = $props();
</script>

<span class="logo" style="--l: {taille}">
  <img src="{base}/img/logos/{nom}.png" alt={alt} />
</span>

<style>
  .logo {
    display: inline-block;
    flex: none;
    width: var(--l);
    height: var(--l);
    border: 2px solid var(--dk-filet);
    background: var(--dk-fond);
    overflow: hidden;
    vertical-align: -0.35em;
  }
  .logo img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
</style>
