<script>
  /**
   * « Ce qui reste : ε », séance 7. Pourquoi les sondages du Québec ratent
   * toujours du même côté ? Par ε, ce que la droite ne prédit pas : la
   * distance verticale entre une personne et la vraie droite.
   *
   *   0  L'équation, ε en rouge (« tout le reste »). Dessous, la vraie
   *      droite (pointillé, POP) et, en gris, la note moyenne des 20 180 à
   *      chaque cran (POP.moyennes) : des deux côtés de la droite, sans
   *      pencher (sur les 20 180, ε n'a aucun lien avec gauche_droite,
   *      c'est ainsi que R choisit la droite).
   *   1  Les Québécois.e.s de la CES, cran par cran (QUEBEC.moyennes), en
   *      rouge, avec un trait de la vraie droite jusqu'à leur moyenne : leur
   *      ε moyen. À gauche, sous la droite. À droite, au-dessus. Leur ε
   *      penche avec gauche_droite (corrélation QUEBEC.correlation, 0,2).
   *   2  La droite des Québécois.e.s (QUEBEC.b0, QUEBEC.b1) se trace : plus
   *      plate, −2,43 au lieu de −5,27. C'est la cloche rouge de la diapo
   *      précédente.
   *   3  La leçon : quand ε est lié à x, la pente se trompe. Puis la question
   *      qui mène à la diapo suivante : qu'est-ce qui se cache dans ε ?
   *
   * À dire, pas à écrire : les points gris ne tombent pas tous sur la
   * droite (la vraie relation n'est pas tout à fait droite : la note monte
   * un peu de 0 à 4, puis plonge). Ce qui compte, c'est qu'ils ne penchent
   * pas, alors que les rouges montent de gauche à droite.
   *
   * Sources : POP (src/lib/data/seance7.js, outils/seance7_data.R);
   * QUEBEC (src/lib/data/seance7_d.js, outils/seance7_d.R), les 4 906
   * Québécois.e.s de la CES, dont QUEBEC.n_modele ont répondu aux deux
   * questions.
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance7.js';
  import { QUEBEC } from '$lib/data/seance7_d.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');

  // Le graphique : gauche_droite de 0 à 10, la note de 20 à 90.
  const X0 = 110, X1 = 690, Y0 = 470, Y1 = 150, N0 = 20, N1 = 90;
  const X = (v) => X0 + (v / 10) * (X1 - X0);
  const Y = (v) => Y0 - ((v - N0) / (N1 - N0)) * (Y0 - Y1);
  const vraie = (x) => POP.b0 + POP.b1 * x;
  const qc = (x) => QUEBEC.b0 + QUEBEC.b1 * x;

  const GRIS = POP.moyennes;
  const ROUGE = QUEBEC.moyennes.map((m, i) => ({ ...m, haut: m.moyenne > vraie(m.x), d: i * 70 }));

  const ARIA =
    `note_carney = β0 + β1 × gauche_droite + ε. ε, c’est tout le reste : la distance entre une personne et la vraie droite. ` +
    `Sur les ${f(POP.n)} répondant.e.s, les moyennes sont des deux côtés de la vraie droite, sans pencher. ` +
    `Chez les Québécois.e.s, elles sont sous la droite à gauche et au-dessus à droite : ε penche avec gauche_droite. ` +
    `Leur droite est plus plate, ${f(QUEBEC.b1, 2)} au lieu de ${f(POP.b1, 2)}. Quand ε est lié à x, la pente se trompe.`;
</script>

<div class="visuel d7-epsilon" bind:this={hote}>
  <svg viewBox="0 0 1000 610" role="img" aria-label={ARIA}>
    <!-- L'équation. -->
    <text x="500" y="52" class="ep-eq">note_carney = β0 + β1 × gauche_droite + <tspan class="ep-eps">ε</tspan></text>
    <path d="M 838 66 v 14 h -36" class="ep-fleche" />
    <text x="790" y="88" class="ep-reste">tout le reste</text>

    <!-- Les axes. -->
    <line x1={X0} y1={Y0} x2={X1 + 10} y2={Y0} class="ep-axe" />
    <line x1={X0 - 16} y1={Y0} x2={X0 - 16} y2={Y1 - 10} class="ep-axe" />
    {#each [0, 2, 4, 6, 8, 10] as t}
      <text x={X(t)} y={Y0 + 28} class="ep-tick">{t}</text>
    {/each}
    {#each [20, 50, 80] as t}
      <text x={X0 - 26} y={Y(t) + 6} class="ep-tick ep-fin">{t}</text>
    {/each}
    <text x={X1 + 10} y={Y0 + 56} class="ep-tick ep-fin">gauche_droite</text>
    <text x={X0 - 26} y={Y1 - 22} class="ep-tick ep-debut">note_carney (moyenne)</text>

    <!-- 0 : la vraie droite et les 20 180, cran par cran. -->
    {#each GRIS as m}
      <circle cx={X(m.x)} cy={Y(m.moyenne)} r="8" class="ep-gris" />
    {/each}
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(10)} y2={Y(vraie(10))} class="ep-vrai" />

    <!-- 1 : les Québécois.e.s, et leur ε moyen. -->
    <g class="ep-etape" class:ep-vu={e >= 1}>
      {#each ROUGE as m}
        <line x1={X(m.x)} y1={Y(vraie(m.x))} x2={X(m.x)} y2={Y(m.moyenne)} class="ep-eps-t" style="transition-delay: {e >= 1 ? m.d : 0}ms" />
        <circle cx={X(m.x)} cy={Y(m.moyenne)} r="9" class="ep-rouge" style="transition-delay: {e >= 1 ? m.d + 150 : 0}ms" />
      {/each}
    </g>

    <!-- 2 : leur droite. -->
    <line x1={X(0)} y1={Y(qc(0))} x2={X(10)} y2={Y(qc(10))} pathLength="1" class="ep-qc" class:ep-trace={e >= 2} />

    <!-- Les étiquettes, à droite. -->
    <g>
      <line x1="740" y1="168" x2="790" y2="168" class="ep-vrai" />
      <text x="804" y="175" class="ep-l">la vraie droite</text>
      <circle cx="765" cy="208" r="8" class="ep-gris" />
      <text x="804" y="215" class="ep-g">les {f(POP.n)}</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <circle cx="765" cy="248" r="9" class="ep-rouge ep-vu-tout" />
      <text x="804" y="255" class="ep-l ep-r">le Québec</text>
      <text x="740" y="312" class="ep-g">à gauche{NN}: sous la droite</text>
      <text x="740" y="340" class="ep-g">à droite{NN}: au-dessus</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 2}>
      <text x="740" y="398" class="ep-g">leur pente</text>
      <text x="740" y="444" class="ep-gros">{f(QUEBEC.b1, 2)}</text>
      <text x="740" y="472" class="ep-g">au lieu de {f(POP.b1, 2)}</text>
    </g>

    <!-- 3 : la leçon, et la question. -->
    <g class="ep-etape" class:ep-vu={e >= 3}>
      <text x="500" y="572" class="ep-lecon">Quand ε bouge avec x, la pente se trompe.</text>
      <text x="500" y="604" class="ep-question">Qu’est-ce qui se cache dans ε{NN}?</text>
    </g>
  </svg>
</div>

<style>
  .d7-epsilon { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .ep-eq { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ep-eps { fill: var(--dk-accent); font-size: 36px; font-weight: 700; }
  .ep-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; }
  .ep-reste { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }

  .ep-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .ep-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ep-fin { text-anchor: end; }
  .ep-debut { text-anchor: start; }

  .ep-vrai { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 12 8; }
  .ep-gris { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 3; }
  .ep-rouge { fill: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .ep-etape.ep-vu .ep-rouge { opacity: 1; }
  .ep-eps-t { stroke: var(--dk-accent); stroke-width: 4; opacity: 0; transition: opacity 0.3s; }
  .ep-etape.ep-vu .ep-eps-t { opacity: 1; }
  .ep-qc { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .ep-qc.ep-trace { stroke-dashoffset: 0; }

  .ep-l { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .ep-r { fill: var(--dk-accent); }
  .ep-g { font-size: 19px; fill: var(--dk-gris); }
  .ep-gros { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .ep-lecon { font-size: 25px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ep-question { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .ep-etape { opacity: 0; transition: opacity 0.2s; }
  .ep-etape.ep-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .ep-etape, .ep-etape.ep-vu, .ep-rouge, .ep-eps-t, .ep-qc { transition: none; }
  }
</style>
