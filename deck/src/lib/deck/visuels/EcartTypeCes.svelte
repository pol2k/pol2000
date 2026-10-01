<script>
  /**
   * L'écart type, séance 5 : seulement de vraies données. L'âge des 20 180
   * répondant.e.s de l'Étude électorale canadienne 2025, sur un seul axe, du
   * début à la fin. Aucune valeur fictive, aucun écart type calculé sur les
   * points à l'écran : le nombre est celui que R calcule sur les 20 180.
   * (La séance 3 garde sa propre version, EcartType.svelte, avec un schéma.)
   *
   *   0  Six vraies personnes (les six premières lignes de la CES) sur l'axe
   *      de l'âge, et la moyenne des 20 180 en rouge.
   *   1  Une flèche va de la moyenne à chaque personne, avec sa distance en
   *      années : chaque personne est à une certaine distance de la moyenne.
   *   2  « À quelle distance se trouve une personne typique ? » Une règle
   *      rouge d'un écart type (17,5 ans) part de la moyenne : la distance
   *      typique, calculée par R sur les 20 180.
   *   3  Les six personnes s'effacent, la règle monte et se double de l'autre
   *      côté : la bande de 32,2 à 67,3 ans sur le vrai histogramme de l'âge.
   *      La partie des barres dans la bande passe au rouge. 6 personnes sur
   *      10 ont entre 33 et 67 ans (âges entiers dans la bande).
   *   4  Petit écart type : tout le monde se ressemble. Grand : ça varie.
   *
   * À dire, pas à écrire : l'écart type n'est pas exactement la moyenne des
   * distances (celle-ci est un peu plus petite sur les 20 180, voir
   * mean(abs(age - mean(age))) dans R), c'est une sorte de moyenne où les
   * grands écarts comptent un peu plus. D'où « typique » et non « en
   * moyenne » à l'écran.
   *
   * Sources, toutes générées par R :
   *   POP (moyenne, écart type, n) : src/lib/data/seance5.js, outils/seance5_data.R
   *   ECART (part dans la bande, ageMin, ageMax) : src/lib/data/seance3_ecart.js,
   *     outils/seance3_ecart.R
   *   QUIZ (cle 'age', tranches de 5 ans) et POIDS_LIGNES (âge des six
   *     premières lignes) : src/lib/data/seance5_normale.js, outils/seance5_normale.R
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance5.js';
  import { ECART } from '$lib/data/seance3_ecart.js';
  import { QUIZ, POIDS_LIGNES } from '$lib/data/seance5_normale.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN);

  // L'axe de l'âge, de 15 à 100 ans (les tranches de l'histogramme commencent à 15).
  const X = (v) => 80 + ((v - 15) / 85) * 840;
  const BASE = 390;
  const XM = X(POP.moyenne);
  const XR = X(POP.moyenne + POP.ecartType);
  const XL = X(POP.moyenne - POP.ecartType);

  // Les six premières personnes de la CES : leur âge et leur distance à la moyenne.
  const RAYON = 9;
  const GENS = POIDS_LIGNES.map((l, i) => {
    const xp = X(l.age);
    const sens = l.age < POP.moyenne ? -1 : 1;
    return {
      age: l.age,
      y: 104 + i * 40,
      xp,
      sens,
      long: Math.abs(xp - XM) - RAYON - 2,
      dist: Math.round(Math.abs(l.age - POP.moyenne))
    };
  });
  const REGLE = 350;
  const MONTEE = REGLE - 104;

  // L'histogramme de l'âge des 20 180.
  const AGE = QUIZ.find((q) => q.cle === 'age');
  const HAUT = 250;
  const MAX = Math.max(...AGE.effectifs);
  const BARRES = AGE.effectifs.map((c, j) => ({
    a: AGE.bornes[j],
    b: AGE.bornes[j + 1],
    h: (c / MAX) * HAUT
  }));

  const SUR10 = Math.round(ECART.partDansUnEt * 10);
  const MOY = f(POP.moyenne, 1);
  const ET = f(POP.ecartType, 1);
  const N = f(POP.n);

  const ARIA =
    `L’âge des ${N} répondant.e.s de l’Étude électorale canadienne 2025, moyenne de ${MOY} ans. ` +
    `Six de ces personnes sont à ${GENS.map((g) => g.dist).join(', ').replace(/, (\d+)$/, ' et $1')} ans de la moyenne. ` +
    `L’écart type, calculé par R sur les ${N} répondant.e.s, est de ${ET} ans${NN}: la distance typique à la moyenne. ` +
    `${SUR10} personnes sur 10 ont entre ${ECART.ageMin} et ${ECART.ageMax} ans. ` +
    `Petit écart type${NN}: tout le monde se ressemble. Grand écart type${NN}: ça varie beaucoup.`;
</script>

<div class="visuel ecart-type-ces" bind:this={hote}>
  <svg viewBox="0 0 1000 550" role="img" aria-label={ARIA}>
    <defs>
      <clipPath id="etc-bande">
        <rect x={XL} y={BASE - HAUT - 10} width={XR - XL} height={HAUT + 10} />
      </clipPath>
    </defs>

    <text x="80" y="26" class="etc-source">Étude électorale canadienne 2025 · âge</text>
    <text x="920" y="26" class="etc-angl" class:etc-vu={e >= 2}>dans R&#8239;: <tspan class="etc-angl-c">sd()</tspan></text>

    <!-- 3 : l'histogramme des 20 180, gris, puis rouge dans la bande. -->
    <g class="etc-histo" class:etc-vu={e >= 3}>
      {#each BARRES as b, j}
        <rect x={X(b.a) + 1} y={BASE - HAUT} width={X(b.b) - X(b.a) - 2} height={HAUT}
              class="etc-barre"
              style="transform: scaleY({e >= 3 ? b.h / HAUT : 0}); transition-delay: {e >= 3 ? 300 + j * 30 : 0}ms" />
      {/each}
      <g clip-path="url(#etc-bande)" class="etc-dedans">
        {#each BARRES as b}
          <rect x={X(b.a) + 1} y={BASE - b.h} width={X(b.b) - X(b.a) - 2} height={b.h} class="etc-barre-r" />
        {/each}
      </g>
      <g style="transform: translateX({XM}px)">
        <rect x={XL - XM} y={REGLE - MONTEE} width={XR - XL} height={BASE - REGLE + MONTEE} class="etc-bande" />
      </g>
    </g>

    <!-- L'axe de l'âge. -->
    <line x1={X(15)} y1={BASE} x2={X(100)} y2={BASE} class="etc-axe" />
    <text x="70" y={BASE + 6} class="etc-axe-t">âge</text>
    {#each [20, 30, 40, 50, 60, 70, 80, 90, 100] as t}
      <line x1={X(t)} y1={BASE} x2={X(t)} y2={BASE + 7} class="etc-axe" />
      <text x={X(t)} y={BASE + 28} class="etc-tick">{t}</text>
    {/each}

    <!-- La moyenne des 20 180. -->
    <line x1={XM} y1="72" x2={XM} y2={BASE} class="etc-moy" />
    <text x={XM} y="62" class="etc-moy-t">moyenne · {MOY} ans</text>

    <!-- 0 à 2 : six vraies personnes. -->
    <g class="etc-gens" class:etc-pale={e === 2} class:etc-parti={e >= 3}>
      {#each GENS as g, i}
        <g class="etc-fleche" class:etc-vu={e >= 1}
           style="transform: translate({XM + g.sens * 2}px, {g.y}px) scale({g.sens}, 1)">
          <path d="M 0 0 H {g.long}" pathLength="1" class="etc-trait" style="transition-delay: {e >= 1 ? i * 90 : 0}ms" />
          <path d="M {g.long - 8} -6 L {g.long} 0 L {g.long - 8} 6" class="etc-pointe" style="transition-delay: {e >= 1 ? i * 90 + 380 : 0}ms" />
        </g>
        <text x={XM + g.sens * 10} y={g.y - 12} class="etc-dist" class:etc-vu={e >= 1}
              style="text-anchor: {g.sens < 0 ? 'end' : 'start'}; transition-delay: {e >= 1 ? i * 90 + 450 : 0}ms">{g.dist} ans</text>
        <circle cx={g.xp} cy={g.y} r={RAYON} class="etc-pt" style="--d: {i * 70}ms" />
        <text x={g.xp + g.sens * 16} y={g.y + 6} class="etc-age"
              style="text-anchor: {g.sens < 0 ? 'end' : 'start'}">{g.age} ans</text>
      {/each}
    </g>

    <!-- 2 : la règle d'un écart type, à droite. 3 : elle monte et se double à gauche. -->
    <g class="etc-regle" class:etc-vu={e >= 2} style="transform: translateY({e >= 3 ? -MONTEE : 0}px)">
      <path d="M {XM} {REGLE} H {XR}" pathLength="1" class="etc-r-trait" />
      <path d="M {XR - 10} {REGLE - 8} L {XR} {REGLE} L {XR - 10} {REGLE + 8}" class="etc-r-pointe" />
      <text x={XR + 14} y={REGLE + 8} class="etc-r-nom" class:etc-cache={e >= 3}>écart type · {ET} ans</text>
      <g class="etc-gauche" class:etc-vu={e >= 3}>
        <path d="M {XM} {REGLE} H {XL}" pathLength="1" class="etc-r-trait" />
        <path d="M {XL + 10} {REGLE - 8} L {XL} {REGLE} L {XL + 10} {REGLE + 8}" class="etc-r-pointe" />
        <text x={(XL + XM) / 2} y={REGLE - 12} class="etc-r-demi">{ET} ans</text>
        <text x={(XR + XM) / 2} y={REGLE - 12} class="etc-r-demi">{ET} ans</text>
      </g>
    </g>

    <!-- Le texte, une idée par temps. -->
    <text x="80" y="466" class="etc-l" class:etc-vu={e === 0}>six des {N} répondant.e.s, avec leur âge</text>
    <text x="80" y="466" class="etc-l" class:etc-vu={e === 1} style="transition-delay: {e === 1 ? 900 : 0}ms">chaque personne est à une certaine distance de la moyenne</text>

    <g class="etc-l" class:etc-vu={e === 2}>
      <text x="80" y="466">À quelle distance se trouve une personne typique&#8239;?</text>
      <g class="etc-l" class:etc-vu={e === 2} style="transition-delay: {e === 2 ? 1300 : 0}ms">
        <text x="80" y="502" class="etc-reponse">L’écart type&#8239;: la distance typique à la moyenne.</text>
        <text x="80" y="532" class="etc-petit">calculé par R sur les {N} répondant.e.s</text>
      </g>
    </g>

    <g class="etc-l" class:etc-vu={e >= 3} style="transition-delay: {e === 3 ? 1400 : 0}ms">
      <text x="80" y="466" class="etc-phrase">{SUR10} personnes sur 10 ont entre {ECART.ageMin} et {ECART.ageMax} ans.</text>
    </g>
    <text x="80" y="500" class="etc-l etc-petit" class:etc-vu={e === 3} style="transition-delay: {e === 3 ? 1400 : 0}ms">à moins d’un écart type de la moyenne, sur les {N}</text>

    <g class="etc-l" class:etc-vu={e >= 4}>
      <text x="80" y="504" class="etc-fin">Petit écart type&#8239;: tout le monde se ressemble.</text>
      <text x="80" y="536" class="etc-fin">Grand écart type&#8239;: ça varie beaucoup.</text>
    </g>
  </svg>
</div>

<style>
  .ecart-type-ces { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .etc-source { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .etc-angl { font-size: 18px; text-anchor: end; fill: var(--dk-gris); opacity: 0; transition: opacity 0.3s; }
  .etc-angl.etc-vu { opacity: 1; }
  .etc-angl-c { font-weight: 600; fill: var(--dk-encre); }

  .etc-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .etc-axe-t { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .etc-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .etc-moy { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .etc-moy-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  /* Les six personnes. */
  .etc-gens { transition: opacity 0.4s; }
  .etc-gens.etc-pale .etc-fleche, .etc-gens.etc-pale .etc-dist { opacity: 0.45; }
  .etc-gens.etc-parti { opacity: 0; }
  .etc-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: etc-pop 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  @keyframes etc-pop { from { transform: scale(0); } to { transform: scale(1); } }
  .etc-age { font-size: 18px; fill: var(--dk-gris); }
  .etc-fleche { opacity: 0; transition: opacity 0.2s; }
  .etc-fleche.etc-vu { opacity: 1; }
  .etc-trait { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.5s ease-out; }
  .etc-fleche.etc-vu .etc-trait { stroke-dashoffset: 0; }
  .etc-pointe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; opacity: 0; transition: opacity 0.2s; }
  .etc-fleche.etc-vu .etc-pointe { opacity: 1; }
  .etc-dist { font-size: 20px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .etc-dist.etc-vu { opacity: 1; transition: opacity 0.3s; }

  /* La règle d'un écart type. */
  .etc-regle { opacity: 0; transition: opacity 0.2s, transform 0.9s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .etc-regle.etc-vu { opacity: 1; }
  .etc-r-trait { fill: none; stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.7s ease-out; }
  .etc-regle.etc-vu .etc-r-trait { stroke-dashoffset: 0; transition-delay: 0.5s; }
  .etc-r-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-linejoin: miter; opacity: 0; transition: opacity 0.2s; }
  .etc-regle.etc-vu .etc-r-pointe { opacity: 1; transition-delay: 1.1s; }
  .etc-r-nom { font-size: 22px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.2s; }
  .etc-regle.etc-vu .etc-r-nom { opacity: 1; transition: opacity 0.4s 1.1s; }
  .etc-regle.etc-vu .etc-r-nom.etc-cache { opacity: 0; transition: opacity 0.2s; }
  .etc-gauche { opacity: 0; transition: opacity 0.2s; }
  .etc-gauche.etc-vu { opacity: 1; transition: opacity 0.2s 0.8s; }
  /* La moitié gauche se trace à son tour : ces règles battent celles de la règle entière. */
  .etc-regle.etc-vu .etc-gauche .etc-r-trait { stroke-dashoffset: 1; transition-delay: 0s; }
  .etc-regle.etc-vu .etc-gauche.etc-vu .etc-r-trait { stroke-dashoffset: 0; transition-delay: 0.9s; }
  .etc-regle.etc-vu .etc-gauche .etc-r-pointe { opacity: 0; transition-delay: 0s; }
  .etc-regle.etc-vu .etc-gauche.etc-vu .etc-r-pointe { opacity: 1; transition-delay: 1.5s; }
  .etc-r-demi { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  /* L'histogramme et la bande. */
  .etc-histo { opacity: 0; transition: opacity 0.2s; }
  .etc-histo.etc-vu { opacity: 1; }
  .etc-barre { fill: var(--dk-gris-2); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.6s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .etc-barre-r { fill: var(--dk-accent); }
  .etc-dedans { opacity: 0; transition: opacity 0.2s; }
  .etc-histo.etc-vu .etc-dedans { opacity: 1; transition: opacity 0.5s 1.2s; }
  .etc-bande { fill: var(--dk-accent); fill-opacity: 0.08; stroke: var(--dk-accent); stroke-width: 2; transform-box: fill-box; transform-origin: center; transform: scaleX(0); transition: transform 0.8s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .etc-histo.etc-vu .etc-bande { transform: scaleX(1); transition-delay: 0.9s; }

  /* Le texte. */
  .etc-l { font-size: 24px; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .etc-l.etc-vu { opacity: 1; transition: opacity 0.4s; }
  .etc-reponse { font-weight: 600; fill: var(--dk-accent); }
  .etc-petit { font-size: 18px; fill: var(--dk-gris); }
  .etc-phrase { font-weight: 600; }
  .etc-fin { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .etc-pt { animation: none; }
    .etc-gens, .etc-fleche, .etc-trait, .etc-pointe, .etc-dist, .etc-dist.etc-vu,
    .etc-regle, .etc-r-trait, .etc-r-pointe, .etc-r-nom, .etc-gauche, .etc-gauche.etc-vu,
    .etc-histo, .etc-barre, .etc-dedans, .etc-bande, .etc-angl, .etc-l, .etc-l.etc-vu,
    .etc-regle.etc-vu .etc-r-trait, .etc-regle.etc-vu .etc-r-pointe, .etc-regle.etc-vu .etc-r-nom,
    .etc-regle.etc-vu .etc-r-nom.etc-cache,
    .etc-regle.etc-vu .etc-gauche .etc-r-trait, .etc-regle.etc-vu .etc-gauche.etc-vu .etc-r-trait,
    .etc-regle.etc-vu .etc-gauche .etc-r-pointe, .etc-regle.etc-vu .etc-gauche.etc-vu .etc-r-pointe,
    .etc-histo.etc-vu .etc-dedans, .etc-histo.etc-vu .etc-bande { transition: none; }
  }
</style>
