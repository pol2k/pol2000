<script>
  /**
   * Lire le vrai tableau de modelsummary (static/img/s8-tableau.png, rendu
   * par outils/seance8_data.R), celui que les étudiant.e.s viennent de
   * produire. Pas de boîte noire : l'image elle-même, et des cadres posés
   * dessus.
   *
   *   0  le tableau, seul;
   *   1  la ligne Gagnant, cadrée; la colonne « Gagnant seul » s'efface :
   *      on lit le modèle 2 (à satisfaction égale avant);
   *   2  la ligne du contrôle s'efface : on ne l'interprète pas;
   *   3  la lecture du coefficient, en français, à côté du cadre;
   *   4  le modèle 1 revient : sans le contrôle, l'écart était 0,266.
   *
   * Cadres en % de l'image (1892 × 1339 px), mesurés sur le PNG (bandes de
   * pixels foncés, PIL) : ligne Gagnant y 451 à 645 (cadre 410 à 677), contrôle y 723 à 917,
   * colonne 1 x 803 à 1135, colonne 2 x 1200 à 1858. Les nombres affichés
   * viennent de COEFS (src/lib/data/seance8.js), pas d'une saisie.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { TABLEAU, COEFS } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const terme = (m, t) => COEFS[m].find((c) => c.terme === t);
  const g1 = terme('modele1', 'gagnant');
  const g2 = terme('modele2', 'gagnant');
  // Trois décimales, virgule : comme dans le tableau (options(OutDec = ",")).
  const f = (b) => b.toFixed(3).replace('.', ',');

  // En % de l'image.
  const LIGNE = { x: 0.6, y: 30.6, l: 98.8, h: 20.0 };
  // La colonne 1 en trois morceaux, pour ne pas effacer les filets du tableau
  // (y 132 à 135, 948 à 951, 1220 à 1223 px).
  const COL1 = [
    { x: 41.2, y: 0.4, l: 20.6, h: 9.3 },
    { x: 41.2, y: 10.3, l: 20.6, h: 60.3 },
    { x: 41.2, y: 71.3, l: 20.6, h: 19.6 }
  ];
  const CONTROLE = { x: 0, y: 52.4, l: 100, h: 17.6 };
  const CELLULE1 = { x: 43.4, y: 32.2, l: 15.6, h: 16.8 };
  const pos = (c) => `left: ${c.x}%; top: ${c.y}%; width: ${c.l}%; height: ${c.h}%`;
</script>

<div class="visuel m8l" bind:this={hote}>
  <figure>
    <div class="m8l-feuille" style="aspect-ratio: {TABLEAU.l} / {TABLEAU.h}">
      <img src="{base}/img/{TABLEAU.img}" alt="Le tableau de modelsummary : Gagnant seul, 0,266 trois étoiles. À satisfaction égale avant, Gagnant 0,144 trois étoiles, satisfaction avant l’élection 0,617 trois étoiles. 11 796 et 11 632 observations." />
      {#each COL1 as c}<span class="m8l-voile" class:on={e >= 1 && e < 4} style={pos(c)}></span>{/each}
      <span class="m8l-voile" class:on={e >= 2} style={pos(CONTROLE)}></span>
      <span class="m8l-cadre" class:on={e >= 1} style={pos(LIGNE)}></span>
      <span class="m8l-cadre m8l-c1" class:on={e >= 4} style={pos(CELLULE1)}></span>
      <svg class="m8l-fleche" class:on={e >= 4} viewBox="0 0 {TABLEAU.l} {TABLEAU.h}" aria-hidden="true">
        <line x1="1125" y1="480" x2="1365" y2="480" />
        <path d="M 1340 458 L 1378 480 L 1340 502" />
      </svg>
    </div>
    <figcaption>CES 2025 · Y = satisfaction envers la démocratie après l’élection (0 à 1)</figcaption>
  </figure>

  <div class="m8l-marge">
    {#if e >= 3}
      <div class="m8l-lecture">
        <p class="m8l-b">{f(g2.b)}<span class="m8l-et">{g2.etoiles}</span></p>
        <p class="m8l-phrase">À satisfaction égale avant l’élection, les gagnants sont {f(g2.b)} plus satisfaits que les perdants (échelle de 0 à 1).</p>
        <p class="m8l-sig">{g2.etoiles}&#8239;: significatif</p>
      </div>
    {/if}
    {#if e >= 2}
      <p class="m8l-ctrl">Contrôle&#8239;: on ne l’interprète pas</p>
    {/if}
    {#if e >= 4}
      <p class="m8l-avant">Sans le contrôle&#8239;: {f(g1.b)}</p>
    {/if}
  </div>
</div>

<style>
  .m8l { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 1.6em; align-items: start; }
  figure { margin: 0; }
  .m8l-feuille { position: relative; height: 23em; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; }
  .m8l-feuille img { display: block; width: 100%; height: 100%; }
  .m8l-cadre { position: absolute; outline: 4px solid var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .m8l-cadre.on { opacity: 1; }
  .m8l-c1 { outline-width: 3px; outline-style: dashed; }
  .m8l-voile { position: absolute; background: #fff; opacity: 0; transition: opacity 0.4s; }
  .m8l-voile.on { opacity: 0.8; }
  .m8l-fleche { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 0.4s; }
  .m8l-fleche.on { opacity: 1; }
  .m8l-fleche line, .m8l-fleche path { fill: none; stroke: var(--dk-accent); stroke-width: 7; }
  figcaption { margin-top: 0.75em; color: var(--dk-gris); font-size: 0.62em; }

  /* La marge : les lectures, à la hauteur des lignes qu'elles commentent. */
  .m8l-marge { position: relative; height: 23em; }
  .m8l-marge > * { position: absolute; left: 0; right: 0; margin: 0; animation: m8l-entre 0.4s ease-out both; }
  .m8l-lecture { bottom: 50%; border-left: 6px solid var(--dk-accent); padding: 0.1em 0 0.1em 0.8em; }
  .m8l-b { margin: 0; font-size: 2.2em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
  .m8l-et { font-size: 0.6em; vertical-align: 0.5em; margin-left: 0.1em; }
  .m8l-phrase { margin: 0.4em 0 0; font-size: 0.95em; line-height: 1.35; font-weight: 600; }
  .m8l-sig { margin: 0.35em 0 0; font-size: 0.8em; color: var(--dk-gris); }
  .m8l-ctrl { top: 56%; font-size: 0.8em; color: var(--dk-gris); border-left: 6px solid var(--dk-gris-2); padding-left: 0.8em; }
  .m8l-avant { top: 73%; font-size: 0.9em; font-weight: 600; border-left: 6px dashed var(--dk-accent); padding-left: 0.8em; }
  @keyframes m8l-entre { from { opacity: 0; transform: translateX(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m8l-cadre, .m8l-voile, .m8l-fleche { transition: none; }
    .m8l-marge > * { animation: none; }
  }
</style>
