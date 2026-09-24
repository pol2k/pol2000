<script>
  /**
   * Les trois règles des données tidy (Wickham 2014), comme au cours 4 de
   * FAS1001 : une colonne, une variable ; une ligne, une observation ; un
   * tableau, un type d'unité observée. La troisième est celle que violent
   * les problèmes 4 et 5. Une règle par clic ; la première est là d'emblée.
   * Les glyphes sont des schémas, pas des données.
   */
  import { brancherTemps } from '../temps.js';
  const REGLES = [
    { n: 1, t: 'Chaque colonne est une variable.' },
    { n: 2, t: 'Chaque ligne est une observation.' },
    { n: 3, t: 'Chaque tableau est un type d’unité observée.' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  // Une grille de 4 × 4 cases de 22 px, en-tête compris.
  const C = 22;
  const cases = [0, 1, 2, 3].flatMap((l) => [0, 1, 2, 3].map((c) => ({ l, c })));
</script>

<div class="visuel trois-regles" bind:this={hote}>
  {#each REGLES as r, i}
    <div class="regle" class:vu={e >= i}>
      <svg viewBox="0 0 {i === 2 ? 212 : 92} 92" role="img" aria-label={r.t}>
        {#if i < 2}
          {#each cases as k}
            <rect x={k.c * C + 2} y={k.l * C + 2} width={C} height={C}
              class:tete={k.l === 0}
              class:allume={(i === 0 && k.c === 1) || (i === 1 && k.l === 2)} />
          {/each}
        {:else}
          {#each [0, 120] as dx, t}
            {#each cases.filter((k) => k.c < 3) as k}
              <rect x={dx + k.c * C + 2} y={k.l * C + 2} width={C} height={C} class:tete={k.l === 0} class:allume={t === 1} />
            {/each}
          {/each}
          <text x="36" y="-6">personnes</text>
          <text x="156" y="-6">élections</text>
        {/if}
      </svg>
      <p><span class="num">{r.n}</span>{r.t}</p>
    </div>
  {/each}
  <p class="source">Wickham (2014), « Tidy Data »</p>
</div>

<style>
  .trois-regles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.6em; align-items: start; }
  .regle { display: flex; flex-direction: column; gap: 1em; border-top: 3px solid var(--dk-encre); padding-top: 1.4em; opacity: 0.12; transition: opacity 0.4s; }
  .regle.vu { opacity: 1; }
  .regle:last-of-type { border-top-color: var(--dk-accent); }
  svg { height: 5.4em; width: auto; overflow: visible; margin-top: 0.8em; }
  rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  rect.tete { fill: var(--dk-encre); }
  rect.allume { fill: var(--dk-accent); }
  rect.tete.allume { fill: var(--dk-accent); stroke: var(--dk-encre); }
  text { font-family: var(--dk-mono); font-size: 13px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  p { margin: 0; font-size: 1.3em; line-height: 1.3; }
  .num { display: block; font-size: 1.6em; font-weight: 600; color: var(--dk-accent); line-height: 1; margin-bottom: 0.25em; }
  .source { grid-column: 1 / -1; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @media (prefers-reduced-motion: reduce) { .regle { transition: none; } }
</style>
