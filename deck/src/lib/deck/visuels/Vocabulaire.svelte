<script>
  /**
   * Quatre mots, ceux d'Arel-Bundock (2021, p. 62-63) : la population,
   * l'échantillon, le paramètre, l'estimé. Un schéma, sans données.
   *
   *   0  À gauche, la population : une grille de 240 carrés.
   *   1  Vingt carrés, choisis une fois pour toutes par un petit générateur
   *      pseudo-aléatoire à graine fixe (pas de Math.random), passent au
   *      rouge; leurs copies glissent dans une petite boîte à droite :
   *      l'échantillon.
   *   2  Sous la population : le paramètre, la vraie valeur, qu'on ne
   *      connaît pas (un grand « ? »).
   *   3  Sous l'échantillon : l'estimé, ce qu'on calcule dans l'échantillon.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La population : 20 colonnes, 12 rangées.
  const COLS = 20, RANGS = 12, PAS = 22, COTE = 18, GX = 60, GY = 84;
  const N = COLS * RANGS;
  const CARRES = Array.from({ length: N }, (_, i) => ({ r: Math.floor(i / COLS), c: i % COLS }));

  // Vingt tirés sans remise : Fisher-Yates partiel, générateur congruentiel à graine fixe.
  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(1496);
  const idx = Array.from({ length: N }, (_, i) => i);
  for (let k = 0; k < 20; k++) {
    const j = k + Math.floor(alea() * (N - k));
    [idx[k], idx[j]] = [idx[j], idx[k]];
  }
  const TIRES = idx.slice(0, 20).sort((a, b) => a - b);
  const rangTire = new Map(TIRES.map((i, k) => [i, k]));

  // L'échantillon : une boîte de 5 sur 4, à droite.
  const BX = 600, BY = 84, MARGE = 16;
  const COPIES = TIRES.map((i, k) => {
    const q = CARRES[i];
    const x0 = GX + q.c * PAS, y0 = GY + q.r * PAS;
    const x1 = BX + MARGE + (k % 5) * PAS, y1 = BY + MARGE + Math.floor(k / 5) * PAS;
    return { x0, y0, dx: x1 - x0, dy: y1 - y0, k };
  });
  const BW = MARGE * 2 + 5 * PAS - (PAS - COTE);
  const BH = MARGE * 2 + 4 * PAS - (PAS - COTE);
  const YF = BY + BH / 2;
</script>

<div class="visuel vocabulaire" bind:this={hote}>
  <svg viewBox="0 0 1000 475" role="img" aria-label="Une population de 240 carrés. Vingt sont tirés et copiés dans une petite boîte : l’échantillon. Sous la population, le paramètre, la vraie valeur, inconnue. Sous l’échantillon, l’estimé, ce qu’on calcule dans l’échantillon.">
    <text x="980" y="22" class="vo-note">schéma</text>

    <!-- La population. -->
    <text x={GX} y="38" class="vo-titre">la population</text>
    <text x={GX} y="66" class="vo-sous">tout le monde qu’on veut décrire</text>
    {#each CARRES as q, i}
      <rect x={GX + q.c * PAS} y={GY + q.r * PAS} width={COTE} height={COTE}
            class="vo-carre" class:vo-rouge={e >= 1 && rangTire.has(i)}
            style="animation-delay: {q.r * 30 + q.c * 6}ms; transition-delay: {e >= 1 && rangTire.has(i) ? rangTire.get(i) * 30 : 0}ms" />
    {/each}

    <!-- L'échantillon : les copies glissent dans la boîte. -->
    <g class="vo-droite" class:vo-vu={e >= 1}>
      <text x={BX} y="38" class="vo-titre">l’échantillon</text>
      <text x={BX} y="66" class="vo-sous">ceux qu’on observe</text>
      <rect x={BX} y={BY} width={BW} height={BH} class="vo-boite" />
      <path d="M {GX + COLS * PAS + 8} {YF} H {BX - 12}" class="vo-fleche" />
      <path d="M {BX - 22} {YF - 8} L {BX - 12} {YF} L {BX - 22} {YF + 8}" class="vo-fleche" />
    </g>
    {#each COPIES as c}
      <rect x={c.x0} y={c.y0} width={COTE} height={COTE} class="vo-copie" class:vo-vu={e >= 1}
            style="transform: {e >= 1 ? `translate(${c.dx}px, ${c.dy}px)` : 'none'}; transition-delay: {e >= 1 ? 350 + c.k * 35 : 0}ms" />
    {/each}

    <!-- Le paramètre. -->
    <g class="vo-bas" class:vo-vu={e >= 2}>
      <text x={GX} y="448" class="vo-inconnu">?</text>
      <text x={GX + 56} y="404" class="vo-titre">le paramètre</text>
      <text x={GX + 56} y="434" class="vo-sous">la vraie valeur, inconnue</text>
    </g>

    <!-- L'estimé. -->
    <g class="vo-bas" class:vo-vu={e >= 3}>
      <text x={BX} y="404" class="vo-titre">l’estimé</text>
      <text x={BX} y="434" class="vo-sous">ce qu’on calcule</text>
      <text x={BX} y="460" class="vo-sous">dans l’échantillon</text>
    </g>
  </svg>
</div>

<style>
  .vocabulaire { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .vo-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }
  .vo-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .vo-sous { font-size: 20px; fill: var(--dk-gris); }
  .vo-inconnu { font-size: 64px; font-weight: 600; fill: var(--dk-encre); }

  .vo-carre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; transition: fill 0.4s; animation: vo-pop 0.35s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  .vo-carre.vo-rouge { fill: var(--dk-accent); }

  .vo-droite { opacity: 0; transition: opacity 0.2s; }
  .vo-droite.vo-vu { opacity: 1; transition: opacity 0.4s 0.2s; }
  .vo-boite { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .vo-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 4; }

  .vo-copie { fill: var(--dk-accent); opacity: 0; transition: transform 0.7s cubic-bezier(0.34, 1.3, 0.64, 1), opacity 0.2s; }
  .vo-copie.vo-vu { opacity: 1; }

  .vo-bas { opacity: 0; transform: translateY(10px); transition: opacity 0.2s, transform 0.2s; }
  .vo-bas.vo-vu { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }

  @keyframes vo-pop { from { transform: scale(0); } to { transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .vo-carre { animation: none; transition: none; }
    .vo-droite, .vo-droite.vo-vu, .vo-copie, .vo-bas, .vo-bas.vo-vu { transition: none; }
  }
</style>
