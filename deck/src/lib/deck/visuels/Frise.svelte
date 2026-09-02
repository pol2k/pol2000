<script>
  /**
   * La session en une bande: quatorze séances, la semaine de lecture, les
   * trois parties en teintes, et — sur demande — les examens et remises
   * posés dessus. Toutes les dates viennent du plan de cours A26.
   */
  let { evaluations = false } = $props();

  const S = [
    { n: 1, d: '3 sept', t: 'Intro', p: 1 },
    { n: 2, d: '10 sept', t: 'R', p: 1 },
    { n: 3, d: '17 sept', t: 'Décrire', p: 1 },
    { n: 4, d: '24 sept', t: 'Données', p: 1, ex: 'Ex. 1 ouvre' },
    { n: 5, d: '1 oct', t: 'Inférence', p: 1, rem: 'Ex. 1 · dim. 4' },
    { n: 6, d: '8 oct', t: 'Rencontres', p: 0 },
    { n: 7, d: '15 oct', t: 'Régression', p: 2 },
    { n: 8, d: '22 oct', t: 'Examen 2', p: 2, ex: 'Ex. 2 · 1 h', rem: 'Mi-session · dim. 25' },
    { n: '—', d: '29 oct', t: 'Lecture', p: -1 },
    { n: 9, d: '5 nov', t: 'Multiple', p: 2 },
    { n: 10, d: '12 nov', t: 'Main, puis IA', p: 2 },
    { n: 11, d: '19 nov', t: 'GOA', p: 3 },
    { n: 12, d: '26 nov', t: 'Causalité', p: 3 },
    { n: 13, d: '3 déc', t: 'Biais', p: 3 },
    { n: 14, d: '10 déc', t: 'Expériences', p: 3, ex: 'Ex. 3 · 1 h', rem: 'Final · ven. 18' }
  ];
</script>

<div class="frise" role="img" aria-label="Les quatorze séances de la session, en trois parties, avec les examens et les remises.">
  <div class="bande">
    {#each S as s}
      <div class="case p{s.p}" class:vide={s.p === -1} class:hors={s.p === 0}>
        <span class="n">{s.n}</span>
        <span class="t">{s.t}</span>
        <span class="d">{s.d}</span>
        {#if evaluations && s.ex}<span class="ex">✎ {s.ex}</span>{/if}
        {#if evaluations && s.rem}<span class="rem">↓ {s.rem}</span>{/if}
      </div>
    {/each}
  </div>
  <div class="legende">
    <span><i class="p1"></i> 1 · Concepts de base</span>
    <span><i class="p2"></i> 2 · Régression</span>
    <span><i class="p3"></i> 3 · Inférence causale</span>
    {#if evaluations}<span>✎ examen &nbsp; ↓ remise</span>{/if}
  </div>
</div>

<style>
  .frise { display: flex; flex-direction: column; gap: 0.7em; }
  .bande { display: grid; grid-template-columns: repeat(15, minmax(0, 1fr)); gap: 3px; }
  .case { display: flex; flex-direction: column; gap: 0.15em; padding: 0.45em 0.3em 0.4em; min-height: 6.2em; border-top: 6px solid var(--dk-encre); background: var(--dk-fond-2); }
  .case.p1 { border-top-color: var(--dk-encre); }
  .case.p2 { border-top-color: var(--dk-gris); }
  .case.p3 { border-top-color: var(--dk-accent); }
  .case.hors { border-top-style: dashed; background: transparent; }
  .case.vide { border-top: 6px dotted var(--dk-filet); background: transparent; }
  .n { font-family: var(--dk-mono); font-weight: 600; font-size: 0.95em; color: var(--dk-accent); }
  .vide .n, .hors .n { color: var(--dk-gris); }
  .t { font-size: 0.6em; line-height: 1.15; font-weight: 600; }
  .d { font-size: 0.5em; color: var(--dk-gris); }
  .ex, .rem { font-size: 0.5em; line-height: 1.15; margin-top: 0.3em; padding: 0.15em 0.25em; }
  .ex { background: var(--dk-encre); color: var(--dk-fond); }
  .rem { border: 1.5px solid var(--dk-accent); color: var(--dk-accent); font-weight: 600; }
  .legende { display: flex; gap: 1.6em; font-size: 0.62em; color: var(--dk-gris); }
  .legende i { display: inline-block; width: 1.6em; height: 0.45em; vertical-align: middle; margin-right: 0.3em; }
  .legende .p1 { background: var(--dk-encre); } .legende .p2 { background: var(--dk-gris); } .legende .p3 { background: var(--dk-accent); }
</style>
