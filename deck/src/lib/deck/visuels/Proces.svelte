<script>
  /**
   * Présumée vraie : le test d'hypothèse comme un procès. Schéma, aucune
   * donnée. Deux colonnes, « au tribunal » (avec une petite balance de la
   * justice) et « en statistique », et quatre lignes, une par temps.
   *
   *   0  L'accusée est présumée innocente | H0 est présumée vraie.
   *   1  Les preuves | les données.
   *   2  Coupable hors de tout doute raisonnable | on rejette H0.
   *   3  Pas assez de preuves : acquittée, pas « innocente » | on ne rejette
   *      pas H0, on ne l'accepte jamais (Arel-Bundock 2021, p. 75).
   *
   * Les lignes à venir gardent leur place (opacité, visibilité) : la grille
   * ne bouge pas. Le filet rouge marque la ligne qu'on vient d'ajouter.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const LIGNES = [
    { g: 'l’accusée est présumée innocente', d: 'H0 est présumée vraie' },
    { g: 'les preuves', d: 'les données' },
    { g: 'coupable hors de tout doute raisonnable', d: 'on rejette H0' },
    { g: `pas assez de preuves${N}: acquittée, pas «${N}innocente${N}»`, d: 'on ne rejette pas H0, on ne l’accepte jamais', src: 'Arel-Bundock (2021, p. 75)' }
  ];
</script>

<div class="visuel proces" bind:this={hote}>
  <span class="prc-note">schéma</span>
  <div class="prc-grille">
    <div class="prc-tete">
      <svg class="prc-balance" viewBox="0 0 64 56" role="img" aria-label="Une balance de la justice">
        <rect x="29" y="3" width="6" height="6" class="prc-trait" />
        <line x1="32" y1="9" x2="32" y2="50" class="prc-trait" />
        <line x1="20" y1="51" x2="44" y2="51" class="prc-trait" />
        <line x1="6" y1="14" x2="58" y2="14" class="prc-trait" />
        <path d="M 6 14 L 1 33 M 6 14 L 11 33 M 58 14 L 53 33 M 58 14 L 63 33" class="prc-fil" />
        <path d="M 0 33 L 12 33 L 9 38 L 3 38 Z M 52 33 L 64 33 L 61 38 L 55 38 Z" class="prc-plateau" />
      </svg>
      <span>au tribunal</span>
    </div>
    <div class="prc-tete"><span>en statistique</span></div>
    {#each LIGNES as l, k}
      <div class="prc-cell prc-g" class:prc-vu={e >= k} class:prc-ici={e === k}>{l.g}</div>
      <div class="prc-cell prc-d" class:prc-vu={e >= k}>
        <span>{l.d}</span>
        {#if l.src}<span class="prc-src">{l.src}</span>{/if}
      </div>
    {/each}
  </div>
</div>

<style>
  .proces { position: relative; }
  .prc-note { position: absolute; top: -0.4em; right: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris-2); }
  .prc-grille { display: grid; grid-template-columns: 1fr 1fr; column-gap: 2.4em; }
  .prc-tete { display: flex; align-items: flex-end; gap: 0.6em; padding-bottom: 0.4em; border-bottom: 3px solid var(--dk-encre); font-size: 1.2em; font-weight: 600; }
  .prc-balance { width: 2.2em; height: auto; display: block; flex: 0 0 auto; }
  .prc-trait { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .prc-fil { fill: none; stroke: var(--dk-encre); stroke-width: 1.5; }
  .prc-plateau { fill: var(--dk-encre); }
  .prc-cell { display: flex; flex-direction: column; gap: 0.3em; padding: 0.55em 0 0.55em 0.7em; border-left: 0.3em solid transparent; border-bottom: 2px solid var(--dk-filet); font-size: 1em; line-height: 1.35; opacity: 0; visibility: hidden; transform: translateY(0.3em); transition: opacity 0.3s, transform 0.3s, visibility 0s 0.3s, border-color 0.3s; }
  .prc-cell.prc-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.5s, transform 0.5s, visibility 0s, border-color 0.3s; }
  .prc-g { color: var(--dk-gris); }
  .prc-d { font-weight: 600; }
  .prc-d.prc-vu { transition-delay: 0.2s; }
  .prc-g.prc-ici { border-left-color: var(--dk-accent); }
  .prc-src { font-size: 0.6em; font-weight: 400; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .prc-cell, .prc-cell.prc-vu, .prc-d.prc-vu { transition: none; }
    .prc-cell { transform: none; }
  }
</style>
