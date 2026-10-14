<script>
  /**
   * Étape 4 du travail : présenter les données, et d'abord la question du
   * sondage derrière chaque variable. Dans R, populisme et satisfaction_dem
   * ne sont que des chiffres de 0 à 1; c'est la question posée, et ses
   * choix de réponse, qui leur donnent un sens. Cinq temps :
   *
   *   0  ce qu'on voit dans R : deux noms, des chiffres de 0 à 1. De quoi ?
   *   1  populisme (X) : l'énoncé, mot pour mot, ses cinq réponses (codes
   *      1 à 5 du codebook) et ce qu'elles deviennent de 0 à 1;
   *   2  satisfaction_dem (Y) : la question, ses quatre réponses. Dans le
   *      codebook, 1 = très satisfait : à l'envers. On retourne l'échelle
   *      pour que 1 veuille dire ce que dit le nom (la règle de la séance 4);
   *   3  « Je ne sais pas / Préfère ne pas répondre » devient NA;
   *   4  la note du codebook : la question sur le populisme n'a été posée
   *      qu'à une partie du sondage postélectoral, tirée au hasard. D'où,
   *      en partie, les 564 personnes que R garde sur 1 000.
   *
   * Libellés, niveaux et valeurs : VARS dans seance7.js (outils/seance7_data.R).
   * Codes bruts et codes « ne sait pas », mot pour mot du codebook officiel
   * de la CES 2025 (ces::download_pdf_codebook("2025")) : pes25_populism_8,
   * p. 341 (codes 1 à 5, 6 = ne sait pas); pes25_dem_sat, p. 229 (1 = très
   * satisfait … 4 = pas du tout satisfait, 5 = ne sait pas). Les blocs du
   * sondage postélectoral (A1, A2, C, attribués au hasard; le populisme est
   * posé aux blocs A1 et A2 seulement) : p. 209 et 210.
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, NOTRE } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La typographie française : espace fine avant « ? » (le texte de VARS a une espace ordinaire).
  const fr = (t) => t.replace(/ ([?!:;])/g, '\u202f$1');
  // Les tiers s'écrivent en fraction : les écarts égaux se voient mieux.
  const val = (v) => (Math.abs(v - 1 / 3) < 0.01 ? '1/3' : Math.abs(v - 2 / 3) < 0.01 ? '2/3' : v.toLocaleString('fr-CA'));
  const COLS = [
    {
      xy: 'X', v: VARS.x, quoi: 'énoncé', na: 6, envers: false,
      // codes 1 à 5 dans l'ordre des niveaux
      lignes: VARS.x.niveaux.map((n, k) => ({ code: k + 1, n, val: VARS.x.valeurs[k] }))
    },
    {
      xy: 'Y', v: VARS.y, quoi: 'question', na: 5, envers: true,
      // codes 1 = très satisfait … 4 = pas du tout : l'inverse des niveaux
      lignes: VARS.y.niveaux.map((n, k) => ({ code: VARS.y.niveaux.length - k, n, val: VARS.y.valeurs[k] })).reverse()
    }
  ];
</script>

<div class="visuel tm-qs" bind:this={hote}>
  {#each COLS as c, i}
    {@const vu = e >= i + 1}
    <div class="tm-qs-col" class:tm-vu={vu} class:tm-actif={e === i + 1}>
      <div class="tm-qs-tete">
        <code class="tm-qs-r"><span class="tm-qs-xy">{c.xy}</span>{c.v.nom}</code>
        <span class="tm-qs-ces" class:tm-cache={!vu}>{c.v.code}</span>
      </div>
      <p class="tm-qs-quoi" class:tm-cache={vu}>De 0 à 1. Mais de quoi&#8239;?</p>
      <div class="tm-qs-corps" class:tm-cache={!vu}>
        <blockquote class="tm-qs-q">«&#8239;{fr(c.v.question)}&#8239;»</blockquote>
        <ol class="tm-qs-rep">
          {#each c.lignes as l, k}
            <li style="--k: {k}">
              <span class="tm-qs-code">{l.code}</span>
              <span class="tm-qs-n">{l.n}</span>
              <span class="tm-qs-fl">→</span>
              <b class="tm-qs-v">{val(l.val)}</b>
            </li>
          {/each}
          <li class="tm-qs-na" class:tm-on={e >= 3}>
            <span class="tm-qs-code">{c.na}</span>
            <span class="tm-qs-n">Je ne sais pas / Préfère ne pas répondre</span>
            <span class="tm-qs-fl">→</span>
            <b class="tm-qs-v">NA</b>
          </li>
        </ol>
        <small class="tm-qs-src">
          {#if c.envers}<span class="tm-qs-envers">codes à l’envers&#8239;: on retourne, 1 = très satisfait</span>{/if}
          codebook CES 2025, p. {c.v.page}
        </small>
      </div>
    </div>
  {/each}

  <div class="tm-qs-note" class:tm-on={e >= 4}>
    <span class="tm-qs-note-et">NOTE DU CODEBOOK, p. 209-210</span>
    <p>La question sur le populisme n’a été posée qu’à une partie du sondage postélectoral, tirée au hasard.</p>
    <p class="tm-qs-note-cle">Une des raisons pour lesquelles R ne garde que {NOTRE.n_modele} personnes sur {NOTRE.n.toLocaleString('fr-CA')}.</p>
  </div>
</div>

<style>
  .tm-qs { display: grid; grid-template-columns: 1fr 1fr; gap: 1em 1.6em; align-items: start; position: relative; }
  .tm-qs-col { position: relative; display: flex; flex-direction: column; gap: 0.5em; border-top: 5px solid var(--dk-filet); padding-top: 0.45em; transition: border-color 0.4s; animation: tm-qs-f 0.4s both; }
  .tm-qs-col.tm-vu { border-top-color: var(--dk-encre); }
  .tm-qs-col.tm-actif { border-top-color: var(--dk-accent); }
  .tm-qs-tete { display: flex; align-items: baseline; justify-content: space-between; gap: 0.8em; }
  .tm-qs-r { font-size: 1.3em; font-weight: 600; }
  .tm-qs-xy { margin-right: 0.5em; color: var(--dk-gris-2); }
  .tm-actif .tm-qs-r { color: var(--dk-accent); }
  .tm-qs-ces { font-size: 0.68em; color: var(--dk-gris); transition: opacity 0.4s; }
  .tm-qs-quoi { position: absolute; left: 0; top: 3em; margin: 0; font-size: 1.3em; color: var(--dk-gris); transition: opacity 0.3s; }
  .tm-qs-corps { display: flex; flex-direction: column; gap: 0.45em; transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-corps.tm-cache { transform: translateY(0.5em); }
  .tm-cache { opacity: 0; }
  .tm-qs-q { margin: 0; font-size: 0.86em; line-height: 1.4; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-encre); padding: 0.45em 0.8em; }
  .tm-actif .tm-qs-q { border-left-color: var(--dk-accent); }

  .tm-qs-rep { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; }
  .tm-qs-rep li { margin: 0; display: grid; grid-template-columns: 1.6em 1fr auto 2.6em; align-items: baseline; gap: 0.5em; font-size: 0.8em; line-height: 1.3; padding: 0.18em 0; border-bottom: 2px solid var(--dk-filet); }
  .tm-qs-code { font-size: 0.85em; color: var(--dk-gris); text-align: right; }
  .tm-qs-fl { color: var(--dk-gris-2); }
  .tm-qs-v { text-align: right; font-weight: 600; color: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .tm-qs-rep li.tm-qs-na { opacity: 0.2; transition: opacity 0.4s; border-bottom: 0; }
  .tm-qs-rep li.tm-qs-na.tm-on { opacity: 1; }
  .tm-qs-na .tm-qs-n { color: var(--dk-gris); }
  .tm-qs-na.tm-on .tm-qs-v { color: var(--dk-fond); background: var(--dk-accent); text-align: center; }
  .tm-qs-src { display: flex; flex-direction: column; gap: 0.15em; font-size: 0.56em; letter-spacing: 0.05em; color: var(--dk-gris); }
  .tm-qs-envers { font-size: 1.25em; font-weight: 600; letter-spacing: 0; color: var(--dk-accent); }

  .tm-qs-note { grid-column: 1 / -1; display: flex; flex-direction: column; gap: 0.2em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.55em 1em 0.6em; border-left: 0.5em solid var(--dk-accent); opacity: 0; transform: translateY(0.5em); transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-note.tm-on { opacity: 1; transform: none; }
  .tm-qs-note-et { font-size: 0.6em; font-weight: 600; letter-spacing: 0.14em; color: var(--dk-accent-clair); }
  .tm-qs-note p { margin: 0; font-size: 0.86em; line-height: 1.4; }
  .tm-qs-note .tm-qs-note-cle { font-weight: 600; color: var(--dk-accent-clair); }

  @keyframes tm-qs-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-qs-col { animation: none; }
    .tm-qs-corps, .tm-qs-quoi, .tm-qs-ces, .tm-qs-note, .tm-qs-rep li.tm-qs-na { transition: none; }
  }
</style>
