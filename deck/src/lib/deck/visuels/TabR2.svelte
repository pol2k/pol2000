<script>
  /**
   * R² = 0,14 : la part de la variation de la note que la droite suit. À
   * gauche, le tableau d'article (TabPublie). À droite, le nuage de notre
   * sondage (783 personnes; `jx` étale gauche_droite de ± 0,3 pour le
   * dessin seulement). Une personne sur 16 est à l'encre, avec son écart.
   *
   *   0  Le nuage.
   *   1  Sans x : on prédit la moyenne (55) à tout le monde. Les écarts à
   *      la moyenne : toute la variation de la note.
   *   2  Avec x : la ligne pivote et devient la droite de R (elle passe par
   *      le point moyen, d'où le pivot). Les écarts rétrécissent, un peu.
   *   3  La barre : 14 % de la variation suit la droite, 86 % reste dans ε.
   *   4  Le garde-fou : un R² faible n'efface pas la pente. Ce n'est pas
   *      une note de qualité.
   *
   * Nombres : NOTRE (coefs, points, r2) dans src/lib/data/seance7.js et
   * R2.moyenne dans src/lib/data/seance7_g.js (outils/seance7_g.R, qui
   * recalcule aussi le R² à la main pour vérifier summary()).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import { R2 } from '$lib/data/seance7_g.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const B0 = NOTRE.coefs[0].b, B1 = NOTRE.coefs[1].b;
  const MOY = R2.moyenne;
  const X0 = 70, X1 = 610, Y0 = 330, Y1 = 20;
  const x = (v) => X0 + (v / 10) * (X1 - X0);
  const y = (v) => Y0 - (v / 100) * (Y0 - Y1);
  const PTS = NOTRE.points;
  // Une personne sur 16, dans l'ordre du fichier : un échantillon fixe, sans hasard.
  const VUS = PTS.filter((_, i) => i % 16 === 0);
  const pred = (v) => B0 + B1 * v;
  const ligne = (a, b) => `path('M ${x(-0.3)} ${y(a)} L ${x(10.3)} ${y(b)}')`;
  const PLATE = ligne(MOY, MOY);
  const DROITE = ligne(pred(-0.3), pred(10.3));
  const ecart = (p, cible) => `path('M ${x(p.jx)} ${y(p.y)} L ${x(p.jx)} ${y(cible)}')`;
  const PART = Math.round(NOTRE.r2 * 100);
  const ON = [[], [], [], ['r2'], ['r2']];
</script>

<div class="visuel tab-r2" bind:this={hote}>
  <div class="tr-tab"><TabPublie on={ON[e]} /></div>

  <div class="tr-droite">
    <svg viewBox="0 0 640 392" role="img" aria-label="Le nuage des {PTS.length} personnes. Sans la position gauche-droite, on prédit la moyenne, {f(MOY)}, à tout le monde. Avec elle, la ligne pivote et les écarts rétrécissent un peu. {PART}&#8239;% de la variation de la note suit la droite, {100 - PART}&#8239;% reste.">
      {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.y)} r="2.4" class="tr-pt" />{/each}

      <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="tr-axe" />
      <line x1={X0} y1={Y0} x2={X0} y2={Y1} class="tr-axe" />
      {#each [0, 5, 10] as v}<text x={x(v)} y={Y0 + 26} class="tr-tick">{v}</text>{/each}
      {#each [0, 50, 100] as v}<text x={X0 - 10} y={y(v) + 6} class="tr-tick tr-g">{v}</text>{/each}
      <text x={(X0 + X1) / 2} y={Y0 + 48} class="tr-titre-axe">position gauche-droite</text>

      <!-- Les écarts : à la moyenne (1), puis à la droite (2). -->
      <g class="tr-ecarts" class:tr-vu={e >= 1}>
        {#each VUS as p}
          <path class="tr-ecart" style="d: {e >= 2 ? ecart(p, pred(p.x)) : ecart(p, MOY)}" />
        {/each}
      </g>
      <g class="tr-vus" class:tr-vu={e >= 1}>
        {#each VUS as p}<circle cx={x(p.jx)} cy={y(p.y)} r="4.5" class="tr-vu-pt" />{/each}
      </g>

      <!-- La ligne : plate (la moyenne), puis elle pivote. -->
      <path class="tr-ligne" class:tr-vu={e >= 1} style="d: {e >= 2 ? DROITE : PLATE}" />
      <text x={x(0.1)} y={y(MOY) - 14} class="tr-lib" class:tr-vu={e === 1}>moyenne : {f(MOY)}</text>
    </svg>

    <div class="tr-barre" class:tr-vu={e >= 3}>
      <div class="tr-part" style="width: {PART}%"><span>{PART}&#8239;%</span></div>
      <div class="tr-reste"><span>{100 - PART}&#8239;% : le reste (ε)</span></div>
    </div>
    <p class="tr-dit">
      {#if e === 1}sans x : la moyenne pour tout le monde
      {:else if e === 2}avec x : les écarts rétrécissent, un peu
      {:else if e === 3}{PART}&#8239;% de la variation de la note suit la droite
      {:else if e === 4}un R² faible n’efface pas la pente
      {:else}&#8203;{/if}
    </p>
  </div>
</div>

<style>
  .tab-r2 { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tr-tab { font-size: 0.92em; }
  .tr-droite { display: flex; flex-direction: column; gap: 0.45em; }
  svg { width: 100%; height: auto; display: block; }
  .tr-pt { fill: var(--dk-encre); opacity: 0.1; }
  .tr-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tr-tick { font-family: var(--dk-mono); font-size: 19px; fill: var(--dk-gris); text-anchor: middle; }
  .tr-g { text-anchor: end; }
  .tr-titre-axe { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }

  .tr-ecarts, .tr-vus { opacity: 0; transition: opacity 0.4s; }
  .tr-ecarts.tr-vu, .tr-vus.tr-vu { opacity: 1; }
  .tr-ecart { fill: none; stroke: var(--dk-gris); stroke-width: 2; transition: d 0.9s ease-in-out; }
  .tr-vu-pt { fill: var(--dk-encre); }

  .tr-ligne { fill: none; stroke: var(--dk-accent); stroke-width: 5; opacity: 0; transition: d 0.9s ease-in-out, opacity 0.4s; }
  .tr-ligne.tr-vu { opacity: 1; }
  .tr-lib { font-family: var(--dk-mono); font-size: 22px; font-weight: 700; fill: var(--dk-accent); text-anchor: start; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; opacity: 0; transition: opacity 0.3s; }
  .tr-lib.tr-vu { opacity: 1; }

  /* La barre : toute la variation de la note, la part qui suit la droite en rouge. */
  .tr-barre { display: flex; height: 2em; border: 2px solid var(--dk-encre); opacity: 0; transition: opacity 0.4s; font-size: 0.85em; }
  .tr-barre.tr-vu { opacity: 1; }
  .tr-part { background: var(--dk-accent); color: var(--dk-fond); display: flex; align-items: center; justify-content: center; font-weight: 700; flex: 0 0 auto; }
  .tr-reste { flex: 1 1 auto; background: var(--dk-fond-2); display: flex; align-items: center; padding-left: 0.7em; color: var(--dk-gris); }
  .tr-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; }

  @media (prefers-reduced-motion: reduce) {
    .tr-ecarts, .tr-vus, .tr-ecart, .tr-ligne, .tr-lib, .tr-barre { transition: none; }
  }
</style>
