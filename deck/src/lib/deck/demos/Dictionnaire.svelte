<script>
  import donnees from './lexicoder.json';
  import { surlignerR } from '../surligner.js';

  /**
   * L'ancienne façon de faire, montrée avec exactement la même mise en scène
   * que l'animation LLM: même tableau, mêmes trois stations, même ligne de R
   * en dessous. Seul le milieu change. C'est la comparaison qui compte, et
   * elle ne tient que si tout le reste est identique.
   *
   * Tout est mesuré: dictionnaire LSD2015 de quanteda, tokens(remove_punct),
   * tokens_lookup. Les mots trouvés et les scores viennent de l'exécution
   * réelle sur les trois avis, pas d'une illustration.
   */
  const L = donnees.lignes;

  const PHASES = [
    { id: 'lire', t: 'Lire la cellule' },
    { id: 'decouper', t: 'Découper en mots' },
    { id: 'apparier', t: 'Chercher chaque mot dans le dictionnaire' },
    { id: 'compter', t: 'Compter les positifs et les négatifs' },
    { id: 'ecrire', t: 'Écrire le score dans la cellule' }
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
  let e = $state(TOTAL - 1);
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

  const aff = (s) => (s === null ? 'indéfini' : (s > 0 ? '+' : '') + s.toFixed(2));

  const charge = $derived(
    !ligne
      ? ''
      : phase?.id === 'decouper'
        ? `${ligne.jetons.length} mots`
        : phase?.id === 'apparier'
          ? (Object.keys(ligne.trouves).length
              ? Object.entries(ligne.trouves)
                  .map(([m, t]) => `${m} ← ${t.via}`)
                  .join(' · ')
              : 'aucun mot trouvé')
          : phase?.id === 'compter'
            ? `${ligne.pos} pos · ${ligne.neg} nég`
            : phase?.id === 'ecrire'
              ? aff(ligne.score)
              : ligne.texte
  );
  const valeur = $derived(phase?.id === 'ecrire');

  const CODE = {
    initial: 'donnees <- readRDS("donnees/ligne_rouge_cleaned.rds")',
    creation: 'donnees$score <- NA_real_',
    lire: 'texte <- donnees$review_text[i]',
    decouper: 'mots <- tokens(texte, remove_punct = TRUE)',
    apparier: 'trouve <- tokens_lookup(mots, data_dictionary_LSD2015)',
    compter: 'n <- table(trouve)',
    ecrire: 'donnees$score[i] <- (n["positive"] - n["negative"]) / sum(n)',
    terminal: 'for (i in seq_len(nrow(donnees))) { ... }'
  };
  const codeR = $derived(
    initial ? CODE.initial : terminal ? CODE.terminal : (CODE[phase?.id] ?? '')
  );

  const quai = () => {
    if (!phase) return null;
    if (phase.id === 'lire') return cellulesTexte[iLigne];
    if (phase.id === 'decouper') return quaiD;
    if (phase.id === 'apparier') return quaiA;
    if (phase.id === 'compter') return quaiC;
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

    const deck = hote.closest('.deck');
    const diapo = hote.closest('.diapo');
    if (!deck || !diapo) return;
    const monIndex = [...deck.querySelectorAll('.diapo')].indexOf(diapo);

    function avancer() {
      e = e >= TOTAL - 1 ? 0 : e + 1;
    }
    diapo.addEventListener('click', avancer);

    const AVANT = ['ArrowRight', 'ArrowDown', 'PageDown', ' '];
    const ARRIERE = ['ArrowLeft', 'ArrowUp', 'PageUp'];
    function auClavier(ev) {
      if (Math.round(deck.scrollTop / deck.clientHeight) !== monIndex) return;
      if (AVANT.includes(ev.key) && e < TOTAL - 1) {
        ev.preventDefault();
        ev.stopPropagation();
        e += 1;
      } else if (ARRIERE.includes(ev.key) && e > 0) {
        ev.preventDefault();
        ev.stopPropagation();
        e -= 1;
      }
    }
    window.addEventListener('keydown', auClavier, true);

    const ro = new ResizeObserver(() => placer(true));
    ro.observe(hote);

    let ici = false;
    function verifier() {
      const y = Math.round(deck.scrollTop / deck.clientHeight) === monIndex;
      if (y && !ici) {
        ici = true;
        e = 0;
      } else if (!y && ici) {
        ici = false;
        e = 0;
      }
    }
    deck.addEventListener('scroll', verifier, { passive: true });
    verifier();
    const t0 = setTimeout(verifier, 350);

    return () => {
      deck.removeEventListener('scroll', verifier);
      diapo.removeEventListener('click', avancer);
      window.removeEventListener('keydown', auClavier, true);
      ro.disconnect();
      clearTimeout(t0);
    };
  });
</script>

<div class="clf dic" bind:this={hote}>
  <div class="clf-tete">
    <span class="pas-t">
      {#if initial}Un classeur de textes
      {:else if creation}Créer la colonne qui va recevoir les scores
      {:else if terminal}La colonne est remplie, ligne par ligne
      {:else}{phase?.t}{/if}
    </span>
    <span class="src">
      LSD2015 · {donnees.entrees.positive} positifs, {donnees.entrees.negative} négatifs
      {#if js}<span class="pas-n">{e + 1} / {TOTAL}</span>{/if}
    </span>
  </div>

  <table class="clf-t">
    <thead>
      <tr>
        <th>ligne</th>
        <th>review_text</th>
        <th>review_rating</th>
        <th class="neuve"
          ><span class="entrant" class:vue={colVue}>score</span
          ><span class="soulign" class:vue={colVue}></span></th
        >
      </tr>
    </thead>
    <tbody>
      {#each L as l, i}
        <tr class:active={i === iLigne}>
          <td class="mono">{l.id}</td>
          <td class="txt"><span bind:this={cellulesTexte[i]} class="cellule">{l.texte}</span></td>
          <td class="num">{l.note}</td>
          <td class="cible">
            <span bind:this={cellulesCible[i]} class="cellule cible-in entrant" class:vue={colVue}>
              {#if remplie(i)}<span class="val" class:nul={l.score === null}>{aff(l.score)}</span
                >{/if}
            </span>
          </td>
        </tr>
      {/each}
      <tr class="reste">
        <td class="mono">…</td>
        <td class="txt">{donnees.total ?? 548} autres lignes</td>
        <td class="num">…</td>
        <td class="cible"></td>
      </tr>
    </tbody>
  </table>

  <div class="stations">
    <div class="st" class:on={phase?.id === 'decouper'}>
      <span class="st-n">DÉCOUPER</span>
      <span class="st-d">le texte devient une liste de mots</span>
      <span class="quai" bind:this={quaiD}></span>
    </div>
    <span class="fl">▸</span>
    <div class="st large" class:on={phase?.id === 'apparier'}>
      <span class="st-n">DICTIONNAIRE</span>
      <span class="st-d jetons">
        {#if ligne && (phase?.id === 'apparier' || phase?.id === 'compter')}
          {#each ligne.jetons as m}
            <span
              class="jt"
              class:pos={ligne.trouves[m]?.p === 'pos'}
              class:neg={ligne.trouves[m]?.p === 'neg'}>{m}</span
            >
          {/each}
        {:else}
          chaque mot, comparé à une liste : {donnees.part_jokers} % des entrées sont des jokers
        {/if}
      </span>
      {#if ligne && (phase?.id === 'apparier' || phase?.id === 'compter')}
        <span class="via">
          {#each Object.entries(ligne.trouves) as [m, t]}
            <span class="v1">{m} ← <b>{t.via}</b></span>
          {:else}
            <span class="v1">aucune entrée ne correspond : le dictionnaire est anglais</span>
          {/each}
        </span>
      {/if}
      <span class="quai" bind:this={quaiA}></span>
    </div>
    <span class="fl">▸</span>
    <div class="st" class:on={phase?.id === 'compter'}>
      <span class="st-n">SCORE</span>
      <span class="st-d">(pos − nég) ÷ total</span>
      <span class="quai" bind:this={quaiC}></span>
    </div>
  </div>

  <figure class="code-r"><pre><code>{@html surlignerR(codeR)}</code></pre></figure>

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
  /* La mise en page est celle de Classifieur.svelte, volontairement: la
     comparaison ne tient que si seul le milieu change. */
  .st.large {
    flex: 1.9;
  }
  .jetons {
    display: flex;
    flex-wrap: wrap;
    gap: 0.15em 0.25em;
  }
  .jt {
    color: var(--dk-gris-2);
  }
  .jt.neg {
    background: var(--dk-accent);
    color: var(--dk-fond);
    font-weight: 600;
    padding: 0 0.2em;
  }
  .jt.pos {
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
  .via b {
    color: var(--dk-accent);
    font-weight: 600;
  }
  .cible .val.nul {
    color: var(--dk-gris-2);
    font-weight: 400;
  }
</style>
