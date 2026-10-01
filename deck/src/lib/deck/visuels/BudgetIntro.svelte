<script>
  /**
   * Le fil rouge de la séance : « Notre budget : 1 000 personnes ». On fait
   * comme si les répondant.e.s de l'Étude électorale canadienne 2025 qui
   * déclarent un parti étaient toute la population. On connaît donc la
   * vraie part du vote conservateur. Une firme de sondage n'a les moyens de
   * questionner que 1 000 personnes : comment les choisir ?
   *
   *   0  La population d'exercice, une grande foule de points (un point
   *      pour 20 électeurs), les conservateurs en rouge. À droite, la vraie
   *      valeur en grand, et « ici, on connaît la réponse ».
   *   1  Un porte-monnaie : « budget : 1 000 personnes », et une petite
   *      boîte de 1 000, à la même échelle que la foule (50 points vides :
   *      on ne sait pas encore qui).
   *   2  Une flèche pointillée de la foule vers la boîte, et la question en
   *      grand : « Comment choisir les 1 000 ? »
   *
   * La taille de la population, la vraie part et le budget viennent de
   * BUDGET (src/lib/data/seance5_budget.js, outils/seance5_budget.R, sans
   * pondération). L'échelle (20 électeurs par point) est un choix de dessin.
   * La place des points rouges dans la grille est tirée par un générateur
   * congruentiel à graine fixe : le nombre de points rouges suit la vraie
   * part, leur position ne veut rien dire.
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

  // Un point pour PAR électeurs, dans la foule comme dans la boîte.
  const PAR = 20;
  const NPOP = Math.round(BUDGET.population / PAR);
  const NBUD = Math.round(BUDGET.n / PAR);
  const NROUGE = Math.round(NPOP * BUDGET.vrai);

  // La foule : une grille de COLS colonnes, dans un cadre.
  const COLS = 36, PAS = 14, R = 4.5;
  const FX = 12, FY = 84;
  const RANGS = Math.ceil(NPOP / COLS);
  const FW = COLS * PAS + 16, FH = RANGS * PAS + 14;

  // Quels points sont rouges : Fisher-Yates partiel, graine fixe.
  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(2025);
  const ordre = Array.from({ length: NPOP }, (_, i) => i);
  for (let i = 0; i < NROUGE; i++) {
    const j = i + Math.floor(alea() * (NPOP - i));
    [ordre[i], ordre[j]] = [ordre[j], ordre[i]];
  }
  const rouges = new Set(ordre.slice(0, NROUGE));
  const foule = Array.from({ length: NPOP }, (_, i) => ({
    x: FX + 15 + (i % COLS) * PAS,
    y: FY + 14 + Math.floor(i / COLS) * PAS,
    rouge: rouges.has(i)
  }));

  // La colonne de droite : la vraie valeur en haut, le budget en dessous.
  const CX = 775;
  // La boîte du budget : même pas, même rayon que la foule.
  const BCOLS = 10;
  const BR = Math.ceil(NBUD / BCOLS);
  const BW = BCOLS * PAS + 16, BH = BR * PAS + 14;
  const BX = CX - BW / 2, BY = 326;
  const boite = Array.from({ length: NBUD }, (_, i) => ({
    x: BX + 15 + (i % BCOLS) * PAS,
    y: BY + 14 + Math.floor(i / BCOLS) * PAS
  }));

  // La flèche pointillée, de la foule vers la boîte.
  const AX1 = FX + FW + 10, AY1 = FY + FH - 40;
  const AX2 = BX - 12, AY2 = BY + BH / 2;
</script>

<div class="visuel budget-intro" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label="Notre population d’exercice : {nPop} électeurs de l’Étude électorale canadienne 2025. Vrai vote conservateur : {vrai} %. Ici, on connaît la réponse. Notre budget : {nBudget} personnes. Comment choisir les {nBudget} ?">
    <!-- 0 : la population d'exercice, une foule de points. -->
    <text x={FX} y="34" class="bi-titre">notre population d’exercice</text>
    <text x={FX} y="64" class="bi-t"><tspan class="bi-fort">{nPop}</tspan> électeurs de la CES</text>
    <rect x={FX} y={FY} width={FW} height={FH} class="bi-cadre" />
    {#each foule as p}
      <circle cx={p.x} cy={p.y} r={R} class={p.rouge ? 'bi-rouge' : 'bi-pt'} />
    {/each}
    <text x={FX} y={FY + FH + 30} class="bi-leg">1 point = {PAR} électeurs</text>
    <circle cx={FX + 300} cy={FY + FH + 24} r="6" class="bi-rouge" />
    <text x={FX + 314} y={FY + FH + 30} class="bi-leg">vote conservateur</text>

    <!-- 0 : la vraie valeur, connue. -->
    <rect x="575" y={FY} width="400" height="170" class="bi-panneau" />
    <text x={CX} y={FY + 38} class="bi-t bi-fort bi-m">vrai vote conservateur</text>
    <text x={CX} y={FY + 116} class="bi-vrai">{vrai}&#8239;%</text>
    <text x={CX} y={FY + 152} class="bi-t bi-m bi-accent">ici, on connaît la réponse</text>

    <!-- 1 : le budget, et une petite boîte de 1 000, à la même échelle. -->
    <g class="bi-budget" class:bi-vu={e >= 1}>
      <g transform="translate(582 270)">
        <rect x="0" y="6" width="58" height="38" class="bi-bourse" />
        <path d="M 0 6 L 10 -6 H 48 L 58 6" class="bi-bourse" />
        <rect x="40" y="18" width="18" height="14" class="bi-fermoir" />
      </g>
      <text x="656" y="300" class="bi-t bi-fort">budget&#8239;: {nBudget} personnes</text>
      <rect x={BX} y={BY} width={BW} height={BH} class="bi-cadre" />
      {#each boite as p}
        <circle cx={p.x} cy={p.y} r={R} class="bi-vide" />
      {/each}
    </g>

    <!-- 2 : la question. -->
    <g class="bi-question" class:bi-vu={e >= 2}>
      <path d="M {AX1} {AY1} C {AX1 + 70} {AY1}, {AX2 - 70} {AY2}, {AX2} {AY2}" class="bi-fleche" />
      <path d="M {AX2 - 12} {AY2 - 8} L {AX2} {AY2} L {AX2 - 12} {AY2 + 8}" class="bi-pointe" />
      <text x="500" y="482" class="bi-grande">Comment choisir les {nBudget}&#8239;?</text>
    </g>

    <text x={FX} y="530" class="bi-source">CES 2025, répondant.e.s qui déclarent un parti, sans pondération</text>
  </svg>
</div>

<style>
  .budget-intro { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }

  .bi-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .bi-pt { fill: var(--dk-gris-2); }
  .bi-rouge { fill: var(--dk-accent); }
  .bi-vide { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .bi-panneau { fill: var(--dk-fond-2); }

  .bi-titre { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .bi-t { font-size: 20px; fill: var(--dk-encre); }
  .bi-fort { font-weight: 600; }
  .bi-m { text-anchor: middle; }
  .bi-accent { fill: var(--dk-accent); font-weight: 600; }
  .bi-vrai { font-size: 84px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .bi-leg { font-size: 18px; fill: var(--dk-gris); }
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
