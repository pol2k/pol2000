<script>
  /**
   * Le quartet d'Anscombe : quatre jeux de onze points, les mêmes chiffres,
   * quatre dessins (datasets::anscombe, src/lib/data/seance3.js).
   *
   *   0  Quatre fiches identiques se remplissent : moyennes, écarts types,
   *      corrélation.
   *   1  Chaque fiche se retourne : son nuage de points apparaît.
   *   2  La même droite se trace sur les quatre.
   *
   * À chaque arrivée sur la diapo, les fiches reviennent et se remplissent
   * de nouveau (tour). Les animations d'entrée n'ont qu'un remplissage
   * « backwards » : sans mouvement, l'état final reste affiché.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { ANSCOMBE } from '$lib/data/seance3.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 2,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  const nb = (v, d = 2) => v.toLocaleString('fr-CA', { maximumFractionDigits: d });
  const r2 = (r) => (Math.round(r * 100) / 100).toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const lignes = (j) => [
    ['moyenne x', nb(j.moyX)],
    ['moyenne y', nb(j.moyY)],
    ['écart type x', nb(j.etX)],
    ['écart type y', nb(j.etY)],
    ['corrélation', r2(j.r)]
  ];

  // Repères du nuage : x de 0 à 20, y de 0 à 14, communs aux quatre.
  const X0 = 44, X1 = 286, Y0 = 258, Y1 = 14;
  const sx = (v) => X0 + (v / 20) * (X1 - X0);
  const sy = (v) => Y0 - (v / 14) * (Y0 - Y1);
  const droite = (j) => `M ${sx(3)} ${sy(j.constante + j.pente * 3)} L ${sx(20)} ${sy(j.constante + j.pente * 20)}`;
</script>

<div class="visuel anscombe" bind:this={hote}>
  {#key tour}
    <div class="rangee">
      {#each ANSCOMBE as j, p}
        <div class="carte" class:tourne={e >= 1} style="--p: {p}">
          <div class="face avant">
            <span class="jeu">Jeu {p + 1}</span>
            {#each lignes(j) as [l, v], k}
              <div class="stat" style="--k: {k}"><span>{l}</span><strong>{v}</strong></div>
            {/each}
          </div>
          <div class="face arriere">
            <span class="jeu">Jeu {p + 1}</span>
            <svg viewBox="0 0 300 290" role="img" aria-label="Nuage de points du jeu {p + 1} d'Anscombe.">
              <path d="M {X0} {Y1} L {X0} {Y0} L {X1} {Y0}" class="axe" />
              {#each [0, 10, 20] as t}
                <text x={sx(t)} y={Y0 + 24} class="tick">{t}</text>
              {/each}
              {#each [0, 7, 14] as t}
                <text x={X0 - 8} y={sy(t) + 5} class="tick d">{t}</text>
              {/each}
              <path d={droite(j)} pathLength="1" class="droite" class:vu={e >= 2} style="--p: {p}" />
              {#each j.x as xv, i}
                <circle cx={sx(xv)} cy={sy(j.y[i])} r="7" class="pt" style="--i: {i}; --p: {p}" />
              {/each}
            </svg>
          </div>
        </div>
      {/each}
    </div>
  {/key}
  <p class="legende">Anscombe (1973) · datasets::anscombe, dans R</p>
</div>

<style>
  .anscombe { display: flex; flex-direction: column; gap: 0.6em; }
  .rangee { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }

  /* La fiche qui se retourne : deux faces dos à dos. */
  .carte {
    position: relative;
    aspect-ratio: 1 / 1.08;
    max-height: 56vh;
    transform-style: preserve-3d;
    transform: perspective(40em) rotateY(0deg);
    transition: transform 0.8s cubic-bezier(0.34, 1.35, 0.64, 1);
    transition-delay: calc(var(--p) * 130ms);
  }
  .carte.tourne { transform: perspective(40em) rotateY(180deg); }
  .face {
    position: absolute;
    inset: 0;
    box-sizing: border-box;
    backface-visibility: hidden;
    -webkit-backface-visibility: hidden;
    border: 3px solid var(--dk-encre);
    background: var(--dk-fond);
    display: flex;
    flex-direction: column;
    padding: 0.55em 0.7em;
  }
  .arriere { transform: rotateY(180deg); }
  .avant { justify-content: center; gap: 0.15em; }
  .jeu { font-size: 0.58em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .avant .jeu { margin-bottom: 0.5em; }

  .stat {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 0.4em;
    font-size: 0.68em;
    padding: 0.32em 0;
    border-bottom: 1px solid var(--dk-filet);
    animation: entre 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
    animation-delay: calc(var(--p) * 150ms + var(--k) * 90ms);
  }
  .stat:last-child { border-bottom: 0; }
  .stat span { color: var(--dk-gris); }
  .stat strong { color: var(--dk-accent); font-weight: 600; font-size: 1.15em; }

  svg { flex: 1 1 0; min-height: 0; width: 100%; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .pt { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; }
  .tourne .pt {
    animation: pop 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) backwards;
    animation-delay: calc(var(--p) * 130ms + 500ms + var(--i) * 45ms);
  }
  .droite {
    fill: none;
    stroke: var(--dk-accent);
    stroke-width: 5;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    transition: stroke-dashoffset 0.9s ease-in-out;
    transition-delay: calc(var(--p) * 160ms);
  }
  .droite.vu { stroke-dashoffset: 0; }

  .legende { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: center; }

  @keyframes entre { from { opacity: 0; transform: translateY(0.7em) scale(0.9); } }
  @keyframes pop { from { transform: scale(0); } }

  @media (prefers-reduced-motion: reduce) {
    .carte, .stat, .pt, .droite { animation: none !important; transition: none !important; }
  }
</style>
