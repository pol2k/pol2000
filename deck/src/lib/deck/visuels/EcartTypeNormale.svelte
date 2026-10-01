<script>
  /**
   * L'écart type sur la courbe normale, juste avant la marge d'erreur. La
   * diapo « La courbe normale » a montré la forme, sans écart type. Ici, la
   * largeur de la cloche a un nom, puis le « 19 sur 20 » sur lequel repose la
   * marge d'erreur. Un schéma : les deux cloches sont des formes normales
   * dessinées ici, pas des données. Quatre temps.
   *
   *   0  Deux cloches, même centre (pointillé rouge) : l'une serrée, l'autre
   *      étalée. « Même centre, largeur différente. » Les deux ont la même
   *      aire, donc la serrée est plus haute.
   *   1  La largeur, c'est l'écart type : une règle sous l'axe, du centre à un
   *      écart type, pour chacune (petit à droite, grand à gauche). La
   *      distance typique au centre. Un repère concret : l'âge des 20 180
   *      répondant.e.s de l'ÉÉC 2025, écart type de 17,5 ans (POP.ecartType).
   *      L'âge n'est pas normal (presque plat de 25 à 70 ans) : il sert
   *      seulement à donner une unité à l'écart type, aucune part n'y est
   *      appliquée.
   *   2  On garde la cloche étalée. À moins d'un écart type du centre :
   *      environ 2 sur 3 (aire grisée, accolade sous l'axe).
   *   3  À moins de deux écarts types : environ 19 sur 20. « Retenez ce 19
   *      sur 20 » : il revient avec la marge d'erreur.
   *
   * Les deux parts viennent de NORMALE (pnorm dans outils/seance5_normale.R),
   * arrondies ici. L'écart type et l'effectif de l'âge viennent de POP
   * (outils/seance5_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { NORMALE } from '$lib/data/seance5_normale.js';
  import { POP } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const pc = (p) => Math.round(p * 100);
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');

  const CX = 500, BASE = 330;
  // Deux cloches de même aire : la hauteur est inversement proportionnelle
  // à la largeur.
  const SDN = 62, HN = 250;
  const SDL = 130, HL = (HN * SDN) / SDL;
  const cloche = (sd, h, zmax) => {
    const zs = Array.from({ length: Math.round((2 * zmax) / 0.05) + 1 }, (_, i) => -zmax + i * 0.05);
    return 'M ' + zs.map((z) => `${(CX + z * sd).toFixed(1)} ${(BASE - h * Math.exp(-0.5 * z * z)).toFixed(1)}`).join(' L ');
  };
  const SERREE = cloche(SDN, HN, 4);
  const ETALEE = cloche(SDL, HL, 3.7);
  const xL = (z) => CX + z * SDL;
  const yL = (z) => BASE - HL * Math.exp(-0.5 * z * z);
  const yN = (z) => BASE - HN * Math.exp(-0.5 * z * z);
  const aire = (a, b) => {
    const zs = Array.from({ length: Math.round((b - a) / 0.05) + 1 }, (_, i) => a + i * 0.05);
    return `M ${xL(a).toFixed(1)} ${BASE} ` + zs.map((z) => `L ${xL(z).toFixed(1)} ${yL(z).toFixed(1)}`).join(' ') + ` L ${xL(b).toFixed(1)} ${BASE} Z`;
  };
  const accolade = (a, b, yy) => `M ${xL(a)} ${yy - 10} V ${yy} H ${xL(b)} V ${yy - 10}`;
  const R = BASE + 28; // la ligne des règles
</script>

<div class="visuel ecart-type-normale" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Deux cloches de même centre, l’une serrée, l’autre étalée : même centre, largeur différente. Cette largeur, c’est l’écart type, la distance typique au centre. Par exemple, l’âge des {f(POP.n)} répondant.e.s a un écart type de {f(POP.ecartType, 1)} ans. Sur une courbe normale, environ 2 valeurs sur 3 ({pc(NORMALE.un)} %) sont à moins d’un écart type du centre, et environ 19 sur 20 ({pc(NORMALE.deux)} %) à moins de deux écarts types. Retenez ce 19 sur 20 : il revient avec la marge d’erreur.">
    <text x="980" y="22" class="et-note">schéma</text>

    <!-- 3 puis 2 : les aires sous la cloche étalée, la plus large d'abord. -->
    <path d={aire(-2, 2)} class="et-aire et-deux" class:et-vu={e >= 3} />
    <path d={aire(-1, 1)} class="et-aire et-un" class:et-vu={e >= 2} />

    <!-- 0 : deux cloches, même centre. -->
    <path d={ETALEE} pathLength="1" class="et-courbe" />
    <g class="et-sort" class:et-cache={e >= 2}>
      <path d={SERREE} pathLength="1" class="et-courbe" />
      <line x1={CX} y1={BASE - HN - 6} x2={CX} y2={BASE} class="et-centre" />
    </g>
    <line x1="15" y1={BASE} x2="985" y2={BASE} class="et-axe" />
    <text x={CX} y="40" class="et-titre et-sort" class:et-cache={e >= 2}>même centre, largeur différente</text>

    <!-- 1 : la largeur, c'est l'écart type. -->
    <g class="et-etape" class:et-vu={e === 1}>
      <line x1={CX + SDN} y1={yN(1)} x2={CX + SDN} y2={R} class="et-guide" />
      <line x1={xL(-1)} y1={yL(-1)} x2={xL(-1)} y2={R} class="et-guide" />
      <path d="M {CX} {R} H {CX + SDN} M {CX} {R - 7} v 14 M {CX + SDN} {R - 7} v 14" class="et-regle" />
      <path d="M {CX} {R} H {xL(-1)} M {xL(-1)} {R - 7} v 14" class="et-regle" />
      <text x={CX + SDN + 12} y={R + 6} class="et-regle-t">petit écart type</text>
      <text x={xL(-1) - 12} y={R + 6} class="et-regle-t et-fin">grand écart type</text>
      <text x={CX} y="414" class="et-phrase">L’écart type&#8239;: la distance typique au centre.</text>
      <text x={CX} y="448" class="et-exemple">Exemple&#8239;: l’âge des {f(POP.n)} répondant.e.s, écart type de {f(POP.ecartType, 1)} ans.</text>
    </g>

    <!-- 2 : à moins d'un écart type. -->
    <g class="et-etape" class:et-vu={e >= 2}>
      <path d={accolade(-1, 1, BASE + 22)} class="et-accolade" />
      <text x={CX} y={BASE + 50} class="et-part">à moins d’un écart type&#8239;: environ 2 sur 3 ({pc(NORMALE.un)}&#8239;%)</text>
    </g>

    <!-- 3 : à moins de deux écarts types. -->
    <g class="et-etape" class:et-vu={e >= 3}>
      <path d={accolade(-2, 2, BASE + 70)} class="et-accolade et-rouge-s" />
      <text x={CX} y={BASE + 98} class="et-part et-rouge">à moins de deux écarts types&#8239;: environ 19 sur 20 ({pc(NORMALE.deux)}&#8239;%)</text>
      <text x={CX} y="476" class="et-phrase et-rouge">Retenez ce 19 sur 20&#8239;: il revient avec la marge d’erreur.</text>
    </g>
  </svg>
</div>

<style>
  .ecart-type-normale { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .et-note { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .et-courbe { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: et-trace 1.2s ease-out forwards; }
  @keyframes et-trace { to { stroke-dashoffset: 0; } }
  .et-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .et-centre { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 8 6; }
  .et-titre { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-sort { transition: opacity 0.4s; }
  .et-guide { stroke: var(--dk-gris); stroke-width: 2; stroke-dasharray: 3 5; }
  .et-regle { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .et-regle-t { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .et-fin { text-anchor: end; }
  .et-phrase { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-exemple { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .et-aire { opacity: 0; transition: opacity 0.6s; }
  .et-un { fill: var(--dk-gris-2); }
  .et-un.et-vu { opacity: 0.55; }
  .et-deux { fill: var(--dk-fond-2); stroke: var(--dk-accent); stroke-width: 2; }
  .et-deux.et-vu { opacity: 1; }
  .et-accolade { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .et-rouge-s { stroke: var(--dk-accent); }
  .et-part { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .et-rouge { fill: var(--dk-accent); }
  .et-cache { opacity: 0; }
  .et-etape { opacity: 0; transition: opacity 0.3s; }
  .et-etape.et-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .et-courbe { animation: none; stroke-dashoffset: 0; }
    .et-etape, .et-etape.et-vu, .et-aire, .et-sort { transition: none; }
  }
</style>
