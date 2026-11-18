<script>
  /**
   * Le plan de la séance 11, en quatre blocs, chacun avec l'image qui
   * l'attend : le carrefour dans le brouillard (deux mondes, reporté de la
   * séance 10), les dominos (dessiner un GOA), les cadrans (ouvert ou
   * fermé : l'aiguille du bout suit-elle ?), la cible (simuler dans R).
   * Même facture qu'Aujourdhui9.
   */
  const BLOCS = [
    { n: '1', titre: 'Deux mondes', sous: 'Le problème fondamental de l’inférence causale' },
    { n: '2', titre: 'Dessiner un GOA', sous: 'Des boîtes, des flèches, nos hypothèses' },
    { n: '3', titre: 'Ouvert ou fermé', sous: 'Quoi contrôler, et quoi laisser tranquille' },
    { n: '4', titre: 'Simuler dans R', sous: 'On fabrique le monde, on connaît la vérité' }
  ];
</script>

<div class="visuel auj11">
  {#each BLOCS as m, i (m.n)}
    <div class="a11-bloc" class:a11-r={i === 2} style="--i: {i}">
      <div class="a11-image" aria-hidden="true">
        <svg viewBox="0 0 240 90">
          {#if i === 0}
            <path d="M 10 60 L 100 60 L 220 14" class="a11-l a11-route" />
            <path d="M 100 60 L 220 84" class="a11-l a11-route" />
            <ellipse cx="180" cy="76" rx="58" ry="16" class="a11-brume" />
          {:else if i === 1}
            {#each [30, 90, 150] as x, k (x)}<rect x={x} y="12" width="16" height="70" class="a11-dom" transform="rotate({k < 2 ? 32 : 0} {x + 16} 82)" />{/each}
          {:else if i === 2}
            {#each [40, 120, 200] as x, k (x)}<path d="M {x - 34} 66 A 34 34 0 0 1 {x + 34} 66" class="a11-l" /><line x1={x} y1="66" x2={x + (k === 2 ? 0 : 22)} y2={k === 2 ? 38 : 42} class="a11-l a11-aig" class:a11-rouge={k === 0} />{/each}
            <rect x="80" y="24" width="80" height="52" class="a11-pince" />
          {:else}
            <circle cx="120" cy="46" r="40" class="a11-b" /><circle cx="120" cy="46" r="24" class="a11-b" /><circle cx="120" cy="46" r="8" class="a11-pl a11-r-f" />
            <line x1="122" y1="44" x2="176" y2="8" class="a11-l a11-fleche" />
          {/if}
        </svg>
      </div>
      <span class="a11-n">{m.n}</span>
      <strong>{m.titre}</strong>
      <span class="a11-sous">{m.sous}</span>
    </div>
  {/each}
</div>

<style>
  .auj11 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.2em; max-width: 62em; margin: 1.2em auto 0; }
  .a11-bloc { border: 3px solid var(--dk-encre); padding: 1.1em 1.1em; display: flex; flex-direction: column; gap: 0.45em; animation: a11-fondu 0.5s both; animation-delay: calc(var(--i) * 0.15s); }
  .a11-bloc.a11-r { border-color: var(--dk-accent); }
  .a11-image { height: 4.6em; display: flex; align-items: center; justify-content: center; margin-bottom: 0.5em; border-bottom: 2px solid var(--dk-filet); padding-bottom: 0.7em; }
  .a11-image svg { height: 100%; width: auto; }
  .a11-b { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .a11-p { stroke-dasharray: 6 4; stroke: var(--dk-gris-2); }
  .a11-rr { stroke: var(--dk-accent); stroke-width: 4; }
  .a11-l { stroke: var(--dk-encre); stroke-width: 3; }
  .a11-pl { fill: var(--dk-encre); }
  .a11-route { stroke: var(--dk-filet); stroke-width: 14; fill: none; stroke-linejoin: round; }
  .a11-brume { fill: var(--dk-gris-2); opacity: 0.6; }
  .a11-dom { fill: var(--dk-encre); }
  .a11-aig { stroke-width: 5; stroke-linecap: round; }
  .a11-rouge { stroke: var(--dk-accent); }
  .a11-pince { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .a11-r-f { fill: var(--dk-accent); }
  .a11-fleche { stroke-width: 5; }
  .a11-l { fill: none; }
  svg text { font-family: var(--dk-mono); font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  svg text.a11-gr { fill: var(--dk-gris-2); }
  svg text.a11-code { font-size: 28px; fill: var(--dk-accent); }
  .a11-n { font-size: 2.6em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .a11-bloc strong { font-size: 1.25em; line-height: 1.25; }
  .a11-sous { font-size: 0.8em; color: var(--dk-gris); }
  @keyframes a11-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .a11-bloc { animation: none; } }
</style>
