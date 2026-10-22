<script>
  /**
   * L'intuition du contrôle, avant les deux règles (M8DeuxRegles) : la
   * scolarité et l'intérêt pour la politique sont liés par deux chemins.
   * Des boîtes et des flèches, sans le vocabulaire des graphes orientés
   * acycliques (séance 11).
   *
   *   0  scolarité → intérêt, la flèche qu'on veut mesurer (« ? »);
   *   1  l'âge apparaît et pousse les deux boîtes : moins de scolarité,
   *      plus d'intérêt (les cohortes plus âgées). Un deuxième chemin, en
   *      rouge, qui passe par l'âge;
   *   2  on contrôle l'âge : son flux s'arrête à la coupure; la boîte est encadrée (la convention de la
   *      figure 6.1 d'Arel-Bundock 2021, p. 128 : les variables encadrées
   *      sont contrôlées), le chemin par l'âge est coupé, il reste la
   *      comparaison à âge égal (M8Pente la dessine ensuite).
   *
   * Le flux (Flux.svelte) : des points voyagent le long de chaque flèche, de
   * la cause vers l'effet. Au temps 1, l'intérêt reçoit deux flux, celui de
   * la scolarité et celui de l'âge : la droite simple les mélange. Au temps
   * 2, l'âge est contrôlé : ses points s'arrêtent à la coupure, seul le flux
   * de la scolarité arrive encore à l'intérêt.
   *
   * Schéma : aucune donnée.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const S = { cx: 190, cy: 370, w: 300, h: 96 };
  const I = { cx: 810, cy: 370, w: 300, h: 96 };
  const A = { cx: 500, cy: 92, w: 200, h: 88 };

  // Une flèche de (a) vers (b) : le trait s'arrête au pied de la pointe.
  function fleche(ax, ay, bx, by, pointe = 22) {
    const dx = bx - ax, dy = by - ay, L = Math.hypot(dx, dy);
    const ux = dx / L, uy = dy / L;
    const px = bx - ux * pointe, py = by - uy * pointe;
    const nx = -uy * pointe * 0.5, ny = ux * pointe * 0.5;
    return {
      d: `M ${ax} ${ay} L ${px} ${py}`,
      tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}`,
      mx: (ax + bx) / 2, my: (ay + by) / 2,
      // La coupure : un trait perpendiculaire au milieu.
      cx1: (ax + bx) / 2 - uy * 22, cy1: (ay + by) / 2 + ux * 22,
      cx2: (ax + bx) / 2 + uy * 22, cy2: (ay + by) / 2 - ux * 22
    };
  }
  const SI = fleche(S.cx + S.w / 2 + 8, S.cy, I.cx - I.w / 2 - 8, I.cy);
  const AS = fleche(A.cx - 60, A.cy + A.h / 2 + 6, S.cx + 40, S.cy - S.h / 2 - 8);
  const AI = fleche(A.cx + 60, A.cy + A.h / 2 + 6, I.cx - 40, I.cy - I.h / 2 - 8);
</script>

<div class="visuel m8i" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La scolarité pointe vers l’intérêt pour la politique. L’âge pointe vers les deux : moins de scolarité, plus d’intérêt. Contrôler l’âge coupe ce deuxième chemin : il reste la comparaison à âge égal.">
    <!-- 0 : scolarité → intérêt. -->
    <path d={SI.d} class="m8i-fl" class:m8i-epais={e >= 2} />
    <polygon points={SI.tete} class="m8i-tete" />
    <Flux d={SI.d} n={4} duree={2.2} r={8} />
    <text x={SI.mx} y={SI.my - 22} class="m8i-q">?</text>
    <text x={SI.mx} y={SI.my + 48} class="m8i-reste m8i-etape m8i-tard" class:m8i-vu={e >= 2}>à âge égal</text>

    <rect x={S.cx - S.w / 2} y={S.cy - S.h / 2} width={S.w} height={S.h} class="m8i-boite" />
    <text x={S.cx} y={S.cy + 10} class="m8i-nom">scolarité</text>
    <rect x={I.cx - I.w / 2} y={I.cy - I.h / 2} width={I.w} height={I.h} class="m8i-boite" />
    <text x={I.cx} y={I.cy + 10} class="m8i-nom">intérêt</text>

    <!-- 1 : l'âge pousse les deux. -->
    <g class="m8i-etape" class:m8i-vu={e >= 1}>
      <rect x={A.cx - A.w / 2} y={A.cy - A.h / 2} width={A.w} height={A.h} class="m8i-boite m8i-age" />
      <text x={A.cx} y={A.cy + 10} class="m8i-nom m8i-rouge-t">âge</text>
    </g>
    <g class:m8i-coupe={e >= 2}>
      <path d={AS.d} pathLength="1" class="m8i-fl m8i-rouge m8i-trace" class:m8i-vu={e >= 1} />
      <polygon points={AS.tete} class="m8i-tete m8i-rouge-t m8i-etape m8i-tard" class:m8i-vu={e >= 1} />
      <path d={AI.d} pathLength="1" class="m8i-fl m8i-rouge m8i-trace" class:m8i-vu={e >= 1} />
      <polygon points={AI.tete} class="m8i-tete m8i-rouge-t m8i-etape m8i-tard" class:m8i-vu={e >= 1} />
      <text x={AS.mx - 34} y={AS.my - 4} class="m8i-etiq m8i-fin m8i-etape m8i-tard" class:m8i-vu={e >= 1}>moins de scolarité</text>
      <text x={AI.mx + 34} y={AI.my - 4} class="m8i-etiq m8i-etape m8i-tard" class:m8i-vu={e >= 1}>plus d’intérêt</text>
    </g>

    <Flux d={AS.d} actif={e >= 1} arret={e >= 2 ? 0.47 : 1} rouge n={3} duree={1.9} r={8} />
    <Flux d={AI.d} actif={e >= 1} arret={e >= 2 ? 0.47 : 1} rouge n={3} duree={1.9} r={8} />

    <!-- 2 : on contrôle l'âge, le chemin est coupé. -->
    <g class="m8i-etape" class:m8i-vu={e >= 2}>
      <rect x={A.cx - A.w / 2 - 12} y={A.cy - A.h / 2 - 12} width={A.w + 24} height={A.h + 24} class="m8i-cadre" />
      <text x={A.cx + A.w / 2 + 34} y={A.cy + 9} class="m8i-ctrl">contrôlé</text>
      <line x1={AS.cx1} y1={AS.cy1} x2={AS.cx2} y2={AS.cy2} class="m8i-cut" />
      <line x1={AI.cx1} y1={AI.cy1} x2={AI.cx2} y2={AI.cy2} class="m8i-cut" />
    </g>

    <text x="0" y="494" class="m8i-cap">schéma · aucune donnée</text>
  </svg>
</div>

<style>
  .m8i { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .m8i-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m8i-boite.m8i-age { stroke: var(--dk-accent); }
  .m8i-nom { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m8i-q { font-size: 36px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m8i-reste { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .m8i-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: stroke-width 0.4s; }
  .m8i-fl.m8i-epais { stroke-width: 7; }
  .m8i-tete { fill: var(--dk-encre); }
  .m8i-rouge { stroke: var(--dk-accent); }
  .m8i-rouge-t { fill: var(--dk-accent); }
  .m8i-etiq { font-size: 24px; font-weight: 600; fill: var(--dk-accent); }
  .m8i-fin { text-anchor: end; }

  /* Le chemin par l'âge, une fois contrôlé : pâli et coupé. */
  .m8i-coupe { opacity: 0.35; transition: opacity 0.5s; }
  .m8i-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 5; }
  .m8i-ctrl { font-size: 26px; font-weight: 700; fill: var(--dk-accent); }
  .m8i-cut { stroke: var(--dk-accent); stroke-width: 6; }
  .m8i-cap { font-size: 18px; fill: var(--dk-gris); }

  .m8i-trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .m8i-trace.m8i-vu { stroke-dashoffset: 0; }
  .m8i-etape { opacity: 0; transition: opacity 0.3s; }
  .m8i-etape.m8i-vu { opacity: 1; transition: opacity 0.5s; }
  .m8i-etape.m8i-tard.m8i-vu { transition: opacity 0.3s 0.7s; }

  @media (prefers-reduced-motion: reduce) {
    .m8i-trace, .m8i-etape, .m8i-etape.m8i-vu, .m8i-etape.m8i-tard.m8i-vu, .m8i-coupe, .m8i-fl { transition: none; }
  }
</style>
