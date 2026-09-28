<script>
  /**
   * Le seuil de 0,05. Un axe des valeurs p, sur une échelle logarithmique de
   * 0,0001 à 1 (chaque graduation est dix fois la précédente, pour que les
   * petites valeurs aient de la place). Le seuil coupe l'axe en deux zones.
   *
   *   0  La ligne rouge du seuil et ses deux zones : à gauche, on rejette H₀
   *      (statistiquement significatif), à droite, on ne rejette pas H₀.
   *   1  La pomicultrice : un point rouge à sa valeur p, juste à gauche du
   *      seuil.
   *   2  Les étoiles qu'on lit dans les tableaux de résultats, alignées sur
   *      leurs seuils : * sous 0,05, ** sous 0,01, *** sous 0,001.
   *   3  Une note : 0,05 est une convention arbitraire (Fisher, 1926, cité
   *      dans Arel-Bundock 2021, p. 71).
   *
   * La valeur p de la pomicultrice vient de POMMES.p. Les seuils (0,05,
   * 0,01, 0,001) sont des conventions, pas des données : ils sont écrits ici.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 4 });
  // Échelle logarithmique : 0,0001 à gauche, 1 à droite.
  const X = (p) => 80 + ((Math.log10(p) + 4) / 4) * 840;
  const SEUIL = 0.05; // la convention
  const XS = X(SEUIL);
  const XP = X(POMMES.p);
  const YA = 236;
  const TICKS = [0.001, 0.01, 0.05, 0.1, 1];
  const ETOILES = [
    { seuil: 0.05, etoiles: '*' },
    { seuil: 0.01, etoiles: '**' },
    { seuil: 0.001, etoiles: '***' }
  ];
  const rejette = POMMES.p < SEUIL;
</script>

<div class="visuel seuil" bind:this={hote}>
  <svg viewBox="0 0 1000 456" role="img" aria-label="Un axe des valeurs p, de 0,0001 à 1, sur une échelle logarithmique. Une ligne rouge à 0,05&#8239;: à gauche, on rejette H₀, c’est statistiquement significatif. À droite, on ne rejette pas H₀. La pomicultrice est à {fr(POMMES.p)}, {rejette ? 'juste à gauche' : 'à droite'} du seuil. Une étoile sous 0,05, deux sous 0,01, trois sous 0,001. 0,05 est une convention arbitraire (Fisher, 1926).">
    <!-- Les deux zones. -->
    <rect x="80" y="44" width={XS - 80} height="130" class="sl-zone" />
    <text x={(80 + XS) / 2} y="102" class="sl-zone-t">on rejette H₀</text>
    <text x={(80 + XS) / 2} y="138" class="sl-zone-s">statistiquement significatif</text>
    <text x={(XS + 920) / 2} y="102" class="sl-zone-t">on ne rejette</text>
    <text x={(XS + 920) / 2} y="134" class="sl-zone-t">pas H₀</text>

    <!-- L'axe des p. -->
    <line x1="80" y1={YA} x2="920" y2={YA} class="sl-axe" />
    {#each TICKS as t}
      <line x1={X(t)} y1={YA} x2={X(t)} y2={YA + 8} class="sl-axe" />
      <text x={X(t)} y={YA + 32} class="sl-tick" class:sl-tick-s={t === SEUIL}>{fr(t)}</text>
    {/each}
    <text x="940" y={YA + 7} class="sl-nom">p</text>

    <!-- Le seuil. -->
    <line x1={XS} y1="34" x2={XS} y2={YA} class="sl-seuil" />

    <!-- Temps 1 : la pomicultrice. -->
    <g class="sl-pom" class:sl-vu={e >= 1}>
      <text x={XP - 18} y={YA - 16} class="sl-pom-t">la pomicultrice&#8239;: {fr(POMMES.p)}</text>
      <circle cx={XP} cy={YA} r="10" class="sl-point" />
    </g>

    <!-- Temps 2 : les étoiles, alignées sur leurs seuils. -->
    <g class="sl-et" class:sl-vu={e >= 2}>
      {#each ETOILES as s, i}
        {@const y = YA + 76 + i * 36}
        <g class="sl-rang" style="transition-delay: {e >= 2 ? i * 150 : 0}ms">
          <line x1="80" y1={y} x2={X(s.seuil)} y2={y} class="sl-barre" />
          <line x1={X(s.seuil)} y1={y - 10} x2={X(s.seuil)} y2={y + 10} class="sl-barre" />
          <text x={X(s.seuil) + 12} y={y + 8} class="sl-etoiles">{s.etoiles}<tspan class="sl-cond" dx="14">p &lt; {fr(s.seuil)}</tspan></text>
        </g>
      {/each}
    </g>

    <!-- Temps 3 : la note. -->
    <g class="sl-note" class:sl-vu={e >= 3}>
      <text x="80" y="424" class="sl-note-t">0,05&#8239;: une convention arbitraire</text>
      <text x="80" y="450" class="sl-note-s">(Fisher, 1926, cité dans Arel-Bundock 2021, p.&#8239;71)</text>
    </g>
  </svg>
</div>

<style>
  .seuil { display: flex; flex-direction: column; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .sl-zone { fill: var(--dk-fond-2); }
  .sl-zone-t { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .sl-zone-s { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .sl-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .sl-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .sl-tick-s { fill: var(--dk-accent); font-weight: 600; }
  .sl-nom { font-size: 22px; font-style: italic; fill: var(--dk-gris); }
  .sl-seuil { stroke: var(--dk-accent); stroke-width: 4; }

  .sl-pom { opacity: 0; transition: opacity 0.3s; }
  .sl-pom.sl-vu { opacity: 1; }
  .sl-pom-t { font-size: 21px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .sl-point { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; transform-box: fill-box; transform-origin: center; transform: scale(0); transition: transform 0.45s cubic-bezier(0.34, 1.8, 0.64, 1); }
  .sl-pom.sl-vu .sl-point { transform: scale(1); }

  .sl-rang { opacity: 0; transition: opacity 0.3s; }
  .sl-et.sl-vu .sl-rang { opacity: 1; transition: opacity 0.4s; }
  .sl-barre { stroke: var(--dk-encre); stroke-width: 3; }
  .sl-etoiles { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .sl-cond { font-size: 20px; font-weight: 400; fill: var(--dk-gris); }

  .sl-note { opacity: 0; transition: opacity 0.3s; }
  .sl-note.sl-vu { opacity: 1; transition: opacity 0.5s; }
  .sl-note-t { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .sl-note-s { font-size: 18px; fill: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .sl-pom, .sl-point, .sl-pom.sl-vu .sl-point, .sl-rang, .sl-et.sl-vu .sl-rang, .sl-note, .sl-note.sl-vu { transition: none; }
  }
</style>
