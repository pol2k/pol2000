<script>
  /**
   * Ouverture de la partie « Des données tidy ». À gauche, la première page
   * de l'article (Wickham 2014, Journal of Statistical Software 59(10)),
   * rendue depuis le PDF de la revue (pdftoppm, 150 dpi, marges rognées).
   * À droite, sa phrase d'ouverture, traduite. Un temps :
   *
   *   0  La page et la citation.
   *   1  Pourquoi ça compte : le chemin de moindre résistance.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tidy-intro" bind:this={hote}>
  <figure class="page">
    <img
      src="{base}/img/wickham-2014-tidy-data.png"
      alt="Première page de l’article « Tidy Data » de Hadley Wickham, Journal of Statistical Software, volume 59, numéro 10, août 2014."
    />
  </figure>

  <div class="droite">
    <blockquote class="cit">
      « Les jeux de données bien rangés se ressemblent tous ; chaque jeu de données désordonné l’est à sa façon. »
      <cite>Hadley Wickham, « Tidy Data », 2014</cite>
    </blockquote>

    <p class="moindre" class:vu={e >= 1}>
      <span class="et">POURQUOI</span>
      <span>Le format tidy, c’est le chemin de moindre résistance pour l’analyse.</span>
    </p>
  </div>
</div>

<style>
  .tidy-intro { display: grid; grid-template-columns: auto 1fr; gap: 2.6em; align-items: center; }
  .page { margin: 0; border: 2px solid var(--dk-encre); background: #fff; line-height: 0; }
  .page img { display: block; height: 21em; width: auto; }
  .droite { display: flex; flex-direction: column; gap: 1.6em; }
  .cit { font-size: 1.25em; line-height: 1.4; }
  .moindre { margin: 0; display: flex; flex-direction: column; gap: 0.35em; font-size: 1em; line-height: 1.4; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .moindre.vu { opacity: 1; transform: none; }
  .moindre .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .moindre { transition: none; transform: none; } }
</style>
