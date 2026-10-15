<script>
  /**
   * « La vraie droite », séance 7. Le dispositif de la séance 5 : les
   * 20 180 répondant.e.s de la CES 2025 sont la population d'exercice. On
   * peut donc calculer la VRAIE droite, ce qu'on ne peut jamais faire dans
   * la vraie vie. Puis notre sondage de 1 000, et sa droite à lui.
   *
   * X = scolarite (5 niveaux), Y = interet (le curseur de 0 à 10, divisé
   * par 10), tous deux de 0 à 1 (VARS). La population se dessine en « dot
   * plot » : l'intérêt moyen de chaque niveau, un point rouge d'autant plus
   * gros qu'il y a de monde (POP.moyennes), sur des ronds pâles qui
   * comptent les gens de chaque case (POP.cases, aire proportionnelle).
   * Notre sondage se dessine en colonnes de points (NOTRE.points, `jx` et
   * `jy` étalés par R pour le dessin seulement).
   *
   *   0  Les ronds pâles et les cinq moyennes (les POP.n_modele personnes
   *      qui ont répondu aux deux questions).
   *   1  La vraie droite, en pointillé (comme « la vraie réponse » de la
   *      séance 5) : pente POP.b1 (+0,17), connue exactement ici. Elle
   *      passe presque pile par les cinq moyennes.
   *   2  La population pâlit. Notre sondage (les NOTRE.n_modele cas
   *      complets parmi 1 000 tiré.e.s) et sa droite, en encre : pente
   *      NOTRE.coefs[1].b (+0,20). Proche de la vraie, pas pareille.
   *
   * Sources : VARS, POP et NOTRE dans src/lib/data/seance7.js
   * (outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, POP, NOTRE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');
  const sg = (v, d) => (v > 0 ? '+' : '') + f(v, d);

  // Libellés courts, tirés du codebook (VARS) : deux lignes par niveau de X.
  const min1 = (s) => s.charAt(0).toLowerCase() + s.slice(1);
  const deuxLignes = (s) => {
    s = min1(s);
    if (s.includes(', ')) { const [a, b] = s.split(', '); return [a + ',', b]; }
    const i = s.indexOf(' ');
    return i < 0 ? [s, ''] : [s.slice(0, i), s.slice(i + 1)];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));
  const BORNES = VARS.y.bornes.map((b) => deuxLignes(b.replace(/'/g, '’')));

  // Le graphique : X et Y de 0 à 1.
  const X0 = 200, X1 = 740, Y0 = 440, Y1 = 90;
  const X = (v) => X0 + v * (X1 - X0);
  const Y = (v) => Y0 - v * (Y0 - Y1);

  // Les ronds pâles (aire proportionnelle au nombre de personnes) et les moyennes.
  const MAXC = Math.max(...POP.cases.map((c) => c.n));
  const CASES = POP.cases.filter((c) => c.n > 0).map((c) => ({ ...c, r: Math.sqrt(c.n / MAXC) * 16 }));
  const MAXM = Math.max(...POP.moyennes.map((m) => m.n));
  const MOY = POP.moyennes.map((m, i) => ({ ...m, r: 6 + Math.sqrt(m.n / MAXM) * 9, d: 300 + i * 90 }));

  const b0 = POP.b0, b1 = POP.b1;
  const n0 = NOTRE.coefs[0].b, n1 = NOTRE.coefs[1].b;
  const PTS = NOTRE.points;

  const ARIA =
    `Les ${f(POP.n)} répondant.e.s de la CES 2025 : l’intérêt moyen pour la politique à chacun des cinq niveaux de scolarité, de 0 à 1. ` +
    `La vraie droite monte de ${f(b1, 2)} du secondaire non terminé à la maîtrise ou au doctorat. On la connaît exactement ici, jamais dans la vraie vie. ` +
    `Notre sondage de ${f(NOTRE.n)} personnes donne une pente de ${f(n1, 2)}${NN}: proche, pas pareille.`;
</script>

<div class="visuel d7-vraie" bind:this={hote}>
  <svg viewBox="0 0 1000 590" role="img" aria-label={ARIA}>
    <text x={X1 + 30} y="26" class="vd-source vd-fin">CES 2025 · les {f(POP.n)} répondant.e.s = la population</text>

    <!-- Les axes et les niveaux du codebook. -->
    <line x1={X0 - 50} y1={Y0 + 30} x2={X1 + 30} y2={Y0 + 30} class="vd-axe" />
    <line x1={X0 - 50} y1={Y0 + 30} x2={X0 - 50} y2={Y1 - 20} class="vd-axe" />
    {#each NX as t}
      <text x={X(t.v)} y={Y0 + 56} class="vd-val">{f(t.v, t.v % 1 ? 2 : 0)}</text>
      <text x={X(t.v)} y={Y0 + 78} class="vd-niv">{t.l[0]}</text>
      <text x={X(t.v)} y={Y0 + 96} class="vd-niv">{t.l[1]}</text>
    {/each}
    {#each [0, 0.5, 1] as t}
      <text x={X0 - 62} y={Y(t) + 6} class="vd-val vd-fin">{f(t, t % 1 ? 1 : 0)}</text>
    {/each}
    <text x={X0 - 100} y={Y(1) - 2} class="vd-niv vd-fin">{BORNES[1][0]}</text>
    <text x={X0 - 100} y={Y(1) + 16} class="vd-niv vd-fin">{BORNES[1][1]}</text>
    <text x={X0 - 100} y={Y(0) - 2} class="vd-niv vd-fin">{BORNES[0][0]}</text>
    <text x={X0 - 100} y={Y(0) + 16} class="vd-niv vd-fin">{BORNES[0][1]}</text>
    <text x={X1 + 30} y={Y0 + 124} class="vd-titre vd-fin">{VARS.x.nom}</text>
    <text x={X0 - 50} y={Y1 - 32} class="vd-titre vd-debut">{VARS.y.nom}</text>

    <!-- 0 : la population, ronds pâles et moyennes. -->
    <g class="vd-pop" class:vd-pale={e >= 2}>
      {#each CASES as c}
        <circle cx={X(c.x)} cy={Y(c.y)} r={c.r} class="vd-case" />
      {/each}
      {#each MOY as m}
        <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="vd-moy" style="animation-delay: {m.d}ms" />
      {/each}
    </g>

    <!-- 2 : notre sondage, en colonnes de points. -->
    <g class="vd-etape" class:vd-vu={e >= 2}>
      {#each PTS as p}
        <circle cx={X(p.jx)} cy={Y(p.jy)} r="2.4" class="vd-pt" />
      {/each}
    </g>

    <!-- 1 : la vraie droite (un halo clair la détache des points). -->
    <g class="vd-vraie-g" class:vd-vu={e >= 1}>
      <line x1={X(0)} y1={Y(b0)} x2={X(1)} y2={Y(b0 + b1)} class="vd-halo" />
      <line x1={X(0)} y1={Y(b0)} x2={X(1)} y2={Y(b0 + b1)} class="vd-vraie" />
    </g>

    <!-- 2 : la droite de notre sondage, par-dessus la vraie. -->
    <line x1={X(0)} y1={Y(n0)} x2={X(1)} y2={Y(n0 + n1)} class="vd-halo vd-halo-n" class:vd-vu={e >= 2} />
    <line x1={X(0)} y1={Y(n0)} x2={X(1)} y2={Y(n0 + n1)} pathLength="1"
          class="vd-notre" class:vd-trace={e >= 2} />

    <!-- Les étiquettes, à droite. -->
    <g class="vd-etape" class:vd-vu={e === 0}>
      <circle cx="800" cy="186" r="11" class="vd-moy vd-leg" />
      <text x="822" y="193" class="vd-l">l’intérêt moyen</text>
      <text x="822" y="219" class="vd-l">d’un niveau</text>
      <circle cx="800" cy="262" r="11" class="vd-case" />
      <text x="822" y="269" class="vd-g">les gens d’une case</text>
      <text x="790" y="320" class="vd-g">{f(POP.n_modele)} ont répondu</text>
      <text x="790" y="344" class="vd-g">aux deux questions</text>
    </g>
    <g class="vd-etape" class:vd-vu={e >= 1}>
      <line x1="790" y1="110" x2="850" y2="110" class="vd-vraie" />
      <text x="790" y="148" class="vd-l">la vraie droite</text>
      <text x="790" y="196" class="vd-gros">{sg(b1, 2)}</text>
      <text x="790" y="224" class="vd-g">connue ici,</text>
      <text x="790" y="248" class="vd-g">jamais dans la vraie vie</text>
    </g>
    <g class="vd-etape vd-tard" class:vd-vu={e >= 2}>
      <line x1="790" y1="310" x2="850" y2="310" class="vd-notre vd-leg" />
      <text x="790" y="348" class="vd-l">notre sondage</text>
      <text x="790" y="396" class="vd-gros">{sg(n1, 2)}</text>
      <text x="790" y="424" class="vd-g">{f(NOTRE.n)} parmi les {f(POP.n)}</text>
      <text x="790" y="448" class="vd-g">proche, pas pareille</text>
    </g>
  </svg>
</div>

<style>
  .d7-vraie { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .vd-source { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .vd-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .vd-val { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .vd-niv { font-size: 14.5px; text-anchor: middle; fill: var(--dk-gris); }
  .vd-titre { font-size: 18px; font-weight: 600; fill: var(--dk-gris); }
  .vd-fin { text-anchor: end; }
  .vd-debut { text-anchor: start; }

  .vd-pop { transition: opacity 0.5s; }
  .vd-pop.vd-pale { opacity: 0.15; }
  .vd-case { fill: var(--dk-gris-2); fill-opacity: 0.28; }
  .vd-moy { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; transform-box: fill-box; transform-origin: center; animation: vd-pop 0.45s ease-out both; }
  .vd-moy.vd-leg { animation: none; }
  @keyframes vd-pop { from { transform: scale(0); } to { transform: scale(1); } }

  .vd-pt { fill: var(--dk-gris); fill-opacity: 0.55; }

  .vd-vraie-g { opacity: 0; transition: opacity 0.5s; }
  .vd-vraie-g.vd-vu { opacity: 1; }
  .vd-halo { stroke: var(--dk-fond); stroke-width: 11; }
  .vd-vraie { stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 14 9; }
  .vd-halo-n { stroke-width: 9; opacity: 0; transition: opacity 0.3s 0.5s; }
  .vd-halo-n.vd-vu { opacity: 1; }
  .vd-notre { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out 0.5s; }
  .vd-notre.vd-trace { stroke-dashoffset: 0; }
  .vd-notre.vd-leg { stroke-dasharray: none; stroke-dashoffset: 0; transition: none; }

  .vd-l { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .vd-g { font-size: 18px; fill: var(--dk-gris); }
  .vd-gros { font-size: 40px; font-weight: 700; fill: var(--dk-encre); }

  .vd-etape { opacity: 0; transition: opacity 0.2s; }
  .vd-etape.vd-vu { opacity: 1; transition: opacity 0.4s; }
  .vd-etape.vd-tard.vd-vu { transition: opacity 0.4s 1.2s; }

  @media (prefers-reduced-motion: reduce) {
    .vd-moy { animation: none; }
    .vd-pop, .vd-vraie-g, .vd-halo-n, .vd-notre, .vd-etape, .vd-etape.vd-vu, .vd-etape.vd-tard.vd-vu { transition: none; }
  }
</style>
