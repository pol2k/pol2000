<script>
  /**
   * Une requête, c'est presque rien. Ce qui compte : ce que le chiffre laisse
   * de côté, la croissance et l'endroit. (REQUETE, ENERGIE,
   * $lib/data/ia_environnement.js.)
   *
   *   0  une requête texte : 0,24 Wh et 0,26 mL, avec les comparaisons de Google;
   *   1  ce que le chiffre laisse de côté;
   *   2  le vrai enjeu : la croissance et l'endroit.
   */
  import { brancherTemps } from '../temps.js';
  import { REQUETE as R, ENERGIE } from '$lib/data/ia_environnement.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => v.toString().replace('.', ',');
  const CD = ENERGIE.find((d) => d.cle === 'cd');
</script>

<div class="visuel m9r9" bind:this={hote}>
  <div class="m9r9-haut">
    <div class="m9r9-tuile">
      <svg viewBox="0 0 60 80" aria-hidden="true"><path d="M 34 4 L 10 46 L 28 46 L 22 76 L 50 30 L 32 30 Z" class="m9r9-plein" /></svg>
      <strong>{f(R.wh)} Wh</strong>
      <span>{R.tele}</span>
    </div>
    <div class="m9r9-tuile">
      <svg viewBox="0 0 60 80" aria-hidden="true"><path d="M 30 6 Q 52 40 50 54 A 20 20 0 0 1 10 54 Q 8 40 30 6 Z" class="m9r9-plein" /></svg>
      <strong>{f(R.ml)} mL</strong>
      <span>{R.gouttes}</span>
    </div>
    <div class="m9r9-cote" class:vu={e >= 1}>
      <span class="m9r9-tag">pas compté</span>
      {#each R.exclu as x}<span class="m9r9-x">{x}</span>{/each}
    </div>
  </div>
  <div class="m9r9-bas" class:vu={e >= 2}>
    <div class="m9r9-enjeu">
      <span class="m9r9-tag rouge">la croissance</span>
      <strong>{CD.twh} → {CD.en2030} TWh</strong>
      <span>centres de données, de 2024 à 2030</span>
    </div>
    <div class="m9r9-enjeu">
      <span class="m9r9-tag rouge">l’endroit</span>
      <strong>une ville</strong>
      <span>un centre de données pèse sur un réseau et une rivière, comme à Memphis</span>
    </div>
  </div>
  <p class="credits">Requête texte médiane à Gemini, mesurée par Google en mai 2025 (arXiv 2508.15734), non vérifiée par un tiers. Croissance : AIE, Energy and AI (2025).</p>
</div>

<style>
  .m9r9 { display: flex; flex-direction: column; gap: 1em; max-width: 60em; margin: 0.4em auto 0; }
  .m9r9-haut { display: grid; grid-template-columns: 1fr 1fr 1.3fr; gap: 1.2em; align-items: stretch; }
  .m9r9-tuile { border: 3px solid var(--dk-encre); padding: 0.9em; display: flex; flex-direction: column; align-items: center; gap: 0.3em; text-align: center; }
  .m9r9-tuile svg { height: 4.5em; width: auto; }
  .m9r9-plein { fill: var(--dk-encre); }
  .m9r9-tuile strong { font-size: 2em; line-height: 1.1; }
  .m9r9-tuile span { font-size: 0.85em; color: var(--dk-gris); }
  .m9r9-cote { border: 3px dashed var(--dk-gris); padding: 0.9em; display: flex; flex-direction: column; gap: 0.45em; justify-content: center; opacity: 0; transition: opacity 0.4s; }
  .m9r9-x { font-size: 0.95em; font-weight: 600; }
  .m9r9-x::before { content: '✕ '; color: var(--dk-accent); font-weight: 800; }
  .m9r9-tag { align-self: flex-start; font-size: 0.72em; font-weight: 800; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); }
  .m9r9-tag.rouge { color: var(--dk-accent); }
  .m9r9-bas { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2em; opacity: 0; transition: opacity 0.4s; }
  .m9r9-enjeu { border: 3px solid var(--dk-accent); padding: 0.8em 1em; display: flex; flex-direction: column; gap: 0.25em; }
  .m9r9-enjeu strong { font-size: 1.6em; color: var(--dk-accent); }
  .m9r9-enjeu span:last-child { font-size: 0.85em; }
  .m9r9-cote.vu, .m9r9-bas.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m9r9-cote, .m9r9-bas { transition: none; } }
</style>
