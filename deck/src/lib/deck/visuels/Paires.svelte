<script>
  /**
   * Pourquoi choisir la moyenne, la médiane, l'écart type, les quartiles ?
   * Parce qu'ils voyagent en couples. Trois temps, un seul jeu de données.
   *
   *   0  Douze valeurs fictives (BASE), montrées deux fois : en haut avec un
   *      repère à la moyenne et une barre d'un écart type de chaque côté ; en
   *      bas avec un repère à la médiane et une boîte du premier au troisième
   *      quartile.
   *   1  Une treizième valeur arrive loin à droite (OUTLIER = 73), en rouge,
   *      dans les deux bandes à la fois : même jeu de données.
   *   2  Conséquence, calculée (pas mise en scène) :
   *        - moyenne : 24,25 → 28 (+3,75) ; écart type (n − 1) : 3,65 → 13,96
   *          (×3,8). La barre du haut s'étire nettement.
   *        - médiane : 24,5 → 25 (+0,5, presque rien).
   *        - quartiles : 21,5 et 27 des deux côtés, identiques avant et
   *          après (voir le contrôle plus bas) : la boîte du bas ne bouge
   *          pas.
   *   3  La règle, puis un cas réel : taille du ménage à l'Étude électorale
   *      canadienne 2025, où une personne a répondu 100 000 000.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // --- Les douze valeurs fictives, triées, et la valeur extrême. ---
  const BASE = [18, 20, 21, 22, 23, 24, 25, 26, 27, 27, 27, 31];
  const OUTLIER = 73;
  const AVEC = [...BASE, OUTLIER];

  const moyenne = (v) => v.reduce((s, n) => s + n, 0) / v.length;
  const ecartType = (v) => {
    const m = moyenne(v);
    return Math.sqrt(v.reduce((s, n) => s + (n - m) ** 2, 0) / (v.length - 1));
  };
  const mediane = (v) => {
    const s = [...v].sort((a, b) => a - b);
    const n = s.length;
    const m = Math.floor(n / 2);
    return n % 2 ? s[m] : (s[m - 1] + s[m]) / 2;
  };
  // Méthode des « charnières » : on coupe en deux moitiés de part et d'autre
  // de la médiane, et Q1/Q3 sont les médianes de ces moitiés.
  const quartiles = (v) => {
    const s = [...v].sort((a, b) => a - b);
    const n = s.length;
    const bas = s.slice(0, Math.floor(n / 2));
    const haut = s.slice(Math.ceil(n / 2));
    return [mediane(bas), mediane(haut)];
  };

  const MOY0 = moyenne(BASE), ET0 = ecartType(BASE), MED0 = mediane(BASE);
  const [Q1, Q3] = quartiles(BASE);
  const MOY1 = moyenne(AVEC), ET1 = ecartType(AVEC), MED1 = mediane(AVEC);
  const [Q1b, Q3b] = quartiles(AVEC);

  // Le cœur de la preuve : la boîte ne doit pas bouger. Si un jour quelqu'un
  // change BASE ou OUTLIER sans vérifier, ceci le signale tout de suite.
  if (Q1 !== Q1b || Q3 !== Q3b) {
    throw new Error('Paires : les quartiles doivent rester identiques avant et après la valeur extrême.');
  }

  // --- Échelle commune aux deux bandes. ---
  const DMIN = 10, DMAX = 76, X0 = 150, X1 = 1850;
  const x = (v) => X0 + ((v - DMIN) / (DMAX - DMIN)) * (X1 - X0);

  const xMoyAvant = x(MOY0), xMoyApres = x(MOY1);
  const xMedAvant = x(MED0), xMedApres = x(MED1);
  const xBarAvantG = x(MOY0 - ET0), xBarAvantD = x(MOY0 + ET0);
  const xBarApresG = x(MOY1 - ET1), xBarApresD = x(MOY1 + ET1);
  const xQ1 = x(Q1), xQ3 = x(Q3);
  const xOut = x(OUTLIER);

  const POINTS = BASE.map((v, i) => ({ v, cx: x(v), dy: (i % 3 - 1) * 16, d: i * 35 }));

  // --- Lignes verticales de mise en page. ---
  // Le dessin fait 2000 unités de large pour environ 880 px à l'écran : tout
  // y est donc réduit de moitié et plus. Les corps de texte sont dimensionnés
  // en conséquence, sinon les étiquettes tombent sous les 10 px en salle.
  const Y_HAUT = 175, LBL_HAUT = 96, MQ_HAUT_0 = 112, MQ_HAUT_1 = 238, BAR_HAUT_Y = 252, REAC_HAUT_Y = 348;
  const Y_BAS = 478, LBL_BAS = 399, MQ_BAS_0 = 416, MQ_BAS_1 = 542, BAR_BAS_Y = 556, REAC_BAS_Y = 652;
</script>

<div class="visuel pr-fig" bind:this={hote}>
  <svg
    class="pr-svg"
    viewBox="0 0 2000 700"
    role="img"
    aria-label="Un même jeu de douze valeurs fictives montré deux fois, en deux bandes horizontales. En haut, un repère à la moyenne et une barre d'un écart type de chaque côté. En bas, un repère à la médiane et une boîte du premier au troisième quartile. Une valeur extrême arrive loin à droite, dans les deux bandes à la fois : en haut, la moyenne et l'écart type se déplacent nettement ; en bas, la médiane et les quartiles restent presque immobiles."
  >
    <line x1={X0} y1={Y_HAUT + 34} x2={X1} y2={Y_HAUT + 34} class="pr-base" />
    <line x1={X0} y1={Y_BAS + 34} x2={X1} y2={Y_BAS + 34} class="pr-base" />

    <text x={X1} y="40" class="pr-fictif">distribution&#8239;: exemple fictif</text>

    <!-- Bande du haut : la moyenne et l'écart type. -->
    <text x={X0} y={LBL_HAUT} class="pr-label">LA MOYENNE ET L'ÉCART TYPE</text>
    <rect
      class="pr-barre"
      x={e >= 2 ? xBarApresG : xBarAvantG}
      y={BAR_HAUT_Y}
      width={(e >= 2 ? xBarApresD - xBarApresG : xBarAvantD - xBarAvantG)}
      height="40"
    />
    <line
      class="pr-marqueur"
      x1={xMoyAvant} x2={xMoyAvant} y1={MQ_HAUT_0} y2={MQ_HAUT_1}
      style="transform: translateX({e >= 2 ? xMoyApres - xMoyAvant : 0}px)"
    />
    {#each POINTS as p}
      <circle class="pr-point" cx={p.cx} cy={Y_HAUT + p.dy} r="15" style="--d: {p.d}ms" />
    {/each}
    <circle class="pr-outlier" class:pr-vu={e >= 1} cx={xOut} cy={Y_HAUT} r="17" />
    <text
      class="pr-reac pr-reac-haut"
      class:pr-vu={e >= 2}
      x={(xBarApresG + xBarApresD) / 2}
      y={REAC_HAUT_Y}
    >les deux se font tirer</text>

    <!-- Bande du bas : la médiane et les quartiles. -->
    <text x={X0} y={LBL_BAS} class="pr-label">LA MÉDIANE ET LES QUARTILES</text>
    <rect class="pr-boite" x={xQ1} y={BAR_BAS_Y} width={xQ3 - xQ1} height="40" />
    <line
      class="pr-marqueur"
      x1={xMedAvant} x2={xMedAvant} y1={MQ_BAS_0} y2={MQ_BAS_1}
      style="transform: translateX({e >= 2 ? xMedApres - xMedAvant : 0}px)"
    />
    {#each POINTS as p}
      <circle class="pr-point" cx={p.cx} cy={Y_BAS + p.dy} r="15" style="--d: {p.d}ms" />
    {/each}
    <circle class="pr-outlier" class:pr-vu={e >= 1} cx={xOut} cy={Y_BAS} r="17" />
    <text
      class="pr-reac pr-reac-bas"
      class:pr-vu={e >= 2}
      x={(xQ1 + xQ3) / 2}
      y={REAC_BAS_Y}
    >les deux tiennent bon</text>
  </svg>

  <div class="pr-clot">
    <p class="pr-regle" class:pr-vu={e >= 3}>Chaque centre a sa dispersion. On rapporte un couple, pas un mélange.</p>
    <p class="pr-menage" class:pr-vu={e >= 3}>
      Taille du ménage&#8239;: moyenne 5 088, médiane 2. <span class="pr-accent">Devinez laquelle ment.</span>
    </p>
    <p class="pr-source" class:pr-vu={e >= 3}>Étude électorale canadienne 2025</p>
  </div>
</div>

<style>
  .pr-fig { display: flex; flex-direction: column; gap: 0.3em; }
  .pr-svg { width: 100%; max-height: 46vh; display: block; overflow: visible; }
  .pr-svg text { font-family: var(--dk-mono); }

  .pr-base { stroke: var(--dk-filet); stroke-width: 4; }

  .pr-label { font-size: 40px; font-weight: 600; letter-spacing: 0.04em; fill: var(--dk-encre); }
  .pr-fictif { font-size: 26px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  .pr-point {
    fill: var(--dk-gris-2);
    stroke: var(--dk-fond);
    stroke-width: 2.5;
    transform-box: fill-box;
    transform-origin: center;
    animation: pr-pop 0.45s cubic-bezier(0.34, 1.7, 0.64, 1) both;
    animation-delay: var(--d);
  }

  .pr-outlier {
    fill: var(--dk-accent);
    stroke: var(--dk-fond);
    stroke-width: 2.5;
    opacity: 0;
    transform-box: fill-box;
    transform-origin: center;
    transform: translateY(-70px) scale(0.7);
  }
  .pr-outlier.pr-vu { animation: pr-chute 0.6s cubic-bezier(0.34, 1.6, 0.64, 1) forwards; }

  .pr-barre, .pr-boite {
    fill: var(--dk-gris-2);
    opacity: 0;
    animation: pr-fondu 0.5s 0.35s both;
    transition: x 0.8s cubic-bezier(0.4, 0, 0.2, 1), width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .pr-marqueur {
    stroke: var(--dk-encre);
    stroke-width: 8;
    opacity: 0;
    animation: pr-fondu 0.5s 0.25s both;
    transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  }

  .pr-reac {
    font-size: 40px;
    font-weight: 600;
    text-anchor: middle;
    paint-order: stroke;
    stroke: var(--dk-fond);
    stroke-width: 14px;
    stroke-linejoin: round;
    opacity: 0;
    transform-box: fill-box;
    transform-origin: center;
    transform: translateY(8px);
    transition: opacity 0.4s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1);
    transition-delay: 0.3s;
  }
  .pr-reac-haut { fill: var(--dk-accent); }
  .pr-reac-bas { fill: var(--dk-encre); }
  .pr-reac.pr-vu { opacity: 1; transform: none; }

  .pr-clot { display: flex; flex-direction: column; gap: 0.25em; margin-top: 0.5em; }
  .pr-regle, .pr-menage {
    margin: 0;
    font-size: 1em;
    font-weight: 600;
    color: var(--dk-encre);
    opacity: 0;
    transform: translateY(6px);
    transition: opacity 0.5s, transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1);
  }
  .pr-menage { font-size: 0.9em; font-weight: 400; transition-delay: 0.15s; }
  .pr-regle.pr-vu, .pr-menage.pr-vu { opacity: 1; transform: none; }
  .pr-accent { color: var(--dk-accent); font-weight: 600; }
  .pr-source {
    margin: 0;
    font-size: 0.6em;
    letter-spacing: 0.06em;
    color: var(--dk-gris);
    text-align: right;
    opacity: 0;
    transition: opacity 0.5s;
    transition-delay: 0.3s;
  }
  .pr-source.pr-vu { opacity: 1; }

  @keyframes pr-pop { from { opacity: 0; transform: scale(0); } to { opacity: 1; transform: scale(1); } }
  @keyframes pr-fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes pr-chute {
    0% { opacity: 0; transform: translateY(-70px) scale(0.7); }
    55% { opacity: 1; transform: translateY(10px) scale(1.08); }
    75% { transform: translateY(-4px) scale(0.97); }
    100% { opacity: 1; transform: translateY(0) scale(1); }
  }

  @media (prefers-reduced-motion: reduce) {
    .pr-point, .pr-barre, .pr-boite, .pr-marqueur, .pr-outlier.pr-vu { animation: none; opacity: 1; }
    .pr-marqueur, .pr-barre, .pr-boite, .pr-reac, .pr-regle, .pr-menage, .pr-source { transition: none; }
    .pr-outlier { opacity: 0; transform: none; }
    .pr-outlier.pr-vu { opacity: 1; }
  }
</style>
