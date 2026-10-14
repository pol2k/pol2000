<script>
  /**
   * « Ce qui reste : ε », séance 7. Pourquoi les sondages des 18 à 34 ans
   * ratent toujours du même côté ? Par ε, ce que la droite ne prédit pas :
   * la distance verticale entre une personne et la vraie droite.
   *
   *   0  L'équation, ε en rouge (« tout le reste »). Dessous, la vraie
   *      droite (pointillé, POP) et, en gris, la satisfaction moyenne des
   *      20 180 à chaque niveau de populisme (POP.moyennes) : des deux côtés
   *      de la droite, sans pencher (sur les 20 180, ε n'a aucun lien avec
   *      le populisme, c'est ainsi que R choisit la droite).
   *   1  Les 18 à 34 ans de la CES, niveau par niveau (JEUNES.moyennes), en
   *      rouge, avec un trait de la vraie droite jusqu'à leur moyenne : leur
   *      ε moyen (JEUNES.moyennes[i].epsilon). En désaccord : sous la
   *      droite. En accord : sur la droite ou au-dessus. Leur ε penche avec
   *      le populisme (corrélation JEUNES.correlation, 0,11). La taille du
   *      point rouge suit le nombre de jeunes à ce niveau (33 seulement à
   *      « fortement en désaccord », 939 à « plutôt en accord »).
   *   2  La droite des jeunes (JEUNES.b0, JEUNES.b1) se trace : plus plate,
   *      −0,19 au lieu de −0,31. C'est la cloche rouge de la diapo
   *      précédente (MILLE.moyenne_facile).
   *   3  La leçon : quand ε bouge avec x, la pente se trompe. Puis la
   *      question qui mène à la section suivante : qu'est-ce qui se cache
   *      dans ε ?
   *
   * L'axe vertical est un zoom (de 0,3 à 0,9, graduations écrites) : les
   * écarts sont de l'ordre de 0,05 à 0,13 sur une échelle de 0 à 1.
   *
   * À dire, pas à écrire : les points gris ne tombent pas tous sur la
   * droite (la vraie relation n'est pas tout à fait droite : la
   * satisfaction baisse doucement, puis plonge à « fortement en accord »).
   * Ce qui compte, c'est qu'ils ne penchent pas, alors que les rouges
   * montent de gauche à droite.
   *
   * Sources : VARS, POP (src/lib/data/seance7.js, outils/seance7_data.R);
   * JEUNES (src/lib/data/seance7_d.js, outils/seance7_d.R), les
   * JEUNES.n jeunes de la CES, dont JEUNES.n_modele ont répondu aux deux
   * questions.
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, POP } from '$lib/data/seance7.js';
  import { JEUNES } from '$lib/data/seance7_d.js';
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
  const min1 = (s) => s.charAt(0).toLowerCase() + s.slice(1);
  const deuxLignes = (s) => {
    s = min1(s);
    if (s.includes(', ')) { const [a, b] = s.split(', '); return [a + ',', b]; }
    const i = s.indexOf(' ');
    return [s.slice(0, i), s.slice(i + 1)];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));

  // Le graphique : populisme de 0 à 1, satisfaction moyenne de 0,3 à 0,9 (zoom).
  const X0 = 130, X1 = 670, Y0 = 470, Y1 = 150, N0 = 0.3, N1 = 0.9;
  const X = (v) => X0 + v * (X1 - X0);
  const Y = (v) => Y0 - ((v - N0) / (N1 - N0)) * (Y0 - Y1);
  const vraie = (x) => POP.b0 + POP.b1 * x;
  const jeunes = (x) => JEUNES.b0 + JEUNES.b1 * x;

  const GRIS = POP.moyennes;
  const NMAX = Math.max(...JEUNES.moyennes.map((m) => m.n));
  const ROUGE = JEUNES.moyennes.map((m, i) => ({ ...m, r: 5 + Math.sqrt(m.n / NMAX) * 8, d: i * 90 }));
  const QUI = 'les 18 à 34 ans';

  const ARIA =
    `${VARS.y.nom} = β0 + β1 × ${VARS.x.nom} + ε. ε, c’est tout le reste${NN}: la distance entre une personne et la vraie droite. ` +
    `Sur les ${f(POP.n)} répondant.e.s, les moyennes sont des deux côtés de la vraie droite, sans pencher. ` +
    `Chez ${QUI}, elles sont sous la droite du côté « en désaccord » et sur la droite ou au-dessus du côté « en accord »${NN}: ε penche avec le populisme. ` +
    `Leur droite est plus plate, ${f(JEUNES.b1, 2)} au lieu de ${f(POP.b1, 2)}. Quand ε bouge avec x, la pente se trompe.`;
</script>

<div class="visuel d7-epsilon" bind:this={hote}>
  <svg viewBox="0 0 1000 664" role="img" aria-label={ARIA}>
    <!-- L'équation. -->
    <text x="500" y="52" class="ep-eq">{VARS.y.nom} = β0 + β1 × {VARS.x.nom} + <tspan class="ep-eps">ε</tspan></text>
    <text x="874" y="92" class="ep-reste">tout le reste ↑</text>

    <!-- Les axes. -->
    <line x1={X0 - 30} y1={Y0 + 20} x2={X1 + 30} y2={Y0 + 20} class="ep-axe" />
    <line x1={X0 - 30} y1={Y0 + 20} x2={X0 - 30} y2={Y1 - 10} class="ep-axe" />
    {#each NX as t}
      <text x={X(t.v)} y={Y0 + 46} class="ep-val">{f(t.v, t.v % 1 ? 2 : 0)}</text>
      <text x={X(t.v)} y={Y0 + 68} class="ep-niv">{t.l[0]}</text>
      <text x={X(t.v)} y={Y0 + 86} class="ep-niv">{t.l[1]}</text>
    {/each}
    {#each [0.4, 0.6, 0.8] as t}
      <text x={X0 - 40} y={Y(t) + 6} class="ep-tick ep-fin">{f(t, 1)}</text>
    {/each}
    <text x={X1 + 30} y={Y0 + 112} class="ep-tick ep-fin">{VARS.x.nom}</text>
    <text x={X0 - 30} y={Y1 - 26} class="ep-tick ep-debut">{VARS.y.nom} (moyenne)</text>

    <!-- 0 : la vraie droite et les 20 180, niveau par niveau. -->
    {#each GRIS as m}
      <circle cx={X(m.x)} cy={Y(m.moyenne)} r="9" class="ep-gris" />
    {/each}
    <line x1={X(0)} y1={Y(vraie(0))} x2={X(1)} y2={Y(vraie(1))} class="ep-vrai" />

    <!-- 1 : les jeunes, et leur ε moyen. -->
    <g class="ep-etape" class:ep-vu={e >= 1}>
      {#each ROUGE as m}
        <line x1={X(m.x)} y1={Y(vraie(m.x))} x2={X(m.x)} y2={Y(m.moyenne)} class="ep-eps-t" style="transition-delay: {e >= 1 ? m.d : 0}ms" />
        <circle cx={X(m.x)} cy={Y(m.moyenne)} r={m.r} class="ep-rouge" style="transition-delay: {e >= 1 ? m.d + 150 : 0}ms" />
      {/each}
    </g>

    <!-- 2 : leur droite. -->
    <line x1={X(0)} y1={Y(jeunes(0))} x2={X(1)} y2={Y(jeunes(1))} pathLength="1" class="ep-jeunes" class:ep-trace={e >= 2} />

    <!-- Les étiquettes, à droite. -->
    <g>
      <line x1="720" y1="168" x2="770" y2="168" class="ep-vrai" />
      <text x="784" y="175" class="ep-l">la vraie droite</text>
      <circle cx="745" cy="208" r="9" class="ep-gris" />
      <text x="784" y="215" class="ep-g">les {f(POP.n)}</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 1}>
      <circle cx="745" cy="248" r="10" class="ep-rouge" />
      <text x="784" y="255" class="ep-l ep-r">{QUI}</text>
      <text x="720" y="300" class="ep-g">en désaccord{NN}:</text>
      <text x="720" y="324" class="ep-g">sous la droite</text>
      <text x="720" y="356" class="ep-g">en accord{NN}:</text>
      <text x="720" y="380" class="ep-g">sur la droite</text>
      <text x="720" y="404" class="ep-g">ou au-dessus</text>
    </g>
    <g class="ep-etape" class:ep-vu={e >= 2}>
      <text x="720" y="446" class="ep-g">leur pente</text>
      <text x="720" y="490" class="ep-gros">{f(JEUNES.b1, 2)}</text>
      <text x="720" y="518" class="ep-g">au lieu de {f(POP.b1, 2)}</text>
    </g>

    <!-- 3 : la leçon, et la question. -->
    <g class="ep-etape" class:ep-vu={e >= 3}>
      <text x="500" y="626" class="ep-lecon">Quand ε bouge avec x, la pente se trompe.</text>
      <text x="500" y="658" class="ep-question">Qu’est-ce qui se cache dans ε{NN}?</text>
    </g>
  </svg>
</div>

<style>
  .d7-epsilon { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .ep-eq { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ep-eps { fill: var(--dk-accent); font-size: 36px; font-weight: 700; }
  .ep-reste { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }

  .ep-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .ep-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ep-val { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ep-niv { font-size: 14.5px; text-anchor: middle; fill: var(--dk-gris); }
  .ep-fin { text-anchor: end; }
  .ep-debut { text-anchor: start; }

  .ep-vrai { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 12 8; }
  .ep-gris { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 3; }
  .ep-rouge { fill: var(--dk-accent); }
  .ep-etape .ep-rouge, .ep-etape .ep-eps-t { opacity: 0; transition: opacity 0.3s; }
  .ep-etape.ep-vu .ep-rouge, .ep-etape.ep-vu .ep-eps-t { opacity: 1; }
  .ep-eps-t { stroke: var(--dk-accent); stroke-width: 4; }
  .ep-jeunes { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .ep-jeunes.ep-trace { stroke-dashoffset: 0; }

  .ep-l { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .ep-r { fill: var(--dk-accent); }
  .ep-g { font-size: 19px; fill: var(--dk-gris); }
  .ep-gros { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .ep-lecon { font-size: 25px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ep-question { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .ep-etape { opacity: 0; transition: opacity 0.2s; }
  .ep-etape.ep-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .ep-etape, .ep-etape.ep-vu, .ep-etape .ep-rouge, .ep-etape .ep-eps-t, .ep-jeunes { transition: none; }
  }
</style>
