<script>
  /**
   * La semaine prochaine : plusieurs variables. Le même tableau d'article
   * (TabPublie, deux colonnes), un coup d'œil seulement, sans rien
   * expliquer : la séance 8 s'en charge.
   *
   *   0  Le modèle 1, comme sur les diapos d'avant (la colonne du modèle 2
   *      garde sa largeur, invisible, ses lignes sont repliées).
   *   1  Le modèle 2 apparaît : une colonne de plus, quatre lignes de plus.
   *   2  La scolarité d'une colonne à l'autre : +0,20, puis +0,19. À peine
   *      bougé (et sur 981 puis 877 personnes, pas tout à fait les mêmes).
   *   3  L'âge : +0,35, la troisième variable de la section TIERS, maintenant
   *      dans le modèle (« à âge égal »).
   *   4  Québec : pas d'étoile.
   *
   * Nombres : NOTRE et MULTIPLE dans src/lib/data/seance7.js. Le modèle 2 a
   * son propre N et son propre R² : chaque colonne a son pied.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, MULTIPLE, VARS } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−');
  const X = VARS.x.nom;
  const b1 = NOTRE.coefs.find((c) => c.terme === X).b;
  const b2 = MULTIPLE.coefs.find((c) => c.terme === X).b;
  const age = MULTIPLE.coefs.find((c) => c.terme === 'age').b;
  const sg = (v) => (v > 0 ? '+' : '') + f(v);
  const ON = [[], ['col2'], [`b-${X}`], ['ligne-age'], ['ligne-quebec']];
  const DIT = [
    '',
    'une colonne de plus, des lignes de plus',
    `${VARS.x.court.toLowerCase()} : ${sg(b1)}, puis ${sg(b2)}`,
    `âge : ${sg(age)}`,
    'Québec : pas d’étoile'
  ];
</script>

<div class="visuel tab-suite" bind:this={hote}>
  <div class="ts-tab"><TabPublie on={ON[e]} deux vu2={e >= 1} /></div>
  <p class="ts-dit" class:ts-vu={e > 0}>{DIT[e] || ' '}</p>
</div>

<style>
  .tab-suite { display: flex; flex-direction: column; align-items: center; gap: 0.6em; }
  .ts-tab { font-size: 0.74em; }
  .ts-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .ts-dit.ts-vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .ts-dit { transition: none; } }
</style>
