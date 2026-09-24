<script>
  /**
   * Si…, alors… : l'anatomie d'une règle de case_when(), puis sa lecture en
   * français, et enfin les trois règles lues de haut en bas (inspiré de
   * « Anatomie d'une ligne de code » et « En langage naturel » du cours 4 de
   * FAS1001). Le code est celui que R a exécuté sur l'Étude électorale
   * canadienne de 1993 (CONSOLES_PLUS.casewhen93[1]); les codes 1 à 11 de
   * cpso3 viennent de EDUC93. Les groupes de la bande sont calculés à partir
   * des seuils lus dans le code : rien n'est tapé à la main. Sept temps :
   *
   *   1  la condition        2  le ~ : « alors »
   *   3  la nouvelle valeur  4  la phrase en français
   *   5  règle 1 : codes 1 à 5
   *   6  règle 2 : codes 6 et 7 (1 à 5 sont déjà pris)
   *   7  règle 3 : codes 8 à 11; NA ne passe aucune règle
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { CONSOLES_PLUS, EDUC93 } from '$lib/data/seance4_plus.js';

  // Découpe du code : chaque ligne qui contient ~ est une règle.
  const LIGNES = CONSOLES_PLUS.casewhen93[1].in.split('\n').map((l) => {
    if (!l.includes('~')) return { regle: false, html: surlignerR(l) };
    const [gauche, droite] = l.split('~');
    const m = gauche.match(/^(\s*)(.*?)(\s*)$/);
    const seuil = Number(gauche.match(/<=\s*(\d+)/)[1]);
    const [, valeur, virgule] = droite.match(/^\s*(.*?)(,?)\s*$/);
    return {
      regle: true,
      retrait: m[1],
      condition: surlignerR(m[2]),
      espace: m[3],
      valeur: surlignerR(valeur),
      virgule,
      nom: valeur.replace(/"/g, ''),
      seuil
    };
  });
  const REGLES = LIGNES.filter((l) => l.regle);

  // Chaque code va à la première règle dont la condition est TRUE.
  const CODES = EDUC93.codes.map((c) => ({ c, r: REGLES.findIndex((r) => c <= r.seuil) }));
  const GROUPES = REGLES.map((r, i) => ({ nom: r.nom, n: CODES.filter((k) => k.r === i).length }));

  const plage = (i) => {
    const cs = CODES.filter((k) => k.r === i).map((k) => k.c);
    return cs.length === 2 ? `${cs[0]} et ${cs[1]}` : `${cs[0]} à ${cs[cs.length - 1]}`;
  };

  const LEG = [
    ['UNE RÈGLE PAR LIGNE', 'Trois catégories, trois règles.'],
    ['LA CONDITION', 'Une question à R : TRUE ou FALSE.'],
    ['ALORS', 'Le ~ se lit « alors ».'],
    ['LA NOUVELLE VALEUR', 'Ce qu’on écrit dans ses_education.'],
    ['EN FRANÇAIS', ''],
    ['RÈGLE 1', `Les codes ${plage(0)}.`],
    ['RÈGLE 2', `Les codes ${plage(1)}. Les codes ${plage(0)} sont déjà pris.`],
    ['RÈGLE 3', `Les codes ${plage(2)}. Aucune règle pour NA : NA.`]
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 7, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Règle mise en avant : la première pendant l'anatomie, puis chacune.
  const active = $derived(e === 0 ? -1 : e <= 4 ? 0 : e - 5);
</script>

<div class="visuel casewhen" bind:this={hote}>
  <pre class="code">{#each LIGNES as l, i}{#if l.regle}{@const k = REGLES.indexOf(l)}<span class="regle" class:vue={k === active} class:passe={e >= 5 && k > active}>{l.retrait}<span class="p" class:on={(e === 1 && k === 0) || (e >= 5 && k === active)}>{@html l.condition}</span>{l.espace}<span class="p tilde" class:on={e === 2 && k === 0}>~</span> <span class="p" class:on={e === 3 && k === 0}>{@html l.valeur}</span>{l.virgule}</span>{:else}<span class="autour">{@html l.html}</span>{/if}{#if i < LIGNES.length - 1}{'\n'}{/if}{/each}</pre>

  {#key e}
    <div class="legende">
      <span class="et">{LEG[e][0]}</span>
      {#if e !== 4}
        <p>{LEG[e][1]}</p>
      {:else}
        <p class="phrase">Si cpso3 vaut 5 ou moins, <b>alors</b> écrire "secondaire_ou_moins".</p>
        <p class="suite">Sinon, essayer la règle suivante. Aucune règle ne marche ? <b>NA</b>.</p>
      {/if}
    </div>
  {/key}

  <div class="bande" class:vue={e >= 5} aria-hidden={e < 5}>
    <div class="cases">
      {#each CODES as k}
        <div class="case" class:prise={e >= 5 && k.r < active} class:juste={e >= 5 && k.r === active}>{k.c}</div>
      {/each}
      <div class="case na" class:aucune={e === 7}>NA</div>
    </div>
    <div class="noms">
      {#each GROUPES as g, i}
        <span style="grid-column: span {g.n}" class:montre={e >= 5 && i <= active} class:juste={i === active}>{g.nom}</span>
      {/each}
      <span class="montre-na" class:montre={e === 7}>NA</span>
    </div>
  </div>
</div>

<style>
  .casewhen { display: flex; flex-direction: column; gap: 0.7em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1.45em; line-height: 1.45; white-space: pre; background: var(--dk-fond-2); border: 3px solid var(--dk-encre); border-left: 0.3em solid var(--dk-accent); padding: 0.45em 0.8em; overflow-x: auto; }
  .autour { opacity: 0.5; }
  .regle { display: inline-block; transition: background 0.3s, opacity 0.3s; }
  .regle.vue { background: #fff; outline: 2px solid var(--dk-encre); outline-offset: 0.08em; }
  .regle.passe { opacity: 0.35; }
  .p { transition: background 0.3s, color 0.3s; padding: 0 0.05em; }
  .p.on { background: var(--dk-accent); color: var(--dk-fond); }
.p.on :global(span) { color: inherit; }
  .tilde.on { font-weight: 700; }

  .legende { display: flex; flex-direction: column; gap: 0.25em; min-height: 3.6em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.35em; line-height: 1.3; animation: fondu 0.4s both; }
  .legende .suite { font-size: 1.05em; color: var(--dk-gris); animation-delay: 0.3s; }
  .legende b { color: var(--dk-accent); }

  .bande { opacity: 0; transition: opacity 0.4s; display: flex; flex-direction: column; gap: 0.3em; }
  .bande.vue { opacity: 1; }
  .cases, .noms { display: grid; grid-template-columns: repeat(11, 1fr) 1.4fr; gap: 0.3em; }
  .case { border: 3px solid var(--dk-encre); text-align: center; font-size: 1.4em; font-weight: 600; padding: 0.2em 0; font-variant-numeric: tabular-nums; transition: background 0.3s, color 0.3s, border-color 0.3s; }
  .case.na { margin-left: 0.6em; border-style: dashed; }
  .case.juste { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .case.aucune { color: var(--dk-gris); border-color: var(--dk-gris); }
  .case.prise { background: var(--dk-encre); color: var(--dk-fond); }
  .noms span { border-top: 3px solid var(--dk-encre); text-align: center; font-size: 0.9em; padding-top: 0.15em; opacity: 0; transition: opacity 0.3s; }
  .noms span.montre { opacity: 1; }
  .noms span.juste { color: var(--dk-accent); border-top-color: var(--dk-accent); font-weight: 600; }
  .noms .montre-na { margin-left: 0.6em; color: var(--dk-gris); border-top-style: dashed; }

  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .legende p { animation: none; } }
</style>
