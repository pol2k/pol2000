<script>
  import donnees from './generation.json';

  /**
   * Un texte en entrée, un texte en sortie, et entre les deux la mécanique
   * qui les relie. L'entrée est posée en bloc, elle ne bouge plus; la sortie
   * se construit un jeton à la fois, sous les yeux.
   *
   * La traduction est choisie exprès: on voit que la sortie dépend
   * entièrement de l'entrée, sans avoir à le dire.
   *
   * Un temps par jeton: la distribution réelle s'affiche, le candidat retenu
   * est marqué, et il apparaît au même instant dans la sortie. Deux temps par
   * jeton doublaient les clics sans rien montrer de plus.
   *
   * Toutes les probabilités sont mesurées: gpt-3.5-turbo-instruct, logprobs
   * réels, top 5, temperature 0. Un appel par jeton, le préfixe complet
   * renvoyé à chaque fois — donc de l'autorégressif, pas une approximation.
   */
  const E = donnees.etapes;
  const TOTAL = 1 + E.length; // l'entrée seule, puis un temps par jeton

  let hote = $state(null);
  let js = $state(false);
  let e = $state(0);

  const iEtape = $derived(e - 1);
  const montreChoix = $derived(e > 0);
  const pose = $derived(e > 0);
  const etape = $derived(iEtape >= 0 && iEtape < E.length ? E[iEtape] : null);
  const jetonsPoses = $derived(e);
  const texte = $derived(E.slice(0, jetonsPoses).map((x) => x.choisi).join(''));

  const lisible = (t) =>
    t === '<|endoftext|>' ? '⟨fin⟩' : t.replace(/\n/g, '⏎').replace(/^ /, '␣');

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
      clearTimeout(t0);
    };
  });
</script>

<div class="gen" bind:this={hote}>
  <div class="gen-tete">
    <span class="lab">UN TEXTE EN ENTRÉE, UN TEXTE EN SORTIE</span>
    <span class="src">
      {donnees.modele} · logprobs réels
      {#if js}<span class="pas-n">{e + 1} / {TOTAL}</span>{/if}
    </span>
  </div>

  <div class="bloc">
    <span class="bl-n">ENTRÉE</span>
    <p class="txt">{donnees.entree}</p>
  </div>

  <div class="fleche">↓</div>

  <div class="bloc sortie">
    <span class="bl-n">SORTIE</span>
    <p class="txt">
      <span class="ajout">{texte}</span>{#if js}<span class="curseur"></span>{/if}
    </p>
  </div>

  {#if etape && montreChoix}
    <ul class="cand">
      {#each etape.candidats as c}
        {@const gagnant = c.t === etape.choisi}
        <li class:gagnant class:retenu={gagnant && pose}>
          <span class="jt">{lisible(c.t)}</span>
          <span class="piste"><span class="rempli" style="width: {c.p}%"></span></span>
          <span class="pc">{c.p.toFixed(1)} %</span>
        </li>
      {/each}
    </ul>
    <p class="note">
      {#if etape.candidats[0].p >= 99.5}
        Aucun choix ici : le jeton n'est qu'un morceau du mot précédent.
      {:else}
        Le plus probable est retenu, puis tout recommence — avec lui en plus dans l'entrée.
      {/if}
    </p>
  {:else}
    <p class="note">Le modèle ne connaît que ce texte. Il doit produire le jeton suivant.</p>
  {/if}
</div>

<style>
  .gen {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.6em;
  }

  .gen-tete {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 1em;
    border-bottom: 2px solid var(--dk-encre);
    padding-bottom: 0.28em;
  }
  .lab {
    font-size: 0.62em;
    letter-spacing: 0.14em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .src {
    font-size: 0.62em;
    color: var(--dk-gris);
    white-space: nowrap;
  }
  .pas-n {
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
    margin-left: 0.6em;
  }

  .bloc {
    border: 2px solid var(--dk-filet);
    padding: 0.45em 0.7em 0.55em;
  }
  .bloc.sortie {
    border-color: var(--dk-accent);
  }
  .bl-n {
    display: block;
    font-size: 0.56em;
    letter-spacing: 0.16em;
    font-weight: 600;
    color: var(--dk-gris);
  }
  .bloc.sortie .bl-n {
    color: var(--dk-accent);
  }
  .bloc .txt {
    margin: 0.15em 0 0;
    font-size: 0.8em;
    line-height: 1.45;
    min-height: 1.5em;
  }
  .fleche {
    text-align: center;
    color: var(--dk-gris-2);
    font-size: 0.8em;
    line-height: 1;
  }
  /* Ce que le modèle a produit se distingue de ce qu'on lui a donné. */
  .ajout {
    color: var(--dk-accent);
    font-weight: 600;
  }
  .curseur {
    display: inline-block;
    width: 0.5em;
    height: 1.05em;
    background: var(--dk-accent);
    vertical-align: text-bottom;
    margin-left: 0.08em;
  }

  .cand {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.22em;
  }
  .cand li {
    display: grid;
    grid-template-columns: 9em 1fr 4.2em;
    gap: 0.7em;
    align-items: center;
    font-size: 0.68em;
  }
  .jt {
    text-align: right;
    color: var(--dk-gris);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .piste {
    height: 1.05em;
    background: var(--dk-fond-2);
    border: 1px solid var(--dk-filet);
  }
  .rempli {
    display: block;
    height: 100%;
    background: var(--dk-gris-2);
    transition: width 0.35s ease-out;
  }
  .pc {
    text-align: right;
    color: var(--dk-gris);
    font-variant-numeric: tabular-nums;
  }

  .cand li.gagnant .jt {
    color: var(--dk-encre);
    font-weight: 600;
  }
  .cand li.gagnant .rempli {
    background: var(--dk-accent);
  }
  .cand li.gagnant .pc {
    color: var(--dk-accent);
    font-weight: 600;
  }
  /* Une fois posé, le gagnant est encadré: on voit ce qui vient de partir
     dans la phrase. */
  .cand li.retenu .piste {
    border-color: var(--dk-accent);
  }
  .cand li.retenu .jt::before {
    content: '▸ ';
    color: var(--dk-accent);
  }

  .note {
    margin: 0;
    font-size: 0.64em;
    color: var(--dk-gris);
    min-height: 2.2em;
  }
</style>
