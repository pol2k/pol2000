<script>
  /**
   * Un vrai exercice R, exécutable dans la page, dans un cadre de terminal
   * encre. Le widget est DataCamp Light, le même que dans le deck; le
   * script est injecté une fois, au montage, et repère le bloc tout seul.
   * Sans réseau, le cadre reste vide: c'est un outil en ligne.
   */
  import { DEVOIRS, LIENS, SEANCES, EVALUATIONS } from '$lib/data/cours.js';
  import { courte } from './dates.js';
  const parNumero = new Map(DEVOIRS.map((d) => [d.seance, d]));
  const dc1 = EVALUATIONS.find((e) => e.id === 'datacamp1');
  const dc2 = EVALUATIONS.find((e) => e.id === 'datacamp2');
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
      <span class="droite">un chapitre par semaine · 10 % de la note</span>
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

  <div class="devoirs">
    <div class="entete">
      <h4>Un chapitre par séance, dans cet ordre</h4>
      {#if LIENS.datacampClasse}
        <a class="bouton plein" href={LIENS.datacampClasse} rel="noopener">Rejoindre la classe <span class="fl">→</span></a>
      {:else}
        <span class="etiq gris">lien vers la classe à venir</span>
      {/if}
    </div>
    <ol>
      {#each SEANCES as s}
        {#if s.lecture}
          <li class="creux"><span class="n">—</span><span class="date">{courte(s.date)}</span><span class="quoi">Semaine de lecture · rien à faire</span></li>
        {:else}
          {@const d = parNumero.get(s.n)}
          <li class:creux={!d}>
            <span class="n">{s.n}</span>
            <span class="date">{courte(s.date)}</span>
            {#if d}
              <a class="quoi" href={d.url} rel="noopener"><strong>{d.cours}</strong><span class="chap">{d.chapitre}</span></a>
            {:else}
              <span class="quoi">{s.partie === 0 ? 'Rencontres individuelles · rien de nouveau' : 'Rien de nouveau : on termine'}</span>
            {/if}
          </li>
          {#if s.n === 8}
            <li class="jalon"><span class="n"></span><span class="date">{courte(dc1.date)}</span><span class="quoi">1re partie remise : les séances 1 à 8 · {dc1.poids} %</span></li>
          {/if}
          {#if s.n === 14}
            <li class="jalon"><span class="n"></span><span class="date">{courte(dc2.date)}</span><span class="quoi">Tout remis, 1re partie comprise · {dc2.poids} %</span></li>
          {/if}
        {/if}
      {/each}
    </ol>
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
  .devoirs { display: flex; flex-direction: column; gap: 0.8rem; }
  .entete { display: flex; align-items: center; justify-content: space-between; gap: 1rem; flex-wrap: wrap; }
  h4 { font-size: 0.66rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--gris); font-weight: 500; }
  ol { list-style: none; border-top: var(--trait); }
  li { display: grid; grid-template-columns: 2.2rem 5.2rem minmax(0, 1fr); gap: 0.4rem 1rem; align-items: baseline; padding: 0.55rem 0; border-bottom: 1px solid var(--filet); font-size: 0.86rem; }
  li .n { font-weight: 600; color: var(--accent); font-variant-numeric: tabular-nums; }
  li .date { color: var(--gris); font-size: 0.74rem; white-space: nowrap; }
  li .quoi { display: flex; flex-wrap: wrap; gap: 0.2rem 0.8rem; color: var(--encre); text-decoration: none; min-width: 0; }
  li a.quoi:hover strong { color: var(--accent); }
  li .chap { color: var(--gris); }
  li.creux .quoi, li.creux .n { color: var(--gris-2); }
  li.jalon { background: var(--encre); color: var(--fond); padding: 0.55rem 0.6rem; margin: 0.2rem 0; border-bottom: 0; }
  li.jalon .date { color: var(--accent-clair); font-weight: 600; }
  li.jalon .quoi { color: var(--fond); }
  @media (max-width: 52rem) { .tete .droite { display: none; } li { grid-template-columns: 2rem minmax(0, 1fr); } li .date { grid-column: 2; } li .quoi { grid-column: 2; } }
</style>
