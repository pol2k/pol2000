<script>
  /**
   * La feuille de route de la séance : trois questions pour décrire une
   * variable. Trois panneaux, un dessin schématique chacun, aucun chiffre.
   * La hiérarchie : la forme EST toute l'histoire ; le centre et la
   * dispersion sont les deux résumés auxquels on se rabat, parce que
   * personne ne retient une forme entière.
   *
   *   0  La forme : un petit histogramme dont la silhouette se trace.
   *      Les deux autres panneaux attendent, pâles.
   *   1  Le centre : une pile de blocs sur un fléau qui oscille, puis
   *      trouve son équilibre sur le pivot.
   *   2  La dispersion : une flèche double qui s'étire et se contracte,
   *      les points s'écartent avec elle.
   *   3  La hiérarchie. La forme s'encadre de rouge : c'est le tout. Un
   *      connecteur « résumée par » en part et descend sur le centre et
   *      sur la dispersion. Chaque panneau gagne sa ligne rouge, et la
   *      clôture dit pourquoi on résume.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Panneau 1 : des hauteurs schématiques, une cloche vague.
  const Y0 = 180;
  const H = [18, 42, 78, 112, 128, 104, 70, 38, 16];
  const PAS = 27, L = 23, XG = 28;
  const barres = H.map((h, i) => ({ x: XG + i * PAS, h }));
  // La silhouette : une courbe lissée (Catmull-Rom) par le haut des barres.
  const pts = [[XG, Y0], ...barres.map((b) => [b.x + L / 2, Y0 - b.h]), [XG + H.length * PAS - (PAS - L), Y0]];
  function lisse(p) {
    let d = `M ${p[0][0]} ${p[0][1]}`;
    for (let i = 0; i < p.length - 1; i++) {
      const p0 = p[i - 1] ?? p[i], p1 = p[i], p2 = p[i + 1], p3 = p[i + 2] ?? p2;
      const c1 = [p1[0] + (p2[0] - p0[0]) / 6, Math.min(Y0, p1[1] + (p2[1] - p0[1]) / 6)];
      const c2 = [p2[0] - (p3[0] - p1[0]) / 6, Math.min(Y0, p2[1] - (p3[1] - p1[1]) / 6)];
      d += ` C ${c1[0].toFixed(1)} ${c1[1].toFixed(1)}, ${c2[0].toFixed(1)} ${c2[1].toFixed(1)}, ${p2[0]} ${p2[1]}`;
    }
    return d;
  }
  const contour = lisse(pts);

  // Panneau 2 : des blocs répartis symétriquement autour du pivot.
  const BLOCS = [
    { x: 52, y: 100 }, { x: 88, y: 100 },
    { x: 132, y: 100 }, { x: 132, y: 70 }, { x: 132, y: 40 },
    { x: 176, y: 100 }, { x: 212, y: 100 }
  ];

  // Panneau 3 : des points à distance du centre (k = écart en unités du dessin).
  const POINTS = [-96, -62, -34, -12, 10, 30, 58, 92];
</script>

<div class="visuel trois-q" bind:this={hote}>
  <div class="lien" class:vu={e >= 3} aria-hidden="true">
    <i class="dep"></i>
    <i class="desc mil"></i>
    <i class="desc fin"></i>
    <span class="lien-t">résumée par</span>
  </div>

  <div class="panneau" class:on={e >= 0} class:actif={e === 0 || e >= 3}>
    <svg viewBox="0 0 300 200" role="img" aria-label="Schéma : un histogramme et sa silhouette.">
      <line x1="16" y1={Y0} x2="284" y2={Y0} class="axe" />
      {#each barres as b, i}
        <rect x={b.x} y={Y0 - b.h} width={L} height={b.h} class="barre" style="--d: {i * 70}ms" />
      {/each}
      <path d={contour} pathLength="1" class="contour" />
    </svg>
    <h3>La forme</h3>
    <p>À quoi ça ressemble&#8239;?</p>
    <p class="pourquoi" class:vu={e >= 3} style="--pd: 0ms">{#if e >= 3}tout y est, mais c’est trop pour une seule tête{/if}</p>
  </div>

  <div class="panneau" class:on={e >= 1} class:actif={e === 1}>
    <svg viewBox="0 0 300 200" role="img" aria-label="Schéma : des blocs en équilibre sur un pivot.">
      <line x1="16" y1={Y0} x2="284" y2={Y0} class="axe" />
      <g class="fleau">
        {#each BLOCS as b, i}
          <rect x={b.x} y={b.y} width="36" height="30" class="bloc" class:milieu={b.x === 132} style="--d: {i * 90}ms" />
        {/each}
        <rect x="36" y="130" width="228" height="8" class="poutre" />
      </g>
      <polygon points="150,138 124,180 176,180" class="pivot" />
    </svg>
    <h3>Le centre</h3>
    <p>Où est le milieu&#8239;?</p>
    <p class="pourquoi" class:vu={e >= 3} style="--pd: 150ms">{#if e >= 3}le résumé en un chiffre{/if}</p>
  </div>

  <div class="panneau" class:on={e >= 2} class:actif={e === 2}>
    <svg viewBox="0 0 300 200" role="img" aria-label="Schéma : une flèche double qui s'étire, des points qui s'écartent.">
      <line x1="16" y1={Y0} x2="284" y2={Y0} class="axe" />
      <line x1="150" y1="40" x2="150" y2={Y0} class="centre" />
      <g class="tige"><line x1="90" y1="86" x2="210" y2="86" class="trait" /></g>
      <g class="tete g"><path d="M 104 70 L 84 86 L 104 102" class="trait" /></g>
      <g class="tete d"><path d="M 196 70 L 216 86 L 196 102" class="trait" /></g>
      {#each POINTS as k}
        <circle cx={150 + k} cy="150" r="8" class="pt" style="--k: {k}" />
      {/each}
    </svg>
    <h3>La dispersion</h3>
    <p>Ça s’étale comment&#8239;?</p>
    <p class="pourquoi" class:vu={e >= 3} style="--pd: 300ms">{#if e >= 3}à quel point ce chiffre résume bien{/if}</p>
  </div>

  <p class="cloture" class:vu={e >= 3}>{#if e >= 3}<span class="ph">Si on pouvait retenir la forme, on n’aurait besoin de rien d’autre.</span> <span class="ph cle">On la résume&#8239;: un centre, une dispersion.</span>{/if}</p>
</div>

<style>
  .trois-q { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.5em 1.2em; }

  /* Le connecteur « résumée par » : il sort du haut de la forme, file vers
     la droite et retombe en flèche sur le centre et sur la dispersion. Même
     grille que les panneaux, pour tomber pile au milieu de chacun. Sa place
     est réservée dès le temps 0. */
  .lien { grid-column: 1 / -1; position: relative; display: grid; grid-template-columns: repeat(3, 1fr); column-gap: 1.2em; height: 1.3em; margin-top: 0.55em; opacity: 0; transition: opacity 0.5s; }
  .lien.vu { opacity: 1; }
  .dep, .desc { display: block; position: relative; box-sizing: border-box; height: 100%; border: 0 solid var(--dk-accent); border-top-width: 3px; }
  .dep { margin-left: 50%; width: calc(50% + 1.2em); height: calc(100% + 0.5em); border-left-width: 3px; }
  .mil { width: calc(100% + 1.2em); }
  .fin { width: 50%; border-right-width: 3px; }
  .mil::after { content: ''; position: absolute; top: 0; bottom: 0; left: calc((100% - 1.2em) / 2); border-left: 3px solid var(--dk-accent); }
  .desc::before { content: ''; position: absolute; bottom: -0.35em; width: 0; height: 0; border-left: 0.4em solid transparent; border-right: 0.4em solid transparent; border-top: 0.55em solid var(--dk-accent); }
  .mil::before { left: calc((100% - 1.2em) / 2 + 1.5px - 0.4em); }
  .fin::before { right: calc(-0.4em - 1.5px); }
  .lien-t { position: absolute; top: 0; left: calc((100% - 3em) / 3 + 0.75em); transform: translate(-50%, -55%); padding: 0 0.5em; background: var(--dk-fond); color: var(--dk-accent); font-size: 0.8em; font-weight: 600; line-height: 1.2; white-space: nowrap; }
  .panneau { display: flex; flex-direction: column; gap: 0.25em; border: 2px solid var(--dk-filet); padding: 0.9em 1em 1em; opacity: 0.28; transition: opacity 0.5s, border-color 0.4s; }
  .panneau.on { opacity: 1; border-color: var(--dk-encre); }
  .panneau.actif { border: 3px solid var(--dk-accent); padding: calc(0.9em - 1px) calc(1em - 1px) calc(1em - 1px); }
  svg { width: 100%; height: auto; max-height: 30vh; display: block; overflow: visible; }
  h3 { margin: 0.4em 0 0; font-size: 1.35em; font-weight: 600; }
  .panneau.actif h3 { color: var(--dk-accent); }
  p { margin: 0; font-size: 0.9em; color: var(--dk-gris); }

  /* Le pourquoi : deux lignes au plus par panneau, puis deux phrases de
     clôture, une par ligne. Leur place est réservée dès le temps 0
     (min-height), sinon les panneaux sautent quand les lignes arrivent. */
  .pourquoi { margin: 0.2em 0 0; font-size: 0.8em; line-height: 1.25; min-height: 2.5em; color: var(--dk-accent); }
  .pourquoi.vu { animation: surgit 0.45s ease-out both; animation-delay: var(--pd); }
  .cloture { grid-column: 1 / -1; margin: 0; font-size: 0.85em; line-height: 1.3; min-height: 2.6em; color: var(--dk-encre); }
  .ph { display: block; }
  .cloture.vu { animation: surgit 0.5s ease-out 0.5s both; }
  .cle { color: var(--dk-accent); font-weight: 600; }

  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .trait { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-linecap: square; stroke-linejoin: miter; }

  /* 1 · la forme */
  .barre { fill: var(--dk-gris-2); transform-box: fill-box; transform-origin: bottom; }
  .on .barre { animation: monte 0.55s cubic-bezier(0.3, 1.5, 0.5, 1) both; animation-delay: var(--d); }
  .contour { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .on .contour { animation: trace 1.6s 0.7s ease-in-out forwards; }

  /* 2 · le centre */
  .bloc { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .bloc.milieu { fill: var(--dk-encre); }
  .on .bloc { animation: tombe 0.5s cubic-bezier(0.3, 1.6, 0.5, 1) both; animation-delay: var(--d); }
  .poutre { fill: var(--dk-encre); }
  .pivot { fill: var(--dk-accent); }
  .fleau { transform-box: view-box; transform-origin: 150px 138px; }
  .on .fleau { animation: oscille 4.5s 0.6s ease-in-out infinite; }

  /* 3 · la dispersion */
  .centre { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 8 6; }
  .tige, .tete { transform-box: view-box; transform-origin: 150px 86px; }
  .on .tige { animation: etire 2.4s ease-in-out infinite alternate; }
  .on .tete.g { animation: tete-g 2.4s ease-in-out infinite alternate; }
  .on .tete.d { animation: tete-d 2.4s ease-in-out infinite alternate; }
  .pt { fill: var(--dk-accent); }
  .on .pt { animation: etale 2.4s ease-in-out infinite alternate; }

  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes tombe { from { transform: translateY(-70px); opacity: 0; } to { transform: none; opacity: 1; } }
  @keyframes oscille {
    0% { transform: rotate(9deg); } 12% { transform: rotate(-7deg); } 24% { transform: rotate(5deg); }
    36% { transform: rotate(-3deg); } 46% { transform: rotate(1.5deg); } 54%, 100% { transform: rotate(0deg); }
  }
  @keyframes etire { from { transform: scaleX(0.35); } to { transform: scaleX(1.55); } }
  @keyframes tete-g { from { transform: translateX(39px); } to { transform: translateX(-33px); } }
  @keyframes tete-d { from { transform: translateX(-39px); } to { transform: translateX(33px); } }
  @keyframes etale { from { transform: translateX(calc(var(--k) * -0.6px)); } to { transform: translateX(calc(var(--k) * 0.35px)); } }
  @keyframes surgit { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .on .barre, .on .bloc, .on .fleau, .on .tige, .on .tete.g, .on .tete.d, .on .pt { animation: none; }
    .on .contour { animation: none; stroke-dashoffset: 0; }
    .panneau, .lien { transition: none; }
    /* Pas d'opacity: 0 sur la base de ces deux règles : sans animation, elles
       doivent rester lisibles. */
    .pourquoi.vu, .cloture.vu { animation: none; }
  }
</style>
