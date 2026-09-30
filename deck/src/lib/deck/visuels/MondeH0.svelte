<script>
  /**
   * Si H0 était vraie : la distribution des moyennes de 50 pommes dans un
   * monde où le vrai poids moyen serait de 100 g. La courbe est la loi de
   * Student à 49 degrés de liberté (STUDENT : grille de t de -4 à 4 et sa
   * densité, calculées par dt() dans outils/seance5_data.R), mise à l'échelle
   * des grammes par l'erreur type : poids = POMMES.h0 + t × POMMES.erreurType.
   * C'est la figure 4.2 d'Arel-Bundock (2021, p. 70). La hauteur est
   * seulement mise à l'échelle pour remplir le dessin. Trois temps.
   *
   *   0  La courbe et ce qu'elle représente.
   *   1  Un repère rouge à notre échantillon, POMMES.moyenne.
   *   2  Une question : serait-ce surprenant ?
   *   3  Les deux queues au moins aussi loin de H0 que notre panier passent
   *      au rouge : la valeur p, dite en mots (« moins de 5 fois sur 100 »,
   *      arrondi vers le haut à partir de POMMES.p). Pas de t à l'écran : R
   *      fait le calcul, la diapo montre l'idée.
   *
   * L'axe va de 90 à 110 g : la courbe, de h0 - 4 erreurs types à
   * h0 + 4 erreurs types, y tient entièrement.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES, STUDENT } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const G0 = 90, G1 = 110, X0 = 60, X1 = 940;
  const BASE = 356, HAUT = 270;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const dmax = Math.max(...STUDENT.densite);
  const y = (d) => BASE - (d / dmax) * HAUT;
  const PTS = STUDENT.t
    .map((t, i) => [x(POMMES.h0 + t * POMMES.erreurType), y(STUDENT.densite[i])])
    .filter(([px]) => px >= X0 && px <= X1);
  const COURBE = 'M ' + PTS.map(([a, b]) => `${a.toFixed(1)} ${b.toFixed(1)}`).join(' L ');
  const AIRE = `${COURBE} L ${PTS[PTS.length - 1][0].toFixed(1)} ${BASE} L ${PTS[0][0].toFixed(1)} ${BASE} Z`;
  const TICKS = [90, 95, 100, 105, 110];
  const MINEURS = Array.from({ length: G1 - G0 + 1 }, (_, i) => G0 + i);
  const XE = x(POMMES.moyenne);
  // Temps 3 : les deux queues au moins aussi loin de H0 que notre panier,
  // découpées dans la même courbe. « Moins de k fois sur 100 » vient de POMMES.p.
  const queue = (garder) => {
    const q = PTS.filter(([px]) => garder(px));
    if (!q.length) return '';
    return 'M ' + q[0][0].toFixed(1) + ' ' + BASE + ' ' + q.map(([a, b]) => `L ${a.toFixed(1)} ${b.toFixed(1)}`).join(' ') + ' L ' + q[q.length - 1][0].toFixed(1) + ' ' + BASE + ' Z';
  };
  const XM = x(2 * POMMES.h0 - POMMES.moyenne);
  const QUEUES = [queue((px) => px >= XE), queue((px) => px <= XM)];
  const SUR100 = Math.ceil(POMMES.p * 100);
</script>

<div class="visuel monde-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 445" role="img" aria-label="Une courbe en cloche centrée sur {POMMES.h0} g&#8239;: les moyennes de {POMMES.n} pommes, si le vrai poids moyen était de {POMMES.h0} g. Notre échantillon, {POMMES.moyenne} g, tombe loin dans la queue droite. Serait-ce surprenant&#8239;?">
    <text x="500" y="38" class="mh0-titre">les moyennes de {POMMES.n} pommes, si le vrai poids moyen était de {POMMES.h0} g</text>

    <path d={AIRE} class="mh0-aire" />
    <path d={COURBE} pathLength="1" class="mh0-courbe" />

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="mh0-axe" />
    {#each MINEURS as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 5} class="mh0-mineur" />
    {/each}
    {#each TICKS as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 9} class="mh0-axe" />
      <text x={x(g)} y={BASE + 30} class="mh0-tick" class:mh0-h0={g === POMMES.h0}>{g} g</text>
    {/each}

    <!-- Temps 1 : notre échantillon. -->
    <g class="mh0-etape" class:mh0-vu={e >= 1}>
      <line x1={XE} y1={BASE} x2={XE} y2="170" class="mh0-repere" />
      <circle cx={XE} cy={BASE} r="9" class="mh0-point" />
      <text x={XE + 14} y="192" class="mh0-lab">notre échantillon&#8239;:</text>
      <text x={XE + 14} y="234" class="mh0-val">{POMMES.moyenne} g</text>
    </g>

    <!-- Temps 2 : la question. -->
    <text x="500" y="432" class="mh0-question mh0-etape" class:mh0-vu={e === 2}>Serait-ce surprenant&#8239;?</text>

    <!-- Temps 3 : les queues, et la réponse en mots. -->
    <g class="mh0-etape" class:mh0-vu={e >= 3}>
      {#each QUEUES as d}<path {d} class="mh0-queue" />{/each}
      <line x1={XM} y1={BASE} x2={XM} y2="300" class="mh0-miroir" />
      <text x={XE + 14} y="290" class="mh0-p">la valeur p</text>
      <text x="500" y="432" class="mh0-reponse">Si H0 était vraie&#8239;: moins de {SUR100} fois sur 100.</text>
    </g>
  </svg>
</div>

<style>
  .monde-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .mh0-titre { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .mh0-aire { fill: var(--dk-fond-2); animation: mh0-fondu 0.6s ease-out 0.3s both; }
  .mh0-courbe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; animation: mh0-trace 0.8s ease-out forwards; }
  @keyframes mh0-trace { to { stroke-dashoffset: 0; } }
  @keyframes mh0-fondu { from { opacity: 0; } to { opacity: 1; } }
  .mh0-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .mh0-mineur { stroke: var(--dk-gris-2); stroke-width: 2; }
  .mh0-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .mh0-tick.mh0-h0 { font-weight: 600; fill: var(--dk-encre); }
  .mh0-repere { stroke: var(--dk-accent); stroke-width: 4; }
  .mh0-point { fill: var(--dk-accent); }
  .mh0-lab { font-size: 21px; fill: var(--dk-encre); }
  .mh0-val { font-size: 34px; font-weight: 600; fill: var(--dk-accent); }
  .mh0-question { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mh0-queue { fill: var(--dk-accent); opacity: 0.85; }
  .mh0-miroir { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 6 5; }
  .mh0-p { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .mh0-reponse { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .mh0-etape { opacity: 0; transition: opacity 0.3s; }
  .mh0-etape.mh0-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .mh0-aire { animation: none; }
    .mh0-courbe { animation: none; stroke-dashoffset: 0; }
    .mh0-etape, .mh0-etape.mh0-vu { transition: none; }
  }
</style>
