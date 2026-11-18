<script>
  /**
   * Les huit modèles du tableau 6.1 d'Arel-Bundock (2021, p. 136), refaits
   * avec set.seed(2026), lancés comme des fléchettes sur une cible dont le
   * centre est le vrai effet (1). La distance d'une fléchette au centre est
   * l'écart entre le coefficient de X et 1; l'angle est un choix de mise en
   * page (fixe), pour que les fléchettes ne se cachent pas.
   *
   *   0  la cible vide : au centre, le vrai effet, 1;
   *   1  M2 à M8 sont lancés, un à un : tous à côté;
   *   2  M1 (contrôler Z1, et seulement Z1) : dans le mille.
   *
   * Rien n'est calculé ici sauf la position : les coefficients viennent de
   * MODELES (src/lib/data/seance11.js, outils/seance11_data.R). Données
   * simulées.
   */
  import { brancherTemps } from '../temps.js';
  import { MODELES, VRAI } from '$lib/data/seance11.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const CX = 330, CY = 300, R = 210; // R pixels = un écart de 1
  const ANGLES = { M1: 0, M2: -30, M3: 200, M4: 150, M5: 110, M6: 160, M7: 250, M8: 60 };
  const virg = (v) => v.toFixed(2).replace('.', ',').replace('-', '−');
  const FL = MODELES.map((m, k) => {
    const d = Math.abs(m.x - VRAI.complexe) * R;
    const a = (ANGLES[m.nom] * Math.PI) / 180;
    return { ...m, tx: CX + d * Math.cos(a), ty: CY + d * Math.sin(a), ordre: m.nom === 'M1' ? 0 : k - 1 };
  });
  const morceaux = (f) => f.split(/Z(\d)/);
</script>

<div class="visuel m11k" bind:this={hote}>
  <svg viewBox="0 0 1200 650" role="img" aria-label="Une cible : au centre, le vrai effet, 1. Sept modèles tombent à côté. Seul le modèle 1, qui contrôle Z1 et rien d’autre, touche le centre.">
    {#each [1.25, 1, 0.75, 0.5, 0.25] as r, i (r)}
      <circle cx={CX} cy={CY} r={r * R} class="anneau" class:fonce={i % 2 === 0} />
    {/each}
    <circle cx={CX} cy={CY} r="16" class="mille" />
    <text x={CX} y={CY + R * 1.25 + 44} class="t-cible">au centre : le vrai effet, 1</text>

    {#each FL as f (f.nom)}
      {@const vu = f.nom === 'M1' ? e >= 2 : e >= 1}
      <g class="fl" class:vu style="--dx: {1300 - f.tx}px; --dy: {-120 - f.ty}px; --o: {f.ordre * 0.28}s">
        <line x1={f.tx} y1={f.ty} x2={f.tx + 52} y2={f.ty - 34} class="tige" class:m1={f.nom === 'M1'} />
        <path d="M {f.tx + 44} {f.ty - 29} l 16 -2 l -6 14 Z" class="plume" class:m1={f.nom === 'M1'} />
        <circle cx={f.tx} cy={f.ty} r="6" class="pointe" class:m1={f.nom === 'M1'} />
        <text x={f.tx + 58} y={f.ty - 40} class="nom" class:m1={f.nom === 'M1'}>{f.nom}</text>
      </g>
    {/each}

    <!-- la liste -->
    {#each FL as f, i (f.nom)}
      {@const vu = f.nom === 'M1' ? e >= 2 : e >= 1}
      <g class="ligne" class:vu style="--o: {f.ordre * 0.28 + 0.3}s">
        <text x="760" y={70 + i * 62} class="l-nom" class:m1={f.nom === 'M1'}>{f.nom}</text>
        <text x="830" y={70 + i * 62} class="l-f" class:m1={f.nom === 'M1'}>{#each morceaux(f.formule) as t, k (k)}{#if k % 2}Z<tspan class="ind" dy="6">{t}</tspan><tspan dy="-6">&#8203;</tspan>{:else}{t}{/if}{/each}</text>
        <text x="1190" y={70 + i * 62} class="l-v" class:m1={f.nom === 'M1'}>{virg(f.x)}</text>
      </g>
    {/each}
  </svg>
  <p class="cap">Données simulées · set.seed(2026), n = 100 000 · d’après Arel-Bundock (2021), tableau 6.1</p>
</div>

<style>
  .m11k { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.25em; }
  svg { width: 100%; max-width: 54em; height: auto; max-height: 60vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .anneau { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .anneau.fonce { fill: var(--dk-fond-2); }
  .mille { fill: var(--dk-accent); }
  .t-cible { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }

  .fl { opacity: 0; transform: translate(var(--dx), var(--dy)); }
  .fl.vu { animation: m11k-vol 0.55s cubic-bezier(0.3, 0.6, 0.4, 1) forwards; animation-delay: var(--o); }
  @keyframes m11k-vol { 0% { opacity: 1; transform: translate(var(--dx), var(--dy)); } 100% { opacity: 1; transform: none; } }
  .tige { stroke: var(--dk-encre); stroke-width: 6; stroke-linecap: round; }
  .plume { fill: var(--dk-gris); }
  .pointe { fill: var(--dk-encre); }
  .nom { font-size: 26px; font-weight: 700; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; }
  .m1.tige { stroke: var(--dk-accent); }
  .m1.plume, .m1.pointe { fill: var(--dk-accent); }
  .nom.m1 { fill: var(--dk-accent); }

  .ligne { opacity: 0; transition: opacity 0.3s; transition-delay: var(--o); }
  .ligne.vu { opacity: 1; }
  .l-nom { font-size: 26px; font-weight: 700; fill: var(--dk-encre); }
  .l-f { font-size: 24px; fill: var(--dk-encre); }
  .l-v { font-size: 26px; font-weight: 700; fill: var(--dk-encre); text-anchor: end; }
  .ind { font-size: 17px; }
  .l-nom.m1, .l-f.m1, .l-v.m1 { fill: var(--dk-accent); }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .fl.vu { animation-duration: 0.01s; animation-delay: 0s; } .ligne { transition: none; } }
</style>
