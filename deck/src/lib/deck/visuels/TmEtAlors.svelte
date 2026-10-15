<script>
  /**
   * Étape 5 du travail : la pertinence. Le test du « Ok, donc ? » : on
   * énonce sa question, on se fait répondre « Ok, donc ? », on répond, et on
   * recommence. Chaque réponse porte plus loin : de votre question à la
   * science politique, puis à la société. À droite, trois cercles qui
   * s'allument au même rythme. Cinq temps :
   *
   *   0  votre question (l'exemple de la séance);
   *   1  « Ok, donc ? »;
   *   2  ce que la science politique y gagne (cercle du milieu);
   *   3  « Ok, donc ? »;
   *   4  ce que la société y gagne (grand cercle), et la règle : vous tenez
   *      votre pertinence quand vous savez répondre.
   *
   * Les réponses sont des exemples de raisonnement, pas des résultats.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const BULLES = [
    { qui: 'vous', t: 'Je relie la scolarité à l’intérêt pour la politique.' },
    { qui: 'eux', t: 'Ok, donc ?' },
    { qui: 'vous', t: 'On saura qui suit la politique, et qui décroche.' },
    { qui: 'eux', t: 'Ok, donc ?' },
    { qui: 'vous', t: 'Si seul.e.s les diplômé.e.s s’intéressent, la participation devient inégale.' }
  ];
  const CERCLES = [
    { r: 62, t: 'votre question', quand: 0 },
    { r: 118, t: 'la science politique', quand: 2 },
    { r: 174, t: 'la société', quand: 4 }
  ];
</script>

<div class="visuel tm-ea" bind:this={hote}>
  <div class="tm-ea-fil">
    {#each BULLES as b, i}
      <div class="tm-ea-b tm-ea-{b.qui}" class:tm-on={e >= i} class:tm-actif={e === i}>{b.t}</div>
    {/each}
  </div>

  <div class="tm-ea-d">
    <svg viewBox="0 0 360 360" role="img" aria-label="Trois cercles emboîtés : votre question, la science politique, la société.">
      {#each [...CERCLES].reverse() as c}
        <circle cx="180" cy="180" r={c.r} class="tm-ea-c" class:tm-on={e >= c.quand} class:tm-actif={e === c.quand || (c.quand === 4 && e > 4)} />
      {/each}
      {#each CERCLES as c}
        <text x="180" y={180 - c.r + (c.r === 62 ? 66 : c.r === 118 ? 46 : 30)} class="tm-ea-t" class:tm-on={e >= c.quand}>{c.t}</text>
      {/each}
    </svg>
    <p class="tm-ea-regle" class:tm-on={e >= 4}>Vous savez répondre à «&#8239;Ok, donc&#8239;?&#8239;»&#8239;: c’est votre pertinence.</p>
  </div>
</div>

<style>
  .tm-ea { display: grid; grid-template-columns: 1.25fr 1fr; gap: 2em; align-items: center; }
  .tm-ea-fil { display: flex; flex-direction: column; gap: 0.55em; }
  .tm-ea-b { max-width: 85%; font-size: 1em; line-height: 1.35; padding: 0.5em 0.9em; opacity: 0; transform: translateY(0.5em); transition: opacity 0.4s, transform 0.4s; }
  .tm-ea-b.tm-on { opacity: 1; transform: none; }
  .tm-ea-vous { align-self: flex-start; border: 3px solid var(--dk-encre); background: #fff; }
  .tm-ea-b.tm-ea-vous:not(.tm-actif).tm-on { opacity: 0.55; }
  .tm-ea-eux { align-self: flex-end; font-size: 1.6em; font-weight: 600; color: var(--dk-fond); background: var(--dk-accent); padding: 0.2em 0.7em; transform: translateY(0.5em) rotate(2deg); }
  .tm-ea-eux.tm-on { transform: rotate(2deg); }
  .tm-ea-b.tm-ea-eux:not(.tm-actif).tm-on { opacity: 0.55; }

  .tm-ea-d { display: flex; flex-direction: column; align-items: center; gap: 0.6em; }
  .tm-ea-d svg { width: 100%; max-height: 46vh; height: auto; display: block; }
  .tm-ea-c { fill: var(--dk-fond); stroke: var(--dk-filet); stroke-width: 3; transition: stroke 0.4s, fill 0.4s; }
  .tm-ea-c.tm-on { stroke: var(--dk-encre); }
  .tm-ea-c.tm-actif { stroke: var(--dk-accent); stroke-width: 6; }
  .tm-ea-t { font-family: var(--dk-mono); font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris-2); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; transition: fill 0.4s; }
  .tm-ea-t.tm-on { fill: var(--dk-encre); }
  .tm-ea-regle { margin: 0; font-size: 0.95em; font-weight: 600; text-align: center; color: var(--dk-accent); opacity: 0; transition: opacity 0.5s 0.4s; }
  .tm-ea-regle.tm-on { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .tm-ea-b, .tm-ea-c, .tm-ea-t, .tm-ea-regle { transition: none; } }
</style>
