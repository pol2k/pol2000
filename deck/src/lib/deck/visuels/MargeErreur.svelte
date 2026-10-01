<script>
  /**
   * La marge d'erreur, d'où elle vient. Fil rouge : « Notre budget : 1 000
   * personnes ». Les 20 180 répondant.e.s de l'Étude électorale canadienne
   * 2025 (BUDGET.population) servent de population d'exercice, on y connaît
   * la vraie part conservatrice (BUDGET.vrai, parmi celles et ceux qui
   * déclarent un vote). On part de ce qu'on a vraiment
   * (un seul échantillon de 1 000), on rappelle la cloche des 1 000
   * échantillons, on y mesure une règle de ± marge, puis on pose cette règle
   * sur notre échantillon à nous. Quatre temps.
   *
   *   0  Un seul échantillon de 1 000 tiré au hasard (celui de la diapo « au
   *      hasard », HASARD.part) : sa part conservatrice, un point sur l'axe.
   *      La question : est-ce la vraie part ?
   *   1  La cloche des parts conservatrices de 1 000 échantillons de 1 000
   *      tirés au hasard (MILLE.hasard.effectifs, tranches d'un demi-point
   *      bornées par MILLE.bornes) et la vraie part (BUDGET.vrai), qu'on
   *      connaît ici parce que les répondant.e.s sont une population
   *      d'exercice.
   *   2  Une règle rouge, centrée sur la vérité, de ± marge, où marge = 1,96 ×
   *      l'écart type des 1 000 parts (MILLE.hasard.marge, calculée par R à
   *      partir de MILLE.hasard.ecartType), soit environ deux écarts types,
   *      2,8 points. Les tranches hors de la règle passent au rouge (par le
   *      centre de chaque tranche, d'où un compte au dessin proche de celui
   *      de R). Le compte affiché est celui de R (MILLE.hasard.dedans : 944,
   *      « à peu près 19 sur 20 », le hasard de la simulation).
   *      Sous notre point, un crochet mesure l'écart entre notre part et la
   *      vérité (0,3 point) : il est bien plus court que la demi-règle.
   *   3  Le renversement : la règle glisse de la vérité jusqu'à NOTRE part.
   *      Si notre part est à moins d'une marge de la vérité, la vérité est à
   *      moins d'une marge de notre part : la règle l'attrape, 19 fois sur
   *      20. Posée sur notre échantillon, la règle prend la largeur que le
   *      sondeur calcule avec ce seul échantillon (HASARD.marge, 2,9 points,
   *      presque pareil que les 2,8 des 1 000 échantillons). C'est la marge
   *      d'erreur du journal, à la diapo suivante.
   *
   * Tout vient de src/lib/data/seance5_budget.js (outils/seance5_budget.R).
   * Le facteur 1,96 est la convention des sondeurs, appliqué dans R.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, HASARD, MILLE } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, '\u202F');
  // Tout en points de pourcentage : 0,331 devient 33,1.
  const pt = (p) => p * 100;
  const points = (v) => (Math.abs(v) < 2 ? 'point' : 'points');

  const H = MILLE.hasard;
  const N_ECH = H.effectifs.reduce((s, n) => s + n, 0); // 1 000 échantillons
  const VRAI = pt(BUDGET.vrai);
  // La règle des 1 000 échantillons : 1,96 fois leur écart type, calculé par R.
  const MARGE = pt(H.marge);
  const DEDANS = H.dedans;
  // Notre échantillon, et la marge que le sondeur calcule avec lui seul.
  const UN = pt(HASARD.part);
  const MARGE_UN = pt(HASARD.marge);
  const UN_ATTRAPE = Math.abs(UN - VRAI) <= MARGE_UN;
  const ECART = Math.abs(UN - VRAI);

  // L'axe des parts, partagé par la cloche et par notre échantillon.
  const A0 = 26, A1 = 40, X0 = 80, X1 = 920, BASE = 232, HAUT = 170;
  const PXA = (X1 - X0) / (A1 - A0);
  const x = (a) => X0 + (a - A0) * PXA;
  const TICKS = Array.from({ length: (A1 - A0) / 2 + 1 }, (_, i) => A0 + 2 * i);
  // Les tranches d'un demi-point de R, [borne, borne suivante), gardées si elles tiennent dans l'axe.
  const B = MILLE.bornes.map((b) => Math.round(b * 1000) / 10);
  const TRANCHES = H.effectifs
    .map((n, j) => ({ lo: B[j], hi: B[j + 1], n }))
    .filter((t) => t.lo >= A0 && t.hi <= A1);
  const MAX = Math.max(...TRANCHES.map((t) => t.n));
  const dehors = (t) => (t.lo + t.hi) / 2 < VRAI - MARGE || (t.lo + t.hi) / 2 > VRAI + MARGE;

  // La règle : demi-largeur en unités du dessin, graduée à chaque point.
  const W2 = MARGE * PXA;
  const W2_UN = MARGE_UN * PXA;
  const GRAD = Array.from({ length: 2 * Math.floor(MARGE) + 1 }, (_, i) => i - Math.floor(MARGE)).filter((k) => k !== 0 && Math.abs(k) < MARGE);
  const RY = BASE + 58; // la règle sous la cloche (temps 2)
  const YU = 385; // la rangée de notre échantillon
  const XU = x(UN), XV = x(VRAI);
  // Largeur de l'étiquette de notre échantillon (Plex Mono : 0,6 em par glyphe).
  const ETIQ = `votre échantillon : ${f(UN, 1)} %`;
  const ETIQ_L = ETIQ.length * 0.6 * 21 + 20;
</script>

<div class="visuel marge-erreur" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Votre échantillon de {f(BUDGET.n)} personnes, tiré au hasard, donne {f(UN, 1)}&#8239;% aux conservateurs. Est-ce la vraie part conservatrice&#8239;? Probablement pas exactement. Les parts conservatrices de {f(N_ECH)} échantillons de {f(BUDGET.n)} forment une cloche autour de la vraie part, {f(VRAI, 1)}&#8239;%. {f(DEDANS)} sur {f(N_ECH)}, à peu près 19 sur 20, tombent à moins de {f(MARGE, 1)} points de la vérité, environ deux écarts types. On pose la règle autour de votre part, avec la marge calculée d’après votre seul échantillon, plus ou moins {f(MARGE_UN, 1)} points&#8239;: de {f(UN - MARGE_UN, 1)} à {f(UN + MARGE_UN, 1)}&#8239;%. La vérité est {UN_ATTRAPE ? 'dedans' : 'dehors'}. 19 fois sur 20, ça marche&#8239;: c’est la marge d’erreur.">

    <!-- 0 : la question, dans l'espace que la cloche occupera. -->
    <g class="me-etape" class:me-vu={e === 0}>
      <text x="500" y="130" class="me-question">Est-ce la vraie part conservatrice&#8239;?</text>
      <text x="500" y="170" class="me-reponse">Probablement pas exactement.</text>
    </g>

    <!-- 2 : la bande de la règle, derrière la cloche. -->
    <rect x={XV - W2} y={BASE - HAUT - 8} width={2 * W2} height={HAUT + 8} class="me-bande me-etape" class:me-vu={e === 2} />

    <!-- 1 : la cloche des 1 000 parts conservatrices. -->
    <g class="me-etape" class:me-vu={e >= 1}>
      {#each TRANCHES as t}
        {@const h = (t.n / MAX) * HAUT}
        {#if t.n > 0}
          <rect x={x(t.lo) + 0.5} y={BASE - h} width={(t.hi - t.lo) * PXA - 1} height={h} class="me-baton" class:me-rouge={e >= 2 && dehors(t)} class:me-pale={e >= 3} />
        {/if}
      {/each}
      <text x={X0} y="92" class="me-legende">{f(N_ECH)} échantillons de {f(BUDGET.n)},</text>
      <text x={X0} y="118" class="me-legende">{f(N_ECH)} parts conservatrices</text>
    </g>

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="me-axe" />
    {#each TICKS as a}
      <line x1={x(a)} y1={BASE} x2={x(a)} y2={BASE + 7} class="me-axe" />
      <text x={x(a)} y={BASE + 26} class="me-tick">{a}&#8239;%</text>
    {/each}

    <!-- La règle de ± marge : sous la vérité au temps 2, sous notre part au temps 3,
         avec la largeur que le sondeur calcule d'après son seul échantillon. -->
    <g class="me-regle" class:me-vu={e >= 2} style="transform: translate({e >= 3 ? XU : XV}px, {e >= 3 ? YU : RY}px)">
      <rect x={e >= 3 ? -W2_UN : -W2} y="-13" width={e >= 3 ? 2 * W2_UN : 2 * W2} height="26" class="me-regle-corps" />
      {#each GRAD as k}
        <line x1={k * PXA} y1="-13" x2={k * PXA} y2="-4" class="me-regle-grad" />
      {/each}
      <line x1="0" y1="-13" x2="0" y2="13" class="me-regle-grad" />
    </g>

    <!-- 2 : ce que la règle mesure sur la cloche. -->
    <g class="me-etape" class:me-vu={e === 2}>
      <text x={XV - W2 - 16} y={RY + 8} class="me-pm">±&#8239;{f(MARGE, 1)} points</text>
      <text x={XV - W2 - 16} y={RY + 34} class="me-pm-s">environ 2 écarts types</text>
      <text x={XV + W2 + 18} y="92" class="me-compte">{f(DEDANS)} sur {f(N_ECH)}</text>
      <text x={XV + W2 + 18} y="120" class="me-lab">à moins de {f(MARGE, 1)} points</text>
      <text x={XV + W2 + 18} y="146" class="me-lab">de la vérité</text>
      <text x={XV + W2 + 18} y="176" class="me-lab me-rouge-t me-gras">à peu près 19 sur 20</text>
    </g>

    <!-- La vérité, connue ici seulement parce que les répondant.e.s sont une population d'exercice. -->
    <g class="me-etape" class:me-vu={e >= 1}>
      <line x1={XV} y1="42" x2={XV} y2={BASE} class="me-vrai" />
      <line x1={XV} y1={BASE + 36} x2={XV} y2={YU + 24} class="me-vrai" />
      <text x={XV} y="30" class="me-vrai-t">la vraie part conservatrice&#8239;: {f(VRAI, 1)}&#8239;%</text>
    </g>

    <!-- Notre échantillon, présent du début à la fin. -->
    <rect x={XU - ETIQ_L / 2} y={YU - 46} width={ETIQ_L} height="30" class="me-fond" />
    <text x={XU} y={YU - 24} class="me-un">votre échantillon&#8239;: {f(UN, 1)}&#8239;%</text>
    <circle cx={XU} cy={YU} r="9" class="me-point" />

    <!-- 2 et 3 : l'écart entre notre part et la vérité. Le même dans les deux sens. -->
    <g class="me-etape" class:me-vu={e >= 2}>
      <line x1={Math.min(XU, XV)} y1={YU + 30} x2={Math.max(XU, XV)} y2={YU + 30} class="me-ecart" />
      <line x1={XU} y1={YU + 23} x2={XU} y2={YU + 37} class="me-ecart" />
      <line x1={XV} y1={YU + 23} x2={XV} y2={YU + 37} class="me-ecart" />
      <text x={(XU + XV) / 2} y={YU + 54} class="me-ecart-t">{f(ECART, 1)} {points(ECART)}</text>
    </g>

    <!-- 3 : la règle posée sur notre part, à la largeur calculée d'après notre échantillon. -->
    <g class="me-etape me-apres" class:me-vu={e >= 3}>
      <text x={XU - W2_UN - 40} y={YU + 8} class="me-pm">±&#8239;{f(MARGE_UN, 1)} points</text>
      <text x={XU - W2_UN - 40} y={YU + 36} class="me-pm-s">d’après votre échantillon</text>
      <text x={XU - W2_UN} y={YU + 44} class="me-borne">{f(UN - MARGE_UN, 1)}</text>
      <text x={XU + W2_UN} y={YU + 44} class="me-borne">{f(UN + MARGE_UN, 1)}</text>
      <text x="500" y="462" class="me-phrase">La règle, posée sur votre échantillon&#8239;: la vérité est {UN_ATTRAPE ? 'dedans' : 'dehors'}.</text>
      <text x="500" y="494" class="me-phrase me-rouge-t me-fin">19 fois sur 20, ça marche. C’est la marge d’erreur.</text>
    </g>
  </svg>
</div>

<style>
  .marge-erreur { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .me-question { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-reponse { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }
  .me-legende { font-size: 19px; fill: var(--dk-gris); }
  .me-bande { fill: var(--dk-fond-2); }
  .me-baton { fill: var(--dk-encre); transition: fill 0.4s, opacity 0.4s; }
  .me-baton.me-rouge { fill: var(--dk-accent); }
  .me-baton.me-pale { opacity: 0.25; }
  .me-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .me-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .me-tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .me-regle { opacity: 0; transition: opacity 0.3s, transform 1.1s cubic-bezier(0.45, 0, 0.25, 1); }
  .me-regle.me-vu { opacity: 1; transition: opacity 0.5s, transform 1.1s cubic-bezier(0.45, 0, 0.25, 1); }
  .me-regle-corps { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .me-regle-grad { stroke: var(--dk-accent); stroke-width: 2.5; }
  .me-pm { font-size: 24px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .me-pm-s { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .me-compte { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .me-lab { font-size: 19px; fill: var(--dk-encre); }
  .me-gras { font-weight: 600; }
  .me-fond { fill: var(--dk-fond); }
  .me-un { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-point { fill: var(--dk-encre); }
  .me-ecart { stroke: var(--dk-encre); stroke-width: 2; }
  .me-ecart-t { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-borne { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .me-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .me-fin { font-size: 24px; }
  .me-rouge-t { fill: var(--dk-accent); }
  .me-etape { opacity: 0; transition: opacity 0.3s; }
  .me-etape.me-vu { opacity: 1; transition: opacity 0.6s; }
  /* Le texte du temps 3 attend que la règle ait fini de glisser. */
  .me-etape.me-apres.me-vu { transition: opacity 0.6s 0.9s; }
  @media (prefers-reduced-motion: reduce) {
    .me-etape, .me-etape.me-vu, .me-etape.me-apres.me-vu, .me-baton, .me-regle, .me-regle.me-vu { transition: none; }
  }
</style>
