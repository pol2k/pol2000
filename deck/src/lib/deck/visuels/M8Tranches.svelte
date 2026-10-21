<script>
  /**
   * « À âge égal », tranche par tranche. Les 20 180 de la CES (cas
   * complets, TRANCHES.n), comme TIERS à la séance 7. On coupe la salle en
   * trois tranches d'âge et on trace, dans chacune, la droite de la
   * scolarité (les points : l'intérêt moyen à chaque niveau).
   *
   *   0  les trois tranches, leurs points et leurs droites;
   *   1  la pente de chaque tranche, et en haut la pente de tout le monde
   *      ensemble : chaque tranche monte plus que l'ensemble;
   *   2  le modèle avec l'âge donne une pente « à âge égal » : il compare des
   *      gens du même âge, comme les tranches.
   *
   * Tout vient de TRANCHES (src/lib/data/seance8.js). L'axe des y va de 0,4
   * à 0,9 (les moyennes), il est écrit sur la figure.
   */
  import { brancherTemps } from '../temps.js';
  import { TRANCHES as T } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const LARG = 250, GAP = 70, XD = 70, YH = 110, YB = 400, YMIN = 0.4, YMAX = 0.9;
  const ox = (i) => XD + i * (LARG + GAP);
  const py = (y) => YB - ((y - YMIN) / (YMAX - YMIN)) * (YB - YH);
</script>

<div class="visuel m8t" bind:this={hote}>
  <svg viewBox="0 0 1000 520" role="img" aria-label="Dans la CES, la pente de la scolarité est {sg(T.b1_seul)} pour tout le monde ensemble, mais {T.tranches.map((t) => `${sg(t.b1)} chez les ${t.nom}`).join(', ')}. À âge égal, le modèle donne {sg(T.b1_a_egal)}.">
    <g class="etape" class:vu={e >= 1}>
      <text x="0" y="34" class="haut">tout le monde ensemble{' '}: <tspan class="val">{sg(T.b1_seul)}</tspan></text>
    </g>
    <text x="0" y={py(YMAX) - 34} class="mini">intérêt moyen (axe de 0,4 à 0,9)</text>
    {#each T.tranches as t, i}
      {@const x0 = ox(i)}
      <rect x={x0} y={YH - 10} width={LARG} height={YB - YH + 20} class="cadre" />
      {#each [0.5, 0.7] as g}
        <line x1={x0} y1={py(g)} x2={x0 + LARG} y2={py(g)} class="grille" />
        {#if i === 0}<text x={x0 - 8} y={py(g) + 6} class="tick">{f(g, 1)}</text>{/if}
      {/each}
      {#each t.moyennes as m, k}
        <circle cx={x0 + 20 + (k * (LARG - 40)) / 4} cy={py(m)} r="7" class="pt" />
      {/each}
      <line x1={x0 + 20} y1={py(t.b0)} x2={x0 + LARG - 20} y2={py(t.b0 + t.b1)} class="dr" />
      <text x={x0 + LARG / 2} y={YB + 40} class="nom">{t.nom}</text>
      <text x={x0 + LARG / 2} y={YB + 64} class="mini c">{nb(t.n)} personnes</text>
      <text x={x0 + 18} y={YH + 22} class="pente etape" class:vu={e >= 1}>{sg(t.b1)}</text>
    {/each}
    <text x={ox(0) + 20} y={YB + 92} class="mini">chaque tranche{' '}: de « secondaire non terminé » (gauche) à « maîtrise, doctorat » (droite)</text>
    <g class="etape" class:vu={e >= 2}>
      <rect x="560" y="2" width="440" height="50" class="boite" />
      <text x="780" y="36" class="egal">à âge égal{' '}: {sg(T.b1_a_egal)}</text>
    </g>
    <text x="0" y="516" class="source">La CES, les {nb(T.n)} qui ont répondu aux trois questions (scolarité, intérêt, âge)</text>
  </svg>
</div>

<style>
  .m8t { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }
  .cadre { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .tick { font-size: 16px; fill: var(--dk-gris); text-anchor: end; }
  .pt { fill: var(--dk-encre); }
  .dr { stroke: var(--dk-accent); stroke-width: 5; }
  .nom { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .mini { font-size: 15px; fill: var(--dk-gris); }
  .c { text-anchor: middle; }
  .pente { font-size: 28px; font-weight: 700; fill: var(--dk-accent); }
  .haut { font-size: 24px; font-weight: 600; fill: var(--dk-gris); }
  .val { fill: var(--dk-encre); font-weight: 700; }
  .boite { fill: var(--dk-encre); }
  .egal { font-size: 26px; font-weight: 700; fill: var(--dk-fond); text-anchor: middle; }
  .source { font-size: 15px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .etape { transition: none; } }
</style>
