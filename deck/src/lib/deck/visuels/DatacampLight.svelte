<script>
  /**
   * Un vrai exercice Datacamp, exécutable dans la diapo — le même widget
   * (DataCamp Light) que sur pol2000.com. Le script est injecté une seule
   * fois; il repère les blocs data-datacamp-exercise au chargement. Le jeu
   * de données est fourni avec R: `presidents`, la cote d'approbation
   * trimestrielle des présidents américains, 1945-1974 (vérifié: Run
   * l'affiche, mean() donne 56,3). Le premier Run montre les données, pour
   * qu'on voie tout de suite que ça marche. Datacamp perd les accents dans
   * les messages du SCT: on les écrit en \u. Sans réseau, le cadre reste
   * vide: c'est un outil en ligne.
   */
  import { base } from '$app/paths';
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

<div class="visuel dcl" bind:this={hote}>
  <div class="entete">
    <img src="{base}/img/datacamp.png" alt="Datacamp" class="logo" />
    <div>
      <strong>Un exercice par semaine, chez vous. Comme celui-ci.</strong>
      <span>Gratuit pour le cours · corrigé sur-le-champ · 10 % de la note · essayez-le maintenant : Run</span>
    </div>
  </div>
  <div class="exercice">
    <div data-datacamp-exercise data-lang="r" data-height="380" data-show-run-button="true">
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
  <div class="semaines">
    {#each Array.from({ length: 14 }) as _, k}<i class:jalon={k === 7 || k === 13}></i>{/each}
    <span class="j1">dim. 25 oct. · 5 %</span><span class="j2">ven. 18 déc. · 5 %</span>
  </div>
</div>

<style>
  .dcl { display: flex; flex-direction: column; gap: 0.7em; }
  .entete { display: flex; align-items: center; gap: 1em; }
  .logo { height: 3.2em; width: 3.2em; border: 2px solid var(--dk-encre); }
  .entete strong { display: block; font-size: 1.1em; }
  .entete span { font-size: 0.78em; color: var(--dk-gris); }
  .exercice { border: 3px solid var(--dk-encre); background: #fff; }
  .exercice :global(.datacamp-exercise) { font-family: var(--dk-mono); }
  .semaines { position: relative; display: flex; gap: 0.3em; padding-bottom: 1.4em; }
  .semaines i { flex: 1; height: 0.8em; background: var(--dk-gris-2); }
  .semaines i.jalon { background: var(--dk-accent); }
  .semaines span { position: absolute; top: 1.1em; font-size: 0.62em; color: var(--dk-accent); font-weight: 600; }
  .j1 { left: 50%; transform: translateX(-50%); } .j2 { right: 0; }
</style>
