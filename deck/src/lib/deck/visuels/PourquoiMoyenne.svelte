<script>
  /**
   * Pis, la moyenne, ça sert à quoi ? Votre moyenne de programme à
   * l'Université Laval. Faits vérifiés (Bureau du registraire; page du
   * profil distinction) : l'échelle va de 0 à 4,33; au premier cycle, il
   * faut maintenir 2,00 sur 4,33 pour poursuivre son programme; le profil
   * distinction exige 3,67 ou plus sur 4,33.
   *
   *   0  La jauge se trace, l'aiguille balaie une fois et s'arrête au milieu
   *      (position de décor, pas une donnée).
   *   1  Un drapeau tombe à 2,00 : « pour poursuivre ». Sous 2,00, la zone
   *      se hachure.
   *   2  Un drapeau tombe à 3,67 : « profil distinction ». Au-dessus, la
   *      zone se teinte; la réponse arrive.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
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

  const MAX = 4.33;
  const X0 = 70, X1 = 930, YH = 150, H = 44;
  const x = (v) => X0 + (v / MAX) * (X1 - X0);
  const TICKS = [0, 1, 2, 3, 4, 4.33];
  const fr = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  const MILIEU = x(MAX / 2);
</script>

<Pis stat="la moyenne" reponse="Il faut 2,00 pour poursuivre votre programme. 3,67 pour la distinction." vu={e >= 2} source="Université Laval · Bureau du registraire ; profil distinction">
  {#snippet children()}
    <svg bind:this={hote} viewBox="0 0 1000 270" preserveAspectRatio="xMidYMid meet" role="img" aria-label="Une jauge de la moyenne de programme, de 0 à 4,33 : 2,00 pour poursuivre son programme, 3,67 pour le profil distinction.">
      <defs>
        <pattern id="moy-hachure" width="12" height="12" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
          <line x1="0" y1="0" x2="0" y2="12" class="hach" />
        </pattern>
      </defs>

      <text x={X0} y={YH - 22} class="nom-j">moyenne de programme</text>

      <!-- Les zones, sous la piste. -->
      <rect x={X0} y={YH} width={x(2) - X0} height={H} fill="url(#moy-hachure)" class="zone-bas" class:vu={e >= 1} />
      <rect x={x(3.67)} y={YH} width={X1 - x(3.67)} height={H} class="zone-haut" class:vu={e >= 2} />

      {#key tour}
        <rect x={X0} y={YH} width={X1 - X0} height={H} pathLength="1" class="piste" />
      {/key}
      {#each TICKS as t}
        <line x1={x(t)} y1={YH + H} x2={x(t)} y2={YH + H + 10} class="tick-l" />
        <text x={x(t)} y={YH + H + 34} class="tick-j" class:fin={t === 4.33}>{fr(t)}</text>
      {/each}

      <!-- L'aiguille : un balayage à l'arrivée, puis le repos au milieu. -->
      {#key tour}
        <g class="aiguille" style="--milieu: {MILIEU}px; --x0: {X0}px; --x1: {X1}px">
          <line x1="0" y1={YH - 14} x2="0" y2={YH + H + 4} />
          <path d="M -10 {YH - 26} L 10 {YH - 26} L 0 {YH - 12} Z" />
        </g>
      {/key}

      <!-- Les deux seuils. -->
      <g style="transform: translateX({x(2)}px)">
        <g class="drapeau" class:vu={e >= 1}>
          <line x1="0" y1={YH + H} x2="0" y2="40" />
          <path d="M 0 40 L 54 52 L 0 64 Z" />
          <text x="-8" y="28" class="drap-t fin">2,00 · pour poursuivre</text>
        </g>
      </g>
      <g style="transform: translateX({x(3.67)}px)">
        <g class="drapeau" class:vu={e >= 2}>
          <line x1="0" y1={YH + H} x2="0" y2="40" />
          <path d="M 0 40 L 54 52 L 0 64 Z" />
          <text x="-8" y="28" class="drap-t fin">3,67 · profil distinction</text>
        </g>
      </g>
    </svg>
  {/snippet}
</Pis>

<style>
  svg { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .nom-j { font-size: 18px; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; fill: var(--dk-gris); }
  .piste { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace-j 0.9s ease-out forwards; }
  @keyframes trace-j { to { stroke-dashoffset: 0; } }
  .tick-l { stroke: var(--dk-encre); stroke-width: 3; }
  .tick-j { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .tick-j.fin { font-weight: 600; fill: var(--dk-encre); }

  .hach { stroke: var(--dk-gris-2); stroke-width: 4; }
  .zone-bas { opacity: 0; transition: opacity 0.5s 0.35s; }
  .zone-bas.vu { opacity: 1; }
  .zone-haut { fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s 0.35s; }
  .zone-haut.vu { opacity: 0.18; }

  .aiguille { transform: translateX(var(--milieu)); animation: balaie 1.4s cubic-bezier(0.45, 0, 0.3, 1) both; }
  .aiguille line { stroke: var(--dk-accent); stroke-width: 6; }
  .aiguille path { fill: var(--dk-accent); }
  @keyframes balaie {
    0% { transform: translateX(var(--x0)); }
    40% { transform: translateX(var(--x1)); }
    75% { transform: translateX(calc(var(--milieu) - 60px)); }
    100% { transform: translateX(var(--milieu)); }
  }

  .drapeau { opacity: 0; transform: translateY(-90px); transition: transform 0.6s cubic-bezier(0.34, 1.7, 0.64, 1), opacity 0.2s; }
  .drapeau.vu { opacity: 1; transform: none; }
  .drapeau line { stroke: var(--dk-encre); stroke-width: 3; }
  .drapeau path { fill: var(--dk-accent); }
  .drap-t { font-size: 20px; font-weight: 600; fill: var(--dk-accent); }
  .drap-t.fin { text-anchor: end; }

  @media (prefers-reduced-motion: reduce) {
    .piste { animation: none; stroke-dashoffset: 0; }
    .aiguille { animation: none; }
    .zone-bas, .zone-haut, .drapeau { transition: none; }
  }
</style>
