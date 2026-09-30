<script>
  /**
   * Plus l'échantillon est grand, plus les moyennes se resserrent. Quatre
   * rangées d'histogrammes, une par taille d'échantillon (10, 50, 200 et
   * 1 000 personnes), chacune faite des moyennes d'âge de mille échantillons
   * tirés parmi les répondant.e.s de l'Étude électorale canadienne 2025.
   *
   * Tout vient de DISTRIBUTIONS (src/lib/data/seance5.js, outils/seance5_data.R) :
   * effectifs par tranche d'un an [a, a + 1) sur BORNES, et l'écart type des
   * moyennes (ecartTypeDesMoyennes). Les rangées partagent un seul axe (30 à
   * 70 ans, toutes les moyennes y tiennent) et chacune est mise à l'échelle
   * de son propre plus haut bâton : elles ont la même hauteur, seule la
   * LARGEUR change. La ligne pointillée est l'âge moyen des 20 180 (POP.moyenne).
   *
   *   0  n = 10.
   *   1  + n = 50.
   *   2  + n = 200.
   *   3  + n = 1 000, et la règle, en mots : plus de monde, des moyennes
   *      plus serrées. Aucun chiffre d'écart à l'écran (séance 5 remaniée :
   *      R fait les calculs, la diapo montre la forme).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, BORNES, DISTRIBUTIONS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');

  // L'axe commun : toutes les tranches de BORNES (30 à 70 ans).
  const AMIN = BORNES[0], AMAX = BORNES[BORNES.length - 1];
  const X0 = 170, X1 = 940;
  const x = (v) => X0 + ((v - AMIN) / (AMAX - AMIN)) * (X1 - X0);
  const LARGE = x(AMIN + 1) - x(AMIN);

  // Quatre rangées de même hauteur.
  const HAUT = 68, PAS = 92, Y0 = 20;
  const RANGEES = DISTRIBUTIONS.map((d, i) => {
    const max = Math.max(...d.effectifs);
    const base = Y0 + HAUT + i * PAS;
    return {
      n: d.n,
      base,
      batons: d.effectifs.map((c, j) => ({ a: BORNES[j], h: (c / max) * HAUT })).filter((b) => b.h > 0)
    };
  });
  const AXE = RANGEES[RANGEES.length - 1].base;
  const XP = x(POP.moyenne);

</script>

<div class="visuel quatre-tailles" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="Les moyennes d’âge de mille échantillons, pour quatre tailles d’échantillon. Avec 10, 50, 200 puis 1 000 personnes, les moyennes se resserrent autour de la vraie moyenne.">
    <!-- La vraie moyenne, à travers les quatre rangées. -->
    <line x1={XP} y1={Y0 - 6} x2={XP} y2={AXE} class="qt-pop" />

    {#each RANGEES as r, i}
      <g class="qt-rangee" class:qt-vu={e >= i}>
        <text x={X0 - 24} y={r.base - HAUT / 2 + 9} class="qt-n">n = {f(r.n)}</text>
        {#each r.batons as b}
          <rect x={x(b.a) + 1} y={r.base - b.h} width={LARGE - 2} height={b.h} class="qt-baton" />
        {/each}
        <line x1={X0} y1={r.base} x2={X1} y2={r.base} class="qt-sol" />
      </g>
    {/each}

    <!-- L'axe commun. -->
    {#each [30, 40, 50, 60, 70] as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 7} class="qt-tick-l" />
      <text x={x(t)} y={AXE + 28} class="qt-tick">{t}</text>
    {/each}
    <text x={(X0 + X1) / 2} y={AXE + 54} class="qt-tick">âge moyen de l’échantillon (ans)</text>

    <!-- Temps 3 : la règle. -->
    <g class="qt-regle" class:qt-vu={e >= 3}>
      <text x="500" y="460" class="qt-regle-t">plus de monde, des moyennes plus serrées autour de la vérité</text>
    </g>
  </svg>
</div>

<style>
  .quatre-tailles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }

  .qt-pop { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 9 7; }
  .qt-n { font-size: 24px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .qt-baton { fill: var(--dk-encre); }
  .qt-sol { stroke: var(--dk-encre); stroke-width: 2.5; }
  .qt-tick-l { stroke: var(--dk-encre); stroke-width: 2.5; }
  .qt-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .qt-regle-t { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .qt-rangee, .qt-regle { opacity: 0; transition: opacity 0.3s; }
  .qt-rangee.qt-vu, .qt-regle.qt-vu { opacity: 1; transition: opacity 0.6s; }

  @media (prefers-reduced-motion: reduce) {
    .qt-rangee, .qt-regle, .qt-rangee.qt-vu, .qt-regle.qt-vu { transition: none; }
  }
</style>
