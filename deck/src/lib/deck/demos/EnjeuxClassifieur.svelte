<script>
  import d from './enjeux-classifieur.json';
  import { surlignerR } from '../surligner.js';
  import { brancherTemps } from '../temps.js';

  /**
   * La nouvelle façon, sur les trois mêmes réponses que EnjeuxDictionnaire et
   * dans la même mise en scène : une puce sort de la cellule, entre dans la
   * consigne, passe par le modèle, revient en JSON, s'y réduit à la seule
   * valeur, puis se pose dans la colonne enjeu.
   *
   * Ce qui a vraiment tourné, dit tel quel : les 300 réponses ont été classées
   * par Claude (Anthropic) dans Claude Code, le 5 novembre 2026, en suivant la
   * consigne affichée au premier temps, toutes dans une même session. Ce n'est
   * pas un appel d'API par ligne. La ligne de R sous le circuit est donc
   * étiquetée « le même geste en R » : c'est ce qu'on écrirait avec ellmer,
   * pas le code qui a produit ces réponses.
   *
   * Au premier temps, la consigne entière. Au dernier, la répartition des 300
   * réponses. Les trois couches partagent une case : la hauteur ne bouge pas.
   * Tout vient de enjeux-classifieur.json (outils/seance9_enjeux.R).
   */
  const L = d.lignes;
  const C = d.consigne;

  const PHASES = [
    { id: 'lire', t: 'Lire la cellule' },
    { id: 'prompt', t: 'Coller la réponse dans la consigne' },
    { id: 'appel', t: 'Soumettre au modèle' },
    { id: 'json', t: 'Recevoir la réponse, en JSON' },
    { id: 'parse', t: 'Extraire la valeur du JSON' },
    { id: 'ecrire', t: 'Écrire la valeur dans la cellule' }
  ];
  const TOTAL = 2 + L.length * PHASES.length + 1;

  let hote = $state(null);
  let puce = $state(null);
  let cellulesTexte = $state([]);
  let cellulesCible = $state([]);
  let quaiPrompt = $state(null);
  let quaiModele = $state(null);
  let quaiRep = $state(null);

  let js = $state(false);
  let e = $state(TOTAL - 1); // sans JS : tableau rempli, répartition affichée
  let pos = $state(null);
  let saut = $state(false);

  const initial = $derived(e === 0);
  const creation = $derived(e === 1);
  const terminal = $derived(e === TOTAL - 1);
  const enCours = $derived(e >= 2 && e < TOTAL - 1);
  const iLigne = $derived(enCours ? Math.floor((e - 2) / PHASES.length) : -1);
  const phase = $derived(enCours ? PHASES[(e - 2) % PHASES.length] : null);
  const ligne = $derived(iLigne >= 0 && iLigne < L.length ? L[iLigne] : null);
  const remplie = (i) => e >= 2 + i * PHASES.length + PHASES.length;
  const colVue = $derived(e >= 1);

  const jsonTexte = (l) => `{"categorie": "${l.categorie}"}`;

  // Le passage du JSON complet à la seule valeur EST l'analyse du JSON.
  const charge = $derived(
    !ligne
      ? ''
      : phase?.id === 'json'
        ? jsonTexte(ligne)
        : phase?.id === 'parse' || phase?.id === 'ecrire'
          ? ligne.categorie
          : ligne.texte
  );
  const brut = $derived(phase?.id === 'json');
  const valeur = $derived(phase?.id === 'parse' || phase?.id === 'ecrire');

  // Le même geste, écrit en R avec ellmer. Pas le code qui a produit ces
  // réponses : celles-ci viennent de Claude, dans Claude Code.
  const CODE = {
    creation: 'donnees$enjeu <- NA_character_',
    lire: 'texte <- donnees$cps25_imp_iss[i]',
    prompt: 'prompt <- paste(consigne, texte)',
    appel: 'reponse <- chat$chat(prompt)',
    json: 'reponse <- chat$chat(prompt)  # du texte, au format JSON',
    parse: 'valeur <- jsonlite::fromJSON(reponse)$categorie',
    ecrire: 'donnees$enjeu[i] <- valeur',
    terminal: 'for (i in seq_len(nrow(donnees))) { ... }'
  };
  const codeR = $derived(
    creation ? CODE.creation : terminal ? CODE.terminal : (CODE[phase?.id] ?? '')
  );

  const quai = () => {
    if (!phase) return null;
    if (phase.id === 'lire') return cellulesTexte[iLigne];
    if (phase.id === 'prompt') return quaiPrompt;
    if (phase.id === 'appel') return quaiModele;
    if (phase.id === 'json' || phase.id === 'parse') return quaiRep;
    return cellulesCible[iLigne];
  };

  function placer(sansTransition = false) {
    const cible = quai();
    if (!hote || !puce || !cible) return;
    const h = hote.getBoundingClientRect();
    const c = cible.getBoundingClientRect();
    const p = puce.getBoundingClientRect();
    saut = sansTransition;
    pos = {
      x: c.left - h.left + c.width / 2 - p.width / 2,
      y: c.top - h.top + c.height / 2 - p.height / 2
    };
    if (sansTransition) requestAnimationFrame(() => (saut = false));
  }

  $effect(() => {
    if (!js) return;
    e;
    requestAnimationFrame(() => placer(phase?.id === 'lire' || !phase));
  });

  $effect(() => {
    if (!hote) return;
    js = true;
    e = 0;
    const off = brancherTemps(hote, { total: TOTAL - 1, lire: () => e, ecrire: (v) => (e = v) });
    const ro = new ResizeObserver(() => placer(true));
    ro.observe(hote);
    return () => {
      off();
      ro.disconnect();
    };
  });

  // La répartition, en deux colonnes, de la plus fréquente à la plus rare.
  const D = d.distribution;
  const max = Math.max(...D.map((x) => x.n));
  const moitie = Math.ceil(D.length / 2);
  const colonnes = [D.slice(0, moitie), D.slice(moitie)];
</script>

<div class="clf enj" bind:this={hote}>
  <div class="clf-tete">
    <span class="pas-t">
      {#if initial}La consigne, écrite une seule fois
      {:else if creation}Créer la colonne qui va recevoir les catégories
      {:else if terminal}Même case que le dictionnaire : {d.accord.n} réponses sur {d.total}
      {:else}{phase?.t}{/if}
    </span>
    <span class="src">
      {d.modele} · {d.total} réponses
      {#if js}<span class="pas-n">{e + 1} / {TOTAL}</span>{/if}
    </span>
  </div>

  <table class="clf-t">
    <thead>
      <tr>
        {#each d.colonnes as c}<th>{c}</th>{/each}
        <th class="neuve"
          ><span class="entrant" class:vue={colVue}>enjeu</span><span class="soulign" class:vue={colVue}
          ></span></th
        >
      </tr>
    </thead>
    <tbody>
      {#each L as l, i}
        <tr class:active={i === iLigne}>
          <td class="mono">{l.id}</td>
          <td class="txt"><span bind:this={cellulesTexte[i]} class="cellule">{l.texte}</span></td>
          <td class="num">{l.langue}</td>
          <td class="cible">
            <span bind:this={cellulesCible[i]} class="cellule cible-in entrant" class:vue={colVue}>
              {#if remplie(i)}<span class="val">{l.categorie}</span>{/if}
            </span>
          </td>
        </tr>
      {/each}
      <tr class="reste">
        <td class="mono">…</td>
        <td class="txt">{d.total - L.length} autres lignes</td>
        <td class="num">…</td>
        <td class="cible"></td>
      </tr>
    </tbody>
  </table>

  <div class="pile">
    <!-- Premier temps : la consigne entière, celle qu'a suivie le modèle. -->
    <div class="couche consigne" class:montre={initial}>
      <p class="c-q">Réponse à la question « {C.question} »</p>
      <p class="c-t">{C.tache} {C.multiple} <code>{C.format}</code></p>
      <ul class="c-cats">
        {#each d.categories as c}<li>{c}</li>{/each}
      </ul>
      <ul class="c-regles">
        {#each C.regles as r}
          <li><span class="r-g">{r[0]}</span><span class="r-d">→ {r[1]}</span></li>
        {/each}
      </ul>
    </div>

    <div class="couche bas" class:montre={!initial}>
      <div class="pile">
        <div class="couche stations" class:montre={!initial && !terminal}>
          <div class="st" class:on={phase?.id === 'prompt'}>
            <span class="st-n">CONSIGNE</span>
            <span class="st-d">{C.tache} {C.multiple}</span>
            <span class="quai" bind:this={quaiPrompt}></span>
          </div>
          <span class="fl">▸</span>
          <div class="st" class:on={phase?.id === 'appel'}>
            <span class="st-n">MODÈLE</span>
            <span class="st-d">{d.modele} · dans Claude Code, 5 novembre 2026</span>
            <span class="quai" bind:this={quaiModele}></span>
          </div>
          <span class="fl">▸</span>
          <div class="st" class:on={phase?.id === 'json' || phase?.id === 'parse'}>
            <span class="st-n">RÉPONSE</span>
            <span class="st-d">
              {#if ligne && (phase?.id === 'json' || phase?.id === 'parse')}
                &#123; "categorie": "<span class="extrait" class:tire={phase?.id === 'parse'}
                  >{ligne.categorie}</span
                >" &#125;
              {:else}
                &#123; "categorie": … &#125;
              {/if}
            </span>
            <span class="quai" bind:this={quaiRep}></span>
          </div>
        </div>

        <!-- Dernier temps : la répartition des 300 réponses. -->
        <div class="couche repart" class:montre={terminal}>
          {#each colonnes as col}
            <ul class="r-col">
              {#each col as x}
                <li class:aucune={x.categorie === 'Aucune'} class:zero={x.n === 0}>
                  <span class="r-lab">{x.categorie}</span>
                  <span class="r-piste"><span class="r-barre" style:width={`${(100 * x.n) / max}%`}></span></span>
                  <span class="r-n">{x.n}</span>
                </li>
              {/each}
            </ul>
          {/each}
        </div>
      </div>

      <figure class="code-r">
        <span class="geste">le même geste en R, avec ellmer</span>
        <pre><code>{@html surlignerR(codeR)}</code></pre>
      </figure>
    </div>
  </div>

  <span
    class="puce"
    class:vis={js && !!phase}
    class:saut
    class:brut
    class:val={valeur}
    bind:this={puce}
    style={pos ? `transform: translate(${pos.x}px, ${pos.y}px)` : ''}
  >
    {charge}
  </span>
</div>

<style>
  /* Mêmes largeurs que EnjeuxDictionnaire : la comparaison tient à ça. */
  .enj .clf-t th:nth-child(1),
  .enj .clf-t td:nth-child(1) {
    width: 9%;
  }
  .enj .clf-t th:nth-child(2),
  .enj .clf-t td:nth-child(2) {
    width: 39%;
  }
  .enj .clf-t th:nth-child(3),
  .enj .clf-t td:nth-child(3) {
    width: 12%;
  }
  .enj .clf-t th:nth-child(4),
  .enj .clf-t td:nth-child(4) {
    width: 40%;
  }
  .enj .puce.val,
  .enj .puce.brut {
    max-width: 40%;
  }

  .pile {
    display: grid;
  }
  .couche {
    grid-area: 1 / 1;
    visibility: hidden;
    opacity: 0;
    transition: opacity 0.3s;
  }
  .couche.montre {
    visibility: visible;
    opacity: 1;
  }
  /* Au premier temps, la consigne prend aussi la place de la ligne de R :
     elle est plus haute que les stations seules. */
  .bas {
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }

  /* La consigne entière, en petit : on la montre une fois, on ne la lit pas. */
  .consigne {
    display: flex;
    flex-direction: column;
    gap: 0.22em;
    border: 2px solid var(--dk-filet);
    padding: 0.3em 0.55em 0.35em;
  }
  .consigne p {
    margin: 0;
    font-size: 0.5em;
    line-height: 1.3;
  }
  .c-q {
    color: var(--dk-gris);
  }
  .c-t {
    color: var(--dk-encre);
    font-weight: 600;
  }
  .c-t code {
    font-family: var(--dk-mono);
    font-weight: 400;
    color: var(--dk-accent);
  }
  .c-cats {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-wrap: wrap;
    gap: 0.15em 0.25em;
  }
  .c-cats li {
    font-size: 0.46em;
    border: 1px solid var(--dk-filet);
    padding: 0.05em 0.35em;
    white-space: nowrap;
  }
  .c-regles {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0.05em 1em;
  }
  .c-regles li {
    font-size: 0.48em;
    line-height: 1.3;
    min-width: 0;
  }
  .r-g {
    color: var(--dk-gris);
  }
  .r-d {
    margin-left: 0.4em;
    color: var(--dk-accent);
    font-weight: 600;
  }

  /* La répartition : deux colonnes de barres, comptes réels. */
  .repart {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.2em;
    align-content: center;
  }
  .r-col {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.12em;
  }
  .r-col li {
    display: grid;
    grid-template-columns: 58% 1fr 2.2em;
    align-items: center;
    gap: 0.5em;
    font-size: 0.48em;
    line-height: 1.25;
  }
  .r-lab {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    color: var(--dk-encre);
  }
  .r-piste {
    display: block;
    height: 0.8em;
  }
  .r-barre {
    display: block;
    height: 100%;
    background: var(--dk-accent);
  }
  .r-n {
    text-align: right;
    font-weight: 600;
    font-variant-numeric: tabular-nums;
    color: var(--dk-accent);
  }
  .r-col li.aucune .r-barre {
    background: var(--dk-gris-2);
  }
  .r-col li.aucune .r-n,
  .r-col li.zero .r-n,
  .r-col li.zero .r-lab {
    color: var(--dk-gris-2);
  }

  /* L'étiquette dit ce qu'est la ligne de R : un modèle, pas une trace. */
  .code-r {
    position: relative;
  }
  .geste {
    position: absolute;
    top: 0.35em;
    right: 0.6em;
    font-size: 0.5em;
    letter-spacing: 0.06em;
    color: var(--dk-gris);
  }
</style>
