<script>
  /**
   * Fidélité et validité, sur quatre cibles. Une mesure fidèle tombe toujours
   * au même endroit; une mesure valide tombe au bon endroit. Les quatre cas
   * apparaissent au clic, de la pire à la meilleure. Les impacts sont des
   * points fixes, pas tirés au hasard : c'est un schéma.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const CAS = [
    { titre: 'Ni fidèle, ni valide', dit: 'Dispersé, et à côté.', pts: [[-52, -30], [40, -58], [-20, 48], [58, 22], [10, -10]] },
    { titre: 'Fidèle, pas valide', dit: 'Toujours au même endroit, mais pas le bon.', pts: [[44, -46], [52, -38], [40, -34], [50, -50], [46, -40]] },
    { titre: 'Valide, pas fidèle', dit: 'Autour du bon endroit, mais dispersé.', pts: [[-40, -22], [36, -30], [-24, 34], [30, 28], [2, -4]] },
    { titre: 'Fidèle et valide', dit: 'Au bon endroit, à chaque fois.', pts: [[-6, -4], [5, -7], [-3, 6], [7, 4], [0, 0]] }
  ];
  const R = [80, 56, 32, 12];
</script>

<div class="visuel m9c" bind:this={hote}>
  {#each CAS as c, i}
    <div class="m9c-cas" class:vu={e >= i + 1} class:bon={i === 3}>
      <svg viewBox="-100 -100 200 200" role="img" aria-label={c.titre + '. ' + c.dit}>
        {#each R as r, k}
          <circle cx="0" cy="0" r={r} class="m9c-anneau" class:plein={k === 3} />
        {/each}
        {#each c.pts as p, k}
          <circle cx={p[0]} cy={p[1]} r="7" class="m9c-pt" style="--k: {k}" />
        {/each}
      </svg>
      <strong>{c.titre}</strong>
      <span>{c.dit}</span>
    </div>
  {/each}
  <p class="m9c-legende">
    <span><b>Fidèle</b> : la même chose, à chaque mesure.</span>
    <span><b>Valide</b> : la bonne chose.</span>
  </p>
</div>

<style>
  .m9c { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.4em; max-width: 64em; margin: 0.8em auto 0; }
  .m9c-cas { display: flex; flex-direction: column; align-items: center; gap: 0.3em; text-align: center; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .m9c-cas.vu { opacity: 1; transform: none; }
  svg { width: 100%; height: auto; max-height: 30vh; display: block; }
  .m9c-anneau { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .m9c-anneau.plein { fill: var(--dk-fond-2); }
  .m9c-pt { fill: var(--dk-accent); opacity: 0; }
  .m9c-cas.vu .m9c-pt { animation: m9c-impact 0.3s both; animation-delay: calc(0.2s + var(--k) * 0.12s); }
  .m9c-cas strong { font-size: 1em; line-height: 1.2; }
  .m9c-cas.bon strong { color: var(--dk-accent); }
  .m9c-cas span { font-size: 0.72em; color: var(--dk-gris); line-height: 1.3; }
  .m9c-legende { grid-column: 1 / -1; margin: 0.4em 0 0; display: flex; gap: 2.4em; justify-content: center; font-size: 0.85em; }
  @keyframes m9c-impact { from { opacity: 0; transform: scale(2.2); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9c-cas, .m9c-cas.vu .m9c-pt { transition: none; animation: none; opacity: 1; } }
</style>
