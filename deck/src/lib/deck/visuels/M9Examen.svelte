<script>
  /**
   * L'examen d'histoire (l'analogie du cours 5 de FAS1001) : cinq questions,
   * vingt-quatre élèves rangés du plus faible au plus fort. Une bonne
   * question est réussie par les forts et ratée par les faibles; la question
   * sur les cigares de Churchill fait l'inverse. C'est ce que l'analyse
   * factorielle repère : une question qui ne « bouge » pas avec les autres.
   *
   * Une rangée par clic (temps 1 à 5), puis la cinquième passe au rouge
   * (temps 6). Les réussites sont un motif fixe, pas un tirage : un schéma,
   * données fictives.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 6, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = 24;
  const QS = [
    { t: 'Q1 · Les causes de la guerre', seuil: 8 },
    { t: 'Q2 · L’opération Barbarossa', seuil: 11 },
    { t: 'Q3 · L’impact économique', seuil: 9 },
    { t: 'Q4 · Les accords de Yalta', seuil: 13 },
    { t: 'Q5 · Les cigares de Churchill', seuil: 10, inverse: true }
  ];
  // Réussi si l'élève (1 = le plus faible) dépasse le seuil, à un petit
  // décalage près qui dépend de l'élève et de la question : du bruit, mais
  // toujours le même.
  const bruit = (i, q) => ((i * 7 + q * 5) % 5) - 2;
  const reussi = (i, q) => {
    const s = QS[q].seuil + bruit(i, q);
    return QS[q].inverse ? i <= s : i > s;
  };
  const score = (q) => Array.from({ length: N }, (_, k) => reussi(k + 1, q)).filter(Boolean).length;
  const NOTES = [
    'Vingt-quatre élèves, du plus faible au plus fort.',
    'Les forts réussissent, les faibles ratent.',
    'Même motif.',
    'Même motif.',
    'Même motif.',
    'Et celle-là ?',
    'Les meilleurs échouent, les plus faibles réussissent : elle ne mesure pas l’histoire.'
  ];
</script>

<div class="visuel m9e" bind:this={hote}>
  <div class="m9e-grille" style="--n: {N}">
    <span class="m9e-coin"></span>
    <div class="m9e-axe"><span>élèves, du plus faible au plus fort</span><span class="m9e-fl">→</span></div>
    <span class="m9e-coin m9e-sc">réussi</span>
    {#each QS as q, k}
      <span class="m9e-q" class:vu={e >= k + 1} class:rouge={e >= 6 && q.inverse}>{q.t}</span>
      <div class="m9e-rang" class:vu={e >= k + 1} class:rouge={e >= 6 && q.inverse}>
        {#each Array.from({ length: N }, (_, i) => i + 1) as i}
          <span class="m9e-cell" class:ok={reussi(i, k)} style="--i: {i}"></span>
        {/each}
      </div>
      <span class="m9e-sc m9e-score" class:vu={e >= k + 1} class:rouge={e >= 6 && q.inverse}>{score(k)}/{N}</span>
    {/each}
  </div>
  {#key e}
    <p class="m9e-note" class:rouge={e >= 6}>{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9e { display: flex; flex-direction: column; gap: 0.9em; max-width: 62em; margin: 0.6em auto 0; }
  .m9e-grille { display: grid; grid-template-columns: 15em 1fr 4em; gap: 0.5em 1em; align-items: center; }
  .m9e-axe { display: flex; justify-content: space-between; font-size: 0.68em; color: var(--dk-gris); letter-spacing: 0.08em; text-transform: uppercase; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; }
  .m9e-fl { font-weight: 700; }
  .m9e-sc { font-size: 0.68em; color: var(--dk-gris); text-align: right; letter-spacing: 0.08em; text-transform: uppercase; }
  .m9e-q { font-size: 0.85em; font-weight: 600; opacity: 0; transition: opacity 0.4s, color 0.4s; }
  .m9e-rang { display: grid; grid-template-columns: repeat(var(--n), 1fr); gap: 0.25em; opacity: 0; transition: opacity 0.4s; }
  .m9e-cell { aspect-ratio: 1; border: 2px solid var(--dk-encre); background: transparent; transition: background 0.3s, border-color 0.3s; }
  .m9e-cell.ok { background: var(--dk-encre); }
  .m9e-score { font-size: 0.9em; font-weight: 700; color: var(--dk-encre); text-transform: none; letter-spacing: 0; opacity: 0; transition: opacity 0.4s; }
  .vu { opacity: 1 !important; }
  .m9e-q.rouge, .m9e-score.rouge { color: var(--dk-accent); }
  .m9e-rang.rouge .m9e-cell { border-color: var(--dk-accent); }
  .m9e-rang.rouge .m9e-cell.ok { background: var(--dk-accent); }
  .m9e-note { margin: 0; font-size: 1.05em; font-weight: 600; animation: m9e-fondu 0.4s both; }
  .m9e-note.rouge { color: var(--dk-accent); }
  @keyframes m9e-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .m9e-q, .m9e-rang, .m9e-score, .m9e-cell { transition: none; } .m9e-note { animation: none; } }
</style>
