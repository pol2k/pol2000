<script>
  /**
   * Pourquoi citer : sept raisons autour d'un même geste, la citation.
   * Au centre, un carré rouge (les guillemets); autour, sur une ellipse,
   * sept pictogrammes qui se dessinent un par clic, reliés au centre par
   * un rayon. Les sept raisons sont celles de l'enseignant :
   *
   *   1  crédibilité scientifique  (un sceau, coché);
   *   2  mise en contexte          (un texte parmi d'autres, reliés);
   *   3  reproductibilité          (deux flèches en boucle);
   *   4  propriété intellectuelle  (une idée, avec son étiquette de nom);
   *   5  prévention du plagiat     (deux pages identiques, interdit);
   *   6  réduction des biais       (une balance à l'équilibre);
   *   7  savoir cumulatif          (des blocs empilés, le vôtre en haut).
   *
   * Sept temps : 0 le centre seul (et sept repères vides), puis une raison
   * par clic. La raison qui vient d'arriver est en rouge, les autres
   * passent à l'encre. Un seul SVG : tout se met à l'échelle ensemble, à
   * 1920 comme à 1280. Pas de données.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 7, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Ellipse : centre (800, 370), rayons 570 × 300, départ en haut.
  const CX = 800;
  const CY = 370;
  const RAISONS = [
    'Crédibilité scientifique',
    'Mise en contexte',
    'Reproductibilité',
    'Propriété intellectuelle',
    'Prévention du plagiat',
    'Réduction des biais',
    'Savoir cumulatif'
  ].map((mot, i) => {
    const a = -Math.PI / 2 + (i * 2 * Math.PI) / 7;
    return { mot, x: Math.round(CX + 570 * Math.cos(a)), y: Math.round(CY + 300 * Math.sin(a)) };
  });
  const B = 58; // demi-côté d'une case
</script>

<div class="visuel m8c" bind:this={hote}>
  <svg viewBox="0 0 1600 790" role="img" aria-label="Pourquoi citer&#8239;: crédibilité scientifique, mise en contexte, reproductibilité, propriété intellectuelle, prévention du plagiat, réduction des biais, savoir cumulatif.">
    <!-- rayons -->
    {#each RAISONS as r, i}
      <line class="m8c-rayon" class:m8c-on={e >= i + 1} x1={CX} y1={CY} x2={r.x} y2={r.y} pathLength="1" />
    {/each}

    <!-- centre : la citation -->
    <rect class="m8c-centre" x={CX - 92} y={CY - 92} width="184" height="184" />
    <g class="m8c-guil" transform="translate({CX} {CY})">
      <path d="M -44 -30 L -64 0 L -44 30 M -14 -30 L -34 0 L -14 30" />
      <path d="M 14 -30 L 34 0 L 14 30 M 44 -30 L 64 0 L 44 30" />
    </g>

    {#each RAISONS as r, i}
      {@const on = e >= i + 1}
      <!-- repère vide -->
      <rect class="m8c-repere" class:m8c-cache={on} x={r.x - 9} y={r.y - 9} width="18" height="18" />
      <g class="m8c-n" class:m8c-on={on} class:m8c-actif={e === i + 1} transform="translate({r.x} {r.y})">
        <rect class="m8c-case" x={-B} y={-B} width={B * 2} height={B * 2} />
        <rect class="m8c-bord tr" x={-B} y={-B} width={B * 2} height={B * 2} pathLength="1" />
        <g class="m8c-ic">
          {#if i === 0}
            <!-- sceau coché -->
            <circle class="tr" style="--k: 0" cx="0" cy="-8" r="26" pathLength="1" />
            <path class="tr" style="--k: 1" d="M -15 14 L -22 38 L -11 33 L -5 42 L 1 19" pathLength="1" />
            <path class="tr" style="--k: 1" d="M 15 14 L 22 38 L 11 33 L 5 42" pathLength="1" />
            <path class="tr rouge" style="--k: 2" d="M -12 -8 L -3 2 L 13 -17" pathLength="1" />
          {:else if i === 1}
            <!-- un texte parmi d'autres -->
            <path class="tr" style="--k: 0" d="M -12 -15 L -24 -24 M 12 -15 L 24 -24 M -12 15 L -24 24 M 12 15 L 24 24" pathLength="1" />
            <rect class="tr" style="--k: 1" x="-42" y="-40" width="18" height="22" pathLength="1" />
            <rect class="tr" style="--k: 1" x="24" y="-40" width="18" height="22" pathLength="1" />
            <rect class="tr" style="--k: 1" x="-42" y="18" width="18" height="22" pathLength="1" />
            <rect class="tr" style="--k: 1" x="24" y="18" width="18" height="22" pathLength="1" />
            <rect class="tr rouge" style="--k: 2" x="-12" y="-15" width="24" height="30" pathLength="1" />
          {:else if i === 2}
            <!-- deux flèches en boucle -->
            <path class="tr" style="--k: 0" d="M 30 -6 A 30 30 0 0 0 -29 -8" pathLength="1" />
            <path class="tr" style="--k: 1" d="M -39 -17 L -29 -5 L -18 -16" pathLength="1" />
            <path class="tr" style="--k: 0" d="M -30 6 A 30 30 0 0 0 29 8" pathLength="1" />
            <path class="tr" style="--k: 1" d="M 39 17 L 29 5 L 18 16" pathLength="1" />
            <rect class="tr rouge" style="--k: 2" x="-6" y="-6" width="12" height="12" pathLength="1" />
          {:else if i === 3}
            <!-- une idée, son étiquette -->
            <path class="tr" style="--k: 0" d="M -9 12 C -9 4 -24 -2 -24 -17 A 21 21 0 0 1 18 -17 C 18 -2 3 4 3 12 Z" transform="translate(3 0)" pathLength="1" />
            <path class="tr" style="--k: 1" d="M -6 21 L 6 21 M -3 29 L 3 29" pathLength="1" />
            <path class="tr" style="--k: 1" d="M 18 2 L 28 14" pathLength="1" />
            <path class="tr rouge" style="--k: 2" d="M 22 14 L 44 14 L 44 40 L 22 40 Z M 28 24 L 38 24 M 28 31 L 35 31" pathLength="1" />
          {:else if i === 4}
            <!-- deux pages identiques, interdit -->
            <path class="tr" style="--k: 0" d="M -42 -36 L -10 -36 L -10 12 L -42 12 Z M -35 -25 L -17 -25 M -35 -16 L -17 -16 M -35 -7 L -22 -7" pathLength="1" />
            <path class="tr" style="--k: 0" d="M 10 -36 L 42 -36 L 42 12 L 10 12 Z M 17 -25 L 35 -25 M 17 -16 L 35 -16 M 17 -7 L 30 -7" pathLength="1" />
            <circle class="tr rouge" style="--k: 1" cx="0" cy="22" r="18" pathLength="1" />
            <path class="tr rouge" style="--k: 2" d="M -12 10 L 12 34" pathLength="1" />
          {:else if i === 5}
            <!-- balance à l'équilibre -->
            <path class="tr" style="--k: 0" d="M 0 -34 L 0 34 M -16 34 L 16 34" pathLength="1" />
            <path class="tr rouge" style="--k: 1" d="M -36 -24 L 36 -24" pathLength="1" />
            <path class="tr" style="--k: 2" d="M -36 -24 L -46 4 M -36 -24 L -26 4 M -48 4 L -24 4" pathLength="1" />
            <path class="tr" style="--k: 2" d="M 36 -24 L 26 4 M 36 -24 L 46 4 M 24 4 L 48 4" pathLength="1" />
          {:else}
            <!-- blocs empilés : le vôtre en haut -->
            <path class="tr" style="--k: 0" d="M -40 18 L -16 18 L -16 40 L -40 40 Z M -12 18 L 12 18 L 12 40 L -12 40 Z M 16 18 L 40 18 L 40 40 L 16 40 Z" pathLength="1" />
            <path class="tr" style="--k: 1" d="M -26 -8 L -2 -8 L -2 14 L -26 14 Z M 2 -8 L 26 -8 L 26 14 L 2 14 Z" pathLength="1" />
            <rect class="tr rouge" style="--k: 2" x="-12" y="-34" width="24" height="22" pathLength="1" />
          {/if}
        </g>
        <rect class="m8c-fond-mot" x={-(r.mot.length * 9.6 + 14)} y={i === 0 ? B : B + 14} width={r.mot.length * 19.2 + 28} height={i === 0 ? 56 : 42} />
        <text class="m8c-mot" x="0" y={B + 44}>{r.mot}</text>
      </g>
    {/each}
  </svg>
</div>

<style>
  .m8c { display: flex; justify-content: center; }
  .m8c svg { display: block; height: 27em; width: auto; max-width: 100%; overflow: visible; }

  .m8c-rayon { stroke: var(--dk-encre); stroke-width: 3; stroke-linecap: butt; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.45s ease-out; }
  .m8c-rayon.m8c-on { stroke-dashoffset: 0; }

  .m8c-centre { fill: var(--dk-accent); }
  .m8c-guil path { fill: none; stroke: var(--dk-fond); stroke-width: 10; stroke-linecap: square; stroke-linejoin: miter; }

  .m8c-repere { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; transition: opacity 0.2s; }
  .m8c-repere.m8c-cache { opacity: 0; }

  .m8c-n { opacity: 0; transition: opacity 0.25s; }
  .m8c-n.m8c-on { opacity: 1; }
  .m8c-case { fill: var(--dk-fond); }
  .m8c-n .tr { fill: none; stroke: var(--dk-encre); stroke-width: 4.5; stroke-linecap: square; stroke-linejoin: miter; stroke-dasharray: 1; stroke-dashoffset: 1; opacity: 0; transition: stroke-dashoffset 0.5s ease-out calc(0.3s + var(--k, 0) * 0.2s), stroke 0.4s, opacity 0s calc(0.3s + var(--k, 0) * 0.2s); }
  .m8c-n .m8c-bord { stroke-width: 3; --k: 0; transition-delay: 0.25s, 0s, 0.25s; }
  .m8c-n.m8c-on .tr { stroke-dashoffset: 0; opacity: 1; }
  .m8c-n .tr.rouge { stroke: var(--dk-accent); }
  .m8c-n.m8c-actif .m8c-bord { stroke: var(--dk-accent); }

  .m8c-mot { font-family: var(--dk-mono); font-size: 32px; font-weight: 600; letter-spacing: -0.01em; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s 0.55s, fill 0.4s; }
  .m8c-n.m8c-on .m8c-mot { opacity: 1; }
  .m8c-fond-mot { fill: var(--dk-fond); }
  .m8c-n.m8c-actif .m8c-mot { fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .m8c-rayon, .m8c-n, .m8c-n .tr, .m8c-mot, .m8c-repere { transition: none; }
    .m8c-rayon.m8c-on, .m8c-n.m8c-on .tr { stroke-dashoffset: 0; opacity: 1; }
  }
</style>
