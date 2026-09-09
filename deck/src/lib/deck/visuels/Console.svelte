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

<div class="visuel console" class:petit bind:this={hote}>
  <div class="fenetre">
    <div class="barre"><span></span><span></span><span></span><em>Console · R</em></div>
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
  </div>
  {#if legende}<p class="legende">{legende}</p>{/if}
</div>

<style>
  .console { display: flex; flex-direction: column; gap: 0.5em; }
  .fenetre { border: 3px solid var(--dk-encre); background: var(--dk-fond); }
  .barre { display: flex; align-items: center; gap: 0.4em; padding: 0.35em 0.7em; border-bottom: 2px solid var(--dk-encre); background: var(--dk-fond-2); }
  .barre span { width: 0.6em; height: 0.6em; border: 2px solid var(--dk-encre); }
  .barre em { margin-left: 0.6em; font-style: normal; font-size: 0.6em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); }
  .corps { padding: 0.5em 0.9em 0.6em; display: flex; flex-direction: column; gap: 0.25em; min-height: 6em; }
  .paire { display: none; flex-direction: column; gap: 0.1em; animation: fondu 0.3s both; }
  .paire.vu { display: flex; }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 0.88em; line-height: 1.5; white-space: pre; overflow-x: auto; }
  .petit pre { font-size: 0.72em; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  .note { margin: 0.1em 0 0.3em 1.1em; font-size: 0.72em; color: var(--dk-accent); font-weight: 600; }
  .attente .curseur { color: var(--dk-accent); animation: clignote 1s steps(1) infinite; font-weight: 400; }
  @keyframes clignote { 50% { opacity: 0; } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.2em); } to { opacity: 1; transform: none; } }
  .legende { margin: 0; font-size: 0.82em; color: var(--dk-gris); }
</style>
