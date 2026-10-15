<script>
  /**
   * Le tableau, c'est l'équation remplie. À gauche, le tableau d'article
   * (TabPublie). À droite, l'équation de la régression, y = β0 + β1x + ε,
   * et sous chaque symbole la case que R a remplie. Chaque clic allume une
   * partie du tableau et remplit la case qui lui répond.
   *
   *   0  Le tableau et l'équation vide.
   *   1  Une colonne = un modèle = une équation.
   *   2  y : la variable en tête de colonne (l'intérêt pour la politique).
   *   3  x : le nom de la ligne (la scolarité).
   *   4  β1 : le coefficient de la ligne, +0,203.
   *   5  β0 : la constante, 0,540.
   * Les mots sous y et x sont les noms de R (VARS), en français courant.
   *
   * Nombres : NOTRE.coefs dans src/lib/data/seance7.js (outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 3) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const [C0, C1] = NOTRE.coefs;
  const ON = [[], ['col1'], ['y'], [`ligne-${VARS.x.nom}`], [`b-${VARS.x.nom}`], ['b-(Intercept)']];
  const MOTS = ['', 'une colonne, un modèle', 'y : la variable en tête', 'x : le nom de la ligne', 'β1 : le coefficient', 'β0 : la constante'];
</script>

<div class="visuel tab-eq" bind:this={hote}>
  <div class="te-tab"><TabPublie on={ON[e]} /></div>

  <div class="te-droite">
    <div class="te-eq" class:te-cadre={e === 1}>
      <span class="te-s" class:te-on={e === 2}>y</span>
      <span class="te-o">=</span>
      <span class="te-s" class:te-on={e === 5}>β<sub>0</sub></span>
      <span class="te-o">+</span>
      <span class="te-s" class:te-on={e === 4}>β<sub>1</sub></span>
      <span class="te-o te-fois">×</span>
      <span class="te-s" class:te-on={e === 3}>x</span>
      <span class="te-o">+</span>
      <span class="te-s">ε</span>

      <span class="te-r" class:te-vu={e >= 2} class:te-on={e === 2}>intérêt</span>
      <span class="te-o te-r te-vu">=</span>
      <span class="te-r" class:te-vu={e >= 5} class:te-on={e === 5}>{f(C0.b)}</span>
      <span class="te-o te-r" class:te-vu={e >= 4}>{C1.b < 0 ? '−' : '+'}</span>
      <span class="te-r" class:te-vu={e >= 4} class:te-on={e === 4}>{f(Math.abs(C1.b))}</span>
      <span class="te-o te-r te-fois te-vu">×</span>
      <span class="te-r" class:te-vu={e >= 3} class:te-on={e === 3}>scolarité</span>
      <span class="te-o te-r te-vu">+</span>
      <span class="te-o te-r te-vu">ε</span>
    </div>
    <p class="te-mot" class:te-vu={e > 0}>{MOTS[e] || ' '}</p>
  </div>
</div>

<style>
  .tab-eq { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2.4em; align-items: center; }
  .te-tab { font-size: 0.92em; }
  .te-droite { display: flex; flex-direction: column; align-items: center; gap: 1.2em; }

  /* L'équation : neuf colonnes, le symbole en haut, la case remplie en bas. */
  .te-eq { display: grid; grid-template-columns: repeat(9, auto); column-gap: 0.45em; row-gap: 0.5em; align-items: baseline; justify-items: center; font-size: 1.75em; padding: 0.4em 0.6em; border: 2px solid transparent; transition: border-color 0.3s; }
  .te-eq.te-cadre { border-color: var(--dk-accent); }
  .te-s { font-weight: 600; color: var(--dk-encre); transition: color 0.3s; }
  .te-o { color: var(--dk-gris); }
  .te-fois { font-size: 0.8em; }
  sub { font-size: 0.6em; line-height: 0; }
  .te-r { font-size: 0.78em; font-weight: 600; color: var(--dk-encre); border-top: 2px solid var(--dk-encre); padding-top: 0.35em; justify-self: stretch; text-align: center; visibility: hidden; opacity: 0; transform: translateY(-0.3em); transition: opacity 0.35s, transform 0.35s, color 0.3s, visibility 0s 0.35s; }
  .te-o.te-r { font-weight: 400; color: var(--dk-gris); border-top-color: transparent; }
  .te-r.te-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.35s, transform 0.35s, color 0.3s; }
  .te-s.te-on, .te-r.te-on { color: var(--dk-accent); }
  .te-r.te-on { border-top-color: var(--dk-accent); }

  .te-mot { margin: 0; min-height: 1.3em; font-size: 1em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .te-mot.te-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .te-eq, .te-s, .te-r, .te-r.te-vu, .te-mot { transition: none; transform: none; }
  }
</style>
