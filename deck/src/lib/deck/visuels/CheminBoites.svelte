<script>
  /**
   * Un dossier est une boîte, et les boîtes vont dans des boîtes. Le chemin
   * ne fait que raconter le trajet : chaque barre oblique veut dire « on
   * ouvre une boîte de plus ». En haut les boîtes emboîtées, en bas le chemin
   * qui s’allonge d’un cran par clic. Rien d’autre à lire.
   *
   *   0  Une grande boîte : Documents. Chemin : Documents
   *   1  Dedans s’ouvre pol2000. Chemin : Documents/pol2000, la nouvelle
   *      barre oblique clignote en rouge.
   *   2  Dedans, data (et, très pâles, ses voisines R et resultats).
   *   3  Dedans, un fichier, dessiné comme une feuille : ces2025.csv.
   *   4  Toutes les barres obliques passent au rouge ensemble, et une seule
   *      phrase apparaît.
   *
   * Coordonnées fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  const SEGMENTS = ['Documents', 'pol2000', 'data', 'ces2025.csv'];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const visibles = $derived(SEGMENTS.slice(0, Math.min(e, 3) + 1));
</script>

<div class="visuel cb-fig" bind:this={hote}>
  <svg
    class="cb-scene"
    viewBox="0 0 1200 424"
    role="img"
    aria-label="Des boîtes emboîtées, de la plus grande à la plus petite&#8239;: la boîte Documents contient la boîte pol2000, qui contient la boîte data, à côté de deux boîtes pâles, R et resultats. Dans la boîte data, une feuille de papier&#8239;: le fichier ces2025.csv."
  >
    <rect x="40" y="16" width="1120" height="392" class="cb-boite" />
    <text x="66" y="58" class="cb-nom">Documents</text>

    <g class="cb-niveau" class:cb-vu={e >= 1}>
      <rect x="90" y="80" width="1020" height="304" class="cb-boite cb-teinte" />
      <text x="116" y="122" class="cb-nom">pol2000</text>
    </g>

    <g class="cb-niveau" class:cb-vu={e >= 2}>
      <rect x="730" y="144" width="160" height="216" class="cb-voisine" />
      <text x="750" y="182" class="cb-nom-pale">R</text>
      <rect x="920" y="144" width="160" height="216" class="cb-voisine" />
      <text x="936" y="182" class="cb-nom-pale">resultats</text>
      <rect x="140" y="144" width="560" height="216" class="cb-boite" />
      <text x="166" y="186" class="cb-nom">data</text>
    </g>

    <g class="cb-niveau" class:cb-vu={e >= 3}>
      <path d="M 190 208 H 256 L 280 232 V 340 H 190 Z M 256 208 V 232 H 280" class="cb-feuille" />
      <path d="M 206 262 H 264 M 206 286 H 264 M 206 310 H 244" class="cb-lignes" />
      <text x="306" y="290" class="cb-nom cb-fichier">ces2025.csv</text>
    </g>
  </svg>

  <p class="cb-chemin" class:cb-rouge={e >= 4}>
    {#each visibles as s, i (s)}{#if i > 0}<span class="cb-barre">/</span>{/if}<span class="cb-seg">{s}</span>{/each}
  </p>

  <div class="cb-bas">
    {#if e >= 4}
      <p class="cb-ligne">Chaque barre oblique&#8239;: on ouvre une boîte.</p>
    {/if}
  </div>
</div>

<style>
  .cb-fig { display: flex; flex-direction: column; gap: 0.6em; }

  .cb-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; }
  .cb-scene text { font-family: var(--dk-mono); }

  .cb-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 5; }
  .cb-boite.cb-teinte { fill: var(--dk-fond-2); }
  .cb-nom { font-size: 32px; font-weight: 600; fill: var(--dk-encre); }
  .cb-nom.cb-fichier { font-size: 34px; }

  /* Les voisines : on voit qu’une boîte en contient plusieurs, sans que
     l’œil quitte le trajet. */
  .cb-voisine { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; opacity: 0.55; }
  .cb-nom-pale { font-size: 26px; fill: var(--dk-gris-2); }

  .cb-feuille { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .cb-lignes { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }

  /* Chaque boîte s’ouvre dans la précédente. */
  .cb-niveau {
    opacity: 0;
    transform-box: fill-box;
    transform-origin: center;
    transform: scale(0.82);
    transition: opacity 0.25s, transform 0.25s;
  }
  .cb-niveau.cb-vu { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s ease-out; }

  /* Le chemin : il est toujours là, il ne fait que s’allonger. */
  .cb-chemin {
    margin: 0;
    align-self: flex-start;
    padding: 0.3em 0.6em;
    border: 3px solid var(--dk-encre);
    background: var(--dk-fond);
    font-family: var(--dk-mono);
    font-size: 1.45em;
    font-weight: 600;
    line-height: 1.3;
    white-space: nowrap;
  }
  .cb-seg { display: inline-block; animation: cb-arrive 0.4s ease-out 0.25s both; }
  .cb-barre {
    display: inline-block;
    margin: 0 0.12em;
    color: var(--dk-encre);
    transition: color 0.4s, transform 0.4s;
    animation: cb-eclair 2.4s ease-out both;
  }
  .cb-chemin.cb-rouge .cb-barre { color: var(--dk-accent); transform: scale(1.45); animation: none; }

  /* La place de la phrase finale est réservée : rien ne saute au clic. */
  .cb-bas { font-size: 1.25em; line-height: 1.35; min-height: 1.35em; }
  .cb-ligne { margin: 0; font-weight: 600; color: var(--dk-accent); animation: cb-arrive 0.4s ease-out 0.3s both; }

  @keyframes cb-arrive { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @keyframes cb-eclair {
    0% { opacity: 0; color: var(--dk-accent); transform: scale(2.2); }
    15% { opacity: 1; color: var(--dk-accent); transform: scale(1.6); }
    70% { color: var(--dk-accent); transform: scale(1.6); }
    100% { color: var(--dk-encre); transform: none; }
  }

  @media (prefers-reduced-motion: reduce) {
    .cb-niveau, .cb-niveau.cb-vu { transition: none; }
    .cb-seg, .cb-barre, .cb-ligne { animation: none; }
    .cb-barre { transition: none; }
  }
</style>
