<script>
  /**
   * Les étoiles de R. En haut, ce que R imprime : l'en-tête et la ligne
   * scolarite de summary(), pour notre sondage (SUMMARY) et pour le
   * sondage de 50 (SORTIES.summary50), puis la légende « Signif. codes »,
   * telles quelles. En bas, la légende décodée sur un axe des valeurs p.
   * Trois temps.
   *
   *   0  Les deux sorties et la légende. La colonne p et les étoiles de
   *      chaque ligne sont encadrées en rouge : ***, et un simple point.
   *   1  L'axe des p (échelle logarithmique de 0,0001 à 1 : chaque
   *      graduation vaut dix fois la précédente). La ligne rouge de 0,05
   *      coupe l'axe en deux zones : à gauche, on rejette H0
   *      (« statistiquement significatif »), à droite, non. Sous l'axe, les
   *      codes de la légende, chacun dans sa tranche. 0,05 est une
   *      convention (Fisher, 1926, cité dans Arel-Bundock 2021, p. 71).
   *   2  Les deux sondages sur l'axe : le nôtre bien plus à gauche que
   *      l'axe (3.87e-10, une flèche), celui de 50 à 0,078, à droite de
   *      0,05. Le point de R : sous 0,1 mais pas sous 0,05, donc pas
   *      significatif.
   *
   * Les seuils (0,001, 0,01, 0,05, 0,1) sont ceux de la légende de R, des
   * conventions : ils sont écrits ici. La valeur p du sondage de 50 vient de
   * H0.cinquante.coefs[1].p.
   */
  import { brancherTemps } from '../temps.js';
  import { SUMMARY, H0 } from '$lib/data/seance7.js';
  import { SORTIES } from '$lib/data/seance7_f.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const fr = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 4 });
  const N = ' ';

  // Les lignes de R, découpées dans les sorties (rien n'est retapé).
  const morceaux = (txt) => {
    const l = txt.split('\n');
    return {
      entete: l.find((s) => /^\s+Estimate/.test(s)).trimEnd(),
      rang: l.find((s) => s.startsWith('scolarite')).trimEnd(),
      legende: l.find((s) => s.startsWith('Signif. codes')).trimEnd()
    };
  };
  const A = morceaux(SUMMARY), B = morceaux(SORTIES.summary50);
  // Où commence la colonne p dans une ligne (5e champ), et jusqu'où vont les étoiles.
  const colP = (rang) => {
    const p = rang.trim().split(/\s+/)[4];
    return { debut: rang.indexOf(p), fin: rang.length };
  };
  const FS = 19, CH = 0.6 * FS, XR = 60;
  const BLOCS = [
    { qui: 'notre sondage', l: A, y: 42 },
    { qui: 'sondage de 50', l: B, y: 104 }
  ];

  // L'axe des p : 0,0001 à gauche, 1 à droite.
  const X = (p) => 80 + ((Math.log10(p) + 4) / 4) * 840;
  const SEUIL = 0.05;
  const XS = X(SEUIL);
  const YA = 304;
  const TICKS = [0.001, 0.01, 0.05, 0.1, 1];
  // Les codes de la légende de R, chacun entre ses deux bornes.
  const CODES = [
    { de: 0.0001, a: 0.001, c: '***' },
    { de: 0.001, a: 0.01, c: '**' },
    { de: 0.01, a: 0.05, c: '*' },
    { de: 0.05, a: 0.1, c: '.' },
    { de: 0.1, a: 1, c: 'rien' }
  ];
  const P50 = H0.cinquante.coefs[1].p;
  const X50 = X(P50);
</script>

<div class="visuel pente-etoiles" bind:this={hote}>
  <svg viewBox="0 0 1000 480" role="img" aria-label="Ce que R imprime{N}: notre sondage, p pratiquement 0, trois étoiles. Le sondage de 50, p = {fr(P50)}, un point. La légende{N}: trois étoiles sous 0,001, deux sous 0,01, une sous 0,05, un point sous 0,1. À gauche de 0,05, on rejette H0{N}: statistiquement significatif. Le point veut dire sous 0,1 mais pas sous 0,05{N}: pas significatif.">
    <!-- 0 : ce que R imprime. -->
    <rect x={XR - 22} y="10" width="924" height="172" class="et-console" />
    {#each BLOCS as b}
      {@const c = colP(b.l.rang)}
      <text x={XR} y={b.y} class="et-r">{b.l.entete}</text>
      <text x={XR} y={b.y + 26} class="et-r et-rang">{b.l.rang}</text>
      <rect x={XR + c.debut * CH - 6} y={b.y + 7} width={(c.fin - c.debut) * CH + 12} height="27" class="et-cible" />
      <text x="924" y={b.y + 26} class="et-qui">{b.qui}</text>
    {/each}
    <text x={XR} y="166" class="et-r et-legende">{A.legende}</text>

    <!-- 1 : la légende, décodée sur l'axe des p. -->
    <g class="et-etape" class:et-vu={e >= 1}>
      <rect x="80" y="200" width={XS - 80} height="66" class="et-zone" />
      <text x={(80 + XS) / 2} y="228" class="et-zone-t">on rejette H0</text>
      <text x={(80 + XS) / 2} y="255" class="et-zone-s">«&#8239;statistiquement significatif&#8239;»</text>
      <text x={XS + 24} y="240" class="et-zone-t et-zone-d">on ne rejette pas H0</text>
      <line x1={XS} y1="200" x2={XS} y2={YA} class="et-seuil" />
      <text x={XS - 8} y="196" class="et-conv">0,05&#8239;: une convention</text>
      {#each CODES as k, i}
        <text x={(X(k.de) + X(k.a)) / 2} y={YA + 66} class="et-code" class:et-mot={k.c === 'rien'} style="transition-delay: {e >= 1 ? i * 120 : 0}ms">{k.c}</text>
      {/each}
    </g>
    <line x1="80" y1={YA} x2="920" y2={YA} class="et-axe" />
    {#each TICKS as t}
      <line x1={X(t)} y1={YA} x2={X(t)} y2={YA + 8} class="et-axe" />
      <text x={X(t)} y={YA + 30} class="et-tick" class:et-tick-s={t === SEUIL}>{fr(t)}</text>
    {/each}
    <text x="936" y={YA + 6} class="et-nom">p</text>

    <!-- 2 : les deux sondages. -->
    <g class="et-etape" class:et-vu={e >= 2}>
      <path d="M 100 {YA - 26} L 80 {YA - 16} L 100 {YA - 6} Z" class="et-fleche" />
      <text x="108" y={YA - 9} class="et-pt-t">notre sondage&#8239;: bien plus à gauche</text>
      <circle cx={X50} cy={YA} r="10" class="et-point" />
      <text x={X50 + 16} y={YA - 14} class="et-pt-t">sondage de 50</text>
      <text x="80" y="420" class="et-fin">«&#8239;.&#8239;»&#8239;: sous 0,1, mais pas sous 0,05. Pas significatif.</text>
      <text x="80" y="456" class="et-src">Fisher (1926), cité dans Arel-Bundock (2021, p.&#8239;71), pour le seuil de 0,05</text>
    </g>
  </svg>
</div>

<style>
  .pente-etoiles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .et-console { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .et-r { font-size: 19px; fill: var(--dk-gris); white-space: pre; }
  .et-rang { fill: var(--dk-encre); font-weight: 600; }
  .et-legende { fill: var(--dk-encre); }
  .et-cible { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .et-qui { font-size: 17px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .et-zone { fill: var(--dk-fond-2); }
  .et-zone-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-zone-d { fill: var(--dk-gris); text-anchor: start; }
  .et-zone-s { font-size: 18px; text-anchor: middle; fill: var(--dk-encre); }
  .et-seuil { stroke: var(--dk-accent); stroke-width: 4; }
  .et-conv { font-size: 15px; text-anchor: end; fill: var(--dk-accent); }
  .et-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .et-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .et-tick-s { fill: var(--dk-accent); font-weight: 600; }
  .et-nom { font-size: 22px; font-style: italic; fill: var(--dk-gris); }
  .et-code { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .et-code.et-mot { font-size: 18px; font-weight: 400; fill: var(--dk-gris); }
  .et-etape.et-vu .et-code { opacity: 1; transition: opacity 0.4s; }
  .et-fleche { fill: var(--dk-accent); }
  .et-point { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .et-pt-t { font-size: 19px; font-weight: 600; fill: var(--dk-accent); }
  .et-fin { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .et-src { font-size: 15px; fill: var(--dk-gris); }
  .et-etape { opacity: 0; transition: opacity 0.2s; }
  .et-etape.et-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .et-etape, .et-etape.et-vu, .et-code, .et-etape.et-vu .et-code { transition: none; }
  }
</style>
