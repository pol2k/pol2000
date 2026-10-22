<script>
  /**
   * « Ils y avaient pensé » : la vraie note 1 de Blais et Gélineau (2007,
   * p. 439), découpée du PDF (outils/seance8_tableaux.sh,
   * static/img/s8-bg-note1.png). L'élection précédente pourrait compter;
   * ils ne la contrôlent pas, pour deux raisons. Ce qu'on en fait en 2025.
   *
   *   0  la note, seule;
   *   1  l'idée (en gris) : perdre deux fois de suite rend plus critique;
   *   2  raison 1 (rouge) : la satisfaction avant « capte » déjà l'élection
   *      précédente. En 2025, on peut le tester;
   *   3  raison 2 (rouge) : le souvenir du vote est douteux. Vrai aussi en
   *      2025.
   *
   * Cadres en % de la découpe (x 38 à 396 pt, y 335 à 408 pt), depuis
   * pdftotext -bbox, une boîte par ligne.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const IDEE = [[4.2, 27.3, 94.3, 9.3], [4.2, 38.9, 94.3, 9.3], [4.2, 50.5, 50.2, 9.3]];
  const R1 = [[54.8, 50.5, 43.7, 9.3], [4.2, 62.2, 82.8, 9.3]];
  const R2 = [[87.4, 62.2, 11.1, 9.3], [4.2, 73.8, 94.3, 9.3], [4.2, 85.4, 39.2, 9.3]];
  const pos = ([x, y, l, h]) => `left: ${x - 0.3}%; top: ${y - 0.8}%; width: ${l + 0.6}%; height: ${h + 1.6}%`;
</script>

<div class="visuel m8n1" bind:this={hote}>
  <figure>
    <div class="m8n1-feuille">
      <img src="{base}/img/s8-bg-note1.png" alt="La note 1 de l’article, en anglais : l’élection précédente pourrait influencer la satisfaction; leur modèle contrôle déjà la satisfaction avant l’élection, qui capte cette influence; et le souvenir du vote passé est peu fiable (Himmelweit et al., 1978)." />
      {#each IDEE as r, j}<span class="m8n1-surl m8n1-encre" class:on={e >= 1} style="{pos(r)}; --d: {j * 0.12}s"></span>{/each}
      {#each R1 as r, j}<span class="m8n1-surl" class:on={e >= 2} style="{pos(r)}; --d: {j * 0.12}s"></span>{/each}
      {#each R2 as r, j}<span class="m8n1-surl" class:on={e >= 3} style="{pos(r)}; --d: {j * 0.12}s"></span>{/each}
      <span class="m8n1-tag" class:on={e >= 2} style="top: {R1[0][1] + 4.6}%">1</span>
      <span class="m8n1-tag" class:on={e >= 3} style="top: {R2[1][1] + 4.6}%">2</span>
    </div>
    <figcaption>Blais et Gélineau (2007), <em>Political Studies</em>, 55(2), p. 439, note 1</figcaption>
  </figure>

  <div class="m8n1-cartes">
    <div class="m8n1-carte m8n1-gris" class:on={e >= 1}>
      <span class="m8n1-eti">L’idée</span>
      <p>L’élection d’avant pourrait compter&#8239;: perdre deux fois de suite rend plus critique.</p>
    </div>
    <div class="m8n1-carte" class:on={e >= 2}>
      <span class="m8n1-eti"><b>1</b> Leur raison</span>
      <p>La satisfaction avant l’élection la «&#8239;capte&#8239;» déjà.</p>
      <p class="m8n1-nous">En 2025, on peut le tester.</p>
    </div>
    <div class="m8n1-carte" class:on={e >= 3}>
      <span class="m8n1-eti"><b>2</b> Leur raison</span>
      <p>Le souvenir du vote passé est douteux.</p>
      <p class="m8n1-nous">Vrai aussi en 2025.</p>
    </div>
  </div>
</div>

<style>
  .m8n1 { max-width: 62em; margin: 0.6em auto 0; display: flex; flex-direction: column; gap: 1.1em; }
  figure { margin: 0 0 0 2.2em; }
  .m8n1-feuille { position: relative; aspect-ratio: 1400 / 286; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0.4em; }
  .m8n1-feuille img { display: block; width: 100%; height: 100%; }
  figcaption { margin-top: 0.8em; color: var(--dk-gris); font-size: 0.6em; }
  .m8n1-surl { position: absolute; background: rgba(198, 16, 46, 0.24); mix-blend-mode: multiply; transform: scaleX(0); transform-origin: left center; transition: transform 0.2s; }
  .m8n1-surl.on { transform: scaleX(1); transition: transform 0.45s ease-out var(--d); }
  .m8n1-encre { background: rgba(20, 20, 20, 0.13); }
  .m8n1-tag { position: absolute; left: -0.5em; transform: translate(-100%, -50%); font-size: 0.75em; font-weight: 700; line-height: 1; padding: 0.3em 0.55em; color: var(--dk-fond); background: var(--dk-accent); opacity: 0; transition: opacity 0.35s 0.3s; }
  .m8n1-tag.on { opacity: 1; }

  .m8n1-cartes { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .m8n1-carte { border-top: 6px solid var(--dk-accent); padding-top: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s 0.35s, transform 0.4s 0.35s; }
  .m8n1-carte.on { opacity: 1; transform: none; }
  .m8n1-gris { border-top-color: var(--dk-gris-2); }
  .m8n1-carte p { margin: 0.35em 0 0; font-size: 0.95em; line-height: 1.4; }
  .m8n1-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n1-eti b { color: var(--dk-fond); background: var(--dk-accent); padding: 0.1em 0.45em; margin-right: 0.3em; }
  .m8n1-nous { font-weight: 700; color: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) {
    .m8n1-surl, .m8n1-surl.on, .m8n1-tag, .m8n1-carte { transition: none; }
  }
</style>
