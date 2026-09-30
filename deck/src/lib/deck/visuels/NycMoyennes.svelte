<script>
  /**
   * Même les bâtiments de New York. En haut, la hauteur des bâtiments : une
   * longue queue, pas une cloche (QUIZ, clé nyc). Dessous, trois rangées :
   * les moyennes de 1 000 échantillons de 10, de 100 puis de 2 000 bâtiments
   * (NYC_MOYENNES). Chaque rangée a son propre axe, un zoom sur ses moyennes :
   * c'est la forme qu'on regarde, pas la largeur. Un pointillé marque la
   * vraie moyenne des bâtiments dans chaque rangée.
   *
   *   0  Les bâtiments.
   *   1  + moyennes de 10 : encore penchées.
   *   2  + moyennes de 100 : ça s'arrondit.
   *   3  + moyennes de 2 000 : une cloche, en rouge, et la phrase.
   *
   * Tout vient de src/lib/data/seance5_normale.js (outils/seance5_normale.R).
   */
  import { brancherTemps } from '../temps.js';
  import { QUIZ, NYC_POP, NYC_MOYENNES } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const X0 = 300, X1 = 960, HAUT = 66, PAS = 94, Y0 = 96;
  const rangee = (bornes, effectifs, i, nom) => {
    const b0 = bornes[0], b1 = bornes[bornes.length - 1];
    const x = (v) => X0 + ((v - b0) / (b1 - b0)) * (X1 - X0);
    const max = Math.max(...effectifs);
    return {
      nom, base: Y0 + i * PAS,
      xp: x(NYC_POP.moyenne),
      batons: effectifs.map((c, j) => ({ x: x(bornes[j]), w: x(bornes[j + 1]) - x(bornes[j]), h: (c / max) * HAUT }))
    };
  };
  const NYC = QUIZ.find((q) => q.cle === 'nyc');
  const RANGEES = [
    rangee(NYC.bornes, NYC.effectifs, 0, 'les bâtiments'),
    ...NYC_MOYENNES.map((m, i) => rangee(m.bornes, m.effectifs, i + 1, `moyennes de ${f(m.n)}`))
  ];
</script>

<div class="visuel nyc-moyennes" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="La hauteur des bâtiments de New York forme une longue queue. Les moyennes de 1 000 échantillons de 10 bâtiments penchent encore, celles de 100 s’arrondissent, celles de 2 000 forment une cloche. Même quand les données ne font pas une cloche, les moyennes en font une.">
    {#each RANGEES as r, i}
      <g class="nm-rangee" class:nm-vu={e >= i}>
        <text x={X0 - 24} y={r.base - HAUT / 2 + 9} class="nm-nom" class:nm-premier={i === 0}>{r.nom}</text>
        {#each r.batons as b}
          <rect x={b.x + 0.5} y={r.base - b.h} width={Math.max(1, b.w - 1)} height={b.h} class="nm-baton" class:nm-rouge={i === 3} />
        {/each}
        <line x1={X0} y1={r.base} x2={X1} y2={r.base} class="nm-sol" />
        <line x1={r.xp} y1={r.base - HAUT - 6} x2={r.xp} y2={r.base} class="nm-pop" class:nm-pop-r={i < 3} />
      </g>
    {/each}
    <text x={X1} y={Y0 + 3 * PAS + 26} class="nm-zoom nm-rangee" class:nm-vu={e >= 1}>chaque rangée a son propre zoom · pointillé&#8239;: la vraie moyenne des bâtiments</text>
    <text x="500" y="458" class="nm-phrase nm-rangee" class:nm-vu={e >= 3}>Même quand les données ne font pas une cloche, les moyennes, elles, en font une.</text>
  </svg>
</div>

<style>
  .nyc-moyennes { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .nm-nom { font-size: 23px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .nm-baton { fill: var(--dk-encre); }
  .nm-baton.nm-rouge { fill: var(--dk-accent); }
  .nm-sol { stroke: var(--dk-encre); stroke-width: 2.5; }
  .nm-pop { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 7 6; }
  .nm-pop.nm-pop-r { stroke: var(--dk-accent); }
  .nm-zoom { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .nm-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .nm-rangee { opacity: 0; transition: opacity 0.3s; }
  .nm-rangee.nm-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .nm-rangee, .nm-rangee.nm-vu { transition: none; }
  }
</style>
