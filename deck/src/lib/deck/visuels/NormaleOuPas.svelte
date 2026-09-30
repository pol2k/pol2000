<script>
  /**
   * Normale ou pas ? Une carte du quiz de la séance 5 : on nomme ce qui a été
   * mesuré, la salle parie sur la forme, puis R la montre. Trois temps.
   *
   *   0  Ce qui a été mesuré, en grand, et sa source. « Votre pari » à la
   *      place du verdict; le cadre du graphique est vide, un grand « ? ».
   *   1  L'histogramme monte, bâton par bâton (effectifs calculés par R).
   *      Pour les bâtiments de New York, tout le spectre, de 0 à 480 m, et un
   *      trait rouge sous l'axe par mètre où se trouve au moins un bâtiment
   *      de 40 m ou plus : les tours, invisibles en bâtons, apparaissent.
   *   2  Le verdict, en rouge, et le pourquoi en deux lignes.
   *
   * Les effectifs viennent de QUIZ, l'écart hommes-femmes de TAILLES
   * (src/lib/data/seance5_normale.js, produit par outils/seance5_normale.R).
   * Le verdict est lu à l'œil, comme en classe (aucun test de normalité) :
   * il est écrit dans ce fichier, avec sa raison.
   *
   * L'âge, vérifié le 30 septembre 2026 contre Statistique Canada (tableau
   * 17-10-0005-01, 1er juillet 2025, 18 ans et plus) : de 7 à 9 % par
   * tranche de cinq ans jusque vers 70 ans, puis ça descend. L'EEC, bâtie
   * avec des quotas d'âge, reproduit ce plateau. Elle surreprésente
   * toutefois les 53 à 72 ans (9,4 % des 58-62 ans contre 7,7 %) : la
   * petite bosse vers 60 ans vient du panel, pas de la population. Rien
   * sur les baby-boomers, donc.
   */
  import { brancherTemps } from '../temps.js';
  import { QUIZ, TAILLES } from '$lib/data/seance5_normale.js';
  let { cle } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const N = ' ';

  const Q = $derived(QUIZ.find((q) => q.cle === cle));
  const TEXTE = {
    hommes: {
      titre: (q) => `La taille de ${f(q.n)} hommes adultes`,
      source: () => 'États-Unis, enquête NHANES, 2009 à 2012',
      axe: 'taille (cm)', ticks: [150, 160, 170, 180, 190, 200],
      verdict: 'une cloche',
      pourquoi: () => [`Des milliers de gènes, l’alimentation, la santé${N}: chacun pousse un peu,`, 'vers le haut ou vers le bas. Comme les billes de la planche.']
    },
    adultes: {
      titre: (q) => `La taille de ${f(q.n)} adultes, hommes et femmes mélangés`,
      source: () => 'États-Unis, enquête NHANES, 2009 à 2012',
      axe: 'taille (cm)', ticks: [140, 150, 160, 170, 180, 190, 200],
      verdict: `piège${N}: une seule cloche, plus large`,
      pourquoi: () => [`On attendait deux bosses. Les hommes mesurent ${f(TAILLES.ecart)} cm de plus en moyenne,`, `mais d’un homme à l’autre, ça va de ${f(TAILLES.hommes95[0])} à ${f(TAILLES.hommes95[1])} cm${N}: les deux cloches se fondent.`]
    },
    iris: {
      titre: (q) => `La longueur des pétales de ${f(q.n)} iris`,
      source: () => 'Anderson, 1935, en bonne partie cueillis en Gaspésie',
      axe: 'longueur du pétale (cm)', ticks: [1, 2, 3, 4, 5, 6, 7],
      verdict: `piège${N}: deux bosses, et un trou`,
      pourquoi: () => ['Trois espèces d’iris mélangées. L’une, l’iris setosa, a de tout petits pétales.', 'Mélanger des groupes très différents, ça fait des bosses.']
    },
    bebes: {
      titre: (q) => `Le poids de ${f(q.n)} bébés à la naissance`,
      source: () => 'Springfield (Massachusetts), 1986',
      axe: 'poids (g)', ticks: [1000, 2000, 3000, 4000, 5000],
      verdict: 'une cloche, mais pas parfaite',
      pourquoi: (q) => [`Seulement ${f(q.n)} bébés${N}: le hasard fait des creux et des bosses.`, `Et une queue à gauche${N}: les bébés nés trop tôt, beaucoup plus légers.`]
    },
    nyc: {
      titre: (q) => `La hauteur des ${f(q.n)} bâtiments de New York`,
      source: () => 'NYC Open Data, 2026',
      axe: 'hauteur (m)', ticks: [0, 100, 200, 300, 400],
      verdict: `pas une cloche${N}: une très longue queue`,
      pourquoi: () => ['Rien sous zéro. Surtout des maisons de 2 ou 3 étages, collées à gauche.', 'Puis quelques tours qui montent très, très haut.']
    },
    age: {
      titre: (q) => `L’âge des ${f(q.n)} répondant.e.s de l’Étude électorale`,
      source: () => 'Étude électorale canadienne 2025',
      axe: 'âge (ans)', ticks: [20, 40, 60, 80, 100],
      verdict: `piège${N}: un plateau`,
      pourquoi: () => [`Pas d’enfants${N}: on sonde les 18 ans et plus. Puis, comme au Canada,`, 'à peu près autant de monde à chaque âge jusque vers 70 ans. Ensuite, ça descend.']
    }
  };
  const T = $derived(TEXTE[cle]);
  const POURQUOI = $derived(T.pourquoi(Q));

  const X0 = 90, X1 = 910, BASE = 412, HAUT = 196;
  const B0 = $derived(Q.bornes[0]);
  const B1 = $derived(Q.bornes[Q.bornes.length - 1]);
  const x = (v) => X0 + ((v - B0) / (B1 - B0)) * (X1 - X0);
  const MAX = $derived(Math.max(...Q.effectifs));
  const BATONS = $derived(Q.effectifs.map((c, j) => ({ a: Q.bornes[j], b: Q.bornes[j + 1], h: (c / MAX) * HAUT })));
  const cloche = $derived(T.verdict.startsWith('une cloche') || T.verdict.includes('une seule cloche'));
  // Les tours de New York : un trait par mètre occupé, à partir de 40 m.
  const TRAITS = $derived(Q.traits ?? []);
</script>

<div class="visuel normale-ou-pas" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="{T.titre(Q)} ({T.source(Q)}). Verdict : {T.verdict}. {POURQUOI.join(' ')}">
    <text x={X0} y="40" class="nop-titre">{T.titre(Q)}</text>
    <text x={X0} y="70" class="nop-source">{T.source(Q)}</text>

    <!-- 0 : le pari. -->
    <text x={X0} y="120" class="nop-pari" class:nop-cache={e >= 2}>Votre pari&#8239;: une cloche, ou pas&#8239;?</text>
    <text x="500" y="350" class="nop-q" class:nop-cache={e >= 1}>?</text>

    <!-- 1 : l'histogramme. -->
    {#each BATONS as b, j}
      <rect x={x(b.a) + 1} y={BASE - HAUT} width={Math.max(1, x(b.b) - x(b.a) - 2)} height={HAUT}
            class="nop-baton" class:nop-rouge={e >= 2 && cloche}
            style="transform: scaleY({e >= 1 ? b.h / HAUT : 0}); transition-delay: {e >= 1 ? Math.min(j, 40) * 25 : 0}ms" />
    {/each}
    {#if TRAITS.length}
      <g class="nop-etape" class:nop-vu={e >= 1}>
        {#each TRAITS as m}
          <line x1={x(m + 0.5)} y1={BASE + 4} x2={x(m + 0.5)} y2={BASE + 18} class="nop-tour" />
        {/each}
        <text x={x(Q.max)} y={BASE - 58} class="nop-plus">la plus haute&#8239;: {f(Q.max)} m</text>
        <path d="M {x(Q.max)} {BASE - 50} L {x(Q.max)} {BASE - 4}" class="nop-fleche" />
        <text x={x(150)} y={BASE - 150} class="nop-plus nop-g">{f(Q.plus40)} bâtiments de plus de 40 m</text>
        <text x={x(150)} y={BASE - 124} class="nop-plus nop-g">{f(Q.plus100)} de plus de 100 m</text>
        <text x={x(150)} y={BASE - 98} class="nop-plus nop-g">{f(Q.plus200)} de plus de 200 m</text>
        <text x={x(150)} y={BASE - 180} class="nop-note">trop peu pour se voir en bâtons&#8239;: un trait rouge sous l’axe par hauteur</text>
      </g>
    {/if}

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="nop-axe" />
    {#each T.ticks as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 8} class="nop-axe" />
      <text x={x(t)} y={BASE + (TRAITS.length ? 44 : 30)} class="nop-tick">{f(t)}</text>
    {/each}
    <text x={X1} y={BASE + (TRAITS.length ? 72 : 58)} class="nop-tick nop-fin">{T.axe}</text>

    <!-- 2 : le verdict et le pourquoi. -->
    <g class="nop-etape" class:nop-vu={e >= 2}>
      <text x={X0} y="120" class="nop-verdict">{T.verdict}</text>
      <text x={X0} y="152" class="nop-raison">{POURQUOI[0]}</text>
      <text x={X0} y="178" class="nop-raison">{POURQUOI[1]}</text>
    </g>
  </svg>
</div>

<style>
  .normale-ou-pas { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .nop-titre { font-size: 27px; font-weight: 600; fill: var(--dk-encre); }
  .nop-source { font-size: 18px; fill: var(--dk-gris); }
  .nop-pari { font-size: 24px; fill: var(--dk-gris); transition: opacity 0.3s; }
  .nop-q { font-size: 150px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris-2); transition: opacity 0.3s; }
  .nop-cache { opacity: 0; }
  .nop-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.6s cubic-bezier(0.34, 1.2, 0.64, 1), fill 0.4s; }
  .nop-baton.nop-rouge { fill: var(--dk-accent); }
  .nop-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .nop-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .nop-fin { text-anchor: end; }
  .nop-tour { stroke: var(--dk-accent); stroke-width: 2; }
  .nop-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; }
  .nop-plus { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .nop-plus.nop-g { text-anchor: start; }
  .nop-note { font-size: 16px; fill: var(--dk-gris); }
  .nop-verdict { font-size: 27px; font-weight: 600; fill: var(--dk-accent); }
  .nop-raison { font-size: 19px; fill: var(--dk-encre); }
  .nop-etape { opacity: 0; transition: opacity 0.2s; }
  .nop-etape.nop-vu { opacity: 1; transition: opacity 0.5s 0.4s; }
  @media (prefers-reduced-motion: reduce) {
    .nop-baton, .nop-q, .nop-pari, .nop-etape, .nop-etape.nop-vu { transition: none; }
  }
</style>
