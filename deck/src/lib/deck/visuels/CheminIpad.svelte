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
   *   1  Le jeton « R » tombe entre les deux et essaie la manière tablette :
   *      une main va toucher le fichier, et reçoit une croix rouge.
   *   2  La main s’efface, la tablette pâlit. Sous le portable, la chaîne
   *      "data/ces2025.csv" se tape toute seule, puis un trait rouge part de
   *      la chaîne et rejoint le fichier. Le chemin est nommé.
   *
   * Coordonnées fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  const COLS = [108, 176, 244];
  const RANGS = [138, 206, 274];
  const CAR = [...'"data/ces2025.csv"'];

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
    aria-label="À gauche, une tablette&#8239;: une grille d’icônes d’applications, dont une est ouverte et contient un document. À droite, un ordinateur portable&#8239;: à l’écran, un dossier nommé data dont dépasse un fichier. Entre les deux, un jeton marqué R tente de toucher le fichier avec une main et reçoit une croix rouge. Sous le portable, le texte «&#8239;data/ces2025.csv&#8239;», entre guillemets, est relié au fichier par un trait rouge."
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

    <!-- ——— R, qui essaie la manière tablette ——— -->
    <g class="ci-r" class:ci-vu={e >= 1}>
      <rect x="535" y="195" width="90" height="90" class="ci-r-boite" />
      <text x="580" y="261" class="ci-r-lettre">R</text>
    </g>
    <g class="ci-main" class:ci-vu={e >= 1} class:ci-parti={e >= 2}>
      <path d="M -9 0 H 9 V 34 H 38 V 78 H -20 V 42 H -9 Z" class="ci-doigt" />
      <path d="M 9 34 V 52 M 24 34 V 52" class="ci-phalange" />
    </g>
    <path
      d="M 895 148 L 955 208 M 955 148 L 895 208"
      class="ci-croix"
      class:ci-vu={e >= 1}
      class:ci-parti={e >= 2}
    />

    <!-- ——— L’adresse, écrite ——— -->
    <g class="ci-puce" class:ci-vu={e >= 2}>
      <rect x="748" y="404" width="364" height="62" class="ci-puce-boite" />
      <text x="930" y="446" class="ci-puce-t">{#each CAR as c, i}<tspan class="ci-car" style="animation-delay: {0.3 + i * 0.07}s">{c}</tspan>{/each}</text>
      <path d="M 1112 435 H 1165 V 190 H 984" pathLength="1" class="ci-lien" />
      <path d="M 1000 178 L 984 190 L 1000 202" class="ci-pointe" />
    </g>
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

  .ci-tab { transition: opacity 0.5s; }
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

  .ci-feuille { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; transition: stroke 0.4s; }
  .ci-lignes { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }
  .ci-fichier.ci-trouve .ci-feuille { stroke: var(--dk-accent); transition-delay: 2.5s; }

  .ci-dossier-fond { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .ci-dossier { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-dossier-nom { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  /* Le jeton R tombe entre les deux appareils. */
  .ci-r { opacity: 0; transform: translateY(-70px); transition: opacity 0.3s, transform 0.5s ease-out; }
  .ci-r.ci-vu { opacity: 1; transform: none; }
  .ci-r-boite { fill: var(--dk-accent); }
  .ci-r-lettre { font-size: 60px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }

  /* La main part du jeton et va toucher le fichier. */
  .ci-main { opacity: 0; transform: translate(640px, 232px); transition: opacity 0.2s, transform 0s 0.2s; }
  .ci-main.ci-vu { opacity: 1; transform: translate(925px, 178px); transition: opacity 0.3s 0.5s, transform 1s ease-in-out 0.7s; }
  .ci-main.ci-parti { opacity: 0; transition: opacity 0.3s; }
  .ci-doigt { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .ci-phalange { fill: none; stroke: var(--dk-encre); stroke-width: 4; }

  .ci-croix { fill: none; stroke: var(--dk-accent); stroke-width: 10; opacity: 0; transition: opacity 0.2s; }
  .ci-croix.ci-vu { opacity: 1; transition: opacity 0.25s 1.8s; }
  .ci-croix.ci-parti { opacity: 0; transition: opacity 0.3s; }

  /* La chaîne se tape, puis le trait rejoint le fichier. */
  .ci-puce { opacity: 0; transition: opacity 0.3s; }
  .ci-puce.ci-vu { opacity: 1; }
  .ci-puce-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .ci-puce-t { font-size: 31px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ci-car { opacity: 0; }
  .ci-puce.ci-vu .ci-car { animation: ci-frappe 0.02s linear both; }
  .ci-lien { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .ci-puce.ci-vu .ci-lien { stroke-dashoffset: 0; transition: stroke-dashoffset 0.8s ease-in-out 1.7s; }
  .ci-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; opacity: 0; }
  .ci-puce.ci-vu .ci-pointe { opacity: 1; transition: opacity 0.2s 2.5s; }

  /* La place de la ligne est réservée : le dessin ne saute pas au clic. */
  .ci-bas { font-size: 1.25em; line-height: 1.35; min-height: 1.35em; }
  .ci-ligne { margin: 0; font-weight: 600; animation: ci-monte 0.4s ease-out both; }
  .ci-ligne.ci-rouge { color: var(--dk-accent); animation-delay: 2.6s; }

  @keyframes ci-frappe { from { opacity: 0; } to { opacity: 1; } }
  @keyframes ci-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .ci-tab, .ci-feuille, .ci-r, .ci-main, .ci-croix, .ci-puce { transition: none; }
    .ci-main.ci-vu, .ci-main.ci-parti, .ci-croix.ci-vu, .ci-croix.ci-parti { transition: none; }
    .ci-fichier.ci-trouve .ci-feuille { transition: none; }
    .ci-puce.ci-vu .ci-car { animation: none; opacity: 1; }
    .ci-puce.ci-vu .ci-lien, .ci-puce.ci-vu .ci-pointe { transition: none; }
    .ci-ligne, .ci-ligne.ci-rouge { animation: none; }
  }
</style>
