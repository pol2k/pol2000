<script>
  /**
   * L'effet causal contre l'information statistique (Arel-Bundock 2021,
   * p. 118-120), avec l'exemple du cours de 2024 : la température, le
   * mercure du thermomètre et les ventes de crème glacée.
   *
   *   0  les jours de juillet défilent : le soleil grossit et rapetisse, le
   *      mercure et les ventes montent et descendent ensemble;
   *   1  observer : je lis le mercure, je devine les ventes. Une flèche
   *      rouge à deux pointes entre les deux : l'information circule;
   *   2  intervenir : on fige le soleil et on chauffe le thermomètre au
   *      briquet. Le mercure grimpe, les ventes ne bougent pas : le mercure
   *      ne cause pas les ventes;
   *   3  le dessin du GOA apparaît sur la scène : la température cause les
   *      deux. Une fourchette.
   *
   * Schéma, aucune donnée. Les trois mouvements du temps 0 partagent la
   * même durée : ils restent synchrones.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const LEG = [
    'Juillet, jour après jour.',
    'Observer : je lis le mercure, je devine les ventes. L’information circule.',
    'Intervenir : chauffer le thermomètre ne vend pas un cornet de plus.',
    'La température cause les deux : une fourchette.'
  ];
  const fige = $derived(e >= 2);
</script>

<div class="visuel m11t" bind:this={hote}>
  <svg viewBox="0 0 1200 580" role="img" aria-label="Le soleil fait monter le mercure et les ventes de crème glacée ensemble. Lire le mercure permet de deviner les ventes. Mais chauffer le thermomètre au briquet ne change pas les ventes : le mercure ne les cause pas. La température cause les deux.">
    <!-- le soleil -->
    <g class="soleil" class:anim={!fige}>
      <circle cx="180" cy="170" r="70" />
      {#each Array(12) as _, i (i)}
        <line x1="180" y1="70" x2="180" y2="40" transform="rotate({i * 30} 180 170)" />
      {/each}
    </g>
    <text x="180" y="300" class="lib">température</text>

    <!-- le thermomètre -->
    <g class="thermo">
      <rect x="560" y="80" width="56" height="360" rx="28" class="verre" />
      <circle cx="588" cy="470" r="46" class="bulbe" />
      <rect x="574" y="100" width="28" height="350" class="mercure" class:anim={!fige} class:chauffe={e === 2} />
      {#each [140, 200, 260, 320, 380] as y (y)}<line x1="616" y1={y} x2="636" y2={y} class="grad" />{/each}
    </g>
    <text x="588" y="560" class="lib">mercure</text>

    <!-- le briquet -->
    <g class="briquet" class:vu={e === 2}>
      <rect x="468" y="500" width="54" height="76" />
      <path d="M 495 496 C 470 470 488 440 495 420 C 505 444 522 468 495 496 Z" class="flamme" />
    </g>

    <!-- la crème glacée -->
    <g class="cornet">
      <path d="M 920 250 L 960 380 L 1000 250 Z" />
      <circle cx="942" cy="236" r="28" />
      <circle cx="978" cy="236" r="28" />
      <circle cx="960" cy="206" r="28" />
    </g>
    <rect x="1060" y="120" width="60" height="320" class="v-cadre" />
    <rect x="1060" y="120" width="60" height="320" class="ventes" class:anim={!fige} />
    <text x="1000" y="490" class="lib">ventes</text>

    <!-- observer : l'information circule -->
    <g class="info" class:vu={e === 1}>
      <path d="M 680 260 L 1020 260" />
      <polygon points="660,260 690,246 690,274" />
      <polygon points="1040,260 1010,246 1010,274" />
      <text x="850" y="236">information</text>
    </g>

    <!-- intervenir : rien ne passe -->
    <g class="rien" class:vu={e === 2}>
      <text x="1090" y="96">inchangées</text>
    </g>

    <!-- la fourchette -->
    <g class="goa" class:vu={e >= 3}>
      <path d="M 260 190 C 380 230 470 250 548 260" />
      <polygon points="556,262 524,246 524,276" />
      <path d="M 250 130 C 500 40 760 60 900 190" />
      <polygon points="908,198 872,190 892,166" />
    </g>
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
</div>

<style>
  .m11t { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; max-width: 52em; height: auto; max-height: 58vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .lib { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }

  .soleil circle { fill: var(--dk-accent); }
  .soleil line { stroke: var(--dk-accent); stroke-width: 9; stroke-linecap: round; }
  .soleil { transform-box: view-box; transform-origin: 180px 170px; transform: scale(0.85); transition: transform 0.6s; }
  .soleil.anim { animation: m11t-soleil 4s ease-in-out infinite alternate; }
  @keyframes m11t-soleil { from { transform: scale(0.55); } to { transform: scale(1.1); } }

  .verre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 5; }
  .bulbe { fill: var(--dk-accent); stroke: var(--dk-encre); stroke-width: 5; }
  .grad { stroke: var(--dk-encre); stroke-width: 4; }
  .mercure { fill: var(--dk-accent); transform-box: fill-box; transform-origin: bottom; transform: scaleY(0.55); transition: transform 1.4s ease-in-out; }
  .mercure.anim { animation: m11t-niveau 4s ease-in-out infinite alternate; }
  .mercure.chauffe { transform: scaleY(0.98); transition-delay: 0.6s; }
  @keyframes m11t-niveau { from { transform: scaleY(0.3); } to { transform: scaleY(0.88); } }

  .briquet { opacity: 0; transition: opacity 0.4s; }
  .briquet.vu { opacity: 1; }
  .briquet rect { fill: var(--dk-encre); }
  .flamme { fill: var(--dk-accent); transform-box: fill-box; transform-origin: bottom; animation: m11t-flamme 0.35s ease-in-out infinite alternate; }
  @keyframes m11t-flamme { from { transform: scaleY(0.85) skewX(-4deg); } to { transform: scaleY(1.1) skewX(4deg); } }

  .cornet path { fill: var(--dk-encre); }
  .cornet circle { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 5; }
  .v-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .ventes { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; transform: scaleY(0.55); transition: transform 0.6s; }
  .ventes.anim { animation: m11t-niveau 4s ease-in-out infinite alternate; }

  .info, .rien, .goa { opacity: 0; transition: opacity 0.4s; }
  .info.vu, .rien.vu, .goa.vu { opacity: 1; }
  .info path { stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 16 10; }
  .info polygon { fill: var(--dk-accent); }
  .info text { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .rien text { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .goa path { fill: none; stroke: var(--dk-encre); stroke-width: 6; }
  .goa polygon { fill: var(--dk-encre); }

  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  @media (prefers-reduced-motion: reduce) { .soleil.anim, .mercure.anim, .ventes.anim, .flamme { animation: none; } }
</style>
