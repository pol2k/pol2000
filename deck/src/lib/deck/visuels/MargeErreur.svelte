<script>
  /**
   * La marge d'erreur, d'où elle vient. On part de ce qu'on a vraiment (un
   * seul échantillon), on rappelle la cloche des 1 000 moyennes, on y mesure
   * une règle de ± 5 ans, puis on pose cette règle sur notre moyenne à nous.
   * Quatre temps.
   *
   *   0  Un seul échantillon de 50 (le premier de la diapo « Trois
   *      échantillons », TROIS[0]) : sa moyenne, 47,6 ans, un point sur l'axe
   *      des âges. La question : est-ce la vraie moyenne des 20 180 ?
   *   1  La cloche des 1 000 moyennes d'échantillons de 50 (MOYENNES_50,
   *      tranches d'une demi-année) et la vraie moyenne (POP.moyenne), qu'on
   *      connaît ici parce que les 20 180 servent de population d'exercice.
   *   2  Une règle rouge, centrée sur la vérité, de ± marge, où marge = 1,96 ×
   *      l'écart type des 1 000 moyennes mesuré par R
   *      (DISTRIBUTIONS[1].ecartTypeDesMoyennes), soit environ deux écarts
   *      types, 5 ans. Les moyennes hors de la règle passent au rouge. Le
   *      compte de celles qui sont dedans est fait ici, sur les 1 000
   *      moyennes de R, et affiché tel quel (941 : « à peu près 19 sur 20 »,
   *      le hasard de la simulation).
   *      Sous notre point, un crochet mesure l'écart entre notre moyenne et
   *      la vérité (2,1 ans) : il est plus court que la demi-règle.
   *   3  Le renversement : la règle glisse de la vérité jusqu'à NOTRE
   *      moyenne. Si notre moyenne est à moins de 5 ans de la vérité, la
   *      vérité est à moins de 5 ans de notre moyenne : la règle l'attrape,
   *      19 fois sur 20. Le crochet de 2,1 ans le montre : même écart dans
   *      les deux sens. C'est la marge d'erreur.
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
  // La marge : 1,96 fois l'écart type des 1 000 moyennes, mesuré par R.
  const MARGE = 1.96 * DISTRIBUTIONS[1].ecartTypeDesMoyennes;
  const DEDANS = MOYENNES_50.filter((m) => Math.abs(m - VRAI) <= MARGE).length;
  const UN = TROIS[0].moyenne;
  const UN_ATTRAPE = Math.abs(UN - VRAI) <= MARGE;

  // L'axe des âges, partagé par la cloche et par notre échantillon.
  const A0 = 38, A1 = 62, X0 = 80, X1 = 920, BASE = 232, HAUT = 170;
  const PXA = (X1 - X0) / (A1 - A0);
  const x = (a) => X0 + (a - A0) * PXA;
  const PAS = 0.5;
  const BORNES = Array.from({ length: (A1 - A0) / PAS }, (_, j) => A0 + j * PAS);
  const COMPTES = BORNES.map((b) => MOYENNES_50.filter((m) => m >= b && m < b + PAS).length);
  const MAX = Math.max(...COMPTES);
  const L = PAS * PXA;
  const dehors = (b) => b + PAS / 2 < VRAI - MARGE || b + PAS / 2 > VRAI + MARGE;

  // La règle : demi-largeur en unités du dessin, graduée à chaque année.
  const W2 = MARGE * PXA;
  const GRAD = Array.from({ length: 2 * Math.floor(MARGE) + 1 }, (_, i) => i - Math.floor(MARGE)).filter((k) => k !== 0 && Math.abs(k) < MARGE);
  const RY = BASE + 58; // la règle sous la cloche (temps 2)
  const YU = 385; // la rangée de notre échantillon
  const XU = x(UN), XV = x(VRAI);
  // Largeur de l'étiquette de notre échantillon (Plex Mono : 0,6 em par glyphe).
  const ETIQ = `votre échantillon : ${f(UN, 1)} ans`;
  const ETIQ_L = ETIQ.length * 0.6 * 21 + 20;
</script>

<div class="visuel marge-erreur" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Votre échantillon de 50 personnes a une moyenne d’âge de {f(UN, 1)} ans. Est-ce la vraie moyenne ? Probablement pas exactement. Les moyennes de {f(1000)} échantillons de 50 forment une cloche autour de la vraie moyenne, {f(VRAI, 1)} ans. {DEDANS} sur {f(1000)}, à peu près 19 sur 20, tombent à moins de {f(MARGE, 0)} ans de la vérité, environ deux écarts types. On pose la même règle de plus ou moins {f(MARGE, 0)} ans autour de votre moyenne : de {f(UN - MARGE, 1)} à {f(UN + MARGE, 1)} ans. La vérité est dedans. 19 fois sur 20, ça marche : c’est la marge d’erreur.">

    <!-- 0 : la question, dans l'espace que la cloche occupera. -->
    <g class="me-etape" class:me-vu={e === 0}>
      <text x="500" y="130" class="me-question">Est-ce la vraie moyenne des {f(POP.n)}&#8239;?</text>
      <text x="500" y="170" class="me-reponse">Probablement pas exactement.</text>
    </g>

    <!-- 2 : la bande de la règle, derrière la cloche. -->
    <rect x={XV - W2} y={BASE - HAUT - 8} width={2 * W2} height={HAUT + 8} class="me-bande me-etape" class:me-vu={e === 2} />

    <!-- 1 : la cloche des 1 000 moyennes. -->
    <g class="me-etape" class:me-vu={e >= 1}>
      {#each BORNES as b, j}
        {@const h = (COMPTES[j] / MAX) * HAUT}
        <rect x={x(b) + 0.5} y={BASE - h} width={L - 1} height={h} class="me-baton" class:me-rouge={e >= 2 && dehors(b)} class:me-pale={e >= 3} />
      {/each}
      <text x={X0} y="92" class="me-legende">{f(1000)} échantillons de 50,</text>
      <text x={X0} y="118" class="me-legende">{f(1000)} moyennes</text>
    </g>

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="me-axe" />
    {#each [40, 45, 50, 55, 60] as a}
      <line x1={x(a)} y1={BASE} x2={x(a)} y2={BASE + 7} class="me-axe" />
      <text x={x(a)} y={BASE + 26} class="me-tick">{a}</text>
    {/each}

    <!-- La règle de ± marge : sous la vérité au temps 2, sous notre moyenne au temps 3. -->
    <g class="me-regle" class:me-vu={e >= 2} style="transform: translate({e >= 3 ? XU : XV}px, {e >= 3 ? YU : RY}px)">
      <rect x={-W2} y="-13" width={2 * W2} height="26" class="me-regle-corps" />
      {#each GRAD as k}
        <line x1={k * PXA} y1="-13" x2={k * PXA} y2="-4" class="me-regle-grad" />
      {/each}
      <line x1="0" y1="-13" x2="0" y2="13" class="me-regle-grad" />
    </g>

    <!-- 2 : ce que la règle mesure sur la cloche. -->
    <g class="me-etape" class:me-vu={e === 2}>
      <text x={XV - W2 - 16} y={RY + 8} class="me-pm">± {f(MARGE, 0)} ans</text>
      <text x={XV - W2 - 16} y={RY + 34} class="me-pm-s">environ 2 écarts types</text>
      <text x={XV + W2 + 18} y="92" class="me-compte">{DEDANS} sur {f(1000)}</text>
      <text x={XV + W2 + 18} y="120" class="me-lab">à moins de {f(MARGE, 0)} ans</text>
      <text x={XV + W2 + 18} y="146" class="me-lab">de la vérité</text>
      <text x={XV + W2 + 18} y="176" class="me-lab me-rouge-t me-gras">à peu près 19 sur 20</text>
    </g>

    <!-- La vérité, connue ici seulement parce que les 20 180 sont une population d'exercice. -->
    <g class="me-etape" class:me-vu={e >= 1}>
      <line x1={XV} y1="42" x2={XV} y2={BASE} class="me-vrai" />
      <line x1={XV} y1={BASE + 36} x2={XV} y2={YU + 24} class="me-vrai" />
      <text x={XV} y="30" class="me-vrai-t">la vraie moyenne des {f(POP.n)}&#8239;: {f(VRAI, 1)} ans</text>
    </g>

    <!-- Notre échantillon, présent du début à la fin. -->
    <rect x={XU - ETIQ_L / 2} y={YU - 46} width={ETIQ_L} height="30" class="me-fond" />
    <text x={XU} y={YU - 24} class="me-un">votre échantillon&#8239;: {f(UN, 1)} ans</text>
    <circle cx={XU} cy={YU} r="9" class="me-point" />

    <!-- 2 et 3 : l'écart entre notre moyenne et la vérité. Le même dans les deux sens. -->
    <g class="me-etape" class:me-vu={e >= 2}>
      <line x1={Math.min(XU, XV)} y1={YU + 30} x2={Math.max(XU, XV)} y2={YU + 30} class="me-ecart" />
      <line x1={XU} y1={YU + 23} x2={XU} y2={YU + 37} class="me-ecart" />
      <line x1={XV} y1={YU + 23} x2={XV} y2={YU + 37} class="me-ecart" />
      <text x={(XU + XV) / 2} y={YU + 54} class="me-ecart-t">{f(Math.abs(UN - VRAI), 1)} ans</text>
    </g>

    <!-- 3 : la règle posée sur notre moyenne. -->
    <g class="me-etape me-apres" class:me-vu={e >= 3}>
      <text x={XU - W2} y={YU + 44} class="me-borne">{f(UN - MARGE, 1)}</text>
      <text x={XU + W2} y={YU + 44} class="me-borne">{f(UN + MARGE, 1)}</text>
      <text x="500" y="462" class="me-phrase">La même règle, posée sur votre moyenne&#8239;: la vérité est {UN_ATTRAPE ? 'dedans' : 'dehors'}.</text>
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
