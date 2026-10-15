<script>
  /**
   * « L'erreur type », séance 7 : la distance typique entre la pente d'un
   * sondage et la vraie pente. Le même langage qu'à la séance 5
   * (EcartTypeCes : « l'écart type, la distance typique »), appliqué aux
   * 1 000 pentes de « Et si on recommençait ? ».
   *
   *   0  Les 1 000 pentes de sondages de 1 000 au hasard (MILLE.hasard,
   *      tranches de 0,01), et la vraie pente en pointillé (POP.b1, +0,17).
   *   1  Notre sondage dans la cloche : un triangle à NOTRE.coefs[1].b
   *      (+0,20), une pente parmi les autres, à 0,03 de la vraie.
   *   2  La règle rouge d'une erreur type (MILLE.ecart_type_hasard, 0,033,
   *      l'écart type des 1 000 pentes), de chaque côté de la vraie pente,
   *      et la définition en mots. Pas de formule. L'erreur type s'écrit
   *      avec trois décimales, comme à la diapo « Et avec un seul
   *      sondage ? » (0,032).
   *
   * Sources : POP, NOTRE, MILLE (src/lib/data/seance7.js, outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, NOTRE, MILLE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');

  const sg = (v, d) => (v > 0 ? '+' : '') + f(v, d);
  const A0 = 0.04, A1 = 0.3, X0 = 80, X1 = 920, AXE = 330, HMAX = 186;
  const x = (v) => X0 + ((v - A0) / (A1 - A0)) * (X1 - X0);
  const L = 0.01;
  const NB = Math.round((A1 - A0) / L);
  const C = new Array(NB).fill(0);
  for (const p of MILLE.hasard) C[Math.min(NB - 1, Math.max(0, Math.floor((p - A0) / L + 1e-9)))]++;
  const YMAX = Math.max(...C);
  const BARRES = C.map((c, j) => ({ a: A0 + j * L, c, h: (c / YMAX) * HMAX, d: j * 18 })).filter((b) => b.c > 0);
  const TICKS = [0.05, 0.1, 0.15, 0.2, 0.25, 0.3];

  const V = POP.b1, ET = MILLE.ecart_type_hasard, NOUS = NOTRE.coefs[1].b;
  const XV = x(V), XG = x(V - ET), XD = x(V + ET), XN = x(NOUS);
  const YR = 122;

  const ARIA =
    `Les pentes de 1 000 sondages de 1 000 personnes tirées au hasard, en cloche autour de la vraie pente, ${sg(V, 2)}. ` +
    `Notre sondage, ${sg(NOUS, 2)}, est l’une d’elles. La distance typique entre la pente d’un sondage et la vraie pente est de ${f(ET, 3)} : c’est l’erreur type.`;
</script>

<div class="visuel d7-erreur type" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label={ARIA}>
    <text x={X0} y="22" class="et-cap">{f(1000)} sondages de {f(1000)} au hasard{NN}: leurs pentes</text>

    <!-- 2 : la bande d'une erreur type de chaque côté. -->
    <rect x={XG} y={YR} width={XD - XG} height={AXE - YR} class="et-bande" class:et-vu={e >= 2} />

    <!-- 0 : la cloche. -->
    {#each BARRES as b}
      <rect x={x(b.a) + 1} y={AXE - b.h} width={x(b.a + L) - x(b.a) - 2} height={b.h} class="et-baton" style="animation-delay: {b.d}ms" />
    {/each}

    <line x1={XV} y1="66" x2={XV} y2={AXE} class="et-vrai" />
    <text x={XV} y="56" class="et-vrai-t">la vraie pente{NN}: {sg(V, 2)}</text>

    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="et-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 8} class="et-axe" />
      <text x={x(t)} y={AXE + 32} class="et-tick">{f(t, 2)}</text>
    {/each}

    <!-- 1 : notre sondage. -->
    <g class="et-etape" class:et-vu={e >= 1}>
      <path d="M {XN} {AXE + 40} l -11 18 h 22 z" class="et-tri" />
      <text x={XN + 18} y={AXE + 58} class="et-nous">notre sondage{NN}: {sg(NOUS, 2)}</text>
    </g>

    <!-- 2 : la règle, de chaque côté. -->
    <g class="et-etape" class:et-vu={e >= 2}>
      <line x1={XG} y1={YR} x2={XD} y2={YR} class="et-regle" />
      <line x1={XG} y1={YR - 10} x2={XG} y2={YR + 10} class="et-regle" />
      <line x1={XV} y1={YR - 10} x2={XV} y2={YR + 10} class="et-regle" />
      <line x1={XD} y1={YR - 10} x2={XD} y2={YR + 10} class="et-regle" />
      <text x={(XG + XV) / 2} y={YR - 16} class="et-et">{f(ET, 3)}</text>
      <text x={(XV + XD) / 2} y={YR - 16} class="et-et">{f(ET, 3)}</text>
      <text x="500" y="448" class="et-def">L’erreur type{NN}: la distance typique</text>
      <text x="500" y="484" class="et-def">entre la pente d’un sondage et la vraie pente.</text>
    </g>
  </svg>
</div>

<style>
  .d7-erreur type { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .et-cap { font-size: 20px; fill: var(--dk-gris); }
  .et-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; animation: et-monte 0.5s ease-out both; }
  @keyframes et-monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .et-bande { fill: var(--dk-accent); fill-opacity: 0.12; opacity: 0; transition: opacity 0.4s; }
  .et-bande.et-vu { opacity: 1; }

  .et-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .et-vrai-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .et-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }

  .et-tri { fill: var(--dk-encre); }
  .et-nous { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }

  .et-regle { stroke: var(--dk-accent); stroke-width: 5; }
  .et-et { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .et-def { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .et-etape { opacity: 0; transition: opacity 0.2s; }
  .et-etape.et-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .et-baton { animation: none; }
    .et-etape, .et-etape.et-vu, .et-bande { transition: none; }
  }
</style>
