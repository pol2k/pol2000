<script>
  /**
   * Pourquoi citer : trois tuiles, une par clic. Pas de données.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const RAISONS = [
    { mot: 'Rendre à César', dit: 'l’idée a un auteur, et il a travaillé pour l’avoir' },
    { mot: 'Permettre de vérifier', dit: 'votre lecteur doit pouvoir retrouver la source' },
    { mot: 'Ne pas plagier', dit: 'ce que vous n’avez pas trouvé vous-même vient de quelqu’un' }
  ];
</script>

<div class="visuel m8c" bind:this={hote}>
  <div class="tuiles">
    {#each RAISONS as r, i}
      <div class="tuile" class:vu={e >= i}>
        <span class="n">{i + 1}</span>
        <strong>{r.mot}</strong>
        <span class="dit">{r.dit}</span>
      </div>
    {/each}
  </div>
  <p class="mi" class:vu={e >= 3}>Votre mi-session, le 28 octobre<span class="sep">·</span><strong>la citation des sources compte dans la note</strong></p>
</div>

<style>
  .m8c { max-width: 62em; margin: 1.4em auto 0; display: flex; flex-direction: column; gap: 1.6em; }
  .tuiles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; }
  .tuile { border: 3px solid var(--dk-encre); padding: 1.5em 1.3em; display: flex; flex-direction: column; gap: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .tuile.vu { opacity: 1; transform: none; }
  .tuile:first-child { border-color: var(--dk-accent); }
  .n { font-size: 3em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  strong { font-size: 1.3em; line-height: 1.2; }
  .dit { color: var(--dk-gris); font-size: 0.95em; }
  .mi { margin: 0; padding: 0.7em 1em; background: var(--dk-encre); color: var(--dk-fond); opacity: 0; transition: opacity 0.4s; }
  .mi.vu { opacity: 1; }
  .mi strong { color: var(--dk-accent-clair); font-size: 1em; }
  .sep { color: var(--dk-gris-2); margin: 0 0.6em; }
  @media (prefers-reduced-motion: reduce) { .tuile, .mi { transition: none; transform: none; } }
</style>
