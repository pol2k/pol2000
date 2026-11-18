<script>
  /**
   * Condition 2 : fermer les chemins par la porte arrière (Arel-Bundock
   * 2021, p. 125-126), avec son exemple : l'éclatement familial,
   * l'itinérance et la santé mentale. Le chemin par la porte arrière est
   * dessiné pour vrai : un plan de maison.
   *
   *   0  le plan : la pièce de la cause (éclatement familial), la pièce de
   *      l'effet (itinérance), et, derrière, la santé mentale;
   *   1  la porte d'en avant : l'effet qu'on cherche passe d'une pièce à
   *      l'autre (points d'encre, de la cause vers l'effet);
   *   2  la porte arrière : la santé mentale entre dans les deux pièces
   *      (points rouges). Une partie du lien entre les deux pièces passe
   *      par là;
   *   3  on verrouille : contrôler la santé mentale. Le cadenas, le cadre
   *      rouge; les points rouges s'arrêtent à la porte. Il ne reste que la
   *      porte d'en avant.
   *
   * Schéma, aucune donnée. Les points : Flux.svelte, comme à la séance 8.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const AVANT = 'M 380 440 L 820 440';
  const ARR_X = 'M 520 200 C 470 250 420 300 330 380';
  const ARR_Y = 'M 680 200 C 730 250 780 300 870 380';
  const LEG = [
    'Trois pièces. On veut l’effet de l’éclatement familial sur l’itinérance.',
    'La porte d’en avant : l’effet qu’on cherche.',
    'La porte arrière : la santé mentale entre dans les deux pièces.',
    'Contrôler la santé mentale : on verrouille la porte arrière.'
  ];
</script>

<div class="visuel m11m" bind:this={hote}>
  <svg viewBox="0 0 1200 600" role="img" aria-label="Un plan de maison. L’éclatement familial et l’itinérance sont deux pièces reliées par une porte d’en avant. Derrière, la santé mentale ouvre sur les deux pièces : une porte arrière. Contrôler la santé mentale, c’est la verrouiller.">
    <!-- les pièces -->
    <rect x="410" y="40" width="380" height="160" class="piece" class:arriere={e >= 2} />
    <text x="600" y="132" class="nom" class:rouge={e >= 2}>Santé mentale</text>
    <rect x="80" y="300" width="440" height="250" class="piece" />
    <text x="300" y="520" class="nom">Éclatement familial</text>
    <rect x="680" y="300" width="440" height="250" class="piece" />
    <text x="900" y="520" class="nom">Itinérance</text>

    <!-- le couloir et la porte d'en avant -->
    <rect x="520" y="405" width="160" height="70" class="couloir" />
    <line x1="520" y1="407" x2="520" y2="473" class="ouverture" />
    <line x1="680" y1="407" x2="680" y2="473" class="ouverture" />
    <text x="600" y="508" class="porte petit" class:vu={e >= 1}>porte</text>
    <text x="600" y="534" class="porte petit" class:vu={e >= 1}>d’en avant</text>

    <!-- les portes arrière -->
    <line x1="470" y1="300" x2="400" y2="300" class="ouverture" />
    <line x1="730" y1="300" x2="800" y2="300" class="ouverture" />
    <line x1="500" y1="200" x2="540" y2="200" class="ouverture" />
    <line x1="660" y1="200" x2="700" y2="200" class="ouverture" />
    <text x="250" y="250" class="porte rouge" class:vu={e >= 2}>porte arrière</text>
    <text x="950" y="250" class="porte rouge" class:vu={e >= 2}>porte arrière</text>

    <!-- les passages -->
    <path d={AVANT} class="passage" class:vu={e >= 1} />
    <path d={ARR_X} class="passage rouge" class:vu={e >= 2} />
    <path d={ARR_Y} class="passage rouge" class:vu={e >= 2} />
    <Flux d={AVANT} actif={e >= 1} n={3} duree={4} r={9} />
    <Flux d={ARR_X} actif={e >= 2} arret={e >= 3 ? 0.08 : 1} rouge n={2} duree={2.6} r={9} />
    <Flux d={ARR_Y} actif={e >= 2} arret={e >= 3 ? 0.08 : 1} rouge n={2} duree={2.6} r={9} />

    <!-- le verrou -->
    <g class="verrou" class:vu={e >= 3}>
      <rect x="396" y="26" width="408" height="188" class="cadre" />
      <path d="M 588 214 L 588 196 C 588 178 612 178 612 196 L 612 214" class="anse" />
      <rect x="578" y="212" width="44" height="36" class="corps" />
    </g>
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="cap">D’après Arel-Bundock (2021), p. 126 · schéma, aucune donnée</p>
</div>

<style>
  .m11m { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.25em; }
  svg { width: 100%; max-width: 50em; height: auto; max-height: 56vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .piece { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 9; transition: stroke 0.4s; }
  .piece.arriere { stroke: var(--dk-accent); }
  .couloir { fill: var(--dk-fond-2); }
  .ouverture { stroke: var(--dk-fond); stroke-width: 12; }
  .nom { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .nom.rouge { fill: var(--dk-accent); }
  .porte { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .porte.rouge { fill: var(--dk-accent); }
  .porte.petit { font-size: 22px; }
  .porte.vu { opacity: 1; }
  .passage { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-dasharray: 4 12; opacity: 0; transition: opacity 0.4s; }
  .passage.rouge { stroke: var(--dk-accent); }
  .passage.vu { opacity: 0.6; }
  .verrou { opacity: 0; transition: opacity 0.4s; }
  .verrou.vu { opacity: 1; }
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 6; }
  .anse { fill: none; stroke: var(--dk-accent); stroke-width: 8; }
  .corps { fill: var(--dk-accent); }
  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .piece, .porte, .passage, .verrou { transition: none; } }
</style>
