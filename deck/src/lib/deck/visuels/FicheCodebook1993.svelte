<script>
  /**
   * Lire une entrée du codebook, sur la vraie page : l'entrée cpsg1 (la TPS)
   * du codebook de l'Étude électorale canadienne de 1993, p. 37. Quatre
   * temps, un cadre rouge à la fois :
   *
   *   1  le nom : ce qu'on tape dans R;
   *   2  la question : mot pour mot;
   *   3  les codes : ce que chaque chiffre veut dire;
   *   4  les codes pièges : 8 et 9, qui ne sont pas des opinions.
   *
   * L'image (static/img/codebook-1993-cpsg1.png, 1075 × 696) est rendue par
   * Ghostscript à 300 ppp depuis ces1993-codebook.pdf, p. 37, recadrée sur
   * x 28–286 pt, y 62–229 pt. Les cadres ci-dessous viennent des boîtes des
   * mots (pdftotext -bbox-layout), marge de 3 pt, en % de ce recadrage :
   * ils suivent l'image à toutes les tailles d'écran.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  // [gauche, haut, largeur, hauteur] en % de l'image; étiquette; précision.
  const PARTIES = [
    { x: 1.9, y: 4.5, l: 12.9, h: 7.9, et: 'LE NOM', txt: ['Ce qu’on tape dans R.'] },
    { x: 4.2, y: 18.9, l: 92.7, h: 29.5, et: 'LA QUESTION', txt: ['Ce qu’on a demandé, mot pour mot.'] },
    { x: 16.1, y: 54.8, l: 33.2, h: 29.5, et: 'LES CODES', txt: ['Ce que chaque chiffre veut dire.'] },
    { x: 16.1, y: 90.7, l: 51.8, h: 8.0, et: 'LES CODES PIÈGES', txt: ['8 = ne sait pas', '9 = refus', 'Pas des opinions.'] }
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel fiche93" bind:this={hote}>
  <figure class="page">
    <div class="cliche">
      <img src="{base}/img/codebook-1993-cpsg1.png" alt="Entrée cpsg1 du codebook de l'Étude électorale canadienne de 1993 : la question sur la TPS, les codes 1 très favorable, 3 plutôt favorable, 5 plutôt opposé, 7 très opposé, 8 ne sait pas, 9 refus." />
      {#each PARTIES as p, i}
        <span class="boite" class:on={e === i + 1} style="left: {p.x}%; top: {p.y}%; width: {p.l}%; height: {p.h}%"></span>
      {/each}
    </div>
    <figcaption>Étude électorale canadienne 1993 · codebook, p. 37</figcaption>
  </figure>

  <div class="legende">
    {#if e === 0}
      <span class="et">UNE ENTRÉE DU CODEBOOK</span>
      <p>Quatre choses à trouver, chaque fois.</p>
    {:else}
      {#key e}
        <div class="bloc">
          <span class="et">{e} / 4 · {PARTIES[e - 1].et}</span>
          {#each PARTIES[e - 1].txt as ligne}<p>{ligne}</p>{/each}
        </div>
      {/key}
    {/if}
  </div>
</div>

<style>
  .fiche93 { display: grid; grid-template-columns: 1.7fr 1fr; gap: 1.6em; align-items: center; }
  .page { margin: 0; display: flex; flex-direction: column; gap: 0.4em; width: min(100%, calc(64vh * 1075 / 696)); }
  /* Le filet est un outline : une bordure sur l'image décalerait les cadres. */
  .cliche { position: relative; aspect-ratio: 1075 / 696; width: 100%; outline: 3px solid var(--dk-encre); background: #fff; }
  .cliche img { display: block; width: 100%; height: 100%; }
  .boite { position: absolute; border: 5px solid var(--dk-accent); opacity: 0; transform: scale(1.06); transition: opacity 0.3s, transform 0.3s; pointer-events: none; }
  .boite.on { opacity: 1; transform: none; }
  figcaption { font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); align-self: flex-end; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .bloc { display: flex; flex-direction: column; gap: 0.4em; animation: fondu 0.4s both; }
  .et { font-size: 0.65em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.4em; line-height: 1.35; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .bloc { animation: none; } .boite { transition: none; } }
</style>
