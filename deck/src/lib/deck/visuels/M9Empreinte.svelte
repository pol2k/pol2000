<script>
  /**
   * L'eau et l'électricité des centres de données, à côté d'autres usages.
   * Deux panneaux, des faits, pas de commentaire ($lib/data/ia_environnement.js) :
   * l'eau consommée aux États-Unis (milliards de litres par jour) et
   * l'électricité consommée dans le monde (TWh par an). Au clic, la prévision
   * de l'AIE pour les centres de données en 2030.
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
  const W = 700, X0 = 370, LX = 230, PAS = 62;
  const fe = (v) => (v < 1 ? v.toFixed(2) : v < 20 ? v.toFixed(1) : Math.round(v).toString()).replace('.', ',');
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const maxE = EAU[0].gLj, maxN = Math.max(...ENERGIE.map((d) => d.twh));
</script>

<div class="visuel m9p" bind:this={hote}>
  <div class="m9p-pan">
    <strong class="m9p-t">L’eau</strong>
    <span class="m9p-u">consommée aux États-Unis · milliards de litres par jour</span>
    <svg viewBox="0 0 {W} {EAU.length * PAS + 6}" role="img" aria-label="Eau consommée aux États-Unis : {EAU.map((d) => `${d.nom} ${fe(d.gLj)}`).join(', ')}.">
      {#each EAU as d, i}
        <g class:ia={d.ia} transform="translate(0 {i * PAS})">
          <text x={X0 - 12} y="28" class="m9p-nom">{d.nom}</text>
          <text x={X0 - 12} y="47" class="m9p-an">{d.an}</text>
          <rect x={X0} y="10" width={Math.max((d.gLj / maxE) * LX, 2)} height="30" class="m9p-rect" />
          <text x={X0 + Math.max((d.gLj / maxE) * LX, 2) + 10} y="32" class="m9p-v">{fe(d.gLj)}</text>
        </g>
      {/each}
    </svg>
  </div>
  <div class="m9p-pan">
    <strong class="m9p-t">L’électricité</strong>
    <span class="m9p-u">consommée dans le monde · TWh par an</span>
    <svg viewBox="0 0 {W} {ENERGIE.length * PAS + 6}" role="img" aria-label="Électricité consommée dans le monde : {ENERGIE.map((d) => `${d.nom} ${d.twh}`).join(', ')}. Centres de données en 2030 : 945 prévus.">
      {#each ENERGIE as d, i}
        <g class:ia={d.ia} transform="translate(0 {i * PAS})">
          <text x={X0 - 12} y="28" class="m9p-nom">{d.nom}</text>
          <text x={X0 - 12} y="47" class="m9p-an">{d.an}</text>
          {#if d.en2030}
            <rect x={X0} y="10" width={(d.en2030 / maxN) * LX} height="30" class="m9p-futur" class:vu={e >= 1} />
          {/if}
          <rect x={X0} y="10" width={(d.twh / maxN) * LX} height="30" class="m9p-rect" />
          <text x={X0 + ((e >= 1 && d.en2030 ? d.en2030 : d.twh) / maxN) * LX + 10} y="32" class="m9p-v">{d.approx ? '≈ ' : ''}{e >= 1 && d.en2030 ? `${nb(d.twh)} → ${nb(d.en2030)} en 2030` : nb(d.twh)}</text>
        </g>
      {/each}
    </svg>
  </div>
  <p class="credits m9p-src">Eau consommée, pas prélevée : USGS (2015), GCSAA (2024, arrosage), LBNL (2023; « + électricité » : l’eau des centrales qui les alimentent). Électricité : AIE, Energy and AI (2025); Our World in Data (climatisation); estimation de l’industrie (aluminium); indice de Cambridge (Bitcoin). Centres de données : toute l’informatique, pas seulement l’IA.</p>
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
  .m9p-rect { fill: var(--dk-gris); }
  .ia .m9p-rect { fill: var(--dk-accent); }
  .ia .m9p-nom, .ia .m9p-v { fill: var(--dk-accent); }
  .m9p-futur { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; stroke-dasharray: 7 6; opacity: 0; transition: opacity 0.5s; }
  .m9p-futur.vu { opacity: 1; }
  .m9p-v { font-size: 18px; font-weight: 700; }
  .m9p-src { grid-column: 1 / -1; margin: 0; }
  @media (prefers-reduced-motion: reduce) { .m9p-futur { transition: none; } }
</style>
