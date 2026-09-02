<script>
  /**
   * Cent points, en une barre; puis les sept échéances posées sur l'automne.
   * Pondérations et dates du plan de cours A26 — rien d'autre.
   */
  const POIDS = [
    { k: 'Examen 1', v: 15, g: 'ex' },
    { k: 'Examen 2', v: 15, g: 'ex' },
    { k: 'Examen 3', v: 15, g: 'ex' },
    { k: 'Mi-session', v: 20, g: 'tr' },
    { k: 'Final', v: 25, g: 'tr' },
    { k: 'DC', v: 5, g: 'dc' },
    { k: 'DC', v: 5, g: 'dc' }
  ];
  // Position sur l'axe: jours depuis le 1er septembre, sur 110 jours (→ 19 déc).
  const jour = (m, j) => ({ 9: 0, 10: 30, 11: 61, 12: 91 }[m] + j - 1);
  const ECH = [
    { j: jour(10, 4), k: 'Ex. 1', g: 'ex' },
    { j: jour(10, 22), k: 'Ex. 2', g: 'ex' },
    { j: jour(10, 25), k: 'Mi-session + DC', g: 'tr', bas: true },
    { j: jour(12, 10), k: 'Ex. 3', g: 'ex' },
    { j: jour(12, 18), k: 'Final + DC', g: 'tr', bas: true }
  ];
  const MOIS = [[0, 'sept'], [30, 'oct'], [61, 'nov'], [91, 'déc']];
  const W = 900, x = (j) => 40 + (j / 110) * (W - 80);
</script>

<div class="pond" role="img" aria-label="Répartition des cent points et calendrier des échéances.">
  <div class="barre">
    {#each POIDS as p}
      <div class="part {p.g}" style="flex: {p.v}"><span>{p.k}</span><strong>{p.v} %</strong></div>
    {/each}
  </div>
  <div class="groupes">
    <span><i class="ex"></i> examens 45 %</span>
    <span><i class="tr"></i> travaux 45 %</span>
    <span><i class="dc"></i> Datacamp 10 %</span>
  </div>

  <svg viewBox="0 0 {W} 150" class="axe">
    <line x1="40" y1="80" x2={W - 40} y2="80" class="trait" />
    {#each MOIS as [j, m]}
      <line x1={x(j)} y1="72" x2={x(j)} y2="88" class="trait" />
      <text x={x(j) + 6} y="112" class="mois">{m}</text>
    {/each}
    {#each ECH as e}
      <line x1={x(e.j)} y1={e.bas ? 80 : 80} x2={x(e.j)} y2={e.bas ? 122 : 40} class="tige {e.g}" />
      <circle cx={x(e.j)} cy="80" r="7" class="pt {e.g}" />
      <text x={x(e.j)} y={e.bas ? 140 : 30} class="et {e.g}">{e.k}</text>
    {/each}
  </svg>
</div>

<style>
  .pond { display: flex; flex-direction: column; gap: 0.6em; }
  .barre { display: flex; gap: 3px; height: 4.2em; }
  .part { display: flex; flex-direction: column; justify-content: center; align-items: center; gap: 0.1em; color: var(--dk-fond); overflow: hidden; }
  .part span { font-size: 0.55em; letter-spacing: 0.06em; text-transform: uppercase; opacity: 0.85; white-space: nowrap; }
  .part strong { font-size: 1.05em; white-space: nowrap; }
  .part.dc strong { font-size: 0.8em; }
  .part.ex { background: var(--dk-encre); }
  .part.tr { background: var(--dk-accent); }
  .part.dc { background: var(--dk-gris); }
  .groupes { display: flex; gap: 1.6em; font-size: 0.66em; color: var(--dk-gris); }
  .groupes i { display: inline-block; width: 1.4em; height: 0.5em; vertical-align: middle; margin-right: 0.3em; }
  .groupes .ex { background: var(--dk-encre); } .groupes .tr { background: var(--dk-accent); } .groupes .dc { background: var(--dk-gris); }
  .axe { width: 100%; height: auto; display: block; }
  .trait { stroke: var(--dk-encre); stroke-width: 3; }
  .mois { font-family: var(--dk-mono); font-size: 17px; letter-spacing: 0.12em; text-transform: uppercase; fill: var(--dk-gris); }
  .tige { stroke-width: 2.5; } .tige.ex { stroke: var(--dk-encre); } .tige.tr { stroke: var(--dk-accent); }
  .pt.ex { fill: var(--dk-encre); } .pt.tr { fill: var(--dk-accent); }
  .et { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; }
  .et.ex { fill: var(--dk-encre); } .et.tr { fill: var(--dk-accent); }
</style>
