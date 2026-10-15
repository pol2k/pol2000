<script>
  /**
   * Étape 4 du travail : présenter les données, et d'abord la question du
   * sondage derrière chaque variable. Dans R, scolarite et interet ne sont
   * que des chiffres de 0 à 1; c'est la question posée, et ses choix de
   * réponse, qui leur donnent un sens. Cinq temps :
   *
   *   0  ce qu'on voit dans R : deux noms, des chiffres de 0 à 1. De quoi ?
   *   1  scolarite (X) : la question, mot pour mot, ses onze réponses
   *      (codes 1 à 11 du codebook) regroupées en cinq niveaux, de 0 à 1;
   *   2  interet (Y) : la question et son curseur de 0 à 10, divisé par 10;
   *   3  « Ne sais pas / Préfère ne pas répondre » (code 12, ou -99 pour le
   *      curseur) devient NA;
   *   4  pourquoi regrouper : combien de personnes donnent chaque réponse.
   *      Les codes 1 à 3 ne comptent que 77 personnes sur 20 180, trop peu
   *      pour un niveau à eux seuls.
   *
   * Questions, réponses, niveaux et codes : VARS dans seance7.js
   * (outils/seance7_data.R), copiés du codebook officiel de la CES 2025
   * (ces::download_pdf_codebook("2025")) : cps25_education p. 41,
   * cps25_interest_gen_1 p. 45 (« collègue » y est une coquille du codebook,
   * corrigée dans VARS). Libellés « ne sait pas » et codes 12 / -99 : mêmes
   * pages. Effectifs par code : SCOL_CODES dans seance7_a.js
   * (outils/seance7_a.R).
   */
  import { brancherTemps } from '../temps.js';
  import { VARS } from '$lib/data/seance7.js';
  import { SCOL_CODES } from '$lib/data/seance7_a.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const X = VARS.x, Y = VARS.y;
  // La typographie française : espace fine avant « ? » (VARS a une espace ordinaire).
  const fr = (t) => t.replace(/ ([?!:;])/g, ' $1');
  const nb = (n) => n.toLocaleString('fr-CA');
  const val = (v) => v.toLocaleString('fr-CA');

  // Les cinq niveaux : leurs codes, et la rangée de grille où commence chacun.
  const codesDe = (c) => (Array.isArray(c) ? c : [c]);
  let rang = 1;
  const NIVEAUX = X.niveaux.map((nom, k) => {
    const codes = codesDe(X.codes[k]);
    const g = { nom, val: X.valeurs[k], de: rang, n: codes.length, petit: codes.includes(1) };
    rang += codes.length;
    return g;
  });
  const CRANS_Y = Array.from({ length: Y.max - Y.min + 1 }, (_, k) => Y.min + k);
</script>

<div class="visuel tm-qs" bind:this={hote}>
  <!-- X : la scolarité -->
  <div class="tm-qs-col" class:tm-vu={e >= 1} class:tm-actif={e === 1}>
    <div class="tm-qs-tete">
      <code class="tm-qs-r"><span class="tm-qs-xy">X</span>{X.nom}</code>
      <span class="tm-qs-ces" class:tm-cache={e < 1}>{X.code} · p. {X.page}</span>
    </div>
    <p class="tm-qs-quoi" class:tm-cache={e >= 1}>De 0 à 1. Mais de quoi&#8239;?</p>
    <div class="tm-qs-corps" class:tm-cache={e < 1}>
      <blockquote class="tm-qs-q">«&#8239;{fr(X.question)}&#8239;»</blockquote>
      <div class="tm-qs-grille" class:tm-compte={e >= 4}>
        {#each X.reponses as r, k}
          <span class="tm-qs-code" class:tm-rare={e >= 4 && k < 3} style="grid-row: {k + 1}">{k + 1}</span>
          <span class="tm-qs-n" class:tm-rare={e >= 4 && k < 3} style="grid-row: {k + 1}">{r}</span>
          <span class="tm-qs-eff" class:tm-rare={k < 3} style="grid-row: {k + 1}">{nb(SCOL_CODES.effectifs[k])}</span>
        {/each}
        {#each NIVEAUX as g}
          <span class="tm-qs-groupe" class:tm-rare={e >= 4 && g.petit} style="grid-row: {g.de} / span {g.n}">
            <span class="tm-qs-gnom">{g.nom}</span><b>{val(g.val)}</b>
          </span>
        {/each}
        <span class="tm-qs-code tm-qs-na" class:tm-on={e >= 3} style="grid-row: 12">12</span>
        <span class="tm-qs-n tm-qs-na" class:tm-on={e >= 3} style="grid-row: 12">Ne sais pas / Préfère ne pas répondre</span>
        <span class="tm-qs-eff" style="grid-row: 12">{nb(SCOL_CODES.ne_sait_pas)}</span>
        <span class="tm-qs-groupe tm-qs-na" class:tm-on={e >= 3} style="grid-row: 12"><span class="tm-qs-gnom"></span><b>NA</b></span>
      </div>
    </div>
  </div>

  <!-- Y : l'intérêt -->
  <div class="tm-qs-col" class:tm-vu={e >= 2} class:tm-actif={e === 2}>
    <div class="tm-qs-tete">
      <code class="tm-qs-r"><span class="tm-qs-xy">Y</span>{Y.nom}</code>
      <span class="tm-qs-ces" class:tm-cache={e < 2}>{Y.code} · p. {Y.page}</span>
    </div>
    <p class="tm-qs-quoi" class:tm-cache={e >= 2}>De 0 à 1. Mais de quoi&#8239;?</p>
    <div class="tm-qs-corps" class:tm-cache={e < 2}>
      <blockquote class="tm-qs-q">«&#8239;{fr(Y.question)}&#8239;»</blockquote>
      <div class="tm-qs-curseur">
        <div class="tm-qs-crans">{#each CRANS_Y as c}<span>{c}</span>{/each}</div>
        <div class="tm-qs-bouts"><span>{Y.bornes[0]}</span><span>{Y.bornes[1]}</span></div>
        <div class="tm-qs-div">÷ 10</div>
        <div class="tm-qs-crans tm-qs-01">{#each CRANS_Y as c}<span>{c === 0 || c === 10 ? val(c / 10) : ''}</span>{/each}</div>
      </div>
      <div class="tm-qs-ligne tm-qs-na" class:tm-on={e >= 3}>
        <span class="tm-qs-n">Je ne sais pas / Préfère ne pas répondre</span>
        <span class="tm-qs-code">-99</span>
        <b>NA</b>
      </div>
    </div>
  </div>

  <div class="tm-qs-note" class:tm-on={e >= 4}>
    <span class="tm-qs-note-et">POURQUOI REGROUPER</span>
    <p>Codes 1 à 3&#8239;: {SCOL_CODES.codes_1_a_3} personnes sur {nb(SCOL_CODES.n)}. Trop peu pour un niveau à elles seules.</p>
  </div>
</div>

<style>
  .tm-qs { display: grid; grid-template-columns: 1.75fr 1fr; grid-template-rows: auto auto; gap: 0.8em 1.6em; align-items: start; }
  .tm-qs-col { position: relative; display: flex; flex-direction: column; gap: 0.45em; border-top: 5px solid var(--dk-filet); padding-top: 0.4em; transition: border-color 0.4s; animation: tm-qs-f 0.4s both; }
  .tm-qs-col.tm-vu { border-top-color: var(--dk-encre); }
  .tm-qs-col.tm-actif { border-top-color: var(--dk-accent); }
  .tm-qs-tete { display: flex; align-items: baseline; justify-content: space-between; gap: 0.8em; }
  .tm-qs-r { font-size: 1.3em; font-weight: 600; }
  .tm-qs-xy { margin-right: 0.5em; color: var(--dk-gris-2); }
  .tm-actif .tm-qs-r { color: var(--dk-accent); }
  .tm-qs-ces { font-size: 0.62em; color: var(--dk-gris); transition: opacity 0.4s; }
  .tm-qs-quoi { position: absolute; left: 0; top: 3em; margin: 0; font-size: 1.3em; color: var(--dk-gris); transition: opacity 0.3s; }
  .tm-qs-corps { display: flex; flex-direction: column; gap: 0.45em; transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-corps.tm-cache { transform: translateY(0.5em); }
  .tm-cache { opacity: 0; }
  .tm-qs-q { margin: 0; font-size: 0.8em; line-height: 1.35; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-encre); padding: 0.4em 0.7em; }
  .tm-actif .tm-qs-q { border-left-color: var(--dk-accent); }

  /* X : onze réponses, cinq niveaux. Colonnes : code, réponse, effectif, niveau. */
  .tm-qs-grille { display: grid; grid-template-columns: 1.5em 1fr auto 10.5em; column-gap: 0.5em; align-items: center; font-size: 0.72em; line-height: 1.2; }
  .tm-qs-grille .tm-qs-code { grid-column: 1; text-align: right; color: var(--dk-gris); }
  .tm-qs-grille .tm-qs-n { grid-column: 2; padding: 0.06em 0; }
  .tm-qs-eff { grid-column: 3; text-align: right; color: var(--dk-gris); font-variant-numeric: tabular-nums; opacity: 0; transition: opacity 0.4s; }
  .tm-compte .tm-qs-eff { opacity: 1; }
  .tm-compte .tm-qs-eff.tm-rare { color: var(--dk-accent); font-weight: 600; }
  .tm-qs-grille .tm-rare { color: var(--dk-accent); }
  .tm-qs-groupe { grid-column: 4; align-self: stretch; display: flex; align-items: center; justify-content: space-between; gap: 0.4em; margin: 0.1em 0; padding: 0 0.5em; border-left: 4px solid var(--dk-encre); background: var(--dk-fond-2); line-height: 1.1; }
  .tm-qs-groupe b { color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .tm-qs-groupe.tm-rare { border-left-color: var(--dk-accent); }
  .tm-qs-gnom { font-weight: 600; }

  /* Y : le curseur et sa division par 10. */
  .tm-qs-curseur { display: flex; flex-direction: column; gap: 0.15em; }
  .tm-qs-crans { display: flex; justify-content: space-between; border-bottom: 4px solid var(--dk-encre); padding-bottom: 0.1em; font-size: 0.66em; font-weight: 600; }
  .tm-qs-crans span { width: 1.6em; text-align: center; }
  .tm-qs-crans span:first-child { text-align: left; } .tm-qs-crans span:last-child { text-align: right; }
  .tm-qs-bouts { display: flex; justify-content: space-between; gap: 1em; font-size: 0.6em; color: var(--dk-gris); }
  .tm-qs-div { align-self: center; font-size: 0.8em; font-weight: 600; color: var(--dk-accent); }
  .tm-qs-01 { border-bottom-color: var(--dk-accent); color: var(--dk-accent); font-size: 0.8em; }

  .tm-qs-ligne { display: grid; grid-template-columns: 1fr auto auto; gap: 0.6em; align-items: baseline; font-size: 0.66em; border-top: 2px solid var(--dk-filet); padding-top: 0.3em; }
  .tm-qs-ligne .tm-qs-code { color: var(--dk-gris); }
  .tm-qs-na { opacity: 0.2; transition: opacity 0.4s; }
  .tm-qs-na.tm-on { opacity: 1; }
  .tm-qs-ligne b, .tm-qs-groupe.tm-qs-na b { color: var(--dk-gris); }
  .tm-qs-ligne.tm-on b, .tm-qs-groupe.tm-qs-na.tm-on b { color: var(--dk-fond); background: var(--dk-accent); padding: 0 0.35em; }
  .tm-qs-groupe.tm-qs-na { background: none; border-left-color: var(--dk-filet); }

  .tm-qs-note { grid-column: 1 / -1; display: flex; align-items: baseline; gap: 1em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.45em 1em; border-left: 0.5em solid var(--dk-accent); opacity: 0; transform: translateY(0.5em); transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-note.tm-on { opacity: 1; transform: none; }
  .tm-qs-note-et { font-size: 0.6em; font-weight: 600; letter-spacing: 0.14em; color: var(--dk-accent-clair); white-space: nowrap; }
  .tm-qs-note p { margin: 0; font-size: 0.86em; line-height: 1.35; }

  @keyframes tm-qs-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-qs-col { animation: none; }
    .tm-qs-corps, .tm-qs-quoi, .tm-qs-ces, .tm-qs-note, .tm-qs-na, .tm-qs-eff { transition: none; }
  }
</style>
