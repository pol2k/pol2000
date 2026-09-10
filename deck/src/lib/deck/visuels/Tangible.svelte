<script>
  /**
   * L'IA est tangible : une photo de centre de données à gauche, une colonne
   * de grands chiffres à droite, une ligne chacun, la source imprimée sur la
   * diapo. Des mesures, des agences et des reportages sérieux ; pas de
   * plaidoyer. Un temps : les deux derniers chiffres (les dégâts humains)
   * n'arrivent qu'au clic, pour qu'on parle d'abord de la planète, puis
   * de vous.
   *
   * Vérifié le 10 septembre 2026 :
   *   NVIDIA, communiqué du 28 octobre 2024 : Colossus, « 100,000 NVIDIA
   *     Hopper GPUs in Memphis, Tennessee » ; en cours de doublement.
   *   TechCrunch, 3 juillet 2025 : 15 turbines à gaz permises par le comté
   *     de Shelby ; « as many as 35 generators without permits » (SELC).
   *   Foyers québécois : 100 000 GPU × 700 W × 8 760 h = 613 GWh par an ;
   *     ÷ 17 600 kWh (consommation résidentielle moyenne, Hydro-Québec ;
   *     le communiqué du 30 juin 2026 donne « 17 000 kWh » pour une
   *     résidence chauffée à l'électricité) ≈ 34 800, arrondi à 35 000.
   *     Les GPU seuls, sans refroidissement ni réseau : un plancher.
   *   Li, Yang, Islam & Ren (2025), Communications of the ACM 68(7) :
   *     « Training GPT-3 in Microsoft's state-of-the-art U.S. data centers
   *     can directly evaporate 700,000 liters of clean freshwater ». Une
   *     estimation modélisée à partir de ratios publiés, dite telle.
   *   Luccioni, Viguier & Ligozat (2023), JMLR : BLOOM, 176 G paramètres,
   *     entraînement mesuré : 24,7 t CO2e ; 50,5 t en comptant la
   *     fabrication du matériel et la consommation hors calcul.
   *   AIE, Energy and AI (avril 2025) : 415 TWh pour les centres de données
   *     en 2024, ~1,5 % de l'électricité mondiale ; ~945 TWh en 2030 dans
   *     le scénario de base (cette projection-là est un scénario).
   *   Bastani et al. (2025), PNAS 122(26) : ~1 000 lycéens en Turquie,
   *     essai contrôlé ; avec GPT-4 sans garde-fou, +48 % en pratique,
   *     puis −17 % à l'examen sans IA par rapport au groupe témoin.
   *   Brynjolfsson, Chandar & Chen (2026), Stanford Digital Economy Lab,
   *     mise à jour du 12 août 2026 : paie ADP, nov. 2022 à juin 2026 ;
   *     l'emploi des 22 à 25 ans dans les métiers les plus exposés est
   *     ~19 % sous ce qu'il serait s'il avait suivi leurs pairs moins
   *     exposés. Document de travail, pas encore évalué par les pairs.
   *   Gardé en réserve, mesuré mais pas sur la diapo (Luccioni, Jernite &
   *     Strubell 2024, ACM FAccT) : 1 000 inférences sur une carte A100,
   *     texte 0,047 kWh, image 2,907 kWh en moyenne, 11,49 kWh au pire.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  const F = [
    { v: '100 000', u: 'GPU', q: 'dans un seul bâtiment, à Memphis', s: 'NVIDIA, 2024' },
    { v: '35', u: 'turbines à gaz', q: 'brûlées sur place pour l’alimenter, 15 permises', s: 'TechCrunch, 2025' },
    { v: '35 000', u: 'foyers québécois', q: 'l’électricité de ces GPU pendant un an', s: 'NVIDIA · Hydro-Québec' },
    { v: '700 000', u: 'litres d’eau', q: 'évaporés pour entraîner GPT-3', s: 'Li et al., 2025' },
    { v: '25 t', u: 'de CO₂e', q: 'pour entraîner BLOOM, mesurées au compteur', s: 'Luccioni et al., 2023' },
    { v: '1,5 %', u: 'de l’électricité mondiale', q: 'pour les centres de données en 2024, le double en 2030', s: 'AIE, 2025' }
  ];
  const H = [
    { v: '− 17 %', u: 'à l’examen', q: 'pour les élèves qui ont pratiqué avec ChatGPT sans garde-fou', s: 'Bastani et al., 2025' },
    { v: '− 19 %', u: 'd’emploi', q: 'chez les 22 à 25 ans dans les métiers les plus exposés à l’IA', s: 'Brynjolfsson et al., 2026' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tangible" bind:this={hote}>
  <div class="corps">
    <figure class="photo">
      <img src="{base}/img/centre-donnees.jpg" alt="Des rangées d’armoires de serveurs dans un centre de données" />
      <figcaption>Un centre de données. Du béton, du cuivre, du courant, de l’eau.</figcaption>
    </figure>
    <ol class="faits">
      {#each F as f, i}
        <li style="animation-delay: {i * 90}ms">
          <span class="v">{f.v}</span>
          <span class="t"><strong>{f.u}</strong> {f.q}</span>
          <span class="s">{f.s}</span>
        </li>
      {/each}
      {#each H as f}
        <li class="humain" class:vu={e === 1}>
          <span class="v">{f.v}</span>
          <span class="t"><strong>{f.u}</strong> {f.q}</span>
          <span class="s">{f.s}</span>
        </li>
      {/each}
    </ol>
  </div>
  <p class="sources">
    <span class="et">Sources</span>
    NVIDIA, communiqué, 28 oct. 2024 · TechCrunch, 3 juill. 2025 · Hydro-Québec, 17 600 kWh par foyer et par an · Li, Yang, Islam &amp; Ren, 2025, <i>Communications of the ACM</i> · Luccioni, Viguier &amp; Ligozat, 2023, <i>JMLR</i> · AIE, <i>Energy and AI</i>, 2025 · Bastani et al., 2025, <i>PNAS</i> · Brynjolfsson, Chandar &amp; Chen, 2026, Stanford Digital Economy Lab
  </p>
</div>

<style>
  .tangible { display: flex; flex-direction: column; gap: 0.7em; }
  .corps { display: grid; grid-template-columns: 0.72fr 1.28fr; gap: 1.2em; align-items: stretch; }
  .photo { margin: 0; display: flex; flex-direction: column; gap: 0.35em; min-height: 0; }
  .photo img { display: block; width: 100%; flex: 1 1 0; min-height: 0; object-fit: cover; border: 2px solid var(--dk-encre); filter: grayscale(1); }
  .photo figcaption { font-size: 0.62em; line-height: 1.35; color: var(--dk-gris); }
  .faits { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; border-top: 2px solid var(--dk-encre); }
  .faits li { display: grid; grid-template-columns: 6.6em 1fr auto; gap: 0 0.7em; align-items: baseline; padding: 0.26em 0; border-bottom: 1px solid var(--dk-filet); animation: fondu 0.5s both; }
  .v { font-family: var(--dk-mono); font-size: 1.5em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; white-space: nowrap; text-align: right; }
  .t { font-size: 0.74em; line-height: 1.3; color: var(--dk-gris); }
  .t strong { color: var(--dk-encre); }
  .s { font-size: 0.54em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris-2); white-space: nowrap; }
  /* Les dégâts humains : présents dans la mise en page, invisibles avant le clic. */
  .faits li.humain { animation: none; opacity: 0; transition: opacity 0.45s; }
  .faits li.humain.vu { opacity: 1; }
  .faits li.humain .v { color: var(--dk-encre); }
  .sources { margin: 0; font-size: 0.6em; line-height: 1.45; color: var(--dk-gris); border-left: 0.34em solid var(--dk-filet); padding-left: 0.8em; }
  .sources .et { font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; margin-right: 0.6em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
