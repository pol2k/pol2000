<script>
  /**
   * À quoi ressemblent les paniers d'un lot à 100 g ? Trois ingrédients pour
   * dessiner le monde de l'acheteur, avant de compter les paniers. Cinq temps.
   *
   *   0  La question, au-dessus d'un axe des poids vide.
   *   1  La forme : une cloche (le théorème central limite). Une cloche pâle,
   *      pas encore à sa place.
   *   2  Le centre : la cloche glisse sur 100 g, ce que dit l'acheteur (H0).
   *   3  La largeur : combien les paniers varient d'un panier à l'autre
   *      (POMMES.erreurType, environ 2,5 g), beaucoup moins que les pommes
   *      (POMMES.ecartType, environ 17 g), parce que dans un panier de 50 les
   *      grosses et les petites s'annulent (comme la taille d'une classe). En pointillé gris, à titre de schéma, la
   *      cloche qu'on aurait si les pommes variaient beaucoup plus.
   *   4  Son panier, 105 g : dans la cloche large, rien d'étonnant. Dans la
   *      vraie, au bout de la queue. On peut maintenant compter.
   *
   * La vraie cloche a la largeur de l'erreur type de la pomicultrice
   * (POMMES.erreurType, calculée par outils/seance5_data.R). La cloche large
   * est un schéma, trois fois plus large, dite telle à l'écran.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const G0 = 88, G1 = 112, X0 = 70, X1 = 930, BASE = 350, HAUT = 170;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const cloche = (centre, et, h) => {
    const pts = [];
    for (let k = -40; k <= 40; k++) {
      const z = k / 10;
      const g = centre + z * et;
      if (g < G0 || g > G1) continue;
      pts.push(`${x(g).toFixed(1)} ${(BASE - h * Math.exp(-0.5 * z * z)).toFixed(1)}`);
    }
    return 'M ' + pts.join(' L ');
  };
  const ET = POMMES.erreurType;
  const VRAIE = cloche(POMMES.h0, ET, HAUT);
  const LARGE = cloche(POMMES.h0, ET * 3, HAUT / 3);
  // Avant le temps 2, la cloche n'est pas encore à sa place : décalée à gauche.
  const DECALAGE = x(POMMES.h0) - x(POMMES.h0 - 6);
  const XP = x(POMMES.moyenne);
  const ETAPES = [
    { n: '1', mot: 'la forme', quoi: 'une cloche', pourquoi: 'le théorème central limite' },
    { n: '2', mot: 'le centre', quoi: `${POMMES.h0} g`, pourquoi: 'ce que dit l’acheteur' },
    { n: '3', mot: 'la largeur', quoi: `les paniers varient de ${f(POMMES.erreurType, 1)}\u202fg`, pourquoi: `pas ${f(POMMES.ecartType)}\u202fg comme une pomme` }
  ];
</script>

<div class="visuel trois-ingredients" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="À quoi ressemblent les paniers d’un lot à {POMMES.h0} g ? Trois ingrédients. La forme : une cloche, grâce au théorème central limite. Le centre : {POMMES.h0} g, ce que dit l’acheteur. La largeur : les paniers de {POMMES.n} pommes varient d’environ {f(POMMES.erreurType, 1)} g, pas {f(POMMES.ecartType)} g comme une pomme, parce que les grosses et les petites s’annulent. Son panier de {POMMES.moyenne} g tombe au bout de la cloche.">
    <text x={X0} y="34" class="ti-question">À quoi ressemblent les paniers d’un lot à {POMMES.h0}&#8239;g&#8239;?</text>

    <!-- Les trois ingrédients, en colonne à gauche. -->
    {#each ETAPES as s, i}
      <g class="ti-etape" class:ti-vu={e >= i + 1}>
        <text x={X0} y={78 + i * 30} class="ti-ing"><tspan class="ti-num">{s.n}</tspan> {s.mot}&#8239;: <tspan class="ti-quoi">{s.quoi}</tspan> <tspan class="ti-pq">({s.pourquoi})</tspan></text>
      </g>
    {/each}

    <!-- 3 : la cloche large, en schéma. -->
    <g class="ti-etape" class:ti-vu={e >= 3}>
      <path d={LARGE} class="ti-large" />
      <text x={x(G0) + 4} y={BASE - HAUT / 3 - 30} class="ti-note">en pointillé&#8239;: si les pommes</text>
      <text x={x(G0) + 4} y={BASE - HAUT / 3 - 10} class="ti-note">variaient beaucoup plus (schéma)</text>
    </g>

    <!-- 1 et 2 : la vraie cloche, qui glisse à sa place. -->
    <g class="ti-cloche" class:ti-vu={e >= 1} style:transform="translateX({e >= 2 ? 0 : -DECALAGE}px)">
      <path d={VRAIE} class="ti-vraie" class:ti-placee={e >= 2} />
    </g>
    <g class="ti-etape" class:ti-vu={e >= 2}>
      <line x1={x(POMMES.h0)} y1={BASE - HAUT - 14} x2={x(POMMES.h0)} y2={BASE} class="ti-centre" />
    </g>

    <!-- L'axe. -->
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ti-axe" />
    {#each [90, 95, 100, 105, 110] as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 8} class="ti-axe" />
      <text x={x(g)} y={BASE + 30} class="ti-tick" class:ti-cent={g === POMMES.h0}>{g}&#8239;g</text>
    {/each}
    <text x={X1} y={BASE + 56} class="ti-tick ti-fin">poids moyen d’un panier de {POMMES.n}</text>

    <!-- 4 : son panier. -->
    <g class="ti-etape" class:ti-vu={e >= 4}>
      <line x1={XP} y1={BASE - HAUT + 20} x2={XP} y2={BASE} class="ti-panier" />
      <circle cx={XP} cy={BASE} r="9" class="ti-point" />
      <text x={XP + 14} y={BASE - HAUT + 40} class="ti-lab">son panier&#8239;: {POMMES.moyenne}&#8239;g</text>
      <text x="500" y="456" class="ti-phrase">Dans le monde de l’acheteur, 105&#8239;g, c’est au bout de la cloche.</text>
      <text x="500" y="486" class="ti-phrase-2">Combien de paniers pèsent autant&#8239;? On va compter.</text>
    </g>
  </svg>
</div>

<style>
  .trois-ingredients { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ti-question { font-size: 25px; font-weight: 700; fill: var(--dk-encre); }
  .ti-ing { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .ti-num { fill: var(--dk-accent); font-weight: 700; }
  .ti-quoi { fill: var(--dk-accent); }
  .ti-pq { fill: var(--dk-gris); font-weight: 400; }
  .ti-large { fill: none; stroke: var(--dk-gris); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ti-note { font-size: 16px; fill: var(--dk-gris); }
  .ti-fin { text-anchor: end; }
  .ti-cloche { opacity: 0; transition: opacity 0.4s, transform 0.9s ease-in-out; }
  .ti-cloche.ti-vu { opacity: 1; }
  .ti-vraie { fill: var(--dk-fond-2); stroke: var(--dk-gris-2); stroke-width: 4; transition: stroke 0.6s; }
  .ti-vraie.ti-placee { stroke: var(--dk-encre); }
  .ti-centre { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ti-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ti-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ti-tick.ti-fin { text-anchor: end; }
  .ti-cent { font-weight: 700; fill: var(--dk-encre); }
  .ti-panier { stroke: var(--dk-accent); stroke-width: 4; }
  .ti-point { fill: var(--dk-accent); }
  .ti-lab { font-size: 21px; font-weight: 700; fill: var(--dk-accent); }
  .ti-phrase { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ti-phrase-2 { font-size: 20px; text-anchor: middle; fill: var(--dk-accent); font-weight: 600; }
  .ti-etape { opacity: 0; transition: opacity 0.3s; }
  .ti-etape.ti-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .ti-etape, .ti-etape.ti-vu, .ti-cloche, .ti-vraie { transition: none; }
  }
</style>
