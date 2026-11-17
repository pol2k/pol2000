<script>
  /**
   * Les huit modèles du tableau 6.1 d'Arel-Bundock (2021, p. 136), refaits
   * avec set.seed(2026) : le coefficient de X dans chacun, contre le vrai
   * effet (1). Un graphique à points : une rangée par modèle, la formule à
   * gauche, le point sur l'axe, un trait vertical au vrai effet. M1 (le
   * seul juste : contrôler Z1 seulement) en rouge.
   *
   * Rien n'est calculé ici : MODELES et VRAI viennent de
   * src/lib/data/seance11.js (outils/seance11_data.R). Données simulées.
   */
  import { MODELES, VRAI } from '$lib/data/seance11.js';

  const X0 = -0.5, X1 = 1.75;
  const G = 470, D = 1180, H = 64, HAUT = 70;
  const px = (v) => G + ((v - X0) / (X1 - X0)) * (D - G);
  const y = (i) => HAUT + i * H;
  const BAS = HAUT + (MODELES.length - 1) * H + 40;
  const virg = (v) => v.toFixed(2).replace('.', ',').replace('-', '−');
  const TICKS = [-0.5, 0, 0.5, 1, 1.5];
  const morceaux = (f) => f.split(/Z(\d)/);
</script>

<div class="visuel m11m">
  <svg viewBox="0 0 1240 {BAS + 60}" role="img" aria-label="Le coefficient de X dans huit modèles. Seul le modèle 1, qui contrôle Z1 seulement, retrouve le vrai effet de 1.">
    <line x1={px(VRAI.complexe)} y1={HAUT - 40} x2={px(VRAI.complexe)} y2={BAS} class="m11m-vrai" />
    <text x={px(VRAI.complexe)} y={HAUT - 48} class="m11m-vrai-t">vrai effet : 1</text>
    {#each MODELES as m, i (m.nom)}
      <line x1={G} y1={y(i)} x2={D} y2={y(i)} class="m11m-rail" />
      <text x="20" y={y(i) + 10} class="m11m-nom" class:juste={i === 0}>{m.nom}</text>
      <text x="90" y={y(i) + 10} class="m11m-f" class:juste={i === 0}>{#each morceaux(m.formule) as t, k (k)}{#if k % 2}Z<tspan class="m11m-ind" dy="7">{t}</tspan><tspan dy="-7">&#8203;</tspan>{:else}{t}{/if}{/each}</text>
      <circle cx={px(m.x)} cy={y(i)} r="14" class="m11m-pt" class:juste={i === 0} />
      <text x={px(m.x) + (m.x > 1.3 ? -26 : 26)} y={y(i) - 18} class="m11m-v" class:juste={i === 0} style="text-anchor: {m.x > 1.3 ? 'end' : 'start'}">{virg(m.x)}</text>
    {/each}
    <line x1={G} y1={BAS} x2={D} y2={BAS} class="m11m-axe" />
    {#each TICKS as t (t)}
      <line x1={px(t)} y1={BAS} x2={px(t)} y2={BAS + 10} class="m11m-axe" />
      <text x={px(t)} y={BAS + 40} class="m11m-tick">{virg(t)}</text>
    {/each}
  </svg>
  <p class="m11m-cap">Données simulées · set.seed(2026), n = 100 000 · d’après Arel-Bundock (2021), tableau 6.1</p>
</div>

<style>
  .m11m { display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; max-width: 54em; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .m11m-rail { stroke: var(--dk-filet); stroke-width: 2; }
  .m11m-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .m11m-tick { font-size: 24px; text-anchor: middle; fill: var(--dk-gris); }
  .m11m-vrai { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 10 8; }
  .m11m-vrai-t { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .m11m-nom { font-size: 28px; font-weight: 700; fill: var(--dk-encre); }
  .m11m-f { font-size: 26px; fill: var(--dk-encre); }
  .m11m-ind { font-size: 18px; }
  .m11m-pt { fill: var(--dk-encre); }
  .m11m-v { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .juste { fill: var(--dk-accent); }
  .m11m-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
</style>
