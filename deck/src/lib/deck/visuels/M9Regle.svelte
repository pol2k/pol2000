<script>
  /**
   * La règle du cours sur l'IA générative, telle que le plan de cours
   * l'énonce : permis pour le code, à condition de le déclarer; non permis
   * pour l'interprétation et la rédaction; et la question qui tranche tout.
   * Trois temps : permis, non permis, la question.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel m9r" bind:this={hote}>
  <div class="m9r-deux">
    <div class="m9r-col ok" class:vu={e >= 1}>
      <span class="m9r-et">Permis, à condition de le déclarer</span>
      <ul>
        <li>écrire du code R</li>
        <li>comprendre du code R</li>
        <li>déboguer du code R</li>
      </ul>
    </div>
    <div class="m9r-col non" class:vu={e >= 2}>
      <span class="m9r-et">Non permis</span>
      <ul>
        <li>interpréter vos résultats</li>
        <li>rédiger vos travaux</li>
      </ul>
      <p class="m9r-pq">Ce que vous affirmez, vous devez pouvoir le défendre.</p>
    </div>
  </div>
  <p class="m9r-q" class:vu={e >= 3}>« L’aurais-je accepté d’un assistant humain sans vérifier son travail ? »</p>
</div>

<style>
  .m9r { display: flex; flex-direction: column; gap: 1.4em; max-width: 60em; margin: 1em auto 0; }
  .m9r-deux { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; }
  .m9r-col { border: 3px solid var(--dk-encre); padding: 1em 1.3em 1.1em; display: flex; flex-direction: column; gap: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .m9r-col.non { border-color: var(--dk-accent); }
  .m9r-col.vu { opacity: 1; transform: none; }
  .m9r-et { font-size: 0.7em; letter-spacing: 0.12em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m9r-col.non .m9r-et { color: var(--dk-accent); }
  .m9r-col ul { margin: 0; padding-left: 1.1em; font-size: 1.05em; line-height: 1.5; }
  .m9r-pq { margin: 0.2em 0 0; font-size: 0.8em; color: var(--dk-gris); }
  .m9r-q { margin: 0; font-size: 1.6em; line-height: 1.3; font-weight: 700; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.5s; }
  .m9r-q.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m9r-col, .m9r-q { transition: none; } }
</style>
