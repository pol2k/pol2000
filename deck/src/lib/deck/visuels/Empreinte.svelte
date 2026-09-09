<script>
  /**
   * Ce que l'IA coûte à l'environnement : six chiffres, chacun avec sa
   * source. Rien ici n'est estimé par nous ; chaque nombre est repris tel
   * quel d'une étude évaluée par les pairs, ou d'un rapport officiel quand
   * c'est dit (AIE, Google). Les comparaisons sont celles des auteurs.
   *
   * Vérifié le 9 septembre 2026 :
   *   AIE, Energy and AI (avril 2025) : 415 TWh en 2024 (~1,5 %), ~945 TWh
   *     en 2030 (un peu moins de 3 %).
   *   Google (août 2025), rapport technique : message texte médian Gemini
   *     0,24 Wh, 0,26 mL d'eau, 0,03 g CO2e. Auto-déclaré, non évalué.
   *   Luccioni, Jernite & Strubell (2024), FAccT : 2,907 kWh par 1 000
   *     images (moyenne), 0,047 kWh par 1 000 textes ; le modèle d'image le
   *     moins efficace = 522 recharges de téléphone par 1 000 images.
   *   Li, Yang, Islam & Ren (2025), Comm. ACM : 700 000 L évaporés pour
   *     entraîner GPT-3 ; 4,2 à 6,6 milliards de m³ prélevés pour l'IA en
   *     2027, soit 4 à 6 fois le Danemark.
   *   Luccioni, Viguier & Ligozat (2023), JMLR : BLOOM, 24,7 t CO2e
   *     (entraînement seul) à 50,5 t (cycle de vie).
   *   Ren, Tomlinson, Black & Torrance (2024), Scientific Reports : écrire
   *     une page avec Llama-3-70B coûte 40 à 150 fois moins qu'un humain
   *     (énergie, CO2, eau), effet rebond non compté.
   */
  import { brancherTemps } from '../temps.js';
  const F = [
    { v: '1,5 %', u: 'de l’électricité mondiale', q: 'Les centres de données en 2024. Le double en 2030, tirés par l’IA.', s: 'AIE, Energy and AI, 2025 · rapport officiel' },
    { v: '0,24 Wh', u: 'un message texte', q: 'Neuf secondes de télévision. C’est Google qui le mesure, sur ses propres serveurs.', s: 'Google, 2025 · auto-déclaré, non évalué' },
    { v: '½ recharge', u: 'de téléphone par image générée', q: 'Le pire modèle testé. Générer une image coûte en moyenne 60 fois plus qu’un texte.', s: 'Luccioni, Jernite & Strubell, 2024 · FAccT' },
    { v: '700 000 L', u: 'd’eau pour entraîner GPT-3', q: 'Évaporée pour refroidir. En 2027, l’IA prélèverait 4 à 6 fois l’eau du Danemark.', s: 'Li, Yang, Islam & Ren, 2025 · Comm. ACM' },
    { v: '25 à 50 t', u: 'de CO₂e pour entraîner BLOOM', q: 'Un seul modèle, 176 milliards de paramètres, mesuré de bout en bout.', s: 'Luccioni, Viguier & Ligozat, 2023 · JMLR' },
    { v: '40 à 150 ×', u: 'moins qu’un humain, par page écrite', q: 'Le contre-argument : l’humain qui écrit consomme aussi. L’effet rebond n’est pas compté.', s: 'Ren, Tomlinson, Black & Torrance, 2024 · Sci. Reports' }
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
      <div class="fait" class:contre={i === 5} style="animation-delay: {i * 100}ms">
        <span class="v">{f.v}</span>
        <span class="u">{f.u}</span>
        <p>{f.q}</p>
        <span class="s">{f.s}</span>
      </div>
    {/each}
  </div>
  <p class="morale" class:vu={e === 1}>Un message ne coûte presque rien. Des milliards par jour, si. Et personne ne publie les chiffres complets.</p>
</div>

<style>
  .empreinte { display: flex; flex-direction: column; gap: 0.8em; }
  .grille { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.8em; }
  .fait { border: 2px solid var(--dk-encre); padding: 0.8em 0.9em 0.7em; display: flex; flex-direction: column; gap: 0.15em; animation: fondu 0.5s both; }
  .fait.contre { border-style: dashed; }
  .v { font-family: var(--dk-mono); font-size: 2em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .contre .v { color: var(--dk-encre); }
  .u { font-size: 0.78em; font-weight: 600; line-height: 1.25; margin-top: 0.2em; }
  .fait p { margin: 0.3em 0 0; font-size: 0.7em; line-height: 1.4; color: var(--dk-gris); }
  .s { margin-top: auto; padding-top: 0.5em; font-size: 0.56em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }
  .morale { margin: 0; font-size: 1.05em; font-weight: 500; border-left: 0.34em solid var(--dk-accent); padding-left: 0.8em; opacity: 0; transition: opacity 0.4s; }
  .morale.vu { opacity: 1; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
