<script>
  /**
   * Mille échantillons de 50 : leurs moyennes s'empilent en histogramme, et
   * la forme qui apparaît est la distribution d'échantillonnage.
   *
   * Les moyennes viennent de MOYENNES_50, dans l'ordre où R les a tirées
   * (src/lib/data/seance5.js, graine 4 dans outils/seance5_data.R). Les
   * tranches d'un an viennent de BORNES : [a, a + 1). Les effectifs sont
   * comptés ici sur les k premières moyennes; à k = 1 000, ils égalent
   * DISTRIBUTIONS[1].effectifs (vérifié). L'échelle verticale est fixée
   * par le plus haut bâton à k = 1 000 : les bâtons grandissent. Sous
   * l'axe, un petit trait par moyenne déjà tirée.
   *
   *   0  Un échantillon : une moyenne, un trait rouge et sa valeur.
   *   1  Dix.
   *   2  Cent.
   *   3  Mille; la forme est nommée : la distribution d'échantillonnage,
   *      centrée sur la vraie moyenne (POP.moyenne, ligne pointillée).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, BORNES, DISTRIBUTIONS, MOYENNES_50 } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const TAILLE = DISTRIBUTIONS[1].n;
  const K = [1, 10, 100, 1000];

  // La tranche de chaque moyenne : BORNES[j] <= m < BORNES[j + 1].
  const tranche = (m) => BORNES.findLastIndex((b) => b <= m);
  const compter = (k) => {
    const c = new Array(BORNES.length - 1).fill(0);
    for (const m of MOYENNES_50.slice(0, k)) c[tranche(m)]++;
    return c;
  };
  const EFF = K.map(compter);
  const YMAX = Math.max(...EFF[EFF.length - 1]);

  // L'axe : de 38 à 62 ans.
  const AMIN = 38, AMAX = 62, X0 = 80, X1 = 920;
  const x = (v) => X0 + ((v - AMIN) / (AMAX - AMIN)) * (X1 - X0);
  const AXE = 380, HMAX = 280;
  const LARGE = x(1) - x(0);
  const BATONS = BORNES.slice(0, -1).map((a, j) => ({ a, j })).filter((b) => b.a >= AMIN && b.a < AMAX);

  const k = $derived(K[e]);
  const eff = $derived(EFF[e]);
  const PREMIERE = MOYENNES_50[0];
  const XP = x(POP.moyenne);
</script>

<div class="visuel mille-ech" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="Les moyennes d’âge de {f(K[3])} échantillons de {TAILLE} personnes, empilées en histogramme : 1, puis 10, puis 100, puis {f(K[3])}. La forme obtenue, la distribution d’échantillonnage, est centrée sur l’âge moyen des {f(POP.n)}, {f(POP.moyenne, 1)} ans.">
    <!-- Le compteur. -->
    <text x={X0} y="38" class="me-compte"><tspan class="me-k">{f(k)}</tspan> échantillon{k > 1 ? 's' : ''} de {TAILLE}</text>

    <!-- Les bâtons. -->
    {#each BATONS as b}
      <rect x={x(b.a) + 1.5} y={AXE - HMAX} width={LARGE - 3} height={HMAX} class="me-baton"
            style="transform: scaleY({eff[b.j] / YMAX})" />
    {/each}

    <!-- La vraie moyenne. -->
    <line x1={XP} y1="84" x2={XP} y2={AXE} class="me-pop" />
    <text x={XP} y="72" class="me-pop-t">les {f(POP.n)}&#8239;: {f(POP.moyenne, 1)} ans</text>

    <!-- L'axe, et un trait par moyenne déjà tirée. -->
    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="me-axe" />
    {#each MOYENNES_50 as m, i}
      <line x1={x(m)} y1={AXE + 6} x2={x(m)} y2={AXE + 22} class="me-trait" class:me-vu={i < k} class:me-premier={i === 0 && k === 1} />
    {/each}
    {#each [40, 45, 50, 55, 60] as t}
      <text x={x(t)} y={AXE + 48} class="me-tick">{t}</text>
    {/each}
    <text x={X1} y={AXE + 74} class="me-tick me-fin">âge moyen de chaque échantillon (ans)</text>

    <!-- 0 : la valeur de la première moyenne. -->
    <text x={x(PREMIERE) + 10} y={AXE - 14} class="me-une" class:me-vu={e === 0}>{f(PREMIERE, 1)} ans</text>

    <!-- 3 : la forme a un nom. -->
    <g class="me-nom" class:me-vu={e === 3}>
      <path d="M 672 204 L 634 282" class="me-lien" />
      <text x="680" y="186" class="me-nom-t">la distribution</text>
      <text x="680" y="214" class="me-nom-t">d’échantillonnage</text>
      <text x="680" y="244" class="me-note">centrée sur la vraie moyenne</text>
    </g>
  </svg>
</div>

<style>
  .mille-ech { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .me-compte { font-size: 30px; font-weight: 600; fill: var(--dk-encre); }
  .me-k { fill: var(--dk-accent); }

  .me-baton { fill: var(--dk-encre); transform-box: fill-box; transform-origin: 50% 100%; transition: transform 0.7s cubic-bezier(0.34, 1.2, 0.64, 1); }

  .me-pop { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .me-pop-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .me-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .me-trait { stroke: var(--dk-encre); stroke-width: 2; opacity: 0; transition: opacity 0.4s; }
  .me-trait.me-vu { opacity: 0.35; }
  .me-trait.me-premier { stroke: var(--dk-accent); stroke-width: 4; opacity: 1; }
  .me-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .me-fin { text-anchor: end; }

  .me-une { font-size: 22px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.2s; }
  .me-une.me-vu { opacity: 1; transition: opacity 0.4s 0.3s; }

  .me-nom { opacity: 0; transition: opacity 0.2s; }
  .me-nom.me-vu { opacity: 1; transition: opacity 0.5s 0.8s; }
  .me-lien { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .me-nom-t { font-size: 24px; font-weight: 600; fill: var(--dk-accent); }
  .me-note { font-size: 18px; fill: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .me-baton, .me-trait, .me-une, .me-une.me-vu, .me-nom, .me-nom.me-vu { transition: none; }
  }
</style>
