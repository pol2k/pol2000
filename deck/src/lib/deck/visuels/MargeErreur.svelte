<script>
  /**
   * La marge d'erreur, d'où elle vient. Les moyennes d'âge de 1 000
   * échantillons de 50 répondant.e.s (la cloche des diapos précédentes),
   * autour de la vraie moyenne des 20 180. Quatre temps.
   *
   *   0  L'histogramme des 1 000 moyennes (tranches d'une demi-année) et la
   *      vraie moyenne.
   *   1  Une bande de ± marge autour de la vérité, où marge = 1,96 × l'écart
   *      type des 1 000 moyennes mesuré par R
   *      (DISTRIBUTIONS[1].ecartTypeDesMoyennes). Les moyennes dedans restent
   *      noires, celles dehors passent au rouge. Le compte de celles qui sont
   *      dedans est fait ici, sur les 1 000 moyennes de R, et affiché tel
   *      quel (941 : « à peu près 19 sur 20 », le hasard de la simulation).
   *   2  Le renversement : un seul échantillon (le premier des trois de la
   *      diapo « Trois échantillons », TROIS[0]), et la même marge autour de
   *      SA moyenne.
   *   3  La vérité est dedans. 19 fois sur 20, ça marche : c'est la marge
   *      d'erreur.
   *
   * Tout vient de src/lib/data/seance5.js (outils/seance5_data.R). Le
   * facteur 1,96 est la convention des sondeurs, écrit ici.
   */
  import { brancherTemps } from '../temps.js';
  import { POP, DISTRIBUTIONS, MOYENNES_50, TROIS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');

  const VRAI = POP.moyenne;
  // La marge : 1,96 fois l'écart entre les 1 000 moyennes, mesuré par R.
  const MARGE = 1.96 * DISTRIBUTIONS[1].ecartTypeDesMoyennes;
  const DEDANS = MOYENNES_50.filter((m) => Math.abs(m - VRAI) <= MARGE).length;
  const UN = TROIS[0].moyenne;

  const A0 = 38, A1 = 62, X0 = 80, X1 = 920, BASE = 300, HAUT = 170;
  const x = (a) => X0 + ((a - A0) / (A1 - A0)) * (X1 - X0);
  const PAS = 0.5;
  const BORNES = Array.from({ length: (A1 - A0) / PAS }, (_, j) => A0 + j * PAS);
  const COMPTES = BORNES.map((b) => MOYENNES_50.filter((m) => m >= b && m < b + PAS).length);
  const MAX = Math.max(...COMPTES);
  const L = x(A0 + PAS) - x(A0);
  const dehors = (b) => b + PAS / 2 < VRAI - MARGE || b + PAS / 2 > VRAI + MARGE;
  const YU = 372;
</script>

<div class="visuel marge-erreur" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Les moyennes d’âge de 1 000 échantillons de 50 personnes. {DEDANS} sur 1 000 tombent à moins de {f(MARGE, 1)} ans de la vraie moyenne, {f(VRAI, 1)} ans : 19 fois sur 20. Avec un seul échantillon, de moyenne {f(UN, 1)} ans, on prend la même marge autour de sa moyenne : de {f(UN - MARGE, 1)} à {f(UN + MARGE, 1)} ans. La vérité est dedans. C’est la marge d’erreur.">
    <text x={X0} y="30" class="me-titre">les moyennes d’âge de {f(1000)} échantillons de 50</text>

    <!-- 1 : la bande autour de la vérité. -->
    <rect x={x(VRAI - MARGE)} y={BASE - HAUT - 30} width={x(VRAI + MARGE) - x(VRAI - MARGE)} height={HAUT + 30} class="me-bande me-etape" class:me-vu={e === 1} />

    {#each BORNES as b, j}
      {@const h = (COMPTES[j] / MAX) * HAUT}
      <rect x={x(b) + 0.5} y={BASE - h} width={L - 1} height={h} class="me-baton" class:me-rouge={e >= 1 && dehors(b)} class:me-pale={e >= 2} />
    {/each}

    <line x1={x(VRAI)} y1={BASE - HAUT - 34} x2={x(VRAI)} y2={BASE} class="me-vrai" />
    <line x1={x(VRAI)} y1={BASE + 34} x2={x(VRAI)} y2={YU + 22} class="me-vrai me-etape" class:me-vu={e >= 2} />
    <text x={x(VRAI)} y={BASE - HAUT - 44} class="me-vrai-t">la vérité&#8239;: {f(VRAI, 1)} ans</text>

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="me-axe" />
    {#each [40, 45, 50, 55, 60] as a}
      <line x1={x(a)} y1={BASE} x2={x(a)} y2={BASE + 7} class="me-axe" />
      <text x={x(a)} y={BASE + 27} class="me-tick">{a}</text>
    {/each}

    <g class="me-etape" class:me-vu={e === 1}>
      <text x={x(VRAI + MARGE) + 14} y={BASE - 120} class="me-compte">{DEDANS} sur {f(1000)}</text>
      <text x={x(VRAI + MARGE) + 14} y={BASE - 92} class="me-lab">à moins de {f(MARGE, 1)} ans</text>
      <text x={x(VRAI + MARGE) + 14} y={BASE - 66} class="me-lab">de la vérité</text>
      <text x="500" y={YU + 16} class="me-phrase">{DEDANS} sur {f(1000)}&#8239;: à peu près 19 échantillons sur 20.</text>
    </g>

    <!-- 2 : un seul échantillon, la même marge autour de sa moyenne. -->
    <g class="me-etape" class:me-vu={e >= 2}>
      <line x1={x(UN - MARGE)} y1={YU} x2={x(UN + MARGE)} y2={YU} class="me-fourchette" />
      <line x1={x(UN - MARGE)} y1={YU - 12} x2={x(UN - MARGE)} y2={YU + 12} class="me-fourchette-b" />
      <line x1={x(UN + MARGE)} y1={YU - 12} x2={x(UN + MARGE)} y2={YU + 12} class="me-fourchette-b" />
      <circle cx={x(UN)} cy={YU} r="9" class="me-point" />
      <text x={x(UN - MARGE) - 16} y={YU + 7} class="me-un">un seul échantillon&#8239;: {f(UN, 1)} ans</text>
      <text x="500" y="436" class="me-phrase">Avec un seul échantillon, on prend la même marge autour de sa moyenne.</text>
    </g>

    <!-- 3 : la vérité est dedans. -->
    <g class="me-etape" class:me-vu={e >= 3}>
      <text x="500" y="470" class="me-phrase me-rouge-t">La vérité est dedans, 19 fois sur 20. C’est la marge d’erreur.</text>
    </g>
  </svg>
</div>

<style>
  .marge-erreur { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .me-titre { font-size: 20px; fill: var(--dk-gris); }
  .me-bande { fill: var(--dk-fond-2); }
  .me-baton { fill: var(--dk-encre); transition: fill 0.4s, opacity 0.4s; }
  .me-baton.me-rouge { fill: var(--dk-accent); }
  .me-baton.me-pale { opacity: 0.25; }
  .me-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .me-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .me-tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .me-compte { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .me-lab { font-size: 19px; fill: var(--dk-encre); }
  .me-fourchette { stroke: var(--dk-accent); stroke-width: 8; }
  .me-fourchette-b { stroke: var(--dk-accent); stroke-width: 4; }
  .me-point { fill: var(--dk-encre); }
  .me-un { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .me-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-rouge-t { fill: var(--dk-accent); }
  .me-etape { opacity: 0; transition: opacity 0.3s; }
  .me-etape.me-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .me-etape, .me-etape.me-vu, .me-baton { transition: none; }
  }
</style>
