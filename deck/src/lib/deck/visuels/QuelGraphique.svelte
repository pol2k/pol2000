<script>
  /**
   * Quel graphique pour quelles variables ? Cinq tuiles, un pictogramme
   * schématique et la fonction qui le dessine.
   *
   *   0  Une catégorielle : des barres, geom_bar().
   *   1  Une numérique : un histogramme, geom_histogram().
   *   2  Catégorielle × numérique : des boîtes côte à côte, geom_boxplot().
   *   3  Deux catégorielles : un tableau croisé, table().
   *   4  Deux numériques : un nuage de points, geom_point().
   *
   * Chaque clic trace la tuile suivante : ses traits se dessinent, puis la
   * fonction monte. Les pictogrammes ne représentent aucune donnée.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 4,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  // Pictogrammes en 120 × 100, tracés trait par trait.
  const TUILES = [
    {
      t: 'Une catégorielle',
      code: 'geom_bar()',
      traits: ['M 8 88 L 114 88', 'M 18 88 L 18 40 L 34 40 L 34 88', 'M 44 88 L 44 16 L 60 16 L 60 88', 'M 70 88 L 70 58 L 86 58 L 86 88', 'M 96 88 L 96 32 L 112 32 L 112 88']
    },
    {
      t: 'Une numérique',
      code: 'geom_histogram()',
      traits: ['M 8 88 L 112 88', 'M 12 88 L 12 72 L 28 72 L 28 46 L 44 46 L 44 18 L 60 18 L 60 28 L 76 28 L 76 52 L 92 52 L 92 74 L 108 74 L 108 88', 'M 28 88 L 28 72', 'M 44 88 L 44 46', 'M 60 88 L 60 28', 'M 76 88 L 76 52', 'M 92 88 L 92 74']
    },
    {
      t: 'Catégorielle × numérique',
      code: 'geom_boxplot()',
      traits: ['M 35 10 L 35 32', 'M 22 32 L 48 32 L 48 66 L 22 66 Z', 'M 22 50 L 48 50', 'M 35 66 L 35 88', 'M 85 22 L 85 44', 'M 72 44 L 98 44 L 98 74 L 72 74 Z', 'M 72 62 L 98 62', 'M 85 74 L 85 92']
    },
    {
      t: 'Deux catégorielles',
      code: 'table()',
      traits: ['M 12 12 L 108 12 L 108 88 L 12 88 Z', 'M 12 37 L 108 37', 'M 12 62 L 108 62', 'M 44 12 L 44 88', 'M 76 12 L 76 88'],
      points: [[60, 49.5], [92, 49.5], [60, 75], [92, 75]]
    },
    {
      t: 'Deux numériques',
      code: 'geom_point()',
      traits: ['M 12 8 L 12 88 L 114 88'],
      points: [[26, 76], [34, 68], [42, 72], [50, 57], [58, 62], [66, 47], [74, 51], [82, 37], [90, 41], [98, 25], [106, 30]]
    }
  ];
</script>

<div class="visuel quel" bind:this={hote}>
  {#key tour}
    {#each TUILES as t, i}
      <div class="tuile" class:vue={e >= i} class:ici={e === i}>
        <span class="titre">{t.t}</span>
        <svg viewBox="0 0 120 100" aria-hidden="true">
          {#each t.traits as d, k}
            <path {d} pathLength="1" class="trait" style="--k: {k}" />
          {/each}
          {#each t.points ?? [] as [x, y], k}
            <circle cx={x} cy={y} r="5" class="pt" style="--k: {k}" />
          {/each}
        </svg>
        <code class="fn">{t.code}</code>
      </div>
    {/each}
  {/key}
</div>

<style>
  .quel { display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.9em; align-items: stretch; }
  .tuile {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 0.6em;
    padding: 0.9em 0.7em 1em;
    border: 3px dashed var(--dk-filet);
    transition: border-color 0.3s;
  }
  .tuile.vue { border-style: solid; border-color: var(--dk-encre); }
  .tuile.ici { border-color: var(--dk-accent); animation: rebond 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards; }
  .titre {
    font-size: 0.74em;
    font-weight: 600;
    line-height: 1.3;
    min-height: 2.7em;
    display: flex;
    align-items: center;
    color: var(--dk-gris-2);
    transition: color 0.3s;
  }
  .vue .titre { color: var(--dk-encre); }

  svg { width: 100%; height: auto; max-height: 30vh; display: block; }
  .trait {
    fill: none;
    stroke: var(--dk-encre);
    stroke-width: 3.5;
    stroke-linejoin: miter;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
  }
  .vue .trait {
    stroke-dashoffset: 0;
    animation: trace 0.65s ease-out backwards;
    animation-delay: calc(var(--k) * 110ms + 150ms);
  }
  .ici .trait { stroke: var(--dk-accent); }
  .pt { fill: var(--dk-accent); transform-box: fill-box; transform-origin: center; transform: scale(0); }
  .vue .pt {
    transform: none;
    animation: pop 0.4s cubic-bezier(0.34, 1.8, 0.64, 1) backwards;
    animation-delay: calc(var(--k) * 70ms + 450ms);
  }
  .vue:not(.ici) .pt { fill: var(--dk-encre); }

  .fn {
    font-family: var(--dk-mono);
    font-size: 0.66em;
    padding: 0.2em 0.5em;
    border: 2px solid var(--dk-encre);
    background: none;
    opacity: 0;
    transform: translateY(0.8em);
  }
  .vue .fn { opacity: 1; transform: none; animation: monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) 0.75s backwards; }
  .ici .fn { color: var(--dk-accent); border-color: var(--dk-accent); }

  @keyframes trace { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  @keyframes monte { from { opacity: 0; transform: translateY(0.8em); } to { opacity: 1; transform: none; } }
  @keyframes rebond { from { transform: scale(0.9); } to { transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .tuile, .trait, .pt, .fn { animation: none !important; transition: none !important; }
  }
</style>
