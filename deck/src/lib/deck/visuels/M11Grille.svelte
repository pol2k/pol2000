<script>
  /**
   * Le résumé des trois types de chemins (Arel-Bundock 2021, p. 122-123) :
   * fourchette, chaîne, collision, sans contrôle puis en contrôlant le
   * maillon central B. Six petits Goa; chaque verdict est calculé par
   * goa.js. (Le deck de 2024 dessinait, sous « fourchette fermée », une
   * collision contrôlée : ici, la fourchette contrôlée est bien A ← B → C.)
   *
   *   0  la rangée « sans contrôle » : ouvert, ouvert, fermé;
   *   1  la rangée « on contrôle B » : tout s'inverse.
   */
  import { brancherTemps } from '../temps.js';
  import Goa from './Goa.svelte';
  import { GOA } from '$lib/data/seance11-goa.js';

  const COLS = [
    ['Fourchette', GOA.fourchetteABC],
    ['Chaîne', GOA.chaineABC],
    ['Collision', GOA.collisionABC]
  ];
  const ABC = ['A', 'B', 'C'];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel m11g" bind:this={hote}>
  <span></span>
  {#each COLS as [nom] (nom)}<strong class="m11g-col">{nom}</strong>{/each}

  <span class="m11g-ligne">Sans contrôle</span>
  {#each COLS as [nom, g] (nom)}
    <div class="m11g-case"><Goa graphe={g} taille={0.62} temps={[{ chemin: ABC, court: true }]} /></div>
  {/each}

  <span class="m11g-ligne m11g-etape" class:vu={e >= 1}>On contrôle B</span>
  {#each COLS as [nom, g] (nom)}
    <div class="m11g-case m11g-etape" class:vu={e >= 1}><Goa graphe={g} taille={0.62} temps={[{ chemin: ABC, controles: ['B'], court: true }]} /></div>
  {/each}
</div>

<style>
  .m11g { width: 100%; display: grid; grid-template-columns: auto repeat(3, 1fr); gap: 0.6em 1.6em; align-items: center; max-width: 60em; margin: 1em auto 0; }
  .m11g-col { font-size: 1.2em; text-align: center; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; }
  .m11g-ligne { font-weight: 700; font-size: 1em; }
  .m11g-case { display: flex; justify-content: center; }
  .m11g-etape { opacity: 0; transition: opacity 0.4s; }
  .m11g-etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m11g-etape { transition: none; } }
</style>
