<script>
  /**
   * Une population de points, et l'échantillon qu'on en tire. Positions
   * pseudo-aléatoires à graine fixe: la figure est la même à chaque rendu.
   * Aucune proportion réelle n'est représentée.
   */
  let { n = 260, k = 24 } = $props();
  let s = 7;
  const r = () => { s = (s * 16807) % 2147483647; return s / 2147483647; };
  const pts = Array.from({ length: n }, () => ({ x: 40 + r() * 880, y: 30 + r() * 300 }));
  const pris = new Set();
  while (pris.size < k) pris.add(Math.floor(r() * n));
</script>

<svg viewBox="0 0 960 392" class="pts" role="img" aria-label="Un nuage de points, dont quelques-uns sont mis en évidence: la population et l'échantillon.">
  <rect x="20" y="10" width="920" height="340" class="cadre" />
  {#each pts as p, i}
    <circle cx={p.x} cy={p.y} r={pris.has(i) ? 9 : 4.5} class={pris.has(i) ? 'ech' : 'pop'} />
  {/each}
  <text x="22" y="380" class="et">POPULATION = tous les points</text>
  <text x="938" y="380" class="et fin">ÉCHANTILLON = les points rouges</text>
</svg>

<style>
  .pts { width: 100%; height: auto; max-height: 58vh; display: block; }
  .cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .pop { fill: var(--dk-gris-2); }
  .ech { fill: var(--dk-accent); }
  .et { font-family: var(--dk-mono); font-size: 16px; letter-spacing: 0.16em; font-weight: 600; fill: var(--dk-encre); }
  .et.fin { text-anchor: end; fill: var(--dk-accent); }
</style>
