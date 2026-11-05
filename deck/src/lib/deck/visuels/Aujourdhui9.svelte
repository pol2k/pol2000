<script>
  /**
   * Le plan de la séance 9, en deux blocs : mesurer un concept qu'on ne voit
   * pas (le populisme dans la CES 2025), puis ce qu'est un modèle de langue.
   * Chaque bloc a son petit schéma : un arbre (concept, dimensions,
   * questions) et une entrée qui devient une sortie, un jeton à la fois (la phrase
   * réelle de la démo Generation : « L'hiver à Québec est froid et enneigé. »).
   */
  const BLOCS = [
    { n: '1', titre: 'Mesurer un concept qu’on ne voit pas', sous: 'La confiance envers les institutions, dans la CES 2025' },
    { n: '2', titre: 'Ce qu’est un modèle de langue', sous: 'Et comment s’en servir sans se faire avoir' }
  ];
</script>

<div class="visuel auj9">
  {#each BLOCS as m, i}
    <div class="a9-bloc" class:a9-ia={i === 1} style="--i: {i}">
      <div class="a9-image" aria-hidden="true">
        {#if i === 0}
          <svg viewBox="0 0 220 120">
            <rect x="70" y="6" width="80" height="30" class="a9-b a9-pointille" /><text x="110" y="26">?</text>
            <rect x="14" y="52" width="56" height="26" class="a9-b" />
            <rect x="82" y="52" width="56" height="26" class="a9-b" />
            <rect x="150" y="52" width="56" height="26" class="a9-b" />
            <line x1="110" y1="36" x2="42" y2="52" class="a9-l" /><line x1="110" y1="36" x2="110" y2="52" class="a9-l" /><line x1="110" y1="36" x2="178" y2="52" class="a9-l" />
            {#each [42, 110, 178] as cx}
              <rect x={cx - 24} y="96" width="48" height="18" class="a9-b a9-r" />
              <line x1={cx} y1="78" x2={cx} y2="96" class="a9-l a9-r" />
            {/each}
          </svg>
        {:else}
          <svg viewBox="0 0 280 120">
            <rect x="10" y="14" width="260" height="34" class="a9-b" />
            <text x="22" y="37" class="a9-g">L’hiver à Québec est</text>
            <line x1="140" y1="48" x2="140" y2="70" class="a9-l" />
            <polygon points="134,66 146,66 140,76" class="a9-pl" />
            <rect x="10" y="80" width="260" height="34" class="a9-b a9-r" />
            <text x="22" y="103" class="a9-g">L’hiver à Québec est <tspan class="a9-rt">froid</tspan></text>
          </svg>
        {/if}
      </div>
      <span class="a9-n">{m.n}</span>
      <strong>{m.titre}</strong>
      <span class="a9-sous">{m.sous}</span>
    </div>
  {/each}
</div>

<style>
  .auj9 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.6em; align-items: stretch; max-width: 54em; margin: 1.2em auto 0; }
  .a9-bloc { border: 3px solid var(--dk-encre); padding: 1.3em 1.4em; display: flex; flex-direction: column; gap: 0.5em; animation: a9-fondu 0.5s both; animation-delay: calc(var(--i) * 0.2s); }
  .a9-bloc.a9-ia { border-color: var(--dk-accent); }
  .a9-image { height: 6.5em; display: flex; align-items: center; justify-content: center; margin-bottom: 0.6em; border-bottom: 2px solid var(--dk-filet); padding-bottom: 0.8em; }
  .a9-image svg { height: 100%; width: auto; }
  .a9-b { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .a9-pointille { stroke-dasharray: 6 4; }
  .a9-l { stroke: var(--dk-encre); stroke-width: 3; }
  .a9-pl { fill: var(--dk-encre); }
  .a9-r { stroke: var(--dk-accent); }
  svg text { font-family: var(--dk-mono); font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  svg text.a9-g { text-anchor: start; font-size: 15px; font-weight: 600; }
  .a9-rt { fill: var(--dk-accent); }
  .a9-n { font-size: 3.2em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .a9-bloc strong { font-size: 1.5em; line-height: 1.25; }
  .a9-sous { font-size: 0.85em; color: var(--dk-gris); }
  @keyframes a9-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .a9-bloc { animation: none; } }
</style>
