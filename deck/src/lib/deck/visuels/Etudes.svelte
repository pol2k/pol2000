<script>
  /**
   * Les études évaluées par les pairs sur l'empreinte environnementale de
   * l'IA, dans l'ordre chronologique, une ligne de résultat chacune. Les
   * deux sources non évaluées (AIE, Google) sont sur la diapo des chiffres,
   * étiquetées comme telles. Références vérifiées le 9 septembre 2026 sur
   * les sites des revues.
   */
  const ETUDES = [
    { a: 'Strubell, Ganesh & McCallum', an: 2019, t: 'Energy and Policy Considerations for Deep Learning in NLP', r: 'ACL', q: 'L’étude fondatrice : un entraînement avec recherche d’architecture émet autant que cinq voitures sur leur vie entière.' },
    { a: 'Luccioni, Viguier & Ligozat', an: 2023, t: 'Estimating the Carbon Footprint of BLOOM', r: 'J. of Machine Learning Research', q: 'Premier bilan de bout en bout : 25 t CO₂e pour l’entraînement, 50 t avec la fabrication du matériel.' },
    { a: 'de Vries', an: 2023, t: 'The growing energy footprint of artificial intelligence', r: 'Joule', q: 'Dès 2027, l’IA pourrait consommer 85 à 134 TWh par an : l’électricité des Pays-Bas.' },
    { a: 'Luccioni, Jernite & Strubell', an: 2024, t: 'Power Hungry Processing', r: 'ACM FAccT', q: 'L’usage compte : les modèles génératifs coûtent des dizaines de fois plus que les spécialisés, et l’image bien plus que le texte.' },
    { a: 'Ren, Tomlinson, Black & Torrance', an: 2024, t: 'Reconciling the contrasting narratives on the environmental impact of LLMs', r: 'Scientific Reports', q: 'Par page écrite, un modèle consomme 40 à 150 fois moins qu’un humain. Effet rebond non compté.' },
    { a: 'Li, Yang, Islam & Ren', an: 2025, t: 'Making AI Less “Thirsty”', r: 'Communications of the ACM', q: 'L’eau, l’angle mort : 700 000 L pour entraîner GPT-3 ; 4 à 6 milliards de m³ pour l’IA en 2027.' },
    { a: 'Alpine, Geldner, Alpine & Chepeliev', an: 2026, t: 'AI-driven productivity gains enable more CO₂ emissions than they avoid', r: 'npj Climate Action', q: 'Les gains de productivité profitent aussi au fossile. Net : +0,5 à 1,8 Gt CO₂ par an, sans politique pour orienter.' }
  ];
</script>

<div class="visuel etudes">
  <ol class="liste">
    {#each ETUDES as s, i}
      <li style="animation-delay: {i * 80}ms">
        <span class="an">{s.an}</span>
        <div>
          <span class="aut">{s.a}</span> · <span class="tit">{s.t}</span> · <span class="rev">{s.r}</span>
          <p>{s.q}</p>
        </div>
      </li>
    {/each}
  </ol>
  <p class="note">Toutes accessibles en ligne. L’AIE et Google, sur la diapo précédente, ne sont pas évalués par les pairs.</p>
</div>

<style>
  .etudes { display: flex; flex-direction: column; gap: 0.5em; }
  .liste { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; }
  .liste li { display: grid; grid-template-columns: 3em 1fr; gap: 0.7em; padding: 0.32em 0; border-bottom: 1px solid var(--dk-filet); margin: 0; font-size: 0.74em; line-height: 1.32; animation: fondu 0.5s both; }
  .liste li:first-child { border-top: 2px solid var(--dk-encre); }
  .an { font-weight: 600; color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .aut { font-weight: 600; }
  .tit { font-style: italic; }
  .rev { color: var(--dk-gris); }
  .liste p { margin: 0.05em 0 0; font-size: 0.92em; color: var(--dk-gris); }
  .note { margin: 0; font-size: 0.66em; color: var(--dk-gris); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
