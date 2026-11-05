<script>
  /**
   * L'examen d'histoire du secondaire, joué en classe. Douze élèves, avec
   * leur prénom et leur moyenne en histoire, rangés de gauche à droite de la
   * plus faible moyenne à la plus forte. Pour chaque question, ils marchent
   * vers la bande « Réussi » (en haut) ou « Raté » (en bas). Comme le rang
   * ne change jamais, le motif se lit d'un coup d'œil : en haut à droite les
   * forts, en bas à gauche les faibles. Au clic :
   *
   *   0  les douze élèves attendent dans le couloir;
   *   1  Q1, la fondation de Québec : les forts montent, les faibles descendent;
   *   2  Q2, la Conquête : même motif;
   *   3  Q3, la Révolution tranquille : encore;
   *   4  Q4, les Coupes Stanley du Canadien, en rouge : tout se mélange;
   *   5  Noah (58) la réussit, Léa (89) la rate, les autres s'effacent.
   *
   * Un clic sur un.e élève ouvre sa fiche (✓ ou ✗ pour chaque question déjà
   * posée) sans faire avancer la diapo : l'écouteur est natif, sur l'hôte,
   * pour passer avant celui que brancherTemps pose sur la diapo.
   *
   * Réussites : un motif fixe, pas un tirage. Données fictives.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let avant = $state(0);
  let choisi = $state(-1);
  let hote = $state(null);

  $effect(() => {
    if (!hote) return;
    e = 0;
    avant = 0;
    choisi = -1;
    const defaire = brancherTemps(hote, {
      total: 5,
      lire: () => e,
      ecrire: (v) => {
        avant = untrack(() => e);
        e = v;
        if (v === 0) choisi = -1;
      }
    });
    function surEleve(ev) {
      const b = ev.target.closest?.('.m9e-eleve');
      if (!b || !hote.contains(b)) return;
      ev.stopPropagation();
      const i = Number(b.dataset.i);
      choisi = choisi === i ? -1 : i;
      b.blur();
    }
    hote.addEventListener('click', surEleve);
    return () => {
      hote.removeEventListener('click', surEleve);
      defaire();
    };
  });

  // Du plus faible au plus fort. Le rang fixe la colonne.
  const ELEVES = [
    { nom: 'Samuel', moy: 51 },
    { nom: 'Jade', moy: 55 },
    { nom: 'Noah', moy: 58 },
    { nom: 'Amira', moy: 62 },
    { nom: 'Thomas', moy: 65 },
    { nom: 'Rosalie', moy: 69 },
    { nom: 'William', moy: 72 },
    { nom: 'Maya', moy: 76 },
    { nom: 'Olivier', moy: 80 },
    { nom: 'Florence', moy: 84 },
    { nom: 'Léa', moy: 89 },
    { nom: 'Félix', moy: 93 }
  ];
  const NOAH = 2, LEA = 10;

  // 1 = réussi. Histoire : 2 faibles sur 6 au plus réussissent, 5 ou 6 forts
  // sur 6, avec une ou deux exceptions près du milieu. Hockey : 3 sur 6 de
  // chaque côté, éparpillés.
  const QS = [
    { t: 'La fondation de Québec', r: [0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1] },
    { t: 'La Conquête', r: [0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1] },
    { t: 'La Révolution tranquille', r: [0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1] },
    { t: 'Les Coupes Stanley du Canadien', r: [1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1], hockey: true }
  ];

  const NOTES = [
    'Douze élèves, de la plus faible moyenne à la plus forte.',
    'Les forts réussissent. Les faibles ratent.',
    'Même motif.',
    'Encore. Les questions vont ensemble.',
    'Le motif se brise.',
    'Noah réussit, Léa rate : cette question mesure le hockey.'
  ];

  // Combien de questions posées, et laquelle est à l'écran.
  const posees = (k) => Math.min(k, 4);
  const q = $derived(posees(e) - 1);
  const Q = $derived(q >= 0 ? QS[q] : null);

  // La bande où se tient l'élève i au temps k.
  function bande(i, k) {
    if (k === 0) return 'attente';
    return QS[posees(k) - 1].r[i] ? 'haut' : 'bas';
  }
  const fiche = $derived(choisi >= 0 ? ELEVES[choisi] : null);
</script>

<div class="visuel m9e" bind:this={hote}>
  <div class="m9e-tete">
    <div class="m9e-carte" class:vide={!Q} class:rouge={Q?.hockey}>
      {#key q}
        {#if Q}<span class="m9e-num">Q{q + 1}</span><span class="m9e-titre">{Q.t}</span>{:else}<span class="m9e-titre pale">L’examen d’histoire</span>{/if}
      {/key}
    </div>
    <div class="m9e-fiche" class:vu={fiche} aria-live="polite">
      {#if fiche}
        <span class="m9e-fiche-nom">{fiche.nom} <b>{fiche.moy}</b></span>
        <span class="m9e-fiche-q">
          {#each QS as qq, k}
            {#if k < posees(e)}
              <span class:h={qq.hockey} class:rate={!qq.r[choisi]}>Q{k + 1}{qq.r[choisi] ? '✓' : '✗'}</span>
            {/if}
          {/each}
        </span>
      {/if}
    </div>
  </div>

  <div class="m9e-scene">
    <div class="m9e-gouttiere">
      <span class="m9e-lab haut"><b>✓</b>Réussi</span>
      <span class="m9e-lab bas"><b>✗</b>Raté</span>
    </div>
    <div class="m9e-piste" class:focus={e >= 5}>
      <div class="m9e-bande haut"></div>
      <div class="m9e-couloir"></div>
      <div class="m9e-bande bas"></div>
      {#each ELEVES as el, i}
        {@const b = bande(i, e)}
        {@const bouge = bande(i, avant) !== b}
        <button
          type="button"
          class="m9e-eleve {b}"
          class:rouge={Q?.hockey}
          class:cerne={e >= 5 && (i === NOAH || i === LEA)}
          class:choisi={choisi === i}
          data-i={i}
          style="--i: {i}"
          aria-label="{el.nom}, moyenne {el.moy}"
        >
          {#key q}
            <svg viewBox="0 0 60 90" aria-hidden="true" class:pas={bouge}>
              <circle cx="30" cy="18" r="13" />
              <path d="M 7 88 Q 7 40 30 40 Q 53 40 53 88 Z" />
            </svg>
          {/key}
          <span class="m9e-nom">{el.nom}</span>
          <span class="m9e-ligne">
            <span class="m9e-moy">{el.moy}</span>
            <span class="m9e-trace">
              {#each QS as qq, k}
                <i class:fait={k < posees(e)} class:ok={qq.r[i] === 1} class:h={qq.hockey}></i>
              {/each}
            </span>
          </span>
        </button>
      {/each}
    </div>
  </div>

  <div class="m9e-axe"><span>moyenne en histoire : faible</span><span class="m9e-fl"></span><span>forte</span></div>

  {#key e}
    <p class="m9e-note" class:rouge={e >= 4}>{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9e { display: flex; flex-direction: column; gap: 0.55em; max-width: 60em; margin: 0 auto; }

  /* L'en-tête : la carte de la question au centre, la fiche à droite. */
  .m9e-tete { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; height: 2.6em; }
  .m9e-carte { grid-column: 2; min-width: 24em; border: 3px solid var(--dk-encre); padding: 0.4em 1.1em; display: flex; gap: 0.8em; align-items: baseline; justify-content: center; transition: border-color 0.3s, color 0.3s; }
  .m9e-carte.rouge { border-color: var(--dk-accent); color: var(--dk-accent); }
  .m9e-carte.vide { border-style: dashed; border-color: var(--dk-filet); }
  .m9e-num { font-size: 1.05em; font-weight: 700; color: var(--dk-accent); animation: m9e-entre 0.35s both; }
  .m9e-titre { font-size: 1.25em; font-weight: 700; white-space: nowrap; animation: m9e-entre 0.35s both; }
  .m9e-titre.pale { color: var(--dk-gris); font-weight: 600; }
  .m9e-fiche { grid-column: 3; justify-self: end; display: flex; flex-direction: column; align-items: flex-end; gap: 0.15em; min-width: 9em; padding: 0.25em 0.6em; border: 2px solid transparent; font-size: 0.78em; opacity: 0; transition: opacity 0.25s; }
  .m9e-fiche.vu { opacity: 1; border-color: var(--dk-encre); }
  .m9e-fiche-nom { font-weight: 800; }
  .m9e-fiche-nom b { color: var(--dk-gris); }
  .m9e-fiche-q { display: flex; gap: 0.5em; font-weight: 700; }
  .m9e-fiche-q .rate { color: var(--dk-gris); }
  .m9e-fiche-q .h { color: var(--dk-accent); }

  /* La scène : une gouttière d'étiquettes, puis la piste à deux bandes. */
  .m9e-scene { display: grid; grid-template-columns: 4.4em 1fr; }
  .m9e-gouttiere { position: relative; height: 12.4em; }
  .m9e-lab { position: absolute; left: 0; display: flex; flex-direction: column; align-items: flex-start; font-size: 0.7em; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
  .m9e-lab b { font-size: 2em; line-height: 1; letter-spacing: 0; }
  .m9e-lab.haut { top: 0.6em; }
  .m9e-lab.bas { bottom: 0.6em; color: var(--dk-gris); }
  .m9e-piste { position: relative; height: 12.4em; }
  .m9e-bande { position: absolute; left: 0; right: 0; height: 5.6em; }
  .m9e-bande.haut { top: 0; background: var(--dk-fond-2); border-top: 2px solid var(--dk-encre); }
  .m9e-bande.bas { bottom: 0; border-bottom: 2px solid var(--dk-gris); background: transparent; }
  .m9e-couloir { position: absolute; left: 0; right: 0; top: 6.2em; border-top: 2px dashed var(--dk-filet); }

  /* Un.e élève : une colonne fixe (son rang), une hauteur qui change (sa bande). */
  .m9e-eleve {
    position: absolute; top: 0; left: calc(var(--i) * 100% / 12); width: calc(100% / 12); height: 5.6em;
    display: flex; flex-direction: column; align-items: center; justify-content: flex-end; gap: 0.1em;
    padding: 0 0 0.25em; margin: 0; border: 0; background: none; font: inherit; color: inherit; cursor: pointer;
    transform: translateY(3.4em);
    transition: transform 0.6s cubic-bezier(0.4, 0, 0.3, 1), opacity 0.4s;
    transition-delay: calc(var(--i) * 40ms);
  }
  .m9e-eleve.haut { transform: translateY(0); }
  .m9e-eleve.bas { transform: translateY(6.8em); }
  .m9e-eleve:focus-visible, .m9e-eleve.choisi { outline: 2px solid var(--dk-encre); outline-offset: -2px; }
  .m9e-eleve svg { height: 2.7em; width: auto; overflow: visible; transform-origin: 50% 100%; }
  .m9e-eleve svg.pas { animation: m9e-pas 0.6s ease-in-out both; animation-delay: calc(var(--i) * 40ms); }
  .m9e-eleve svg circle, .m9e-eleve svg path { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; transition: fill 0.3s, stroke 0.3s; }
  .m9e-eleve.haut svg circle, .m9e-eleve.haut svg path { fill: var(--dk-encre); }
  .m9e-eleve.rouge svg circle, .m9e-eleve.rouge svg path { stroke: var(--dk-accent); }
  .m9e-eleve.rouge.haut svg circle, .m9e-eleve.rouge.haut svg path { fill: var(--dk-accent); }
  .m9e-nom { font-size: 0.8em; font-weight: 800; line-height: 1.1; white-space: nowrap; }
  .m9e-ligne { display: flex; align-items: center; gap: 0.3em; font-size: 0.8em; line-height: 1.1; }
  .m9e-moy { font-weight: 700; color: var(--dk-gris); }
  .m9e-trace { display: flex; gap: 2px; }
  .m9e-trace i { width: 0.55em; height: 0.55em; border: 2px solid var(--dk-filet); }
  .m9e-trace i.fait { border-color: var(--dk-encre); }
  .m9e-trace i.fait.ok { background: var(--dk-encre); }
  .m9e-trace i.fait.h { border-color: var(--dk-accent); }
  .m9e-trace i.fait.h.ok { background: var(--dk-accent); }

  /* Le dernier temps : Noah et Léa, les autres en retrait. */
  .m9e-piste.focus .m9e-eleve:not(.cerne) { opacity: 0.3; }
  .m9e-eleve.cerne { outline: 3px solid var(--dk-accent); outline-offset: -3px; }
  .m9e-eleve.cerne .m9e-nom { color: var(--dk-accent); }

  .m9e-axe { display: flex; align-items: center; gap: 0.6em; margin-left: 6.3em; font-size: 0.7em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .m9e-fl { flex: 1; height: 2px; background: var(--dk-gris); position: relative; }
  .m9e-fl::after { content: ''; position: absolute; right: -2px; top: -5px; border-left: 10px solid var(--dk-gris); border-top: 6px solid transparent; border-bottom: 6px solid transparent; }
  .m9e-note { margin: 0; text-align: center; font-size: 1.15em; font-weight: 700; min-height: 1.4em; animation: m9e-entre 0.4s both; }
  .m9e-note.rouge { color: var(--dk-accent); }

  /* Le pas : un dandinement le temps de traverser. */
  @keyframes m9e-pas {
    0% { transform: rotate(0); }
    20% { transform: rotate(-8deg) translateY(-0.15em); }
    40% { transform: rotate(8deg); }
    60% { transform: rotate(-8deg) translateY(-0.15em); }
    80% { transform: rotate(6deg); }
    100% { transform: rotate(0); }
  }
  @keyframes m9e-entre { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m9e-eleve, .m9e-eleve svg circle, .m9e-eleve svg path, .m9e-fiche, .m9e-carte { transition: none; }
    .m9e-eleve svg.pas, .m9e-num, .m9e-titre, .m9e-note { animation: none; }
  }
</style>
