<script module>
  /**
   * TP 1, étape 5 (la pertinence), dans le vrai article : l'affirmation en
   * une phrase en tête de la p. 426, puis le raisonnement qui la justifie,
   * maillon par maillon (« ok, donc ? »). Chaque temps surligne la phrase de
   * l'article et ajoute un maillon à la chaîne de la carte. La carte de M8Fil.
   */
  export const ETATS = [
    { passages: [{ phrase: 'Exploring the winner/loser gap is crucial for the study of democracy.' }] },
    { passages: [{ phrase: 'Democratic contests inevitably produce winners and losers.' }] },
    { passages: [{ phrase: 'The democratic process is based on the premise that losers consent to their loss' }] },
    { passages: [{ phrase: 'Satisfaction with democracy is therefore closely associated with the legitimacy of the political regime.' }] },
    {
      passages: [
        { phrase: 'Elections act as one vehicle to foster legitimacy.' },
        { phrase: 'It seeks to understand to what extent elections contribute to satisfaction (or dissatisfaction) with the performance of the political regime.' }
      ]
    }
  ];
  // La chaîne : un maillon par temps, à partir du temps 1 (texte fixe, rendu en HTML).
  const CHAINE = [
    'Toute élection fait des perdants.',
    'La démocratie repose sur le consentement des perdants.',
    'La satisfaction va de pair avec la légitimité du régime.',
    'L’écart gagnants‑perdants dit si les élections bâtissent la légitimité.'
  ];
</script>

<script>
  // e : le temps de cette étape (0 = son premier passage). M8Fil.
  let { e = 0 } = $props();
</script>

{#if e === 0}
  <span class="m8n-eti">La consigne</span>
  <p class="m8n-consigne">Justifiez la pertinence et l’originalité de votre question.</p>
  <span class="m8n-eti">En une phrase · p.&nbsp;426</span>
  <p class="m8n-grand">Étudier l’écart gagnants‑perdants est crucial pour la démocratie.</p>
{:else}
  <span class="m8n-eti">Leur justification · p.&nbsp;426</span>
  <ol class="m8n-chaine">
    {#each CHAINE.slice(0, e) as m, i}
      {#if i}
        <li class="m8n-fleche" class:on={i === e - 1} aria-hidden="true">
          <svg viewBox="0 0 20 22" width="0.7em" height="0.77em"><line x1="10" y1="1" x2="10" y2="14" /><polygon points="4,12 16,12 10,21" /></svg>
        </li>
      {/if}
      <li class="m8n-maillon" class:on={i === e - 1}>
        {#if i === CHAINE.length - 1}<span class="m8n-donc">Donc</span>{/if}
        <span>{m}</span>
      </li>
    {/each}
  </ol>
{/if}

<style>
  .m8n-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-consigne { margin: 0 0 0.4em; font-size: 0.85em; line-height: 1.4; font-style: italic; color: var(--dk-gris); }
  .m8n-grand { margin: 0; font-size: 1.35em; font-weight: 700; line-height: 1.3; }

  .m8n-chaine { list-style: none; margin: 0.1em 0 0; padding: 0; display: flex; flex-direction: column; align-items: stretch; }
  .m8n-maillon { display: flex; flex-direction: column; gap: 0.15em; padding: 0.3em 0.6em; border: 2px solid var(--dk-filet); font-size: 0.7em; line-height: 1.3; color: var(--dk-gris); }
  .m8n-maillon.on { padding: 0.45em 0.65em; border-color: var(--dk-accent); color: var(--dk-encre); font-size: 0.95em; font-weight: 700; animation: m8n-entre 0.45s ease-out 1.1s both; }
  .m8n-donc { font-size: 0.68em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 700; color: var(--dk-accent); }
  .m8n-fleche { display: flex; justify-content: center; padding: 0.1em 0; }
  .m8n-fleche svg { display: block; }
  .m8n-fleche line { stroke: var(--dk-gris); stroke-width: 2; }
  .m8n-fleche polygon { fill: var(--dk-gris); }
  .m8n-fleche.on line { stroke: var(--dk-accent); }
  .m8n-fleche.on polygon { fill: var(--dk-accent); }
  .m8n-fleche.on { animation: m8n-entre 0.35s ease-out 0.95s both; }
  @keyframes m8n-entre { from { opacity: 0; transform: translateY(-6px); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m8n-maillon.on, .m8n-fleche.on { animation: none; }
  }
</style>
