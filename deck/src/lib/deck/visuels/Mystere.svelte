<script>
  /**
   * Le mystère du -99, résolu. L'échelle gauche-droite de 0 à 10
   * (GAUCHE_DROITE, généré par outils/seance4_data.R) : les réponses de 0 à
   * 10, et, mis à part au bout de l'axe coupé, les « ne sait pas » codés -99.
   * Trois temps.
   *
   *   0  Les barres montent, -99 compris. La moyenne de R (-11,44) tombe à
   *      gauche du 0, hors de l'échelle.
   *   1  La barre -99 devient NA et s'efface.
   *   2  La moyenne glisse à 4,97, dans l'échelle.
   */
  import { brancherTemps } from '../temps.js';
  import { GAUCHE_DROITE as G } from '$lib/data/seance4.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const virgule = (x) => String(x).replace('.', ',').replace('-', '−');
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');

  // L'axe : la barre -99 seule à gauche (X99), une coupure, puis 0 à 10.
  const X99 = 80, XC = 150, X0 = 200, X1 = 610, Y0 = 320, Y1 = 50;
  const pas = (X1 - X0) / 11;
  const cx = (v) => X0 + (v + 0.5) * pas;
  // La moyenne de 0 à 10 tombe dans l'échelle; celle de -11,44 se place
  // dans la zone de la coupure, entre -99 et 0 : un repère, pas une abscisse.
  const xBrute = XC;
  const xPropre = cx(G.moyennePropre);
  const MAX = Math.ceil(Math.max(...G.effectifs) / 1000) * 1000;
  const y = (n) => Y0 - (n / MAX) * (Y0 - Y1);
  const graduations = Array.from({ length: MAX / 1000 + 1 }, (_, k) => k * 1000);
  const n99 = G.effectifs[G.valeurs.indexOf(-99)];
  const reste = G.valeurs.map((v, k) => ({ v, n: G.effectifs[k] })).filter((b) => b.v !== -99);
  const xMoy = $derived(e >= 2 ? xPropre : xBrute);
</script>

<div class="visuel mystere" bind:this={hote}>
  <svg viewBox="0 0 660 400" role="img" aria-label="Diagramme à barres de l'échelle gauche-droite, de 0 à 10, avec {milliers(n99)} réponses codées -99. Avec les -99, R calcule une moyenne de {virgule(G.moyenneBrute)}, hors de l'échelle. Une fois les -99 changés en NA, la moyenne est de {virgule(G.moyennePropre)}.">
    {#each graduations as g}
      <line x1={X99 - 38} y1={y(g)} x2={X99 - 30} y2={y(g)} class="axe" />
      <text x={X99 - 44} y={y(g) + 5} class="tick d">{milliers(g)}</text>
    {/each}
    <line x1={X99 - 30} y1={Y0} x2={X99 - 30} y2={Y1 - 10} class="axe" />
    <!-- l'axe coupé -->
    <line x1={X99 - 30} y1={Y0} x2={XC - 10} y2={Y0} class="axe" />
    <text x={XC} y={Y0 + 7} class="coupure">//</text>
    <line x1={XC + 10} y1={Y0} x2={X1} y2={Y0} class="axe" />

    <!-- la barre -99 -->
    <g class="b99" class:parti={e >= 1}>
      <rect x={X99 - pas / 2 + 4} y={y(n99)} width={pas - 8} height={Y0 - y(n99)} class="barre rouge" />
      <text x={X99} y={y(n99) - 10} class="val">{milliers(n99)}</text>
    </g>
    <text x={X99} y={Y0 + 26} class="tick" class:rouge-t={e < 1}>{e >= 1 ? 'NA' : '−99'}</text>

    {#each reste as b, k}
      <rect x={X0 + k * pas + 4} y={y(b.n)} width={pas - 8} height={Y0 - y(b.n)} class="barre" style="animation-delay: {k * 50}ms" />
      <text x={cx(b.v)} y={Y0 + 26} class="tick">{b.v}</text>
    {/each}
    <text x={(X0 + X1) / 2} y={Y0 + 58} class="lab">0 = gauche · 10 = droite</text>

    <g class="moy" style="transform: translateX({xMoy}px)">
      <line x1="0" y1={Y0} x2="0" y2={Y1 - 20} />
      <text x="10" y={Y1 - 6} class:propre={e >= 2}>moyenne · {virgule(e >= 2 ? G.moyennePropre : G.moyenneBrute)}</text>
    </g>
  </svg>
  <p class="source">Étude électorale canadienne 2025 · cps25_lr_scale_bef_1</p>
</div>

<style>
  .mystere { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .coupure { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .rouge-t { fill: var(--dk-accent); font-weight: 600; }
  .lab { font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }
  .val { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .barre { fill: var(--dk-gris-2); animation: monte 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: bottom; transform-box: fill-box; }
  .barre.rouge { fill: var(--dk-accent); }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .b99 { transition: opacity 0.5s, transform 0.6s cubic-bezier(0.6, 0, 0.9, 0.5); }
  .b99.parti { opacity: 0; transform: translateY(60px); }
  .moy { transition: transform 0.9s cubic-bezier(0.34, 1.3, 0.64, 1); animation: fondu 0.4s 0.8s both; }
  .moy line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 8; }
  .moy text { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .moy text.propre { fill: var(--dk-encre); }
  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .barre, .moy { animation: none; }
    .moy, .b99 { transition: none; }
  }
</style>
