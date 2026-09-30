<script>
  /**
   * « 19 fois sur 20 » : la marge d'erreur d'un sondage, sur de vraies
   * données. Les répondant.e.s de l'Étude électorale canadienne 2025 qui
   * déclarent un parti servent de population : ici, on connaît la vraie
   * part libérale, le sondeur non. On y tire des sondages de 1 000 personnes
   * (SONDAGE, dans src/lib/data/seance5_normale.js; outils/seance5_normale.R
   * calcule chaque marge d'erreur et documente la graine).
   *
   *   0  La vraie réponse, qu'on connaît ici : une ligne pointillée.
   *   1  Un sondage de 1 000 personnes : un point. Proche, pas pareil.
   *   2  Sa marge d'erreur : la fourchette. Elle attrape la vraie réponse.
   *      Dessous, la phrase telle qu'on la lit dans le journal.
   *   3  On refait le sondage 20 fois : 20 fourchettes. Celle qui rate est
   *      en rouge, avec la raison (trop ou pas assez de libéraux, par hasard).
   *   4  La phrase : 19 fois sur 20, la fourchette attrape la vraie réponse.
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
  const pc = (p) => f(p * 100, 1);
  const P0 = 38, P1 = 56, X0 = 90, X1 = 930;
  const x = (p) => X0 + ((p * 100 - P0) / (P1 - P0)) * (X1 - X0);
  const S = SONDAGE.sondages;
  const PREMIER = S[0];
  const XV = x(SONDAGE.vrai);
  // Étape 1-2 : le premier sondage, en grand. Étape 3 : vingt rangées serrées.
  const YU = 200;
  const Y1 = 118, PAS = 12.5, AXE = Y1 + 19 * PAS + 26;
  const yRang = (i) => Y1 + i * PAS;
  const RATE = S.findIndex((s) => !s.couvre);
  const trop = RATE >= 0 && S[RATE].p > SONDAGE.vrai;
  const ticks = [40, 45, 50, 55];
</script>

<div class="visuel dix-neuf" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Parmi les {f(SONDAGE.population)} répondant.e.s qui déclarent un parti, la vraie part libérale est de {pc(SONDAGE.vrai)} %. Un sondage de {f(SONDAGE.n)} personnes trouve {pc(PREMIER.p)} %, avec une marge d’erreur de plus ou moins {pc(PREMIER.marge)} points : sa fourchette attrape la vraie réponse. Sur 20 sondages, {SONDAGE.couvrent} l’attrapent.">
    <!-- 0 : la vraie réponse. -->
    <line x1={XV} y1="70" x2={XV} y2={AXE} class="ds-vrai" />
    <text x={XV} y="36" class="ds-vrai-t">la vraie réponse&#8239;: {pc(SONDAGE.vrai)}&#8239;%</text>
    <text x={XV} y="60" class="ds-vrai-s">les {f(SONDAGE.population)} (ici, on la connaît. Le sondeur, non.)</text>

    <!-- 1-2 : un sondage, en grand. -->
    <g class="ds-seul" class:ds-vu={e >= 1 && e < 3}>
      <!-- Des fonds couleur papier : la ligne de la vraie réponse passe derrière le texte. -->
      <rect x={X0 - 8} y={YU - 74} width="560" height="42" class="ds-fond" />
      <rect x={X0 - 8} y={YU + 84} width="840" height="70" class="ds-fond ds-etape" class:ds-vu={e >= 2} />
      <rect x={x(PREMIER.p) - 72} y={YU + 50} width="144" height="28" class="ds-fond ds-etape" class:ds-vu={e >= 2} />
      <text x={X0} y={YU - 44} class="ds-lab">un sondage de {f(SONDAGE.n)} personnes&#8239;: <tspan class="ds-rouge">{pc(PREMIER.p)}&#8239;%</tspan></text>
      <line x1={x(PREMIER.p - PREMIER.marge)} y1={YU} x2={x(PREMIER.p + PREMIER.marge)} y2={YU} class="ds-fourchette ds-grosse" class:ds-vu={e >= 2} />
      <circle cx={x(PREMIER.p)} cy={YU} r="11" class="ds-point-g" />
      <g class="ds-etape" class:ds-vu={e >= 2}>
        <text x={x(PREMIER.p - PREMIER.marge)} y={YU + 42} class="ds-borne">{pc(PREMIER.p - PREMIER.marge)}</text>
        <text x={x(PREMIER.p + PREMIER.marge)} y={YU + 42} class="ds-borne">{pc(PREMIER.p + PREMIER.marge)}</text>
        <text x={x(PREMIER.p)} y={YU + 70} class="ds-borne ds-marge">± {pc(PREMIER.marge)} points</text>
        <text x={X0} y={YU + 110} class="ds-journal">Dans le journal&#8239;: «&#8239;{pc(PREMIER.p)}&#8239;%, marge d’erreur de ±&#8239;{pc(PREMIER.marge)} points, 19 fois sur 20&#8239;»</text>
        <text x={X0} y={YU + 142} class="ds-journal-s">La vraie réponse est probablement dans la fourchette.</text>
      </g>
    </g>

    <!-- 3 : vingt sondages. -->
    {#each S as s, i}
      <g class="ds-etape" class:ds-vu={e >= 3} style="transition-delay: {e >= 3 ? i * 50 : 0}ms">
        <line x1={x(s.p - s.marge)} y1={yRang(i)} x2={x(s.p + s.marge)} y2={yRang(i)} class="ds-fourchette" class:ds-rate={!s.couvre} />
        <circle cx={x(s.p)} cy={yRang(i)} r="4.5" class="ds-point" class:ds-rate-p={!s.couvre} />
      </g>
    {/each}
    <g class="ds-etape" class:ds-vu={e >= 3}>
      <text x={X0 - 12} y={yRang(0) + 6} class="ds-rang">1</text>
      <text x={X0 - 12} y={yRang(19) + 6} class="ds-rang">20</text>
      {#if RATE >= 0}
        <text x={x(S[RATE].p + S[RATE].marge) + 14} y={yRang(RATE) - 4} class="ds-pourquoi">celui-ci rate&#8239;: par hasard,</text>
        <text x={x(S[RATE].p + S[RATE].marge) + 14} y={yRang(RATE) + 20} class="ds-pourquoi">{trop ? 'trop' : 'pas assez'} de libéraux tirés</text>
      {/if}
    </g>

    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="ds-axe" />
    {#each ticks as t}
      <line x1={x(t / 100)} y1={AXE} x2={x(t / 100)} y2={AXE + 8} class="ds-axe" />
      <text x={x(t / 100)} y={AXE + 30} class="ds-tick">{t}&#8239;%</text>
    {/each}

    <!-- 4 : la phrase. -->
    <text x="500" y="488" class="ds-phrase ds-etape" class:ds-vu={e >= 4}>{SONDAGE.couvrent} fois sur 20, la fourchette attrape la vraie réponse. Une fois, elle rate.</text>
  </svg>
</div>

<style>
  .dix-neuf { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .ds-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .ds-vrai-t { font-size: 25px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ds-vrai-s { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-lab { font-size: 25px; font-weight: 600; fill: var(--dk-encre); }
  .ds-fond { fill: var(--dk-fond); }
  .ds-rouge { fill: var(--dk-accent); }
  .ds-fourchette { stroke: var(--dk-encre); stroke-width: 4; }
  .ds-fourchette.ds-grosse { stroke: var(--dk-accent); stroke-width: 12; opacity: 0; transition: opacity 0.4s; }
  .ds-fourchette.ds-grosse.ds-vu { opacity: 1; }
  .ds-fourchette.ds-rate { stroke: var(--dk-accent); stroke-width: 6; }
  .ds-point { fill: var(--dk-encre); }
  .ds-point-g { fill: var(--dk-encre); }
  .ds-rate-p { fill: var(--dk-accent); }
  .ds-borne { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-marge { font-weight: 600; fill: var(--dk-accent); }
  .ds-journal { font-size: 21px; fill: var(--dk-encre); }
  .ds-journal-s { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .ds-rang { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .ds-pourquoi { font-size: 19px; font-weight: 600; fill: var(--dk-accent); }
  .ds-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ds-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-phrase { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ds-seul { opacity: 0; transition: opacity 0.3s; }
  .ds-seul.ds-vu { opacity: 1; transition: opacity 0.5s; }
  .ds-etape { opacity: 0; transition: opacity 0.3s; }
  .ds-etape.ds-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ds-seul, .ds-seul.ds-vu, .ds-etape, .ds-etape.ds-vu, .ds-fourchette.ds-grosse { transition: none; }
  }
</style>
