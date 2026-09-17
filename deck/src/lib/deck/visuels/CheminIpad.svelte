<script>
  /**
   * Pourquoi un chemin ? Parce que R ne touche pas d’icône. Sur une tablette,
   * on touche l’app et « nos choses » sont dedans : on ne range rien. Sur un
   * ordinateur, le fichier est quelque part, et R ne peut pas cliquer dessus :
   * il lui faut l’adresse, écrite. Un seul dessin, presque pas de mots.
   *
   *   0  Deux appareils côte à côte : la tablette (une grille d’apps, une app
   *      ouverte avec un document dedans) et le portable (un dossier `data`,
   *      un fichier qui en dépasse).
   *   1  Le logo de R tombe entre les deux et essaie la manière tablette :
   *      une main va toucher le fichier, et reçoit une croix rouge.
   *   2  La main disparaît, la tablette pâlit. Sous le portable, la chaîne
   *      "data/data.csv" se tape toute seule, puis un trait rouge part de
   *      la chaîne et rejoint le fichier. Le chemin est nommé.
   *
   * Chaque temps tient en une seconde environ et son état de repos ne dépend
   * que de `e` : l’ancienne version enchaînait des délais (croix à 1,8 s,
   * phrase à 2,6 s) qu’un clic au rythme de la parole coupait avant la fin.
   *
   * Coordonnées fixes, aucun hasard.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  const COLS = [108, 176, 244];
  const RANGS = [138, 206, 274];
  const ADRESSE = '"data/data.csv"';
  // IBM Plex Mono : chasse de 0,6 cadratin, corps 31 → largeur exacte du texte.
  const LARGEUR = ADRESSE.length * 31 * 0.6;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel ci-fig" bind:this={hote}>
  <svg
    class="ci-scene"
    viewBox="0 0 1200 480"
    role="img"
    aria-label="À gauche, une tablette&#8239;: une grille d’icônes d’applications, dont une est ouverte et contient un document. À droite, un ordinateur portable&#8239;: à l’écran, un dossier nommé data dont dépasse un fichier. Entre les deux, le logo de R tente de toucher le fichier avec une main et reçoit une croix rouge. Sous le portable, le texte «&#8239;data/data.csv&#8239;», entre guillemets, est relié au fichier par un trait rouge."
  >
    <!-- ——— La tablette : on touche l’app, le document est « dedans » ——— -->
    <g class="ci-tab" class:ci-pale={e >= 2}>
      <text x="280" y="38" class="ci-nom">iPad</text>
      <text x="280" y="76" class="ci-dit">on touche l’app</text>
      <rect x="70" y="100" width="420" height="280" class="ci-coque" />
      <rect x="90" y="120" width="380" height="240" class="ci-ecran" />
      {#each RANGS as y}
        {#each COLS as x}
          <rect {x} {y} width="52" height="52" class="ci-app" class:ci-touchee={x === 244 && y === 206} />
        {/each}
      {/each}
      <circle cx="270" cy="232" r="12" class="ci-tape" />
      <path d="M 296 206 L 326 138 M 296 258 L 326 326" class="ci-zoom" />
      <rect x="326" y="138" width="126" height="188" class="ci-ouverte" />
      <rect x="326" y="138" width="126" height="26" class="ci-bandeau" />
      <path d="M 356 190 H 406 L 422 206 V 300 H 356 Z M 406 190 V 206 H 422" class="ci-feuille" />
      <path d="M 368 228 H 410 M 368 250 H 410 M 368 272 H 396" class="ci-lignes" />
    </g>

    <!-- ——— Le portable : le fichier est quelque part ——— -->
    <text x="930" y="38" class="ci-nom">ordinateur</text>
    <text x="930" y="76" class="ci-dit">le fichier est quelque part</text>
    <rect x="730" y="100" width="400" height="240" class="ci-ecran ci-portable" />
    <path d="M 730 340 H 1130 L 1180 380 H 680 Z" class="ci-coque" />
    <path d="M 830 190 H 900 L 916 208 H 1020 V 318 H 830 Z" class="ci-dossier-fond" />
    <g class="ci-fichier" class:ci-trouve={e >= 2}>
      <path d="M 880 140 H 948 L 970 162 V 262 H 880 Z M 948 140 V 162 H 970" class="ci-feuille" />
      <path d="M 894 182 H 956 M 894 202 H 956" class="ci-lignes" />
    </g>
    <rect x="830" y="224" width="190" height="94" class="ci-dossier" />
    <text x="925" y="281" class="ci-dossier-nom">data</text>

    <!-- ——— R, qui essaie la manière tablette ———
         Le logo reste monté (l’image est déjà chargée au clic) : seule une
         classe le fait tomber. La main et la croix, elles, n’existent qu’au
         temps 1 : leur entrée rejoue à chaque arrivée, et un clic hâtif les
         retire d’un coup au lieu de les laisser à mi-chemin. -->
    <image
      href="{base}/img/Rlogo.png"
      x="525" y="197.4" width="110" height="85.2"
      class="ci-r"
      class:ci-vu={e >= 1}
    />
    {#if e === 1}
      <g transform="translate(925 178)">
        <g class="ci-main">
          <path d="M -9 0 H 9 V 34 H 38 V 78 H -20 V 42 H -9 Z" class="ci-doigt" />
          <path d="M 9 34 V 52 M 24 34 V 52" class="ci-phalange" />
        </g>
      </g>
      <path d="M 895 148 L 955 208 M 955 148 L 895 208" class="ci-croix" />
    {/if}

    <!-- ——— L’adresse, écrite ———
         Le texte est entier dès l’arrivée ; un cache de la couleur du fond se
         retire par crans d’une lettre (police à chasse fixe : 0,6 cadratin). -->
    {#if e >= 2}
      <g class="ci-puce">
        <rect x="770" y="404" width="320" height="62" class="ci-puce-boite" />
        <text x="930" y="446" class="ci-puce-t">{ADRESSE}</text>
        <rect x={930 - LARGEUR / 2} y="410" width={LARGEUR} height="50" class="ci-cache" style="--ci-n: {ADRESSE.length}" />
        <path d="M 1090 435 H 1165 V 190 H 984" pathLength="1" class="ci-lien" />
        <path d="M 1000 178 L 984 190 L 1000 202" class="ci-pointe" />
      </g>
    {/if}
  </svg>

  <div class="ci-bas">
    {#if e === 1}
      <p class="ci-ligne">R ne clique pas.</p>
    {:else if e >= 2}
      <p class="ci-ligne ci-rouge">Il lui faut l’adresse, écrite. Cette adresse, c’est le chemin.</p>
    {/if}
  </div>
</div>

<style>
  .ci-fig { display: flex; flex-direction: column; gap: 0.6em; }

  .ci-scene { width: 100%; max-height: 46vh; display: block; overflow: visible; }
  .ci-scene text { font-family: var(--dk-mono); }

  .ci-nom { font-size: 32px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ci-dit { font-size: 27px; text-anchor: middle; fill: var(--dk-gris); }

  .ci-tab { transition: opacity 0.3s; }
  .ci-tab.ci-pale { opacity: 0.28; }

  .ci-coque { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 5; stroke-linejoin: miter; }
  .ci-ecran { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-ecran.ci-portable { stroke-width: 5; }
  .ci-app { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-app.ci-touchee { fill: var(--dk-encre); }
  .ci-tape { fill: none; stroke: var(--dk-fond); stroke-width: 4; }
  .ci-zoom { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; }
  .ci-ouverte { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-bandeau { fill: var(--dk-encre); }

  .ci-feuille { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; transition: stroke 0.2s; }
  .ci-lignes { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }
  .ci-fichier.ci-trouve .ci-feuille { stroke: var(--dk-accent); transition-delay: 0.85s; }

  .ci-dossier-fond { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .ci-dossier { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-dossier-nom { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  /* Principe : l’état de repos de chaque temps est le CSS nu, fixé par `e`
     seul. Les entrées sont des keyframes « from » seulement, courtes, en
     `backwards` : interrompues ou non, elles finissent sur l’état de repos. */

  /* Le logo R tombe entre les deux appareils. */
  .ci-r { opacity: 0; transform: translateY(-70px); transition: opacity 0.25s, transform 0.35s ease-out; }
  .ci-r.ci-vu { opacity: 1; transform: none; }

  /* La main part du logo et va toucher le fichier ; la croix tombe aussitôt. */
  .ci-main { animation: ci-va 0.55s ease-in-out 0.15s backwards; }
  .ci-doigt { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .ci-phalange { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .ci-croix { fill: none; stroke: var(--dk-accent); stroke-width: 10; animation: ci-parait 0.15s linear 0.7s backwards; }

  /* La chaîne se tape, puis le trait rejoint le fichier. */
  .ci-puce { animation: ci-parait 0.15s linear backwards; }
  .ci-puce-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-puce-t { font-size: 31px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ci-cache {
    fill: var(--dk-fond);
    transform-box: fill-box;
    transform-origin: 100% 50%;
    transform: scaleX(0);
    animation: ci-tape 0.45s steps(var(--ci-n), end) 0.1s backwards;
  }
  .ci-lien { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; stroke-dasharray: 1; stroke-dashoffset: 0; animation: ci-trace 0.35s ease-in-out 0.55s backwards; }
  .ci-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; animation: ci-parait 0.1s linear 0.9s backwards; }

  /* La place de la ligne est réservée : le dessin ne saute pas au clic. */
  .ci-bas { font-size: 1.25em; line-height: 1.35; min-height: 1.35em; }
  .ci-ligne { margin: 0; font-weight: 600; animation: ci-monte 0.3s ease-out backwards; }
  .ci-ligne.ci-rouge { color: var(--dk-accent); }

  @keyframes ci-va { from { opacity: 0; transform: translate(-285px, 54px); } 25% { opacity: 1; transform: translate(-285px, 54px); } }
  @keyframes ci-parait { from { opacity: 0; } }
  @keyframes ci-tape { from { transform: scaleX(1); } }
  @keyframes ci-trace { from { stroke-dashoffset: 1; } }
  @keyframes ci-monte { from { opacity: 0; transform: translateY(0.4em); } }

  @media (prefers-reduced-motion: reduce) {
    .ci-tab, .ci-feuille, .ci-r { transition: none; }
    .ci-fichier.ci-trouve .ci-feuille { transition: none; }
    .ci-main, .ci-croix, .ci-puce, .ci-cache, .ci-lien, .ci-pointe, .ci-ligne { animation: none; }
  }
</style>
