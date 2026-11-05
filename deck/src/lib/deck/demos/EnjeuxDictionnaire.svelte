<script>
  import d from './enjeux-dictionnaire.json';
  import { surlignerR } from '../surligner.js';
  import { brancherTemps } from '../temps.js';

  /**
   * L'ancienne façon, sur la question ouverte de la CES 2025 : un dictionnaire
   * de mots-clés, écrit à la main, en anglais et en français. Même mise en
   * scène que EnjeuxClassifieur (même tableau, mêmes trois stations, même
   * ligne de R dessous, mêmes trois réponses) : seul le milieu change.
   *
   * Les trois réponses sont trois échecs mesurés, un de chaque type : un mot
   * attrapé à tort, deux catégories à la fois, aucun mot connu. Les mots, les
   * entrées trouvées, la décision et le bilan viennent de l'exécution de
   * outils/seance9_enjeux.R, pas d'une illustration.
   *
   * Au premier temps, un extrait du dictionnaire. Au dernier, le bilan sur les
   * 300 réponses. Les trois occupent la même case, pour que la hauteur de la
   * diapositive ne bouge pas d'un temps à l'autre.
   */
  const L = d.lignes;
  const B = d.bilan;

  const PHASES = [
    { id: 'lire', t: 'Lire la cellule' },
    { id: 'decouper', t: 'Découper en mots, sans majuscules ni accents' },
    { id: 'apparier', t: 'Chercher chaque mot dans le dictionnaire' },
    { id: 'decider', t: 'Compter les catégories trouvées' },
    { id: 'ecrire', t: 'Écrire la catégorie dans la cellule' }
  ];
  const TOTAL = 2 + L.length * PHASES.length + 1;

  let hote = $state(null);
  let puce = $state(null);
  let cellulesTexte = $state([]);
  let cellulesCible = $state([]);
  let quaiD = $state(null);
  let quaiA = $state(null);
  let quaiC = $state(null);

  let js = $state(false);
  let e = $state(TOTAL - 1); // sans JS : tableau rempli, bilan affiché
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
  const montreMots = $derived(phase?.id === 'apparier' || phase?.id === 'decider');

  const pluriel = (n, mot) => `${n} ${mot}${n > 1 ? 's' : ''}`;
  const aff = (l) =>
    l.valeur ?? (l.cats.length ? `NA · ${pluriel(l.cats.length, 'catégorie')}` : 'NA · aucun mot');

  const charge = $derived(
    !ligne
      ? ''
      : phase?.id === 'decouper'
        ? pluriel(ligne.jetons.length, 'mot')
        : phase?.id === 'apparier'
          ? ligne.trouves.length
            ? ligne.trouves.map((t) => `${t.mot} ← ${t.motif}`).join(' · ')
            : 'aucun mot trouvé'
          : phase?.id === 'decider'
            ? pluriel(ligne.cats.length, 'catégorie')
            : phase?.id === 'ecrire'
              ? aff(ligne)
              : ligne.texte
  );
  const valeur = $derived(phase?.id === 'ecrire');

  // Les lignes de outils/seance9_enjeux.R, telles quelles.
  const CODE = {
    creation: 'donnees$enjeu <- NA_character_',
    lire: 'texte <- donnees$cps25_imp_iss[i]',
    decouper:
      'mots <- stri_trans_general(tolower(texte), "Latin-ASCII")\nmots <- strsplit(mots, "[^a-z0-9]+")[[1]]',
    apparier: 'trouve <- chercher(mots, dictionnaire)',
    decider: 'cats <- unique(trouve$categorie)',
    ecrire: 'donnees$enjeu[i] <- if (length(cats) == 1) cats else NA',
    terminal: 'for (i in seq_len(nrow(donnees))) { ... }'
  };
  const codeR = $derived(
    terminal ? CODE.terminal : creation ? CODE.creation : (CODE[phase?.id] ?? '')
  );

  const quai = () => {
    if (!phase) return null;
    if (phase.id === 'lire') return cellulesTexte[iLigne];
    if (phase.id === 'decouper') return quaiD;
    if (phase.id === 'apparier') return quaiA;
    if (phase.id === 'decider') return quaiC;
    return cellulesCible[iLigne];
  };

  // Mesuré à chaque temps : le zoom du deck peut changer à l'exécution.
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

  const largeur = (n) => `${(100 * n) / d.echantillon}%`;
</script>

<div class="clf enj" bind:this={hote}>
  <div class="clf-tete">
    <span class="pas-t">
      {#if initial}Un dictionnaire, écrit à la main
      {:else if creation}Créer la colonne qui va recevoir les catégories
      {:else if terminal}La colonne est remplie, ligne par ligne
      {:else}{phase?.t}{/if}
    </span>
    <span class="src">
      {d.mots_cles} mots-clés · {d.echantillon} réponses tirées au hasard
      {#if js}<span class="pas-n">{e + 1} / {TOTAL}</span>{/if}
    </span>
  </div>

  <table class="clf-t">
    <thead>
      <tr>
        <th>ligne</th>
        <th>cps25_imp_iss</th>
        <th>langue</th>
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
              {#if remplie(i)}<span class="val" class:nul={l.valeur === null}>{aff(l)}</span>{/if}
            </span>
          </td>
        </tr>
      {/each}
      <tr class="reste">
        <td class="mono">…</td>
        <td class="txt">{d.echantillon - L.length} autres lignes</td>
        <td class="num">…</td>
        <td class="cible"></td>
      </tr>
    </tbody>
  </table>

  <div class="pile">
    <!-- Premier temps : un extrait du dictionnaire, cinq entrées par catégorie. -->
    <div class="couche extrait-dico" class:montre={initial}>
      {#each d.par_categorie as c}
        <div class="ent">
          <span class="ent-c">{c.categorie}</span>
          <span class="ent-m">{c.extrait.join(' · ')} <span class="ent-n">+{c.n - c.extrait.length}</span></span>
        </div>
      {/each}
    </div>

    <div class="couche bas" class:montre={!initial}>
      <div class="pile">
        <div class="couche stations" class:montre={!initial && !terminal}>
          <div class="st" class:on={phase?.id === 'decouper'}>
            <span class="st-n">DÉCOUPER</span>
            <span class="st-d">minuscules, sans accents, une liste de mots</span>
            <span class="quai" bind:this={quaiD}></span>
          </div>
          <span class="fl">▸</span>
          <div class="st large" class:on={phase?.id === 'apparier'}>
            <span class="st-n">DICTIONNAIRE</span>
            <span class="st-d jetons">
              {#if ligne && montreMots}
                {#each ligne.jetons as m, k}
                  <span class="jt" class:pris={!!ligne.touche[k]}>{m}</span>
                {/each}
              {:else}
                chaque mot comparé à {d.mots_cles} mots-clés, en anglais et en français
              {/if}
            </span>
            {#if ligne && montreMots}
              <span class="via">
                {#each ligne.trouves as t}
                  <span class="v1">{t.mot} ← <b>{t.motif}</b></span>
                {:else}
                  <span class="v1">aucune entrée ne correspond</span>
                {/each}
              </span>
              {#if ligne.cats.length}
                <span class="via cats-l">→ {ligne.cats.join(' + ')}</span>
              {/if}
            {/if}
            <span class="quai" bind:this={quaiA}></span>
          </div>
          <span class="fl">▸</span>
          <div class="st" class:on={phase?.id === 'decider'}>
            <span class="st-n">DÉCIDER</span>
            <span class="st-d">
              {#if ligne && phase?.id === 'decider'}
                {pluriel(ligne.cats.length, 'catégorie')} → {ligne.cats.length === 1 ? 'on l’écrit' : 'NA'}
              {:else}
                1 catégorie : on l’écrit. 0 ou plusieurs : NA
              {/if}
            </span>
            <span class="quai" bind:this={quaiC}></span>
          </div>
        </div>

        <!-- Dernier temps : le bilan, sur les 300 réponses. -->
        <div class="couche bilan" class:montre={terminal}>
          <span class="b-t">Sur {d.echantillon} réponses</span>
          <div class="barre">
            <span class="seg s-ok" style:width={largeur(B.classees)}>{B.p_classees} %</span>
            <span class="seg s-amb" style:width={largeur(B.ambigues)}>{B.p_ambigues} %</span>
            <span class="seg s-rien" style:width={largeur(B.aucun)}>{B.p_aucun} %</span>
          </div>
          <div class="leg">
            <span><i class="c s-ok"></i>{B.classees} classées dans une seule catégorie</span>
            <span><i class="c s-amb"></i>{B.ambigues} ambiguës : plusieurs catégories (NA)</span>
            <span><i class="c s-rien"></i>{B.aucun} sans aucun mot connu (NA)</span>
          </div>
        </div>
      </div>

      <figure class="code-r"><pre><code>{@html surlignerR(codeR)}</code></pre></figure>
    </div>
  </div>

  <span
    class="puce"
    class:vis={js && !!phase}
    class:saut
    class:val={valeur}
    bind:this={puce}
    style={pos ? `transform: translate(${pos.x}px, ${pos.y}px)` : ''}
  >
    {charge}
  </span>
</div>

<style>
  /* La mise en page commune vit dans deck.css (.clf, .stations, .puce…).
     Ici, seulement ce que les catégories, plus longues qu'un score, exigent. */
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
  .enj .puce.val {
    max-width: 40%;
  }
  .cible .val.nul {
    color: var(--dk-gris-2);
    font-weight: 400;
  }

  /* Trois couches dans la même case de grille : la plus haute fixe la
     hauteur, les autres sont seulement masquées. Rien ne saute au clic. */
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
  /* Au premier temps, l'extrait du dictionnaire prend aussi la place de la
     ligne de R. */
  .bas {
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }

  .st.large {
    flex: 1.9;
  }
  .jetons {
    display: flex;
    flex-wrap: wrap;
    gap: 0.15em 0.3em;
  }
  .jt {
    color: var(--dk-gris-2);
  }
  .jt.pris {
    border: 1px solid var(--dk-accent);
    color: var(--dk-accent);
    font-weight: 600;
    padding: 0 0.2em;
  }
  .via {
    display: flex;
    flex-wrap: wrap;
    gap: 0.1em 0.7em;
    font-size: 0.52em;
    color: var(--dk-gris);
    margin-top: 0.1em;
  }
  .cats-l {
    color: var(--dk-encre);
  }
  .via b {
    color: var(--dk-accent);
    font-weight: 600;
    font-family: var(--dk-mono);
  }

  .extrait-dico {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0.3em 0.6em;
    align-content: start;
  }
  .ent {
    display: flex;
    flex-direction: column;
    min-width: 0;
    border-top: 2px solid var(--dk-filet);
    padding-top: 0.15em;
  }
  .ent-c {
    font-size: 0.5em;
    font-weight: 600;
    color: var(--dk-gris);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .ent-m {
    font-family: var(--dk-mono);
    font-size: 0.5em;
    color: var(--dk-accent);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .ent-n {
    color: var(--dk-gris-2);
  }

  .bilan {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 0.3em;
  }
  .b-t {
    font-size: 0.58em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .barre {
    display: flex;
    width: 100%;
    height: 1.5em;
    border: 2px solid var(--dk-encre);
  }
  .seg {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.58em;
    font-weight: 600;
    white-space: nowrap;
    overflow: hidden;
  }
  .s-ok {
    background: var(--dk-encre);
    color: var(--dk-fond);
  }
  .s-amb {
    background: var(--dk-accent);
    color: var(--dk-fond);
  }
  .s-rien {
    background: var(--dk-fond-2);
    color: var(--dk-gris);
  }
  .leg {
    display: flex;
    flex-wrap: wrap;
    gap: 0.2em 1.4em;
    font-size: 0.55em;
    color: var(--dk-encre);
  }
  .leg span {
    display: flex;
    align-items: center;
    gap: 0.4em;
  }
  .c {
    display: inline-block;
    width: 0.9em;
    height: 0.9em;
    border: 1px solid var(--dk-encre);
  }
</style>
