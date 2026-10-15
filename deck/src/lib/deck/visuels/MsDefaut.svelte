<script>
  /**
   * Une ligne de code, un tableau. À gauche, library(modelsummary) et
   * modelsummary(modele, stars = TRUE). À droite, le vrai tableau que cette
   * ligne donne (static/img/s7-ms-defaut.png, rendu par modelsummary 2.6
   * avec output = "….png", outils/seance7_ms.R). Il est presque bon, mais
   * il parle encore la langue de R.
   *
   *   0  Le code et le tableau.
   *   1  Les noms de R : (Intercept), scolarite.
   *   2  Le bruit, pour un cours comme le nôtre : R2 Adj., AIC, BIC,
   *      Log.Lik., RMSE.
   *   3  La note : un seuil de plus (+ p < 0.1) et des points décimaux.
   *
   * Les bandes rouges posées sur l'image viennent de MS_DEFAUT.lignes : le
   * script a repéré chaque ligne de texte de l'image (haut, bas, en fraction
   * de sa hauteur) et l'a nommée d'après le tableau de modelsummary.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { MS_DEFAUT as M } from '$lib/data/seance7_ms.js';
  import MsCode from './MsCode.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // L'échelle de l'image : 72 pixels du PNG pour 1 em (le PNG est rendu 4 fois trop grand).
  const PX = 72;
  const GROUPES = [[], ['(Intercept)', 'scolarite'], ['R2 Adj.', 'AIC', 'BIC', 'Log.Lik.', 'RMSE'], ['note']];
  const DIT = ['', 'les noms de R', 'du bruit, pour nous', 'un seuil de plus (+ p < 0.1), des points décimaux'];
  const vus = $derived(M.lignes.filter((l) => GROUPES[e].includes(l.etiquette)));
</script>

<div class="visuel ms-defaut" bind:this={hote}>
  <div class="md-gauche">
    <MsCode code={M.code} />
    <p class="md-dit" class:md-vu={e > 0}>{DIT[e] || ' '}</p>
  </div>
  <figure class="md-tab" style="width: {M.l / PX}em; height: {M.h / PX}em">
    <img src="{base}/img/{M.img}" alt="Le tableau par défaut de modelsummary : (Intercept) 0.540*** (0.021), scolarite 0.203*** (0.032), puis Num.Obs. 981, R2 0.039, R2 Adj., AIC, BIC, Log.Lik., RMSE, et la légende + p < 0.1, * p < 0.05, ** p < 0.01, *** p < 0.001." />
    {#each vus as l (l.etiquette)}
      <span class="md-bande" style="top: calc({l.haut * 100}% - 0.25em); height: calc({(l.bas - l.haut) * 100}% + 0.5em)"></span>
    {/each}
  </figure>
</div>

<style>
  .ms-defaut { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2.4em; align-items: center; }
  .md-gauche { display: flex; flex-direction: column; gap: 1em; }
  .md-dit { margin: 0; min-height: 1.3em; font-size: 1.1em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .md-dit.md-vu { opacity: 1; }
  .md-tab { position: relative; margin: 0; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; }
  .md-tab img { display: block; width: 100%; height: 100%; }
  .md-bande { position: absolute; left: -0.3em; right: -0.3em; border: 3px solid var(--dk-accent); background: rgba(198, 16, 46, 0.08); animation: md-entre 0.3s both; }
  @keyframes md-entre { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .md-bande { animation: none; } }
</style>
