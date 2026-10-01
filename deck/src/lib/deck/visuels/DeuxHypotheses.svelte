<script>
  /**
   * La conversation : la pomicultrice et l'acheteur (exemple fictif
   * d'Arel-Bundock 2021, p. 62-63). Deux personnages en schéma, à gauche la
   * pomicultrice (son panier de pommes rouges), à droite l'acheteur (bras
   * croisés). Les bulles arrivent une à une. Quatre temps.
   *
   *   0  Le cadre : l'acheteur n'accepte que les lots de plus de POMMES.h0
   *      grammes en moyenne. C'est une exigence, un seuil, pas la moyenne
   *      connue de pommes « dans la limite ».
   *   1  Elle : son panier de POMMES.n pommes pèse POMMES.moyenne g en
   *      moyenne, son lot dépasse POMMES.h0 g. C'est H1, ce qu'elle
   *      affirme (pas « ce qu'elle veut prouver » : PourquoiH0 dit qu'on ne
   *      peut pas prouver H1 directement).
   *   2  Lui : peut-être que le lot est juste à POMMES.h0 g, ou moins, et
   *      qu'elle est tombée sur un bon panier, par chance. C'est H0.
   *   3  Les étiquettes : « H1 · ce qu'elle affirme » sur sa bulle,
   *      « H0 · l'hypothèse nulle » sur celle de l'acheteur, dont le filet
   *      passe au rouge (H0 porte le rouge partout dans le deck).
   *   4  Elle : d'accord, supposons que tu as raison. À quel point mon
   *      panier serait-il chanceux ? (Les diapos suivantes construisent le
   *      monde à POMMES.h0 g et comptent les paniers : PaniersH0.svelte.)
   *
   * H0 est unilatérale, « POMMES.h0 g ou moins », le complément de H1. Le
   * livre écrit H0 comme un point (p. 67) et teste des deux côtés (p. 71),
   * d'où le « d'après » de la source.
   *
   * Remanié le 1er octobre 2026 à la demande du professeur : la diapo
   * raconte la conversation du livre au lieu de poser deux cartes H1 et H0.
   * L'exemple politique (l'âge et l'intérêt pour la politique) est retiré.
   *
   * La largeur de chaque bulle est calculée à partir de ses lignes (IBM Plex
   * Mono : une chasse de 0,6 corps), donc aucun texte ne déborde de sa
   * bulle. Les bulles cachées gardent leur place (opacité) : rien ne saute.
   * Tous les nombres viennent de POMMES (src/lib/data/seance5.js).
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

  // Typographie : corps des bulles, interligne, marges intérieures.
  const F = 24, CH = F * 0.6, LH = 32, PAD = 22;
  const HAUT_BULLE = (n) => 36 + (n - 1) * LH + 19;
  // Étiquettes H1 et H0.
  const TF = 20, TCH = TF * 0.6, TH = 30, TPAD = 12;

  // Chaque ligne est une suite de segments, { t, g } (g : gras).
  const ELLE_1 = [
    [{ t: `Mon panier de ${POMMES.n} pommes` }],
    [{ t: `pèse ${POMMES.moyenne} g en moyenne.` }],
    [{ t: `Mon lot dépasse ${POMMES.h0} g.`, g: true }]
  ];
  const LUI = [
    [{ t: `Peut-être que ton lot est juste à ${POMMES.h0} g,` }],
    [{ t: 'ou moins, et que tu es tombée' }],
    [{ t: 'sur un bon panier, ' }, { t: 'par chance.', g: true }]
  ];
  const ELLE_2 = [
    [{ t: 'D’accord, supposons que tu as raison.' }],
    [{ t: 'À quel point mon panier', g: true }],
    [{ t: 'serait-il chanceux ?', g: true }]
  ];
  const ETIQ_H1 = [{ t: 'H1', g: true }, { t: ' · ce qu’elle affirme' }];
  const ETIQ_H0 = [{ t: 'H0', g: true }, { t: ' · l’hypothèse nulle' }];

  const long = (segs) => segs.reduce((s, x) => s + x.t.length, 0);
  const largeur = (lignes) => Math.max(...lignes.map(long)) * CH + 2 * PAD;
  const largeurEtiq = (segs) => long(segs) * TCH + 2 * TPAD;

  // Les bulles : la sienne à gauche (x = 170), celle de l'acheteur à droite
  // (bord droit à 830). La bulle H1 reste plus large que son étiquette.
  const G = 170, D = 830;
  const wH1 = largeurEtiq(ETIQ_H1), wH0 = largeurEtiq(ETIQ_H0);
  const A = { x: G, y: 82, w: Math.max(largeur(ELLE_1), wH1 + 60), h: HAUT_BULLE(ELLE_1.length) };
  const B = { y: A.y + A.h + 18 + TH, w: largeur(LUI), h: HAUT_BULLE(LUI.length) };
  B.x = D - B.w;
  const C = { x: G, y: B.y + B.h + 20, w: largeur(ELLE_2), h: HAUT_BULLE(ELLE_2.length) };
  const H = C.y + C.h + 37;

  // Contour d'une bulle à coins carrés, queue comprise, en un seul tracé.
  // b1 < b2 : la base de la queue sur le côté; (qx, qy) : sa pointe.
  function bulleGauche(r, b1, b2, qx, qy) {
    return `M ${r.x} ${r.y} H ${r.x + r.w} V ${r.y + r.h} H ${r.x} V ${b2} L ${qx} ${qy} L ${r.x} ${b1} Z`;
  }
  function bulleDroite(r, b1, b2, qx, qy) {
    const x1 = r.x + r.w;
    return `M ${r.x} ${r.y} H ${x1} V ${b1} L ${qx} ${qy} L ${x1} ${b2} V ${r.y + r.h} H ${r.x} Z`;
  }
  // Les queues visent les personnages : vers le bas pour la première bulle,
  // vers le haut pour la dernière, à l'horizontale pour l'acheteur.
  const dA = bulleGauche(A, A.y + A.h - 36, A.y + A.h - 14, G - 24, A.y + A.h + 8);
  const dB = bulleDroite(B, B.y + 34, B.y + 56, D + 26, B.y + 41);
  const dC = bulleGauche(C, C.y + 16, C.y + 38, G - 24, C.y);

  const LIGNES = (r, lignes) => lignes.map((segs, i) => ({ segs, x: r.x + PAD, y: r.y + 36 + i * LH }));
  const TXT_A = LIGNES(A, ELLE_1), TXT_B = LIGNES(B, LUI), TXT_C = LIGNES(C, ELLE_2);

  // Les étiquettes, en onglet sur le bord haut : à gauche pour elle, à
  // droite pour lui (du côté de qui parle).
  const TAB_A = { x: A.x, y: A.y - TH, w: wH1 };
  const TAB_B = { x: D - wH0, y: B.y - TH, w: wH0 };
</script>

<div class="visuel conversation" bind:this={hote}>
  <svg viewBox="0 0 1000 {H}" role="img" aria-label="Exemple fictif. L’acheteur n’accepte que les lots de plus de {POMMES.h0}&#8239;g en moyenne. La pomicultrice&#8239;: mon panier de {POMMES.n} pommes pèse {POMMES.moyenne}&#8239;g en moyenne, mon lot dépasse {POMMES.h0}&#8239;g. C’est H1, ce qu’elle affirme. L’acheteur&#8239;: peut-être que ton lot est juste à {POMMES.h0}&#8239;g, ou moins, et que tu es tombée sur un bon panier, par chance. C’est H0, l’hypothèse nulle. La pomicultrice&#8239;: d’accord, supposons que tu as raison. À quel point mon panier serait-il chanceux&#8239;?">
    <!-- Temps 0 : le cadre. -->
    <text x="500" y="32" class="dh-cadre">L’acheteur n’accepte que les lots de <tspan class="dh-gras">plus de {POMMES.h0}&#8239;g</tspan> en moyenne.</text>

    <!-- Les personnages. Elle : son panier de pommes rouges. -->
    <g class="dh-perso">
      <circle cx="72" cy="268" r="22" />
      <path d="M 54 296 L 90 296 L 104 366 L 40 366 Z" />
      <circle cx="107" cy="322" r="6" class="dh-pomme" />
      <circle cx="119" cy="320" r="6" class="dh-pomme" />
      <circle cx="131" cy="322" r="6" class="dh-pomme" />
      <path d="M 94 328 L 140 328 L 133 350 L 101 350 Z" />
    </g>
    <text x="72" y="396" class="dh-nom">la</text>
    <text x="72" y="418" class="dh-nom">pomicultrice</text>

    <!-- Lui : bras croisés. -->
    <g class="dh-perso">
      <circle cx="926" cy="282" r="22" />
      <rect x="900" y="308" width="52" height="66" />
      <rect x="892" y="330" width="68" height="14" class="dh-bras" />
    </g>
    <text x="926" y="404" class="dh-nom">l’acheteur</text>

    <!-- Temps 3 : les étiquettes, sous les bulles dans l'ordre du dessin
         (le filet de la bulle passe par-dessus le bas de l'onglet). -->
    <g class="dh-etape" class:dh-vu={e >= 3}>
      <rect x={TAB_A.x} y={TAB_A.y} width={TAB_A.w} height={TH} class="dh-tab-h1" />
      <text x={TAB_A.x + TPAD} y={TAB_A.y + 22} class="dh-etiq dh-etiq-h1">{#each ETIQ_H1 as s}<tspan class:dh-gras={s.g}>{s.t}</tspan>{/each}</text>
      <rect x={TAB_B.x} y={TAB_B.y} width={TAB_B.w} height={TH} class="dh-tab-h0" />
      <text x={TAB_B.x + TPAD} y={TAB_B.y + 22} class="dh-etiq dh-etiq-h0">{#each ETIQ_H0 as s}<tspan class:dh-gras={s.g}>{s.t}</tspan>{/each}</text>
    </g>

    <!-- Temps 1 : elle, H1. -->
    <g class="dh-etape" class:dh-vu={e >= 1}>
      <path d={dA} class="dh-bulle" />
      {#each TXT_A as l}<text x={l.x} y={l.y} class="dh-txt">{#each l.segs as s}<tspan class:dh-gras={s.g}>{s.t}</tspan>{/each}</text>{/each}
    </g>

    <!-- Temps 2 : lui, H0. Son filet rougit au temps 3. -->
    <g class="dh-etape" class:dh-vu={e >= 2}>
      <path d={dB} class="dh-bulle" class:dh-nulle={e >= 3} />
      {#each TXT_B as l}<text x={l.x} y={l.y} class="dh-txt">{#each l.segs as s}<tspan class:dh-gras={s.g}>{s.t}</tspan>{/each}</text>{/each}
    </g>

    <!-- Temps 4 : elle accepte de supposer H0 vraie. -->
    <g class="dh-etape" class:dh-vu={e >= 4}>
      <path d={dC} class="dh-bulle" />
      {#each TXT_C as l}<text x={l.x} y={l.y} class="dh-txt">{#each l.segs as s}<tspan class:dh-gras={s.g}>{s.t}</tspan>{/each}</text>{/each}
    </g>

    <text x="996" y={H - 9} class="dh-src">Exemple fictif · d’après Arel-Bundock (2021, p. 62-63)</text>
  </svg>
</div>

<style>
  .conversation { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .dh-gras { font-weight: 600; }
  .dh-cadre { font-size: 22px; text-anchor: middle; }
  .dh-nom { font-size: 20px; text-anchor: middle; }
  .dh-perso circle, .dh-perso path, .dh-perso rect { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: miter; }
  .dh-perso .dh-pomme { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .dh-perso .dh-bras { fill: var(--dk-encre); }
  .dh-bulle { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: miter; transition: stroke 0.4s, stroke-width 0.4s; }
  .dh-bulle.dh-nulle { stroke: var(--dk-accent); stroke-width: 3; }
  .dh-txt { font-size: 24px; }
  .dh-tab-h1 { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-width: 2; }
  .dh-tab-h0 { fill: var(--dk-accent); stroke: var(--dk-accent); stroke-width: 3; }
  .dh-etiq { font-size: 20px; }
  .dh-etiq-h1 { fill: var(--dk-gris); }
  .dh-etiq-h0 { fill: var(--dk-fond); }
  .dh-src { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .dh-etape { opacity: 0; transform: translateY(10px); transition: opacity 0.3s, transform 0.3s; }
  .dh-etape.dh-vu { opacity: 1; transform: none; transition: opacity 0.45s, transform 0.45s; }

  @media (prefers-reduced-motion: reduce) {
    .dh-etape, .dh-etape.dh-vu, .dh-bulle { transition: none; }
    .dh-etape { transform: none; }
  }
</style>
