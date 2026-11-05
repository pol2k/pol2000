<script>
  /**
   * L'examen d'histoire du secondaire, une question à la fois. Douze élèves,
   * rangés selon leur moyenne en histoire. Une carte montre la question; les
   * élèves qui la réussissent se remplissent et sautent. Sous chacun, une
   * petite trace garde les questions précédentes. Au clic :
   *
   *   0  les élèves, du plus faible au plus fort;
   *   1  Q1 : les forts réussissent, les faibles ratent;
   *   2  Q2 : même motif;
   *   3  Q3 : encore;
   *   4  la question sur le hockey : ça s'éparpille, en rouge;
   *   5  Noah la réussit, Léa la rate.
   *
   * Réussites : un motif fixe, pas un tirage. Données fictives.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const MOY = [48, 52, 57, 61, 64, 68, 72, 75, 79, 83, 88, 93];
  const NOAH = 1, LEA = 10;   // indices 0 = le plus faible
  const QS = [
    { t: 'La fondation de Québec', r: [0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1] },
    { t: 'La Conquête', r: [0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1] },
    { t: 'La Révolution tranquille', r: [0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1] },
    { t: 'Les Coupes Stanley du Canadien', r: [1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1], hockey: true }
  ];
  const NOTES = [
    'Douze élèves, rangés selon leur moyenne en histoire.',
    'Les forts réussissent. Les faibles ratent.',
    'Même motif.',
    'Encore le même motif : les questions vont ensemble.',
    'Les forts ne font pas mieux que les faibles.',
    'Noah la réussit, Léa la rate : elle mesure le hockey, pas l’histoire.'
  ];
  const q = $derived(e >= 1 ? Math.min(e, 4) - 1 : -1);
  const Q = $derived(q >= 0 ? QS[q] : null);
</script>

<div class="visuel m9e" bind:this={hote}>
  <div class="m9e-carte" class:vide={!Q} class:rouge={Q?.hockey}>
    {#key q}
      {#if Q}<span class="m9e-num">Q{q + 1}</span><span class="m9e-titre">{Q.t}</span>{:else}<span class="m9e-titre pale">L’examen d’histoire</span>{/if}
    {/key}
  </div>

  <div class="m9e-rang">
    {#each MOY as m, i}
      {@const ok = Q ? Q.r[i] === 1 : false}
      <div class="m9e-eleve" class:ok class:rouge={Q?.hockey} class:cerne={e >= 5 && (i === NOAH || i === LEA)} style="--i: {i}">
        <span class="m9e-coche">{ok ? '✓' : ''}</span>
        <svg viewBox="0 0 60 90" aria-hidden="true">
          <circle cx="30" cy="18" r="13" />
          <path d="M 7 88 Q 7 40 30 40 Q 53 40 53 88 Z" />
        </svg>
        <span class="m9e-moy">{m}</span>
        <span class="m9e-trace">
          {#each QS as qq, k}
            <i class:fait={e >= k + 1} class:ok={qq.r[i] === 1} class:h={qq.hockey}></i>
          {/each}
        </span>
        <span class="m9e-nom">{#if e >= 5 && i === NOAH}Noah{:else if e >= 5 && i === LEA}Léa{/if}</span>
      </div>
    {/each}
  </div>
  <div class="m9e-axe"><span>moyenne en histoire : du plus faible</span><span class="m9e-fl"></span><span>au plus fort</span></div>

  {#key e}
    <p class="m9e-note" class:rouge={e >= 4}>{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9e { display: flex; flex-direction: column; gap: 0.7em; max-width: 60em; margin: 0 auto; }
  .m9e-carte { align-self: center; min-width: 26em; border: 3px solid var(--dk-encre); padding: 0.45em 1.2em; display: flex; gap: 0.8em; align-items: baseline; justify-content: center; transition: border-color 0.3s; }
  .m9e-carte.rouge { border-color: var(--dk-accent); color: var(--dk-accent); }
  .m9e-carte.vide { border-style: dashed; border-color: var(--dk-filet); }
  .m9e-num { font-size: 1.1em; font-weight: 700; color: var(--dk-accent); animation: m9e-entre 0.35s both; }
  .m9e-titre { font-size: 1.35em; font-weight: 700; animation: m9e-entre 0.35s both; }
  .m9e-titre.pale { color: var(--dk-gris); font-weight: 600; }
  .m9e-rang { display: grid; grid-template-columns: repeat(12, 1fr); gap: 0.4em; align-items: end; margin-top: 0.4em; }
  .m9e-eleve { display: flex; flex-direction: column; align-items: center; gap: 0.15em; }
  .m9e-coche { height: 1.2em; font-size: 1.2em; font-weight: 800; line-height: 1; color: var(--dk-encre); }
  .m9e-eleve.rouge .m9e-coche { color: var(--dk-accent); }
  .m9e-eleve svg { width: 72%; height: auto; overflow: visible; transition: transform 0.35s; transition-delay: calc(var(--i) * 45ms); }
  .m9e-eleve svg circle, .m9e-eleve svg path { fill: transparent; stroke: var(--dk-encre); stroke-width: 4; transition: fill 0.3s, stroke 0.3s; transition-delay: calc(var(--i) * 45ms); }
  .m9e-eleve.ok svg { transform: translateY(-10px); }
  .m9e-eleve.ok svg circle, .m9e-eleve.ok svg path { fill: var(--dk-encre); }
  .m9e-eleve.rouge svg circle, .m9e-eleve.rouge svg path { stroke: var(--dk-accent); }
  .m9e-eleve.rouge.ok svg circle, .m9e-eleve.rouge.ok svg path { fill: var(--dk-accent); }
  .m9e-eleve.cerne svg { outline: 4px solid var(--dk-encre); outline-offset: 6px; }
  .m9e-moy { font-size: 0.85em; font-weight: 700; }
  .m9e-trace { display: flex; gap: 3px; margin-top: 0.15em; }
  .m9e-trace i { width: 0.6em; height: 0.6em; border: 2px solid var(--dk-filet); }
  .m9e-trace i.fait { border-color: var(--dk-encre); }
  .m9e-trace i.fait.ok { background: var(--dk-encre); }
  .m9e-trace i.fait.h { border-color: var(--dk-accent); }
  .m9e-trace i.fait.h.ok { background: var(--dk-accent); }
  .m9e-nom { min-height: 1.2em; font-size: 0.85em; font-weight: 800; color: var(--dk-accent); }
  .m9e-axe { display: flex; align-items: center; gap: 0.6em; font-size: 0.7em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .m9e-fl { flex: 1; height: 2px; background: var(--dk-gris); position: relative; }
  .m9e-fl::after { content: ''; position: absolute; right: -2px; top: -5px; border-left: 10px solid var(--dk-gris); border-top: 6px solid transparent; border-bottom: 6px solid transparent; }
  .m9e-note { margin: 0.2em 0 0; text-align: center; font-size: 1.2em; font-weight: 700; min-height: 1.4em; animation: m9e-entre 0.4s both; }
  .m9e-note.rouge { color: var(--dk-accent); }
  @keyframes m9e-entre { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9e-eleve svg, .m9e-eleve svg circle, .m9e-eleve svg path { transition: none; } .m9e-num, .m9e-titre, .m9e-note { animation: none; } }
</style>
