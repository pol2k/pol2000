<script>
  /**
   * L'eau et l'électricité des centres de données, à côté d'autres usages.
   * Deux panneaux, des faits ($lib/data/ia_environnement.js) : l'eau consommée
   * aux États-Unis (milliards de litres par an) et l'électricité consommée
   * (TWh par an). Échelles linéaires.
   *
   *   0  les deux panneaux;
   *   1  la prévision de l'AIE pour les centres de données en 2030.
   */
  import { brancherTemps } from '../temps.js';
  import { EAU, ENERGIE } from '$lib/data/ia_environnement.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const W = 700, X0 = 360, LX = 230, PAS = 62;
  const nb = (v) => (v < 100 ? (Math.round(v * 10) / 10).toLocaleString('fr-CA') : Math.round(v).toLocaleString('fr-CA')).replace(/\s/g, ' ');
  const maxE = EAU[0].gL;
  const maxN = Math.max(...ENERGIE.map((d) => d.en2030 ?? d.twh));
</script>

<div class="visuel m9p" bind:this={hote}>
  <div class="m9p-pan">
    <strong class="m9p-t">L’eau</strong>
    <span class="m9p-u">consommée aux États-Unis · milliards de litres par an</span>
    <svg viewBox="0 0 {W} {EAU.length * PAS + 6}" role="img" aria-label="Eau consommée aux États-Unis, en milliards de litres par an : {EAU.map((d) => `${d.nom} ${nb(d.gL)}`).join(', ')}.">
      {#each EAU as d, i (d.cle)}
        <g class:ia={d.ia} transform="translate(0 {i * PAS})">
          <text x={X0 - 12} y="28" class="m9p-nom">{d.nom}{d.note ? ' *' : ''}</text>
          <text x={X0 - 12} y="47" class="m9p-an">{d.an}</text>
          <rect x={X0} y="10" width={Math.max(Math.min(d.gL / maxE, 1) * LX, 2)} height="30" class="m9p-rect" />
          <text x={X0 + Math.max(Math.min(d.gL / maxE, 1) * LX, 2) + 10} y="32" class="m9p-v">{nb(d.gL)}</text>
        </g>
      {/each}
    </svg>
  </div>
  <div class="m9p-pan">
    <strong class="m9p-t">L’électricité</strong>
    <span class="m9p-u">consommée · TWh par an</span>
    <svg viewBox="0 0 {W} {ENERGIE.length * PAS + 6}" role="img" aria-label="Électricité consommée, en TWh par an : {ENERGIE.map((d) => `${d.nom} ${nb(d.twh)}`).join(', ')}. Centres de données en 2030 : 945 prévus.">
      {#each ENERGIE as d, i}
        <g class:ia={d.ia} transform="translate(0 {i * PAS})">
          <text x={X0 - 12} y="28" class="m9p-nom">{d.nom}</text>
          <text x={X0 - 12} y="47" class="m9p-an">{d.an}{d.note ? ` · ${d.note}` : ''}</text>
          {#if d.en2030}
            <rect x={X0} y="10" width={(d.en2030 / maxN) * LX} height="30" class="m9p-futur" class:vu={e >= 1} />
          {/if}
          <rect x={X0} y="10" width={(d.twh / maxN) * LX} height="30" class="m9p-rect" />
          <text x={X0 + ((e >= 1 && d.en2030 ? d.en2030 : d.twh) / maxN) * LX + 10} y="32" class="m9p-v">{e >= 1 && d.en2030 ? `${nb(d.twh)} → ${nb(d.en2030)} en 2030` : nb(d.twh)}</text>
        </g>
      {/each}
    </svg>
  </div>
  <p class="credits m9p-src">* Eau : USGS (2020, 48 États, irrigation agricole), GCSAA (2024, eau d’arrosage appliquée), LBNL (2023; l’eau « de l’électricité » comprend l’évaporation des barrages et chevauche les centrales). Électricité : AIE (2022, 2025; 2030 prévu), Hydro-Québec (2025), Cambridge (Bitcoin, rythme annualisé fin 2024). Centres de données : tous usages, pas seulement l’IA.</p>
</div>

<style>
  .m9p { display: grid; grid-template-columns: 1fr 1fr; gap: 0.6em 2em; max-width: 66em; margin: 0.4em auto 0; }
  .m9p-pan { display: flex; flex-direction: column; gap: 0.2em; }
  .m9p-t { font-size: 1.3em; }
  .m9p-u { font-size: 0.75em; color: var(--dk-gris); border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; margin-bottom: 0.3em; }
  svg { width: 100%; height: auto; max-height: 44vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9p-nom { font-size: 16px; font-weight: 700; text-anchor: end; }
  .m9p-an { font-size: 13px; text-anchor: end; fill: var(--dk-gris); }
  .m9p-rect { fill: var(--dk-gris); transition: width 0.6s; }
  .ia .m9p-rect { fill: var(--dk-accent); }
  .ia .m9p-nom, .ia .m9p-v { fill: var(--dk-accent); }
  .m9p-futur { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; stroke-dasharray: 7 6; opacity: 0; transition: opacity 0.5s; }
  .m9p-futur.vu { opacity: 1; }
  .m9p-v { font-size: 17px; font-weight: 700; }
  .m9p-src { grid-column: 1 / -1; margin: 0; }
  @media (prefers-reduced-motion: reduce) { .m9p-futur, .m9p-rect { transition: none; } }
</style>
