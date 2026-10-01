<script>
  /**
   * « Et si le budget changeait ? » Trois budgets : 100, 1 000 et 4 000
   * personnes par sondage. Pour chacun, 1 000 sondages au hasard, empilés
   * en histogramme sur le même axe. Plus le budget est gros, plus les
   * sondages se serrent autour du vrai vote conservateur. Aucun écart type
   * à l'écran : la forme suffit.
   *
   * Tout vient de src/lib/data/seance5_budget.js (outils/seance5_budget.R,
   * Étude électorale canadienne 2025, toute l'enquête comme population;
   * parts calculées parmi celles et ceux qui déclarent un vote) :
   * TAILLES (n et effectifs de chaque rangée), MILLE.bornes (tranches d'un
   * demi-point, [a, a + 0,005), les mêmes pour TAILLES), BUDGET.vrai (la
   * ligne pointillée).
   *
   * Chaque rangée est à sa propre échelle : son plus haut bâton touche le
   * plafond de la rangée. C'est la largeur qui compte, pas la hauteur.
   *
   * Avec 100 personnes, un sondage ne peut donner qu'un pourcentage entier
   * (k sur 100). Dans R, une partie de ces valeurs tombe dans la tranche
   * d'un demi-point juste en dessous (arrondi machine : 0,29 lu comme
   * 0,2899…), d'où un peigne de bâtons vides. Pour cette rangée, chaque
   * tranche est donc rendue au pourcentage entier qu'elle contient
   * (a arrondi vers le haut au 1/n près), et les bâtons sont larges d'un
   * point, centrés sur ce pourcentage. Les effectifs ne changent pas.
   *
   *   0  L'axe, la ligne pointillée du vrai vote, la rangée de 100.
   *   1  + la rangée de 1 000.
   *   2  + la rangée de 4 000.
   *   3  La phrase : « Plus de monde : des sondages plus serrés autour de
   *      la vérité. »
   *
   * Remplace QuatreTailles (l'âge moyen) dans la séance 5.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, MILLE, TAILLES } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const pc = (p) => `${f(p * 100, 1)} %`;
  const N = ' ';

  // L'axe : de 15 à 46 %, à droite de la colonne des étiquettes.
  const AMIN = 0.15, AMAX = 0.46, X0 = 260, X1 = 960;
  const x = (v) => X0 + ((v - AMIN) / (AMAX - AMIN)) * (X1 - X0);
  const B = MILLE.bornes;
  const PAS = B[1] - B[0];
  const TICKS = [15, 20, 25, 30, 35, 40, 45];
  const XV = x(BUDGET.vrai);

  // Les rangées : une ligne de base, un plafond, à 130 unités d'écart.
  const BASES = [172, 302, 432], HR = 104, HAUT = 52;

  // Les bâtons d'une rangée : [de, à) en proportion, et l'effectif.
  const barres = (t) => {
    if (1 / t.n <= PAS) {
      return t.effectifs.map((c, j) => ({ de: B[j], a: B[j + 1], c })).filter((b) => b.c > 0);
    }
    // Pourcentages entiers : on regroupe par valeur possible (k sur n).
    const par = new Map();
    t.effectifs.forEach((c, j) => {
      if (!c) return;
      const k = Math.ceil(B[j] * t.n - 1e-6);
      par.set(k, (par.get(k) ?? 0) + c);
    });
    return [...par].map(([k, c]) => ({ de: (k - 0.5) / t.n, a: (k + 0.5) / t.n, c }));
  };
  const RANGEES = TAILLES.map((t, r) => {
    const bs = barres(t).filter((b) => b.de >= AMIN && b.a <= AMAX);
    const max = Math.max(...bs.map((b) => b.c));
    return { r, n: t.n, base: BASES[r], bs: bs.map((b) => ({ ...b, h: (b.c / max) * HR })) };
  });
  const NB = f(TAILLES[0].effectifs.reduce((s, v) => s + v, 0));
</script>

<div class="visuel budget-tailles" bind:this={hote}>
  <svg viewBox="0 0 1000 552" role="img" aria-label="Trois budgets : {TAILLES.map((t) => f(t.n)).join(', ')} personnes par sondage. Pour chacun, {NB} sondages au hasard. Avec {f(TAILLES[0].n)} personnes, les résultats s’étalent loin du vrai vote conservateur, {pc(BUDGET.vrai)}. Avec {f(TAILLES[TAILLES.length - 1].n)}, ils se serrent autour. Plus de monde : des sondages plus serrés autour de la vérité.">
    <text x="30" y="36" class="bt-chapeau">chaque rangée{N}: {NB} sondages au hasard</text>

    {#each RANGEES as g}
      <g class="bt-rangee" class:bt-vu={e >= g.r}>
        <text x="30" y={g.base - 40} class="bt-n">{f(g.n)} personnes</text>
        <text x="30" y={g.base - 14} class="bt-sous">par sondage</text>
        {#each g.bs as b}
          <rect x={x(b.de) + 1.5} y={g.base - HR} width={x(b.a) - x(b.de) - 3} height={HR} class="bt-baton"
                style="transform: scaleY({e >= g.r ? b.h / HR : 0})" />
        {/each}
        <line x1={X0} y1={g.base} x2={X1} y2={g.base} class="bt-base" />
      </g>
    {/each}

    <!-- Le vrai vote, à travers les trois rangées. -->
    <line x1={XV} y1="50" x2={XV} y2={BASES[2]} class="bt-vrai" />
    <text x={XV} y="36" class="bt-vrai-t">le vrai vote{N}: {pc(BUDGET.vrai)}</text>

    <!-- L'axe, sous la dernière rangée. -->
    {#each TICKS as t}
      <line x1={x(t / 100)} y1={BASES[2]} x2={x(t / 100)} y2={BASES[2] + 8} class="bt-base" />
      <text x={x(t / 100)} y={BASES[2] + 32} class="bt-tick">{t}</text>
    {/each}
    <text x={X1} y={BASES[2] + 58} class="bt-tick bt-fin">part du vote conservateur dans chaque sondage (%)</text>

    <!-- 3 : la leçon. -->
    <text x="500" y="538" class="bt-lecon" class:bt-vu={e >= 3}>Plus de monde{N}: des sondages plus serrés autour de la vérité.</text>
  </svg>
</div>

<style>
  .budget-tailles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .bt-chapeau { font-size: 20px; fill: var(--dk-gris); }
  .bt-n { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .bt-sous { font-size: 18px; fill: var(--dk-gris); }

  .bt-rangee text { opacity: 0; transition: opacity 0.2s; }
  .bt-rangee.bt-vu text { opacity: 1; transition: opacity 0.4s; }
  .bt-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.7s cubic-bezier(0.34, 1.2, 0.64, 1); }
  .bt-base { stroke: var(--dk-encre); stroke-width: 2; }
  .bt-rangee .bt-base { opacity: 0; transition: opacity 0.2s; }
  .bt-rangee.bt-vu .bt-base { opacity: 1; }

  .bt-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .bt-vrai-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .bt-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .bt-fin { text-anchor: end; }

  .bt-lecon { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .bt-lecon.bt-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .bt-rangee text, .bt-rangee.bt-vu text, .bt-baton, .bt-rangee .bt-base, .bt-lecon, .bt-lecon.bt-vu { transition: none; }
  }
</style>
