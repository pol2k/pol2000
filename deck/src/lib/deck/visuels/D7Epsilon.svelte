<script>
  /**
   * « Ce qui reste : ε », séance 7. Pourquoi les sondages d'électeurs et
   * électrices conservateurs ratent toujours du même côté ? Par ε, ce que la
   * droite ne prédit pas : la distance verticale entre une personne et la
   * vraie droite. Ici, on choisit les gens selon une variable (le vote
   * conservateur) liée à la fois à X et à Y.
   *
   *   0  L'équation, ε en rouge (« tout le reste »). Dessous, la population :
   *      l'intérêt moyen de chaque niveau en anneaux d'encre (POP.moyennes,
   *      taille selon le nombre de gens) et la vraie droite (pointillé). Sur
   *      les 20 180, ε n'a aucun lien avec la scolarité : c'est ainsi que R
   *      choisit la droite.
   *   1  Qui garde-t-on ? En haut de chaque colonne, la part de conservateurs
   *      (CONSERVATEURS.moyennes[i].part) : 29 % au secondaire non terminé,
   *      18 % à la maîtrise ou au doctorat (lien avec X). Et ils
   *      s'intéressent plus à la politique que les autres
   *      (CONSERVATEURS.interet_moyen, 0,70 contre 0,66 : lien avec Y).
   *   2  L'intérêt moyen des conservateurs, en rouge (CONSERVATEURS.moyennes,
   *      les mêmes valeurs que MILLE.moyennes_facile), avec un trait de la
   *      vraie droite jusqu'à leur moyenne : leur ε moyen. Positif partout,
   *      mais plus grand à gauche (+0,07) qu'à droite (+0,02) : les
   *      conservateurs peu scolarisés sont inhabituellement intéressés pour
   *      leur niveau. Leur ε baisse avec la scolarité.
   *   3  La droite des conservateurs (CONSERVATEURS.b0, CONSERVATEURS.b1) se
   *      trace : plus plate, +0,12 au lieu de +0,17. C'est la cloche rouge
   *      de la diapo précédente (MILLE.moyenne_facile).
   *   4  La leçon : quand ε bouge avec x, la pente se trompe. Puis la
   *      question qui mène à la section suivante : qu'est-ce qui se cache
   *      dans ε ?
   *
   * L'axe vertical est un zoom (de 0,5 à 0,85, graduations écrites) : les
   * écarts sont de 0,02 à 0,07 sur une échelle de 0 à 1.
   *
   * Sources : VARS, POP (src/lib/data/seance7.js, outils/seance7_data.R);
   * CONSERVATEURS (src/lib/data/seance7_d.js, outils/seance7_d.R).
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, POP } from '$lib/data/seance7.js';
  import { CONSERVATEURS } from '$lib/data/seance7_d.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');
  const sg = (v, d) => (v > 0 ? '+' : '') + f(v, d);
  const min1 = (s) => s.charAt(0).toLowerCase() + s.slice(1);
  const deuxLignes = (s) => {
    s = min1(s);
    if (s.includes(', ')) { const [a, b] = s.split(', '); return [a + ',', b]; }
    const i = s.indexOf(' ');
    return i < 0 ? [s, ''] : [s.slice(0, i), s.slice(i + 1)];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));

  // Le graphique : scolarité de 0 à 1, intérêt moyen de 0,5 à 0,85 (zoom).
  const X0 = 160, X1 = 660, Y0 = 470, Y1 = 150, N0 = 0.5, N1 = 0.85;
  const X = (v) => X0 + v * (X1 - X0);
  const Y = (v) => Y0 - ((v - N0) / (N1 - N0)) * (Y0 - Y1);
  const vraie = (x) => POP.b0 + POP.b1 * x;
  const C = CONSERVATEURS;
  const leurs = (x) => C.b0 + C.b1 * x;

  const taille = (n, max) => 6 + Math.sqrt(n / max) * 8;
  const MAXP = Math.max(...POP.moyennes.map((m) => m.n));
  const GRIS = POP.moyennes.map((m) => ({ ...m, r: taille(m.n, MAXP) }));
  const MAXC = Math.max(...C.moyennes.map((m) => m.n));
  const ROUGE = C.moyennes.map((m, i) => ({ ...m, r: taille(m.n, MAXC), d: i * 90 }));
  const PREMIER = ROUGE[0], DERNIER = ROUGE[ROUGE.length - 1];

  const ARIA =
    `${VARS.y.nom} = β0 + β1 × ${VARS.x.nom} + ε. ε, c’est tout le reste${NN}: la distance entre une personne et la vraie droite. ` +
    `On ne garde que les électeurs conservateurs. Ils sont plus nombreux chez les moins scolarisé.e.s (${f(PREMIER.part * 100)} % contre ${f(DERNIER.part * 100)} %) ` +
    `et s’intéressent plus à la politique (${f(C.interet_moyen.conservateurs, 2)} contre ${f(C.interet_moyen.autres, 2)}). ` +
    `Leur ε moyen est de ${sg(PREMIER.epsilon, 2)} à gauche et ${sg(DERNIER.epsilon, 2)} à droite. ` +
    `Leur droite est plus plate, ${sg(C.b1, 2)} au lieu de ${sg(POP.b1, 2)}. Quand ε bouge avec x, la pente se trompe.`;
</script>

<div class="visuel d7-epsilon" bind:this={hote}>
  <svg viewBox="0 0 1000 672" role="img" aria-label={ARIA}>
    <!-- L'équation. -->
    <text x="500" y="48" class="ep-eq">{VARS.y.nom} = β0 + β1 × {VARS.x.nom} + <tspan class="ep-eps">ε</tspan></text>
    <text x="815" y="86" class="ep-reste">tout le reste ↑</text>

    <!-- Les axes. -->
    <line x1={X0 - 40} y1={Y0 + 24} x2={X1 + 30} y2={Y0 + 24} class="ep-axe" />
    <line x1={X0 - 40} y1={Y0 + 24} x2={X0 - 40} y2={Y1 - 30} class="ep-axe" />
    {#each NX as t}
      <text x={X(t.v)} y={Y0 + 50} class="ep-val">{f(t.v, t.v % 1 ? 2 : 0)}</text>
      <text x={X(t.v)} y={Y0 + 72} class="ep-niv">{t.l[0]}</text>
      <text x={X(t.v)} y={Y0 + 90} class="ep-niv">{t.l[1]}</text>
    {/each}
    {#each [0.5, 0.6, 0.7, 0.8] as t}
      <text x={X0 - 52} y={Y(t) + 6} class="ep-tick ep-fin">{f(t, 1)}</text>
    {/each}
    <text x={X1 + 30} y={Y0 + 116} class="ep-tick ep-fin">{VARS.x.nom}</text>
    <text x={X0 - 40} y={Y1 - 50} class="ep-tick ep-debut">{VARS.y.nom} (moyenne)</text>

    <!-- 0 : la population, niveau par niveau, et la vraie droite. -->
    {#each GRIS as m}
      <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="ep-pop" />
    {/each}
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(1)} y2={Y(vraie(1))} class="ep-halo" />
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(1)} y2={Y(vraie(1))} class="ep-vrai" />

    <!-- 1 : la part de conservateurs à chaque niveau. -->
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <text x={X0 - 52} y={Y1 - 22} class="ep-garde ep-fin">conservateurs</text>
      {#each ROUGE as m}
        <text x={X(m.x)} y={Y1 - 22} class="ep-garde">{f(m.part * 100)}{NN}%</text>
      {/each}
    </g>

    <!-- 2 : les conservateurs, et leur ε moyen. -->
    <g class="ep-etape" class:ep-vu={e >= 2}>
      {#each ROUGE as m}
        <line x1={X(m.x)} y1={Y(vraie(m.x))} x2={X(m.x)} y2={Y(m.moyenne)} class="ep-eps-t" style="transition-delay: {e >= 2 ? m.d : 0}ms" />
        <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="ep-rouge" style="transition-delay: {e >= 2 ? m.d + 150 : 0}ms" />
      {/each}
    </g>

    <!-- 3 : leur droite. -->
    <line x1={X(0)} y1={Y(leurs(0))} x2={X(1)} y2={Y(leurs(1))} pathLength="1" class="ep-gardes" class:ep-trace={e >= 3} />

    <!-- Les étiquettes, à droite. -->
    <g>
      <line x1="720" y1="162" x2="770" y2="162" class="ep-vrai" />
      <text x="784" y="169" class="ep-l">la vraie droite</text>
      <circle cx="745" cy="202" r="10" class="ep-pop" />
      <text x="784" y="209" class="ep-g">les {f(POP.n)}</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <text x="720" y="252" class="ep-g">intérêt moyen{NN}:</text>
      <text x="720" y="278" class="ep-g">conservateurs <tspan class="ep-fort">{f(C.interet_moyen.conservateurs, 2)}</tspan></text>
      <text x="720" y="302" class="ep-g">les autres <tspan class="ep-fort ep-encre">{f(C.interet_moyen.autres, 2)}</tspan></text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 2}>
      <circle cx="745" cy="344" r="10" class="ep-rouge ep-leg" />
      <text x="784" y="351" class="ep-l ep-r">les conservateurs</text>
      <text x="720" y="388" class="ep-g">ε à gauche{NN}: <tspan class="ep-fort">{sg(PREMIER.epsilon, 2)}</tspan></text>
      <text x="720" y="414" class="ep-g">ε à droite{NN}: <tspan class="ep-fort">{sg(DERNIER.epsilon, 2)}</tspan></text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 3}>
      <text x="720" y="458" class="ep-g">leur pente</text>
      <text x="720" y="502" class="ep-gros">{sg(C.b1, 2)}</text>
      <text x="720" y="530" class="ep-g">au lieu de {sg(POP.b1, 2)}</text>
    </g>

    <!-- 4 : la leçon, et la question. -->
    <g class="ep-etape" class:ep-vu={e >= 4}>
      <text x="500" y="630" class="ep-lecon">Quand ε bouge avec x, la pente se trompe.</text>
      <text x="500" y="664" class="ep-question">Qu’est-ce qui se cache dans ε{NN}?</text>
    </g>
  </svg>
</div>

<style>
  .d7-epsilon { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  text { font-family: var(--dk-mono); }

  .ep-eq { font-size: 32px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ep-eps { fill: var(--dk-accent); font-size: 38px; font-weight: 700; }
  .ep-reste { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }

  .ep-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .ep-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ep-val { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ep-niv { font-size: 14.5px; text-anchor: middle; fill: var(--dk-gris); }
  .ep-fin { text-anchor: end; }
  .ep-debut { text-anchor: start; }

  .ep-pop { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .ep-halo { stroke: var(--dk-fond); stroke-width: 9; }
  .ep-vrai { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 12 8; }
  .ep-garde { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ep-garde.ep-fin { text-anchor: end; }

  .ep-rouge { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; }
  .ep-etape .ep-rouge, .ep-etape .ep-eps-t { opacity: 0; transition: opacity 0.3s; }
  .ep-etape.ep-vu .ep-rouge, .ep-etape.ep-vu .ep-eps-t { opacity: 1; }
  .ep-eps-t { stroke: var(--dk-accent); stroke-width: 4; }
  .ep-gardes { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .ep-gardes.ep-trace { stroke-dashoffset: 0; }

  .ep-l { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .ep-r { fill: var(--dk-accent); }
  .ep-g { font-size: 19px; fill: var(--dk-gris); }
  .ep-fort { font-weight: 700; fill: var(--dk-accent); }
  .ep-fort.ep-encre { fill: var(--dk-encre); }
  .ep-gros { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .ep-lecon { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ep-question { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .ep-etape { opacity: 0; transition: opacity 0.2s; }
  .ep-etape.ep-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .ep-etape, .ep-etape.ep-vu, .ep-etape .ep-rouge, .ep-etape .ep-eps-t, .ep-gardes { transition: none; }
  }
</style>
