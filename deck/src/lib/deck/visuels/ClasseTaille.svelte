<script>
  /**
   * « Une personne, une classe » : deux sortes de variation, sur un seul axe,
   * la taille en mètres. Une personne peut être petite ou grande, les gens
   * varient beaucoup. Mais la taille moyenne d'une classe de 50 personnes
   * tirées au hasard bouge à peine : les grands et les petits s'annulent.
   * Remplace les deux diapos des dés (Des, DesMoyenne). Cinq temps.
   *
   *   0  Six vrais adultes (PERSONNES), debout sur l'axe à leur taille. Chaque
   *      silhouette est aussi haute que la personne (1 px par cm), avec sa
   *      taille au-dessus. « Une personne : de … à …. Ça varie beaucoup. »
   *   1  Les silhouettes s'effacent, l'histogramme gris des adultes monte
   *      (POPULATION, tranches de 2 cm). « Les gens varient beaucoup. »
   *   2  Une classe de 50 adultes tirés au hasard (CLASSE) : 50 points sur une
   *      bande au-dessus de l'histogramme, chacun à sa taille, puis leur
   *      moyenne en rouge, qu'un pointillé descend jusqu'à l'axe.
   *   3  1 000 classes de 50 (CLASSES, tranches de 0,5 cm) : une cloche rouge
   *      étroite monte en trois secondes sur le même axe. La largeur se lit
   *      d'un coup d'œil : la cloche des moyennes est bien plus étroite que
   *      l'histogramme des gens. État final fixé : dès le temps 4, ou après
   *      trois secondes, les 1 000 moyennes sont toutes là.
   *   4  « Pourquoi ? » La classe revient au premier plan, ses points
   *      coloriés de part et d'autre de sa moyenne (plus petits en gris, plus
   *      grands en encre) : dans une classe, les grands et les petits
   *      s'annulent.
   *   5  Le lien avec la suite, sur une page vide : une personne, un.e
   *      répondant.e varient beaucoup. La moyenne d'une classe de 50, d'un
   *      sondage de 1 000 varie très peu. (Pas de pommes ici : la
   *      pomicultrice vient plus loin dans la séance.)
   *
   * Les hauteurs des bâtons sont schématiques : il n'y a pas d'axe vertical,
   * chaque histogramme est mis à l'échelle de son plus haut bâton (170 px pour
   * les gens, 240 px pour les moyennes, plus haut parce que plus serré). Ils
   * ne sont pas dessinés à une densité commune; seule la largeur se compare.
   *
   * L'ordre d'arrivée des 1 000 moyennes est fixe (comme dans Recommencer) :
   * la liste des tranches parcourue par pas constant premier avec sa
   * longueur. Rien d'aléatoire, l'état final égale les effectifs de R. Le
   * petit décalage vertical des 50 points de la classe est fixe lui aussi.
   *
   * Tailles affichées en mètres, arrondies au centimètre (Math.round sur les
   * cm, puis /100). Tout vient de src/lib/data/seance5_tailles.js
   * (outils/seance5_tailles.R, NHANES 2009 à 2012 par le paquet R NHANES,
   * adultes de 20 ans et plus).
   */
  import { brancherTemps } from '../temps.js';
  import { POPULATION, PERSONNES, CLASSE, CLASSES } from '$lib/data/seance5_tailles.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, N);
  // Une taille en cm, écrite en mètres au centimètre près : 150,5 cm donne « 1,51 m ».
  const m = (cm) => `${f(Math.round(cm) / 100, 2)}${N}m`;

  // L'axe : de 134 à 202 cm, les bornes de l'histogramme.
  const A0 = POPULATION.bornes[0];
  const A1 = POPULATION.bornes[POPULATION.bornes.length - 1];
  const X0 = 70, X1 = 930, BASE = 400;
  const x = (v) => X0 + ((v - A0) / (A1 - A0)) * (X1 - X0);
  const TICKS = [140, 150, 160, 170, 180, 190, 200];

  // 0 : six silhouettes, 1 px par cm, triées de la plus petite à la plus grande.
  const GENS = [...PERSONNES]
    .sort((a, b) => a - b)
    .map((h, i) => {
      const r = h * 0.07;
      return {
        h,
        x: x(h),
        tete: BASE - h + r,
        r,
        cou: BASE - h + 2 * r + 3,
        hanche: BASE - h * 0.47,
        l: h * 0.16,
        jambe: h * 0.065,
        ly: BASE - h - 14 - (i % 2) * 28,
        i
      };
    });
  const PLUS_PETIT = m(Math.min(...PERSONNES));
  const PLUS_GRAND = m(Math.max(...PERSONNES));

  // 1 : l'histogramme gris des adultes.
  const HPOP = 170;
  const MAXPOP = Math.max(...POPULATION.effectifs);
  const BARRES = POPULATION.effectifs.map((c, j) => ({
    a: POPULATION.bornes[j],
    b: POPULATION.bornes[j + 1],
    h: (c / MAXPOP) * HPOP
  }));

  // 2 : la classe de 50, sur une bande.
  const YB = 112;
  const POINTS = CLASSE.tailles.map((t, i) => ({
    x: x(t),
    y: YB + (((i * 7) % 5) - 2) * 8,
    grand: t > CLASSE.moyenne,
    i
  }));
  const XC = x(CLASSE.moyenne);
  const XMIN = x(Math.min(...CLASSE.tailles));
  const XMAX = x(Math.max(...CLASSE.tailles));

  // 3 : les 1 000 moyennes, arrivée dans un ordre fixe.
  const HMOY = 240;
  const MB = CLASSES.bornes;
  const MEFF = CLASSES.effectifs;
  const MAXMOY = Math.max(...MEFF);
  const NB = MEFF.reduce((s, c) => s + c, 0);
  const pgcd = (a, b) => (b ? pgcd(b, a % b) : a);
  const ORDRE = (() => {
    const liste = MEFF.flatMap((c, j) => Array(c).fill(j));
    const n = liste.length;
    let pas = Math.round(n * 0.618);
    while (pgcd(pas, n) !== 1) pas++;
    return liste.map((_, i) => liste[(i * pas) % n]);
  })();
  const DUREE = 3000;
  const calme = () => typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches;
  let t = $state(0);
  $effect(() => {
    if (e !== 3) return;
    if (calme()) {
      t = DUREE;
      return;
    }
    t = 0;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const k = $derived(e < 3 ? 0 : e > 3 ? NB : Math.max(1, Math.min(NB, Math.round((t / DUREE) * NB))));
  const MEFF_VU = $derived.by(() => {
    const c = new Array(MEFF.length).fill(0);
    for (let i = 0; i < k; i++) c[ORDRE[i]]++;
    return c;
  });
  const XLM = x(CLASSES.max) + 14;

  // Le texte, une idée par temps.
  const LIGNES = [
    { l1: `Une personne${N}: de ${PLUS_PETIT} à ${PLUS_GRAND}.`, l2: 'Ça varie beaucoup.' },
    { l1: `Les ${f(POPULATION.n)} adultes de l’enquête${N}: de ${m(POPULATION.min)} à ${m(POPULATION.max)}.`, l2: 'Les gens varient beaucoup.' },
    { l1: `Une classe de ${f(CLASSE.n)} adultes, tirés au hasard.`, l2: `Sa taille moyenne${N}: ${m(CLASSE.moyenne)}.`, rouge: true },
    { l1: `${f(CLASSES.nombre)} classes de ${f(CLASSES.n)}${N}: des moyennes de ${m(CLASSES.min)} à ${m(CLASSES.max)}.`, l2: 'Les moyennes de classes varient très peu.', rouge: true },
    { l1: `Pourquoi${N}?`, l2: 'Dans une classe, les grands et les petits s’annulent.' }
  ];

  const ARIA =
    `La taille des adultes de l’enquête NHANES, États-Unis, 2009 à 2012. ` +
    `Six adultes tirés au hasard mesurent de ${PLUS_PETIT} à ${PLUS_GRAND}${N}: une personne, ça varie beaucoup. ` +
    `Les ${f(POPULATION.n)} adultes vont de ${m(POPULATION.min)} à ${m(POPULATION.max)}. ` +
    `Une classe de ${f(CLASSE.n)} adultes tirés au hasard a une taille moyenne de ${m(CLASSE.moyenne)}. ` +
    `Les moyennes de ${f(CLASSES.nombre)} classes de ${f(CLASSES.n)} vont de ${m(CLASSES.min)} à ${m(CLASSES.max)}, une cloche étroite${N}: ` +
    `les moyennes de classes varient très peu, parce que dans une classe, les grands et les petits s’annulent. ` +
    `De même, une personne ou un.e répondant.e varie beaucoup, mais la moyenne d’une classe de 50 ` +
    `ou d’un sondage de 1${N}000 varie très peu.`;
</script>

<div class="visuel classe-taille" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={ARIA}>
    <g class="ct-graphe" class:ct-parti={e >= 5}>
      <text x={X0} y="24" class="ct-source">NHANES · États-Unis, 2009 à 2012</text>
      <text x={X1} y="24" class="ct-source ct-droite ct-l" class:ct-vu={e === 0}>six adultes, tirés au hasard</text>

      <!-- 1 : l'histogramme gris des adultes. -->
      <g class="ct-pop" class:ct-pale={e >= 3}>
        {#each BARRES as b, j}
          <rect x={x(b.a) + 1} y={BASE - HPOP} width={x(b.b) - x(b.a) - 2} height={HPOP}
                class="ct-barre"
                style="transform: scaleY({e >= 1 ? b.h / HPOP : 0}); transition-delay: {e >= 1 ? 300 + j * 20 : 0}ms" />
        {/each}
        <text x={x(184)} y="322" class="ct-nom ct-l" class:ct-vu={e >= 1} style="transition-delay: {e === 1 ? 900 : 0}ms">{f(POPULATION.n)} adultes</text>
      </g>

      <!-- 3 : la cloche rouge des 1 000 moyennes. -->
      <g class:ct-pale={e === 4}>
        {#each MEFF_VU as c, j}
          <rect x={x(MB[j]) + 0.75} y={BASE - (c / MAXMOY) * HMOY} width={x(MB[j + 1]) - x(MB[j]) - 1.5} height={(c / MAXMOY) * HMOY} class="ct-moy" />
        {/each}
        <text x={XLM} y="210" class="ct-nom ct-rouge ct-l" class:ct-vu={e >= 3}>{f(CLASSES.nombre)} moyennes</text>
      </g>

      <!-- L'axe de la taille. -->
      <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ct-axe" />
      {#each TICKS as v}
        <line x1={x(v)} y1={BASE} x2={x(v)} y2={BASE + 8} class="ct-axe" />
        <text x={x(v)} y={BASE + 30} class="ct-tick">{f(v / 100, 2)}</text>
      {/each}
      <text x={X1} y={BASE + 56} class="ct-tick ct-droite">taille (m)</text>

      <!-- 0 : six vraies personnes, debout à leur taille. -->
      <g class="ct-gens" class:ct-parti={e >= 1}>
        {#each GENS as g}
          <g class="ct-silhouette" style="--d: {g.i * 90}ms">
            <circle cx={g.x} cy={g.tete} r={g.r} />
            <rect x={g.x - g.l / 2} y={g.cou} width={g.l} height={g.hanche - g.cou} />
            <rect x={g.x - g.l / 2} y={g.hanche - 1} width={g.jambe} height={BASE - g.hanche + 1} />
            <rect x={g.x + g.l / 2 - g.jambe} y={g.hanche - 1} width={g.jambe} height={BASE - g.hanche + 1} />
          </g>
          <text x={g.x} y={g.ly} class="ct-taille" style="--d: {g.i * 90 + 200}ms">{m(g.h)}</text>
        {/each}
      </g>

      <!-- 2 : une classe de 50, et sa moyenne. 4 : les petits et les grands. -->
      <g class="ct-classe" class:ct-vu={e === 2 || e === 4} class:ct-pale={e === 3} class:ct-pourquoi={e === 4}>
        {#each POINTS as p}
          <circle cx={p.x} cy={p.y} r="6" class="ct-pt" class:ct-grand={p.grand}
                  style="transition-delay: {e === 2 ? p.i * 18 : 0}ms" />
        {/each}
        <g class="ct-moyenne">
          <line x1={XC} y1={YB} x2={XC} y2={BASE} class="ct-pointille" />
          <circle cx={XC} cy={YB} r="11" class="ct-rond" />
          <circle cx={XC} cy={BASE} r="9" class="ct-rond" />
          <text x={XC} y="72" class="ct-moy-t">{m(CLASSE.moyenne)}</text>
        </g>
        <g class="ct-cotes">
          <text x={XMIN - 16} y={YB + 7} class="ct-cote ct-droite">plus petits</text>
          <text x={XMAX + 16} y={YB + 7} class="ct-cote ct-encre">plus grands</text>
        </g>
      </g>

      <!-- Le texte. -->
      {#each LIGNES as l, i}
        <g class="ct-l" class:ct-vu={e === i} style="transition-delay: {e === i && i > 0 ? 700 : 0}ms">
          <text x={X0} y="490" class="ct-l1">{l.l1}</text>
          <text x={X0} y="526" class="ct-l2" class:ct-rouge={l.rouge}>{l.l2}</text>
        </g>
      {/each}
    </g>

    <!-- 5 : le lien avec la suite. -->
    <g class="ct-lien" class:ct-vu={e >= 5}>
      <text x="500" y="170" class="ct-chaine">une personne → un.e répondant.e</text>
      <text x="500" y="210" class="ct-sous">varie beaucoup</text>
      <text x="500" y="330" class="ct-chaine ct-rouge">une classe de 50 → un sondage de 1&#8239;000</text>
      <text x="500" y="370" class="ct-sous ct-rouge">sa moyenne varie très peu</text>
    </g>
  </svg>
</div>

<style>
  .classe-taille { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .ct-graphe { transition: opacity 0.4s; }
  .ct-graphe.ct-parti { opacity: 0; }
  .ct-source { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .ct-droite { text-anchor: end; }

  .ct-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ct-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ct-tick.ct-droite { text-anchor: end; }

  /* Les six personnes. */
  .ct-gens { transition: opacity 0.4s; }
  .ct-gens.ct-parti { opacity: 0; }
  .ct-silhouette { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; animation: ct-monte 0.5s cubic-bezier(0.34, 1.3, 0.64, 1) both; animation-delay: var(--d); }
  @keyframes ct-monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .ct-taille { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); animation: ct-apparait 0.4s both; animation-delay: var(--d); }
  @keyframes ct-apparait { from { opacity: 0; } to { opacity: 1; } }

  /* L'histogramme des adultes. */
  .ct-pop { transition: opacity 0.4s; }
  .ct-pop.ct-pale { opacity: 0.55; }
  .ct-barre { fill: var(--dk-gris-2); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.6s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .ct-nom { font-size: 20px; font-weight: 600; fill: var(--dk-gris); }

  /* Les 1 000 moyennes. */
  .ct-moy { fill: var(--dk-accent); }
  .ct-pale { opacity: 0.3; transition: opacity 0.4s; }

  /* La classe de 50. */
  .ct-classe { opacity: 0; transition: opacity 0.3s; }
  .ct-classe.ct-vu { opacity: 1; }
  .ct-classe.ct-pale { opacity: 0.25; }
  .ct-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2; opacity: 0; transition: opacity 0.25s, fill 0.4s; }
  .ct-classe.ct-vu .ct-pt, .ct-classe.ct-pale .ct-pt { opacity: 1; }
  .ct-classe.ct-pourquoi .ct-pt { fill: var(--dk-gris-2); }
  .ct-classe.ct-pourquoi .ct-pt.ct-grand { fill: var(--dk-encre); }
  .ct-moyenne { opacity: 0; transition: opacity 0.2s; }
  .ct-classe.ct-vu .ct-moyenne, .ct-classe.ct-pale .ct-moyenne { opacity: 1; transition: opacity 0.5s 1.3s; }
  .ct-pointille { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 9 7; }
  .ct-rond { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2.5; }
  .ct-moy-t { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ct-cotes { opacity: 0; transition: opacity 0.2s; }
  .ct-classe.ct-pourquoi .ct-cotes { opacity: 1; transition: opacity 0.4s 0.4s; }
  .ct-cote { font-size: 20px; font-weight: 600; fill: var(--dk-gris); }
  .ct-cote.ct-encre { fill: var(--dk-encre); }

  /* Le texte. */
  .ct-l { opacity: 0; transition: opacity 0.2s; }
  .ct-l.ct-vu { opacity: 1; transition: opacity 0.4s; }
  .ct-l1 { font-size: 22px; fill: var(--dk-encre); }
  .ct-l2 { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .ct-rouge { fill: var(--dk-accent); }

  /* Le lien. */
  .ct-lien { opacity: 0; transition: opacity 0.2s; }
  .ct-lien.ct-vu { opacity: 1; transition: opacity 0.5s 0.3s; }
  .ct-chaine { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ct-chaine.ct-rouge { fill: var(--dk-accent); }
  .ct-sous { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ct-sous.ct-rouge { fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .ct-silhouette, .ct-taille { animation: none; }
    .ct-graphe, .ct-gens, .ct-pop, .ct-barre, .ct-pale, .ct-classe, .ct-pt, .ct-moyenne,
    .ct-classe.ct-vu .ct-moyenne, .ct-classe.ct-pale .ct-moyenne, .ct-cotes,
    .ct-classe.ct-pourquoi .ct-cotes, .ct-l, .ct-l.ct-vu, .ct-lien, .ct-lien.ct-vu { transition: none; }
  }
</style>
