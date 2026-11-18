<script>
  /**
   * Dessiner un GOA : chaque phrase de la littérature devient une flèche.
   * L'exemple d'Arel-Bundock (2021, p. 116) : l'éducation et l'idéologie
   * politique, et quatre résultats d'études antérieures.
   *
   *   0  la question seule : éducation → idéologie, une flèche pointillée
   *      et un « ? »;
   *   1 à 4  une phrase s'allume à gauche, sa flèche se trace à droite (en
   *      rouge, le temps qu'elle arrive), les boîtes nécessaires
   *      apparaissent. Les phrases déjà tracées pâlissent : elles sont
   *      devenues des flèches.
   *
   * Schéma, aucune donnée.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const PHRASES = [
    'L’éducation augmente le revenu.',
    'Le revenu augmente l’appui aux partis qui promettent des baisses d’impôt.',
    'Le revenu des parents augmente l’éducation des enfants.',
    'Le revenu des parents augmente le revenu des enfants.'
  ];
  // Les boîtes : centre, largeur, deux lignes au plus.
  const N = {
    parents: { x: 170, y: 90, w: 250, l: ['Revenu', 'des parents'], des: 3 },
    revenu: { x: 640, y: 90, w: 230, l: ['Revenu', 'individuel'], des: 1 },
    educ: { x: 170, y: 400, w: 230, l: ['Éducation'], des: 0 },
    ideo: { x: 1000, y: 400, w: 230, l: ['Idéologie', 'politique'], des: 0 }
  };
  const H = 100;
  // Une flèche par phrase, de bord à bord.
  const FL = [
    { d: 'M 260 352 L 560 150', tete: [560, 150, 260, 352] },
    { d: 'M 730 150 L 920 345', tete: [920, 345, 730, 150] },
    { d: 'M 170 148 L 170 335', tete: [170, 335, 170, 148] },
    { d: 'M 302 90 L 510 90', tete: [510, 90, 302, 90] }
  ];
  const tete = ([bx, by, ax, ay]) => {
    const L = Math.hypot(bx - ax, by - ay), ux = (bx - ax) / L, uy = (by - ay) / L;
    return `${bx + ux * 14},${by + uy * 14} ${bx - ux * 10 - uy * 12},${by - uy * 10 + ux * 12} ${bx - ux * 10 + uy * 12},${by - uy * 10 - ux * 12}`;
  };
</script>

<div class="visuel m11h" bind:this={hote}>
  <ol class="phrases">
    {#each PHRASES as p, i (i)}
      <li class:active={e === i + 1} class:faite={e > i + 1}><span class="n">{i + 1}</span>{p}</li>
    {/each}
  </ol>
  <svg viewBox="0 0 1140 470" role="img" aria-label="Le GOA de l’éducation et de l’idéologie, une flèche par phrase : l’éducation cause le revenu, le revenu cause l’idéologie, le revenu des parents cause l’éducation et le revenu individuel.">
    <!-- la question -->
    <path d="M 290 400 L 870 400" class="question" />
    <polygon points={tete([880, 400, 290, 400])} class="pt-q" />
    <text x="580" y="388" class="q">?</text>

    {#each FL as f, i (i)}
      <g class="fl" class:vu={e >= i + 1} class:neuve={e === i + 1}>
        <path d={f.d} pathLength="1" class="trait" />
        <polygon points={tete(f.tete)} class="pointe" />
      </g>
    {/each}

    {#each Object.entries(N) as [id, n] (id)}
      <g class="boite" class:vu={e >= n.des}>
        <rect x={n.x - n.w / 2} y={n.y - H / 2 + (n.l.length === 1 ? 20 : 0)} width={n.w} height={n.l.length === 1 ? 60 : H} />
        {#each n.l as l, k (k)}<text x={n.x} y={n.y + (n.l.length === 1 ? 11 : k * 36 - 6)}>{l}</text>{/each}
      </g>
    {/each}
  </svg>
</div>

<style>
  .m11h { width: 100%; display: grid; grid-template-columns: minmax(0, 0.8fr) minmax(0, 1.2fr); gap: 2em; align-items: center; margin-top: 0.6em; }
  .phrases { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.6em; }
  .phrases li { display: grid; grid-template-columns: 1.6em 1fr; gap: 0.4em; padding: 0.5em 0.7em; border: 3px solid var(--dk-filet); font-size: 0.85em; line-height: 1.35; transition: border-color 0.3s, opacity 0.3s; }
  .phrases .n { font-weight: 700; color: var(--dk-accent); }
  .phrases li.active { border-color: var(--dk-accent); font-weight: 700; }
  .phrases li.faite { opacity: 0.4; }
  svg { width: 100%; height: auto; max-height: 56vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .question { stroke: var(--dk-gris-2); stroke-width: 5; stroke-dasharray: 14 10; }
  .pt-q { fill: var(--dk-gris-2); }
  .q { font-size: 44px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .boite { opacity: 0; transition: opacity 0.4s 0.5s; }
  .boite.vu { opacity: 1; }
  .boite rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .boite text { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .fl .trait { fill: none; stroke: var(--dk-encre); stroke-width: 6; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .fl .pointe { fill: var(--dk-encre); opacity: 0; }
  .fl.vu .trait { stroke-dashoffset: 0; transition: stroke-dashoffset 0.9s ease-out 0.5s, stroke 0.6s; }
  .fl.vu .pointe { opacity: 1; transition: opacity 0.2s 1.3s; }
  .fl.neuve .trait { stroke: var(--dk-accent); }
  .fl.neuve .pointe { fill: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .fl .trait, .fl .pointe, .boite, .phrases li { transition: none; } }
</style>
