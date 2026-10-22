<script>
  /**
   * Ce que le modèle met de côté : la figure 5.5 d'Arel-Bundock (2021),
   * redessinée et montée lentement, une idée par clic. Chaque cercle est la
   * variation d'une variable. Là où deux cercles se recoupent, les deux
   * variables varient ensemble.
   *
   *   0  l'intérêt seul : il varie d'une personne à l'autre;
   *   1  la scolarité se pose dessus : leur part commune, en rouge pâle,
   *      c'est ce que voit la régression simple;
   *   2  l'âge arrive, il touche les deux;
   *   3  la zone commune aux trois, en noir : à qui l'attribuer ?
   *   4  le modèle met de côté tout ce que la scolarité partage avec l'âge
   *      (hachuré). Ce qui reste en rouge plein, c'est la part propre de la
   *      scolarité qui touche l'intérêt : le coefficient « à âge égal ».
   *
   * Pourquoi pas « ce que la pente simple attribuait à tort » : dans la CES,
   * la pente monte quand on tient l'âge constant (TRANCHES : 0,17 seule,
   * 0,19 à âge égal; la diapositive précédente le montre). Un diagramme de
   * Venn ne sait pas dessiner un effet masqué. Il montre donc quelle
   * variation le modèle utilise, pas dans quel sens le chiffre bouge.
   *
   * Un schéma, pas des données : la taille des cercles et des recoupements
   * ne mesure rien.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const W = 1000, H = 540;
  const Y = { x: 545, y: 270, r: 160 };   // intérêt
  const S = { x: 360, y: 185, r: 125 };   // scolarité
  const A = { x: 360, y: 355, r: 125 };   // âge
  const rot = (c) => `rotate(-90 ${c.x} ${c.y})`;
</script>

<div class="visuel m8v" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Trois cercles : l'intérêt, la scolarité et l'âge. La part commune à l'intérêt et à la scolarité est ce que voit la régression simple. L'âge touche les deux. Le modèle met de côté ce que la scolarité partage avec l'âge. Le coefficient à âge égal vient de la part propre de la scolarité qui touche l'intérêt.">
    <defs>
      <clipPath id="m8v-s"><circle cx={S.x} cy={S.y} r={S.r} /></clipPath>
      <clipPath id="m8v-a"><circle cx={A.x} cy={A.y} r={A.r} /></clipPath>
      <clipPath id="m8v-y"><circle cx={Y.x} cy={Y.y} r={Y.r} /></clipPath>
      <mask id="m8v-sans-a">
        <rect x="0" y="0" width={W} height={H} fill="#fff" />
        <circle cx={A.x} cy={A.y} r={A.r} fill="#000" />
      </mask>
      <pattern id="m8v-hach" width="14" height="14" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
        <rect width="14" height="14" class="hach-fond" />
        <line x1="0" y1="0" x2="0" y2="14" class="hach-trait" />
      </pattern>
    </defs>

    <!-- 1 à 3 : intérêt ∩ scolarité, rouge pâle (la régression simple) -->
    <circle cx={Y.x} cy={Y.y} r={Y.r} clip-path="url(#m8v-s)" class="pale etape" class:vu={e >= 1 && e < 4} />
    <!-- 4 : la part propre de la scolarité qui touche l'intérêt -->
    <g mask="url(#m8v-sans-a)">
      <circle cx={Y.x} cy={Y.y} r={Y.r} clip-path="url(#m8v-s)" class="propre etape" class:vu={e >= 4} />
    </g>
    <!-- 3 : la zone commune aux trois -->
    <g clip-path="url(#m8v-s)">
      <circle cx={Y.x} cy={Y.y} r={Y.r} clip-path="url(#m8v-a)" class="trois etape" class:vu={e === 3} />
    </g>
    <!-- 4 : scolarité ∩ âge, hachurée -->
    <circle cx={A.x} cy={A.y} r={A.r} clip-path="url(#m8v-s)" fill="url(#m8v-hach)" class="etape" class:vu={e >= 4} />

    <!-- les cercles, qui se dessinent -->
    <circle cx={Y.x} cy={Y.y} r={Y.r} class="trait" />
    <circle cx={S.x} cy={S.y} r={S.r} transform={rot(S)} pathLength="1" class="trait trace" class:vu={e >= 1} />
    <circle cx={A.x} cy={A.y} r={A.r} transform={rot(A)} pathLength="1" class="trait trace" class:vu={e >= 2} />

    <!-- les noms -->
    <text x={Y.x + 58} y={Y.y + 10} class="nom mil">intérêt</text>
    <text x={S.x - 92} y={S.y - 48} class="nom etape" class:vu={e >= 1}>scolarité</text>
    <text x={A.x - 92} y={A.y + 70} class="nom etape" class:vu={e >= 2}>âge</text>

    <!-- 0 : l'intérêt varie -->
    <g class="etape" class:vu={e >= 0}>
      <line x1={Y.x + 118} y1={Y.y + 109} x2="738" y2="452" class="fleche" />
      <text x="748" y="452" class="note">varie d’une</text>
      <text x="748" y="482" class="note">personne à l’autre</text>
    </g>

    <!-- 1 à 3 : la part commune -->
    <g class="etape" class:vu={e >= 1 && e < 4}>
      <line x1="445" y1="168" x2="738" y2="92" class="fleche" />
      <circle cx="445" cy="168" r="6" class="bout" />
      <text x="748" y="86" class="fort">la part commune</text>
      <text x="748" y="118" class="note">la régression simple</text>
    </g>

    <!-- 3 : à qui l'attribuer ? -->
    <g class="etape" class:vu={e === 3}>
      <line x1="420" y1="270" x2="222" y2="270" class="fleche" />
      <circle cx="420" cy="270" r="6" class="bout clair" />
      <text x="212" y="262" class="fort fin">à qui</text>
      <text x="212" y="294" class="fort fin">l’attribuer&#8239;?</text>
    </g>

    <!-- 4 : mis de côté, et ce qui reste -->
    <g class="etape" class:vu={e >= 4}>
      <line x1="300" y1="270" x2="222" y2="270" class="fleche" />
      <circle cx="300" cy="270" r="6" class="bout" />
      <text x="212" y="262" class="fort fin">mis de côté</text>
      <text x="212" y="292" class="note fin">partagé avec l’âge</text>

      <line x1="445" y1="168" x2="738" y2="92" class="fleche" />
      <circle cx="445" cy="168" r="6" class="bout clair" />
      <text x="748" y="86" class="fort rouge">à âge égal</text>
      <text x="748" y="118" class="note">le coefficient</text>
      <text x="748" y="146" class="note">de la scolarité</text>
    </g>

    <text x="0" y={H - 6} class="source">Un schéma, pas des données · d’après Arel-Bundock (2021), figure 5.5</text>
  </svg>
</div>

<style>
  .m8v { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  text { font-family: var(--dk-mono); }
  .trait { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .trace { stroke-dasharray: 1 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .trace.vu { stroke-dashoffset: 0; }
  .pale { fill: var(--dk-accent); fill-opacity: 0.22; }
  .propre { fill: var(--dk-accent); }
  .trois { fill: var(--dk-encre); }
  .hach-fond { fill: var(--dk-fond-2); }
  .hach-trait { stroke: var(--dk-gris-2); stroke-width: 5; }
  .nom { font-size: 32px; font-weight: 700; fill: var(--dk-encre); }
  .fort { font-size: 28px; font-weight: 700; fill: var(--dk-encre); }
  .note { font-size: 23px; fill: var(--dk-gris); }
  .fin { text-anchor: end; }
  .rouge { fill: var(--dk-accent); }
  .fleche { stroke: var(--dk-encre); stroke-width: 2; }
  .bout { fill: var(--dk-encre); }
  .bout.clair { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .mil { text-anchor: middle; }
  .source { font-size: 18px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.45s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) {
    .etape, .trace { transition: none; }
  }
</style>
