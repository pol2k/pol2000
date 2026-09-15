<script>
  /**
   * L'écart type, comme une distance typique à la moyenne. Aucune formule :
   * on montre des distances, on les range, on en retient une longueur.
   *
   * En haut, un schéma : dix valeurs fictives dont la moyenne vaut 50.
   *   0  Les dix points et la moyenne, en rouge.
   *   1  Une flèche se trace de la moyenne jusqu'à chaque point.
   *   2  Les flèches se détachent et s'alignent à gauche, triées, comme des
   *      barres ; un repère rouge se pose à leur longueur typique (celle que
   *      sd() de R donnerait pour ces dix valeurs).
   * En bas, la vraie variable :
   *   3  L'âge de l'Étude électorale canadienne 2025 : une bande d'un écart
   *      type de chaque côté de la moyenne s'ouvre depuis le centre
   *      (src/lib/data/seance3.js).
   */
  import { brancherTemps } from '../temps.js';
  import { AGE } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const VALEURS = [22, 34, 40, 45, 48, 52, 55, 60, 66, 78];
  const N = VALEURS.length;
  const MOY = VALEURS.reduce((s, v) => s + v, 0) / N;
  const ET = Math.sqrt(VALEURS.reduce((s, v) => s + (v - MOY) ** 2, 0) / (N - 1));

  // Le schéma : 0 à 100 sur la largeur.
  const K = 8.4;
  const x = (v) => 80 + v * K;
  const ORIGINE = 80;
  const rangee = (i) => 50 + i * 9;
  const PILE = 222;
  // Rang de chaque flèche dans la pile : de la plus courte à la plus longue.
  const ordre = VALEURS.map((v, i) => i).sort((a, b) => Math.abs(VALEURS[a] - MOY) - Math.abs(VALEURS[b] - MOY));
  const rang = VALEURS.map((_, i) => ordre.indexOf(i));
  const XMARQUE = ORIGINE + ET * K;
  const XLONG = ORIGINE + Math.max(...VALEURS.map((v) => Math.abs(v - MOY))) * K;

  // La vraie variable : l'âge, de 15 à 100 ans.
  const X = (v) => 80 + ((v - 15) / 85) * 840;
  const f1 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
  const DEMI = X(AGE.moyenne + AGE.et) - X(AGE.moyenne);
</script>

<div class="visuel ecart-type" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Dix valeurs fictives autour d'une moyenne de 50 : des flèches mesurent la distance de chacune à la moyenne, puis se rangent ; l'écart type est leur longueur typique. En bas, l'âge de l'Étude électorale canadienne 2025 : moyenne de 49,7 ans, écart type de 17,5 ans.">
    <text x="920" y="26" class="note">schéma</text>

    <!-- Le schéma : axe, moyenne, points. -->
    <line x1={x(0)} y1="160" x2={x(100)} y2="160" class="axe" />
    {#each [0, 50, 100] as t}
      <line x1={x(t)} y1="160" x2={x(t)} y2="167" class="axe" />
      <text x={x(t)} y="186" class="tick">{t}</text>
    {/each}
    <line x1={x(MOY)} y1="36" x2={x(MOY)} y2="160" class="moy" />
    <text x={x(MOY)} y="26" class="moy-t">moyenne · {MOY}</text>

    {#each VALEURS as v, i}
      <line x1={x(v)} y1={rangee(i)} x2={x(v)} y2="160" class="chute" class:vu={e === 1} />
      <circle cx={x(v)} cy="160" r="9" class="pt" style="--d: {i * 50}ms" />
    {/each}

    <!-- Les flèches : de la moyenne vers chaque point, puis rangées en pile. -->
    {#each VALEURS as v, i}
      {@const L = Math.abs(v - MOY) * K}
      {@const sens = v < MOY ? -1 : 1}
      <g class="fleche" class:vu={e >= 1} class:rangee={e >= 2}
         style="transform: {e >= 2 ? `translate(${ORIGINE}px, ${PILE + rang[i] * 9}px) scale(1, 1)` : `translate(${x(MOY)}px, ${rangee(i)}px) scale(${sens}, 1)`}; transition-delay: {e >= 2 ? rang[i] * 60 : 0}ms">
        <path d="M 0 0 H {L}" pathLength="1" class="trait" style="transition-delay: {e === 1 ? i * 70 : 0}ms" />
        <path d="M {L - 7} -5 L {L} 0 L {L - 7} 5" class="pointe" style="transition-delay: {e === 1 ? i * 70 + 350 : 0}ms" />
      </g>
    {/each}

    <g class="pile" class:vu={e >= 2}>
      <line x1={ORIGINE} y1={PILE - 8} x2={ORIGINE} y2={PILE + N * 9} class="zero" />
      <g class="marque" style="transform: translateX({e >= 2 ? XMARQUE - ORIGINE : 0}px)">
        <line x1={ORIGINE} y1={PILE - 14} x2={ORIGINE} y2={PILE + N * 9 + 6} />
      </g>
      <line x1={XMARQUE} y1={PILE + 45} x2={XLONG + 24} y2={PILE + 45} class="lien" />
      <text x={XLONG + 34} y={PILE + 51} class="et-t">écart type : la distance typique à la moyenne</text>
    </g>

    <!-- La vraie variable : l'âge. -->
    <g class="reel" class:vu={e >= 3}>
      <text x="80" y="356" class="titre-r">Âge · Étude électorale canadienne 2025</text>
      <g style="transform: translateX({X(AGE.moyenne)}px)">
        <rect x={-DEMI} y="405" width={DEMI * 2} height="40" class="bande" />
      </g>
      <line x1={X(AGE.moyenne)} y1="396" x2={X(AGE.moyenne)} y2="460" class="moy" />
      <text x={X(AGE.moyenne)} y="388" class="moy-t">moyenne · {f1(AGE.moyenne)} ans</text>
      <text x={X(AGE.moyenne) + DEMI + 12} y="431" class="pm">± {f1(AGE.et)} ans</text>
      <line x1={X(15)} y1="460" x2={X(100)} y2="460" class="axe" />
      {#each [20, 30, 40, 50, 60, 70, 80, 90, 100] as t}
        <line x1={X(t)} y1="460" x2={X(t)} y2="467" class="axe" />
        <text x={X(t)} y="486" class="tick">{t}</text>
      {/each}
    </g>
  </svg>
</div>

<style>
  .ecart-type { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .note { font-size: 14px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .moy { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .moy-t { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: pop 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  .chute { stroke: var(--dk-gris-2); stroke-width: 1.5; stroke-dasharray: 3 4; opacity: 0; transition: opacity 0.3s; }
  .chute.vu { opacity: 1; transition-delay: 0.6s; }

  .fleche { opacity: 0; transition: transform 0.8s cubic-bezier(0.34, 1.4, 0.64, 1), opacity 0.2s; }
  .fleche.vu { opacity: 1; }
  .fleche .trait { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.45s ease-out; }
  .fleche.vu .trait { stroke-dashoffset: 0; }
  .fleche .pointe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; opacity: 0; transition: opacity 0.2s; }
  .fleche.vu .pointe { opacity: 1; }

  .pile { opacity: 0; transition: opacity 0.3s; }
  .pile.vu { opacity: 1; }
  .zero { stroke: var(--dk-encre); stroke-width: 2.5; }
  .marque { transition: transform 0.9s cubic-bezier(0.34, 1.56, 0.64, 1) 0.8s; }
  .marque line { stroke: var(--dk-accent); stroke-width: 5; }
  .lien { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 5 5; opacity: 0; transition: opacity 0.3s 1.6s; }
  .et-t { font-size: 17px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 1.6s; }
  .pile.vu .lien, .pile.vu .et-t { opacity: 1; }

  .reel { opacity: 0; transition: opacity 0.3s; }
  .reel.vu { opacity: 1; }
  .titre-r { font-size: 16px; font-weight: 600; letter-spacing: 0.04em; fill: var(--dk-encre); }
  .bande { fill: var(--dk-accent); fill-opacity: 0.25; stroke: var(--dk-accent); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; transform: scaleX(0); transition: transform 0.9s cubic-bezier(0.34, 1.4, 0.64, 1) 0.2s; }
  .reel.vu .bande { transform: scaleX(1); }
  .pm { font-size: 18px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.9s; }
  .reel.vu .pm { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .pt { animation: none; }
    .fleche, .fleche .trait, .marque, .bande, .chute, .lien, .et-t, .pm { transition: none; }
  }
</style>
