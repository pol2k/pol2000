<script>
  /**
   * L'argument de la diapo, dessiné plutôt qu'écrit: il n'y a qu'un seul
   * mécanisme. La bifurcation n'arrive pas dans le modèle, elle arrive de
   * notre côté, après coup, selon une vérité à laquelle il n'a pas accès.
   *
   * Les deux boîtes de droite sont volontairement identiques: c'est le
   * dessin qui porte la thèse. Une boîte « hallucination » en rouge dirait
   * le contraire de ce qu'on affirme.
   *
   * Largeurs calculées, jamais estimées: en IBM Plex Mono une glyphe avance
   * de 0,6 em, plus le letter-spacing par caractère pour les étiquettes.
   */
  const larg = (txt, taille, ls = 0) => txt.length * taille * (0.6 + ls);

  const SEP = 560; // la ligne qui sépare le modèle de notre lecture
  const Y = 173; // axe de la sortie unique

  const BG = { x: 20, y: 128, w: 430, h: 90 };
  const BD = { x: 610, w: 330, h: 52 };
  const Y_A = 100,
    Y_B = 195; // hauts des deux boîtes de droite

  if (import.meta.env.DEV) {
    const tient = (t, s, ls, dispo, ou) => {
      const l = larg(t, s, ls);
      if (l > dispo)
        console.warn(`[Hallucination] « ${t} » fait ${Math.round(l)} pour ${dispo} (${ou})`);
    };
    tient('la suite la plus plausible', 24, 0, BG.w - 40, 'boîte du modèle');
    tient('« hallucination »', 24, 0, BD.w - 30, 'boîte de droite');
    tient("CE QU'ON EN DIT APRÈS COUP", 17, 0.12, 1020 - 610, 'entête de droite');
    tient('le modèle ne fait pas cette distinction', 17, 0, 1020 - 610, 'note du bas');
  }
</script>

<div class="hal">
  <svg
    viewBox="0 0 1020 330"
    role="img"
    aria-label="Le modèle produit une seule sortie, la suite la plus plausible, sans étape de vérification. C'est nous qui, après coup, l'appelons réponse si elle est vraie et hallucination si elle est fausse."
  >
    <text class="tete" x={BG.x} y="26">CE QUE LE MODÈLE FAIT</text>
    <rect class="bloc" x={BG.x} y={BG.y} width={BG.w} height={BG.h} />
    <text class="bloc-t" x={BG.x + BG.w / 2} y={Y + 9} text-anchor="middle"
      >la suite la plus plausible</text
    >
    <text class="note" x={BG.x + BG.w / 2} y="250" text-anchor="middle"
      >aucune étape de vérification</text
    >

    <path class="fx" d="M{BG.x + BG.w} {Y} L{SEP - 8} {Y}" />
    <path class="sep" d="M{SEP} 46 L{SEP} 300" />

    <text class="tete" x={BD.x} y="26">CE QU'ON EN DIT APRÈS COUP</text>

    <path class="fx" d="M{SEP} {Y} L580 {Y} L580 {Y_A + BD.h / 2} L{BD.x - 6} {Y_A + BD.h / 2}" />
    <path
      class="fx"
      d="M{BD.x - 15} {Y_A + BD.h / 2 - 7} L{BD.x - 5} {Y_A + BD.h / 2} L{BD.x - 15} {Y_A +
        BD.h / 2 +
        7}"
    />
    <path class="fx" d="M{SEP} {Y} L580 {Y} L580 {Y_B + BD.h / 2} L{BD.x - 6} {Y_B + BD.h / 2}" />
    <path
      class="fx"
      d="M{BD.x - 15} {Y_B + BD.h / 2 - 7} L{BD.x - 5} {Y_B + BD.h / 2} L{BD.x - 15} {Y_B +
        BD.h / 2 +
        7}"
    />

    <text class="si" x={BD.x} y={Y_A - 10}>SI C'EST VRAI</text>
    <rect class="bloc" x={BD.x} y={Y_A} width={BD.w} height={BD.h} />
    <text class="bloc-t" x={BD.x + BD.w / 2} y={Y_A + 35} text-anchor="middle">« réponse »</text>

    <text class="si" x={BD.x} y={Y_B - 10}>SI C'EST FAUX</text>
    <rect class="bloc" x={BD.x} y={Y_B} width={BD.w} height={BD.h} />
    <text class="bloc-t" x={BD.x + BD.w / 2} y={Y_B + 35} text-anchor="middle"
      >« hallucination »</text
    >

    <text class="note fort" x={BD.x} y="290">le modèle ne fait pas cette distinction</text>
  </svg>
</div>

<style>
  .hal {
    width: 100%;
  }
  svg {
    width: 100%;
    height: auto;
    display: block;
  }

  :global(.hal text) {
    font-family: var(--dk-mono);
  }

  :global(.hal .tete) {
    font-size: 17px;
    letter-spacing: 0.12em;
    fill: var(--dk-gris);
  }
  :global(.hal .si) {
    font-size: 15px;
    letter-spacing: 0.1em;
    fill: var(--dk-accent);
  }
  :global(.hal .bloc) {
    fill: none;
    stroke: var(--dk-encre);
    stroke-width: 2.5;
  }
  :global(.hal .bloc-t) {
    font-size: 24px;
    fill: var(--dk-encre);
  }
  :global(.hal .fx) {
    stroke: var(--dk-encre);
    stroke-width: 2.5;
    fill: none;
  }
  :global(.hal .sep) {
    stroke: var(--dk-gris-2);
    stroke-width: 2;
    stroke-dasharray: 7 7;
    fill: none;
  }
  :global(.hal .note) {
    font-size: 17px;
    fill: var(--dk-gris);
  }
  :global(.hal .note.fort) {
    fill: var(--dk-accent);
  }

  /* Sur fond encre, l'encre est invisible: tout le jeu bascule. */
  :global(.diapo.encre .hal .bloc) {
    stroke: var(--dk-fond);
  }
  :global(.diapo.encre .hal .bloc-t) {
    fill: var(--dk-fond);
  }
  :global(.diapo.encre .hal .fx) {
    stroke: var(--dk-fond);
  }
  :global(.diapo.encre .hal .tete),
  :global(.diapo.encre .hal .note) {
    fill: var(--dk-gris-2);
  }
  :global(.diapo.encre .hal .si),
  :global(.diapo.encre .hal .note.fort) {
    fill: var(--dk-accent-clair);
  }
  :global(.diapo.encre .hal .sep) {
    stroke: var(--dk-gris);
  }
</style>
