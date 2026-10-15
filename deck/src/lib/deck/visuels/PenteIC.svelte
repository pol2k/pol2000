<script>
  /**
   * L'intervalle de confiance de la pente. Notre pente, puis une fourchette
   * autour d'elle : environ deux erreurs types de chaque côté, calculée par
   * R (confint). Puis la question de H0 lue directement sur l'axe : 0 est-il
   * dans la fourchette ? Le même verdict que la valeur p, sans formule.
   * Trois temps. (Le sondage de 50 est retiré le 15 octobre 2026, avec sa
   * diapo.)
   *
   *   0  Notre pente, NOTRE.coefs[1].b (+0,20), un point sur l'axe.
   *   1  Sa fourchette, de NOTRE.coefs[1].bas à .haut (+0,14 à +0,27),
   *      et, en bas à gauche, la commande et la ligne scolarite de
   *      confint(modele), telles que R les imprime (SORTIES.confint).
   *   2  H0, 0, en pointillé : loin hors de la fourchette. On rejette H0,
   *      comme avec p (< 0,001).
   *
   * Un intervalle qui exclut 0, c'est p < 0,05 (à 95 % et 0,05, les deux
   * vont ensemble).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import { SORTIES } from '$lib/data/seance7_f.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => (v > 0 ? '+' : '') + v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const N = ' ';
  const A = NOTRE.coefs[1];
  const fp = (p) => (p < 0.001 ? 'p < 0,001' : `p = ${p.toLocaleString('fr-CA', { maximumFractionDigits: 3 })}`);
  const dedans = (c) => c.bas <= 0 && 0 <= c.haut;

  // L'axe des pentes, de −0,1 à +0,35.
  const P0 = -0.1, P1 = 0.35, X0 = 70, X1 = 930, BASE = 330;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  const RANGS = [
    { c: A, y: 230, qui: 'notre sondage', vu: 0 }
  ];

  // Les sorties de R : la commande, l'en-tête et la ligne scolarite.
  const sortie = (code, txt) => {
    const l = txt.split('\n');
    return [`> ${code}`, l.find((s) => /2\.5 %/.test(s)).trimEnd(), l.find((s) => s.startsWith('scolarite')).trimEnd()];
  };
  const R1 = sortie(SORTIES.code_confint, SORTIES.confint);

  const PHRASES = [
    [`Notre pente${N}: ${f(A.b)}.`, `Une estimation. À quel point est-elle précise${N}?`],
    ['L’intervalle de confiance à 95\u202f%', 'Notre pente, plus ou moins environ 2 erreurs types.'],
    [`0 est-il dans l’intervalle${N}? Non.`, `On rejette H0. Même verdict qu’avec la valeur p (${fp(A.p)}).`]
  ];
</script>

<div class="visuel pente-ic" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Notre pente, {f(A.b)}. Son intervalle de confiance à 95{N}%, de {f(A.bas)} à {f(A.haut)}{N}: environ 2 erreurs types de chaque côté. 0 n’est pas dedans{N}: on rejette H0, le même verdict que la valeur p.">
    {#key e}
      <g class="ic-phrase">
        <text x="40" y="42" class="ic-titre">{PHRASES[e][0]}</text>
        <text x="40" y="74" class="ic-sous">{PHRASES[e][1]}</text>
      </g>
    {/key}

    <!-- 2 : H0. -->
    <g class="ic-etape" class:ic-vu={e >= 2}>
      <line x1={x(0)} y1="128" x2={x(0)} y2={BASE} class="ic-h0" />
      <text x={x(0)} y="120" class="ic-h0-t">H0</text>
    </g>

    <!-- Les fourchettes. -->
    {#each RANGS as r}
      <g class="ic-etape" class:ic-vu={e >= r.vu}>
        <text x={Math.max(x(r.c.bas), x(0) + 12)} y={r.y - 26} class="ic-qui">{r.qui}</text>
        <g class="ic-etape" class:ic-vu={e >= Math.max(1, r.vu)}>
          <line x1={x(r.c.bas)} y1={r.y} x2={x(r.c.haut)} y2={r.y} class="ic-fourchette" />
          <line x1={x(r.c.bas)} y1={r.y - 14} x2={x(r.c.bas)} y2={r.y + 14} class="ic-borne" />
          <line x1={x(r.c.haut)} y1={r.y - 14} x2={x(r.c.haut)} y2={r.y + 14} class="ic-borne" />
          <text x={x(r.c.bas) - 12} y={r.y + 7} class="ic-b ic-b-g">{f(r.c.bas)}</text>
          <text x={x(r.c.haut) + 12} y={r.y + 7} class="ic-b ic-b-d">{f(r.c.haut)}</text>
        </g>
        <circle cx={x(r.c.b)} cy={r.y} r="10" class="ic-point" />
        {#if dedans(r.c)}
          <circle cx={x(0)} cy={r.y} r="17" class="ic-anneau ic-etape" class:ic-vu={e >= Math.max(2, r.vu)} />
        {/if}
      </g>
    {/each}

    <!-- L'axe. -->
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ic-axe" />
    {#each [-0.1, 0, 0.1, 0.2, 0.3] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 8} class="ic-axe" />
      <text x={x(k)} y={BASE + 30} class="ic-tick" class:ic-zero={k === 0}>{k > 0 ? '+' : ''}{k.toLocaleString('fr-CA', { minimumFractionDigits: Number.isInteger(k) ? 0 : 1 }).replace('-', '−')}</text>
    {/each}
    <text x={X1} y={BASE + 54} class="ic-tick ic-fin">pente de la droite</text>

    <!-- Les sorties de R. -->
    {#each [{ l: R1, x: 280, vu: 1 }] as s}
      <g class="ic-etape" class:ic-vu={e >= s.vu}>
        <rect x={s.x} y="404" width="440" height="92" class="ic-console" />
        {#each s.l as ligne, i}
          <text x={s.x + 16} y={430 + i * 27} class="ic-r" class:ic-cmd={i === 0} class:ic-rang={i === 2}>{ligne}</text>
        {/each}
      </g>
    {/each}
  </svg>
</div>

<style>
  .pente-ic { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ic-phrase { animation: ic-fondu 0.5s ease-out both; }
  @keyframes ic-fondu { from { opacity: 0; } to { opacity: 1; } }
  .ic-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .ic-sous { font-size: 21px; fill: var(--dk-gris); }
  .ic-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ic-h0-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ic-qui { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .ic-fourchette { stroke: var(--dk-accent); stroke-width: 12; }
  .ic-anneau { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .ic-borne { stroke: var(--dk-encre); stroke-width: 3; }
  .ic-b { font-size: 18px; fill: var(--dk-gris); }
  .ic-b-g { text-anchor: end; }
  .ic-b-d { text-anchor: start; }
  .ic-point { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; }
  .ic-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ic-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ic-zero { font-weight: 600; fill: var(--dk-encre); }
  .ic-fin { text-anchor: end; }
  .ic-console { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .ic-r { font-size: 19px; fill: var(--dk-gris); white-space: pre; }
  .ic-cmd { fill: var(--dk-encre); }
  .ic-rang { fill: var(--dk-encre); font-weight: 600; }
  .ic-etape { opacity: 0; transition: opacity 0.2s; }
  .ic-etape.ic-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ic-phrase { animation: none; }
    .ic-etape, .ic-etape.ic-vu { transition: none; }
  }
</style>
