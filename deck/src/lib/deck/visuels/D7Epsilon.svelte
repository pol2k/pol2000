<script>
  /**
   * « Ce qui reste : ε », séance 7. Pourquoi les sondages de gens déjà
   * intéressés ratent toujours du même côté ? Par ε, ce que la droite ne
   * prédit pas : la distance verticale entre une personne et la vraie
   * droite. Ici, la sélection se fait sur Y (l'intérêt lui-même).
   *
   *   0  L'équation, ε en rouge (« tout le reste »). Dessous, la population :
   *      ronds pâles (POP.cases), l'intérêt moyen de chaque niveau en
   *      anneaux d'encre (POP.moyennes, taille selon le nombre de gens), et
   *      la vraie droite (pointillé). Sur les 20 180, ε n'a aucun lien avec
   *      la scolarité : c'est ainsi que R choisit la droite.
   *   1  La coupe : on ne garde que les gens à 6 sur 10 ou plus
   *      (INTERESSES.seuil). Les ronds sous la coupe pâlissent. En haut de
   *      chaque colonne, la part des gens gardée (INTERESSES.moyennes[i].
   *      part_gardee) : 56 % au secondaire non terminé, 82 % à la maîtrise
   *      ou au doctorat. On enlève plus de monde à gauche.
   *   2  L'intérêt moyen des gens gardés, en rouge (INTERESSES.moyennes,
   *      les mêmes valeurs que MILLE.moyennes_facile), avec un trait de la
   *      vraie droite jusqu'à leur moyenne : leur ε moyen. Il est positif
   *      partout (on n'a gardé que des gens intéressés), mais beaucoup plus
   *      grand à gauche (+0,21) qu'à droite (+0,09) : les peu scolarisé.e.s
   *      qu'on garde sont celles et ceux qui sont inhabituellement
   *      intéressé.e.s pour leur niveau. Leur ε est lié à la scolarité
   *      (corrélation INTERESSES.correlation, −0,22).
   *   3  La droite des gens gardés (INTERESSES.b0, INTERESSES.b1) se trace :
   *      presque plate, +0,05 au lieu de +0,17. C'est la cloche rouge de la
   *      diapo précédente (MILLE.moyenne_facile).
   *   4  La leçon : quand ε bouge avec x, la pente se trompe. Puis la
   *      question qui mène à la section suivante : qu'est-ce qui se cache
   *      dans ε ?
   *
   * Sources : VARS, POP (src/lib/data/seance7.js, outils/seance7_data.R);
   * INTERESSES (src/lib/data/seance7_d.js, outils/seance7_d.R).
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, POP } from '$lib/data/seance7.js';
  import { INTERESSES } from '$lib/data/seance7_d.js';
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

  // Le graphique : scolarité et intérêt de 0 à 1.
  const X0 = 160, X1 = 660, Y0 = 470, Y1 = 140;
  const X = (v) => X0 + v * (X1 - X0);
  const Y = (v) => Y0 - v * (Y0 - Y1);
  const vraie = (x) => POP.b0 + POP.b1 * x;
  const gardes = (x) => INTERESSES.b0 + INTERESSES.b1 * x;
  const SEUIL = INTERESSES.seuil;
  const YC = Y(SEUIL - 0.05);

  const MAXC = Math.max(...POP.cases.map((c) => c.n));
  const CASES = POP.cases.filter((c) => c.n > 0).map((c) => ({ ...c, r: Math.sqrt(c.n / MAXC) * 14, garde: c.y >= SEUIL - 1e-9 }));
  const taille = (n, max) => 6 + Math.sqrt(n / max) * 8;
  const MAXP = Math.max(...POP.moyennes.map((m) => m.n));
  const GRIS = POP.moyennes.map((m) => ({ ...m, r: taille(m.n, MAXP) }));
  const MAXI = Math.max(...INTERESSES.moyennes.map((m) => m.n));
  const ROUGE = INTERESSES.moyennes.map((m, i) => ({ ...m, r: taille(m.n, MAXI), d: i * 90 }));
  const PREMIER = ROUGE[0], DERNIER = ROUGE[ROUGE.length - 1];

  const ARIA =
    `${VARS.y.nom} = β0 + β1 × ${VARS.x.nom} + ε. ε, c’est tout le reste${NN}: la distance entre une personne et la vraie droite. ` +
    `On ne garde que les gens déjà intéressés, 6 sur 10 ou plus. On enlève plus de monde chez les peu scolarisé.e.s : ` +
    `on en garde ${f(PREMIER.part_gardee * 100)} %, contre ${f(DERNIER.part_gardee * 100)} % à la maîtrise ou au doctorat. ` +
    `Les peu scolarisé.e.s qui restent sont inhabituellement intéressé.e.s : leur ε moyen est de ${sg(PREMIER.epsilon, 2)}, contre ${sg(DERNIER.epsilon, 2)} à droite. ` +
    `Leur droite est presque plate, ${sg(INTERESSES.b1, 2)} au lieu de ${sg(POP.b1, 2)}. Quand ε bouge avec x, la pente se trompe.`;
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
    {#each [0, 0.5, 1] as t}
      <text x={X0 - 52} y={Y(t) + 6} class="ep-tick ep-fin">{f(t, t % 1 ? 1 : 0)}</text>
    {/each}
    <text x={X1 + 30} y={Y0 + 116} class="ep-tick ep-fin">{VARS.x.nom}</text>
    <text x={X0 - 40} y={Y1 - 50} class="ep-tick ep-debut">{VARS.y.nom}</text>

    <!-- 0 : la population. 1 : ce qui est sous la coupe pâlit. -->
    {#each CASES as c}
      <circle cx={X(c.x)} cy={Y(c.y)} r={c.r} class="ep-case" class:ep-coupe={e >= 1 && !c.garde} />
    {/each}
    {#each GRIS as m}
      <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="ep-pop" />
    {/each}
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(1)} y2={Y(vraie(1))} class="ep-halo" />
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(1)} y2={Y(vraie(1))} class="ep-vrai" />

    <!-- 1 : la coupe, et la part gardée de chaque niveau. -->
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <line x1={X0 - 40} y1={YC} x2={X1 + 30} y2={YC} class="ep-seuil" />
      <text x={X0 - 52} y={Y1 - 22} class="ep-garde ep-fin">gardé.e.s</text>
      {#each ROUGE as m}
        <text x={X(m.x)} y={Y1 - 22} class="ep-garde">{f(m.part_gardee * 100)}{NN}%</text>
      {/each}
    </g>

    <!-- 2 : les gens gardés, et leur ε moyen. -->
    <g class="ep-etape" class:ep-vu={e >= 2}>
      {#each ROUGE as m}
        <line x1={X(m.x)} y1={Y(vraie(m.x))} x2={X(m.x)} y2={Y(m.moyenne)} class="ep-eps-t" style="transition-delay: {e >= 2 ? m.d : 0}ms" />
        <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="ep-rouge" style="transition-delay: {e >= 2 ? m.d + 150 : 0}ms" />
      {/each}
    </g>

    <!-- 3 : leur droite. -->
    <line x1={X(0)} y1={Y(gardes(0))} x2={X(1)} y2={Y(gardes(1))} pathLength="1" class="ep-gardes" class:ep-trace={e >= 3} />

    <!-- Les étiquettes, à droite. -->
    <g>
      <line x1="720" y1="162" x2="770" y2="162" class="ep-vrai" />
      <text x="784" y="169" class="ep-l">la vraie droite</text>
      <circle cx="745" cy="202" r="10" class="ep-pop" />
      <text x="784" y="209" class="ep-g">les {f(POP.n)}</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <line x1="720" y1="242" x2="770" y2="242" class="ep-seuil" />
      <text x="784" y="249" class="ep-g ep-r">on garde 6 sur 10</text>
      <text x="784" y="273" class="ep-g ep-r">ou plus</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 2}>
      <circle cx="745" cy="314" r="10" class="ep-rouge ep-leg" />
      <text x="784" y="321" class="ep-l ep-r">les gens gardés</text>
      <text x="720" y="360" class="ep-g">ε à gauche{NN}: <tspan class="ep-fort">{sg(PREMIER.epsilon, 2)}</tspan></text>
      <text x="720" y="386" class="ep-g">ε à droite{NN}: <tspan class="ep-fort">{sg(DERNIER.epsilon, 2)}</tspan></text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 3}>
      <text x="720" y="432" class="ep-g">leur pente</text>
      <text x="720" y="476" class="ep-gros">{sg(INTERESSES.b1, 2)}</text>
      <text x="720" y="504" class="ep-g">au lieu de {sg(POP.b1, 2)}</text>
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

  .ep-case { fill: var(--dk-gris-2); fill-opacity: 0.3; transition: fill-opacity 0.6s; }
  .ep-case.ep-coupe { fill-opacity: 0.06; }
  .ep-pop { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .ep-halo { stroke: var(--dk-fond); stroke-width: 9; }
  .ep-vrai { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 12 8; }
  .ep-seuil { stroke: var(--dk-accent); stroke-width: 2.5; stroke-dasharray: 4 5; }
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
  .ep-gros { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .ep-lecon { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ep-question { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .ep-etape { opacity: 0; transition: opacity 0.2s; }
  .ep-etape.ep-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .ep-case, .ep-etape, .ep-etape.ep-vu, .ep-etape .ep-rouge, .ep-etape .ep-eps-t, .ep-gardes { transition: none; }
  }
</style>
