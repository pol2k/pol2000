<script>
  /**
   * « À vote égal » : la variable confondante dans la vraie CES. Le vote
   * libéral (les gagnant.e.s de l'élection) va avec moins de populisme ET
   * plus de satisfaction envers la démocratie. Une fois le vote tenu
   * constant, la pente du populisme passe de −0,31 à −0,22 : une partie du
   * lien passait par le vote, une partie reste. Ce qui reste n'est pas
   * prouvé causal (d'autres variables peuvent se cacher dans ε).
   *
   * Quatre temps :
   *   0  Deux comparaisons, libéraux contre autres partis : le populisme
   *      moyen (0,55 contre 0,67) et la satisfaction moyenne (0,74 contre
   *      0,48). Le vote pousse les deux.
   *   1  La pente du populisme seul, en barre vers la gauche : −0,31.
   *   2  La pente à vote égal, sous la première : −0,22.
   *   3  La différence (−0,09) passe en rouge : la part du vote. Le reste
   *      (−0,22) en encre : ce qui reste, pas forcément causal.
   *
   * Tout vient de PARTI dans src/lib/data/seance7.js (outils/seance7_data.R,
   * section 8) : les 20 180 répondant.e.s de la CES 2025, celles et ceux qui
   * ont répondu aux deux questions et déclaré un vote (PARTI.n). b1_seul =
   * lm(satisfaction_dem ~ populisme), b1_a_vote_egal = le coefficient du
   * populisme dans lm(satisfaction_dem ~ populisme + vote_liberal). La
   * différence est la seule soustraction faite ici.
   */
  import { brancherTemps } from '../temps.js';
  import { PARTI } from '$lib/data/seance7.js';

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
    { titre: 'populisme moyen', x0: 190, lib: PARTI.populisme_moyen.liberal, aut: PARTI.populisme_moyen.autre },
    { titre: 'satisfaction moyenne', x0: 690, lib: PARTI.satisfaction_moyenne.liberal, aut: PARTI.satisfaction_moyenne.autre }
  ];
  const LARGE = 230; // longueur d'une barre qui vaudrait 1

  // La jauge des pentes : 0 à droite, −0,40 à gauche.
  const ZERO = 940, GAUCHE = 300, BORNE = -0.4;
  const gx = (v) => ZERO - (v / BORNE) * (ZERO - GAUCHE);
  const SEUL = PARTI.b1_seul, EGAL = PARTI.b1_a_vote_egal, DIFF = SEUL - EGAL;
  const R1 = 262, R2 = 372, H = 38;
</script>

<div class="visuel pp" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Dans la CES, les personnes qui ont voté libéral sont moins populistes ({f(PARTI.populisme_moyen.liberal)} contre {f(PARTI.populisme_moyen.autre)}) et plus satisfaites de la démocratie ({f(PARTI.satisfaction_moyenne.liberal)} contre {f(PARTI.satisfaction_moyenne.autre)}). La pente du populisme passe de {s(SEUL)} seul à {s(EGAL)} à vote égal{N}: {s(DIFF)} venait du vote, {s(EGAL)} reste.">
    <!-- 0 : le vote pousse les deux. -->
    <text x="0" y="22" class="pp-leg"><tspan class="pp-rouge-t">■ vote libéral</tspan>   <tspan class="pp-encre-t">■ autres partis</tspan></text>
    {#each PANNEAUX as p}
      <text x={p.x0} y="64" class="pp-titre">{p.titre}</text>
      <rect x={p.x0} y="78" width={p.lib * LARGE} height="30" class="pp-lib" />
      <text x={p.x0 + p.lib * LARGE + 10} y="101" class="pp-val pp-rouge-t">{f(p.lib)}</text>
      <rect x={p.x0} y="116" width={p.aut * LARGE} height="30" class="pp-aut" />
      <text x={p.x0 + p.aut * LARGE + 10} y="139" class="pp-val">{f(p.aut)}</text>
    {/each}

    <!-- La jauge : le zéro. -->
    <g class="pp-etape" class:pp-vu={e >= 1}>
      <line x1={ZERO} y1={R1 - 70} x2={ZERO} y2={R2 + H + 12} class="pp-zero" />
      <text x={ZERO} y={R2 + H + 38} class="pp-tick">0</text>
    </g>

    <!-- 1 : seul. -->
    <g class="pp-etape" class:pp-vu={e >= 1}>
      <text x={ZERO - 8} y={R1 - 14} class="pp-code pp-fin" class:pp-efface={e >= 3}>lm(satisfaction_dem ~ populisme)</text>
      <text x="0" y={R1 + 27} class="pp-rang">seul</text>
      <rect x={gx(SEUL)} y={R1} width={ZERO - gx(SEUL)} height={H} class="pp-barre" class:pp-vu-b={e >= 1} style="transform-origin: {ZERO}px 0" />
      <rect x={gx(SEUL)} y={R1} width={gx(EGAL) - gx(SEUL)} height={H} class="pp-part" class:pp-on={e >= 3} />
      <text x={gx(SEUL) - 12} y={R1 + 28} class="pp-b pp-fin">{s(SEUL)}</text>
    </g>

    <!-- 2 : à vote égal. -->
    <g class="pp-etape" class:pp-vu={e >= 2}>
      <text x={ZERO - 8} y={R2 - 14} class="pp-code pp-fin" class:pp-efface={e >= 3}>lm(satisfaction_dem ~ populisme + vote_liberal)</text>
      <text x="0" y={R2 + 27} class="pp-rang">à vote égal</text>
      <rect x={gx(EGAL)} y={R2} width={ZERO - gx(EGAL)} height={H} class="pp-barre" class:pp-vu-b={e >= 2} style="transform-origin: {ZERO}px 0" />
      <text x={gx(EGAL) - 12} y={R2 + 28} class="pp-b pp-fin">{s(EGAL)}</text>
    </g>

    <!-- 3 : la part du vote, et ce qui reste. -->
    <g class="pp-etape" class:pp-vu={e >= 3}>
      <line x1={gx(EGAL)} y1={R1 - 6} x2={gx(EGAL)} y2={R2 + H + 6} class="pp-guide" />
      <text x={(gx(SEUL) + gx(EGAL)) / 2} y={R1 - 14} class="pp-note pp-rouge-t">{s(DIFF)}{N}: le vote</text>
      <text x={(gx(EGAL) + ZERO) / 2} y={R2 - 14} class="pp-note">ce qui reste</text>
      <text x={(gx(EGAL) + ZERO) / 2} y={R2 + H + 34} class="pp-sous">causal{N}? pas prouvé</text>
    </g>

    <text x="0" y="484" class="pp-source">La CES, les {PARTI.n.toLocaleString('fr-CA')} qui ont répondu aux deux questions et déclaré un vote</text>
  </svg>
</div>

<style>
  .pp { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .pp-leg { font-size: 21px; font-weight: 600; white-space: pre; }
  .pp-rouge-t { fill: var(--dk-accent); }
  .pp-encre-t { fill: var(--dk-encre); }
  .pp-titre { font-size: 22px; font-weight: 600; fill: var(--dk-gris); }
  .pp-lib { fill: var(--dk-accent); }
  .pp-aut { fill: var(--dk-encre); }
  .pp-val { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }

  .pp-zero { stroke: var(--dk-encre); stroke-width: 2; }
  .pp-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .pp-code { font-size: 20px; fill: var(--dk-gris); transition: opacity 0.3s; }
  .pp-code.pp-efface { opacity: 0; }
  .pp-fin { text-anchor: end; }
  .pp-rang { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .pp-barre { fill: var(--dk-encre); transform: scaleX(0); transition: transform 0.8s ease-out; }
  .pp-barre.pp-vu-b { transform: scaleX(1); }
  .pp-part { fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s; }
  .pp-part.pp-on { opacity: 1; }
  .pp-b { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .pp-guide { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 6 6; }
  .pp-note { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .pp-sous { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .pp-source { font-size: 17px; fill: var(--dk-gris); }

  .pp-etape { opacity: 0; transition: opacity 0.3s; }
  .pp-etape.pp-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .pp-barre, .pp-part, .pp-etape, .pp-etape.pp-vu { transition: none; }
  }
</style>
