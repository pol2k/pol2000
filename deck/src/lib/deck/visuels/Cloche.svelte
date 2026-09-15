<script>
  /**
   * La règle 68, 95, 99,7, en schéma. La cloche est tracée en JavaScript à
   * partir de la forme de la loi normale : c'est un dessin, pas une donnée,
   * et la figure le dit.
   *
   *   0  La cloche se trace, la moyenne et les repères à ±1, ±2, ±3 écarts
   *      types apparaissent.
   *   1  L'aire entre −1 et +1 écart type se remplit comme de l'eau qui
   *      monte : 68 %.
   *   2  Entre −2 et +2 : 95 %. Le chiffre précédent rapetisse, reste.
   *   3  Entre −3 et +3 : 99,7 %.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const BASE = 370, H = 270, ZMAX = 3.6, CX = 500, DEMI = 420;
  const x = (z) => CX + (z * DEMI) / ZMAX;
  const y = (z) => BASE - H * Math.exp((-z * z) / 2);
  const trace = (a, b, pas = 120) =>
    Array.from({ length: pas + 1 }, (_, i) => {
      const z = a + (i * (b - a)) / pas;
      return `${x(z).toFixed(1)} ${y(z).toFixed(1)}`;
    });
  const COURBE = 'M ' + trace(-ZMAX, ZMAX, 160).join(' L ');
  const aire = (k) => `M ${x(-k)} ${BASE} L ${trace(-k, k).join(' L ')} L ${x(k)} ${BASE} Z`;

  const BANDES = [
    { k: 1, pct: '68 %', op: 0.7 },
    { k: 2, pct: '95 %', op: 0.35 },
    { k: 3, pct: '99,7 %', op: 0.15 }
  ];
  const REPERES = [-3, -2, -1, 0, 1, 2, 3];
  const nomRepere = (z) => (z === 0 ? 'moyenne' : `${z < 0 ? '−' : '+'}${Math.abs(z)} ét`);
</script>

<div class="visuel cloche" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="Une courbe en cloche : 68 % des valeurs à moins d'un écart type de la moyenne, 95 % à moins de deux, 99,7 % à moins de trois. Schéma.">
    <defs>
      {#each BANDES as b}
        <clipPath id="cloche-eau-{b.k}">
          <rect x="0" y={BASE - H - 20} width="1000" height={H + 20} class="niveau" class:monte={e >= b.k} />
        </clipPath>
      {/each}
    </defs>

    <!-- Les aires, de la plus large à la plus étroite. -->
    {#each [...BANDES].reverse() as b}
      <path d={aire(b.k)} class="aire" style="fill-opacity: {b.op}" clip-path="url(#cloche-eau-{b.k})" />
    {/each}

    <line x1={x(0)} y1={BASE} x2={x(0)} y2={y(0)} class="centre" />
    <path d={COURBE} pathLength="1" class="courbe" />
    <line x1={x(-ZMAX)} y1={BASE} x2={x(ZMAX)} y2={BASE} class="axe" />
    {#each REPERES as z, i}
      <g class="repere" style="--d: {0.9 + i * 0.07}s">
        <line x1={x(z)} y1={BASE} x2={x(z)} y2={BASE + 9} class="axe" />
        <text x={x(z)} y={BASE + 32} class="tick" class:moy={z === 0}>{nomRepere(z)}</text>
      </g>
    {/each}

    <!-- Les pourcentages, en haut à gauche : le dernier en grand. -->
    {#each BANDES as b, j}
      <g class="ligne" class:vu={e >= b.k} class:petite={e > b.k} style="transform: translateY({60 + j * 56}px)">
        <rect x="0" y="-22" width="24" height="24" style="fill-opacity: {b.op}" />
        <text x="38" y="0">±{b.k} ét · {b.pct}</text>
      </g>
    {/each}

    <text x={x(-ZMAX)} y="448" class="note">ét = écart type</text>
    <text x={x(ZMAX)} y="448" class="note d">Quand la distribution a la forme d'une cloche · schéma</text>
  </svg>
</div>

<style>
  .cloche { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .courbe { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: tracer 1.3s ease-in-out forwards; }
  @keyframes tracer { to { stroke-dashoffset: 0; } }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .centre { stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 6 6; }
  .repere { opacity: 0; animation: fondu 0.4s both; animation-delay: var(--d); }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.moy { fill: var(--dk-encre); font-weight: 600; }

  .aire { fill: var(--dk-accent); stroke: none; }
  .niveau { transform: translateY(300px); transition: transform 1.1s cubic-bezier(0.3, 1.2, 0.6, 1); }
  .niveau.monte { transform: none; }

  .ligne { opacity: 0; transition: opacity 0.4s; }
  .ligne.vu { opacity: 1; }
  .ligne rect { fill: var(--dk-accent); stroke: var(--dk-accent); stroke-width: 2; transition: transform 0.5s; transform-box: fill-box; transform-origin: 0 100%; }
  .ligne text { font-size: 32px; font-weight: 600; fill: var(--dk-accent); transform-box: fill-box; transform-origin: 0 100%; transition: transform 0.5s cubic-bezier(0.34, 1.4, 0.64, 1), fill 0.4s; }
  .ligne.petite text { transform: scale(0.6); fill: var(--dk-gris); }
  .ligne.petite rect { transform: scale(0.75); }

  .note { font-size: 14px; fill: var(--dk-gris-2); letter-spacing: 0.04em; }
  .note.d { text-anchor: end; }

  @media (prefers-reduced-motion: reduce) {
    .courbe { animation: none; stroke-dashoffset: 0; }
    .repere { animation: none; opacity: 1; }
    .niveau, .ligne, .ligne text, .ligne rect { transition: none; }
  }
</style>
