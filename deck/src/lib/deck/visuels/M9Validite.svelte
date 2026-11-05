<script>
  /**
   * La validité, vérifiée sur une autre mesure : la moyenne de l'échelle
   * gauche-droite selon l'intention de vote (VALIDITE, outils/seance9_data.R),
   * du parti le plus à gauche au plus à droite. La théorie dit où les partis
   * devraient tomber; les barres poussent une à une.
   */
  import { VALIDITE as V } from '$lib/data/seance9.js';
  const W = 1000, X0 = 150, LX = 700, PAS = 56, H = V.length * PAS + 50;
  const x = (v) => X0 + v * LX;
  const f = (v) => v.toFixed(2).replace('.', ',');
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, '\u202f');
</script>

<div class="visuel m9val">
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Moyenne de l’échelle gauche-droite selon l’intention de vote : {V.map((p) => `${p.parti} ${f(p.moyenne)}`).join(', ')}.">
    {#each [0, 0.25, 0.5, 0.75, 1] as t}
      <line x1={x(t)} y1="4" x2={x(t)} y2={V.length * PAS} class="m9val-grille" />
      <text x={x(t)} y={V.length * PAS + 30} class="m9val-t">{t === 0 ? '0 gauche' : t === 1 ? '1 droite' : f(t)}</text>
    {/each}
    {#each V as p, i}
      <g style="--i: {i}">
        <text x={X0 - 18} y={i * PAS + 36} class="m9val-nom">{p.parti}</text>
        <rect x={x(0)} y={i * PAS + 12} width={p.moyenne * LX} height="34" class="m9val-barre" class:haut={p.moyenne >= 0.5} />
        <text x={x(p.moyenne) + 14} y={i * PAS + 37} class="m9val-v">{f(p.moyenne)}</text>
      </g>
    {/each}
  </svg>
  <p class="credits">CES 2025, sondage de campagne, sans pondération. Intention de vote; partis avec au moins 50 personnes dans l’échelle ({V.map((p) => `${p.parti}\u00a0${nb(p.n)}`).join(' · ')}).</p>
</div>

<style>
  .m9val { display: flex; flex-direction: column; gap: 0.3em; max-width: 54em; margin: 0.4em auto 0; }
  svg { width: 100%; height: auto; max-height: 46vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9val-grille { stroke: var(--dk-filet); stroke-width: 2; }
  .m9val-t { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .m9val-nom { font-size: 24px; font-weight: 700; text-anchor: end; }
  .m9val-barre { fill: var(--dk-gris); transform-box: fill-box; transform-origin: left; animation: m9val-pousse 0.6s both; animation-delay: calc(var(--i) * 0.15s + 0.2s); }
  .m9val-barre.haut { fill: var(--dk-encre); }
  .m9val-v { font-size: 24px; font-weight: 700; animation: m9val-fondu 0.4s both; animation-delay: calc(var(--i) * 0.15s + 0.6s); }
  @keyframes m9val-pousse { from { transform: scaleX(0); } to { transform: none; } }
  @keyframes m9val-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .m9val-barre, .m9val-v { animation: none; } }
</style>
