<script>
  /**
   * « 19 fois sur 20 » : la marge d'erreur d'un sondage, lue dans le journal
   * puis décodée morceau par morceau, sur de vraies données. Fil rouge :
   * « Notre budget : 1 000 personnes ». Les répondant.e.s de l'Étude
   * électorale canadienne 2025 qui déclarent un parti servent de population
   * d'exercice : ici, on connaît la vraie part conservatrice (BUDGET.vrai),
   * le sondeur non. On y tire 20 sondages de 1 000 personnes au hasard
   * (SONDAGES, dans src/lib/data/seance5_budget.js). outils/seance5_budget.R
   * calcule chaque marge d'erreur et documente la graine (SONDAGES.graine),
   * choisie pour qu'exactement un sondage sur 20 rate la vraie part : le
   * « 19 sur 20 » net n'est pas un hasard de la simulation.
   *
   * En haut, la coupure de journal, qui reste là. Le morceau qu'on décode
   * passe au rouge.
   *   0  La coupure seule : « Conservateurs : 31,3 % / marge d'erreur de
   *      ± 2,9 points, 19 fois sur 20 » (le premier sondage,
   *      SONDAGES.sondages[0]).
   *   1  « 31,3 % » : un point sur l'axe, ce que disent les 1 000 sondé.e.s.
   *   2  « ± 2,9 points » : la règle de la diapo précédente, posée sur
   *      31,3 %. Une fourchette rouge, avec ses deux bornes.
   *   3  La vraie réponse (33,1 %), qu'on connaît ici et pas le sondeur : une
   *      ligne pointillée. La fourchette l'attrape.
   *   4  « 19 fois sur 20 » : on refait le sondage 20 fois. Vingt fourchettes,
   *      celle du journal en premier. Celle qui rate est en rouge, son
   *      étiquette du côté opposé à la vraie réponse pour ne pas croiser la
   *      ligne pointillée.
   *   5  La phrase : c'est la méthode qui attrape la vraie réponse 19 fois
   *      sur 20, pas ce sondage-là.
   *
   * Jamais « 95 % de chances » : c'est la méthode qui a raison 19 fois sur 20.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, SONDAGES } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, '\u202F');
  const pc = (p) => f(p * 100, 1);
  const P0 = 24, P1 = 42, X0 = 90, X1 = 930;
  const x = (p) => X0 + ((p * 100 - P0) / (P1 - P0)) * (X1 - X0);
  const S = SONDAGES.sondages;
  const PREMIER = S[0];
  const VRAI = BUDGET.vrai;
  const COUVRENT = S.filter((s) => s.couvre).length;
  const XV = x(VRAI);
  const XP = x(PREMIER.p);
  const XG = x(PREMIER.p - PREMIER.marge), XD = x(PREMIER.p + PREMIER.marge);

  // Temps 1 à 3 : le premier sondage, en grand. Temps 4 : vingt rangées serrées.
  const YU = 222;
  const Y1 = 158, PAS = 13, AXE = Y1 + 19 * PAS + 16;
  const yRang = (i) => Y1 + i * PAS;
  const RATE = S.findIndex((s) => !s.couvre);
  // L'étiquette du sondage qui rate, du côté opposé à la vraie réponse : elle ne croise pas la ligne pointillée.
  const RATE_G = RATE >= 0 && S[RATE].p < VRAI;
  const XRATE = RATE < 0 ? 0 : RATE_G ? x(S[RATE].p - S[RATE].marge) - 14 : x(S[RATE].p + S[RATE].marge) + 14;
  const ticks = [25, 30, 35, 40];

  // Largeurs des fonds couleur papier (Plex Mono : 0,6 em par glyphe).
  const larg = (t, taille) => t.length * 0.6 * taille + 20;
  const T1 = `ce que disent les ${f(BUDGET.n)} sondé.e.s`;
  const T2 = `la règle de la marge d’erreur, posée sur ${pc(PREMIER.p)} %`;
</script>

<div class="visuel dix-neuf" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Dans le journal&#8239;: conservateurs {pc(PREMIER.p)}&#8239;%, marge d’erreur de plus ou moins {pc(PREMIER.marge)} points, 19 fois sur 20. {pc(PREMIER.p)}&#8239;%, c’est ce que disent les {f(BUDGET.n)} personnes sondées. Plus ou moins {pc(PREMIER.marge)} points, c’est une fourchette de {pc(PREMIER.p - PREMIER.marge)} à {pc(PREMIER.p + PREMIER.marge)}&#8239;%. La vraie part conservatrice, qu’on connaît ici et pas le sondeur, est de {pc(VRAI)}&#8239;%&#8239;: la fourchette l’attrape. On refait le sondage {S.length} fois&#8239;: {COUVRENT} fourchettes sur {S.length} attrapent la vraie réponse. C’est la méthode qui a raison 19 fois sur 20.">

    <!-- La coupure de journal. Le morceau décodé passe au rouge. -->
    <rect x="90" y="8" width="820" height="100" class="ds-coupure" />
    <text x="106" y="32" class="ds-journal-t">dans le journal</text>
    <text x="500" y="66" class="ds-titre">Conservateurs&#8239;: <tspan class="ds-morceau" class:ds-on={e === 1}>{pc(PREMIER.p)}&#8239;%</tspan></text>
    <text x="500" y="96" class="ds-sous">marge d’erreur de <tspan class="ds-morceau" class:ds-on={e === 2}>±&#8239;{pc(PREMIER.marge)} points</tspan>, <tspan class="ds-morceau" class:ds-on={e >= 4}>19 fois sur 20</tspan></text>

    <!-- 3 et plus : la vraie réponse, qu'on connaît ici. -->
    <g class="ds-etape" class:ds-vu={e >= 3}>
      <line x1={XV} y1="144" x2={XV} y2={AXE} class="ds-vrai" />
      <text x={XV} y="136" class="ds-vrai-t">la vraie réponse&#8239;: {pc(VRAI)}&#8239;%</text>
    </g>

    <!-- 1 à 3 : un sondage, en grand. -->
    <g class="ds-seul" class:ds-vu={e >= 1 && e < 4}>
      <!-- Des fonds couleur papier : la ligne de la vraie réponse passe derrière le texte. -->
      <rect x={XP - larg(T1, 21) / 2} y={YU - 52} width={larg(T1, 21)} height="30" class="ds-fond" />
      <text x={XP} y={YU - 30} class="ds-lab">{T1}</text>
      <line x1={XG} y1={YU} x2={XD} y2={YU} class="ds-fourchette ds-grosse" class:ds-vu={e >= 2} />
      <circle cx={XP} cy={YU} r="11" class="ds-point-g" />
      <g class="ds-etape" class:ds-vu={e >= 2}>
        <line x1={XG} y1={YU - 14} x2={XG} y2={YU + 14} class="ds-borne-l" />
        <line x1={XD} y1={YU - 14} x2={XD} y2={YU + 14} class="ds-borne-l" />
        <text x={XG} y={YU + 40} class="ds-borne">{pc(PREMIER.p - PREMIER.marge)}</text>
        <text x={XD} y={YU + 40} class="ds-borne">{pc(PREMIER.p + PREMIER.marge)}</text>
        <rect x={XP - larg(T2, 20) / 2} y={YU + 56} width={larg(T2, 20)} height="30" class="ds-fond" />
        <text x={XP} y={YU + 78} class="ds-lab ds-lab-p">la règle de la marge d’erreur, posée sur {pc(PREMIER.p)}&#8239;%</text>
      </g>
      <g class="ds-etape" class:ds-vu={e >= 3}>
        <text x={XV - 16} y={YU + 128} class="ds-connu">ici, on la connaît.</text>
        <text x={XV - 16} y={YU + 154} class="ds-connu">Le sondeur, non.</text>
      </g>
    </g>

    <!-- 4 : vingt sondages. -->
    {#each S as s, i}
      <g class="ds-etape" class:ds-vu={e >= 4} style="transition-delay: {e >= 4 ? i * 50 : 0}ms">
        <line x1={x(s.p - s.marge)} y1={yRang(i)} x2={x(s.p + s.marge)} y2={yRang(i)} class="ds-fourchette" class:ds-rate={!s.couvre} />
        <circle cx={x(s.p)} cy={yRang(i)} r="4.5" class="ds-point" class:ds-rate-p={!s.couvre} />
      </g>
    {/each}
    <g class="ds-etape" class:ds-vu={e >= 4}>
      <text x={X0} y="214" class="ds-cote">{S.length} sondages</text>
      <text x={X0} y="240" class="ds-cote">de {f(BUDGET.n)}</text>
      <text x={x(S[0].p + S[0].marge) + 14} y={yRang(0) + 6} class="ds-notre">celui du journal</text>
      {#if RATE >= 0}
        <text x={XRATE} y={yRang(RATE) - 2} class="ds-pourquoi" class:ds-fin={RATE_G}>celui-ci rate,</text>
        <text x={XRATE} y={yRang(RATE) + 20} class="ds-pourquoi" class:ds-fin={RATE_G}>par hasard</text>
      {/if}
    </g>

    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="ds-axe" />
    {#each ticks as t}
      <line x1={x(t / 100)} y1={AXE} x2={x(t / 100)} y2={AXE + 8} class="ds-axe" />
      <text x={x(t / 100)} y={AXE + 30} class="ds-tick">{t}&#8239;%</text>
    {/each}

    <!-- 5 : la phrase. -->
    <text x="500" y="490" class="ds-phrase ds-etape" class:ds-vu={e >= 5}>C’est la méthode qui a raison 19 fois sur 20.</text>
  </svg>
</div>

<style>
  .dix-neuf { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .ds-coupure { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .ds-journal-t { font-size: 17px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .ds-titre { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ds-sous { font-size: 23px; text-anchor: middle; fill: var(--dk-encre); }
  .ds-morceau { transition: fill 0.4s; }
  .ds-morceau.ds-on { fill: var(--dk-accent); font-weight: 600; }
  .ds-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .ds-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ds-connu { font-size: 20px; text-anchor: end; fill: var(--dk-gris); }
  .ds-lab { font-size: 21px; text-anchor: middle; fill: var(--dk-encre); }
  .ds-lab-p { font-size: 20px; fill: var(--dk-accent); }
  .ds-fond { fill: var(--dk-fond); }
  .ds-fourchette { stroke: var(--dk-encre); stroke-width: 4; }
  .ds-fourchette.ds-grosse { stroke: var(--dk-accent); stroke-width: 12; opacity: 0; transition: opacity 0.4s; }
  .ds-fourchette.ds-grosse.ds-vu { opacity: 1; }
  .ds-fourchette.ds-rate { stroke: var(--dk-accent); stroke-width: 6; }
  .ds-borne-l { stroke: var(--dk-accent); stroke-width: 4; }
  .ds-point { fill: var(--dk-encre); }
  .ds-point-g { fill: var(--dk-encre); }
  .ds-rate-p { fill: var(--dk-accent); }
  .ds-borne { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-cote { font-size: 20px; fill: var(--dk-gris); }
  .ds-notre { font-size: 18px; fill: var(--dk-gris); }
  .ds-pourquoi { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .ds-pourquoi.ds-fin { text-anchor: end; }
  .ds-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ds-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ds-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ds-seul { opacity: 0; transition: opacity 0.3s; }
  .ds-seul.ds-vu { opacity: 1; transition: opacity 0.5s; }
  .ds-etape { opacity: 0; transition: opacity 0.3s; }
  .ds-etape.ds-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ds-seul, .ds-seul.ds-vu, .ds-etape, .ds-etape.ds-vu, .ds-fourchette.ds-grosse, .ds-morceau { transition: none; }
  }
</style>
