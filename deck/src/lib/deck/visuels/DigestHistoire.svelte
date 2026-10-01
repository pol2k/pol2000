<script>
  /**
   * 1936, l'histoire avant les chiffres. Peu de texte, des images d'époque :
   * les deux candidats, une vraie couverture du magazine, les enveloppes.
   * Quatre temps.
   *
   *   0  1936, la Grande Dépression. Deux portraits : Franklin D. Roosevelt,
   *      démocrate, et Alf Landon, républicain.
   *   1  À droite, une couverture du Literary Digest (16 février 1924, avec
   *      l'étiquette d'adresse d'un abonné). À gauche, son sondage a toujours
   *      prédit le gagnant : 1916, 1920, 1924, 1928, 1932, un crochet chacun.
   *   2  En 1936 : une enveloppe par million de bulletins postés (DIGEST.postes),
   *      et à qui : lecteurs, automobilistes, abonnés du téléphone (trois
   *      pictogrammes, un mot chacun).
   *   3  Votre pari : qui gagne ? Les deux portraits s'encadrent de rouge.
   *
   * Sources : Squire (1988, p. 126-127) pour les bulletins et les listes;
   * l'article « The Literary Digest » de Wikipédia (consulté le 30 septembre
   * 2026) pour le bilan depuis 1916. Le nombre de bulletins vient de DIGEST
   * (src/lib/data/seance5.js). Aucune autre donnée.
   *
   * Images (Wikimedia Commons, licences vérifiées sur les pages des fichiers
   * le 1er octobre 2026; redimensionnées, portraits passés en gris) :
   *
   *   static/img/s5-1936-roosevelt.jpg
   *     https://commons.wikimedia.org/wiki/File:Franklin_D._Roosevelt_1936_june_(3x4_cropped)_(B%26W).jpg
   *     Portrait de Franklin D. Roosevelt, 20 juin 1936. Auteur : FDR
   *     Presidential Library & Museum (Flickr 32810560620). Licence
   *     {{cc-by-2.0}}, https://creativecommons.org/licenses/by/2.0/
   *     (attribution obligatoire : d'où la ligne de crédit sous la figure).
   *
   *   static/img/s5-1936-landon.jpg
   *     https://commons.wikimedia.org/wiki/File:LandonPortr_(cropped).jpg
   *     Portrait d'Alf Landon, vers 1936. Auteur inconnu, Library of
   *     Congress, cph.3c06389. Licence {{PD-US-not renewed}}, domaine public.
   *
   *   static/img/s5-1936-digest-1924.jpg
   *     https://commons.wikimedia.org/wiki/File:TheLiteraryDigest16Feb1924.jpg
   *     Couverture du Literary Digest, 16 février 1924 (vol. 80, no 7).
   *     Auteur : The Literary Digest (tableau de F. W. Loven). Licence
   *     {{PD-1923}}, domaine public aux États-Unis (publié avant 1929).
   *     Ce n'est PAS le numéro de 1936 : la légende le dit à l'écran. Le
   *     bandeau parle d'un autre vote du magazine (sur les impôts), pas de
   *     la présidentielle.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const ANNEES = [1916, 1920, 1924, 1928, 1932];
  const MILLIONS = Math.round(DIGEST.postes / 1e6);
  const ENV = Array.from({ length: MILLIONS }, (_, i) => i);
  // Les deux candidats : portrait de 120 × 160 (3:4, comme les fichiers), nom à droite.
  const CANDIDATS = [
    { x: 40, image: 's5-1936-roosevelt.jpg', nom: 'Roosevelt', parti: 'démocrate' },
    { x: 330, image: 's5-1936-landon.jpg', nom: 'Landon', parti: 'républicain' }
  ];
</script>

<div class="visuel digest-histoire" bind:this={hote}>
  <svg viewBox="0 0 1000 510" role="img" aria-label="1936, la Grande Dépression. Franklin D. Roosevelt, démocrate, contre Alf Landon, républicain. Une couverture du Literary Digest, un magazine très lu, datée de 1924. Son sondage a toujours prédit le bon gagnant depuis 1916. En 1936, il envoie {MILLIONS} millions de bulletins par la poste, à des lecteurs, des automobilistes et des abonnés du téléphone. Votre pari : qui gagne ?">
    <!-- 0 : le contexte et les deux candidats. -->
    <text x="40" y="30" class="dh-contexte"><tspan class="dh-an-fort">1936</tspan> · la Grande Dépression</text>
    {#each CANDIDATS as c}
      <image href="{base}/img/{c.image}" x={c.x} y="48" width="120" height="160" preserveAspectRatio="xMidYMid slice" />
      <rect x={c.x} y="48" width="120" height="160" class="dh-cadre" class:dh-pari-cadre={e >= 3} />
      <text x={c.x + 132} y="122" class="dh-nom">{c.nom}</text>
      <text x={c.x + 132} y="148" class="dh-role">{c.parti}</text>
    {/each}

    <!-- 1 : le magazine et sa réputation. -->
    <g class="dh-etape" class:dh-vu={e >= 1}>
      <text x="650" y="30" class="dh-legende">Le <tspan class="dh-ital">Literary Digest</tspan>, 1924</text>
      <image href="{base}/img/s5-1936-digest-1924.jpg" x="650" y="44" width="300" height="413" preserveAspectRatio="xMidYMid slice" />
      <rect x="650" y="44" width="300" height="413" class="dh-cadre" />
      <text x="40" y="258" class="dh-titre">Son sondage&#8239;: toujours le bon gagnant</text>
      {#each ANNEES as a, i}
        <g class="dh-annee" class:dh-vu={e >= 1} style="transition-delay: {e >= 1 ? 300 + i * 220 : 0}ms">
          <text x={40 + i * 112} y="294" class="dh-an">{a}</text>
          <path d="M {104 + i * 112} 285 l 7 8 l 14 -18" class="dh-coche" />
        </g>
      {/each}
    </g>

    <!-- 2 : il voit grand. Une enveloppe par million. -->
    <g class="dh-etape" class:dh-vu={e >= 2}>
      {#each ENV as i}
        <g class="dh-env" style="transition-delay: {e >= 2 ? i * 90 : 0}ms" class:dh-vu={e >= 2}>
          <rect x={40 + i * 50} y="314" width="40" height="28" class="dh-enveloppe" />
          <path d="M {40 + i * 50} 314 L {60 + i * 50} 330 L {80 + i * 50} 314" class="dh-rabat" />
        </g>
      {/each}
      <text x="40" y="378" class="dh-titre"><tspan class="dh-rouge">{MILLIONS} millions</tspan> de bulletins par la poste</text>

      <!-- À qui : trois pictogrammes, un mot chacun. -->
      <g class="dh-picto" transform="translate(40 398)">
        <!-- un magazine -->
        <rect x="0" y="0" width="24" height="30" />
        <path d="M 5 8 h 14 M 5 14 h 14 M 5 20 h 10" />
      </g>
      <text x="74" y="422" class="dh-qui">lecteurs</text>

      <g class="dh-picto" transform="translate(192 402)">
        <!-- une automobile des années 1930 -->
        <path d="M 2 18 v -8 h 8 l 6 -9 h 16 l 6 9 h 6 v 8 z" />
        <circle cx="12" cy="20" r="5" class="dh-roue" />
        <circle cx="34" cy="20" r="5" class="dh-roue" />
      </g>
      <text x="246" y="422" class="dh-qui">autos</text>

      <g class="dh-picto" transform="translate(330 394)">
        <!-- un téléphone chandelier -->
        <path d="M 6 34 L 11 28 H 21 L 26 34 Z M 16 28 V 9 M 16 9 L 8 4 V 14 Z M 16 14 H 24" />
        <rect x="24" y="11" width="6" height="16" />
      </g>
      <text x="370" y="422" class="dh-qui">téléphones</text>
    </g>

    <!-- 3 : le pari. -->
    <text x="500" y="496" class="dh-pari dh-etape" class:dh-vu={e >= 3}>Votre pari&#8239;: qui gagne&#8239;?</text>
  </svg>
  <p class="dh-credit">Images&#8239;: Wikimedia Commons · Roosevelt, FDR Presidential Library &amp; Museum, CC BY 2.0 · Landon et couverture, domaine public</p>
</div>

<style>
  .digest-histoire { display: flex; flex-direction: column; align-items: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .dh-contexte { font-size: 22px; fill: var(--dk-gris); }
  .dh-an-fort { font-weight: 700; fill: var(--dk-encre); }
  .dh-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 2; transition: stroke 0.4s, stroke-width 0.4s; }
  .dh-cadre.dh-pari-cadre { stroke: var(--dk-accent); stroke-width: 4; }
  .dh-nom { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .dh-role { font-size: 17px; fill: var(--dk-gris); }
  .dh-legende { font-size: 18px; fill: var(--dk-gris); }
  .dh-titre { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .dh-ital { font-style: italic; }
  .dh-rouge { fill: var(--dk-accent); font-weight: 700; }
  .dh-an { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .dh-coche { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .dh-annee, .dh-env { opacity: 0; transition: opacity 0.3s; }
  .dh-annee.dh-vu, .dh-env.dh-vu { opacity: 1; }
  .dh-enveloppe { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .dh-rabat { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .dh-picto rect, .dh-picto path { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .dh-picto .dh-roue { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .dh-qui { font-size: 18px; fill: var(--dk-gris); }
  .dh-pari { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .dh-etape { opacity: 0; transition: opacity 0.3s; }
  .dh-etape.dh-vu { opacity: 1; transition: opacity 0.6s; }
  .dh-credit { margin: 0.3em 0 0; font-family: var(--dk-mono); font-size: 0.45em; line-height: 1.3; color: var(--dk-gris-2); text-align: center; }
  @media (prefers-reduced-motion: reduce) {
    .dh-etape, .dh-etape.dh-vu, .dh-annee, .dh-env, .dh-cadre { transition: none; }
  }
</style>
