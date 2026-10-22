<script>
  /**
   * Le vrai tableau 1 de Blais et Gélineau (2007, p. 431), tel qu'imprimé :
   * la satisfaction envers la démocratie (de 0 à 1), avant et après
   * l'élection de 1997, chez les mêmes personnes (CES 1997). Sous le
   * tableau, une clé en français pour les cinq colonnes, alignée sur elles.
   *
   *   0  le tableau entier, et la clé;
   *   1  la ligne « Before » : les futurs gagnants sont déjà plus satisfaits;
   *   2  la ligne « Difference » : tout le monde monte après l'élection.
   *
   * L'image (static/img/s8-bg-tableau1.png, 1978 × 867) vient de
   * outils/seance8_tableaux.sh. Les cadres et la clé sont en % de l'image,
   * calculés depuis les boîtes de pdftotext -bbox (boîte de la découpe :
   * x 38 à 394 pt, y 54 à 210 pt) : ils suivent l'image à toutes les tailles.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // [gauche, haut, largeur, hauteur] en % de l'image.
  const CADRES = [
    { x: 5.1, y: 51.0, l: 91.0, h: 7.4 },
    { x: 5.1, y: 66.2, l: 91.0, h: 7.5 }
  ];
  // Le centre de chaque colonne, en % de la largeur.
  const CLE = [
    { x: 26.4, t: 'gagnant partout' },
    { x: 41.9, t: 'gagnant au pays seulement' },
    { x: 57.5, t: 'gagnant chez soi seulement' },
    { x: 73.1, t: 'perdant partout' },
    { x: 87.8, t: 'n’a pas voté' }
  ];
  const DITS = ['', 'Avant même l’élection, les futurs gagnants sont plus satisfaits.', 'Après l’élection, tout le monde est plus satisfait. Une « lune de miel » pour la démocratie.'];
</script>

<div class="visuel m8gl" bind:this={hote}>
  <figure>
    <div class="feuille">
      <img src="{base}/img/s8-bg-tableau1.png" alt="Le tableau 1 de l’article, en anglais : la satisfaction moyenne avant l’élection, après l’élection, la différence et le nombre de personnes, pour cinq groupes. Gagnants partout : 0,645 avant, 0,738 après. Perdants partout : 0,526 avant, 0,579 après. N’a pas voté : 0,493 avant, 0,577 après. Tous les groupes augmentent." />
      {#each CADRES as c, i}
        <span class="m8-cadre" class:on={e === i + 1} style="left: {c.x}%; top: {c.y}%; width: {c.l}%; height: {c.h}%"></span>
      {/each}
    </div>
    <div class="cle" aria-hidden="true">
      {#each CLE as c}<span style="left: {c.x}%">{c.t}</span>{/each}
    </div>
    <figcaption>Blais et Gélineau (2007), tableau 1, p. 431 · CES 1997 · satisfaction de 0 (pas du tout) à 1 (très satisfait)</figcaption>
  </figure>
  <div class="dits">
    {#each DITS as d, i}{#if i}<p class="dit" class:vu={e === i}>{d}</p>{/if}{/each}
  </div>
</div>

<style>
  .m8gl { max-width: 62em; margin: 0.2em auto 0; display: flex; flex-direction: column; gap: 0.6em; }
  figure { margin: 0 auto; width: min(100%, 98vh); }
  .feuille { position: relative; border: 2px solid var(--dk-filet); background: #fff; }
  img { display: block; width: 100%; height: auto; }
  .m8-cadre { position: absolute; outline: 4px solid var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .m8-cadre.on { opacity: 1; }
  .cle { position: relative; height: 2.3em; margin-top: 0.25em; }
  .cle span { position: absolute; transform: translateX(-50%); width: 8.5em; text-align: center; font-size: 0.62em; line-height: 1.25; color: var(--dk-encre); font-weight: 600; }
  figcaption { margin-top: 0.2em; color: var(--dk-gris); font-size: 0.66em; }
  .dits { display: grid; }
  .dit { grid-area: 1 / 1; margin: 0; padding: 0.55em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.05em; opacity: 0; transition: opacity 0.4s; }
  .dit.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m8-cadre, .dit { transition: none; } }
</style>
