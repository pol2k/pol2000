<script>
  /**
   * Ce que le modèle met de côté : la figure 5.5 d'Arel-Bundock (2021),
   * redessinée. Chaque cercle est la variation d'une variable. Là où deux
   * cercles se recoupent, les deux variables varient ensemble.
   *
   *   0  l'intérêt et la scolarité : leur part commune, en rouge pâle
   *      (c'est la pente de la régression simple);
   *   1  l'âge entre en scène, il touche les deux;
   *   2  la part que la scolarité partage avec l'âge, hachurée : le modèle
   *      la met de côté, il ne sait pas à qui l'attribuer;
   *   3  ce qui reste, en rouge plein : la part de la scolarité à elle, qui
   *      touche l'intérêt. Le coefficient « à âge égal » vient de là.
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
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const Y = { x: 640, y: 250, r: 175 };
  const X1 = { x: 400, y: 165, r: 150 };
  const X2 = { x: 400, y: 340, r: 150 };
</script>

<div class="visuel m8v" bind:this={hote}>
  <svg viewBox="0 0 1000 520" role="img" aria-label="Trois cercles : l'intérêt, la scolarité et l'âge. La part que la scolarité partage avec l'âge est mise de côté. Le coefficient de la scolarité vient de la part qui lui est propre et qui touche l'intérêt.">
    <defs>
      <clipPath id="m8v-x1"><circle cx={X1.x} cy={X1.y} r={X1.r} /></clipPath>
      <clipPath id="m8v-x2"><circle cx={X2.x} cy={X2.y} r={X2.r} /></clipPath>
      <mask id="m8v-sans-x2">
        <rect x="0" y="0" width="1000" height="520" fill="#fff" />
        <circle cx={X2.x} cy={X2.y} r={X2.r} fill="#000" />
      </mask>
      <pattern id="m8v-hach" width="14" height="14" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
        <rect width="14" height="14" fill="#eeeee9" />
        <line x1="0" y1="0" x2="0" y2="14" stroke="#5c6367" stroke-width="5" />
      </pattern>
    </defs>

    <!-- 0 : intérêt ∩ scolarité, pâle (simple) -->
    <circle cx={Y.x} cy={Y.y} r={Y.r} clip-path="url(#m8v-x1)" class="pale" class:efface={e >= 3} />
    <!-- 3 : la part propre de la scolarité qui touche l'intérêt -->
    <g mask="url(#m8v-sans-x2)">
      <circle cx={Y.x} cy={Y.y} r={Y.r} clip-path="url(#m8v-x1)" class="propre etape" class:vu={e >= 3} />
    </g>
    <!-- 2 : scolarité ∩ âge, hachurée -->
    <circle cx={X2.x} cy={X2.y} r={X2.r} clip-path="url(#m8v-x1)" fill="url(#m8v-hach)" class="etape" class:vu={e >= 2} />

    <circle cx={Y.x} cy={Y.y} r={Y.r} class="trait" />
    <circle cx={X1.x} cy={X1.y} r={X1.r} class="trait" />
    <g class="etape" class:vu={e >= 1}><circle cx={X2.x} cy={X2.y} r={X2.r} class="trait" /></g>

    <text x={Y.x + 30} y={Y.y + 8} class="nom">intérêt</text>
    <text x={X1.x - 100} y={X1.y - 40} class="nom">scolarité</text>
    <g class="etape" class:vu={e >= 1}><text x={X2.x - 100} y={X2.y + 70} class="nom">âge</text></g>

    <g class="etape" class:vu={e === 0}>
      <line x1="520" y1="200" x2="640" y2="60" class="fleche" />
      <text x="650" y="56" class="note">le lien de la régression simple</text>
    </g>
    <g class="etape" class:vu={e >= 2}>
      <line x1="300" y1="252" x2="120" y2="252" class="fleche" />
      <text x="0" y="230" class="note">mis de côté</text>
      <text x="0" y="290" class="petit">ce que les deux</text>
      <text x="0" y="314" class="petit">partagent</text>
    </g>
    <g class="etape" class:vu={e >= 3}>
      <line x1="530" y1="165" x2="700" y2="60" class="fleche rouge-l" />
      <text x="706" y="52" class="note rouge">le coefficient « à âge égal »</text>
      <text x="706" y="80" class="petit">vient d'ici seulement</text>
    </g>

    <text x="0" y="514" class="source">Un schéma, pas des données · d'après Arel-Bundock (2021), figure 5.5</text>
  </svg>
</div>

<style>
  .m8v { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }
  .trait { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .pale { fill: var(--dk-accent); opacity: 0.25; transition: opacity 0.4s; }
  .pale.efface { opacity: 0; }
  .propre { fill: var(--dk-accent); }
  .nom { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .note { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .fin-g { text-anchor: start; }
  .petit { font-size: 19px; fill: var(--dk-gris); }
  .rouge { fill: var(--dk-accent); }
  .fleche { stroke: var(--dk-encre); stroke-width: 2.5; }
  .rouge-l { stroke: var(--dk-accent); }
  .source { font-size: 15px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .etape, .pale { transition: none; } }
</style>
