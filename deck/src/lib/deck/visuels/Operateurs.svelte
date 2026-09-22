<script>
  /**
   * Poser une question à R : le bol de fruits d'Adrien Cloutier (hiver
   * 2024), refait avec de vraies données. Huit cases, les codes de
   * scolarité des huit premières personnes de l'Étude électorale 2025. Chaque
   * clic pose une question; R répond TRUE (rouge) ou FALSE (gris), case
   * par case. Quatre temps :
   *
   *   1  scol >= 9        2  scol == 7        3  scol %in% 6:7
   *   4  sum(scol >= 9) : TRUE compte pour 1.
   *
   * Le vecteur est lu dans la console générée (CONSOLES.operateurs), pour
   * que la figure et R ne puissent pas diverger.
   */
  import { brancherTemps } from '../temps.js';
  import { CONSOLES } from '$lib/data/seance4.js';

  const src = CONSOLES.operateurs[0].in;
  const SCOL = src.slice(src.indexOf('c(') + 2, src.lastIndexOf(')')).split(',').map((s) => Number(s.trim()));

  const QUESTIONS = [
    { expr: 'scol', test: null, dit: 'Huit codes de scolarité. Huit personnes.' },
    { expr: 'scol >= 9', test: (v) => v >= 9, dit: 'Un baccalauréat ou plus ?' },
    { expr: 'scol == 7', test: (v) => v === 7, dit: 'Exactement 7 ? Deux signes =, pas un.' },
    { expr: 'scol %in% 6:7', test: (v) => v === 6 || v === 7, dit: 'Parmi 6 et 7 ?' },
    { expr: 'sum(scol >= 9)', test: (v) => v >= 9, dit: 'TRUE compte pour 1.' }
  ];
  const total = SCOL.filter((v) => v >= 9).length;

  const OPS = [['==', 'égal'], ['!=', 'différent'], ['<', 'plus petit'], ['>=', 'plus grand ou égal'], ['%in%', 'parmi']];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const q = $derived(QUESTIONS[e]);
</script>

<div class="visuel operateurs" bind:this={hote}>
  <div class="scene">
    {#key e}<pre class="expr">{q.expr}{#if e === 4}<span class="rep"> → {total}</span>{/if}</pre>{/key}
    <div class="cases">
      {#each SCOL as v, i}
        {@const vrai = q.test ? q.test(v) : null}
        <div class="case" class:vrai={vrai === true} class:faux={vrai === false} style="transition-delay: {i * 50}ms">
          <span class="v">{v}</span>
          <span class="r">{vrai === null ? ' ' : vrai ? (e === 4 ? '1' : 'TRUE') : (e === 4 ? '0' : 'FALSE')}</span>
        </div>
      {/each}
    </div>
    {#key e}<p class="dit">{q.dit}</p>{/key}
  </div>

  <aside class="ops">
    {#each OPS as [op, sens]}
      <div><code>{op}</code><span>{sens}</span></div>
    {/each}
    <p class="dc">Datacamp de la semaine : Conditionals and Control Flow</p>
  </aside>
</div>

<style>
  .operateurs { display: grid; grid-template-columns: 1fr auto; gap: 2em; align-items: center; }
  .scene { display: flex; flex-direction: column; gap: 0.8em; min-width: 0; }
  .expr { margin: 0; font-family: var(--dk-mono); font-size: 2.1em; font-weight: 600; border: 3px solid var(--dk-encre); padding: 0.3em 0.6em; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); animation: fondu 0.35s both; }
  .rep { color: var(--dk-accent); }
  .cases { display: grid; grid-template-columns: repeat(8, 1fr); gap: 0.4em; }
  .case { border: 3px solid var(--dk-encre); display: flex; flex-direction: column; align-items: center; padding: 0.45em 0.1em 0.35em; gap: 0.2em; transition: background 0.3s, color 0.3s, border-color 0.3s; }
  .v { font-size: 1.9em; font-weight: 600; line-height: 1; font-variant-numeric: tabular-nums; }
  .r { font-size: 0.62em; font-weight: 600; letter-spacing: 0.04em; min-height: 1.2em; }
  .case.vrai { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .case.faux { background: var(--dk-fond-2); border-color: var(--dk-filet); color: var(--dk-gris-2); }
  .dit { margin: 0; font-size: 1.3em; animation: fondu 0.4s both; }
  .ops { border-left: 3px solid var(--dk-encre); padding-left: 1.1em; display: flex; flex-direction: column; gap: 0.35em; font-size: 0.85em; }
  .ops div { display: grid; grid-template-columns: 3.2em 1fr; gap: 0.6em; align-items: baseline; }
  .ops code { font-family: var(--dk-mono); font-weight: 600; color: var(--dk-accent); font-size: 1.1em; }
  .ops span { color: var(--dk-gris); }
  .dc { margin: 0.8em 0 0; font-size: 0.8em; font-weight: 600; color: var(--dk-encre); max-width: 13em; line-height: 1.35; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .expr, .dit { animation: none; } .case { transition: none; } }
</style>
