<script>
  /**
   * La grammaire des graphiques : un graphique est un empilement de couches.
   * Trois feuilles à plat, côte à côte, arrivent une à la fois, puis
   * glissent l'une sur l'autre pour former un seul graphique.
   *
   *   0  Les données : un tableau, avec les noms de colonnes
   *      gdpPercap | lifeExp | continent (Gapminder, l'exemple de la suite)
   *      et des lignes vides.
   *   1  Les esthétiques, aes() : deux axes, x = gdpPercap et y = lifeExp.
   *   2  Les géométries, geom_...() : quelques points.
   *   3  Les trois feuilles glissent au centre et s'empilent : le tableau
   *      passe derrière (son bord dépasse), les axes et les points se
   *      superposent en un graphique fini. Dessous, les trois noms reliés
   *      par des « + ».
   *
   * Schéma pur : aucune donnée. Les points sont une liste fixe, sans
   * tendance : le schéma ne montre pas la relation, le vrai graphique de R
   * (Couches.svelte) s'en charge.
   * Source : Wickham (2010), « A Layered Grammar of Graphics ».
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Une feuille : 290 × 230 en coordonnées locales.
  const W = 290;
  const H = 230;
  // Côte à côte (temps 0 à 2) : trois feuilles alignées.
  const XS = [45, 355, 665];
  const Y = 60;
  // Empilées (temps 3) : au centre, agrandies ; le tableau dépasse derrière.
  const S = 1.3;
  const CX = 500 - (W * S) / 2;
  const CY = 175 - (H * S) / 2;
  const DECALE = 22;
  const pose = (i) =>
    e >= 3
      ? `translate(${i === 0 ? CX - DECALE : CX}px, ${i === 0 ? CY - DECALE : CY}px) scale(${S})`
      : `translate(${XS[i]}px, ${Y}px) scale(1)`;

  // Le tableau : trois colonnes, un en-tête, des lignes vides.
  const COLS = [
    { nom: 'gdpPercap', x: 50 },
    { nom: 'lifeExp', x: 141 },
    { nom: 'continent', x: 236 }
  ];
  const SEPARATEURS = [100, 182];
  const RANGEES = [80, 118, 156, 194];

  // Les axes : zone de tracé de x 58 à 274, de y 20 à 182.
  const X0 = 58;
  const X1 = 274;
  const Y0 = 20;
  const Y1 = 182;
  const TX = [100, 150, 200, 250];
  const TY = [60, 100, 140];

  // Les points : positions fixes, sans tendance.
  const POINTS = [
    [84, 120], [96, 70], [110, 150], [124, 98], [138, 56], [150, 132], [164, 86],
    [178, 160], [190, 110], [204, 64], [218, 140], [232, 92], [246, 120], [258, 74]
  ];

  const NOMS = [
    { nom: 'les données', code: '' },
    { nom: 'les esthétiques', code: 'aes()' },
    { nom: 'les géométries', code: 'geom_...()' }
  ];
</script>

<div class="visuel grammaire" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="Schéma de la grammaire des graphiques. Trois couches&#8239;: les données, un tableau aux colonnes gdpPercap, lifeExp et continent. Les esthétiques, aes(), qui placent le PIB par habitant en x et l’espérance de vie en y. Les géométries, geom_...(), des points. Les trois couches s’empilent en un seul graphique&#8239;: les données plus les esthétiques plus les géométries.">
    <text x="980" y="24" class="gr-note">schéma</text>

    <!-- Couche 1 : les données. Dessinée en premier, elle passe derrière. -->
    <g class="gr-feuille" style="transform: {pose(0)}">
      <rect x="0" y="0" width={W} height={H} class="gr-cadre" class:gr-rouge={e === 0} />
      <g class="gr-tableau" class:gr-efface={e >= 3}>
        {#each SEPARATEURS as x}
          <line x1={x} y1="0" x2={x} y2={H} class="gr-filet" />
        {/each}
        {#each RANGEES as y}
          <line x1="0" y1={y} x2={W} y2={y} class="gr-filet" />
        {/each}
        <line x1="0" y1="42" x2={W} y2="42" class="gr-trait" />
        {#each COLS as c}
          <text x={c.x} y="29" class="gr-col">{c.nom}</text>
        {/each}
      </g>
    </g>

    <!-- Couche 2 : les esthétiques. -->
    <g class="gr-feuille" class:gr-cache={e < 1} style="transform: {pose(1)}">
      <rect x="0" y="0" width={W} height={H} class="gr-cadre" class:gr-rouge={e === 1} />
      <line x1={X0} y1={Y0} x2={X0} y2={Y1} class="gr-trait" />
      <line x1={X0} y1={Y1} x2={X1} y2={Y1} class="gr-trait" />
      {#each TX as x}
        <line x1={x} y1={Y1} x2={x} y2={Y1 + 7} class="gr-trait" />
      {/each}
      {#each TY as y}
        <line x1={X0 - 7} y1={y} x2={X0} y2={y} class="gr-trait" />
      {/each}
      <text x={(X0 + X1) / 2} y="214" class="gr-axe"><tspan class="gr-xy">x =</tspan> gdpPercap</text>
      <text transform="translate(30 {(Y0 + Y1) / 2}) rotate(-90)" class="gr-axe"><tspan class="gr-xy">y =</tspan> lifeExp</text>
    </g>

    <!-- Couche 3 : les géométries. Sans fond : posée sur les axes, elle les laisse voir. -->
    <g class="gr-feuille" class:gr-cache={e < 2} style="transform: {pose(2)}">
      <rect x="0" y="0" width={W} height={H} class="gr-cadre gr-vide" class:gr-rouge={e === 2} />
      {#each POINTS as [x, y]}
        <circle cx={x} cy={y} r="7" class="gr-pt" />
      {/each}
    </g>

    <!-- Les noms, sous chaque feuille (temps 0 à 2). -->
    {#each NOMS as n, i}
      <g class="gr-nom" class:gr-cache={e < i || e >= 3}>
        <text x={XS[i] + W / 2} y="326" class="gr-titre" class:gr-titre-rouge={e === i}>{n.nom}</text>
        {#if n.code}<text x={XS[i] + W / 2} y="356" class="gr-code">{n.code}</text>{/if}
      </g>
    {/each}

    <!-- Temps 3 : une seule ligne, les trois couches reliées par des +. -->
    <text x="500" y="366" class="gr-titre gr-somme" class:gr-cache={e < 3}>les données <tspan class="gr-plus">+</tspan> les esthétiques <tspan class="gr-plus">+</tspan> les géométries</text>

    <image href="{base}/img/hex-ggplot2.png" x="0" y="398" width="48" height="55" class="gr-hex" />
    <text x="62" y="440" class="gr-source">Wickham (2010), A Layered Grammar of Graphics</text>
  </svg>
</div>

<style>
  .grammaire { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .gr-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  .gr-feuille { transition: transform 0.7s cubic-bezier(0.5, 0, 0.2, 1), opacity 0.4s; }
  .gr-cache { opacity: 0; }
  .gr-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; vector-effect: non-scaling-stroke; transition: stroke 0.3s; }
  .gr-cadre.gr-vide { fill: none; }
  .gr-cadre.gr-rouge { stroke: var(--dk-accent); stroke-width: 3; }
  .gr-trait { stroke: var(--dk-encre); stroke-width: 2.5; vector-effect: non-scaling-stroke; }
  .gr-filet { stroke: var(--dk-filet); stroke-width: 1.5; vector-effect: non-scaling-stroke; }
  .gr-tableau { transition: opacity 0.4s; }
  .gr-tableau.gr-efface { opacity: 0; }
  .gr-col { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .gr-axe { font-size: 18px; text-anchor: middle; fill: var(--dk-encre); font-weight: 600; }
  .gr-xy { fill: var(--dk-gris); font-weight: 400; }
  .gr-pt { fill: var(--dk-encre); }

  .gr-nom, .gr-somme { transition: opacity 0.4s; }
  .gr-somme { transition-delay: 0.35s; }
  .gr-somme.gr-cache { transition-delay: 0s; }
  .gr-titre { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.3s; }
  .gr-titre-rouge { fill: var(--dk-accent); }
  .gr-code { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }
  .gr-plus { fill: var(--dk-accent); font-weight: 700; }

  .gr-source { font-size: 18px; fill: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .gr-feuille, .gr-cadre, .gr-tableau, .gr-nom, .gr-somme, .gr-titre { transition: none; }
  }
</style>
