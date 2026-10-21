<script>
  /**
   * Le code à gauche, ce que R produit à droite (un tableau de modelsummary
   * ou un graphique de modelplot, rendu par R lui-même : static/img/s8-*.png,
   * outils/seance8_data.R). Comme MsDeux.
   *
   *   0  le code (les lignes `nouveau` en rouge);
   *   1  l'image prend toute la diapo (le code s'efface) : un tableau doit
   *      se lire du fond de la salle.
   *
   *   code, img, l, h — le code exécuté et son image (src/lib/data/seance8.js)
   *   px              — pixels du PNG pour 1 em (88 pour un tableau haut)
   *   dit             — une ligne sous le code, facultative
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import MsCode from './MsCode.svelte';
  let { code, img, l, h, px = 88, alt = '', dit = '', nouveau = [] } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel m8i" class:plein={e >= 1} bind:this={hote}>
  <div class="gauche">
    <MsCode {code} nouveau={e === 0 ? nouveau : []} />
    {#if dit}<p class="dit">{dit}</p>{/if}
  </div>
  <figure class:vu={e >= 1} style="--l: {l}; --h: {h}; width: {l / px}em; height: {h / px}em">
    <img src="{base}/img/{img}" {alt} />
  </figure>
</div>

<style>
  .m8i { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2.2em; align-items: center; }
  .gauche { display: flex; flex-direction: column; gap: 1em; font-size: 0.86em; }
  .dit { margin: 0; font-size: 1.15em; font-weight: 600; color: var(--dk-accent); }
  figure { margin: 0; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; opacity: 0; transform: translateX(0.6em); transition: opacity 0.4s, transform 0.4s; }
  figure.vu { opacity: 1; transform: none; }
  figure img { display: block; width: 100%; height: 100%; }
  .m8i.plein { grid-template-columns: 1fr; justify-items: center; }
  .m8i.plein .gauche { display: none; }
  .m8i.plein figure { height: 64vh !important; width: auto !important; aspect-ratio: var(--l) / var(--h); }
  @media (prefers-reduced-motion: reduce) { figure { transition: none; transform: none; } }
</style>
