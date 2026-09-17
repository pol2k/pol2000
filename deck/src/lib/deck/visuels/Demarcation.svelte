<script>
  /**
   * Comment sait-on qu’un énoncé est scientifique ? Pas par son sujet : par
   * le fait qu’on puisse le vérifier. Quatre portes en enfilade, une
   * hypothèse qui doit toutes les franchir. Les quatre portes et leurs
   * quatre gloses sont là dès l’arrivée : les clics ne servent qu’à faire
   * avancer les cartes, UNE PORTE PAR CLIC, pour qu’on puisse s’arrêter à
   * chaque porte et en parler. Neuf temps.
   *
   *   0  Le couloir, les quatre portes nommées, les quatre gloses, la boîte
   *      « testable » au bout. Aucune carte.
   *   1  La carte « Tout arrive pour une raison. » entre et s’arrête devant
   *      la porte 1.
   *   2  Elle est dans la porte 1, PLAUSIBLE : coche, la glose 1 s’allume.
   *   3  Porte 2, VÉRIFIABLE : la porte se ferme, croix rouge, la carte
   *      rebondit, tombe et grisaille. La glose 2 s’allume en rouge. Elle
   *      n’est pas fausse : elle est invérifiable, et c’est ça qui la
   *      disqualifie. Aucune observation ne pourrait la contredire, ce qui
   *      prépare la diapositive suivante : Popper et les théories
   *      compatibles avec tout. Elle ne verra jamais les portes 3 et 4.
   *   4  La seconde carte, « Plus on est âgé, plus on vote. », entre devant
   *      la porte 1. Les verdicts de la première carte s’effacent ; la carte
   *      tombée reste par terre. C’est l’hypothèse de la séance 1 : rappel
   *      voulu.
   *   5  Porte 1, coche.
   *   6  Porte 2, coche.
   *   7  Porte 3, coche.
   *   8  Porte 4, coche.
   *   9  La carte se range dans la boîte « testable », qui passe au rouge.
   *
   * Tout l’état de repos est une fonction de `e` seul : la position de
   * chaque carte est un `transform` calculé depuis `e` et animé par une
   * transition. Reculer ramène donc la carte porte par porte, et des clics
   * rapides ne laissent jamais d’état intermédiaire. Seul le rebond du temps
   * 3 est une animation, déclenchée par le clic, et son image finale EST la
   * position de repos (pas d’image-clé finale : elle retombe sur le style).
   *
   * Les quatre règles et leurs glosses sont celles de Pétry et Gélineau
   * (2009), « Comment construire une recherche empirique », chapitre 1,
   * p. 5-6, lecture déjà au programme du cours. Leurs mots, cités tels
   * quels. Schéma : aucune donnée, coordonnées fixes.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 9, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Espace fine insécable : la typographie française avant les guillemets.
  const FINE = ' ';
  const cite = (t) => `«${FINE}${t}${FINE}»`;

  const REGLES = [
    { nom: 'PLAUSIBLE', gloss: cite('elle doit avoir un rapport étroit avec le phénomène observé qu’elle prétend expliquer') },
    { nom: 'VÉRIFIABLE', gloss: cite('Il ne sert à rien de poser une hypothèse […] puisque nous ne pourrons jamais vérifier une telle hypothèse.') },
    { nom: 'PRÉCISE', gloss: cite('sa formulation doit éviter toute ambiguïté') },
    { nom: 'GÉNÉRALE', gloss: cite('son pouvoir d’explication va au-delà du cas particulier') }
  ];

  // Géométrie du couloir. Les portes sont deux montants verticaux qui
  // laissent passer une carte dans la bande centrale (y de 114 à 186).
  // Les deux cartes ont la même taille (180 × 54) : elles tiennent dans la
  // bande, et « devant la porte 1 » (centre x = 95) finit à x = 185, avant
  // le montant (190).
  const PORTES = [200, 340, 480, 620];
  const LANE = 150;
  const DEVANT = 95;
  const HORS = -130;

  // Verdict affiché sur la porte i au temps t : '' | 'oui' | 'non'.
  // Temps 1 à 3, c’est la première carte ; à partir de 4, la seconde.
  function verdict(i, t) {
    if (t <= 3) {
      if (i === 0 && t >= 2) return 'oui';
      if (i === 1 && t === 3) return 'non';
      return '';
    }
    return t >= 5 + i ? 'oui' : '';
  }
  // La porte où se tient la carte en ce moment (-1 : aucune).
  const porteIci = (t) => (t === 2 ? 0 : t === 3 ? 1 : t >= 5 && t <= 8 ? t - 5 : -1);
  // Une porte passe à l’encre dès qu’une carte l’a atteinte, et le reste.
  const ATTEINTE = [2, 3, 7, 8];

  // Position de repos de chaque carte, fonction de `e` seul. La carte tombée
  // (92, 236, -13°) reste à gauche du montant de la porte 1 et sous la bande.
  const pos1 = (t) =>
    t <= 0 ? [HORS, LANE, 0] : t === 1 ? [DEVANT, LANE, 0] : t === 2 ? [PORTES[0], LANE, 0] : [92, 236, -13];
  const pos2 = (t) =>
    t < 4 ? [HORS, LANE, 0] : t === 4 ? [DEVANT, LANE, 0] : t <= 8 ? [PORTES[t - 5], LANE, 0] : [840, LANE, 0];
  const tr = ([x, y, r]) => `transform: translate(${x}px, ${y}px) rotate(${r}deg)`;
</script>

<div class="visuel dm-fig" bind:this={hote}>
  <svg
    class="dm-svg"
    viewBox="0 0 1000 300"
    role="img"
    aria-label="Un couloir de quatre portes en enfilade, nommées plausible, vérifiable, précise et générale, puis une boîte marquée testable. Une carte portant l’énoncé tout arrive pour une raison avance d’une porte à chaque clic : elle franchit la porte plausible, puis la porte vérifiable se ferme devant elle, elle rebondit et tombe. Une seconde carte, plus on est âgé plus on vote, franchit les quatre portes une à une, chacune marquée d’une coche, et se range dans la boîte testable."
  >
    <!-- Le couloir. -->
    <line x1="20" y1={LANE} x2="690" y2={LANE} class="dm-couloir" />

    <!-- La boîte d’arrivée. -->
    <text x="840" y="92" class="dm-but-t" class:dm-allume={e >= 9}>testable</text>
    <rect x="700" y="104" width="280" height="92" class="dm-but" class:dm-allume={e >= 9} />

    <!-- Les quatre portes, nommées dès l’arrivée. -->
    {#each REGLES as r, i}
      {@const v = verdict(i, e)}
      <g class="dm-porte" class:dm-atteinte={e >= ATTEINTE[i]} class:dm-oui={v === 'oui'} class:dm-non={v === 'non'}>
        <rect x={PORTES[i] - 10} y="36" width="20" height="78" class="dm-montant" />
        <rect x={PORTES[i] - 10} y="186" width="20" height="78" class="dm-montant" />
        <!-- Le battant : il ne se ferme que sur un refus. -->
        <line x1={PORTES[i]} y1="114" x2={PORTES[i]} y2="186" class="dm-battant" />
        <text x={PORTES[i]} y="26" class="dm-porte-t">{r.nom}</text>
        <!-- Sous la porte : son numéro, puis son verdict. Tracés, pas des
             glyphes : la police du deck n’a ni coche ni croix. -->
        {#if v === 'oui'}
          <path d="M {PORTES[i] - 12} 281 l 8 9 l 16 -18" class="dm-coche" />
        {:else if v === 'non'}
          <path d="M {PORTES[i] - 10} 272 l 20 20 m 0 -20 l -20 20" class="dm-croix" />
        {:else}
          <text x={PORTES[i]} y="290" class="dm-porte-n">{i + 1}</text>
        {/if}
      </g>
    {/each}

    <!-- La carte invérifiable : devant la porte 1, dans la porte 1, puis
         refusée à la porte 2. Elle reste par terre ensuite. -->
    <g class="dm-jeton dm-inverif" class:dm-la={e >= 1} class:dm-tombe={e >= 3} style={tr(pos1(e))}>
      <rect x="-90" y="-27" width="180" height="54" class="dm-carte" />
      <text x="0" y="-4" class="dm-carte-t">Tout arrive</text>
      <text x="0" y="17" class="dm-carte-t">pour une raison.</text>
    </g>
    <!-- Les étincelles passent APRÈS la carte : en SVG, l’ordre du document
         est l’ordre de peinture, et la carte est opaque. -->
    <g class="dm-choc" class:dm-tombe={e >= 3}>
      <path d="M 322 128 L 306 118 M 322 150 L 302 150 M 322 172 L 306 182" />
    </g>

    <!-- L’hypothèse de la séance 1 : une porte par clic, puis la boîte. -->
    <g class="dm-jeton dm-bonne" class:dm-la={e >= 4} style={tr(pos2(e))}>
      <rect x="-90" y="-27" width="180" height="54" class="dm-carte dm-carte-ok" />
      <text x="0" y="-4" class="dm-carte-t dm-carte-t-ok">Plus on est âgé,</text>
      <text x="0" y="17" class="dm-carte-t dm-carte-t-ok">plus on vote.</text>
    </g>
  </svg>

  <div class="dm-regles">
    {#each REGLES as r, i}
      {@const v = verdict(i, e)}
      <div class="dm-regle" class:dm-oui={v === 'oui'} class:dm-non={v === 'non'} class:dm-ici={porteIci(e) === i}>
        <span class="dm-regle-n">{i + 1}</span>
        <span class="dm-regle-t">{r.nom}</span>
        <span class="dm-regle-g">{r.gloss}</span>
      </div>
    {/each}
  </div>

  <p class="dm-source">Pétry et Gélineau (2009), Comment construire une recherche empirique, p. 5-6</p>
</div>

<style>
  .dm-fig { display: flex; flex-direction: column; gap: 0.5em; }
  /* Le couloir est large et plat (viewBox 1000 × 300) : sa hauteur vient du
     rapport d'aspect, pas de max-height. On le borne quand même, parce que la
     rangée des quatre gloses en dessous doit tenir dans la diapositive. */
  .dm-svg { width: 100%; max-height: 32vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .dm-couloir { stroke: var(--dk-filet); stroke-width: 4; stroke-dasharray: 12 10; }

  /* La boîte s'allume quand la carte y arrive (la glissade dure 0,6 s). */
  .dm-but { fill: none; stroke: var(--dk-filet); stroke-width: 4; stroke-dasharray: 10 8; transition: stroke 0.3s; }
  .dm-but.dm-allume { stroke: var(--dk-accent); stroke-dasharray: none; transition-delay: 0.4s; }
  .dm-but-t { font-size: 22px; font-weight: 600; letter-spacing: 0.1em; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.3s; }
  .dm-but-t.dm-allume { fill: var(--dk-accent); transition-delay: 0.4s; }

  /* Une porte : pâle tant qu'aucune carte ne l'a atteinte, à l'encre ensuite,
     rouge sur un refus. Le passage la fait clignoter ; le repos, c'est la coche. */
  .dm-montant { fill: var(--dk-filet); transition: fill 0.35s; }
  .dm-porte.dm-atteinte .dm-montant { fill: var(--dk-encre); }
  .dm-porte.dm-oui .dm-montant { animation: dm-flash 0.7s ease-out; }
  .dm-porte.dm-non .dm-montant { fill: var(--dk-accent); }
  .dm-battant { stroke: var(--dk-accent); stroke-width: 6; opacity: 0; transition: opacity 0.2s; }
  .dm-porte.dm-non .dm-battant { opacity: 1; }
  .dm-porte-t { font-size: 20px; font-weight: 600; letter-spacing: 0.04em; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.3s; }
  .dm-porte.dm-non .dm-porte-t { fill: var(--dk-accent); }
  .dm-porte-n { font-size: 20px; text-anchor: middle; fill: var(--dk-gris-2); }
  .dm-coche { fill: none; stroke: var(--dk-encre); stroke-width: 6; animation: dm-marque 0.35s ease-out 0.3s both; }
  .dm-croix { fill: none; stroke: var(--dk-accent); stroke-width: 6; animation: dm-marque 0.35s ease-out 0.3s both; }

  /* Les cartes. Leur place vient du style en ligne, fonction de `e` ; la
     transition fait le trajet, à l'aller comme au retour. */
  .dm-jeton { opacity: 0; transition: transform 0.6s cubic-bezier(0.5, 0, 0.3, 1), opacity 0.3s; }
  .dm-jeton.dm-la { opacity: 1; }
  .dm-carte { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .dm-carte-t { font-size: 17px; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .dm-carte-ok { stroke: var(--dk-accent); stroke-width: 4; }
  .dm-carte-t-ok { font-weight: 600; fill: var(--dk-accent); }

  /* Le refus : la carte part de la porte 1, cogne le battant de la porte 2,
     retombe. Pas d'image-clé finale : l'animation atterrit sur le style en
     ligne, qui est la position de repos. */
  .dm-inverif.dm-tombe { animation: dm-rebond 1.1s; }
  .dm-inverif.dm-tombe .dm-carte { stroke: var(--dk-gris-2); transition-delay: 0.5s; }
  .dm-inverif.dm-tombe .dm-carte-t { fill: var(--dk-gris-2); transition-delay: 0.5s; }

  .dm-choc path { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linecap: round; opacity: 0; transform-box: fill-box; transform-origin: 100% 50%; }
  .dm-choc.dm-tombe path { animation: dm-etincelle 0.5s ease-out 0.36s; }

  /* Les quatre gloses : lisibles dès l'arrivée. Encre quand la porte est
     franchie, rouge quand elle refuse, fond grisé pour la porte en cours. */
  .dm-regles { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.9em; }
  .dm-regle { display: flex; flex-direction: column; gap: 0.3em; padding: 0.6em 0.7em 0.7em; min-height: 8.6em; border: 3px solid var(--dk-filet); transition: border-color 0.3s, background-color 0.3s; }
  .dm-regle.dm-oui { border-color: var(--dk-encre); }
  .dm-regle.dm-non { border-color: var(--dk-accent); }
  .dm-regle.dm-ici { background-color: var(--dk-fond-2); }
  .dm-regle-n { font-size: 1.6em; font-weight: 600; line-height: 1; color: var(--dk-gris-2); transition: color 0.3s; }
  .dm-oui .dm-regle-n { color: var(--dk-encre); }
  .dm-non .dm-regle-n { color: var(--dk-accent); }
  .dm-regle-t { font-size: 0.95em; font-weight: 600; letter-spacing: 0.08em; min-height: 1.3em; transition: color 0.3s; }
  .dm-non .dm-regle-t { color: var(--dk-accent); }
  .dm-regle-g { font-size: 0.68em; line-height: 1.3; color: var(--dk-gris); }

  .dm-source { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes dm-flash { 0% { fill: var(--dk-encre); } 35% { fill: var(--dk-accent); } 100% { fill: var(--dk-encre); } }
  @keyframes dm-marque { from { opacity: 0; } to { opacity: 1; } }
  @keyframes dm-etincelle { 0% { opacity: 0; transform: scale(0.4); } 30% { opacity: 1; transform: scale(1.15); } 100% { opacity: 0; transform: scale(1.3); } }

  @keyframes dm-rebond {
    0% { transform: translate(200px, 150px) rotate(0deg); }
    34% { transform: translate(247px, 150px) rotate(0deg); animation-timing-function: cubic-bezier(0.4, 0, 0.5, 1); }
    48% { transform: translate(216px, 153px) rotate(-5deg); }
    70% { transform: translate(150px, 182px) rotate(-9deg); animation-timing-function: cubic-bezier(0.5, 0, 0.6, 1); }
  }

  @media (prefers-reduced-motion: reduce) {
    .dm-porte.dm-oui .dm-montant,
    .dm-coche, .dm-croix,
    .dm-inverif.dm-tombe,
    .dm-choc.dm-tombe path { animation: none; }
    .dm-but, .dm-but-t, .dm-montant, .dm-battant, .dm-porte-t,
    .dm-jeton, .dm-carte, .dm-carte-t,
    .dm-regle, .dm-regle-n, .dm-regle-t { transition: none; }
  }
</style>
