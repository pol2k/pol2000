<script>
  /**
   * Poser une question à R, avec les onze codes de scolarité de l'Étude
   * électorale canadienne 1993 (cpso3). Pas des personnes : les valeurs
   * possibles. Chaque clic pose une question; chaque code répond TRUE
   * (rouge, allumé) ou FALSE (gris, éteint), d'un balayage de haut en bas.
   *
   *   0  educ <- 1:11             les onze codes, du moins au plus scolarisé
   *   1  educ >= 9                plus grand ou égal à
   *   2  educ == 7                égal à (deux =, pas un)
   *   3  educ %in% c(6, 7)        fait partie de
   *   4  educ <= 5                plus petit ou égal à
   *   5  sum(ces93$cpso3 >= 9, na.rm = TRUE)   TRUE compte pour 1 : 428
   *
   * Les TRUE/FALSE sont lus dans la sortie de R (CONSOLES_PLUS.operateurs93),
   * pas recalculés ici : la figure ne peut pas diverger de la console. Les
   * effectifs viennent de EDUC93; leur somme doit retomber sur la sortie de
   * sum(), sinon on le signale dans la console du navigateur.
   * Inspiré du « bol de fruits » d'Adrien Cloutier (hiver 2024).
   */
  import { brancherTemps } from '../temps.js';
  import { CONSOLES_PLUS, EDUC93 } from '$lib/data/seance4_plus.js';

  const C = CONSOLES_PLUS.operateurs93;

  // Étiquettes françaises abrégées du codebook (EDUC93.etiquettes, en anglais).
  const NOMS = [
    'Aucune scolarité',
    'Primaire commencé',
    'Primaire terminé',
    'Secondaire commencé',
    'Secondaire terminé',
    'Collégial commencé',
    'Collégial terminé',
    'Université commencée',
    'Baccalauréat',
    'Maîtrise',
    'Professionnel, doctorat'
  ];

  // «  [1] FALSE FALSE … TRUE » → [false, false, …, true]
  const lire = (out) => out.replace(/^\s*\[\d+\]/, '').trim().split(/\s+/).map((m) => m === 'TRUE');
  const ligne = (expr) => C.find((l) => l.in === expr);

  const QUESTIONS = [
    { expr: 'educ >= 9', op: '>=', nom: 'plus grand ou égal à' },
    { expr: 'educ == 7', op: '==', nom: 'égal à', note: 'deux =, pas un' },
    { expr: 'educ %in% c(6, 7)', op: '%in%', nom: 'fait partie de' },
    { expr: 'educ <= 5', op: '<=', nom: 'plus petit ou égal à' }
  ].map((q) => {
    const [avant, apres] = q.expr.split(q.op);
    return { ...q, avant, apres, rep: lire(ligne(q.expr).out) };
  });

  // Le décompte dans les vraies données.
  const somme = C[C.length - 1];
  // Le code affiché est celui de la console, coupé avant na.rm pour tenir en gros.
  const [sAvant, sApres0] = somme.in.split('>=');
  const sApres = sApres0.replace(/,\s*na\.rm/, ',\n    na.rm');
  const TOTAL_R = Number(somme.out.replace(/^\s*\[\d+\]/, '').trim());
  const vraiSomme = QUESTIONS[0].rep; // même question : cpso3 >= 9
  const parts = EDUC93.effectifs.filter((_, i) => vraiSomme[i]);
  if (parts.reduce((s, n) => s + n, 0) !== TOTAL_R) console.warn('Operateurs93 : effectifs ≠ sortie de sum()');

  const fmt = (n) => n.toLocaleString('fr-CA');
  const DERNIER = QUESTIONS.length + 1;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: DERNIER, lire: () => e, ecrire: (v) => (e = v) });
  });

  const q = $derived(e >= 1 && e <= QUESTIONS.length ? QUESTIONS[e - 1] : null);
  const rep = $derived(q ? q.rep : e === DERNIER ? vraiSomme : null);
</script>

<div class="visuel op93" bind:this={hote}>
  <div class="boite">
  <ol class="echelle">
    {#each EDUC93.codes as code, i}
      {@const v = rep ? rep[i] : null}
      <li class:vrai={v === true} class:faux={v === false} style="--i: {i}; --l: {42 + (i / 10) * 42}%">
        <span class="code">{code}</span>
        <span class="marche">
          <span class="barre"><span class="nom">{NOMS[i]}</span></span>
          {#key e}{#if v !== null}
            <span class="pastille rep" class:v class:f={!v}>{e === DERNIER ? (v ? '1' : '0') : v ? 'TRUE' : 'FALSE'}</span>
          {/if}{/key}
          {#if e === DERNIER && v}<span class="n">{fmt(EDUC93.effectifs[i])}</span>{/if}
        </span>
      </li>
    {/each}
  </ol>
  {#key e}{#if rep}<span class="balai" aria-hidden="true"></span>{/if}{/key}
  </div>

  <div class="question">
    {#key e}
      {#if e === 0}
        <pre class="expr">{C[0].in}</pre>
        <p class="source">cpso3 · Étude électorale canadienne 1993</p>
        <div class="legende">
          <span class="pastille v">TRUE</span><span>oui</span>
          <span class="pastille f">FALSE</span><span>non</span>
        </div>
      {:else if q}
        <pre class="expr">{q.avant}<b>{q.op}</b>{q.apres}</pre>
        <div class="op">
          <span class="glyphe">{q.op}</span>
          <span class="sens">{q.nom}{#if q.note}<em>{q.note}</em>{/if}</span>
        </div>
      {:else}
        <pre class="expr long">{sAvant}<b>&gt;=</b>{sApres}</pre>
        <pre class="sortie">{somme.out}</pre>
        <p class="compte"><span class="pastille v">TRUE</span> compte pour 1</p>
        <p class="addition">{parts.map(fmt).join(' + ')} = <b>{fmt(TOTAL_R)}</b> personnes</p>
      {/if}
    {/key}
  </div>
</div>

<style>
  .op93 { display: grid; grid-template-columns: minmax(0, 1.15fr) minmax(0, 1fr); gap: 2.2em; align-items: center; }

  /* L'échelle : onze marches, la barre s'allonge avec le code. */
  .boite { position: relative; }
  .echelle { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.26em; }
  .echelle li { display: grid; grid-template-columns: 1.7em 1fr; gap: 0.45em; align-items: center; font-size: 0.92em; }
  .code { font-weight: 700; font-size: 1.15em; text-align: right; font-variant-numeric: tabular-nums; transition: color 0.3s; transition-delay: calc(var(--i) * 70ms); }
  .marche { display: flex; align-items: center; gap: 0.45em; min-width: 0; }
  .barre { display: block; flex: 0 0 var(--l); border: 2px solid var(--dk-encre); background: var(--dk-fond); padding: 0.14em 0.5em; transition: background 0.3s, border-color 0.3s, color 0.3s; transition-delay: calc(var(--i) * 70ms); }
  .nom { white-space: nowrap; font-size: 0.92em; }
  .rep { font-size: 0.72em; animation: tomber 0.3s both; animation-delay: calc(var(--i) * 70ms); }
  .n { font-weight: 700; font-size: 0.95em; color: var(--dk-accent); font-variant-numeric: tabular-nums; animation: fondu 0.3s both; animation-delay: calc(0.4s + var(--i) * 70ms); }

  .echelle li.vrai .barre { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .echelle li.vrai .code { color: var(--dk-accent); }
  .echelle li.faux .barre { background: var(--dk-fond-2); border-color: var(--dk-filet); color: var(--dk-gris-2); }
  .echelle li.faux .code { color: var(--dk-gris-2); }
  @keyframes tomber { from { opacity: 0; transform: translateX(-0.5em); } to { opacity: 1; transform: none; } }

  /* Le balayage : un trait rouge descend l'échelle, en même temps que les réponses. */
  .balai { position: absolute; left: 0; right: 0; top: 0; height: 3px; background: var(--dk-accent); animation: balayer 0.95s ease-in-out both; pointer-events: none; }
  @keyframes balayer { 0% { top: 0; opacity: 1; } 90% { opacity: 1; } 100% { top: 100%; opacity: 0; } }

  /* La question posée. */
  .question { display: flex; flex-direction: column; gap: 0.9em; min-width: 0; }
  .expr { margin: 0; font-family: var(--dk-mono); font-size: 2.3em; font-weight: 600; line-height: 1.3; border: 3px solid var(--dk-encre); border-left: 0.3em solid var(--dk-accent); background: var(--dk-fond-2); padding: 0.3em 0.55em; animation: fondu 0.35s both; }
  .expr.long { font-size: 1.55em; }
  .expr b { color: var(--dk-accent); }
  .source { margin: 0; font-size: 0.8em; color: var(--dk-gris); animation: fondu 0.4s 0.1s both; }

  .op { display: grid; grid-template-columns: auto 1fr; gap: 0.6em; align-items: center; animation: fondu 0.4s 0.15s both; }
  .glyphe { font-family: var(--dk-mono); font-weight: 700; font-size: 2.6em; line-height: 1; color: var(--dk-fond); background: var(--dk-accent); padding: 0.12em 0.3em; }
  .sens { font-size: 1.45em; font-weight: 600; line-height: 1.25; display: flex; flex-direction: column; }
  .sens em { font-style: normal; font-weight: 400; font-size: 0.72em; color: var(--dk-gris); margin-top: 0.2em; }

  .legende { display: grid; grid-template-columns: auto 1fr; gap: 0.45em 0.6em; align-items: center; font-size: 1.2em; animation: fondu 0.4s 0.2s both; }
  .pastille { font-weight: 700; font-size: 0.85em; padding: 0.1em 0.45em; border: 2px solid; text-align: center; }
  .pastille.v { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .pastille.f { background: var(--dk-fond-2); border-color: var(--dk-filet); color: var(--dk-gris-2); }

  .sortie { margin: 0; font-family: var(--dk-mono); font-size: 2em; font-weight: 700; color: var(--dk-accent); animation: fondu 0.4s 0.5s both; }
  .compte { margin: 0; font-size: 1.4em; font-weight: 600; display: flex; gap: 0.5em; align-items: center; animation: fondu 0.4s 0.8s both; }
  .addition { margin: 0; font-size: 1.1em; color: var(--dk-gris); font-variant-numeric: tabular-nums; animation: fondu 0.4s 1.1s both; }
  .addition b { color: var(--dk-accent); }

  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .expr, .source, .op, .legende, .sortie, .compte, .addition, .balai { animation: none; }
    .code, .barre { transition: none; }
    .rep, .n { animation: none; }
  }
</style>
