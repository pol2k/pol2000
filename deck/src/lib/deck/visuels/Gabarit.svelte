<script>
  /**
   * Le gabarit d’un article scientifique : un seul document, huit sections,
   * toujours dans le même ordre. Ce qu’on apprend aujourd’hui, décrire une
   * variable, se fait dans une section précise : « Données et méthodes ».
   *
   *   0  La page et ses huit sections numérotées, de haut en bas.
   *   1  La section 5, « Données et méthodes », passe au rouge, les sept
   *      autres s’effacent. « Vous êtes ici. »
   *   2  La section 5 s’ouvre : un panneau se déplie à droite, avec trois
   *      pictogrammes (la forme, le centre, la dispersion) et la phrase de
   *      clôture en rouge.
   *
   * Les sections arrivent l’une après l’autre quand la diapositive entre à
   * l’écran (IntersectionObserver), mais l’état de repos est complet sans
   * cette animation. Les trois pictogrammes sont des schémas à tracés
   * fixes, aucune donnée, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  const SECTIONS = [
    'Introduction',
    'Question de recherche',
    'Revue de littérature',
    'Hypothèses',
    'Données et méthodes',
    'Résultats',
    'Discussion',
    'Conclusion'
  ];
  const ICI = 4; // rang de « Données et méthodes »
  const Y0 = 30, PAS = 51, H = 43;
  const Y_ICI = Y0 + ICI * PAS;
  const MI = Y_ICI + H / 2;

  /* Pictogrammes : hauteurs et positions fixes. */
  const BARRES = [18, 42, 74, 100, 70, 40, 20];
  /* [décalage, nombre de carrés empilés] : la pile s’équilibre sur le pivot. */
  const POIDS = [[-61, 1], [-39, 2], [-17, 3], [5, 2], [27, 1], [49, 1]];
  const POINTS = [-62, -30, -12, 4, 20, 62];

  let e = $state(0);
  let hote = $state(null);
  let joue = $state(false);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  /* L’arrivée des sections se rejoue chaque fois que la figure entre à l’écran. */
  $effect(() => {
    if (!hote || typeof IntersectionObserver === 'undefined') return;
    const obs = new IntersectionObserver((vus) => (joue = vus[vus.length - 1].isIntersecting));
    obs.observe(hote);
    return () => obs.disconnect();
  });
</script>

<div class="visuel gb-fig" bind:this={hote}>
  <svg
    class="gb-scene"
    class:gb-joue={joue}
    viewBox="0 0 1000 484"
    role="img"
    aria-label="Une page d’article scientifique découpée en huit sections numérotées, de haut en bas&#8239;: introduction, question de recherche, revue de littérature, hypothèses, données et méthodes, résultats, discussion, conclusion. La section 5, données et méthodes, est en rouge&#8239;: vous êtes ici. Elle s’ouvre sur trois pictogrammes&#8239;: la forme, le centre, la dispersion."
  >
    <!-- ——— La page : un seul document ——— -->
    <path d="M 20 8 H 394 L 410 24 V 446 H 20 Z" class="gb-page" />
    <path d="M 394 8 V 24 H 410" class="gb-pli" />

    {#each SECTIONS as nom, i}
      {@const y = Y0 + i * PAS}
      <g class="gb-rang" class:gb-loin={e >= 1 && i !== ICI} class:gb-ici={e >= 1 && i === ICI}>
        <g class="gb-pose" style="--k: {i}">
          <rect x="34" y={y} width="358" height={H} class="gb-case" />
          <line x1="78" y1={y} x2="78" y2={y + H} class="gb-sep" />
          <text x="56" y={y + 30} class="gb-num">{i + 1}</text>
          <text x="92" y={y + 30} class="gb-nom">{nom}</text>
        </g>
      </g>
    {/each}

    <text x="20" y="474" class="gb-legende">le gabarit d’un article scientifique</text>

    <!-- ——— La section 5 s’ouvre ——— -->
    {#if e >= 2}
      <path d="M 392 {Y_ICI} L 470 30 M 392 {Y_ICI + H} L 470 340" pathLength="1" class="gb-zoom" />
      <g class="gb-panneau">
        <rect x="470" y="30" width="515" height="310" class="gb-cadre" />

        <!-- la forme : un mini histogramme -->
        <g transform="translate(552 0)">
          {#each BARRES as h, k}
            <rect x={-66 + k * 19} y={226 - h} width="16" height={h} class="gb-plein gb-pop" style="--j: {k}" />
          {/each}
          <line x1="-74" y1="228" x2="74" y2="228" class="gb-trait" />
          <text x="0" y="300" class="gb-mot">la forme</text>
        </g>

        <!-- le centre : un point d’équilibre -->
        <g transform="translate(718 0)">
          {#each POIDS as [dx, n], k}
            {#each Array.from({ length: n }) as _, m}
              <rect x={dx} y={208 - m * 21} width="18" height="18" class="gb-plein gb-pop" style="--j: {k}" />
            {/each}
          {/each}
          <line x1="-74" y1="228" x2="74" y2="228" class="gb-trait" />
          <path d="M 0 232 L 17 262 H -17 Z" class="gb-pivot" />
          <text x="0" y="300" class="gb-mot">le centre</text>
        </g>

        <!-- la dispersion : une double flèche -->
        <g transform="translate(884 0)">
          {#each POINTS as dx, k}
            <rect x={dx - 7} y="176" width="14" height="14" class="gb-plein gb-pop" style="--j: {k}" />
          {/each}
          <path d="M -66 228 H 66 M -50 216 L -68 228 L -50 240 M 50 216 L 68 228 L 50 240" class="gb-etendue" />
          <text x="0" y="300" class="gb-mot">la dispersion</text>
        </g>
      </g>

      <g class="gb-fin">
        <text x="470" y="390" class="gb-fin-t">On y décrit ses données,</text>
        <text x="470" y="424" class="gb-fin-t">pour être le plus transparent possible.</text>
      </g>
    {/if}

    <!-- ——— Vous êtes ici : à côté de la section, puis en tête du panneau.
         Dessiné après le panneau, sinon le cadre le recouvre. ——— -->
    {#if e >= 1}
      <g class="gb-repere">
        {#if e === 1}
          <g class="gb-fleche">
            <path d="M 540 {MI} H 424 M 442 {MI - 13} L 422 {MI} L 442 {MI + 13}" class="gb-fleche-t" />
          </g>
        {/if}
        <g class="gb-ici-g" class:gb-monte={e >= 2}>
          <text x="556" y={MI + 9} class="gb-ici-t">vous êtes ici</text>
        </g>
      </g>
    {/if}
  </svg>
</div>

<style>
  .gb-fig { display: flex; justify-content: center; }
  .gb-scene { width: 100%; max-height: 60vh; display: block; overflow: visible; }
  .gb-scene text { font-family: var(--dk-mono); }

  /* La page. */
  .gb-page { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .gb-pli { fill: none; stroke: var(--dk-encre); stroke-width: 4; }

  /* Les huit sections. L’effacement vit sur le groupe extérieur, l’arrivée
     sur le groupe intérieur : l’un ne bloque pas l’autre. */
  .gb-rang { opacity: 1; transition: opacity 0.4s; }
  .gb-rang.gb-loin { opacity: 0.3; }
  .gb-case { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: fill 0.35s, stroke 0.35s; }
  .gb-sep { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.35s; }
  .gb-num { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.35s; }
  .gb-nom { font-size: 22px; font-weight: 500; fill: var(--dk-encre); transition: fill 0.35s; }
  .gb-ici .gb-case { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .gb-ici .gb-sep { stroke: var(--dk-fond); }
  .gb-ici .gb-num, .gb-ici .gb-nom { fill: var(--dk-fond); font-weight: 600; }
  .gb-joue .gb-pose { animation: gb-arrive 0.32s ease-out both; animation-delay: calc(var(--k) * 90ms + 300ms); }

  .gb-legende { font-size: 19px; letter-spacing: 0.04em; fill: var(--dk-gris); }

  /* Vous êtes ici. */
  .gb-repere { animation: gb-parait 0.35s ease-out 0.2s both; }
  .gb-fleche { animation: gb-pousse 1.2s ease-in-out 0.6s infinite; }
  .gb-fleche-t { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; }
  .gb-ici-g { transition: transform 0.5s cubic-bezier(0.45, 0, 0.3, 1); }
  .gb-ici-g.gb-monte { transform: translate(-66px, -190px); }
  .gb-ici-t { font-size: 26px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; fill: var(--dk-accent); }

  /* Le panneau qui se déplie. */
  .gb-zoom { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 0; animation: gb-trace 0.4s ease-out both; }
  .gb-panneau { transform-box: fill-box; transform-origin: 0% 50%; animation: gb-ouvre 0.45s ease-out 0.25s both; }
  .gb-cadre { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .gb-plein { fill: var(--dk-encre); }
  .gb-pop { transform-box: fill-box; transform-origin: 50% 100%; animation: gb-pop 0.35s ease-out both; animation-delay: calc(var(--j) * 40ms + 650ms); }
  .gb-trait { stroke: var(--dk-encre); stroke-width: 4; }
  .gb-pivot { fill: var(--dk-accent); }
  .gb-etendue { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; }
  .gb-mot { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .gb-fin { animation: gb-parait 0.4s ease-out 1.1s both; }
  .gb-fin-t { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }

  @keyframes gb-arrive { from { opacity: 0; transform: translateX(-16px); } to { opacity: 1; transform: none; } }
  @keyframes gb-parait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes gb-pousse { 0%, 100% { transform: translateX(0); } 50% { transform: translateX(-8px); } }
  @keyframes gb-trace { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes gb-ouvre { from { opacity: 0; transform: scaleX(0.15); } to { opacity: 1; transform: none; } }
  @keyframes gb-pop { from { transform: scaleY(0); } to { transform: scaleY(1); } }

  @media (prefers-reduced-motion: reduce) {
    .gb-joue .gb-pose, .gb-repere, .gb-fleche, .gb-zoom, .gb-panneau, .gb-pop, .gb-fin { animation: none; }
    .gb-rang, .gb-case, .gb-sep, .gb-num, .gb-nom, .gb-ici-g { transition: none; }
  }
</style>
