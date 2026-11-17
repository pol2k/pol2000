<script>
  /**
   * Un exercice « contrôler ou pas » (le cours 11 de 2024, images goa27 à
   * goa31) : le graphe à droite, les cinq questions à gauche, une réponse
   * par clic. Un seul compteur pilote les deux : le graphe reçoit l'état
   * correspondant au nombre de réponses montrées (Goa sans temps propre).
   *
   *   graphe    une entrée de GOA;
   *   reponses  cinq réponses courtes (« Z3 » s'écrit Z₃ à l'écran);
   *   etats     six états de Goa : avant toute réponse, puis après chacune.
   *
   * Les clés sont vérifiées par src/lib/deck/goa.test.js sur les mêmes
   * graphes.
   */
  import { brancherTemps } from '../temps.js';
  import Goa from './Goa.svelte';

  let { graphe, reponses = [], etats = [] } = $props();

  const QUESTIONS = [
    'Y a-t-il des descendants de X ?',
    'Y a-t-il des chemins par la porte arrière ?',
    'Sont-ils ouverts ?',
    'Peut-on les bloquer ?',
    'L’effet de X sur Y est-il identifiable ?'
  ];
  const indices = (t) => t.replace(/Z(\d)/g, 'Z<sub>$1</sub>');

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: reponses.length, lire: () => e, ecrire: (v) => (e = v) });
  });
  const etat = $derived(etats[Math.min(e, etats.length - 1)] ?? {});
</script>

<div class="visuel m11x" bind:this={hote}>
  <ol class="m11x-q">
    {#each QUESTIONS as q, i (i)}
      <li>
        <span class="m11x-n">{i + 1}</span>
        <span class="m11x-txt">
          <span class="m11x-question">{q}</span>
          <strong class="m11x-rep" class:vu={e > i}>{@html indices(reponses[i] ?? '')}</strong>
        </span>
      </li>
    {/each}
  </ol>
  <div class="m11x-g">
    <Goa {graphe} taille={0.9} temps={[etat]} legende="Schéma, aucune donnée" />
  </div>
</div>

<style>
  .m11x { width: 100%; display: grid; grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr); gap: 2em; align-items: center; margin-top: 0.6em; }
  .m11x-q { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.55em; }
  .m11x-q li { display: grid; grid-template-columns: 1.5em 1fr; gap: 0.5em; align-items: baseline; border-top: 2px solid var(--dk-filet); padding-top: 0.35em; }
  .m11x-n { font-size: 1.3em; font-weight: 700; color: var(--dk-accent); }
  .m11x-txt { display: flex; flex-direction: column; gap: 0.1em; }
  .m11x-question { font-size: 0.85em; color: var(--dk-gris); }
  .m11x-rep { font-size: 1em; line-height: 1.3; min-height: 1.3em; opacity: 0; transition: opacity 0.4s; }
  .m11x-rep.vu { opacity: 1; }
  .m11x-g { display: flex; justify-content: center; }
  @media (prefers-reduced-motion: reduce) { .m11x-rep { transition: none; } }
</style>
