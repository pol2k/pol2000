<script>
  /**
   * Ce qu'on fait d'une réponse d'IA avant de s'en servir : trois
   * vérifications, dans l'ordre, et la question du plan de cours en
   * exergue. Pas de morale : une procédure.
   */
  import Picto from '../Picto.svelte';
  const V = [
    { p: 'eclair', t: 'Ça s’exécute ?', s: 'Collez la ligne, lancez-la. Pas d’erreur, c’est le minimum, pas la preuve.' },
    { p: 'oeil', t: 'Je comprends chaque mot ?', s: 'Une fonction inconnue ? Demandez ce qu’elle fait, ou ?fonction. Sinon vous ne pourrez pas la défendre.' },
    { p: 'loupe', t: 'Le résultat est plausible ?', s: 'nrow() avant et après un filtre. Une moyenne qui a du sens. Un graphique qui ressemble aux données.' }
  ];
</script>

<div class="visuel verifier">
  <p class="question">« L’aurais-je accepté d’un assistant humain sans vérifier son travail ? »</p>
  <div class="trois">
    {#each V as v, i}
      <div class="v" style="animation-delay: {i * 130}ms">
        <span class="pic"><Picto nom={v.p} taille="2.4em" /></span>
        <strong>{v.t}</strong>
        <p>{v.s}</p>
      </div>
    {/each}
  </div>
  <p class="regle">Permis pour écrire, comprendre et déboguer du code, <strong>à condition de le déclarer</strong>. Jamais pour interpréter un résultat ni rédiger un travail.</p>
</div>

<style>
  .verifier { display: flex; flex-direction: column; gap: 1em; }
  .question { margin: 0; font-size: 1.35em; font-weight: 500; line-height: 1.3; border-left: 0.34em solid var(--dk-accent); padding-left: 0.8em; }
  .trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .v { border: 2px solid var(--dk-encre); padding: 1em 1em 0.9em; display: flex; flex-direction: column; gap: 0.3em; animation: fondu 0.5s both; }
  .pic { color: var(--dk-accent); margin-bottom: 0.2em; }
  .v strong { font-size: 1.1em; }
  .v p { margin: 0; font-size: 0.76em; line-height: 1.45; color: var(--dk-gris); }
  .regle { margin: 0; font-size: 0.9em; color: var(--dk-gris); }
  .regle strong { color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
