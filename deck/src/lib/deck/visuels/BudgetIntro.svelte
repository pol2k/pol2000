<script>
  /**
   * Le fil rouge de la séance : « Notre budget : 1 000 personnes ». On fait
   * comme si les 20 180 répondant.e.s de l'Étude électorale canadienne 2025
   * étaient toute la population. Comme dans tout vrai sondage, une partie
   * d'entre elles et eux ne déclare pas de vote. On connaît donc la vraie
   * part du vote conservateur, calculée parmi celles et ceux qui déclarent
   * un vote. Une firme de sondage n'a les moyens de questionner que 1 000
   * personnes, tirées parmi les 20 180 : comment les choisir ?
   *
   *   0  La population d'exercice, une grande foule de points (un point
   *      pour 20 répondant.e.s) : vote conservateur en rouge, autre vote en
   *      gris, pas de vote déclaré en contour pâle. Au-dessus, sur toute la
   *      largeur : « Faisons comme si les 20 180 répondant.e.s de la CES
   *      étaient tout le Canada. » (trop longue pour le panneau de droite,
   *      d'où sa place en haut). À droite, « la vraie réponse » en grand
   *      (vote conservateur, parmi les votes déclarés), puis, en petit,
   *      « c'est le paramètre. Chaque sondage en donne un estimé. » (les
   *      mots de la diapo « Quatre mots »), et « ici, on connaît la
   *      réponse ». « La vraie réponse » est le nom de ce 33,1 % dans
   *      toute l'histoire du budget.
   *   1  Une petite boîte de 1 000, à la même échelle que la foule
   *      (50 points vides : on ne sait pas encore qui), et dessous un
   *      porte-monnaie : « budget : 1 000 personnes ».
   *   2  Une flèche pointillée de la foule vers la boîte, et la question en
   *      grand : « Comment choisir les 1 000 ? »
   *
   * La taille de la population, le nombre de répondant.e.s qui déclarent un
   * vote, la vraie part et le budget viennent de BUDGET
   * (src/lib/data/seance5_budget.js, outils/seance5_budget.R, sans
   * pondération). L'échelle (20 répondant.e.s par point) est un choix de
   * dessin. La place des points dans la grille est tirée par un générateur
   * congruentiel à graine fixe : le nombre de points de chaque sorte suit
   * les données, leur position ne veut rien dire.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const nPop = f(BUDGET.population);
  const nBudget = f(BUDGET.n);
  const vrai = f(BUDGET.vrai * 100, 1);

  // Un point pour PAR répondant.e.s, dans la foule comme dans la boîte.
  const PAR = 20;
  const NPOP = Math.round(BUDGET.population / PAR);
  const NBUD = Math.round(BUDGET.n / PAR);
  // Trois sortes de points : vote conservateur (parmi les votes déclarés),
  // autre vote, pas de vote déclaré.
  const NROUGE = Math.round((BUDGET.population * (BUDGET.declares / BUDGET.population) * BUDGET.vrai) / PAR);
  const NMUET = Math.round((BUDGET.population - BUDGET.declares) / PAR);

  // La foule : une grille de COLS colonnes, dans un cadre.
  const COLS = 46, PAS = 11, R = 3.8;
  const FX = 12, FY = 84;
  const RANGS = Math.ceil(NPOP / COLS);
  const FW = COLS * PAS + 16, FH = RANGS * PAS + 14;

  // Quels points sont rouges, lesquels sont muets : Fisher-Yates partiel,
  // graine fixe.
  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(2025);
  const ordre = Array.from({ length: NPOP }, (_, i) => i);
  for (let i = 0; i < NROUGE + NMUET; i++) {
    const j = i + Math.floor(alea() * (NPOP - i));
    [ordre[i], ordre[j]] = [ordre[j], ordre[i]];
  }
  const rouges = new Set(ordre.slice(0, NROUGE));
  const muets = new Set(ordre.slice(NROUGE, NROUGE + NMUET));
  const foule = Array.from({ length: NPOP }, (_, i) => ({
    x: FX + 13 + (i % COLS) * PAS,
    y: FY + 12 + Math.floor(i / COLS) * PAS,
    classe: rouges.has(i) ? 'bi-rouge' : muets.has(i) ? 'bi-muet' : 'bi-pt'
  }));

  // La légende des trois sortes de points, sur une ligne (mono : 0,6 × 18).
  const CAR = 0.6 * 18;
  const LY = FY + FH + 56;
  const LEG = [
    { classe: 'bi-rouge', mot: 'vote conservateur' },
    { classe: 'bi-pt', mot: 'autre vote' },
    { classe: 'bi-muet', mot: 'pas de vote déclaré' }
  ];
  let lx = FX + 6;
  const legende = LEG.map((l) => {
    const item = { ...l, cx: lx, tx: lx + 14 };
    lx += 14 + l.mot.length * CAR + 26;
    return item;
  });

  // La colonne de droite : la vraie réponse en haut, le budget en dessous.
  const CX = 775;
  const PH = 230; // hauteur du panneau de la vraie réponse
  // La boîte du budget : même pas, même rayon que la foule. Le
  // porte-monnaie et « budget : 1 000 personnes » passent sous la boîte,
  // pour que la flèche du temps 2 passe au-dessus d'eux.
  const BCOLS = 10;
  const BR = Math.ceil(NBUD / BCOLS);
  const BW = BCOLS * PAS + 16, BH = BR * PAS + 14;
  const BX = CX - BW / 2, BY = FY + PH + 16;
  const YB = BY + BH + 17; // haut du porte-monnaie
  const boite = Array.from({ length: NBUD }, (_, i) => ({
    x: BX + 13 + (i % BCOLS) * PAS,
    y: BY + 12 + Math.floor(i / BCOLS) * PAS
  }));

  // La flèche pointillée, de la foule vers la boîte.
  const AX1 = FX + FW + 10, AY1 = FY + FH - 20;
  const AX2 = BX - 12, AY2 = BY + BH / 2;
</script>

<div class="visuel budget-intro" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label="Notre population d’exercice. Faisons comme si les {nPop} répondant.e.s de l’Étude électorale canadienne 2025 étaient tout le Canada. Certain.e.s ne déclarent pas de vote. La vraie réponse, le vote conservateur parmi les votes déclarés&#8239;: {vrai}&#8239;%. C’est le paramètre. Chaque sondage en donne un estimé. Ici, on connaît la réponse. Notre budget&#8239;: {nBudget} personnes. Comment choisir les {nBudget}&#8239;?">
    <!-- 0 : la population d'exercice, une foule de points. -->
    <text x={FX} y="34" class="bi-titre">notre population d’exercice</text>
    <text x={FX} y="64" class="bi-t">Faisons comme si les <tspan class="bi-fort">{nPop}</tspan> répondant.e.s de la CES étaient tout le Canada.</text>
    <rect x={FX} y={FY} width={FW} height={FH} class="bi-cadre" />
    {#each foule as p}
      <circle cx={p.x} cy={p.y} r={R} class={p.classe} />
    {/each}
    <text x={FX} y={FY + FH + 28} class="bi-leg">1 point = {PAR} répondant.e.s</text>
    {#each legende as l}
      <circle cx={l.cx} cy={LY - 6} r="6" class={l.classe} />
      <text x={l.tx} y={LY} class="bi-leg">{l.mot}</text>
    {/each}

    <!-- 0 : la vraie réponse, connue, parmi les votes déclarés. -->
    <rect x="575" y={FY} width="400" height={PH} class="bi-panneau" />
    <text x={CX} y={FY + 28} class="bi-t bi-fort bi-m">la vraie réponse</text>
    <text x={CX} y={FY + 52} class="bi-leg bi-m">vote conservateur</text>
    <text x={CX} y={FY + 73} class="bi-leg bi-m">parmi les votes déclarés</text>
    <text x={CX} y={FY + 140} class="bi-vrai">{vrai}&#8239;%</text>
    <text x={CX} y={FY + 168} class="bi-p bi-m">c’est le <tspan class="bi-fort">paramètre</tspan>.</text>
    <text x={CX} y={FY + 188} class="bi-p bi-m">Chaque sondage en donne un <tspan class="bi-fort">estimé</tspan>.</text>
    <text x={CX} y={FY + 216} class="bi-t bi-m bi-accent">ici, on connaît la réponse</text>

    <!-- 1 : une petite boîte de 1 000, à la même échelle, et le budget. -->
    <g class="bi-budget" class:bi-vu={e >= 1}>
      <rect x={BX} y={BY} width={BW} height={BH} class="bi-cadre" />
      {#each boite as p}
        <circle cx={p.x} cy={p.y} r={R} class="bi-vide" />
      {/each}
      <g transform="translate(582 {YB})">
        <rect x="0" y="6" width="58" height="38" class="bi-bourse" />
        <path d="M 0 6 L 10 -6 H 48 L 58 6" class="bi-bourse" />
        <rect x="40" y="18" width="18" height="14" class="bi-fermoir" />
      </g>
      <text x="656" y={YB + 30} class="bi-t bi-fort">budget&#8239;: {nBudget} personnes</text>
    </g>

    <!-- 2 : la question. -->
    <g class="bi-question" class:bi-vu={e >= 2}>
      <path d="M {AX1} {AY1} C {AX1 + 70} {AY1}, {AX2 - 70} {AY2}, {AX2} {AY2}" class="bi-fleche" />
      <path d="M {AX2 - 12} {AY2 - 8} L {AX2} {AY2} L {AX2 - 12} {AY2 + 8}" class="bi-pointe" />
      <text x="500" y="499" class="bi-grande">Comment choisir les {nBudget}&#8239;?</text>
    </g>

    <text x={FX} y="530" class="bi-source">CES 2025, les {nPop} répondant.e.s, sans pondération</text>
  </svg>
</div>

<style>
  .budget-intro { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }

  .bi-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .bi-pt { fill: var(--dk-gris); }
  .bi-muet { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 1.5; }
  .bi-rouge { fill: var(--dk-accent); }
  .bi-vide { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .bi-panneau { fill: var(--dk-fond-2); }

  .bi-titre { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .bi-t { font-size: 20px; fill: var(--dk-encre); }
  .bi-fort { font-weight: 600; }
  .bi-m { text-anchor: middle; }
  .bi-accent { fill: var(--dk-accent); font-weight: 600; }
  .bi-vrai { font-size: 76px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .bi-leg { font-size: 18px; fill: var(--dk-gris); }
  .bi-p { font-size: 17px; fill: var(--dk-gris); }
  .bi-grande { font-size: 36px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .bi-source { font-size: 18px; fill: var(--dk-gris-2); letter-spacing: 0.02em; }

  .bi-bourse { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .bi-fermoir { fill: var(--dk-accent); stroke: var(--dk-encre); stroke-width: 2; }
  .bi-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 8 7; }
  .bi-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 3; }

  .bi-budget { opacity: 0; transform: translateY(12px); transition: opacity 0.2s, transform 0.2s; }
  .bi-budget.bi-vu { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }

  .bi-question { opacity: 0; transition: opacity 0.2s; }
  .bi-question.bi-vu { opacity: 1; transition: opacity 0.5s; }
  .bi-question .bi-grande { transform: translateY(10px); transition: transform 0.2s; }
  .bi-question.bi-vu .bi-grande { transform: none; transition: transform 0.5s 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }

  @media (prefers-reduced-motion: reduce) {
    .bi-budget, .bi-budget.bi-vu, .bi-question, .bi-question.bi-vu,
    .bi-question .bi-grande, .bi-question.bi-vu .bi-grande { transition: none; }
    .bi-budget, .bi-question .bi-grande { transform: none; }
  }
</style>
