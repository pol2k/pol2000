<script>
  /**
   * Où est R ? Un plan de l’ordinateur, dessiné comme des pièces. R est un
   * jeton rouge, toujours debout dans UNE pièce. Un chemin relatif comme
   * "data/ces2025.csv" est un itinéraire qui part de la pièce où R se
   * trouve : mêmes indications, mauvais point de départ, on n’arrive nulle
   * part. C’est la seule idée de la diapositive.
   *
   *   0  Le plan (Documents > pol2000 > data, R, resultats ; ailleurs,
   *      Téléchargements) et le jeton R dans pol2000. La vraie console :
   *      getwd() et sa sortie. « R est ici ».
   *   1  L’itinéraire "data/ces2025.csv" : un tracé rouge part du jeton,
   *      passe la porte de data, atteint le fichier. Coche.
   *   2  Le jeton saute dans Téléchargements. Le même itinéraire repart :
   *      il cherche une porte data, il n’y en a pas. Croix. La sortie de
   *      getwd() est retirée, elle ne serait plus vraie.
   *   3  Le jeton revient, l’itinéraire réussit de nouveau, et la règle
   *      s’écrit en rouge.
   *
   * Toutes les chaînes R viennent de seance3_chemins.js (vraie session R).
   * Coordonnées fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';
  import { CHEMINS } from '$lib/data/seance3_chemins.js';

  const appel = CHEMINS.consoles.ou[0];
  const chemin = CHEMINS.consoles.charger[0].in.match(/"[^"]+"/)[0];
  const fichier = CHEMINS.apres.data[0];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  let reussi = $derived(e === 1 || e === 3);
  let rate = $derived(e === 2);
  /* Au temps 3, le tracé attend que le jeton soit rentré. */
  let delai = $derived(e === 3 ? '0.9s' : '0s');
</script>

<div class="visuel or-fig" bind:this={hote}>
  <svg
    class="or-plan"
    viewBox="0 0 1200 470"
    role="img"
    style:--or-d={delai}
    aria-label="Un plan schématique de l’ordinateur, dessiné comme des pièces&#8239;: la pièce Documents contient la pièce pol2000, qui contient trois pièces, data, R et resultats&#8239;; dans data, une feuille, le fichier ces2025.csv. À part, une autre pièce&#8239;: Téléchargements. Un jeton carré rouge marqué R se tient dans pol2000. Un tracé rouge en pointillés part du jeton, entre dans data et atteint le fichier. Quand le jeton est dans Téléchargements, le même tracé ne trouve aucune porte data et finit sur une croix."
  >
    <defs>
      <mask id="or-masque-ok" maskUnits="userSpaceOnUse" x="0" y="0" width="1200" height="470">
        <path d="M 176 215 L 540 215 L 540 160 L 634 160" pathLength="1" class="or-trace" class:or-va={reussi} />
      </mask>
      <mask id="or-masque-non" maskUnits="userSpaceOnUse" x="0" y="0" width="1200" height="470">
        <path d="M 968 178 L 1076 178" pathLength="1" class="or-trace or-court" class:or-va={rate} />
      </mask>
    </defs>

    <!-- ——— Les pièces ——— -->
    <rect x="10" y="10" width="810" height="450" class="or-mur or-dehors" />
    <text x="30" y="46" class="or-nom or-pale">Documents</text>

    <rect x="40" y="64" width="750" height="376" class="or-mur or-projet" />
    <text x="60" y="102" class="or-nom or-fort">pol2000</text>

    <rect x="430" y="84" width="340" height="160" class="or-mur" />
    <text x="450" y="122" class="or-nom">data</text>
    <line x1="430" y1="197" x2="430" y2="233" class="or-porte" />

    <rect x="430" y="264" width="160" height="74" class="or-mur" />
    <text x="510" y="310" class="or-nom or-centre">R</text>
    <line x1="450" y1="264" x2="486" y2="264" class="or-porte" />

    <rect x="610" y="264" width="160" height="74" class="or-mur" />
    <text x="690" y="310" class="or-nom or-centre or-serre">resultats</text>
    <line x1="630" y1="264" x2="666" y2="264" class="or-porte" />

    <rect x="850" y="10" width="340" height="250" class="or-mur" />
    <text x="870" y="46" class="or-nom">Téléchargements</text>

    <!-- Le fichier, une feuille à coin plié. -->
    <g class="or-feuille" class:or-trouve={reussi}>
      <path d="M 640 112 L 684 112 L 700 128 L 700 190 L 640 190 Z" class="or-papier" />
      <path d="M 684 112 L 684 128 L 700 128" class="or-pli" />
      <path d="M 652 146 L 688 146 M 652 160 L 688 160 M 652 174 L 688 174" class="or-rang" />
    </g>
    <text x="670" y="226" class="or-petit or-centre">{fichier}</text>

    <!-- ——— La console : où suis-je ? (fausse au temps 2, donc retirée) ——— -->
    <g class="or-console" class:or-vu={e !== 2}>
      <line x1="138" y1="253" x2="138" y2="356" class="or-lien" />
      <rect x="60" y="356" width="610" height="76" class="or-ecran" />
      <text x="78" y="387" class="or-petit or-fort">&gt; {appel.in}</text>
      <text x="78" y="419" class="or-petit">{appel.out}</text>
    </g>

    <!-- ——— Les indications ——— -->
    <g class="or-indic" class:or-vu={e >= 1}>
      <rect x="850" y="300" width="340" height="72" class="or-puce" />
      <text x="1020" y="346" class="or-code">{chemin}</text>
    </g>

    <!-- Depuis pol2000 : on arrive. -->
    <path d="M 176 215 L 540 215 L 540 160 L 634 160" class="or-route" mask="url(#or-masque-ok)" />
    <path d="M 714 152 L 727 167 L 752 134" class="or-coche" class:or-vu={reussi} />

    <!-- Depuis Téléchargements : pas de porte data. -->
    <g class="or-fantome" class:or-vu={rate}>
      <rect x="1040" y="100" width="135" height="120" class="or-vide" />
      <text x="1107" y="134" class="or-petit or-centre or-pale">data&#8239;?</text>
    </g>
    <path d="M 968 178 L 1076 178" class="or-route" mask="url(#or-masque-non)" />
    <path d="M 1085 156 L 1129 200 M 1129 156 L 1085 200" class="or-croix" class:or-vu={rate} />

    <!-- ——— Le jeton R : X et Y animés à part, pour un vrai saut ——— -->
    <g class="or-jx" class:or-loin={e === 2} class:or-retour={e === 3}>
      <g class="or-jy" class:or-loin={e === 2} class:or-retour={e === 3}>
        <text x="100" y="163" class="or-ici">R est ici</text>
        <rect x="100" y="177" width="76" height="76" class="or-jeton" />
        <text x="138" y="233" class="or-jeton-t">R</text>
      </g>
    </g>
  </svg>

  <div class="or-bas">
    {#if e === 1}
      <p class="or-ligne">depuis ici&#8239;: on entre dans <b>data</b>, on prend le fichier</p>
    {:else if e === 2}
      <p class="or-ligne">mêmes indications, mauvais point de départ</p>
    {:else if e >= 3}
      <p class="or-regle">Un chemin relatif part toujours de l’endroit où R se trouve.</p>
      <p class="or-note">Dans ce cours&#8239;: le dossier ouvert dans Positron.</p>
    {/if}
  </div>
</div>

<style>
  .or-fig { display: flex; flex-direction: column; gap: 0.6em; }

  .or-plan { width: 100%; max-height: 43vh; display: block; overflow: visible; }
  .or-plan text { font-family: var(--dk-mono); }

  /* Les pièces */
  .or-mur { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .or-mur.or-dehors { fill: none; stroke: var(--dk-gris-2); }
  .or-mur.or-projet { fill: var(--dk-fond-2); stroke-width: 5; }
  .or-porte { stroke: var(--dk-fond-2); stroke-width: 8; }

  .or-nom { font-size: 28px; fill: var(--dk-encre); }
  .or-nom.or-serre { font-size: 26px; }
  .or-nom.or-pale { fill: var(--dk-gris); }
  .or-fort { font-weight: 600; }
  .or-centre { text-anchor: middle; }
  .or-petit { font-size: 25px; fill: var(--dk-encre); }
  .or-petit.or-pale { fill: var(--dk-gris); }

  /* Le fichier */
  .or-papier { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; transition: stroke 0.3s; }
  .or-pli { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: stroke 0.3s; }
  .or-rang { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }
  .or-feuille.or-trouve .or-papier,
  .or-feuille.or-trouve .or-pli { stroke: var(--dk-accent); transition-delay: calc(var(--or-d) + 1.1s); }

  /* La console */
  .or-console { opacity: 0; transition: opacity 0.3s; }
  .or-console.or-vu { opacity: 1; transition-delay: var(--or-d); }
  .or-lien { stroke: var(--dk-encre); stroke-width: 4; }
  .or-ecran { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }

  /* Les indications */
  .or-indic { opacity: 0; transition: opacity 0.35s; }
  .or-indic.or-vu { opacity: 1; }
  .or-puce { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 5; }
  .or-code { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  /* Le tracé : pointillés rouges, dévoilés par un masque qui se dessine. */
  .or-route { fill: none; stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 16 10; stroke-linejoin: miter; }
  .or-trace { fill: none; stroke: #fff; stroke-width: 16; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .or-trace.or-va { stroke-dashoffset: 0; animation: or-dessine 1.1s ease-in-out var(--or-d) both; }
  .or-trace.or-court.or-va { animation-duration: 0.5s; animation-delay: 0.95s; }

  .or-coche { fill: none; stroke: var(--dk-accent); stroke-width: 8; opacity: 0; transition: opacity 0.25s; }
  .or-coche.or-vu { opacity: 1; transition-delay: calc(var(--or-d) + 1.1s); }

  .or-fantome { opacity: 0; transition: opacity 0.3s; }
  .or-fantome.or-vu { opacity: 1; transition-delay: 0.8s; }
  .or-vide { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 12 9; }
  .or-croix { fill: none; stroke: var(--dk-accent); stroke-width: 9; opacity: 0; transition: opacity 0.25s; }
  .or-croix.or-vu { opacity: 1; transition-delay: 1.5s; }

  /* Le jeton */
  .or-jeton { fill: var(--dk-accent); }
  .or-jeton-t { font-size: 52px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }
  .or-ici { font-size: 28px; font-weight: 600; fill: var(--dk-accent); }

  .or-jx.or-loin { transform: translateX(792px); animation: or-va-x 0.8s ease-in-out both; }
  .or-jy.or-loin { transform: translateY(-37px); animation: or-va-y 0.8s both; }
  .or-jx.or-retour { animation: or-rev-x 0.8s ease-in-out both; }
  .or-jy.or-retour { animation: or-rev-y 0.8s both; }

  /* Sous le plan : la place est réservée, le plan ne bouge pas. */
  .or-bas { min-height: 3.3em; display: flex; flex-direction: column; gap: 0.35em; }
  .or-ligne { margin: 0; font-size: 1.05em; line-height: 1.4; animation: or-monte 0.4s ease-out both; }
  .or-ligne b { font-weight: 600; }
  .or-regle { margin: 0; font-size: 1.3em; font-weight: 600; line-height: 1.3; color: var(--dk-accent); animation: or-monte 0.45s ease-out both; }
  .or-note { margin: 0; font-size: 0.75em; line-height: 1.4; color: var(--dk-encre); animation: or-monte 0.45s ease-out 0.2s both; }

  @keyframes or-dessine { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes or-va-x { from { transform: translateX(0); } to { transform: translateX(792px); } }
  @keyframes or-rev-x { from { transform: translateX(792px); } to { transform: translateX(0); } }
  @keyframes or-va-y {
    0% { transform: translateY(0); animation-timing-function: ease-out; }
    50% { transform: translateY(-150px); animation-timing-function: ease-in; }
    100% { transform: translateY(-37px); }
  }
  @keyframes or-rev-y {
    0% { transform: translateY(-37px); animation-timing-function: ease-out; }
    50% { transform: translateY(-150px); animation-timing-function: ease-in; }
    100% { transform: translateY(0); }
  }
  @keyframes or-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .or-trace.or-va, .or-trace.or-court.or-va { animation: none; }
    .or-jx.or-loin, .or-jy.or-loin, .or-jx.or-retour, .or-jy.or-retour { animation: none; }
    .or-ligne, .or-regle, .or-note { animation: none; }
    .or-papier, .or-pli, .or-console, .or-indic, .or-coche, .or-fantome, .or-croix { transition: none; }
  }
</style>
