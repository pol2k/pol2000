<script>
  /**
   * La session en une bande, comme dans le deck: quinze cases (quatorze
   * séances et la semaine de lecture), trois parties en trois tons, et
   * sous la bande, la liste. Chaque case mène à sa ligne. Le passé, le
   * présent et l'avenir se distinguent d'après la date.
   */
  import { base } from '$app/paths';
  import { PARTIES, SEANCES } from '$lib/data/cours.js';
  import { aujourdhui, courte, longue, prochaineSeance } from './dates.js';

  let ref = $state(aujourdhui());
  $effect(() => { ref = aujourdhui(); });
  const prochaine = $derived(prochaineSeance(ref));
  const etat = (s) => (s.lecture ? '' : prochaine && s.n === prochaine.n ? 'on' : s.date < ref ? 'fait' : '');
  const TONS = ['hors', 'p1', 'p2', 'p3'];
</script>

<div class="frise">
  <div class="bande" role="list">
    {#each SEANCES as s}
      {#if s.lecture}
        <div class="case vide" role="listitem"><span class="n">—</span><span class="t">Lecture</span><span class="d">{courte(s.date)}</span></div>
      {:else}
        <a href="#seance-{s.n}" class="case {TONS[s.partie]} {etat(s)}" role="listitem" title={s.titre}>
          <span class="n">{s.n}</span>
          <span class="t">{s.court}</span>
          <span class="d">{courte(s.date)}</span>
          {#if s.examen}<span class="ex">examen</span>{/if}
        </a>
      {/if}
    {/each}
  </div>
  <div class="legende">
    {#each PARTIES as p}<span><i class="p{p.n}"></i>{p.n} · {p.nom}</span>{/each}
  </div>

  <ol class="liste">
    {#each SEANCES as s}
      {#if s.lecture}
        <li class="lecture" id="lecture">
          <span class="num">—</span>
          <div class="corps">
            <p class="jour">{longue(s.date)}</p>
            <h3>{s.titre}</h3>
            <p class="resume">{s.resume}</p>
          </div>
        </li>
      {:else}
        <li id="seance-{s.n}" class="{etat(s)} {TONS[s.partie]}">
          <span class="num">{s.n}</span>
          <div class="corps">
            <p class="jour">{longue(s.date)}{#if s.examen} · <span class="ex-l">examen en classe</span>{/if}</p>
            <h3>{s.titre}</h3>
            <p class="resume">{s.resume}</p>
            {#if s.note}<p class="note">{s.note}</p>{/if}
          </div>
          <div class="action">
            {#if s.deck}
              <a class="bouton" href="{base}/{s.deck}">Diapositives <span class="fl">→</span></a>
            {:else}
              <span class="etiq gris">à venir</span>
            {/if}
          </div>
        </li>
      {/if}
    {/each}
  </ol>
</div>

<style>
  .frise { display: flex; flex-direction: column; gap: 0.7rem; }
  .bande { display: grid; grid-template-columns: repeat(15, minmax(4.3rem, 1fr)); gap: 3px; overflow-x: auto; scrollbar-width: thin; padding-bottom: 2px; }
  .case { display: flex; flex-direction: column; gap: 0.15rem; padding: 0.55rem 0.5rem 0.5rem; min-height: 6rem; border-top: 6px solid var(--encre); background: var(--fond-2); color: var(--encre); text-decoration: none; position: relative; transition: background 0.15s; }
  a.case:hover { background: var(--encre); color: var(--fond); text-decoration: none; }
  a.case:hover .d { color: var(--gris-2); }
  .case.p1 { border-top-color: var(--encre); }
  .case.p2 { border-top-color: var(--gris); }
  .case.p3 { border-top-color: var(--accent); }
  .case.hors { border-top-style: dashed; background: transparent; }
  .case.vide { border-top: 6px dotted var(--filet); background: transparent; color: var(--gris); }
  .case .n { font-weight: 600; font-size: 1rem; color: var(--accent); }
  .case.vide .n, .case.hors .n { color: var(--gris); }
  .case .t { font-size: 0.64rem; line-height: 1.2; font-weight: 600; }
  .case .d { font-size: 0.6rem; color: var(--gris); margin-top: auto; }
  .case .ex { position: absolute; bottom: 0.45rem; right: 0.4rem; font-size: 0.5rem; letter-spacing: 0.1em; text-transform: uppercase; background: var(--encre); color: var(--fond); padding: 0.1em 0.3em; }
  a.case:hover .ex { background: var(--accent-clair); color: var(--encre); }
  .case.fait .n { color: var(--gris-2); }
  .case.fait .t { color: var(--gris); }
  .case.on { outline: 3px solid var(--accent); outline-offset: -3px; }
  .legende { display: flex; gap: 1.6rem; font-size: 0.66rem; letter-spacing: 0.08em; color: var(--gris); flex-wrap: wrap; }
  .legende i { display: inline-block; width: 1.6em; height: 0.45em; vertical-align: middle; margin-right: 0.4em; }
  .legende .p1 { background: var(--encre); } .legende .p2 { background: var(--gris); } .legende .p3 { background: var(--accent); }

  .liste { list-style: none; margin: 1.6rem 0 0; padding: 0; border-top: var(--trait); }
  .liste li { display: grid; grid-template-columns: 4rem minmax(0, 1fr) auto; gap: 1.2rem; align-items: start; padding: 1.3rem 0.4rem; border-bottom: var(--trait-fin); scroll-margin-top: 4.5rem; transition: background 0.2s; }
  .liste li:hover { background: var(--fond-2); }
  .liste li.on { border-left: 5px solid var(--accent); padding-left: 1rem; }
  .num { font-size: 2.4rem; font-weight: 600; line-height: 0.9; letter-spacing: -0.05em; color: var(--gris-2); }
  li.fait .num { color: var(--encre); }
  li.on .num { color: var(--accent); }
  li.lecture .num { color: var(--filet); }
  .corps { display: flex; flex-direction: column; gap: 0.35rem; min-width: 0; }
  .jour { font-size: 0.66rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--gris); }
  .ex-l { color: var(--accent); font-weight: 600; }
  h3 { font-size: 1.12rem; line-height: 1.2; }
  li.fait h3 { color: var(--gris); }
  li.lecture h3 { color: var(--gris); }
  .resume { font-size: 0.86rem; color: var(--gris); max-width: var(--mesure); }
  .note { font-size: 0.8rem; font-weight: 600; }
  .action { align-self: center; }
  @media (max-width: 40rem) {
    .liste li { grid-template-columns: 2.6rem minmax(0, 1fr); }
    .num { font-size: 1.6rem; }
    .action { grid-column: 2; justify-self: start; }
  }
</style>
