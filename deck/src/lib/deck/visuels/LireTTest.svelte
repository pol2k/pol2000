<script>
  /**
   * Lire la sortie de t.test(), morceau par morceau. À gauche, la commande et
   * sa sortie complète, telles que R les a imprimées (CONSOLES.centre dans
   * src/lib/data/seance5.js, produit par outils/seance5_data.R) ; rien n'est
   * retapé : les morceaux sont repérés dans le texte de R par des motifs.
   * À droite, une glose en français par morceau ; elles s'accumulent.
   *
   *   0  L'hypothèse nulle : mu = 5 dans la commande, H0 à droite.
   *   1  t = ... : à combien d'erreurs types l'estimé est de 5.
   *   2  p-value = ... : comparée à 0,05.
   *   3  L'intervalle de confiance à 95 % : contient-il 5 ?
   *   4  mean of x : l'estimé, la moyenne des répondant.e.s.
   *   5  Le verdict, encadré.
   *
   * Les nombres des gloses viennent de TESTS.centre (t, p, ic, estimes) ;
   * la valeur testée (5) est lue dans la commande elle-même. Les mots du
   * verdict dépendent de p et de l'intervalle : ils suivent les chiffres.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { CONSOLES, TESTS } from '$lib/data/seance5.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const C = CONSOLES.centre[0];
  const T = TESTS.centre;
  const SEUIL = 0.05;

  // La commande, coupée autour de « mu = 5 ».
  const mMu = C.in.match(/mu = ([\d.]+)/);
  const MU = Number(mMu[1]);
  const CMD = [C.in.slice(0, mMu.index), mMu[0], C.in.slice(mMu.index + mMu[0].length)].map(surlignerR);

  // La sortie, sans ses lignes vides de début et de fin, coupée en morceaux.
  const SORTIE = C.out.replace(/^\n+/, '').replace(/\n+$/, '');
  const MOTIFS = [
    [1, /t = -?[\d.]+/],
    [2, /p-value [=<] [\d.e-]+/],
    [3, /\d+ percent confidence interval:\n\s*-?[\d.]+ -?[\d.]+/],
    [4, /mean of x\s*\n\s*-?[\d.]+/]
  ];
  function segmenter(txt) {
    const trouves = MOTIFS.map(([id, re]) => {
      const m = txt.match(re);
      return m ? { id, i: m.index, n: m[0].length } : null;
    })
      .filter(Boolean)
      .sort((a, b) => a.i - b.i);
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
  const SEG = segmenter(SORTIE);

  const f = (x, d) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const AT = Math.abs(T.t);
  const DANS = T.ic[0] <= MU && MU <= T.ic[1];
  const REJET = T.p < SEUIL;
</script>

<div class="visuel lire-t" bind:this={hote}>
  <div class="lt-console">
    <pre class="lt-in"><span class="lt-prompt">&gt;</span> {@html CMD[0]}<span class="lt-piece" class:lt-on={e === 0}>{@html CMD[1]}</span>{@html CMD[2]}</pre>
    <pre class="lt-out">{#each SEG as s}{#if s.id}<span class="lt-piece" class:lt-on={e === s.id} class:lt-lu={e > s.id}>{s.txt}</span>{:else}{s.txt}{/if}{/each}</pre>
  </div>

  <div class="lt-gloses">
    <div class="lt-h0" class:lt-actif={e === 0}>
      <b>H<sub>0</sub></b>&#8239;: la position gauche-droite moyenne est de {MU}, le centre de l’échelle
    </div>

    <div class="lt-glose" class:lt-vu={e >= 1} class:lt-actif={e === 1}>
      <span class="lt-num">1</span>
      <span class="lt-txt"><b>t</b>&#8239;: l’estimé est à {f(AT, 1)} {AT < 2 ? 'erreur type' : 'erreurs types'} {T.t < 0 ? 'sous' : 'au-dessus de'} {MU}</span>
    </div>

    <div class="lt-glose" class:lt-vu={e >= 2} class:lt-actif={e === 2}>
      <span class="lt-num">2</span>
      <span class="lt-txt"><b>p = {f(T.p, 2)}</b>&#8239;: plus {T.p >= SEUIL ? 'grand' : 'petit'} que {f(SEUIL, 2)}</span>
    </div>

    <div class="lt-glose" class:lt-vu={e >= 3} class:lt-actif={e === 3}>
      <span class="lt-num">3</span>
      <span class="lt-txt"><b>l’intervalle</b> {DANS ? 'contient' : 'ne contient pas'} {MU}<span class="lt-bornes">de {f(T.ic[0], 3)} à {f(T.ic[1], 3)}</span></span>
    </div>

    <div class="lt-glose" class:lt-vu={e >= 4} class:lt-actif={e === 4}>
      <span class="lt-num">4</span>
      <span class="lt-txt"><b>l’estimé</b>&#8239;: la moyenne des répondant.e.s, {f(T.estimes, 2)}</span>
    </div>

    <div class="lt-verdict" class:lt-vu={e >= 5}>
      {#if !REJET && DANS}
        On ne rejette pas H<sub>0</sub>. La moyenne pourrait être {MU}.
      {:else}
        On rejette H<sub>0</sub>.
      {/if}
    </div>
  </div>
</div>

<style>
  .lire-t { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 1.4em; align-items: start; }

  /* La console : comme Console.svelte, papier grisé, filet d'encre, règle rouge. */
  .lt-console { font-size: 0.86em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.34em solid var(--dk-accent); padding: 0.6em 0.9em 0.7em; display: flex; flex-direction: column; gap: 0.3em; }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.5; white-space: pre; tab-size: 4; color: var(--dk-encre); }
  .lt-prompt { color: var(--dk-accent); font-weight: 600; }
  .lt-out { padding-left: 1.1em; }
  /* Le cadre rouge est un contour : il ne décale aucun caractère. */
  .lt-piece { transition: color 0.3s; }
  .lt-piece.lt-lu { font-weight: 600; }
  .lt-piece.lt-on { color: var(--dk-accent); font-weight: 600; outline: 0.1em solid var(--dk-accent); outline-offset: 0.06em; }

  .lt-gloses { display: flex; flex-direction: column; gap: 0.65em; font-size: 0.88em; line-height: 1.35; }
  .lt-gloses b { font-weight: 700; }
  .lt-h0 { border: 2px solid var(--dk-filet); padding: 0.45em 0.7em; color: var(--dk-encre); transition: border-color 0.3s; }
  .lt-h0.lt-actif { border-color: var(--dk-accent); }
  .lt-glose { display: flex; gap: 0.6em; align-items: baseline; visibility: hidden; opacity: 0; transform: translateX(0.4em); color: var(--dk-gris); transition: opacity 0.35s, transform 0.35s, color 0.3s, visibility 0s 0.35s; }
  .lt-glose.lt-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.35s, transform 0.35s, color 0.3s; }
  .lt-glose.lt-actif { color: var(--dk-encre); }
  .lt-num { flex: 0 0 auto; width: 1.5em; height: 1.5em; display: inline-flex; align-items: center; justify-content: center; border: 2px solid var(--dk-filet); font-size: 0.75em; font-weight: 600; color: var(--dk-gris-2); transition: border-color 0.3s, color 0.3s; }
  .lt-actif .lt-num { border-color: var(--dk-accent); color: var(--dk-accent); }
  .lt-bornes { display: block; font-size: 0.8em; color: var(--dk-gris); }
  .lt-verdict { border: 3px solid var(--dk-accent); padding: 0.55em 0.8em; font-size: 1.1em; font-weight: 600; line-height: 1.35; color: var(--dk-encre); visibility: hidden; opacity: 0; transform: translateY(0.3em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .lt-verdict.lt-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.4s, transform 0.4s; }
  sub { font-size: 0.7em; line-height: 0; }

  @media (prefers-reduced-motion: reduce) {
    .lt-piece, .lt-h0, .lt-glose, .lt-glose.lt-vu, .lt-num, .lt-verdict, .lt-verdict.lt-vu { transition: none; transform: none; }
  }
</style>
