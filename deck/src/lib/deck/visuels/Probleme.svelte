<script>
  /**
   * Un problème de données désordonnées, avant et après (Wickham 2014; le
   * cours 4 de FAS1001). Les tableaux sont des extraits de vraies données et
   * le code est celui que R a exécuté pour produire l'après
   * (outils/seance4_data.R → TIDY et CONSOLES).
   *
   *   avant       — [{ titre?, cols, rows, suite? }] : un ou plusieurs tableaux
   *   marque      — noms de colonnes de l'avant où loge le défaut
   *   code        — le code R, colorié comme dans la console
   *   apres       — [{ titre?, cols, rows, suite? }]
   *   explication — une ligne
   *   source      — la provenance, en petit
   *
   *   partie      — '' (tout sur une diapo, quatre temps), 'probleme' ou 'solution'
   *   marqueTitres — rougir aussi les titres des tableaux de l'avant (quand le
   *                  défaut est le fait d'avoir plusieurs tableaux)
   *
   *   partie = '' (par défaut)
   *     0  L'avant.
   *     1  Les colonnes fautives rougissent; l'explication apparaît.
   *     2  Le code.
   *     3  L'après.
   *   partie = 'probleme'
   *     0  L'avant, en grand.
   *     1  Les colonnes fautives rougissent; l'explication apparaît.
   *   partie = 'solution'
   *     0  Le code, en grand, et l'avant en petit (déjà marqué), pour mémoire.
   *     1  La flèche et l'après.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  let {
    avant = [], marque = [], code = '', apres = [], explication = '', source = '',
    partie = '', marqueTitres = false, rappel = true
  } = $props();
  const total = $derived(partie ? 1 : 3);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fmt = (v) => (v === null || v === undefined ? 'NA' : v);
  // Un nom de colonne R ne se coupe qu'après un « _ », jamais au milieu d'un mot.
  const morceaux = (c) => c.split('_').map((m, k, a) => (k < a.length - 1 ? m + '_' : m));
  // Le cas le plus haut (les sièges : dix lignes après, plus le code) resserre les tableaux.
  const lignes = (ts) => ts.reduce((n, t) => n + t.rows.length + (t.suite ? 1 : 0) + (t.titre ? 1 : 0) + 1, 0);
  // Seuls les tableaux visibles comptent : l'avant sur la diapo du problème, l'après sur celle de la solution.
  const dense = $derived(
    partie === 'probleme' ? lignes(avant) > 8 : partie === 'solution' ? lignes(apres) > 8 : Math.max(lignes(avant), lignes(apres)) > 8
  );
</script>

{#snippet tableau(t, rougir)}
  <figure class="tab">
    {#if t.titre}<figcaption class:rouge={rougir && marqueTitres}>{t.titre}</figcaption>{/if}
    <table>
      <thead><tr>{#each t.cols as c}<th class:rouge={rougir && marque.includes(c)}>{#each morceaux(c) as m, k}{#if k > 0}<wbr />{/if}{m}{/each}</th>{/each}</tr></thead>
      <tbody>
        {#each t.rows as r}
          <tr>{#each r as v, j}<td class:na={v === null} class:rouge={rougir && marque.includes(t.cols[j])} class:nb={typeof v === 'number'}>{fmt(v)}</td>{/each}</tr>
        {/each}
        {#if t.suite}<tr class="suite"><td colspan={t.cols.length}>{t.suite}</td></tr>{/if}
      </tbody>
    </table>
  </figure>
{/snippet}

{#if partie === 'probleme'}
<div class="visuel probleme seul" class:dense bind:this={hote}>
  <p class="expl" class:vu={e >= 1}>{explication}</p>
  <div class="cote avant">
    <span class="et">AVANT</span>
    <div class="pile">{#each avant as t}{@render tableau(t, e >= 1)}{/each}</div>
  </div>
  {#if source}<p class="source">{source}</p>{/if}
</div>
{:else if partie === 'solution'}
<div class="visuel probleme solution" class:dense class:rappel bind:this={hote}>
  <div class="cote">
    <span class="et rouge-et">SOLUTION</span>
    <pre class="code ample vu">{@html surlignerR(code)}</pre>
  </div>
  {#if rappel}
    <div class="cote avant mini">
      <span class="et">AVANT</span>
      <div class="pile">{#each avant as t}{@render tableau(t, true)}{/each}</div>
    </div>
    <div class="fl" class:vu={e >= 1}>→</div>
  {/if}
  <div class="cote apres" class:vu={e >= 1}>
    <span class="et">APRÈS · TIDY</span>
    <div class="pile">{#each apres as t}{@render tableau(t, false)}{/each}</div>
  </div>
  {#if source}<p class="source">{source}</p>{/if}
</div>
{:else}
<div class="visuel probleme" class:dense bind:this={hote}>
  <p class="expl" class:vu={e >= 1}>{explication}</p>

  <div class="cote avant">
    <span class="et">AVANT</span>
    <div class="pile">{#each avant as t}{@render tableau(t, e >= 1)}{/each}</div>
  </div>

  <div class="fl" class:vu={e >= 3}>→</div>

  <div class="cote apres" class:vu={e >= 3}>
    <span class="et">APRÈS · TIDY</span>
    <div class="pile">{#each apres as t}{@render tableau(t, false)}{/each}</div>
  </div>

  <pre class="code" class:vu={e >= 2}>{@html surlignerR(code)}</pre>

  {#if source}<p class="source">{source}</p>{/if}
</div>
{/if}

<style>
  .probleme { display: grid; grid-template-columns: minmax(0, 1fr) auto minmax(0, 1fr); gap: 0.55em 1em; align-items: start; }
  .expl { grid-column: 1 / -1; margin: 0; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); min-height: 1.4em; opacity: 0; transition: opacity 0.4s; }
  .expl.vu { opacity: 1; }
  .cote { display: flex; flex-direction: column; gap: 0.35em; min-width: 0; }
  .apres { opacity: 0; transition: opacity 0.45s; }
  .apres.vu { opacity: 1; }
  .et { font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-gris); }
  .apres .et { color: var(--dk-accent); }
  .pile { display: flex; flex-wrap: wrap; gap: 0.8em; align-items: flex-start; }
  .tab { margin: 0; display: flex; flex-direction: column; gap: 0.2em; flex: 1 1 auto; min-width: 0; }
  figcaption { font-family: var(--dk-mono); font-size: 0.8em; font-weight: 600; }
  /* .probleme devant : l'emporter sur .diapo table / th / td de deck.css (majuscules, 0,72em). */
  .probleme table { width: 100%; border-collapse: collapse; font-size: 1em; border: 2px solid var(--dk-encre); font-variant-numeric: tabular-nums; }
  .probleme.dense table { font-size: 0.8em; }
  .probleme.dense td { padding-top: 0.14em; padding-bottom: 0.14em; }
  .probleme th { text-align: left; padding: 0.3em 0.9em 0.3em 0.6em; background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-size: 0.82em; font-weight: 600; letter-spacing: 0; text-transform: none; white-space: normal; overflow-wrap: normal; word-break: keep-all; border: 0; transition: background 0.3s; }
  .probleme td { padding: 0.26em 0.9em 0.26em 0.6em; border-bottom: 1px solid var(--dk-filet); white-space: nowrap; transition: background 0.3s, color 0.3s; }
  .probleme td.nb { text-align: right; }
  .probleme td.na { color: var(--dk-gris-2); }
  .probleme th.rouge { background: var(--dk-accent); }
  .probleme td.rouge { background: color-mix(in srgb, var(--dk-accent) 15%, transparent); color: var(--dk-accent); font-weight: 600; }
  .probleme .suite td { color: var(--dk-gris); border-bottom: 0; font-size: 0.9em; }
  .fl { align-self: center; font-size: 2.2em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .fl.vu { opacity: 1; }
  .code { grid-column: 1 / -1; margin: 0.2em 0 0; font-family: var(--dk-mono); font-size: 0.8em; line-height: 1.5; white-space: pre; overflow-x: auto; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.42em; border-left-color: var(--dk-accent); padding: 0.55em 0.9em; opacity: 0; transition: opacity 0.4s; }
  .code.vu { opacity: 1; }
  .source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  /* Le problème seul : l'avant occupe la diapo. */
  .probleme.seul { grid-template-columns: minmax(0, 1fr); gap: 0.8em; }
  .probleme.seul .expl { font-size: 1.2em; }
  .probleme.seul table { font-size: 1.2em; }
  .probleme.seul.dense table { font-size: 1em; }
  .probleme.seul .pile { gap: 1.6em; }
  .probleme.seul .tab { flex: 0 1 auto; }
  .probleme figcaption { transition: color 0.3s; }
  .probleme figcaption.rouge { color: var(--dk-accent); }
  /* La solution : le code en haut, puis l'avant (en petit) → l'après. */
  .probleme.solution { gap: 0.9em 1em; }
  .probleme.solution > .cote:first-child { grid-column: 1 / -1; }
  .probleme.solution:not(.rappel) { grid-template-columns: minmax(0, 1fr); }
  .probleme.solution.rappel { grid-template-columns: minmax(0, 0.75fr) auto minmax(0, 1.25fr); }
  .code.ample { grid-column: auto; margin: 0; font-size: 1em; }
  .et.rouge-et { color: var(--dk-accent); }
  .mini table { font-size: 0.72em; }
  .mini .pile { gap: 0.5em; }
  .mini figcaption { font-size: 0.66em; }
  @media (prefers-reduced-motion: reduce) { .expl, .apres, .fl, .code, th, td, figcaption { transition: none; } }
</style>
