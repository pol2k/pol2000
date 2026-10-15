<script>
  /**
   * R² = 0,04 : la part de la variation de l'intérêt que la droite suit. À
   * gauche, le tableau d'article (TabPublie). À droite, notre sondage en
   * colonnes (pâles : `jx` et `jy` étalent chaque personne, pour le dessin
   * seulement). Une personne sur 20 est à l'encre, à sa vraie valeur
   * d'intérêt, avec son écart.
   *
   *   0  Le nuage.
   *   1  Sans x : on prédit la moyenne (0,67) à tout le monde. Les écarts à
   *      la moyenne : toute la variation de l'intérêt.
   *   2  Avec x : la ligne pivote et devient la droite de R (elle passe par
   *      le point moyen, d'où le pivot). Les écarts rétrécissent à peine.
   *   3  La barre : 4 % de la variation suit la droite, 96 % reste dans ε.
   *   4  La vedette : un R² faible n'efface pas la pente. 4 % seulement, et
   *      pourtant t = 6,3 et trois étoiles (NOTRE.coefs[1].t et p). Le R²
   *      n'est pas une note de qualité.
   *
   * Nombres : NOTRE (coefs, points, r2, moyenne_y) et VARS dans
   * src/lib/data/seance7.js. outils/seance7_g.R recalcule le R² à la main
   * pour vérifier summary().
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const nb = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  const B0 = NOTRE.coefs[0].b, B1 = NOTRE.coefs[1].b;
  const MOY = NOTRE.moyenne_y;
  const X0 = 160, X1 = 560, Y0 = 250, Y1 = 40;
  const x = (v) => X0 + v * (X1 - X0);
  const y = (v) => Y0 - v * (Y0 - Y1);
  // Les niveaux de scolarité sur deux lignes, coupés à la virgule ou au premier espace.
  const deuxLignes = (t) => {
    const s = t.toLowerCase(), i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return j > 0 ? [s.slice(0, j), s.slice(j + 1)] : [s, ''];
  };
  const NX = VARS.x.valeurs.map((v, i) => ({ v, l: deuxLignes(VARS.x.niveaux[i]) }));
  const C1 = NOTRE.coefs[1];
  const et = (p) => (p < 0.001 ? '***' : p < 0.01 ? '**' : p < 0.05 ? '*' : '');
  const PTS = NOTRE.points;
  // Une personne sur 20, dans l'ordre du fichier : un échantillon fixe, sans hasard.
  const VUS = PTS.filter((_, i) => i % 20 === 0);
  const pred = (v) => B0 + B1 * v;
  const ligne = (a, b) => `path('M ${x(-0.08)} ${y(a)} L ${x(1.08)} ${y(b)}')`;
  const PLATE = ligne(MOY, MOY);
  const DROITE = ligne(pred(-0.08), pred(1.08));
  const ecart = (p, cible) => `path('M ${x(p.jx)} ${y(p.y)} L ${x(p.jx)} ${y(cible)}')`;
  const PART = Math.round(NOTRE.r2 * 100);
  const ON = [[], [], [], ['r2'], ['r2', `b-${VARS.x.nom}`, `etoiles-${VARS.x.nom}`]];
</script>

<div class="visuel tab-r2" bind:this={hote}>
  <div class="tr-tab"><TabPublie on={ON[e]} /></div>

  <div class="tr-droite">
    <svg viewBox="0 0 640 352" role="img" aria-label="Les {PTS.length} personnes de notre sondage, en colonnes. Sans la scolarité, on prédit la moyenne, {f(MOY)}, à tout le monde. Avec elle, la ligne pivote et les écarts rétrécissent à peine. {PART}&#8239;% de la variation de l’intérêt suit la droite, {100 - PART}&#8239;% reste. Et pourtant la pente est nette&#8239;: t = {f(C1.t, 1)}.">
      {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.jy)} r="2.4" class="tr-pt" />{/each}

      <line x1={X0 - 30} y1={Y0 + 16} x2={X1 + 30} y2={Y0 + 16} class="tr-axe" />
      <line x1={X0 - 30} y1={Y0 + 16} x2={X0 - 30} y2={Y1 - 16} class="tr-axe" />
      {#each NX as t}
        <text x={x(t.v)} y={Y0 + 38} class="tr-tick">{nb(t.v)}</text>
        <text x={x(t.v)} y={Y0 + 56} class="tr-niv">{t.l[0]}</text>
        <text x={x(t.v)} y={Y0 + 71} class="tr-niv">{t.l[1]}</text>
      {/each}
      {#each [0, 0.5, 1] as v}<text x={X0 - 40} y={y(v) + 6} class="tr-tick tr-g">{nb(v)}</text>{/each}
      <text x="4" y="16" class="tr-titre-axe tr-g0">intérêt</text>
      <text x={(X0 + X1) / 2} y={Y0 + 96} class="tr-titre-axe">scolarité</text>

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
      <text x={x(-0.06)} y={y(MOY) - 12} class="tr-lib" class:tr-vu={e === 1}>moyenne : {f(MOY)}</text>
    </svg>

    <div class="tr-barre" class:tr-vu={e >= 3}>
      <div class="tr-part" style="width: {PART}%"></div>
      <div class="tr-reste"><span><b>{PART}&#8239;%</b> suit la droite · {100 - PART}&#8239;% : le reste (ε)</span></div>
    </div>
    <p class="tr-dit" class:tr-cache={e >= 4}>
      {#if e === 1}sans x : la moyenne pour tout le monde
      {:else if e === 2}avec x : les écarts rétrécissent, à peine
      {:else if e === 3}{PART}&#8239;% de la variation suit la droite
      {:else if e < 4}&#8203;{/if}
    </p>
    <p class="tr-vedette" class:tr-vu={e >= 4}>un R² faible n’efface pas la pente<span>{PART}&#8239;% seulement, et pourtant t = {f(C1.t, 1)} {et(C1.p)}</span></p>
  </div>
</div>

<style>
  .tab-r2 { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tr-tab { font-size: 0.92em; }
  .tr-droite { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; display: block; max-height: 46vh; }
  .tr-pt { fill: var(--dk-encre); opacity: 0.1; }
  .tr-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tr-tick { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }
  .tr-g { text-anchor: end; }
  .tr-niv { font-family: var(--dk-mono); font-size: 14px; fill: var(--dk-gris); text-anchor: middle; }
  .tr-niv.tr-g { text-anchor: end; }
  .tr-titre-axe.tr-g0 { text-anchor: start; }
  .tr-titre-axe { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }

  .tr-ecarts, .tr-vus { opacity: 0; transition: opacity 0.4s; }
  .tr-ecarts.tr-vu, .tr-vus.tr-vu { opacity: 1; }
  .tr-ecart { fill: none; stroke: var(--dk-gris); stroke-width: 2; transition: d 0.9s ease-in-out; }
  .tr-vu-pt { fill: var(--dk-encre); }

  .tr-ligne { fill: none; stroke: var(--dk-accent); stroke-width: 5; opacity: 0; transition: d 0.9s ease-in-out, opacity 0.4s; }
  .tr-ligne.tr-vu { opacity: 1; }
  .tr-lib { font-family: var(--dk-mono); font-size: 22px; font-weight: 700; fill: var(--dk-accent); text-anchor: start; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; opacity: 0; transition: opacity 0.3s; }
  .tr-lib.tr-vu { opacity: 1; }

  /* La barre : toute la variation de l’intérêt, la part qui suit la droite en rouge. */
  .tr-barre { display: flex; height: 1.7em; border: 2px solid var(--dk-encre); opacity: 0; transition: opacity 0.4s; font-size: 0.85em; }
  .tr-barre.tr-vu { opacity: 1; }
  .tr-part { background: var(--dk-accent); color: var(--dk-fond); display: flex; align-items: center; justify-content: center; font-weight: 700; flex: 0 0 auto; }
  .tr-reste { flex: 1 1 auto; background: var(--dk-fond-2); display: flex; align-items: center; padding-left: 0.7em; color: var(--dk-gris); }
  .tr-tick.tr-g { text-anchor: end; }
  .tr-reste b { color: var(--dk-accent); }
  .tr-vedette { display: none; margin: 0.2em auto 0; padding: 0.3em 0.9em 0.35em; border: 3px solid var(--dk-accent); text-align: center; font-size: 1.2em; font-weight: 700; line-height: 1.3; color: var(--dk-accent); animation: tr-entre 0.4s both; }
  .tr-vedette.tr-vu { display: block; }
  .tr-vedette span { display: block; font-size: 0.7em; color: var(--dk-encre); }
  @keyframes tr-entre { from { opacity: 0; transform: scale(0.96); } to { opacity: 1; transform: none; } }
  .tr-dit.tr-cache { display: none; }
  .tr-dit { margin: 0; min-height: 1.3em; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; }

  @media (prefers-reduced-motion: reduce) {
    .tr-ecarts, .tr-vus, .tr-ecart, .tr-ligne, .tr-lib, .tr-barre { transition: none; }
  }
</style>
