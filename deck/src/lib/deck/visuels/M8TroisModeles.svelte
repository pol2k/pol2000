<script>
  /**
   * Les trois modèles de Blais et Gélineau en 2025, d'un coup, avant de
   * coder en direct (demande du professeur). Une ligne par modèle; chacun
   * ajoute une seule variable (en rouge) à celui d'avant.
   *
   *   0  modèle 1 : l'écart brut;
   *   1  modèle 2 : leur modèle (vérifier);
   *   2  modèle 3 : le nôtre, avec le vote de 2021 (faire mieux, leur
   *      note 1).
   *
   * Le code complet, étape par étape, est en annexe de la séance.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const MODELES = [
    { nom: 'L’écart brut', base: 'apres ~ gagnant', ajout: '', q: `Les gagnants sont-ils plus satisfaits après l’élection${N}?` },
    { nom: 'Leur modèle', role: 'vérifier', base: 'apres ~ gagnant', ajout: ' + avant', q: '… à satisfaction égale avant l’élection' },
    { nom: 'Le nôtre', role: 'faire mieux', base: 'apres ~ gagnant + avant', ajout: ' + gagnant_2021', q: '… et à vote de 2021 égal (leur note 1)' }
  ];
</script>

<div class="visuel m8m" bind:this={hote}>
  {#each MODELES as m, i}
    <div class="m8m-ligne" class:vu={e >= i} class:ici={e === i}>
      <div class="m8m-nom">
        <span class="m8m-n">Modèle {i + 1}</span>
        <strong>{m.nom}</strong>
        {#if m.role}<span class="m8m-role">{m.role}</span>{/if}
      </div>
      <code class="m8m-f">lm({m.base}<span class="m8m-ajout">{m.ajout}</span>)</code>
      <p class="m8m-q">{m.q}</p>
    </div>
  {/each}
  <p class="m8m-y">Y = apres, la satisfaction après l’élection · X = gagnant</p>
</div>

<style>
  .m8m { max-width: 64em; margin: 1em auto 0; display: flex; flex-direction: column; gap: 0.9em; }
  .m8m-ligne { display: grid; grid-template-columns: 11em minmax(0, 1fr); grid-template-rows: auto auto; column-gap: 1.4em; row-gap: 0.25em; align-items: baseline; border-left: 8px solid var(--dk-filet); padding: 0.55em 0 0.55em 1em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s, border-color 0.4s; }
  .m8m-ligne.vu { opacity: 1; transform: none; }
  .m8m-ligne.ici { border-left-color: var(--dk-accent); }
  .m8m-nom { grid-row: 1 / span 2; display: flex; flex-direction: column; gap: 0.1em; }
  .m8m-n { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8m-nom strong { font-size: 1.25em; line-height: 1.2; }
  .m8m-role { font-size: 0.75em; font-weight: 600; color: var(--dk-accent); }
  .m8m-f { font-family: var(--dk-mono); font-size: 1.1em; font-weight: 600; white-space: nowrap; }
  .m8m-ajout { color: var(--dk-accent); }
  .m8m-q { margin: 0; font-size: 0.9em; color: var(--dk-gris); }
  .m8m-y { margin: 0.4em 0 0; font-size: 0.7em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m8m-ligne { transition: none; } }
</style>
