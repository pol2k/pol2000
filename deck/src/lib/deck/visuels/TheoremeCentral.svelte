<script>
  /**
   * Le théorème central limite, en une diapo. Trois données de formes très
   * différentes (les bâtiments de New York, l'âge des répondant.e.s, les
   * pétales d'iris), et, dessous, les moyennes d'échantillons tirés au
   * hasard dans chacune : trois cloches. Quatre temps.
   *
   *   0  Les trois formes : longue queue, plateau, deux bosses.
   *   1  Les trois cloches de moyennes (2 000 bâtiments, 50 personnes,
   *      50 pétales par échantillon; 1 000 échantillons chaque fois). Chaque
   *      panneau a sa propre échelle : c'est la forme qu'on regarde.
   *   2  L'énoncé, en mots.
   *   3  La condition : le hasard doit vraiment être là. Et le lien avec la
   *      nature (la planche de Galton).
   *
   * Données : NYC_POP, NYC_MOYENNES, QUIZ (âge, iris) et IRIS_MOYENNES dans
   * src/lib/data/seance5_normale.js; DISTRIBUTIONS et BORNES dans
   * src/lib/data/seance5.js. Tout est calculé par R.
   */
  import { brancherTemps } from '../temps.js';
  import { NYC_POP, NYC_MOYENNES, QUIZ, IRIS_MOYENNES } from '$lib/data/seance5_normale.js';
  import { DISTRIBUTIONS, BORNES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const AGE = QUIZ.find((q) => q.cle === 'age');
  const IRIS = QUIZ.find((q) => q.cle === 'iris');
  // Les moyennes d'âge : on garde les tranches non vides de DISTRIBUTIONS[1].
  const d50 = DISTRIBUTIONS[1].effectifs;
  const j0 = d50.findIndex((c) => c > 0), j1 = d50.length - [...d50].reverse().findIndex((c) => c > 0);
  const AGE_M = { effectifs: d50.slice(j0, j1), bornes: BORNES.slice(j0, j1 + 1) };
  const COLS = [
    { nom: 'les bâtiments de New York', forme: 'longue queue', haut: NYC_POP.effectifs, bas: NYC_MOYENNES[2].effectifs, n: '2 000' },
    { nom: 'l’âge des répondant.e.s', forme: 'plateau', haut: AGE.effectifs, bas: AGE_M.effectifs, n: '50' },
    { nom: 'les pétales d’iris', forme: 'deux bosses', haut: IRIS.effectifs, bas: IRIS_MOYENNES.effectifs, n: '50' }
  ];
  const W = 270, G = 45, X0 = (1000 - (3 * W + 2 * G)) / 2;
  const Y_HAUT = 150, Y_BAS = 330, H = 88;
  const batons = (eff, x0) => {
    const max = Math.max(...eff), l = W / eff.length;
    return eff.map((c, j) => ({ x: x0 + j * l, w: l, h: (c / max) * H }));
  };
</script>

<div class="visuel theoreme" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Trois données de formes très différentes : les bâtiments de New York (une longue queue), l’âge des répondant.e.s (un plateau), les pétales d’iris (deux bosses). Les moyennes d’échantillons tirés au hasard dans chacune forment trois cloches. Le théorème central limite : peu importe la forme des données, la moyenne d’un échantillon tiré au hasard suit une courbe normale. À une condition : le hasard doit vraiment être là.">
    {#each COLS as c, i}
      {@const x0 = X0 + i * (W + G)}
      <text x={x0 + W / 2} y="36" class="tc-nom">{c.nom}</text>
      <text x={x0 + W / 2} y="62" class="tc-forme">{c.forme}</text>
      {#each batons(c.haut, x0) as b}
        <rect x={b.x + 0.5} y={Y_HAUT - b.h} width={Math.max(0.5, b.w - 1)} height={b.h} class="tc-baton" />
      {/each}
      <line x1={x0} y1={Y_HAUT} x2={x0 + W} y2={Y_HAUT} class="tc-axe" />
      <g class="tc-etape" class:tc-vu={e >= 1}>
        <path d="M {x0 + W / 2} {Y_HAUT + 14} V {Y_BAS - H - 36} M {x0 + W / 2 - 9} {Y_BAS - H - 46} L {x0 + W / 2} {Y_BAS - H - 36} L {x0 + W / 2 + 9} {Y_BAS - H - 46}" class="tc-fleche" />
        <text x={x0 + W / 2 + 16} y={Y_HAUT + 44} class="tc-n">moyennes de {c.n}</text>
        {#each batons(c.bas, x0) as b}
          <rect x={b.x + 0.5} y={Y_BAS - b.h} width={Math.max(0.5, b.w - 1)} height={b.h} class="tc-baton tc-rouge" />
        {/each}
        <line x1={x0} y1={Y_BAS} x2={x0 + W} y2={Y_BAS} class="tc-axe" />
        <text x={x0 + W / 2} y={Y_BAS + 30} class="tc-forme tc-cloche">une cloche</text>
      </g>
    {/each}

    <!-- 2 : l'énoncé. -->
    <g class="tc-etape" class:tc-vu={e >= 2}>
      <text x="500" y="410" class="tc-titre">Le théorème central limite</text>
      <text x="500" y="440" class="tc-enonce">Peu importe la forme des données, les moyennes d’échantillons font une cloche.</text>
    </g>
    <!-- 3 : la condition. -->
    <g class="tc-etape" class:tc-vu={e >= 3}>
      <text x="500" y="472" class="tc-condition">À une condition&#8239;: le hasard doit vraiment être là. Tirage au hasard, causes indépendantes.</text>
      <text x="500" y="498" class="tc-nature">Dans la nature aussi&#8239;: beaucoup de petites causes indépendantes additionnées.</text>
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
  .tc-n { font-size: 15px; fill: var(--dk-gris); }
  .tc-titre { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .tc-enonce { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tc-condition { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tc-nature { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .tc-etape { opacity: 0; transition: opacity 0.3s; }
  .tc-etape.tc-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .tc-etape, .tc-etape.tc-vu { transition: none; }
  }
</style>
