<script>
  /**
   * Pourquoi des carrés ? Juste après « Comment ça marche ? » (RegMoindres).
   * Les mêmes quinze vraies personnes (QUINZE, outils/seance7_data.R), deux
   * fois : à gauche la droite de lm(), à droite une autre droite, qui
   * descend. Les deux passent par le point moyen (scolarité moyenne 0,67,
   * intérêt moyen 0,67) : pour toute droite qui passe par ce point, les
   * écarts au-dessus et au-dessous s'annulent exactement.
   *
   *   0  Les deux droites sur les mêmes points.
   *   1  Les distances, avec leur sens : au-dessus (rouge, +), au-dessous
   *      (encre, −). Additionnées : +1,79 − 1,79 = 0 à gauche, +2,09 − 2,09
   *      = 0 à droite. La même somme pour deux droites très différentes :
   *      additionner les écarts avec leur sens ne peut pas choisir.
   *   2  Les carrés : un carré n'est jamais négatif, tout le monde compte.
   *      Aire totale : 1,25 à gauche, 1,62 à droite.
   *   3  À droite, un encart sans données : un écart de 2 contre deux écarts
   *      de 1. En distance, égalité (2 = 1 + 1). En aire, 4 contre 2 : un
   *      gros raté pèse plus que deux petits.
   *   4  Une seule droite a la plus petite aire totale : celle de lm(), « les
   *      moindres carrés ». L'autre pâlit.
   *
   * Tous les nombres viennent de POURQUOI (outils/seance7_j.R, qui refait
   * QUINZE et vérifie l'accord avec seance7_data.R et seance7_b.R). La droite
   * qui descend ici (pente −0,5 par le point moyen, aire 1,62) n'est pas
   * celle de la diapo précédente (0,95 − 0,5 × x, aire 1,67) : elle doit
   * passer par le point moyen pour que la somme fasse 0. D'où son étiquette,
   * « une autre droite ». Les points qui partagent une case sont rangés côte
   * à côte, comme dans RegMoindres.
   */
  import { brancherTemps } from '../temps.js';
  import { QUINZE } from '$lib/data/seance7.js';
  import { POURQUOI } from '$lib/data/seance7_j.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Deux petits repères identiques, de 0 à 1 dans les deux sens.
  const T = 250, HAUT = 46;
  const GAUCHE = [60, 384];
  const PAS = 9;
  const sy = (v) => HAUT + T - v * T;

  // Les points rangés côte à côte dans leur case (même règle que RegMoindres).
  const placer = (x0) => {
    const groupes = new Map();
    QUINZE.points.forEach((p, i) => {
      const k = p.x + '|' + p.y;
      if (!groupes.has(k)) groupes.set(k, []);
      groupes.get(k).push({ ...p, i });
    });
    const out = [];
    for (const g of groupes.values()) {
      g.sort((a, b) => a.jx - b.jx);
      g.forEach((p, j) => out.push({ ...p, px: x0 + p.x * T + (j - (g.length - 1) / 2) * PAS }));
    }
    return out.sort((a, b) => a.i - b.i);
  };

  const PANNEAUX = POURQUOI.droites.map((d, k) => {
    const x0 = GAUCHE[k];
    const auPixel = (px) => d.b0 + d.b1 * ((px - x0) / T);
    const pts = placer(x0).map((p) => {
      const sur = auPixel(p.px);
      const res = p.y - (d.b0 + d.b1 * p.x);
      const cote = Math.abs(p.y - sur) * T;
      return { ...p, sur, dessus: res > 0, cote };
    });
    return { ...d, x0, pts, titre: k === 0 ? 'la droite de lm()' : 'une autre droite, qui descend' };
  });

  const virgule = (v, d = 2) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });

  // L'encart du gros écart : une unité = 38 px.
  const U = 38;
  const G = POURQUOI.gros;
  const PHRASE = [
    '',
    'au-dessus et au-dessous s’annulent : 0 pour les deux droites',
    'un carré n’est jamais négatif : tout le monde compte',
    'un gros écart pèse plus que deux petits',
    'une seule droite a la plus petite aire : les moindres carrés'
  ];
</script>

<div class="visuel rc" bind:this={hote}>
  <svg viewBox="0 0 1000 440" role="img"
    aria-label="Les mêmes quinze personnes, deux droites très différentes. Les écarts au-dessus et au-dessous s’annulent : 0 pour les deux. Au carré, l'aire totale vaut {virgule(PANNEAUX[0].carres)} pour la droite de lm et {virgule(PANNEAUX[1].carres)} pour l'autre. Un écart de 2 donne une aire de {G.aire_un}, deux écarts de 1 une aire de {G.aire_deux}. Une seule droite a la plus petite aire : les moindres carrés.">
    <defs>
      {#each PANNEAUX as P, k}
        <clipPath id="rc-cadre-{k}"><rect x={P.x0 - 22} y={HAUT - 8} width={T + 36} height={T + 16} /></clipPath>
      {/each}
    </defs>

    {#each PANNEAUX as P, k}
      <g class="panneau" class:pale={e >= 4 && k === 1}>
        <text x={P.x0 + T / 2} y="22" class="titre" class:r={e >= 4 && k === 0}>{P.titre}</text>
        <!-- Les axes : scolarité en x, intérêt en y, de 0 à 1. -->
        <line x1={P.x0 - 22} y1={HAUT + T + 14} x2={P.x0 + T + 14} y2={HAUT + T + 14} class="axe" />
        <line x1={P.x0 - 22} y1={HAUT + T + 14} x2={P.x0 - 22} y2={HAUT - 4} class="axe" />
        <text x={P.x0 + T / 2} y={HAUT + T + 40} class="nom-axe">scolarité</text>
        <text x={P.x0 - 32} y={HAUT + T / 2} class="nom-axe" transform="rotate(-90 {P.x0 - 32} {HAUT + T / 2})">intérêt</text>

        <g clip-path="url(#rc-cadre-{k})">
          <g class="carres" class:vu={e >= 2}>
            {#each P.pts as p}
              <rect x={p.x <= 0.5 ? p.px : p.px - p.cote} y={Math.min(sy(p.y), sy(p.sur))} width={p.cote} height={p.cote} class="carre" />
            {/each}
          </g>
          <g class="ecarts" class:vu={e >= 1}>
            {#each P.pts as p}
              <line x1={p.px} y1={sy(p.y)} x2={p.px} y2={sy(p.sur)} class="ecart" class:dessous={!p.dessus && e < 2} />
            {/each}
          </g>
          <line x1={P.x0 - 0.1 * T} y1={sy(P.b0 - 0.1 * P.b1)} x2={P.x0 + 1.1 * T} y2={sy(P.b0 + 1.1 * P.b1)} class="droite" class:r={e >= 4 && k === 0} />
        </g>
        {#each P.pts as p, i}
          <circle cx={p.px} cy={sy(p.y)} r="5.5" class="pt" style="--k: {i}" />
        {/each}

        <!-- Sous chaque repère, ce qu'on additionne. -->
        <g class="lecture" class:vu={e === 1}>
          <text x={P.x0 + T / 2} y="388" class="somme"><tspan class="plus">+{virgule(P.dessus)}</tspan> <tspan class="moins">{virgule(P.dessous)}</tspan> <tspan class="egal">= {virgule(P.somme, 0)}</tspan></text>
          <text x={P.x0 + T / 2} y="416" class="et">au-dessus · au-dessous</text>
        </g>
        <g class="lecture" class:vu={e >= 2}>
          <text x={P.x0 + T / 2} y="392" class="aire" class:r={e >= 4 && k === 0}>{virgule(P.carres)}</text>
          <text x={P.x0 + T / 2} y="418" class="et">aire totale des carrés</text>
        </g>
      </g>
    {/each}

    <!-- L'encart : un écart de 2 contre deux écarts de 1. Sans données. -->
    <g class="encart" class:vu={e >= 3}>
      <line x1="692" y1="10" x2="692" y2="420" class="filet" />
      <text x="776" y="40" class="col">distance</text>
      <text x="920" y="40" class="col">aire</text>

      <text x="712" y="78" class="rang">un écart de {G.un}</text>
      <line x1="756" y1="96" x2="756" y2={96 + G.un * U} class="ecart" />
      <text x="786" y={96 + U + 8} class="n">{G.un}</text>
      <rect x="874" y="96" width={G.un * U} height={G.un * U} class="carre fort" />
      <line x1={874 + U} y1="96" x2={874 + U} y2={96 + 2 * U} class="grille" />
      <line x1="874" y1={96 + U} x2={874 + 2 * U} y2={96 + U} class="grille" />
      <text x={874 + 2 * U + 18} y={96 + U + 8} class="n r">{G.aire_un}</text>

      <text x="712" y="232" class="rang">deux écarts de 1</text>
      <line x1="744" y1="250" x2="744" y2={250 + U} class="ecart" />
      <line x1="760" y1="250" x2="760" y2={250 + U} class="ecart" />
      <text x="776" y={250 + U / 2 + 8} class="n">{G.deux[0]} + {G.deux[1]}</text>
      <rect x="874" y="250" width={U} height={U} class="carre fort" />
      <rect x={874 + U + 8} y="250" width={U} height={U} class="carre fort" />
      <text x={874 + 2 * U + 18} y={250 + U / 2 + 8} class="n r">{G.aire_deux}</text>

      <line x1="712" y1="322" x2="990" y2="322" class="filet" />
      <text x="776" y="366" class="verdict">{G.un} = {G.deux[0] + G.deux[1]}</text>
      <text x="920" y="366" class="verdict r">{G.aire_un} &gt; {G.aire_deux}</text>
    </g>
  </svg>

  <p class="phrase" class:r={e >= 4}>
    {#each PHRASE as t, k}
      <span class:vu={e === k}>{t}</span>
    {/each}
  </p>
  <p class="source">15 répondant.e.s de notre sondage, CES 2025<span class="note" class:vu={e >= 3}>{' · l’encart : un exemple, pas des données'}</span></p>
</div>

<style>
  .rc { display: flex; flex-direction: column; align-items: center; gap: 0.4em; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .titre { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .titre.r { fill: var(--dk-accent); }
  .nom-axe { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }

  .panneau { transition: opacity 0.5s; }
  .panneau.pale { opacity: 0.3; }
  .pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2; animation: rc-pose 0.4s cubic-bezier(0.34, 1.6, 0.64, 1) both; animation-delay: calc(var(--k) * 40ms + 100ms); transform-box: fill-box; transform-origin: center; }
  .droite { stroke: var(--dk-gris); stroke-width: 4; transition: stroke 0.4s, stroke-width 0.4s; }
  .droite.r { stroke: var(--dk-accent); stroke-width: 5; }

  .ecarts, .carres, .lecture, .encart { opacity: 0; transition: opacity 0.5s; }
  .ecarts.vu, .carres.vu, .lecture.vu, .encart.vu { opacity: 1; }
  .ecart { stroke: var(--dk-accent); stroke-width: 3; transition: stroke 0.5s; }
  .ecart.dessous { stroke: var(--dk-encre); }
  .carre { fill: var(--dk-accent); fill-opacity: 0.07; stroke: var(--dk-accent); stroke-opacity: 0.35; stroke-width: 1; }
  .carre.fort { fill-opacity: 0.12; stroke-opacity: 1; stroke-width: 2; }
  .grille { stroke: var(--dk-accent); stroke-width: 1; stroke-dasharray: 3 3; }

  .somme { font-size: 26px; font-weight: 600; text-anchor: middle; font-variant-numeric: tabular-nums; }
  .plus { fill: var(--dk-accent); }
  .moins { fill: var(--dk-encre); }
  .egal { fill: var(--dk-encre); font-size: 30px; }
  .aire { font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); font-variant-numeric: tabular-nums; transition: fill 0.4s; }
  .aire.r { fill: var(--dk-accent); }
  .et { font-size: 14px; letter-spacing: 0.08em; text-anchor: middle; fill: var(--dk-gris); }

  .filet { stroke: var(--dk-filet); stroke-width: 2; }
  .col { font-size: 14px; letter-spacing: 0.12em; text-transform: uppercase; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .rang { font-size: 16px; font-weight: 600; fill: var(--dk-encre); }
  .n { font-size: 24px; font-weight: 600; fill: var(--dk-encre); font-variant-numeric: tabular-nums; }
  .n.r { fill: var(--dk-accent); }
  .verdict { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .verdict.r { fill: var(--dk-accent); }

  .phrase { display: grid; margin: 0; font-size: 1.05em; font-weight: 600; text-align: center; min-height: 1.4em; }
  .phrase span { grid-area: 1 / 1; opacity: 0; transition: opacity 0.4s; }
  .phrase span.vu { opacity: 1; }
  .phrase.r { color: var(--dk-accent); }
  .source { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  .note { display: none; }
  .note.vu { display: inline; }

  @keyframes rc-pose { from { opacity: 0; transform: scale(0.2); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .pt { animation: none; }
    .ecarts, .carres, .lecture, .encart, .panneau, .phrase span, .ecart { transition: none; }
  }
</style>
