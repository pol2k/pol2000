<script>
  /**
   * Le problème fondamental de l'inférence causale, en un carrefour (le
   * pont avec la séance 10, reportée par la grève). Le fil du cours : la
   * scolarité et l'intérêt pour la politique (séances 7 et 8).
   *
   *   0  Marie arrive au carrefour. Deux routes : l'université, ou pas;
   *   1  elle prend la route de l'université. Au bout, son intérêt pour la
   *      politique se remplit : 7 sur 10;
   *   2  le brouillard tombe sur l'autre route : la Marie qui n'y est pas
   *      allée n'existe pas. Sa jauge reste vide, un « ? »;
   *   3  l'effet de l'université pour Marie : 7 − ?. Le problème
   *      fondamental : on ne voit jamais les deux routes à la fois;
   *   4  alors on regarde quelqu'un d'autre sur l'autre route : Julie, 4;
   *   5  mais Julie arrive avec ses bagages (d'autres parents, un autre
   *      âge, une autre région) : l'écart de 3, c'est l'université, ou
   *      les bagages ?
   *
   * Exemple fictif : Marie, Julie et leurs chiffres n'existent pas. Le
   * brouillard dérive en boucle (CSS); tout le reste ne dépend que du temps.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const LEG = [
    'Marie arrive au carrefour.',
    'Elle va à l’université.',
    'L’autre route : personne ne la verra jamais.',
    'L’effet pour Marie : la différence entre les deux routes.',
    'Alors on regarde quelqu’un d’autre : Julie.',
    'Mais Julie arrive avec ses bagages.'
  ];
  const BAGAGES = [
    ['d’autres parents', 540, 480],
    ['un autre âge', 540, 540],
    ['une autre région', 540, 600]
  ];
</script>

{#snippet personne(classe)}
  <g class={classe}>
    <circle cx="0" cy="-96" r="17" />
    <path d="M0 -79 L0 -38 M0 -70 L-20 -50 M0 -70 L20 -50 M0 -38 L-16 0 M0 -38 L16 0" />
  </g>
{/snippet}

<div class="visuel m11c" bind:this={hote}>
  <svg viewBox="0 0 1400 640" role="img" aria-label="Marie arrive à un carrefour. Elle prend la route de l’université : son intérêt pour la politique vaut 7 sur 10. L’autre route est dans le brouillard : on ne saura jamais ce qu’elle serait devenue sans l’université. Julie, sur l’autre route, vaut 4, mais elle arrive avec d’autres parents, un autre âge, une autre région.">
    <defs>
      <filter id="m11c-flou" x="-30%" y="-60%" width="160%" height="220%"><feGaussianBlur stdDeviation="16" /></filter>
    </defs>

    <!-- les routes -->
    <path d="M 60 380 L 470 380 L 940 190" class="route" />
    <path d="M 470 380 L 900 560" class="route" />
    <path d="M 60 380 L 470 380 L 940 190" class="ligne" />
    <path d="M 470 380 L 900 560" class="ligne" />

    <!-- le panneau -->
    <g class="panneau">
      <line x1="470" y1="380" x2="470" y2="190" class="poteau" />
      <path d="M 478 206 L 700 206 L 724 228 L 700 250 L 478 250 Z" />
      <text x="596" y="236">université</text>
      <path d="M 478 262 L 700 262 L 724 284 L 700 306 L 478 306 Z" class="bas" />
      <text x="596" y="292">pas d’université</text>
    </g>

    <!-- l'université, au bout de la route du haut -->
    <g class="univ">
      <path d="M 960 96 L 1050 48 L 1140 96 Z" />
      <rect x="968" y="98" width="164" height="12" />
      {#each [982, 1018, 1054, 1090, 1116] as x (x)}<rect x={x} y="114" width="12" height="62" />{/each}
      <rect x="960" y="176" width="180" height="14" />
    </g>

    <!-- Marie -->
    <g class="marie" class:marche={e >= 1}>
      {@render personne('silh')}
      <text x="0" y="34" class="nom">Marie</text>
    </g>

    <!-- la jauge de Marie -->
    <g class="jauge" class:vu={e >= 1} transform="translate(1150 250)">
      <text x="0" y="-16" class="j-tit">intérêt</text>
      <rect x="0" y="0" width="240" height="34" class="j-cadre" />
      <rect x="0" y="0" width="168" height="34" class="j-plein" class:rempli={e >= 1} />
      <text x="254" y="28" class="j-val">7</text>
    </g>

    <!-- le brouillard sur l'autre route -->
    <g class="brouillard" class:vu={e >= 2 && e < 4} class:mince={e >= 4} filter="url(#m11c-flou)">
      <ellipse cx="640" cy="470" rx="190" ry="70" class="nuage n1" />
      <ellipse cx="820" cy="540" rx="230" ry="80" class="nuage n2" />
      <ellipse cx="1000" cy="560" rx="200" ry="70" class="nuage n3" />
      <ellipse cx="1180" cy="580" rx="200" ry="70" class="nuage n1" />
    </g>

    <!-- la Marie qui n'existe pas -->
    <g class="fantome" class:vu={e >= 2 && e < 4} transform="translate(930 560)">
      {@render personne('silh pointille')}
    </g>
    <g class="jauge" class:vu={e >= 2} transform="translate(1150 540)">
      <text x="0" y="-16" class="j-tit">intérêt</text>
      <rect x="0" y="0" width="240" height="34" class="j-cadre" class:pointille={e < 4} />
      <rect x="0" y="0" width="96" height="34" class="j-plein j-gris" class:rempli={e >= 4} />
      <text x="254" y="28" class="j-val" class:gris={e < 4}>{e >= 4 ? '4' : '?'}</text>
    </g>

    <!-- Julie et ses bagages -->
    <g class="julie" class:vu={e >= 4} transform="translate(930 560)">
      {@render personne('silh')}
      <text x="0" y="34" class="nom">Julie</text>
    </g>
    {#each BAGAGES as [t, x, y], i (t)}
      <g class="bagage" class:vu={e >= 5} style="--i: {i}">
        <line x1={x + 262} y1={y - 9} x2="906" y2="500" class="fil" />
        <text {x} {y}>{t}</text>
      </g>
    {/each}

    <!-- l'effet -->
    <g class="effet" class:vu={e >= 3}>
      <text x="1270" y="410" class="eff">{e >= 4 ? '7 − 4 = 3' : '7 − ?'}</text>
      <text x="1270" y="452" class="eff-sous">{e >= 5 ? 'l’université, ou les bagages ?' : e >= 4 ? 'un écart' : 'l’effet pour Marie'}</text>
    </g>
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="cap">Exemple fictif</p>
</div>

<style>
  .m11c { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 60vh; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .route { fill: none; stroke: var(--dk-fond-2); stroke-width: 70; stroke-linejoin: round; stroke-linecap: round; }
  .ligne { fill: none; stroke: var(--dk-filet); stroke-width: 4; stroke-dasharray: 22 18; }

  .poteau { stroke: var(--dk-encre); stroke-width: 8; }
  .panneau path { fill: var(--dk-encre); }
  .panneau path.bas { fill: var(--dk-gris); }
  .panneau text { fill: var(--dk-fond); font-size: 22px; font-weight: 600; text-anchor: middle; }

  .univ rect, .univ path { fill: var(--dk-encre); }

  .silh circle { fill: var(--dk-encre); }
  .silh path { stroke: var(--dk-encre); stroke-width: 9; stroke-linecap: round; fill: none; }
  .silh.pointille circle { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 6 5; }
  .silh.pointille path { stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 8 6; }
  .nom { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }

  .marie { transform: translate(140px, 400px); }
  .marie.marche { animation: m11c-marche 2.6s ease-in-out forwards; }
  @keyframes m11c-marche {
    0% { transform: translate(140px, 400px); }
    45% { transform: translate(470px, 400px); }
    100% { transform: translate(880px, 236px); }
  }

  .jauge, .fantome, .julie, .effet { opacity: 0; transition: opacity 0.5s; }
  .jauge.vu, .fantome.vu, .julie.vu, .effet.vu { opacity: 1; }
  .jauge.vu { transition-delay: 0.3s; }
  .j-tit { font-size: 22px; fill: var(--dk-gris); }
  .j-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .j-cadre.pointille { stroke: var(--dk-gris-2); stroke-dasharray: 8 6; }
  .j-plein { fill: var(--dk-accent); transform-box: fill-box; transform-origin: left; transform: scaleX(0); transition: transform 1s ease-out 1.6s; }
  .j-plein.rempli { transform: scaleX(1); }
  .j-plein.j-gris { fill: var(--dk-encre); transition-delay: 0.4s; }
  .j-val { font-size: 34px; font-weight: 700; fill: var(--dk-encre); }
  .j-val.gris { fill: var(--dk-gris-2); }

  .brouillard { opacity: 0; transition: opacity 1.4s; }
  .brouillard.vu { opacity: 1; }
  .brouillard.mince { opacity: 0.3; }
  .nuage { fill: #a9ada7; }
  .n1 { animation: m11c-derive 7s ease-in-out infinite alternate; }
  .n2 { animation: m11c-derive 9s ease-in-out infinite alternate-reverse; }
  .n3 { animation: m11c-derive 8s ease-in-out infinite alternate; }
  @keyframes m11c-derive { from { transform: translateX(-30px); } to { transform: translateX(40px); } }

  .bagage { opacity: 0; transform: translateX(-20px); transition: opacity 0.4s, transform 0.4s; transition-delay: calc(var(--i) * 0.25s); }
  .bagage.vu { opacity: 1; transform: none; }
  .bagage text { font-size: 24px; font-weight: 700; fill: var(--dk-accent); text-anchor: end; }
  .bagage .fil { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 4 4; }
  .bagage text { text-anchor: start; }

  .eff { font-size: 48px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .eff-sous { font-size: 24px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }

  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .marie.marche { animation: none; transform: translate(880px, 236px); }
    .nuage { animation: none; }
    .j-plein, .bagage, .brouillard, .jauge { transition: none; }
  }
</style>
