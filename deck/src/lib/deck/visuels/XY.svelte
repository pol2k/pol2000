<script>
  /**
   * Une question de recherche quantitative, c'est au minimum un X et un Y.
   * Trois temps: un « ? » seul; X apparaît; la flèche et Y. Puis la nuance:
   * une question peut aussi être descriptive — un Y seul, qu'on décrit sans
   * chercher à l'expliquer. Elle est vraie, mais elle n'est pas le cœur du
   * cours.
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

<div class="visuel xy" bind:this={hote}>
  <div class="scene">
    <div class="boite x" class:vu={e >= 1}>
      <span class="lettre">X</span>
      <strong>la variable indépendante</strong>
      <small>ce qui, selon nous, explique</small>
      <em>l'âge</em>
    </div>
    <div class="fl" class:vu={e >= 2}>→</div>
    <div class="boite y" class:vu={e >= 2}>
      <span class="lettre">Y</span>
      <strong>la variable dépendante</strong>
      <small>ce qu'on veut expliquer</small>
      <em>voter, ou non</em>
    </div>
    <div class="q" class:vu={e === 0}>?</div>
  </div>
  <p class="lead" class:vu={e >= 2}>Une question de recherche <strong>quantitative</strong>, c'est très au minimum un X et un Y.</p>
  <p class="nuance" class:vu={e === 3}>Et une question seulement <strong>descriptive</strong> ? « Combien de jeunes votent ? » — un Y, sans X. Elle existe, elle est utile. Mais dès qu'on veut <em>expliquer</em>, il faut un X.</p>
</div>

<style>
  .xy { display: flex; flex-direction: column; gap: 0.8em; align-items: center; }
  .scene { position: relative; display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.4em; align-items: center; width: 100%; min-height: 11em; }
  .boite { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.15em; border: 3px solid var(--dk-encre); padding: 1.1em 1em; opacity: 0; transform: translateY(0.6em); transition: opacity 0.5s, transform 0.5s; }
  .boite.vu { opacity: 1; transform: none; }
  .boite.y { border-color: var(--dk-accent); }
  .lettre { font-family: var(--dk-mono); font-size: 5.5em; line-height: 1; font-weight: 600; }
  .y .lettre { color: var(--dk-accent); }
  .boite strong { font-size: 1.1em; }
  .boite small { font-size: 0.75em; color: var(--dk-gris); }
  .boite em { font-size: 0.9em; color: var(--dk-accent); font-style: normal; font-weight: 600; margin-top: 0.4em; }
  .fl { font-size: 4.5em; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.2s; }
  .fl.vu { opacity: 1; }
  .q { position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-family: var(--dk-mono); font-size: 7em; font-weight: 600; color: var(--dk-gris-2); opacity: 0; transition: opacity 0.4s; pointer-events: none; }
  .q.vu { opacity: 1; }
  .lead { margin: 0; font-size: 1.25em; text-align: center; opacity: 0; transition: opacity 0.5s; }
  .lead.vu { opacity: 1; }
  .nuance { margin: 0; font-size: 0.9em; color: var(--dk-gris); text-align: center; max-width: 36em; opacity: 0; transition: opacity 0.5s; }
  .nuance.vu { opacity: 1; }
  .nuance strong, .nuance em { color: var(--dk-encre); }
</style>
