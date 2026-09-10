<script>
  /**
   * Positron, le vrai : une capture d'écran de la fenêtre (1920 × 1080,
   * R 4.6.1, faite le 10 septembre 2026 sur un dossier préparé : un script,
   * deux objets en mémoire, un histogramme des âges de l'ÉEC 2025). Au clic,
   * un projecteur s'allume sur une zone à la fois, le reste s'assombrit et
   * une fiche dit à quoi elle sert. Cinq temps : éditeur, console,
   * variables, graphiques, explorateur.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  // Zones en pixels de la capture (viewBox 1920 × 1080).
  const Z = [
    { x: 313, y: 92, w: 1284, h: 601, et: '1 · L’ÉDITEUR', t: 'Là où vous écrivez. Un fichier .R se garde, se relance, se corrige. Ctrl + Entrée envoie la ligne à la console.', fx: 330, fy: 720, fw: 900 },
    { x: 313, y: 693, w: 1284, h: 352, et: '2 · LA CONSOLE', t: 'Là où R répond. Ce que vous y tapez s’exécute tout de suite. Et s’oublie quand vous fermez.', fx: 330, fy: 380, fw: 900 },
    { x: 1597, y: 92, w: 323, h: 508, et: '3 · LES VARIABLES', t: 'Ce que R a en mémoire en ce moment. Ici : df, 20 180 lignes ; age ; ages. Si ce n’est pas là, R ne le connaît pas.', fx: 330, fy: 380, fw: 900 },
    { x: 1597, y: 600, w: 323, h: 445, et: '4 · LES GRAPHIQUES', t: 'Ce que vous dessinez arrive ici. Un histogramme des âges de l’Étude électorale 2025 : vous ferez le vôtre tout à l’heure.', fx: 330, fy: 380, fw: 900 },
    { x: 70, y: 92, w: 243, h: 953, et: '5 · L’EXPLORATEUR', t: 'Les fichiers du dossier que vous avez ouvert. C’est de ça qu’on parle dans deux diapos.', fx: 500, fy: 380, fw: 900 }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: Z.length, lire: () => e, ecrire: (v) => (e = v) });
  });
  const z = $derived(e > 0 ? Z[e - 1] : null);
</script>

<div class="visuel positron" bind:this={hote}>
  <img src="{base}/img/positron-capture.png" alt="La fenêtre de Positron : l’explorateur de fichiers à gauche, l’éditeur avec un script au centre, la console en bas, les variables et un histogramme à droite." />
  <svg viewBox="0 0 1920 1080" class="voile" class:on={!!z} aria-hidden="true">
    <defs>
      <mask id="trou">
        <rect x="0" y="0" width="1920" height="1080" fill="#fff" />
        {#if z}<rect x={z.x} y={z.y} width={z.w} height={z.h} fill="#000" />{/if}
      </mask>
    </defs>
    <rect x="0" y="0" width="1920" height="1080" class="ombre" mask="url(#trou)" />
    {#if z}
      <rect x={z.x} y={z.y} width={z.w} height={z.h} class="cadre" />
      {#key e}
        <g class="fiche" style="transform: translate({z.fx}px, {z.fy}px)">
          <rect x="0" y="0" width={z.fw} height="196" />
          <text x="28" y="48" class="et">{z.et}</text>
          <foreignObject x="28" y="66" width={z.fw - 56} height="124">
            <p xmlns="http://www.w3.org/1999/xhtml" class="t">{z.t}</p>
          </foreignObject>
        </g>
      {/key}
    {/if}
  </svg>
  <p class="indice" class:cache={e > 0}>cliquez, ou flèche droite : une zone à la fois</p>
</div>

<style>
  /* La capture est en 16:9 comme la diapo, mais la diapo a un bandeau et
     un titre: on la borne en hauteur et le conteneur épouse l'image, pour
     que le voile SVG reste calé dessus. */
  /* deck.css impose width: 100% à tout .visuel; la borne passe donc par
     max-width, que cette règle ne touche pas. */
  .positron { position: relative; max-width: calc(74vh * 1.7778); aspect-ratio: 1920 / 1080; margin: 0 auto; border: 2px solid var(--dk-encre); box-sizing: border-box; }
  img { display: block; width: 100%; height: 100%; object-fit: fill; }
  .voile { position: absolute; inset: 0; width: 100%; height: 100%; pointer-events: none; }
  .ombre { fill: rgba(12, 14, 15, 0); transition: fill 0.4s; }
  .on .ombre { fill: rgba(12, 14, 15, 0.72); }
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 8; animation: pulse 1.6s ease-in-out infinite; }
  @keyframes pulse { 0%, 100% { stroke-opacity: 1; } 50% { stroke-opacity: 0.45; } }
  .fiche rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .fiche { animation: fondu 0.35s both; }
  .et { font-family: var(--dk-mono); font-size: 26px; font-weight: 600; letter-spacing: 0.14em; fill: var(--dk-accent); }
  .t { margin: 0; font-family: var(--dk-mono); font-size: 27px; line-height: 1.3; color: var(--dk-encre); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; } }
  .indice { position: absolute; right: 0.6em; bottom: 0.5em; margin: 0; font-size: 0.62em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-fond); background: var(--dk-encre); padding: 0.3em 0.7em; transition: opacity 0.3s; }
  .indice.cache { opacity: 0; }
</style>
