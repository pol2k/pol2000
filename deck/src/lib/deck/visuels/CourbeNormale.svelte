<script>
  /**
   * La courbe normale, expliquée. Après la planche de Galton (d'où elle
   * vient), ce qu'elle est. Un schéma, sans données : aucune valeur réelle
   * n'est montrée, pour ne pas vendre la réponse du quiz qui suit. Cinq
   * temps.
   *
   *   0  La cloche se dessine : une seule bosse, au milieu.
   *   1  Symétrique. Au centre : la moyenne, qui est aussi la médiane et la
   *      valeur la plus fréquente (le rappel de la séance 3).
   *   2  Sa largeur : l'écart type. Une règle graduée en écarts types sous
   *      l'axe. Deux nombres suffisent pour la décrire : le centre et la
   *      largeur.
   *   3  À moins d'un écart type du centre : environ 2 sur 3.
   *   4  À moins de deux écarts types : environ 19 sur 20. « Retenez ce 19 sur
   *      20 » : il revient avec la marge d'erreur.
   *
   * Les deux parts viennent de NORMALE (pnorm dans outils/seance5_normale.R).
   * La courbe est la densité normale, dessinée ici.
   */
  import { brancherTemps } from '../temps.js';
  import { NORMALE } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const pc = (p) => Math.round(p * 100);
  const CX = 500, SD = 118, BASE = 330, HAUT = 230;
  const x = (z) => CX + z * SD;
  const y = (z) => BASE - HAUT * Math.exp(-0.5 * z * z);
  const Z = Array.from({ length: 161 }, (_, i) => -4 + i * 0.05);
  const COURBE = 'M ' + Z.map((z) => `${x(z).toFixed(1)} ${y(z).toFixed(1)}`).join(' L ');
  const aire = (a, b) => {
    const zs = Z.filter((z) => z >= a - 1e-9 && z <= b + 1e-9);
    return `M ${x(a).toFixed(1)} ${BASE} ` + zs.map((z) => `L ${x(z).toFixed(1)} ${y(z).toFixed(1)}`).join(' ') + ` L ${x(b).toFixed(1)} ${BASE} Z`;
  };
</script>

<div class="visuel courbe-normale" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La courbe normale : une seule bosse, au milieu, symétrique. Au centre, la moyenne, qui est aussi la médiane et la valeur la plus fréquente. Sa largeur, c’est l’écart type. Environ {pc(NORMALE.un)} % des valeurs sont à moins d’un écart type du centre, environ 2 sur 3. Environ {pc(NORMALE.deux)} % à moins de deux écarts types, environ 19 sur 20.">
    <text x="980" y="22" class="cn-note">schéma</text>

    <!-- 4 puis 3 : les aires, la plus large d'abord. -->
    <path d={aire(-2, 2)} class="cn-aire cn-deux" class:cn-vu={e >= 4} />
    <path d={aire(-1, 1)} class="cn-aire cn-un" class:cn-vu={e >= 3} />

    <!-- 0 : la cloche. -->
    <path d={COURBE} pathLength="1" class="cn-courbe" />
    <line x1={x(-4)} y1={BASE} x2={x(4)} y2={BASE} class="cn-axe" />
    <text x={x(0)} y={BASE - HAUT - 18} class="cn-lab" class:cn-cache={e >= 1}>une seule bosse, au milieu</text>

    <!-- 1 : symétrique, et le centre. -->
    <g class="cn-etape" class:cn-vu={e >= 1}>
      <line x1={x(0)} y1={BASE - HAUT - 6} x2={x(0)} y2={BASE} class="cn-centre" />
      <text x={x(0)} y={BASE - HAUT - 18} class="cn-lab">au centre&#8239;: la moyenne</text>
      <text x={x(0)} y={BASE - HAUT - 44} class="cn-petit">aussi la médiane, et la valeur la plus fréquente</text>
      <path d="M {x(-1.9)} {y(-1.9) - 26} q 60 -40 120 -20 M {x(-1.9) + 110} {y(-1.9) - 56} l 12 10 l -14 6" class="cn-miroir" class:cn-cache={e >= 2} />
      <path d="M {x(1.9)} {y(1.9) - 26} q -60 -40 -120 -20 M {x(1.9) - 110} {y(1.9) - 56} l -12 10 l 14 6" class="cn-miroir" class:cn-cache={e >= 2} />
      <text x={x(-2.6)} y={y(-2.6) - 40} class="cn-sym" class:cn-cache={e >= 2}>symétrique</text>
    </g>

    <!-- 2 : la largeur, en écarts types. -->
    <g class="cn-etape" class:cn-vu={e >= 2}>
      {#each [-3, -2, -1, 0, 1, 2, 3] as z}
        <line x1={x(z)} y1={BASE} x2={x(z)} y2={BASE + 10} class="cn-axe" />
        {#if Math.abs(z) < 3}<text x={x(z)} y={BASE + 34} class="cn-tick">{z === 0 ? 'centre' : (z > 0 ? '+' : '−') + Math.abs(z)}</text>{/if}
      {/each}
      <text x={x(3.9)} y={BASE + 34} class="cn-tick cn-fin">écarts types</text>
      <path d="M {x(0)} {BASE + 52} H {x(1)} M {x(0)} {BASE + 46} v 12 M {x(1)} {BASE + 46} v 12" class="cn-regle" />
      <text x={x(1) + 12} y={BASE + 60} class="cn-regle-t">sa largeur&#8239;: l’écart type</text>
      <text x="500" y="438" class="cn-phrase" class:cn-cache={e >= 3}>Deux nombres suffisent pour la décrire&#8239;: le centre et la largeur.</text>
    </g>

    <!-- 3 et 4 : les parts. -->
    <g class="cn-etape" class:cn-vu={e >= 3}>
      <text x={x(0)} y={BASE - 60} class="cn-part">environ 2 sur 3</text>
      <text x={x(0)} y={BASE - 34} class="cn-part-s">à moins d’un écart type ({pc(NORMALE.un)}&#8239;%)</text>
    </g>
    <g class="cn-etape" class:cn-vu={e >= 4}>
      <text x={x(-2.35)} y={BASE - 88} class="cn-part cn-rouge cn-fin">environ 19 sur 20</text>
      <text x={x(-2.35)} y={BASE - 62} class="cn-part-s cn-fin">à moins de deux écarts types</text>
      <text x={x(-2.35)} y={BASE - 40} class="cn-part-s cn-fin">({pc(NORMALE.deux)}&#8239;%)</text>
      <text x="500" y="438" class="cn-phrase cn-rouge-t">Retenez ce 19 sur 20&#8239;: il reviendra.</text>
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
  .cn-miroir { fill: none; stroke: var(--dk-gris); stroke-width: 2.5; transition: opacity 0.3s; }
  .cn-sym { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); transition: opacity 0.3s; }
  .cn-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .cn-fin { text-anchor: end; }
  .cn-regle { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .cn-regle-t { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .cn-aire { opacity: 0; transition: opacity 0.6s; }
  .cn-aire.cn-vu { opacity: 1; }
  .cn-un { fill: var(--dk-gris-2); }
  .cn-un.cn-vu { opacity: 0.55; }
  .cn-deux { fill: var(--dk-fond-2); stroke: var(--dk-accent); stroke-width: 2; }
  .cn-part { font-size: 23px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .cn-part.cn-fin, .cn-part-s.cn-fin { text-anchor: end; }
  .cn-rouge { fill: var(--dk-accent); }
  .cn-part-s { font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }
  .cn-phrase { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.3s; }
  .cn-rouge-t { fill: var(--dk-accent); }
  .cn-cache { opacity: 0; }
  .cn-etape { opacity: 0; transition: opacity 0.3s; }
  .cn-etape.cn-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .cn-courbe { animation: none; stroke-dashoffset: 0; }
    .cn-etape, .cn-etape.cn-vu, .cn-aire, .cn-lab, .cn-miroir, .cn-sym, .cn-phrase { transition: none; }
  }
</style>
