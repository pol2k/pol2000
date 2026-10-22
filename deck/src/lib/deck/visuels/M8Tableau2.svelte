<script>
  /**
   * Le vrai tableau 2 de Blais et Gélineau (2007, p. 432), tel qu'imprimé,
   * en entier : un grand tableau, et la question « combien de variables se
   * lisent ? ». Le piège de la table 2, sur leur propre tableau 2.
   *
   *   0  le tableau entier : 19 variables (et les seuils, et l'ajustement);
   *   1  leur X, en quatre groupes (la référence : gagnant partout), cadré;
   *      tout le reste est un contrôle, on ne le lit pas;
   *   2  une ligne : perdre au pays et dans sa circonscription, agrandie
   *      (static/img/s8-bg-ligne.png), lue par le signe et les étoiles.
   *
   * Leur modèle est un probit ordonné (leur note 7), pas une régression
   * linéaire : on ne lit pas la taille du coefficient. Les auteurs, eux,
   * commentent certains contrôles dans leur texte; on ne le dit pas sur la
   * diapo.
   *
   * Images : outils/seance8_tableaux.sh. Cadres en % de la découpe
   * (x 86 à 448 pt, y 54 à 628 pt), depuis pdftotext -bbox.
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
  const CADRES = [
    { x: 5.5, y: 12.7, l: 90.0, h: 13.4 },
    { x: 5.5, y: 19.5, l: 90.0, h: 3.3 }
  ];
</script>

<div class="visuel m8t2" bind:this={hote}>
  <figure>
    <div class="feuille">
      <img src="{base}/img/s8-bg-tableau2.png" alt="Le tableau 2 de l’article, en anglais : deux modèles, une vingtaine de variables et leurs coefficients. Dans le modèle 2, perdre au pays et dans sa circonscription : −0,447, trois étoiles." />
      {#each CADRES as c, i}
        <span class="m8-cadre" class:on={e === i + 1} class:pale={i === 0 && e === 2} style="left: {c.x}%; top: {c.y}%; width: {c.l}%; height: {c.h}%"></span>
      {/each}
    </div>
    <figcaption>Blais et Gélineau (2007), tableau 2, p. 432</figcaption>
  </figure>

  <div class="droite">
    {#if e === 0}
      <p class="q">19 variables.<br />Combien se lisent&#8239;?</p>
    {:else if e === 1}
      <div class="bloc">
        <p class="gros"><span class="rouge">Leur X</span>&#8239;: quatre lignes (dont l’abstention)</p>
        <p class="moyen">comparées aux gagnants partout</p>
      </div>
      <div class="bloc gris">
        <p class="moyen">Tout le reste&#8239;: des contrôles.<br /><strong>On ne les lit pas.</strong></p>
      </div>
    {:else}
      <div class="zoom"><img src="{base}/img/s8-bg-ligne.png" alt="La ligne agrandie : Lose federal/lose constituency, −0,447, trois étoiles, erreur type 0,120." /></div>
      <p class="gros">Perdre au pays et chez soi&#8239;: <span class="rouge">moins satisfait</span> que les gagnants partout, après l’élection, à satisfaction égale avant.</p>
      <p class="moyen gris">Pas une régression linéaire&#8239;: on lit le signe (−) et les étoiles (***).</p>
    {/if}
  </div>
</div>

<style>
  .m8t2 { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2.2em; align-items: center; }
  figure { margin: 0; }
  .feuille { position: relative; height: 66vh; aspect-ratio: 1100 / 1744; border: 2px solid var(--dk-filet); background: #fff; }
  .feuille img { display: block; width: 100%; height: 100%; }
  .m8-cadre { position: absolute; outline: 3px solid var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .m8-cadre.on { opacity: 1; }
  .m8-cadre.pale { opacity: 0.35; outline-width: 2px; }
  figcaption { margin-top: 0.3em; color: var(--dk-gris); font-size: 0.62em; }
  .droite { display: flex; flex-direction: column; gap: 0.9em; }
  .q { margin: 0; font-size: 2em; font-weight: 700; line-height: 1.25; }
  .bloc { border-left: 6px solid var(--dk-accent); padding: 0.2em 0 0.2em 0.8em; }
  .bloc.gris { border-left-color: var(--dk-gris-2); }
  .gros { margin: 0; font-size: 1.3em; font-weight: 700; line-height: 1.3; }
  .moyen { margin: 0.2em 0 0; font-size: 1em; line-height: 1.35; }
  .gris { color: var(--dk-gris); }
  .rouge { color: var(--dk-accent); }
  .zoom { border: 4px solid var(--dk-accent); background: #fff; padding: 0.3em 0.5em; }
  .zoom img { display: block; width: 100%; height: auto; }
  @media (prefers-reduced-motion: reduce) { .m8-cadre { transition: none; } }
</style>
