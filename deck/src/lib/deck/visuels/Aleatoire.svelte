<script>
  /**
   * Au hasard, ou pas : ce qui fait un échantillon aléatoire simple
   * (Arel-Bundock 2021, p. 62), tout le monde a la même chance d'être
   * tiré. Un schéma, sans données : une population de 24 sur 10 carrés.
   *
   *   0  La population, toute en encre.
   *   1  Vingt-quatre carrés passent au rouge, un par colonne, à une rangée
   *      choisie par un petit générateur pseudo-aléatoire à graine fixe
   *      (pas de Math.random) : ils sont semés partout.
   *   2  Ils redeviennent noirs; à la place, un bloc de 6 sur 4 dans un coin
   *      passe au rouge, encadré : « les plus faciles à joindre ». Même
   *      nombre de personnes, un seul coin de la population.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const COLS = 24, RANGS = 10, PAS = 32, COTE = 26;
  const GX = (1000 - ((COLS - 1) * PAS + COTE)) / 2, GY = 70;
  const CARRES = Array.from({ length: COLS * RANGS }, (_, i) => ({ r: Math.floor(i / COLS), c: i % COLS }));

  // Au hasard : une personne par colonne, la rangée tirée par un générateur à graine fixe.
  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(2306);
  const RANGEE = Array.from({ length: COLS }, () => Math.floor(alea() * RANGS));
  const auHasard = (q) => RANGEE[q.c] === q.r;

  // Pas au hasard : le coin en haut à gauche, 6 colonnes sur 4 rangées (24 aussi).
  const CC = 6, CR = 4;
  const dansLeCoin = (q) => q.c < CC && q.r < CR;
  const COIN = { x: GX - 7, y: GY - 7, w: (CC - 1) * PAS + COTE + 14, h: (CR - 1) * PAS + COTE + 14 };
</script>

<div class="visuel aleatoire" bind:this={hote}>
  <svg viewBox="0 0 1000 450" role="img" aria-label="Une population de 240 carrés. Au hasard : 24 carrés semés partout, tout le monde a la même chance d’être tiré. Pas au hasard : 24 carrés tassés dans un coin, les plus faciles à joindre.">
    <text x="980" y="22" class="al-note">schéma</text>

    {#each CARRES as q}
      {@const rouge = (e === 1 && auHasard(q)) || (e === 2 && dansLeCoin(q))}
      <rect x={GX + q.c * PAS} y={GY + q.r * PAS} width={COTE} height={COTE}
            class="al-carre" class:al-rouge={rouge}
            style="animation-delay: {q.r * 30 + q.c * 5}ms; transition-delay: {rouge ? (e === 1 ? q.c * 25 : (q.r * CC + q.c) * 20) : 0}ms" />
    {/each}

    <!-- Le coin. -->
    <g class="al-coin" class:al-vu={e === 2}>
      <rect x={COIN.x} y={COIN.y} width={COIN.w} height={COIN.h} class="al-cadre" />
      <text x={COIN.x} y={COIN.y - 14} class="al-etiq">les plus faciles à joindre</text>
    </g>

    <!-- Les deux légendes, au même endroit. -->
    <text x="500" y="432" class="al-leg" class:al-vu={e === 1}><tspan class="al-fort">au hasard</tspan>&#8239;: tout le monde a la même chance d’être tiré</text>
    <text x="500" y="432" class="al-leg" class:al-vu={e === 2}><tspan class="al-fort">pas au hasard</tspan>&#8239;: un seul coin de la population</text>
  </svg>
</div>

<style>
  .aleatoire { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .al-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  .al-carre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; transition: fill 0.35s; animation: al-pop 0.35s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  .al-carre.al-rouge { fill: var(--dk-accent); }

  .al-coin { opacity: 0; transition: opacity 0.2s; }
  .al-coin.al-vu { opacity: 1; transition: opacity 0.4s 0.5s; }
  .al-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .al-etiq { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }

  .al-leg { font-size: 24px; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .al-leg.al-vu { opacity: 1; transition: opacity 0.4s 0.6s; }
  .al-fort { font-weight: 600; }

  @keyframes al-pop { from { transform: scale(0); } to { transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .al-carre { animation: none; transition: none; }
    .al-coin, .al-coin.al-vu, .al-leg, .al-leg.al-vu { transition: none; }
  }
</style>
