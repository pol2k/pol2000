<script>
  /**
   * Le monde où H0 est vraie, mille fois. On mélange la colonne populisme
   * de notre sondage 1 000 fois (la diapo précédente en montre un) : 1 000
   * pentes, toutes nées du hasard seul. Elles forment une cloche autour de
   * 0, comme les 1 000 paniers de pommes de la séance 5. Puis notre vraie
   * pente, −0,37, tombe loin, très loin. Quatre temps.
   *
   *   0  L'axe des pentes, H0 (0) en pointillé. Un mélange, une pente : le
   *      premier mélange (H0.notre.pentes[0], 0,04, celui de la diapo
   *      précédente), un point sur l'axe.
   *   1  Mille mélanges : les bâtons montent en trois secondes
   *      (requestAnimationFrame), une cloche autour de 0. L'état final est
   *      fixé : dès le temps 2, ou après trois secondes, les 1 000 pentes
   *      sont toutes là, toujours les mêmes. La phrase nomme le théorème
   *      central limite (séance 5) : les pentes aussi forment une cloche.
   *   2  Notre pente, −0,37 (H0.notre.b1), en rouge, et son miroir, +0,37,
   *      en gris : « aussi loin de 0 » se compte des deux côtés. Le compte
   *      de R : H0.notre.aussi_loin (0) sur 1 000.
   *   3  La phrase du haut s'efface; en bas, la conclusion : pas une fois
   *      sur 1 000. On rejette H0.
   *
   * Les bâtons sont des tranches de 0,01 calculées ici à partir des 1 000
   * pentes de R (H0.notre.pentes, src/lib/data/seance7.js, outils/
   * seance7_data.R, graine 7). Le compte affiché est celui de R.
   */
  import { brancherTemps } from '../temps.js';
  import { H0 } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const N = ' ';
  const PENTES = H0.notre.pentes;
  const TOUS = f(PENTES.length, 0);
  const B = H0.notre.b1;
  const LOIN = H0.notre.aussi_loin;

  // L'axe des pentes, de −0,6 à +0,6.
  const P0 = -0.6, P1 = 0.6, X0 = 70, X1 = 930, BASE = 350, HAUT = 190;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  // Les tranches de 0,01.
  const L = 0.01;
  const tranche = (p) => Math.floor(p / L + 1e-9);
  const T0 = tranche(Math.min(...PENTES)), T1 = tranche(Math.max(...PENTES));
  const COMPTE_FINAL = (() => {
    const c = new Array(T1 - T0 + 1).fill(0);
    for (const p of PENTES) c[tranche(p) - T0]++;
    return c;
  })();
  const MAX = Math.max(...COMPTE_FINAL);

  // 1 : les mille pentes arrivent en trois secondes; état final déterministe.
  const DUREE = 3000;
  let t = $state(0);
  $effect(() => {
    if (e !== 1) return;
    t = 0;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const combien = $derived(e < 1 ? 0 : e > 1 ? PENTES.length : Math.min(PENTES.length, Math.round((t / DUREE) * PENTES.length)));
  const COMPTES = $derived.by(() => {
    const c = new Array(T1 - T0 + 1).fill(0);
    for (let i = 0; i < combien; i++) c[tranche(PENTES[i]) - T0]++;
    return c;
  });

  const PHRASES = {
    0: ['Le monde où H0 est vraie.', `Un mélange, une pente${N}: ${f(PENTES[0])}.`],
    1: [`${TOUS} mélanges, ${TOUS} pentes.`, 'Une cloche autour de 0. Le théorème central limite, encore.'],
    2: [`Notre pente${N}: ${f(B)}.`, `Combien de mélanges vont aussi loin de 0${N}?`]
  };
  const XB = x(B), XM = x(-B);
</script>

<div class="visuel pente-monde-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Le monde où H0 est vraie{N}: on mélange les réponses sur le populisme {TOUS} fois. {TOUS} pentes, en cloche autour de 0. Notre pente, {f(B)}, est très loin. {LOIN} mélange sur {TOUS} va aussi loin de 0. On rejette H0.">
    <text x="990" y="20" class="mh-note">CES 2025 · notre sondage, mélangé {TOUS} fois</text>

    {#key e}
      {#if PHRASES[e]}
        <g class="mh-phrase">
          <text x="40" y="54" class="mh-titre">{PHRASES[e][0]}</text>
          <text x="40" y="88" class="mh-sous">{PHRASES[e][1]}</text>
        </g>
      {/if}
    {/key}

    <!-- 1 : les mille pentes. -->
    {#each COMPTES as c, j}
      {@const h = (c / MAX) * HAUT}
      <rect x={x((T0 + j) * L) + 0.5} y={BASE - h} width={x(L) - x(0) - 1} height={h} class="mh-baton" />
    {/each}

    <!-- 0 : un seul mélange. -->
    <g class="mh-etape" class:mh-vu={e === 0}>
      <circle cx={x(PENTES[0])} cy={BASE} r="9" class="mh-un" />
      <text x={x(PENTES[0]) + 16} y={BASE - 18} class="mh-un-t">un mélange</text>
    </g>

    <!-- L'axe, et H0. -->
    <line x1={x(0)} y1="128" x2={x(0)} y2={BASE} class="mh-h0" />
    <text x={x(0)} y="120" class="mh-h0-t">H0</text>
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="mh-axe" />
    {#each [-0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 8} class="mh-axe" />
      <text x={x(k)} y={BASE + 30} class="mh-tick" class:mh-zero={k === 0}>{k > 0 ? '+' : ''}{f(k, k === 0 ? 0 : 1)}</text>
    {/each}
    <text x={X1} y={BASE + 56} class="mh-tick mh-fin">pente de la droite</text>

    <!-- 2 : notre pente, et son miroir. -->
    <g class="mh-etape" class:mh-vu={e >= 2}>
      <line x1={XM} y1="150" x2={XM} y2={BASE} class="mh-miroir" />
      <text x={XM - 10} y="146" class="mh-miroir-t">ou +{f(-B)}</text>
      <line x1={XB} y1="130" x2={XB} y2={BASE} class="mh-notre" />
      <circle cx={XB} cy={BASE} r="10" class="mh-point" />
      <text x={XB + 14} y="156" class="mh-lab">notre pente&#8239;: {f(B)}</text>
      <text x={XB + 14} y="196" class="mh-compte">{LOIN} sur {TOUS}</text>
      <text x={XB + 14} y="222" class="mh-lab-s">aussi loin de 0</text>
    </g>

    <!-- 3 : la conclusion. -->
    <g class="mh-etape mh-apres" class:mh-vu={e >= 3}>
      <text x="40" y="438" class="mh-cours">Si H0 était vraie, une pente comme la nôtre&#8239;:</text>
      <text x="40" y="470" class="mh-cours">{LOIN === 0 ? 'pas une fois' : `${LOIN} fois`} sur {TOUS}. <tspan class="mh-rouge">On rejette H0.</tspan></text>
    </g>
  </svg>
</div>

<style>
  .pente-monde-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .mh-note { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .mh-phrase { animation: mh-fondu 0.5s ease-out both; }
  @keyframes mh-fondu { from { opacity: 0; } to { opacity: 1; } }
  .mh-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .mh-sous { font-size: 21px; fill: var(--dk-gris); }
  .mh-baton { fill: var(--dk-encre); }
  .mh-un { fill: var(--dk-encre); }
  .mh-un-t { font-size: 18px; fill: var(--dk-encre); }
  .mh-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .mh-h0-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mh-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .mh-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .mh-zero { font-weight: 600; fill: var(--dk-encre); }
  .mh-fin { text-anchor: end; }
  .mh-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .mh-point { fill: var(--dk-accent); }
  .mh-miroir { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 6 6; }
  .mh-miroir-t { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .mh-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .mh-compte { font-size: 32px; font-weight: 600; fill: var(--dk-accent); }
  .mh-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .mh-cours { font-size: 23px; font-weight: 600; fill: var(--dk-encre); }
  .mh-rouge { fill: var(--dk-accent); }
  .mh-etape { opacity: 0; transition: opacity 0.2s; }
  .mh-etape.mh-vu { opacity: 1; transition: opacity 0.5s; }
  .mh-etape.mh-apres.mh-vu { transition: opacity 0.5s 0.3s; }
  @media (prefers-reduced-motion: reduce) {
    .mh-phrase { animation: none; }
    .mh-etape, .mh-etape.mh-vu, .mh-etape.mh-apres.mh-vu { transition: none; }
  }
</style>
