<script>
  /**
   * Quatre sortes de vide. Quatre cartes, une par clic, comme l'ancienne
   * TroisVides : une grande valeur, un dessin, un grand nombre, une ligne.
   * Le dessin porte l'idée; le texte reste minimal.
   *
   *   1  -99 : l'histogramme réel de l'échelle gauche-droite
   *      (GAUCHE_DROITE.effectifs). La barre de -99 (n99) a l'air d'une
   *      réponse, puis glisse loin à gauche de la règle 0-10 et entraîne la
   *      moyenne de moyennePropre à moyenneBrute.
   *   2  « Ne sait pas » : une case cochée parmi les choix de réponse
   *      (VOTE_VIDE.nsp), puis la fourche : catégorie ou NA.
   *   3  NA : trois questions, celle du vote est sautée (VOTE_VIDE.na). Pas
   *      d'étiquette « déjà voté » : ce n'est qu'une des raisons.
   *   4  NaN : la même règle 0-10, vide; la moyenne ne trouve pas où se
   *      poser. Dans R : 0 / 0 (CONSOLES_PLUS.nan[0]).
   *
   * Aucun nombre n'est tapé à la main.
   */
  import { brancherTemps } from '../temps.js';
  import { GAUCHE_DROITE, VOTE_VIDE } from '$lib/data/seance4.js';
  import { CONSOLES_PLUS } from '$lib/data/seance4_plus.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const virgule = (x) => x.toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).replace('-', '−');
  const sortie = (l) => l.out.replace(/^\[1\]\s*/, '');

  // -99 : règle à l'échelle, de -12,2 à 10, avec une coupure pour loger -99.
  const G = GAUCHE_DROITE;
  const AXE = 80;
  const HMAX = 62;
  const xg = (v) => 140 + v * 9;
  const max = Math.max(...G.effectifs);
  const BARRES = G.valeurs
    .map((v, i) => ({ v, h: (G.effectifs[i] / max) * HMAX }))
    .filter((b) => b.v >= 0);
  const H99 = (G.n99 / max) * HMAX;
  const X99 = 12;
  const DEPART99 = xg(-1.5) - X99; // d'où part la barre : juste à côté du 0
  const XM = xg(G.moyenneBrute);
  const DEPARTM = xg(G.moyennePropre) - XM;

  // NaN : la même règle, sans personne dessus.
  const xn = (v) => 30 + v * 18;

  const NAN = CONSOLES_PLUS.nan[0];
</script>

<div class="visuel quatre-vides" bind:this={hote}>
  <!-- 1. -99 -->
  <div class="carte n99" class:vu={e > 0}>
    <span class="glyphe">−99</span>
    <svg class="dessin" viewBox="0 0 240 128" aria-hidden="true">
      {#each BARRES as b}
        <rect x={xg(b.v) - 3.5} y={AXE - b.h} width="7" height={b.h} class="barre" />
      {/each}
      <line x1="30" y1={AXE} x2="236" y2={AXE} class="prolonge" />
      <line x1={xg(0) - 5} y1={AXE} x2={xg(10) + 5} y2={AXE} class="regle" />
      {#each [0, 5, 10] as t}
        <text x={xg(t)} y={AXE + 17} class="graduation">{t}</text>
      {/each}
      <line x1="2" y1={AXE} x2="20" y2={AXE} class="prolonge" />
      <path d="M 21 {AXE + 6} l 5 -12 M 26 {AXE + 6} l 5 -12" class="coupure" />
      <g class="glisse" style="--de: {DEPART99}px">
        <rect x={X99 - 4.5} y={AXE - H99} width="9" height={H99} class="b99" />
      </g>
      <text x={X99} y={AXE + 17} class="graduation rouge">−99</text>
      <g class="glisse moy" style="--de: {DEPARTM}px">
        <path d="M {XM} {AXE + 24} l -6 10 h 12 z" class="triangle" />
      </g>
      <text x={xg(G.moyennePropre)} y={AXE + 47} class="etiq avant">moyenne {virgule(G.moyennePropre)}</text>
      <text x={XM - 8} y={AXE + 47} class="etiq apres">moyenne {virgule(G.moyenneBrute)}</text>
    </svg>
    <span class="n">{milliers(G.n99)}</span>
    <span class="unite">personnes</span>
    <p>R le lit comme un nombre</p>
  </div>

  <!-- 2. Ne sait pas -->
  <div class="carte nsp" class:vu={e > 1}>
    <span class="glyphe">Ne sait pas</span>
    <div class="dessin choix">
      <div class="partis">
        <span class="option"><i></i>PLC</span>
        <span class="option"><i></i>PCC</span>
        <span class="option"><i></i>NPD</span>
      </div>
      <span class="option coche"><i></i>Ne sait pas</span>
      <div class="fourche">
        <svg viewBox="0 0 200 26" preserveAspectRatio="none" aria-hidden="true">
          <path d="M 100 0 V 8 M 100 8 L 45 24 M 100 8 L 155 24" />
        </svg>
        <span class="branche">catégorie</span><span class="branche">NA</span>
      </div>
    </div>
    <span class="n">{milliers(VOTE_VIDE.nsp)}</span>
    <span class="unite">personnes</span>
    <p>Une vraie réponse</p>
  </div>

  <!-- 3. NA -->
  <div class="carte na" class:vu={e > 2}>
    <span class="glyphe">NA</span>
    <svg class="dessin" viewBox="0 0 240 128" aria-hidden="true">
      {#each [['âge', 4], ['scolarité', 94]] as [q, y]}
        <rect x="6" {y} width="150" height="30" class="question" />
        <text x="18" y={y + 20} class="libelle">{q}</text>
        <rect x="136" y={y + 10} width="10" height="10" class="repondu" />
      {/each}
      <rect x="6" y="49" width="150" height="30" class="question pleine" />
      <rect x="6" y="49" width="150" height="30" class="question trou" />
      <text x="18" y="69" class="libelle vote">vote</text>
      <text x="146" y="69" class="libelle vote na-mot">NA</text>
      <path d="M 162 19 C 236 19, 236 109, 162 109" class="saut" pathLength="1" />
      <path d="M 170 103 L 161 109 L 170 115" class="pointe" />
    </svg>
    <span class="n">{milliers(VOTE_VIDE.na)}</span>
    <span class="unite">personnes</span>
    <p>Question jamais posée</p>
  </div>

  <!-- 4. NaN -->
  <div class="carte nan" class:vu={e > 3}>
    <span class="glyphe">NaN</span>
    <svg class="dessin" viewBox="0 0 240 128" aria-hidden="true">
      <rect x="18" y="18" width="204" height="58" class="groupe" />
      <text x="120" y="53" class="vide-mot">aucune réponse</text>
      <line x1={xn(0) - 5} y1={AXE} x2={xn(10) + 5} y2={AXE} class="regle" />
      {#each [0, 5, 10] as t}
        <text x={xn(t)} y={AXE + 17} class="graduation">{t}</text>
      {/each}
      <g class="cherche">
        <path d="M {xn(5)} {AXE + 24} l -6 10 h 12 z" class="triangle" />
        <text x={xn(5)} y={AXE + 47} class="etiq point">?</text>
      </g>
    </svg>
    <code class="calcul"><span class="in">{NAN.in}</span><span class="fleche">→</span><span class="out">{sortie(NAN)}</span></code>
    <span class="unite">dans R</span>
    <p>Un calcul sans réponse</p>
  </div>

  <p class="source">Étude électorale canadienne 2025 · {milliers(G.n)} personnes</p>
</div>

<style>
  .quatre-vides { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 1em; align-items: stretch; }

  /* Une carte par clic, comme l'ancienne version. */
  .carte { display: flex; flex-direction: column; border: 3px solid var(--dk-encre); padding: 0.8em 0.9em 0.8em; visibility: hidden; opacity: 0; }
  .carte.vu { visibility: visible; animation: fondu 0.4s both; }
  .glyphe { font-size: 1.7em; font-weight: 600; line-height: 1.2; letter-spacing: -0.02em; white-space: nowrap; }
  .dessin { display: block; width: 100%; height: 7.6em; margin: 0.5em 0 0.4em; overflow: visible; }
  .n { font-size: 2.3em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; margin-top: auto; }
  .unite { font-size: 0.6em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; margin-top: 0.3em; }
  .carte p { margin: 0.6em 0 0; padding-top: 0.5em; border-top: 2px solid var(--dk-filet); font-size: 0.82em; line-height: 1.35; font-weight: 600; }

  /* Éléments de dessin communs. */
  .regle { stroke: var(--dk-encre); stroke-width: 3; }
  .prolonge { stroke: var(--dk-filet); stroke-width: 2; }
  .graduation { font-family: var(--dk-mono); font-size: 13px; text-transform: none; letter-spacing: 0; font-weight: 600; fill: var(--dk-gris); text-anchor: middle; }
  .triangle { fill: var(--dk-encre); }
  .etiq { font-family: var(--dk-mono); font-size: 13px; text-transform: none; letter-spacing: 0; font-weight: 600; fill: var(--dk-encre); }

  /* 1. -99 : un nombre d'apparence légitime, loin de la règle. */
  .n99 { border-color: var(--dk-accent); }
  .n99 .glyphe { color: var(--dk-accent); }
  .barre { fill: var(--dk-encre); }
  .b99 { fill: var(--dk-accent); }
  .coupure { stroke: var(--dk-gris); stroke-width: 2; fill: none; }
  .rouge { fill: var(--dk-accent); }
  .n99 .moy .triangle { fill: var(--dk-accent); }
  .n99 .etiq.avant { text-anchor: middle; opacity: 0; }
  .n99 .etiq.apres { text-anchor: start; fill: var(--dk-accent); }
  .n99.vu .glisse { animation: glisse 1.1s 0.6s both cubic-bezier(0.55, 0, 0.3, 1); }
  .n99.vu .b99 { animation: vire 1.1s 0.6s both; }
  .n99.vu .moy .triangle { animation: vire 1.1s 0.6s both; }
  .n99.vu .etiq.avant { animation: montre-cache 1.7s both; }
  .n99.vu .etiq.apres, .n99.vu .rouge { animation: apparait 0.4s 1.5s both; }
  @keyframes glisse { from { transform: translateX(var(--de)); } to { transform: none; } }
  @keyframes vire { from { fill: var(--dk-encre); } to { fill: var(--dk-accent); } }
  @keyframes montre-cache { 0%, 45% { opacity: 1; } 70%, 100% { opacity: 0; } }

  /* 2. Ne sait pas : une case cochée parmi les autres, puis la fourche. */
  .choix { display: flex; flex-direction: column; gap: 0.45em; font-size: 0.82em; height: 9.3em; }
  .partis { display: flex; gap: 0.9em; }
  .option { display: flex; align-items: center; gap: 0.45em; font-weight: 600; color: var(--dk-gris); white-space: nowrap; }
  .option i { width: 0.9em; height: 0.9em; border: 2px solid var(--dk-gris); flex: none; }
  .option.coche { color: var(--dk-encre); }
  .option.coche i { border: 3px solid var(--dk-encre); }
  .nsp.vu .coche i { animation: coche 0.3s 0.6s both; }
  @keyframes coche { from { background: transparent; } to { background: var(--dk-encre); } }
  .fourche { display: grid; grid-template-columns: 1fr 1fr; justify-items: center; row-gap: 0.15em; }
  .fourche svg { grid-column: 1 / -1; width: 100%; height: 1.2em; }
  .fourche path { stroke: var(--dk-encre); stroke-width: 2; fill: none; vector-effect: non-scaling-stroke; }
  .branche { font-weight: 600; border: 2px solid var(--dk-encre); padding: 0.15em 0.55em; }
  .nsp.vu .fourche { animation: apparait 0.4s 1s both; }

  /* 3. NA : la question du vote est sautée. */
  .question { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .question.trou { stroke: var(--dk-gris-2); stroke-dasharray: 6 5; fill: var(--dk-fond-2); opacity: 0; }
  .libelle { font-family: var(--dk-mono); font-size: 15px; font-weight: 600; fill: var(--dk-encre); }
  .libelle.vote { transition: fill 0.4s; }
  .na-mot { text-anchor: end; fill: var(--dk-gris); opacity: 0; }
  .repondu { fill: var(--dk-encre); }
  .saut { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .pointe { fill: none; stroke: var(--dk-accent); stroke-width: 3; opacity: 0; }
  .na.vu .saut { animation: trace 0.8s 0.5s both; }
  .na.vu .pointe { animation: apparait 0.2s 1.2s both; }
  .na.vu .pleine { animation: montre-cache 2.4s both; }
  .na.vu .trou, .na.vu .na-mot { animation: apparait 0.5s 1.3s both; }
  .na.vu .vote:not(.na-mot) { animation: grisee 0.5s 1.3s both; }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes grisee { to { fill: var(--dk-gris-2); } }

  /* 4. NaN : une règle sans personne; la moyenne ne sait pas où se poser. */
  .groupe { fill: none; stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 6 5; }
  .vide-mot { font-family: var(--dk-mono); font-size: 15px; font-weight: 600; fill: var(--dk-gris-2); text-anchor: middle; }
  .point { text-anchor: middle; font-size: 17px; fill: var(--dk-accent); }
  .nan.vu .cherche { animation: cherche 1.6s 0.4s both ease-in-out; }
  .nan.vu .point { animation: apparait 0.3s 2s both; }
  @keyframes cherche { 0% { transform: none; } 25% { transform: translateX(-80px); } 60% { transform: translateX(80px); } 100% { transform: none; } }
  .calcul { display: flex; align-items: baseline; gap: 0.45em; margin-top: auto; font-family: var(--dk-mono); font-size: 1.55em; font-weight: 600; line-height: 1; white-space: nowrap; }
  .calcul .fleche { color: var(--dk-gris); font-weight: 400; }
  .calcul .out { color: var(--dk-accent); }

  .source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes apparait { from { opacity: 0; } to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .carte.vu { animation: none; opacity: 1; }
    .n99.vu .glisse, .n99.vu .b99, .n99.vu .moy .triangle, .nan.vu .cherche { animation: none !important; }
    .n99.vu .etiq.avant { animation: none !important; opacity: 0; }
    .n99.vu .etiq.apres, .n99.vu .rouge, .nsp.vu .fourche, .na.vu .pointe, .na.vu .trou, .na.vu .na-mot, .nan.vu .point { animation: none !important; opacity: 1; }
    .nsp.vu .coche i { animation: none !important; background: var(--dk-encre); }
    .na.vu .saut { animation: none !important; stroke-dashoffset: 0; }
    .na.vu .pleine { animation: none !important; opacity: 0; }
    .na.vu .vote:not(.na-mot) { animation: none !important; fill: var(--dk-gris-2); }
  }
</style>
