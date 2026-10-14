<script>
  /**
   * « La vraie droite », séance 7. Le dispositif de la séance 5 : les
   * 20 180 répondant.e.s de la CES 2025 sont la population d'exercice. On
   * peut donc calculer la VRAIE droite, ce qu'on ne peut jamais faire dans
   * la vraie vie. Puis notre sondage de 1 000, et sa droite à lui.
   *
   *   0  La population en damier : à chaque cran de gauche_droite (0 à 10),
   *      un carré par tranche de 10 points de la note de Carney, d'autant
   *      plus gros qu'il y a de monde dedans (aire proportionnelle au
   *      nombre de personnes). GRILLE.comptes, les 15 993 personnes qui ont
   *      répondu aux deux questions.
   *   1  La vraie droite, en pointillé (comme « la vraie réponse » de la
   *      séance 5) : pente POP.b1 (−5,27), connue exactement ici.
   *   2  Le damier pâlit. Notre sondage (NOTRE.points, les 783 cas
   *      complets parmi 1 000 tiré.e.s, étalés de ± 0,3 cran pour le dessin
   *      seulement) et sa droite, en encre : pente NOTRE.coefs[1].b (−5,05).
   *      Proche de la vraie, pas pareille.
   *
   * Sources : GRILLE dans src/lib/data/seance7_d.js (outils/seance7_d.R);
   * POP et NOTRE dans src/lib/data/seance7.js (outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, NOTRE } from '$lib/data/seance7.js';
  import { GRILLE } from '$lib/data/seance7_d.js';
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

  // Le graphique : gauche_droite de 0 à 10, la note de 0 à 100.
  const X0 = 120, X1 = 760, Y0 = 470, Y1 = 70;
  const X = (v) => X0 + (v / 10) * (X1 - X0);
  const Y = (v) => Y0 - (v / 100) * (Y0 - Y1);

  // Le damier : aire proportionnelle au nombre de personnes.
  const MAX = Math.max(...GRILLE.comptes.flat());
  const COTE = 36;
  const CASES = GRILLE.comptes.flatMap((col, k) =>
    col.map((c, t) => ({ k, t, c, cote: Math.sqrt(c / MAX) * COTE }))
  ).filter((d) => d.c > 0);

  const b0 = POP.b0, b1 = POP.b1;
  const n0 = NOTRE.coefs[0].b, n1 = NOTRE.coefs[1].b;
  const PTS = NOTRE.points;

  const ARIA =
    `Les ${f(POP.n)} répondant.e.s de la CES 2025, en damier : la note donnée à Mark Carney selon la position gauche-droite. ` +
    `La vraie droite descend de ${f(-b1, 2)} points par cran vers la droite. On la connaît exactement ici, jamais dans la vraie vie. ` +
    `Notre sondage de ${f(NOTRE.n)} personnes donne une pente de ${f(n1, 2)} : proche, pas pareille.`;
</script>

<div class="visuel d7-vraie" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={ARIA}>
    <text x={X1 + 20} y="26" class="vd-source vd-fin">CES 2025 · les {f(POP.n)} répondant.e.s = la population</text>

    <!-- Les axes. -->
    <line x1={X0} y1={Y0} x2={X1 + 20} y2={Y0} class="vd-axe" />
    <line x1={X0 - 20} y1={Y0} x2={X0 - 20} y2={Y1 - 10} class="vd-axe" />
    {#each [0, 2, 4, 6, 8, 10] as t}
      <text x={X(t)} y={Y0 + 30} class="vd-tick">{t}</text>
    {/each}
    {#each [0, 50, 100] as t}
      <text x={X0 - 32} y={Y(t) + 6} class="vd-tick vd-fin">{t}</text>
    {/each}
    <text x={X1 + 20} y={Y0 + 62} class="vd-tick vd-fin">gauche_droite (0 = gauche, 10 = droite)</text>
    <text x={X0 - 32} y={Y1 - 24} class="vd-tick vd-debut">note_carney</text>

    <!-- 0 : le damier de la population. -->
    <g class="vd-damier" class:vd-pale={e >= 2}>
      {#each CASES as d, i}
        <rect x={X(d.k) - d.cote / 2} y={Y(d.t * 10 + 5) - d.cote / 2} width={d.cote} height={d.cote}
              class="vd-case" style="animation-delay: {(d.k * 10 + d.t) * 6}ms" />
      {/each}
    </g>

    <!-- 2 : notre sondage, ses points et sa droite. -->
    <g class="vd-etape" class:vd-vu={e >= 2}>
      {#each PTS as p}
        <circle cx={X(p.jx)} cy={Y(p.y)} r="2.6" class="vd-pt" />
      {/each}
    </g>
    <line x1={X(0)} y1={Y(n0)} x2={X(10)} y2={Y(n0 + 10 * n1)} pathLength="1"
          class="vd-notre" class:vd-trace={e >= 2} />

    <!-- 1 : la vraie droite. -->
    <line x1={X(0)} y1={Y(b0)} x2={X(10)} y2={Y(b0 + 10 * b1)} class="vd-vraie" class:vd-vu={e >= 1} />

    <!-- Les étiquettes, à droite. -->
    <g class="vd-etape" class:vd-vu={e === 0}>
      <text x="800" y="200" class="vd-l">un carré =</text>
      <text x="800" y="228" class="vd-l">les gens d’une case</text>
      <text x="800" y="268" class="vd-g">plus il est gros,</text>
      <text x="800" y="294" class="vd-g">plus il y a de monde</text>
    </g>
    <g class="vd-etape" class:vd-vu={e >= 1}>
      <line x1="800" y1="120" x2="860" y2="120" class="vd-vraie vd-vu vd-leg" />
      <text x="800" y="160" class="vd-l">la vraie droite</text>
      <text x="800" y="210" class="vd-gros">{f(b1, 2)}</text>
      <text x="800" y="240" class="vd-g">connue ici,</text>
      <text x="800" y="264" class="vd-g">jamais dans la vraie vie</text>
    </g>
    <g class="vd-etape vd-tard" class:vd-vu={e >= 2}>
      <line x1="800" y1="330" x2="860" y2="330" class="vd-notre vd-trace vd-leg" />
      <text x="800" y="370" class="vd-l">notre sondage</text>
      <text x="800" y="420" class="vd-gros">{f(n1, 2)}</text>
      <text x="800" y="450" class="vd-g">{f(NOTRE.n)} parmi les {f(POP.n)}</text>
      <text x="800" y="474" class="vd-g">proche, pas pareille</text>
    </g>
  </svg>
</div>

<style>
  .d7-vraie { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .vd-source { font-size: 18px; text-anchor: end; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .vd-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .vd-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .vd-fin { text-anchor: end; }
  .vd-debut { text-anchor: start; }

  .vd-damier { transition: opacity 0.5s; }
  .vd-damier.vd-pale { opacity: 0.18; }
  .vd-case { fill: var(--dk-gris-2); transform-box: fill-box; transform-origin: center; animation: vd-pop 0.4s ease-out both; }
  @keyframes vd-pop { from { transform: scale(0); } to { transform: scale(1); } }

  .vd-pt { fill: var(--dk-gris); fill-opacity: 0.55; }

  .vd-vraie { stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 14 9; opacity: 0; transition: opacity 0.5s; }
  .vd-vraie.vd-vu { opacity: 1; }
  .vd-notre { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out 0.5s; }
  .vd-notre.vd-trace { stroke-dashoffset: 0; }
  .vd-leg { stroke-dashoffset: 0; transition: none; }
  .vd-notre.vd-leg { stroke-dasharray: none; }

  .vd-l { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .vd-g { font-size: 18px; fill: var(--dk-gris); }
  .vd-gros { font-size: 40px; font-weight: 700; fill: var(--dk-encre); }

  .vd-etape { opacity: 0; transition: opacity 0.2s; }
  .vd-etape.vd-vu { opacity: 1; transition: opacity 0.4s; }
  .vd-etape.vd-tard.vd-vu { transition: opacity 0.4s 1.2s; }

  @media (prefers-reduced-motion: reduce) {
    .vd-case { animation: none; }
    .vd-damier, .vd-vraie, .vd-notre, .vd-etape, .vd-etape.vd-vu, .vd-etape.vd-tard.vd-vu { transition: none; }
  }
</style>
