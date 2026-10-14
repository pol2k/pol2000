<script>
  /**
   * N = 564 : pourquoi pas 1 000 ? À gauche, le tableau d'article
   * (TabPublie). À droite, les 1 000 personnes de notre sondage, une case
   * chacune, dans l'ordre du tirage. R ne garde que celles qui ont répondu
   * aux deux questions. Ici, c'est presque une personne sur deux qui manque,
   * et la raison principale n'est pas un refus : c'est le plan du sondage.
   *
   *   0  Les 1 000 tiré.e.s parmi les 20 180, toutes à l'encre.
   *   1  Pas de sondage post-électoral (les deux questions viennent de ce
   *      deuxième sondage, après l'élection) : en gris.
   *   2  Sondage fait, mais la question sur le populisme ne leur a pas été
   *      posée (posée à une partie seulement) : en rouge.
   *   3  « Je ne sais pas / Préfère ne pas répondre » à l'une des deux :
   *      contour rouge.
   *   4  Les trois groupes s'effacent : 1 000 − 436 = 564, le N du tableau.
   *
   * Chaque personne est classée selon la première raison qui s'applique.
   * Nombres : MANQUANTS dans src/lib/data/seance7_g.js (outils/seance7_g.R,
   * qui refait notre sondage, graine 62, et vérifie les comptes contre
   * NOTRE.n_modele et NOTRE.manquants de seance7.js).
   */
  import { brancherTemps } from '../temps.js';
  import { MANQUANTS as M } from '$lib/data/seance7_g.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const COL = 50, C = 15, G = 3;
  const MANQUE = M.n - M.n_modele;
  const GENRES = [
    { s: 1, n: M.pas_post, mot: 'pas de sondage après l’élection' },
    { s: 2, n: M.pas_posee, mot: 'question sur le populisme pas posée' },
    { s: 3, n: M.ne_sait_pas, mot: '« je ne sais pas »' }
  ];
  const ON = [[], [], [], [], ['n']];
</script>

<div class="visuel tab-n" bind:this={hote}>
  <div class="tn-tab"><TabPublie on={ON[e]} /></div>

  <div class="tn-droite">
    <p class="tn-haut">{f(M.n)} tiré.e.s parmi les 20&#8239;180</p>
    <svg viewBox="0 0 {COL * (C + G)} {Math.ceil(M.n / COL) * (C + G)}" class="tn-e{Math.min(e, 3)}" class:tn-fin={e >= 4} role="img" aria-label="Les {f(M.n)} personnes de notre sondage. {MANQUE} n’entrent pas dans le modèle&#8239;: {M.pas_post} n’ont pas fait le sondage après l’élection, {M.pas_posee} l’ont fait mais la question sur le populisme ne leur a pas été posée, {M.ne_sait_pas} ont répondu «&#8239;je ne sais pas&#8239;» à l’une des deux questions. Il en reste {M.n_modele}, le N du tableau.">
      {#each M.statut as s, i}
        <rect x={(i % COL) * (C + G)} y={Math.floor(i / COL) * (C + G)} width={C} height={C} class="tn-c tn-s{s}" />
      {/each}
    </svg>
    <div class="tn-legende">
      {#each GENRES as g, k}
        <span class="tn-l" class:tn-vu={e >= k + 1}><svg viewBox="0 0 18 18" class="tn-ech"><rect x="1.5" y="1.5" width="15" height="15" class="tn-c tn-s{g.s} tn-force" /></svg><b>{g.n}</b> {g.mot}</span>
      {/each}
    </div>
    <p class="tn-calcul" class:tn-vu={e >= 4}>{f(M.n)} − {MANQUE} = <b>{f(M.n_modele)}</b></p>
  </div>
</div>

<style>
  .tab-n { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tn-tab { font-size: 0.92em; }
  .tn-droite { display: flex; flex-direction: column; gap: 0.5em; }
  .tn-haut { margin: 0; font-size: 0.8em; font-weight: 600; color: var(--dk-encre); }
  svg { width: 100%; height: auto; display: block; }

  /* Les cases : à l'encre, puis chaque raison se marque à son temps (1 à 3), puis tout s'efface (4). */
  .tn-c { fill: var(--dk-encre); stroke: none; transition: fill 0.4s, stroke 0.4s, opacity 0.5s; }
  .tn-e1 .tn-s1, .tn-e2 .tn-s1, .tn-e3 .tn-s1, .tn-force.tn-s1 { fill: var(--dk-gris-2); }
  .tn-e2 .tn-s2, .tn-e3 .tn-s2, .tn-force.tn-s2 { fill: var(--dk-accent); }
  .tn-e3 .tn-s3, .tn-force.tn-s3 { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 2.5; }
  .tn-fin .tn-s1, .tn-fin .tn-s2, .tn-fin .tn-s3 { opacity: 0.12; }

  .tn-legende { display: flex; flex-direction: column; gap: 0.2em; font-size: 0.8em; color: var(--dk-encre); }
  .tn-l { display: inline-flex; align-items: center; gap: 0.5em; white-space: nowrap; opacity: 0; transition: opacity 0.4s; }
  .tn-l.tn-vu { opacity: 1; }
  .tn-l b { min-width: 2em; text-align: right; }
  .tn-ech { width: 0.95em; height: 0.95em; }
  .tn-calcul { margin: 0.1em 0 0; font-size: 1.4em; font-weight: 600; color: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .tn-calcul b { color: var(--dk-accent); }
  .tn-calcul.tn-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .tn-c, .tn-l, .tn-calcul { transition: none; }
  }
</style>
