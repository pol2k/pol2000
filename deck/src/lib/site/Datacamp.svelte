<script>
  /**
   * Un vrai exercice R, exécutable dans la page, dans un cadre de terminal
   * encre. Le widget est DataCamp Light, le même que dans le deck; le
   * script est injecté une fois, au montage, et repère le bloc tout seul.
   * Sans réseau, le cadre reste vide: c'est un outil en ligne.
   */
  import { DATACAMP, LIENS } from '$lib/data/cours.js';
  const SRC = 'https://cdn.datacamp.com/datacamp-light-latest.min.js';
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    if (!document.querySelector(`script[src="${SRC}"]`)) {
      const s = document.createElement('script'); s.src = SRC; s.async = true; document.head.appendChild(s);
    } else if (window.initAddedDCLightExercises) {
      window.initAddedDCLightExercises();
    }
  });
</script>

<div class="dc" bind:this={hote}>
  <div class="terminal">
    <div class="tete">
      <span class="pastilles"><i></i><i></i><i></i></span>
      <span class="titre">datacamp · R · essayez-le : Run</span>
      <span class="droite">un exercice par semaine · 10 % de la note</span>
    </div>
    <div class="exercice">
      <div data-datacamp-exercise data-lang="r" data-height="360" data-show-run-button="true">
        <code data-type="pre-exercise-code">data(presidents)</code>
        <code data-type="sample-code"># `presidents` : la cote d'approbation des présidents américains,
# chaque trimestre, de 1945 à 1974. Cliquez Run pour la voir.
presidents

# À vous : calculez la cote moyenne avec mean().
# Il y a des valeurs manquantes (NA) : ajoutez na.rm = TRUE.
</code>
        <code data-type="solution">presidents
mean(presidents, na.rm = TRUE)</code>
        <code data-type="sct">test_function("mean", args = c("x", "na.rm"))
success_msg("Bravo ! Votre premier calcul en R, sur de vraies donn&amp;eacute;es politiques.")</code>
      </div>
    </div>
  </div>

  <div class="bas">
    <div class="jalons">
      <div class="semaines">
        {#each Array.from({ length: 14 }) as _, k}<i class:jalon={k === 7 || k === 13}></i>{/each}
      </div>
      <div class="dates"><span><strong>dim. 25 oct.</strong> · 1re partie · 5 %</span><span><strong>ven. 18 déc.</strong> · 1re + 2e partie · 5 %</span></div>
      <p>Des devoirs obligatoires chaque semaine. Pour la totalité des points, tous les devoirs de la période doivent être faits à l'échéance.</p>
      {#if LIENS.datacampClasse}
        <a class="bouton plein" href={LIENS.datacampClasse} rel="noopener">Rejoindre la classe <span class="fl">→</span></a>
      {:else}
        <span class="etiq gris">lien vers la classe à venir</span>
      {/if}
    </div>
    <div class="cours">
      {#each DATACAMP as g}
        <div>
          <h4>{g.groupe}</h4>
          <ul class="cmd">
            {#each g.cours as [nom, url]}<li><a href={url} rel="noopener">{nom}</a></li>{/each}
          </ul>
        </div>
      {/each}
    </div>
  </div>
</div>

<style>
  .dc { display: flex; flex-direction: column; gap: 1.4rem; }
  .terminal { border: 3px solid var(--encre); }
  .tete { display: flex; align-items: center; gap: 1rem; background: var(--encre); color: var(--fond); padding: 0.45rem 0.9rem; font-size: 0.66rem; letter-spacing: 0.12em; text-transform: uppercase; }
  .pastilles { display: flex; gap: 0.35rem; }
  .pastilles i { width: 0.6rem; height: 0.6rem; background: var(--fond); opacity: 0.85; }
  .pastilles i:first-child { background: var(--accent-clair); }
  .tete .droite { margin-left: auto; color: var(--gris-2); }
  .exercice { background: #fff; min-height: 360px; }
  .exercice :global(.datacamp-exercise) { font-family: var(--mono); }
  .bas { display: grid; grid-template-columns: 1.1fr 1.6fr; gap: 2rem; align-items: start; }
  .jalons { display: flex; flex-direction: column; gap: 0.6rem; }
  .semaines { display: flex; gap: 0.3rem; }
  .semaines i { flex: 1; height: 0.8rem; background: var(--gris-2); }
  .semaines i.jalon { background: var(--accent); }
  .dates { display: flex; justify-content: space-between; gap: 1rem; font-size: 0.7rem; color: var(--gris); }
  .dates strong { color: var(--accent); }
  .jalons p { font-size: 0.82rem; color: var(--gris); }
  .cours { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2rem; }
  h4 { font-size: 0.66rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--gris); font-weight: 500; margin-bottom: 0.5rem; padding-bottom: 0.4rem; border-bottom: var(--trait); }
  .cours li { font-size: 0.82rem; line-height: 1.4; margin-bottom: 0.3rem; }
  .cours a { color: var(--encre); }
  .cours a:hover { color: var(--accent); }
  @media (max-width: 52rem) { .bas { grid-template-columns: 1fr; } .cours { grid-template-columns: 1fr 1fr; } .tete .droite { display: none; } }
  @media (max-width: 30rem) { .cours { grid-template-columns: 1fr; } }
</style>
