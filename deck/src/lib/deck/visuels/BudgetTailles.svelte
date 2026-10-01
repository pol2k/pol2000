<script>
  /**
   * « Et si le budget changeait ? » Trois budgets : 100, 1 000 et 4 000
   * personnes par sondage. Pour chacun, 1 000 sondages au hasard, empilés
   * en histogramme sur le même axe. Plus le budget est gros, plus les
   * sondages se serrent autour de la vraie réponse (33,1 %). Aucun écart
   * type à l'écran : la forme suffit.
   *
   * Tout vient de src/lib/data/seance5_budget.js (outils/seance5_budget.R,
   * Étude électorale canadienne 2025, toute l'enquête comme population;
   * parts calculées parmi celles et ceux qui déclarent un vote) :
   * TAILLES.rangees (n et effectifs de chaque rangée), TAILLES.bornes
   * (tranches d'un demi-point, [a, a + 0,005), de 0 à 70 %, assez large pour
   * qu'aucun sondage ne soit ramené dans une tranche du bord), BUDGET.vrai
   * (la ligne pointillée).
   *
   * L'axe se cale sur les données : de la première à la dernière tranche
   * non vide des trois rangées, arrondies aux 5 points (10 à 55 % avec la
   * graine actuelle; les sondages de 100 vont de 14 à 52 %). Chaque rangée
   * est à sa propre échelle : son plus haut bâton touche le plafond de la
   * rangée. C'est la largeur qui compte, pas la hauteur.
   *
   * Avec 100 personnes, environ 69 déclarent un vote : les parts possibles
   * sont des fractions (23 sur 69, 24 sur 70…), d'où une rangée un peu
   * dentelée. C'est le hasard des fractions, pas une erreur.
   *
   *   0  L'axe, la ligne pointillée de la vraie réponse, la rangée de 100.
   *   1  + la rangée de 1 000.
   *   2  + la rangée de 4 000.
   *   3  La phrase : « Plus de monde : des sondages plus serrés autour de
   *      la vraie réponse. »
   *
   * Remplace QuatreTailles (l'âge moyen) dans la séance 5.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, TAILLES } from '$lib/data/seance5_budget.js';
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

  // Les bâtons d'une rangée : [de, à) en proportion, et l'effectif.
  const B = TAILLES.bornes;
  const barres = (t) => t.effectifs.map((c, j) => ({ de: B[j], a: B[j + 1], c })).filter((b) => b.c > 0);
  const TOUTES = TAILLES.rangees.map(barres);

  // L'axe : toutes les tranches non vides, arrondies aux 5 points, à droite des étiquettes.
  const bas5 = (v) => Math.floor(v * 20 + 1e-9) / 20;
  const haut5 = (v) => Math.ceil(v * 20 - 1e-9) / 20;
  const AMIN = bas5(Math.min(...TOUTES.map((bs) => bs[0].de)));
  const AMAX = haut5(Math.max(...TOUTES.map((bs) => bs[bs.length - 1].a)));
  const X0 = 260, X1 = 960;
  const x = (v) => X0 + ((v - AMIN) / (AMAX - AMIN)) * (X1 - X0);
  const TICKS = Array.from({ length: Math.round((AMAX - AMIN) * 20) + 1 }, (_, i) => Math.round(AMIN * 100) + 5 * i);
  const XV = x(BUDGET.vrai);

  // Les rangées : une ligne de base, un plafond, à 130 unités d'écart.
  const BASES = [172, 302, 432], HR = 104;

  const RANGEES = TAILLES.rangees.map((t, r) => {
    const bs = TOUTES[r];
    const max = Math.max(...bs.map((b) => b.c));
    return { r, n: t.n, base: BASES[r], bs: bs.map((b) => ({ ...b, h: (b.c / max) * HR })) };
  });
  const NB = f(TAILLES.rangees[0].effectifs.reduce((s, v) => s + v, 0));
  const R = TAILLES.rangees;
</script>

<div class="visuel budget-tailles" bind:this={hote}>
  <svg viewBox="0 0 1000 552" role="img" aria-label="Trois budgets{N}: {R.map((t) => f(t.n)).join(', ')} personnes par sondage. Pour chacun, {NB} sondages au hasard. Avec {f(R[0].n)} personnes, les résultats s’étalent loin de la vraie réponse, {pc(BUDGET.vrai)}. Avec {f(R[R.length - 1].n)}, ils se serrent autour. Plus de monde{N}: des sondages plus serrés autour de la vraie réponse.">
    <text x="30" y="30" class="bt-chapeau">chaque rangée{N}:</text>
    <text x="30" y="56" class="bt-chapeau">{NB} sondages au hasard</text>

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

    <!-- La vraie réponse, à travers les trois rangées. -->
    <line x1={XV} y1="50" x2={XV} y2={BASES[2]} class="bt-vrai" />
    <text x={XV} y="36" class="bt-vrai-t">la vraie réponse{N}: {pc(BUDGET.vrai)}</text>

    <!-- L'axe, sous la dernière rangée. -->
    {#each TICKS as t}
      <line x1={x(t / 100)} y1={BASES[2]} x2={x(t / 100)} y2={BASES[2] + 8} class="bt-base" />
      <text x={x(t / 100)} y={BASES[2] + 32} class="bt-tick">{t}</text>
    {/each}
    <text x={X1} y={BASES[2] + 58} class="bt-tick bt-fin">part du vote conservateur dans chaque sondage (%)</text>

    <!-- 3 : la leçon. -->
    <text x="500" y="538" class="bt-lecon" class:bt-vu={e >= 3}>Plus de monde{N}: des sondages plus serrés autour de la vraie réponse.</text>
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
