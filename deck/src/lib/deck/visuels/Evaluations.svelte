<script>
  /**
   * Les sept évaluations sur la ligne du temps de la session, chacune avec sa
   * date et son poids — la barre des cent points en tête. Un seul regard:
   * quand, combien, sous quelle forme. Dates et poids du plan de cours A26.
   */
  const jour = (m, j) => ({ 9: 0, 10: 30, 11: 61, 12: 91 }[m] + j - 1);
  const W = 1180, X0 = 60, X1 = W - 130, x = (j) => X0 + (j / 110) * (X1 - X0);
  const MOIS = [[0, 'septembre'], [30, 'octobre'], [61, 'novembre'], [91, 'décembre']];
  const EV = [
    { j: jour(10, 4), k: 'Examen 1 · R', d: 'dim. 4 oct.', v: 15, g: 'ex', h: 1 },
    { j: jour(10, 22), k: 'Examen 2', d: 'jeu. 22 oct. · en classe', v: 15, g: 'ex', h: 2 },
    { j: jour(10, 25), k: 'Travail de mi-session', d: 'dim. 25 oct.', v: 20, g: 'tr', h: -1 },
    { j: jour(10, 25), k: 'Datacamp 1', d: 'dim. 25 oct.', v: 5, g: 'dc', h: -2 },
    { j: jour(12, 10), k: 'Examen 3', d: 'jeu. 10 déc. · en classe', v: 15, g: 'ex', h: 1 },
    { j: jour(12, 18), k: 'Travail final', d: 'ven. 18 déc.', v: 25, g: 'tr', h: -1 },
    { j: jour(12, 18), k: 'Datacamp 2', d: 'ven. 18 déc.', v: 5, g: 'dc', h: -2 }
  ];
  const Y = 215;
  const yh = (h) => (h > 0 ? Y - 70 - (h - 1) * 96 : Y + 100 + (-h - 1) * 96);
  const LEC = [jour(10, 26), jour(10, 30)];
</script>

<div class="visuel evals">
  <div class="barre">
    {#each [['Examen 1', 15, 'ex'], ['Examen 2', 15, 'ex'], ['Examen 3', 15, 'ex'], ['Mi-session', 20, 'tr'], ['Final', 25, 'tr'], ['DC', 5, 'dc'], ['DC', 5, 'dc']] as [k, v, g]}
      <div class="part {g}" style="flex: {v}"><span>{k}</span><strong>{v} %</strong></div>
    {/each}
  </div>
  <svg viewBox="0 0 {W} 470" role="img" aria-label="Ligne du temps de septembre à décembre avec les sept évaluations, leurs dates et leurs poids.">
    <!-- semaine de lecture -->
    <rect x={x(LEC[0])} y={Y - 14} width={x(LEC[1]) - x(LEC[0])} height="28" class="lecture" />
    <line x1={X0} y1={Y} x2={X1} y2={Y} class="axe" />
    {#each MOIS as [j, m]}
      <line x1={x(j)} y1={Y - 10} x2={x(j)} y2={Y + 10} class="axe" />
      <text x={x(j) + 6} y={Y + 34} class="mois">{m}</text>
    {/each}
    {#each EV as e}
      {@const yy = yh(e.h)}
      <line x1={x(e.j)} y1={Y} x2={x(e.j)} y2={yy + (e.h > 0 ? 40 : -40)} class="tige {e.g}" />
      <circle cx={x(e.j)} cy={Y} r="8" class="pt {e.g}" />
    {/each}
    {#each EV as e}
      {@const yy = yh(e.h)}
      <g class="etq {e.g}" style="transform: translate({x(e.j)}px, {yy}px)">
        <rect x="-112" y="-40" width="224" height="80" />
        <text y="-14" class="k">{e.k}</text>
        <text y="8" class="d">{e.d}</text>
        <text y="31" class="v">{e.v} %</text>
      </g>
    {/each}
  </svg>
</div>

<style>
  .evals { display: flex; flex-direction: column; gap: 0.2em; }
  .barre { display: flex; gap: 3px; height: 3.4em; }
  .part { display: flex; flex-direction: column; justify-content: center; align-items: center; color: var(--dk-fond); overflow: hidden; }
  .part span { font-size: 0.5em; letter-spacing: 0.08em; text-transform: uppercase; opacity: 0.85; white-space: nowrap; }
  .part strong { font-size: 0.95em; white-space: nowrap; }
  .part.dc strong { font-size: 0.75em; }
  .part.ex { background: var(--dk-encre); } .part.tr { background: var(--dk-accent); } .part.dc { background: var(--dk-gris); }
  svg { width: 100%; height: auto; display: block; }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .lecture { fill: var(--dk-fond-2); stroke: var(--dk-filet); stroke-width: 2; }
  .mois { font-family: var(--dk-mono); font-size: 15px; letter-spacing: 0.1em; text-transform: uppercase; fill: var(--dk-gris); }
  .tige { stroke-width: 2.5; } .tige.ex { stroke: var(--dk-encre); } .tige.tr { stroke: var(--dk-accent); } .tige.dc { stroke: var(--dk-gris); }
  .pt.ex { fill: var(--dk-encre); } .pt.tr { fill: var(--dk-accent); } .pt.dc { fill: var(--dk-gris); }
  .etq rect { fill: var(--dk-fond); stroke-width: 2.5; }
  .etq.ex rect { stroke: var(--dk-encre); } .etq.tr rect { stroke: var(--dk-accent); } .etq.dc rect { stroke: var(--dk-gris); }
  .etq .k { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .etq.tr .k { fill: var(--dk-accent); }
  .etq .d { font-family: var(--dk-mono); font-size: 13px; text-anchor: middle; fill: var(--dk-gris); }
  .etq .v { font-family: var(--dk-mono); font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .etq.tr .v { fill: var(--dk-accent); }
</style>
