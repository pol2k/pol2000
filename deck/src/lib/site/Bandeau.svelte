<script>
  /**
   * Le bandeau du site: le même repère qu'en haut de chaque diapositive —
   * petites capitales espacées, filet de 2 px, rouge à droite — avec en
   * plus une barre de progression de lecture, comme celle du deck.
   */
  import { base } from '$app/paths';
  import { COURS } from '$lib/data/cours.js';

  let { liens = [], retour = '' } = $props();
  let progres = $state(0);
  let ouvert = $state(false);

  function auDefilement() {
    const h = document.documentElement;
    const max = h.scrollHeight - h.clientHeight;
    progres = max > 0 ? Math.min(1, h.scrollTop / max) : 0;
  }
</script>

<svelte:window onscroll={auDefilement} />

<div class="barre" style="width: {progres * 100}%"></div>
<header class="bandeau">
  <a class="marque" href="{base}/">
    {#if retour}<span class="fl">←</span>{/if}
    <strong>{COURS.sigle}</strong><span class="sep">·</span><span class="t">{COURS.titre}</span>
  </a>
  <button class="menu" aria-expanded={ouvert} aria-label="Menu" onclick={() => (ouvert = !ouvert)}>{ouvert ? '×' : '≡'}</button>
  <nav class:ouvert>
    {#each liens as l}
      <a href={l.href} class:phare={l.phare} onclick={() => (ouvert = false)}>{l.texte}</a>
    {/each}
  </nav>
</header>

<style>
  .barre { position: fixed; top: 0; left: 0; height: 3px; z-index: 60; background: var(--accent); transition: width 0.2s ease; }
  .bandeau {
    position: sticky; top: 0; z-index: 50;
    display: flex; align-items: center; justify-content: space-between; gap: 1rem;
    padding: 0.85rem var(--marge);
    background: var(--fond);
    border-bottom: var(--trait);
    font-size: 0.66rem; letter-spacing: 0.14em; text-transform: uppercase;
  }
  .marque { display: flex; align-items: center; gap: 0.6em; color: var(--encre); text-decoration: none; white-space: nowrap; }
  .marque:hover { text-decoration: none; }
  .marque .fl { color: var(--accent); }
  .marque .sep, .marque .t { color: var(--gris); }
  nav { display: flex; gap: 1.6em; }
  nav a { color: var(--encre); text-decoration: none; padding: 0.2em 0; border-bottom: 2px solid transparent; }
  nav a:hover { border-bottom-color: var(--encre); }
  nav a.phare { color: var(--accent); }
  nav a.phare:hover { border-bottom-color: var(--accent); }
  .menu { display: none; font-size: 1.3rem; line-height: 1; padding: 0 0.3em; }
  @media (max-width: 52rem) {
    .marque .t, .marque .sep { display: none; }
    .menu { display: block; }
    nav { display: none; position: absolute; left: 0; right: 0; top: 100%; flex-direction: column; gap: 0;
      background: var(--fond); border-bottom: var(--trait); }
    nav.ouvert { display: flex; }
    nav a { padding: 0.9em var(--marge); border-bottom: var(--trait-fin); }
  }
</style>
