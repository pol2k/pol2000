<script>
  /**
   * Le plan de la séance 8, en deux moitiés : comprendre (ajouter des
   * variables, lire chaque coefficient), la pause, puis coder (l'atelier,
   * du brut au tableau, et un exercice). Pas de temps.
   */
  const MOITIES = [
    { n: '1', titre: 'Comprendre', items: ['Ajouter des variables', 'Lire chaque coefficient'] },
    { n: '2', titre: 'Coder', items: ['Du brut au tableau, ensemble', 'Puis à vous'] }
  ];
</script>

<div class="visuel auj8">
  {#each MOITIES as m, i}
    <div class="a8-bloc" class:a8-code={i === 1} style="--i: {i}">
      <span class="a8-n">{m.n}</span>
      <strong>{m.titre}</strong>
      {#each m.items as it}<span class="a8-it">{it}</span>{/each}
    </div>
    {#if i === 0}<div class="a8-pause"><span>pause</span></div>{/if}
  {/each}
</div>

<style>
  .auj8 { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.6em; align-items: stretch; max-width: 58em; margin: 1.2em auto 0; }
  .a8-bloc { border: 3px solid var(--dk-encre); padding: 1.4em 1.6em; display: flex; flex-direction: column; gap: 0.5em; animation: a8-fondu 0.5s both; animation-delay: calc(var(--i) * 0.2s); }
  .a8-bloc.a8-code { border-color: var(--dk-accent); }
  .a8-n { font-size: 3.2em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .a8-bloc strong { font-size: 1.5em; margin-bottom: 0.3em; }
  .a8-it { font-size: 1.05em; color: var(--dk-gris); }
  .a8-pause { display: flex; align-items: center; }
  .a8-pause span { writing-mode: vertical-rl; transform: rotate(180deg); font-size: 0.8em; letter-spacing: 0.2em; text-transform: uppercase; color: var(--dk-gris-2); border-left: 2px dashed var(--dk-gris-2); padding-left: 0.5em; }
  @keyframes a8-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .a8-bloc { animation: none; } }
</style>
