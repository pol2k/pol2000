<script>
  /**
   * L'écart type (standard deviation, sd() dans R) : à quelle distance de la
   * moyenne se trouve une personne typique. Un seul nombre, dans les unités de
   * la variable. Aucune formule, aucune recette : on montre des distances, on
   * les range, on en retient une longueur, puis on la lit sur de vraies
   * personnes.
   *
   * En haut, un schéma : dix valeurs fictives dont la moyenne vaut 50.
   *   0  Les dix points sur leur axe et la moyenne, en rouge.
   *   1  Une flèche va de la moyenne à chaque point : chaque valeur est à une
   *      certaine distance de la moyenne.
   *   2  Les flèches se rangent, de la plus courte à la plus longue ; un repère
   *      rouge se pose à leur longueur typique et le nombre s'affiche (calculé
   *      sur les dix valeurs comme le fait sd() de R).
   *   3  Les flèches s'effacent et le schéma pâlit ; en bas, la vraie variable :
   *      l'âge de l'Étude électorale canadienne 2025, une bande d'un écart type
   *      de chaque côté de la moyenne, la part des répondant.e.s qui s'y
   *      trouvent (src/lib/data/seance3_ecart.js), et ce que le nombre dit.
   */
  import { brancherTemps } from '../temps.js';
  import { ECART } from '$lib/data/seance3_ecart.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const VALEURS = [22, 34, 40, 45, 48, 52, 55, 60, 66, 78];
  const N = VALEURS.length;
  const MOY = VALEURS.reduce((s, v) => s + v, 0) / N;
  // Le même calcul que sd() de R, sur les dix valeurs du schéma.
  const ET = Math.sqrt(VALEURS.reduce((s, v) => s + (v - MOY) ** 2, 0) / (N - 1));

  // Le schéma : 0 à 100 sur la largeur.
  const K = 8.4;
  const x = (v) => 80 + v * K;
  const ORIGINE = 80;
  const rangee = (i) => 50 + i * 9;
  const PILE = 232;
  const PAS = 14;
  // Rang de chaque flèche dans la pile : de la plus courte à la plus longue.
  const ordre = VALEURS.map((v, i) => i).sort((a, b) => Math.abs(VALEURS[a] - MOY) - Math.abs(VALEURS[b] - MOY));
  const rang = VALEURS.map((_, i) => ordre.indexOf(i));
  const XMARQUE = ORIGINE + ET * K;
  const XTEXTE = 390;

  // La vraie variable : l'âge, de 15 à 100 ans.
  const X = (v) => 80 + ((v - 15) / 85) * 840;
  const f1 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
  const XM = X(ECART.moyenne);
  const DEMI = X(ECART.moyenne + ECART.et) - XM;
  const PCT = Math.round(ECART.partDansUnEt * 100);
  const SUR10 = Math.round(ECART.partDansUnEt * 10);
</script>

<div class="visuel ecart-type" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Dix valeurs fictives autour d’une moyenne de 50 : des flèches mesurent la distance de chacune à la moyenne, puis se rangent de la plus courte à la plus longue ; l’écart type, {Math.round(ET)}, est leur longueur typique. En bas, l’âge de l’Étude électorale canadienne 2025 : moyenne de {f1(ECART.moyenne)} ans, écart type de {f1(ECART.et)} ans ; {PCT}&#8239;% des répondant.e.s ont entre {ECART.ageMin} et {ECART.ageMax} ans.">
    <text x="920" y="26" class="et-note">schéma</text>
    <text x="80" y="26" class="et-angl">dans R&#8239;: <tspan class="et-angl-c">sd()</tspan></text>

    <!-- Le schéma : axe, moyenne, points. Il pâlit quand la vraie variable arrive. -->
    <g class="et-schema" class:et-pale={e >= 3}>
    <line x1={x(0)} y1="160" x2={x(100)} y2="160" class="et-axe" />
    {#each [0, 50, 100] as t}
      <line x1={x(t)} y1="160" x2={x(t)} y2="167" class="et-axe" />
      <text x={x(t)} y="187" class="et-tick">{t}</text>
    {/each}
    <line x1={x(MOY)} y1="36" x2={x(MOY)} y2="160" class="et-moy" />
    <text x={x(MOY)} y="26" class="et-moy-t">moyenne · {MOY}</text>

    {#each VALEURS as v, i}
      <line x1={x(v)} y1={rangee(i)} x2={x(v)} y2="160" class="et-chute" class:et-vu={e === 1} />
      <circle cx={x(v)} cy="160" r="9" class="et-pt" style="--d: {i * 50}ms" />
    {/each}

    <!-- Les flèches : de la moyenne vers chaque point ; rangées en pile au temps 2. -->
    {#each VALEURS as v, i}
      {@const L = Math.abs(v - MOY) * K}
      {@const sens = v < MOY ? -1 : 1}
      <g class="et-fleche" class:et-vu={e === 1 || e === 2}
         style="transform: {e === 2 ? `translate(${ORIGINE}px, ${PILE + rang[i] * PAS}px) scale(1, 1)` : `translate(${x(MOY)}px, ${rangee(i)}px) scale(${sens}, 1)`}; transition-delay: {e === 2 ? rang[i] * 60 : 0}ms">
        <path d="M 0 0 H {L}" pathLength="1" class="et-trait" style="transition-delay: {e === 1 ? i * 70 : 0}ms" />
        <path d="M {L - 7} -5 L {L} 0 L {L - 7} 5" class="et-pointe" style="transition-delay: {e === 1 ? i * 70 + 350 : 0}ms" />
      </g>
    {/each}
    </g>

    <!-- Temps 1 : une seule ligne. -->
    <text x="500" y="270" class="et-ligne" class:et-vu={e === 1}>chaque valeur est à une certaine distance de la moyenne</text>

    <!-- Temps 2 : la pile, le repère, le nombre. -->
    <g class="et-pile" class:et-vu={e === 2}>
      <line x1={ORIGINE} y1={PILE - 12} x2={ORIGINE} y2={PILE + (N - 1) * PAS + 12} class="et-zero" />
      <g class="et-marque" style="transform: translateX({e === 2 ? XMARQUE - ORIGINE : 0}px)">
        <line x1={ORIGINE} y1={PILE - 18} x2={ORIGINE} y2={PILE + (N - 1) * PAS + 18} />
      </g>
      <g class="et-typique">
        <line x1={XMARQUE + 6} y1={PILE + 28} x2={XTEXTE - 14} y2={PILE + 28} class="et-lien" />
        <text x={XTEXTE} y={PILE + 44} class="et-nombre">écart type&#8239;: {Math.round(ET)}</text>
        <text x={XTEXTE} y={PILE + 86} class="et-glose">la distance typique à la moyenne</text>
        <text x={ORIGINE} y="412" class="et-petit">une sorte de moyenne des distances, où les grands écarts comptent plus</text>
      </g>
    </g>

    <!-- Temps 3 : la vraie variable, l'âge. -->
    <g class="et-reel" class:et-vu={e >= 3}>
      <text x="80" y="224" class="et-source">Étude électorale canadienne 2025</text>
      <text x="80" y="254" class="et-titre">Âge&#8239;: moyenne {f1(ECART.moyenne)} ans, écart type {f1(ECART.et)} ans</text>
      <g style="transform: translateX({XM}px)">
        <rect x={-DEMI} y="274" width={DEMI * 2} height="42" class="et-bande" />
      </g>
      <line x1={XM} y1="266" x2={XM} y2="324" class="et-moy" />
      <text x={XM + DEMI / 2} y="304" class="et-part">{PCT}&#8239;%</text>
      <text x={XM + DEMI + 12} y="303" class="et-pm">± {f1(ECART.et)} ans</text>
      <line x1={X(15)} y1="324" x2={X(100)} y2="324" class="et-axe" />
      {#each [20, 30, 40, 50, 60, 70, 80, 90, 100] as t}
        <line x1={X(t)} y1="324" x2={X(t)} y2="331" class="et-axe" />
        <text x={X(t)} y="350" class="et-tick">{t}</text>
      {/each}
      <g class="et-lecture">
        <text x="80" y="396" class="et-phrase">{SUR10} personnes sur 10 ont entre {ECART.ageMin} et {ECART.ageMax} ans.</text>
      </g>
      <g class="et-morale">
        <text x="80" y="446" class="et-fin">Petit écart type&#8239;: tout le monde ressemble à la moyenne.</text>
        <text x="80" y="476" class="et-fin">Grand&#8239;: la moyenne ne ressemble à personne.</text>
      </g>
    </g>
  </svg>
</div>

<style>
  .ecart-type { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .et-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }
  .et-angl { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.02em; }
  .et-angl-c { font-weight: 600; fill: var(--dk-encre); }
  .et-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .et-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .et-moy { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .et-moy-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .et-schema { transition: opacity 0.4s; }
  .et-schema.et-pale { opacity: 0.3; }
  .et-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: et-pop 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  @keyframes et-pop { from { transform: scale(0); } to { transform: scale(1); } }
  .et-chute { stroke: var(--dk-gris-2); stroke-width: 1.5; stroke-dasharray: 3 4; opacity: 0; transition: opacity 0.3s; }
  .et-chute.et-vu { opacity: 1; transition-delay: 0.6s; }

  .et-fleche { opacity: 0; transition: transform 0.8s cubic-bezier(0.34, 1.4, 0.64, 1), opacity 0.2s; }
  .et-fleche.et-vu { opacity: 1; }
  .et-trait { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.45s ease-out; }
  .et-fleche.et-vu .et-trait { stroke-dashoffset: 0; }
  .et-pointe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; opacity: 0; transition: opacity 0.2s; }
  .et-fleche.et-vu .et-pointe { opacity: 1; }

  .et-ligne { font-size: 24px; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .et-ligne.et-vu { opacity: 1; transition: opacity 0.4s 0.9s; }

  .et-pile { opacity: 0; transition: opacity 0.2s; }
  .et-pile.et-vu { opacity: 1; transition: opacity 0.3s; }
  .et-zero { stroke: var(--dk-encre); stroke-width: 3; }
  .et-marque { transition: transform 0.9s cubic-bezier(0.34, 1.56, 0.64, 1) 0.8s; }
  .et-marque line { stroke: var(--dk-accent); stroke-width: 5; }
  .et-typique { opacity: 0; transition: opacity 0.2s; }
  .et-pile.et-vu .et-typique { opacity: 1; transition: opacity 0.4s 1.6s; }
  .et-lien { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 5 5; }
  .et-nombre { font-size: 44px; font-weight: 600; fill: var(--dk-accent); }
  .et-glose { font-size: 24px; fill: var(--dk-encre); }
  .et-petit { font-size: 18px; fill: var(--dk-gris); }

  .et-reel { opacity: 0; transition: opacity 0.2s; }
  .et-reel.et-vu { opacity: 1; transition: opacity 0.3s 0.3s; }
  .et-source { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .et-titre { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .et-bande { fill: var(--dk-accent); fill-opacity: 0.25; stroke: var(--dk-accent); stroke-width: 3; transform-box: fill-box; transform-origin: center; transform: scaleX(0); transition: transform 0.9s cubic-bezier(0.34, 1.4, 0.64, 1) 0.5s; }
  .et-reel.et-vu .et-bande { transform: scaleX(1); }
  .et-part { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .et-pm { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }
  .et-part, .et-pm, .et-lecture, .et-morale { opacity: 0; transition: opacity 0.2s; }
  .et-reel.et-vu .et-part, .et-reel.et-vu .et-pm { opacity: 1; transition: opacity 0.4s 1.2s; }
  .et-reel.et-vu .et-lecture { opacity: 1; transition: opacity 0.4s 1.5s; }
  .et-reel.et-vu .et-morale { opacity: 1; transition: opacity 0.4s 2.1s; }
  .et-phrase { font-size: 24px; fill: var(--dk-encre); }
  .et-fin { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .et-pt { animation: none; }
    .et-schema { transition: none; }
    .et-fleche, .et-trait, .et-pointe, .et-marque, .et-bande, .et-chute, .et-chute.et-vu, .et-ligne, .et-ligne.et-vu,
    .et-pile, .et-pile.et-vu, .et-typique, .et-pile.et-vu .et-typique, .et-reel, .et-reel.et-vu,
    .et-part, .et-pm, .et-lecture, .et-morale,
    .et-reel.et-vu .et-part, .et-reel.et-vu .et-pm, .et-reel.et-vu .et-lecture, .et-reel.et-vu .et-morale { transition: none; }
  }
</style>
