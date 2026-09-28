<script>
  /**
   * L'intervalle de confiance de la pomicultrice (Arel-Bundock 2021,
   * p. 72-74). Une droite des poids, de 95 à 112 g.
   *
   *   0  L'estimé, 105 g : un gros point.
   *   1  L'intervalle, de 100,1 à 109,9 g : l'estimé plus ou moins deux
   *      erreurs types (l'équation 4.6 du livre arrondit 1,96 à 2).
   *   2  H₀, 100 g, en rouge : juste à l'extérieur de l'intervalle. À cette
   *      échelle, 100 et 100,1 se touchent presque; une loupe, en haut à
   *      gauche, montre l'écart. On rejette H₀.
   *
   * Les nombres viennent de POMMES (moyenne, h0, ic), calculés par
   * outils/seance5_data.R. Le verdict est calculé ici : H₀ est-elle hors de
   * l'intervalle? L'intervalle s'écrit « de ... à ... », jamais avec un
   * point-virgule.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const [BAS, HAUT] = POMMES.ic;
  const dehors = POMMES.h0 < BAS || POMMES.h0 > HAUT;

  // La droite des poids : 95 à 112 g.
  const X = (v) => 80 + ((v - 95) / 17) * 840;
  const YA = 330;
  const YI = 220;
  const GRAMMES = Array.from({ length: 18 }, (_, i) => 95 + i);
  const ETIQ = [95, 100, 105, 110];
  const XH = X(POMMES.h0);

  // La loupe : quelques dixièmes de gramme autour de H₀ et de la borne basse.
  const L = (v) => 170 + (v - POMMES.h0) * 600;
  const CIBLE = X((POMMES.h0 + BAS) / 2);
</script>

<div class="visuel ic" bind:this={hote}>
  <svg viewBox="0 0 1000 376" role="img" aria-label="Une droite des poids, de 95 à 112 grammes. L’estimé de la pomicultrice, {POMMES.moyenne} g, est un gros point. Son intervalle de confiance va de {fr(BAS, 1)} à {fr(HAUT, 1)} g, l’estimé plus ou moins deux erreurs types. H₀, {POMMES.h0} g, est marquée en rouge, {dehors ? 'juste à l’extérieur' : 'à l’intérieur'} de l’intervalle.">
    <!-- L'axe des grammes. -->
    <line x1={X(95)} y1={YA} x2={X(112)} y2={YA} class="ic-axe" />
    {#each GRAMMES as g}
      <line x1={X(g)} y1={YA} x2={X(g)} y2={YA + (ETIQ.includes(g) ? 9 : 5)} class="ic-axe" />
    {/each}
    {#each ETIQ as g}
      <text x={X(g)} y={YA + 32} class="ic-tick" class:ic-cache={g === POMMES.h0 && e >= 2}>{g}</text>
    {/each}
    <text x="946" y={YA + 7} class="ic-unite">g</text>

    <!-- Temps 1 : l'intervalle. -->
    <g class="ic-int" class:ic-vu={e >= 1}>
      <line x1={X(BAS)} y1={YI} x2={X(HAUT)} y2={YI} class="ic-trait" />
      <line x1={X(BAS)} y1={YI - 17} x2={X(BAS)} y2={YI + 17} class="ic-bout" />
      <line x1={X(HAUT)} y1={YI - 17} x2={X(HAUT)} y2={YI + 17} class="ic-bout" />
      <text x={X(POMMES.moyenne)} y={YI + 52} class="ic-bornes">de {fr(BAS, 1)} à {fr(HAUT, 1)} g</text>
      <text x={X(POMMES.moyenne)} y={YI + 80} class="ic-regle">l’estimé ± 2 erreurs types</text>
    </g>

    <!-- Temps 0 : l'estimé. -->
    <text x={X(POMMES.moyenne)} y={YI - 34} class="ic-estime">l’estimé&#8239;: {POMMES.moyenne} g</text>
    <circle cx={X(POMMES.moyenne)} cy={YI} r="13" class="ic-point" />

    <!-- Temps 2 : H₀, la loupe, le verdict. -->
    <g class="ic-h0" class:ic-vu={e >= 2}>
      <line x1={XH} y1={YI - 24} x2={XH} y2={YA} class="ic-rouge" />
      <text x={XH} y={YA + 32} class="ic-h0-t">H₀ = {POMMES.h0}</text>

      <circle cx={CIBLE} cy={YI} r="18" class="ic-cible" />
      <line x1="280" y1="144" x2={CIBLE - 12} y2={YI - 13} class="ic-fil" />
      <rect x="70" y="24" width="210" height="120" class="ic-loupe" />
      <line x1={L(BAS)} y1="80" x2="280" y2="80" class="ic-trait" />
      <line x1={L(BAS)} y1="60" x2={L(BAS)} y2="100" class="ic-bout" />
      <line x1={L(POMMES.h0)} y1="36" x2={L(POMMES.h0)} y2="118" class="ic-rouge" />
      <text x={L(POMMES.h0)} y="138" class="ic-l-h0">{POMMES.h0}</text>
      <text x={L(BAS)} y="138" class="ic-l-bas">{fr(BAS, 1)}</text>

      <text x="320" y="72" class="ic-verdict">{POMMES.h0} est {dehors ? 'hors de' : 'dans'} l’intervalle&#8239;:</text>
      <text x="320" y="104" class="ic-verdict">{dehors ? 'on rejette H₀' : 'on ne rejette pas H₀'}</text>
    </g>
  </svg>
  <p class="ic-src">exemple fictif · Arel-Bundock (2021, p.&#8239;72-74)</p>
</div>

<style>
  .ic { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ic-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .ic-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); transition: opacity 0.3s; }
  .ic-tick.ic-cache { opacity: 0; }
  .ic-unite { font-size: 22px; fill: var(--dk-gris); }

  .ic-point { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; transform-box: fill-box; transform-origin: center; animation: ic-pop 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  @keyframes ic-pop { from { transform: scale(0); } to { transform: scale(1); } }
  .ic-estime { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .ic-int { opacity: 0; transition: opacity 0.3s; }
  .ic-int.ic-vu { opacity: 1; }
  .ic-int .ic-trait { transform-box: fill-box; transform-origin: center; transform: scaleX(0); transition: transform 0.6s cubic-bezier(0.34, 1.3, 0.64, 1); }
  .ic-int.ic-vu .ic-trait { transform: scaleX(1); }
  .ic-trait { stroke: var(--dk-encre); stroke-width: 5; }
  .ic-bout { stroke: var(--dk-encre); stroke-width: 4; }
  .ic-bornes { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ic-regle { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }

  .ic-h0 { opacity: 0; transition: opacity 0.3s; }
  .ic-h0.ic-vu { opacity: 1; transition: opacity 0.5s; }
  .ic-rouge { stroke: var(--dk-accent); stroke-width: 4; }
  .ic-h0-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ic-cible { fill: none; stroke: var(--dk-gris); stroke-width: 2; }
  .ic-fil { stroke: var(--dk-gris); stroke-width: 1.5; }
  .ic-loupe { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-width: 2; }
  .ic-l-h0 { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .ic-l-bas { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .ic-verdict { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }

  .ic-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .ic-point { animation: none; }
    .ic-tick, .ic-int, .ic-int .ic-trait, .ic-int.ic-vu .ic-trait, .ic-h0, .ic-h0.ic-vu { transition: none; }
  }
</style>
