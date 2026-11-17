<script>
  /**
   * Le plan de la séance 11, en quatre blocs, chacun avec son petit schéma :
   * deux mondes (le problème fondamental, reporté de la séance 10), dessiner
   * un GOA, ouvert ou fermé, simuler dans R. Même facture qu'Aujourdhui9.
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
            <rect x="20" y="8" width="90" height="30" class="a11-b" />
            <rect x="20" y="52" width="90" height="30" class="a11-b a11-p" />
            <text x="175" y="31">7</text>
            <text x="175" y="76" class="a11-gr">?</text>
          {:else if i === 1}
            <rect x="6" y="30" width="44" height="30" class="a11-b" />
            <rect x="98" y="30" width="44" height="30" class="a11-b" />
            <rect x="190" y="30" width="44" height="30" class="a11-b" />
            <line x1="50" y1="45" x2="88" y2="45" class="a11-l" /><polygon points="98,45 86,39 86,51" class="a11-pl" />
            <line x1="142" y1="45" x2="180" y2="45" class="a11-l" /><polygon points="190,45 178,39 178,51" class="a11-pl" />
          {:else if i === 2}
            <rect x="6" y="30" width="44" height="30" class="a11-b" />
            <rect x="98" y="30" width="44" height="30" class="a11-b" />
            <rect x="90" y="22" width="60" height="46" class="a11-b a11-rr" />
            <rect x="190" y="30" width="44" height="30" class="a11-b" />
            <line x1="50" y1="45" x2="80" y2="45" class="a11-l a11-p" />
            <line x1="160" y1="45" x2="190" y2="45" class="a11-l a11-p" />
          {:else}
            <text x="120" y="54" class="a11-code">lm(Y ~ X)</text>
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
  svg text { font-family: var(--dk-mono); font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  svg text.a11-gr { fill: var(--dk-gris-2); }
  svg text.a11-code { font-size: 28px; fill: var(--dk-accent); }
  .a11-n { font-size: 2.6em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .a11-bloc strong { font-size: 1.25em; line-height: 1.25; }
  .a11-sous { font-size: 0.8em; color: var(--dk-gris); }
  @keyframes a11-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .a11-bloc { animation: none; } }
</style>
