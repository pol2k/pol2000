<script>
  /**
   * Deux droites parallèles : ce qu'une variable binaire fait à la droite.
   * Notre sondage de la séance 7 (1 000, graine 62), les personnes qui ont
   * répondu aux trois questions (PARALLELES.n). C'est la figure 5.4
   * d'Arel-Bundock (2021) (la taille de la mère, puis « femme »), refaite
   * dans la CES : interet ~ scolarite + femme.
   *
   *   0  le nuage, gris, et la droite de la séance 7 (scolarité seule);
   *   1  les points prennent leur couleur : femmes en rouge, hommes à l'encre;
   *   2  la droite seule s'efface, deux droites parallèles la remplacent :
   *      la même pente pour tout le monde;
   *   3  l'écart entre les deux droites, partout le même : le coefficient
   *      de « femme », à scolarité égale.
   *
   * Tout vient de PARALLELES (src/lib/data/seance8.js, outils/seance8_data.R).
   * jx et jy étalent les points pour le dessin seulement.
   */
  import { brancherTemps } from '../temps.js';
  import { PARALLELES as P } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  const X0 = 170, LX = 640, Y0 = 452, LY = 410;
  const px = (x) => X0 + x * LX;
  const py = (y) => Y0 - y * LY;
  const S0 = P.seule[0].b, S1 = P.seule[1].b;
  const D0 = P.deux[0].b, D1 = P.deux[1].b, DF = P.deux[2].b;
  const NIV = ['Secondaire non terminé', 'Secondaire', 'Collégial', 'Université, 1er cycle', 'Maîtrise, doctorat'];
  const XG = 0.5; // où l'on mesure l'écart
</script>

<div class="visuel m8p" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label="Notre sondage : l'intérêt pour la politique selon la scolarité. Seule, la pente est {sg(S1)}. Avec « femme » dans le modèle, deux droites parallèles de pente {sg(D1)}, celle des femmes {f(DF)} plus bas, à scolarité égale.">
    <!-- Axes -->
    <line x1={X0 - 50} y1={Y0} x2={X0 + LX + 50} y2={Y0} class="axe" />
    <line x1={X0 - 50} y1={Y0} x2={X0 - 50} y2={py(1)} class="axe" />
    {#each [0, 0.5, 1] as t}
      <text x={X0 - 62} y={py(t) + 6} class="tick fin">{f(t, t % 1 ? 1 : 0)}</text>
    {/each}
    <text x={X0 - 50} y={py(1) - 14} class="titre-axe">intérêt (0 à 1)</text>
    {#each NIV as n, i}
      <text x={px(i / 4)} y={Y0 + 26} class="niv">{#each n.split(/, | (?=non)/) as l, k}<tspan x={px(i / 4)} dy={k ? 18 : 0}>{l}</tspan>{/each}</text>
    {/each}

    <!-- Les points -->
    {#each P.points as p}
      <circle cx={px(p.jx)} cy={py(p.jy)} r="3.2" class="pt" class:pt-f={e >= 1 && p.femme === 1} class:pt-h={e >= 1 && p.femme === 0} />
    {/each}

    <!-- 0 : la droite seule -->
    <g class="etape" class:vu={e < 2}>
      <line x1={px(0)} y1={py(S0)} x2={px(1)} y2={py(S0 + S1)} class="dr-seule" />
      <text x={px(1) + 14} y={py(S0 + S1) + 8} class="lab">seule{' '}: {sg(S1)}</text>
    </g>

    <!-- 1 : la légende -->
    <g class="etape" class:vu={e >= 1}>
      <text x={X0 + 190} y="26" class="leg"><tspan class="rouge">● femmes</tspan>   <tspan>● hommes</tspan></text>
    </g>

    <!-- 2 : deux droites parallèles -->
    <g class="etape" class:vu={e >= 2}>
      <line x1={px(0)} y1={py(D0)} x2={px(1)} y2={py(D0 + D1)} class="dr dr-h" />
      <line x1={px(0)} y1={py(D0 + DF)} x2={px(1)} y2={py(D0 + DF + D1)} class="dr dr-f" />
      <text x={px(1) + 14} y={py(D0 + D1) + 2} class="lab">hommes</text>
      <text x={px(1) + 14} y={py(D0 + DF + D1) + 14} class="lab rouge">femmes</text>
      <text x="996" y="26" class="gros fin">même pente{' '}: {sg(D1)}</text>
    </g>

    <!-- 3 : l'écart, à scolarité égale -->
    <g class="etape" class:vu={e >= 3}>
      <line x1={px(XG)} y1={py(D0 + D1 * XG) + 4} x2={px(XG)} y2={py(D0 + DF + D1 * XG) - 4} class="ecart" />
      <text x={px(XG) + 14} y={py(D0 + D1 * XG + DF / 2) + 10} class="gros rouge">femme{' '}: {sg(DF)}</text>
      <text x={px(XG) + 14} y={py(D0 + D1 * XG + DF / 2) + 40} class="lab">à scolarité égale</text>
    </g>

    <text x="0" y="534" class="source">Notre sondage de la séance 7 · les {P.n} qui ont répondu aux trois questions (scolarité, intérêt, genre)</text>
  </svg>
</div>

<style>
  .m8p { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 18px; fill: var(--dk-gris); }
  .fin { text-anchor: end; }
  .titre-axe { font-size: 18px; fill: var(--dk-gris); }
  .niv { font-size: 15px; fill: var(--dk-gris); text-anchor: middle; }
  .pt { fill: var(--dk-gris-2); opacity: 0.3; transition: fill 0.4s, opacity 0.4s; }
  .pt.pt-f { fill: var(--dk-accent); opacity: 0.35; }
  .pt.pt-h { fill: var(--dk-encre); opacity: 0.3; }
  .dr-seule { stroke: var(--dk-encre); stroke-width: 6; }
  .dr { stroke-width: 6; }
  .dr-h { stroke: var(--dk-encre); }
  .dr-f { stroke: var(--dk-accent); }
  .ecart { stroke: var(--dk-accent); stroke-width: 4; marker-end: none; }
  .lab, .gros { paint-order: stroke; stroke: var(--dk-fond); stroke-width: 7px; stroke-linejoin: round; }
  .lab { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .leg { font-size: 21px; font-weight: 600; white-space: pre; fill: var(--dk-encre); }
  .gros { font-size: 26px; font-weight: 700; fill: var(--dk-encre); }
  .rouge, .rouge tspan { fill: var(--dk-accent); }
  .source { font-size: 15px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .etape, .pt { transition: none; } }
</style>
