<script>
  /**
   * L'électricité de quelques usages du numérique, en Wh, sur une échelle où
   * chaque trait vaut dix fois le précédent (ACTIVITES,
   * $lib/data/ia_environnement.js). Les usages de l'IA en rouge. Les lignes
   * arrivent une à une. Pour mettre en perspective, pas pour classer.
   */
  import { ACTIVITES as A } from '$lib/data/ia_environnement.js';
  const W = 1000, X0 = 400, LX = 520, PAS = 46, Y0 = 36;
  const L0 = -2, L1 = 3; // de 0,01 à 1 000 Wh
  const x = (wh) => X0 + ((Math.log10(wh) - L0) / (L1 - L0)) * LX;
  const f = (v) => (v < 1 ? v.toFixed(2) : v < 10 ? v.toFixed(1) : Math.round(v).toLocaleString('fr-CA').replace(/\s/g, ' ')).replace('.', ',');
  const TRAITS = [0.01, 0.1, 1, 10, 100, 1000];
  const H = Y0 + A.length * PAS + 10;
</script>

<div class="visuel m9a">
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Électricité en wattheures : {A.map((a) => `${a.nom} ${f(a.wh)}`).join(', ')}.">
    {#each TRAITS as t}
      <line x1={x(t)} y1={Y0 - 8} x2={x(t)} y2={H - 6} class="m9a-trait" />
      <text x={x(t)} y={Y0 - 16} class="m9a-t">{f(t)} Wh</text>
    {/each}
    {#each A as a, i}
      <g class:ia={a.ia} class="m9a-l" style="--i: {i}">
        <text x={X0 - 22} y={Y0 + i * PAS + 24} class="m9a-nom">{a.nom}</text>
        <line x1={x(0.01)} y1={Y0 + i * PAS + 17} x2={x(a.wh)} y2={Y0 + i * PAS + 17} class="m9a-tige" />
        <circle cx={x(a.wh)} cy={Y0 + i * PAS + 17} r="9" class="m9a-pt" />
        <text x={x(a.wh) + 16} y={Y0 + i * PAS + 24} class="m9a-v">{f(a.wh)}</text>
      </g>
    {/each}
  </svg>
  <p class="m9a-pied">Chaque trait vaut dix fois le précédent. <b class="rouge">En rouge</b> : l’IA.</p>
  <p class="credits">IA : centre de données seulement (Google, OpenAI, MIT Technology Review, 2025). Streaming : écran, réseau et centre de données compris, moyenne 2019 (AIE, 2020). Les deux ne comptent pas la même chose.</p>
</div>

<style>
  .m9a { display: flex; flex-direction: column; gap: 0.3em; max-width: 60em; margin: 0.2em auto 0; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9a-trait { stroke: var(--dk-filet); stroke-width: 2; }
  .m9a-t { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .m9a-nom { font-size: 19px; font-weight: 700; text-anchor: end; }
  .m9a-tige { stroke: var(--dk-encre); stroke-width: 2; }
  .m9a-pt { fill: var(--dk-encre); }
  .m9a-v { font-size: 19px; font-weight: 700; }
  .ia .m9a-nom, .ia .m9a-v { fill: var(--dk-accent); }
  .ia .m9a-tige { stroke: var(--dk-accent); }
  .ia .m9a-pt { fill: var(--dk-accent); }
  .m9a-l { animation: m9a-fondu 0.4s both; animation-delay: calc(var(--i) * 0.12s + 0.2s); }
  .m9a-pied { margin: 0; font-size: 0.9em; text-align: center; }
  .m9a-pied .rouge { color: var(--dk-accent); }
  @keyframes m9a-fondu { from { opacity: 0; transform: translateX(-0.5em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9a-l { animation: none; } }
</style>
