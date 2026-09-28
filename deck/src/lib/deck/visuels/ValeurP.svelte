<script>
  /**
   * La valeur p, sur l'exemple de la pomicultrice (Arel-Bundock 2021,
   * p. 70-71). La courbe est la loi de Student à 49 degrés de liberté :
   * la répartition des t qu'on obtiendrait si H₀ était vraie. On y pose
   * notre t, puis on colore tout ce qui est au moins aussi extrême.
   *
   *   0  La courbe, de t = −4 à t = 4 : « si H₀ était vraie, les t se
   *      répartiraient ainsi ».
   *   1  Notre t, en rouge, et son miroir gris de l'autre côté de zéro.
   *   2  Les deux queues au-delà de |t| se remplissent de rouge. La valeur p
   *      s'affiche, avec sa définition en une phrase : la probabilité d'un t
   *      au moins aussi extrême que le nôtre, si H₀ était vraie. Ce n'est
   *      PAS la probabilité que H₀ soit vraie.
   *   3  La même valeur dans R : la commande et sa sortie, telles que R les
   *      a imprimées.
   *
   * Les nombres : la courbe vient de STUDENT (t et densite, calculés par
   * dt() dans outils/seance5_data.R), notre t et p de POMMES, la commande et
   * sa sortie de CONSOLES.pvaleur. Les queues sont découpées dans les
   * tableaux de STUDENT, pas redessinées à la main.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES, STUDENT, CONSOLES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');

  // t de −4 à 4 sur la largeur; la densité sur la hauteur.
  const X = (t) => 500 + t * 105;
  const YB = 260;
  const DMAX = Math.max(...STUDENT.densite);
  const Y = (d) => YB - (d / DMAX) * 190;
  const PTS = STUDENT.t.map((t, i) => [X(t), Y(STUDENT.densite[i])]);
  const ligne = (pts) => pts.map(([x, y], i) => `${i ? 'L' : 'M'} ${x.toFixed(1)} ${y.toFixed(1)}`).join(' ');
  const COURBE = ligne(PTS);
  const AIRE = `${ligne([[X(STUDENT.t[0]), YB], ...PTS, [X(STUDENT.t.at(-1)), YB]])} Z`;

  // Les queues : les points de STUDENT au-delà de |notre t|, fermés sur l'axe.
  const T = Math.abs(POMMES.t);
  const EPS = 1e-9;
  const queue = (garder) => {
    const pts = PTS.filter((_, i) => garder(STUDENT.t[i]));
    return `${ligne([[pts[0][0], YB], ...pts, [pts.at(-1)[0], YB]])} Z`;
  };
  const GAUCHE = queue((t) => t <= -T + EPS);
  const DROITE = queue((t) => t >= T - EPS);

  const XT = X(POMMES.t);
  const XM = X(-POMMES.t);
  const TICKS = [-4, -3, -2, -1, 0, 1, 2, 3, 4];
  const R = CONSOLES.pvaleur[0];
</script>

<div class="visuel valeur-p" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="La loi de Student, de t = −4 à t = 4&#8239;: la répartition des t si H₀ était vraie. Notre t, {fr(POMMES.t, 2)}, en rouge, et son miroir à {fr(-POMMES.t, 2)}. Les deux queues au-delà sont en rouge&#8239;: p = {fr(POMMES.p, 3)}, la probabilité d’un t au moins aussi extrême que le nôtre, si H₀ était vraie. Dans R&#8239;: {R.in}, qui donne {R.out}.">
    <text x="500" y="32" class="vp-cadre">si H₀ était vraie, les t se répartiraient ainsi</text>

    <!-- La courbe de Student et son axe. -->
    <path d={AIRE} class="vp-aire" />
    <path d={GAUCHE} class="vp-queue" class:vp-vu={e >= 2} />
    <path d={DROITE} class="vp-queue" class:vp-vu={e >= 2} />
    <path d={COURBE} class="vp-courbe" />
    <line x1={X(-4)} y1={YB} x2={X(4)} y2={YB} class="vp-axe" />
    {#each TICKS as t}
      <line x1={X(t)} y1={YB} x2={X(t)} y2={YB + 7} class="vp-axe" />
      <text x={X(t)} y={YB + 30} class="vp-tick">{fr(t, 0)}</text>
    {/each}
    <text x="946" y={YB + 7} class="vp-nom">t</text>

    <!-- Temps 1 : notre t, et son miroir. -->
    <g class="vp-t" class:vp-vu={e >= 1}>
      <line x1={XM} y1={YB} x2={XM} y2="100" class="vp-miroir" />
      <text x={XM - 12} y="112" class="vp-miroir-t">{fr(-POMMES.t, 2)}</text>
      <line x1={XT} y1={YB} x2={XT} y2="100" class="vp-notre" />
      <text x={XT + 12} y="112" class="vp-notre-t">notre t&#8239;: {fr(POMMES.t, 2)}</text>
    </g>

    <!-- Temps 2 : la valeur p et sa définition. -->
    <g class="vp-p" class:vp-vu={e >= 2}>
      <text x="80" y="352" class="vp-nombre">p = {fr(POMMES.p, 3)}</text>
      <text x="420" y="324" class="vp-def">la probabilité d’un t au moins aussi</text>
      <text x="420" y="354" class="vp-def">extrême que le nôtre, si H₀ était vraie</text>
    </g>

    <!-- Temps 3 : la même chose dans R. -->
    <g class="vp-r" class:vp-vu={e >= 3}>
      <rect x="80" y="382" width="840" height="68" class="vp-puce" />
      <rect x="80" y="382" width="7" height="68" class="vp-regle" />
      <text x="104" y="409" class="vp-code"><tspan class="vp-chevron">&gt;</tspan> {R.in}</text>
      <text x="104" y="437" class="vp-sortie">{R.out}</text>
      <text x="902" y="409" class="vp-dansr">dans R</text>
    </g>
  </svg>
  <p class="vp-src">exemple fictif · Arel-Bundock (2021, p.&#8239;70-71)</p>
</div>

<style>
  .valeur-p { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .vp-cadre { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .vp-aire { fill: var(--dk-fond-2); }
  .vp-courbe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: round; }
  .vp-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .vp-tick { font-size: 19px; text-anchor: middle; fill: var(--dk-gris); }
  .vp-nom { font-size: 22px; font-style: italic; fill: var(--dk-gris); }

  .vp-queue { fill: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .vp-queue.vp-vu { opacity: 0.9; transition: opacity 0.6s 0.1s; }

  .vp-t { opacity: 0; transition: opacity 0.3s; }
  .vp-t.vp-vu { opacity: 1; }
  .vp-notre, .vp-miroir { transform-box: fill-box; transform-origin: bottom; transform: scaleY(0); transition: transform 0.5s cubic-bezier(0.34, 1.4, 0.64, 1); }
  .vp-t.vp-vu .vp-notre, .vp-t.vp-vu .vp-miroir { transform: scaleY(1); }
  .vp-t.vp-vu .vp-miroir { transition-delay: 0.35s; }
  .vp-notre { stroke: var(--dk-accent); stroke-width: 5; }
  .vp-miroir { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 6; }
  .vp-notre-t { font-size: 24px; font-weight: 600; fill: var(--dk-accent); }
  .vp-miroir-t { font-size: 20px; text-anchor: end; fill: var(--dk-gris); }

  .vp-p { opacity: 0; transform: translateY(8px); transition: opacity 0.3s, transform 0.3s; }
  .vp-p.vp-vu { opacity: 1; transform: none; transition: opacity 0.5s 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.4s; }
  .vp-nombre { font-size: 56px; font-weight: 600; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .vp-def { font-size: 22px; fill: var(--dk-encre); }

  .vp-r { opacity: 0; transition: opacity 0.3s; }
  .vp-r.vp-vu { opacity: 1; transition: opacity 0.5s; }
  .vp-puce { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .vp-regle { fill: var(--dk-accent); }
  .vp-code { font-size: 20px; fill: var(--dk-encre); white-space: pre; }
  .vp-chevron { fill: var(--dk-accent); font-weight: 600; }
  .vp-sortie { font-size: 20px; fill: var(--dk-gris); white-space: pre; }
  .vp-dansr { font-size: 18px; text-anchor: end; fill: var(--dk-gris); letter-spacing: 0.06em; }

  .vp-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .vp-queue, .vp-queue.vp-vu, .vp-t, .vp-notre, .vp-miroir, .vp-t.vp-vu .vp-notre, .vp-t.vp-vu .vp-miroir,
    .vp-p, .vp-p.vp-vu, .vp-r, .vp-r.vp-vu { transition: none; }
  }
</style>
