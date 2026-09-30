<script>
  /**
   * La CES ressemble-t-elle au Canada ? L'âge des répondant.e.s de l'Étude
   * électorale canadienne 2025 contre les estimations de Statistique Canada
   * (tableau 17-10-0005-01, 1er juillet 2025, 18 ans et plus), en % par
   * tranche de cinq ans. Tout vient de RECENSEMENT
   * (src/lib/data/seance5_normale.js, outils/seance5_normale.R). Trois temps.
   *
   *   0  Statistique Canada : des bâtons gris. Un plateau jusque vers 70 ans.
   *   1  La CES brute : un trait rouge par tranche. Grâce aux quotas, proche.
   *      Mais trop de 53 à 72 ans, pas assez de 18 à 27 ans ni de 83 ans et +.
   *   2  La CES pondérée : un trait noir par tranche, qui se rapproche des
   *      bâtons. La phrase : des quotas pour ressembler, des poids pour
   *      corriger le reste.
   */
  import { brancherTemps } from '../temps.js';
  import { RECENSEMENT as R } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const n = R.groupes.length;
  const X0 = 90, X1 = 960, BASE = 360, HAUT = 250, PMAX = 10;
  const pas = (X1 - X0) / n;
  const y = (p) => BASE - (p / PMAX) * HAUT;
  const cx = (i) => X0 + pas * (i + 0.5);
</script>

<div class="visuel eec-canada" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="L’âge des adultes au Canada selon Statistique Canada, et dans l’Étude électorale canadienne, brute puis pondérée. Les deux dessinent un plateau jusque vers 70 ans. La CES brute a trop de 53 à 72 ans et pas assez de jeunes et de très âgés. Les poids corrigent la plus grande partie de l’écart.">
    <!-- La légende. -->
    <rect x={X0} y="14" width="22" height="16" class="ec-bat" />
    <text x={X0 + 32} y="29" class="ec-leg">Statistique Canada, 2025</text>
    <g class="ec-etape" class:ec-vu={e >= 1}>
      <line x1={X0 + 330} y1="22" x2={X0 + 356} y2="22" class="ec-brut" />
      <text x={X0 + 366} y="29" class="ec-leg">CES brute</text>
    </g>
    <g class="ec-etape" class:ec-vu={e >= 2}>
      <line x1={X0 + 510} y1="22" x2={X0 + 536} y2="22" class="ec-pond" />
      <text x={X0 + 546} y="29" class="ec-leg">CES pondérée</text>
    </g>

    {#each [0, 2, 4, 6, 8, 10] as p}
      <line x1={X0} y1={y(p)} x2={X1} y2={y(p)} class="ec-grille" />
      <text x={X0 - 12} y={y(p) + 6} class="ec-tick ec-g">{p}&#8239;%</text>
    {/each}
    {#each R.groupes as g, i}
      <rect x={cx(i) - pas * 0.36} y={y(R.statcan[i])} width={pas * 0.72} height={BASE - y(R.statcan[i])} class="ec-bat" />
      <line x1={cx(i) - pas * 0.42} y1={y(R.eecBrut[i])} x2={cx(i) + pas * 0.42} y2={y(R.eecBrut[i])} class="ec-brut ec-etape" class:ec-vu={e >= 1} />
      <line x1={cx(i) - pas * 0.42} y1={y(R.eecPondere[i])} x2={cx(i) + pas * 0.42} y2={y(R.eecPondere[i])} class="ec-pond ec-etape" class:ec-vu={e >= 2} />
      <text x={cx(i)} y={BASE + 24} class="ec-tick">{g.split(' ')[0]}</text>
    {/each}
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ec-axe" />
    <text x={X1} y={BASE + 50} class="ec-tick ec-fin">âge (tranches de cinq ans)</text>

    <text x="500" y="448" class="ec-phrase ec-etape" class:ec-vu={e === 1}>Des quotas pour ressembler au Canada. Mais trop de 53 à 72 ans.</text>
    <text x="500" y="448" class="ec-phrase ec-etape" class:ec-vu={e >= 2}>Des quotas pour ressembler, des poids pour corriger le reste.</text>
    <text x="500" y="478" class="ec-source">Statistique Canada, tableau 17-10-0005-01 · Étude électorale canadienne 2025</text>
  </svg>
</div>

<style>
  .eec-canada { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ec-bat { fill: var(--dk-gris-2); }
  .ec-brut { stroke: var(--dk-accent); stroke-width: 5; }
  .ec-pond { stroke: var(--dk-encre); stroke-width: 5; }
  .ec-grille { stroke: var(--dk-fond-2); stroke-width: 1.5; }
  .ec-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ec-leg { font-size: 19px; fill: var(--dk-encre); }
  .ec-tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .ec-g { text-anchor: end; }
  .ec-fin { text-anchor: end; font-size: 17px; }
  .ec-phrase { font-size: 23px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ec-source { font-size: 14px; text-anchor: middle; fill: var(--dk-gris); }
  .ec-etape { opacity: 0; transition: opacity 0.3s; }
  .ec-etape.ec-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .ec-etape, .ec-etape.ec-vu { transition: none; }
  }
</style>
