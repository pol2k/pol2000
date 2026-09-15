<script>
  /**
   * Comment on fait une inférence ? Un chemin en quatre stations, un jeton
   * rouge qui roule de l'une à l'autre. Cinq temps.
   *
   *   0  Les stations et le rail se tracent, pâles.
   *   1  Une question.
   *   2  Observer : un échantillon, par des procédures publiques.
   *   3  Décrire : les statistiques descriptives, aujourd'hui.
   *   4  Généraliser, avec incertitude : la séance 5. Le jeton y va, puis
   *      revient à « Décrire », dont le cadre devient rouge; « vous êtes
   *      ici » rebondit au-dessus.
   *
   * Schéma, aucune donnée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const X = [125, 375, 625, 875];
  const RAIL = 272, HAUT = 92, H = 140, L = 160;
  const STATIONS = [
    { nom: 'Une question', badge: '' },
    { nom: 'Observer', badge: 'procédures publiques' },
    { nom: 'Décrire', badge: 'aujourd’hui' },
    { nom: 'Généraliser', badge: 'avec incertitude · séance 5' }
  ];
  // Où est le jeton : au départ, invisible avant la première station.
  const xJeton = $derived(e === 0 ? X[0] - 80 : e === 4 ? X[2] : X[e - 1]);
  const xProgres = $derived(e === 0 ? 60 : e === 4 ? X[3] : X[e - 1]);
</script>

<div class="visuel demarche" bind:this={hote}>
  <svg viewBox="0 0 1000 370" role="img" aria-label="Quatre étapes : une question, observer, décrire, généraliser avec incertitude. On est à l'étape décrire.">
    <!-- Le rail. -->
    <line x1="60" y1={RAIL} x2="940" y2={RAIL} pathLength="1" class="rail-d" />
    <!-- Le trajet parcouru : un rectangle, pas une ligne. Seules les propriétés
         géométriques x, y, width et height s'animent en CSS. -->
    <rect x="60" y={RAIL - 4} width={Math.max(xProgres - 60, 0)} height="8" class="progres-d" class:cache={e === 0} />

    {#each STATIONS as s, i}
      {@const allume = e >= i + 1}
      {@const ici = e === 4 && i === 2}
      <g class="station" class:allume class:ici style="--k: {i}">
        <rect x={X[i] - L / 2} y={HAUT} width={L} height={H} pathLength="1" class="cadre-d" />
        <line x1={X[i]} y1={HAUT + H} x2={X[i]} y2={RAIL} class="attache" />
        {#if i === 0}
          <text x={X[i]} y={HAUT + 108} class="interro">?</text>
        {:else if i === 1}
          {#each Array.from({ length: 16 }) as _, k}
            <rect x={X[i] - 45 + (k % 4) * 24} y={HAUT + 26 + Math.floor(k / 4) * 24} width="18" height="18" class="glyphe-d plein-d" style="--j: {k}" />
          {/each}
        {:else if i === 2}
          {#each [30, 62, 96, 74, 44, 22] as h, k}
            <rect x={X[i] - 57 + k * 19} y={HAUT + 118 - h} width="16" height={h} class="glyphe-d plein-d" style="--j: {k}" />
          {/each}
          <line x1={X[i] - 64} y1={HAUT + 118} x2={X[i] + 64} y2={HAUT + 118} class="glyphe-d trait-d" />
        {:else}
          <path d="M {X[i] - 62} {HAUT + 40} q 20 -10 40 0 t 40 0 t 40 0 M {X[i] - 62} {HAUT + 100} q 20 -10 40 0 t 40 0 t 40 0" class="glyphe-d vague" />
          <circle cx={X[i]} cy={HAUT + 70} r="8" class="glyphe-d plein-d" />
          <path d="M {X[i] - 26} {HAUT + 52} L {X[i] - 34} {HAUT + 52} L {X[i] - 34} {HAUT + 88} L {X[i] - 26} {HAUT + 88} M {X[i] + 26} {HAUT + 52} L {X[i] + 34} {HAUT + 52} L {X[i] + 34} {HAUT + 88} L {X[i] + 26} {HAUT + 88}" class="glyphe-d marge" />
        {/if}
        <text x={X[i]} y={RAIL + 38} class="nom-d">{s.nom}</text>
        {#if s.badge}<text x={X[i]} y={RAIL + 66} class="badge-d">{s.badge}</text>{/if}
      </g>
    {/each}

    <!-- Le jeton : il glisse entre les stations et rebondit à chaque arrivée. -->
    <g class="jeton-d" class:cache={e === 0} class:retour={e === 4} style="transform: translateX({xJeton}px); --x3: {X[2]}px; --x4: {X[3]}px">
      {#key e}
        <circle cx="0" cy={RAIL} r="16" class="bille" />
      {/key}
    </g>

    {#if e === 4}
      <g class="ici-d" style="transform: translate({X[2]}px, 0px)">
        <text y="30" class="ici-t">vous êtes ici</text>
        <path d="M 0 40 L 0 76 M -10 66 L 0 76 L 10 66" class="ici-f" />
      </g>
    {/if}
  </svg>
</div>

<style>
  .demarche { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .rail-d { stroke: var(--dk-filet); stroke-width: 8; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.9s ease-out forwards; }
  .progres-d { fill: var(--dk-accent); transition: width 0.9s cubic-bezier(0.34, 1.2, 0.64, 1), opacity 0.3s; }
  .cache { opacity: 0; }

  .cadre-d { fill: var(--dk-fond); stroke: var(--dk-filet); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.7s ease-out forwards; animation-delay: calc(var(--k) * 150ms + 200ms); transition: stroke 0.3s, stroke-width 0.3s; }
  .attache { stroke: var(--dk-filet); stroke-width: 3; transition: stroke 0.3s; }
  .allume .cadre-d { stroke: var(--dk-encre); }
  .allume .attache { stroke: var(--dk-encre); }
  .ici .cadre-d { stroke: var(--dk-accent); stroke-width: 6; }

  .glyphe-d { transition: fill 0.35s, stroke 0.35s; }
  .plein-d { fill: var(--dk-filet); }
  .trait-d, .vague, .marge { fill: none; stroke: var(--dk-filet); stroke-width: 3; }
  .interro { font-size: 96px; font-weight: 600; text-anchor: middle; fill: var(--dk-filet); transition: fill 0.35s; }
  .allume .plein-d { fill: var(--dk-encre); animation: pop 0.4s cubic-bezier(0.34, 1.8, 0.64, 1) both; animation-delay: calc(var(--j, 0) * 35ms + 350ms); transform-box: fill-box; transform-origin: 50% 100%; }
  .allume .trait-d, .allume .vague { stroke: var(--dk-encre); }
  .allume .marge { stroke: var(--dk-accent); stroke-width: 4; }
  .allume .interro { fill: var(--dk-encre); animation: pop 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) 0.35s both; transform-box: fill-box; transform-origin: center; }
  .ici .plein-d { fill: var(--dk-accent); }

  .nom-d { font-size: 22px; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.3s; }
  .allume .nom-d { fill: var(--dk-encre); font-weight: 600; }
  .ici .nom-d { fill: var(--dk-accent); }
  .badge-d { font-size: 15px; letter-spacing: 0.06em; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.3s; }
  .allume .badge-d { fill: var(--dk-accent); font-weight: 600; }

  .jeton-d { transition: transform 0.9s cubic-bezier(0.45, 0, 0.3, 1), opacity 0.3s; }
  .jeton-d.retour { animation: retour 1.3s cubic-bezier(0.45, 0, 0.3, 1) both; }
  .bille { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 4; animation: rebond 0.9s ease-out both; }

  .ici-t { font-size: 17px; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; text-anchor: middle; fill: var(--dk-accent); animation: apparait 0.4s ease-out 1.2s both; }
  .ici-f { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linecap: round; stroke-linejoin: round; animation: apparait 0.4s ease-out 1.2s both, saute 1.2s ease-in-out 1.6s infinite; }

  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  @keyframes retour { 0% { transform: translateX(var(--x3)); } 45% { transform: translateX(var(--x4)); } 100% { transform: translateX(var(--x3)); } }
  @keyframes rebond { 0% { transform: translateY(0); } 55% { transform: translateY(0); } 70% { transform: translateY(-26px); } 85% { transform: translateY(0); } 93% { transform: translateY(-8px); } 100% { transform: translateY(0); } }
  @keyframes apparait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes saute { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(6px); } }
  @media (prefers-reduced-motion: reduce) {
    .rail-d, .cadre-d { animation: none; stroke-dashoffset: 0; }
    .jeton-d, .progres-d { transition: none; }
    .jeton-d.retour, .bille, .allume .plein-d, .allume .interro, .ici-t, .ici-f { animation: none; }
  }
</style>
