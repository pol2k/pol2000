<script>
  /**
   * L'échelle, c'est la moyenne des onze questions. Trois personnes fictives,
   * onze réponses chacune, recodées de 0 (gauche) à 1 (droite). Chaque
   * réponse est un point, empilé sur sa valeur. Au clic :
   *
   *   0  les onze réponses de chaque personne, et la règle commune en bas;
   *   1  le calcul : la somme, divisée par 11, et le point d'équilibre;
   *   2  les onze points glissent vers ce point : il n'en reste qu'un;
   *   3  les trois scores descendent sur la même règle gauche-droite.
   *
   * Données fictives : les moyennes sont calculées ici, pas tapées.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const W = 1100, X0 = 200, LX = 600, PAS = 100, B0 = 95, RY = 362, H = 410;
  const PT = 17, R = 8;
  const x = (v) => X0 + v * LX;
  const f2 = (v) => v.toFixed(2).replace('.', ',');
  const fs = (v) => String(v).replace('.', ',');
  const VALEURS = [0, 0.25, 0.5, 0.75, 1];
  const ETIQ = ['0', '0,25', '0,5', '0,75', '1'];

  const P = [
    { l: 'A', rep: [0, 0.25, 0, 0.5, 0.25, 0.5, 0.25, 0.5, 0, 0.5, 0.25] },
    { l: 'B', rep: [0.5, 0.25, 0.75, 0.5, 0.5, 0.25, 0.75, 0.5, 1, 0.25, 0.75] },
    { l: 'C', rep: [0.75, 1, 0.5, 1, 0.75, 0.75, 1, 0.5, 0.75, 1, 0.5] }
  ].map((p, j) => {
    const b = B0 + j * PAS;
    const somme = p.rep.reduce((s, v) => s + v, 0);
    const m = somme / p.rep.length;
    const vus = {};
    const pts = p.rep.map((v, i) => {
      const k = (vus[v] = (vus[v] ?? -1) + 1);
      return { v, i, cx: x(v), cy: b - R - 3 - k * PT };
    });
    return { ...p, b, somme, m, pts };
  });

  const DIT = [
    'Chaque point : une réponse, de 0 (gauche) à 1 (droite).',
    'On additionne les onze réponses, on divise par 11.',
    'La moyenne : le point d’équilibre des onze réponses.',
    null
  ];
  const aria = 'Trois personnes fictives, onze réponses chacune de 0 à 1. ' +
    P.map((p) => `Personne ${p.l} : ${fs(p.somme)} divisé par 11, environ ${f2(p.m)}.`).join(' ') +
    ' Les trois scores sont placés sur une même règle de 0 (gauche) à 1 (droite).';
</script>

<div class="visuel m9moy" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label={aria}>
    {#each P as p}
      <g class="m9moy-rang" class:loin={e >= 3}>
        <text x="0" y={p.b - 20} class="m9moy-qui">Personne {p.l}</text>
        <line x1={x(0)} y1={p.b} x2={x(1)} y2={p.b} class="m9moy-bande" />
        {#each VALEURS as v}
          <line x1={x(v)} y1={p.b - 5} x2={x(v)} y2={p.b + 5} class="m9moy-bande" />
        {/each}
        <polygon points="{x(p.m)},{p.b + 3} {x(p.m) - 10},{p.b + 17} {x(p.m) + 10},{p.b + 17}" class="m9moy-pivot" class:vu={e >= 1 && e < 3} />
        {#each p.pts as d}
          <circle cx={d.cx} cy={d.cy} r={R} class="m9moy-pt" class:fondu={e >= 2}
            style="--d: {d.i * 25}ms; transform: translate({e >= 2 ? x(p.m) - d.cx : 0}px, {e >= 2 ? p.b - d.cy : 0}px)" />
        {/each}
        <text x="840" y={p.b - 20} class="m9moy-calc" class:vu={e >= 1}>{fs(p.somme)} ÷ 11 ≈ <tspan class="m9moy-res">{f2(p.m)}</tspan></text>
      </g>
    {/each}

    <g class="m9moy-regle" class:vu={e >= 3}>
      <line x1={x(0)} y1={RY} x2={x(1)} y2={RY} class="m9moy-axe" />
      {#each VALEURS as v, k}
        <line x1={x(v)} y1={RY - 9} x2={x(v)} y2={RY + 9} class="m9moy-tick" />
        <text x={x(v)} y={RY + 38} class="m9moy-n">{ETIQ[k]}</text>
      {/each}
      <text x={x(0) - 22} y={RY + 8} class="m9moy-bout fin">gauche</text>
      <text x={x(1) + 22} y={RY + 8} class="m9moy-bout">droite</text>
    </g>

    {#each P as p}
      <g class="m9moy-score" class:vu={e >= 2} style="transform: translateY({e >= 3 ? RY - p.b : 0}px)">
        <circle cx={x(p.m)} cy={p.b} r="16" class="m9moy-rouge" />
        <text x={x(p.m)} y={p.b + 7} class="m9moy-lettre">{p.l}</text>
        <text x={x(p.m)} y={p.b - 26} class="m9moy-val">{f2(p.m)}</text>
      </g>
    {/each}
  </svg>
  <div class="m9moy-pied">
    {#key e}
      <p class="m9moy-dit">
        {#if DIT[e]}{DIT[e]}{:else}Un score par personne, de 0 à 1 : c’est <code>rowMeans()</code>.{/if}
      </p>
    {/key}
    <p class="credits m9moy-src">Données fictives : un schéma.</p>
  </div>
</div>

<style>
  .m9moy { display: flex; flex-direction: column; gap: 0.4em; max-width: 62em; margin: 0.4em auto 0; }
  svg { width: 100%; height: auto; max-height: 46vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9moy-rang { transition: opacity 0.5s; }
  .m9moy-rang.loin { opacity: 0.25; }
  .m9moy-qui { font-size: 26px; font-weight: 700; }
  .m9moy-bande { stroke: var(--dk-gris); stroke-width: 2; }
  .m9moy-pivot { fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .m9moy-pivot.vu { opacity: 1; }
  .m9moy-pt { fill: var(--dk-encre); transition: transform 0.7s var(--d), opacity 0.2s; }
  .m9moy-pt.fondu { opacity: 0; transition: transform 0.7s var(--d), opacity 0.2s calc(var(--d) + 0.7s); }
  .m9moy-calc { font-size: 24px; font-weight: 600; opacity: 0; transition: opacity 0.4s; }
  .m9moy-calc.vu { opacity: 1; }
  .m9moy-res { fill: var(--dk-accent); font-weight: 700; }
  .m9moy-regle { opacity: 0.45; transition: opacity 0.5s; }
  .m9moy-regle.vu { opacity: 1; }
  .m9moy-axe { stroke: var(--dk-encre); stroke-width: 4; }
  .m9moy-tick { stroke: var(--dk-encre); stroke-width: 3; }
  .m9moy-n { font-size: 22px; font-weight: 600; text-anchor: middle; }
  .m9moy-bout { font-size: 22px; fill: var(--dk-gris); font-weight: 600; }
  .m9moy-bout.fin { text-anchor: end; }
  .m9moy-score { opacity: 0; transition: opacity 0.2s, transform 0.8s; }
  .m9moy-score.vu { opacity: 1; transition: opacity 0.3s 0.8s, transform 0.8s; }
  .m9moy-rouge { fill: var(--dk-accent); stroke: var(--dk-encre); stroke-width: 2; }
  .m9moy-lettre { font-size: 20px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }
  .m9moy-val { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .m9moy-pied { border-top: 2px solid var(--dk-encre); padding-top: 0.4em; display: flex; flex-direction: column; gap: 0.2em; }
  .m9moy-dit { margin: 0; font-size: 1.1em; font-weight: 700; text-align: center; animation: m9moy-fondu 0.4s both; }
  .m9moy-dit code { color: var(--dk-accent); }
  .m9moy-src { margin: 0; }
  @keyframes m9moy-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .m9moy-rang, .m9moy-pivot, .m9moy-pt, .m9moy-pt.fondu, .m9moy-calc, .m9moy-regle, .m9moy-score, .m9moy-score.vu { transition: none; }
    .m9moy-dit { animation: none; }
  }
</style>
