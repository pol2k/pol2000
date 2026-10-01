<script>
  /**
   * Le théorème central limite, en une diapo. Trois données vues au quiz,
   * de formes très différentes (les bâtiments de New York, l'âge des
   * répondant.e.s, la note donnée à Pierre Poilievre), et, dessous, les
   * moyennes d'échantillons tirés au hasard dans chacune : trois cloches.
   * Quatre temps.
   *
   *   0  Les trois formes : longue queue, plateau, deux camps.
   *   1  Les trois cloches de moyennes (2 000 bâtiments, 50 personnes,
   *      50 notes par échantillon; 1 000 échantillons chaque fois). Chaque
   *      panneau a sa propre échelle : c'est la forme qu'on regarde.
   *   2  L'énoncé, en mots simples, en grand (le h2 donne le nom).
   *   3  Les conditions : un vrai hasard, et des échantillons assez grands
   *      (New York, avec sa très longue queue, en demande 2 000).
   *
   * Données : NYC_POP, NYC_MOYENNES, QUIZ (âge, poilievre) et
   * POILIEVRE_MOYENNES dans src/lib/data/seance5_normale.js; DISTRIBUTIONS
   * et BORNES dans src/lib/data/seance5.js. Tout est calculé par R.
   */
  import { brancherTemps } from '../temps.js';
  import { NYC_POP, NYC_MOYENNES, QUIZ, POILIEVRE_MOYENNES } from '$lib/data/seance5_normale.js';
  import { DISTRIBUTIONS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const AGE = QUIZ.find((q) => q.cle === 'age');
  const POIL = QUIZ.find((q) => q.cle === 'poilievre');
  // Les moyennes d'âge : on garde les tranches non vides de DISTRIBUTIONS[1].
  const d50 = DISTRIBUTIONS[1].effectifs;
  const j0 = d50.findIndex((c) => c > 0), j1 = d50.length - [...d50].reverse().findIndex((c) => c > 0);
  const COLS = [
    { nom: 'les bâtiments de New York', forme: 'longue queue', haut: NYC_POP.effectifs, bas: NYC_MOYENNES[2].effectifs, n: f(NYC_MOYENNES[2].n) },
    { nom: 'l’âge des répondant.e.s', forme: 'plateau', haut: AGE.effectifs, bas: d50.slice(j0, j1), n: f(DISTRIBUTIONS[1].n) },
    { nom: 'la note de Poilievre', forme: 'deux camps', haut: POIL.effectifs, bas: POILIEVRE_MOYENNES.effectifs, n: f(POILIEVRE_MOYENNES.n) }
  ];
  const W = 270, G = 45, X0 = (1000 - (3 * W + 2 * G)) / 2;
  const Y_HAUT = 150, Y_BAS = 290, H = 72;
  const batons = (eff, x0) => {
    const max = Math.max(...eff), l = W / eff.length;
    return eff.map((c, j) => ({ x: x0 + j * l, w: l, h: (c / max) * H }));
  };
</script>

<div class="visuel theoreme" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Trois données de formes très différentes : les bâtiments de New York (une longue queue), l’âge des répondant.e.s (un plateau), la note donnée à Pierre Poilievre (deux camps). Les moyennes d’échantillons tirés au hasard dans chacune forment trois cloches. Peu importe la forme des données, si on tire des échantillons au hasard, leurs moyennes forment une cloche. Deux conditions : un vrai hasard, et des échantillons assez grands.">
    {#each COLS as c, i}
      {@const x0 = X0 + i * (W + G)}
      <text x={x0 + W / 2} y="32" class="tc-nom">{c.nom}</text>
      <text x={x0 + W / 2} y="58" class="tc-forme">{c.forme}</text>
      {#each batons(c.haut, x0) as b}
        <rect x={b.x + 0.5} y={Y_HAUT - b.h} width={Math.max(0.5, b.w - 1)} height={b.h} class="tc-baton" />
      {/each}
      <line x1={x0} y1={Y_HAUT} x2={x0 + W} y2={Y_HAUT} class="tc-axe" />
      <!-- 1 : les moyennes. -->
      <g class="tc-etape" class:tc-vu={e >= 1}>
        <path d="M {x0 + W / 2} {Y_HAUT + 12} V {Y_BAS - H - 10} M {x0 + W / 2 - 9} {Y_BAS - H - 20} L {x0 + W / 2} {Y_BAS - H - 10} L {x0 + W / 2 + 9} {Y_BAS - H - 20}" class="tc-fleche" />
        <text x={x0 + W / 2 + 14} y={Y_HAUT + 42} class="tc-n">moyennes de {c.n}</text>
        {#each batons(c.bas, x0) as b}
          <rect x={b.x + 0.5} y={Y_BAS - b.h} width={Math.max(0.5, b.w - 1)} height={b.h} class="tc-baton tc-rouge" />
        {/each}
        <line x1={x0} y1={Y_BAS} x2={x0 + W} y2={Y_BAS} class="tc-axe" />
        <text x={x0 + W / 2} y={Y_BAS + 28} class="tc-forme tc-cloche">une cloche</text>
      </g>
    {/each}

    <!-- 2 : l'énoncé, en mots. -->
    <g class="tc-etape" class:tc-vu={e >= 2}>
      <text x="500" y="368" class="tc-enonce">Peu importe la forme des données,</text>
      <text x="500" y="404" class="tc-enonce">si on tire des échantillons au hasard,</text>
      <text x="500" y="440" class="tc-enonce tc-cloche">leurs moyennes forment une cloche.</text>
    </g>
    <!-- 3 : les conditions. -->
    <g class="tc-etape" class:tc-vu={e >= 3}>
      <text x="500" y="486" class="tc-condition">Deux conditions&#8239;: un vrai hasard, et des échantillons assez grands.</text>
    </g>
  </svg>
</div>

<style>
  .theoreme { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .tc-nom { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tc-forme { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .tc-cloche { fill: var(--dk-accent); font-weight: 600; }
  .tc-baton { fill: var(--dk-encre); }
  .tc-baton.tc-rouge { fill: var(--dk-accent); }
  .tc-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tc-fleche { fill: none; stroke: var(--dk-gris); stroke-width: 2.5; }
  .tc-n { font-size: 17px; fill: var(--dk-gris); }
  .tc-enonce { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tc-enonce.tc-cloche { fill: var(--dk-accent); }
  .tc-condition { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tc-etape { opacity: 0; transition: opacity 0.3s; }
  .tc-etape.tc-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .tc-etape, .tc-etape.tc-vu { transition: none; }
  }
</style>
