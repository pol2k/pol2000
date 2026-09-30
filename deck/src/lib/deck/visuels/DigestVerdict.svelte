<script>
  /**
   * Le résultat de 1936, en trois temps : la prévision, la réalité, l'écart.
   * Deux groupes de bâtons sur la même échelle (Landon, Roosevelt); dans
   * chacun, la prévision du Literary Digest (bâton creux) puis le résultat
   * de l'élection (bâton plein).
   *
   *   0  La prévision : « Landon gagne », 55 contre 41, sur 2,3 millions de
   *      réponses.
   *   1  La réalité : « Roosevelt gagne, et de loin », 61 contre 37.
   *   2  L'écart, en flèches : de combien de points chaque prévision a raté.
   *      La phrase : une erreur d'environ 20 points, avec 2,3 millions de
   *      réponses.
   *
   * Tous les nombres viennent de DIGEST (src/lib/data/seance5.js), qui les
   * tient de Squire (1988, p. 126-127). Les écarts sont calculés ici.
   */
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const REPONSES = DIGEST.retournes / 1e6;
  const BASE = 392, K = 4.0, L = 100;
  const y = (p) => BASE - p * K;
  const GROUPES = [
    { nom: 'Landon', cx: 250, prev: DIGEST.prevision.Landon, reel: DIGEST.resultat.Landon },
    { nom: 'Roosevelt', cx: 720, prev: DIGEST.prevision.Roosevelt, reel: DIGEST.resultat.Roosevelt }
  ].map((g) => ({ ...g, ecart: g.reel - g.prev }));
  const PIRE = Math.max(...GROUPES.map((g) => Math.abs(g.ecart)));
</script>

<div class="visuel digest-verdict" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La prévision du Literary Digest, sur {f(REPONSES, 1)} millions de réponses : Landon {DIGEST.prevision.Landon} %, Roosevelt {DIGEST.prevision.Roosevelt} %. La réalité : Roosevelt {DIGEST.resultat.Roosevelt} %, Landon {DIGEST.resultat.Landon} %. Une erreur d’environ {PIRE} points.">
    <!-- Les manchettes. -->
    <text x="40" y="44" class="dv-une dv-prev-t" class:dv-barre-t={e >= 1}>Le Digest prévoit&#8239;: Landon gagne</text>
    <text x="40" y="74" class="dv-sous">sur {f(REPONSES, 1)} millions de réponses</text>
    <text x="40" y="112" class="dv-une dv-reel-t dv-etape" class:dv-vu={e >= 1}>Réalité&#8239;: Roosevelt, et de loin</text>

    {#each GROUPES as g}
      {@const xp = g.cx - L - 8}
      {@const xr = g.cx + 8}
      <!-- 0 : la prévision, bâton creux. -->
      <rect x={xp} y={y(g.prev)} width={L} height={g.prev * K} class="dv-prev" class:dv-landon={g.nom === 'Landon'} />
      <text x={xp + L / 2} y={y(g.prev) - 12} class="dv-val" class:dv-rouge={g.nom === 'Landon'}>{g.prev}&#8239;%</text>
      <text x={xp + L / 2} y={BASE + 28} class="dv-qui">prévu</text>
      <!-- 1 : la réalité, bâton plein. -->
      <g class="dv-etape" class:dv-vu={e >= 1}>
        <rect x={xr} y={y(g.reel)} width={L} height={g.reel * K} class="dv-reel" class:dv-landon={g.nom === 'Landon'} />
        <text x={xr + L / 2} y={y(g.reel) - 12} class="dv-val" class:dv-rouge={g.nom === 'Landon'}>{g.reel}&#8239;%</text>
        <text x={xr + L / 2} y={BASE + 28} class="dv-qui">réel</text>
      </g>
      <text x={g.cx} y={BASE + 58} class="dv-nom" class:dv-rouge={g.nom === 'Landon'}>{g.nom}</text>
      <!-- 2 : l'écart. -->
      <g class="dv-etape" class:dv-vu={e >= 2}>
        <line x1={xp + L} y1={y(g.prev)} x2={xr + L + 26} y2={y(g.prev)} class="dv-guide" />
        <path d="M {xr + L + 18} {y(g.prev)} V {y(g.reel)} M {xr + L + 10} {y(g.reel) + (g.ecart > 0 ? 12 : -12)} L {xr + L + 18} {y(g.reel)} L {xr + L + 26} {y(g.reel) + (g.ecart > 0 ? 12 : -12)}" class="dv-fleche" />
        <text x={xr + L + 36} y={(y(g.prev) + y(g.reel)) / 2 + 8} class="dv-ecart">{g.ecart > 0 ? '+' : '−'}{Math.abs(g.ecart)} points</text>
      </g>
    {/each}
    <line x1="100" y1={BASE} x2="900" y2={BASE} class="dv-axe" />

    <text x="500" y="494" class="dv-phrase dv-etape" class:dv-vu={e >= 2}>Une erreur d’environ {PIRE} points. Avec {f(REPONSES, 1)} millions de réponses.</text>
  </svg>
</div>

<style>
  .digest-verdict { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .dv-une { font-size: 26px; font-weight: 700; }
  .dv-prev-t { fill: var(--dk-encre); transition: fill 0.4s; }
  .dv-prev-t.dv-barre-t { fill: var(--dk-gris-2); text-decoration: line-through; }
  .dv-reel-t { fill: var(--dk-accent); }
  .dv-sous { font-size: 18px; fill: var(--dk-gris); }
  .dv-prev { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 8 5; }
  .dv-prev.dv-landon { stroke: var(--dk-accent); }
  .dv-reel { fill: var(--dk-encre); }
  .dv-reel.dv-landon { fill: var(--dk-accent); }
  .dv-val { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .dv-rouge { fill: var(--dk-accent); }
  .dv-qui { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .dv-nom { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .dv-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .dv-guide { stroke: var(--dk-gris); stroke-width: 1.5; stroke-dasharray: 4 4; }
  .dv-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 3.5; }
  .dv-ecart { font-size: 22px; font-weight: 700; fill: var(--dk-accent); }
  .dv-phrase { font-size: 23px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .dv-etape { opacity: 0; transition: opacity 0.3s; }
  .dv-etape.dv-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .dv-etape, .dv-etape.dv-vu, .dv-prev-t { transition: none; }
  }
</style>
