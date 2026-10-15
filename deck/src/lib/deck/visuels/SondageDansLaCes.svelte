<script>
  /**
   * « Dans la vraie vie, on a un sondage » : la diapo qui rend le dispositif
   * impossible à manquer, juste avant « Jouer avec la droite ».
   *
   * À gauche, la foule : les 20 180 répondant.e.s de la CES 2025 (POP.n),
   * un petit carré par personne, en rangées de 180 (chaque rangée est une
   * ligne pointillée : 113 lignes plutôt que 20 180 éléments). C'est la
   * population d'exercice : on y connaît la vraie pente (POP.b1, 0,17).
   * À droite, la droite de la population et, au temps 2, celle de notre
   * sondage (NOTRE.coefs, 0,20), sur scolarité de 0 à 1 (origine à 0) et
   * intérêt de 0,5 à 0,8 (repères écrits) pour que l'écart se voie.
   *
   * Les 1 000 carrés rouges sont schématiques : leur place dans la foule
   * vient d'un générateur pseudo-aléatoire à graine fixe (62, comme notre
   * sondage), pas des vraies lignes tirées par R. Même dessin à chaque fois.
   *
   * Temps :
   *   0  la foule, et la vraie pente : 0,17 (« on connaît la vraie réponse »);
   *   1  1 000 personnes tirées au hasard s'allument en rouge, la foule pâlit :
   *      « notre sondage, comme un vrai sondeur »;
   *   2  la droite de notre sondage : 0,20 (R en garde 981), « proche, pas
   *      pareil ».
   */
  import { brancherTemps } from '../temps.js';
  import { POP, NOTRE } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f2 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const mille = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const P_POP = f2(POP.b1), P_NOTRE = f2(NOTRE.coefs[1].b);
  const SANS = NOTRE.n - NOTRE.n_modele; // 19 sans réponse sur l'intérêt

  // ---- La foule : 180 par rangée, une cellule de 3 unités.
  const COLS = 180, PAS = 3, CX = 20, CY = 78, COTE = 2.2;
  const RANGS = Math.ceil(POP.n / COLS);
  const rangees = Array.from({ length: RANGS }, (_, r) => ({
    y: CY + r * PAS + COTE / 2,
    long: (r === RANGS - 1 ? POP.n - r * COLS : COLS) * PAS
  }));

  // ---- Les 1 000 tiré.e.s : un générateur congruentiel à graine fixe, sans remise.
  function tirer(n, k, graine) {
    let s = graine >>> 0;
    const pris = new Set();
    while (pris.size < k) {
      s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
      pris.add(s % n);
    }
    return [...pris];
  }
  const TIRES = tirer(POP.n, NOTRE.n, 62);
  const CHEMIN = TIRES.map((i) => `M${CX + (i % COLS) * PAS - 0.4} ${CY + Math.floor(i / COLS) * PAS - 0.4}h3v3h-3z`).join('');

  // ---- Les deux droites : scolarité 0 à 1, intérêt 0,5 à 0,8.
  const GX0 = 690, GX1 = 960, GYB = 350, GYT = 110, YMIN = 0.5, YMAX = 0.8;
  const gx = (v) => GX0 + v * (GX1 - GX0);
  const gy = (v) => GYB - ((v - YMIN) / (YMAX - YMIN)) * (GYB - GYT);
  const droite = (b0, b1) => ({ x1: gx(0), y1: gy(b0), x2: gx(1), y2: gy(b0 + b1) });
  const D_POP = droite(POP.b0, POP.b1);
  const D_NOTRE = droite(NOTRE.coefs[0].b, NOTRE.coefs[1].b);
  const nb = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
</script>

<div class="visuel sondage-ces" bind:this={hote} data-temps={e}>
  <svg viewBox="0 0 1000 440" role="img" aria-label="Les {mille(POP.n)} répondant.e.s de la CES, la population d’exercice&#8239;: on y connaît la vraie pente, {P_POP}. On en tire {mille(NOTRE.n)} au hasard, comme un vrai sondeur&#8239;: c’est notre sondage. R en garde {mille(NOTRE.n_modele)}. Leur droite a une pente de {P_NOTRE}&#8239;: proche, pas pareille.">

    <!-- La légende de la foule, qui change au temps 1. -->
    <g class="fondu" class:vu={e === 0}>
      <text x={CX} y="30" class="titre">toute la CES&#8239;: {mille(POP.n)} répondant.e.s</text>
      <text x={CX} y="58" class="sous">on connaît la vraie réponse</text>
    </g>
    <g class="fondu" class:vu={e >= 1}>
      <text x={CX} y="30" class="titre rouge">{mille(NOTRE.n)} tiré.e.s au hasard</text>
      <text x={CX} y="58" class="sous">notre sondage, comme un vrai sondeur</text>
    </g>

    <!-- La foule : chaque rangée est une ligne pointillée, un tiret par personne. -->
    <g class="foule" class:pale={e >= 1}>
      {#each rangees as r}
        <line x1={CX} y1={r.y} x2={CX + r.long} y2={r.y} />
      {/each}
    </g>
    <path d={CHEMIN} class="tires" class:vu={e >= 1} />
    <text x={CX} y="432" class="note fondu" class:vu={e >= 2}>R en garde {mille(NOTRE.n_modele)} ({SANS} sans réponse sur l’intérêt)</text>

    <!-- Les deux droites. -->
    <text x={GX0 - 50} y="30" class="titre droit">pente de toute la CES&#8239;: {P_POP}</text>
    <text x={GX0 - 50} y="62" class="titre droit rouge fondu" class:vu={e >= 2}>pente de notre sondage&#8239;: {P_NOTRE}</text>
    <line x1={GX0} y1={GYB} x2={GX1 + 10} y2={GYB} class="axe" />
    <line x1={GX0} y1={GYB} x2={GX0} y2={GYT - 10} class="axe" />
    {#each [0, 1] as v}
      <line x1={gx(v)} y1={GYB} x2={gx(v)} y2={GYB + 6} class="axe" />
      <text x={gx(v)} y={GYB + 24} class="tick">{v}</text>
    {/each}
    {#each [0.5, 0.6, 0.7, 0.8] as v}
      <line x1={GX0 - 6} y1={gy(v)} x2={GX0} y2={gy(v)} class="axe" />
      <text x={GX0 - 10} y={gy(v) + 5} class="tick fin">{nb(v)}</text>
    {/each}
    <text x={(GX0 + GX1) / 2} y={GYB + 46} class="tick titre-axe">scolarite</text>
    <text transform="translate({GX0 - 50} {(GYB + GYT) / 2}) rotate(-90)" class="tick titre-axe">interet</text>
    <line {...D_POP} class="d-pop" />
    <line {...D_NOTRE} class="d-notre" class:vu={e >= 2} />
    <text x={(GX0 + GX1) / 2} y="432" class="proche fondu" class:vu={e >= 2}>proche, pas pareil</text>
  </svg>
</div>

<style>
  .sondage-ces svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  .titre { font-family: var(--dk-mono); font-size: 23px; font-weight: 600; fill: var(--dk-encre); }
  .titre.rouge { fill: var(--dk-accent); }
  .titre.droit { font-size: 20px; }
  .sous { font-family: var(--dk-mono); font-size: 18px; fill: var(--dk-gris); }
  .note { font-family: var(--dk-mono); font-size: 15px; fill: var(--dk-gris); }
  .fondu { opacity: 0; transition: opacity 0.5s; }
  .fondu.vu { opacity: 1; }

  .foule line { stroke: var(--dk-encre); stroke-width: 2.2; stroke-dasharray: 2.2 0.8; transition: stroke 0.6s, opacity 0.6s; }
  .foule.pale line { opacity: 0.18; }
  .tires { fill: var(--dk-accent); opacity: 0; transition: opacity 0.8s 0.2s; }
  .tires.vu { opacity: 1; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.fin { text-anchor: end; }
  .titre-axe { font-weight: 600; fill: var(--dk-encre); }
  .d-pop { stroke: var(--dk-encre); stroke-width: 4; }
  .d-notre { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 400; stroke-dashoffset: 400; transition: stroke-dashoffset 1s ease-out; }
  .d-notre.vu { stroke-dashoffset: 0; }
  .proche { font-family: var(--dk-mono); font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
</style>
