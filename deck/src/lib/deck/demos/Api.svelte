<script>
  /**
   * Ce qu'est un API, pour quelqu'un qui n'a jamais ouvert un terminal.
   * Le modèle ne s'installe pas: il reste chez le fournisseur. On lui envoie
   * du texte, il en renvoie. Deux flèches, et ce qui voyage sur chacune.
   *
   * Aucune quantité affichée: le schéma nomme les champs, il ne les mesure pas.
   *
   * Toutes les largeurs sont calculées, jamais estimées à l'œil. En IBM Plex
   * Mono, une glyphe avance de 0,6 em; une étiquette espacée ajoute encore son
   * letter-spacing par caractère. Un texte plus large que sa boîte déborde en
   * silence — c'est la faute qu'on a déjà faite sur le schéma de l'attention.
   */
  const larg = (txt, taille, ls = 0) => txt.length * taille * (0.6 + ls);

  const VB_L = 1020; // largeur du viewBox
  const BOITE = 250; // largeur d'une machine
  const CX_G = BOITE / 2; // 125
  const CX_D = VB_L - BOITE / 2; // 895
  const CX_M = VB_L / 2; // 510

  // Couloir entre les deux boîtes, où passent les flèches.
  const GA = BOITE + 12; // 262
  const DR = VB_L - BOITE - 12; // 758
  const COURSE = DR - GA - 12; // distance parcourue par le paquet

  const T_LIEU = 17,
    T_DEDANS = 22,
    T_SENS = 21,
    T_QUOI = 18,
    T_NOTE = 16;

  // Vérifications de non-débordement, actives en développement seulement.
  if (import.meta.env.DEV) {
    const tient = (txt, taille, ls, dispo, ou) => {
      const l = larg(txt, taille, ls);
      if (l > dispo) console.warn(`[Api] « ${txt} » fait ${Math.round(l)} pour ${dispo} (${ou})`);
    };
    tient('CHEZ LE FOURNISSEUR', T_LIEU, 0.12, BOITE * 2, 'étiquette de droite');
    tient('votre ordinateur', T_DEDANS, 0, 220, 'boîte de gauche');
    tient('le modèle', T_DEDANS, 0, 220, 'boîte de droite');
    tient('votre texte · vos paramètres · votre clé', T_QUOI, 0, DR - GA + 40, 'requête');
    tient('le texte produit · le compte de jetons', T_QUOI, 0, DR - GA + 40, 'réponse');
    tient('un centre de données', T_NOTE, 0, BOITE * 1.6, 'note');
  }
</script>

<div class="api">
  <svg
    viewBox="0 0 {VB_L} 300"
    role="img"
    aria-label="Votre script R envoie une requête — texte, paramètres, clé — au serveur du fournisseur, qui renvoie une réponse contenant le texte produit et le compte de jetons."
  >
    <!-- chez vous -->
    <text class="lieu" x={CX_G} y="22" text-anchor="middle">CHEZ VOUS</text>
    <rect class="boite" x="0" y="38" width={BOITE} height="210" />
    <rect class="dedans" x={CX_G - 110} y="108" width="220" height="70" />
    <text class="dedans-t" x={CX_G} y="151" text-anchor="middle">votre ordinateur</text>

    <!-- chez le fournisseur -->
    <text class="lieu" x={CX_D} y="22" text-anchor="middle">CHEZ LE FOURNISSEUR</text>
    <rect class="boite" x={VB_L - BOITE} y="38" width={BOITE} height="210" />
    <rect class="dedans plein" x={CX_D - 110} y="108" width="220" height="70" />
    <text class="dedans-t inv" x={CX_D} y="151" text-anchor="middle">le modèle</text>
    <text class="note" x={CX_D} y="274" text-anchor="middle">un centre de données</text>
    <text class="note" x={CX_D} y="294" text-anchor="middle">quelque part</text>

    <!-- requête -->
    <text class="sens" x={CX_M} y="62" text-anchor="middle">REQUÊTE</text>
    <text class="quoi" x={CX_M} y="86" text-anchor="middle"
      >votre texte · vos paramètres · votre clé</text
    >
    <path class="fx" d="M{GA} 104 L{DR - 12} 104" />
    <path class="fx" d="M{DR - 21} 97 L{DR - 11} 104 L{DR - 21} 111" />
    <rect class="paq va" x={GA} y="97" width="14" height="14" style="--course: {COURSE}px" />

    <!-- réponse -->
    <path class="fx" d="M{DR} 196 L{GA + 12} 196" />
    <path class="fx" d="M{GA + 21} 189 L{GA + 11} 196 L{GA + 21} 203" />
    <rect
      class="paq vient"
      x={GA + COURSE}
      y="189"
      width="14"
      height="14"
      style="--course: {COURSE}px"
    />
    <text class="sens" x={CX_M} y="220" text-anchor="middle">RÉPONSE</text>
    <text class="quoi" x={CX_M} y="244" text-anchor="middle"
      >le texte produit · le compte de jetons</text
    >
  </svg>
</div>

<style>
  .api {
    width: 100%;
  }
  svg {
    width: 100%;
    height: auto;
    display: block;
    overflow: visible;
  }

  :global(.api .boite) {
    fill: none;
    stroke: var(--dk-encre);
    stroke-width: 2.5;
  }
  :global(.api .dedans) {
    fill: none;
    stroke: var(--dk-gris-2);
    stroke-width: 2.5;
  }
  :global(.api .dedans.plein) {
    fill: var(--dk-accent);
    stroke: var(--dk-accent);
  }

  :global(.api text) {
    font-family: var(--dk-mono);
  }

  :global(.api .lieu) {
    font-size: 17px;
    letter-spacing: 0.12em;
    fill: var(--dk-gris);
  }
  :global(.api .dedans-t) {
    font-size: 22px;
    fill: var(--dk-encre);
  }
  :global(.api .dedans-t.inv) {
    fill: var(--dk-fond);
    font-weight: 600;
  }
  :global(.api .note) {
    font-size: 16px;
    fill: var(--dk-gris);
  }

  :global(.api .sens) {
    font-size: 21px;
    font-weight: 600;
    letter-spacing: 0.16em;
    fill: var(--dk-accent);
  }
  :global(.api .quoi) {
    font-size: 18px;
    fill: var(--dk-gris);
  }

  :global(.api .fx) {
    stroke: var(--dk-encre);
    stroke-width: 2.5;
    fill: none;
  }

  :global(.api .paq) {
    fill: var(--dk-accent);
    transform-box: view-box;
    animation-duration: 7s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
  }
  :global(.api .paq.va) {
    animation-name: api-va;
  }
  :global(.api .paq.vient) {
    animation-name: api-vient;
  }

  @keyframes api-va {
    0% {
      transform: translateX(0);
      opacity: 0;
    }
    4% {
      opacity: 1;
    }
    42% {
      transform: translateX(var(--course));
      opacity: 1;
    }
    46%,
    100% {
      transform: translateX(var(--course));
      opacity: 0;
    }
  }

  @keyframes api-vient {
    0%,
    48% {
      transform: translateX(0);
      opacity: 0;
    }
    52% {
      opacity: 1;
    }
    90% {
      transform: translateX(calc(-1 * var(--course)));
      opacity: 1;
    }
    94%,
    100% {
      transform: translateX(calc(-1 * var(--course)));
      opacity: 0;
    }
  }

  /* Sans animation, le paquet de réponse resterait garé à l'extrémité droite
     de sa flèche — ce qui se lit comme un déplacement vers la droite, soit
     l'inverse du sens réel. Les flèches et leurs pointes portent déjà le sens:
     on retire les paquets plutôt que de les figer à contresens. */
  @media (prefers-reduced-motion: reduce) {
    :global(.api .paq) {
      animation: none;
      opacity: 0;
    }
  }
</style>
