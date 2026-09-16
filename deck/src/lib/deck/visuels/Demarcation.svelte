<script>
  /**
   * Comment sait-on qu’un énoncé est scientifique ? Pas par son sujet : par
   * le fait qu’on puisse le vérifier. Quatre portes en enfilade, une
   * hypothèse qui doit toutes les franchir. Cinq temps.
   *
   *   0  Le couloir, les quatre portes encore pâles, la boîte « testable »
   *      au bout. Rien n’est nommé.
   *   1  Porte 1, PLAUSIBLE.
   *   2  Porte 2, VÉRIFIABLE. Une petite carte « Tout arrive pour une
   *      raison. » arrive de la gauche, passe la porte 1, rebondit sur la
   *      porte 2 et tombe. Elle n’est pas fausse : elle est invérifiable,
   *      et c’est ça qui la disqualifie. Aucune observation ne pourrait la
   *      contredire, ce qui prépare la diapositive suivante : Popper et
   *      les théories compatibles avec tout.
   *   3  Porte 3, PRÉCISE.
   *   4  Porte 4, GÉNÉRALE. Une seconde carte, « Plus on est âgé, plus on
   *      vote. », traverse les quatre portes et se range dans la boîte
   *      « testable ». C’est l’hypothèse de la séance 1 : rappel voulu.
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
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
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
  const PORTES = [200, 340, 480, 620];
  const LANE = 150;
</script>

<div class="visuel dm-fig" bind:this={hote}>
  <svg
    class="dm-svg"
    viewBox="0 0 1000 300"
    role="img"
    aria-label="Un couloir de quatre portes en enfilade, nommées plausible, vérifiable, précise et générale, puis une boîte marquée testable. Une carte portant l’énoncé tout arrive pour une raison franchit la première porte, rebondit sur la porte vérifiable et tombe. Une seconde carte, plus on est âgé plus on vote, traverse les quatre portes et se range dans la boîte."
  >
    <!-- Le couloir. -->
    <line x1="20" y1={LANE} x2="690" y2={LANE} class="dm-couloir" />

    <!-- La boîte d’arrivée. -->
    <text x="840" y="92" class="dm-but-t" class:dm-allume={e >= 4}>testable</text>
    <rect x="700" y="104" width="280" height="92" class="dm-but" class:dm-allume={e >= 4} />

    <!-- Les quatre portes. -->
    {#each REGLES as r, i}
      {@const vu = e >= i + 1}
      <g class="dm-porte" class:dm-vu={vu} class:dm-valide={e >= 4} style="--k: {i}">
        <rect x={PORTES[i] - 10} y="36" width="20" height="78" class="dm-montant" />
        <rect x={PORTES[i] - 10} y="186" width="20" height="78" class="dm-montant" />
        {#if vu}
          <text x={PORTES[i]} y="26" class="dm-porte-t">{r.nom}</text>
          <text x={PORTES[i]} y="288" class="dm-porte-n">{i + 1}</text>
        {/if}
      </g>
    {/each}

    <!-- Temps 2 : la carte invérifiable rebondit sur la porte 2 et tombe. -->
    {#if e >= 2}
      <g class="dm-jeton dm-inverif">
        <rect x="-74" y="-25" width="148" height="50" class="dm-carte" />
        <text x="0" y="-4" class="dm-carte-t">Tout arrive</text>
        <text x="0" y="14" class="dm-carte-t">pour une raison.</text>
      </g>
      <!-- Les étincelles passent APRÈS la carte : en SVG, l’ordre du document
           est l’ordre de peinture, et la carte est opaque. -->
      <g class="dm-choc">
        <path d="M 322 128 L 306 118 M 322 150 L 302 150 M 322 172 L 306 182" />
      </g>
    {/if}

    <!-- Temps 4 : l’hypothèse de la séance 1 traverse tout. -->
    {#if e >= 4}
      <g class="dm-jeton dm-bonne">
        <rect x="-130" y="-19" width="260" height="38" class="dm-carte dm-carte-ok" />
        <text x="0" y="6" class="dm-carte-t dm-carte-t-ok">Plus on est âgé, plus on vote.</text>
      </g>
    {/if}
  </svg>

  <div class="dm-regles">
    {#each REGLES as r, i}
      {@const vu = e >= i + 1}
      <div class="dm-regle" class:dm-vu={vu} class:dm-ici={e === i + 1}>
        <span class="dm-regle-n">{i + 1}</span>
        <span class="dm-regle-t">{#if vu}{r.nom}{/if}</span>
        <span class="dm-regle-g">{#if vu}{r.gloss}{/if}</span>
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

  .dm-but { fill: none; stroke: var(--dk-filet); stroke-width: 4; stroke-dasharray: 10 8; transition: stroke 0.4s 1.9s, stroke-dasharray 0.4s 1.9s; }
  .dm-but.dm-allume { stroke: var(--dk-accent); stroke-dasharray: none; }
  .dm-but-t { font-size: 20px; font-weight: 600; letter-spacing: 0.1em; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.4s 1.9s; }
  .dm-but-t.dm-allume { fill: var(--dk-accent); }

  .dm-montant { fill: var(--dk-filet); transition: fill 0.35s; }
  .dm-porte.dm-vu .dm-montant { fill: var(--dk-encre); animation: dm-pousse 0.45s cubic-bezier(0.34, 1.7, 0.64, 1) both; transform-box: fill-box; transform-origin: 50% 50%; }
  /* Chaque porte s’allume au moment où la carte y arrive, pas avant. */
  .dm-porte.dm-valide .dm-montant { animation: dm-flash 0.6s ease-out both; animation-delay: calc(var(--k) * 300ms + 1000ms); }
  .dm-porte-t { font-size: 15px; font-weight: 600; letter-spacing: 0.1em; text-anchor: middle; fill: var(--dk-encre); animation: dm-monte 0.4s ease-out both; }
  .dm-porte-n { font-size: 15px; text-anchor: middle; fill: var(--dk-gris-2); animation: dm-monte 0.4s ease-out 0.1s both; }

  .dm-carte { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .dm-carte-t { font-size: 14px; text-anchor: middle; fill: var(--dk-encre); }
  .dm-carte-ok { stroke: var(--dk-accent); stroke-width: 4; }
  .dm-carte-t-ok { font-weight: 600; fill: var(--dk-accent); }

  /* La carte invérifiable : elle passe la porte 1, cogne la porte 2, retombe. */
  .dm-inverif { animation: dm-rebond 1.7s both; }
  .dm-inverif .dm-carte { animation: dm-grise 0.6s ease-out 1.25s both; }
  .dm-inverif .dm-carte-t { animation: dm-grise-t 0.6s ease-out 1.25s both; }

  .dm-choc path { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linecap: round; opacity: 0; animation: dm-etincelle 0.5s ease-out 0.62s both; }

  /* L’hypothèse testable : elle glisse jusque dans la boîte. */
  .dm-bonne { animation: dm-passe 2.3s cubic-bezier(0.5, 0, 0.3, 1) both; }

  .dm-regles { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.9em; }
  .dm-regle { display: flex; flex-direction: column; gap: 0.3em; padding: 0.6em 0.7em 0.7em; min-height: 8.6em; border: 3px dashed var(--dk-filet); transition: border-color 0.3s; }
  .dm-regle.dm-vu { border-style: solid; border-color: var(--dk-encre); }
  .dm-regle.dm-ici { border-color: var(--dk-accent); animation: dm-tape 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .dm-regle-n { font-size: 1.6em; font-weight: 600; line-height: 1; color: var(--dk-gris-2); transition: color 0.3s; }
  .dm-vu .dm-regle-n { color: var(--dk-encre); }
  .dm-ici .dm-regle-n { color: var(--dk-accent); }
  .dm-regle-t { font-size: 0.95em; font-weight: 600; letter-spacing: 0.08em; min-height: 1.3em; animation: dm-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) 0.15s both; }
  .dm-ici .dm-regle-t { color: var(--dk-accent); }
  .dm-regle-g { font-size: 0.68em; line-height: 1.3; color: var(--dk-gris); animation: dm-monte 0.45s ease-out 0.3s both; }

  .dm-source { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes dm-pousse { from { transform: scaleY(0.2); } to { transform: scaleY(1); } }
  @keyframes dm-flash { 0% { fill: var(--dk-encre); } 35% { fill: var(--dk-accent); } 100% { fill: var(--dk-encre); } }
  @keyframes dm-monte { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @keyframes dm-tape { from { transform: scale(0.94); } to { transform: scale(1); } }
  @keyframes dm-etincelle { 0% { opacity: 0; transform: scale(0.4); } 30% { opacity: 1; transform: scale(1.15); } 100% { opacity: 0; transform: scale(1.3); } }

  @keyframes dm-rebond {
    0% { transform: translate(-120px, 150px) rotate(0deg); }
    40% { transform: translate(256px, 150px) rotate(0deg); animation-timing-function: cubic-bezier(0.4, 0, 0.5, 1); }
    52% { transform: translate(222px, 152px) rotate(-5deg); }
    70% { transform: translate(158px, 168px) rotate(-9deg); animation-timing-function: cubic-bezier(0.5, 0, 0.6, 1); }
    100% { transform: translate(108px, 228px) rotate(-13deg); }
  }
  @keyframes dm-grise { from { stroke: var(--dk-encre); } to { stroke: var(--dk-gris-2); } }
  @keyframes dm-grise-t { from { fill: var(--dk-encre); } to { fill: var(--dk-gris-2); } }

  @keyframes dm-passe {
    0% { transform: translate(-150px, 150px); }
    10% { transform: translate(-150px, 150px); }
    100% { transform: translate(840px, 150px); }
  }

  @media (prefers-reduced-motion: reduce) {
    .dm-porte.dm-vu .dm-montant,
    .dm-porte.dm-valide .dm-montant,
    .dm-porte-t, .dm-porte-n,
    .dm-regle.dm-ici, .dm-regle-t, .dm-regle-g,
    .dm-inverif .dm-carte, .dm-inverif .dm-carte-t { animation: none; }
    .dm-but, .dm-but-t, .dm-montant, .dm-regle, .dm-regle-n { transition: none; }
    .dm-choc path { animation: none; opacity: 1; }
    .dm-inverif { animation: none; transform: translate(108px, 228px) rotate(-13deg); }
    .dm-inverif .dm-carte { stroke: var(--dk-gris-2); }
    .dm-inverif .dm-carte-t { fill: var(--dk-gris-2); }
    .dm-bonne { animation: none; transform: translate(840px, 150px); }
  }
</style>
