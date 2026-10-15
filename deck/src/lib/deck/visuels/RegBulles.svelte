<script>
  /**
   * La population en points : l'intérêt pour la politique (0 à 1, le
   * curseur de 0 à 10 divisé par 10) selon la scolarité (5 niveaux, de 0 à
   * 1). 5 × 11 = 55 cases. En pâle, chaque case en bulle, comme
   * geom_count() : sa surface est proportionnelle au nombre de personnes
   * (POP.cases). En rouge, la moyenne de chaque niveau, un point dont la
   * surface suit le nombre de personnes du niveau (POP.moyennes). 19 736
   * personnes : les 20 180 répondant.e.s de la CES 2025 qui ont répondu
   * aux deux questions (outils/seance7_data.R). Les niveaux et les bornes
   * viennent de VARS (le codebook).
   *
   * Pas d'état propre : le parent dit quoi montrer.
   *   moyennes  les cinq moyennes, des points rouges;
   *   droite    la droite de la population, b0 et b1 de POP, de 0 à 1;
   *   pred      une valeur de scolarité (0,75 par exemple) et predire, le
   *             moment de la montrer : on monte jusqu'à la droite, puis on
   *             file vers l'axe de l'intérêt;
   *   pale      les bulles en retrait, quand les moyennes et la droite sont
   *             le sujet.
   */
  import { POP, VARS } from '$lib/data/seance7.js';

  let { moyennes = false, droite = false, pred = null, predire = false, pale = false } = $props();
  // Un identifiant par exemplaire : le nuage paraît sur plus d'une diapo.
  const uid = $props.id();

  // Repères : scolarité de 0 à 1 (en x), intérêt de 0 à 1 (en y).
  const X0 = 214, X1 = 768, Y0 = 430, Y1 = 50;
  const sx = (v) => X0 + v * (X1 - X0);
  const sy = (v) => Y0 - v * (Y0 - Y1);
  const AXE_X = Y0 + 26, AXE_Y = X0 - 64;
  const MAX = Math.max(...POP.cases.map((c) => c.n));
  // La plus grosse bulle remplit sa case (38 px de haut).
  const rayon = (n) => 18.5 * Math.sqrt(n / MAX);
  const MAXM = Math.max(...POP.moyennes.map((m) => m.n));
  const rayonM = (n) => Math.max(6, 16 * Math.sqrt(n / MAXM));

  const virgule = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  // Les niveaux du codebook, en minuscules, sur deux lignes au besoin.
  const NX = VARS.x.niveaux.map((t) => {
    const s = t.toLowerCase();
    const i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return j > 0 ? [s.slice(0, j), s.slice(j + 1)] : [s, ''];
  });
  // Les bornes du curseur, sur deux lignes (« beaucoup / d'intérêt »).
  const BORNES = VARS.y.bornes.map((t) => { const s = t.toLowerCase(); const j = s.indexOf(' '); return [s.slice(0, j), s.slice(j + 1)]; });
  const TICKS = [0, 0.2, 0.4, 0.6, 0.8, 1];

  const prevu = (x) => POP.b0 + POP.b1 * x;
</script>

<svg viewBox="0 0 820 540" class="rb" class:pale role="img"
  aria-label="Les 19 736 répondant.e.s de la CES 2025 : l’intérêt pour la politique selon la scolarité. La moyenne monte à chaque niveau de scolarité.">
  <defs>
    <clipPath id="rb-cadre-{uid}"><rect x={X0 - 30} y={Y1 - 30} width={X1 - X0 + 60} height={Y0 - Y1 + 60} /></clipPath>
  </defs>

  <!-- Les axes et les niveaux. -->
  <line x1={AXE_Y} y1={AXE_X} x2={X1 + 30} y2={AXE_X} class="axe" />
  <line x1={AXE_Y} y1={AXE_X} x2={AXE_Y} y2={Y1 - 24} class="axe" />
  {#each VARS.x.valeurs as v, i}
    <line x1={sx(v)} y1={AXE_X} x2={sx(v)} y2={AXE_X + 7} class="axe" />
    <text x={sx(v)} y={AXE_X + 27} class="val">{virgule(v)}</text>
    <text x={sx(v)} y={AXE_X + 48} class="niv">{NX[i][0]}</text>
    <text x={sx(v)} y={AXE_X + 66} class="niv">{NX[i][1]}</text>
  {/each}
  {#each TICKS as v}
    <line x1={AXE_Y - 7} y1={sy(v)} x2={AXE_Y} y2={sy(v)} class="axe" />
    <text x={AXE_Y - 13} y={sy(v) + 6} class="val d">{virgule(v)}</text>
  {/each}
  <text x={AXE_Y - 52} y={sy(1) - 2} class="niv d">{BORNES[1][0]}</text>
    <text x={AXE_Y - 52} y={sy(1) + 15} class="niv d">{BORNES[1][1]}</text>
  <text x={AXE_Y - 52} y={sy(0) - 2} class="niv d">{BORNES[0][0]}</text>
    <text x={AXE_Y - 52} y={sy(0) + 15} class="niv d">{BORNES[0][1]}</text>
  <text x={(X0 + X1) / 2} y="534" class="titre-axe">scolarité</text>
  <text x={AXE_Y - 13} y="16" class="titre-axe d">intérêt</text>

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
    <circle cx={sx(m.x)} cy={sy(m.moyenne)} r={rayonM(m.n)} class="moy" class:vu={moyennes} style="--k: {i}" />
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

  .bulle { fill: var(--dk-encre); fill-opacity: 0.14; stroke: var(--dk-encre); stroke-opacity: 0.35; stroke-width: 1; transition: fill-opacity 0.5s, stroke-opacity 0.5s; }
  .pale .bulle { fill-opacity: 0.06; stroke-opacity: 0.16; }

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
