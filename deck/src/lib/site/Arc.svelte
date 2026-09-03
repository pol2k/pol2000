<script>
  /**
   * L'arc du cours en une figure qui se dessine: décrire une variable
   * (les points, leur moyenne), relier deux variables (la droite), inférer
   * (la bande d'incertitude), puis raisonner sur la cause (une troisième
   * variable sépare le nuage et change la pente). Quatre temps joués à
   * l'arrivée, puis pilotés au clic. Les points sont fictifs, engendrés par
   * une graine fixe: la figure est schématique et le dit.
   */
  let { auto = true } = $props();

  // Générateur à graine fixe (LCG): déterministe d'une visite à l'autre.
  function graine(s) {
    let a = s >>> 0;
    return () => { a = (a * 1664525 + 1013904223) >>> 0; return a / 4294967296; };
  }
  const al = graine(20260903);
  const N = 36;
  // z: une troisième variable, binaire. Elle pousse X et Y à la fois — le
  // cas classique de la variable confondante.
  const PTS = Array.from({ length: N }, (_, i) => {
    const z = i % 2;
    const x = 0.12 + 0.34 * z + 0.42 * al();
    const y = 0.16 + 0.32 * x + 0.24 * z + (al() - 0.5) * 0.2;
    return { x, y, z };
  });

  function ols(pts) {
    const n = pts.length;
    const mx = pts.reduce((s, p) => s + p.x, 0) / n;
    const my = pts.reduce((s, p) => s + p.y, 0) / n;
    const sxx = pts.reduce((s, p) => s + (p.x - mx) ** 2, 0);
    const sxy = pts.reduce((s, p) => s + (p.x - mx) * (p.y - my), 0);
    const b = sxy / sxx;
    const a = my - b * mx;
    const s2 = pts.reduce((s, p) => s + (p.y - (a + b * p.x)) ** 2, 0) / (n - 2);
    return { a, b, mx, my, sxx, s: Math.sqrt(s2), n };
  }
  const TOUT = ols(PTS);
  const G0 = ols(PTS.filter((p) => p.z === 0));
  const G1 = ols(PTS.filter((p) => p.z === 1));

  // Géométrie: viewBox 640 × 400, marges pour les axes.
  const L = 56, R = 620, T = 24, B = 336;
  const X = (v) => L + v * (R - L);
  const Y = (v) => B - v * (B - T);
  const seg = (m, x0 = 0.04, x1 = 0.96) => ({ x1: X(x0), y1: Y(m.a + m.b * x0), x2: X(x1), y2: Y(m.a + m.b * x1) });
  const D_TOUT = seg(TOUT), D_G0 = seg(G0, 0.04, 0.62), D_G1 = seg(G1, 0.4, 0.96);

  // Bande d'incertitude autour de la droite: l'intervalle de confiance
  // habituel, à deux erreurs-types, évasé aux extrémités.
  const BANDE = (() => {
    const xs = Array.from({ length: 25 }, (_, k) => 0.04 + (0.92 * k) / 24);
    const h = (x) => 2 * TOUT.s * Math.sqrt(1 / TOUT.n + (x - TOUT.mx) ** 2 / TOUT.sxx);
    const haut = xs.map((x) => `${X(x).toFixed(1)},${Y(TOUT.a + TOUT.b * x + h(x)).toFixed(1)}`);
    const bas = xs.slice().reverse().map((x) => `${X(x).toFixed(1)},${Y(TOUT.a + TOUT.b * x - h(x)).toFixed(1)}`);
    return [...haut, ...bas].join(' ');
  })();

  const TEMPS = [
    { t: 'Décrire', l: "Une variable à la fois : où est son centre, comment elle s'étale." },
    { t: 'Relier', l: 'Deux variables : une droite qui résume la relation entre X et Y.' },
    { t: 'Inférer', l: "Un échantillon, une population : ce qu'on peut affirmer, et avec quelle marge." },
    { t: 'Causer', l: 'Une troisième variable peut fabriquer une relation, ou la cacher.' }
  ];

  let p = $state(0);
  let minuteries = [];
  function arreter() { minuteries.forEach(clearTimeout); minuteries = []; }
  function aller(n) { arreter(); p = n; }

  $effect(() => {
    const calme = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!auto || calme) { p = 4; return; }
    p = 0;
    [1, 2, 3, 4].forEach((n, i) => minuteries.push(setTimeout(() => (p = n), 350 + i * 2100)));
    return arreter;
  });
</script>

<figure class="arc p{p}">
  <svg viewBox="0 0 640 400" role="img" aria-label="Nuage de points fictifs : la moyenne, puis une droite de régression, puis sa bande d'incertitude, puis deux groupes qui changent la pente.">
    <!-- axes -->
    <line x1={L} y1={T} x2={L} y2={B} class="axe" />
    <line x1={L} y1={B} x2={R} y2={B} class="axe" />
    <text x={L - 14} y={T + 12} class="lettre" text-anchor="end">Y</text>
    <text x={R} y={B + 30} class="lettre" text-anchor="end">X</text>

    <!-- 3 · la bande -->
    <polygon points={BANDE} class="bande" />

    <!-- 1 · la moyenne -->
    <line x1={X(0.02)} y1={Y(TOUT.my)} x2={X(0.98)} y2={Y(TOUT.my)} class="moy" />
    <text x={X(0.98)} y={Y(TOUT.my) - 8} class="lib moy-l" text-anchor="end">moyenne de Y</text>

    <!-- 4 · deux droites -->
    <line {...D_G0} class="dr g0" />
    <line {...D_G1} class="dr g1" />

    <!-- 2 · la droite -->
    <line {...D_TOUT} class="dr tout" />
    <text x={D_TOUT.x2 - 6} y={D_TOUT.y2 - 12} class="lib dr-l" text-anchor="end">la droite</text>
    <text x={X(0.5)} y={Y(TOUT.a + TOUT.b * 0.5) + 44} class="lib bande-l" text-anchor="middle">l'incertitude</text>

    <!-- les points -->
    {#each PTS as q, i}
      <circle cx={X(q.x)} cy={Y(q.y)} r="6" class="pt z{q.z}" style="transition-delay: {p <= 1 ? i * 28 : 0}ms" />
    {/each}

    <!-- 4 · le petit graphe causal -->
    <g class="goa" transform="translate(84 30)">
      <circle cx="0" cy="56" r="13" /><text x="0" y="61" text-anchor="middle">X</text>
      <circle cx="96" cy="56" r="13" /><text x="96" y="61" text-anchor="middle">Y</text>
      <circle cx="48" cy="0" r="13" class="z" /><text x="48" y="5" text-anchor="middle" class="z">Z</text>
      <line x1="15" y1="56" x2="81" y2="56" marker-end="url(#fleche)" />
      <line x1="38" y1="11" x2="9" y2="44" marker-end="url(#fleche)" class="z" />
      <line x1="58" y1="11" x2="87" y2="44" marker-end="url(#fleche)" class="z" />
    </g>
    <defs>
      <marker id="fleche" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
        <path d="M 0 0 L 10 5 L 0 10 z" fill="context-stroke" />
      </marker>
    </defs>
  </svg>

  <div class="temps" role="tablist" aria-label="Les quatre temps du cours">
    {#each TEMPS as t, i}
      <button role="tab" aria-selected={p === i + 1} class:on={p === i + 1} class:fait={p > i + 1} onclick={() => aller(i + 1)}>
        <span class="n">{i + 1}</span><span class="t">{t.t}</span>
      </button>
    {/each}
  </div>
  <figcaption>
    <span class="l">{p > 0 ? TEMPS[p - 1].l : ' '}</span>
    <span class="note">Figure schématique · données fictives</span>
  </figcaption>
</figure>

<style>
  .arc { display: flex; flex-direction: column; gap: 0.7rem; width: 100%; }
  svg { width: 100%; height: auto; display: block; overflow: visible; }
  .axe { stroke: var(--encre); stroke-width: 2; }
  .lettre { font-family: var(--mono); font-size: 15px; font-weight: 600; fill: var(--encre); }
  .lib { font-family: var(--mono); font-size: 11px; letter-spacing: 0.1em; text-transform: uppercase; fill: var(--gris); opacity: 0; transition: opacity 0.5s; }

  .pt { fill: var(--gris-2); opacity: 0; transform: scale(0.2); transform-box: fill-box; transform-origin: center; transition: opacity 0.35s, transform 0.5s var(--courbe), fill 0.6s; }
  .p1 .pt, .p2 .pt, .p3 .pt, .p4 .pt { opacity: 1; transform: none; }
  .p2 .pt, .p3 .pt { fill: var(--encre); }
  .p4 .pt.z0 { fill: var(--encre); }
  .p4 .pt.z1 { fill: var(--accent); }

  .moy { stroke: var(--gris); stroke-width: 2; stroke-dasharray: 6 6; opacity: 0; transition: opacity 0.5s 0.8s; }
  .p1 .moy, .p1 .moy-l { opacity: 1; }
  .p2 .moy, .p3 .moy, .p4 .moy { opacity: 0.35; transition-delay: 0s; }

  .dr { stroke-width: 3; stroke-linecap: square; stroke-dasharray: 1000; stroke-dashoffset: 1000; transition: stroke-dashoffset 1.3s var(--courbe), opacity 0.5s, stroke 0.5s; }
  .dr.tout { stroke: var(--accent); }
  .p2 .dr.tout, .p3 .dr.tout { stroke-dashoffset: 0; }
  .p2 .dr-l { opacity: 1; transition-delay: 0.9s; }
  .p4 .dr.tout { stroke-dashoffset: 0; stroke: var(--gris-2); stroke-dasharray: 8 6; }

  .bande { fill: var(--accent); opacity: 0; transition: opacity 0.7s; }
  .p3 .bande { opacity: 0.14; }
  .p3 .bande-l { opacity: 1; transition-delay: 0.4s; fill: var(--accent); }

  .dr.g0 { stroke: var(--encre); }
  .dr.g1 { stroke: var(--accent); }
  .p4 .dr.g0, .p4 .dr.g1 { stroke-dashoffset: 0; }

  .goa { opacity: 0; transition: opacity 0.6s 0.5s; }
  .goa circle { fill: var(--fond); stroke: var(--encre); stroke-width: 2; }
  .goa circle.z { stroke: var(--accent); }
  .goa text { font-family: var(--mono); font-size: 13px; font-weight: 600; fill: var(--encre); }
  .goa text.z { fill: var(--accent); }
  .goa line { stroke: var(--encre); stroke-width: 2; }
  .goa line.z { stroke: var(--accent); }
  .p4 .goa { opacity: 1; }

  .temps { display: grid; grid-template-columns: repeat(4, 1fr); border-top: var(--trait); border-bottom: var(--trait); }
  .temps button { display: flex; align-items: baseline; gap: 0.6em; padding: 0.7em 0.2em; text-align: left; border-right: var(--trait-fin); font-family: var(--mono); color: var(--gris-2); transition: color 0.2s; position: relative; }
  .temps button:last-child { border-right: 0; }
  .temps .n { font-weight: 600; font-size: 1.15rem; line-height: 1; }
  .temps .t { font-size: 0.66rem; letter-spacing: 0.14em; text-transform: uppercase; }
  .temps button.fait { color: var(--encre); }
  .temps button.on { color: var(--accent); }
  .temps button.on::after { content: ''; position: absolute; left: 0; right: 0; bottom: -2px; height: 4px; background: var(--accent); }
  .temps button:hover { color: var(--accent); }
  figcaption { display: flex; justify-content: space-between; gap: 1.5rem; align-items: baseline; flex-wrap: wrap; }
  figcaption .l { font-size: 0.9rem; line-height: 1.45; max-width: 34em; }
  figcaption .note { font-size: 0.62rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--gris-2); white-space: nowrap; }
  @media (max-width: 40rem) {
    .temps .t { display: none; }
    .temps button { justify-content: center; }
  }
</style>
