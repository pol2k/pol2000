<script>
  /**
   * Normale ou pas ? Une carte du quiz de la séance 5 : on nomme ce qui a été
   * mesuré, la salle devine la forme, puis R la montre. Trois temps.
   *
   *   0  Ce qui a été mesuré, en grand, et sa source. Le cadre du graphique
   *      est vide, un grand « ? » au milieu : la salle devine.
   *   1  L'histogramme monte, bâton par bâton (effectifs calculés par R).
   *   2  Le verdict, en rouge, et une raison en une ligne.
   *
   * Les effectifs viennent de QUIZ (src/lib/data/seance5_normale.js, produit
   * par outils/seance5_normale.R). Le verdict est lu à l'œil, comme en classe
   * (aucun test de normalité) : il est écrit dans ce fichier, avec sa raison.
   * Chaque rangée est mise à l'échelle de son plus haut bâton.
   */
  import { brancherTemps } from '../temps.js';
  import { QUIZ } from '$lib/data/seance5_normale.js';
  let { cle } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');

  const Q = $derived(QUIZ.find((q) => q.cle === cle));
  // Ce qui s'affiche : le titre, la source, l'axe, les graduations, le verdict.
  const TEXTE = {
    michelson: { titre: (q) => `${f(q.n)} mesures de la vitesse de la lumière`, source: 'Michelson, 1879', axe: 'vitesse mesurée (km/s)', ticks: [299700, 299800, 299900, 300000], verdict: 'une cloche', raison: 'Chaque mesure, c’est la vraie vitesse plus plein de petites erreurs.' },
    nyc: { titre: (q) => `La hauteur des ${f(q.n)} bâtiments de New York`, source: 'NYC Open Data, 2026', axe: 'hauteur (m)', ticks: [0, 10, 20, 30, 40], verdict: 'pas une cloche : une longue queue', raison: 'Rien sous zéro, surtout des maisons, et quelques tours immenses.' },
    bebes: { titre: (q) => `Le poids de ${f(q.n)} bébés à la naissance`, source: 'Springfield (Massachusetts), 1986', axe: 'poids (g)', ticks: [1000, 2000, 3000, 4000, 5000], verdict: 'une cloche, à peu près', raison: 'Beaucoup de petites causes qui s’additionnent.' },
    rivieres: { titre: (q) => `La longueur de ${f(q.n)} grandes rivières d’Amérique du Nord`, source: 'World Almanac, 1975', axe: 'longueur (km)', ticks: [0, 1000, 2000, 3000, 4000, 5000, 6000], verdict: 'pas une cloche : une longue queue', raison: 'Beaucoup de rivières moyennes, quelques géantes.' },
    geyser: { titre: (q) => `L’attente entre deux éruptions d’Old Faithful`, source: (q) => `Yellowstone, ${f(q.n)} éruptions`, axe: 'attente (minutes)', ticks: [40, 50, 60, 70, 80, 90, 100], verdict: 'pas une cloche : deux bosses', raison: 'Deux groupes mélangés : des attentes courtes et des longues.' },
    age: { titre: (q) => `L’âge des ${f(q.n)} répondant.e.s de l’Étude électorale`, source: 'Étude électorale canadienne 2025', axe: 'âge (ans)', ticks: [20, 40, 60, 80, 100], verdict: 'pas une cloche : un plateau', raison: 'De 25 à 75 ans, à peu près autant de monde partout. Retenez-la.' }
  };
  const T = $derived(TEXTE[cle]);
  const SOURCE = $derived(typeof T.source === 'function' ? T.source(Q) : T.source);

  const X0 = 90, X1 = 910, BASE = 412, HAUT = 222;
  const B0 = $derived(Q.bornes[0]);
  const B1 = $derived(Q.bornes[Q.bornes.length - 1]);
  const x = (v) => X0 + ((v - B0) / (B1 - B0)) * (X1 - X0);
  const MAX = $derived(Math.max(...Q.effectifs));
  const BATONS = $derived(Q.effectifs.map((c, j) => ({ a: Q.bornes[j], b: Q.bornes[j + 1], h: (c / MAX) * HAUT })));
  const cloche = $derived(T.verdict.startsWith('une cloche'));
</script>

<div class="visuel normale-ou-pas" bind:this={hote}>
  <svg viewBox="0 0 1000 484" role="img" aria-label="{T.titre(Q)} ({SOURCE}). Verdict : {T.verdict}. {T.raison}">
    <text x={X0} y="42" class="nop-titre">{T.titre(Q)}</text>
    <text x={X0} y="76" class="nop-source">{SOURCE}</text>

    <!-- 0 : le cadre vide, et la question. -->
    <text x="500" y="350" class="nop-q" class:nop-cache={e >= 1}>?</text>

    <!-- 1 : l'histogramme. -->
    {#each BATONS as b, j}
      <rect x={x(b.a) + 1} y={BASE - HAUT} width={Math.max(1, x(b.b) - x(b.a) - 2)} height={HAUT}
            class="nop-baton" class:nop-rouge={e >= 2 && cloche}
            style="transform: scaleY({e >= 1 ? b.h / HAUT : 0}); transition-delay: {e >= 1 ? j * 25 : 0}ms" />
    {/each}
    {#if Q.au_dela > 0}
      <g class="nop-etape" class:nop-vu={e >= 1}>
        <path d="M {X1 - 170} {BASE - 60} H {X1 + 40} M {X1 + 28} {BASE - 70} L {X1 + 40} {BASE - 60} L {X1 + 28} {BASE - 50}" class="nop-fleche" />
        <text x={X1 + 40} y={BASE - 110} class="nop-plus">+ {f(Q.au_dela)} plus hauts</text>
        <text x={X1 + 40} y={BASE - 80} class="nop-plus">jusqu’à {f(Q.max)} m</text>
      </g>
    {/if}

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="nop-axe" />
    {#each T.ticks as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 8} class="nop-axe" />
      <text x={x(t)} y={BASE + 30} class="nop-tick">{f(t)}</text>
    {/each}
    <text x={X1} y={BASE + 58} class="nop-tick nop-fin">{T.axe}</text>

    <!-- 2 : le verdict. -->
    <g class="nop-etape" class:nop-vu={e >= 2}>
      <text x={X0} y="124" class="nop-verdict">{T.verdict}</text>
      <text x={X0} y="156" class="nop-raison">{T.raison}</text>
    </g>
  </svg>
</div>

<style>
  .normale-ou-pas { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .nop-titre { font-size: 27px; font-weight: 600; fill: var(--dk-encre); }
  .nop-source { font-size: 18px; fill: var(--dk-gris); }
  .nop-q { font-size: 150px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris-2); transition: opacity 0.3s; }
  .nop-q.nop-cache { opacity: 0; }
  .nop-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.6s cubic-bezier(0.34, 1.2, 0.64, 1), fill 0.4s; }
  .nop-baton.nop-rouge { fill: var(--dk-accent); }
  .nop-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .nop-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .nop-fin { text-anchor: end; }
  .nop-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .nop-plus { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .nop-verdict { font-size: 28px; font-weight: 600; fill: var(--dk-accent); }
  .nop-raison { font-size: 20px; fill: var(--dk-encre); }
  .nop-etape { opacity: 0; transition: opacity 0.2s; }
  .nop-etape.nop-vu { opacity: 1; transition: opacity 0.5s 0.4s; }
  @media (prefers-reduced-motion: reduce) {
    .nop-baton, .nop-q, .nop-etape, .nop-etape.nop-vu { transition: none; }
  }
</style>
