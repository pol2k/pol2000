<script>
  /**
   * Les sources retenues : deux études qui mesurent, évaluées par les pairs
   * dans des revues sans agenda, et le rapport de l'agence qui tient les
   * comptes de l'électricité. Puis, nommé sans chiffre, ce qu'on a laissé
   * de côté et pourquoi : la salle doit savoir que ça existe, et savoir
   * pourquoi ce n'est pas sur la diapo. Vérifié le 9 septembre 2026.
   */
  const ETUDES = [
    { a: 'Luccioni, Viguier & Ligozat', an: 2023, t: 'Estimating the Carbon Footprint of BLOOM, a 176B Parameter Language Model', r: 'Journal of Machine Learning Research', m: 'MESURE', q: 'Le compteur d’un vrai entraînement, publié ligne par ligne, fabrication du matériel comprise. La référence du domaine.' },
    { a: 'Luccioni, Jernite & Strubell', an: 2024, t: 'Power Hungry Processing: Watts Driving the Cost of AI Deployment?', r: 'ACM FAccT', m: 'MESURE', q: '88 modèles, 1 000 inférences chacun, sur la même carte, code public. L’usage, pas seulement l’entraînement.' },
    { a: 'Agence internationale de l’énergie', an: 2025, t: 'Energy and AI', r: 'rapport, non évalué par les pairs', m: 'DONNÉES', q: 'Les comptes de l’électricité mondiale. Le chiffre de 2024 est une donnée ; celui de 2030, un scénario.' }
  ];
  const ECARTEES = [
    ['L’eau', 'Li et al., 2025, Comm. ACM : modélisée à partir de ratios publiés, pas mesurée. Sérieux, mais une estimation.'],
    ['Les projections nationales', 'de Vries, 2023, Joule : un commentaire de quatre pages, calculé sur des livraisons de serveurs.'],
    ['Les effets indirects', 'Alpine et al., 2026, npj Climate Action : un modèle économique dont le résultat dépend du scénario, par des auteurs en campagne.'],
    ['Le contre-argument', 'Ren et al., 2024, Scientific Reports : l’IA écrirait pour 40 à 150 fois moins qu’un humain. La comptabilité humaine y est contestable.']
  ];
</script>

<div class="visuel etudes">
  <ol class="liste">
    {#each ETUDES as s, i}
      <li style="animation-delay: {i * 80}ms">
        <span class="an">{s.an}</span>
        <div>
          <span class="aut">{s.a}</span> · <span class="tit">{s.t}</span> · <span class="rev">{s.r}</span> <span class="m">[ {s.m} ]</span>
          <p>{s.q}</p>
        </div>
      </li>
    {/each}
  </ol>
  <div class="ecartees">
    <span class="et">LAISSÉ DE CÔTÉ, ET POURQUOI</span>
    {#each ECARTEES as [t, q]}
      <p><strong>{t}.</strong> {q}</p>
    {/each}
  </div>
</div>

<style>
  .etudes { display: flex; flex-direction: column; gap: 0.8em; }
  .liste { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; }
  .liste li { display: grid; grid-template-columns: 3em 1fr; gap: 0.7em; padding: 0.45em 0; border-bottom: 1px solid var(--dk-filet); margin: 0; font-size: 0.82em; line-height: 1.35; animation: fondu 0.5s both; }
  .liste li:first-child { border-top: 2px solid var(--dk-encre); }
  .an { font-weight: 600; color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .aut { font-weight: 600; }
  .tit { font-style: italic; }
  .rev { color: var(--dk-gris); }
  .m { font-size: 0.72em; letter-spacing: 0.12em; font-weight: 600; color: var(--dk-accent); white-space: nowrap; }
  .liste p { margin: 0.1em 0 0; font-size: 0.92em; color: var(--dk-gris); }
  .ecartees { border-left: 0.34em solid var(--dk-filet); padding-left: 0.8em; display: flex; flex-direction: column; gap: 0.25em; }
  .et { font-size: 0.56em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); margin-bottom: 0.2em; }
  .ecartees p { margin: 0; font-size: 0.7em; line-height: 1.4; color: var(--dk-gris); }
  .ecartees strong { color: var(--dk-encre); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
