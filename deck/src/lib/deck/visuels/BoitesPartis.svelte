<script>
  /**
   * L'âge, parti par parti : une boîte à moustaches par intention de vote
   * (codes 1 à 5), telle que ggplot_build() la calcule sur l'Étude électorale
   * canadienne 2025 (src/lib/data/seance3.js).
   *
   *   0  Les médianes tombent en place.
   *   1  Les boîtes s'ouvrent depuis la médiane (du 1er au 3e quartile).
   *   2  Les moustaches se tracent jusqu'au plus jeune et au plus âgé.
   *   3  NPD et Vert restent allumés, médianes 41 et 43 ; Libéral et Bloc,
   *      médiane 55, en retrait ; Conservateur s'efface.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { AGE_PARTIS } from '$lib/data/seance3.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 3,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  const NOMS = ['Libéral', 'Conservateur', 'NPD', 'Bloc Québécois', 'Vert'];
  const COUL = ['#d71920', '#1a4782', '#f37021', '#33b2cc', '#3d9b35'];
  const JEUNES = [2, 4];
  const AINES = [0, 3];

  const W = 1000, RH = 74, TOP = 26, XL = 240, XR = 960;
  const YA = TOP + RH * 5 + 4;
  const H = YA + 62;
  const x = (v) => XL + ((v - 15) / 85) * (XR - XL);
  const cy = (i) => TOP + RH * i + RH / 2;
  const ticks = [20, 30, 40, 50, 60, 70, 80, 90, 100];
</script>

<div class="visuel boites" bind:this={hote}>
  <pre class="code">ggplot(d, aes(x = age, y = parti)) + geom_boxplot()</pre>
  {#key tour}
    <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label="Boîtes à moustaches de l'âge selon l'intention de vote, Étude électorale canadienne 2025 : médianes de 55 ans chez les libéraux et au Bloc, 50 chez les conservateurs, 41 au NPD et 43 chez les verts.">
      {#each ticks as t}
        <path d="M {x(t)} {TOP} L {x(t)} {YA}" class="grille" />
        <text x={x(t)} y={YA + 26} class="tick">{t}</text>
      {/each}
      <path d="M {XL} {YA} L {XR} {YA}" class="axe" />
      <text x={(XL + XR) / 2} y={H - 6} class="lab">Âge</text>

      {#each AGE_PARTIS as p, i}
        {@const c = cy(i)}
        <g class="rang" class:terne={e >= 3 && !JEUNES.includes(i) && !AINES.includes(i)} class:retrait={e >= 3 && AINES.includes(i)} style="--c: {COUL[i]}; --i: {i}">
          <text x={XL - 26} y={c + 7} class="nom">{NOMS[i]}</text>
          <path d="M {x(p.q1)} {c} L {x(p.min)} {c} M {x(p.min)} {c - 12} L {x(p.min)} {c + 12}" pathLength="1" class="moust" class:vu={e >= 2} />
          <path d="M {x(p.q3)} {c} L {x(p.max)} {c} M {x(p.max)} {c - 12} L {x(p.max)} {c + 12}" pathLength="1" class="moust" class:vu={e >= 2} />
          <rect x={x(p.q1)} y={c - 19} width={x(p.q3) - x(p.q1)} height="38" class="boite" class:vu={e >= 1} style="transform-origin: {x(p.med)}px {c}px" />
          <path d="M {x(p.med)} {c - 25} L {x(p.med)} {c + 25}" class="med" />
          {#if e >= 3 && (JEUNES.includes(i) || AINES.includes(i))}
            <text x={x(p.med)} y={c - 31} class="val" class:fort={JEUNES.includes(i)}>{p.med}</text>
          {/if}
        </g>
      {/each}
    </svg>
  {/key}
  <p class="legende">Étude électorale canadienne 2025 · intention de vote</p>
</div>

<style>
  .boites { display: flex; flex-direction: column; gap: 0.6em; flex: 1 1 auto; min-height: 0; }
  .code {
    flex: none;
    align-self: flex-start;
    margin: 0;
    font-family: var(--dk-mono);
    font-size: 0.78em;
    border: 3px solid var(--dk-encre);
    padding: 0.45em 0.9em;
    white-space: pre;
  }
  svg { flex: 1 1 0; min-height: 0; max-height: 60vh; width: 100%; display: block; }
  text { font-family: var(--dk-mono); }
  .grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .lab { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .rang { transition: opacity 0.5s; }
  .rang.terne { opacity: 0.18; }
  .rang.retrait { opacity: 0.5; }
  .nom { font-size: 21px; font-weight: 600; text-anchor: end; fill: var(--c); }

  .med {
    stroke: var(--c);
    stroke-width: 7;
    animation: chute 0.6s cubic-bezier(0.34, 1.7, 0.64, 1) backwards;
    animation-delay: calc(var(--i) * 110ms + 100ms);
  }
  .boite {
    fill: var(--c);
    fill-opacity: 0.18;
    stroke: var(--c);
    stroke-width: 3;
    transform-box: view-box;
    transform: scaleX(0);
    transition: transform 0.35s ease-in;
  }
  .boite.vu {
    transform: none;
    transition: transform 0.7s cubic-bezier(0.34, 1.56, 0.64, 1);
    transition-delay: calc(var(--i) * 90ms);
  }
  .moust {
    fill: none;
    stroke: var(--c);
    stroke-width: 3;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    transition: stroke-dashoffset 0.25s;
  }
  .moust.vu {
    stroke-dashoffset: 0;
    transition: stroke-dashoffset 0.7s ease-out;
    transition-delay: calc(var(--i) * 90ms);
  }
  .val {
    font-size: 20px;
    font-weight: 600;
    text-anchor: middle;
    fill: var(--dk-gris);
    transform-box: fill-box;
    transform-origin: center bottom;
    animation: pop 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) backwards;
  }
  .val.fort { fill: var(--dk-accent); font-size: 24px; }

  .legende { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes chute { from { opacity: 0; transform: translateY(-60px); } }
  @keyframes pop { from { opacity: 0; transform: scale(0.3); } }

  @media (prefers-reduced-motion: reduce) {
    .rang, .med, .boite, .moust, .val { animation: none !important; transition: none !important; }
  }
</style>
