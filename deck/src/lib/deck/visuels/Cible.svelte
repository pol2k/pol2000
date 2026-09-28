<script>
  /**
   * Le biais et la variance, en quatre cibles : la figure 4.1
   * d'Arel-Bundock (2021, p. 66-67), redessinée. Schéma, aucune donnée.
   * En colonnes, la variance (faible, élevée); en rangées, le biais (faible,
   * élevé). Le centre rouge est la vraie valeur. Deux temps.
   *
   *   0  Quatre cibles vides et leurs en-têtes.
   *   1  Dans chaque cible, dix X : l'estimé de dix échantillons. Serrés au
   *      centre, dispersés autour du centre, serrés mais décalés, dispersés
   *      et décalés. Les positions sont fixes (un motif de dix points dont la
   *      moyenne est exactement zéro, retourné d'une cible à l'autre), puis
   *      une ligne : biais, la justesse, variance, la précision.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Dix points dans un disque unité, de moyenne exactement nulle sur les deux axes.
  const MOTIF = [[0.2, 0.1], [-0.5, 0.3], [0.6, -0.4], [-0.3, -0.6], [0.8, 0.2], [-0.8, -0.1], [0.1, 0.8], [0.3, -0.9], [-0.4, 0.7], [0, -0.1]];
  const R = 78;
  const COLS = [430, 750];
  const RANGS = [148, 330];
  const SERRE = 13, LARGE = 50;
  const DECALAGE = [32, -28];
  // [colonne, rangée, dispersion, décalage, retournement du motif]
  const CIBLES = [
    { c: 0, r: 0, s: SERRE, d: [0, 0], f: [1, 1] },
    { c: 1, r: 0, s: LARGE, d: [0, 0], f: [-1, 1] },
    { c: 0, r: 1, s: SERRE, d: DECALAGE, f: [1, -1] },
    { c: 1, r: 1, s: LARGE, d: DECALAGE, f: [-1, -1] }
  ].map((q) => ({
    cx: COLS[q.c],
    cy: RANGS[q.r],
    x: MOTIF.map(([u, v]) => [COLS[q.c] + q.d[0] + u * q.f[0] * q.s, RANGS[q.r] + q.d[1] + v * q.f[1] * q.s])
  }));
  const B = 7;
</script>

<div class="visuel cible-bv" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Schéma&#8239;: quatre cibles. En colonnes, variance faible et variance élevée. En rangées, biais faible et biais élevé. Chaque X est l’estimé d’un échantillon. Biais faible et variance faible&#8239;: les X sont serrés au centre. Biais faible et variance élevée&#8239;: dispersés autour du centre. Biais élevé et variance faible&#8239;: serrés mais à côté du centre. Biais élevé et variance élevée&#8239;: dispersés et à côté.">
    <text x="990" y="22" class="cib-note">schéma</text>
    <text x="10" y="22" class="cib-src">Arel-Bundock (2021, p. 66-67, figure 4.1)</text>

    <text x={COLS[0]} y="56" class="cib-col">variance faible</text>
    <text x={COLS[1]} y="56" class="cib-col">variance élevée</text>
    <text x="300" y={RANGS[0] + 8} class="cib-rang">biais faible</text>
    <text x="300" y={RANGS[1] + 8} class="cib-rang">biais élevé</text>

    {#each CIBLES as q, k}
      <g class="cib-cible" style="animation-delay: {k * 90}ms">
        <circle cx={q.cx} cy={q.cy} r={R} class="cib-anneau cib-ext" />
        <circle cx={q.cx} cy={q.cy} r={R * (2 / 3)} class="cib-anneau" />
        <circle cx={q.cx} cy={q.cy} r={R / 3} class="cib-anneau" />
        <circle cx={q.cx} cy={q.cy} r="8" class="cib-centre" />
      </g>
    {/each}

    <!-- Temps 1 : les X. -->
    <g class="cib-etape" class:cib-vu={e >= 1}>
      {#each CIBLES as q, k}
        {#each q.x as [px, py], j}
          <path d="M {px - B} {py - B} L {px + B} {py + B} M {px + B} {py - B} L {px - B} {py + B}" class="cib-x" style="transition-delay: {e >= 1 ? k * 220 + j * 35 : 0}ms" />
        {/each}
      {/each}
      <text x="352" y="446" class="cib-leg">chaque X&#8239;: l’estimé d’un échantillon</text>
      <text x="352" y="478" class="cib-ligne">biais&#8239;: la justesse · variance&#8239;: la précision</text>
    </g>
  </svg>
</div>

<style>
  .cible-bv { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .cib-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }
  .cib-src { font-size: 17px; fill: var(--dk-gris); }
  .cib-col { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .cib-rang { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .cib-cible { animation: cib-fondu 0.5s ease-out both; }
  @keyframes cib-fondu { from { opacity: 0; } to { opacity: 1; } }
  .cib-anneau { fill: none; stroke: var(--dk-gris-2); stroke-width: 2.5; }
  .cib-ext { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .cib-centre { fill: var(--dk-accent); }
  .cib-x { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; opacity: 0; transition: opacity 0.25s; }
  .cib-etape.cib-vu .cib-x { opacity: 1; }
  .cib-leg { font-size: 22px; fill: var(--dk-encre); }
  .cib-ligne { font-size: 20px; fill: var(--dk-gris); }
  .cib-leg, .cib-ligne { opacity: 0; transition: opacity 0.3s; }
  .cib-etape.cib-vu .cib-leg { opacity: 1; transition: opacity 0.5s 1s; }
  .cib-etape.cib-vu .cib-ligne { opacity: 1; transition: opacity 0.5s 1.3s; }

  @media (prefers-reduced-motion: reduce) {
    .cib-cible { animation: none; }
    .cib-x, .cib-leg, .cib-ligne, .cib-etape.cib-vu .cib-leg, .cib-etape.cib-vu .cib-ligne { transition: none; }
  }
</style>
