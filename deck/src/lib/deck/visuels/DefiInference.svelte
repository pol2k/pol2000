<script>
  /**
   * Le défi de l'inférence : la diapositive d'accueil de la section.
   * Dans mon échantillon, je trouve une relation. Est-elle vraie pour tout
   * le monde ? Deux vérifications, puis la promesse de la séance.
   *
   *   0  À gauche, mon échantillon : les répondant.e.s de l'Étude électorale
   *      canadienne 2025, et une relation qu'on y trouve. Sur l'échelle
   *      gauche-droite (0 à 10), les personnes nées ailleurs qu'au Canada se
   *      placent un peu plus à droite que celles nées au Canada. Deux pistes,
   *      deux carrés qui glissent jusqu'à leur moyenne.
   *   1  Le saut : une flèche rouge vers « tous les adultes canadiens », un
   *      brouillard avec un grand « ? », et la question.
   *   2  Vérification 1, un carré numéroté posé sur la flèche : l'échantillon
   *      ressemble-t-il à la population ? Renvoi : 1936, la CES, les poids.
   *   3  Vérification 2 : la relation pourrait-elle venir du hasard ?
   *      Renvoi : la marge d'erreur, les pommes.
   *   4  La promesse : comment répondre, le plus simplement possible. Une
   *      note grise : une relation n'est pas encore une cause (troisième partie).
   *
   * Données (src/lib/data/seance5.js, généré par outils/seance5_data.R) :
   *   - TESTS.nGaucheDroite : les 16 996 répondant.e.s qui ont répondu à
   *     la question gauche-droite, affichés dans la boîte.
   *   - TESTS.naissance.estimes : les moyennes de gauche_droite selon
   *     ne_canada, dans l'ordre du t.test de R (ne_canada = 0, puis 1),
   *     donc [nées ailleurs, nées au Canada]. Les carrés sont placés à la
   *     valeur brute, les étiquettes arrondies à une décimale.
   *   - Attention : la relation ne porte que sur les répondant.e.s qui ont
   *     répondu à l'échelle (TESTS.nGaucheDroite, 16 996), et les moyennes
   *     sont sans pondération.
   * Rien n'est tapé à la main. Pas de Math.random.
   */
  import { brancherTemps } from '../temps.js';
  import { TESTS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const n = f(TESTS.nGaucheDroite);
  const [AILLEURS, CANADA] = TESTS.naissance.estimes;

  // La règle de 0 à 10, dans la boîte de l'échantillon.
  const RX0 = 50, RX1 = 370;
  const px = (v) => RX0 + (v / 10) * (RX1 - RX0);
  const PISTES = [
    { nom: 'né.e.s au Canada', v: CANADA, y: 124, ty: 104, rouge: false },
    { nom: 'né.e.s ailleurs', v: AILLEURS, y: 170, ty: 150, rouge: true }
  ].map((p) => ({ ...p, x: px(p.v), etiq: f(p.v, 1) }));

  // Le brouillard : des traits qui dérivent, à positions fixes.
  const BRUME = [104, 132, 160, 188].map((y, k) => ({ y, x0: 620 + (k % 3) * 18, x1: 960 - (k % 2) * 26, v: 9 + (k % 4) * 3 }));

  // La flèche et ses deux postes de contrôle.
  const FY = 120, FX0 = 412, FX1 = 590;
  const POSTES = [470, 532];

  const aria = `À gauche, mon échantillon : ${n} répondant.e.s de l’Étude électorale canadienne 2025. Sur une échelle gauche-droite de 0 à 10, les personnes nées au Canada se placent à ${PISTES[0].etiq} en moyenne, celles nées ailleurs à ${PISTES[1].etiq}. Une flèche vers tous les adultes canadiens, dans le brouillard : est-ce vrai pour tout le monde ? Deux vérifications. Un, mon échantillon ressemble-t-il à la population ? Deux, la relation pourrait-elle venir du hasard ?`;
</script>

<div class="visuel defi-inference" bind:this={hote}>
  <svg viewBox="0 0 1000 512" role="img" aria-label={aria}>
    <!-- Mon échantillon et la relation qu'on y trouve. -->
    <rect x="20" y="16" width="380" height="206" class="di-boite" />
    <text x="40" y="48" class="di-titre">mon échantillon</text>
    <text x="40" y="74" class="di-sous">{n} répondant.e.s · CES 2025</text>
    {#each PISTES as p, k}
      <text x={RX0} y={p.ty} class="di-sous">{p.nom}</text>
      <line x1={RX0} y1={p.y} x2={RX1} y2={p.y} class="di-piste" />
      <g class="di-point" style="--dx: {p.x - RX0}px; animation-delay: {200 + k * 250}ms">
        <rect x={p.x - 9} y={p.y - 9} width="18" height="18" class:di-rouge={p.rouge} class="di-carre" />
        <text x={p.x + 16} y={p.y + 7} class="di-valeur" class:di-rouge-t={p.rouge}>{p.etiq}</text>
      </g>
    {/each}
    {#each [0, 5, 10] as t}
      <line x1={px(t)} y1="180" x2={px(t)} y2="188" class="di-tic" />
    {/each}
    <text x={px(0)} y="208" class="di-sous">0 gauche</text>
    <text x={px(5)} y="208" class="di-sous" text-anchor="middle">5</text>
    <text x={px(10)} y="208" class="di-sous" text-anchor="end">droite 10</text>

    <!-- Le saut vers la population, dans le brouillard. -->
    <g class="di-apparait" class:di-vu={e >= 1}>
      <rect x="600" y="16" width="380" height="206" class="di-brume-cadre" />
      {#each BRUME as b}
        <line x1={b.x0} y1={b.y} x2={b.x1} y2={b.y} class="di-brume" style="animation-duration: {b.v}s" />
      {/each}
      <text x="620" y="50" class="di-titre">tous les adultes</text>
      <text x="620" y="78" class="di-titre">canadiens</text>
      <text x="790" y="206" class="di-inconnu" text-anchor="middle">?</text>
      <text x="980" y="262" class="di-titre" text-anchor="end">Est-ce vrai pour tout le monde&#8239;?</text>
    </g>
    {#if e >= 1}
      <path d="M {FX0} {FY} H {FX1 - 4}" pathLength="1" class="di-saut" />
      <path d="M {FX1 - 18} {FY - 13} L {FX1 - 2} {FY} L {FX1 - 18} {FY + 13}" pathLength="1" class="di-saut di-pointe" />
    {/if}

    <!-- Les deux vérifications : un poste sur la flèche, une ligne en bas. -->
    {#each POSTES as x, k}
      {#if e >= k + 2}
        <g class="di-poste">
          <rect x={x - 18} y={FY - 18} width="36" height="36" class="di-num" />
          <text {x} y={FY + 8} class="di-num-t" text-anchor="middle">{k + 1}</text>
        </g>
      {/if}
    {/each}

    <g class="di-ligne" class:di-vu={e >= 2}>
      <rect x="20" y="292" width="36" height="36" class="di-num" />
      <text x="38" y="318" class="di-num-t" text-anchor="middle">1</text>
      <text x="74" y="316" class="di-titre">Mon échantillon ressemble-t-il à la population&#8239;?</text>
      <text x="74" y="344" class="di-renvoi">pas biaisé · 1936, la CES, les poids</text>
    </g>
    <g class="di-ligne" class:di-vu={e >= 3}>
      <rect x="20" y="364" width="36" height="36" class="di-num" />
      <text x="38" y="390" class="di-num-t" text-anchor="middle">2</text>
      <text x="74" y="388" class="di-titre">La relation pourrait-elle venir du hasard&#8239;?</text>
      <text x="74" y="416" class="di-renvoi">un autre échantillon donnerait autre chose · la marge d’erreur, les pommes</text>
    </g>

    <!-- La promesse. -->
    <g class="di-ligne" class:di-vu={e >= 4}>
      <line x1="20" y1="440" x2="980" y2="440" class="di-filet" />
      <text x="20" y="474" class="di-titre">Aujourd’hui&#8239;: comment répondre, le plus simplement possible.</text>
      <text x="20" y="502" class="di-renvoi">(et une relation n’est pas encore une cause&#8239;: troisième partie du cours)</text>
    </g>
  </svg>
</div>

<style>
  .defi-inference { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .di-titre { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .di-sous { font-size: 18px; fill: var(--dk-gris); }
  .di-renvoi { font-size: 18px; fill: var(--dk-gris); }
  .di-valeur { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .di-rouge-t { fill: var(--dk-accent); }
  .di-inconnu { font-size: 110px; font-weight: 600; fill: var(--dk-accent); }

  .di-boite { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .di-piste { stroke: var(--dk-gris-2); stroke-width: 2; }
  .di-tic { stroke: var(--dk-gris-2); stroke-width: 2; }
  .di-carre { fill: var(--dk-encre); }
  .di-carre.di-rouge { fill: var(--dk-accent); }
  .di-point { animation: di-glisse 0.9s cubic-bezier(0.34, 1.3, 0.64, 1) both; }

  .di-brume-cadre { fill: none; stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 12 9; }
  .di-brume { stroke: var(--dk-filet); stroke-width: 7; stroke-dasharray: 70 40 20 55; animation: di-deriver linear infinite; }
  .di-saut { fill: none; stroke: var(--dk-accent); stroke-width: 8; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; animation: di-trace 0.6s ease-out forwards; }
  .di-saut.di-pointe { stroke-width: 6; animation-delay: 0.5s; }

  .di-num { fill: var(--dk-encre); }
  .di-num-t { font-size: 24px; font-weight: 600; fill: var(--dk-fond); }
  .di-poste { transform-box: fill-box; transform-origin: center; animation: di-pop 0.4s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  .di-filet { stroke: var(--dk-encre); stroke-width: 2; }

  .di-apparait { opacity: 0; transition: opacity 0.2s; }
  .di-apparait.di-vu { opacity: 1; transition: opacity 0.5s 0.3s; }
  .di-ligne { opacity: 0; transform: translateY(10px); transition: opacity 0.2s, transform 0.2s; }
  .di-ligne.di-vu { opacity: 1; transform: none; transition: opacity 0.4s 0.2s, transform 0.5s 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }

  @keyframes di-glisse { from { transform: translateX(calc(-1 * var(--dx))); } to { transform: none; } }
  @keyframes di-deriver { to { stroke-dashoffset: -185; } }
  @keyframes di-trace { to { stroke-dashoffset: 0; } }
  @keyframes di-pop { from { transform: scale(0); } to { transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .di-point, .di-brume, .di-poste { animation: none; }
    .di-saut { animation: none; stroke-dashoffset: 0; }
    .di-apparait, .di-apparait.di-vu, .di-ligne, .di-ligne.di-vu { transition: none; }
  }
</style>
