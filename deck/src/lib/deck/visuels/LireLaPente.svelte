<script>
  /**
   * « Lire la pente » : ce que veut dire β1 = −5,05, sur la droite de R
   * (notre sondage, NOTRE.coefs de src/lib/data/seance7.js : 79,8 et
   * −5,05). Pas de nuage ici : la droite seule, pour voir la marche.
   * L'axe vertical va de 25 à 85 (pas de 0 à 100) pour que la marche de
   * 5 points se voie; c'est une droite, pas des barres, et les repères
   * sont écrits.
   *
   * On compare deux positions sur la droite (à 3 et à 4), pas une
   * personne qui « bouge » : la régression compare des gens, elle ne dit
   * pas ce qui arrive si quelqu'un change d'idée. Les deux notes prédites
   * ne sont pas écrites : arrondies, leur différence ne tomberait pas
   * juste (64,7 − 59,6 = 5,1). Seule la marche, −5,05, est écrite.
   *
   * Temps :
   *   0  la droite de R et son équation;
   *   1  à 3 et à 4 sur la droite, et la marche entre les deux : + 1 cran,
   *      − 5,05 points;
   *   2  la même marche à chaque cran, de 0 à 10 : un escalier régulier.
   *      La phrase : « Un cran de plus vers la droite : 5 points de moins
   *      pour Carney, en moyenne. »;
   *   3  l'ordonnée à l'origine : à 0, la droite prédit 79,8;
   *   4  la recette générale, sur fond d'encre : « + 1 unité de x → β1
   *      unités de y », la flèche se lit « est associé à » (pas « cause »),
   *      et « toutes choses égales par ailleurs » annoncé pour la séance 8.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import EquationDroite from './EquationDroite.svelte';

  const R0 = NOTRE.coefs[0].b;
  const R1 = NOTRE.coefs[1].b;
  const TOTAL = 4;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Format québécois, vrai signe moins (U+2212).
  const f = (v, d) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const B0 = f(R0, 1);
  const B1 = f(R1, 2);
  const B1_ARRONDI = Math.round(Math.abs(R1)); // « 5 points » dans la phrase

  // Le dessin : gauche_droite de 0 à 10, note de 25 à 85.
  const X0 = 78, X1 = 598, YB = 420, YT = 22, Y_BAS = 25, Y_HAUT = 85;
  const x = (v) => X0 + (v / 10) * (X1 - X0);
  const y = (v) => YB - ((v - Y_BAS) / (Y_HAUT - Y_BAS)) * (YB - YT);
  const pred = (v) => R0 + R1 * v;
  const A = 3; // la marche qu'on regarde : de 3 à 4
  const MARCHES = Array.from({ length: 10 }, (_, k) => k).filter((k) => k !== A);
  const chemin = (k) => `M ${x(k)} ${y(pred(k))} H ${x(k + 1)} V ${y(pred(k + 1))}`;

  // Le rôle de chaque case de l'équation, selon le temps.
  const actif = $derived(e === 1 || e === 2 ? 'b1' : e === 3 ? 'b0' : null);
</script>

<div class="visuel lire-pente" bind:this={hote} data-temps={e}>
  <EquationDroite b0={R0} b1={R1} {actif} />

  <div class="corps">
    <svg viewBox="0 0 620 478" role="img" aria-label="La droite de R&#8239;: note égale {B0} moins {f(-R1, 2)} fois gauche_droite. D’un cran au suivant, par exemple de 3 à 4, la droite descend de {f(-R1, 2)} points, et c’est la même marche à chaque cran. À 0, tout à gauche, la droite prédit {B0}.">
      <!-- Les axes. -->
      <line x1={X0} y1={YB} x2={X1} y2={YB} class="axe" />
      <line x1={X0} y1={YB} x2={X0} y2={YT - 8} class="axe" />
      {#each [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] as v}
        <line x1={x(v)} y1={YB} x2={x(v)} y2={YB + 7} class="axe" />
        <text x={x(v)} y={YB + 27} class="tick" class:fort={e >= 1 && (v === A || v === A + 1)}>{v}</text>
      {/each}
      {#each [30, 40, 50, 60, 70, 80] as v}
        <line x1={X0 - 7} y1={y(v)} x2={X0} y2={y(v)} class="axe" />
        <text x={X0 - 13} y={y(v) + 5} class="tick fin">{v}</text>
      {/each}
      <text x={(X0 + X1) / 2} y="470" class="titre-axe">gauche_droite</text>
      <text transform="translate(18 {(YB + YT) / 2}) rotate(-90)" class="titre-axe">note prédite</text>

      <!-- La droite de R. -->
      <line x1={x(0)} y1={y(pred(0))} x2={x(10)} y2={y(pred(10))} class="droite" />

      <!-- 2 : la même marche à chaque cran. -->
      {#each MARCHES as k}
        <path d={chemin(k)} pathLength="1" class="trace fine" class:vu={e >= 2} style="transition-delay: {e >= 2 ? 150 + k * 110 : 0}ms" />
      {/each}

      <!-- 1 : à 3, à 4, et la marche entre les deux. -->
      <g class="apparait" class:vu={e >= 1}>
        <line x1={x(A)} y1={y(pred(A))} x2={x(A)} y2={YB} class="guide" />
        <line x1={x(A + 1)} y1={y(pred(A + 1))} x2={x(A + 1)} y2={YB} class="guide" />
      </g>
      <path d={chemin(A)} pathLength="1" class="trace" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 500 : 0}ms" />
      <circle cx={x(A)} cy={y(pred(A))} r="9" class="pt apparait" class:vu={e >= 1} />
      <circle cx={x(A + 1)} cy={y(pred(A + 1))} r="9" class="pt apparait" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 250 : 0}ms" />
      <g class="apparait" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 1300 : 0}ms">
        <text x={(x(A) + x(A + 1)) / 2} y={y(pred(A + 1)) + 34} class="note-m">+1 cran</text>
        <text x={x(A + 1) + 14} y={(y(pred(A)) + y(pred(A + 1))) / 2 + 8} class="note-m rouge debut">{B1}</text>
      </g>

      <!-- 3 : l'ordonnée à l'origine, à 0. -->
      <g class="apparait" class:vu={e >= 3}>
        <circle cx={x(0)} cy={y(R0)} r="11" class="pt0" />
        <text x={x(0) + 20} y={y(R0) - 16} class="note-m debut encre">à 0&#8239;: {B0}</text>
      </g>
    </svg>

    <div class="panneau">
      <p class="gros apparait" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 1300 : 0}ms">+1 cran → <span class="rouge">{B1}</span> points</p>
      <p class="phrase apparait" class:vu={e >= 2}>Un cran de plus vers la droite&#8239;: {B1_ARRONDI} points de moins pour Carney, en moyenne.</p>
      <p class="phrase apparait" class:vu={e >= 3}>À 0 (tout à gauche), la droite prédit <b>{B0}</b>.</p>
      <div class="recette apparait" class:vu={e >= 4}>
        <p class="r1">+1 unité de x → β1 unités de y</p>
        <p class="r2">«&#8239;→&#8239;» se lit «&#8239;est associé à&#8239;», pas «&#8239;cause&#8239;»</p>
        <p class="r3">toutes choses égales par ailleurs&#8239;: séance 8</p>
      </div>
    </div>
  </div>
</div>

<style>
  .lire-pente { display: flex; flex-direction: column; gap: 0.5em; }
  .corps { display: grid; grid-template-columns: minmax(0, 1.12fr) 1fr; gap: 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 61vh; display: block; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.3s; }
  .tick.fin { text-anchor: end; }
  .tick.fort { fill: var(--dk-accent); font-weight: 600; }
  .titre-axe { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .droite { stroke: var(--dk-encre); stroke-width: 4; }
  .guide { stroke: var(--dk-gris-2); stroke-width: 1.5; stroke-dasharray: 4 5; }

  .trace { fill: none; stroke: var(--dk-accent); stroke-width: 4.5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .trace.fine { stroke-width: 2.5; opacity: 0.75; transition-duration: 0.35s; }
  .trace.vu { stroke-dashoffset: 0; }

  .pt { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .pt0 { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .note-m { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }
  .note-m.debut { text-anchor: start; }
  .note-m.rouge { fill: var(--dk-accent); font-size: 22px; }
  .note-m.encre { font-size: 20px; }

  .apparait { opacity: 0; transition: opacity 0.45s; }
  .apparait.vu { opacity: 1; }

  .panneau { display: flex; flex-direction: column; gap: 0.75em; }
  .panneau p { margin: 0; }
  .gros { font-size: 1.3em !important; font-weight: 600; line-height: 1.2 !important; font-variant-numeric: tabular-nums; }
  .rouge { color: var(--dk-accent); }
  .phrase { font-size: 0.9em !important; line-height: 1.4 !important; }
  .phrase b { color: var(--dk-accent); }
  .recette { background: var(--dk-encre); color: var(--dk-fond); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.35em; }
  .r1 { color: var(--dk-accent-clair); font-weight: 600; font-size: 1em !important; }
  .r2 { font-size: 0.8em !important; line-height: 1.4 !important; }
  .r3 { font-size: 0.76em !important; line-height: 1.4 !important; color: var(--dk-gris-2); }
</style>
