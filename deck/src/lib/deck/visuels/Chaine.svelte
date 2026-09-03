<script>
  /**
   * Opérationnaliser: du concept à la mesure, en trois temps, puis un
   * quatrième pour ce qui se perd à chaque flèche. La règle 0–10 est dessinée
   * avec le « 5 » en évidence: centriste, indifférent, ou mal à l'aise ? Le
   * chiffre ne le dit pas.
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

<div class="visuel chaine" bind:this={hote}>
  <div class="etapes">
    <div class="etape" class:vu={e >= 0}>
      <span class="et">CONCEPT</span>
      <strong>« Être à gauche »</strong>
      <small>une idée, dans une tête</small>
    </div>
    <div class="fl" class:vu={e >= 1}><span>→</span><em class:vu={e === 3}>on perd la nuance</em></div>
    <div class="etape" class:vu={e >= 1}>
      <span class="et">DÉFINITION</span>
      <strong>Se situer soi-même sur un axe gauche-droite</strong>
      <small>ce qu'on accepte de vouloir dire par là</small>
    </div>
    <div class="fl" class:vu={e >= 2}><span>→</span><em class:vu={e === 3}>on perd le contexte</em></div>
    <div class="etape mesure" class:vu={e >= 2}>
      <span class="et">MESURE</span>
      <svg viewBox="0 0 300 90">
        <line x1="20" y1="45" x2="280" y2="45" class="regle" />
        {#each Array.from({ length: 11 }) as _, i}
          <line x1={20 + i * 26} y1="36" x2={20 + i * 26} y2="54" class="regle" />
          <text x={20 + i * 26} y="76" class="tick" class:cinq={i === 5}>{i}</text>
        {/each}
        <circle cx="150" cy="45" r="9" class="point" class:vu={e === 3} />
      </svg>
      <small>une échelle de 0 (gauche) à 10 (droite)</small>
    </div>
  </div>
  <div class="perte" class:vu={e === 3}>
    <strong>Chaque flèche perd quelque chose.</strong>
    <span>Quelqu'un qui répond <b>5</b> : centriste, indifférent, ou mal à l'aise avec la question ? Le chiffre ne le dit pas. Une bonne mesure dit ce qu'elle perd.</span>
  </div>
</div>

<style>
  .chaine { display: flex; flex-direction: column; gap: 1em; }
  .etapes { display: grid; grid-template-columns: 1fr auto 1.2fr auto 1.3fr; gap: 0.8em; align-items: stretch; }
  .etape { border: 3px solid var(--dk-filet); padding: 0.9em 1em; display: flex; flex-direction: column; gap: 0.35em; opacity: 0.15; transform: translateY(0.4em); transition: opacity 0.5s, transform 0.5s; }
  .etape.vu { opacity: 1; transform: none; border-color: var(--dk-encre); }
  .etape.mesure.vu { border-color: var(--dk-accent); }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .mesure .et { color: var(--dk-accent); }
  .etape strong { font-size: 1.15em; line-height: 1.25; }
  .etape small { font-size: 0.72em; color: var(--dk-gris); }
  .fl { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.2em; opacity: 0; transition: opacity 0.4s 0.2s; }
  .fl.vu { opacity: 1; }
  .fl span { font-size: 2em; color: var(--dk-accent); line-height: 1; }
  .fl em { font-size: 0.6em; color: var(--dk-accent); font-style: normal; font-weight: 600; white-space: nowrap; opacity: 0; transition: opacity 0.4s; }
  .fl em.vu { opacity: 1; }
  .mesure svg { width: 100%; height: auto; }
  .regle { stroke: var(--dk-encre); stroke-width: 3; }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.cinq { fill: var(--dk-accent); font-weight: 600; font-size: 20px; }
  .point { fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .point.vu { opacity: 1; }
  .perte { border-left: 6px solid var(--dk-accent); padding: 0.5em 1em; display: flex; flex-direction: column; gap: 0.2em; opacity: 0; transition: opacity 0.5s; }
  .perte.vu { opacity: 1; }
  .perte strong { font-size: 1.2em; }
  .perte span { font-size: 0.88em; color: var(--dk-gris); }
  .perte b { color: var(--dk-accent); }
</style>
