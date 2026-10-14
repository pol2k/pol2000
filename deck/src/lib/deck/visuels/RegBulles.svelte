<script>
  /**
   * Le nuage de la CES 2025 en bulles, comme geom_count() : la note donnée à
   * Mark Carney (0 à 100, arrondie à la dizaine) selon la position
   * gauche-droite (0 à 10). Chaque bulle compte les personnes de sa case;
   * sa surface est proportionnelle au nombre. 15 993 personnes : les
   * 20 180 répondant.e.s de la CES moins celles qui n'ont pas répondu aux
   * deux questions (BULLES, outils/seance7_b.R).
   *
   * Pas d'état propre : le parent dit quoi montrer.
   *   moyennes  les onze moyennes de la population, un carré rouge par cran
   *             (POP.moyennes, outils/seance7_data.R);
   *   droite    la droite de la population, b0 et b1 de POP (lm sur les
   *             15 993), tracée de 0 à 10;
   *   a8        la prédiction à 8 : on monte de 8 jusqu'à la droite, puis
   *             on file vers l'axe de la note;
   *   pale      les bulles en retrait, quand la droite est le sujet.
   */
  import { BULLES } from '$lib/data/seance7_b.js';
  import { POP } from '$lib/data/seance7.js';

  let { moyennes = false, droite = false, a8 = false, pale = false } = $props();
  // Un identifiant par exemplaire : le nuage paraît sur plus d'une diapo.
  const uid = $props.id();

  // Repères : gauche-droite de 0 à 10 (en x), note de 0 à 100 (en y).
  const X0 = 96, X1 = 736, Y0 = 404, Y1 = 34;
  const sx = (v) => X0 + (v / 10) * (X1 - X0);
  const sy = (v) => Y0 - (v / 100) * (Y0 - Y1);
  const MAX = Math.max(...BULLES.cases.map((c) => c.n));
  // La plus grosse bulle remplit presque sa case (37 px de haut).
  const rayon = (n) => 18.5 * Math.sqrt(n / MAX);

  const prevu = (x) => POP.b0 + POP.b1 * x;
  const P8 = prevu(8);
</script>

<svg viewBox="0 0 760 470" class="rb" class:pale role="img"
  aria-label="Nuage en bulles : la note donnée à Mark Carney selon la position gauche-droite, 15 993 répondant.e.s de la CES 2025. Plus on se place à droite, plus la note baisse.">
  <defs>
    <clipPath id="rb-cadre-{uid}"><rect x={X0} y={Y1 - 6} width={X1 - X0} height={Y0 - Y1 + 6} /></clipPath>
  </defs>

  <!-- Les axes. -->
  <line x1={X0 - 18} y1={Y0 + 18} x2={X1 + 12} y2={Y0 + 18} class="axe" />
  <line x1={X0 - 18} y1={Y0 + 18} x2={X0 - 18} y2={Y1 - 8} class="axe" />
  {#each [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] as v}
    <line x1={sx(v)} y1={Y0 + 18} x2={sx(v)} y2={Y0 + 25} class="axe" />
    <text x={sx(v)} y={Y0 + 46} class="tick">{v}</text>
  {/each}
  {#each [0, 25, 50, 75, 100] as v}
    <line x1={X0 - 25} y1={sy(v)} x2={X0 - 18} y2={sy(v)} class="axe" />
    <text x={X0 - 32} y={sy(v) + 6} class="tick d">{v}</text>
  {/each}
  <text x={sx(0)} y="466" class="pole">← GAUCHE</text>
  <text x={sx(10)} y="466" class="pole fin">DROITE →</text>
  <text x={(X0 + X1) / 2} y="466" class="titre-axe">position gauche-droite</text>
  <text transform="translate(18 {(Y0 + Y1) / 2}) rotate(-90)" class="titre-axe">note de Carney</text>

  <!-- Les bulles. -->
  <g class="bulles">
    {#each BULLES.cases as c}
      <circle cx={sx(c.x)} cy={sy(c.y)} r={rayon(c.n)} class="bulle" />
    {/each}
  </g>

  <!-- La prédiction à 8, sous la droite. -->
  <g class="a8" class:vu={a8}>
    <path d="M {sx(8)} {Y0 + 18} L {sx(8)} {sy(P8)} L {X0 - 18} {sy(P8)}" pathLength="1" class="pointille" />
    <circle cx={sx(8)} cy={sy(P8)} r="9" class="cible" />
  </g>

  <!-- La droite de la population. -->
  <path d="M {sx(0)} {sy(prevu(0))} L {sx(10)} {sy(prevu(10))}" pathLength="1" class="droite" class:vu={droite} clip-path="url(#rb-cadre-{uid})" />

  <!-- Les onze moyennes. -->
  {#each POP.moyennes as m, i}
    <rect x={sx(m.x) - 8} y={sy(m.moyenne) - 8} width="16" height="16" class="moy" class:vu={moyennes} style="--k: {i}" />
  {/each}
</svg>

<style>
  .rb { width: 100%; height: auto; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .pole { font-size: 13px; letter-spacing: 0.14em; font-weight: 600; fill: var(--dk-gris); }
  .pole.fin { text-anchor: end; }
  .titre-axe { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .bulle { fill: var(--dk-encre); fill-opacity: 0.2; stroke: var(--dk-encre); stroke-opacity: 0.45; stroke-width: 1.2; transition: fill-opacity 0.5s, stroke-opacity 0.5s; }
  .pale .bulle { fill-opacity: 0.09; stroke-opacity: 0.22; }

  .moy { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; opacity: 0; transform-box: fill-box; transform-origin: center; transform: scale(0.2);
    transition: opacity 0.3s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); transition-delay: calc(var(--k) * 60ms); }
  .moy.vu { opacity: 1; transform: none; }

  .droite { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .droite.vu { stroke-dashoffset: 0; }

  .a8 { opacity: 0; transition: opacity 0.3s; }
  .a8.vu { opacity: 1; }
  .pointille { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .a8.vu .pointille { stroke-dashoffset: 0; }
  .cible { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }

  @media (prefers-reduced-motion: reduce) {
    .moy, .droite, .pointille, .a8 { transition: none; }
  }
</style>
