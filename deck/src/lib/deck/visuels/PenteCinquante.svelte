<script>
  /**
   * Et avec un petit sondage ? 50 personnes tirées parmi les 20 180 (graine
   * 62); R en garde 21, celles qui ont répondu aux deux questions. Même
   * raisonnement qu'avec notre sondage : on mélange le populisme 1 000
   * fois, on compte les pentes au moins aussi loin de 0 que la sienne. Ici,
   * le compte n'est pas 0, et on ne rejette pas H0. Cinq temps.
   *
   *   0  Sa pente, H0.cinquante.coefs[1].b (−0,39), en rouge sur l'axe.
   *   1  Son monde où H0 est vraie : les 1 000 pentes des mélanges
   *      (H0.cinquante.pentes, tranches de 0,04). Une cloche bien plus large
   *      qu'avec notre sondage (écart type 0,21 contre 0,044).
   *   2  Les deux queues, au-delà de −0,39 et de +0,39, passent au rouge
   *      (« aussi loin de 0 » se compte des deux côtés, comme dans R). Le
   *      compte de R : H0.cinquante.aussi_loin (63) sur 1 000, « environ
   *      6 fois sur 100 », et la valeur p de R, 0,06
   *      (H0.cinquante.coefs[1].p) : la même, à l'arrondi près.
   *   3  La phrase du haut s'efface; en bas : plus de 5 fois sur 100 (de
   *      justesse), on ne rejette pas H0.
   *   4  Pourtant, ici, on connaît la vraie pente (POP.b1, −0,31, les
   *      20 180 comme population d'exercice) : H0 est fausse. Ne pas
   *      rejeter H0, ce n'est pas prouver H0 (le procès de la séance 5 :
   *      acquittée, pas innocente).
   *
   * Les tranches sont calculées ici à partir des 1 000 pentes de R; une
   * tranche passe au rouge si son centre est au moins aussi loin de 0 que
   * la pente (d'où un dessin proche du compte de R, qui est celui affiché).
   */
  import { brancherTemps } from '../temps.js';
  import { H0, POP } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const N = ' ';
  const C = H0.cinquante;
  const B = C.coefs[1].b, P = C.coefs[1].p, LOIN = C.aussi_loin;
  const TOUS = f(C.pentes.length, 0);
  const SUR100 = Math.round(LOIN / 10);
  const SEUIL = 5;
  // La valeur p comme R l'imprime (0.06), en français.
  const fp = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 3 });

  // L'axe des pentes, de −1 à +1.
  const P0 = -1, P1 = 1, X0 = 70, X1 = 930, BASE = 350, HAUT = 190;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  const L = 0.04;
  const tr = (p) => Math.floor(p / L + 1e-9);
  const T0 = tr(Math.min(...C.pentes));
  const COMPTES = new Array(tr(Math.max(...C.pentes)) - T0 + 1).fill(0);
  for (const p of C.pentes) COMPTES[tr(p) - T0]++;
  const MAX = Math.max(...COMPTES);
  const loin = (j) => Math.abs((T0 + j + 0.5) * L) >= Math.abs(B);
  const XB = x(B), XM = x(-B), XV = x(POP.b1);
  // L'étiquette de sa pente, sur un fond papier : la ligne de la vraie pente passe derrière.
  const LAB = `sa pente${N}: ${f(B)}`;
  const LARG = LAB.length * 0.6 * 21 + 8;

  const PHRASES = {
    0: [`Un petit sondage${N}: 50 tiré.e.s parmi les 20${N}180.`, `R en garde ${C.n_modele}. Sa pente${N}: ${f(B)}.`],
    1: [`Son monde où H0 est vraie${N}: ${TOUS} mélanges.`, `Avec ${C.n_modele} personnes, le hasard fait bouger la pente bien plus.`],
    2: [`Combien de mélanges vont aussi loin de 0${N}?`, '']
  };
</script>

<div class="visuel pente-cinquante" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Un petit sondage{N}: 50 personnes tirées parmi les 20 180, dont {C.n_modele} ont répondu aux deux questions. Sa pente{N}: {f(B)}. Dans son monde où H0 est vraie, les {TOUS} pentes des mélanges forment une cloche large. {LOIN} sur {TOUS} vont aussi loin de 0, environ {SUR100} fois sur 100. Dans R, p = {fp(P)}. C’est plus de {SEUIL} fois sur 100{N}: on ne rejette pas H0. Pourtant, la vraie pente est {f(POP.b1)}. Ne pas rejeter H0, ce n’est pas prouver H0.">
    <text x="990" y="20" class="cq-note">CES 2025 · un sondage de 50, mélangé {TOUS} fois</text>

    {#key e}
      {#if PHRASES[e]}
        <g class="cq-phrase">
          <text x="40" y="54" class="cq-titre">{PHRASES[e][0]}</text>
          <text x="40" y="88" class="cq-sous">{PHRASES[e][1]}</text>
        </g>
      {/if}
    {/key}

    <!-- 1 : la cloche; 2 : ses queues en rouge. -->
    <g class="cq-etape" class:cq-vu={e >= 1}>
      {#each COMPTES as c, j}
        {@const h = (c / MAX) * HAUT}
        <rect x={x((T0 + j) * L) + 0.5} y={BASE - h} width={x(L) - x(0) - 1} height={h} class="cq-baton" class:cq-rouge={e >= 2 && loin(j)} />
      {/each}
    </g>

    <!-- L'axe, et H0. -->
    <line x1={x(0)} y1="128" x2={x(0)} y2={BASE} class="cq-h0" />
    <text x={x(0)} y="120" class="cq-h0-t">H0</text>
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="cq-axe" />
    {#each [-1, -0.5, 0, 0.5, 1] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 8} class="cq-axe" />
      <text x={x(k)} y={BASE + 30} class="cq-tick" class:cq-zero={k === 0}>{k > 0 ? '+' : ''}{f(k, Number.isInteger(k) ? 0 : 1)}</text>
    {/each}
    <text x={X1} y={BASE + 56} class="cq-tick cq-fin">pente de la droite</text>

    <!-- 4 : la vraie pente, derrière l'étiquette de sa pente. -->
    <g class="cq-etape" class:cq-vu={e >= 4}>
      <line x1={XV} y1="118" x2={XV} y2={BASE} class="cq-vrai" />
      <text x={XV - 12} y="112" class="cq-vrai-t">la vraie pente&#8239;: {f(POP.b1)}</text>
    </g>

    <!-- 0 : sa pente. -->
    <line x1={XB} y1="140" x2={XB} y2={BASE} class="cq-notre" />
    <circle cx={XB} cy={BASE} r="10" class="cq-point" />
    <rect x={XB - 12 - LARG} y="140" width={LARG} height="28" class="cq-fond" />
    <text x={XB - 12} y="160" class="cq-lab cq-fin">{LAB}</text>

    <!-- 2 : le miroir et le compte. -->
    <g class="cq-etape" class:cq-vu={e >= 2}>
      <line x1={XM} y1="140" x2={XM} y2={BASE} class="cq-miroir" />
      <text x={XM + 12} y="160" class="cq-miroir-t">ou +{f(-B)}</text>
      <text x={XM + 12} y="200" class="cq-compte">{LOIN} sur {TOUS}</text>
      <text x={XM + 12} y="228" class="cq-lab-s">environ {SUR100} fois sur 100</text>
      <text x={XM + 12} y="256" class="cq-r">dans R&#8239;: p = {fp(P)}</text>
    </g>

    <!-- 3 : le verdict. -->
    <g class="cq-etape cq-apres" class:cq-vu={e >= 3}>
      <text x="40" y="440" class="cq-cours">Plus de {SEUIL} fois sur 100&#8239;: <tspan class="cq-rouge-t">on ne rejette pas H0.</tspan></text>
    </g>

    <!-- 4 : H0 est fausse, et on ne l'a pas rejetée. -->
    <g class="cq-etape" class:cq-vu={e >= 4}>
      <text x="40" y="478" class="cq-proces">Pourtant, H0 est fausse. Ne pas rejeter H0, ce n’est pas la prouver.</text>
      <text x="40" y="502" class="cq-proces-s">Au procès&#8239;: acquittée, pas innocente.</text>
    </g>
  </svg>
</div>

<style>
  .pente-cinquante { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .cq-note { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .cq-phrase { animation: cq-fondu 0.5s ease-out both; }
  @keyframes cq-fondu { from { opacity: 0; } to { opacity: 1; } }
  .cq-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .cq-sous { font-size: 21px; fill: var(--dk-gris); }
  .cq-baton { fill: var(--dk-encre); transition: fill 0.4s; }
  .cq-baton.cq-rouge { fill: var(--dk-accent); }
  .cq-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .cq-h0-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .cq-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .cq-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .cq-zero { font-weight: 600; fill: var(--dk-encre); }
  .cq-fin { text-anchor: end; }
  .cq-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .cq-point { fill: var(--dk-accent); }
  .cq-fond { fill: var(--dk-fond); }
  .cq-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .cq-miroir { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 6 6; }
  .cq-miroir-t { font-size: 18px; fill: var(--dk-gris); }
  .cq-compte { font-size: 32px; font-weight: 600; fill: var(--dk-accent); }
  .cq-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .cq-r { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .cq-cours { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .cq-rouge-t { fill: var(--dk-accent); }
  .cq-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 2 5; stroke-linecap: round; }
  .cq-vrai-t { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .cq-proces { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .cq-proces-s { font-size: 18px; fill: var(--dk-gris); }
  .cq-etape { opacity: 0; transition: opacity 0.2s; }
  .cq-etape.cq-vu { opacity: 1; transition: opacity 0.5s; }
  .cq-etape.cq-apres.cq-vu { transition: opacity 0.5s 0.2s; }
  @media (prefers-reduced-motion: reduce) {
    .cq-phrase { animation: none; }
    .cq-etape, .cq-etape.cq-vu, .cq-etape.cq-apres.cq-vu, .cq-baton { transition: none; }
  }
</style>
