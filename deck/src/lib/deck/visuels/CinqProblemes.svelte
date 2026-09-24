<script>
  /**
   * Les cinq problèmes communs des données désordonnées (Wickham 2014), tels
   * que le cours 4 de FAS1001 les présentait. Chacun a son petit glyphe (une
   * grille schématique où le défaut est en rouge) et le verbe qui le règle.
   * Un problème par clic; le premier est là d'emblée. Avec `tout`, les cinq
   * sont là d'emblée, sans clic : c'est le récapitulatif qui suit les cinq
   * diapos problème / solution.
   *
   * Le quatrième (le palmarès Billboard) se règle en un seul tableau : une
   * ligne par chanson et par semaine. Son défaut est dans la ligne (plusieurs
   * observations), là où celui du premier est dans les en-têtes.
   */
  import { brancherTemps } from '../temps.js';
  let { tout = false } = $props();

  const P = [
    { t: 'Des valeurs dans les en-têtes', v: 'pivot_longer()' },
    { t: 'Plusieurs variables dans une colonne', v: 'pivot_longer(names_sep = )' },
    { t: 'Des variables dans les lignes et les colonnes', v: 'pivot_longer() + pivot_wider()' },
    { t: 'Plusieurs observations dans une ligne', v: 'pivot_longer()' },
    { t: 'Une observation dans plusieurs tableaux', v: 'bind_rows()' }
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    if (tout) { e = P.length - 1; return; }
    e = 0;
    return brancherTemps(hote, { total: P.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Une grille de 4 colonnes × 3 lignes de données, plus l'en-tête.
  const W = 18, H = 11, X0 = 2, Y0 = 2;
  const cases = [];
  for (let r = 0; r < 4; r++) for (let c = 0; c < 4; c++) cases.push({ r, c });
</script>

<div class="visuel cinq" bind:this={hote}>
  {#each P as p, i}
    <div class="ligne" class:vu={e >= i}>
      <span class="num">{i + 1}</span>
      <svg viewBox="0 0 110 52" aria-hidden="true">
        {#if i < 4}
          {#each cases as { r, c }}
            {@const rouge =
              (i === 0 && r === 0 && c > 0) ||
              (i === 1 && r === 0 && c > 1) ||
              (i === 2 && ((r === 0 && c > 1) || (r > 0 && c === 1))) ||
              (i === 3 && r === 1 && c > 1)}
            <rect x={X0 + c * (W + 2)} y={Y0 + r * (H + 1)} width={W} height={H}
              class:tete={r === 0} class:rouge />
            {#if i === 1 && r === 0 && c > 1}
              <line x1={X0 + c * (W + 2) + W / 2} y1={Y0} x2={X0 + c * (W + 2) + W / 2} y2={Y0 + H} class="coupe" />
            {/if}
          {/each}
        {:else}
          {#each [0, 1] as t}
            {#each cases.filter((k) => k.c < 2) as { r, c }}
              <rect x={X0 + t * 48 + c * (W + 2)} y={Y0 + r * (H + 1)} width={W} height={H} class:tete={r === 0} class:rouge={r > 0 && t === 1} />
            {/each}
          {/each}
        {/if}
      </svg>
      <span class="t">{p.t}</span>
      <code class="v">{p.v}</code>
    </div>
  {/each}
  <p class="source">Wickham (2014), « Tidy Data »</p>
</div>

<style>
  .cinq { display: flex; flex-direction: column; gap: 0.55em; }
  .ligne { display: grid; grid-template-columns: 1.4em 5.4em 1fr auto; gap: 0.9em; align-items: center; padding: 0.35em 0.2em; border-bottom: 2px solid var(--dk-filet); opacity: 0.12; transition: opacity 0.4s; }
  .ligne.vu { opacity: 1; }
  .num { font-size: 1.5em; font-weight: 600; color: var(--dk-accent); }
  svg { width: 5.4em; height: auto; display: block; }
  rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 1.5; }
  rect.tete { fill: var(--dk-encre); }
  rect.rouge { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .coupe { stroke: var(--dk-fond); stroke-width: 2; }
  .t { font-size: 1.12em; line-height: 1.3; }
  .v { font-family: var(--dk-mono); font-size: 0.85em; font-weight: 600; color: var(--dk-accent); border: 2px solid var(--dk-accent); padding: 0.2em 0.5em; white-space: nowrap; }
  .source { margin: 0.2em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @media (prefers-reduced-motion: reduce) { .ligne { transition: none; } }
</style>
