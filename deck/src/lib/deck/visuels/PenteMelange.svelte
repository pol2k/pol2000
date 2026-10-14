<script>
  /**
   * Et si H0 était vraie ? Le nuage de notre sondage (les 783 personnes
   * qui ont répondu aux deux questions, parmi les 1 000 tiré.e.s), sa droite,
   * puis le monde où H0 est vraie, fabriqué avec nos propres données : on
   * mélange la colonne gauche_droite. Chaque personne garde sa note de
   * Carney, mais reçoit la position gauche-droite d'une autre. Le lien
   * disparaît, tout le reste reste. Trois temps.
   *
   *   0  H0 en mots, en haut. Le nuage (NOTRE.points, x étalé de ± 0,3 pour
   *      le dessin seulement) et la droite de R, en rouge (NOTRE.coefs[1],
   *      −5,05).
   *   1  On mélange : les points glissent à l'horizontale vers leur position
   *      mélangée (MELANGE.x); leur hauteur, la note, ne bouge pas. La droite
   *      rouge pâlit.
   *   2  La droite de R sur les données mélangées (MELANGE.b0, MELANGE.b1,
   *      0,21) : presque à plat. C'est le premier des 1 000 mélanges de la
   *      diapo suivante (H0.notre.pentes[0]).
   *
   * Données : NOTRE (src/lib/data/seance7.js, outils/seance7_data.R) et
   * MELANGE (src/lib/data/seance7_f.js, outils/seance7_f.R, qui refait le
   * même mélange, graine 7, et vérifie la pente).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import { MELANGE } from '$lib/data/seance7_f.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const N = ' ';

  // Le nuage : x de 0 à 10, la note de 0 à 100.
  const X0 = 150, X1 = 820, Y0 = 452, Y1 = 132;
  const x = (v) => X0 + ((v + 0.5) / 11) * (X1 - X0);
  const y = (v) => Y0 - (v / 100) * (Y0 - Y1);
  const PTS = NOTRE.points.map((p, i) => ({
    cx: x(p.jx),
    cy: y(p.y),
    // Le glissement : la position mélangée, avec le même petit étalement.
    dx: x(MELANGE.x[i] + (p.jx - p.x)) - x(p.jx),
    // Un léger décalage, pour que les points ne partent pas tous en même temps.
    delai: (i * 37) % 600
  }));
  const B = NOTRE.coefs[1].b, B0 = NOTRE.coefs[0].b;
  const droite = (b0, b1) => ({ x1: x(0), y1: y(b0), x2: x(10), y2: y(b0 + 10 * b1) });
  const NOTRE_D = droite(B0, B);
  const MEL_D = droite(MELANGE.b0, MELANGE.b1);

  const PHRASES = [
    [`H0${N}: β1 = 0`, 'La position gauche-droite ne change rien à la note de Carney.'],
    ['Imaginons que H0 est vraie.', 'On mélange les positions gauche-droite. Les notes ne bougent pas.'],
    ['Le lien a disparu.', `Une droite presque à plat${N}: le hasard seul.`]
  ];
</script>

<div class="visuel pente-melange" bind:this={hote}>
  <svg viewBox="0 0 1000 524" role="img" aria-label="H0{N}: bêta 1 égale 0, la position gauche-droite ne change rien à la note de Carney. Le nuage de notre sondage, {NOTRE.n_modele} personnes, et sa droite{N}: pente de {f(B)}. On mélange les positions gauche-droite{N}: chaque personne garde sa note mais reçoit la position d’une autre. La droite devient presque plate{N}: pente de {f(MELANGE.b1)}.">
    {#key e}
      <g class="pm-phrase">
        <text x="40" y="42" class="pm-titre">{PHRASES[e][0]}</text>
        <text x="40" y="76" class="pm-sous">{PHRASES[e][1]}</text>
      </g>
    {/key}

    <!-- Les axes. -->
    <line x1={X0 - 10} y1={Y0 + 10} x2={X1} y2={Y0 + 10} class="pm-axe" />
    <line x1={X0 - 10} y1={Y1} x2={X0 - 10} y2={Y0 + 10} class="pm-axe" />
    {#each [0, 5, 10] as k}
      <text x={x(k)} y={Y0 + 36} class="pm-tick">{k}</text>
    {/each}
    {#each [0, 50, 100] as k}
      <text x={X0 - 22} y={y(k) + 6} class="pm-tick pm-fin">{k}</text>
    {/each}
    <text x={x(0)} y={Y0 + 58} class="pm-pole">gauche</text>
    <text x={x(10)} y={Y0 + 58} class="pm-pole">droite</text>
    <text x={x(5)} y={Y0 + 58} class="pm-nom">position gauche-droite</text>
    <text x={X0 - 10} y={Y1 - 16} class="pm-nom pm-debut">note de Carney</text>

    <!-- Les 783 personnes. -->
    {#each PTS as p}
      <circle cx={p.cx} cy={p.cy} r="4" class="pm-pt" style="transform: translateX({e >= 1 ? p.dx : 0}px); transition-delay: {e >= 1 ? p.delai : 0}ms" />
    {/each}

    <!-- La droite de notre sondage, puis celle du mélange. -->
    <line {...NOTRE_D} class="pm-droite" class:pm-pale={e >= 1} />
    <g class="pm-lab" class:pm-pale-t={e >= 1}>
      <text x={NOTRE_D.x2 + 12} y={NOTRE_D.y2 - 22} class="pm-pente">pente</text>
      <text x={NOTRE_D.x2 + 12} y={NOTRE_D.y2 + 8}>{f(B)}</text>
    </g>
    <g class="pm-etape" class:pm-vu={e >= 2}>
      <line {...MEL_D} class="pm-droite pm-encre" />
      <g class="pm-lab pm-lab-encre">
        <text x={MEL_D.x2 + 12} y={MEL_D.y2 - 22} class="pm-pente">pente</text>
        <text x={MEL_D.x2 + 12} y={MEL_D.y2 + 8}>{f(MELANGE.b1)}</text>
      </g>
    </g>

    <text x="990" y="20" class="pm-src">CES 2025 · notre sondage · {NOTRE.n_modele} personnes</text>
  </svg>
</div>

<style>
  .pente-melange { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 54vh; display: block; }
  text { font-family: var(--dk-mono); }
  .pm-phrase { animation: pm-fondu 0.5s ease-out both; }
  @keyframes pm-fondu { from { opacity: 0; } to { opacity: 1; } }
  .pm-titre { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .pm-sous { font-size: 22px; fill: var(--dk-gris); }
  .pm-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .pm-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .pm-fin { text-anchor: end; }
  .pm-pole { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .pm-nom { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pm-debut { text-anchor: start; }
  .pm-pt { fill: var(--dk-encre); opacity: 0.2; transition: transform 1.1s cubic-bezier(0.6, 0, 0.3, 1); }
  .pm-droite { stroke: var(--dk-accent); stroke-width: 5; transition: opacity 0.6s; }
  .pm-droite.pm-pale { opacity: 0.25; }
  .pm-droite.pm-encre { stroke: var(--dk-encre); }
  .pm-lab text { font-size: 26px; font-weight: 600; }
  .pm-lab { font-size: 26px; font-weight: 600; fill: var(--dk-accent); transition: opacity 0.6s; }
  .pm-lab.pm-pale-t { opacity: 0.3; }
  .pm-lab-encre { fill: var(--dk-encre); }
  .pm-lab .pm-pente { font-size: 17px; font-weight: 400; }
  .pm-src { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .pm-etape { opacity: 0; transition: opacity 0.2s; }
  .pm-etape.pm-vu { opacity: 1; transition: opacity 0.6s 0.2s; }
  @media (prefers-reduced-motion: reduce) {
    .pm-phrase { animation: none; }
    .pm-pt, .pm-droite, .pm-lab, .pm-etape, .pm-etape.pm-vu { transition: none; }
  }
</style>
