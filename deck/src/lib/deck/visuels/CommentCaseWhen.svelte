<script>
  /**
   * Comment case_when() lit vos données : la mécanique, sur six vraies
   * personnes de l'Étude électorale canadienne 2025. À gauche, la colonne
   * df_raw$cps25_demsat (BRUT); au centre, les quatre règles du code que R a
   * exécuté (CONSOLES.satisfaction); à droite, df_clean$satisfaction (PROPRE)
   * qui se remplit. Rien n'est tapé à la main : les codes, les règles et les
   * valeurs écrites viennent de src/lib/data/seance4.js.
   *
   * Pour la ligne active, chaque règle est testée de haut en bas (« 4 == 1 »
   * → FALSE…); la première TRUE donne la valeur; les suivantes ne sont pas
   * testées; aucune TRUE → NA. Cinq temps :
   *
   *   1  ligne 1 : quatre tests, la quatrième règle gagne
   *   2  ligne 2 : la deuxième règle gagne, les deux dernières ne sont pas testées
   *   3  lignes 3 et 4 (comme la ligne 2), puis la ligne 5 : aucune règle, NA
   *   4  toutes les autres lignes d'un coup : la colonne complète
   *   5  les trois idées, en clair
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { CONSOLES, BRUT, PROPRE } from '$lib/data/seance4.js';

  // Le code exécuté par R, découpé ligne à ligne.
  const CODE = CONSOLES.satisfaction.find((l) => l.in.includes('case_when')).in;
  const LIGNES = CODE.split('\n').map((l) => {
    const m = l.match(/^(\s*)(.*?==\s*(\S+))(\s*~\s*)(.*?)(,?)$/);
    if (!m) return { regle: false, html: surlignerR(l) };
    return {
      regle: true,
      retrait: m[1],
      condition: surlignerR(m[2]),
      code: m[3],
      tilde: m[4],
      valeur: surlignerR(m[5]),
      virgule: m[6]
    };
  });
  const REGLES = LIGNES.filter((l) => l.regle);
  const [DEST] = CODE.split(' <- ');
  const SOURCE = CODE.match(/(df_raw\$\w+)/)[1];
  const VAR_BRUT = SOURCE.split('$')[1];
  const VAR_PROPRE = DEST.split('$')[1];

  // Les six personnes : le code brut et la valeur que R a écrite.
  const iB = BRUT.cols.indexOf(VAR_BRUT);
  const iP = PROPRE.cols.indexOf(VAR_PROPRE);
  const RANGS = BRUT.rows.map((r, i) => {
    const code = r[iB];
    const v = PROPRE.rows[i][iP];
    return {
      code,
      ecrit: v === null ? 'NA' : String(v),
      gagne: REGLES.findIndex((g) => String(code) === g.code)
    };
  });

  // Ligne active à chaque temps, et lignes déjà écrites dans df_clean.
  const NA_RANG = RANGS.findIndex((r) => r.gagne === -1);
  const ACTIVE = [-1, 0, 1, NA_RANG, -1, -1];
  const ECRITES = [0, 1, 2, NA_RANG + 1, RANGS.length, RANGS.length];
  const PAS = 0.75; // secondes entre deux tests

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const a = $derived(ACTIVE[e]);
  const rang = $derived(a >= 0 ? RANGS[a] : null);
  // Nombre de règles testées pour la ligne active (toutes si aucune ne gagne).
  const testees = $derived(rang ? (rang.gagne === -1 ? REGLES.length : rang.gagne + 1) : 0);
  const fin = $derived(testees * PAS + 0.3);

  const IDEES = [
    'Une ligne à la fois.',
    'De haut en bas : la première règle vraie gagne.',
    'Aucune règle vraie : NA.'
  ];
</script>

<div class="visuel ccw" bind:this={hote}>
  {#key e}
    <div class="scene">
      <!-- df_raw -->
      <div class="col">
        <div class="tete"><span class="df">df_raw</span><span class="var">{VAR_BRUT}</span></div>
        {#each RANGS as r, i}
          <div class="rangee">
            <span class="num">{i + 1}</span>
            <span class="cell brut" class:active={i === a} class:lue={i < ECRITES[e] && i !== a}>{r.code}</span>
          </div>
        {/each}
        <div class="rangee suite"><span class="num"></span><span class="cell vide">⋮</span></div>
      </div>

      <!-- les règles -->
      <div class="regles">
        {#each LIGNES as l}
          {#if l.regle}
            {@const k = REGLES.indexOf(l)}
            {@const teste = rang && k < testees}
            {@const vrai = teste && k === rang.gagne}
            <div class="ligne regle" class:saute={rang && k >= testees} class:gagne={vrai} style="--t: {k * PAS}s">
              <code class="ligne-code">{l.retrait}{@html l.condition}{l.tilde}<span class="val">{@html l.valeur}</span>{l.virgule}</code>
              <span class="verdict">
                {#if teste}
                  <span class="test"><span class="x">{rang.code}</span> == {l.code}</span>
                  <span class="verite" class:vrai>{vrai ? 'TRUE' : 'FALSE'}</span>
                {:else if rang}
                  <span class="non">non testée</span>
                {/if}
              </span>
            </div>
          {:else}
            <div class="ligne autour">
              <code class="ligne-code">{@html l.html}</code>
              <span class="verdict resultat" class:na={rang && rang.gagne === -1} style="--t: {fin}s">
                {#if rang && l.html.includes('(') === false}
                  {#if rang.gagne === -1}
                    <span>aucune TRUE</span> <b>→ NA</b>
                  {:else}
                    <b>→ {rang.ecrit}</b>
                  {/if}
                {/if}
              </span>
            </div>
          {/if}
        {/each}
      </div>

      <!-- df_clean -->
      <div class="col">
        <div class="tete"><span class="df">df_clean</span><span class="var">{VAR_PROPRE}</span></div>
        {#each RANGS as r, i}
          {@const ecrite = i < ECRITES[e]}
          <div class="rangee">
            <span class="num">{i + 1}</span>
            <span
              class="cell propre"
              class:ecrite
              class:na={r.ecrit === 'NA'}
              class:neuve={i === a}
              style="--t: {i === a ? fin + 0.4 : 0}s">{ecrite ? r.ecrit : ''}</span>
          </div>
        {/each}
        <div class="rangee suite"><span class="num"></span><span class="cell vide" class:plein={e >= 4}>⋮</span></div>
      </div>
    </div>
  {/key}

  <ol class="idees" class:vue={e >= 5} aria-hidden={e < 5}>
    {#each IDEES as t, i}
      <li style="--t: {i * 0.35}s"><span>{t}</span></li>
    {/each}
  </ol>
</div>

<style>
  .ccw { display: flex; flex-direction: column; gap: 1em; }
  .scene { display: grid; grid-template-columns: auto auto auto; justify-content: space-between; gap: 1.6em; align-items: start; }

  /* Les deux colonnes de données */
  .col { display: flex; flex-direction: column; gap: 0.25em; }
  .tete { display: flex; flex-direction: column; margin-bottom: 0.2em; padding-left: 1.6em; }
  .df { font-size: 0.7em; letter-spacing: 0.12em; color: var(--dk-gris); }
  .var { font-size: 0.95em; font-weight: 600; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.1em; }
  .rangee { display: grid; grid-template-columns: 1.6em 1fr; align-items: center; }
  .num { font-size: 0.75em; color: var(--dk-gris-2); text-align: right; padding-right: 0.6em; font-variant-numeric: tabular-nums; }
  .cell { border: 2px solid var(--dk-encre); text-align: center; font-size: 1.25em; font-weight: 600; height: 1.5em; line-height: 1.4em; font-variant-numeric: tabular-nums; }
  .cell.vide { border-style: dashed; border-color: var(--dk-gris-2); color: var(--dk-gris-2); font-weight: 400; transition: color 0.3s, border-color 0.3s; }
  .cell.vide.plein { border-color: var(--dk-encre); color: var(--dk-encre); }
  .brut.active { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .brut.lue { color: var(--dk-gris-2); border-color: var(--dk-gris-2); }
  .propre { border-style: dashed; border-color: var(--dk-gris-2); }
  .propre.ecrite { border-style: solid; border-color: var(--dk-encre); }
  .propre.ecrite.na { color: var(--dk-gris); border-style: dashed; border-color: var(--dk-gris); }
  .propre.neuve { animation: ecrire 0.5s var(--t) both; }

  /* Le code, une rangée par ligne, avec la colonne des tests */
  .regles { display: grid; grid-template-columns: auto 11em; column-gap: 1.2em; align-items: center; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.3em solid var(--dk-accent); padding: 0.5em 0.7em; align-self: center; }
  .ligne { display: contents; }
  .ligne > * { min-height: 2em; }
  .verdict { display: flex; align-items: center; }
  .ligne-code { display: block; font-family: var(--dk-mono); font-size: 1.05em; white-space: pre; padding: 0 0.2em; line-height: 1.9; }
  .autour .ligne-code { opacity: 0.6; }
  .regle .ligne-code { transition: opacity 0.3s; }
  .regle.saute .ligne-code { opacity: 0.3; }
  .regle.gagne .ligne-code { animation: souligner 0.4s var(--t) both; }
  .regle.gagne .val { animation: allumer 0.4s var(--t) both; }
  .val :global(span) { color: inherit; }
  .verdict { gap: 0.6em; white-space: nowrap; font-size: 1.05em; }
  .regle .verdict > * { animation: fondu 0.35s var(--t) both; }
  .test { color: var(--dk-gris); }
  .test .x { color: var(--dk-encre); font-weight: 600; }
  .verite { border: 2px solid var(--dk-gris-2); color: var(--dk-gris); padding: 0 0.35em; font-weight: 600; letter-spacing: 0.04em; }
  .verite.vrai { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
  .non { color: var(--dk-gris-2); font-size: 0.85em; border: 2px dashed var(--dk-gris-2); padding: 0 0.35em; }

  .resultat > * { animation: fondu 0.35s var(--t) both; }
  .resultat b { color: var(--dk-accent); }
  .resultat.na b { color: var(--dk-gris); }
  .resultat span { color: var(--dk-gris); }

  /* Les trois idées */
  .idees { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: 1fr 1.5fr 1.2fr; gap: 1.2em; border-top: 2px solid var(--dk-encre); padding-top: 0.5em; counter-reset: idee; }
  .idees li { font-size: 1.05em; line-height: 1.3; opacity: 0; transition: opacity 0.4s var(--t); counter-increment: idee; }
  .idees li::before { content: counter(idee); color: var(--dk-accent); font-weight: 700; margin-right: 0.5em; }
  .idees.vue li { opacity: 1; }

  @keyframes fondu { from { opacity: 0; transform: translateY(0.25em); } to { opacity: 1; transform: none; } }
  @keyframes ecrire { from { background: var(--dk-accent); color: var(--dk-fond); opacity: 0; } 30% { opacity: 1; background: var(--dk-accent); color: var(--dk-fond); } to { background: transparent; } }
  @keyframes souligner { from { outline: 2px solid transparent; } to { outline: 2px solid var(--dk-accent); background: #fff; } }
  @keyframes allumer { from { background: transparent; } to { background: var(--dk-accent); color: var(--dk-fond); } }
  @media (prefers-reduced-motion: reduce) {
    .regle .verdict > *, .resultat, .propre.neuve, .regle.gagne .ligne-code, .regle.gagne .val { animation-duration: 0.01s; animation-delay: 0s; }
  }
</style>
