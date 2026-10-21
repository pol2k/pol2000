<script>
  /**
   * Pourquoi ajouter des variables : deux des avantages d'Adrien Cloutier
   * (H24, cours 9) et d'Arel-Bundock (2021, p. 90). Le troisième (prédire
   * par profil) lit les contrôles : on le laisse de côté. Deux tuiles, une
   * par clic. Pas de données.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const RAISONS = [
    { mot: 'Moins de biais', dit: 'on sort une variable de ε' },
    { mot: 'Plus de précision', dit: 'des erreurs de prédiction plus petites' }
  ];
</script>

<div class="visuel m8r" bind:this={hote}>
  {#each RAISONS as r, i}
    <div class="tuile" class:vu={e >= i}>
      <span class="n">{i + 1}</span>
      <strong>{r.mot}</strong>
      <span class="dit">{r.dit}</span>
    </div>
  {/each}
</div>

<style>
  .m8r { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.4em; max-width: 44em; margin: 1.4em auto 0; }
  .tuile { border: 3px solid var(--dk-encre); padding: 1.6em 1.3em; display: flex; flex-direction: column; gap: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .tuile.vu { opacity: 1; transform: none; }
  .tuile:first-child { border-color: var(--dk-accent); }
  .n { font-size: 3em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  strong { font-size: 1.35em; line-height: 1.2; }
  .dit { color: var(--dk-gris); font-size: 0.95em; }
  @media (prefers-reduced-motion: reduce) { .tuile { transition: none; transform: none; } }
</style>
