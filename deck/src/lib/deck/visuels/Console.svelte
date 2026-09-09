<script>
  /**
   * La console de R, pilotée au clic. Chaque temps révèle une commande et
   * la réponse de R, exactement comme la salle la verra sur son propre
   * écran. Les sorties ne sont pas tapées à la main : elles viennent d'un
   * vrai R 4.6 (outils/swiss_data.R et la préparation de la séance), sinon
   * on montre un résultat qui n'existe pas.
   *
   *   lignes  — [{ in: 'commande', out: 'réponse' | '' , note: 'aparté' }]
   *   tout    — true : tout est visible d'emblée, sans temps (diapo de rappel)
   *   legende — texte sous la console, facultatif
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  let { lignes = [], tout = false, legende = '', petit = false } = $props();

  let e = $state(0);
  let hote = $state(null);
  const visibles = $derived(tout ? lignes.length : e);
  $effect(() => {
    if (!hote || tout) return;
    e = 0;
    return brancherTemps(hote, { total: lignes.length, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<!-- Pas de fausse fenêtre: un bloc de code du deck (papier grisé, filet
     d'encre, règle rouge à gauche), le chevron de R en tête de chaque ligne.
     Imiter Positron, c'est faire un dessin laid d'une chose que la salle a
     sous les yeux; on montre seulement ce qui se tape et ce qui répond. -->
<div class="visuel console" class:petit bind:this={hote}>
  <div class="corps">
    {#each lignes as l, i}
      <div class="paire" class:vu={i < visibles}>
        <pre class="in"><span class="prompt">&gt;</span> {@html surlignerR(l.in)}</pre>
        {#if l.out}<pre class="out">{l.out}</pre>{/if}
        {#if l.note}<p class="note">{l.note}</p>{/if}
      </div>
    {/each}
    {#if visibles < lignes.length}
      <pre class="in attente"><span class="prompt">&gt;</span> <b class="curseur">▍</b></pre>
    {/if}
  </div>
  {#if legende}<p class="legende">{legende}</p>{/if}
</div>

<style>
  .console { display: flex; flex-direction: column; gap: 0.5em; }
  .corps { background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.7em 0.9em 0.75em; display: flex; flex-direction: column; gap: 0.3em; min-height: 6em; }
  .paire { display: none; flex-direction: column; gap: 0.1em; animation: fondu 0.3s both; }
  .paire.vu { display: flex; }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.5; white-space: pre; overflow-x: auto; }
  .petit pre { font-size: 0.8em; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  .note { margin: 0.1em 0 0.3em 1.1em; font-size: 0.72em; color: var(--dk-accent); font-weight: 600; }
  .attente .curseur { color: var(--dk-accent); animation: clignote 1s steps(1) infinite; font-weight: 400; }
  @keyframes clignote { 50% { opacity: 0; } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.2em); } to { opacity: 1; transform: none; } }
  .legende { margin: 0; font-size: 0.82em; color: var(--dk-gris); }
</style>
