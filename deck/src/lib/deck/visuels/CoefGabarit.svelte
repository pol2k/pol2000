<script>
  /**
   * Le gabarit du graphique des coefficients, pour les travaux. Les images
   * sont celles que produit le code de GABARIT, exécuté tel quel par
   * outils/seance7_h.R (le modèle à plusieurs variables de notre sondage) :
   * static/img/s7-gabarit-ggplot.png et s7-gabarit-modelplot.png, 2 100 ×
   * 1 200 pixels (7 × 4 pouces à 300 dpi). Pas de temps au clic.
   *
   * vue = 'resultat' : le graphique en grand (le code suit, deux diapos).
   * vue = 'modelplot' : le raccourci de modelsummary, le code en haut,
   *                     l'image dessous (1 680 × 960, 5,6 × 3,2 pouces).
   */
  import { base } from '$app/paths';
  import Code from '../Code.svelte';
  import { GABARIT } from '$lib/data/seance7_h.js';

  /** @type {{ vue?: 'resultat' | 'modelplot' }} */
  let { vue = 'resultat' } = $props();
</script>

{#if vue === 'resultat'}
  <div class="visuel cg-resultat">
    <img src="{base}/img/{GABARIT.image}" width={GABARIT.largeur} height={GABARIT.hauteur}
      alt="Le graphique des coefficients produit par le gabarit&#8239;: scolarité, âge, femme, revenu et Québec, chacun avec son point et son intervalle de confiance à 95&#8239;%, une ligne pointillée à 0." />
  </div>
{:else}
  <div class="visuel cg-deux">
    <Code src={GABARIT.en_une_ligne} titre="modelsummary · en une ligne ou presque" />
    <img src="{base}/img/{GABARIT.image_modelplot}" width={GABARIT.largeur_modelplot} height={GABARIT.hauteur_modelplot}
      alt="Le graphique produit par modelplot()&#8239;: les mêmes cinq coefficients et leurs intervalles à 95&#8239;%." />
  </div>
{/if}

<style>
  .cg-resultat { display: flex; flex-direction: column; align-items: center; gap: 0.5em; }
  .cg-resultat img { width: auto; max-width: 100%; max-height: 60vh; height: auto; display: block;
    border: 2px solid var(--dk-encre); background: #fff; }
  .cg-deux { display: flex; flex-direction: column; align-items: center; gap: 0.6em; }
.cg-deux :global(.bloc-code) { align-self: stretch; }
  .cg-deux img { width: auto; max-width: 100%; max-height: 40vh; height: auto; display: block; border: 2px solid var(--dk-encre); background: #fff; }
</style>
