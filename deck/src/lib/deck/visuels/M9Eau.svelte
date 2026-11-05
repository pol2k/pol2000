<script>
  /**
   * Qui consomme le plus d'eau aux États-Unis ? L'eau consommée (pas
   * prélevée), en milliards de litres par jour (EAU, $lib/data/ia_environnement.js).
   *
   *   0  les cinq barres, à la même échelle : l'irrigation écrase tout;
   *   1  on enlève l'irrigation et on zoome : le golf, les centres de données;
   *   2  les deux rapports : golf / centres de données.
   */
  import { brancherTemps } from '../temps.js';
  import { EAU } from '$lib/data/ia_environnement.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const W = 1000, X0 = 470, LX = 400, PAS = 64, Y0 = 10;
  const max = $derived(e >= 1 ? EAU[1].gLj : EAU[0].gLj);
  const f = (v) => (v < 1 ? v.toFixed(2) : v < 20 ? v.toFixed(1) : Math.round(v).toString()).replace('.', ',');
  const golf = EAU.find((d) => d.cle === 'golf');
  const ratio = (d) => (golf.gLj / d.gLj).toFixed(golf.gLj / d.gLj < 10 ? 1 : 0).replace('.', ',');
  const H = Y0 + EAU.length * PAS + 10;
</script>

<div class="visuel m9w" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Eau consommée aux États-Unis, en milliards de litres par jour : {EAU.map((d) => `${d.nom} ${f(d.gLj)}`).join(', ')}.">
    {#each EAU as d, i}
      {@const parti = e >= 1 && d.cle === 'irrigation'}
      {@const rang = e >= 1 ? i - 1 : i}
      <g class="m9w-barre" class:parti class:ia={d.ia} style="transform: translateY({Math.max(rang, 0) * PAS}px)">
        <text x={X0 - 16} y={Y0 + 30} class="m9w-nom">{d.nom}</text>
        <text x={X0 - 16} y={Y0 + 50} class="m9w-an">{d.an}</text>
        <rect x={X0} y={Y0 + 8} width={Math.max(Math.min(d.gLj / max, 1) * LX, 2)} height="36" class="m9w-rect" />
        <text x={X0 + Math.min(d.gLj / max, 1) * LX + 12} y={Y0 + 35} class="m9w-v">{f(d.gLj)}</text>
        {#if e >= 2 && d.ia}
          <text x={X0 + Math.min(d.gLj / max, 1) * LX + 110} y={Y0 + 35} class="m9w-ratio">golf : ×{ratio(d)}</text>
        {/if}
      </g>
    {/each}
  </svg>
  <p class="m9w-dit">{e >= 2 ? 'Le golf boit plus que les centres de données : 30 fois plus sur place, 2 fois plus en comptant leur électricité.' : e >= 1 ? 'Sans l’irrigation, on y voit quelque chose.' : 'Milliards de litres consommés par jour, aux États-Unis.'}</p>
  <p class="credits">USGS (2015), GCSAA (2024, eau d’arrosage), LBNL (2023). Eau consommée, pas prélevée. Centres de données : toute l’informatique, pas seulement l’IA.</p>
</div>

<style>
  .m9w { display: flex; flex-direction: column; gap: 0.4em; max-width: 62em; margin: 0.2em auto 0; }
  svg { width: 100%; height: auto; max-height: 50vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9w-barre { transition: transform 0.7s, opacity 0.5s; }
  .m9w-barre.parti { opacity: 0; }
  .m9w-rect { fill: var(--dk-gris); transition: width 0.7s; }
  .m9w-barre.ia .m9w-rect { fill: var(--dk-accent); }
  .m9w-nom { font-size: 20px; font-weight: 700; text-anchor: end; }
  .m9w-barre.ia .m9w-nom, .m9w-barre.ia .m9w-v { fill: var(--dk-accent); }
  .m9w-an { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .m9w-v { font-size: 22px; font-weight: 700; transition: x 0.7s; }
  .m9w-ratio { font-size: 18px; font-weight: 700; fill: var(--dk-encre); }
  .m9w-dit { margin: 0; text-align: center; font-size: 1.15em; font-weight: 700; }
  @media (prefers-reduced-motion: reduce) { .m9w-barre, .m9w-rect, .m9w-v { transition: none; } }
</style>
