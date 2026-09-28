<script>
  /**
   * L'erreur type : l'écart type des moyennes, d'un échantillon à l'autre.
   * À gauche, les 1 000 moyennes d'âge d'échantillons de 50 personnes tirées
   * parmi les répondant.e.s de l'Étude électorale canadienne 2025
   * (DISTRIBUTIONS[1], tranches d'un an [a, a+1) sur BORNES). À droite, le
   * mot et le raccourci. Trois temps.
   *
   *   0  L'histogramme, une bande d'un écart type de chaque côté de son
   *      centre (DISTRIBUTIONS[1].moyenne ± DISTRIBUTIONS[1].ecartTypeDesMoyennes)
   *      et, sur un bras du crochet, la longueur de cet écart type. La
   *      définition, en mots.
   *   1  Le raccourci d'Arel-Bundock (2021, p. 65, équation 4.2), en mots :
   *      l'écart type des âges (POP.ecartType) divisé par la racine carrée
   *      de n (DISTRIBUTIONS[1].n). Le résultat est DISTRIBUTIONS[1].erreurType,
   *      calculé par outils/seance5_data.R.
   *   2  Les deux nombres côte à côte : l'écart type mesuré sur les mille
   *      échantillons, et le calcul. Presque pareil.
   *
   * Nuance : le calcul utilise l'écart type des 20 180 âges. Avec un seul
   * échantillon, on prendrait l'écart type de l'échantillon, qui en est proche.
   */
  import { brancherTemps } from '../temps.js';
  import { DISTRIBUTIONS, BORNES, POP } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const D = DISTRIBUTIONS[1];
  const fr = (v, d) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const MILLE = fr(D.effectifs.reduce((s, n) => s + n, 0), 0);

  // L'histogramme : de 38 à 62 ans (les 1 000 moyennes vont de D.min à D.max).
  const A0 = 38, A1 = 62, X0 = 50, X1 = 500;
  const BASE = 270, HAUT = 150;
  const x = (v) => X0 + ((v - A0) / (A1 - A0)) * (X1 - X0);
  const max = Math.max(...D.effectifs);
  const y = (n) => BASE - (n / max) * HAUT;
  const BARRES = D.effectifs
    .map((n, i) => ({ a: BORNES[i], n }))
    .filter((b) => b.n > 0 && b.a >= A0 && b.a < A1);
  const TICKS = [40, 45, 50, 55, 60];

  const M = D.moyenne;
  const ET = D.ecartTypeDesMoyennes;
  const XM = x(M), XG = x(M - ET), XD = x(M + ET);
  const YC = 96;
</script>

<div class="visuel erreur-type" bind:this={hote}>
  <svg viewBox="0 0 1000 440" role="img" aria-label="Histogramme des {MILLE} moyennes d’âge d’échantillons de {D.n} personnes, centré sur {fr(M, 1)} ans. Leur écart type, {fr(ET, 2)} ans, est l’erreur type. Le raccourci, l’écart type des âges divisé par la racine carrée de {D.n}, donne {fr(POP.ecartType, 2)} ÷ √{D.n} = {fr(D.erreurType, 2)} ans. Presque pareil.">
    <!-- L'histogramme des mille moyennes. -->
    <text x="50" y="34" class="ert-cap">{MILLE} moyennes d’échantillons de {D.n}</text>
    <rect x={XG} y={YC} width={XD - XG} height={BASE - YC} class="ert-bande" />
    {#each BARRES as b, i}
      <rect x={x(b.a)} y={y(b.n)} width={x(b.a + 1) - x(b.a)} height={BASE - y(b.n)} class="ert-barre" style="animation-delay: {i * 30}ms" />
    {/each}
    <line x1={x(A0)} y1={BASE} x2={x(A1)} y2={BASE} class="ert-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 7} class="ert-axe" />
      <text x={x(t)} y={BASE + 26} class="ert-tick">{t}</text>
    {/each}
    <text x={(X0 + X1) / 2} y="322" class="ert-titre-axe">âge moyen de l’échantillon</text>

    <!-- Le crochet : un écart type de chaque côté du centre, la longueur sur le bras droit. -->
    <line x1={XG} y1={YC} x2={XM} y2={YC} class="ert-bras" />
    <line x1={XG} y1={YC - 8} x2={XG} y2={YC + 8} class="ert-bras" />
    <line x1={XM} y1={YC} x2={XD} y2={YC} class="ert-bras-r" />
    <line x1={XM} y1={YC - 10} x2={XM} y2={YC + 10} class="ert-bras-r" />
    <line x1={XD} y1={YC - 10} x2={XD} y2={YC + 10} class="ert-bras-r" />
    <text x={(XM + XD) / 2} y={YC - 18} class="ert-et">{fr(ET, 2)} ans</text>

    <!-- La définition. -->
    <text x="560" y="92" class="ert-mot">l’erreur type&#8239;:</text>
    <text x="560" y="128" class="ert-def">l’écart type des moyennes,</text>
    <text x="560" y="156" class="ert-def">d’un échantillon à l’autre</text>

    <!-- Temps 1 : le raccourci, en mots. -->
    <g class="ert-etape" class:ert-vu={e >= 1}>
      <text x="560" y="214" class="ert-def">écart type ÷ racine carrée de n</text>
      <text x="560" y="258" class="ert-calc">{fr(POP.ecartType, 2)} ÷ √{D.n} = <tspan class="ert-rouge">{fr(D.erreurType, 2)} ans</tspan></text>
      <text x="560" y="288" class="ert-src">Arel-Bundock (2021, p. 65, équation 4.2)</text>
    </g>

    <!-- Temps 2 : les deux nombres. -->
    <g class="ert-etape" class:ert-vu={e >= 2}>
      <text x="275" y="364" class="ert-lab">mille échantillons&#8239;:</text>
      <text x="275" y="422" class="ert-gros">{fr(ET, 2)}</text>
      <text x="522" y="408" class="ert-pareil">presque pareil</text>
      <text x="770" y="364" class="ert-lab">un seul échantillon, un calcul&#8239;:</text>
      <text x="770" y="422" class="ert-gros">{fr(D.erreurType, 2)}</text>
    </g>
  </svg>
</div>

<style>
  .erreur-type { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ert-cap { font-size: 20px; fill: var(--dk-encre); }
  .ert-bande { fill: var(--dk-accent); fill-opacity: 0.12; }
  .ert-barre { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 1.5; transform-box: fill-box; transform-origin: bottom; animation: ert-monte 0.5s ease-out both; }
  @keyframes ert-monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .ert-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ert-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ert-titre-axe { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ert-bras { stroke: var(--dk-gris); stroke-width: 2.5; }
  .ert-bras-r { stroke: var(--dk-accent); stroke-width: 4; }
  .ert-et { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ert-mot { font-size: 30px; font-weight: 600; fill: var(--dk-encre); }
  .ert-def { font-size: 21px; fill: var(--dk-encre); }
  .ert-calc { font-size: 30px; font-weight: 600; fill: var(--dk-encre); }
  .ert-rouge { fill: var(--dk-accent); }
  .ert-src { font-size: 17px; fill: var(--dk-gris); }
  .ert-lab { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .ert-gros { font-size: 52px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ert-pareil { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .ert-etape { opacity: 0; transition: opacity 0.3s; }
  .ert-etape.ert-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .ert-barre { animation: none; }
    .ert-etape, .ert-etape.ert-vu { transition: none; }
  }
</style>
