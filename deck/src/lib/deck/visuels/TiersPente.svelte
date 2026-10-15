<script>
  /**
   * « À âge égal » : une troisième variable dans la vraie CES, l'âge. Les
   * aîné.e.s ont en moyenne un peu moins de scolarité, mais beaucoup plus
   * d'intérêt pour la politique. Laissé dans ε, l'âge pousse donc la
   * scolarité vers le bas et l'intérêt vers le haut : il CACHE une partie du
   * lien. Une fois l'âge tenu constant, la pente de la scolarité grandit
   * (0,17 → 0,19). Une troisième variable peut rapprocher une pente de zéro,
   * pas seulement l'en éloigner. Ce qui reste n'est pas prouvé causal.
   *
   * Quatre temps :
   *   0  Deux comparaisons, 35 ans et moins contre 65 ans et plus : la
   *      scolarité moyenne et l'intérêt moyen.
   *   1  La pente de la scolarité seule, en barre : +0,17.
   *   2  La pente à âge égal, sous la première : +0,19.
   *   3  Ce que la deuxième barre a de plus passe en rouge : « l'âge cachait
   *      une partie du lien ». Et sous elle : causal ? pas prouvé.
   *
   * Tout vient de TIERS dans src/lib/data/seance7.js (outils/seance7_data.R,
   * section 8) : les 20 180 répondant.e.s de la CES 2025, celles et ceux qui
   * ont répondu aux trois questions (TIERS.n). b1_seul = lm(interet ~
   * scolarite), b1_a_egal = le coefficient de la scolarité dans
   * lm(interet ~ scolarite + age). TIERS.jeunes et TIERS.aines : moyennes des
   * 35 ans et moins et des 65 ans et plus. Aucun calcul ici.
   */
  import { brancherTemps } from '../temps.js';
  import { TIERS, VARS } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' '; // espace fine insécable
  const f = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const s = (v) => (v < 0 ? '−' : '+') + f(Math.abs(v));

  // Les comparaisons du haut : une échelle de 0 à 1 par panneau.
  const PANNEAUX = [
    { titre: `${VARS.x.court.toLowerCase()} moyenne`, x0: 190, jeu: TIERS.jeunes.scolarite, ain: TIERS.aines.scolarite },
    { titre: `${VARS.y.court.split(' ')[0].toLowerCase()} moyen`, x0: 650, jeu: TIERS.jeunes.interet, ain: TIERS.aines.interet }
  ];
  const LARGE = 230; // longueur d'une barre qui vaudrait 1

  // La jauge des pentes : 0 à gauche, 0,20 à droite.
  const ZERO = 300, DROITE = 860, BORNE = 0.2;
  const gx = (v) => ZERO + (v / BORNE) * (DROITE - ZERO);
  const SEUL = TIERS.b1_seul, EGAL = TIERS.b1_a_egal;
  const R1 = 262, R2 = 372, H = 38;
  const nb = TIERS.n.toLocaleString('fr-CA');
</script>

<div class="visuel tp" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Dans la CES, les 65 ans et plus ont un peu moins de scolarité que les 35 ans et moins ({f(TIERS.aines.scolarite)} contre {f(TIERS.jeunes.scolarite)}) mais plus d’intérêt pour la politique ({f(TIERS.aines.interet)} contre {f(TIERS.jeunes.interet)}). La pente de la scolarité passe de {s(SEUL)} seule à {s(EGAL)} à âge égal{N}: l’âge cachait une partie du lien.">
    <!-- 0 : l'âge pousse les deux, en sens contraires. -->
    <text x="0" y="22" class="tp-leg"><tspan class="tp-rouge-t">■ 65 ans et plus</tspan>   <tspan class="tp-encre-t">■ 35 ans et moins</tspan></text>
    {#each PANNEAUX as p}
      <text x={p.x0} y="64" class="tp-titre">{p.titre}</text>
      <rect x={p.x0} y="78" width={p.ain * LARGE} height="30" class="tp-ain" />
      <text x={p.x0 + p.ain * LARGE + 10} y="101" class="tp-val tp-rouge-t">{f(p.ain)}</text>
      <rect x={p.x0} y="116" width={p.jeu * LARGE} height="30" class="tp-jeu" />
      <text x={p.x0 + p.jeu * LARGE + 10} y="139" class="tp-val">{f(p.jeu)}</text>
    {/each}

    <!-- La jauge : le zéro. -->
    <g class="tp-etape" class:tp-vu={e >= 1}>
      <line x1={ZERO} y1={R1 - 70} x2={ZERO} y2={R2 + H + 12} class="tp-zero" />
      <text x={ZERO} y={R2 + H + 38} class="tp-tick">0</text>
    </g>

    <!-- 1 : seule. -->
    <g class="tp-etape" class:tp-vu={e >= 1}>
      <text x={ZERO + 8} y={R1 - 14} class="tp-code" class:tp-efface={e >= 3}>lm(interet ~ scolarite)</text>
      <text x="0" y={R1 + 27} class="tp-rang">seule</text>
      <rect x={ZERO} y={R1} width={gx(SEUL) - ZERO} height={H} class="tp-barre" class:tp-vu-b={e >= 1} style="transform-origin: {ZERO}px 0" />
      <text x={gx(SEUL) + 12} y={R1 + 28} class="tp-b">{s(SEUL)}</text>
    </g>

    <!-- 2 : à âge égal. -->
    <g class="tp-etape" class:tp-vu={e >= 2}>
      <text x={ZERO + 8} y={R2 - 14} class="tp-code" class:tp-efface={e >= 3}>lm(interet ~ scolarite + age)</text>
      <text x="0" y={R2 + 27} class="tp-rang">à âge égal</text>
      <rect x={ZERO} y={R2} width={gx(EGAL) - ZERO} height={H} class="tp-barre" class:tp-vu-b={e >= 2} style="transform-origin: {ZERO}px 0" />
      <rect x={gx(SEUL)} y={R2} width={gx(EGAL) - gx(SEUL)} height={H} class="tp-part" class:tp-on={e >= 3} />
      <text x={gx(EGAL) + 12} y={R2 + 28} class="tp-b">{s(EGAL)}</text>
    </g>

    <!-- 3 : l'âge cachait une partie du lien. -->
    <g class="tp-etape" class:tp-vu={e >= 3}>
      <line x1={gx(SEUL)} y1={R1 - 6} x2={gx(SEUL)} y2={R2 + H + 6} class="tp-guide" />
      <text x={gx(EGAL)} y={R2 - 14} class="tp-note tp-rouge-t tp-fin">l’âge cachait une partie du lien</text>
      <text x={(ZERO + gx(EGAL)) / 2} y={R2 + H + 34} class="tp-sous">causal{N}? pas prouvé</text>
    </g>

    <text x="0" y="484" class="tp-source">La CES, les {nb} qui ont répondu aux trois questions (scolarité, intérêt, âge)</text>
  </svg>
</div>

<style>
  .tp { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .tp-leg { font-size: 21px; font-weight: 600; white-space: pre; }
  .tp-rouge-t { fill: var(--dk-accent); }
  .tp-encre-t { fill: var(--dk-encre); }
  .tp-titre { font-size: 22px; font-weight: 600; fill: var(--dk-gris); }
  .tp-ain { fill: var(--dk-accent); }
  .tp-jeu { fill: var(--dk-encre); }
  .tp-val { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }

  .tp-zero { stroke: var(--dk-encre); stroke-width: 2; }
  .tp-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .tp-code { font-size: 20px; fill: var(--dk-gris); transition: opacity 0.3s; }
  .tp-code.tp-efface { opacity: 0; }
  .tp-fin { text-anchor: end; }
  .tp-rang { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .tp-barre { fill: var(--dk-encre); transform: scaleX(0); transition: transform 0.8s ease-out; }
  .tp-barre.tp-vu-b { transform: scaleX(1); }
  .tp-part { fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s; }
  .tp-part.tp-on { opacity: 1; }
  .tp-b { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .tp-guide { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 6 6; }
  .tp-note { font-size: 24px; font-weight: 700; }
  .tp-sous { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .tp-source { font-size: 17px; fill: var(--dk-gris); }

  .tp-etape { opacity: 0; transition: opacity 0.3s; }
  .tp-etape.tp-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .tp-barre, .tp-part, .tp-etape, .tp-etape.tp-vu { transition: none; }
  }
</style>
