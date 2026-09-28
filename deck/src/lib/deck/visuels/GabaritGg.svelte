<script>
  /**
   * Le gabarit de ggplot2, en cinq temps, comme l'anatomie d'une ligne de R
   * (Anatomie.svelte) : un seul modèle, très grand, dont une partie
   * s'allume à la fois.
   *
   *   0  Le gabarit entier : trois blancs à remplir.
   *   1  <DONNÉES> : quel tableau.
   *   2  aes(<CORRESPONDANCES>) : quelle variable va où.
   *   3  <GEOM>() : quelle forme ; et le + qui ajoute une couche.
   *   4  Le gabarit rempli, dessous, avec les variables de la séance :
   *      les trois parties remplies sont soulignées en rouge.
   *
   * Aucun nombre. Le gabarit suit Wickham, Çetinkaya-Rundel et Grolemund
   * (2023), R for Data Science, 2e éd., chap. 1.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const G = [
    { et: 'LE GABARIT', mots: 'trois blancs à remplir' },
    { et: 'LES DONNÉES', mots: 'quel tableau ?' },
    { et: 'LES CORRESPONDANCES', mots: 'quelle variable va où : x, y, couleur' },
    { et: 'LA GÉOMÉTRIE', mots: 'quelle forme : points, barres, lignes' }
  ];

  // Le gabarit rempli, en morceaux : 1, 2, 3 sont les blancs remplis.
  const REMPLI = [
    ['ggplot(', 0],
    ['df_clean', 1],
    [', ', 0],
    ['aes(x = age, y = gauche_droite)', 2],
    [') +\n  ', 0],
    ['geom_point()', 3]
  ].map(([t, k]) => ({ html: surlignerR(t), k }));
</script>

<div class="visuel gabarit-gg" bind:this={hote}>
  <pre class="gt-modele"><span class="gt-fn">ggplot</span>(data = <span class="gt-p" class:gt-on={e === 1}><span class="gt-blanc">&lt;DONNÉES&gt;</span></span>, <span class="gt-p" class:gt-on={e === 2}><span class="gt-fn">aes</span>(<span class="gt-blanc">&lt;CORRESPONDANCES&gt;</span>)</span>) <span class="gt-p" class:gt-on={e === 3}>+</span>
  <span class="gt-p" class:gt-on={e === 3}><span class="gt-blanc">&lt;GEOM&gt;</span>()</span></pre>

  <!-- Toutes les légendes dans la même case : la hauteur ne bouge pas d'un temps à l'autre. -->
  <div class="gt-bas">
    {#each G as g, i}
      <div class="gt-legende" class:gt-vu={e === i}>
        <div class="gt-rang">
          <span class="gt-et">{g.et}</span>
          <span class="gt-mots">{g.mots}</span>
        </div>
        {#if i === 3}
          <div class="gt-rang">
            <span class="gt-et">LE +</span>
            <span class="gt-mots">ajoute une couche</span>
          </div>
        {/if}
      </div>
    {/each}
    <div class="gt-legende" class:gt-vu={e === 4}>
      <span class="gt-et">REMPLI</span>
      <pre class="gt-rempli">{#each REMPLI as m}{#if m.k}<span class="gt-r">{@html m.html}</span>{:else}{@html m.html}{/if}{/each}</pre>
    </div>
  </div>

  <span class="gt-source">Wickham, Çetinkaya-Rundel et Grolemund (2023), <i>R for Data Science</i>, 2e éd., chap. 1</span>
</div>

<style>
  .gabarit-gg { display: flex; flex-direction: column; gap: 0.9em; align-items: flex-start; }
  .gt-modele { margin: 0; font-family: var(--dk-mono); font-size: 1.75em; font-weight: 500; line-height: 1.5; letter-spacing: -0.01em; white-space: pre; border: 3px solid var(--dk-encre); padding: 0.4em 0.6em; width: 100%; box-sizing: border-box; overflow: hidden; color: var(--dk-encre); }
  .gt-fn { font-weight: 600; }
  .gt-blanc { color: var(--dk-gris); transition: color 0.3s; }
  .gt-p { padding: 0.02em 0; transition: color 0.3s, background 0.3s; text-decoration: underline; text-decoration-color: var(--dk-fond); text-decoration-thickness: 0.08em; text-underline-offset: 0.18em; }
  .gt-p.gt-on { color: var(--dk-accent); background: var(--dk-fond-2); text-decoration-color: var(--dk-accent); }
  .gt-p.gt-on .gt-blanc { color: var(--dk-accent); }

  .gt-bas { display: grid; width: 100%; }
  .gt-legende { grid-area: 1 / 1; display: flex; flex-direction: column; gap: 0.6em; visibility: hidden; opacity: 0; transform: translateY(0.3em); transition: opacity 0.35s, transform 0.35s, visibility 0s 0.35s; }
  .gt-legende.gt-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.35s, transform 0.35s; }
  .gt-rang { display: flex; flex-direction: column; gap: 0.2em; }
  .gt-et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .gt-mots { font-size: 1.3em; line-height: 1.35; color: var(--dk-encre); }

  .gt-rempli { margin: 0; font-family: var(--dk-mono); font-size: 1.4em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.24em solid var(--dk-accent); padding: 0.35em 0.7em; color: var(--dk-encre); align-self: flex-start; }
  .gt-r { text-decoration: underline; text-decoration-color: var(--dk-accent); text-decoration-thickness: 0.1em; text-underline-offset: 0.2em; }

  .gt-source { font-size: 0.55em; color: var(--dk-gris); letter-spacing: 0.02em; }

  @media (prefers-reduced-motion: reduce) {
    .gt-blanc, .gt-p, .gt-legende, .gt-legende.gt-vu { transition: none; }
  }
</style>
