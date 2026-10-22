<script>
  /**
   * Le genre sort du bruit et entre dans le modèle. Notre sondage de la
   * séance 7 (1 000, graine 62), les 877 qui ont répondu à toutes les
   * questions du modèle de la séance 7 : les mêmes que la diapo suivante
   * (M8Pente) et que l'escalier, pour que la droite seule soit partout la
   * même. La figure 5.4 d'Arel-Bundock (2021) refaite dans la CES :
   * interet ~ scolarite, puis interet ~ scolarite + femme.
   *
   *   0  le nuage, gris, et une seule droite (la scolarité seule). Le genre
   *      est dans le bruit, autour de la droite;
   *   1  il en sort : les points prennent leur couleur, et l'intérêt moyen
   *      de chaque groupe (gros points) se détache de la droite. Les hommes
   *      au-dessus, les femmes en dessous : les traits verticaux, c'est la
   *      part du bruit qui vient du genre;
   *   2  il entre dans le modèle : la droite se dédouble en deux droites
   *      parallèles, et les traits fondent (chaque moyenne retrouve sa
   *      droite);
   *   3  l'écart entre les deux droites, le même partout, et la pente,
   *      la même pour tout le monde. À droite, la pente de la scolarité,
   *      du début à la fin : le genre ne la change presque pas (+0,19 avant
   *      et après; l'âge, sur la diapo suivante, la fait bouger).
   *
   * Les chiffres viennent de GENRE (src/lib/data/seance8_bruit.js,
   * outils/seance8_bruit.R); les points étalés (jx et jy, pour le dessin
   * seulement) de PARALLELES, filtrés sur les 877 (POINTS[i].m). Les gros points :
   * l'intérêt moyen par niveau et par genre, leur aire selon le nombre de
   * personnes (12 seulement au premier niveau, d'où leur petite taille).
   * Les axes sont ceux de M8Pente, la diapo suivante : les mêmes points au
   * même endroit.
   */
  import { Tween } from 'svelte/motion';
  import { cubicInOut } from 'svelte/easing';
  import { brancherTemps } from '../temps.js';
  import { PARALLELES as P } from '$lib/data/seance8.js';
  import { GENRE as G, POINTS } from '$lib/data/seance8_bruit.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // 0 : une droite; 1 : deux droites.
  const lent = () => typeof window !== 'undefined' && !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const t = new Tween(0, { duration: 900, easing: cubicInOut });
  $effect(() => {
    t.set(e >= 2 ? 1 : 0, { duration: e === 0 || !lent() ? 0 : 900 });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  const X0 = 200, LX = 580, Y0 = 452, LY = 400;
  const px = (x) => X0 + x * LX;
  const py = (y) => Y0 - y * LY;
  const S0 = G.seule.b0, S1 = G.seule.b1;
  const D0 = G.deux.b0, D1 = G.deux.b1, DF = G.deux.femme;
  const PTS = P.points.filter((p, i) => POINTS[i].m === 1);
  const NIV = ['Secondaire non terminé', 'Secondaire', 'Collégial', 'Université, 1er cycle', 'Maîtrise, doctorat'];

  // La droite de chaque groupe, de la droite seule (t = 0) à la sienne (t = 1).
  const droite = (fm, x, k) => (1 - k) * (S0 + S1 * x) + k * (D0 + (fm ? DF : 0) + D1 * x);
  const MOY = G.moyennes;
  const fin = (fm) => MOY.find((m) => m.femme === fm && m.x === 1).moyenne;
  const rayon = (n) => 3 + Math.sqrt(n) * 0.85;
  const PAN = 960; // la colonne de droite
  const XG = 0.125; // l'écart se mesure entre deux niveaux, loin des points
</script>

<div class="visuel m8p" bind:this={hote}>
  <svg viewBox="0 0 1200 560" role="img" aria-label="Notre sondage : l'intérêt pour la politique selon la scolarité. Une seule droite, pente {sg(S1)}. En couleur, les hommes sont au-dessus de la droite, les femmes en dessous. Avec le sexe dans le modèle, deux droites parallèles de même pente, {sg(D1)}, séparées par un écart de {f(DF)}.">
    <!-- Axes -->
    <line x1={X0 - 50} y1={Y0 + 10} x2={X0 + LX + 40} y2={Y0 + 10} class="axe" />
    <line x1={X0 - 50} y1={Y0 + 10} x2={X0 - 50} y2={py(1) - 6} class="axe" />
    {#each [0, 0.5, 1] as v}
      <text x={X0 - 62} y={py(v) + 7} class="tick fin">{f(v, v % 1 ? 1 : 0)}</text>
    {/each}
    <text x={X0 - 50} y={py(1) - 22} class="titre-axe">intérêt pour la politique</text>
    {#each NIV as n, i}
      <text x={px(i / 4)} y={Y0 + 38} class="niv">{#each n.split(/, | (?=non)/) as l, k}<tspan x={px(i / 4)} dy={k ? 20 : 0}>{l}</tspan>{/each}</text>
    {/each}

    <!-- Les personnes -->
    {#each PTS as p}
      <circle cx={px(p.jx)} cy={py(p.jy)} r="3.2" class="pt" class:pt-f={e >= 1 && p.femme === 1} class:pt-h={e >= 1 && p.femme === 0} />
    {/each}

    <!-- 1 : ce que le genre laissait dans le bruit (moyenne → droite) -->
    <g class="etape" class:vu={e >= 1}>
      {#each MOY as m}
        <line x1={px(m.x)} y1={py(m.moyenne)} x2={px(m.x)} y2={py(droite(m.femme, m.x, t.current))} class="trait" class:trait-f={m.femme === 1} />
      {/each}
    </g>

    <!-- Les droites : une seule, qui se dédouble -->
    <line x1={px(0)} y1={py(droite(0, 0, t.current))} x2={px(1)} y2={py(droite(0, 1, t.current))} class="dr" />
    <line x1={px(0)} y1={py(droite(1, 0, t.current))} x2={px(1)} y2={py(droite(1, 1, t.current))} class="dr dr-f" class:cache={e < 2} />

    <!-- 1 : les moyennes de chaque groupe -->
    <g class="etape" class:vu={e >= 1}>
      {#each MOY as m}
        <circle cx={px(m.x)} cy={py(m.moyenne)} r={rayon(m.n)} class="moy" class:moy-f={m.femme === 1} />
      {/each}
    </g>

    <!-- Étiquettes au bout des droites -->
    <g class="etape" class:vu={e < 2}>
      <text x={px(1) + 26} y={py(S0 + S1) + 8} class="lab">tout le monde</text>
    </g>
    <g class="etape" class:vu={e >= 1 && e < 2}>
      <text x={px(1) + 26} y={py(fin(0)) - 10} class="lab-p">hommes</text>
      <text x={px(1) + 26} y={py(fin(1)) + 30} class="lab-p rouge">femmes</text>
    </g>
    <g class="etape" class:vu={e >= 2}>
      <text x={px(1) + 26} y={py(D0 + D1) + 2} class="lab">hommes</text>
      <text x={px(1) + 26} y={py(D0 + DF + D1) + 18} class="lab rouge">femmes</text>
    </g>

    <!-- 3 : l'écart, le même partout, et la même pente -->
    <g class="etape" class:vu={e >= 3}>
      {#each [XG, 0.875] as xg}
        <line x1={px(xg)} y1={py(D0 + D1 * xg) + 5} x2={px(xg)} y2={py(D0 + DF + D1 * xg) - 5} class="ecart" />
        <line x1={px(xg) - 10} y1={py(D0 + D1 * xg)} x2={px(xg) + 10} y2={py(D0 + D1 * xg)} class="ecart" />
        <line x1={px(xg) - 10} y1={py(D0 + DF + D1 * xg)} x2={px(xg) + 10} y2={py(D0 + DF + D1 * xg)} class="ecart" />
      {/each}
      <text x={px(XG) + 18} y={py(D0 + DF + D1 * XG) + 46} class="gros rouge">écart{' '}: {f(DF)}</text>
    </g>

    <!-- À droite : la légende, puis la pente -->
    <g class="etape" class:vu={e >= 1}>
      <text x={PAN} y="34" class="leg"><tspan class="rouge">●</tspan> femmes</text>
      <text x={PAN} y="68" class="leg">● hommes</text>
    </g>
    <text x={PAN} y="220" class="pan-nom">pente</text>
    <text x={PAN} y="262" class="pan-val">{sg(e >= 2 ? D1 : S1)}</text>
    <g class="etape" class:vu={e >= 3}>
      <text x={PAN} y="294" class="pan-nom">la même</text>
      <text x={PAN} y="320" class="pan-nom">pour les deux</text>
    </g>

    <text x="0" y="552" class="source">Notre sondage de la séance 7 · {G.n} personnes · gros points{' '}: intérêt moyen par niveau et par sexe</text>
  </svg>
</div>

<style>
  .m8p { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 20px; fill: var(--dk-gris); }
  .fin { text-anchor: end; }
  .titre-axe { font-size: 20px; fill: var(--dk-gris); }
  .niv { font-size: 17px; fill: var(--dk-gris); text-anchor: middle; }

  .pt { fill: var(--dk-gris-2); opacity: 0.32; transition: fill 0.5s, opacity 0.5s; }
  .pt.pt-f { fill: var(--dk-accent); opacity: 0.3; }
  .pt.pt-h { fill: var(--dk-encre); opacity: 0.26; }

  .dr { stroke: var(--dk-encre); stroke-width: 6; }
  .dr-f { stroke: var(--dk-accent); transition: opacity 0.2s; }
  .dr-f.cache { opacity: 0; }

  .trait { stroke: var(--dk-encre); stroke-width: 4; }
  .trait-f { stroke: var(--dk-accent); }
  .moy { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; }
  .moy-f { fill: var(--dk-accent); }

  .ecart { stroke: var(--dk-accent); stroke-width: 4; }
  .lab, .lab-p, .gros { paint-order: stroke; stroke: var(--dk-fond); stroke-width: 7px; stroke-linejoin: round; }
  .lab { font-size: 23px; font-weight: 700; fill: var(--dk-encre); }
  .lab-p { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .leg { font-size: 22px; font-weight: 600; white-space: pre; fill: var(--dk-encre); }
  .gros { font-size: 27px; font-weight: 700; fill: var(--dk-encre); }
  .pan-nom { font-size: 21px; fill: var(--dk-gris); }
  .pan-val { font-size: 34px; font-weight: 700; fill: var(--dk-encre); }
  .rouge, .rouge tspan, tspan.rouge { fill: var(--dk-accent); }
  .source { font-size: 17px; fill: var(--dk-gris); }

  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .etape, .pt, .dr-f { transition: none; } }
</style>
