<script>
  /**
   * Le nuage de la population en bulles, comme geom_count() : la
   * satisfaction envers la démocratie (4 niveaux, de 0 à 1) selon le
   * populisme (5 niveaux, de 0 à 1). Les deux variables n'ont que quelques
   * valeurs : 5 × 4 = 20 cases. Chaque bulle compte les personnes de sa
   * case; sa surface est proportionnelle au nombre. 10 993 personnes : les
   * 20 180 répondant.e.s de la CES 2025 qui ont répondu aux deux questions
   * (POP.cases, outils/seance7_data.R). Les étiquettes des niveaux viennent
   * de VARS (le codebook), raccourcies.
   *
   * Pas d'état propre : le parent dit quoi montrer.
   *   moyennes  les cinq moyennes de la population, un carré rouge par
   *             niveau de populisme (POP.moyennes);
   *   droite    la droite de la population, b0 et b1 de POP, de 0 à 1;
   *   pred      une valeur de populisme (0,75 par exemple) et predire,
   *             le moment de la montrer : on monte jusqu'à la droite,
   *             puis on file vers l'axe de la satisfaction;
   *   pale      les bulles en retrait, quand la droite est le sujet.
   */
  import { POP, VARS } from '$lib/data/seance7.js';

  let { moyennes = false, droite = false, pred = null, predire = false, pale = false } = $props();
  // Un identifiant par exemplaire : le nuage paraît sur plus d'une diapo.
  const uid = $props.id();

  // Repères : populisme de 0 à 1 (en x), satisfaction de 0 à 1 (en y).
  const X0 = 214, X1 = 768, Y0 = 414, Y1 = 78;
  const sx = (v) => X0 + v * (X1 - X0);
  const sy = (v) => Y0 - v * (Y0 - Y1);
  const AXE_X = Y0 + 62, AXE_Y = X0 - 66;
  const MAX = Math.max(...POP.cases.map((c) => c.n));
  // La plus grosse bulle remplit presque sa case (115 px de haut).
  const rayon = (n) => 52 * Math.sqrt(n / MAX);

  const virgule = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  // Les niveaux du codebook, en minuscules, sur deux lignes au besoin.
  const NX = VARS.x.niveaux.map((t) => {
    const s = t.toLowerCase();
    const i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return [s.slice(0, j), s.slice(j + 1)];
  });
  const NY = VARS.y.niveaux.map((t) => t.toLowerCase().replace(' satisfait', ''));

  const prevu = (x) => POP.b0 + POP.b1 * x;
</script>

<svg viewBox="0 0 820 570" class="rb" class:pale role="img"
  aria-label="Nuage en bulles des 10 993 répondant.e.s de la CES 2025 : la satisfaction envers la démocratie selon le populisme. Plus on est en accord avec l’énoncé populiste, moins on est satisfait.">
  <defs>
    <clipPath id="rb-cadre-{uid}"><rect x={X0} y={Y1 - 30} width={X1 - X0} height={Y0 - Y1 + 60} /></clipPath>
  </defs>

  <!-- Les axes et les niveaux. -->
  <line x1={AXE_Y} y1={AXE_X} x2={X1 + 26} y2={AXE_X} class="axe" />
  <line x1={AXE_Y} y1={AXE_X} x2={AXE_Y} y2={Y1 - 44} class="axe" />
  {#each VARS.x.valeurs as v, i}
    <line x1={sx(v)} y1={AXE_X} x2={sx(v)} y2={AXE_X + 7} class="axe" />
    <text x={sx(v)} y={AXE_X + 27} class="val">{virgule(v)}</text>
    <text x={sx(v)} y={AXE_X + 48} class="niv">{NX[i][0]}</text>
    <text x={sx(v)} y={AXE_X + 66} class="niv">{NX[i][1]}</text>
  {/each}
  {#each VARS.y.valeurs as v, i}
    <line x1={AXE_Y - 7} y1={sy(v)} x2={AXE_Y} y2={sy(v)} class="axe" />
    <text x={AXE_Y - 13} y={sy(v) - 3} class="niv d">{NY[i]}</text>
    <text x={AXE_Y - 13} y={sy(v) + 16} class="val d">{virgule(v)}</text>
  {/each}
  <text x={(X0 + X1) / 2} y="564" class="titre-axe">populisme</text>
  <text x={AXE_Y - 13} y="22" class="titre-axe d">satisfaction</text>

  <!-- Les bulles. -->
  <g class="bulles">
    {#each POP.cases as c}
      <circle cx={sx(c.x)} cy={sy(c.y)} r={rayon(c.n)} class="bulle" />
    {/each}
  </g>

  <!-- La prédiction, sous la droite. -->
  {#if pred !== null}
    <g class="pred" class:vu={predire}>
      <path d="M {sx(pred)} {AXE_X} L {sx(pred)} {sy(prevu(pred))} L {AXE_Y} {sy(prevu(pred))}" pathLength="1" class="guide" />
      <circle cx={sx(pred)} cy={sy(prevu(pred))} r="10" class="cible" />
    </g>
  {/if}

  <!-- La droite de la population. -->
  <path d="M {sx(0)} {sy(prevu(0))} L {sx(1)} {sy(prevu(1))}" pathLength="1" class="droite" class:vu={droite} clip-path="url(#rb-cadre-{uid})" />

  <!-- Les cinq moyennes. -->
  {#each POP.moyennes as m, i}
    <rect x={sx(m.x) - 10} y={sy(m.moyenne) - 10} width="20" height="20" class="moy" class:vu={moyennes} style="--k: {i}" />
  {/each}
</svg>

<style>
  .rb { width: 100%; height: auto; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .val { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .niv { font-size: 15px; text-anchor: middle; fill: var(--dk-encre); }
  .val.d, .niv.d { text-anchor: end; }
  .titre-axe { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .titre-axe.d { text-anchor: end; }

  .bulle { fill: var(--dk-encre); fill-opacity: 0.16; stroke: var(--dk-encre); stroke-opacity: 0.4; stroke-width: 1.2; transition: fill-opacity 0.5s, stroke-opacity 0.5s; }
  .pale .bulle { fill-opacity: 0.08; stroke-opacity: 0.2; }

  .moy { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2.5; opacity: 0; transform-box: fill-box; transform-origin: center; transform: scale(0.2);
    transition: opacity 0.3s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); transition-delay: calc(var(--k) * 80ms); }
  .moy.vu { opacity: 1; transform: none; }

  .droite { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .droite.vu { stroke-dashoffset: 0; }

  .pred { opacity: 0; transition: opacity 0.3s; }
  .pred.vu { opacity: 1; }
  .guide { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .pred.vu .guide { stroke-dashoffset: 0; }
  .cible { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }

  @media (prefers-reduced-motion: reduce) {
    .moy, .droite, .guide, .pred { transition: none; }
  }
</style>
