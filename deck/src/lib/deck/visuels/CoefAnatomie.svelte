<script>
  /**
   * L'anatomie d'un graphique des coefficients, un morceau par clic, sur le
   * modèle simple de notre sondage (note_carney ~ gauche_droite, 783 cas
   * complets). Le morceau qu'on nomme est en rouge, les précédents restent
   * en encre.
   *
   *   0  Le dessin seul : un point, sa moustache, la ligne à 0, l'axe.
   *   1  Le point : le coefficient, −5,05.
   *   2  La moustache : l'intervalle de confiance à 95 % (la méthode qui
   *      attrape la vraie pente 19 fois sur 20, comme à la section d'avant).
   *   3  La ligne à 0 : H0, « aucun effet ».
   *   4  À gauche de 0 : négatif (la note baisse). À droite : positif.
   *   5  La distance à 0 : la taille de l'effet, en points de note (le
   *      thermomètre de Carney, 0 à 100), par cran de l'échelle gauche-droite.
   *
   * Les nombres viennent de NOTRE.coefs[1] (src/lib/data/seance7.js, généré
   * par outils/seance7_data.R). L'axe (−8 à +8) est celui de CoefDuTableau.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const C = NOTRE.coefs[1];

  const V0 = -8, V1 = 8, XL = 350, XR = 960;
  const x = (v) => XL + ((v - V0) / (V1 - V0)) * (XR - XL);
  const ticks = [-8, -4, 0, 4, 8];
  const X0 = x(0), XB = x(C.b), XG = x(C.bas), XD = x(C.haut);
  const YR = 290, AXE = 430, YDIST = 336;
</script>

<div class="visuel coef-ana" bind:this={hote}>
  <svg viewBox="0 0 1000 510" role="img" aria-label="Le graphique des coefficients, morceau par morceau. Le point est le coefficient, {f(C.b)}. La moustache est l’intervalle de confiance à 95&#8239;%, de {f(C.bas)} à {f(C.haut)}&#8239;: la méthode attrape la vraie pente 19 fois sur 20. La ligne à 0, c’est H0&#8239;: aucun effet. À gauche de 0, l’effet est négatif, la note baisse. À droite, il est positif. La distance à 0 donne la taille de l’effet&#8239;: environ 5 points de moins par cran vers la droite.">

    <!-- 4 : à gauche, négatif. À droite, positif. -->
    <g class="ca-etape" class:ca-vu={e >= 4} class:ca-ici={e === 4}>
      <text x={(XL + X0) / 2} y="150" class="ca-cote ca-signe">&#8592; négatif</text>
      <text x={(XL + X0) / 2} y="178" class="ca-cote-s">la note baisse</text>
      <text x={(X0 + XR) / 2} y="150" class="ca-cote ca-signe">positif &#8594;</text>
      <text x={(X0 + XR) / 2} y="178" class="ca-cote-s">la note monte</text>
    </g>

    <!-- 3 : la ligne à 0. -->
    <line x1={X0} y1="96" x2={X0} y2={AXE} class="ca-zero" class:ca-rouge-l={e === 3} />
    <g class="ca-etape" class:ca-vu={e >= 3} class:ca-ici={e === 3}>
      <text x={X0} y="78" class="ca-cote">0 = aucun effet (H0)</text>
    </g>

    <!-- L'axe, en points de note. -->
    <line x1={XL} y1={AXE} x2={XR} y2={AXE} class="ca-axe" class:ca-rouge-l={e === 4} />
    {#each ticks as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 9} class="ca-axe" />
      <text x={x(t)} y={AXE + 34} class="ca-tick">{f(t, 0)}</text>
    {/each}
    <text x={(XL + XR) / 2} y="502" class="ca-titre-axe">effet sur la note de Carney, en points</text>

    <!-- La rangée : la variable, sa moustache, son point. -->
    <text x="320" y={YR - 4} class="ca-lab">Position gauche-droite</text>
    <text x="320" y={YR + 22} class="ca-sous">(0 à 10)</text>
    <line x1={XG} y1={YR} x2={XD} y2={YR} class="ca-moustache" class:ca-rouge-l={e === 2} />
    <line x1={XG} y1={YR - 10} x2={XG} y2={YR + 10} class="ca-borne" class:ca-rouge-l={e === 2} />
    <line x1={XD} y1={YR - 10} x2={XD} y2={YR + 10} class="ca-borne" class:ca-rouge-l={e === 2} />
    <circle cx={XB} cy={YR} r="10" class="ca-point" class:ca-rouge-p={e === 1} />

    <!-- 1 : le point. -->
    <g class="ca-etape" class:ca-vu={e >= 1} class:ca-ici={e === 1}>
      <text x={XB} y="222" class="ca-cote-s ca-suit">le coefficient</text>
      <text x={XB} y="256" class="ca-cote ca-gros">{f(C.b)}</text>
    </g>

    <!-- 2 : la moustache. -->
    <g class="ca-etape" class:ca-vu={e >= 2} class:ca-ici={e === 2}>
      <line x1="424" y1="336" x2={XG + 8} y2={YR + 14} class="ca-renvoi" />
      <text x="416" y="346" class="ca-cote ca-fin">l’intervalle de confiance</text>
      <text x="416" y="374" class="ca-cote-s ca-fin ca-suit">à 95&#8239;% · 19 fois sur 20</text>
    </g>

    <!-- 5 : la distance à 0, en points de note. -->
    <g class="ca-etape" class:ca-vu={e >= 5} class:ca-ici={e === 5}>
      <line x1={XB} y1={YDIST} x2={X0} y2={YDIST} class="ca-dist" />
      <line x1={XB} y1={YDIST - 10} x2={XB} y2={YDIST + 10} class="ca-dist" />
      <line x1={X0} y1={YDIST - 10} x2={X0} y2={YDIST + 10} class="ca-dist" />
      <text x={X0 + 18} y={YDIST + 8} class="ca-cote ca-debut">5 points de moins</text>
      <text x={X0 + 18} y={YDIST + 36} class="ca-cote-s ca-debut ca-suit">par cran vers la droite</text>
    </g>
  </svg>
</div>

<style>
  .coef-ana { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .ca-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 7 6; transition: stroke 0.4s, stroke-width 0.4s; }
  .ca-axe { stroke: var(--dk-encre); stroke-width: 2; transition: stroke 0.4s; }
  .ca-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ca-titre-axe { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ca-lab { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .ca-sous { font-size: 19px; text-anchor: end; fill: var(--dk-gris); }
  .ca-point { fill: var(--dk-encre); transition: fill 0.4s; }
  .ca-moustache { stroke: var(--dk-encre); stroke-width: 6; transition: stroke 0.4s; }
  .ca-borne { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .ca-rouge-p { fill: var(--dk-accent); }
  .ca-zero.ca-rouge-l { stroke: var(--dk-accent); stroke-width: 4; }
  .ca-rouge-l { stroke: var(--dk-accent); }
  .ca-cote { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .ca-cote-s { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.4s; }
  .ca-gros { font-size: 28px; }
  .ca-fin { text-anchor: end; }
  .ca-debut { text-anchor: start; }
  .ca-ici .ca-cote, .ca-ici .ca-suit { fill: var(--dk-accent); }
  .ca-ici .ca-signe { fill: var(--dk-accent); }
  .ca-renvoi { stroke: var(--dk-gris); stroke-width: 2; }
  .ca-ici .ca-renvoi { stroke: var(--dk-accent); }
  .ca-dist { stroke: var(--dk-encre); stroke-width: 3; }
  .ca-ici .ca-dist { stroke: var(--dk-accent); }
  .ca-etape { opacity: 0; transition: opacity 0.3s; }
  .ca-etape.ca-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ca-etape, .ca-etape.ca-vu, .ca-zero, .ca-axe, .ca-point, .ca-moustache, .ca-borne, .ca-cote, .ca-cote-s { transition: none; }
  }
</style>
