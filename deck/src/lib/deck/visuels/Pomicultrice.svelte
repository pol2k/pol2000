<script>
  /**
   * La pomicultrice : l'exemple fictif d'Arel-Bundock (2021, p. 62). Un
   * verger, un échantillon, deux nombres, une question. Quatre temps.
   *
   *   0  Le verger, en schéma : des rangées de pommes grises qui pâlissent à
   *      droite (il y en a bien plus). La règle de l'acheteur : un poids
   *      moyen de plus de POMMES.h0 grammes.
   *   1  POMMES.n pommes, choisies au hasard (un mélange de Fisher-Yates mené
   *      par un petit générateur congruentiel à graine fixe, pas Math.random),
   *      rougissent et vont dans le panier. Leur place dans le verger reste
   *      vide.
   *   2  Les deux nombres de l'échantillon : POMMES.moyenne et
   *      POMMES.ecartType (la racine de la variance, 300, du livre).
   *   3  La question : ces grammes de plus suffisent-ils pour conclure ?
   *
   * Tous les nombres viennent de POMMES (src/lib/data/seance5.js).
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');

  // Le verger : 20 colonnes, 11 rangées. Les trois dernières colonnes pâlissent.
  const NC = 20, NR = 11, PAS = 23, OX = 44, OY = 76;
  const PALE = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.55, 0.3, 0.12];
  const VERGER = Array.from({ length: NC * NR }, (_, i) => ({ c: i % NC, r: Math.floor(i / NC) })).map((p) => ({
    ...p, x: OX + p.c * PAS, y: OY + p.r * PAS, o: PALE[p.c]
  }));

  // Le tirage : un mélange de Fisher-Yates sur les pommes bien visibles.
  let graine = 20210062;
  const alea = () => ((graine = (Math.imul(graine, 1664525) + 1013904223) >>> 0) / 4294967296);
  const candidates = VERGER.map((p, i) => i).filter((i) => VERGER[i].o === 1);
  for (let i = candidates.length - 1; i > 0; i--) {
    const j = Math.floor(alea() * (i + 1));
    [candidates[i], candidates[j]] = [candidates[j], candidates[i]];
  }
  const CHOISIES = candidates.slice(0, POMMES.n).sort((a, b) => a - b);
  const PRISE = new Set(CHOISIES);

  // Le panier : dix pommes par rangée, rempli par le fond.
  const PX = 666, PY = 246, PP = 25, PR = 24;
  const DANS_PANIER = CHOISIES.map((i, k) => ({
    ox: VERGER[i].x, oy: VERGER[i].y,
    bx: PX + (k % 10) * PP, by: PY - Math.floor(k / 10) * PR, k
  }));
  const RANGS_PANIER = Math.ceil(POMMES.n / 10);
  const HAUT_PANIER = PY - (RANGS_PANIER - 1) * PR - 24;
</script>

<div class="visuel pomicultrice" bind:this={hote}>
  <svg viewBox="0 0 1000 465" role="img" aria-label="Exemple fictif. Un verger de centaines de milliers de pommes. L’acheteur exige un poids moyen de plus de {POMMES.h0} g. La pomicultrice tire au hasard {POMMES.n} pommes. Leur moyenne est de {POMMES.moyenne} g, leur écart type de {fr(POMMES.ecartType, 1)} g. Est-ce assez pour conclure que la vraie moyenne dépasse {POMMES.h0} g&#8239;?">
    <text x={OX} y="40" class="pom-verger-t">des centaines de milliers de pommes</text>
    <text x="990" y="22" class="pom-src">Exemple fictif · Arel-Bundock (2021, p. 62)</text>

    <!-- Le verger. -->
    {#each VERGER as p, i}
      <circle cx={p.x} cy={p.y} r="8" class="pom-pomme" class:pom-vide={e >= 1 && PRISE.has(i)} style="opacity: {p.o}; animation-delay: {p.c * 25 + p.r * 15}ms" />
    {/each}

    <!-- Le panier. -->
    <path d="M 622 {HAUT_PANIER} L 642 {PY + 20} L 916 {PY + 20} L 936 {HAUT_PANIER}" class="pom-panier" />
    <line x1="608" y1={HAUT_PANIER} x2="950" y2={HAUT_PANIER} class="pom-panier" />

    <!-- Temps 1 : les pommes choisies rougissent et vont au panier. -->
    {#each DANS_PANIER as q}
      <circle cx="0" cy="0" r="8" class="pom-rouge" class:pom-vu={e >= 1}
        style="transform: translate({e >= 1 ? q.bx : q.ox}px, {e >= 1 ? q.by : q.oy}px); transition-delay: {e >= 1 ? `0s, ${300 + q.k * 8}ms` : '0s, 0s'}" />
    {/each}
    <g class="pom-etape" class:pom-vu={e >= 1}>
      <text x="779" y="306" class="pom-lab">un échantillon aléatoire</text>
      <text x="779" y="334" class="pom-lab">de {POMMES.n} pommes</text>
    </g>

    <!-- La règle de l'acheteur. -->
    <text x={OX} y="366" class="pom-regle">l’acheteur exige un poids moyen</text>
    <text x={OX} y="396" class="pom-regle">de plus de <tspan class="pom-gras">{POMMES.h0} g</tspan></text>

    <!-- Temps 2 : les deux nombres. -->
    <g class="pom-etape" class:pom-vu={e >= 2}>
      <text x="622" y="384" class="pom-nombre">moyenne&#8239;: {POMMES.moyenne} g</text>
      <text x="622" y="422" class="pom-nombre">écart type&#8239;: {fr(POMMES.ecartType, 1)} g</text>
    </g>

    <!-- Temps 3 : la question. -->
    <text x={OX} y="455" class="pom-question pom-etape" class:pom-vu={e >= 3}>{POMMES.moyenne} g&#8239;: assez pour conclure que la vraie moyenne dépasse {POMMES.h0} g&#8239;?</text>
  </svg>
</div>

<style>
  .pomicultrice { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .pom-verger-t { font-size: 22px; fill: var(--dk-encre); }
  .pom-src { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .pom-pomme { fill: var(--dk-gris-2); stroke: var(--dk-gris-2); stroke-width: 2; transform-box: fill-box; transform-origin: center; animation: pom-pop 0.4s ease-out both; transition: fill 0.3s, stroke 0.3s; }
  .pom-pomme.pom-vide { fill: var(--dk-fond); stroke: var(--dk-filet); }
  @keyframes pom-pop { from { transform: scale(0); } to { transform: scale(1); } }
  .pom-panier { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .pom-rouge { fill: var(--dk-accent); opacity: 0; transition: opacity 0.3s, transform 0.7s cubic-bezier(0.45, 0, 0.2, 1); }
  .pom-rouge.pom-vu { opacity: 1; }
  .pom-lab { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .pom-regle { font-size: 22px; fill: var(--dk-encre); }
  .pom-gras { font-weight: 600; }
  .pom-nombre { font-size: 30px; font-weight: 600; fill: var(--dk-encre); }
  .pom-question { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .pom-etape { opacity: 0; transition: opacity 0.3s; }
  .pom-etape.pom-vu { opacity: 1; transition: opacity 0.5s 0.3s; }

  @media (prefers-reduced-motion: reduce) {
    .pom-pomme { animation: none; }
    .pom-pomme, .pom-rouge, .pom-etape, .pom-etape.pom-vu { transition: none; }
  }
</style>
