<script>
  /**
   * Les étoiles de R (repensé le 15 octobre 2026 à la demande du
   * professeur) : une seule idée, les étoiles sont un raccourci pour la
   * valeur p. En haut, notre ligne scolarite de summary(), telle que R
   * l'imprime (SUMMARY), et la légende « Signif. codes ». En bas, la légende
   * décodée en cinq cases. Trois temps.
   *
   *   0  La ligne de R; la valeur p et ses étoiles sont encadrées en rouge.
   *      Dessous, la légende de R, telle quelle.
   *   1  Les cinq cases de la légende, de gauche à droite : *** (p sous
   *      0,001), ** (sous 0,01), * (sous 0,05), . (sous 0,1), rien. Un filet
   *      rouge après la case * : à gauche, « significatif » au seuil
   *      habituel de 0,05 (une convention).
   *   2  Notre valeur p, 3.87e-10, tombe dans la case *** : elle passe au
   *      rouge, avec une flèche depuis la ligne de R.
   *
   * Les seuils sont ceux de la légende de R : des conventions, écrites ici.
   * Le texte de R est découpé dans SUMMARY, rien n'est retapé.
   */
  import { brancherTemps } from '../temps.js';
  import { SUMMARY } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const N = ' ';

  // Les lignes de R.
  const LIGNES = SUMMARY.split('\n');
  const ENTETE = LIGNES.find((s) => /^\s+Estimate/.test(s)).trimEnd();
  const RANG = LIGNES.find((s) => s.startsWith('scolarite')).trimEnd();
  const LEGENDE = LIGNES.find((s) => s.startsWith('Signif. codes')).trimEnd();
  const CHAMPS = RANG.trim().split(/\s+/);
  const P_TXT = CHAMPS[4], ETOILES = CHAMPS[5] ?? '';
  const P = Number(P_TXT);
  const P_COL = RANG.indexOf(P_TXT);
  const FS = 22, CH = 0.6 * FS, XR = 70;

  // Les cinq cases de la légende de R.
  const CASES = [
    { c: '***', seuil: 'p < 0,001', max: 0.001 },
    { c: '**', seuil: 'p < 0,01', max: 0.01 },
    { c: '*', seuil: 'p < 0,05', max: 0.05 },
    { c: '.', seuil: 'p < 0,1', max: 0.1 },
    { c: '', seuil: 'p ≥ 0,1', max: Infinity }
  ];
  const ICI = CASES.findIndex((k) => P < k.max);
  const W = 168, G = 10, CX0 = (1000 - (5 * W + 4 * G)) / 2, CY = 268, CHT = 110;
  const cx = (i) => CX0 + i * (W + G);
  const XS = cx(3) - G / 2;
  // La flèche : du bas des étoiles de R jusqu'à la case.
  const XE = XR + (P_COL + (P_TXT.length + 1 + ETOILES.length) / 2) * CH;
</script>

<div class="visuel pente-etoiles" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="La ligne de R pour la scolarité{N}: valeur p {P_TXT}, trois étoiles. La légende de R{N}: trois étoiles si p est sous 0,001, deux sous 0,01, une sous 0,05, un point sous 0,1, rien au-delà. Sous 0,05{N}: statistiquement significatif, une convention. Notre valeur p tombe dans la case des trois étoiles.">
    <!-- 0 : ce que R imprime. -->
    <rect x={XR - 24} y="12" width="910" height="128" class="et-console" />
    <text x={XR} y="46" class="et-r">{ENTETE}</text>
    <text x={XR} y="80" class="et-r et-rang">{RANG}</text>
    <rect x={XR + P_COL * CH - 8} y="56" width={(RANG.length - P_COL) * CH + 16} height="34" class="et-cible" />
    <text x={XR} y="122" class="et-r et-legende">{LEGENDE}</text>

    <!-- 1 : la légende, en cinq cases. -->
    <g class="et-etape" class:et-vu={e >= 1}>
      <text x={(cx(0) + cx(2) + W) / 2} y={CY - 18} class="et-zone">significatif</text>
      <text x={(cx(3) + cx(4) + W) / 2} y={CY - 18} class="et-zone et-gris">pas significatif</text>
      {#each CASES as k, i}
        <g class="et-case" class:et-ici={e >= 2 && i === ICI} style="transition-delay: {e === 1 ? i * 110 : 0}ms">
          <rect x={cx(i)} y={CY} width={W} height={CHT} class="et-boite" />
          <text x={cx(i) + W / 2} y={CY + 64} class="et-etoiles" class:et-point={k.c === '.'} class:et-rien={!k.c}>{k.c || 'rien'}</text>
          <text x={cx(i) + W / 2} y={CY + CHT + 32} class="et-seuil">{k.seuil}</text>
        </g>
      {/each}
      <line x1={XS} y1={CY - 40} x2={XS} y2={CY + CHT + 12} class="et-filet" />
      <text x={XS} y={CY + CHT + 70} class="et-conv">0,05&#8239;: le seuil habituel, une convention</text>
    </g>

    <!-- 2 : notre p tombe dans sa case. -->
    <g class="et-etape" class:et-vu={e >= 2}>
      <path d="M {XE} 146 C {XE} 210, {cx(ICI) + W / 2} 170, {cx(ICI) + W / 2} {CY - 6}" class="et-fleche" />
      <path d="M {cx(ICI) + W / 2 - 9} {CY - 18} L {cx(ICI) + W / 2} {CY - 4} L {cx(ICI) + W / 2 + 9} {CY - 18}" class="et-fleche" />
    </g>
  </svg>
</div>

<style>
  .pente-etoiles { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .et-console { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .et-r { font-size: 22px; fill: var(--dk-gris); white-space: pre; }
  .et-rang { fill: var(--dk-encre); font-weight: 600; }
  .et-legende { font-size: 19px; }
  .et-cible { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .et-zone { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-gris { fill: var(--dk-gris); }
  .et-case { transition: opacity 0.3s; }
  .et-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; transition: fill 0.4s, stroke 0.4s; }
  .et-etoiles { font-size: 46px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .et-point { font-size: 60px; }
  .et-rien { font-size: 20px; font-weight: 400; fill: var(--dk-gris); }
  .et-seuil { font-size: 19px; text-anchor: middle; fill: var(--dk-encre); }
  .et-ici .et-boite { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .et-ici .et-etoiles { fill: var(--dk-fond); }
  .et-filet { stroke: var(--dk-accent); stroke-width: 4; }
  .et-conv { font-size: 17px; text-anchor: middle; fill: var(--dk-accent); }
  .et-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-linejoin: miter; }
  .et-etape { opacity: 0; transition: opacity 0.2s; }
  .et-etape.et-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .et-etape, .et-etape.et-vu, .et-case, .et-boite, .et-etoiles { transition: none; }
  }
</style>
