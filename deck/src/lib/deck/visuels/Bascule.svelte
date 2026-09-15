<script>
  /**
   * Le mode, la médiane, la moyenne, sur le vecteur d'Adrien Cloutier
   * (hiver 2024). Des jetons carrés posés sur une droite graduée, elle-même
   * posée sur une bascule. Cinq temps.
   *
   *   0  Les jetons 2, 2, 2, 3 tombent sur la droite (de 0 à 10) ; les trois 2
   *      s'empilent.
   *   1  MODE : la plus haute pile s'allume. 2.
   *   2  MÉDIANE : les jetons se rangent en ligne, on raye les extrêmes paire
   *      par paire, le milieu reste. 2.
   *   3  MOYENNE : les jetons reviennent, le pivot glisse jusqu'au point
   *      d'équilibre, la planche oscille puis se stabilise. 2,25.
   *   4  Un jeton 106 arrive de la droite ; l'échelle passe à 0-110, la planche
   *      bascule, le pivot court jusqu'à 23. La médiane ne bouge pas.
   *
   * Les valeurs sont celles que R donne : mean(c(2, 2, 2, 3)) = 2.25,
   * median() = 2 ; mean(c(2, 2, 2, 3, 106)) = 23, median() = 2.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie (viewBox 760 × 400).
  const X0 = 50, X1 = 710, AY = 300, S = 44, SOL = 372;
  const max = $derived(e >= 4 ? 110 : 10);
  const pos = (v, m) => X0 + (v / m) * (X1 - X0);

  // Les jetons, déjà dans l'ordre. k = rang dans la pile.
  const JETONS = [
    { v: 2, k: 0 },
    { v: 2, k: 1 },
    { v: 2, k: 2 },
    { v: 3, k: 0 }
  ];

  function place(t, j) {
    // Temps 2 : une rangée triée au-dessus de la bascule.
    if (e === 2) return { x: 250 + j * 70 - S / 2, y: 26 };
    // À l'échelle 0-110, 2 et 3 sont presque au même endroit : le 3 monte sur la pile.
    const k = e >= 4 && t.v === 3 ? 3 : t.k;
    return { x: pos(t.v, max) - S / 2, y: AY - S - k * (S + 2) };
  }

  const moyenne = $derived(e >= 4 ? 23 : 2.25);
  const fx = $derived(e >= 3 ? pos(moyenne, max) : pos(5, 10));
  const fmt = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });

  const TICKS_A = Array.from({ length: 11 }, (_, i) => i);
  const TICKS_B = Array.from({ length: 12 }, (_, i) => i * 10);
</script>

<div class="visuel bascule" bind:this={hote}>
  <div class="scene">
    <pre class="chip">x &lt;- c(2, 2, 2, 3{#if e >= 4}<span class="neuf">, 106</span>{/if})</pre>
    <svg viewBox="0 0 760 400" role="img" aria-label="Quatre jetons, 2, 2, 2 et 3, sur une bascule. Le mode et la médiane valent 2, la moyenne 2,25. Un jeton 106 arrive : la moyenne passe à 23, la médiane reste à 2.">
      <line x1="20" y1={SOL} x2="740" y2={SOL} class="sol" />

      <!-- Le pivot : pointillé au repos, rouge une fois la moyenne trouvée. -->
      <g class="pivot" class:actif={e >= 3} class:vite={e >= 4} style="transform: translate({fx}px, 0px)">
        <polygon points="-32,{SOL} 0,{AY + 12} 32,{SOL}" />
        {#if e >= 3}
          {#key moyenne}
            <text y={SOL + 24} class="p-val">{fmt(moyenne)}</text>
          {/key}
        {/if}
      </g>

      <g class="planche" class:osc3={e === 3} class:osc4={e === 4} style="transform-origin: {fx}px {AY + 12}px">
        <rect x={X0 - 22} y={AY} width={X1 - X0 + 44} height="12" class="poutre" />
        {#each TICKS_A as t}
          <g class="tick" class:cache={e >= 4} style="transform: translate({pos(t, max)}px, 0px)">
            <line y1={AY} y2={AY + 12} />
            <text y={AY + 34}>{t}</text>
          </g>
        {/each}
        {#each TICKS_B as t}
          <g class="tick" class:cache={e < 4} style="transform: translate({pos(t, max)}px, 0px)">
            <line y1={AY} y2={AY + 12} />
            <text y={AY + 34}>{t}</text>
          </g>
        {/each}

        {#each JETONS as t, j}
          {@const p = place(t, j)}
          <g class="jeton" class:mode={e === 1 && t.v === 2} class:loin={e >= 4} style="transform: translate({p.x}px, {p.y}px)">
            <g class="chute" style="animation-delay: {j * 140}ms">
              <rect width={S} height={S} />
              <text x={S / 2} y={S / 2 + 9}>{t.v}</text>
            </g>
          </g>
        {/each}

        {#if e >= 4}
          <g class="jeton extreme" style="transform: translate({pos(106, 110) - S / 2}px, {AY - S}px)">
            <g class="vol">
              <rect width={S} height={S} />
              <text x={S / 2} y={S / 2 + 9} class="petit">106</text>
            </g>
          </g>
        {/if}
      </g>

      <!-- Temps 2 : on raye les extrêmes, on encadre le milieu. -->
      {#if e === 2}
        <g class="rayures">
          {#each [0, 3] as j}
            <line x1={250 + j * 70 - S / 2 - 6} y1="20" x2={250 + j * 70 + S / 2 + 6} y2={26 + S + 6} class="raye" />
          {/each}
          <rect x={250 + 70 - S / 2 - 8} y="18" width={70 + S + 16} height={S + 16} class="milieu" />
        </g>
      {/if}
    </svg>
  </div>

  <div class="lecture">
    <div class="ligne" class:vu={e >= 1}>
      <span class="et">MODE</span>
      {#if e >= 1}<span class="val">2</span>{/if}
    </div>
    <div class="ligne" class:vu={e >= 2}>
      <span class="et">MÉDIANE</span>
      {#if e >= 2}
        {#key e >= 4}
          <span class="val" class:flash={e >= 4}>2</span>
        {/key}
      {/if}
    </div>
    <div class="ligne" class:vu={e >= 3}>
      <span class="et">MOYENNE</span>
      {#if e >= 3}
        {#key moyenne}
          <span class="val" class:rouge={e >= 4}>{fmt(moyenne)}</span>
        {/key}
      {/if}
    </div>
  </div>

  <p class="leg" class:vu={e >= 4}>La moyenne court après la valeur extrême. La médiane reste.</p>
</div>

<style>
  .bascule { display: grid; grid-template-columns: 1fr 11em; gap: 0.4em 1.6em; align-items: center; }
  .scene { display: flex; flex-direction: column; gap: 0.3em; min-width: 0; }
  .chip { margin: 0; align-self: flex-start; font-family: var(--dk-mono); font-size: 0.9em; border: 3px solid var(--dk-encre); padding: 0.3em 0.8em; }
  .chip .neuf { color: var(--dk-accent); font-weight: 600; }
  svg { width: 100%; height: auto; max-height: 54vh; display: block; }
  text { font-family: var(--dk-mono); }

  .sol { stroke: var(--dk-filet); stroke-width: 3; }
  .poutre { fill: var(--dk-encre); }

  .pivot { transition: transform 0.9s cubic-bezier(0.34, 1.4, 0.64, 1); }
  .pivot.vite { transition: transform 1s cubic-bezier(0.34, 1.4, 0.64, 1) 0.9s; }
  .pivot polygon { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 7 6; transition: fill 0.4s, stroke 0.4s; }
  .pivot.actif polygon { fill: var(--dk-accent); stroke: var(--dk-accent); stroke-dasharray: none; }
  .p-val { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); animation: pop 0.5s cubic-bezier(0.34, 1.8, 0.64, 1) both; transform-box: fill-box; transform-origin: center; }

  .planche { transform-box: view-box; }
  .planche.osc3 { animation: osc3 1.6s ease-out 0.6s both; }
  .planche.osc4 { animation: osc4 2.6s ease-in-out both; }
  @keyframes osc3 {
    0% { transform: rotate(-7deg); }
    35% { transform: rotate(4deg); }
    65% { transform: rotate(-1.6deg); }
    85% { transform: rotate(0.6deg); }
    100% { transform: rotate(0deg); }
  }
  @keyframes osc4 {
    0%, 20% { transform: rotate(0deg); }
    32% { transform: rotate(9deg); }
    55% { transform: rotate(9deg); }
    72% { transform: rotate(-3deg); }
    86% { transform: rotate(1deg); }
    100% { transform: rotate(0deg); }
  }

  .tick { transition: transform 0.8s cubic-bezier(0.65, 0, 0.35, 1), opacity 0.5s; }
  .tick.cache { opacity: 0; }
  .tick line { stroke: var(--dk-fond); stroke-width: 2; }
  .tick text { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }

  .jeton { transition: transform 0.75s cubic-bezier(0.34, 1.45, 0.64, 1); }
  .jeton.loin { transition: transform 0.8s cubic-bezier(0.65, 0, 0.35, 1) 0.5s; }
  .jeton rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: fill 0.3s, stroke 0.3s; }
  .jeton text { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.3s; }
  .jeton text.petit { font-size: 17px; }
  .jeton.mode rect { fill: var(--dk-accent); stroke: var(--dk-accent); animation: lueur 1s ease-in-out infinite; }
  .jeton.mode text { fill: var(--dk-fond); }
  .jeton.extreme rect { stroke: var(--dk-accent); stroke-width: 4; }
  .jeton.extreme text { fill: var(--dk-accent); }
  .chute { animation: chute 0.7s cubic-bezier(0.34, 1.5, 0.64, 1) both; }
  @keyframes chute { from { transform: translateY(-260px); opacity: 0; } 30% { opacity: 1; } to { transform: none; opacity: 1; } }
  .vol { animation: vol 0.8s cubic-bezier(0.2, 0.8, 0.3, 1.2) both; transform-box: fill-box; transform-origin: center; }
  @keyframes vol { from { transform: translate(260px, -220px) rotate(200deg); opacity: 0; } 30% { opacity: 1; } to { transform: none; opacity: 1; } }
  @keyframes lueur { 0%, 100% { stroke-width: 3; } 50% { stroke-width: 9; } }

  .raye { stroke: var(--dk-accent); stroke-width: 5; stroke-linecap: square; stroke-dasharray: 90; stroke-dashoffset: 90; animation: trace 0.35s ease-out 0.8s forwards; }
  .milieu { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 520; stroke-dashoffset: 520; animation: trace 0.6s ease-out 1.3s forwards; }
  @keyframes trace { to { stroke-dashoffset: 0; } }

  .lecture { display: flex; flex-direction: column; gap: 0.9em; }
  .ligne { display: flex; flex-direction: column; border-top: 3px solid var(--dk-filet); padding-top: 0.3em; min-height: 3.6em; transition: border-color 0.3s; }
  .ligne.vu { border-top-color: var(--dk-encre); }
  .et { font-size: 0.66em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .ligne.vu .et { color: var(--dk-encre); }
  .val { font-size: 2.4em; line-height: 1; font-weight: 600; color: var(--dk-encre); display: inline-block; animation: popc 0.5s cubic-bezier(0.34, 1.8, 0.64, 1) both; font-variant-numeric: tabular-nums; }
  .val.rouge { color: var(--dk-accent); }
  .val.flash { animation: flash 0.5s ease-in-out 1.9s 3 both; }
  @keyframes popc { from { transform: scale(0.3); opacity: 0; } to { transform: none; opacity: 1; } }
  @keyframes pop { from { transform: scale(0.3); opacity: 0; } to { transform: none; opacity: 1; } }
  @keyframes flash { 0%, 100% { color: var(--dk-encre); transform: none; } 50% { color: var(--dk-accent); transform: scale(1.18); } }

  .leg { grid-column: 1 / -1; margin: 0; min-height: 1.5em; font-size: 1em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.5s 2.2s; }
  .leg.vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .planche.osc3, .planche.osc4, .chute, .vol, .jeton.mode rect, .val, .val.flash, .p-val { animation: none; }
    .raye, .milieu { animation: none; stroke-dashoffset: 0; }
    .jeton, .jeton.loin, .tick, .pivot, .pivot.vite { transition: none; }
    .leg { transition: none; }
  }
</style>
