<script>
  /**
   * La pondération, puis le ratissage (raking). Suite de « La CES
   * ressemble-t-elle au Canada ? ». Cinq temps.
   *
   *   0  La règle : un poids = % dans la population ÷ % dans l'échantillon.
   *   1  Les 18 à 22 ans : 7,4 % du Canada, 5,2 % de la CES. Chaque jeune
   *      compte pour environ 1,4 personne : son carré grossit.
   *   2  Les 58 à 62 ans : 7,7 % contre 9,4 %. Chacun compte pour environ
   *      0,8 personne : son carré rapetisse.
   *   3  Mais on corrige plusieurs choses à la fois : l'âge, le genre, la
   *      région. Trois jauges, l'échantillon (point) et la population
   *      (trait). On ajuste l'âge, ce qui dérange un peu le genre et la
   *      région; on ajuste le genre, puis la région; on recommence. Les
   *      écarts fondent (environ cinq secondes).
   *   4  Tout colle : c'est le ratissage (raking). La CES fournit ces poids.
   *
   * Les pourcentages des temps 1 et 2 viennent de RECENSEMENT
   * (src/lib/data/seance5_normale.js : Statistique Canada, tableau
   * 17-10-0005-01, et la CES 2025 brute); les poids sont leur rapport,
   * calculé ici. Les jauges du ratissage sont un schéma : leurs écarts sont
   * inventés pour montrer la méthode, pas mesurés (dit à l'écran).
   * La règle est celle du cours FAS1001 de l'enseignant (« poids = % dans
   * la population / % dans l'échantillon »).
   */
  import { brancherTemps } from '../temps.js';
  import { RECENSEMENT as R } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const ex = (i) => ({ groupe: R.groupes[i], pop: R.statcan[i], ech: R.eecBrut[i], poids: R.statcan[i] / R.eecBrut[i] });
  const JEUNES = ex(0);
  const AINES = ex(R.groupes.findIndex((g) => g.startsWith('58')));

  // Le ratissage : une suite d'états [âge, genre, région] (écarts au
  // recensement, en unités de schéma) et la jauge qu'on vient d'ajuster.
  const ETATS = [
    { d: [0.8, -0.55, 0.6], ajuste: -1 },
    { d: [0, -0.4, 0.45], ajuste: 0 },
    { d: [0.22, 0, 0.3], ajuste: 1 },
    { d: [0.12, 0.14, 0], ajuste: 2 },
    { d: [0, 0.08, 0.06], ajuste: 0 },
    { d: [0.04, 0, 0.04], ajuste: 1 },
    { d: [0.02, 0.02, 0], ajuste: 2 },
    { d: [0, 0, 0], ajuste: -1 }
  ];
  const PAS = 650;
  let t = $state(0);
  $effect(() => {
    if (e !== 3) return;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < ETATS.length * PAS) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const k = $derived(e >= 4 ? ETATS.length - 1 : e === 3 ? Math.min(ETATS.length - 1, Math.floor(t / PAS)) : 0);
  const ETAT = $derived(ETATS[k]);
  const JAUGES = ['l’âge', 'le genre', 'la région'];
  const GX0 = 620, GX1 = 950, GC = (GX0 + GX1) / 2;
  const gx = (d) => GC + d * 150;
</script>

<div class="visuel ponderation" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Un poids = % dans la population ÷ % dans l’échantillon. Les 18 à 22 ans : {f(JEUNES.pop)} % du Canada, {f(JEUNES.ech)} % de la CES, chacun compte pour {f(JEUNES.poids)} personne. Les 58 à 62 ans : {f(AINES.pop)} % contre {f(AINES.ech)} %, chacun compte pour {f(AINES.poids)} personne. On corrige l’âge, le genre et la région à la fois, en recommençant jusqu’à ce que tout colle : c’est le ratissage.">
    <!-- 0 : la règle. -->
    <text x="40" y="44" class="po-titre">Un poids&#8239;=</text>
    <text x="236" y="30" class="po-frac">% dans la population</text>
    <line x1="230" y1="42" x2="556" y2="42" class="po-barre" />
    <text x="236" y="68" class="po-frac">% dans l’échantillon</text>

    <!-- 1 : les jeunes. -->
    <g class="po-etape" class:po-vu={e >= 1}>
      <text x="40" y="130" class="po-groupe">les {JEUNES.groupe} ans</text>
      <text x="40" y="160" class="po-calc">{f(JEUNES.pop)} ÷ {f(JEUNES.ech)} = <tspan class="po-rouge">{f(JEUNES.poids)}</tspan></text>
      <rect x={500 - 26 * JEUNES.poids} y={138 - 26 * JEUNES.poids} width={52 * JEUNES.poids} height={52 * JEUNES.poids} class="po-carre po-grand" />
      <text x="40" y="190" class="po-sens">trop peu nombreux&#8239;: chacun compte pour {f(JEUNES.poids)}</text>
    </g>
    <!-- 2 : les aînés. -->
    <g class="po-etape" class:po-vu={e >= 2}>
      <text x="40" y="250" class="po-groupe">les {AINES.groupe} ans</text>
      <text x="40" y="280" class="po-calc">{f(AINES.pop)} ÷ {f(AINES.ech)} = <tspan class="po-rouge">{f(AINES.poids)}</tspan></text>
      <rect x={500 - 26 * AINES.poids} y={262 - 26 * AINES.poids} width={52 * AINES.poids} height={52 * AINES.poids} class="po-carre" />
      <text x="40" y="310" class="po-sens">trop nombreux&#8239;: chacun compte pour {f(AINES.poids)}</text>
    </g>

    <!-- 3 : le ratissage. -->
    <g class="po-etape" class:po-vu={e >= 3}>
      <text x={GX0} y="120" class="po-groupe">à corriger en même temps</text>
      <text x={GX1} y="144" class="po-note">schéma · trait&#8239;: le Canada · point&#8239;: la CES</text>
      {#each JAUGES as j, i}
        {@const y = 190 + i * 62}
        <text x={GX0} y={y - 12} class="po-jauge" class:po-actif={ETAT.ajuste === i}>{j}</text>
        <line x1={GX0} y1={y + 8} x2={GX1} y2={y + 8} class="po-rail" />
        <line x1={GC} y1={y - 4} x2={GC} y2={y + 20} class="po-cible" />
        <circle cx={gx(ETAT.d[i])} cy={y + 8} r="9" class="po-point" class:po-ok={Math.abs(ETAT.d[i]) < 1e-9} />
      {/each}
      <text x={GX0} y="378" class="po-sens">on ajuste l’âge, ça dérange le genre.</text>
      <text x={GX0} y="400" class="po-sens">on ajuste le genre, puis la région.</text>
      <text x={GX0} y="422" class="po-sens">on recommence.</text>
    </g>

    <!-- 4 : tout colle. -->
    <g class="po-etape" class:po-vu={e >= 4}>
      <text x="500" y="462" class="po-phrase">Jusqu’à ce que tout colle&#8239;: c’est le <tspan class="po-rouge">ratissage</tspan> (raking).</text>
      <text x="500" y="486" class="po-note-c">La CES fournit ces poids, prêts à utiliser dans R.</text>
    </g>
  </svg>
</div>

<style>
  .ponderation { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }
  .po-titre { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .po-frac { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .po-barre { stroke: var(--dk-encre); stroke-width: 3; }
  .po-groupe { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .po-calc { font-size: 22px; fill: var(--dk-encre); }
  .po-rouge { fill: var(--dk-accent); font-weight: 700; }
  .po-sens { font-size: 17px; fill: var(--dk-gris); }
  .po-carre { fill: var(--dk-encre); }
  .po-grand { fill: var(--dk-accent); }
  .po-note { font-size: 14px; text-anchor: end; fill: var(--dk-gris); }
  .po-jauge { font-size: 19px; font-weight: 600; fill: var(--dk-gris); transition: fill 0.2s; }
  .po-jauge.po-actif { fill: var(--dk-accent); }
  .po-rail { stroke: var(--dk-gris-2); stroke-width: 3; }
  .po-cible { stroke: var(--dk-encre); stroke-width: 4; }
  .po-point { fill: var(--dk-accent); transition: cx 0.45s ease-in-out, fill 0.3s; }
  .po-point.po-ok { fill: var(--dk-encre); }
  .po-phrase { font-size: 23px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .po-note-c { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .po-etape { opacity: 0; transition: opacity 0.3s; }
  .po-etape.po-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .po-etape, .po-etape.po-vu, .po-point, .po-jauge { transition: none; }
  }
</style>
