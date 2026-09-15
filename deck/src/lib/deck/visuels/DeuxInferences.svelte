<script>
  /**
   * Deux sortes d'inférence (King, Keohane et Verba, 1994) : descriptive et
   * causale. Trois temps.
   *
   *   0  « l'inférence » en haut; deux branches se tracent vers deux
   *      colonnes vides.
   *   1  La colonne descriptive : « Qu'est-ce qui se passe ? », et une vraie
   *      part, celle des personnes qui comptent voter conservateur dans
   *      l'Étude électorale canadienne 2025. Calculée ici à partir de
   *      VOTE.effectifs (src/lib/data/seance3.js) : le code 2 sur les codes
   *      1 à 6 et 8; le code 7, « ne sait pas », est écarté.
   *   2  La colonne causale : « Pourquoi ? », revenu → vote.
   */
  import { brancherTemps } from '../temps.js';
  import { VOTE } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const choix = VOTE.effectifs.reduce((s, n, k) => (k === 6 ? s : s + n), 0);
  const part = VOTE.effectifs[1] / choix;
  const pct = Math.round(part * 100);
</script>

<div class="visuel deux-inf" bind:this={hote}>
  <svg class="arbre-i" viewBox="0 0 1000 110" aria-hidden="true">
    <text x="500" y="34" class="racine">l’inférence</text>
    <path d="M 500 48 L 500 70 L 250 70 L 250 106" pathLength="1" class="branche" />
    <path d="M 500 48 L 500 70 L 750 70 L 750 106" pathLength="1" class="branche" style="animation-delay: 0.15s" />
  </svg>
  <div class="cols">
    <div class="col-i" class:plein={e >= 1} class:ici={e === 1}>
      {#if e >= 1}
        <span class="gros">descriptive</span>
        <span class="quest">Qu’est-ce qui se passe{N}?</span>
        <span class="ex">Quelle part compte voter conservateur{N}?</span>
        <div class="piste-i" style="--p: {(part * 100).toFixed(1)}%"><div class="rempli-i"></div><span class="val-i">{pct}{N}%</span></div>
        <span class="mini-i">Étude électorale canadienne 2025, sans les «&#8239;ne sait pas&#8239;»</span>
        <span class="tag-i">partie 1 · dès aujourd’hui</span>
      {/if}
    </div>
    <div class="col-i" class:plein={e >= 2} class:ici={e === 2}>
      {#if e >= 2}
        <span class="gros">causale</span>
        <span class="quest">Pourquoi{N}?</span>
        <span class="ex">Le revenu fait-il voter conservateur{N}?</span>
        <svg class="glyphe-i" viewBox="0 0 420 70" role="img" aria-label="Revenu, flèche, vote.">
          <rect x="4" y="12" width="130" height="46" class="boite-i" />
          <text x="69" y="42" class="mot-i">revenu</text>
          <path d="M 146 35 L 272 35 M 256 22 L 272 35 L 256 48" pathLength="1" class="fleche-i" />
          <rect x="284" y="12" width="130" height="46" class="boite-i rouge" />
          <text x="349" y="42" class="mot-i rouge">vote</text>
        </svg>
        <span class="tag-i">partie 3 · novembre</span>
      {/if}
    </div>
  </div>
</div>

<style>
  .deux-inf { display: flex; flex-direction: column; gap: 0.2em; }
  .arbre-i { width: 100%; height: auto; max-height: 12vh; display: block; }
  .racine { font-family: var(--dk-mono); font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); animation: pop 0.5s cubic-bezier(0.34, 1.7, 0.64, 1) both; transform-box: fill-box; transform-origin: center; }
  .branche { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.7s ease-out 0.25s forwards; }
  .cols { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; }
  .col-i { display: flex; flex-direction: column; gap: 0.4em; min-height: 15em; padding: 0.9em 1em 1em; border: 3px dashed var(--dk-filet); transition: border-color 0.3s; }
  .col-i.plein { border-style: solid; border-color: var(--dk-encre); }
  .col-i.ici { border-color: var(--dk-accent); animation: rebond 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .gros { font-size: 1.9em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; animation: monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .ici .gros { color: var(--dk-accent); }
  .quest { font-size: 1.1em; font-weight: 600; animation: monte 0.45s ease-out 0.15s both; }
  .ex { font-size: 0.85em; color: var(--dk-gris); animation: monte 0.45s ease-out 0.3s both; }
  .piste-i { position: relative; height: 1.6em; margin-top: 0.3em; background: var(--dk-fond-2); animation: monte 0.4s ease-out 0.4s both; }
  .rempli-i { height: 100%; width: 0; background: var(--dk-accent); animation: remplir 0.9s cubic-bezier(0.34, 1.3, 0.64, 1) 0.6s forwards; }
  .val-i { position: absolute; left: calc(var(--p) + 0.6em); top: 50%; transform: translateY(-50%); font-weight: 600; color: var(--dk-accent); animation: monte 0.4s ease-out 1.2s both; }
  .mini-i { font-size: 0.6em; color: var(--dk-gris); letter-spacing: 0.04em; animation: monte 0.4s ease-out 0.5s both; }
  .glyphe-i { width: 80%; height: auto; display: block; margin-top: 0.3em; animation: monte 0.4s ease-out 0.4s both; }
  .boite-i { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .boite-i.rouge { stroke: var(--dk-accent); }
  .mot-i { font-family: var(--dk-mono); font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mot-i.rouge { fill: var(--dk-accent); }
  .fleche-i { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.6s ease-out 0.7s forwards; }
  .tag-i { margin-top: auto; align-self: flex-start; font-size: 0.66em; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-accent); border: 2px solid var(--dk-accent); padding: 0.2em 0.55em; animation: monte 0.4s ease-out 0.6s both; }
  @keyframes pop { from { opacity: 0; transform: scale(0.5); } to { opacity: 1; transform: none; } }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes monte { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @keyframes rebond { from { transform: scale(0.95); } to { transform: scale(1); } }
  @keyframes remplir { to { width: var(--p); } }
  @media (prefers-reduced-motion: reduce) {
    .racine, .col-i, .gros, .quest, .ex, .piste-i, .val-i, .mini-i, .glyphe-i, .tag-i { animation: none; }
    .branche, .fleche-i { animation: none; stroke-dashoffset: 0; }
    .rempli-i { animation: none; width: var(--p); }
  }
</style>
