<script>
  /**
   * La régression, telle qu'elle sort de R — une ligne de code, un tableau,
   * et les vraies moyennes par tranche posées sur l'axe. Toutes les valeurs
   * viennent de $lib/data/ces.js, généré par ces_fit.R. Deux temps: le code
   * et le tableau; puis les moyennes, pour voir ce que « 0,03 » veut dire.
   */
  import { brancherTemps } from '../temps.js';
  import { REG, MOYENNES } from '$lib/data/ces.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const fmt = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const p = (v) => (v < 0.001 ? '< 0,001' : v.toLocaleString('fr-CA', { maximumFractionDigits: 3 }));
  const nom = { '(Intercept)': 'Constante', income: 'Revenu (tranche 1 à 8)' };
  const X0 = 60, X1 = 900, x = (v) => X0 + (v / 10) * (X1 - X0);
</script>

<div class="visuel reg" bind:this={hote}>
  <div class="haut">
    <pre class="code"><span class="fn">lm</span>(cps25_lr_scale_bef_1 <span class="op">~</span> cps25_income, <span class="arg">data</span> = ces)</pre>
    <table>
      <thead><tr><th></th><th>Coefficient</th><th>Erreur-type</th><th>t</th><th>p</th></tr></thead>
      <tbody>
        {#each REG.coefs as c}
          <tr class:cle={c.term === 'income'}><td>{nom[c.term]}</td><td>{fmt(c.estimate)}</td><td>{fmt(c.se)}</td><td>{c.t.toLocaleString('fr-CA')}</td><td>{p(c.p)}</td></tr>
        {/each}
      </tbody>
      <tfoot><tr><td colspan="5">N = {REG.n.toLocaleString('fr-CA')} · R² = {REG.r2.toLocaleString('fr-CA', { minimumFractionDigits: 4 })}</td></tr></tfoot>
    </table>
  </div>

  <svg viewBox="0 0 960 150" class="moy" class:vu={e === 1} role="img" aria-label="Moyenne du placement gauche-droite pour chacune des huit tranches de revenu: toutes entre 4,8 et 5,2.">
    <line x1={X0} y1="90" x2={X1} y2="90" class="axe" />
    {#each [0, 2, 4, 5, 6, 8, 10] as v}
      <line x1={x(v)} y1="84" x2={x(v)} y2="96" class="axe" /><text x={x(v)} y="118" class="tick">{v}</text>
    {/each}
    <text x={X0} y="142" class="pole">GAUCHE</text><text x={X1} y="142" class="pole fin">DROITE</text>
    {#each MOYENNES as m, i}
      <g class="pt" style="transition-delay: {i * 80}ms">
        <line x1={x(m.mean)} y1="90" x2={x(m.mean)} y2={40 + (i % 2) * 22} class="tige" />
        <circle cx={x(m.mean)} cy="90" r="7" />
        <text x={x(m.mean)} y={34 + (i % 2) * 22} class="lib">{m.income}</text>
      </g>
    {/each}
    <text x="480" y="18" class="legende">Moyenne réelle par tranche de revenu, 1 à 8. Toutes entre {Math.min(...MOYENNES.map((m) => m.mean)).toLocaleString('fr-CA')} et {Math.max(...MOYENNES.map((m) => m.mean)).toLocaleString('fr-CA')}.</text>
  </svg>
</div>

<style>
  .reg { display: flex; flex-direction: column; gap: 0.6em; }
  .haut { display: grid; grid-template-columns: 1fr; gap: 0.6em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1.05em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.6em 0.9em; white-space: pre-wrap; }
  .fn { color: var(--dk-accent-clair); font-weight: 600; } .op { color: var(--dk-accent-clair); } .arg { color: var(--dk-gris-2); }
  table { width: 100%; border-collapse: collapse; font-size: 0.82em; }
  th { text-align: right; font-weight: 600; color: var(--dk-gris); font-size: 0.8em; letter-spacing: 0.1em; text-transform: uppercase; padding: 0.3em 0.6em; border-bottom: 2px solid var(--dk-encre); }
  th:first-child, td:first-child { text-align: left; }
  td { text-align: right; padding: 0.35em 0.6em; border-bottom: 1px solid var(--dk-filet); font-variant-numeric: tabular-nums; }
  tr.cle td { font-weight: 600; color: var(--dk-accent); }
  tfoot td { color: var(--dk-gris); border-bottom: 0; text-align: left; font-size: 0.85em; }
  .moy { width: 100%; height: auto; display: block; }
  .moy .pt { opacity: 0; transition: opacity 0.5s; }
  .moy.vu .pt { opacity: 1; }
  .moy .legende { opacity: 0; transition: opacity 0.5s 0.6s; }
  .moy.vu .legende { opacity: 1; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .pole { font-family: var(--dk-mono); font-size: 13px; letter-spacing: 0.16em; font-weight: 600; fill: var(--dk-encre); } .pole.fin { text-anchor: end; }
  .tige { stroke: var(--dk-accent); stroke-width: 2; }
  .pt circle { fill: var(--dk-accent); }
  .lib { font-family: var(--dk-mono); font-size: 13px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .legende { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-encre); }
</style>
