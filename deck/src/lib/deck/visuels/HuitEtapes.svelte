<script>
  /**
   * Le test d'hypothèse en huit étapes (Arel-Bundock 2021, p. 74-75), avec,
   * à droite de chaque étape, sa valeur dans l'exemple de la pomicultrice.
   * Deux étapes par temps.
   *
   *   0  1 Choisir H₀ (100 g) et 2 Choisir un seuil (0,05).
   *   1  3 Tirer un échantillon aléatoire (50 pommes) et 4 Estimer (105 g).
   *   2  5 Calculer l'erreur type (2,45 g) et 6 Calculer t (2,04).
   *   3  7 Calculer p (0,047) et 8 Comparer p au seuil : on rejette H₀.
   *
   * Les valeurs viennent de POMMES (h0, n, moyenne, erreurType, t, p). Le
   * seuil, 0,05, est la convention. Le verdict de l'étape 8 est calculé ici.
   * Chaque rangée est une grille à trois cellules, chacune un seul élément :
   * aucun balisage en ligne ne se répand dans des cellules de trop.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const SEUIL = 0.05; // la convention
  const rejette = POMMES.p < SEUIL;
  const ETAPES = [
    ['Choisir H₀', `${POMMES.h0} g`],
    ['Choisir un seuil', fr(SEUIL, 2)],
    ['Tirer un échantillon aléatoire', `${POMMES.n} pommes`],
    ['Estimer', `${POMMES.moyenne} g`],
    ['Calculer l’erreur type', `${fr(POMMES.erreurType, 2)} g`],
    ['Calculer t', fr(POMMES.t, 2)],
    ['Calculer p', fr(POMMES.p, 3)],
    ['Comparer p au seuil', `${fr(POMMES.p, 3)} ${rejette ? '<' : '≥'} ${fr(SEUIL, 2)} : ${rejette ? 'on rejette H₀' : 'on ne rejette pas H₀'}`]
  ];
</script>

<div class="visuel huit-etapes" bind:this={hote}>
  <div class="he-liste" role="list">
    {#each ETAPES as [quoi, val], i}
      <div class="he-rang" role="listitem" class:he-vu={i < 2 * (e + 1)} class:he-fin={i === ETAPES.length - 1} style="--d: {(i % 2) * 150}ms">
        <span class="he-num">{i + 1}</span>
        <span class="he-quoi">{quoi}</span>
        <span class="he-val">{val}</span>
      </div>
    {/each}
  </div>
  <p class="he-src">exemple fictif · Arel-Bundock (2021, p.&#8239;74-75)</p>
</div>

<style>
  .huit-etapes { display: flex; flex-direction: column; gap: 0.5em; max-width: 46em; margin: 0 auto; }
  .he-liste { display: flex; flex-direction: column; border-top: 2px solid var(--dk-encre); }
  .he-rang { display: grid; grid-template-columns: 2.2em minmax(0, 1fr) auto; align-items: center; gap: 0.9em; padding: 0.32em 0.2em; border-bottom: 1px solid var(--dk-filet); opacity: 0; visibility: hidden; transform: translateX(-0.5em); transition: opacity 0.25s, transform 0.25s, visibility 0s 0.25s; }
  .he-rang.he-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.4s var(--d), transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) var(--d), visibility 0s; }
  .he-num { display: flex; align-items: center; justify-content: center; width: 1.7em; height: 1.7em; border: 2px solid var(--dk-encre); font-weight: 600; font-size: 0.95em; }
  .he-quoi { font-size: 1.05em; }
  .he-val { font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: right; white-space: nowrap; }
  .he-fin .he-num { background: var(--dk-encre); color: var(--dk-fond); }
  .he-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .he-rang, .he-rang.he-vu { transition: none; transform: none; }
  }
</style>
