<script>
  /**
   * Un sujet, une question, une question testable: trois bandes de plus en
   * plus étroites. Ce qui se resserre, c'est ce qu'il reste à décider.
   */
  const ETAGES = [
    { et: 'UN SUJET', t: 'La participation électorale des jeunes.', w: 100, note: 'on en parle' },
    { et: 'UNE QUESTION', t: 'Pourquoi les jeunes votent-ils moins ?', w: 78, note: 'mille réponses' },
    { et: 'UNE QUESTION TESTABLE', t: 'L’âge est-il associé à la probabilité de voter, chez les électeur.rice.s du Québec en 2022 ?', w: 56, note: 'quoi · chez qui · quel lien' }
  ];
</script>

<div class="entonnoir" role="img" aria-label="Du sujet à la question testable, en trois bandes de plus en plus étroites.">
  {#each ETAGES as e, i}
    <div class="etage" style="width: {e.w}%" class:fin={i === 2}>
      <span class="et">{e.et}</span>
      <p>{e.t}</p>
      <span class="note">{e.note}</span>
    </div>
  {/each}
</div>

<style>
  .entonnoir { display: flex; flex-direction: column; align-items: center; gap: 0.35em; }
  .etage { border: 2px solid var(--dk-encre); padding: 0.55em 0.9em 0.5em; display: grid; grid-template-columns: auto 1fr auto; column-gap: 1em; align-items: baseline; background: var(--dk-fond-2); }
  .etage.fin { border-color: var(--dk-accent); border-width: 3px; background: transparent; }
  .et { font-size: 0.56em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); white-space: nowrap; }
  .fin .et { color: var(--dk-accent); }
  .etage p { margin: 0; font-size: 0.92em; line-height: 1.35; }
  .note { font-size: 0.6em; color: var(--dk-gris); white-space: nowrap; }
</style>
