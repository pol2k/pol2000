<script>
  /**
   * Les pictogrammes des côtés sombres de l'IA, partagés par M9Risque (une
   * diapo par thème) et M9Risques (les cinq tuiles). Un schéma par clé :
   *
   *   livres        un livre, une tête de mort sur la couverture;
   *   detruits      un livre qui descend dans une déchiqueteuse;
   *   existentiel   un cadran dont l'aiguille file vers la zone rouge;
   *   militaire     un drone vu de haut, pris dans un réticule;
   *   surveillance  neuf silhouettes, un cadre de détection sur chaque visage.
   *
   * `joue` rejoue l'animation d'arrivée; sans elle, l'état de repos est
   * complet. `delai` (en secondes) décale toute l'animation, pour les tuiles
   * qui arrivent l'une après l'autre. Tracés fixes, aucune donnée, aucun hasard.
   */
  let { cle, joue = false, delai = 0 } = $props();

  // Le cadran : angle compté depuis la verticale, en degrés.
  const CX = 100, CY = 146;
  const pt = (r, a) => [CX + r * Math.sin((a * Math.PI) / 180), CY - r * Math.cos((a * Math.PI) / 180)];
  const arc = (r, a0, a1) => {
    const [x0, y0] = pt(r, a0), [x1, y1] = pt(r, a1);
    return `M ${x0} ${y0} A ${r} ${r} 0 ${a1 - a0 > 180 ? 1 : 0} 1 ${x1} ${y1}`;
  };
  const GRAD = Array.from({ length: 13 }, (_, k) => -90 + k * 15);

  // La déchiqueteuse : sept lanières de longueurs fixes.
  const LANIERES = [40, 52, 34, 48, 56, 38, 44];

  // La surveillance : une grille de trois par trois.
  const GRILLE = [40, 100, 160].flatMap((cy, r) => [40, 100, 160].map((cx, c) => ({ cx, cy, k: r * 3 + c })));
</script>

<svg viewBox="0 0 200 200" class="m9pi m9pi-{cle}" class:joue style="--d0: {delai}s" aria-hidden="true">
  {#if cle === 'livres'}
    <rect x="40" y="22" width="18" height="156" class="m9pi-plein" />
    <rect x="58" y="22" width="104" height="156" pathLength="1" class="m9pi-trait m9pi-trace" />
    <line x1="162" y1="30" x2="170" y2="30" class="m9pi-fin" />
    <line x1="170" y1="30" x2="170" y2="186" class="m9pi-fin" />
    <line x1="170" y1="186" x2="48" y2="186" class="m9pi-fin" />
    <g class="m9pi-pop" style="transform-origin: 110px 100px">
      <circle cx="110" cy="84" r="26" class="m9pi-rouge" />
      <rect x="97" y="100" width="26" height="16" class="m9pi-rouge" />
      <circle cx="100" cy="84" r="7" class="m9pi-papier" />
      <circle cx="120" cy="84" r="7" class="m9pi-papier" />
      <polygon points="110,94 106,101 114,101" class="m9pi-papier" />
      <line x1="103" y1="106" x2="103" y2="116" class="m9pi-dent" />
      <line x1="110" y1="106" x2="110" y2="116" class="m9pi-dent" />
      <line x1="117" y1="106" x2="117" y2="116" class="m9pi-dent" />
      <line x1="80" y1="128" x2="140" y2="160" class="m9pi-os" />
      <line x1="140" y1="128" x2="80" y2="160" class="m9pi-os" />
    </g>
  {:else if cle === 'detruits'}
    <g class="m9pi-descend">
      <rect x="64" y="18" width="72" height="96" class="m9pi-trait" />
      <rect x="64" y="18" width="12" height="96" class="m9pi-plein" />
      {#each [36, 50, 64, 78] as y}
        <line x1="86" y1={y} x2="124" y2={y} class="m9pi-ligne" />
      {/each}
    </g>
    {#each LANIERES as h, k}
      <rect x={45 + k * 16} y="146" width="10" height={h} class="m9pi-rouge m9pi-lan" style="--k: {k}" />
    {/each}
    <rect x="26" y="100" width="148" height="48" class="m9pi-plein" />
    <line x1="44" y1="112" x2="156" y2="112" class="m9pi-fente" />
  {:else if cle === 'existentiel'}
    <path d={arc(88, -90, 90)} class="m9pi-trait" />
    <path d={arc(88, 45, 90)} class="m9pi-zone" />
    {#each GRAD as a}
      {@const [x0, y0] = pt(a % 45 === 0 ? 62 : 70, a)}
      {@const [x1, y1] = pt(80, a)}
      <line x1={x0} y1={y0} x2={x1} y2={y1} class="m9pi-grad" class:fort={a >= 45} />
    {/each}
    <line x1="10" y1={CY} x2="190" y2={CY} class="m9pi-trait" />
    <line x1={CX} y1={CY} x2={CX} y2={CY - 72} class="m9pi-aig" style="transform-origin: {CX}px {CY}px" />
    <circle cx={CX} cy={CY} r="9" class="m9pi-plein" />
  {:else if cle === 'militaire'}
    {#each [[62, 62], [138, 62], [62, 138], [138, 138]] as [x, y]}
      <line x1="100" y1="100" x2={x} y2={y} class="m9pi-bras" />
      <circle cx={x} cy={y} r="17" class="m9pi-rotor" />
    {/each}
    <rect x="86" y="86" width="28" height="28" class="m9pi-plein" />
    <g class="m9pi-vise" style="transform-origin: 100px 100px">
      <circle cx="100" cy="100" r="84" class="m9pi-reticule" />
      <line x1="100" y1="6" x2="100" y2="46" class="m9pi-reticule" />
      <line x1="100" y1="154" x2="100" y2="194" class="m9pi-reticule" />
      <line x1="6" y1="100" x2="46" y2="100" class="m9pi-reticule" />
      <line x1="154" y1="100" x2="194" y2="100" class="m9pi-reticule" />
    </g>
  {:else if cle === 'surveillance'}
    {#each GRILLE as g (g.k)}
      <circle cx={g.cx} cy={g.cy - 8} r="10" class="m9pi-plein" />
      <path d="M {g.cx - 19} {g.cy + 22} v -5 a 19 13 0 0 1 38 0 v 5 Z" class="m9pi-plein" />
      <rect x={g.cx - 17} y={g.cy - 25} width="34" height="34" class="m9pi-cadre" style="--k: {g.k}; transform-origin: {g.cx}px {g.cy - 8}px" />
    {/each}
  {/if}
</svg>

<style>
  .m9pi { width: 100%; height: 100%; display: block; overflow: visible; --pi-encre: var(--dk-encre); --pi-rouge: var(--dk-accent); --pi-papier: var(--dk-fond); --pi-fond2: var(--dk-fond-2); --pi-gris: var(--dk-gris); }
  /* Sur une diapo encre : traits en papier, rouge remplacé par l'or. */
:global(.diapo.encre) .m9pi { --pi-encre: var(--dk-fond); --pi-rouge: var(--dk-accent-clair); --pi-papier: var(--dk-encre); --pi-fond2: var(--dk-encre); --pi-gris: var(--dk-gris-2); }
  .m9pi-trait { fill: none; stroke: var(--pi-encre); stroke-width: 4; }
  .m9pi-fin { stroke: var(--pi-encre); stroke-width: 4; }
  .m9pi-plein { fill: var(--pi-encre); }
  .m9pi-rouge { fill: var(--pi-rouge); }
  .m9pi-papier { fill: var(--pi-papier); }
  .m9pi-dent { stroke: var(--pi-papier); stroke-width: 2; }
  .m9pi-os { stroke: var(--pi-rouge); stroke-width: 9; stroke-linecap: round; }
  .m9pi-ligne { stroke: var(--pi-gris); stroke-width: 4; }
  .m9pi-fente { stroke: var(--pi-papier); stroke-width: 4; }
  .m9pi-zone { fill: none; stroke: var(--pi-rouge); stroke-width: 12; }
  .m9pi-grad { stroke: var(--pi-encre); stroke-width: 3; }
  .m9pi-grad.fort { stroke: var(--pi-rouge); }
  .m9pi-aig { stroke: var(--pi-rouge); stroke-width: 6; transform: rotate(62deg); }
  .m9pi-bras { stroke: var(--pi-encre); stroke-width: 6; }
  .m9pi-rotor { fill: var(--pi-fond2); stroke: var(--pi-encre); stroke-width: 3; }
  .m9pi-reticule { fill: none; stroke: var(--pi-rouge); stroke-width: 4; }
  .m9pi-cadre { fill: none; stroke: var(--pi-rouge); stroke-width: 3; }

  /* L'arrivée, rejouée à chaque entrée : sans .joue, tout est déjà en place. */
  .joue .m9pi-trace { stroke-dasharray: 1; animation: m9pi-trace 0.9s ease-out both; animation-delay: var(--d0); }
  .joue .m9pi-pop { animation: m9pi-pop 0.45s cubic-bezier(0.3, 1.5, 0.6, 1) both; animation-delay: calc(var(--d0) + 0.7s); }
  .joue .m9pi-descend { animation: m9pi-descend 1.1s ease-in-out both; animation-delay: var(--d0); }
  .joue .m9pi-lan { transform-box: fill-box; transform-origin: top; animation: m9pi-pousse 0.5s ease-out both; animation-delay: calc(var(--d0) + 0.6s + var(--k) * 70ms); }
  .joue .m9pi-aig { animation: m9pi-aiguille 1.6s ease-in-out both; animation-delay: var(--d0); }
  .joue .m9pi-zone { animation: m9pi-parait 0.4s both; animation-delay: calc(var(--d0) + 1.1s); }
  .joue .m9pi-vise { animation: m9pi-vise 0.9s ease-out both; animation-delay: var(--d0); }
  .joue .m9pi-cadre { animation: m9pi-cadre 0.35s ease-out both; animation-delay: calc(var(--d0) + 0.3s + var(--k) * 120ms); }

  @keyframes m9pi-trace { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes m9pi-pop { from { opacity: 0; transform: scale(0.2); } to { opacity: 1; transform: none; } }
  @keyframes m9pi-descend { from { transform: translateY(-34px); } to { transform: none; } }
  @keyframes m9pi-pousse { from { transform: scaleY(0); } to { transform: none; } }
  @keyframes m9pi-aiguille {
    0% { transform: rotate(-84deg); }
    70% { transform: rotate(72deg); }
    85% { transform: rotate(56deg); }
    100% { transform: rotate(62deg); }
  }
  @keyframes m9pi-parait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes m9pi-vise { from { opacity: 0; transform: scale(1.6) rotate(45deg); } to { opacity: 1; transform: none; } }
  @keyframes m9pi-cadre { from { opacity: 0; transform: scale(1.6); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .joue .m9pi-trace, .joue .m9pi-pop, .joue .m9pi-descend, .joue .m9pi-lan, .joue .m9pi-aig,
    .joue .m9pi-zone, .joue .m9pi-vise, .joue .m9pi-cadre { animation: none; }
  }
</style>
