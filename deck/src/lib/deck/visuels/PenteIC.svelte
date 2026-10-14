<script>
  /**
   * L'intervalle de confiance de la pente. Notre pente, puis une fourchette
   * autour d'elle : environ deux erreurs types de chaque côté, calculée par
   * R (confint). Puis la question de H0 lue directement sur l'axe : 0 est-il
   * dans la fourchette ? Le même verdict que la valeur p, sans formule.
   * Quatre temps.
   *
   *   0  Notre pente, NOTRE.coefs[1].b (−5,05), un point sur l'axe.
   *   1  Sa fourchette, de NOTRE.coefs[1].bas à .haut (−5,93 à −4,17),
   *      et, en bas à gauche, la commande et la ligne gauche_droite de
   *      confint(modele), telles que R les imprime (SORTIES.confint).
   *   2  H0, 0, en pointillé : loin hors de la fourchette. On rejette H0,
   *      comme avec p (< 0,001).
   *   3  Le sondage de 50 (H0.cinquante.coefs[1] : −4,22, de −9,07 à
   *      +0,63) : une fourchette bien plus large, qui attrape 0. On ne
   *      rejette pas H0, comme avec p (0,086). Sa sortie de R à droite
   *      (SORTIES.confint50).
   *
   * Un intervalle qui exclut 0, c'est p < 0,05; un intervalle qui contient
   * 0, c'est p ≥ 0,05 (à 95 % et 0,05, les deux vont ensemble).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, H0 } from '$lib/data/seance7.js';
  import { SORTIES } from '$lib/data/seance7_f.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => (v > 0 ? '+' : '') + v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const N = ' ';
  const A = NOTRE.coefs[1], C = H0.cinquante.coefs[1];
  const fp = (p) => (p < 0.001 ? 'p < 0,001' : `p = ${p.toLocaleString('fr-CA', { maximumFractionDigits: 3 })}`);
  const dedans = (c) => c.bas <= 0 && 0 <= c.haut;

  // L'axe des pentes, de −10 à +2.
  const P0 = -10, P1 = 2, X0 = 70, X1 = 930, BASE = 330;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  const RANGS = [
    { c: A, y: 182, qui: 'notre sondage', vu: 0 },
    { c: C, y: 270, qui: 'sondage de 50', vu: 3 }
  ];

  // Les sorties de R : la commande, l'en-tête et la ligne gauche_droite.
  const sortie = (code, txt) => {
    const l = txt.split('\n');
    return [`> ${code}`, l.find((s) => /2\.5 %/.test(s)).trimEnd(), l.find((s) => s.startsWith('gauche_droite')).trimEnd()];
  };
  const R1 = sortie(SORTIES.code_confint, SORTIES.confint);
  const R2 = sortie(SORTIES.code_confint50, SORTIES.confint50);

  const PHRASES = [
    [`Notre pente${N}: ${f(A.b)}.`, `Une estimation. À quel point est-elle précise${N}?`],
    ['L’intervalle de confiance à 95\u202f%', 'Notre pente, plus ou moins environ 2 erreurs types.'],
    [`0 est-il dans l’intervalle${N}? Non.`, `On rejette H0. Même verdict qu’avec la valeur p (${fp(A.p)}).`],
    [`Le sondage de 50${N}: 0 est dedans.`, `On ne rejette pas H0. Même verdict qu’avec la valeur p (${fp(C.p)}).`]
  ];
</script>

<div class="visuel pente-ic" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Notre pente, {f(A.b)}. Son intervalle de confiance à 95{N}%, de {f(A.bas)} à {f(A.haut)}{N}: environ 2 erreurs types de chaque côté. 0 n’est pas dedans{N}: on rejette H0, le même verdict que la valeur p. Le sondage de 50{N}: pente de {f(C.b)}, intervalle de {f(C.bas)} à {f(C.haut)}. 0 est dedans{N}: on ne rejette pas H0, {fp(C.p)}.">
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
        <text x={x(r.c.bas)} y={r.y - 26} class="ic-qui">{r.qui}</text>
        <g class="ic-etape" class:ic-vu={e >= Math.max(1, r.vu)}>
          <line x1={x(r.c.bas)} y1={r.y} x2={x(r.c.haut)} y2={r.y} class="ic-fourchette" />
          <line x1={x(r.c.bas)} y1={r.y - 14} x2={x(r.c.bas)} y2={r.y + 14} class="ic-borne" />
          <line x1={x(r.c.haut)} y1={r.y - 14} x2={x(r.c.haut)} y2={r.y + 14} class="ic-borne" />
          <text x={x(r.c.bas)} y={r.y + 40} class="ic-b">{f(r.c.bas)}</text>
          <text x={x(r.c.haut)} y={r.y + 40} class="ic-b">{f(r.c.haut)}</text>
        </g>
        <circle cx={x(r.c.b)} cy={r.y} r="10" class="ic-point" />
        {#if dedans(r.c)}
          <circle cx={x(0)} cy={r.y} r="17" class="ic-anneau ic-etape" class:ic-vu={e >= Math.max(2, r.vu)} />
        {/if}
      </g>
    {/each}

    <!-- L'axe. -->
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ic-axe" />
    {#each [-10, -8, -6, -4, -2, 0, 2] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 8} class="ic-axe" />
      <text x={x(k)} y={BASE + 30} class="ic-tick" class:ic-zero={k === 0}>{k > 0 ? '+' : ''}{k.toLocaleString('fr-CA').replace('-', '−')}</text>
    {/each}
    <text x={X1} y={BASE + 54} class="ic-tick ic-fin">pente de la droite</text>

    <!-- Les sorties de R. -->
    {#each [{ l: R1, x: 40, vu: 1 }, { l: R2, x: 520, vu: 3 }] as s}
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
  .ic-b { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
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
