<script>
  /**
   * Deux modèles côte à côte : une liste nommée (les noms deviennent les
   * en-têtes de colonnes) et les noms des variables, écrits une fois dans
   * `noms`. Le vrai tableau : static/img/s7-ms-deux.png (MS_DEUX,
   * outils/seance7_ms.R; modele2 est le modèle à plusieurs variables de la
   * séance, MULTIPLE).
   *
   *   0  Le code.
   *   1  Le tableau apparaît.
   *
   * Échelle : 88 pixels du PNG pour 1 em (le tableau est haut).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { MS_DEUX as M } from '$lib/data/seance7_ms.js';
  import MsCode from './MsCode.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const PX = 88;
  const lignes = M.code.split('\n');
  // La liste nommée : la ligne qui crée `modeles`.
  const LISTE = lignes.findIndex((l) => l.startsWith('modeles <- list('));
</script>

<div class="visuel ms-deux" bind:this={hote}>
  <div class="mx-gauche">
    <MsCode code={M.code} nouveau={e === 0 ? [LISTE] : []} />
    <p class="mx-dit">une liste nommée = une colonne par modèle</p>
  </div>
  <figure class="mx-tab" class:mx-vu={e >= 1} style="width: {M.l / PX}em; height: {M.h / PX}em">
    <img src="{base}/img/{M.img}" alt="Deux modèles côte à côte, Modèle 1 et Modèle 2, avec la constante, la scolarité, l’âge, femme, le revenu et Québec, puis Num.Obs. et R2." />
  </figure>
</div>

<style>
  .ms-deux { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2.4em; align-items: center; }
  .mx-gauche { display: flex; flex-direction: column; gap: 1em; font-size: 0.86em; }
  .mx-dit { margin: 0; font-size: 1.15em; font-weight: 600; color: var(--dk-accent); }
  .mx-tab { margin: 0; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; opacity: 0; transform: translateX(0.6em); transition: opacity 0.4s, transform 0.4s; }
  .mx-tab.mx-vu { opacity: 1; transform: none; }
  .mx-tab img { display: block; width: 100%; height: 100%; }
  @media (prefers-reduced-motion: reduce) { .mx-tab { transition: none; transform: none; } }
</style>
