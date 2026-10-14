<script>
  /**
   * Du tableau au graphique des coefficients : la même ligne de tableau,
   * dessinée. En haut, le tableau de notre sondage (le modèle simple
   * note_carney ~ gauche_droite, 783 cas complets parmi les 1 000 tiré.e.s
   * parmi les 20 180). En bas, un axe horizontal en points de note, avec
   * une ligne verticale à 0. Les chiffres « s'envolent » du tableau vers le
   * dessin : une copie rouge part de la cellule, l'original reste en place.
   *
   *   0  Le tableau seul (constante et gauche-droite), l'axe vide.
   *   1  Le coefficient (−5,05) quitte le tableau et devient un point. La
   *      constante pâlit : on ne la dessine pas.
   *   2  Les deux bornes de l'intervalle de confiance à 95 % (−5,93 et
   *      −4,17) s'envolent à leur tour : la moustache se trace entre elles.
   *
   * Tous les nombres viennent de NOTRE.coefs (src/lib/data/seance7.js,
   * généré par outils/seance7_data.R : coef(summary(m)) et confint(m)).
   * L'axe (−8 à +8) est le même qu'à la diapo suivante (CoefAnatomie).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  // Format québécois, vrai signe moins.
  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const C0 = NOTRE.coefs[0]; // la constante
  const C1 = NOTRE.coefs[1]; // gauche_droite

  // L'axe : −8 à +8 points de note.
  const V0 = -8, V1 = 8, XL = 350, XR = 960;
  const x = (v) => XL + ((v - V0) / (V1 - V0)) * (XR - XL);
  const ticks = [-8, -4, 0, 4, 8];

  // Le tableau.
  const YH = 46, YC = 100, YG = 144;
  const XCOEF = 600, XA = 840; // centre de « Coefficient », place du « à »
  // Le dessin.
  const YR = 330, AXE = 420;
  // Les envolées : de la cellule à leur place sur le dessin.
  const vol = (x1, y1, x2, y2) => `transform: translate(${x2 - x1}px, ${y2 - y1}px)`;
</script>

<div class="visuel coef-tab" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Le tableau de notre sondage&#8239;: le coefficient de la position gauche-droite est de {f(C1.b)}, intervalle de confiance à 95&#8239;% de {f(C1.bas)} à {f(C1.haut)}. Dans le graphique, le coefficient devient un point à {f(C1.b)} sur un axe horizontal, et l’intervalle devient une moustache de {f(C1.bas)} à {f(C1.haut)}. Une ligne verticale marque 0.">

    <!-- Le tableau : trois filets, comme dans un article. -->
    <line x1="30" y1="14" x2="970" y2="14" class="ct-filet" />
    <text x="40" y={YH} class="ct-tete ct-gauche">Variable</text>
    <text x={XCOEF} y={YH} class="ct-tete">Coefficient</text>
    <text x={XA} y={YH} class="ct-tete">IC à 95&#8239;%</text>
    <line x1="30" y1="62" x2="970" y2="62" class="ct-filet-fin" />
    <g class="ct-constante" class:ct-pale={e >= 1}>
      <text x="40" y={YC} class="ct-cel ct-gauche">Constante</text>
      <text x={XCOEF} y={YC} class="ct-cel">{f(C0.b)}</text>
      <text x={XA - 30} y={YC} class="ct-cel ct-fin">{f(C0.bas)}</text>
      <text x={XA} y={YC} class="ct-cel">à</text>
      <text x={XA + 30} y={YC} class="ct-cel ct-debut">{f(C0.haut)}</text>
    </g>
    <text x="40" y={YG} class="ct-cel ct-gauche ct-var">Position gauche-droite (0 à 10)</text>
    <text x={XCOEF} y={YG} class="ct-cel" class:ct-parti={e >= 1}>{f(C1.b)}</text>
    <text x={XA - 30} y={YG} class="ct-cel ct-fin" class:ct-parti={e >= 2}>{f(C1.bas)}</text>
    <text x={XA} y={YG} class="ct-cel" class:ct-parti={e >= 2}>à</text>
    <text x={XA + 30} y={YG} class="ct-cel ct-debut" class:ct-parti={e >= 2}>{f(C1.haut)}</text>
    <line x1="30" y1="166" x2="970" y2="166" class="ct-filet" />

    <!-- Le dessin : l'axe en points de note, la ligne à 0. -->
    <line x1={x(0)} y1="236" x2={x(0)} y2={AXE} class="ct-zero" />
    <line x1={XL} y1={AXE} x2={XR} y2={AXE} class="ct-axe" />
    {#each ticks as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 9} class="ct-axe" />
      <text x={x(t)} y={AXE + 34} class="ct-tick">{f(t, 0)}</text>
    {/each}
    <text x={(XL + XR) / 2} y="490" class="ct-titre-axe">effet sur la note de Carney, en points</text>

    <!-- La variable, à gauche de sa rangée. -->
    <g class="ct-etape" class:ct-vu={e >= 1}>
      <text x="320" y={YR - 4} class="ct-lab">Position gauche-droite</text>
      <text x="320" y={YR + 22} class="ct-sous">(0 à 10)</text>
    </g>

    <!-- 2 : la moustache, entre les deux bornes. -->
    <line x1={x(C1.bas)} y1={YR} x2={x(C1.haut)} y2={YR} pathLength="1" class="ct-moustache" class:ct-trace={e >= 2} />
    <g class="ct-etape ct-tard" class:ct-vu={e >= 2}>
      <line x1={x(C1.bas)} y1={YR - 10} x2={x(C1.bas)} y2={YR + 10} class="ct-borne" />
      <line x1={x(C1.haut)} y1={YR - 10} x2={x(C1.haut)} y2={YR + 10} class="ct-borne" />
    </g>
    <!-- 1 : le point. -->
    <circle cx={x(C1.b)} cy={YR} r="11" class="ct-point ct-etape ct-tard" class:ct-vu={e >= 1} />

    <!-- Les copies rouges qui s'envolent (posées sur l'original au départ). -->
    <g class="ct-vole" class:ct-parti={e >= 1} style={e >= 1 ? vol(XCOEF, YG, x(C1.b), YR - 26) : ''}>
      <text x={XCOEF} y={YG} class="ct-cel ct-rouge">{f(C1.b)}</text>
    </g>
    <g class="ct-vole" class:ct-parti={e >= 2} style={e >= 2 ? vol(XA - 30, YG, x(C1.bas) - 6, YR + 44) : ''}>
      <text x={XA - 30} y={YG} class="ct-cel ct-fin ct-rouge">{f(C1.bas)}</text>
    </g>
    <g class="ct-vole" class:ct-parti={e >= 2} style={e >= 2 ? vol(XA + 30, YG, x(C1.haut) + 6, YR + 44) : ''}>
      <text x={XA + 30} y={YG} class="ct-cel ct-debut ct-rouge">{f(C1.haut)}</text>
    </g>
  </svg>
</div>

<style>
  .coef-tab { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .ct-filet { stroke: var(--dk-encre); stroke-width: 2; }
  .ct-filet-fin { stroke: var(--dk-encre); stroke-width: 1; }
  .ct-tete { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .ct-cel { font-size: 23px; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .ct-gauche { text-anchor: start; }
  .ct-fin { text-anchor: end; }
  .ct-debut { text-anchor: start; }
  .ct-var { font-weight: 600; }
  .ct-cel.ct-parti { fill: var(--dk-gris); }
  .ct-constante { transition: opacity 0.5s; }
  .ct-constante.ct-pale { opacity: 0.3; }
  .ct-rouge { fill: var(--dk-accent); font-weight: 600; }
  .ct-vole { opacity: 0; transition: transform 0.9s cubic-bezier(0.5, 0, 0.3, 1), opacity 0.2s; }
  .ct-vole.ct-parti { opacity: 1; }
  .ct-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 7 6; }
  .ct-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .ct-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ct-titre-axe { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ct-lab { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .ct-sous { font-size: 19px; text-anchor: end; fill: var(--dk-gris); }
  .ct-point { fill: var(--dk-encre); }
  .ct-moustache { stroke: var(--dk-encre); stroke-width: 6; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.6s 0.8s; }
  .ct-moustache.ct-trace { stroke-dashoffset: 0; }
  .ct-borne { stroke: var(--dk-encre); stroke-width: 3; }
  .ct-etape { opacity: 0; transition: opacity 0.3s; }
  .ct-etape.ct-vu { opacity: 1; transition: opacity 0.5s; }
  .ct-etape.ct-tard.ct-vu { transition: opacity 0.4s 0.8s; }
  @media (prefers-reduced-motion: reduce) {
    .ct-vole, .ct-moustache, .ct-etape, .ct-etape.ct-vu, .ct-etape.ct-tard.ct-vu, .ct-constante, .ct-cel { transition: none; }
  }
</style>
