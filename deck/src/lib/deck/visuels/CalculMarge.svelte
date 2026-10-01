<script>
  /**
   * « Le calcul, pas à pas » : la marge d'erreur de notre sondage, en cinq
   * rangées, une par clic (temps 0 à 4). Chaque rangée : un numéro, une
   * étiquette, une grande valeur, une ligne grise d'explication.
   * Tout est calculé depuis HASARD et BUDGET (src/lib/data/seance5_budget.js,
   * outils/seance5_budget.R). Le facteur 1,96 est appliqué dans R (HASARD.marge),
   * on dit « environ 2 » à l'écran.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, HASARD } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const N = HASARD.declares;
  const UN = HASARD.part * 100;
  const SUR10 = Math.round(HASARD.part * 10);
  const ET_GENS = Math.sqrt(HASARD.part * (1 - HASARD.part)) * 100;
  const RACINE = Math.sqrt(N);
  const ET = ET_GENS / RACINE;
  const MARGE = HASARD.marge * 100;
  const BAS = UN - MARGE, HAUT = UN + MARGE;
  const VRAI = BUDGET.vrai * 100;
  const DEDANS = VRAI >= BAS && VRAI <= HAUT;
  const Y = [50, 146, 242, 338, 434];
</script>

<div class="visuel calcul-marge" bind:this={hote}>
  <svg viewBox="0 0 1000 480" role="img" aria-label="Le calcul de la marge d’erreur, pas à pas. Notre sondage&#8239;: {f(UN, 1)}&#8239;%. L’écart type des gens&#8239;: {f(ET_GENS)}. Divisé par la racine de {f(N)}&#8239;: {f(ET, 1)} point. Fois environ 2&#8239;: plus ou moins {f(MARGE, 1)} points. La fourchette&#8239;: de {f(BAS, 1)} à {f(HAUT, 1)}&#8239;%. La vraie réponse, {f(VRAI, 1)}&#8239;%, est {DEDANS ? 'dedans' : 'dehors'}.">
    {#snippet rang(i, etiq)}
      <rect x="20" y={Y[i] - 34} width="44" height="44" class="cm-badge" class:cm-badge-r={i >= 3} />
      <text x="42" y={Y[i] - 3} class="cm-num">{i + 1}</text>
      <text x="85" y={Y[i]} class="cm-etiq">{etiq}</text>
    {/snippet}

    <g class="cm-etape" class:cm-vu={e >= 0}>
      {@render rang(0, 'Notre sondage')}
      <text x="480" y={Y[0]} class="cm-val">{f(UN, 1)}&#8239;%</text>
      <text x="85" y={Y[0] + 32} class="cm-gris">{f(N)} votes déclarés, {SUR10} sur 10 conservateurs</text>
    </g>
    <g class="cm-etape" class:cm-vu={e >= 1}>
      {@render rang(1, 'Combien les gens varient')}
      <text x="480" y={Y[1]} class="cm-val">{f(ET_GENS)}</text>
      <text x="85" y={Y[1] + 32} class="cm-gris">l’écart type des gens&#8239;: très partagés (0 = tout le monde pareil, 50 = moitié-moitié)</text>
    </g>
    <g class="cm-etape" class:cm-vu={e >= 2}>
      {@render rang(2, 'Combien les sondages varient')}
      <text x="480" y={Y[2]} class="cm-val">{f(ET_GENS)} ÷ √{f(N)} ≈ {f(ET, 1)} point</text>
      <text x="85" y={Y[2] + 32} class="cm-gris">l’erreur type (√{f(N)} ≈ {f(RACINE)})&#8239;: les hasards s’annulent en partie</text>
    </g>
    <g class="cm-etape" class:cm-vu={e >= 3}>
      {@render rang(3, 'La marge d’erreur')}
      <text x="480" y={Y[3]} class="cm-val">2 × {f(ET, 1)} ≈ <tspan class="cm-rouge">±&#8239;{f(MARGE, 1)} points</tspan></text>
      <text x="85" y={Y[3] + 32} class="cm-gris">fois environ 2&#8239;: 19 sondages sur 20 tombent dans cet écart</text>
    </g>
    <g class="cm-etape" class:cm-vu={e >= 4}>
      {@render rang(4, 'La fourchette')}
      <text x="480" y={Y[4]} class="cm-val cm-rouge">de {f(BAS, 1)} à {f(HAUT, 1)}&#8239;%</text>
      <text x="85" y={Y[4] + 32} class="cm-gris">la vraie réponse, {f(VRAI, 1)}&#8239;%, est {DEDANS ? 'dedans' : 'dehors'} <tspan class="cm-rouge cm-gras">{DEDANS ? '✓' : '✗'}</tspan></text>
    </g>
  </svg>
</div>

<style>
  .calcul-marge { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .cm-badge { fill: var(--dk-encre); }
  .cm-badge-r { fill: var(--dk-accent); }
  .cm-num { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .cm-etiq { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .cm-val { font-size: 34px; font-weight: 600; fill: var(--dk-encre); }
  .cm-gris { font-size: 17px; fill: var(--dk-gris); }
  .cm-rouge { fill: var(--dk-accent); }
  .cm-gras { font-weight: 600; }
  .cm-etape { opacity: 0; transition: opacity 0.5s; }
  .cm-etape.cm-vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) {
    .cm-etape { transition: none; }
  }
</style>
