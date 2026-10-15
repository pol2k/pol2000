<script>
  /**
   * La cloche, posée sur 0 (remanié le 15 octobre 2026 à la demande du
   * professeur) : on prend la cloche de notre estimation, on la pose sur
   * 0 (le monde où H0 est vraie), puis on regarde où tombe notre pente dans
   * cette cloche. Quatre temps.
   *
   *   0  Notre pente, NOTRE.coefs[1].b (+0,20), en rouge, avec sa cloche :
   *      une courbe normale de largeur NOTRE.coefs[1].se (0,032, l'erreur
   *      type calculée par R), centrée sur +0,20. C'est de combien le
   *      hasard du tirage ferait bouger notre pente d'un sondage à l'autre.
   *   1  La cloche glisse jusqu'à 0 : si H0 était vraie, la cloche serait
   *      centrée sur 0. Notre pente, elle, reste à +0,20.
   *   2  La confirmation : les 1 000 mélanges de la diapo précédente
   *      (H0.notre.pentes, tranches de 0,01) remplissent la même cloche
   *      (leur écart type, H0.notre.ecart_type, 0,033, contre 0,032 pour R).
   *   3  Où tombe notre pente dans la cloche centrée sur 0 ? Loin dans la
   *      queue : H0.notre.aussi_loin (0) mélange sur 1 000 aussi loin. On
   *      rejette H0.
   *
   * La courbe est dessinée ici à partir de l'erreur type de R (la forme de
   * la courbe normale, à l'échelle des bâtons : même aire). Les bâtons et
   * le compte viennent de R (src/lib/data/seance7.js, outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, H0 } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const N = ' ';
  const fs = (v, d = 2) => (v > 0 ? '+' : '') + f(v, d);
  const C = NOTRE.coefs[1];
  const B = C.b, SE = C.se;
  const PENTES = H0.notre.pentes;
  const TOUS = f(PENTES.length, 0);
  const LOIN = H0.notre.aussi_loin;

  // L'axe des pentes, de −0,15 à +0,3.
  const P0 = -0.15, P1 = 0.3, X0 = 70, X1 = 930, BASE = 350, HAUT = 180;
  const x = (p) => X0 + ((p - P0) / (P1 - P0)) * (X1 - X0);
  // Les bâtons des mélanges : tranches de 0,01, en densité (compte ÷ 1 000 ÷ 0,01).
  const L = 0.01;
  const tr = (p) => Math.floor(p / L + 1e-9);
  const T0 = tr(Math.min(...PENTES));
  const COMPTES = new Array(tr(Math.max(...PENTES)) - T0 + 1).fill(0);
  for (const p of PENTES) COMPTES[tr(p) - T0]++;
  // La courbe normale de largeur SE : sa hauteur au sommet fixe l'échelle.
  const SOMMET = 1 / (SE * Math.sqrt(2 * Math.PI));
  const DMAX = Math.max(SOMMET, Math.max(...COMPTES) / (PENTES.length * L));
  const yd = (d) => BASE - (d / DMAX) * HAUT;
  // La courbe, dessinée autour de 0; on la déplace en bloc.
  const COURBE = (() => {
    const pts = [];
    for (let k = -4; k <= 4.0001; k += 0.1) {
      const p = k * SE;
      pts.push(`${pts.length ? 'L' : 'M'} ${x(p).toFixed(1)} ${yd(SOMMET * Math.exp(-k * k / 2)).toFixed(1)}`);
    }
    return pts.join(' ');
  })();
  const DX = x(B) - x(0);
  const XB = x(B), XZ = x(0);

  const PHRASES = [
    [`Notre pente${N}: ${fs(B)}, avec sa cloche.`, `Le hasard du tirage la fait bouger d’environ ${f(SE, 3)} (l’erreur type).`],
    ['Si H0 était vraie,', 'la cloche serait centrée sur 0.'],
    [`Les ${TOUS} mélanges${N}: la même cloche.`, 'Le monde où H0 est vraie, construit avec nos données.'],
    [`Et notre pente${N}? Loin dans la queue.`, '']
  ];
</script>

<div class="visuel pente-monde-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Notre pente, {fs(B)}, avec sa cloche{N}: le hasard du tirage la fait bouger d’environ {f(SE, 3)}, l’erreur type. Si H0 était vraie, la cloche serait centrée sur 0. Les {TOUS} mélanges forment la même cloche. Notre pente reste à {fs(B)}, loin dans la queue{N}: {LOIN} mélange sur {TOUS} va aussi loin. On rejette H0.">
    {#key e}
      <g class="mh-phrase">
        <text x="40" y="42" class="mh-titre">{PHRASES[e][0]}</text>
        <text x="40" y="74" class="mh-sous">{PHRASES[e][1]}</text>
      </g>
    {/key}

    <!-- 2 : les mille mélanges, en bâtons. -->
    <g class="mh-etape" class:mh-vu={e >= 2}>
      {#each COMPTES as c, j}
        {@const h = BASE - yd(c / (PENTES.length * L))}
        <rect x={x((T0 + j) * L) + 0.5} y={BASE - h} width={x(L) - x(0) - 1} height={h} class="mh-baton" />
      {/each}
    </g>

    <!-- La cloche : sur notre pente au temps 0, puis glissée sur 0. -->
    <g class="mh-cloche" class:mh-sur0={e >= 1} style="transform: translateX({e >= 1 ? 0 : DX}px)">
      <path d="{COURBE} L {x(4 * SE)} {BASE} L {x(-4 * SE)} {BASE} Z" class="mh-aire" />
      <path d={COURBE} class="mh-courbe" />
      <!-- La largeur : une erreur type de part et d'autre du centre. -->
      <g class="mh-etape" class:mh-vu={e <= 1}>
        <line x1={x(-SE)} y1={BASE + 44} x2={x(SE)} y2={BASE + 44} class="mh-largeur" />
        <line x1={x(-SE)} y1={BASE + 36} x2={x(-SE)} y2={BASE + 52} class="mh-largeur" />
        <line x1={x(SE)} y1={BASE + 36} x2={x(SE)} y2={BASE + 52} class="mh-largeur" />
        <text x={x(0)} y={BASE + 74} class="mh-largeur-t">± {f(SE, 3)}</text>
      </g>
    </g>

    <!-- H0. -->
    <g class="mh-etape" class:mh-vu={e >= 1}>
      <line x1={XZ} y1="128" x2={XZ} y2={BASE} class="mh-h0" />
      <text x={XZ} y="120" class="mh-h0-t">H0</text>
    </g>

    <!-- L'axe. -->
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="mh-axe" />
    {#each [-0.1, 0, 0.1, 0.2, 0.3] as k}
      <line x1={x(k)} y1={BASE} x2={x(k)} y2={BASE + 8} class="mh-axe" />
      <text x={x(k)} y={BASE + 30} class="mh-tick" class:mh-zero={k === 0}>{k > 0 ? '+' : ''}{f(k, k === 0 ? 0 : 1)}</text>
    {/each}
    <text x={X0} y={BASE + 74} class="mh-tick mh-debut">pente de la droite</text>

    <!-- Notre pente : elle ne bouge jamais. -->
    <line x1={XB} y1="96" x2={XB} y2={BASE} class="mh-notre" />
    <circle cx={XB} cy={BASE} r="10" class="mh-point" />
    <text x={XB + 14} y="112" class="mh-lab">notre pente</text>
    <text x={XB + 14} y="138" class="mh-lab">{fs(B)}</text>

    <!-- 3 : où elle tombe. -->
    <g class="mh-etape mh-apres" class:mh-vu={e >= 3}>
      <text x={XB + 14} y="232" class="mh-compte">{LOIN} sur {TOUS}</text>
      <text x={XB + 14} y="260" class="mh-lab-s">mélanges</text>
      <text x={XB + 14} y="284" class="mh-lab-s">aussi loin de 0</text>
      <text x="40" y="474" class="mh-cours">Dans le monde de H0, une pente comme la nôtre n’arrive pas. <tspan class="mh-rouge">On rejette H0.</tspan></text>
    </g>
  </svg>
</div>

<style>
  .pente-monde-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .mh-phrase { animation: mh-fondu 0.5s ease-out both; }
  @keyframes mh-fondu { from { opacity: 0; } to { opacity: 1; } }
  .mh-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .mh-sous { font-size: 21px; fill: var(--dk-gris); }
  .mh-baton { fill: var(--dk-encre); opacity: 0.85; }
  .mh-cloche { transition: transform 1.4s cubic-bezier(0.6, 0, 0.3, 1); }
  .mh-aire { fill: var(--dk-accent); opacity: 0.14; transition: fill 0.6s, opacity 0.6s; }
  .mh-courbe { fill: none; stroke: var(--dk-accent); stroke-width: 4; transition: stroke 0.6s; }
  .mh-sur0 .mh-aire { fill: var(--dk-encre); opacity: 0.08; }
  .mh-sur0 .mh-courbe { stroke: var(--dk-encre); }
  .mh-largeur { stroke: var(--dk-gris); stroke-width: 2.5; }
  .mh-largeur-t { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .mh-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .mh-h0-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mh-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .mh-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .mh-zero { font-weight: 600; fill: var(--dk-encre); }
  .mh-debut { text-anchor: start; }
  .mh-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .mh-point { fill: var(--dk-accent); }
  .mh-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
    .mh-compte { font-size: 30px; font-weight: 600; fill: var(--dk-accent); }
  .mh-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .mh-cours { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .mh-rouge { fill: var(--dk-accent); }
  .mh-etape { opacity: 0; transition: opacity 0.2s; }
  .mh-etape.mh-vu { opacity: 1; transition: opacity 0.5s; }
  .mh-etape.mh-apres.mh-vu { transition: opacity 0.5s 0.3s; }
  @media (prefers-reduced-motion: reduce) {
    .mh-phrase { animation: none; }
    .mh-cloche, .mh-aire, .mh-courbe, .mh-etape, .mh-etape.mh-vu, .mh-etape.mh-apres.mh-vu { transition: none; }
  }
</style>
