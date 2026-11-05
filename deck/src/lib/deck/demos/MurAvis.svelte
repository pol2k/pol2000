<script>
  import { base } from '$app/paths';
  import avis from './avis-reels.json';
  import { PHOTO_RESTAURANT } from '$lib/data/credits-images.js';

  /**
   * Le corpus, montré au lieu d'être décrit: six vrais avis Google, dans leur
   * langue d'origine, chacun avec l'étoile que son auteur a laissée.
   *
   * C'est la démonstration de l'argument de la diapositive — la vérité terrain
   * est déjà là, dans la donnée — plutôt qu'une phrase qui l'affirme.
   *
   * Aucun nom d'auteur: le dépôt est public, seuls le texte et la note en
   * sortent. Les six textes sont vérifiés au mot près contre le corpus.
   */
  const etoiles = (n) => '★'.repeat(n) + '☆'.repeat(5 - n);
</script>

<div class="mur-tete">
  {#if PHOTO_RESTAURANT}
    <figure class="photo">
      <img src="{base}/img/{PHOTO_RESTAURANT.fichier}" alt="La devanture du restaurant La Ligne Rouge" />
    </figure>
  {/if}
  <div class="prov-col">
    <span class="prov">
      <img src="{base}/img/google-maps.png" alt="" />
      Google Maps
    </span>
    <span class="gros">{avis.total}</span>
    <span class="lab">avis récoltés</span>
    {#if PHOTO_RESTAURANT}
      <span class="credit">{PHOTO_RESTAURANT.auteur}</span>
    {/if}
  </div>
</div>

<div class="mur">
  {#each avis.avis as a}
    <figure class="av" class:haut={a.note >= 4} class:bas={a.note <= 2}>
      <div class="av-t">
        <span class="et">{etoiles(a.note)}</span>
        <span class="lg">{a.langue}</span>
      </div>
      <blockquote>{a.texte}</blockquote>
    </figure>
  {/each}
</div>

<style>
  /* La provenance des avis, montrée plutôt qu'écrite: le logo dit d'où vient
     la donnée en un coup d'œil. Marque déposée, usage nominatif. */
  /* La photo en colonne plutôt qu'en bandeau: à pleine largeur elle mangeait
     la hauteur des avis, qui sont le sujet de la diapositive. */
  .mur-tete {
    display: grid;
    grid-template-columns: 1.75fr 1fr;
    gap: 1em;
    align-items: stretch;
    margin-bottom: 0.6em;
  }
  .prov-col {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 0.1em;
  }
  .gros {
    font-size: 1.9em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.04em;
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
  }
  .lab {
    font-size: 0.6em;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .prov {
    display: flex;
    align-items: center;
    gap: 0.45em;
    font-size: 0.66em;
    color: var(--dk-gris);
  }
  .prov img {
    width: 1.5em;
    height: 1.5em;
    display: block;
  }
  /* L'image est large: elle tient mieux en bandeau qu'en vignette, et elle
     ancre la diapositive sans voler la place aux avis. */
  .photo {
    margin: 0;
  }
  /* Le fichier est déjà recadré sur la bande utile: on l'affiche entier
     plutôt que de le rogner une seconde fois en CSS, ce qui coupait les
     enseignes. */
  .photo img {
    display: block;
    width: 100%;
    height: auto;
    border: 2px solid var(--dk-encre);
  }
  .credit {
    font-size: 0.52em;
    color: var(--dk-gris-2);
    margin-top: 0.35em;
  }

  .mur {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.6em;
    width: 100%;
  }

  .av {
    margin: 0;
    border: 2px solid var(--dk-filet);
    padding: 0.5em 0.65em 0.6em;
    display: flex;
    flex-direction: column;
    gap: 0.35em;
    min-width: 0;
  }
  .av.haut {
    border-color: var(--dk-encre);
  }
  .av.bas {
    border-color: var(--dk-accent);
  }

  .av-t {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 0.5em;
  }
  /* L'étoile porte la note réelle: c'est elle, la vérité terrain. */
  .et {
    font-size: 0.78em;
    letter-spacing: 0.08em;
    color: var(--dk-accent);
  }
  .lg {
    font-size: 0.55em;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-gris-2);
  }

  blockquote {
    margin: 0;
    font-size: 0.66em;
    line-height: 1.45;
    color: var(--dk-encre);
  }
</style>
