<script>
  /**
   * Deux habits, les mêmes chiffres. À gauche, ce que R imprime pour
   * summary(modele) (SUMMARY dans src/lib/data/seance7.js, la vraie sortie
   * de outils/seance7_data.R, rien n'est retapé : les morceaux sont repérés
   * dans le texte de R par des motifs). À droite, le même modèle dans
   * l'habit d'un article (TabPublie). Chaque clic surligne la même
   * information des deux côtés, et une ligne dit le mot de R et le mot de
   * l'article.
   *
   *   0  Les deux, côte à côte.
   *   1  Les noms : note_carney (dans l'appel) et les lignes de R deviennent
   *      la variable en tête de colonne et les noms des lignes.
   *   2  Estimate : le coefficient.
   *   3  Std. Error : l'erreur type, entre parenthèses.
   *   4  Pr(>|t|) et ses codes : les étoiles et leur légende.
   *   5  « 217 observations deleted » et « 781 degrees of freedom » : R
   *      n'imprime pas N, il faut le déduire (1 000 − 217 = 783).
   *   6  Multiple R-squared : le R², arrondi.
   *   7  Tout ce qui a son pendant reste à l'encre, le reste pâlit : ce que
   *      l'article laisse de côté (Call, Residuals, t value, l'erreur type
   *      des résidus, le R² ajusté, le test F).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, CODE_SUMMARY, SUMMARY } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 7, lire: () => e, ecrire: (v) => (e = v) });
  });

  const echap = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const [C0, C1] = NOTRE.coefs;
  // Les morceaux, chacun avec le temps où il passe au rouge. Les nombres sont
  // cherchés tels que R les imprime (4 décimales) : si R change, le motif ne
  // trouve rien et la diapo le montre.
  const MOTIFS = [
    [1, /note_carney/],
    [1, /^(\(Intercept\)|gauche_droite)(?= )/gm],
    [2, /Estimate/],
    [2, new RegExp(`${echap(C0.b.toFixed(4))}|${echap(C1.b.toFixed(4))}`, 'g')],
    [3, /Std\. Error/],
    [3, new RegExp(`${echap(C0.se.toFixed(4))}|${echap(C1.se.toFixed(4))}`, 'g')],
    [4, /Pr\(>\|t\|\)/],
    [4, /\S+ +\*+(?= *$)/gm],
    [4, /Signif\. codes:.*$/m],
    [5, /\d+ degrees of freedom/],
    [5, /\(\d+ observations deleted due to missingness\)/],
    [6, /Multiple R-squared: +[\d.]+/]
  ];
  function segmenter(txt) {
    const trouves = [];
    for (const [id, re] of MOTIFS) {
      const g = re.global ? re : new RegExp(re.source, re.flags + 'g');
      for (const m of txt.matchAll(g)) trouves.push({ id, i: m.index, n: m[0].length });
    }
    trouves.sort((a, b) => a.i - b.i);
    const out = [];
    let pos = 0;
    for (const t of trouves) {
      if (t.i < pos) continue;
      if (t.i > pos) out.push({ txt: txt.slice(pos, t.i), id: 0 });
      out.push({ txt: txt.slice(t.i, t.i + t.n), id: t.id });
      pos = t.i + t.n;
    }
    if (pos < txt.length) out.push({ txt: txt.slice(pos), id: 0 });
    return out;
  }
  const SEG = segmenter(SUMMARY.replace(/^\n+/, '').replace(/\n+$/, ''));
  const SUPPRIMES = Number(SUMMARY.match(/\((\d+) observations deleted/)[1]);

  const f = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const ON = [[], ['y', 'x'], ['coef'], ['se'], ['etoiles', 'legende'], ['n'], ['r2'], []];
  const GLOSES = [
    '',
    'les noms de R → des mots',
    'Estimate → le coefficient',
    'Std. Error → l’erreur type, entre parenthèses',
    'Pr(>|t|) → les étoiles',
    `${SUPPRIMES} observations deleted → N = ${f(NOTRE.n)} − ${SUPPRIMES} = ${f(NOTRE.n_modele)}`,
    'Multiple R-squared → R²',
    'le reste, l’article le laisse de côté'
  ];
</script>

<div class="visuel tab-habits" bind:this={hote}>
  <div class="th-cote">
    <p class="th-etiq">ce que R imprime</p>
    <div class="th-console" class:th-tri={e === 7}>
      <pre class="th-in"><span class="th-prompt">&gt;</span> {CODE_SUMMARY}</pre>
      <pre class="th-out">{#each SEG as s}{#if s.id}<span class="th-piece" class:th-on={e === s.id} class:th-garde={e === 7}>{s.txt}</span>{:else}{s.txt}{/if}{/each}</pre>
    </div>
  </div>
  <div class="th-cote">
    <p class="th-etiq">ce que l’article publie</p>
    <div class="th-tab"><TabPublie on={ON[e]} /></div>
  </div>
  <p class="th-glose" class:th-vu={e > 0}>{GLOSES[e] || ' '}</p>
</div>

<style>
  .tab-habits { display: grid; grid-template-columns: auto auto; justify-content: space-between; column-gap: 2em; row-gap: 0.5em; align-items: start; }
  .th-cote { display: flex; flex-direction: column; gap: 0.35em; }
  .th-etiq { margin: 0; font-size: 0.6em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }

  /* La console : comme Console.svelte, papier grisé, filet d'encre, règle rouge. */
  .th-console { font-size: 0.84em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.5em solid var(--dk-accent); padding: 0.6em 0.9em 0.7em; }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.3; white-space: pre; tab-size: 4; color: var(--dk-encre); transition: color 0.4s; }
  .th-prompt { color: var(--dk-accent); font-weight: 600; }
  .th-out { padding-left: 1.1em; }
  /* Le cadre rouge est un contour : il ne décale aucun caractère. */
  .th-piece { transition: color 0.3s; }
  .th-piece.th-on { color: var(--dk-accent); font-weight: 600; outline: 0.12em solid var(--dk-accent); outline-offset: 0.06em; }
  /* Temps 7 : ce qui a son pendant dans l'article reste à l'encre, le reste pâlit. */
  .th-tri .th-out { color: #c4c6c2; }
  .th-tri .th-piece.th-garde { color: var(--dk-encre); font-weight: 600; }

  .th-tab { font-size: 0.88em; }
  .th-glose { grid-column: 1 / -1; margin: 0.2em 0 0; min-height: 1.4em; font-size: 0.95em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .th-glose.th-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    pre, .th-piece, .th-glose { transition: none; }
  }
</style>
