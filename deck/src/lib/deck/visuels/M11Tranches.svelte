<script>
  /**
   * Ce que « contrôler Z » veut dire, sur les vraies données simulées de
   * la collision (Arel-Bundock 2021, simulation 3, p. 133-134) : on ne
   * compare plus que des observations qui ont le même Z, une tranche à la
   * fois.
   *
   *   0  400 points (X, Y) et la droite sans contrôle : 1,70, le vrai effet;
   *   1  une tranche de Z (Z près de 0) s'allume, le reste s'efface : dans
   *      la tranche, la droite tombe à 0,45;
   *   2  une autre tranche (Z près de 3) : même pente, 0,45. C'est ce que
   *      fait lm(Y ~ X + Z) : la pente commune des tranches;
   *   3  retour à tout le nuage : le vrai effet est 1,7. Contrôler Z, un
   *      descendant de X, a coupé une partie de l'effet.
   *
   * Rien n'est tapé à la main : les points (les 400 premières lignes des
   * données de set.seed(2026)) et les coefficients (estimés sur les 100 000
   * lignes) viennent de TRANCHES (src/lib/data/seance11.js,
   * outils/seance11_data.R). Données simulées.
   */
  import { brancherTemps } from '../temps.js';
  import { TRANCHES } from '$lib/data/seance11.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const G = 120, D = 1060, H = 30, B = 540;
  const px = (v) => G + ((v + 3.2) / 6.4) * (D - G);
  const py = (v) => B - ((v + 8) / 16) * (B - H);
  const DEMI = 0.45;
  const z0 = $derived(e === 1 ? 0 : e === 2 ? 3 : null);
  const dans = (p) => z0 !== null && Math.abs(p.z - z0) < DEMI;
  const { simple: S, controle: C } = TRANCHES;
  const virg = (v) => v.toFixed(2).replace('.', ',');
  // La droite d'une tranche : la pente de lm(Y ~ X + Z), à Z = z0, sur
  // l'étendue des X de la tranche.
  const ligneTranche = (z) => {
    const pts = TRANCHES.points.filter((p) => Math.abs(p.z - z) < DEMI);
    const x0 = Math.min(...pts.map((p) => p.x)), x1 = Math.max(...pts.map((p) => p.x));
    const f = (x) => C.a + C.b * x + C.bz * z;
    return { x1: px(x0), y1: py(f(x0)), x2: px(x1), y2: py(f(x1)) };
  };
  const T0 = ligneTranche(0), T3 = ligneTranche(3);
  const LS = { x1: px(-3), y1: py(S.a + S.b * -3), x2: px(3), y2: py(S.a + S.b * 3) };
  const LEG = [
    `Sans contrôle : ${virg(S.b)}. Le vrai effet.`,
    `Contrôler Z : ne comparer que des points au même Z. Dans la tranche : ${virg(C.b)}.`,
    `Une autre tranche, la même pente : ${virg(C.b)}. C’est lm(Y ~ X + Z).`,
    'Z est un descendant de X : le contrôler coupe une partie de l’effet.'
  ];
</script>

<div class="visuel m11r" bind:this={hote}>
  <svg viewBox="0 0 1100 600" role="img" aria-label="Un nuage de 400 points simulés. Sans contrôle, la pente vaut 1,70. Dans une tranche où Z est fixe, la pente tombe à 0,45.">
    <line x1={G} y1={B} x2={D} y2={B} class="axe" />
    <line x1={G} y1={B} x2={G} y2={H} class="axe" />
    <text x={(G + D) / 2} y={B + 48} class="titre-axe">X →</text>
    <text x={G - 30} y={(H + B) / 2} class="titre-axe">Y</text>

    {#each TRANCHES.points as p, i (i)}
      <circle cx={px(p.x)} cy={py(p.y)} r="6" class="pt" class:allume={dans(p)} class:efface={z0 !== null && !dans(p)} />
    {/each}

    <line {...LS} class="droite" class:pale={e === 1 || e === 2} />
    <line {...T0} class="tranche" class:vu={e === 1} />
    <line {...T3} class="tranche" class:vu={e === 2} />
    <text x={D - 10} y={LS.y2 + 40} class="etiq" class:pale={e === 1 || e === 2}>{virg(S.b)}</text>
    {#if e === 1}<text x={T0.x2 + 14} y={T0.y2 + 8} class="etiq rouge">{virg(C.b)}</text>{/if}
    {#if e === 2}<text x={T3.x2 + 14} y={T3.y2 + 8} class="etiq rouge">{virg(C.b)}</text>{/if}
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="cap">Données simulées · set.seed(2026) · 400 des 100 000 points · pentes estimées sur les 100 000</p>
</div>

<style>
  .m11r { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.25em; }
  svg { width: 100%; max-width: 44em; height: auto; max-height: 52vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .titre-axe { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .pt { fill: var(--dk-gris-2); opacity: 0.75; transition: opacity 0.5s, fill 0.4s; }
  .pt.allume { fill: var(--dk-accent); opacity: 1; }
  .pt.efface { opacity: 0.1; }
  .droite { stroke: var(--dk-encre); stroke-width: 6; transition: opacity 0.4s; }
  .droite.pale { opacity: 0.2; }
  .tranche { stroke: var(--dk-accent); stroke-width: 8; opacity: 0; transition: opacity 0.4s 0.4s; }
  .tranche.vu { opacity: 1; }
  .etiq { font-size: 30px; font-weight: 700; fill: var(--dk-encre); text-anchor: end; transition: opacity 0.4s; }
  .etiq.pale { opacity: 0.2; }
  .etiq.rouge { fill: var(--dk-accent); text-anchor: start; }
  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .pt, .droite, .tranche, .etiq { transition: none; } }
</style>
