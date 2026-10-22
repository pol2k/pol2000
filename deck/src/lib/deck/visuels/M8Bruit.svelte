<script>
  /**
   * Sortir une variable du bruit, et la mettre dans le modèle. Schéma, aucune
   * donnée. La suite du graphe de la diapo précédente (GrapheEpsilon) : les
   * mêmes boîtes, le même nuage pointillé, les mêmes mots.
   *
   *   0  le modèle ne contient que la scolarité, qui pointe vers l'intérêt.
   *      Tout le reste (le genre, l'âge, le revenu, la région…) est dans le
   *      bruit, un nuage qui pointe lui aussi vers l'intérêt;
   *   1  le genre sort du nuage et entre dans le modèle : il prend une boîte
   *      et sa propre flèche. Le nuage rapetisse (diapo suivante : M8Paralleles);
   *   2  l'âge fait de même (diapo d'après : M8Pente).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le modèle (à gauche), l'intérêt (à droite), le bruit (en bas à droite).
  const CAD = { x: 20, y: 44, w: 380, h: 336 };
  const SLOT = [112, 212, 312]; // centres des trois places du modèle
  const BW = 300, BH = 72, BXC = 210;
  const Y = { cx: 830, cy: 212, w: 250, h: 96 };

  function fleche(ax, ay, bx, by, pointe = 20) {
    const dx = bx - ax, dy = by - ay, L = Math.hypot(dx, dy);
    const ux = dx / L, uy = dy / L;
    const px = bx - ux * pointe, py = by - uy * pointe;
    const nx = -uy * pointe * 0.5, ny = ux * pointe * 0.5;
    return { d: `M ${ax} ${ay} L ${px} ${py}`, tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}` };
  }
  const FL = SLOT.map((cy, i) => fleche(BXC + BW / 2 + 6, cy, Y.cx - Y.w / 2 - 6, Y.cy + (i - 1) * 26));
  const FB = fleche(830, 346, 830, Y.cy + Y.h / 2 + 6);

  // Ceux qui sortent du nuage : leur place dans le nuage, leur place dans le modèle.
  const MOBILES = [
    { nom: 'le sexe', de: { x: 528, y: 398 }, vers: { x: BXC, y: SLOT[1] }, entre: 1 },
    { nom: 'l’âge', de: { x: 600, y: 444 }, vers: { x: BXC, y: SLOT[2] }, entre: 2 }
  ];
  const RESTE = [
    { nom: 'le revenu', x: 752, y: 400 },
    { nom: 'la région', x: 846, y: 448 },
    { nom: '…', x: 930, y: 400 }
  ];
  // Le nuage rapetisse à chaque sortie (son bord droit ne bouge pas).
  const NUAGE = [
    { cx: 700, rx: 290, ry: 82 },
    { cx: 742, rx: 248, ry: 76 },
    { cx: 815, rx: 172, ry: 64 }
  ];
  const nu = $derived(NUAGE[e]);
</script>

<div class="visuel m8b" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Schéma. Le modèle ne contient que la scolarité, qui pointe vers l'intérêt pour la politique. Tout le reste, le sexe, l'âge, le revenu, la région, est dans le bruit. Le sexe, puis l'âge, sortent du bruit et entrent dans le modèle, chacun avec sa flèche. Le bruit rapetisse.">
    <!-- Le modèle -->
    <rect x={CAD.x} y={CAD.y} width={CAD.w} height={CAD.h} class="b-cadre" />
    <text x={CAD.x} y={CAD.y - 14} class="b-titre">le modèle</text>

    <!-- Le bruit -->
    <ellipse cy="410" style="cx: {nu.cx}px; rx: {nu.rx}px; ry: {nu.ry}px" class="b-nuage" />
    <text x="990" y={410 - NUAGE[0].ry - 14} class="b-titre b-gris b-fin">le bruit</text>
    <path d={FB.d} class="b-fl b-fl-gris" />
    <polygon points={FB.tete} class="b-tete-gris" />
    {#each RESTE as r}
      <text x={r.x} y={r.y + 8} class="b-mot">{r.nom}</text>
    {/each}

    <!-- L'intérêt -->
    <rect x={Y.cx - Y.w / 2} y={Y.cy - Y.h / 2} width={Y.w} height={Y.h} class="b-boite b-y" />
    <text x={Y.cx} y={Y.cy + 11} class="b-nom">intérêt</text>

    <!-- La scolarité, dans le modèle depuis le début -->
    <rect x={BXC - BW / 2} y={SLOT[0] - BH / 2} width={BW} height={BH} class="b-boite" />
    <text x={BXC} y={SLOT[0] + 10} class="b-nom">scolarité</text>
    <path d={FL[0].d} class="b-fl" />
    <polygon points={FL[0].tete} class="b-tete" />

    <!-- Les places libres du modèle -->
    {#each [1, 2] as i}
      <rect x={BXC - BW / 2} y={SLOT[i] - BH / 2} width={BW} height={BH} class="b-libre" class:b-cache={e >= i} />
    {/each}

    <!-- Ce qui sort du bruit -->
    {#each MOBILES as m, i}
      {@const dedans = e >= m.entre}
      {@const neuf = e === m.entre}
      {@const p = dedans ? m.vers : m.de}
      <path d={FL[i + 1].d} pathLength="1" class="b-fl b-trace" class:b-vu={dedans} class:b-rouge={neuf} />
      <polygon points={FL[i + 1].tete} class="b-tete b-pointe" class:b-vu={dedans} class:b-rouge-t={neuf} />
      <g class="b-mobile" style="transform: translate({p.x}px, {p.y}px)">
        <rect x={-BW / 2} y={-BH / 2} width={BW} height={BH} class="b-boite b-sienne" class:b-vu={dedans} class:b-rouge={neuf} />
        <text y={dedans ? 10 : 8} class="b-mot b-mot-m" class:b-entre={dedans} class:b-rouge-x={neuf}>{m.nom}</text>
      </g>
    {/each}

    <text x="0" y="484" class="b-cap">schéma</text>
  </svg>
</div>

<style>
  .m8b { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .b-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .b-titre { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .b-gris { fill: var(--dk-gris); }
  .b-fin { text-anchor: end; }

  .b-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .b-y { stroke-width: 4; }
  .b-nom { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .b-libre { fill: none; stroke: var(--dk-filet); stroke-width: 2; stroke-dasharray: 6 6; transition: opacity 0.3s; }
  .b-libre.b-cache { opacity: 0; }

  .b-nuage { fill: var(--dk-fond-2); stroke: var(--dk-gris); stroke-width: 2.5; stroke-dasharray: 10 8; transition: cx 0.9s ease-in-out, rx 0.9s ease-in-out, ry 0.9s ease-in-out; }
  .b-mot { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }

  .b-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .b-tete { fill: var(--dk-encre); }
  .b-fl-gris { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 7; }
  .b-tete-gris { fill: var(--dk-gris-2); }

  /* Le mot voyage, puis prend sa boîte, puis sa flèche se trace. */
  .b-mobile { transition: transform 0.9s ease-in-out; }
  .b-mot-m { transition: font-size 0.5s 0.4s, fill 0.4s; }
  .b-mot-m.b-entre { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }
  .b-mot-m.b-rouge-x { fill: var(--dk-accent); }
  .b-sienne { opacity: 0; transition: opacity 0.3s, stroke 0.4s; }
  .b-sienne.b-vu { opacity: 1; transition: opacity 0.4s 0.6s, stroke 0.4s; }
  .b-boite.b-rouge { stroke: var(--dk-accent); }
  .b-trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.2s, stroke 0.4s; }
  .b-trace.b-vu { stroke-dashoffset: 0; transition: stroke-dashoffset 0.6s 0.9s ease-out, stroke 0.4s; }
  .b-fl.b-rouge { stroke: var(--dk-accent); }
  .b-pointe { opacity: 0; transition: opacity 0.2s, fill 0.4s; }
  .b-pointe.b-vu { opacity: 1; transition: opacity 0.2s 1.4s, fill 0.4s; }
  .b-tete.b-rouge-t { fill: var(--dk-accent); }

  .b-cap { font-size: 18px; fill: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .b-nuage, .b-mobile, .b-mot-m, .b-sienne, .b-sienne.b-vu, .b-trace, .b-trace.b-vu, .b-pointe, .b-pointe.b-vu, .b-libre { transition: none; }
  }
</style>
