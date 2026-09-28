<script>
  /**
   * Deux erreurs classiques avec ggplot2, et ce que R répond. Le code et le
   * message viennent d'un vrai Rscript (ERREURS dans src/lib/data/seance5.js,
   * produit par outils/seance5_data.R, sans la trace d'appels) : rien n'est
   * retapé.
   *
   *   0  Le pipe |> à la place du + : le coupable en rouge, la réponse de R,
   *      puis la règle en une ligne.
   *   1  Le + en début de ligne au lieu de la fin : même présentation.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { ERREURS } from '$lib/data/seance5.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le code coupé autour du coupable ; le coupable reste du texte brut, en rouge.
  const couper = (code, i, n) => ({
    avant: surlignerR(code.slice(0, i)),
    coupable: code.slice(i, i + n),
    apres: surlignerR(code.slice(i + n))
  });
  const pipe = ERREURS.pipe.code;
  const ligne = ERREURS.ligne.code;
  const PANNEAUX = [
    { ...couper(pipe, pipe.indexOf('|>'), 2), sortie: ERREURS.pipe.sortie, regle: 'pipe' },
    // Le + fautif : le premier après le saut de ligne.
    { ...couper(ligne, ligne.indexOf('+', ligne.indexOf('\n')), 1), sortie: ERREURS.ligne.sortie, regle: 'ligne' }
  ];
</script>

<div class="visuel erreurs-gg" bind:this={hote}>
  {#each PANNEAUX as p, i}
    <div class="eg-panneau" class:eg-vu={e >= i}>
      <pre class="eg-code">{@html p.avant}<span class="eg-coupable">{p.coupable}</span>{@html p.apres}</pre>
      <pre class="eg-sortie">{p.sortie}</pre>
      <div class="eg-regle">
        {#if p.regle === 'pipe'}
          le <b>+</b> relie les couches de ggplot2, pas <b>|&gt;</b>
        {:else}
          le <b>+</b> va à la fin de la ligne, jamais au début
        {/if}
      </div>
    </div>
  {/each}
</div>

<style>
  .erreurs-gg { display: flex; flex-direction: column; gap: 1.2em; }
  .eg-panneau { display: flex; flex-direction: column; gap: 0.4em; align-items: flex-start; visibility: hidden; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .eg-panneau.eg-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.4s, transform 0.4s; }

  .eg-code { margin: 0; font-family: var(--dk-mono); font-size: 0.8em; line-height: 1.5; white-space: pre; border: 2px solid var(--dk-encre); padding: 0.45em 0.8em; color: var(--dk-encre); background: var(--dk-fond); }
  .eg-coupable { color: var(--dk-accent); font-weight: 700; outline: 0.12em solid var(--dk-accent); outline-offset: 0.08em; }

  /* La réponse de R : bloc de console, papier grisé, règle rouge à gauche. */
  .eg-sortie { margin: 0; font-family: var(--dk-mono); font-size: 0.66em; line-height: 1.45; white-space: pre; background: var(--dk-fond-2); border-left: 0.34em solid var(--dk-accent); padding: 0.5em 0.9em; color: var(--dk-encre); }

  .eg-regle { font-size: 0.85em; line-height: 1.35; color: var(--dk-encre); }
  .eg-regle b { font-weight: 700; }

  @media (prefers-reduced-motion: reduce) {
    .eg-panneau, .eg-panneau.eg-vu { transition: none; transform: none; }
  }
</style>
