<script>
  /**
   * La pondération. Suite de « La CES ressemble-t-elle au Canada ? ». Trois
   * temps (deux clics). Le ratissage a été retiré le 1er octobre 2026, à la
   * demande de l'enseignant : on parle seulement de poids.
   *
   *   0  En haut, la règle en fraction : un poids = % dans la population ÷
   *      % dans l'échantillon. Le gris est le Canada, le rouge la CES : la
   *      fraction sert aussi de légende. Dessous, deux groupes côte à côte.
   *      Pour chacun, un « plancher » gris donne la place que le groupe
   *      occupe au Canada, et des personnages rouges (la CES) se tiennent
   *      dessus. Les 18 à 22 ans ne remplissent pas leur plancher, les 58 à
   *      62 ans débordent du leur.
   *   1  Les 18 à 22 ans : 7,4 ÷ 5,2 = 1,4. Chaque personnage grossit de
   *      1,4 fois et la rangée arrive pile au bout du plancher.
   *   2  Les 58 à 62 ans : 7,7 ÷ 9,4 = 0,8. Chaque personnage rapetisse et
   *      la rangée rentre dans son plancher.
   *   3  Une ligne : chaque répondant.e reçoit son poids.
   *
   * Les pourcentages et les rangées de personnages viennent de RECENSEMENT
   * (src/lib/data/seance5_normale.js : Statistique Canada, tableau
   * 17-10-0005-01, et la CES 2025 brute). Les poids sont leur rapport,
   * calculé ici. La longueur d'une rangée est proportionnelle au % de la CES,
   * celle d'un plancher au % du Canada : une rangée grossie du poids a donc
   * exactement la longueur du plancher. Le nombre de personnages est le %
   * arrondi (un personnage par point de %), c'est un dessin, pas un effectif.
   * La règle est celle du cours FAS1001 de l'enseignant (« poids = % dans
   * la population / % dans l'échantillon »).
   *
   * Toutes les animations passent par transform (CSS), jamais par x, width
   * ou cx. Au dernier clic, l'état est fixe : rangées à leur taille finale.
   */
  import { brancherTemps } from '../temps.js';
  import { RECENSEMENT as R } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const ex = (i) => ({ groupe: R.groupes[i], pop: R.statcan[i], ech: R.eecBrut[i], poids: R.statcan[i] / R.eecBrut[i] });
  const JEUNES = ex(0);
  const AINES = ex(R.groupes.findIndex((g) => g.startsWith('58')));

  // Les deux colonnes. K : pixels par point de %, pour que la plus longue
  // rangée (ou le plus long plancher) tienne dans LARGEUR.
  const LARGEUR = 430;
  const K = LARGEUR / Math.max(JEUNES.pop, JEUNES.ech, AINES.pop, AINES.ech);
  const SOL = 250; // les pieds des personnages
  const COLONNES = [
    { ...JEUNES, x0: 30, vu: 1 },
    { ...AINES, x0: 540, vu: 2 }
  ].map((c) => {
    const n = Math.max(1, Math.round(c.ech));
    return { ...c, n, u: (c.ech * K) / n, plancher: c.pop * K };
  });

</script>

<div class="visuel ponderation" bind:this={hote}>
  <svg viewBox="0 0 1000 440" role="img" aria-label="Un poids = % dans la population ÷ % dans l’échantillon. Les {JEUNES.groupe} ans : {f(JEUNES.pop)} % du Canada, {f(JEUNES.ech)} % de la CES. Les personnages de la CES grossissent : chacun compte pour {f(JEUNES.poids)} personne. Les {AINES.groupe} ans : {f(AINES.pop)} % contre {f(AINES.ech)} %. Ils rapetissent : chacun compte pour {f(AINES.poids)} personne. Chaque répondant.e reçoit son poids.">
    <!-- 0 : la règle, qui sert aussi de légende (gris = Canada, rouge = CES). -->
    <text x="290" y="54" class="po-titre">Un poids&#8239;=</text>
    <text x="570" y="38" class="po-frac po-gris">% dans la population</text>
    <line x1="444" y1="48" x2="696" y2="48" class="po-barre" />
    <text x="570" y="72" class="po-frac po-rouge">% dans l’échantillon</text>

    <!-- 0 à 2 : deux groupes d'âge, côte à côte. -->
    {#each COLONNES as c}
      {@const w = e >= c.vu ? c.poids : 1}
      <g>
        <text x={c.x0} y="122" class="po-groupe">{c.groupe} ans</text>

        <!-- le calcul, au clic -->
        <g class="po-etape" class:po-vu={e >= c.vu}>
          <text x={c.x0 + 320} y="104" class="po-fnum po-gris">{f(c.pop)}</text>
          <line x1={c.x0 + 296} y1="112" x2={c.x0 + 344} y2="112" class="po-barre-p" />
          <text x={c.x0 + 320} y="134" class="po-fnum po-rouge">{f(c.ech)}</text>
          <text x={c.x0 + 356} y="126" class="po-poids">=&#8239;{f(c.poids)}</text>
        </g>

        <!-- le plancher : la place du groupe au Canada -->
        <rect x={c.x0} y={SOL + 3} width={c.plancher} height="10" class="po-plancher" />
        <line x1={c.x0 + c.plancher} y1="160" x2={c.x0 + c.plancher} y2={SOL + 13} class="po-fin" />

        <!-- les répondant.e.s de la CES -->
        {#each Array.from({ length: c.n }, (_, i) => i) as i}
          <g class="po-perso" style:transform="translate({c.x0 + i * c.u * w}px, {SOL}px) scale({w})">
            <rect x={c.u * 0.2} y={-c.u * 0.8} width={c.u * 0.6} height={c.u * 0.8} />
            <circle cx={c.u * 0.5} cy={-c.u * 1.02} r={c.u * 0.17} />
          </g>
        {/each}

        <text x={c.x0} y="286" class="po-lib po-rouge">CES {f(c.ech)}&#8239;%</text>
        <text x={c.x0 + c.plancher} y="286" class="po-lib po-gris po-fin-txt">Canada {f(c.pop)}&#8239;%</text>
        <text x={c.x0} y="314" class="po-sens po-etape" class:po-vu={e >= c.vu}>chacun compte pour {f(c.poids)} personne</text>
      </g>
    {/each}

    <!-- 3 : la conclusion. -->
    <text x="500" y="390" class="po-phrase po-etape" class:po-vu={e >= 3}>Chaque répondant.e reçoit son poids.</text>
    <text x="500" y="426" class="po-sens po-centre po-etape" class:po-vu={e >= 3}>Trop peu nombreux&#8239;: plus de 1. Trop nombreux&#8239;: moins de 1.</text>
  </svg>
</div>

<style>
  .ponderation { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }
  .po-titre { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .po-frac { font-size: 20px; font-weight: 600; text-anchor: middle; }
  .po-barre { stroke: var(--dk-encre); stroke-width: 2; }
  .po-gris { fill: var(--dk-gris); }
  .po-rouge { fill: var(--dk-accent); }
  .po-groupe { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .po-fnum { font-size: 20px; font-weight: 600; text-anchor: middle; }
  .po-barre-p { stroke: var(--dk-encre); stroke-width: 2; }
  .po-poids { font-size: 28px; font-weight: 700; fill: var(--dk-accent); }
  .po-plancher { fill: var(--dk-gris-2); }
  .po-fin { stroke: var(--dk-gris); stroke-width: 2; stroke-dasharray: 5 5; }
  .po-perso { fill: var(--dk-accent); transform-box: view-box; transform-origin: 0 0; transition: transform 0.9s ease-in-out; }
  .po-lib { font-size: 17px; font-weight: 600; }
  .po-fin-txt { text-anchor: end; }
  .po-centre { text-anchor: middle; }
  .po-sens { font-size: 17px; fill: var(--dk-gris); }
  .po-phrase { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .po-etape { opacity: 0; transition: opacity 0.3s; }
  .po-etape.po-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .po-etape, .po-etape.po-vu, .po-perso { transition: none; }
  }
</style>
