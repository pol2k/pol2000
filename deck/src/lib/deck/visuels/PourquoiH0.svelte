<script>
  /**
   * Pourquoi le monde à 100 g ? H0 dit « 100 g ou moins » : ce n'est pas un
   * monde, c'est une infinité de mondes (100 g, 99 g, 98 g…). On n'en
   * construit qu'un, celui à 100 g, parce que c'est le plus favorable à H0 :
   * si même des pommes ordinaires de 100 g donnent rarement un panier de
   * 105 g, des pommes plus légères le donnent encore plus rarement. Quatre
   * temps.
   *
   *   0  Trois mondes de H0, une rangée chacun, sur le même axe : une cloche
   *      centrée sur 100, 99 et 98 g. La ligne rouge du panier, 105 g, les
   *      traverse toutes.
   *   1  La queue de chaque cloche au-delà de 105 g passe au rouge, et le
   *      compte : combien de 1 000 paniers pèsent 105 g ou plus dans ce
   *      monde-là (27, 6, 0).
   *   2  Le monde à 100 g est encadré, « le plus favorable à H0 »; les deux
   *      autres pâlissent. Une ligne : rare à 100 g, encore plus rare en
   *      dessous, on teste donc le monde à 100 g.
   *   3  La stratégie : on ne peut pas prouver H1 directement, on montre que
   *      H0 explique très mal son panier, ce qui donne du poids à H1.
   *
   * Sources. Les comptes viennent de MONDES (src/lib/data/seance5_normale.js,
   * outils/seance5_normale.R : 1 000 paniers de 50 pommes fictives par
   * monde, le monde à 100 g est celui de PANIERS), lus par leur moyenne et
   * non par leur rang. Les cloches sont un schéma : une courbe normale
   * d'écart type POMMES.erreurType (src/lib/data/seance5.js), la forme que
   * prennent les moyennes de paniers. D'où l'étiquette « schéma · comptes
   * simulés ».
   *
   * Remanié le 1er octobre 2026 à la demande du professeur : l'ancienne
   * version opposait les mondes sans fin de H1 au monde unique de H0
   * (« exactement 100 g »), ce qui ne tenait plus une fois H0 écrite
   * « 100 g ou moins ».
   */
  import { brancherTemps } from '../temps.js';
  import { MONDES, PANIERS } from '$lib/data/seance5_normale.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const N = '\u202f';

  // L'axe commun : de 90 à 110 g, sur 250 à 750.
  const G0 = 90, G1 = 110, X0 = 250, X1 = 750;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const PANIER = POMMES.moyenne;
  const XP = x(PANIER);

  // Les rangées : le monde le plus lourd en haut.
  const PAS = 76, Y0 = 205, HAUT = 60;
  const RANGS = [...MONDES].sort((a, b) => b.moyenne - a.moyenne).map((m, k) => ({ ...m, yb: Y0 + k * PAS, k }));
  const BAS = RANGS[RANGS.length - 1].yb;
  const ET = POMMES.erreurType;

  // Une cloche normale schématique, de mu - 3,2 ET à mu + 3,2 ET.
  const point = (g, mu, yb) => `${x(g).toFixed(1)} ${(yb - HAUT * Math.exp(-0.5 * ((g - mu) / ET) ** 2)).toFixed(1)}`;
  const cloche = (mu, yb) => {
    const pts = [];
    for (let k = -32; k <= 32; k++) pts.push(point(mu + (k / 10) * ET, mu, yb));
    return 'M ' + pts.join(' L ');
  };
  // La queue au-delà du panier, fermée sur la ligne de base.
  const queue = (mu, yb) => {
    const fin = mu + 3.2 * ET;
    if (fin <= PANIER) return '';
    const pts = [];
    for (let k = 0; k <= 20; k++) pts.push(point(PANIER + (k / 20) * (fin - PANIER), mu, yb));
    return `M ${XP.toFixed(1)} ${yb} L ` + pts.join(' L ') + ` L ${x(fin).toFixed(1)} ${yb} Z`;
  };

  const SOUS = RANGS.map((r) => `${r.moyenne} g${N}?`).join(' ') + ' Des mondes sans fin.';
  const TEST = RANGS[0].moyenne;
</script>

<div class="visuel pourquoi-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="H0 dit : {TEST} g ou moins. C’est une infinité de mondes. Dans chacun, {f(PANIERS.n)} paniers de {POMMES.n} pommes fictives. Paniers de {PANIER} g ou plus : {RANGS.map((r) => `${r.auMoins105} à ${r.moyenne} g`).join(', ')}. Le monde à {TEST} g est le plus favorable à H0 : c’est lui qu’on teste. On ne peut pas prouver H1 directement. On montre que H0 explique très mal son panier. Ça donne du poids à H1.">
    <text x="990" y="22" class="pq-note">schéma · comptes simulés, pommes fictives</text>

    <!-- H0 : des mondes sans fin. -->
    <text x="30" y="52" class="pq-h">H0</text>
    <text x="92" y="52" class="pq-t">{TEST}&#8239;g ou moins</text>
    <text x="30" y="84" class="pq-s">{SOUS}</text>

    <!-- Le panier de la pomicultrice. -->
    <line x1={XP} y1="124" x2={XP} y2={BAS} class="pq-panier" />
    <text x={XP - 8} y="116" class="pq-panier-t">son panier&#8239;: {PANIER}&#8239;g</text>

    <!-- 1 : l'en-tête des comptes. -->
    <text x="990" y="116" class="pq-col pq-etape" class:pq-vu={e >= 1}>paniers de {PANIER}&#8239;g ou plus</text>

    <!-- 2 : le cadre du monde le plus favorable à H0. -->
    <rect x="18" y={RANGS[0].yb - HAUT - 14} width="977" height={HAUT + 26} class="pq-cadre pq-etape" class:pq-vu={e >= 2} />

    {#each RANGS as r}
      <g class="pq-rang" style="animation-delay: {r.k * 250}ms"><g class="pq-ton" class:pq-pale={e >= 2 && r.k > 0}>
        <text x="30" y={r.yb - 8} class="pq-g">{r.moyenne}&#8239;g</text>
        <path d={queue(r.moyenne, r.yb)} class="pq-queue" class:pq-vu={e >= 1} />
        <path d={cloche(r.moyenne, r.yb)} class="pq-cloche" class:pq-cloche-h0={r.k === 0} />
        <line x1={X0} y1={r.yb} x2={X1} y2={r.yb} class="pq-base" />
        <text x="990" y={r.yb - 10} class="pq-compte pq-etape" class:pq-vu={e >= 1}><tspan class="pq-nb">{f(r.auMoins105)}</tspan> sur {f(PANIERS.n)}</text>
      </g></g>
    {/each}
    <text x="30" y={RANGS[0].yb - 40} class="pq-tag pq-etape" class:pq-vu={e >= 2}>le plus favorable à H0</text>
    <text x="30" y={BAS + 36} class="pq-points">…</text>

    <!-- L'axe, sous la dernière rangée. -->
    {#each [90, 95, 100, 105, 110] as g}
      <text x={x(g)} y={BAS + 24} class="pq-tick">{g} g</text>
    {/each}

    <!-- 2 : pourquoi 100 g. -->
    <text x="500" y="422" class="pq-ligne pq-etape" class:pq-vu={e >= 2}>Rare à {TEST}&#8239;g, encore plus rare en dessous&#8239;: on teste le monde à {TEST}&#8239;g.</text>

    <!-- 3 : la stratégie. -->
    <g class="pq-etape" class:pq-vu={e >= 3}>
      <text x="500" y="460" class="pq-ligne">On ne peut pas prouver H1 directement.</text>
      <text x="500" y="490" class="pq-ligne pq-rouge">On montre que H0 explique très mal son panier. Ça donne du poids à H1.</text>
    </g>
  </svg>
</div>

<style>
  .pourquoi-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .pq-note { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .pq-h { font-size: 38px; font-weight: 700; fill: var(--dk-accent); }
  .pq-t { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .pq-s { font-size: 19px; fill: var(--dk-gris); }
  .pq-rouge { fill: var(--dk-accent); }
  .pq-panier { stroke: var(--dk-accent); stroke-width: 4; }
  .pq-panier-t { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .pq-col { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .pq-rang { opacity: 0; animation: pq-fondu 0.6s ease-out forwards; }
  .pq-ton { transition: opacity 0.4s; }
  .pq-ton.pq-pale { opacity: 0.3; }
  @keyframes pq-fondu { to { opacity: 1; } }
  .pq-g { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .pq-cloche { fill: none; stroke: var(--dk-gris); stroke-width: 3; }
  .pq-cloche.pq-cloche-h0 { stroke: var(--dk-encre); }
  .pq-queue { fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .pq-queue.pq-vu { opacity: 1; transition: opacity 0.5s 0.2s; }
  .pq-base { stroke: var(--dk-encre); stroke-width: 2; }
  .pq-compte { font-size: 20px; text-anchor: end; fill: var(--dk-encre); }
  .pq-nb { font-size: 34px; font-weight: 600; fill: var(--dk-accent); }
  .pq-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .pq-tag { font-size: 17px; font-weight: 600; fill: var(--dk-accent); }
  .pq-points { font-size: 28px; fill: var(--dk-gris); }
  .pq-tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .pq-ligne { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pq-ligne.pq-rouge { fill: var(--dk-accent); }
  .pq-etape { opacity: 0; transition: opacity 0.3s; }
  .pq-etape.pq-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .pq-rang { animation: none; opacity: 1; }
    .pq-ton, .pq-queue, .pq-queue.pq-vu, .pq-etape, .pq-etape.pq-vu { transition: none; }
  }
</style>
