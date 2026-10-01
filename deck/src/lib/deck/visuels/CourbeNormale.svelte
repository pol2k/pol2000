<script>
  /**
   * La courbe normale, l'idée générale. Après la planche de Galton (d'où elle
   * vient), ce qu'elle est. Un schéma, sans données : aucune valeur réelle
   * n'est montrée, pour ne pas vendre la réponse du quiz qui suit. Pas
   * d'écart type ici : il vient plus tard, juste avant la marge d'erreur
   * (EcartTypeNormale.svelte). Quatre temps.
   *
   *   0  La cloche se dessine : une seule bosse, au milieu.
   *   1  Symétrique : la moitié gauche est le miroir de la droite.
   *   2  Au centre : la moyenne, qui est aussi la médiane et la valeur la
   *      plus fréquente (le rappel de la séance 3).
   *   3  Des points s'empilent sous la courbe, une colonne par position :
   *      beaucoup près du centre, de moins en moins en s'éloignant. La
   *      plupart près du centre, les extrêmes sont rares.
   *
   * La courbe est la forme de la densité normale, dessinée ici. Les piles de
   * points sont calculées sur cette même courbe (la plus haute pile qui tient
   * dessous) : rien n'est tiré au hasard, rien n'est mesuré.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const CX = 500, SD = 118, BASE = 330, HAUT = 230;
  const x = (z) => CX + z * SD;
  const y = (z) => BASE - HAUT * Math.exp(-0.5 * z * z);
  const Z = Array.from({ length: 161 }, (_, i) => -4 + i * 0.05);
  const COURBE = 'M ' + Z.map((z) => `${x(z).toFixed(1)} ${y(z).toFixed(1)}`).join(' L ');

  // Les piles : une colonne tous les 0,2 (unités du schéma), des points de
  // rayon R empilés au pas P, autant qu'il en tient sous la courbe au bord
  // extérieur de la colonne.
  const R = 7, P = 16;
  const POINTS = [];
  for (let i = -15; i <= 15; i++) {
    const z = i * 0.2;
    const bord = Math.abs(z) + R / SD;
    const n = Math.floor((HAUT * Math.exp(-0.5 * bord * bord)) / P - 0.15);
    for (let k = 0; k < n; k++) POINTS.push({ cx: x(z), cy: BASE - R - 2 - k * P, d: Math.abs(i) * 0.03 + k * 0.02 });
  }
</script>

<div class="visuel courbe-normale" bind:this={hote}>
  <svg viewBox="0 0 1000 400" role="img" aria-label="La courbe normale : une seule bosse, au milieu. Elle est symétrique. Au centre, la moyenne, qui est aussi la médiane et la valeur la plus fréquente. Sous la courbe, des points s’empilent : la plupart près du centre, de moins en moins en s’éloignant. Les valeurs extrêmes sont rares.">
    <text x="980" y="22" class="cn-note">schéma</text>

    <!-- 3 : les piles de points, sous la courbe. -->
    <g class="cn-points" class:cn-vu={e >= 3}>
      {#each POINTS as p}
        <circle cx={p.cx.toFixed(1)} cy={p.cy.toFixed(1)} r={R} style="transition-delay: {e >= 3 ? p.d : 0}s" />
      {/each}
    </g>

    <!-- 0 : la cloche. -->
    <path d={COURBE} pathLength="1" class="cn-courbe" />
    <line x1={x(-4)} y1={BASE} x2={x(4)} y2={BASE} class="cn-axe" />
    <text x={x(0)} y={BASE - HAUT - 18} class="cn-lab" class:cn-cache={e >= 2}>une seule bosse, au milieu</text>

    <!-- 1 : symétrique. -->
    <g class="cn-etape" class:cn-vu={e >= 1 && e < 3}>
      <path d="M {x(-1.9)} {y(-1.9) - 26} q 60 -40 120 -20 M {x(-1.9) + 110} {y(-1.9) - 56} l 12 10 l -14 6" class="cn-miroir" />
      <path d="M {x(1.9)} {y(1.9) - 26} q -60 -40 -120 -20 M {x(1.9) - 110} {y(1.9) - 56} l -12 10 l 14 6" class="cn-miroir" />
      <text x={x(-2.6)} y={y(-2.6) - 40} class="cn-sym">symétrique</text>
    </g>

    <!-- 2 : le centre. -->
    <g class="cn-etape" class:cn-vu={e >= 2}>
      <line x1={x(0)} y1={BASE - HAUT - 6} x2={x(0)} y2={BASE} class="cn-centre" />
      <text x={x(0)} y={BASE - HAUT - 18} class="cn-lab">au centre&#8239;: la moyenne</text>
      <text x={x(0)} y={BASE - HAUT - 44} class="cn-petit">aussi la médiane, et la valeur la plus fréquente</text>
    </g>

    <!-- 3 : la plupart près du centre, les extrêmes rares. -->
    <g class="cn-etape" class:cn-vu={e >= 3}>
      <text x={x(0)} y={BASE + 40} class="cn-lab">la plupart, près du centre</text>
      <text x={x(-2.6)} y={BASE + 40} class="cn-rare cn-fin">← rares</text>
      <text x={x(2.6)} y={BASE + 40} class="cn-rare">rares →</text>
    </g>
  </svg>
</div>

<style>
  .courbe-normale { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .cn-note { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .cn-courbe { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: cn-trace 1.2s ease-out forwards; }
  @keyframes cn-trace { to { stroke-dashoffset: 0; } }
  .cn-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .cn-lab { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.3s; }
  .cn-petit { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .cn-centre { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 8 6; }
  .cn-miroir { fill: none; stroke: var(--dk-gris); stroke-width: 2.5; }
  .cn-sym { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .cn-rare { font-size: 20px; font-weight: 600; fill: var(--dk-gris); }
  .cn-fin { text-anchor: end; }
  .cn-points circle { fill: var(--dk-gris-2); opacity: 0; transition: opacity 0.25s; }
  .cn-points.cn-vu circle { opacity: 1; }
  .cn-cache { opacity: 0; }
  .cn-etape { opacity: 0; transition: opacity 0.3s; }
  .cn-etape.cn-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .cn-courbe { animation: none; stroke-dashoffset: 0; }
    .cn-etape, .cn-etape.cn-vu, .cn-lab, .cn-points circle { transition: none !important; }
  }
</style>
