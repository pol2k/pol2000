<script>
  /**
   * Le plan de la séance 8, en trois blocs : Zotero, ajouter des variables
   * à la régression, puis la pratique dans R (Blais et Gélineau, 2007).
   * Chaque bloc a son image : le logo de Zotero, un petit schéma (deux
   * variables vers Y), les logos de R et de Positron.
   */
  import { base } from '$app/paths';
  const BLOCS = [
    { n: '1', titre: 'Zotero' },
    { n: '2', titre: 'Ajouter des variables à la régression' },
    { n: '3', titre: 'Pratique dans R' }
  ];
</script>

<div class="visuel auj8">
  {#each BLOCS as m, i}
    <div class="a8-bloc" class:a8-code={i === 2} style="--i: {i}">
      <div class="a8-image" aria-hidden="true">
        {#if i === 0}
          <img class="a8-zotero" src="{base}/img/zotero-logo.svg" alt="" />
        {:else if i === 1}
          <svg viewBox="0 0 220 120">
            <defs><marker id="a8-fl" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="3.5" markerHeight="3.5" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="currentColor" /></marker></defs>
            <rect x="4" y="12" width="70" height="36" class="a8-b" /><text x="39" y="36">X</text>
            <rect x="4" y="72" width="70" height="36" class="a8-b a8-r" /><text x="39" y="96" class="a8-r">+</text>
            <rect x="146" y="42" width="70" height="36" class="a8-b" /><text x="181" y="66">Y</text>
            <line x1="78" y1="32" x2="142" y2="56" class="a8-l" marker-end="url(#a8-fl)" />
            <line x1="78" y1="88" x2="142" y2="66" class="a8-l a8-r" marker-end="url(#a8-fl)" />
          </svg>
        {:else}
          <img class="a8-r-logo" src="{base}/img/Rlogo.png" alt="" />
          <img class="a8-positron" src="{base}/img/positron-logo.png" alt="" />
        {/if}
      </div>
      <span class="a8-n">{m.n}</span>
      <strong>{m.titre}</strong>
    </div>
  {/each}
</div>

<style>
  .auj8 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.3em; align-items: stretch; max-width: 66em; margin: 1.2em auto 0; }
  .a8-bloc { border: 3px solid var(--dk-encre); padding: 1.3em 1.3em; display: flex; flex-direction: column; gap: 0.5em; animation: a8-fondu 0.5s both; animation-delay: calc(var(--i) * 0.2s); }
  .a8-bloc.a8-code { border-color: var(--dk-accent); }
  .a8-image { height: 6.5em; min-width: 0; overflow: hidden; display: flex; align-items: center; justify-content: center; gap: 1.2em; margin-bottom: 0.6em; border-bottom: 2px solid var(--dk-filet); padding-bottom: 0.8em; }
  .a8-zotero { height: 2.6em; width: auto; }
  .a8-r-logo { height: 3.2em; width: auto; flex: none; }
  .a8-positron { height: auto; width: 58%; min-width: 0; }
  .a8-image svg { height: 100%; width: auto; color: var(--dk-encre); }
  .a8-b { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .a8-l { stroke: var(--dk-encre); stroke-width: 3; }
  .a8-r { stroke: var(--dk-accent); color: var(--dk-accent); fill: var(--dk-accent); }
  rect.a8-r { fill: none; }
  svg text { font-family: var(--dk-mono); font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  svg text.a8-r { fill: var(--dk-accent); }
  .a8-n { font-size: 3.2em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .a8-bloc strong { font-size: 1.5em; line-height: 1.25; }
  @keyframes a8-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .a8-bloc { animation: none; } }
</style>
