<script>
  /**
   * Les sondages faciles, puis notre sondage au hasard, sur de vraies
   * données. On fait comme si les 20 180 répondant.e.s de l'Étude électorale
   * canadienne 2025 étaient toute la population (BUDGET.population) : on
   * connaît donc la vraie réponse (BUDGET.vrai, 33,1 %, la part conservatrice
   * parmi celles et ceux qui déclarent un vote). Le budget : BUDGET.n
   * personnes. Chaque rangée est un sondage de cette taille.
   * Source : src/lib/data/seance5_budget.js, généré par outils/seance5_budget.R
   * (FACILES, HASARD, graines documentées dans le script).
   *
   *   0  La règle de la part conservatrice (10 à 60 %) et la vraie réponse,
   *      une ligne pointillée.
   *   1  Le Québec : un point rouge, et une accolade rouge mince jusqu'à la
   *      vraie réponse, avec l'écart (« 12,6 points de trop peu »).
   *   2  L'Alberta, trop haut.
   *   3  Le campus : les diplômé.e.s universitaires.
   *   4  Les 65 ans et plus.
   *   5  Notre sondage au hasard (HASARD, 30,5 %) : le même budget, parmi
   *      tout le monde, en encre. Le point tombe juste à côté de la ligne
   *      pointillée. C'est ce même sondage qui revient à « La marge
   *      d'erreur » (MargeErreur) et dans le journal de « 19 fois sur 20 »
   *      (DixNeufSurVingt, SONDAGES.sondages[0]).
   *
   * Les écarts sont calculés sur les valeurs déjà arrondies à une décimale :
   * l'arithmétique affichée tombe toujours juste. Aucun nombre tapé à la main.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, FACILES, HASARD } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, '\u202f');
  // En points de pourcentage, arrondi à une décimale.
  const r1 = (p) => Math.round(p * 1000) / 10;
  const pc = (p) => f(r1(p), 1);

  // La règle : 10 à 60 %, à droite. Les étiquettes, à gauche.
  const P0 = 10, P1 = 60, X0 = 440, X1 = 950;
  const x = (p) => X0 + ((r1(p) - P0) / (P1 - P0)) * (X1 - X0);
  const XV = x(BUDGET.vrai);
  const ticks = [10, 20, 30, 40, 50, 60];

  const Y_VRAI = 92, AXE = 530;
  const YF = [160, 232, 304, 376];
  const YH = 474;

  // « nos voisins : le Québec » → ['nos voisins', 'le Québec'].
  const couper = (nom) => nom.replace(/'/g, '’').split(/\s*:\s*/);

  function ecart(p) {
    const g = Math.round(Math.abs(r1(BUDGET.vrai) - r1(p)) * 10) / 10;
    return `${f(g, 1)} ${g < 2 ? 'point' : 'points'}`;
  }

  const ROWS = FACILES.map((d, i) => {
    const parts = couper(d.nom);
    const xp = x(d.part);
    const bas = xp < XV;
    return {
      cle: d.cle,
      quoi: parts.length > 1 ? parts[0] : '',
      qui: parts[parts.length - 1],
      y: YF[i],
      xp,
      bas,
      val: `${pc(d.part)}\u202f%`,
      gap: `${ecart(d.part)} ${bas ? 'de trop peu' : 'de trop'}`
    };
  });
  const XH = x(HASARD.part);

  const N = f(BUDGET.n);
  const aria =
    `On fait comme si ${f(BUDGET.population)} répondant.e.s étaient toute la population. ` +
    `La vraie réponse : ${pc(BUDGET.vrai)} %. Un budget de ${N} personnes. ` +
    ROWS.map((r) => `${r.quoi ? r.quoi + ', ' : ''}${r.qui} : ${r.val}, ${r.gap}.`).join(' ') +
    ` ${N} au hasard, parmi tout le monde : ${pc(HASARD.part)} %, à ${ecart(HASARD.part)} près. ` +
    '';
  // Espace fine insécable devant : et %, comme dans le texte visible.
  const ARIA = aria.replace(/ ([:%?!])/g, '\u202f$1');
</script>

<div class="visuel faciles" bind:this={hote}>
  <svg viewBox="0 0 1000 625" role="img" aria-label={ARIA}>

    <!-- 0 : le cadre de l'exercice. -->
    <text x="20" y="28" class="ef-cadre">la population&#8239;: {f(BUDGET.population)} personnes</text>
    <text x="20" y="54" class="ef-cadre">le budget&#8239;: {N} personnes</text>

    <!-- 0 : la vraie réponse. La ligne s'arrête sur la règle. -->
    <text x={XV} y={Y_VRAI} class="ef-vrai-t">la vraie réponse&#8239;: {pc(BUDGET.vrai)}&#8239;%</text>
    <line x1={XV} y1={Y_VRAI + 14} x2={XV} y2={AXE} class="ef-vrai" />

    <!-- 1 à 4 : les sondages faciles. Accolade, puis point, puis texte. -->
    {#each ROWS as r, i}
      <g class="ef-etape" class:ef-vu={e >= i + 1}>
        <line x1={r.xp} y1={r.y} x2={XV} y2={r.y} pathLength="1" class="ef-accolade" class:ef-trace={e >= i + 1} />
        <line x1={XV} y1={r.y - 10} x2={XV} y2={r.y + 10} class="ef-bout" class:ef-trace={e >= i + 1} />
        <circle cx={r.xp} cy={r.y} r="13" class="ef-point" />
        {#if r.quoi}
          <text x="20" y={r.y - 8} class="ef-quoi">{r.quoi}</text>
          <text x="20" y={r.y + 18} class="ef-qui">{r.qui}</text>
        {:else}
          <text x="20" y={r.y + 7} class="ef-qui">{r.qui}</text>
        {/if}
        <text x={r.bas ? r.xp - 20 : r.xp + 20} y={r.y + 7} class="ef-val" class:ef-fin={r.bas}>{r.val}</text>
        <text x={r.bas ? XV - 12 : XV + 12} y={r.y - 22} class="ef-gap" class:ef-fin={r.bas}>{r.gap}</text>
      </g>
    {/each}

    <!-- 5 : au hasard, parmi tout le monde. Le point tombe sur la ligne. -->
    <g class="ef-etape" class:ef-vu={e >= 5}>
      <circle cx={XH} cy={YH} r="15" class="ef-point-h" />
      <text x="20" y={YH - 8} class="ef-qui ef-fort">{N} au hasard,</text>
      <text x="20" y={YH + 18} class="ef-qui ef-fort">parmi tout le monde</text>
      <text x={Math.max(XH, XV) + 24} y={YH + 7} class="ef-val ef-val-h">{pc(HASARD.part)}&#8239;%</text>
      <text x={Math.max(XH, XV) + 24} y={YH - 24} class="ef-gap ef-gap-h">à {ecart(HASARD.part)} près</text>
    </g>

    <!-- La règle. -->
    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="ef-axe" />
    {#each ticks as t}
      <line x1={X0 + ((t - P0) / (P1 - P0)) * (X1 - X0)} y1={AXE} x2={X0 + ((t - P0) / (P1 - P0)) * (X1 - X0)} y2={AXE + 8} class="ef-axe" />
      <text x={X0 + ((t - P0) / (P1 - P0)) * (X1 - X0)} y={AXE + 30} class="ef-tick">{t}&#8239;%</text>
    {/each}
    <text x="20" y={AXE + 30} class="ef-tick ef-tick-t">vote conservateur</text>

    <!-- 6 : la phrase, sous la règle. -->
  </svg>
</div>

<style>
  .faciles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .ef-cadre { font-size: 19px; fill: var(--dk-gris); }
  .ef-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; }
  .ef-vrai-t { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .ef-accolade { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.2s; }
  .ef-accolade.ef-trace { stroke-dashoffset: 0; transition: stroke-dashoffset 0.6s 0.35s ease-out; }
  .ef-bout { stroke: var(--dk-accent); stroke-width: 3; opacity: 0; transition: opacity 0.2s; }
  .ef-bout.ef-trace { opacity: 1; transition: opacity 0.2s 0.85s; }
  .ef-point { fill: var(--dk-accent); }
  .ef-point-h { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; }

  .ef-quoi { font-size: 19px; fill: var(--dk-gris); }
  .ef-qui { font-size: 21px; fill: var(--dk-encre); }
  .ef-fort { font-weight: 600; }
  .ef-val { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .ef-val-h { fill: var(--dk-encre); }
  .ef-gap { font-size: 18px; fill: var(--dk-accent); }
  .ef-gap-h { fill: var(--dk-encre); }
  .ef-fin { text-anchor: end; }

  .ef-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ef-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ef-tick-t { text-anchor: start; }

  .ef-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ef-rouge { fill: var(--dk-accent); }

  .ef-etape { opacity: 0; transition: opacity 0.3s; }
  .ef-etape.ef-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .ef-etape, .ef-etape.ef-vu, .ef-accolade, .ef-accolade.ef-trace, .ef-bout, .ef-bout.ef-trace { transition: none; }
  }
</style>
