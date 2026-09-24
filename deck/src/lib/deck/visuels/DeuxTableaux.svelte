<script>
  /**
   * df_raw et df_clean : deux tableaux séparés. Le brut (l'Étude électorale
   * canadienne de 1993, tel que chargé) ne change jamais; le propre naît vide,
   * avec autant de lignes que le brut, puis se remplit une colonne à la fois.
   * Le code est celui que R a exécuté (CONSOLES_PLUS.casewhen93[1] et [2]),
   * la taille du brut vient de RAW93. Les noms de colonnes affichés sont de
   * vrais noms de names(df_raw) : la 1re (idnum), la 2e (refprov), la 349e
   * (cpsg1), la 522e (cpso3) et la dernière (rlink). Aucune valeur n'est
   * montrée dans le brut; id vaut 1, 2, 3… par construction. Trois temps :
   *
   *   0  df_raw seul, en lecture seulement.
   *   1  df_clean <- data.frame(id = 1:nrow(df_raw)) : même nombre de lignes, une colonne.
   *   2  case_when() lit cpso3 dans df_raw et écrit ses_education dans df_clean.
   *   3  D'autres colonnes suivront; df_raw n'a pas bougé.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { RAW93, CONSOLES_PLUS } from '$lib/data/seance4_plus.js';

  const [N, P] = RAW93;
  const milliers = (n) => String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ' ');

  // Le code exécuté; nrow(df_raw) est repéré pour s'allumer au temps 1.
  const CREER = surlignerR(CONSOLES_PLUS.casewhen93[1].in).replace(
    /<span class="r-fn">nrow<\/span>\(df_raw\)/,
    '<span class="nrow"><span class="r-fn">nrow</span>(df_raw)</span>'
  );
  const REMPLIR = surlignerR(CONSOLES_PLUS.casewhen93[2].in);

  // En-têtes du brut : null = colonnes sautées.
  const BRUT = ['idnum', 'refprov', null, 'cpsg1', null, 'cpso3', null, 'rlink'];
  // Quatre premières lignes, un saut, la dernière : les mêmes dans les deux tableaux.
  const LIGNES = [1, 2, 3, 4, null, N];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel deux-tableaux" bind:this={hote}>
  <!-- Les noms -->
  <div class="nom">
    <code>df_raw</code>
    <span class="verrou" class:fort={e === 3}>
      <svg viewBox="0 0 20 24" aria-hidden="true"><path d="M5 11V7a5 5 0 0 1 10 0v4" /><rect x="2" y="11" width="16" height="11" /></svg>
      lecture seulement
    </span>
  </div>
  <div></div>
  <div class="nom" class:cache={e < 1}><code class="rouge">df_clean</code></div>

  <!-- Les tableaux -->
  <table class="brut">
    <thead>
      <tr>{#each BRUT as c}<th class:saut={!c} class:lu={c === 'cpso3' && e >= 2}>{c ?? '…'}</th>{/each}</tr>
    </thead>
    <tbody>
      {#each LIGNES as l}
        <tr class:trou={l === null}>
          {#each BRUT as c}<td class:saut={!c} class:lu={c === 'cpso3' && e >= 2}>{l === null ? '⋮' : ''}</td>{/each}
        </tr>
      {/each}
    </tbody>
  </table>

  <div class="fleche" class:vue={e >= 2}>
    <span class="fn">case_when()</span>
    <svg viewBox="0 0 100 20" preserveAspectRatio="none" aria-hidden="true"><path d="M2 10H92" /><path d="M84 3L96 10L84 17" /></svg>
  </div>

  <table class="propre" class:cache={e < 1}>
    <thead>
      <tr>
        <th>id</th>
        <th class="nouvelle" class:cache={e < 2}>ses_education</th>
        <th class="fantome" class:cache={e < 3}>…</th>
      </tr>
    </thead>
    <tbody>
      {#each LIGNES as l}
        <tr class:trou={l === null}>
          <td class="id">{l === null ? '⋮' : l}</td>
          <td class="nouvelle" class:cache={e < 2}>{#if l === null}⋮{:else}<span class="barre"></span>{/if}</td>
          <td class="fantome" class:cache={e < 3}></td>
        </tr>
      {/each}
    </tbody>
  </table>

  <!-- Les tailles -->
  <p class="taille"><b class:allume={e === 1}>{milliers(N)} lignes</b> × <b class:allume={e === 3}>{milliers(P)} colonnes</b></p>
  <div></div>
  <p class="taille" class:cache={e < 1}><b class:allume={e === 1}>{milliers(N)} lignes</b> × {e >= 2 ? '2 colonnes' : '1 colonne'}</p>

  <!-- Le code -->
  <!-- Deux blocs : le second garde sa place, pour que rien ne saute au clic. -->
  <pre class="code" class:cache={e < 1}><span class="ligne" class:passe={e >= 2}>{@html CREER}</span></pre>
  <pre class="code deux" class:cache={e < 2}><span class="ligne">{@html REMPLIR}</span></pre>
</div>

<style>
  .deux-tableaux {
    display: grid;
    grid-template-columns: auto 1fr auto;
    gap: 0.3em 0;
    align-items: start;
    width: 100%;
  }
  .cache { visibility: hidden; opacity: 0; }
  .nom, .propre, .taille, .code, .fantome, .nouvelle { transition: opacity 0.45s; }

  .nom { display: flex; align-items: baseline; gap: 0.8em; }
  .nom code { font-family: var(--dk-mono); font-size: 1.15em; font-weight: 600; }
  .nom code.rouge { color: var(--dk-accent); }
  .verrou { display: inline-flex; align-items: center; gap: 0.35em; font-size: 0.7em; letter-spacing: 0.08em; color: var(--dk-gris); border: 2px solid var(--dk-gris); padding: 0.1em 0.5em; transition: color 0.3s, border-color 0.3s; }
  .verrou svg { width: 0.9em; height: 1.1em; fill: none; stroke: currentColor; stroke-width: 2.4; }
  .verrou.fort { color: var(--dk-accent); border-color: var(--dk-accent); }

  table { border-collapse: collapse; border: 3px solid var(--dk-encre); font-size: 0.95em; }
  th { background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; text-transform: none; letter-spacing: 0; padding: 0.2em 0.55em; text-align: left; white-space: nowrap; transition: background 0.3s; }
  td { height: 1.35em; padding: 0 0.55em; border-bottom: 1px solid var(--dk-filet); border-right: 1px solid var(--dk-filet); background: var(--dk-fond-2); transition: background 0.3s, outline-color 0.3s; }
  th.saut, td.saut { color: var(--dk-gris-2); text-align: center; padding: 0 0.3em; }
  th.saut { background: var(--dk-gris); color: var(--dk-fond); }
  tr.trou td { background: transparent; color: var(--dk-gris-2); text-align: center; line-height: 1; }
  th.lu { background: var(--dk-accent); }
  td.lu { background: #f4d6db; }

  /* Le propre : bordures séparées, pour qu'une colonne cachée ne laisse aucun trait. */
  .propre { border: 0; border-collapse: separate; border-spacing: 0; }
  .propre th, .propre td { border-right: 3px solid var(--dk-encre); }
  .propre th:first-child, .propre td:first-child { border-left: 3px solid var(--dk-encre); }
  .propre th { border-top: 3px solid var(--dk-encre); }
  .propre tr:last-child td { border-bottom: 3px solid var(--dk-encre); }
  .propre td { background: #fff; }
  .propre td.id { text-align: right; font-variant-numeric: tabular-nums; font-weight: 600; }
  .propre th.nouvelle { background: var(--dk-accent); border-top-color: var(--dk-accent); }
  .barre { display: block; height: 0.35em; background: var(--dk-accent); opacity: 0.75; }
  .propre th.fantome, .propre td.fantome { background: transparent; color: var(--dk-gris); border: 0; border-right: 2px dashed var(--dk-gris-2); min-width: 2.5em; text-align: center; }
  .propre th.fantome { border-top: 2px dashed var(--dk-gris-2); }
  .propre tr:last-child td.fantome { border-bottom: 2px dashed var(--dk-gris-2); }
  .propre td.fantome { border-bottom: 1px dashed var(--dk-filet); }

  .fleche { align-self: center; display: flex; flex-direction: column; align-items: center; gap: 0.2em; padding: 0 0.6em; opacity: 0; transition: opacity 0.45s; }
  .fleche.vue { opacity: 1; }
  .fleche .fn { font-family: var(--dk-mono); font-weight: 600; font-size: 0.8em; color: var(--dk-accent); }
  .fleche svg { width: 100%; min-width: 5em; height: 1.1em; fill: none; stroke: var(--dk-accent); stroke-width: 3; vector-effect: non-scaling-stroke; }
  .fleche svg path { vector-effect: non-scaling-stroke; }

  .taille { margin: 0.1em 0 0; font-size: 0.8em; color: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .taille b { font-weight: 600; color: var(--dk-encre); transition: color 0.3s; }
  .taille b.allume { color: var(--dk-accent); }

  .code {
    grid-column: 1 / -1;
    margin: 0.5em 0 0;
    font-family: var(--dk-mono);
    font-size: 1.05em;
    line-height: 1.4;
    white-space: pre;
    background: var(--dk-fond-2);
    border: 3px solid var(--dk-encre);
    border-left: 0.3em solid var(--dk-accent);
    padding: 0.4em 0.8em;
  }
  .code.deux { margin-top: 0.1em; }
  .ligne { transition: opacity 0.4s; }
  .ligne.passe { opacity: 0.4; }
.ligne:not(.passe) :global(.nrow) { background: var(--dk-accent); color: var(--dk-fond); }
.ligne:not(.passe) :global(.nrow span) { color: inherit; }

  @media (prefers-reduced-motion: reduce) { .nom, .propre, .taille, .code, .fleche, .ligne { transition: none; } }
</style>
