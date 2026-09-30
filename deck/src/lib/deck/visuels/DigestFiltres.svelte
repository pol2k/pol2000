<script>
  /**
   * Qu'est-ce qui a mal tourné en 1936 ? Deux filtres entre la population et
   * l'échantillon du Literary Digest, puis la leçon de Gallup. Des boîtes
   * emboîtées, une par temps. Quatre temps.
   *
   *   0  La population : tous les électeurs américains.
   *   1  Premier filtre, qui est sur les listes : ses lecteurs, les
   *      propriétaires d'automobiles, les abonnés du téléphone. En 1936,
   *      surtout des gens aisés.
   *   2  Second filtre, qui répond : moins de 25 %, surtout ceux qui
   *      détestaient Roosevelt. Selon Squire (1988), c'est ce filtre-là qui a
   *      fait le plus de dégâts (la non-réponse).
   *   3  Pendant ce temps, George Gallup interroge environ 50 000 personnes
   *      choisies pour ressembler à l'électorat, et prédit Roosevelt. Le
   *      Literary Digest disparaît peu après. La leçon en une ligne.
   *
   * Sources : Squire (1988, p. 126-127) pour les listes, le taux de réponse
   * (DIGEST.taux, src/lib/data/seance5.js) et la non-réponse; l'article
   * « The Literary Digest » de Wikipédia (consulté le 30 septembre 2026) pour
   * Gallup (environ 50 000 personnes) et la fin du magazine (racheté en
   * 1938, disparu peu après).
   */
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const TAUX = Math.round(DIGEST.taux * 100);
</script>

<div class="visuel digest-filtres" bind:this={hote}>
  <svg viewBox="0 0 1000 480" role="img" aria-label="La population : tous les électeurs américains. Premier filtre, qui est sur les listes : lecteurs, automobiles, téléphone, surtout des gens aisés en 1936. Second filtre, qui répond : moins de {TAUX} %, surtout ceux qui détestaient Roosevelt. Pendant ce temps, George Gallup interroge environ 50 000 personnes choisies pour ressembler à l’électorat et prédit Roosevelt. Mieux vaut un petit échantillon bien choisi qu’un énorme échantillon biaisé.">
    <!-- 0 : la population. -->
    <rect x="20" y="20" width="620" height="340" class="df-boite df-pop" />
    <text x="40" y="54" class="df-titre">la population</text>
    <text x="40" y="80" class="df-sous">tous les électeurs américains</text>

    <!-- 1 : premier filtre. -->
    <g class="df-etape" class:df-vu={e >= 1}>
      <rect x="60" y="100" width="566" height="246" class="df-boite df-listes" />
      <text x="80" y="132" class="df-titre"><tspan class="df-num">1</tspan> qui est sur les listes</text>
      <text x="80" y="158" class="df-sous">lecteurs, automobiles, téléphone</text>
      <text x="80" y="182" class="df-sous">en 1936&#8239;: surtout des gens aisés</text>
    </g>

    <!-- 2 : second filtre. -->
    <g class="df-etape" class:df-vu={e >= 2}>
      <rect x="96" y="200" width="516" height="130" class="df-boite df-repond" />
      <text x="116" y="236" class="df-titre df-rouge"><tspan class="df-num">2</tspan> qui répond&#8239;: moins de {TAUX}&#8239;%</text>
      <text x="116" y="262" class="df-sous">surtout ceux qui détestaient Roosevelt</text>
      <text x="116" y="300" class="df-note">le filtre qui a fait le plus de dégâts (Squire, 1988)</text>
    </g>

    <!-- 3 : Gallup. -->
    <g class="df-etape" class:df-vu={e >= 3}>
      <rect x="666" y="20" width="314" height="340" class="df-boite df-gallup" />
      <text x="686" y="54" class="df-titre">George Gallup</text>
      <text x="686" y="90" class="df-g">environ</text>
      <text x="686" y="130" class="df-gros">50 000</text>
      <text x="686" y="160" class="df-g">personnes, choisies pour</text>
      <text x="686" y="184" class="df-g">ressembler à l’électorat</text>
      <text x="686" y="230" class="df-g">Il prédit&#8239;:</text>
      <text x="686" y="266" class="df-gros-2">Roosevelt</text>
      <text x="686" y="330" class="df-note">le Digest disparaît peu après</text>
      <text x="500" y="420" class="df-lecon">Mieux vaut un petit échantillon bien choisi</text>
      <text x="500" y="454" class="df-lecon">qu’un énorme échantillon biaisé.</text>
    </g>
  </svg>
</div>

<style>
  .digest-filtres { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .df-boite { stroke: var(--dk-encre); stroke-width: 2.5; }
  .df-pop { fill: var(--dk-fond); }
  .df-listes { fill: var(--dk-fond-2); }
  .df-repond { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .df-gallup { fill: var(--dk-fond-2); }
  .df-titre { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .df-rouge { fill: var(--dk-accent); }
  .df-num { fill: var(--dk-accent); }
  .df-sous { font-size: 18px; fill: var(--dk-encre); }
  .df-note { font-size: 15px; fill: var(--dk-gris); }
  .df-g { font-size: 18px; fill: var(--dk-encre); }
  .df-gros { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .df-gros-2 { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .df-lecon { font-size: 25px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .df-etape { opacity: 0; transition: opacity 0.3s; }
  .df-etape.df-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .df-etape, .df-etape.df-vu { transition: none; }
  }
</style>
