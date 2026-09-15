<script>
  /**
   * L'âge des 20 180 répondant.e.s de l'Étude électorale canadienne 2025,
   * des points à la boîte à moustaches. Chaque point est un centile réel
   * (quantile(age, 0:100 / 100), src/lib/data/seance3.js) ; la boîte vient
   * de ggplot_build() de geom_boxplot().
   *
   *   0  Les 101 points tombent sur l'axe, du plus jeune au plus âgé.
   *   1  Quatre groupes de 25 % en alternance, trois séparateurs rouges
   *      tombent : Q1, médiane, Q3.
   *   2  Une accolade rouge de Q1 à Q3 : l'écart interquartile.
   *   3  Les points s'aplatissent sur une ligne et la boîte se dessine,
   *      moustaches comprises. L'étiquette geom_boxplot() apparaît.
   */
  import { brancherTemps } from '../temps.js';
  import { AGE, AGE_BOITE, AGE_CENTILES } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const X0 = 80, X1 = 920, BASE = 270, YBOITE = 190;
  const x = (v) => X0 + ((v - 15) / 85) * (X1 - X0);

  // Empilement déterministe : une valeur à moins de 0,9 an du début de la
  // colonne courante monte d'un cran dans cette colonne.
  const POINTS = [];
  {
    let debut = -Infinity;
    let k = 0;
    AGE_CENTILES.forEach((v, i) => {
      if (v - debut <= 0.9) k++;
      else { debut = v; k = 0; }
      POINTS.push({ i, cx: x(debut), k, g: i < 25 ? 0 : i < 50 ? 1 : i < 75 ? 2 : 3 });
    });
  }
  const [qmin, q1, med, q3, qmax] = AGE.quartiles;
  const SEPARATEURS = [
    { v: q1, t: `Q1 · ${q1}` },
    { v: med, t: `médiane · ${med}` },
    { v: q3, t: `Q3 · ${q3}` }
  ];
  const bornes = [qmin, q1, med, q3, qmax];
  const n = AGE.n.toLocaleString('fr-CA');
  const B = AGE_BOITE;
</script>

<div class="visuel quartiles" bind:this={hote}>
  <svg viewBox="0 0 1000 370" role="img" aria-label="L'âge des répondant.e.s de l'Étude électorale canadienne 2025 en 101 centiles : quartiles à 35, 50 et 64 ans, écart interquartile de 29 ans, puis la boîte à moustaches de 18 à 96 ans.">
    <text x={X0} y="28" class="note">1 point = 1 % des répondant.e.s · {n} personnes</text>

    <!-- La boîte, dessinée au dernier temps. -->
    <g class="boite" class:vu={e >= 3}>
      <path d="M {x(B.q1)} {YBOITE - 26} H {x(B.q3)} V {YBOITE + 26} H {x(B.q1)} Z" pathLength="1" class="cadre" />
      <path d="M {x(B.min)} {YBOITE} H {x(B.q1)}" pathLength="1" class="moust" />
      <path d="M {x(B.q3)} {YBOITE} H {x(B.max)}" pathLength="1" class="moust" />
      <path d="M {x(B.min)} {YBOITE - 14} V {YBOITE + 14} M {x(B.max)} {YBOITE - 14} V {YBOITE + 14}" class="cap" />
      <line x1={x(B.med)} y1={YBOITE - 32} x2={x(B.med)} y2={YBOITE + 32} class="med" />
      <text x={x(B.min) - 12} y={YBOITE + 6} class="bout d">{B.min}</text>
      <text x={x(B.max) + 12} y={YBOITE + 6} class="bout">{B.max}</text>
    </g>

    {#each POINTS as p}
      <g class="pt" style="transform: translate({p.cx}px, {e >= 3 ? YBOITE : BASE - 12 - p.k * 13}px); transition-delay: {e >= 3 ? p.i * 4 : 0}ms">
        <circle r="5.5" class="g{p.g}" class:groupe={e >= 1} class:efface={e >= 3} style="--d: {p.i * 16}ms" />
      </g>
    {/each}

    {#each SEPARATEURS as s, j}
      <g class="sep" class:vu={e >= 1} class:pale={e >= 3} style="transition-delay: {e >= 1 ? j * 150 : 0}ms">
        <line x1={x(s.v)} y1="92" x2={x(s.v)} y2={BASE} />
        <text x={x(s.v)} y="80">{s.t}</text>
      </g>
    {/each}
    {#each [0, 1, 2, 3] as g}
      <text x={(x(bornes[g]) + x(bornes[g + 1])) / 2} y="132" class="pct" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 450 + g * 90 : 0}ms">25 %</text>
    {/each}

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="axe" />
    {#each [20, 30, 40, 50, 60, 70, 80, 90, 100] as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 7} class="axe" />
      <text x={x(t)} y={BASE + 26} class="tick">{t}</text>
    {/each}
    <text x="975" y={BASE + 6} class="lab">Âge</text>

    <g class="eiq" class:vu={e >= 2}>
      <path d="M {x(q1)} 314 L {x(q1)} 327 L {x(q3)} 327 L {x(q3)} 314" pathLength="1" />
      <text x={(x(q1) + x(q3)) / 2} y="356">écart interquartile · {AGE.eiq} ans</text>
    </g>

    <g class="fn" class:vu={e >= 3}>
      <rect x="770" y="8" width="200" height="34" />
      <text x="870" y="31">geom_boxplot()</text>
    </g>
  </svg>
</div>

<style>
  .quartiles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .note { font-size: 15px; fill: var(--dk-gris); }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .lab { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .pt { transition: transform 0.7s cubic-bezier(0.5, 0, 0.3, 1.3); }
  .pt circle { fill: var(--dk-accent); transform-box: fill-box; transform-origin: center; animation: pluie 0.6s cubic-bezier(0.3, 1.4, 0.6, 1) both; animation-delay: var(--d); transition: fill 0.4s, opacity 0.5s; }
  .pt circle.groupe.g0, .pt circle.groupe.g2 { fill: var(--dk-encre); }
  .pt circle.groupe.g1, .pt circle.groupe.g3 { fill: var(--dk-gris-2); }
  .pt circle.efface { opacity: 0.2; }
  @keyframes pluie { from { transform: translateY(-260px); opacity: 0; } 40% { opacity: 1; } to { transform: none; opacity: 1; } }

  .sep { opacity: 0; transform: translateY(-40px); transition: opacity 0.35s, transform 0.55s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .sep.vu { opacity: 1; transform: none; }
  .sep line { stroke: var(--dk-accent); stroke-width: 4; transition: opacity 0.4s; }
  .sep.pale line { opacity: 0.25; }
  .sep text { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .pct { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .pct.vu { opacity: 1; }

  .eiq path { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .eiq.vu path { stroke-dashoffset: 0; }
  .eiq text { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.5s; }
  .eiq.vu text { opacity: 1; }

  .boite .cadre { fill: var(--dk-fond-2); fill-opacity: 0; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out 0.5s, fill-opacity 0.4s 1.1s; }
  .boite .moust { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.6s ease-out 1.2s; }
  .boite .cap { stroke: var(--dk-encre); stroke-width: 3; opacity: 0; transition: opacity 0.3s 1.7s; }
  .boite .med { stroke: var(--dk-accent); stroke-width: 7; opacity: 0; transition: opacity 0.3s 1s; }
  .boite .bout { font-size: 18px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s 1.8s; }
  .boite .bout.d { text-anchor: end; }
  .boite.vu .cadre { stroke-dashoffset: 0; fill-opacity: 1; }
  .boite.vu .moust { stroke-dashoffset: 0; }
  .boite.vu .cap, .boite.vu .med, .boite.vu .bout { opacity: 1; }

  .fn { opacity: 0; transform: translateY(-8px); transition: opacity 0.4s 1.9s, transform 0.4s 1.9s; }
  .fn.vu { opacity: 1; transform: none; }
  .fn rect { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 2.5; }
  .fn text { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .pt circle { animation: none; }
    .pt, .sep, .eiq path, .eiq text, .boite *, .fn { transition: none; }
  }
</style>
