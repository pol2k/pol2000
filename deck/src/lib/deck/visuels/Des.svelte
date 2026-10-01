<script>
  /**
   * La moyenne de plusieurs dés. Trois panneaux côte à côte : 10 000 lancers
   * d'un dé, de deux dés, puis de dix dés. Chaque barre compte combien de
   * lancers donnent cette moyenne. Un dé seul : plat, chaque face a la même
   * chance. Deux dés : un triangle, parce que 3,5 s'obtient de six façons et
   * 1 ou 6 d'une seule. Dix dés : une cloche, parce qu'une moyenne de 1
   * demande que les dix dés montrent 1. Chaque panneau est mis à l'échelle de
   * sa plus haute barre : c'est la forme qu'on regarde.
   *
   * Au-dessus de chaque panneau, les faces du premier lancer de la série.
   *
   *   0  Un dé : plat.
   *   1  + deux dés : un triangle.
   *   2  + dix dés : une cloche, en rouge.
   *   3  + la phrase : les hauts et les bas s'annulent.
   *   4  + le lien : un échantillon de 50 personnes, c'est 50 dés.
   *
   * Tout vient de src/lib/data/seance5_des.js (outils/seance5_des.R).
   */
  import { brancherTemps } from '../temps.js';
  import { DES } from '$lib/data/seance5_des.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie : trois panneaux de 280 de large, axe de 0,5 à 6,5.
  const LARGEUR = 280, GAUCHES = [30, 360, 690];
  const BASE = 330, HAUT = 170;
  const Y_TITRE = 34, Y_DES = 52, H_DES = 74;

  // Les points d'une face : positions en tiers de la face (−1, 0, 1).
  const POINTS = {
    1: [[0, 0]],
    2: [[-1, -1], [1, 1]],
    3: [[-1, -1], [0, 0], [1, 1]],
    4: [[-1, -1], [1, -1], [-1, 1], [1, 1]],
    5: [[-1, -1], [1, -1], [0, 0], [-1, 1], [1, 1]],
    6: [[-1, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [1, 1]]
  };

  // Les dés du premier lancer : une rangée pour 1 ou 2 dés, deux rangées de 5 pour 10.
  const placerDes = (faces, cx) => {
    const parRangee = faces.length > 5 ? 5 : faces.length;
    const c = faces.length > 5 ? 32 : 56;
    const ecart = faces.length > 5 ? 10 : 16;
    const rangees = Math.ceil(faces.length / parRangee);
    const larg = parRangee * c + (parRangee - 1) * ecart;
    const haut = rangees * c + (rangees - 1) * ecart;
    const x0 = cx - larg / 2, y0 = Y_DES + (H_DES - haut) / 2;
    return faces.map((f, i) => {
      const x = x0 + (i % parRangee) * (c + ecart);
      const y = y0 + Math.floor(i / parRangee) * (c + ecart);
      return {
        x, y, c,
        points: POINTS[f].map(([dx, dy]) => ({ cx: x + c / 2 + dx * c * 0.27, cy: y + c / 2 + dy * c * 0.27 })),
        r: c * 0.09
      };
    });
  };

  const PANNEAUX = DES.map((d, i) => {
    const g = GAUCHES[i];
    const x = (v) => g + ((v - 0.5) / 6) * LARGEUR;
    const pas = d.valeurs.length > 1 ? d.valeurs[1] - d.valeurs[0] : 1;
    const w = pas * (LARGEUR / 6) * 0.8;
    const max = Math.max(...d.effectifs);
    return {
      titre: d.des === 1 ? '1 dé' : `${d.des} dés`,
      centre: g + LARGEUR / 2,
      gauche: g,
      batons: d.valeurs.map((v, j) => ({ x: x(v) - w / 2, w, h: (d.effectifs[j] / max) * HAUT })),
      graduations: [1, 2, 3, 4, 5, 6].map((v) => ({ v, x: x(v) })),
      des: placerDes(d.premier, g + LARGEUR / 2)
    };
  });
</script>

<div class="visuel des" bind:this={hote}>
  <svg viewBox="0 0 1000 516" role="img" aria-label="10 000 lancers d’un dé, de deux dés et de dix dés. Un dé seul donne un histogramme plat. La moyenne de deux dés fait un triangle, avec 3,5 au sommet. La moyenne de dix dés fait une cloche. Chaque dé est plat, leur moyenne fait une cloche, parce que les hauts et les bas s’annulent. Un échantillon de 50 personnes, c’est comme 50 dés.">
    {#each PANNEAUX as p, i}
      <g class="de-temps" class:de-vu={e >= i}>
        <text x={p.centre} y={Y_TITRE} class="de-titre" class:de-rouge={i === 2}>{p.titre}</text>
        {#each p.des as d}
          <rect x={d.x} y={d.y} width={d.c} height={d.c} class="de-face" />
          {#each d.points as pt}
            <circle cx={pt.cx} cy={pt.cy} r={d.r} class="de-point" />
          {/each}
        {/each}
        {#each p.batons as b}
          <rect x={b.x} y={BASE - b.h} width={b.w} height={b.h} class="de-baton" class:de-rouge={i === 2} />
        {/each}
        <line x1={p.gauche} y1={BASE} x2={p.gauche + LARGEUR} y2={BASE} class="de-sol" />
        {#each p.graduations as t}
          <line x1={t.x} y1={BASE} x2={t.x} y2={BASE + 7} class="de-sol" />
          <text x={t.x} y={BASE + 28} class="de-grad">{t.v}</text>
        {/each}
        <text x={p.centre} y={BASE + 56} class="de-axe">la moyenne des dés</text>
      </g>
    {/each}
    <g class="de-temps" class:de-vu={e >= 3}>
      <text x="500" y="430" class="de-phrase">Chaque dé est plat.</text>
      <text x="500" y="460" class="de-phrase">Leur moyenne fait une cloche&#8239;: les hauts et les bas s’annulent.</text>
    </g>
    <text x="500" y="502" class="de-lien de-temps" class:de-vu={e >= 4}>Un échantillon de 50 personnes, c’est comme 50 dés.</text>
  </svg>
</div>

<style>
  .des { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .de-titre { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-titre.de-rouge { fill: var(--dk-accent); }
  .de-face { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .de-point { fill: var(--dk-encre); }
  .de-baton { fill: var(--dk-encre); }
  .de-baton.de-rouge { fill: var(--dk-accent); }
  .de-sol { stroke: var(--dk-encre); stroke-width: 2; }
  .de-grad { font-size: 18px; text-anchor: middle; fill: var(--dk-encre); }
  .de-axe { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .de-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .de-lien { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .de-temps { opacity: 0; transition: opacity 0.3s; }
  .de-temps.de-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .de-temps, .de-temps.de-vu { transition: none; }
  }
</style>
