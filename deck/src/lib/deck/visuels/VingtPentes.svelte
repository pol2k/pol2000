<script>
  /**
   * « 19 fois sur 20 », pour la pente : le miroir de DixNeufSurVingt (la
   * marge d'erreur, séance 5), même dessin, pour que la salle le
   * reconnaisse. Les 20 180 répondant.e.s de la CES 2025 sont la population
   * d'exercice : on y connaît la vraie pente (POP.b1, +0,17), R non. On y
   * tire 20 sondages de 1 000 personnes au hasard (VINGT.sondages, dans
   * src/lib/data/seance7.js); le premier est NOTRE sondage. Pour les 19
   * autres, outils/seance7_data.R prend la première graine à partir de 70
   * qui donne exactement un raté sur 20 (VINGT.graine, 70) : le « 19 sur
   * 20 » net n'est pas un hasard de la simulation, il est choisi, et dit
   * comme tel au professeur (pas sur la diapo).
   *
   * En haut, l'encadré « dans R », qui reste là; le morceau qu'on décode
   * passe au rouge.
   *   0  L'encadré : notre pente et son intervalle de confiance à 95 %
   *      (NOTRE.coefs[1]). Dessous, en grand, notre fourchette.
   *   1  La vraie pente, +0,17, en pointillé : ici, on la connaît; R, non.
   *      La fourchette l'attrape.
   *   2  On refait le sondage 20 fois : vingt fourchettes, la nôtre en
   *      premier. Celle qui rate est en rouge, son étiquette du côté opposé
   *      à la vraie pente pour ne pas croiser la ligne pointillée.
   *   3  « 95 % » passe au rouge, et la phrase : c'est la méthode qui
   *      attrape la vraie pente 19 fois sur 20, pas ce sondage-là.
   *
   * Jamais « 95 % de chances » : c'est la méthode qui a raison 19 fois sur 20.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, POP, VINGT } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const N = ' ';
  const S = VINGT.sondages;
  const A = NOTRE.coefs[1];
  const VRAI = POP.b1;
  const COUVRENT = S.filter((s) => s.couvre).length;

  // L'axe des pentes, de −0,1 à +0,35 (de la place à gauche pour l'étiquette du raté).
  const P0 = -0.1, P1 = 0.35, X0 = 90, X1 = 930;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  const XV = x(VRAI);

  // Temps 0 et 1 : notre fourchette, en grand. Temps 2 : vingt rangées serrées.
  const YU = 232;
  const Y1 = 160, PAS = 13, AXE = Y1 + 19 * PAS + 16;
  const yRang = (i) => Y1 + i * PAS;
  const RATE = S.findIndex((s) => !s.couvre);
  // L'étiquette du raté, du côté opposé à la vraie pente.
  const RATE_G = RATE >= 0 && S[RATE].haut < VRAI;
  const XRATE = RATE < 0 ? 0 : RATE_G ? x(S[RATE].bas) - 14 : x(S[RATE].haut) + 14;
  const TICKS = [-0.1, 0, 0.1, 0.2, 0.3];
  const larg = (t, taille) => t.length * 0.6 * taille + 20;
  const T1 = `notre sondage au hasard, ${f(NOTRE.n, 0)} personnes`;
</script>

<div class="visuel vingt-pentes" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Dans R{N}: notre pente, {f(A.b)}, intervalle de confiance à 95{N}% de {f(A.bas)} à {f(A.haut)}. La vraie pente, qu’on connaît ici et pas R, est de {f(VRAI)}{N}: la fourchette l’attrape. On refait le sondage {S.length} fois{N}: {COUVRENT} fourchettes sur {S.length} attrapent la vraie pente. C’est la méthode qui a raison 19 fois sur 20.">

    <!-- L'encadré « dans R ». -->
    <rect x="90" y="8" width="820" height="100" class="vp-encadre" />
    <text x="106" y="32" class="vp-dansr">dans R · confint(modele)</text>
    <text x="500" y="66" class="vp-titre">notre pente&#8239;: {f(A.b)}</text>
    <text x="500" y="96" class="vp-sous">intervalle de confiance à <tspan class="vp-morceau" class:vp-on={e >= 3}>95&#8239;%</tspan>&#8239;: de {f(A.bas)} à {f(A.haut)}</text>

    <!-- 1 et plus : la vraie pente, qu'on connaît ici. -->
    <g class="vp-etape" class:vp-vu={e >= 1}>
      <line x1={XV} y1="146" x2={XV} y2={AXE} class="vp-vrai" />
      <text x={XV} y="138" class="vp-vrai-t">la vraie pente&#8239;: {f(VRAI)}</text>
    </g>

    <!-- 0 et 1 : notre fourchette, en grand. -->
    <g class="vp-seul" class:vp-vu={e < 2}>
      <rect x={x(A.b) - larg(T1, 21) / 2} y={YU - 54} width={larg(T1, 21)} height="30" class="vp-fond" />
      <text x={x(A.b)} y={YU - 32} class="vp-lab">{T1}</text>
      <line x1={x(A.bas)} y1={YU} x2={x(A.haut)} y2={YU} class="vp-fourchette vp-grosse" />
      <circle cx={x(A.b)} cy={YU} r="11" class="vp-point-g" />
      <line x1={x(A.bas)} y1={YU - 14} x2={x(A.bas)} y2={YU + 14} class="vp-borne-l" />
      <line x1={x(A.haut)} y1={YU - 14} x2={x(A.haut)} y2={YU + 14} class="vp-borne-l" />
      <text x={x(A.bas)} y={YU + 40} class="vp-borne">{f(A.bas)}</text>
      <text x={x(A.haut)} y={YU + 40} class="vp-borne">{f(A.haut)}</text>
      <g class="vp-etape" class:vp-vu={e >= 1}>
        <text x={XV + 16} y={YU + 96} class="vp-connu">Ici, on la connaît.</text>
        <text x={XV + 16} y={YU + 122} class="vp-connu">R, non.</text>
      </g>
    </g>

    <!-- 2 : vingt sondages. -->
    {#each S as s, i}
      <g class="vp-etape" class:vp-vu={e >= 2} style="transition-delay: {e >= 2 ? i * 50 : 0}ms">
        <line x1={x(s.bas)} y1={yRang(i)} x2={x(s.haut)} y2={yRang(i)} class="vp-fourchette" class:vp-rate={!s.couvre} />
        <circle cx={x(s.b1)} cy={yRang(i)} r="4.5" class="vp-point" class:vp-rate-p={!s.couvre} />
      </g>
    {/each}
    <g class="vp-etape" class:vp-vu={e >= 2}>
      <text x={X0} y="214" class="vp-cote">{S.length} sondages</text>
      <text x={X0} y="240" class="vp-cote">de {f(NOTRE.n, 0)}</text>
      <text x={x(S[0].haut) + 14} y={yRang(0) + 6} class="vp-notre">le nôtre</text>
      {#if RATE >= 0}
        <text x={XRATE} y={yRang(RATE) - 2} class="vp-pourquoi" class:vp-fin={RATE_G}>celui-ci rate,</text>
        <text x={XRATE} y={yRang(RATE) + 20} class="vp-pourquoi" class:vp-fin={RATE_G}>par hasard</text>
      {/if}
    </g>

    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="vp-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 8} class="vp-axe" />
      <text x={x(t)} y={AXE + 30} class="vp-tick">{t > 0 ? '+' : ''}{f(t, t === 0 ? 0 : 1)}</text>
    {/each}
    <text x={X1 + 12} y={AXE + 6} class="vp-tick vp-debut">pente</text>

    <!-- 3 : la phrase. -->
    <text x="500" y="490" class="vp-phrase vp-etape" class:vp-vu={e >= 3}>C’est la méthode qui attrape la vraie pente 19 fois sur 20.</text>
  </svg>
</div>

<style>
  .vingt-pentes { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .vp-encadre { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .vp-dansr { font-size: 17px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .vp-titre { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .vp-sous { font-size: 23px; text-anchor: middle; fill: var(--dk-encre); }
  .vp-morceau { transition: fill 0.4s; }
  .vp-morceau.vp-on { fill: var(--dk-accent); font-weight: 600; }
  .vp-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .vp-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .vp-connu { font-size: 20px; fill: var(--dk-gris); }
  .vp-lab { font-size: 21px; text-anchor: middle; fill: var(--dk-encre); }
  .vp-fond { fill: var(--dk-fond); }
  .vp-fourchette { stroke: var(--dk-encre); stroke-width: 4; }
  .vp-fourchette.vp-grosse { stroke: var(--dk-accent); stroke-width: 12; }
  .vp-fourchette.vp-rate { stroke: var(--dk-accent); stroke-width: 6; }
  .vp-borne-l { stroke: var(--dk-accent); stroke-width: 4; }
  .vp-point { fill: var(--dk-encre); }
  .vp-point-g { fill: var(--dk-encre); }
  .vp-rate-p { fill: var(--dk-accent); }
  .vp-borne { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .vp-cote { font-size: 20px; fill: var(--dk-gris); }
  .vp-notre { font-size: 18px; fill: var(--dk-gris); }
  .vp-pourquoi { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .vp-pourquoi.vp-fin { text-anchor: end; }
  .vp-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .vp-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .vp-tick.vp-debut { text-anchor: start; }
  .vp-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .vp-seul { opacity: 0; transition: opacity 0.3s; }
  .vp-seul.vp-vu { opacity: 1; transition: opacity 0.5s; }
  .vp-etape { opacity: 0; transition: opacity 0.3s; }
  .vp-etape.vp-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .vp-seul, .vp-seul.vp-vu, .vp-etape, .vp-etape.vp-vu, .vp-morceau { transition: none; }
  }
</style>
