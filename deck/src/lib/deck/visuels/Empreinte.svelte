<script>
  /**
   * Ce que l'IA coûte à l'environnement : six chiffres, trois sources, et
   * seulement des sources qui mesurent. Les estimations, projections et
   * scénarios (eau, 2027, effets indirects) existent mais reposent sur des
   * hypothèses ; on les nomme sur la diapo suivante sans les chiffrer.
   *
   * Vérifié le 9 septembre 2026 sur les sites des revues et de l'AIE :
   *   AIE, Energy and AI (avril 2025) : 415 TWh pour les centres de données
   *     en 2024, ~1,5 % de l'électricité mondiale ; ~945 TWh en 2030 dans
   *     le scénario de base (cette projection-là est un scénario, dit tel).
   *   Luccioni, Viguier & Ligozat (2023), JMLR : BLOOM, 176 G paramètres,
   *     entraînement mesuré : 24,7 t CO2e ; 50,5 t en comptant la
   *     fabrication du matériel et la consommation hors calcul.
   *   Luccioni, Jernite & Strubell (2024), ACM FAccT : énergie mesurée pour
   *     1 000 inférences sur une carte A100 : classification de texte
   *     0,002 kWh ; génération de texte 0,047 kWh ; génération d'images
   *     2,907 kWh en moyenne ; le modèle d'image le moins efficace,
   *     11,49 kWh = 522 recharges de téléphone (0,012 kWh la recharge, EPA).
   */
  import { brancherTemps } from '../temps.js';
  const F = [
    { v: '1,5 %', u: 'de l’électricité mondiale', q: 'Les centres de données en 2024 : 415 TWh, mesurés. Tout le numérique, pas seulement l’IA.', s: 'AIE, Energy and AI, 2025' },
    { v: '× 2', u: 'd’ici 2030', q: 'Le scénario de base de l’AIE : 945 TWh. L’IA en est le premier moteur. C’est une projection, pas une mesure.', s: 'AIE, Energy and AI, 2025' },
    { v: '25 t', u: 'de CO₂e pour entraîner BLOOM', q: 'Un modèle de 176 milliards de paramètres, entraînement mesuré au compteur. 50 t en comptant la fabrication du matériel.', s: 'Luccioni, Viguier & Ligozat, 2023 · JMLR' },
    { v: '0,05 Wh', u: 'par texte généré', q: 'Mesuré sur une carte graphique de recherche, 1 000 fois. Peu de chose, une fois.', s: 'Luccioni, Jernite & Strubell, 2024 · FAccT' },
    { v: '60 ×', u: 'plus pour une image que pour un texte', q: '2,9 kWh par 1 000 images en moyenne, contre 0,047 kWh par 1 000 textes. Le pire modèle : une demi-recharge de téléphone par image.', s: 'Luccioni, Jernite & Strubell, 2024 · FAccT' },
    { v: '24 ×', u: 'plus pour un modèle génératif que pour un modèle spécialisé', q: 'Générer un texte contre classer un texte. Le modèle à tout faire coûte des dizaines de fois le modèle fait pour une tâche.', s: 'Luccioni, Jernite & Strubell, 2024 · FAccT' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel empreinte" bind:this={hote}>
  <div class="grille">
    {#each F as f, i}
      <div class="fait" class:scenario={i === 1} style="animation-delay: {i * 100}ms">
        <span class="v">{f.v}</span>
        <span class="u">{f.u}</span>
        <p>{f.q}</p>
        <span class="s">{f.s}</span>
      </div>
    {/each}
  </div>
  <p class="morale" class:vu={e === 1}>Une requête ne coûte presque rien. Des milliards par jour, si. Et l’image coûte bien plus que le texte.</p>
</div>

<style>
  .empreinte { display: flex; flex-direction: column; gap: 0.8em; }
  .grille { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.8em; }
  .fait { border: 2px solid var(--dk-encre); padding: 0.8em 0.9em 0.7em; display: flex; flex-direction: column; gap: 0.15em; animation: fondu 0.5s both; }
  .fait.scenario { border-style: dashed; }
  .v { font-family: var(--dk-mono); font-size: 2em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .scenario .v { color: var(--dk-encre); }
  .u { font-size: 0.78em; font-weight: 600; line-height: 1.25; margin-top: 0.2em; }
  .fait p { margin: 0.3em 0 0; font-size: 0.7em; line-height: 1.4; color: var(--dk-gris); }
  .s { margin-top: auto; padding-top: 0.5em; font-size: 0.56em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }
  .morale { margin: 0; font-size: 1.05em; font-weight: 500; border-left: 0.34em solid var(--dk-accent); padding-left: 0.8em; opacity: 0; transition: opacity 0.4s; }
  .morale.vu { opacity: 1; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
