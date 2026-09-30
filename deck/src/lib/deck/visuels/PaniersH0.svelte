<script>
  /**
   * Le monde de H0, construit panier par panier. Si H0 était vraie, les
   * pommes de la pomicultrice seraient ordinaires : 100 g en moyenne. On
   * remplit 1 000 paniers de 50 pommes dans ce monde-là, et on regarde où
   * tombe le vrai panier. Tout vient de PANIERS
   * (src/lib/data/seance5_normale.js, simulation d'outils/seance5_normale.R,
   * pommes fictives, dit à l'écran).
   *
   * Avec panier = 105 (la diapo principale), cinq temps :
   *   0  L'axe des poids, la ligne de 100 g : le monde de H0.
   *   1  Dix paniers tombent, un carré chacun, avec leur poids : même avec
   *      des pommes ordinaires, un panier peut peser 97 g ou 103 g.
   *   2  Mille paniers : les bâtons montent (environ trois secondes); une
   *      cloche autour de 100 g.
   *   3  Le vrai panier, 105 g, en rouge; les paniers aussi lourds passent
   *      au rouge; le compte, lu dans les données.
   *   4  Le verdict, en mots.
   * Avec panier = 102 (la diapo « et si »), la cloche est déjà là : 0 le
   * monde de H0 rempli, 1 le panier et le compte, 2 le verdict.
   *
   * « Environ k fois sur 100 » est le compte sur 1 000 divisé par 10 et
   * arrondi : un seul chiffre à l'écran, celui de la simulation.
   */
  import { brancherTemps } from '../temps.js';
  import { PANIERS } from '$lib/data/seance5_normale.js';
  let { panier = 105 } = $props();
  const rapide = panier !== 105;
  let e = $state(0);
  let hote = $state(null);
  const TOTAL = rapide ? 2 : 4;
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  // Les temps, ramenés à ceux de la diapo principale.
  const T = $derived(rapide ? e + 2 : e);

  const G0 = 90, G1 = 110, X0 = 70, X1 = 930, BASE = 380, HAUT = 220;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const B = PANIERS.bornes, M = PANIERS.moyennes;
  const L = x(B[1]) - x(B[0]);
  const tranche = (m) => Math.min(B.length - 2, Math.max(0, Math.floor((m - B[0]) / (B[1] - B[0]))));
  const MAX = Math.max(...PANIERS.effectifs);

  // 1 : dix paniers, des carrés empilés dans leur tranche.
  const CARRE = 14;
  const DIX = (() => {
    const pile = new Map();
    return M.slice(0, 10).map((m, i) => {
      const j = tranche(m);
      const h = pile.get(j) ?? 0;
      pile.set(j, h + 1);
      return { m, x: x(B[j]) + L / 2, y: BASE - (h + 1) * (CARRE + 2), i };
    });
  })();

  // 2 : les mille paniers arrivent en trois secondes; état final déterministe.
  const DUREE = 3000;
  let t = $state(0);
  $effect(() => {
    if (T !== 2 || rapide) return;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const combien = $derived(T < 2 ? 0 : T > 2 || rapide ? M.length : Math.min(M.length, Math.round((t / DUREE) * M.length)));
  const COMPTES = $derived.by(() => {
    const c = new Array(B.length - 1).fill(0);
    for (let i = 0; i < combien; i++) c[tranche(M[i])]++;
    return c;
  });

  const XP = x(panier);
  const nb = panier === 105 ? PANIERS.auMoins105 : PANIERS.auMoins102;
  const sur100 = Math.round(nb / 10);
  const rare = nb < 50;
</script>

<div class="visuel paniers-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Le monde de H0 : 1 000 paniers de 50 pommes ordinaires, 100 g en moyenne. Ils forment une cloche autour de 100 g. {f(nb)} paniers sur 1 000 pèsent {panier} g ou plus : environ {sur100} fois sur 100. {rare ? 'C’est rare : on rejette H0.' : 'Ce n’est pas rare : on ne rejette pas H0.'}">
    <text x={X1} y="68" class="ph-note">simulation · pommes fictives</text>
    <text x={X0} y="40" class="ph-titre">le monde de H0&#8239;: des pommes ordinaires, 100 g en moyenne</text>
    <text x={X0} y="68" class="ph-sous">{T >= 2 ? `${f(1000)} paniers de 50 pommes` : T >= 1 ? '10 paniers de 50 pommes' : 'on remplit des paniers de 50 pommes'}</text>

    <!-- 1 : dix paniers. -->
    {#each DIX as d}
      <g class="ph-etape" class:ph-vu={T === 1} style="transition-delay: {T === 1 ? d.i * 180 : 0}ms">
        <rect x={d.x - CARRE / 2} y={d.y} width={CARRE} height={CARRE} class="ph-carre" />
      </g>
    {/each}
    <text x={X0} y="110" class="ph-dix ph-etape" class:ph-vu={T === 1}>{DIX.slice(0, 5).map((d) => f(d.m, 1) + ' g').join(' · ')} · …</text>

    <!-- 2 : mille paniers. -->
    {#each COMPTES as c, j}
      {@const h = (c / MAX) * HAUT}
      <rect x={x(B[j]) + 1} y={BASE - h} width={L - 2} height={h} class="ph-baton" class:ph-rouge={T >= 3 && B[j] >= panier - 1e-9} />
    {/each}

    <!-- L'axe, et 100 g. -->
    <line x1={x(100)} y1="128" x2={x(100)} y2={BASE} class="ph-h0" />
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ph-axe" />
    {#each [90, 95, 100, 105, 110] as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 8} class="ph-axe" />
      <text x={x(g)} y={BASE + 30} class="ph-tick" class:ph-cent={g === 100}>{g} g</text>
    {/each}
    <text x={X1} y={BASE + 56} class="ph-tick ph-fin">poids moyen du panier</text>

    <!-- 3 : notre panier. -->
    <g class="ph-etape" class:ph-vu={T >= 3}>
      <line x1={XP} y1="120" x2={XP} y2={BASE} class="ph-notre" />
      <circle cx={XP} cy={BASE} r="9" class="ph-point" />
      <text x={XP + 14} y="146" class="ph-lab">{panier === 105 ? 'son panier' : 'et si son panier'}&#8239;: {panier} g</text>
      <text x={XP + 14} y="180" class="ph-compte">{f(nb)} sur {f(1000)}</text>
      <text x={XP + 14} y="206" class="ph-lab-s">pèsent {panier} g ou plus</text>
    </g>

    <!-- 4 : le verdict. -->
    <g class="ph-etape" class:ph-vu={T >= 4}>
      <text x="500" y="462" class="ph-verdict">Si H0 était vraie&#8239;: environ {sur100} fois sur 100. {rare ? 'C’est rare.' : 'Ce n’est pas rare.'}</text>
      <text x="500" y="492" class="ph-verdict-2" class:ph-rouge-t={rare}>{rare ? 'On rejette H0 : H0 explique très mal son panier.' : 'On ne rejette pas H0 : on ne peut pas conclure.'}</text>
    </g>
  </svg>
</div>

<style>
  .paniers-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ph-note { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .ph-titre { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .ph-sous { font-size: 19px; fill: var(--dk-gris); }
  .ph-dix { font-size: 19px; fill: var(--dk-encre); }
  .ph-carre { fill: var(--dk-encre); }
  .ph-baton { fill: var(--dk-encre); transition: fill 0.4s; }
  .ph-baton.ph-rouge { fill: var(--dk-accent); }
  .ph-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ph-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ph-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ph-cent { font-weight: 600; fill: var(--dk-encre); }
  .ph-fin { text-anchor: end; }
  .ph-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .ph-point { fill: var(--dk-accent); }
  .ph-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .ph-compte { font-size: 30px; font-weight: 600; fill: var(--dk-accent); }
  .ph-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .ph-verdict { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ph-verdict-2 { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ph-rouge-t { fill: var(--dk-accent); }
  .ph-etape { opacity: 0; transition: opacity 0.2s; }
  .ph-etape.ph-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .ph-etape, .ph-etape.ph-vu, .ph-baton { transition: none; }
  }
</style>
