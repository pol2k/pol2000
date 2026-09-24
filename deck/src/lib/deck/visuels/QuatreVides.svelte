<script>
  /**
   * Quatre sortes de vide. Remplace TroisVides : même idée, plus NaN.
   * Chaque sorte est une case de tableau qui se comporte à sa façon, avec
   * ce que R en fait. Au temps 0, quatre cases vides; un clic en remplit une.
   *
   *   1  -99 : code de non-réponse des curseurs de 0 à 10
   *      (GAUCHE_DROITE.n99). La case clignote en rouge : R le prend pour un
   *      nombre, et mean() rend -11.43717 (CONSOLES_PLUS.moyenne[0]).
   *   2  « Ne sait pas » : une vraie réponse, code 7 de l'intention de vote
   *      (VOTE_VIDE.nsp). À vous de trancher : catégorie ou NA.
   *   3  NA : la question n'a jamais été posée (VOTE_VIDE.na), surtout parce
   *      que la personne avait déjà voté (raisons["6"]). R le sait : is.na()
   *      les compte (CONSOLES.nonpose[0]).
   *   4  NaN : un calcul sans réponse. 0 / 0, ou la moyenne d'un groupe où
   *      personne n'a répondu. is.na(NaN) vaut TRUE (CONSOLES_PLUS.nan).
   *
   * Aucune sortie n'est tapée à la main : on retire seulement le « [1] ».
   */
  import { brancherTemps } from '../temps.js';
  import { GAUCHE_DROITE, VOTE_VIDE, CONSOLES } from '$lib/data/seance4.js';
  import { CONSOLES_PLUS } from '$lib/data/seance4_plus.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const sortie = (l) => l.out.replace(/^\[1\]\s*/, '');
  const M = CONSOLES_PLUS.moyenne;
  const N = CONSOLES_PLUS.nan;

  const LIGNES = [
    {
      cle: 'n99', case: '−99', n: milliers(GAUCHE_DROITE.n99),
      ligne: 'Un code de non-réponse',
      quoi: 'échelle gauche-droite, de 0 à 10',
      r: [{ in: 'mean(…)', out: sortie(M[0]) }]
    },
    {
      cle: 'nsp', case: 'Ne sait pas', n: milliers(VOTE_VIDE.nsp),
      ligne: 'Une vraie réponse',
      quoi: 'intention de vote, code 7',
      choix: ['catégorie', 'NA']
    },
    {
      cle: 'na', case: 'NA', n: milliers(VOTE_VIDE.na),
      ligne: 'Une question jamais posée',
      quoi: `intention de vote · ${milliers(VOTE_VIDE.raisons['6'])} avaient déjà voté`,
      r: [{ in: CONSOLES.nonpose[0].in, out: sortie(CONSOLES.nonpose[0]), long: true }]
    },
    {
      cle: 'nan', case: 'NaN', avant: N[0].in, n: '',
      ligne: 'Un calcul sans réponse',
      quoi: 'la moyenne d’un groupe où personne n’a répondu',
      r: [
        { in: N[0].in, out: sortie(N[0]) },
        { in: N[2].in, out: sortie(N[2]) }
      ]
    }
  ];
</script>

<div class="visuel quatre-vides" bind:this={hote}>
  <div class="tete">
    <span>valeur</span><span class="d">personnes</span><span></span><span>dans R</span>
  </div>
  {#each LIGNES as l, i}
    <div class="rang {l.cle}" class:vu={e > i}>
      <div class="case">
        {#if l.avant}
          <span class="glyphe calc">{l.avant}</span>
          <span class="glyphe res">{l.case}</span>
        {:else}
          <span class="glyphe">{l.case}</span>
        {/if}
      </div>
      <span class="n">{l.n}</span>
      <div class="texte">
        <span class="ligne">{l.ligne}</span>
        <span class="quoi">{l.quoi}</span>
      </div>
      <div class="r">
        {#if l.choix}
          <span class="option p1">{l.choix[0]}</span><span class="ou">ou</span><span class="option p2">{l.choix[1]}</span>
        {:else}
          {#each l.r as c}
            <code class:long={c.long}><span class="in">{c.in}</span><span class="out">{c.out}</span></code>
          {/each}
        {/if}
      </div>
    </div>
  {/each}
  <p class="source">Étude électorale canadienne 2025 · {milliers(GAUCHE_DROITE.n)} personnes</p>
</div>

<style>
  .quatre-vides { display: grid; grid-template-columns: 7.6em 5.4em minmax(0, 1fr) 17em; column-gap: 1.1em; row-gap: 0.55em; align-items: center; }
  .tete, .rang { display: contents; }
  .tete span { font-size: 0.6em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .tete .d { text-align: right; }

  /* Avant le clic : la case est vide, le reste de la rangée est caché. */
  .rang:not(.vu) .glyphe, .rang:not(.vu) .n, .rang:not(.vu) .texte, .rang:not(.vu) .r { visibility: hidden; }

  /* La case : une cellule de tableau. */
  .case { height: 2.5em; border: 2px dashed var(--dk-filet); display: grid; place-items: center; }
  .vu .case { border: 3px solid var(--dk-encre); }
  .glyphe { grid-area: 1 / 1; font-size: 1.45em; font-weight: 600; letter-spacing: -0.02em; }
  .vu .glyphe { animation: entre 0.35s both; }

  .n { font-size: 1.7em; font-weight: 600; text-align: right; white-space: nowrap; letter-spacing: -0.03em; }
  .vu .n { animation: entre 0.4s 0.15s both; }
  .texte { display: flex; flex-direction: column; gap: 0.15em; }
  .vu .texte { animation: entre 0.4s 0.25s both; }
  .ligne { font-size: 1.05em; font-weight: 600; }
  .quoi { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }

  .r { display: flex; flex-direction: column; gap: 0.3em; }
  .vu .r { animation: entre 0.4s 0.5s both; }
  code { display: flex; justify-content: space-between; gap: 0.8em; font-family: var(--dk-mono); font-size: 0.85em; background: var(--dk-fond-2); padding: 0.3em 0.6em; }
  code.long { flex-direction: column; gap: 0.1em; }
  code.long .out { align-self: flex-end; }
  .out { font-weight: 600; }

  /* -99 : l'air d'un nombre, puis il clignote en rouge. */
  .n99.vu .case { border-color: var(--dk-accent); animation: alerte 0.5s 0.6s 3 both; }
  .n99.vu .glyphe { animation: entre 0.35s both, vire 1.5s 0.6s both; }
  .n99 .glyphe { color: var(--dk-accent); }
  .n99 .out { color: var(--dk-accent); }
  @keyframes alerte { 0%, 100% { background: transparent; } 50% { background: var(--dk-accent); } }
  @keyframes vire { from { color: var(--dk-encre); } 30%, 70% { color: var(--dk-fond); } to { color: var(--dk-accent); } }

  /* Ne sait pas : une vraie réponse; le choix de l'analyste bascule. */
  .nsp .glyphe { font-size: 0.95em; letter-spacing: 0; }
  .nsp .r { flex-direction: row; align-items: center; gap: 0.5em; }
  .option { font-size: 0.85em; font-weight: 600; border: 2px solid var(--dk-encre); padding: 0.25em 0.6em; }
  .ou { font-size: 0.75em; color: var(--dk-gris); }
  .vu .p1 { animation: choix 2.4s 0.9s 2 both; }
  .vu .p2 { animation: choix 2.4s 2.1s 2 both; }
  @keyframes choix { 0%, 50%, 100% { background: transparent; color: var(--dk-encre); } 10%, 40% { background: var(--dk-encre); color: var(--dk-fond); } }

  /* NA : un trou franc, que R reconnaît. */
  .na.vu .case { border-style: dashed; border-color: var(--dk-gris); }
  .na .glyphe { color: var(--dk-gris); }

  /* NaN : 0 / 0 s'efface et laisse NaN. */
  .nan .calc { font-size: 1.1em; opacity: 0; }
  .nan.vu .calc { animation: sort 1.4s both; }
  .nan.vu .res { animation: entre 0.4s 1.1s both; }
  @keyframes sort { 0%, 60% { opacity: 1; } 100% { opacity: 0; } }

  .source { grid-column: 1 / -1; margin: 0.3em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @keyframes entre { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .vu .glyphe, .vu .n, .vu .texte, .vu .r, .vu .case, .vu .option, .vu .res { animation: none !important; }
    .nan.vu .calc { animation: none !important; opacity: 0; }
  }
</style>
