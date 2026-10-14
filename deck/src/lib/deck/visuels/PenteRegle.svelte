<script>
  /**
   * La statistique t : à combien d'erreurs types de zéro tombe notre pente ?
   * On mesure la distance entre H0 (0) et notre pente (−0,37) avec une règle
   * dont chaque bloc vaut une erreur type (0,044, calculée par R avec notre
   * seul sondage). Quatre temps.
   *
   *   0  L'axe des pentes, H0 en pointillé, la cloche pâle du monde où H0
   *      est vraie (H0.notre.pentes, tranches de 0,01), notre pente en rouge.
   *      Sous l'axe, un seul bloc, rouge : une erreur type, NOTRE.coefs[1].se.
   *      Sa largeur est à peu près celle de la cloche (écart type des 1 000
   *      mélanges : H0.notre.ecart_type, 0,044; R, avec un seul sondage :
   *      0,044). On dit « à peu près » : ce sont deux façons de l'estimer.
   *   1  Les blocs s'ajoutent un à un jusqu'à notre pente : 8, et un bout.
   *   2  En haut, en grand : t = −8,397, la colonne « t value » de R
   *      (découpée dans SUMMARY, telle que R l'imprime), et la phrase : à
   *      plus de 8 erreurs types de zéro.
   *   3  Sous la règle, le panier de pommes de la séance 5 : à 2 erreurs
   *      types de 100 g (POMMES.t, 2,04, src/lib/data/seance5.js, exemple
   *      du livre), et c'était déjà rare. Puis la règle du pouce : au-delà
   *      d'environ 2 erreurs types, c'est rare si H0 était vraie.
   *
   * Aucune division sur la diapo : le t affiché est celui de R. Le nombre de
   * blocs dessinés vient de la même division (pente ÷ erreur type), faite ici
   * pour le dessin seulement.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, H0, SUMMARY } from '$lib/data/seance7.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const N = ' ';
  const C = NOTRE.coefs[1];
  const B = C.b, SE = C.se;
  // Le t tel que R l'imprime (colonne « t value » de la ligne populisme).
  const T = Number(SUMMARY.split('\n').find((l) => l.startsWith('populisme')).trim().split(/\s+/)[3]);

  // L'axe des pentes, de −0,45 à +0,2.
  const P0 = -0.45, P1 = 0.2, X0 = 60, X1 = 940, BASE = 296;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  const XB = x(B), XZ = x(0);
  const BLOC = x(SE) - x(0);

  // La cloche pâle du monde où H0 est vraie.
  const L = 0.01;
  const PENTES = H0.notre.pentes;
  const tr = (p) => Math.floor(p / L + 1e-9);
  const T0 = tr(Math.min(...PENTES));
  const CLOCHE = new Array(tr(Math.max(...PENTES)) - T0 + 1).fill(0);
  for (const p of PENTES) CLOCHE[tr(p) - T0]++;
  const MAXC = Math.max(...CLOCHE);

  // Les blocs : autant d'erreurs types entières qu'il en tient, et le bout.
  const ENTIERS = Math.floor(Math.abs(B) / SE);
  const BLOCS = Array.from({ length: ENTIERS }, (_, i) => ({ i, x: XZ - (i + 1) * BLOC }));
  const BOUT = Math.abs(B) / SE - ENTIERS;
  const YR = 336, HR = 34;
  // Le panier de pommes : POMMES.t erreurs types.
  const YP = 414;
  const PT = POMMES.t;
  const PANIER = Array.from({ length: Math.floor(PT) }, (_, i) => XZ - (i + 1) * BLOC);
  const PBOUT = PT - Math.floor(PT);

  const PHRASES = [
    [`La règle${N}: une erreur type, ${f(SE, 3)}.`, 'De combien le hasard fait bouger une pente, d’habitude.'],
    ['On compte les erreurs types', 'entre 0 et notre pente.']
  ];
</script>

<div class="visuel pente-regle" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La règle{N}: une erreur type, {f(SE, 3)}, de combien le hasard fait bouger une pente d’habitude. Entre 0 et notre pente, {f(B)}, on compte {ENTIERS} erreurs types, et un bout. t = {f(T, 3)}{N}: notre pente est à plus de {ENTIERS} erreurs types de 0. Le panier de pommes de la séance 5 était à {f(PT)} erreurs types, et c’était déjà rare. Au-delà d’environ 2 erreurs types, c’est rare si H0 était vraie.">
    <!-- La phrase (0 et 1), puis t (2 et 3). -->
    {#key e < 2 ? e : 2}
      {#if e < 2}
        <g class="rg-phrase">
          <text x="40" y="42" class="rg-titre">{PHRASES[e][0]}</text>
          <text x="40" y="74" class="rg-sous">{PHRASES[e][1]}</text>
        </g>
      {:else}
        <g class="rg-phrase">
          <text x="40" y="66" class="rg-t">t = {f(T, 3)}</text>
          <text x="400" y="46" class="rg-t-s">notre pente est à plus de {ENTIERS}</text>
          <text x="400" y="74" class="rg-t-s">erreurs types de 0 <tspan class="rg-gris">(la colonne «&#8239;t value&#8239;» de R)</tspan></text>
        </g>
      {/if}
    {/key}

    <!-- La cloche pâle, autour de 0. -->
    {#each CLOCHE as c, j}
      {@const h = (c / MAXC) * 110}
      <rect x={x((T0 + j) * L) + 0.5} y={BASE - h} width={x(L) - x(0) - 1} height={h} class="rg-cloche" />
    {/each}

    <!-- L'axe, H0, notre pente. -->
    <line x1={XZ} y1="132" x2={XZ} y2={BASE} class="rg-h0" />
    <text x={XZ} y="124" class="rg-h0-t">H0</text>
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="rg-axe" />
    {#each [-0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 7} class="rg-axe" />
      {#if Math.abs(k - B) > 0.04}
        <text x={x(k)} y={BASE + 28} class="rg-tick" class:rg-zero={k === 0}>{k > 0 ? '+' : ''}{f(k, k === 0 ? 0 : 1)}</text>
      {/if}
    {/each}
    <line x1={XB} y1="124" x2={XB} y2={YR + HR} class="rg-notre" />
    <circle cx={XB} cy={BASE} r="10" class="rg-point" />
    <text x={XB + 14} y="148" class="rg-lab">notre pente&#8239;: {f(B)}</text>

    <!-- La règle : un bloc au temps 0, tous au temps 1. -->
    {#each BLOCS as c}
      <g class="rg-pas" class:rg-vu={c.i === 0 || e >= 1} style="transition-delay: {e >= 1 ? c.i * 110 : 0}ms">
        <rect x={c.x} y={YR} width={BLOC} height={HR} class="rg-bloc" class:rg-pair={c.i % 2 === 1} class:rg-un={c.i === 0 && e === 0} />
        {#if e >= 1}
          <text x={c.x + BLOC / 2} y={YR + 24} class="rg-num" class:rg-num-pair={c.i % 2 === 1}>{c.i + 1}</text>
        {/if}
      </g>
    {/each}
    <rect x={XB} y={YR} width={BOUT * BLOC} height={HR} class="rg-bout rg-pas" class:rg-vu={e >= 1} style="transition-delay: {e >= 1 ? ENTIERS * 110 : 0}ms" />
    <g class="rg-etape" class:rg-vu={e === 0}>
      <text x={XZ - BLOC - 12} y={YR + 25} class="rg-une">une erreur type&#8239;: {f(SE, 3)}</text>
    </g>

    <!-- 3 : le panier de pommes, et la règle du pouce. -->
    <g class="rg-etape" class:rg-vu={e >= 3}>
      {#each PANIER as px, i}
        <rect x={px} y={YP} width={BLOC} height={HR} class="rg-bloc" class:rg-pair={i % 2 === 1} />
      {/each}
      <rect x={XZ - PT * BLOC} y={YP} width={PBOUT * BLOC} height={HR} class="rg-bout" />
      <line x1={XZ} y1={YP - 6} x2={XZ} y2={YP + HR + 6} class="rg-axe" />
      <text x={XZ - PT * BLOC - 14} y={YP + 24} class="rg-pom">le panier de pommes (séance 5)&#8239;: {f(PT)}</text>
      <text x="40" y="490" class="rg-pouce">Au-delà d’environ 2 erreurs types&#8239;: rare, si H0 était vraie.</text>
    </g>
  </svg>
</div>

<style>
  .pente-regle { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .rg-phrase { animation: rg-fondu 0.5s ease-out both; }
  @keyframes rg-fondu { from { opacity: 0; } to { opacity: 1; } }
  .rg-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .rg-sous { font-size: 21px; fill: var(--dk-gris); }
  .rg-t { font-size: 54px; font-weight: 600; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .rg-t-s { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .rg-gris { font-weight: 400; fill: var(--dk-gris); font-size: 18px; }
  .rg-cloche { fill: var(--dk-gris-2); opacity: 0.5; }
  .rg-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .rg-h0-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .rg-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .rg-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .rg-zero { font-weight: 600; fill: var(--dk-encre); }
  .rg-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .rg-point { fill: var(--dk-accent); }
  .rg-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .rg-bloc { fill: var(--dk-encre); stroke: var(--dk-encre); stroke-width: 2; transition: fill 0.4s; }
  .rg-bloc.rg-pair { fill: var(--dk-fond); }
  .rg-bloc.rg-un { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .rg-bout { fill: none; stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 4 4; }
  .rg-num { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .rg-num.rg-num-pair { fill: var(--dk-encre); }
  .rg-une { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .rg-pom { font-size: 19px; text-anchor: end; fill: var(--dk-encre); }
  .rg-pouce { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .rg-pas { opacity: 0; transition: opacity 0.15s; }
  .rg-pas.rg-vu { opacity: 1; transition: opacity 0.25s; }
  .rg-etape { opacity: 0; transition: opacity 0.2s; }
  .rg-etape.rg-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .rg-phrase { animation: none; }
    .rg-pas, .rg-pas.rg-vu, .rg-etape, .rg-etape.rg-vu, .rg-bloc { transition: none; }
  }
</style>
