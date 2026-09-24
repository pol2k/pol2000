<script>
  /**
   * Notre objectif : l'échelle d'abstraction des données (d'après le cours 4
   * de FAS1001). Une flèche verticale; en haut les données non structurées
   * (images, sons), au milieu les semi-structurées (textes, journaux), en bas
   * les structurées (un tableau). Le cours travaille en bas : un sondage
   * devient un tableau propre, prêt pour l'analyse.
   *
   *   0  La flèche et le premier niveau : non structurées.
   *   1  Semi-structurées.
   *   2  Structurées, le tableau.
   *   3  À droite, une grande flèche rouge descend du haut jusqu'au tableau
 *      (« structurer ») : peu importe la source, notre travail est de la
 *      ramener à un tableau en deux dimensions, lignes × colonnes. Les deux
 *      premiers niveaux pâlissent; le tableau passe au rouge.
   *
   * Tout est dessiné à la main, sans image : rien de mesuré n'est suggéré.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Trois rangées, de haut en bas; y est le centre de la rangée.
  const RANGEES = [
    { y: 75, nom: 'Non structurées', ex: 'images · sons' },
    { y: 235, nom: 'Semi-structurées', ex: 'textes · journaux · débats' },
    { y: 395, nom: 'Structurées', ex: 'sondages · données économiques' }
  ];

  // L'onde sonore : des hauteurs fixes, pas de hasard.
  const ONDE = [10, 22, 34, 18, 40, 26, 12, 30, 44, 20, 8];
  // Le tableau : 4 colonnes, 1 en-tête + 3 lignes.
  const TX = 95, TY = 350, TW = 170, TH = 90, NC = 4, NL = 4;
</script>

<div class="visuel objectif" bind:this={hote}>
  <svg viewBox="-10 0 1000 505" role="img" aria-label="Échelle d'abstraction des données. En haut, les données non structurées : images et sons. Au milieu, les données semi-structurées : textes, journaux, débats. En bas, les données structurées, en tableau : sondages et données économiques. Une flèche descend de chaque niveau vers le tableau : notre travail est de structurer les données en un tableau en deux dimensions, lignes et colonnes.">
    <!-- la flèche : de plus en plus abstrait vers le haut -->
    <g class="fleche">
      <line x1="30" y1="490" x2="30" y2="22" />
      <polyline points="16,40 30,18 44,40" />
      <text x="0" y="0" transform="translate(12 255) rotate(-90)" class="axe">abstraction</text>
    </g>

    <!-- 1 · non structurées : une image et une onde sonore -->
    <g class="rangee" class:vu={e >= 0} class:efface={e >= 3}>
      <g class="glyphe">
        <rect x="95" y="35" width="95" height="75" />
        <circle cx="165" cy="57" r="9" />
        <polyline points="95,110 125,72 145,92 160,80 190,110" />
        {#each ONDE as h, k}
          <line x1={210 + k * 6} y1={RANGEES[0].y - h / 2} x2={210 + k * 6} y2={RANGEES[0].y + h / 2} class="onde" />
        {/each}
      </g>
      <text x="310" y={RANGEES[0].y - 4} class="nom">{RANGEES[0].nom}</text>
      <text x="310" y={RANGEES[0].y + 34} class="ex">{RANGEES[0].ex}</text>
    </g>

    <!-- 2 · semi-structurées : un journal -->
    <g class="rangee" class:vu={e >= 1} class:efface={e >= 3}>
      <g class="glyphe">
        <rect x="120" y="190" width="100" height="92" />
        <line x1="132" y1="206" x2="208" y2="206" class="gras" />
        <rect x="132" y="218" width="34" height="26" class="plein" />
        <line x1="174" y1="222" x2="208" y2="222" />
        <line x1="174" y1="232" x2="208" y2="232" />
        <line x1="174" y1="242" x2="200" y2="242" />
        <line x1="132" y1="256" x2="208" y2="256" />
        <line x1="132" y1="266" x2="208" y2="266" />
        <line x1="132" y1="274" x2="186" y2="274" />
      </g>
      <text x="310" y={RANGEES[1].y - 4} class="nom">{RANGEES[1].nom}</text>
      <text x="310" y={RANGEES[1].y + 34} class="ex">{RANGEES[1].ex}</text>
    </g>

    <!-- 3 · structurées : un tableau, une ligne par répondant -->
    <g class="rangee structure" class:vu={e >= 2} class:cible={e >= 3}>
      <rect x="70" y="325" width="890" height="175" class="cadre" />
      <g class="glyphe">
        <rect x={TX} y={TY} width={TW} height={TH / NL} class="entete" />
        <rect x={TX} y={TY} width={TW} height={TH} />
        {#each Array(NL - 1) as _, k}
          <line x1={TX} y1={TY + ((k + 1) * TH) / NL} x2={TX + TW} y2={TY + ((k + 1) * TH) / NL} />
        {/each}
        {#each Array(NC - 1) as _, k}
          <line x1={TX + ((k + 1) * TW) / NC} y1={TY} x2={TX + ((k + 1) * TW) / NC} y2={TY + TH} />
        {/each}
      </g>
      <text x="310" y={RANGEES[2].y - 4} class="nom">{RANGEES[2].nom}</text>
      <text x="310" y={RANGEES[2].y + 34} class="ex">{RANGEES[2].ex}</text>
      <text x="310" y={RANGEES[2].y + 76} class="dim">lignes × colonnes</text>
      <text x="945" y="484" class="etiquette">POL-2000</text>
    </g>

    <!-- 4 · notre travail : tout descend vers le tableau -->
    <g class="descente" class:vu={e >= 3}>
      <line x1="890" y1="30" x2="890" y2="318" />
      <polyline points="870,294 890,322 910,294" />
      <text x="0" y="0" transform="translate(922 175) rotate(90)" class="verbe">structurer</text>
    </g>
  </svg>
</div>

<style>
  .objectif { display: flex; flex-direction: column; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .fleche line, .fleche polyline { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .fleche line { stroke-dasharray: 470; stroke-dashoffset: 470; animation: trace 0.9s 0.1s ease-out forwards; }

  .rangee { opacity: 0; transform: translateY(14px); transition: opacity 0.5s, transform 0.5s cubic-bezier(0.34, 1.3, 0.64, 1); }
  .rangee.vu { opacity: 1; transform: none; }
  .rangee.vu.efface { opacity: 0.35; }

  .glyphe rect, .glyphe line, .glyphe polyline, .glyphe circle { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .glyphe .plein { fill: var(--dk-gris-2); stroke: none; }
  .glyphe .gras { stroke-width: 6; }
  .glyphe .onde { stroke: var(--dk-gris); stroke-width: 3.5; }
  .glyphe .entete { fill: var(--dk-encre); stroke: none; transition: fill 0.5s; }

  .nom { font-size: 38px; font-weight: 600; fill: var(--dk-encre); transition: fill 0.5s; }
  .axe { font-size: 22px; letter-spacing: 0.08em; text-anchor: middle; fill: var(--dk-gris); }
  .ex { font-size: 25px; fill: var(--dk-gris); }

  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 3; opacity: 0; transition: opacity 0.5s; }
  .etiquette { font-size: 24px; font-weight: 600; letter-spacing: 0.06em; text-anchor: end; fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s 0.2s; }

  .dim { font-size: 27px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s 0.6s; }

  /* la flèche de droite : se trace vers le bas, en rouge */
  .descente line, .descente polyline { fill: none; stroke: var(--dk-accent); stroke-width: 8; stroke-linejoin: miter; }
  .descente line { stroke-dasharray: 290; stroke-dashoffset: 290; transition: stroke-dashoffset 0.7s ease-out; }
  .descente polyline, .descente .verbe { opacity: 0; transition: opacity 0.3s 0.6s; }
  .descente.vu line { stroke-dashoffset: 0; }
  .descente.vu polyline, .descente.vu .verbe { opacity: 1; }
  .verbe { font-size: 34px; font-weight: 600; letter-spacing: 0.04em; text-anchor: middle; fill: var(--dk-accent); }

  .cible .cadre, .cible .etiquette, .cible .dim { opacity: 1; }
  .cible .glyphe rect, .cible .glyphe line { stroke: var(--dk-accent); }
  .cible .glyphe .entete { fill: var(--dk-accent); }
  .cible .nom { fill: var(--dk-accent); }

  @keyframes trace { to { stroke-dashoffset: 0; } }
  @media (prefers-reduced-motion: reduce) {
    .fleche line { animation: none; stroke-dashoffset: 0; }
    .rangee, .cadre, .etiquette, .nom, .dim, .glyphe .entete, .descente line, .descente polyline, .descente .verbe { transition: none; }
  }
</style>
