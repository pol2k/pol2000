<script>
  /**
   * Les données ou leurs moyennes ? Une carte de la séance 5, placée après
   * le théorème central limite. Le point : les données peuvent avoir
   * n'importe quelle forme, mais les moyennes d'échantillons tirés au hasard
   * dans ces données forment une cloche. Trois temps.
   *
   *   0  Ce qui a été mesuré, en grand, et sa source. Le cadre de gauche
   *      est vide, un grand « ? ».
   *   1  À gauche, l'histogramme des DONNÉES monte, bâton par bâton, en
   *      encre, avec sa forme en deux mots (une cloche, deux camps, une
   *      longue queue, un plateau). Pour les bâtiments de New York, tout le
   *      spectre, de 0 à 480 m, et un trait rouge sous l'axe par mètre où se
   *      trouve au moins un bâtiment de 40 m ou plus : les tours, invisibles
   *      en bâtons, apparaissent, avec leur nombre.
   *   2  « et la moyenne de N … tirés au hasard ? » : à droite, plus petit
   *      et en rouge, l'histogramme de 1 000 moyennes d'échantillons. Une
   *      cloche. Chaque histogramme a son propre axe (les moyennes se
   *      serrent au milieu des données) : les graduations le disent.
   *   3  Une ligne : les données, telle forme. Leurs moyennes, une cloche.
   *
   * Les cartes : hommes (déjà une cloche, et leurs moyennes aussi),
   * poilievre, nyc, age. Poilievre : la note de 0 à 100 donnée au chef
   * conservateur par les répondant.e.s de la CES 2025. Tranches de 5 points;
   * la dernière, [100, 105), ne contient que les notes de 100 pile. La
   * tranche [0, 5) contient aussi les notes de 1 à 4 : on ne la cite donc pas
   * comme « des zéros ». La source affiche la taille de toute l'enquête
   * (POP.n), jamais le nombre de répondant.e.s qui ont noté Poilievre.
   *
   * Les effectifs des données viennent de QUIZ; les moyennes de
   * HOMMES_MOYENNES (50 hommes), POILIEVRE_MOYENNES (50 notes), NYC_MOYENNES
   * (l'entrée à 2 000 bâtiments), tous dans src/lib/data/seance5_normale.js
   * (outils/seance5_normale.R), et pour l'âge de DISTRIBUTIONS (l'entrée à
   * 50 répondant.e.s) et BORNES de src/lib/data/seance5.js
   * (outils/seance5_data.R). Pour l'âge, les tranches vides aux deux bouts
   * (de 30 à 70 ans) sont retirées de l'affichage : elles ne contiennent
   * aucune moyenne. Les formes sont lues à l'œil, comme en classe (aucun
   * test de normalité) : elles sont écrites dans ce fichier.
   *
   * Les hommes : au Québec, une taille se dit en pieds et pouces. Les
   * données arrivent en pouces (R a divisé les cm de NHANES par 2,54). Les
   * graduations s'écrivent comme dans ClasseTaille.svelte : aux 4 pouces,
   * « 5 pi », « 5 pi 4 », « 5 pi 8 »; celles des moyennes, au pouce.
   *
   * L'âge, vérifié le 30 septembre 2026 contre Statistique Canada (tableau
   * 17-10-0005-01, 1er juillet 2025, 18 ans et plus) : de 7 à 9 % par
   * tranche de cinq ans jusque vers 70 ans, puis ça descend. La CES, bâtie
   * avec des quotas d'âge, reproduit ce plateau (la petite bosse vers 60 ans
   * vient du panel, pas de la population).
   */
  import { brancherTemps } from '../temps.js';
  import { QUIZ, NYC_MOYENNES, POILIEVRE_MOYENNES, HOMMES_MOYENNES } from '$lib/data/seance5_normale.js';
  import { DISTRIBUTIONS, BORNES, POP } from '$lib/data/seance5.js';
  let { cle } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const N = ' ';
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, N);

  // Une graduation en pieds et pouces : 64 po donne « 5 pi 4 », 60 po donne « 5 pi ».
  const grad = (po) => (po % 12 ? `${Math.floor(po / 12)}${N}pi ${po % 12}` : `${po / 12}${N}pi`);

  const AGE_50 = DISTRIBUTIONS.find((d) => d.n === 50);
  const MOYENNES = {
    hommes: HOMMES_MOYENNES,
    poilievre: POILIEVRE_MOYENNES,
    nyc: NYC_MOYENNES.find((m) => m.n === 2000),
    age: { n: AGE_50.n, bornes: BORNES, effectifs: AGE_50.effectifs }
  };

  const Q = $derived(QUIZ.find((q) => q.cle === cle));
  const TEXTE = {
    hommes: {
      titre: (q) => `La taille de ${f(q.n)} hommes adultes`,
      source: () => 'États-Unis, enquête NHANES, 2009 à 2012',
      axe: 'taille (pieds et pouces)', ticks: [60, 64, 68, 72, 76, 80], etiquette: grad,
      rpas: 1,
      forme: 'une cloche',
      qui: 'hommes tirés au hasard',
      unite: ', pieds et pouces',
      fin: [`Les données${N}: déjà une cloche,`, ' et leurs moyennes aussi.']
    },
    poilievre: {
      titre: () => 'Ce que les répondant.e.s pensent de Pierre Poilievre',
      source: () => `Étude électorale canadienne 2025, ${f(POP.n)} répondant.e.s`,
      axe: 'note de 0 à 100', ticks: [0, 20, 40, 60, 80, 100],
      forme: 'deux camps',
      qui: 'personnes tirées au hasard',
      unite: ', note sur 100',
      fin: [`Les données${N}: deux camps.`, ` Leurs moyennes${N}: une cloche.`]
    },
    nyc: {
      titre: (q) => `La hauteur des ${f(q.n)} bâtiments de New York`,
      source: () => 'NYC Open Data, 2026',
      axe: 'hauteur (m)', ticks: [0, 100, 200, 300, 400],
      forme: 'une longue queue',
      qui: 'bâtiments tirés au hasard',
      unite: ' (m)',
      fin: [`Les données${N}: une longue queue.`, ` Leurs moyennes${N}: une cloche.`]
    },
    age: {
      titre: (q) => `L’âge des ${f(q.n)} répondant.e.s de l’Étude électorale`,
      source: () => 'Étude électorale canadienne 2025',
      axe: 'âge (ans)', ticks: [20, 40, 60, 80, 100],
      forme: 'un plateau',
      qui: 'personnes tirées au hasard',
      unite: ' (ans)',
      fin: [`Les données${N}: un plateau.`, ` Leurs moyennes${N}: une cloche.`]
    }
  };
  const T = $derived(TEXTE[cle]);

  // Gauche : les données. Droite : les moyennes, plus petites.
  const X0 = 60, X1 = 540, RX0 = 620, RX1 = 960, BASE = 380, HAUT = 200, RHAUT = 150;
  const B0 = $derived(Q.bornes[0]);
  const B1 = $derived(Q.bornes[Q.bornes.length - 1]);
  const x = (v) => X0 + ((v - B0) / (B1 - B0)) * (X1 - X0);
  const MAX = $derived(Math.max(...Q.effectifs));
  const BATONS = $derived(Q.effectifs.map((c, j) => ({ a: Q.bornes[j], b: Q.bornes[j + 1], h: (c / MAX) * HAUT })));
  // Les tours de New York : un trait par mètre occupé, à partir de 40 m.
  const TRAITS = $derived(Q.traits ?? []);

  // Les moyennes : on retire les tranches vides aux deux bouts (on en garde une).
  const M = $derived.by(() => {
    const brut = MOYENNES[cle];
    const pleins = brut.effectifs.map((c, j) => (c > 0 ? j : -1)).filter((j) => j >= 0);
    const i0 = Math.max(0, pleins[0] - 1);
    const i1 = Math.min(brut.effectifs.length - 1, pleins[pleins.length - 1] + 1);
    return {
      n: brut.n,
      bornes: brut.bornes.slice(i0, i1 + 2),
      effectifs: brut.effectifs.slice(i0, i1 + 1),
      total: brut.effectifs.reduce((s, c) => s + c, 0)
    };
  });
  const M0 = $derived(M.bornes[0]);
  const M1 = $derived(M.bornes[M.bornes.length - 1]);
  const xr = (v) => RX0 + ((v - M0) / (M1 - M0)) * (RX1 - RX0);
  const RMAX = $derived(Math.max(...M.effectifs));
  const RBATONS = $derived(M.effectifs.map((c, j) => ({ a: M.bornes[j], b: M.bornes[j + 1], h: (c / RMAX) * RHAUT })));
  // Graduations des moyennes : le plus fin des pas qui en donne au plus cinq.
  // Les hommes : au pouce (T.rpas), écrites en pieds et pouces.
  const RTICKS = $derived.by(() => {
    for (const pas of T.rpas ? [T.rpas] : [0.1, 0.2, 0.5, 1, 2, 5, 10, 20]) {
      const k0 = Math.ceil(M0 / pas - 1e-9), k1 = Math.floor(M1 / pas + 1e-9);
      if (k1 - k0 + 1 <= 5) {
        return Array.from({ length: k1 - k0 + 1 }, (_, i) => ({ v: Math.round((k0 + i) * pas * 1000) / 1000, d: pas < 1 ? 1 : 0 }));
      }
    }
    return [];
  });
  const RAXE = $derived(`${f(M.total)} moyennes${T.unite}`);

  const ARIA = $derived(`${T.titre(Q)} (${T.source(Q)}). Les données${N}: ${T.forme}. ` +
    `Et la moyenne de ${f(M.n)} ${T.qui}${N}? ${f(M.total)} moyennes, en rouge${N}: une cloche. ${T.fin.join('')}`);
</script>

<div class="visuel normale-ou-pas" bind:this={hote}>
  <svg viewBox="0 0 1000 520" role="img" aria-label={ARIA}>
    <text x={X0} y="40" class="nop-titre">{T.titre(Q)}</text>
    <text x={X0} y="70" class="nop-source">{T.source(Q)}</text>

    <!-- 0 : le pari, posé par le h2. -->
    <text x={(X0 + X1) / 2} y="330" class="nop-q" class:nop-cache={e >= 1}>?</text>

    <!-- 1 : les données et leur forme. -->
    <g class="nop-etape" class:nop-vu={e >= 1}>
      <text x={X0} y="112" class="nop-entete">les données</text>
      <text x={X0} y="144" class="nop-forme">{T.forme}</text>
    </g>
    {#each BATONS as b, j}
      <rect x={x(b.a) + 1} y={BASE - HAUT} width={Math.max(1, x(b.b) - x(b.a) - 2)} height={HAUT}
            class="nop-baton"
            style="transform: scaleY({e >= 1 ? b.h / HAUT : 0}); transition-delay: {e >= 1 ? Math.min(j, 40) * 25 : 0}ms" />
    {/each}
    {#if TRAITS.length}
      <g class="nop-etape" class:nop-vu={e >= 1}>
        {#each TRAITS as m}
          <line x1={x(m + 0.5)} y1={BASE + 4} x2={x(m + 0.5)} y2={BASE + 18} class="nop-tour" />
        {/each}
        <text x={x(Q.max)} y={BASE - 58} class="nop-plus">la plus haute&#8239;: {f(Q.max)} m</text>
        <path d="M {x(Q.max)} {BASE - 50} L {x(Q.max)} {BASE - 4}" class="nop-fleche" />
        <text x={x(100)} y={BASE - 150} class="nop-plus nop-g">{f(Q.plus40)} bâtiments de plus de 40 m</text>
        <text x={x(100)} y={BASE - 124} class="nop-plus nop-g">{f(Q.plus100)} de plus de 100 m</text>
        <text x={x(100)} y={BASE - 98} class="nop-plus nop-g">{f(Q.plus200)} de plus de 200 m</text>
      </g>
    {/if}

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="nop-axe" />
    {#each T.ticks as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 8} class="nop-axe" />
      <text x={x(t)} y={BASE + (TRAITS.length ? 44 : 30)} class="nop-tick">{T.etiquette ? T.etiquette(t) : f(t)}</text>
    {/each}
    <text x={X1} y={BASE + (TRAITS.length ? 72 : 58)} class="nop-tick nop-fin">{T.axe}</text>

    <!-- 2 : et la moyenne de N, tirés au hasard ? 1 000 fois. -->
    <g class="nop-etape" class:nop-vu={e >= 2}>
      <text x={RX0} y="112" class="nop-entete">et la moyenne de {f(M.n)}</text>
      <text x={RX0} y="140" class="nop-question">{T.qui}&#8239;?</text>
      <path d="M 556 {BASE - 75} L 602 {BASE - 75} M 591 {BASE - 85} L 603 {BASE - 75} L 591 {BASE - 65}" class="nop-fleche" />
      <line x1={RX0} y1={BASE} x2={RX1} y2={BASE} class="nop-axe" />
      {#each RTICKS as t}
        <line x1={xr(t.v)} y1={BASE} x2={xr(t.v)} y2={BASE + 8} class="nop-axe" />
        <text x={xr(t.v)} y={BASE + 30} class="nop-tick">{T.etiquette ? T.etiquette(t.v) : f(t.v, t.d)}</text>
      {/each}
      <text x={RX1} y={BASE + 58} class="nop-tick nop-fin">{RAXE}</text>
    </g>
    {#each RBATONS as b, j}
      <rect x={xr(b.a) + 1} y={BASE - RHAUT} width={Math.max(1, xr(b.b) - xr(b.a) - 2)} height={RHAUT}
            class="nop-baton nop-rouge"
            style="transform: scaleY({e >= 2 ? b.h / RHAUT : 0}); transition-delay: {e >= 2 ? 300 + Math.min(j, 40) * 25 : 0}ms" />
    {/each}

    <!-- 3 : la phrase à retenir. -->
    <g class="nop-etape" class:nop-vu={e >= 3}>
      <text x={X0} y={BASE + 118} class="nop-fin-ligne"><tspan class="nop-encre">{T.fin[0]}</tspan><tspan class="nop-accent">{T.fin[1]}</tspan></text>
    </g>
  </svg>
</div>

<style>
  .normale-ou-pas { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .nop-titre { font-size: 27px; font-weight: 600; fill: var(--dk-encre); }
  .nop-source { font-size: 18px; fill: var(--dk-gris); }
  .nop-q { font-size: 150px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris-2); transition: opacity 0.3s; }
  .nop-cache { opacity: 0; }
  .nop-entete { font-size: 19px; fill: var(--dk-gris); }
  .nop-forme { font-size: 27px; font-weight: 600; fill: var(--dk-encre); }
  .nop-question { font-size: 19px; font-weight: 600; fill: var(--dk-accent); }
  .nop-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.6s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .nop-baton.nop-rouge { fill: var(--dk-accent); }
  .nop-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .nop-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .nop-fin { text-anchor: end; }
  .nop-tour { stroke: var(--dk-accent); stroke-width: 1.5; }
  .nop-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; }
  .nop-plus { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .nop-plus.nop-g { text-anchor: start; }
  .nop-fin-ligne { font-size: 24px; font-weight: 600; }
  .nop-encre { fill: var(--dk-encre); }
  .nop-accent { fill: var(--dk-accent); }
  .nop-etape { opacity: 0; transition: opacity 0.2s; }
  .nop-etape.nop-vu { opacity: 1; transition: opacity 0.5s 0.4s; }
  @media (prefers-reduced-motion: reduce) {
    .nop-baton, .nop-q, .nop-etape, .nop-etape.nop-vu { transition: none; }
  }
</style>
