<script>
  /**
   * La statistique t : mesurer l'écart entre notre estimé et H0 avec une
   * règle graduée en erreurs types. L'exemple de la pomicultrice
   * (Arel-Bundock 2021, p. 62-69). Quatre temps.
   *
   *   0  Une grande règle en grammes. Deux points : H0 (POMMES.h0) et notre
   *      estimé (POMMES.moyenne), et l'écart entre les deux (POMMES.ecart).
   *   1  Sous la règle, des graduations toutes les POMMES.erreurType
   *      grammes à partir de H0 : une erreur type devient l'unité.
   *   2  Le calcul : t = écart ÷ erreur type = POMMES.t. Notre estimé est à
   *      POMMES.t erreurs types de H0.
   *   3  La règle du pouce du livre (p. 69) : un t de 2 ou plus, en valeur
   *      absolue, serait surprenant si H0 était vraie.
   *
   * Tous les nombres viennent de POMMES (src/lib/data/seance5.js), calculés
   * par outils/seance5_data.R. Le seuil de 2 est celui du livre.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const ET = POMMES.erreurType;
  const H0 = POMMES.h0, EST = POMMES.moyenne;

  // La règle : de 99 à 111 g.
  const G0 = 99, G1 = 111, X0 = 60, X1 = 940;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const HAUT = 150, BAS = 198;
  const DEMIS = Array.from({ length: (G1 - G0) * 2 + 1 }, (_, i) => G0 + i / 2);
  // Les graduations en erreurs types, à partir de H0, tant qu'elles tiennent sur la règle.
  const GRADS = [];
  for (let k = 0; H0 + k * ET <= G1; k++) GRADS.push({ k, g: H0 + k * ET });
  const XH = x(H0), XE = x(EST);
  const SEUIL = 2;
</script>

<div class="visuel stat-t" bind:this={hote}>
  <svg viewBox="0 0 1000 485" role="img" aria-label="Une règle en grammes. H0, {H0} g, et notre estimé, {EST} g&#8239;: l’écart est de {POMMES.ecart} g. Graduée en erreurs types de {fr(ET, 2)} g, la règle montre que notre estimé est à {fr(POMMES.t, 2)} erreurs types de H0. t = {POMMES.ecart} ÷ {fr(ET, 2)} = {fr(POMMES.t, 2)}. Un t de {SEUIL} ou plus, en valeur absolue, serait surprenant si H0 était vraie.">
    <!-- Les deux points et leur écart. -->
    <text x={XH} y="58" class="sta-h0">H0</text>
    <text x={XE} y="58" class="sta-est">notre estimé</text>
    <line x1={XH} y1="70" x2={XH} y2={HAUT - 12} class="sta-guide" />
    <line x1={XE} y1="70" x2={XE} y2={HAUT - 12} class="sta-guide" />
    <line x1={XH + 4} y1="112" x2={XE - 4} y2="112" class="sta-fleche" />
    <path d="M {XE - 14} 104 L {XE - 4} 112 L {XE - 14} 120" class="sta-fleche" />
    <text x={(XH + XE) / 2} y="100" class="sta-ecart">l’écart&#8239;: {POMMES.ecart} g</text>

    <!-- La règle. -->
    <rect x={X0 - 20} y={HAUT} width={X1 - X0 + 40} height={BAS - HAUT} class="sta-regle" />
    {#each DEMIS as g}
      <line x1={x(g)} y1={HAUT} x2={x(g)} y2={HAUT + (Number.isInteger(g) ? 16 : 8)} class="sta-cran" />
      {#if Number.isInteger(g)}
        <text x={x(g)} y={HAUT + 38} class="sta-g">{g}</text>
      {/if}
    {/each}
    <text x={X1 + 28} y={HAUT + 38} class="sta-unite">g</text>
    <circle cx={XH} cy={HAUT} r="11" class="sta-pt-h0" />
    <circle cx={XE} cy={HAUT} r="11" class="sta-pt-est" />

    <!-- Temps 1 : les graduations en erreurs types. -->
    <g class="sta-etape" class:sta-vu={e >= 1}>
      {#each GRADS as q}
        <line x1={x(q.g)} y1={BAS + 6} x2={x(q.g)} y2={BAS + 36} class="sta-grad" style="transition-delay: {q.k * 80}ms" />
        <text x={x(q.g)} y={BAS + 60} class="sta-grad-t">{q.k === 0 ? fr(q.g) : fr(q.g, 2)}</text>
      {/each}
      <line x1={XH} y1={BAS + 82} x2={x(H0 + ET)} y2={BAS + 82} class="sta-crochet" />
      <line x1={XH} y1={BAS + 74} x2={XH} y2={BAS + 90} class="sta-crochet" />
      <line x1={x(H0 + ET)} y1={BAS + 74} x2={x(H0 + ET)} y2={BAS + 90} class="sta-crochet" />
      <text x={XH} y={BAS + 116} class="sta-une">une erreur type&#8239;: {fr(ET, 2)} g</text>
    </g>

    <!-- Temps 2 : le calcul. -->
    <g class="sta-etape" class:sta-vu={e >= 2}>
      <text x={X0} y="390" class="sta-t">t = {POMMES.ecart} ÷ {fr(ET, 2)} = <tspan class="sta-rouge">{fr(POMMES.t, 2)}</tspan></text>
      <text x={X0} y="428" class="sta-phrase">notre estimé est à {fr(POMMES.t, 2)} erreurs types de H0</text>
    </g>

    <!-- Temps 3 : la règle du pouce. -->
    <g class="sta-etape" class:sta-vu={e >= 3}>
      <text x={X0} y="472" class="sta-pouce">|t| ≥ {SEUIL}&#8239;: surprenant, si H0 était vraie</text>
      <text x="990" y="472" class="sta-src">Arel-Bundock (2021, p. 69)</text>
    </g>
  </svg>
</div>

<style>
  .stat-t { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .sta-h0 { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .sta-est { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .sta-guide { stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 4 5; }
  .sta-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; stroke-linejoin: miter; }
  .sta-ecart { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .sta-regle { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .sta-cran { stroke: var(--dk-encre); stroke-width: 2; }
  .sta-g { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .sta-unite { font-size: 18px; fill: var(--dk-gris); }
  .sta-pt-h0 { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; }
  .sta-pt-est { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .sta-grad { stroke: var(--dk-encre); stroke-width: 4; transform-box: fill-box; transform-origin: top; transform: scaleY(0); transition: transform 0.4s ease-out; }
  .sta-etape.sta-vu .sta-grad { transform: scaleY(1); }
  .sta-grad-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .sta-crochet { stroke: var(--dk-encre); stroke-width: 3; }
  .sta-une { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .sta-t { font-size: 48px; font-weight: 600; fill: var(--dk-encre); }
  .sta-rouge { fill: var(--dk-accent); }
  .sta-phrase { font-size: 22px; fill: var(--dk-encre); }
  .sta-pouce { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .sta-src { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .sta-etape { opacity: 0; transition: opacity 0.3s; }
  .sta-etape.sta-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .sta-grad, .sta-etape, .sta-etape.sta-vu { transition: none; }
  }
</style>
