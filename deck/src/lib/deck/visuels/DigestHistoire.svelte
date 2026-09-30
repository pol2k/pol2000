<script>
  /**
   * 1936, l'histoire avant les chiffres. Le contexte, le magazine et sa
   * réputation, le pari. Quatre temps.
   *
   *   0  1936, la Grande Dépression. Deux candidats : Franklin D. Roosevelt,
   *      démocrate, président sortant; Alf Landon, républicain, gouverneur du
   *      Kansas.
   *   1  Le Literary Digest, un magazine très lu. Depuis 1916, son sondage a
   *      toujours prédit le gagnant : 1916, 1920, 1924, 1928, 1932, un crochet
   *      chacun.
   *   2  En 1936, il voit grand : 10 millions de bulletins par la poste, à ses
   *      lecteurs, aux propriétaires d'automobiles, aux abonnés du téléphone.
   *   3  Votre pari : qui gagne ?
   *
   * Sources : Squire (1988, p. 126-127) pour les bulletins et les listes;
   * l'article « The Literary Digest » de Wikipédia (consulté le 30 septembre
   * 2026) pour le bilan depuis 1916. Le nombre de bulletins vient de DIGEST
   * (src/lib/data/seance5.js). Schéma, aucune autre donnée.
   */
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
</script>

<div class="visuel digest-histoire" bind:this={hote}>
  <svg viewBox="0 0 1000 480" role="img" aria-label="1936, la Grande Dépression. Franklin D. Roosevelt, démocrate et président sortant, contre Alf Landon, républicain. Le Literary Digest, un magazine très lu, a prédit le bon gagnant à chaque élection depuis 1916. En 1936, il envoie {MILLIONS} millions de bulletins par la poste. Votre pari : qui gagne ?">
    <!-- 0 : le contexte. -->
    <text x="40" y="40" class="dh-contexte">1936 · les États-Unis en pleine Grande Dépression</text>
    <g class="dh-carte">
      <rect x="40" y="62" width="410" height="92" class="dh-cadre" />
      <text x="62" y="100" class="dh-nom">Franklin D. Roosevelt</text>
      <text x="62" y="132" class="dh-role">démocrate · président sortant</text>
    </g>
    <text x="500" y="116" class="dh-contre">contre</text>
    <g class="dh-carte">
      <rect x="550" y="62" width="410" height="92" class="dh-cadre" />
      <text x="572" y="100" class="dh-nom">Alf Landon</text>
      <text x="572" y="132" class="dh-role">républicain · gouverneur du Kansas</text>
    </g>

    <!-- 1 : la réputation. -->
    <g class="dh-etape" class:dh-vu={e >= 1}>
      <text x="40" y="204" class="dh-titre">Le <tspan class="dh-ital">Literary Digest</tspan>, un magazine très lu. Son sondage ne s’est jamais trompé&#8239;:</text>
      {#each ANNEES as a, i}
        <g class="dh-annee" class:dh-vu={e >= 1} style="transition-delay: {e >= 1 ? 300 + i * 220 : 0}ms">
          <text x={90 + i * 190} y="246" class="dh-an">{a}</text>
          <path d="M {150 + i * 190} 234 l 8 9 l 16 -20" class="dh-coche" />
        </g>
      {/each}
    </g>

    <!-- 2 : il voit grand. -->
    <g class="dh-etape" class:dh-vu={e >= 2}>
      <text x="40" y="306" class="dh-titre">En 1936, il voit grand&#8239;: <tspan class="dh-rouge">{MILLIONS} millions</tspan> de bulletins par la poste.</text>
      {#each ENV as i}
        <g class="dh-env" style="transition-delay: {e >= 2 ? i * 90 : 0}ms" class:dh-vu={e >= 2}>
          <rect x={40 + i * 50} y="324" width="40" height="28" class="dh-enveloppe" />
          <path d="M {40 + i * 50} 324 L {60 + i * 50} 340 L {80 + i * 50} 324" class="dh-rabat" />
        </g>
      {/each}
      <text x="560" y="344" class="dh-listes">à ses lecteurs, aux propriétaires</text>
      <text x="560" y="368" class="dh-listes">d’automobiles, aux abonnés du téléphone</text>
    </g>

    <!-- 3 : le pari. -->
    <text x="500" y="448" class="dh-pari dh-etape" class:dh-vu={e >= 3}>Votre pari&#8239;: qui gagne&#8239;?</text>
  </svg>
</div>

<style>
  .digest-histoire { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .dh-contexte { font-size: 22px; fill: var(--dk-gris); }
  .dh-cadre { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2.5; }
  .dh-nom { font-size: 27px; font-weight: 700; fill: var(--dk-encre); }
  .dh-role { font-size: 17px; fill: var(--dk-gris); }
  .dh-contre { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .dh-titre { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .dh-ital { font-style: italic; }
  .dh-rouge { fill: var(--dk-accent); }
  .dh-an { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .dh-coche { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .dh-annee, .dh-env { opacity: 0; transition: opacity 0.3s; }
  .dh-annee.dh-vu, .dh-env.dh-vu { opacity: 1; }
  .dh-enveloppe { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .dh-rabat { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .dh-listes { font-size: 18px; fill: var(--dk-gris); }
  .dh-pari { font-size: 34px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .dh-etape { opacity: 0; transition: opacity 0.3s; }
  .dh-etape.dh-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .dh-etape, .dh-etape.dh-vu, .dh-annee, .dh-env { transition: none; }
  }
</style>
