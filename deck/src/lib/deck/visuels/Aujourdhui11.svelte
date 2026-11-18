<script>
  /**
   * Le plan de la séance 11, en cinq blocs, chacun avec l'image qui
   * l'attend : la pile de journaux (une manchette, puis l'article qui la
   * porte), le carrefour dans le brouillard (deux mondes, reporté de la
   * séance 10), les dominos (dessiner un GOA), deux boîtes (les deux règles : une
   * variable barrée, une variable encadrée), la cible (simuler dans R).
   * Même facture qu'Aujourdhui9.
   */
  const BLOCS = [
    { n: '1', titre: 'Une manchette', sous: 'Repérer les signes d’une étude qui ne tient pas' },
    { n: '2', titre: 'Deux mondes', sous: 'Le problème fondamental de l’inférence causale' },
    { n: '3', titre: 'Dessiner un GOA', sous: 'Des boîtes, des flèches, nos hypothèses' },
    { n: '4', titre: 'Deux règles', sous: 'Quoi contrôler, et quoi laisser tranquille' },
    { n: '5', titre: 'Simuler dans R', sous: 'On fabrique le monde, on connaît la vérité' }
  ];
</script>

<div class="visuel auj11">
  {#each BLOCS as m, i (m.n)}
    <div class="a11-bloc" class:a11-r={i === 3} style="--i: {i}">
      <div class="a11-image" aria-hidden="true">
        <svg viewBox="0 0 240 90">
          {#if i === 0}
            {#each [0, 1, 2] as k (k)}<g transform="translate({62 + k * 14} {14 + k * 6}) rotate({-6 + k * 6})"><rect width="96" height="66" class="a11-journal" /><line x1="10" y1="16" x2="86" y2="16" class="a11-rr" /><line x1="10" y1="34" x2="66" y2="34" class="a11-l" /><line x1="10" y1="48" x2="78" y2="48" class="a11-l" /></g>{/each}
          {:else if i === 1}
            <path d="M 10 60 L 100 60 L 220 14" class="a11-l a11-route" />
            <path d="M 100 60 L 220 84" class="a11-l a11-route" />
            <ellipse cx="180" cy="76" rx="58" ry="16" class="a11-brume" />
          {:else if i === 2}
            {#each [30, 90, 150] as x, k (x)}<rect x={x} y="12" width="16" height="70" class="a11-dom" transform="rotate({k < 2 ? 32 : 0} {x + 16} 82)" />{/each}
          {:else if i === 3}
            <rect x="34" y="22" width="70" height="48" class="a11-b" /><line x1="30" y1="18" x2="108" y2="74" class="a11-rr" /><line x1="108" y1="18" x2="30" y2="74" class="a11-rr" />
            <rect x="136" y="22" width="70" height="48" class="a11-b" /><rect x="126" y="12" width="90" height="68" class="a11-pince" />
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
  .auj11 { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 0.9em; max-width: 100%; font-size: 0.86em; margin: 1.2em auto 0; }
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
  .a11-journal { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
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
