<script>
  /**
   * L'inférence : utiliser ce qu'on sait pour apprendre ce qu'on ne sait pas.
   * À gauche, ce qu'on sait : les répondant.e.s de l'Étude électorale
   * canadienne 2025 (N vient de src/lib/data/ces2025.js), un bloc de carrés
   * allumés. À droite, ce qu'on veut savoir : tout l'électorat, dans le
   * brouillard. Trois temps.
   *
   *   0  Les carrés apparaissent rangée par rangée; le brouillard dérive.
   *   1  Une flèche rouge saute de gauche à droite; un peu de lumière rouge
   *      se répand dans le brouillard.
   *   2  La définition de King, Keohane et Verba (1994, p. 46). La page est
   *      attestée, et la proposition citée l'est aussi; la formule
   *      d'ouverture (« Inference is the process of... ») n'a pas pu être
   *      retrouvée dans le texte, alors elle reste hors des guillemets :
   *      le cadre (« L'inférence, c'est ») est le nôtre, en français, et
   *      seule la proposition vérifiée est citée, en anglais, dans le
   *      texte original.
   *
   * Pas de nuage de population avec son échantillon : la séance 1 l'a
   * déjà dessiné. Ici, on oppose le connu et l'inconnu.
   */
  import { brancherTemps } from '../temps.js';
  import { N } from '$lib/data/ces2025.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const n = N.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const COTE = 14, PAS = 15, GX = 70, GY = 88;
  const CARRES = Array.from({ length: COTE * COTE }, (_, i) => ({ r: Math.floor(i / COTE), c: i % COTE }));
  // Le brouillard : des traits horizontaux qui dérivent, à positions fixes.
  const BRUME = [70, 105, 140, 175, 210, 245, 280].map((y, k) => ({ y, x0: 450 + (k % 3) * 20, x1: 950 - (k % 2) * 30, v: 9 + (k % 4) * 3 }));
  // La lumière qui se répand : quelques carrés rouges, du bord gauche vers le fond.
  const LUEURS = [[470, 150], [505, 190], [490, 230], [545, 120], [560, 170], [600, 215], [640, 140], [690, 190], [740, 130], [790, 220]];
</script>

<div class="visuel inference" bind:this={hote}>
  <svg viewBox="0 0 1000 380" role="img" aria-label="À gauche, un bloc de carrés : les 20 180 répondant.e.s de l'Étude électorale canadienne 2025, ce qu'on sait. À droite, un brouillard : tout l'électorat canadien, ce qu'on veut savoir. Une flèche va de l'un à l'autre.">
    <!-- Ce qu'on sait. -->
    <text x={GX} y="58" class="et">ce qu’on sait</text>
    {#each CARRES as q}
      <rect x={GX + q.c * PAS} y={GY + q.r * PAS} width="12" height="12" class="carre-i" style="animation-delay: {q.r * 45 + q.c * 8}ms" />
    {/each}
    <text x={GX} y={GY + COTE * PAS + 28} class="sous">{n} répondant.e.s</text>
    <text x={GX} y={GY + COTE * PAS + 52} class="mini">Étude électorale canadienne 2025</text>

    <!-- Ce qu'on veut savoir : le brouillard. -->
    <rect x="430" y="30" width="540" height="300" class="brume-cadre" />
    {#each BRUME as b}
      <line x1={b.x0} y1={b.y} x2={b.x1} y2={b.y} class="brume" style="animation-duration: {b.v}s" />
    {/each}
    <text x="458" y="62" class="et">ce qu’on veut savoir</text>
    <text x="458" y="314" class="sous">tout l’électorat canadien</text>

    <!-- Le saut. -->
    {#if e >= 1}
      <path d="M 290 170 Q 380 30 470 150" pathLength="1" class="saut" />
      <path d="M 448 146 L 470 150 L 468 128" pathLength="1" class="saut pointe" />
      {#each LUEURS as [x, y], k}
        <rect {x} {y} width="14" height="14" class="lueur" style="animation-delay: {600 + k * 80}ms; --o: {1 - k * 0.07}" />
      {/each}
    {/if}
  </svg>
  <blockquote class="citation-i" class:vu={e >= 2}>
    <p>L’inférence, c’est <span lang="en">“using the facts we know to learn about facts we do not know”</span>.</p>
    <cite>King, Keohane and Verba (1994, p. 46)</cite>
  </blockquote>
</div>

<style>
  .inference { display: flex; flex-direction: column; gap: 0.6em; }
  svg { width: 100%; height: auto; max-height: 50vh; display: block; }
  text { font-family: var(--dk-mono); }
  .et { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .sous { font-size: 18px; fill: var(--dk-encre); }
  .mini { font-size: 15px; fill: var(--dk-gris); }
  .carre-i { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; animation: pop 0.35s cubic-bezier(0.34, 1.8, 0.64, 1) both; }
  .brume-cadre { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 12 9; }
  .brume { stroke: var(--dk-filet); stroke-width: 7; stroke-dasharray: 70 40 20 55; animation: deriver linear infinite; }
  .saut { fill: none; stroke: var(--dk-accent); stroke-width: 8; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.7s ease-out forwards; }
  .saut.pointe { stroke-width: 7; animation-delay: 0.55s; }
  .lueur { fill: var(--dk-accent); opacity: 0; transform-box: fill-box; transform-origin: center; animation: lueur 0.5s cubic-bezier(0.34, 1.8, 0.64, 1) forwards; }
  .citation-i { margin: 0; border-left: 0.34em solid var(--dk-accent); padding: 0.1em 0 0.1em 0.8em; opacity: 0; transform: translateY(0.6em); transition: opacity 0.5s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .citation-i.vu { opacity: 1; transform: none; }
  .citation-i p { margin: 0; font-size: 1.15em; line-height: 1.35; font-weight: 600; }
  .citation-i cite { display: block; margin-top: 0.35em; font-style: normal; font-size: 0.62em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes deriver { to { stroke-dashoffset: -185; } }
  @keyframes lueur { from { opacity: 0; transform: scale(0); } to { opacity: var(--o); transform: scale(1); } }
  @media (prefers-reduced-motion: reduce) {
    .carre-i, .brume { animation: none; }
    .saut { animation: none; stroke-dashoffset: 0; }
    .lueur { animation: none; opacity: var(--o); }
    .citation-i { transition: none; }
  }
</style>
