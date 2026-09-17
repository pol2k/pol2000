<script>
  /**
   * Un aes, trois geoms, sur l'âge des 20 180 répondant.e.s de l'Étude
   * électorale canadienne 2025, la variable de jeudi dernier. Les barres,
   * la boîte et la courbe sont ce que ggplot_build() calcule
   * (src/lib/data/seance3.js, généré par outils/seance3_data.R).
   *
   *   0  geom_histogram() : les barres montent.
   *   1  geom_boxplot() : les barres filent dans la boîte, qui s'ouvre
   *      depuis la médiane ; les moustaches se tracent.
   *   2  geom_density() : la boîte se dissout, la courbe se dessine.
   *
   * La ligne de code du bas change à chaque temps ; la première ne bouge pas.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { AGE_HIST, AGE_BOITE, AGE_DENSITE } from '$lib/data/seance3.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 2,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  const GEOMS = ['geom_histogram(binwidth = 5, boundary = 15)', 'geom_boxplot()', 'geom_density()'];

  const W = 1000, H = 370, X0 = 60, X1 = 960, Y0 = 300, Y1 = 24;
  const x = (v) => X0 + ((v - 15) / 85) * (X1 - X0);
  const maxN = Math.max(...AGE_HIST.effectifs);
  const yh = (n) => Y0 - (n / maxN) * (Y0 - Y1);

  // La boîte, couchée au milieu du dessin comme geom_boxplot(aes(x = …)).
  const CY = 168, BH = 118;
  const B = AGE_BOITE;
  const barres = AGE_HIST.effectifs.map((n, i) => {
    const x0 = x(AGE_HIST.debut[i]), x1 = x(AGE_HIST.fin[i]);
    return { x: x0, w: x1 - x0, y: yh(n), h: Y0 - yh(n), dx: x(B.med) - (x0 + x1) / 2, dy: CY - (yh(n) + Y0) / 2 };
  });

  const maxD = Math.max(...AGE_DENSITE.y);
  const yd = (d) => Y0 - (d / maxD) * (Y0 - Y1 - 16);
  const courbe = AGE_DENSITE.x.map((v, i) => `${i ? 'L' : 'M'} ${x(v).toFixed(1)} ${yd(AGE_DENSITE.y[i]).toFixed(1)}`).join(' ');
  const aire = `${courbe} L ${x(AGE_DENSITE.x[AGE_DENSITE.x.length - 1]).toFixed(1)} ${Y0} L ${x(AGE_DENSITE.x[0]).toFixed(1)} ${Y0} Z`;
  const ticks = [20, 30, 40, 50, 60, 70, 80, 90, 100];
</script>

<div class="visuel geoms" bind:this={hote}>
  <pre class="code">ggplot(df, aes(x = cps25_age_in_years)) +
  {#key e}<span class="geom">{GEOMS[e]}</span>{/key}</pre>
  {#key tour}
    <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label="L'âge des répondant.e.s de l'Étude électorale canadienne 2025, dessiné en histogramme, puis en boîte à moustaches, puis en courbe de densité.">
      <path d="M {X0} {Y0} L {X1} {Y0}" class="axe" />
      {#each ticks as t}
        <path d="M {x(t)} {Y0} L {x(t)} {Y0 + 8}" class="axe" />
        <text x={x(t)} y={Y0 + 28} class="tick">{t}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={H - 6} class="lab">cps25_age_in_years</text>

      <g>
        {#each barres as b, i}
          <g class="vol" class:parti={e >= 1} style="--dx: {b.dx}px; --dy: {b.dy}px; --i: {i}">
            <rect x={b.x} y={b.y} width={b.w} height={b.h} class="barre" style="--i: {i}" />
          </g>
        {/each}
      </g>

      <g class="boite" class:vu={e === 1}>
        <path d="M {x(B.q1)} {CY} L {x(B.min)} {CY} M {x(B.min)} {CY - 22} L {x(B.min)} {CY + 22}" pathLength="1" class="moust" />
        <path d="M {x(B.q3)} {CY} L {x(B.max)} {CY} M {x(B.max)} {CY - 22} L {x(B.max)} {CY + 22}" pathLength="1" class="moust" />
        <g class="corps" style="transform-origin: {x(B.med)}px {CY}px">
          <rect x={x(B.q1)} y={CY - BH / 2} width={x(B.q3) - x(B.q1)} height={BH} class="rect" />
          <path d="M {x(B.med)} {CY - BH / 2} L {x(B.med)} {CY + BH / 2}" class="med" />
        </g>
        {#each [B.q1, B.med, B.q3] as v}
          <text x={x(v)} y={CY - BH / 2 - 14} class="val">{v}</text>
        {/each}
      </g>

      <g class="dens" class:vu={e >= 2}>
        <path d={aire} class="aire" />
        <path d={courbe} pathLength="1" class="ligne" />
      </g>
    </svg>
  {/key}
</div>

<style>
  .geoms { display: flex; flex-direction: column; gap: 0.7em; flex: 1 1 auto; min-height: 0; }
  .code {
    flex: none;
    margin: 0;
    font-family: var(--dk-mono);
    font-size: 0.8em;
    line-height: 1.55;
    border: 3px solid var(--dk-encre);
    padding: 0.55em 0.9em;
    white-space: pre;
    overflow: hidden;
  }
  .geom {
    display: inline-block;
    color: var(--dk-accent);
    font-weight: 600;
    animation: glisse 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
  }
  svg { flex: 1 1 0; min-height: 0; max-height: 60vh; width: 100%; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .lab { font-size: 17px; text-anchor: middle; fill: var(--dk-encre); }

  /* Les barres : elles montent à l'arrivée, puis filent vers la médiane. */
  .vol {
    transform-box: fill-box;
    transform-origin: center;
    transition: transform 0.75s cubic-bezier(0.6, -0.25, 0.7, 1), opacity 0.5s ease-in;
    transition-delay: calc(var(--i) * 28ms);
  }
  .vol.parti { transform: translate(var(--dx), var(--dy)) scale(0.08); opacity: 0; }
  .barre {
    fill: var(--dk-gris-2);
    stroke: var(--dk-fond);
    stroke-width: 2;
    transform-box: fill-box;
    transform-origin: bottom;
    animation: monte 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
    animation-delay: calc(var(--i) * 45ms);
  }

  /* La boîte : elle s'ouvre depuis la médiane, puis les moustaches filent. */
  .corps {
    transform-box: view-box;
    transform: scale(0, 0.3);
    transition: transform 0.7s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  .vu .corps { transform: none; transition-delay: 0.45s; }
  .rect { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .med { stroke: var(--dk-accent); stroke-width: 7; }
  .moust {
    fill: none;
    stroke: var(--dk-encre);
    stroke-width: 4;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    transition: stroke-dashoffset 0.3s ease-in;
  }
  .vu .moust { stroke-dashoffset: 0; transition: stroke-dashoffset 0.6s ease-out 1s; }
  .val { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .vu .val { opacity: 1; transition-delay: 1.2s; }

  /* La densité : la ligne se trace, l'aire se remplit ensuite. */
  .aire { fill: var(--dk-accent); fill-opacity: 0; transition: fill-opacity 0.3s; }
  .vu .aire { fill-opacity: 0.16; transition: fill-opacity 0.6s 1.3s; }
  .ligne {
    fill: none;
    stroke: var(--dk-accent);
    stroke-width: 5;
    stroke-linejoin: round;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    transition: stroke-dashoffset 0.3s;
  }
  .vu .ligne { stroke-dashoffset: 0; transition: stroke-dashoffset 1.3s ease-in-out 0.35s; }

  @keyframes glisse { from { opacity: 0; transform: translateY(-0.7em); } }
  @keyframes monte { from { transform: scaleY(0); } }

  @media (prefers-reduced-motion: reduce) {
    .geom, .vol, .barre, .corps, .moust, .val, .aire, .ligne { animation: none !important; transition: none !important; }
  }
</style>
