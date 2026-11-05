<script>
  /**
   * Comment savoir si une échelle est bonne ? Deux critères, deux façons
   * de les prouver. Au clic :
   *
   *   1  la fiabilité : les questions vont-elles ensemble ? Statistique;
   *   2  la validité : mesure-t-on le bon concept ? Théorique;
   *   3  il faut les deux.
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

<div class="visuel m9q" bind:this={hote}>
  <div class="m9q-deux">
    <div class="m9q-col" class:vu={e >= 1}>
      <strong class="m9q-nom">Fiabilité</strong>
      <span class="m9q-q">Les questions mesurent-elles la même chose ?</span>
      <span class="m9q-type">statistique</span>
      <svg viewBox="0 0 200 90" aria-hidden="true">
        {#each [[20, 70], [44, 58], [70, 52], [96, 40], [120, 34], [148, 22], [176, 14]] as [cx, cy]}
          <circle {cx} {cy} r="7" class="m9q-pt" />
        {/each}
        <line x1="14" y1="76" x2="186" y2="10" class="m9q-l" />
      </svg>
      <span class="m9q-preuve">On la prouve avec des <b>chiffres</b>.</span>
    </div>
    <div class="m9q-col" class:vu={e >= 2}>
      <strong class="m9q-nom">Validité</strong>
      <span class="m9q-q">Mesure-t-on le bon concept ?</span>
      <span class="m9q-type">théorique</span>
      <svg viewBox="0 0 200 90" aria-hidden="true">
        <rect x="36" y="8" width="128" height="74" class="m9q-livre" />
        <line x1="100" y1="8" x2="100" y2="82" class="m9q-livre" />
        {#each [24, 38, 52, 66] as y}
          <line x1="48" y1={y} x2="90" y2={y} class="m9q-ligne" />
          <line x1="110" y1={y} x2="152" y2={y} class="m9q-ligne" />
        {/each}
      </svg>
      <span class="m9q-preuve">On la prouve avec la <b>théorie</b>.</span>
    </div>
  </div>
  <p class="m9q-phrase" class:vu={e >= 3}>Pour un concept difficile à mesurer, il faut <strong>les deux</strong>.</p>
</div>

<style>
  .m9q { display: flex; flex-direction: column; gap: 1.4em; max-width: 50em; margin: 0.6em auto 0; }
  .m9q-deux { display: grid; grid-template-columns: 1fr 1fr; gap: 2.4em; }
  .m9q-col { border: 3px solid var(--dk-encre); padding: 1.2em; display: flex; flex-direction: column; align-items: center; gap: 0.45em; text-align: center; opacity: 0; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s; }
  .m9q-col.vu { opacity: 1; transform: none; }
  .m9q-nom { font-size: 1.7em; }
  .m9q-q { font-size: 0.95em; min-height: 2.6em; }
  .m9q-type { font-size: 0.8em; font-weight: 700; letter-spacing: 0.14em; text-transform: uppercase; color: #fff; background: var(--dk-accent); padding: 0.15em 0.6em; }
  svg { width: 70%; height: auto; max-height: 14vh; display: block; margin: 0.3em 0; }
  .m9q-pt { fill: var(--dk-encre); }
  .m9q-l { stroke: var(--dk-accent); stroke-width: 3; }
  .m9q-livre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .m9q-ligne { stroke: var(--dk-gris); stroke-width: 4; stroke-linecap: round; }
  .m9q-preuve { font-size: 1.05em; }
  .m9q-preuve b { color: var(--dk-accent); }
  .m9q-phrase { margin: 0; text-align: center; font-size: 1.4em; opacity: 0; transition: opacity 0.5s; }
  .m9q-phrase strong { color: var(--dk-accent); }
  .m9q-phrase.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m9q-col, .m9q-phrase { transition: none; } }
</style>
