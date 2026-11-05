<script>
  import donnees from './classifieur.json';
  import { surlignerR } from '../surligner.js';

  /**
   * Le geste de la semaine, animé: une puce unique fait le tour du circuit.
   * Elle se détache de la cellule, se pose dans le quai du PROMPT, glisse
   * jusqu'à l'API, revient à RÉPONSE sous forme de JSON, s'y réduit à la
   * seule valeur — c'est l'analyse du JSON —, puis remonte se poser dans la
   * colonne score.
   *
   * Sous le circuit, la ligne de R qui fait exactement l'opération en cours.
   * Le geste et son code, côte à côte, au même instant.
   *
   * Rien ne se joue tout seul: un clic sur la diapositive avance d'un temps.
   * C'est un support de cours, la cadence appartient à la personne qui parle.
   *
   * La touche « diapositive suivante » avance aussi l'animation, pour qu'un
   * télécommande de conférencier suffise. Une fois l'animation terminée, la
   * touche reprend son rôle normal et fait passer à la diapositive suivante.
   *
   * Les lignes viennent de classifieur.json, engendré depuis le vrai
   * avis_exemple.csv. Un test échoue si les deux divergent.
   *
   * Le JSON montré a la forme qu'impose le schéma enseigné; ce n'est pas la
   * sortie mesurée d'un appel réel.
   */
  const L = donnees.lignes;

  const PHASES = [
    { id: 'lire', t: 'Lire la cellule' },
    { id: 'prompt', t: 'Coller le texte dans un prompt' },
    { id: 'appel', t: "Envoyer à l'API" },
    { id: 'json', t: 'Recevoir la réponse, en JSON' },
    { id: 'parse', t: 'Extraire la valeur du JSON' },
    { id: 'ecrire', t: 'Écrire la valeur dans la cellule' }
  ];
  // Deux temps avant la boucle: le classeur tel quel, puis la colonne créée.
  // Un temps terminal après la dernière écriture.
  const TOTAL = 2 + L.length * PHASES.length + 1;

  let hote = $state(null);
  let puce = $state(null);
  let cellulesTexte = $state([]);
  let cellulesCible = $state([]);
  let quaiPrompt = $state(null);
  let quaiApi = $state(null);
  let quaiRep = $state(null);

  let js = $state(false);
  let e = $state(TOTAL - 1); // sans JS: tableau terminé, puce masquée
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

  const aff = (s) => (s > 0 ? '+' : '') + s.toFixed(2);
  const jsonTexte = (l) => `{"score": ${l.score.toFixed(2)}}`;

  // Ce que la puce transporte à chaque temps. Le passage du JSON complet à la
  // seule valeur EST l'analyse: on la voit se produire, on ne l'annonce pas.
  const charge = $derived(
    !ligne
      ? ''
      : phase?.id === 'json'
        ? jsonTexte(ligne)
        : phase?.id === 'parse' || phase?.id === 'ecrire'
          ? aff(ligne.score)
          : ligne.texte
  );
  const brut = $derived(phase?.id === 'json');
  const valeur = $derived(phase?.id === 'parse' || phase?.id === 'ecrire');

  const CODE = {
    initial: 'donnees <- readRDS("donnees/ligne_rouge_cleaned.rds")',
    creation: 'donnees$score <- NA_real_',
    lire: 'texte <- donnees$review_text[i]',
    prompt: 'prompt <- paste(consigne, texte)',
    appel: 'reponse <- chat$chat(prompt)',
    parse: 'valeur <- jsonlite::fromJSON(reponse)$score',
    ecrire: 'donnees$score[i] <- valeur',
    terminal: 'for (i in seq_len(nrow(donnees))) { ... }'
  };
  const codeR = $derived(
    initial
      ? CODE.initial
      : creation
        ? CODE.creation
        : terminal
          ? CODE.terminal
          : phase?.id === 'json'
            ? `reponse\n#> ${jsonTexte(ligne)}`
            : (CODE[phase?.id] ?? '')
  );

  const quai = () => {
    if (!phase) return null;
    if (phase.id === 'lire') return cellulesTexte[iLigne];
    if (phase.id === 'prompt') return quaiPrompt;
    if (phase.id === 'appel') return quaiApi;
    if (phase.id === 'json' || phase.id === 'parse') return quaiRep;
    return cellulesCible[iLigne];
  };

  // Mesuré à chaque temps, jamais mis en cache: ajuster.mjs peut écrire un
  // facteur d'échelle sur la diapo et le zoom du deck change à l'exécution.
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

    // Un clic avance d'un temps. Aucune minuterie: la personne qui enseigne
    // parle pendant chaque étape, elle ne court pas après une animation.
    // Arrivé au bout, un clic de plus reprend au début.
    function avancer() {
      e = e >= TOTAL - 1 ? 0 : e + 1;
    }

    diapo.addEventListener('click', avancer);

    // Une télécommande de conférencier n'envoie que « suivant » / « précédent ».
    // Tant que l'animation n'est pas terminée, on capte ces touches avant le
    // deck et on avance d'un temps; une fois au bout, on les laisse passer et
    // la présentation continue normalement. En capture sur window: le deck
    // écoute en phase de bouillonnement, donc stopPropagation le neutralise.
    const AVANT = ['ArrowRight', 'ArrowDown', 'PageDown', ' '];
    const ARRIERE = ['ArrowLeft', 'ArrowUp', 'PageUp'];

    function auClavier(ev) {
      const surCetteDiapo = Math.round(deck.scrollTop / deck.clientHeight) === monIndex;
      if (!surCetteDiapo) return;

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

    // On repart du classeur nu à chaque arrivée sur la diapositive, et on
    // remet à zéro en partant: revenir dessus ne doit pas reprendre au milieu.
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

<div class="clf" bind:this={hote}>
  <div class="clf-tete">
    <span class="pas-t">
      {#if initial}Un classeur de textes
      {:else if creation}Créer la colonne qui va recevoir les données
      {:else if terminal}La colonne est remplie, ligne par ligne
      {:else}{phase?.t}{/if}
    </span>
    <span class="src">
      {donnees.fichier} · {donnees.total} lignes
      {#if js}<span class="pas-n">{e + 1} / {TOTAL}</span>{/if}
    </span>
  </div>

  <table class="clf-t">
    <thead>
      <tr>
        {#each donnees.colonnes as c}<th>{c}</th>{/each}
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
            <span
              bind:this={cellulesCible[i]}
              class="cellule cible-in entrant"
              class:vue={colVue}
            >
              {#if remplie(i)}<span class="val">{aff(l.score)}</span>{/if}
            </span>
          </td>
        </tr>
      {/each}
      <tr class="reste">
        <td class="mono">…</td>
        <td class="txt">{donnees.total - L.length} autres lignes</td>
        <td class="num">…</td>
        <td class="cible"></td>
      </tr>
    </tbody>
  </table>

  <div class="stations">
    <div class="st" class:on={phase?.id === 'prompt'}>
      <span class="st-n">PROMPT</span>
      <span class="st-d">Score de −1.00 à +1.00. Réponds selon le schéma.</span>
      <span class="quai" bind:this={quaiPrompt}></span>
    </div>
    <span class="fl">▸</span>
    <div class="st" class:on={phase?.id === 'appel'}>
      <span class="st-n">API</span>
      <span class="st-d">{donnees.modele} · temperature 0</span>
      <span class="quai" bind:this={quaiApi}></span>
    </div>
    <span class="fl">▸</span>
    <div class="st" class:on={phase?.id === 'json' || phase?.id === 'parse'}>
      <span class="st-n">RÉPONSE</span>
      <span class="st-d">
        {#if ligne && (phase?.id === 'json' || phase?.id === 'parse')}
          &#123; "score": <span class="extrait" class:tire={phase?.id === 'parse'}
            >{ligne.score.toFixed(2)}</span
          > &#125;
        {:else}
          &#123; "score": … &#125;
        {/if}
      </span>
      <span class="quai" bind:this={quaiRep}></span>
    </div>
  </div>

  <figure class="code-r">
    <pre><code>{@html surlignerR(codeR)}</code></pre>
  </figure>

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
