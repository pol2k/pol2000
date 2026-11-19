<script>
  /**
   * Règle 1 : ne jamais contrôler une variable sur laquelle X a un effet.
   * L'effet de X coule vers Y par deux tuyaux : directement, et en passant
   * par Z (l'exemple du cours : l'éducation agit sur l'idéologie
   * directement, et en passant par le revenu). Au bout, un réservoir
   * recueille tout ce qui arrive à Y : c'est l'effet qu'on mesure.
   *
   *   0  les deux tuyaux coulent, le réservoir se remplit : 100 % de
   *      l'effet de X arrive à Y;
   *   1  on contrôle Z : une vanne rouge se ferme sur Z, les points s'y
   *      arrêtent, rien n'en repart; le réservoir redescend à 50 %. On ne
   *      mesure plus qu'une partie de l'effet.
   *
   * Schéma, aucune donnée : la moitié de l'effet passe par Z, par
   * convention. Les points : Flux.svelte.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const DIRECT = 'M 300 180 L 940 180';
  const VERS_Z = 'M 270 230 L 540 440';
  const DE_Z = 'M 760 440 L 980 230';
  const LEG = [
    'L’éducation agit sur l’idéologie directement, et en passant par le revenu : tout l’effet arrive.',
    'On contrôle le revenu : le chemin par le revenu est coupé. On ne mesure plus que la moitié de l’effet.'
  ];
  const part = $derived(e >= 1 ? 50 : 100);
</script>

<div class="visuel m11d" bind:this={hote}>
  <svg viewBox="0 0 1400 560" role="img" aria-label="L’éducation agit sur l’idéologie par deux chemins : directement, et en passant par le revenu. Un réservoir au bout recueille tout l’effet : 100 %. Quand on contrôle le revenu, le chemin par le revenu se ferme, et le réservoir redescend à 50 %.">
    <defs>
      <marker id="m11d-pointe" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 L10 5 L0 10 Z" class="m11d-pt" /></marker>
    </defs>

    <!-- les tuyaux -->
    <path d={DIRECT} class="m11d-tuyau" />
    <path d={VERS_Z} class="m11d-tuyau" />
    <path d={DE_Z} class="m11d-tuyau" class:m11d-sec={e >= 1} />
    <path d={DIRECT} class="m11d-fleche" marker-end="url(#m11d-pointe)" />
    <path d={VERS_Z} class="m11d-fleche" marker-end="url(#m11d-pointe)" />
    <path d={DE_Z} class="m11d-fleche" class:m11d-gris={e >= 1} marker-end="url(#m11d-pointe)" />

    <Flux d={DIRECT} n={5} duree={2.6} r={10} />
    <Flux d={VERS_Z} n={3} duree={2} r={10} arret={e >= 1 ? 0.86 : 1} />
    <Flux d={DE_Z} actif={e === 0} n={3} duree={2} r={10} />

    <!-- les variables -->
    <g class="m11d-n"><rect x="40" y="130" width="250" height="100" /><text x="165" y="191">Éducation</text><text x="165" y="118" class="m11d-xy">X</text></g>
    <g class="m11d-n"><rect x="950" y="130" width="250" height="100" /><text x="1075" y="191">Idéologie</text><text x="1075" y="118" class="m11d-xy">Y</text></g>
    <g class="m11d-n"><rect x="540" y="400" width="220" height="90" /><text x="650" y="455">Revenu</text><text x="650" y="550" class="m11d-xy">Z</text></g>

    <!-- la vanne : contrôler Z -->
    <g class="m11d-vanne" class:m11d-vu={e >= 1}>
      <rect x="526" y="386" width="248" height="118" />
      <text x="650" y="378" class="m11d-ctl">contrôlé</text>
    </g>

    <!-- le réservoir de Y -->
    <g class="m11d-res">
      <text x="1300" y="96" class="m11d-ttl">effet mesuré</text>
      <rect x="1250" y="120" width="100" height="320" class="m11d-cuve" />
      <rect x="1250" y="120" width="100" height="320" class="m11d-eau" style="transform: scaleY({part / 100})" />
      <line x1="1236" y1="280" x2="1364" y2="280" class="m11d-mi" />
      <text x="1300" y="486" class="m11d-pct" class:m11d-rouge={e >= 1}>{part}&#8239;%</text>
    </g>
  </svg>
  <p class="m11d-legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="m11d-cap">Schéma, aucune donnée · la moitié de l’effet passe par le revenu, par convention</p>
</div>

<style>
  .m11d { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 58vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .m11d-tuyau { fill: none; stroke: var(--dk-fond-2); stroke-width: 44; stroke-linecap: round; transition: stroke 0.6s; }
  .m11d-tuyau.m11d-sec { stroke: #e9e9e4; }
  .m11d-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.6s; }
  .m11d-fleche.m11d-gris { stroke: var(--dk-gris-2); stroke-dasharray: 10 8; }
  .m11d-pt { fill: var(--dk-encre); }
  .m11d-n rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .m11d-n text { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11d-n text.m11d-xy { font-size: 26px; fill: var(--dk-accent); }
  .m11d-vanne { opacity: 0; transition: opacity 0.4s; }
  .m11d-vanne.m11d-vu { opacity: 1; }
  .m11d-vanne rect { fill: none; stroke: var(--dk-accent); stroke-width: 8; }
  .m11d-ctl { font-size: 24px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .m11d-ttl { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11d-cuve { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .m11d-eau { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; transition: transform 1.4s cubic-bezier(0.4, 0, 0.2, 1) 0.6s; }
  .m11d-mi { stroke: var(--dk-gris); stroke-width: 2; stroke-dasharray: 6 5; }
  .m11d-pct { font-size: 46px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11d-pct.m11d-rouge { fill: var(--dk-accent); }
  .m11d-legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .m11d-legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .m11d-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11d-eau, .m11d-vanne { transition: none; } }
</style>
