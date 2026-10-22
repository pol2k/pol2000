<script>
  /**
   * Faire mieux : lire le tableau à deux colonnes (static/img/s8-tableau3.png,
   * rendu par outils/seance8_data.R) : leur modèle, puis le même avec
   * gagnant_2021 (leur note 1). On ne lit que la ligne Gagnant.
   *
   *   0  le tableau, seul;
   *   1  la ligne Gagnant, cadrée, et la flèche d'une colonne à l'autre;
   *   2  les contrôles s'effacent : on ne les interprète pas;
   *   3  la lecture, en français. Sur les mêmes personnes, leur modèle donne
   *      presque la même chose : la baisse vient du contrôle, pas des
   *      personnes perdues (modele2_meme);
   *   4  ce que ça dit de leur note 1.
   *
   * Cadres en % de l'image (1697 × 1611 px), mesurés sur le PNG (bandes de
   * pixels foncés, PIL) : ligne Gagnant y 451 à 645 (cadre 410 à 677),
   * contrôles y 723 à 1188, colonne 1 x 802 à 1123, colonne 2 x 1190 à 1656.
   * Les nombres viennent de COEFS (src/lib/data/seance8.js).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { TABLEAU3 as T, COEFS } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const terme = (m, t) => COEFS[m].find((c) => c.terme === t);
  const g2 = terme('modele2', 'gagnant');
  const g3 = terme('modele3', 'gagnant');
  const gm = terme('modele2_meme', 'gagnant');
  const f = (b) => b.toFixed(3).replace('.', ',');
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');

  const LIGNE = { x: 0.6, y: 25.4, l: 98.8, h: 16.6 };
  const CONTROLES = { x: 0, y: 43.2, l: 100, h: 31.2 };
  const pos = (c) => `left: ${c.x}%; top: ${c.y}%; width: ${c.l}%; height: ${c.h}%`;
</script>

<div class="visuel m8l3" bind:this={hote}>
  <figure>
    <div class="m8l3-feuille" style="aspect-ratio: {T.l} / {T.h}">
      <img src="{base}/img/{T.img}" alt="Le tableau de modelsummary : leur modèle, Gagnant 0,144 trois étoiles; avec gagnant en 2021, Gagnant 0,122 trois étoiles. 11 632 et 10 046 observations." />
      <span class="m8l3-voile" class:on={e >= 2} style={pos(CONTROLES)}></span>
      <span class="m8l3-cadre" class:on={e >= 1} style={pos(LIGNE)}></span>
      <svg class="m8l3-fleche" class:on={e >= 1} viewBox="0 0 {T.l} {T.h}" aria-hidden="true">
        <line x1="1090" y1="480" x2="1280" y2="480" />
        <path d="M 1256 458 L 1294 480 L 1256 502" />
      </svg>
    </div>
    <figcaption>CES 2025 · Y = satisfaction envers la démocratie après l’élection (0 à 1)</figcaption>
  </figure>

  <div class="m8l3-marge">
    {#if e >= 1}
      <p class="m8l3-b"><span class="m8l3-pale">{f(g2.b)}</span> → {f(g3.b)}<span class="m8l3-et">{g3.etoiles}</span></p>
    {/if}
    {#if e >= 3}
      <div class="m8l3-lecture">
        <p class="m8l3-phrase">À satisfaction égale avant l’élection et à vote de 2021 égal, les gagnants sont {f(g3.b)} plus satisfaits que les perdants.</p>
        <p class="m8l3-memes">Sur les mêmes {nb(COEFS.n.modele3)} personnes, leur modèle donne {f(gm.b)}&#8239;: la baisse vient du contrôle.</p>
      </div>
    {/if}
    {#if e >= 2}
      <p class="m8l3-ctrl">Contrôles&#8239;: on ne les interprète pas</p>
    {/if}
    {#if e >= 4}
      <div class="m8l3-note">
        <span class="m8l3-eti">Leur note 1</span>
        <p>La satisfaction avant ne capte pas tout. Leur conclusion, elle, tient.</p>
      </div>
    {/if}
  </div>
</div>

<style>
  .m8l3 { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 1.6em; align-items: start; }
  figure { margin: 0; }
  .m8l3-feuille { position: relative; height: 23em; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; }
  .m8l3-feuille img { display: block; width: 100%; height: 100%; }
  .m8l3-cadre { position: absolute; outline: 4px solid var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .m8l3-cadre.on { opacity: 1; }
  .m8l3-voile { position: absolute; background: #fff; opacity: 0; transition: opacity 0.4s; }
  .m8l3-voile.on { opacity: 0.8; }
  .m8l3-fleche { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; transition: opacity 0.4s 0.2s; }
  .m8l3-fleche.on { opacity: 1; }
  .m8l3-fleche line, .m8l3-fleche path { fill: none; stroke: var(--dk-accent); stroke-width: 7; }
  figcaption { margin-top: 0.75em; color: var(--dk-gris); font-size: 0.62em; }

  .m8l3-marge { position: relative; height: 23em; }
  .m8l3-marge > * { position: absolute; left: 0; right: 0; margin: 0; animation: m8l3-entre 0.4s ease-out both; }
  .m8l3-b { top: 22%; font-size: 2.1em; font-weight: 700; line-height: 1; color: var(--dk-accent); border-left: 6px solid var(--dk-accent); padding-left: 0.4em; }
  .m8l3-pale { color: var(--dk-gris-2); }
  .m8l3-et { font-size: 0.6em; vertical-align: 0.5em; margin-left: 0.1em; }
  .m8l3-lecture { top: 38%; border-left: 6px solid var(--dk-accent); padding-left: 0.8em; }
  .m8l3-phrase { margin: 0; font-size: 0.92em; line-height: 1.35; font-weight: 600; }
  .m8l3-memes { margin: 0.4em 0 0; font-size: 0.75em; line-height: 1.35; color: var(--dk-gris); }
  .m8l3-ctrl { top: 70%; font-size: 0.8em; color: var(--dk-gris); border-left: 6px solid var(--dk-gris-2); padding-left: 0.8em; }
  .m8l3-note { top: 80%; background: var(--dk-fond); border: 2px solid var(--dk-encre); border-left: 8px solid var(--dk-accent); padding: 0.5em 0.8em; }
  .m8l3-note p { margin: 0.25em 0 0; font-size: 0.85em; line-height: 1.35; font-weight: 600; }
  .m8l3-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  @keyframes m8l3-entre { from { opacity: 0; transform: translateX(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m8l3-cadre, .m8l3-voile, .m8l3-fleche { transition: none; }
    .m8l3-marge > * { animation: none; }
  }
</style>
