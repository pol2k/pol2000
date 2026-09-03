<script>
  /**
   * Population, échantillon, inférence — en trois temps. Le nuage complet
   * (la population), puis les points tirés (l'échantillon) qui s'allument,
   * puis la flèche qui remonte de l'échantillon vers la population: la
   * question de la séance 5. Positions pseudo-aléatoires à graine fixe;
   * aucune proportion réelle.
   */
  import { brancherTemps } from '../temps.js';
  let { n = 320, k = 28 } = $props();
  let s = 7;
  const r = () => { s = (s * 16807) % 2147483647; return s / 2147483647; };
  const pts = Array.from({ length: n }, () => ({ x: 40 + r() * 1020, y: 40 + r() * 320 }));
  const pris = new Set();
  while (pris.size < k) pris.add(Math.floor(r() * n));

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel points" bind:this={hote}>
  <svg viewBox="0 0 1100 470" role="img" aria-label="Un nuage de points, la population; quelques-uns en rouge, l'échantillon; puis une flèche de l'échantillon vers la population.">
    <rect x="20" y="20" width="1060" height="360" class="cadre" />
    {#each pts as p, i}
      {@const dans = pris.has(i)}
      <circle cx={p.x} cy={p.y} r={dans && e >= 1 ? 10 : 4.5} class={dans && e >= 1 ? 'ech' : 'pop'} class:pale={e >= 1 && !dans} style="transition-delay: {dans ? (i % 7) * 60 : 0}ms" />
    {/each}
    <text x="22" y="410" class="et">POPULATION · tous les cas qui nous intéressent</text>
    <text x="1078" y="410" class="et fin" class:vu={e >= 1}>ÉCHANTILLON · ceux qu'on a observés</text>
    <g class="inf" class:vu={e === 2}>
      <path d="M 550 455 C 550 430, 550 400, 550 385" class="fl" marker-end="url(#fp)" />
      <text x="550" y="462" class="q">ce que je vois ici, puis-je le dire de tous ?</text>
    </g>
    <defs><marker id="fp" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0L10 5L0 10z" class="pointe" /></marker></defs>
  </svg>
</div>

<style>
  .points { width: 100%; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  .cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  circle { transition: r 0.5s, fill 0.5s, opacity 0.5s; }
  .pop { fill: var(--dk-gris); }
  .pop.pale { opacity: 0.35; }
  .ech { fill: var(--dk-accent); }
  .et { font-family: var(--dk-mono); font-size: 16px; letter-spacing: 0.12em; font-weight: 600; fill: var(--dk-encre); }
  .et.fin { text-anchor: end; fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s; }
  .et.fin.vu { opacity: 1; }
  .inf { opacity: 0; transition: opacity 0.5s; }
  .inf.vu { opacity: 1; }
  .fl { fill: none; stroke: var(--dk-accent); stroke-width: 5; }
  .pointe { fill: var(--dk-accent); }
  .q { font-family: var(--dk-mono); font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
</style>
