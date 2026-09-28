<script>
  /**
   * Significatif n'est pas important. Deux études, deux valeurs p sous
   * 0,001, deux effets de tailles très différentes (les deux telles que
   * rapportées par Arel-Bundock 2021, p. 76).
   *
   *   0  À gauche, Bertrand et Mullainathan (2004) : des CV identiques sauf
   *      le nom. Les noms perçus comme blancs reçoivent 50 % plus de rappels
   *      pour une entrevue que les noms perçus comme afro-américains. Deux
   *      barres dans le rapport 1 à 1,5. p < 0,001.
   *   1  À droite, Sevi, Arel-Bundock et Blais (2019), élections fédérales
   *      canadiennes : les candidates reçoivent 0,5 point de pourcentage de
   *      moins. Deux barres presque égales. p < 0,001 aussi. Sous chaque
   *      panneau, un mot : important, minuscule.
   *   2  Une bande plus petite, nos propres données : la satisfaction envers
   *      la démocratie (0 à 1), chez les personnes nées hors du Canada et au
   *      Canada. L'écart est significatif, et petit.
   *
   * Les deux études sont des exceptions documentées dans
   * outils/seance5_data.R : leurs nombres (50 %, 1 et 1,5, 0,5 point,
   * p < 0,001) sont écrits ici, faute de jeu de données. Les barres de
   * droite n'ont pas d'axe : leur longueur est schématique, seul l'écart est
   * à l'échelle (0,5 point sur une échelle de 100 points longue de 400).
   * Aucun niveau de vote n'est affiché, parce qu'il n'est pas rapporté.
   *
   * La bande du bas vient de TESTS.satisfaction (t.test(satisfaction ~
   * ne_canada), Étude électorale canadienne 2025, sans pondération) : le
   * groupe 0 est né hors du Canada, le groupe 1 au Canada. L'écart est
   * arrondi à l'unité : les moyennes exportées le sont à trois décimales,
   * ce qui fausserait la première décimale de l'écart.
   */
  import { brancherTemps } from '../temps.js';
  import { TESTS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });

  // Arel-Bundock (2021, p. 76) : les deux études citées.
  const BM = { rapport: [1.5, 1] };
  const SAB = { ecart: 0.5 };
  const P_CITE = 'p < 0,001';

  // Gauche : 1 unité de rapport = 180. Droite : 100 points = 400.
  const UR = 180;
  const LD = 236;
  const LF = LD - SAB.ecart * 4;

  // Nos données.
  const S = TESTS.satisfaction;
  const [HORS, AU] = S.estimes;
  const ECART = Math.round((HORS - AU) * 100);
  const pS = S.p < 0.001 ? 'p < 0,001' : `p = ${fr(S.p, 3)}`;
  const US = 300;
</script>

<div class="visuel importance" bind:this={hote}>
  <svg viewBox="0 0 1000 494" role="img" aria-label="Deux études, deux valeurs p sous 0,001. Bertrand et Mullainathan (2004)&#8239;: à CV identiques, les noms perçus comme blancs reçoivent 50&#8239;% plus de rappels pour une entrevue que les noms perçus comme afro-américains. C’est important. Sevi, Arel-Bundock et Blais (2019)&#8239;: aux élections fédérales canadiennes, les candidates reçoivent 0,5 point de pourcentage de moins. C’est minuscule. Dans l’Étude électorale canadienne 2025, la satisfaction envers la démocratie est de {fr(HORS, 2)} chez les personnes nées hors du Canada et de {fr(AU, 2)} chez celles nées au Canada, un écart de {ECART} points sur 100, {pS}.">
    <!-- Gauche : Bertrand et Mullainathan (2004). -->
    <g class="im-pan">
      <text x="30" y="28" class="im-etude">Bertrand et Mullainathan (2004)</text>
      <text x="30" y="62" class="im-titre">50&#8239;% plus de rappels</text>
      <text x="30" y="90" class="im-titre">pour une entrevue</text>
      <text x="30" y="118" class="im-ctx">CV identiques, sauf le nom</text>
      <text x="30" y="150" class="im-lab">noms perçus comme blancs</text>
      <rect x="30" y="158" width={BM.rapport[0] * UR} height="24" class="im-barre" />
      <text x={30 + BM.rapport[0] * UR + 10} y="178" class="im-val">{fr(BM.rapport[0], 1)}</text>
      <text x="30" y="208" class="im-lab">noms perçus comme afro-américains</text>
      <rect x="30" y="216" width={BM.rapport[1] * UR} height="24" class="im-barre" />
      <text x={30 + BM.rapport[1] * UR + 10} y="236" class="im-val">{fr(BM.rapport[1], 0)}</text>
      <rect x="30" y="258" width="128" height="32" class="im-tag" />
      <text x="94" y="280" class="im-tag-t">{P_CITE}</text>
    </g>

    <line x1="500" y1="10" x2="500" y2="334" class="im-sep" class:im-vu={e >= 1} />

    <!-- Droite : Sevi, Arel-Bundock et Blais (2019). -->
    <g class="im-pan im-droite" class:im-vu={e >= 1}>
      <text x="530" y="28" class="im-etude">Sevi, Arel-Bundock et Blais (2019)</text>
      <text x="530" y="62" class="im-titre">les candidates reçoivent</text>
      <text x="530" y="90" class="im-titre">0,5 point de pourcentage de moins</text>
      <text x="530" y="118" class="im-ctx">élections fédérales canadiennes</text>
      <text x="530" y="150" class="im-lab">candidats (hommes)</text>
      <rect x="530" y="158" width={LD} height="24" class="im-barre" />
      <text x="530" y="208" class="im-lab">candidates (femmes)</text>
      <rect x="530" y="216" width={LF} height="24" class="im-barre" />
      <text x={530 + LD + 18} y="206" class="im-ecart">écart&#8239;: {fr(SAB.ecart, 1)} point</text>
      <rect x="530" y="258" width="128" height="32" class="im-tag" />
      <text x="594" y="280" class="im-tag-t">{P_CITE}</text>
    </g>

    <!-- Temps 1 : un mot sous chaque panneau. -->
    <g class="im-mots" class:im-vu={e >= 1}>
      <text x="30" y="330" class="im-mot">important</text>
      <text x="530" y="330" class="im-mot">minuscule</text>
    </g>

    <!-- Temps 2 : nos données. -->
    <g class="im-nous" class:im-vu={e >= 2}>
      <line x1="30" y1="354" x2="970" y2="354" class="im-sep-h" />
      <text x="30" y="382" class="im-etude">Étude électorale canadienne 2025, sans pondération</text>
      <text x="30" y="410" class="im-var">satisfaction envers la démocratie, de 0 à 1</text>
      <text x="272" y="442" class="im-lab im-fin">né.e.s hors du Canada</text>
      <rect x="284" y="428" width={HORS * US} height="18" class="im-barre" />
      <text x={284 + HORS * US + 10} y="443" class="im-val-p">{fr(HORS, 2)}</text>
      <text x="272" y="474" class="im-lab im-fin">né.e.s au Canada</text>
      <rect x="284" y="460" width={AU * US} height="18" class="im-barre" />
      <text x={284 + AU * US + 10} y="475" class="im-val-p">{fr(AU, 2)}</text>
      <text x="660" y="450" class="im-nous-ecart">{ECART} points sur 100</text>
      <rect x="660" y="458" width="128" height="30" class="im-tag" />
      <text x="724" y="479" class="im-tag-t">{pS}</text>
    </g>
  </svg>
  <p class="im-src">Les deux études, telles que rapportées par Arel-Bundock (2021, p.&#8239;76)</p>
</div>

<style>
  .importance { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .im-etude { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.02em; }
  .im-titre { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .im-ctx { font-size: 18px; fill: var(--dk-gris); }
  .im-lab { font-size: 18px; fill: var(--dk-encre); }
  .im-lab.im-fin { text-anchor: end; }
  .im-barre { fill: var(--dk-encre); }
  .im-val { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .im-val-p { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .im-ecart { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .im-tag { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .im-tag-t { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .im-mot { font-size: 32px; font-weight: 600; fill: var(--dk-accent); letter-spacing: -0.01em; }
  .im-mots { opacity: 0; transition: opacity 0.3s; }
  .im-mots.im-vu { opacity: 1; transition: opacity 0.5s 0.7s; }

  .im-sep { stroke: var(--dk-filet); stroke-width: 2; opacity: 0; transition: opacity 0.3s; }
  .im-sep.im-vu { opacity: 1; }
  .im-droite { opacity: 0; transition: opacity 0.3s; }
  .im-droite.im-vu { opacity: 1; transition: opacity 0.5s; }

  .im-nous { opacity: 0; transition: opacity 0.3s; }
  .im-nous.im-vu { opacity: 1; transition: opacity 0.5s; }
  .im-sep-h { stroke: var(--dk-encre); stroke-width: 2; }
  .im-var { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .im-nous-ecart { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }

  .im-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .im-mots, .im-mots.im-vu, .im-sep, .im-droite, .im-droite.im-vu, .im-nous, .im-nous.im-vu { transition: none; }
  }
</style>
