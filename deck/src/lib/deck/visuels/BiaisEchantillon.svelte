<script>
  /**
   * Ne sonder que les passionné.e.s : un échantillon biaisé. Les
   * répondant.e.s de l'Étude électorale canadienne 2025 servent de
   * population (POP). Deux distributions de 1 000 moyennes d'âge
   * d'échantillons de 50, sur un même axe, en tranches d'un an [a, a+1)
   * (BORNES). Trois temps.
   *
   *   0  En gris, les 1 000 échantillons tirés au hasard parmi tout le monde
   *      (DISTRIBUTIONS[1]), et la vraie moyenne (POP.moyenne) en pointillé.
   *   1  En rouge, 1 000 échantillons tirés seulement parmi les personnes
   *      très intéressées par la politique, 8 à 10 sur 10 à
   *      cps25_interest_gen_1 (BIAIS, BIAIS.nSousGroupe personnes). Une
   *      flèche va de la vraie moyenne au centre des moyennes biaisées
   *      (BIAIS.moyenne) : l'écart, arrondi à une décimale.
   *   2  Une phrase : plus d'échantillons n'y changent rien.
   *
   * Les nombres viennent de src/lib/data/seance5.js (outils/seance5_data.R);
   * « 1 000 » est la somme des effectifs de DISTRIBUTIONS[1] (celle de BIAIS
   * vaut aussi 1 000).
   */
  import { brancherTemps } from '../temps.js';
  import { BIAIS, DISTRIBUTIONS, BORNES, POP } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const D = DISTRIBUTIONS[1];
  const fr = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const MILLE = fr(D.effectifs.reduce((s, n) => s + n, 0));
  const ECART = fr(BIAIS.moyenne - POP.moyenne, 1);

  const A0 = 38, A1 = 65, X0 = 60, X1 = 950;
  const BASE = 380, HAUT = 175;
  const x = (v) => X0 + ((v - A0) / (A1 - A0)) * (X1 - X0);
  const max = Math.max(...D.effectifs, ...BIAIS.effectifs);
  const y = (n) => BASE - (n / max) * HAUT;
  const dans = (a) => a >= A0 && a < A1;
  const GRIS = D.effectifs.map((n, i) => ({ a: BORNES[i], n })).filter((b) => b.n > 0 && dans(b.a));

  // L'histogramme rouge en escalier, de la première à la dernière tranche non vide.
  const nonVides = BIAIS.effectifs.map((n, i) => (n > 0 ? i : -1)).filter((i) => i >= 0);
  const i0 = nonVides[0], i1 = nonVides[nonVides.length - 1];
  let d = `M ${x(BORNES[i0])} ${BASE}`;
  for (let i = i0; i <= i1; i++) d += ` V ${y(BIAIS.effectifs[i])} H ${x(BORNES[i + 1])}`;
  const ESCALIER = d + ` V ${BASE} Z`;

  const XV = x(POP.moyenne), XB = x(BIAIS.moyenne);
  const YF = 166;
  const TICKS = [40, 45, 50, 55, 60, 65];
</script>

<div class="visuel biais-ech" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="Deux histogrammes de {MILLE} moyennes d’âge d’échantillons de {D.n}. En gris, tirés au hasard parmi les {fr(POP.n)} répondant.e.s&#8239;: ils se centrent sur la vraie moyenne, {fr(POP.moyenne, 1)} ans. En rouge, tirés seulement parmi les {fr(BIAIS.nSousGroupe)} personnes très intéressées par la politique&#8239;: ils se centrent sur {fr(BIAIS.moyenne, 1)} ans, {ECART} ans trop haut.">
    <!-- Les légendes. -->
    <rect x="40" y="13" width="18" height="18" class="bse-sw-gris" />
    <text x="68" y="29" class="bse-leg">{MILLE} échantillons de {D.n}, tirés au hasard parmi les {fr(POP.n)}</text>
    <g class="bse-etape" class:bse-vu={e >= 1}>
      <rect x="40" y="47" width="18" height="18" class="bse-sw-rouge" />
      <text x="68" y="63" class="bse-leg">tirés seulement parmi les {fr(BIAIS.nSousGroupe)} très intéressé.e.s</text>
      <text x="68" y="88" class="bse-leg">par la politique (8 à 10 sur 10)</text>
    </g>

    <!-- En gris : au hasard. -->
    {#each GRIS as b, i}
      <rect x={x(b.a)} y={y(b.n)} width={x(b.a + 1) - x(b.a)} height={BASE - y(b.n)} class="bse-barre" style="animation-delay: {i * 30}ms" />
    {/each}

    <!-- En rouge : seulement les passionné.e.s. -->
    <path d={ESCALIER} class="bse-rouge" class:bse-vu={e >= 1} />

    <!-- La vraie moyenne. -->
    <line x1={XV} y1="126" x2={XV} y2={BASE} class="bse-vraie" />
    <text x={XV - 10} y="138" class="bse-vraie-t">la vraie moyenne</text>

    <!-- L'écart. -->
    <g class="bse-etape" class:bse-vu={e >= 1}>
      <path d="M {XV} {YF} H {XB}" pathLength="1" class="bse-fleche" class:bse-trace={e >= 1} />
      <path d="M {XB - 10} {YF - 7} L {XB} {YF} L {XB - 10} {YF + 7}" class="bse-pointe" />
      <line x1={XB} y1={YF + 10} x2={XB} y2={BASE} class="bse-centre" />
      <text x={XB + 12} y={YF + 9} class="bse-ecart">+{ECART} ans</text>
    </g>

    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="bse-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 7} class="bse-axe" />
      <text x={x(t)} y={BASE + 26} class="bse-tick">{t} ans</text>
    {/each}

    <text x={X0} y="448" class="bse-cap bse-etape" class:bse-vu={e >= 2}>Mille échantillons de plus n’y changent rien&#8239;: on vise à côté.</text>
  </svg>
</div>

<style>
  .biais-ech { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .bse-leg { font-size: 20px; fill: var(--dk-encre); }
  .bse-sw-gris { fill: var(--dk-gris-2); }
  .bse-sw-rouge { fill: var(--dk-accent); fill-opacity: 0.18; stroke: var(--dk-accent); stroke-width: 3; }
  .bse-barre { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 2; transform-box: fill-box; transform-origin: bottom; animation: bse-monte 0.5s ease-out both; }
  @keyframes bse-monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .bse-rouge { fill: var(--dk-accent); fill-opacity: 0.18; stroke: var(--dk-accent); stroke-width: 3.5; stroke-linejoin: miter; transform-box: fill-box; transform-origin: bottom; transform: scaleY(0); opacity: 0; transition: transform 0.6s ease-out, opacity 0.3s; }
  .bse-rouge.bse-vu { transform: scaleY(1); opacity: 1; }
  .bse-vraie { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .bse-vraie-t { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .bse-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.5s ease-out; }
  .bse-fleche.bse-trace { stroke-dashoffset: 0; transition: stroke-dashoffset 0.5s ease-out 0.6s; }
  .bse-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-linejoin: miter; }
  .bse-centre { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 4 5; }
  .bse-ecart { font-size: 28px; font-weight: 600; fill: var(--dk-accent); }
  .bse-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .bse-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .bse-cap { font-size: 22px; fill: var(--dk-encre); }
  .bse-etape { opacity: 0; transition: opacity 0.3s; }
  .bse-etape.bse-vu { opacity: 1; transition: opacity 0.5s 0.3s; }

  @media (prefers-reduced-motion: reduce) {
    .bse-barre { animation: none; }
    .bse-rouge, .bse-fleche, .bse-fleche.bse-trace, .bse-etape, .bse-etape.bse-vu { transition: none; }
  }
</style>
