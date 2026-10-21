<script>
  /**
   * Un test, pas une réplication : ce qui change entre Blais (2005) et
   * notre essai sur la CES 2025. Deux colonnes, une ligne par clic.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const LIGNES = [
    { quoi: 'Les données', blais: '11 études électorales empilées, 1965-2004', nous: 'une seule, 2025' },
    { quoi: 'Le vote', blais: 'le vote libéral', nous: 'l’intention de vote, pendant la campagne' },
    { quoi: 'L’origine', blais: 'six groupes d’origine ethnique', nous: 'né.e hors du Canada (en 2025, l’origine est du texte libre)' },
    { quoi: 'La méthode', blais: 'un logit, traduit en « impact »', nous: 'une régression linéaire, × 100' },
    { quoi: 'Pareil', blais: 'l’Ontario et l’Atlantique, sans le Québec', nous: 'idem' }
  ];
</script>

<div class="visuel m8e" bind:this={hote}>
  <div class="ligne tete"><span></span><span>Blais (2005)</span><span class="rouge">Nous (2025)</span></div>
  {#each LIGNES as l, i}
    <div class="ligne" class:vu={e >= i} class:pareil={i === 4}>
      <strong>{l.quoi}</strong><span>{l.blais}</span><span class="nous">{l.nous}</span>
    </div>
  {/each}
</div>

<style>
  .m8e { max-width: 62em; margin: 1em auto 0; display: flex; flex-direction: column; }
  .ligne { display: grid; grid-template-columns: 9em 1fr 1fr; gap: 1.2em; padding: 0.65em 0.4em; border-bottom: 1px solid var(--dk-filet); opacity: 0; transition: opacity 0.4s; font-size: 1.05em; }
  .ligne.vu, .ligne.tete { opacity: 1; }
  .tete { border-bottom: 2px solid var(--dk-encre); font-weight: 600; font-size: 0.9em; letter-spacing: 0.08em; text-transform: uppercase; }
  .rouge, .nous { color: var(--dk-accent); }
  .pareil { color: var(--dk-gris); }
  .pareil .nous { color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .ligne { transition: none; } }
</style>
