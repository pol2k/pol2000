<script>
  /**
   * Comment ça marche ? R cherche la droite qui passe le plus près de tous
   * les points. Quinze vraies personnes de notre sondage (QUINZE, graine 62
   * puis 28, outils/seance7_data.R) : scolarité (0 à 1) et intérêt pour la
   * politique (0 à 1). D'abord seulement la distance verticale entre chaque
   * point et la droite (un trait rouge), puis le carré bâti sur cette
   * distance (un aplat pâle). À droite, l'aire totale des carrés : plus elle
   * est petite, plus la droite passe près des points. Pourquoi des carrés
   * plutôt que les distances : la diapo suivante (RegCarres).
   *
   *   0  Les quinze points.
   *   1  Une droite qui descend (0,95 − 0,5 × x) et, pour chaque personne,
   *      sa distance à la droite. Rien d'autre.
   *   2  Sur chaque distance, un carré. L'aire totale des carrés apparaît.
   *   3  La moyenne pour tout le monde (une droite plate) : bien mieux.
   *   4  La droite de lm() : la plus petite aire totale possible, un peu
   *      sous la moyenne (avec 15 personnes, la scolarité n'explique qu'une
   *      petite part de l'intérêt : c'est le petit R² qu'on lira plus loin).
   *
   * Entre deux temps, la droite glisse (constante et pente interpolées) et
   * l'aire se recalcule en direct sur les quinze vraies valeurs. Aux temps
   * 2, 3 et 4, elle vaut exactement DROITES[k].somme, calculé par R
   * (outils/seance7_b.R, somme des carrés des écarts) : 1,67, 1,27, 1,25.
   * Le trajet ne descend jamais sous la valeur d'arrivée (vérifié pas à pas).
   *
   * Le dessin : des personnes partagent parfois la même case (deux à
   * « université, 1er cycle » et 0,8, deux à 0,3). Le léger étalement `jx`
   * de R ne suffit pas à les séparer dans le dessin : on les range côte à
   * côte dans leur case, dans l'ordre de `jx`, 17 px l'une de l'autre. Le
   * trait de chaque distance va du point à la droite à l'endroit où le point
   * est dessiné; l'aire, elle, utilise les vraies valeurs de x.
   */
  import { brancherTemps } from '../temps.js';
  import { Tween } from 'svelte/motion';
  import { cubicInOut } from 'svelte/easing';
  import { QUINZE, VARS } from '$lib/data/seance7.js';
  import { DROITES } from '$lib/data/seance7_b.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const lent = () => typeof window !== 'undefined' && !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const ligne = new Tween([DROITES[0].b0, DROITES[0].b1], { duration: 900, easing: cubicInOut });
  $effect(() => {
    const d = DROITES[Math.max(0, e - 2)];
    ligne.set([d.b0, d.b1], { duration: e === 0 || !lent() ? 0 : 900 });
  });

  // Repères : scolarité de 0 à 1 (en x), intérêt de 0 à 1 (en y). Le
  // carré d'un écart a le même côté en pixels dans les deux sens.
  const X0 = 196, X1 = 676, Y0 = 392, Y1 = 46;
  const PX = Y0 - Y1;
  const sx = (v) => X0 + v * (X1 - X0);
  const sy = (v) => Y0 - v * PX;
  const AXE_X = Y0 + 24, AXE_Y = X0 - 56;

  // Les points rangés côte à côte dans leur case.
  const PAS = 17;
  const PTS = (() => {
    const groupes = new Map();
    QUINZE.points.forEach((p, i) => {
      const k = p.x + '|' + p.y;
      if (!groupes.has(k)) groupes.set(k, []);
      groupes.get(k).push({ ...p, i });
    });
    const out = [];
    for (const g of groupes.values()) {
      g.sort((a, b) => a.jx - b.jx);
      g.forEach((p, j) => out.push({ ...p, px: sx(p.x) + (j - (g.length - 1) / 2) * PAS }));
    }
    return out.sort((a, b) => a.i - b.i);
  })();

  const prevu = (x) => ligne.current[0] + ligne.current[1] * x;
  const auPixel = (px) => prevu((px - X0) / (X1 - X0));
  const total = $derived(QUINZE.points.reduce((s, p) => s + (p.y - prevu(p.x)) ** 2, 0));
  const MAXI = DROITES[0].somme;

  const virgule = (v, d = 2) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  // Les niveaux du codebook, en minuscules, sur deux lignes.
  const NX = VARS.x.niveaux.map((t) => {
    const s = t.toLowerCase();
    const i = s.indexOf(', ');
    if (i > 0) return [s.slice(0, i + 1), s.slice(i + 2)];
    const j = s.indexOf(' ');
    return j > 0 ? [s.slice(0, j), s.slice(j + 1)] : [s, ''];
  });
  // Les bornes du curseur, sur deux lignes (« beaucoup / d'intérêt »).
  const BORNES = VARS.y.bornes.map((t) => { const s = t.toLowerCase(); const j = s.indexOf(' '); return [s.slice(0, j), s.slice(j + 1)]; });
  const TICKS = [0, 0.2, 0.4, 0.6, 0.8, 1];
  const ETIQ = ['une droite qui descend', 'la moyenne pour tout le monde', 'la droite de lm()'];
</script>

<div class="visuel rm" bind:this={hote}>
  <svg viewBox="0 0 700 520" role="img"
    aria-label="Quinze personnes de notre sondage : scolarité et intérêt pour la politique. Trois droites essayées, chacune avec ses écarts aux points. La droite de lm a le plus petit total des carrés : {virgule(DROITES[2].somme)}.">
    <defs>
      <clipPath id="rm-cadre"><rect x={X0 - 60} y={Y1 - 10} width={X1 - X0 + 80} height={Y0 - Y1 + 20} /></clipPath>
    </defs>

    <line x1={AXE_Y} y1={AXE_X} x2={X1 + 18} y2={AXE_X} class="axe" />
    <line x1={AXE_Y} y1={AXE_X} x2={AXE_Y} y2={Y1 - 30} class="axe" />
    {#each VARS.x.valeurs as v, i}
      <line x1={sx(v)} y1={AXE_X} x2={sx(v)} y2={AXE_X + 7} class="axe" />
      <text x={sx(v)} y={AXE_X + 27} class="val">{v.toLocaleString('fr-CA')}</text>
      <text x={sx(v)} y={AXE_X + 48} class="niv">{NX[i][0]}</text>
      <text x={sx(v)} y={AXE_X + 66} class="niv">{NX[i][1]}</text>
    {/each}
    {#each TICKS as v}
      <line x1={AXE_Y - 7} y1={sy(v)} x2={AXE_Y} y2={sy(v)} class="axe" />
      <text x={AXE_Y - 13} y={sy(v) + 6} class="val d">{v.toLocaleString('fr-CA')}</text>
    {/each}
    <text x={AXE_Y - 52} y={sy(1) - 2} class="niv d">{BORNES[1][0]}</text>
    <text x={AXE_Y - 52} y={sy(1) + 15} class="niv d">{BORNES[1][1]}</text>
    <text x={AXE_Y - 52} y={sy(0) - 2} class="niv d">{BORNES[0][0]}</text>
    <text x={AXE_Y - 52} y={sy(0) + 15} class="niv d">{BORNES[0][1]}</text>
    <text x={(X0 + X1) / 2} y="512" class="titre-axe">scolarité</text>
    <text x={AXE_Y - 13} y="14" class="titre-axe d">intérêt</text>

    <g clip-path="url(#rm-cadre)" class="essai" class:vu={e >= 1}>
      <!-- Les carrés (à partir du temps 2), puis les distances, puis la droite. -->
      <g class="carres" class:vu={e >= 2}>
        {#each PTS as p}
          {@const cote = Math.abs(p.y - auPixel(p.px)) * PX}
          <rect x={p.x <= 0.5 ? p.px : p.px - cote} y={Math.min(sy(p.y), sy(auPixel(p.px)))} width={cote} height={cote} class="carre" />
        {/each}
      </g>
      {#each PTS as p}
        <line x1={p.px} y1={sy(p.y)} x2={p.px} y2={sy(auPixel(p.px))} class="ecart" />
      {/each}
      <line x1={sx(-0.1)} y1={sy(prevu(-0.1))} x2={sx(1.1)} y2={sy(prevu(1.1))} class="droite" class:r={e === 4} />
    </g>

    {#each PTS as p, i}
      <circle cx={p.px} cy={sy(p.y)} r="7.5" class="pt" style="--k: {i}" />
    {/each}
  </svg>

  <div class="cote">
    <ul class="legende">
      <li class:vu={e >= 1}><svg viewBox="0 0 30 30" class="ic"><line x1="15" y1="3" x2="15" y2="27" class="ecart" /></svg><span>la distance entre le point et la droite</span></li>
      <li class:vu={e >= 2}><svg viewBox="0 0 30 30" class="ic"><rect x="3" y="3" width="24" height="24" class="carre" /><line x1="3" y1="3" x2="3" y2="27" class="ecart" /></svg><span>le carré bâti sur cette distance</span></li>
    </ul>
    <div class="lecture" class:vu={e >= 2}>
      <span class="et">l'aire totale des carrés</span>
      <span class="val-g" class:r={e === 4}>{virgule(total)}</span>
      <span class="jauge"><span class="plein" class:r={e === 4} style="width: {(100 * total) / MAXI}%"></span></span>
    </div>
    <ol class="essais">
      {#each ETIQ as t, k}
        <li class:vu={e >= k + 2} class:actuel={e === k + 2}>
          <span class="t">{t}</span><span class="s">{e >= k + 2 ? virgule(DROITES[k].somme) : ''}</span>
        </li>
      {/each}
    </ol>
    <p class="mot" class:vu={e >= 4}>la droite qui passe le plus près de tous les points</p>
    <p class="source">15 répondant.e.s de notre sondage, CES 2025</p>
  </div>
</div>

<style>
  .rm { display: grid; grid-template-columns: 1.25fr 1fr; gap: 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .val { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .niv { font-size: 13px; text-anchor: middle; fill: var(--dk-encre); }
  .val.d, .niv.d { text-anchor: end; }
  .titre-axe.d { text-anchor: end; }
  .titre-axe { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; animation: rm-pose 0.4s cubic-bezier(0.34, 1.6, 0.64, 1) both; animation-delay: calc(var(--k) * 50ms + 100ms); transform-box: fill-box; transform-origin: center; }
  .essai, .carres { opacity: 0; transition: opacity 0.5s; }
  .essai.vu, .carres.vu { opacity: 1; }
  .carre { fill: var(--dk-accent); fill-opacity: 0.07; stroke: var(--dk-accent); stroke-opacity: 0.3; stroke-width: 1; }
  .ecart { stroke: var(--dk-accent); stroke-width: 3; }
  .droite { stroke: var(--dk-gris); stroke-width: 5; transition: stroke 0.4s; }
  .droite.r { stroke: var(--dk-encre); }

  .cote { display: flex; flex-direction: column; gap: 0.9em; }
  .legende { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 0.3em; }
  .legende li { display: flex; align-items: center; gap: 0.6em; margin: 0; font-size: 0.8em; line-height: 1.25; opacity: 0; transition: opacity 0.4s; }
  .legende li.vu { opacity: 1; }
  .ic { width: 1.5em; height: 1.5em; flex: none; overflow: visible; }
  .lecture { display: flex; flex-direction: column; gap: 0.15em; opacity: 0; transition: opacity 0.4s; }
  .lecture.vu { opacity: 1; }
  .et { font-size: 0.7em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .val-g { white-space: nowrap; font-size: 3em; font-weight: 600; line-height: 1.05; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
  .val-g.r { color: var(--dk-accent); }
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
    .essai, .carres, .legende li, .lecture, .essais li, .mot { transition: none; }
  }
</style>
