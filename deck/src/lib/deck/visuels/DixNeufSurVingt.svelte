<script>
  /**
   * « 19 fois sur 20 » : la marge d'erreur d'un sondage, sur de vraies
   * données. Les répondant.e.s de l'Étude électorale canadienne 2025 qui
   * déclarent un parti servent de population : on connaît la vraie part
   * libérale. On y tire des sondages de 1 000 personnes (SONDAGE, dans
   * src/lib/data/seance5_normale.js, outils/seance5_normale.R, qui calcule
   * aussi chaque marge d'erreur).
   *
   *   0  Le premier sondage, écrit comme dans un journal : la part, la marge,
   *      « 19 fois sur 20 ».
   *   1  Sa fourchette, sur un axe en pourcentage.
   *   2  La vraie valeur, qu'on connaît ici : dans la fourchette.
   *   3  Dix-neuf autres sondages, tirés de la même façon. Ceux qui ratent
   *      la vraie valeur seraient en rouge; le compte est lu dans les données.
   *   4  La phrase : la méthode se trompe environ une fois sur 20.
   *
   * Jamais « 95 % de chances » : c'est la méthode qui a raison 19 fois sur 20.
   */
  import { brancherTemps } from '../temps.js';
  import { SONDAGE } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const P0 = 38, P1 = 56, X0 = 90, X1 = 930;
  const x = (p) => X0 + ((p * 100 - P0) / (P1 - P0)) * (X1 - X0);
  const S = SONDAGE.sondages;
  const PREMIER = S[0];
  const Y1 = 170, PAS = 11, AXE = Y1 + 20 * PAS + 18;
  const XV = x(SONDAGE.vrai);
  const ticks = [40, 45, 50, 55];
</script>

<div class="visuel dix-neuf" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Un sondage de {f(SONDAGE.n)} personnes : Parti libéral {f(PREMIER.p * 100, 1)} %, marge d’erreur de plus ou moins {f(PREMIER.marge * 100, 1)} points, 19 fois sur 20. La vraie valeur, {f(SONDAGE.vrai * 100, 1)} %, est dans la fourchette. Sur 20 sondages, {SONDAGE.couvrent} l’attrapent.">
    <!-- 0 : le sondage, comme dans le journal. -->
    <rect x={X0} y="18" width={X1 - X0} height="92" class="ds-carte" />
    <text x={X0 + 24} y="56" class="ds-une">Sondage de {f(SONDAGE.n)} personnes&#8239;: Parti libéral <tspan class="ds-rouge">{f(PREMIER.p * 100, 1)}&#8239;%</tspan></text>
    <text x={X0 + 24} y="92" class="ds-sous">marge d’erreur de ±&#8239;{f(PREMIER.marge * 100, 1)} points, <tspan class="ds-gras">19 fois sur 20</tspan></text>

    <!-- 1 : la fourchette du premier sondage. -->
    <g class="ds-etape" class:ds-vu={e >= 1}>
      <line x1={x(PREMIER.p - PREMIER.marge)} y1={Y1} x2={x(PREMIER.p + PREMIER.marge)} y2={Y1} class="ds-fourchette ds-premier" class:ds-mince={e >= 3} />
      <circle cx={x(PREMIER.p)} cy={Y1} r={e >= 3 ? 4 : 9} class="ds-point" />
      <text x={x(PREMIER.p + PREMIER.marge) + 16} y={Y1 + 8} class="ds-lab" class:ds-cache={e >= 3}>la fourchette</text>
    </g>

    <!-- 2 : la vraie valeur. -->
    <g class="ds-etape" class:ds-vu={e >= 2}>
      <line x1={XV} y1={Y1 - 30} x2={XV} y2={AXE} class="ds-vrai" />
      <text x={XV} y={Y1 - 40} class="ds-vrai-t">la vraie valeur&#8239;: {f(SONDAGE.vrai * 100, 1)}&#8239;%</text>
    </g>

    <!-- 3 : dix-neuf autres sondages. -->
    {#each S.slice(1) as s, i}
      <g class="ds-etape" class:ds-vu={e >= 3} style="transition-delay: {e >= 3 ? i * 60 : 0}ms">
        <line x1={x(s.p - s.marge)} y1={Y1 + (i + 1) * PAS} x2={x(s.p + s.marge)} y2={Y1 + (i + 1) * PAS} class="ds-fourchette ds-mince" class:ds-rate={!s.couvre} />
        <circle cx={x(s.p)} cy={Y1 + (i + 1) * PAS} r="4" class="ds-point" class:ds-rate-p={!s.couvre} />
      </g>
    {/each}
    <text x={X1} y={Y1 - 40} class="ds-compte ds-etape" class:ds-vu={e >= 3}>ici&#8239;: {SONDAGE.couvrent} sur 20</text>

    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="ds-axe" />
    {#each ticks as t}
      <line x1={x(t / 100)} y1={AXE} x2={x(t / 100)} y2={AXE + 8} class="ds-axe" />
      <text x={x(t / 100)} y={AXE + 30} class="ds-tick">{t}&#8239;%</text>
    {/each}

    <!-- 4 : la phrase. -->
    <text x="500" y="478" class="ds-phrase ds-etape" class:ds-vu={e >= 4}>19 fois sur 20&#8239;: la méthode se trompe environ une fois sur 20.</text>
  </svg>
</div>

<style>
  .dix-neuf { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ds-carte { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .ds-une { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .ds-sous { font-size: 22px; fill: var(--dk-encre); }
  .ds-gras { font-weight: 600; }
  .ds-rouge { fill: var(--dk-accent); }
  .ds-fourchette { stroke: var(--dk-encre); stroke-width: 10; transition: stroke-width 0.4s; }
  .ds-fourchette.ds-premier { stroke: var(--dk-accent); }
  .ds-fourchette.ds-mince { stroke-width: 4; }
  .ds-fourchette.ds-rate { stroke: var(--dk-accent); }
  .ds-point { fill: var(--dk-encre); transition: r 0.4s; }
  .ds-rate-p { fill: var(--dk-accent); }
  .ds-lab { font-size: 22px; font-weight: 600; fill: var(--dk-accent); transition: opacity 0.3s; }
  .ds-lab.ds-cache { opacity: 0; }
  .ds-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .ds-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ds-compte { font-size: 24px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .ds-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ds-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-phrase { font-size: 25px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ds-etape { opacity: 0; transition: opacity 0.3s; }
  .ds-etape.ds-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ds-etape, .ds-etape.ds-vu, .ds-fourchette, .ds-point, .ds-lab { transition: none; }
  }
</style>
