<script>
  /**
   * Une courte liste numérotée, un élément par clic (séance 11) : les trois
   * fonctions du GOA, les quatre faits de l'exemple de l'éducation, les deux
   * conditions de l'identification. Un grand numéro rouge, une phrase, une
   * glose grise au besoin. Rien d'autre.
   *
   *   items   [{ t: 'phrase', g: 'glose' (facultatif) }]
   *   tout    true : tout est visible d'emblée, sans clic
   */
  import { brancherTemps } from '../temps.js';

  let { items = [], tout = false } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || tout) return;
    e = 0;
    return brancherTemps(hote, { total: items.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<ol class="visuel m11l" bind:this={hote}>
  {#each items as it, i (i)}
    <li class:vu={tout || e >= i}>
      <span class="m11l-n">{i + 1}</span>
      <span class="m11l-txt"><strong>{it.t}</strong>{#if it.g}<em>{it.g}</em>{/if}</span>
    </li>
  {/each}
</ol>

<style>
  .m11l { list-style: none; margin: 1.4em auto 0; padding: 0; max-width: 46em; display: flex; flex-direction: column; gap: 1em; }
  .m11l li { display: grid; grid-template-columns: 2.2em 1fr; gap: 0.8em; align-items: baseline; border-top: 2px solid var(--dk-encre); padding-top: 0.6em; opacity: 0; transition: opacity 0.4s; font-size: 1em; }
  .m11l li.vu { opacity: 1; }
  .m11l-n { font-size: 2.2em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
  .m11l-txt { display: flex; flex-direction: column; gap: 0.2em; }
  .m11l-txt strong { font-size: 1.3em; line-height: 1.3; }
  .m11l-txt em { font-style: normal; font-size: 0.9em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11l li { transition: none; } }
</style>
