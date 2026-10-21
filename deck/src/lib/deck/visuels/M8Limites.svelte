<script>
  /**
   * Ce que contrôler ne fait pas. Trois tuiles, une par clic, chacune
   * renvoie à la séance où on y revient. Pas de données.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const LIMITES = [
    { mot: 'Seulement ce qu’on a mesuré', dit: 'ce qui n’est pas dans la base reste dans ε', ou: 'séance 13 · les biais' },
    { mot: 'Pas n’importe quelle variable', dit: 'certains contrôles font plus de mal que de bien', ou: 'séance 11 · les GOA' },
    { mot: 'Toujours une association', dit: 'à tout le reste égal, ce n’est pas encore une cause', ou: 'séance 10 · la causalité' }
  ];
</script>

<div class="visuel m8l" bind:this={hote}>
  {#each LIMITES as l, i}
    <div class="tuile" class:vu={e >= i}>
      <strong>{l.mot}</strong>
      <span class="dit">{l.dit}</span>
      <span class="ou">{l.ou}</span>
    </div>
  {/each}
</div>

<style>
  .m8l { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 60em; margin: 1.4em auto 0; }
  .tuile { border: 3px solid var(--dk-encre); padding: 1.5em 1.3em; display: flex; flex-direction: column; gap: 0.7em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .tuile.vu { opacity: 1; transform: none; }
  strong { font-size: 1.3em; line-height: 1.25; }
  .dit { color: var(--dk-gris); font-size: 0.95em; }
  .ou { margin-top: auto; font-size: 0.72em; font-weight: 600; letter-spacing: 0.06em; color: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .tuile { transition: none; transform: none; } }
</style>
