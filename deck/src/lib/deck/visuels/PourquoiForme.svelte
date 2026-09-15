<script>
  /**
   * Pis, la forme, ça sert à quoi ? Le thermomètre de Pierre Poilievre dans
   * l'Étude électorale canadienne 2025 (FORMES.poilievre, seance3.js) : une
   * distribution en U. Sa moyenne tombe là où presque personne ne se trouve.
   *
   *   0  Les dix barres montent.
   *   1  La moyenne (pointillé rouge) et un bonhomme qui tombe dessus :
   *      « personne ici ? »
   *   2  La tranche 0 à 10 s'allume (36 %), les tranches autour de la
   *      moyenne s'encadrent (11 %) ; la réponse arrive.
   *
   * Les pourcentages sont calculés ici à partir des effectifs exportés par R.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { FORMES } from '$lib/data/seance3.js';
  import Pis from './Pis.svelte';

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

  const P = FORMES.poilievre;
  const X0 = 80, X1 = 940, Y0 = 320, Y1 = 50;
  const max = Math.max(...P.effectifs);
  const x = (v) => X0 + (v / 100) * (X1 - X0);
  const y = (n) => Y0 - (n / max) * (Y0 - Y1);
  const larg = (X1 - X0) / P.effectifs.length;
  const pct = (n) => Math.round((n / P.n) * 100);
  const bas = pct(P.effectifs[0]);
  const milieu = pct(P.effectifs[3] + P.effectifs[4]);
  const moy = Math.round(P.moyenne);
  const hautMilieu = Math.min(y(P.effectifs[3]), y(P.effectifs[4]));
</script>

<Pis stat="la forme" reponse="La moyenne d'une opinion divisée ne décrit presque personne." vu={e >= 2} source="Étude électorale canadienne 2025 · thermomètre de Pierre Poilievre, 0 à 100">
  {#snippet children()}
    <svg bind:this={hote} viewBox="0 0 1000 390" preserveAspectRatio="xMidYMid meet" role="img" aria-label="Thermomètre de Pierre Poilievre : une distribution en U. {bas} % lui donnent 10 ou moins, seulement {milieu} % se situent près de la moyenne de {moy}.">
      {#key tour}
        <g>
          {#each P.effectifs as n, i}
            <rect
              x={X0 + i * larg + 4}
              y={y(n)}
              width={larg - 8}
              height={Y0 - y(n)}
              class="barre-f"
              class:allume={e >= 2 && i === 0}
              class:pale={e >= 2 && i !== 0}
              style="animation-delay: {i * 70}ms"
            />
          {/each}
        </g>
      {/key}
      <line x1={X0 - 10} y1={Y0} x2={X1 + 10} y2={Y0} class="axe-f" />
      {#each [0, 50, 100] as v}
        <line x1={x(v)} y1={Y0} x2={x(v)} y2={Y0 + 8} class="axe-f" />
        <text x={x(v)} y={Y0 + 28} class="tick-f">{v}</text>
      {/each}

      <!-- La moyenne, et quelqu'un qui cherche qui s'y trouve. -->
      <g class="moyenne-f" class:vu={e >= 1}>
        <line x1={x(P.moyenne)} y1={Y0} x2={x(P.moyenne)} y2={Y1 - 16} class="moy-l" />
        <text x={x(P.moyenne) + 10} y={Y1 - 20} class="moy-t">moyenne · {moy}</text>
      </g>
      <g style="transform: translate({x(P.moyenne)}px, {Y0}px)">
        <g class="bonhomme" class:vu={e >= 1}>
          <circle cx="0" cy="-58" r="10" />
          <line x1="0" y1="-48" x2="0" y2="-22" />
          <line x1="-14" y1="-40" x2="14" y2="-40" />
          <line x1="0" y1="-22" x2="-11" y2="0" />
          <line x1="0" y1="-22" x2="11" y2="0" />
          <text x="18" y="-74" class="ici-t">personne ici&#8239;?</text>
        </g>
      </g>

      <!-- Temps 2 : les deux faits qui comptent. -->
      <g class="fait" class:vu={e >= 2}>
        <text x={x(10) + 16} y={y(P.effectifs[0]) + 40} class="fait-t">{bas} %&#8239;: 10 ou moins</text>
      </g>
      <g class="fait" class:vu={e >= 2} style="transition-delay: 0.25s">
        <rect x={x(30) + 2} y={hautMilieu - 8} width={x(50) - x(30) - 4} height={Y0 - hautMilieu + 8} class="cadre-f" />
        <path d="M {x(30) + 4} {Y0 + 40} L {x(30) + 4} {Y0 + 46} L {x(50) - 4} {Y0 + 46} L {x(50) - 4} {Y0 + 40}" class="acc-f" />
        <text x={x(40)} y={Y0 + 66} class="fait-t c">{milieu} % entre 31 et 50</text>
      </g>
    </svg>
  {/snippet}
</Pis>

<style>
  svg { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .barre-f { fill: var(--dk-gris-2); transform-box: fill-box; transform-origin: bottom; animation: monte-f 0.6s cubic-bezier(0.34, 1.5, 0.64, 1) both; transition: fill 0.4s, opacity 0.4s; }
  .barre-f.allume { fill: var(--dk-accent); }
  .barre-f.pale { opacity: 0.55; }
  @keyframes monte-f { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  .axe-f { stroke: var(--dk-encre); stroke-width: 3; }
  .tick-f { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }

  .moyenne-f { opacity: 0; transition: opacity 0.4s; }
  .moyenne-f.vu { opacity: 1; }
  .moy-l { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 8; }
  .moy-t { font-size: 19px; font-weight: 600; fill: var(--dk-accent); }

  .bonhomme { opacity: 0; transform: translateY(-160px); transition: transform 0.7s cubic-bezier(0.34, 1.6, 0.64, 1) 0.2s, opacity 0.2s 0.2s; }
  .bonhomme.vu { opacity: 1; transform: none; }
  .bonhomme circle { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3.5; }
  .bonhomme line { stroke: var(--dk-encre); stroke-width: 3.5; stroke-linecap: square; }
  .ici-t { font-size: 16px; font-weight: 600; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; }

  .fait { opacity: 0; transform: translateY(10px); transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .fait.vu { opacity: 1; transform: none; }
  .fait-t { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }
  .fait-t.c { text-anchor: middle; }
  .cadre-f { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .acc-f { fill: none; stroke: var(--dk-accent); stroke-width: 3; }

  @media (prefers-reduced-motion: reduce) {
    .barre-f { animation: none; }
    .moyenne-f, .bonhomme, .fait { transition: none; }
  }
</style>
