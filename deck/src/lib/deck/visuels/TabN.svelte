<script>
  /**
   * N = 981 : pourquoi pas 1 000 ? À gauche, le tableau d'article
   * (TabPublie). À droite, les 1 000 personnes de notre sondage, une case
   * chacune, dans l'ordre du tirage. R ne garde que celles qui ont répondu
   * aux deux questions, sans le dire dans le tableau. Ici, il en manque
   * très peu : la leçon est le réflexe (toujours vérifier N), pas l'alarme.
   *
   *   0  Les 1 000 tiré.e.s parmi les 20 180, toutes à l'encre.
   *   1  Celles qui manquent se marquent en rouge, avec la raison lue dans
   *      les codes bruts du codebook (ici : la case « je ne sais pas /
   *      préfère ne pas répondre » du curseur sur l'intérêt, code -99).
   *   2  Elles s'effacent : 1 000 − 19 = 981, le N du tableau. Le réflexe.
   *
   * Nombres : MANQUANTS dans src/lib/data/seance7_g.js (outils/seance7_g.R,
   * qui refait notre sondage, graine 62, et vérifie les comptes contre
   * NOTRE.n_modele, NOTRE.manquants et la ligne « observations deleted » de
   * summary()). Les groupes vides ne s'affichent pas.
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
    { n: M.interet_nsp, mot: '« je ne sais pas / préfère ne pas répondre » à l’intérêt' },
    { n: M.interet_autre, mot: 'intérêt manquant, autre raison' },
    { n: M.scolarite, mot: 'scolarité manquante' }
  ].filter((g) => g.n > 0);
  const ON = [[], [], ['n']];
</script>

<div class="visuel tab-n" bind:this={hote}>
  <div class="tn-tab"><TabPublie on={ON[e]} /></div>

  <div class="tn-droite">
    <p class="tn-haut">{f(M.n)} tiré.e.s parmi les 20&#8239;180</p>
    <svg viewBox="0 0 {COL * (C + G)} {Math.ceil(M.n / COL) * (C + G)}" class:tn-e1={e >= 1} class:tn-fin={e >= 2} role="img" aria-label="Les {f(M.n)} personnes de notre sondage. {MANQUE} n’entrent pas dans le modèle&#8239;: {GENRES.map((g) => `${g.n}, ${g.mot}`).join('. ')}. Il en reste {f(M.n_modele)}, le N du tableau.">
      {#each M.statut as s, i}
        <rect x={(i % COL) * (C + G)} y={Math.floor(i / COL) * (C + G)} width={C} height={C} class="tn-c" class:tn-manque={s > 0} />
      {/each}
    </svg>
    <div class="tn-legende" class:tn-vu={e >= 1}>
      {#each GENRES as g}
        <span class="tn-l"><svg viewBox="0 0 18 18" class="tn-ech"><rect x="1.5" y="1.5" width="15" height="15" class="tn-c tn-force" /></svg><b>{g.n}</b> {g.mot}</span>
      {/each}
    </div>
    <p class="tn-calcul" class:tn-vu={e >= 2}>{f(M.n)} − {MANQUE} = <b>{f(M.n_modele)}</b></p>
    <p class="tn-reflexe" class:tn-vu={e >= 2}>toujours vérifier N</p>
  </div>
</div>

<style>
  .tab-n { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tn-tab { font-size: 0.92em; }
  .tn-droite { display: flex; flex-direction: column; gap: 0.5em; }
  .tn-haut { margin: 0; font-size: 0.8em; font-weight: 600; color: var(--dk-encre); }
  svg { width: 100%; height: auto; display: block; }

  /* Les cases : à l'encre, les manquantes passent au rouge (temps 1) puis s'effacent (temps 2). */
  .tn-c { fill: var(--dk-encre); transition: fill 0.4s, opacity 0.5s; }
  .tn-e1 .tn-manque, .tn-force { fill: var(--dk-accent); }
  .tn-fin .tn-manque { opacity: 0.12; }

  .tn-legende { display: flex; flex-direction: column; gap: 0.2em; font-size: 0.8em; color: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .tn-legende.tn-vu { opacity: 1; }
  .tn-l { display: inline-flex; align-items: center; gap: 0.5em; }
  .tn-ech { width: 0.95em; height: 0.95em; flex: 0 0 auto; }
  .tn-calcul { margin: 0.1em 0 0; font-size: 1.4em; font-weight: 600; color: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .tn-calcul b { color: var(--dk-accent); }
  .tn-reflexe { margin: 0; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.3s; }
  .tn-calcul.tn-vu, .tn-reflexe.tn-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .tn-c, .tn-legende, .tn-calcul, .tn-reflexe { transition: none; }
  }
</style>
