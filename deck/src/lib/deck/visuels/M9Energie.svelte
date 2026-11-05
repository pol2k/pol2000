<script>
  /**
   * Qui consomme le plus d'électricité dans le monde ? En TWh par an
   * (ENERGIE, $lib/data/ia_environnement.js).
   *
   *   0  quatre usages, à la même échelle; les centres de données en rouge;
   *   1  leur prolongement prévu pour 2030, en pointillé.
   */
  import { brancherTemps } from '../temps.js';
  import { ENERGIE } from '$lib/data/ia_environnement.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const W = 1000, X0 = 330, LX = 560, PAS = 72, Y0 = 10, MAX = 2100;
  const x = (v) => X0 + (v / MAX) * LX;
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const H = Y0 + ENERGIE.length * PAS + 10;
</script>

<div class="visuel m9n" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Électricité consommée dans le monde, en TWh par an : {ENERGIE.map((d) => `${d.nom} ${d.twh}`).join(', ')}. Centres de données : 945 TWh prévus en 2030.">
    {#each ENERGIE as d, i}
      <g class:ia={d.ia} transform="translate(0 {i * PAS})">
        <text x={X0 - 16} y={Y0 + 32} class="m9n-nom">{d.nom}</text>
        <text x={X0 - 16} y={Y0 + 53} class="m9n-an">{d.an}</text>
        {#if d.en2030}
          <rect x={x(0)} y={Y0 + 10} width={(d.en2030 / MAX) * LX} height="38" class="m9n-futur" class:vu={e >= 1} />
          <text x={x(d.en2030) + 12} y={Y0 + 37} class="m9n-v rouge" class:vu={e >= 1} style="opacity: {e >= 1 ? 1 : 0}">{nb(d.en2030)} en 2030</text>
        {/if}
        <rect x={x(0)} y={Y0 + 10} width={(d.twh / MAX) * LX} height="38" class="m9n-rect" />
        <text x={x(d.twh) + 12} y={Y0 + 37} class="m9n-v" style="opacity: {d.en2030 && e >= 1 ? 0 : 1}">{d.approx ? '≈ ' : ''}{nb(d.twh)}</text>
      </g>
    {/each}
  </svg>
  <p class="m9n-dit">{e >= 1 ? 'En 2030 : plus du double, un peu plus que tout le Japon aujourd’hui.' : 'TWh par an, dans le monde. Les centres de données : 1,5 % de l’électricité.'}</p>
  <p class="credits">AIE, Energy and AI (2025) et Our World in Data (climatisation, 2022); aluminium : estimation de l’industrie; Bitcoin : indice de Cambridge. Centres de données : toute l’informatique, pas seulement l’IA.</p>
</div>

<style>
  .m9n { display: flex; flex-direction: column; gap: 0.4em; max-width: 62em; margin: 0.2em auto 0; }
  svg { width: 100%; height: auto; max-height: 48vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9n-rect { fill: var(--dk-gris); }
  .ia .m9n-rect { fill: var(--dk-accent); }
  .ia .m9n-nom { fill: var(--dk-accent); }
  .m9n-futur { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 9 7; opacity: 0; transition: opacity 0.5s; }
  .m9n-futur.vu { opacity: 1; }
  .m9n-nom { font-size: 21px; font-weight: 700; text-anchor: end; }
  .m9n-an { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .m9n-v { font-size: 22px; font-weight: 700; transition: opacity 0.4s; }
  .m9n-v.rouge { fill: var(--dk-accent); }
  .m9n-dit { margin: 0; text-align: center; font-size: 1.15em; font-weight: 700; }
  @media (prefers-reduced-motion: reduce) { .m9n-futur, .m9n-v { transition: none; } }
</style>
