<script>
  /**
   * Le rendre beau, un argument à la fois. À gauche, le code complet de
   * l'étape (les lignes ajoutées en rouge). À droite, le vrai tableau que ce
   * code donne : chaque étape a été exécutée telle quelle par
   * outils/seance7_ms.R (MS_BEAU, static/img/s7-ms-beau-*.png).
   *
   *   0  modelsummary(modele, stars = TRUE) : le tableau par défaut.
   *   1  coef_rename : des noms en français.
   *   2  gof_map = c("nobs", "r.squared") : seulement N et R².
   *   3  options(OutDec = ",") : la virgule décimale.
   *   4  title et notes.
   *
   * Les images gardent la même échelle d'une étape à l'autre (72 pixels du
   * PNG pour 1 em) : le texte du tableau ne change pas de taille, seul le
   * tableau raccourcit. Elles sont empilées en haut de leur cadre.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { MS_BEAU as B } from '$lib/data/seance7_ms.js';
  import MsCode from './MsCode.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: B.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const PX = 72;
  const HMAX = Math.max(...B.map((b) => b.h));
  const LMAX = Math.max(...B.map((b) => b.l));
  // Les lignes nouvelles : celles qui n'étaient pas dans le code de l'étape d'avant.
  const nouveau = (i) => {
    if (i === 0) return [];
    const avant = B[i - 1].code.split('\n');
    return B[i].code.split('\n').map((l, k) => (avant.includes(l) ? -1 : k)).filter((k) => k >= 0);
  };
  const DIT = ['', 'des noms en français', 'seulement N et R²', 'la virgule décimale', 'un titre et une note'];
</script>

<div class="visuel ms-beau" bind:this={hote}>
  <div class="mb-gauche">
    <MsCode code={B[e].code} nouveau={nouveau(e)} />
    <p class="mb-dit" class:mb-vu={e > 0}>{DIT[e] || ' '}</p>
  </div>
  <figure class="mb-tab" style="width: {LMAX / PX}em; height: {HMAX / PX}em">
    {#each B as b, i}
      <img src="{base}/img/{b.img}" class:mb-vu={i === e} style="width: {b.l / PX}em; height: {b.h / PX}em" alt={i === e ? 'Le tableau que donne ce code.' : ''} />
    {/each}
  </figure>
</div>

<style>
  .ms-beau { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2.4em; align-items: center; }
  .mb-gauche { display: flex; flex-direction: column; gap: 1em; font-size: 0.92em; }
  .mb-dit { margin: 0; min-height: 1.3em; font-size: 1.15em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .mb-dit.mb-vu { opacity: 1; }
  .mb-tab { position: relative; margin: 0; }
  .mb-tab img { position: absolute; top: 0; left: 0; display: block; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; opacity: 0; transition: opacity 0.35s; }
  .mb-tab img.mb-vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .mb-tab img, .mb-dit { transition: none; } }
</style>
