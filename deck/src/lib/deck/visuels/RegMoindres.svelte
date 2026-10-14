<script>
  /**
   * Comment ça marche ? R cherche la droite qui passe le plus près de tous
   * les points. Quinze vraies personnes de notre sondage (QUINZE, graine 15,
   * outils/seance7_data.R). Pour chaque droite, l'écart vertical entre
   * chaque point et la droite (un trait rouge) et le carré bâti sur cet écart
   * (un aplat pâle). À droite, le total des carrés : plus il est petit, plus
   * la droite passe près des points.
   *
   *   0  Les quinze points.
   *   1  Une droite qui monte (20 + 6 × x) : mauvais sens, gros carrés.
   *   2  La moyenne pour tout le monde (une droite plate) : mieux.
   *   3  La droite de R, lm() : le plus petit total possible.
   *
   * Entre deux temps, la droite glisse (constante et pente interpolées) et
   * le total se recalcule en direct sur les quinze points. Aux temps 1, 2 et
   * 3, il vaut exactement DROITES[k].somme, calculé par R
   * (outils/seance7_b.R) : 20 625, 11 254, 9 366. Le trajet ne descend
   * jamais sous la valeur d'arrivée (vérifié pas à pas).
   */
  import { brancherTemps } from '../temps.js';
  import { Tween } from 'svelte/motion';
  import { cubicInOut } from 'svelte/easing';
  import { QUINZE } from '$lib/data/seance7.js';
  import { DROITES } from '$lib/data/seance7_b.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const lent = () => typeof window !== 'undefined' && !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const ligne = new Tween([DROITES[0].b0, DROITES[0].b1], { duration: 900, easing: cubicInOut });
  $effect(() => {
    const d = DROITES[Math.max(0, e - 1)];
    ligne.set([d.b0, d.b1], { duration: e === 0 || !lent() ? 0 : 900 });
  });

  // Repères : x de 0 à 10, note de 0 à 100. Même échelle en pixels pour
  // les deux sens d'un carré : un écart de 10 points = 10 × PX pixels.
  const X0 = 90, X1 = 610, Y0 = 410, Y1 = 30;
  const PX = (Y0 - Y1) / 100;
  const sx = (v) => X0 + (v / 10) * (X1 - X0);
  const sy = (v) => Y0 - v * PX;

  const prevu = (x) => ligne.current[0] + ligne.current[1] * x;
  const total = $derived(QUINZE.points.reduce((s, p) => s + (p.y - prevu(p.x)) ** 2, 0));
  const MAXI = DROITES[0].somme;

  const milliers = (n) => Math.round(n).toLocaleString('fr-CA').replace(/\s/g, ' ');
  const ETIQ = ['une droite qui monte', 'la moyenne pour tout le monde', 'la droite de lm()'];
</script>

<div class="visuel rm" bind:this={hote}>
  <svg viewBox="0 0 640 470" role="img"
    aria-label="Quinze personnes : position gauche-droite et note de Carney. Trois droites essayées, chacune avec ses écarts aux points. La droite de R, celle de lm, a le plus petit total des carrés : 9 366.">
    <defs>
      <clipPath id="rm-cadre"><rect x={X0} y={Y1} width={X1 - X0} height={Y0 - Y1} /></clipPath>
    </defs>

    <line x1={X0 - 14} y1={Y0 + 14} x2={X1} y2={Y0 + 14} class="axe" />
    <line x1={X0 - 14} y1={Y0 + 14} x2={X0 - 14} y2={Y1} class="axe" />
    {#each [0, 2, 4, 6, 8, 10] as v}
      <line x1={sx(v)} y1={Y0 + 14} x2={sx(v)} y2={Y0 + 21} class="axe" />
      <text x={sx(v)} y={Y0 + 42} class="tick">{v}</text>
    {/each}
    {#each [0, 50, 100] as v}
      <line x1={X0 - 21} y1={sy(v)} x2={X0 - 14} y2={sy(v)} class="axe" />
      <text x={X0 - 28} y={sy(v) + 6} class="tick d">{v}</text>
    {/each}
    <text x={(X0 + X1) / 2} y="466" class="titre-axe">position gauche-droite</text>
    <text transform="translate(20 {(Y0 + Y1) / 2}) rotate(-90)" class="titre-axe">note de Carney</text>

    <g clip-path="url(#rm-cadre)" class="essai" class:vu={e >= 1}>
      <!-- Les carrés, puis les écarts, puis la droite. -->
      {#each QUINZE.points as p}
        {@const g = p.y - prevu(p.x)}
        {@const cote = Math.abs(g) * PX}
        <rect x={p.x <= 5 ? sx(p.x) : sx(p.x) - cote} y={Math.min(sy(p.y), sy(prevu(p.x)))} width={cote} height={cote} class="carre" />
      {/each}
      {#each QUINZE.points as p}
        <line x1={sx(p.x)} y1={sy(p.y)} x2={sx(p.x)} y2={sy(prevu(p.x))} class="ecart" />
      {/each}
      <line x1={sx(0)} y1={sy(prevu(0))} x2={sx(10)} y2={sy(prevu(10))} class="droite" class:r={e === 3} />
    </g>

    {#each QUINZE.points as p, i}
      <circle cx={sx(p.x)} cy={sy(p.y)} r="8" class="pt" style="--k: {i}" />
    {/each}
  </svg>

  <div class="cote">
    <div class="lecture" class:vu={e >= 1}>
      <span class="et">total des carrés</span>
      <span class="val" class:r={e === 3}>{milliers(total)}</span>
      <span class="jauge"><span class="plein" class:r={e === 3} style="width: {(100 * total) / MAXI}%"></span></span>
    </div>
    <ol class="essais">
      {#each ETIQ as t, k}
        <li class:vu={e >= k + 1} class:actuel={e === k + 1}>
          <span class="t">{t}</span><span class="s">{e >= k + 1 ? milliers(DROITES[k].somme) : ''}</span>
        </li>
      {/each}
    </ol>
    <p class="mot" class:vu={e >= 3}>la droite qui passe le plus près de tous les points</p>
    <p class="source">15 répondant.e.s de la CES 2025</p>
  </div>
</div>

<style>
  .rm { display: grid; grid-template-columns: 1.25fr 1fr; gap: 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .titre-axe { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; animation: rm-pose 0.4s cubic-bezier(0.34, 1.6, 0.64, 1) both; animation-delay: calc(var(--k) * 50ms + 100ms); transform-box: fill-box; transform-origin: center; }
  .essai { opacity: 0; transition: opacity 0.4s; }
  .essai.vu { opacity: 1; }
  .carre { fill: var(--dk-accent); fill-opacity: 0.07; stroke: var(--dk-accent); stroke-opacity: 0.3; stroke-width: 1; }
  .ecart { stroke: var(--dk-accent); stroke-width: 3; }
  .droite { stroke: var(--dk-gris); stroke-width: 5; transition: stroke 0.4s; }
  .droite.r { stroke: var(--dk-encre); }

  .cote { display: flex; flex-direction: column; gap: 0.9em; }
  .lecture { display: flex; flex-direction: column; gap: 0.15em; opacity: 0; transition: opacity 0.4s; }
  .lecture.vu { opacity: 1; }
  .et { font-size: 0.7em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .val { white-space: nowrap; font-size: 3em; font-weight: 600; line-height: 1.05; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
  .val.r { color: var(--dk-accent); }
  .jauge { display: block; height: 0.7em; border: 2px solid var(--dk-encre); }
  .plein { display: block; height: 100%; background: var(--dk-gris-2); }
  .plein.r { background: var(--dk-accent); }

  .essais { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 0.15em; }
  .essais li { display: flex; justify-content: space-between; gap: 1em; font-size: 0.8em; color: var(--dk-gris-2); opacity: 0; transition: opacity 0.3s, color 0.3s; margin: 0; }
  .essais li.vu { opacity: 1; }
  .essais li.actuel { color: var(--dk-encre); font-weight: 600; }
  .essais .s { font-variant-numeric: tabular-nums; }

  .mot { font-size: 1em; font-weight: 600; line-height: 1.3; color: var(--dk-accent); border-top: 2px solid var(--dk-encre); padding-top: 0.5em; opacity: 0; transition: opacity 0.4s 0.6s; }
  .mot.vu { opacity: 1; }

  .source { margin: 0; font-size: 0.62em; color: var(--dk-gris); }

  @keyframes rm-pose { from { opacity: 0; transform: scale(0.2); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .pt { animation: none; }
    .essai, .lecture, .essais li, .mot { transition: none; }
  }
</style>
