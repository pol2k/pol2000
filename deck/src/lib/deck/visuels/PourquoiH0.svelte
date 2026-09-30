<script>
  /**
   * Pourquoi passer par H0 ? La pomicultrice veut prouver H1 (« plus de
   * 100 g »). Mais H1 n'est pas un monde : c'est une infinité de mondes
   * (101 g ? 104 g ? 120 g ?), impossibles à construire un par un. H0
   * (« exactement 100 g ») est un seul monde, précis : on peut le construire
   * et y regarder son panier. Schéma, aucune donnée. Trois temps.
   *
   *   0  À gauche, H1 : des cloches pâles qui défilent, centrées sur 101,
   *      103, 106, 110, 115 g, et des points de suspension.
   *   1  À droite, H0 : une seule cloche, nette, centrée sur 100 g.
   *   2  La stratégie, en deux lignes : on ne prouve pas H1 directement, on
   *      montre que H0 explique très mal le panier, ce qui donne du poids à H1.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  // Une cloche schématique, centrée sur cx, de demi-largeur l, haute de h.
  const cloche = (cx, l, h, base) => {
    const pts = [];
    for (let k = -30; k <= 30; k++) {
      const u = k / 10;
      pts.push(`${(cx + (u * l) / 3).toFixed(1)} ${(base - h * Math.exp(-0.5 * u * u)).toFixed(1)}`);
    }
    return 'M ' + pts.join(' L ');
  };
  // À gauche : l'axe de 95 à 125 g sur 60 à 440.
  const xg = (g) => 60 + ((g - 95) / 30) * 380;
  const MONDES = [101, 103, 106, 110, 115, 121];
  // À droite : l'axe de 90 à 110 g sur 560 à 940.
  const xd = (g) => 560 + ((g - 90) / 20) * 380;
  const BASE = 290;
</script>

<div class="visuel pourquoi-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="H1, plus de 100 g, c’est une infinité de mondes possibles : 101 g, 104 g, 120 g… impossibles à construire un par un. H0, exactement 100 g, c’est un seul monde, qu’on peut construire. On ne prouve pas H1 directement : on montre que H0 explique très mal le panier, ce qui donne du poids à H1.">
    <text x="980" y="22" class="pq-note">schéma</text>
    <!-- H1 : des mondes sans fin. -->
    <text x="60" y="54" class="pq-h">H1</text>
    <text x="120" y="54" class="pq-t">plus de 100 g</text>
    <text x="60" y="88" class="pq-s">101 g&#8239;? 104 g&#8239;? 120 g&#8239;? des mondes sans fin</text>
    {#each MONDES as m, i}
      <path d={cloche(xg(m), 70, 130, BASE)} class="pq-cloche-h1" style="animation-delay: {i * 220}ms" />
    {/each}
    <text x={xg(125) + 6} y={BASE - 20} class="pq-points">…</text>
    <line x1="60" y1={BASE} x2="440" y2={BASE} class="pq-axe" />
    {#each [100, 110, 120] as g}
      <text x={xg(g)} y={BASE + 28} class="pq-tick">{g} g</text>
    {/each}
    <text x="60" y={BASE + 70} class="pq-verdict">impossibles à construire un par un</text>

    <!-- H0 : un seul monde. -->
    <g class="pq-etape" class:pq-vu={e >= 1}>
      <text x="560" y="54" class="pq-h pq-rouge">H0</text>
      <text x="620" y="54" class="pq-t">exactement 100 g</text>
      <text x="560" y="88" class="pq-s">des pommes ordinaires. Un seul monde.</text>
      <path d={cloche(xd(100), 150, 170, BASE)} class="pq-cloche-h0" />
      <line x1="560" y1={BASE} x2="940" y2={BASE} class="pq-axe" />
      {#each [90, 100, 110] as g}
        <text x={xd(g)} y={BASE + 28} class="pq-tick">{g} g</text>
      {/each}
      <text x="560" y={BASE + 70} class="pq-verdict pq-rouge">on peut le construire</text>
    </g>

    <!-- 2 : la stratégie. -->
    <g class="pq-etape" class:pq-vu={e >= 2}>
      <text x="500" y="430" class="pq-strat">On ne peut pas prouver H1 directement.</text>
      <text x="500" y="462" class="pq-strat pq-rouge">On montre que H0 explique très mal son panier. Ça donne du poids à H1.</text>
    </g>
  </svg>
</div>

<style>
  .pourquoi-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .pq-note { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .pq-h { font-size: 40px; font-weight: 700; fill: var(--dk-gris); }
  .pq-t { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .pq-s { font-size: 18px; fill: var(--dk-gris); }
  .pq-rouge { fill: var(--dk-accent); }
  .pq-cloche-h1 { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; opacity: 0; animation: pq-fondu 0.6s ease-out forwards; }
  @keyframes pq-fondu { to { opacity: 1; } }
  .pq-points { font-size: 40px; fill: var(--dk-gris); }
  .pq-cloche-h0 { fill: var(--dk-fond-2); stroke: var(--dk-accent); stroke-width: 4; }
  .pq-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .pq-tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .pq-verdict { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .pq-strat { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pq-etape { opacity: 0; transition: opacity 0.3s; }
  .pq-etape.pq-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .pq-cloche-h1 { animation: none; opacity: 1; }
    .pq-etape, .pq-etape.pq-vu { transition: none; }
  }
</style>
