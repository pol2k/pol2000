<script>
  /**
   * L'examen d'histoire du secondaire. Vingt élèves, rangés selon leur
   * moyenne en histoire cette année, du plus faible au plus fort. Une bonne
   * question est réussie par les forts et ratée par les faibles. La question
   * sur le hockey ne suit pas : elle mesure autre chose. C'est l'intuition de
   * la fiabilité : chaque question doit aller avec chaque autre.
   *
   *   0  les élèves et leur moyenne;
   *   1  la première question se remplit, de gauche à droite;
   *   2  les quatre suivantes : même motif;
   *   3  Léa, forte, réussit tout;
   *   4  Noah, faible, rate tout;
   *   5  la question sur le hockey;
   *   6  elle passe au rouge : Noah la réussit, Léa la rate.
   *
   * Réussites : un motif fixe, pas un tirage. Données fictives.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 6, lire: () => e, ecrire: (v) => (e = v) });
  });

  const MOY = [48, 52, 55, 57, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 85, 88, 91, 95];
  const N = MOY.length;
  const FORT = 19, FAIBLE = 2;   // Léa et Noah, rang 1 = le plus faible
  const HOCKEY = [1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1];
  const QS = [
    { t: 'La fondation de Québec', seuil: 6, temps: 1 },
    { t: 'La Conquête', seuil: 8, temps: 2 },
    { t: 'Les Patriotes', seuil: 11, temps: 2 },
    { t: 'La Confédération', seuil: 9, temps: 2 },
    { t: 'La Révolution tranquille', seuil: 7, temps: 2 },
    { t: 'Les Coupes Stanley du Canadien', hockey: true, temps: 5 }
  ];
  // Un petit décalage propre à l'élève et à la question : du bruit, toujours le même.
  const bruit = (i, q) => ((i * 7 + q * 5) % 5) - 2;
  const reussi = (i, q) => (QS[q].hockey ? HOCKEY[i - 1] === 1 : i > QS[q].seuil + bruit(i, q));
  const score = (q) => Array.from({ length: N }, (_, k) => reussi(k + 1, q)).filter(Boolean).length;
  const ELEVES = Array.from({ length: N }, (_, k) => k + 1);
  const NOTES = [
    'Vingt élèves, rangés selon leur moyenne en histoire cette année.',
    'Les forts réussissent. Les faibles ratent.',
    'Même motif, question après question.',
    'Léa, 91 % de moyenne : réussit les cinq.',
    'Noah, 52 % de moyenne : rate les cinq.',
    'Et cette question-là ?',
    'Noah la réussit, Léa la rate. Les forts ne font pas mieux que les faibles : elle mesure le hockey, pas l’histoire.'
  ];
  const rouge = $derived(e >= 6);
</script>

<div class="visuel m9e" bind:this={hote}>
  <div class="m9e-grille" style="--n: {N}">
    <span class="m9e-tete">moyenne en histoire</span>
    <div class="m9e-rang m9e-moys">
      {#each ELEVES as i}
        <span class="m9e-moy" class:fort={e >= 3 && i === FORT} class:faible={e >= 4 && i === FAIBLE}>{MOY[i - 1]}</span>
      {/each}
    </div>
    <span class="m9e-tete m9e-sc">réussi</span>

    {#each QS as q, k}
      {@const vu = e >= q.temps}
      <span class="m9e-q" class:vu class:rouge={rouge && q.hockey}>Q{k + 1} · {q.t}</span>
      <div class="m9e-rang" class:vu class:hockey={q.hockey} class:rouge={rouge && q.hockey}>
        {#each ELEVES as i}
          <span
            class="m9e-cell"
            class:ok={reussi(i, k)}
            class:col-fort={vu && e >= 3 && i === FORT}
            class:col-faible={vu && e >= 4 && i === FAIBLE}
            class:cerne={rouge && q.hockey && (i === FORT || i === FAIBLE)}
            style="--d: {(q.temps === 2 ? (k - 1) * 160 : 0) + i * 28}ms"
          ></span>
        {/each}
      </div>
      <span class="m9e-score" class:vu class:rouge={rouge && q.hockey}>{score(k)}/{N}</span>
    {/each}

    <span></span>
    <div class="m9e-rang m9e-noms">
      {#each ELEVES as i}
        <span class="m9e-nom">
          {#if i === FORT}<b class:vu={e >= 3}>Léa</b>{/if}
          {#if i === FAIBLE}<b class:vu={e >= 4}>Noah</b>{/if}
        </span>
      {/each}
    </div>
    <span></span>
  </div>
  {#key e}
    <p class="m9e-note" class:rouge>{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9e { display: flex; flex-direction: column; gap: 0.7em; max-width: 64em; margin: 0.2em auto 0; }
  .m9e-grille { display: grid; grid-template-columns: 15em 1fr 3.4em; gap: 0.45em 0.9em; align-items: center; }
  .m9e-tete { font-size: 0.66em; color: var(--dk-gris); letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; }
  .m9e-sc { text-align: right; }
  .m9e-rang { display: grid; grid-template-columns: repeat(var(--n), 1fr); gap: 0.3em; }
  .m9e-moys { border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.25em; }
  .m9e-moy { font-size: 0.72em; font-weight: 600; text-align: center; color: var(--dk-gris); transition: color 0.3s; }
  .m9e-moy.fort, .m9e-moy.faible { color: var(--dk-accent); font-weight: 800; }
  .m9e-q { font-size: 0.82em; font-weight: 600; opacity: 0.15; transition: opacity 0.4s, color 0.4s; }
  .m9e-q.vu { opacity: 1; }
  .m9e-cell { aspect-ratio: 1; border: 2px solid var(--dk-filet); background: transparent; transition: background 0.25s, border-color 0.25s, outline-color 0.3s; transition-delay: 0ms; outline: 3px solid transparent; outline-offset: 2px; }
  .m9e-rang.vu .m9e-cell { border-color: var(--dk-encre); transition-delay: var(--d); }
  .m9e-rang.vu .m9e-cell.ok { background: var(--dk-encre); }
  .m9e-cell.col-fort, .m9e-cell.col-faible { outline-color: var(--dk-accent); transition-delay: 0ms; }
  .m9e-rang.rouge .m9e-cell { border-color: var(--dk-accent); transition-delay: 0ms; }
  .m9e-rang.rouge .m9e-cell.ok { background: var(--dk-accent); }
  .m9e-cell.cerne { outline: 4px solid var(--dk-encre); outline-offset: 3px; }
  .m9e-score { font-size: 0.85em; font-weight: 700; text-align: right; opacity: 0; transition: opacity 0.4s, color 0.4s; }
  .m9e-score.vu { opacity: 1; }
  .m9e-q.rouge, .m9e-score.rouge { color: var(--dk-accent); }
  .m9e-nom { text-align: center; font-size: 0.78em; min-height: 1.2em; }
  .m9e-nom b { color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .m9e-nom b.vu { opacity: 1; }
  .m9e-note { margin: 0; font-size: 1.05em; font-weight: 600; min-height: 2.7em; animation: m9e-fondu 0.4s both; }
  .m9e-note.rouge { color: var(--dk-accent); }
  @keyframes m9e-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .m9e-q, .m9e-cell, .m9e-score, .m9e-nom b { transition: none; } .m9e-note { animation: none; } }
</style>
