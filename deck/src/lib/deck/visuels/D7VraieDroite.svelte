<script>
  /**
   * « La vraie droite », séance 7. Le dispositif de la séance 5 : les
   * 20 180 répondant.e.s de la CES 2025 sont la population d'exercice. On
   * peut donc calculer la VRAIE droite, ce qu'on ne peut jamais faire dans
   * la vraie vie. Puis notre sondage de 1 000, et sa droite à lui.
   *
   * X = populisme, Y = satisfaction_dem, tous deux de 0 à 1 (VARS). Les deux
   * n'ont que 5 et 4 valeurs : 20 cases. La population se dessine en
   * bulles (aire proportionnelle au nombre de personnes, POP.cases), notre
   * sondage en grappes de points (NOTRE.points, `jx` et `jy` étalés par R
   * pour le dessin seulement).
   *
   *   0  Les bulles de la population (les POP.n_modele personnes qui ont
   *      répondu aux deux questions).
   *   1  La vraie droite, en pointillé (comme « la vraie réponse » de la
   *      séance 5) : pente POP.b1 (−0,31), connue exactement ici. Elle se
   *      lit d'un bout à l'autre de l'axe : de « fortement en désaccord » à
   *      « fortement en accord », la satisfaction baisse de 0,31.
   *   2  Les bulles pâlissent. Notre sondage (les NOTRE.n_modele cas
   *      complets parmi 1 000 tiré.e.s) et sa droite, en encre : pente
   *      NOTRE.coefs[1].b (−0,37). Proche de la vraie, pas pareille.
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

  // Libellés courts, tirés du codebook (VARS) : deux lignes pour X, un mot pour Y.
  const min1 = (s) => s.charAt(0).toLowerCase() + s.slice(1);
  const deuxLignes = (s) => {
    s = min1(s);
    if (s.includes(', ')) { const [a, b] = s.split(', '); return [a + ',', b]; }
    const i = s.indexOf(' ');
    return [s.slice(0, i), s.slice(i + 1)];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));
  const NY = VARS.y.valeurs.map((v, i) => ({ v, l: min1(VARS.y.niveaux[i]).replace(/ satisfait$/, '') }));
  const val = (v) => (Math.abs(v - 1 / 3) < 0.01 ? '⅓' : Math.abs(v - 2 / 3) < 0.01 ? '⅔' : f(v, v % 1 ? 2 : 0));

  // Le graphique : X et Y de 0 à 1.
  const X0 = 190, X1 = 730, Y0 = 430, Y1 = 90;
  const X = (v) => X0 + v * (X1 - X0);
  const Y = (v) => Y0 - v * (Y0 - Y1);

  // Les bulles : aire proportionnelle au nombre de personnes.
  const MAX = Math.max(...POP.cases.map((c) => c.n));
  const RMAX = 54;
  const BULLES = POP.cases.filter((c) => c.n > 0).map((c, i) => ({ ...c, r: Math.sqrt(c.n / MAX) * RMAX, d: i * 25 }));

  const b0 = POP.b0, b1 = POP.b1;
  const n0 = NOTRE.coefs[0].b, n1 = NOTRE.coefs[1].b;
  const PTS = NOTRE.points;

  const ARIA =
    `Les ${f(POP.n)} répondant.e.s de la CES 2025, en bulles : la satisfaction envers la démocratie selon le populisme, deux variables de 0 à 1. ` +
    `La vraie droite descend de ${f(-b1, 2)} de « fortement en désaccord » à « fortement en accord ». On la connaît exactement ici, jamais dans la vraie vie. ` +
    `Notre sondage de ${f(NOTRE.n)} personnes donne une pente de ${f(n1, 2)}${NN}: proche, pas pareille.`;
</script>

<div class="visuel d7-vraie" bind:this={hote}>
  <svg viewBox="0 0 1000 580" role="img" aria-label={ARIA}>
    <text x={X1 + 30} y="26" class="vd-source vd-fin">CES 2025 · les {f(POP.n)} répondant.e.s = la population</text>

    <!-- Les axes et les niveaux du codebook. -->
    <line x1={X0 - 40} y1={Y0 + 40} x2={X1 + 30} y2={Y0 + 40} class="vd-axe" />
    <line x1={X0 - 40} y1={Y0 + 40} x2={X0 - 40} y2={Y1 - 30} class="vd-axe" />
    {#each NX as t}
      <text x={X(t.v)} y={Y0 + 66} class="vd-val">{val(t.v)}</text>
      <text x={X(t.v)} y={Y0 + 88} class="vd-niv">{t.l[0]}</text>
      <text x={X(t.v)} y={Y0 + 106} class="vd-niv">{t.l[1]}</text>
    {/each}
    {#each NY as t}
      <text x={X0 - 52} y={Y(t.v) + 6} class="vd-val vd-fin">{val(t.v)}</text>
      <text x={X0 - 84} y={Y(t.v) + 6} class="vd-niv vd-fin">{t.l}</text>
    {/each}
    <text x={X1 + 30} y={Y0 + 134} class="vd-titre vd-fin">{VARS.x.nom}</text>
    <text x={X0 - 40} y={Y1 - 42} class="vd-titre vd-debut">{VARS.y.nom}</text>

    <!-- 0 : les bulles de la population. -->
    <g class="vd-bulles" class:vd-pale={e >= 2}>
      {#each BULLES as b}
        <circle cx={X(b.x)} cy={Y(b.y)} r={b.r} class="vd-bulle" style="animation-delay: {b.d}ms" />
      {/each}
    </g>

    <!-- 2 : notre sondage, ses grappes. -->
    <g class="vd-etape" class:vd-vu={e >= 2}>
      {#each PTS as p}
        <circle cx={X(p.jx)} cy={Y(p.jy)} r="2.6" class="vd-pt" />
      {/each}
    </g>

    <!-- 1 : la vraie droite (un halo clair la détache des bulles). -->
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
      <text x="790" y="190" class="vd-l">un rond =</text>
      <text x="790" y="218" class="vd-l">les gens d’une case</text>
      <text x="790" y="258" class="vd-g">plus il est gros,</text>
      <text x="790" y="282" class="vd-g">plus il y a de monde</text>
      <text x="790" y="322" class="vd-g">{f(POP.n_modele)} ont répondu</text>
      <text x="790" y="346" class="vd-g">aux deux questions</text>
    </g>
    <g class="vd-etape" class:vd-vu={e >= 1}>
      <line x1="790" y1="110" x2="850" y2="110" class="vd-vraie" />
      <text x="790" y="148" class="vd-l">la vraie droite</text>
      <text x="790" y="196" class="vd-gros">{f(b1, 2)}</text>
      <text x="790" y="224" class="vd-g">connue ici,</text>
      <text x="790" y="248" class="vd-g">jamais dans la vraie vie</text>
    </g>
    <g class="vd-etape vd-tard" class:vd-vu={e >= 2}>
      <line x1="790" y1="310" x2="850" y2="310" class="vd-notre vd-leg" />
      <text x="790" y="348" class="vd-l">notre sondage</text>
      <text x="790" y="396" class="vd-gros">{f(n1, 2)}</text>
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

  .vd-bulles { transition: opacity 0.5s; }
  .vd-bulles.vd-pale { opacity: 0.18; }
  .vd-bulle { fill: var(--dk-gris-2); fill-opacity: 0.75; transform-box: fill-box; transform-origin: center; animation: vd-pop 0.45s ease-out both; }
  @keyframes vd-pop { from { transform: scale(0); } to { transform: scale(1); } }

  .vd-pt { fill: var(--dk-gris); fill-opacity: 0.6; }

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
    .vd-bulle { animation: none; }
    .vd-bulles, .vd-vraie-g, .vd-notre, .vd-etape, .vd-etape.vd-vu, .vd-etape.vd-tard.vd-vu { transition: none; }
  }
</style>
