<script>
  /**
   * N = 783 : pourquoi pas 1 000 ? À gauche, le tableau d'article
   * (TabPublie). À droite, les 1 000 personnes de notre sondage, une case
   * chacune, dans l'ordre du tirage. R ne garde que celles qui ont répondu
   * aux deux questions.
   *
   *   0  Les 1 000 tiré.e.s parmi les 20 180, toutes à l'encre.
   *   1  Les 217 qui manquent se marquent : sans position gauche-droite,
   *      sans note de Carney, ni l'une ni l'autre. Les comptes à côté.
   *   2  Elles s'effacent : 1 000 − 217 = 783, le N du tableau.
   *
   * Nombres : MANQUANTS dans src/lib/data/seance7_g.js (outils/seance7_g.R,
   * qui refait notre sondage, graine 62, et vérifie que 783 + 217 = 1 000).
   */
  import { brancherTemps } from '../temps.js';
  import { MANQUANTS as M } from '$lib/data/seance7_g.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const COL = 50, C = 15, G = 3;
  const MANQUE = M.n - M.n_modele;
  const GENRES = [
    { s: 2, n: M.sans_position, mot: 'sans position gauche-droite' },
    { s: 1, n: M.sans_note, mot: 'sans note de Carney' },
    { s: 3, n: M.sans_les_deux, mot: 'ni l’une ni l’autre' }
  ];
  const ON = [[], ['n'], ['n']];
</script>

<div class="visuel tab-n" bind:this={hote}>
  <div class="tn-tab"><TabPublie on={ON[e]} /></div>

  <div class="tn-droite">
    <p class="tn-haut">{f(M.n)} tiré.e.s parmi les 20&#8239;180</p>
    <svg viewBox="0 0 {COL * (C + G)} {Math.ceil(M.n / COL) * (C + G)}" class:tn-e1={e >= 1} class:tn-e2={e >= 2} role="img" aria-label="Les {f(M.n)} personnes de notre sondage. {MANQUE} n’ont pas répondu aux deux questions&#8239;: {M.sans_position} sans position gauche-droite, {M.sans_note} sans note de Carney, {M.sans_les_deux} ni l’une ni l’autre. Il en reste {M.n_modele}, le N du tableau.">
      {#each M.statut as s, i}
        <rect x={(i % COL) * (C + G)} y={Math.floor(i / COL) * (C + G)} width={C} height={C} class="tn-c tn-s{s}" />
      {/each}
    </svg>
    <div class="tn-legende" class:tn-vu={e >= 1}>
      {#each GENRES as g}
        <span class="tn-l"><svg viewBox="0 0 18 18" class="tn-ech"><rect x="1.5" y="1.5" width="15" height="15" class="tn-c tn-s{g.s} tn-force" /></svg><b>{g.n}</b> {g.mot}</span>
      {/each}
    </div>
    <p class="tn-calcul" class:tn-vu={e >= 2}>{f(M.n)} − {MANQUE} = <b>{f(M.n_modele)}</b></p>
  </div>
</div>

<style>
  .tab-n { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tn-tab { font-size: 0.92em; }
  .tn-droite { display: flex; flex-direction: column; gap: 0.5em; }
  .tn-haut { margin: 0; font-size: 0.8em; font-weight: 600; color: var(--dk-encre); }
  svg { width: 100%; height: auto; display: block; }

  /* Les cases : à l'encre, puis les manquantes se marquent (temps 1) et s'effacent (temps 2). */
  .tn-c { fill: var(--dk-encre); stroke: none; transition: fill 0.4s, stroke 0.4s, opacity 0.5s; }
  .tn-e1 .tn-s1, .tn-force.tn-s1 { fill: var(--dk-gris-2); }
  .tn-e1 .tn-s2, .tn-force.tn-s2 { fill: var(--dk-accent); }
  .tn-e1 .tn-s3, .tn-force.tn-s3 { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 2.5; }
  .tn-e2 .tn-s1, .tn-e2 .tn-s2, .tn-e2 .tn-s3 { opacity: 0.12; }

  .tn-legende { display: flex; flex-wrap: wrap; gap: 0.3em 1.3em; font-size: 0.78em; color: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .tn-legende.tn-vu { opacity: 1; }
  .tn-l { display: inline-flex; align-items: center; gap: 0.4em; white-space: nowrap; }
  .tn-ech { width: 0.95em; height: 0.95em; }
  .tn-calcul { margin: 0.2em 0 0; font-size: 1.5em; font-weight: 600; color: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .tn-calcul b { color: var(--dk-accent); }
  .tn-calcul.tn-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .tn-c, .tn-legende, .tn-calcul { transition: none; }
  }
</style>
