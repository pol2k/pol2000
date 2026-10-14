<script>
  /**
   * « Avez-vous lu les consignes ? » La vraie première page des consignes du
   * travail de mi-session, posée de travers comme une feuille sur un bureau,
   * et ce qu'il faut en retenir, un cadre rouge à la fois. Cinq temps :
   *
   *   0  la page arrive, la question est posée;
   *   1  le poids : 20 %;
   *   2  la date : mercredi 28 octobre, 23h59;
   *   3  la remise : un PDF, sur monPortail (pas de .docx);
   *   4  les sept éléments du travail : le parcours qu'on suit ensuite.
   *
   * L'image (static/img/s7-consignes-mi-session.jpg, 1020 × 1320) est la
   * page 1 de travaux/POL-2000_A26_travail_mi-session.pdf, rendue par
   * pdftoppm à 120 ppp. Les cadres viennent des boîtes des mots
   * (pdftotext -bbox, page de 612 × 792 pt), en % de la page : ils suivent
   * l'image à toutes les tailles d'affichage. Le poids, la date et l'heure
   * viennent de cours.js (EVALUATIONS, id 'misession'), comme sur le site.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { EVALUATIONS } from '$lib/data/cours.js';
  import TmParcours from './TmParcours.svelte';

  const ms = EVALUATIONS.find((v) => v.id === 'misession');
  const d = new Date(ms.date + 'T12:00:00');
  const semaine = d.toLocaleDateString('fr-CA', { weekday: 'long' });
  const quantieme = d.toLocaleDateString('fr-CA', { day: 'numeric', month: 'long' });

  // [gauche, haut, largeur, hauteur] en % de la page.
  const CADRES = [
    { x: 8.6, y: 15.4, l: 12.6, h: 6.0 },
    { x: 71.0, y: 15.4, l: 18.6, h: 6.0 },
    { x: 50.2, y: 15.4, l: 15.4, h: 6.0 },
    { x: 8.8, y: 35.6, l: 82.8, h: 20.2 }
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tm-cons" bind:this={hote}>
  <figure class="tm-cons-page">
    <div class="tm-cons-feuille">
      <img src="{base}/img/s7-consignes-mi-session.jpg" alt="Première page des consignes du travail de mi-session : pondération 20 %, individuel, format PDF sur monPortail, à remettre le mercredi 28 octobre à 23h59, puis la description et les sept éléments du travail." />
      {#each CADRES as c, i}
        <span class="tm-cons-cadre" class:tm-on={e === i + 1} style="left: {c.x}%; top: {c.y}%; width: {c.l}%; height: {c.h}%"></span>
      {/each}
    </div>
    <figcaption>Les consignes · 2 pages · sur le site du cours</figcaption>
  </figure>

  <div class="tm-cons-droite">
    {#if e === 0}
      <p class="tm-cons-q">L’avez-vous lu&#8239;?</p>
    {:else}
      <div class="tm-cons-tuiles">
        <div class="tm-cons-t" class:tm-actif={e === 1}>
          <span class="tm-cons-gros">{ms.poids}&#8239;%</span>
          <span class="tm-cons-et">de la note finale</span>
        </div>
        {#if e >= 2}
          <div class="tm-cons-t" class:tm-actif={e === 2}>
            <span class="tm-cons-et">À REMETTRE</span>
            <strong>{semaine} {quantieme}</strong>
            <span class="tm-cons-h">{ms.heure}</span>
          </div>
        {/if}
        {#if e >= 3}
          <div class="tm-cons-t tm-cons-fichiers" class:tm-actif={e === 3}>
            <span class="tm-cons-pdf">PDF</span>
            <span class="tm-cons-docx">.docx</span>
            <span class="tm-cons-et">sur monPortail</span>
          </div>
        {/if}
        {#if e >= 4}
          <div class="tm-cons-t tm-cons-sept tm-actif">
            <span class="tm-cons-gros">7</span>
            <span class="tm-cons-et">éléments, une étape à la fois</span>
          </div>
        {/if}
      </div>
    {/if}
  </div>

  <div class="tm-cons-bas" class:tm-on={e >= 4}>
    <TmParcours />
  </div>
</div>

<style>
  .tm-cons { display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto; gap: 0.9em 2.4em; align-items: center; }
  .tm-cons-page { margin: 0; display: flex; flex-direction: column; gap: 0.5em; grid-row: 1; }
  .tm-cons-feuille { position: relative; height: 52vh; aspect-ratio: 1020 / 1320; background: #fff; outline: 3px solid var(--dk-encre); transform: rotate(-2.5deg); animation: tm-cons-pose 0.7s cubic-bezier(0.34, 1.4, 0.64, 1) both; }
  .tm-cons-feuille img { display: block; width: 100%; height: 100%; }
  .tm-cons-cadre { position: absolute; border: 4px solid var(--dk-accent); opacity: 0; transform: scale(1.12); transition: opacity 0.3s, transform 0.35s; pointer-events: none; }
  .tm-cons-cadre.tm-on { opacity: 1; transform: none; }
  figcaption { font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); }

  .tm-cons-droite { grid-row: 1; min-height: 52vh; display: flex; flex-direction: column; justify-content: center; }
  .tm-cons-q { margin: 0; font-size: 2.6em; font-weight: 600; line-height: 1.1; letter-spacing: -0.03em; animation: tm-cons-f 0.5s 0.5s both; }
  .tm-cons-tuiles { display: grid; grid-template-columns: 1fr 1fr; gap: 0.9em; }
  .tm-cons-t { display: flex; flex-direction: column; justify-content: center; gap: 0.25em; border: 3px solid var(--dk-encre); padding: 0.7em 1em; min-height: 6.4em; animation: tm-cons-f 0.4s both; }
  .tm-cons-t.tm-actif { border-color: var(--dk-accent); }
  .tm-cons-gros { font-size: 2.8em; font-weight: 600; line-height: 1; color: var(--dk-accent); letter-spacing: -0.03em; }
  .tm-cons-et { font-size: 0.72em; font-weight: 600; letter-spacing: 0.08em; color: var(--dk-gris); }
  .tm-cons-t strong { font-size: 1.25em; line-height: 1.2; }
  .tm-cons-h { font-size: 1em; font-weight: 600; color: var(--dk-accent); }
  .tm-cons-fichiers { flex-direction: row; flex-wrap: wrap; align-content: center; align-items: baseline; justify-content: flex-start; column-gap: 0.8em; }
  .tm-cons-fichiers .tm-cons-et { flex-basis: 100%; }
  .tm-cons-pdf { font-size: 2.2em; font-weight: 600; color: var(--dk-accent); line-height: 1; }
  .tm-cons-docx { font-size: 1.2em; font-weight: 600; color: var(--dk-gris-2); text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 0.14em; }

  .tm-cons-bas { grid-column: 1 / -1; opacity: 0; transform: translateY(0.4em); transition: opacity 0.5s 0.3s, transform 0.5s 0.3s; }
  .tm-cons-bas.tm-on { opacity: 1; transform: none; }
  .tm-cons-bas :global(.tm-parcours li) { font-size: 0.8em; }

  @keyframes tm-cons-pose { from { opacity: 0; transform: translateY(-1.2em) rotate(4deg); } to { opacity: 1; transform: rotate(-2.5deg); } }
  @keyframes tm-cons-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-cons-feuille, .tm-cons-q, .tm-cons-t { animation: none; }
    .tm-cons-cadre, .tm-cons-bas { transition: none; }
  }
</style>
