<script>
  /**
   * L'exporter : ajouter output = "…" à l'appel. Les travaux se remettent en
   * PDF : le tableau va dans le document (Word, Google Docs), puis le
   * document s'enregistre en PDF.
   *
   *   0  Une seule fois : installer modelsummary et pandoc. Puis
   *      output = "tableau.docx". À droite, la vraie page du fichier .docx
   *      produit par ce code (ouverte par LibreOffice, outils/seance7_ms.R).
   *   1  output = "tableau.png" : une image. Il faut aussi webshot2 (et
   *      Google Chrome sur l'ordinateur). À droite, le vrai tableau.png.
   *
   * Le code et les images : MS_EXPORT dans src/lib/data/seance7_ms.js,
   * static/img/s7-ms-docx.png et s7-ms-png.png. `noms` vient de la diapo
   * d'avant (MS_DEUX).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { MS_EXPORT as X } from '$lib/data/seance7_ms.js';
  import MsCode from './MsCode.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les deux aperçus à la même hauteur de texte : le .docx est rendu à 300 ppp, le .png 4 fois trop grand.
  const VUES = [
    { ...X.apercu, px: 46, dit: 'tableau.docx : Word, puis « Enregistrer en PDF »' },
    { ...X.image, px: 80, dit: 'tableau.png : une image à glisser dans le travail' }
  ];
  const code = $derived(e === 0 ? X.docx : X.png);
  const sortie = $derived(code.split('\n').findIndex((l) => l.includes('output =')));
  const installer = $derived(e === 0 ? X.installer : `${X.installer}\n${X.installer_png}`);
</script>

<div class="visuel ms-export" bind:this={hote}>
  <div class="mx-gauche">
    <MsCode code={installer} etiquette="une seule fois" nouveau={e === 1 ? [installer.split('\n').length - 1] : []} />
    <MsCode code={code} etiquette="puis" nouveau={[sortie]} />
  </div>
  <div class="mx-droite">
    <figure class="mx-vue" style="width: {Math.max(...VUES.map((v) => v.l / v.px))}em; height: {Math.max(...VUES.map((v) => v.h / v.px))}em">
      {#each VUES as v, i}
        <img src="{base}/img/{v.img}" class:mx-vu={i === e} style="width: {v.l / v.px}em; height: {v.h / v.px}em" alt={i === e ? v.dit : ''} />
      {/each}
    </figure>
    <p class="mx-dit">{VUES[e].dit}</p>
  </div>
</div>

<style>
  .ms-export { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2.4em; align-items: center; }
  .mx-gauche { display: flex; flex-direction: column; gap: 1em; font-size: 0.92em; }
  .mx-droite { display: flex; flex-direction: column; align-items: center; gap: 1.2em; }
  .mx-vue { position: relative; margin: 0; }
  .mx-vue img { position: absolute; top: 0; left: 50%; translate: -50% 0; display: block; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; opacity: 0; transition: opacity 0.35s; }
  .mx-vue img.mx-vu { opacity: 1; }
  .mx-dit { margin: 0; max-width: 16em; font-size: 1.05em; font-weight: 600; line-height: 1.35; text-align: center; color: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .mx-vue img { transition: none; } }
</style>
