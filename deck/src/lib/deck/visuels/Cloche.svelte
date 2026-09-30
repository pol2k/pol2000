<script>
  /**
   * D'où vient la cloche : additionner des petits hasards. On lance k pièces,
   * on compte les piles, et on recommence 10 000 fois (R, set.seed(51)).
   * Quatre panneaux côte à côte, un par temps : 1, 2, 5, puis 20 pièces.
   * Chaque panneau est mis à l'échelle de son plus haut bâton.
   *
   *   0  1 pièce : deux bâtons égaux. Pas de cloche.
   *   1  2 pièces : un triangle.
   *   2  5 pièces : ça s'arrondit.
   *   3  20 pièces : la cloche, en rouge, et son nom. Une phrase dessous.
   *
   * Les effectifs viennent de CLOCHE (src/lib/data/seance5_normale.js,
   * outils/seance5_normale.R). Rien d'autre à l'écran que des bâtons : pas
   * de nombres à lire.
   */
  import { brancherTemps } from '../temps.js';
  import { CLOCHE } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const L = 215, G = 30, X0 = (1000 - (4 * L + 3 * G)) / 2, BASE = 330, HAUT = 200;
  const PANNEAUX = CLOCHE.map((c, i) => {
    const max = Math.max(...c.effectifs);
    const larg = L / c.effectifs.length;
    return {
      pieces: c.pieces,
      x: X0 + i * (L + G),
      batons: c.effectifs.map((v, j) => ({ dx: j * larg, w: larg, h: (v / max) * HAUT }))
    };
  });
</script>

<div class="visuel cloche" bind:this={hote}>
  <svg viewBox="0 0 1000 450" role="img" aria-label="On lance des pièces et on compte les piles, 10 000 fois. Avec 1 pièce, deux bâtons égaux. Avec 2, un triangle. Avec 5, ça s’arrondit. Avec 20, une cloche : la courbe normale. Additionner beaucoup de petits hasards donne une cloche.">
    <text x="500" y="40" class="cl-consigne">lancer des pièces, compter les piles, recommencer {f(10000)} fois</text>
    {#each PANNEAUX as p, i}
      <g class="cl-panneau" class:cl-vu={e >= i}>
        {#each p.batons as b}
          <rect x={p.x + b.dx + 1} y={BASE - b.h} width={Math.max(1, b.w - 2)} height={b.h} class="cl-baton" class:cl-rouge={i === 3 && e >= 3} />
        {/each}
        <line x1={p.x} y1={BASE} x2={p.x + L} y2={BASE} class="cl-axe" />
        <text x={p.x + L / 2} y={BASE + 40} class="cl-n">{p.pieces} pièce{p.pieces > 1 ? 's' : ''}</text>
      </g>
    {/each}
    <g class="cl-fin" class:cl-vu={e >= 3}>
      <text x={PANNEAUX[3].x + L / 2} y="100" class="cl-nom">la courbe normale</text>
      <text x="500" y="432" class="cl-phrase">Additionner beaucoup de petits hasards donne une cloche.</text>
    </g>
  </svg>
</div>

<style>
  .cloche { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .cl-consigne { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }
  .cl-baton { fill: var(--dk-encre); transition: fill 0.5s; }
  .cl-baton.cl-rouge { fill: var(--dk-accent); }
  .cl-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .cl-n { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .cl-nom { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .cl-phrase { font-size: 27px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .cl-panneau, .cl-fin { opacity: 0; transition: opacity 0.3s; }
  .cl-panneau.cl-vu, .cl-fin.cl-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .cl-baton, .cl-panneau, .cl-fin, .cl-panneau.cl-vu, .cl-fin.cl-vu { transition: none; }
  }
</style>
