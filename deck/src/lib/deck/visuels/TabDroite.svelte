<script>
  /**
   * Les deux nombres du haut du tableau dessinent la droite. À gauche, le
   * tableau d'article (TabPublie). À droite, notre sondage en colonnes de
   * points : la scolarité n'a que 5 niveaux et l'intérêt 11 valeurs, `jx`
   * et `jy` étalent un peu chaque personne pour le dessin seulement (le
   * modèle utilise x et y). Les axes vont de 0 à 1, avec les niveaux et les
   * bornes du codebook (VARS). Par-dessus, la droite de R.
   *
   *   0  Le nuage seul.
   *   1  L'ordonnée à l'origine (la constante du tableau) : l'intérêt que la
   *      droite prédit à 0 (secondaire non terminé). Un point sur l'axe
   *      vertical.
   *   2  Le signe : la droite part de ce point et monte. Positif = plus
   *      scolarisé, plus intéressé.
   *   3  La pente se lit de 0 à 1, sur tout l'éventail : du secondaire non
   *      terminé à la maîtrise ou au doctorat, +0,20.
   *   4  Un niveau de scolarité vaut 0,25 : quatre marches d'environ +0,05.
   *
   * Les deux axes partent du même 0, sans marge (demande de l'enseignant,
   * 15 octobre). Pour que les colonnes de points restent dans le cadre, le
   * léger étalement du dessin (`jx`, `jy`) est replié vers l'intérieur aux
   * bords (à 0 et à 1) : il reste du même côté que le cadre, rien d'autre ne
   * bouge. La graduation 0 est commune aux deux axes.
   *
   * Nombres : NOTRE.coefs, NOTRE.points et VARS dans src/lib/data/seance7.js
   * (outils/seance7_data.R). Les marches sont calculées depuis la pente.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '\u2212');
  const sg = (v, d = 2) => (v > 0 ? '+' : '') + f(v, d);
  const nb = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  const B0 = NOTRE.coefs[0].b, B1 = NOTRE.coefs[1].b;
  const X0 = 170, X1 = 590, Y0 = 350, Y1 = 30;
  const x = (v) => X0 + v * (X1 - X0);
  const y = (v) => Y0 - v * (Y0 - Y1);
  const yd = (v) => y(B0 + B1 * v);
  // L'étalement du dessin, replié vers l'intérieur aux bords : rien ne dépasse 0 ni 1.
  const replier = (v, c) => (c <= 0 ? c + Math.abs(v - c) : c >= 1 ? c - Math.abs(v - c) : v);
  const PTS = NOTRE.points.map((p) => ({ ...p, jx: replier(p.jx, p.x), jy: replier(p.jy, p.y) }));
  // Les niveaux de scolarité sur deux lignes, coupés à la virgule ou au premier espace.
  const deuxLignes = (t) => {
    const s = t.toLowerCase(), i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return j > 0 ? [s.slice(0, j), s.slice(j + 1)] : [s, ''];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));
  // En y, le curseur de 0 à 10 ramené de 0 à 1 : une graduation par point, les bornes nommées.
  const GY = Array.from({ length: VARS.y.max - VARS.y.min + 1 }, (_, k) => k / (VARS.y.max - VARS.y.min));
  const BORNES = VARS.y.bornes.map((t) => t.toLowerCase().split(' '));
  const PAS = VARS.x.valeurs[1] - VARS.x.valeurs[0]; // un niveau de scolarité : 0,25
  const MARCHES = VARS.x.valeurs.slice(0, -1);
  const K = MARCHES[2]; // la marche en rouge : de 0,5 à 0,75
  const BX = `b-${VARS.x.nom}`;
  const ON = [[], ['b-(Intercept)'], [BX], [BX], [BX]];
  const DIT = [
    '',
    `l’ordonnée à l’origine (la constante du tableau)\u202f: ${f(B0)}`,
    B1 > 0 ? 'positif\u202f: plus scolarisé, plus intéressé' : 'négatif\u202f: plus scolarisé, moins intéressé',
    `de 0 à 1\u202f: ${sg(B1)}`,
    `un niveau de plus (+${f(PAS)})\u202f: environ ${sg(B1 * PAS)}`
  ];
</script>

<div class="visuel tab-droite" bind:this={hote}>
  <div class="td-tab"><TabPublie on={ON[e]} /></div>

  <div class="td-fig">
    <svg viewBox="0 0 680 462" role="img" aria-label="Les {PTS.length} personnes de notre sondage, en colonnes, une par niveau de scolarité, et la droite de R. À 0, {VARS.x.niveaux[0].toLowerCase()}, la droite prédit un intérêt de {f(B0)}. Elle monte de {f(B1)} de 0 à 1, et d’environ {f(B1 * PAS)} par niveau.">
      <!-- Le nuage en colonnes, pâle : le décor. -->
      {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.jy)} r="2.4" class="td-pt" />{/each}

      <!-- Les axes, avec les niveaux et les bornes du codebook. -->
      <!-- Des repères pâles à chaque dixième en y : on lit la droite sans effort. -->
      {#each GY.slice(1) as v}<line x1={X0} y1={y(v)} x2={X1} y2={y(v)} class="td-grille" class:td-demi={v === 0.5 || v === 1} />{/each}
      <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="td-axe" />
      <line x1={X0} y1={Y0} x2={X0} y2={Y1} class="td-axe" />
      {#each NX as t}
        <line x1={x(t.v)} y1={Y0} x2={x(t.v)} y2={Y0 + 8} class="td-axe" />
        {#if t.v > 0}<text x={x(t.v)} y={Y0 + 30} class="td-tick">{nb(t.v)}</text>{/if}
        <text x={x(t.v)} y={Y0 + 50} class="td-niv">{t.l[0]}</text>
        <text x={x(t.v)} y={Y0 + 66} class="td-niv">{t.l[1]}</text>
      {/each}
      {#each GY as v}<line x1={X0 - 7} y1={y(v)} x2={X0} y2={y(v)} class="td-axe td-fine" />{/each}
      {#each [0.5, 1] as v}<text x={X0 - 12} y={y(v) + 6} class="td-tick td-g">{nb(v)}</text>{/each}
      <text x={X0 - 12} y={y(1) + 26} class="td-niv td-g">{BORNES[1][0]}</text>
      <text x={X0 - 12} y={y(1) + 42} class="td-niv td-g">{BORNES[1].slice(1).join(' ')}</text>
      <text x={X0 - 12} y={y(0) - 26} class="td-niv td-g">{BORNES[0][0]}</text>
      <text x={X0 - 12} y={y(0) - 10} class="td-niv td-g">{BORNES[0].slice(1).join(' ')}</text>
      <!-- L'origine : un seul 0, commun aux deux axes. -->
      <text x={X0 - 10} y={Y0 + 22} class="td-tick td-g">0</text>
      <text x="4" y="16" class="td-titre-axe td-g0">intérêt</text>
      <text x={(X0 + X1) / 2} y="452" class="td-titre-axe">scolarité</text>

      <!-- 2 · La droite, qui se dessine depuis la constante. -->
      <line x1={x(0)} y1={yd(0)} x2={x(1)} y2={yd(1)} class="td-droite" class:td-vu={e >= 2} pathLength="1" />

      <!-- 3 · De 0 à 1 : on avance sur tout l'éventail, on monte de la pente. -->
      <g class="td-une" class:td-vu={e === 3}>
        <line x1={x(0)} y1={yd(0)} x2={x(1)} y2={yd(0)} class="td-pas td-tir" />
        <line x1={x(1)} y1={yd(0)} x2={x(1)} y2={yd(1)} class="td-pas td-chute" />
        <text x={x(1) + 12} y={(yd(0) + yd(1)) / 2 + 9} class="td-lib td-g0">{sg(B1)}</text>
        <text x={x(0.5)} y={yd(0) + 34} class="td-lib td-encre">de 0 à 1</text>
      </g>

      <!-- 4 · Les quatre marches d'un niveau (0,25) : on avance, puis on monte. -->
      <g class="td-marches" class:td-vu={e >= 4}>
        {#each MARCHES as k, i}
          <path d="M{x(k)} {yd(k)} H{x(k + PAS)} V{yd(k + PAS)}" class="td-marche" class:td-rouge={k === K} style="transition-delay: {i * 90}ms" />
        {/each}
        <text x={x(K + PAS / 2)} y={yd(K) + 30} class="td-lib td-encre td-petit">+{f(PAS)}</text>
      </g>

      <!-- 1 · La constante : le point à 0. -->
      <g class="td-const" class:td-vu={e >= 1}>
        <circle cx={x(0)} cy={yd(0)} r="8" class="td-c" />
        <text x={x(0) + 6} y={yd(0) - 18} class="td-lib td-g0" class:td-pale={e >= 2}>{f(B0)}</text>
      </g>
    </svg>
    <p class="td-dit" class:td-vu={e > 0}>{DIT[e] || ' '}</p>
  </div>
</div>

<style>
  .tab-droite { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .td-tab { font-size: 0.92em; }
  .td-fig { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; display: block; max-height: 64vh; }
  .td-pt { fill: var(--dk-encre); opacity: 0.13; }
  .td-grille { stroke: var(--dk-filet); stroke-width: 1; }
  .td-grille.td-demi { stroke: var(--dk-gris-2); stroke-dasharray: 4 4; }
  .td-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .td-fine { stroke-width: 1.5; }
  .td-tick.td-g { text-anchor: end; }
  .td-tick { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }
  .td-niv { font-family: var(--dk-mono); font-size: 14px; fill: var(--dk-gris); text-anchor: middle; }
  .td-niv.td-g { text-anchor: end; }
  .td-titre-axe { font-family: var(--dk-mono); font-size: 18px; letter-spacing: 0.06em; fill: var(--dk-encre); text-anchor: middle; font-weight: 600; }
  .td-titre-axe.td-g0 { text-anchor: start; }

  .td-droite { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .td-droite.td-vu { stroke-dashoffset: 0; }

  .td-const { opacity: 0; transition: opacity 0.35s; }
  .td-const.td-vu { opacity: 1; }
  .td-c { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .td-lib { font-family: var(--dk-mono); font-size: 26px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; }
  .td-lib.td-g0 { text-anchor: start; }
  .td-lib.td-fin { text-anchor: end; }
  .td-lib.td-encre { fill: var(--dk-encre); }
  .td-lib.td-petit { font-size: 20px; }
  .td-pale { opacity: 0.75; }

  .td-une { opacity: 0; transition: opacity 0.35s; }
  .td-une.td-vu { opacity: 1; }
  .td-pas { stroke: var(--dk-encre); stroke-width: 3; }
  .td-tir { stroke-dasharray: 8 6; }
  .td-chute { stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: none; }

  .td-marche { fill: none; stroke: var(--dk-encre); stroke-width: 3; opacity: 0; transition: opacity 0.25s; }
  .td-marche.td-rouge { stroke: var(--dk-accent); stroke-width: 4.5; }
  .td-marches text { opacity: 0; transition: opacity 0.3s 0.4s; }
  .td-marches.td-vu .td-marche, .td-marches.td-vu text { opacity: 1; }

  .td-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.3s; }
  .td-dit.td-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .td-droite, .td-const, .td-une, .td-marche, .td-marches text, .td-dit { transition: none; }
  }
</style>
