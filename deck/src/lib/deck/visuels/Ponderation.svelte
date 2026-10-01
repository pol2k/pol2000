<script>
  /**
   * La pondération, puis le ratissage (raking). Suite de « La CES
   * ressemble-t-elle au Canada ? ». Cinq temps (quatre clics).
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
   *   3  Le ratissage : l'âge, le genre et la région à corriger ensemble.
   *      Une ligne verticale (le Canada), trois barres rouges qui partent
   *      d'elle (l'écart de la CES, à gauche s'il en manque, à droite s'il y
   *      en a trop). On ajuste une jauge à la fois : son écart tombe à zéro,
   *      les deux autres bougent un peu. Une flèche en boucle tourne d'un
   *      tiers à chaque correction et compte les tours. Les écarts fondent
   *      en trois tours (environ six secondes).
   *   4  Tout est à zéro : « Jusqu'à ce que tout colle : c'est le
   *      ratissage (raking). » (Remplace la ligne du temps 3.)
   *
   * Les pourcentages et les rangées de personnages viennent de RECENSEMENT
   * (src/lib/data/seance5_normale.js : Statistique Canada, tableau
   * 17-10-0005-01, et la CES 2025 brute). Les poids sont leur rapport,
   * calculé ici. La longueur d'une rangée est proportionnelle au % de la CES,
   * celle d'un plancher au % du Canada : une rangée grossie du poids a donc
   * exactement la longueur du plancher. Le nombre de personnages est le %
   * arrondi (un personnage par point de %), c'est un dessin, pas un effectif.
   * Les jauges du ratissage sont un schéma : leurs écarts sont inventés pour
   * montrer la méthode, pas mesurés (« schéma » à l'écran).
   * La règle est celle du cours FAS1001 de l'enseignant (« poids = % dans
   * la population / % dans l'échantillon »).
   *
   * Toutes les animations passent par transform (CSS), jamais par x, width
   * ou cx. Au dernier clic, l'état est fixe : rangées à leur taille finale,
   * écarts à zéro, compteur au troisième tour.
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

  // Le ratissage : une suite d'états [âge, genre, région] (écarts au
  // Canada, en unités de schéma) et la jauge qu'on vient d'ajuster.
  // Trois tours : âge, genre, région, puis on recommence.
  const ETATS = [
    { d: [0.8, -0.55, 0.6], ajuste: -1 },
    { d: [0, -0.35, 0.45], ajuste: 0 },
    { d: [0.2, 0, 0.3], ajuste: 1 },
    { d: [0.1, 0.12, 0], ajuste: 2 },
    { d: [0, 0.07, 0.05], ajuste: 0 },
    { d: [0.03, 0, 0.03], ajuste: 1 },
    { d: [0.015, 0.015, 0], ajuste: 2 },
    { d: [0, 0, 0], ajuste: -1 }
  ];
  const PAS = 750;
  let t = $state(0);
  $effect(() => {
    if (e !== 3) return;
    t = 0;
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
  const tour = $derived(Math.max(1, Math.ceil(k / 3)));
  const JAUGES = ['l’âge', 'le genre', 'la région'];
  const LIGNE = 410, ECHELLE = 150, RAIL = 220;
  const jy = (i) => 388 + i * 32;
  const BX = 800, BY = 410, BR = 34; // la flèche en boucle
  // L'arc de la boucle : 300 degrés, ouvert en haut à droite, flèche au bout.
  const pt = (deg) => [BR * Math.cos((deg * Math.PI) / 180), BR * Math.sin((deg * Math.PI) / 180)];
  const [ax0, ay0] = pt(-60), [ax1, ay1] = pt(-120);
  const ARC = `M ${ax0} ${ay0} A ${BR} ${BR} 0 1 1 ${ax1} ${ay1}`;
  // La pointe suit la tangente au bout de l'arc (sens horaire, à -120°).
  const TX = Math.sin((120 * Math.PI) / 180), TY = Math.cos((120 * Math.PI) / 180);
  const POINTE = [
    [ax1 + 12 * TX, ay1 + 12 * TY],
    [ax1 - 7 * TY, ay1 + 7 * TX],
    [ax1 + 7 * TY, ay1 - 7 * TX]
  ].map((p) => p.join(',')).join(' ');
</script>

<div class="visuel ponderation" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Un poids = % dans la population ÷ % dans l’échantillon. Les {JEUNES.groupe} ans : {f(JEUNES.pop)} % du Canada, {f(JEUNES.ech)} % de la CES. Les personnages de la CES grossissent : chacun compte pour {f(JEUNES.poids)} personne. Les {AINES.groupe} ans : {f(AINES.pop)} % contre {f(AINES.ech)} %. Ils rapetissent : chacun compte pour {f(AINES.poids)} personne. Puis on corrige l’âge, le genre et la région à la fois. Corriger l’un dérange les autres, alors on recommence, tour après tour, jusqu’à ce que tout colle : c’est le ratissage. Schéma.">
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

    <!-- 3 : le ratissage. -->
    <g class="po-etape" class:po-vu={e >= 3}>
      <text x="30" y="358" class="po-sous">à corriger ensemble</text>
      <text x="980" y="358" class="po-note">schéma</text>
      <text x={LIGNE} y="358" class="po-lib po-gris po-centre">Canada</text>
      {#each JAUGES as j, i}
        <text x="30" y={jy(i) + 6} class="po-jauge" class:po-actif={ETAT.ajuste === i}>{j}</text>
        <line x1={LIGNE - RAIL} y1={jy(i)} x2={LIGNE + RAIL} y2={jy(i)} class="po-rail" />
        <rect x="0" y="-10" width="1" height="20" class="po-ecart" style:transform="translate({LIGNE}px, {jy(i)}px) scaleX({ETAT.d[i] * ECHELLE})" />
      {/each}
      <line x1={LIGNE} y1="368" x2={LIGNE} y2="466" class="po-cible" />

      <!-- la boucle : un tiers de tour à chaque correction -->
      <g class="po-boucle" class:po-tourne={e === 3} style:transform="translate({BX}px, {BY}px) rotate({e >= 3 ? k * 120 : 0}deg)">
        <path d={ARC} class="po-arc" />
        <polygon points={POINTE} class="po-pointe" />
      </g>
      <text x={BX} y={BY + 11} class="po-tour">{tour}</text>
      <text x={BX + BR + 16} y={BY + 6} class="po-lib po-gris">tour</text>

      <text x="30" y="490" class="po-sens po-sort" class:po-cache={e >= 4}>corriger l’un dérange les autres</text>
    </g>

    <!-- 4 : tout colle. -->
    <text x="500" y="490" class="po-phrase po-etape" class:po-vu={e >= 4}>Jusqu’à ce que tout colle&#8239;: c’est le <tspan class="po-rouge">ratissage</tspan> (raking).</text>
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
  .po-sous { font-size: 19px; font-weight: 700; fill: var(--dk-encre); }
  .po-note { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .po-jauge { font-size: 19px; font-weight: 600; fill: var(--dk-gris); transition: fill 0.2s; }
  .po-jauge.po-actif { fill: var(--dk-accent); }
  .po-rail { stroke: var(--dk-gris-2); stroke-width: 2; }
  .po-cible { stroke: var(--dk-encre); stroke-width: 4; }
  .po-ecart { fill: var(--dk-accent); transform-box: view-box; transform-origin: 0 0; transition: transform 0.5s ease-in-out; }
  .po-boucle { transform-box: view-box; transform-origin: 0 0; }
  .po-boucle.po-tourne { transition: transform 0.5s ease-in-out; }
  .po-arc { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .po-pointe { fill: var(--dk-accent); }
  .po-tour { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .po-phrase { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .po-sort { transition: opacity 0.3s; }
  .po-cache { opacity: 0; }
  .po-etape { opacity: 0; transition: opacity 0.3s; }
  .po-etape.po-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .po-etape, .po-etape.po-vu, .po-sort, .po-jauge, .po-perso, .po-ecart, .po-boucle.po-tourne { transition: none; }
  }
</style>
