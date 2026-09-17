<script>
  /**
   * Qu'est-ce qui décide qu'une chose est scientifique : le sujet qu'on
   * étudie, ou la façon dont on l'étudie ? La méthode. Trois temps.
   *
   *   0  Cinq sujets, chacun dans sa tuile, sans lien entre eux : une
   *      étoile, une cellule, une élection, une guerre, un marché.
   *      Pictogrammes schématiques, aucune donnée.
   *   1  Les cinq tuiles se déversent dans une même boîte : LA MÉTHODE.
   *      Les cinq chemins se tracent en décalé.
   *   2  Ce qu'il y a dans la boîte : les quatre caractéristiques de la
   *      recherche scientifique selon King, Keohane et Verba (1994), déjà
   *      vues plus tôt dans la séance. Rappel, donc : quatre mots, pas plus.
   *      La figure s'arrête là.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie (viewBox 1000 × 460). Cinq tuiles de 150, écartées de 30.
  const CENTRES = [140, 320, 500, 680, 860];
  const HAUT = 16, TUILE_H = 140, BAS = HAUT + TUILE_H; // 156
  const GLYPHE = 68; // hauteur du pictogramme dans la tuile
  const BOITE_Y = 252, BOITE_H = 66;

  const SUJETS = ['une étoile', 'une cellule', 'une élection', 'une guerre', 'un marché'];

  // Les quatre caractéristiques, en rappel. Deux colonnes, deux rangées.
  const TRAITS = [
    { t: 'une inférence', x: 150, y: 372 },
    { t: 'des procédures publiques', x: 520, y: 372 },
    { t: 'une incertitude déclarée', x: 150, y: 424 },
    { t: 'des règles explicites', x: 520, y: 424 }
  ];

  // Le chemin d'une tuile vers la boîte : une courbe qui se resserre.
  const chemin = (cx, i) => {
    const bx = 500 + (i - 2) * 16;
    return `M ${cx} ${BAS} C ${cx} ${BAS + 52}, ${bx} ${BOITE_Y - 52}, ${bx} ${BOITE_Y}`;
  };
</script>

<div class="visuel pe-fig" bind:this={hote}>
  <svg
    viewBox="0 0 1000 460"
    role="img"
    aria-label="Cinq sujets très différents, une étoile, une cellule, une élection, une guerre et un marché, se déversent dans une même boîte appelée la méthode. Cette boîte contient une inférence, des procédures publiques, une incertitude déclarée et des règles explicites. C’est la méthode, et non le sujet, qui décide qu’une recherche est scientifique."
  >
    <!-- Les cinq chemins, tracés en décalé, sous les tuiles. -->
    {#each CENTRES as cx, i}
      <path d={chemin(cx, i)} pathLength="1" class="pe-chemin" class:pe-vu={e >= 1} style="--k: {i}" />
    {/each}

    <!-- Les cinq sujets. -->
    {#each CENTRES as cx, i}
      {@const cy = HAUT + GLYPHE}
      <g class="pe-tuile" style="--k: {i}">
        <rect x={cx - 75} y={HAUT} width="150" height={TUILE_H} class="pe-cadre" />

        {#if i === 0}
          <!-- Une étoile : un éclat. -->
          <path d="M {cx - 34} {cy} L {cx + 34} {cy} M {cx} {cy - 34} L {cx} {cy + 34}" class="pe-trait" />
          <path d="M {cx - 23} {cy - 23} L {cx + 23} {cy + 23} M {cx + 23} {cy - 23} L {cx - 23} {cy + 23}" class="pe-trait pe-fin" />
          <circle cx={cx} cy={cy} r="8" class="pe-plein" />
        {:else if i === 1}
          <!-- Une cellule : une membrane, un noyau. -->
          <circle cx={cx} cy={cy} r="30" class="pe-trait" />
          <circle cx={cx + 7} cy={cy - 5} r="9" class="pe-plein" />
        {:else if i === 2}
          <!-- Une élection : un bulletin, une urne. -->
          <path d="M {cx - 12} {cy - 42} L {cx + 11} {cy - 36} L {cx + 7} {cy - 18} L {cx - 16} {cy - 24} Z" class="pe-trait pe-fin" />
          <rect x={cx - 32} y={cy - 14} width="64" height="46" class="pe-trait" />
          <path d="M {cx - 17} {cy - 14} L {cx + 17} {cy - 14}" class="pe-trait pe-epais" />
        {:else if i === 3}
          <!-- Une guerre : un char. Chenille et ses roues, caisse, tourelle, canon. -->
          <path d="M {cx - 42} {cy} L {cx + 34} {cy} L {cx + 24} {cy + 22} L {cx - 32} {cy + 22} Z" class="pe-trait" />
          <path d="M {cx - 36} {cy} L {cx - 28} {cy - 16} L {cx + 22} {cy - 16} L {cx + 30} {cy}" class="pe-trait" />
          <rect x={cx - 20} y={cy - 34} width="30" height="18" class="pe-trait" />
          <path d="M {cx + 10} {cy - 26} L {cx + 44} {cy - 26}" class="pe-trait pe-epais" />
          {#each [-25, -11, 3, 17] as dx}
            <circle cx={cx + dx} cy={cy + 11} r="5" class="pe-plein" />
          {/each}
        {:else}
          <!-- Un marché : une ligne de prix. -->
          <path d="M {cx - 36} {cy + 24} L {cx - 17} {cy - 2} L {cx - 1} {cy + 12} L {cx + 15} {cy - 20} L {cx + 34} {cy - 28}" class="pe-trait" />
          <path d="M {cx + 22} {cy - 26} L {cx + 34} {cy - 28} L {cx + 31} {cy - 16}" class="pe-trait pe-fin" />
        {/if}

        <text x={cx} y={HAUT + 124} class="pe-sujet">{SUJETS[i]}</text>
      </g>
    {/each}

    <!-- La méthode, où tout se déverse. -->
    <g class="pe-boite" class:pe-vu={e >= 1}>
      <rect x="250" y={BOITE_Y} width="500" height={BOITE_H} class="pe-boite-c" />
      <text x="500" y={BOITE_Y + 44} class="pe-boite-t">LA MÉTHODE</text>
    </g>

    <!-- Ce qu'il y a dedans : le rappel des quatre traits. -->
    {#each TRAITS as t, i}
      <g class="pe-trait-g" class:pe-vu={e >= 2} style="--k: {i}">
        <rect x={t.x} y={t.y - 11} width="12" height="12" class="pe-puce" />
        <text x={t.x + 26} y={t.y} class="pe-trait-t">{t.t}</text>
      </g>
    {/each}
  </svg>
</div>

<style>
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .pe-tuile { animation: pe-pose 0.5s cubic-bezier(0.34, 1.5, 0.64, 1) both; animation-delay: calc(var(--k) * 110ms + 150ms); }
  .pe-cadre { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .pe-trait { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .pe-trait.pe-fin { stroke-width: 3; }
  .pe-trait.pe-epais { stroke-width: 6; }
  .pe-plein { fill: var(--dk-encre); }
  .pe-sujet { font-size: 17px; text-anchor: middle; fill: var(--dk-encre); }

  .pe-chemin {
    fill: none;
    stroke: var(--dk-accent);
    stroke-width: 4;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    transition: stroke-dashoffset 0.7s ease-out;
    transition-delay: calc(var(--k) * 130ms);
  }
  .pe-chemin.pe-vu { stroke-dashoffset: 0; }

  .pe-boite { opacity: 0; transition: opacity 0.3s 0.5s; }
  .pe-boite.pe-vu { opacity: 1; }
  .pe-boite-c {
    fill: var(--dk-fond);
    stroke: var(--dk-encre);
    stroke-width: 5;
    transform-box: fill-box;
    transform-origin: center;
    transform: scaleX(0.7);
    transition: transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1) 0.5s;
  }
  .pe-boite.pe-vu .pe-boite-c { transform: none; }
  .pe-boite-t {
    font-size: 32px;
    font-weight: 600;
    letter-spacing: 0.1em;
    text-anchor: middle;
    fill: var(--dk-encre);
  }

  .pe-trait-g { opacity: 0; transition: opacity 0.35s, transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1); transform: translateY(10px); transition-delay: calc(var(--k) * 120ms); }
  .pe-trait-g.pe-vu { opacity: 1; transform: none; }
  .pe-puce { fill: var(--dk-accent); }
  .pe-trait-t { font-size: 20px; fill: var(--dk-encre); }

  @keyframes pe-pose { from { opacity: 0; transform: translateY(-26px); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pe-tuile { animation: none; }
    .pe-chemin, .pe-boite, .pe-boite-c, .pe-trait-g { transition: none; }
  }
</style>
