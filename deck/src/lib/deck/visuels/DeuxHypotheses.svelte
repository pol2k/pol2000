<script>
  /**
   * Deux hypothèses : H1, l'hypothèse de recherche, et H0, l'hypothèse nulle
   * (vocabulaire d'Arel-Bundock 2021, p. 67). Deux cartes côte à côte; celle
   * de H0 porte le filet rouge, c'est elle qu'on teste. Deux temps.
   *
   *   0  L'exemple de la pomicultrice. H1, ce qu'elle veut prouver à
   *      l'acheteur : ses pommes pèsent plus de POMMES.h0 grammes en moyenne
   *      (le livre, p. 63 : « µ > 100 »). H0, tout le reste : 100 g ou moins,
   *      rien de spécial, ou l'inverse.
   *   1  Un exemple politique, lu dans le même sens : H1, l'intérêt augmente
   *      avec l'âge; H0, il n'augmente pas (il reste pareil, ou il baisse).
   *   (La stratégie, et pourquoi on ne construit que le monde à 100 g, ont
   *   leur propre diapo : PourquoiH0.svelte.)
   *
   * Remanié le 30 septembre 2026 : l'ancienne H1 (« n'est pas de 100 g »)
   * se lisait à l'envers de l'exemple politique. Remanié le 1er octobre 2026
   * à la demande du professeur : H0 devient « 100 g ou moins », le
   * complément de H1. Le livre écrit H0 comme un point, « µ = 100 » (p. 67),
   * et teste des deux côtés (p. 71); la version unilatérale est celle du
   * cours, d'où le « d'après » de la source.
   *
   * Les lignes cachées gardent leur place (opacité, visibilité) : rien ne
   * saute d'un temps à l'autre.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel deux-hyp" bind:this={hote}>
  <div class="dhy-cartes">
    <div class="dhy-carte">
      <div class="dhy-tete"><span class="dhy-h">H1</span><span class="dhy-nom">hypothèse de recherche</span></div>
      <p class="dhy-sous">ce qu’on veut prouver</p>
      <p class="dhy-ex">Mes pommes pèsent plus de {POMMES.h0}&#8239;g en moyenne.</p>
      <p class="dhy-ex dhy-pol" class:dhy-vu={e >= 1}>L’intérêt pour la politique augmente avec l’âge.</p>
    </div>
    <div class="dhy-carte dhy-nulle">
      <div class="dhy-tete"><span class="dhy-h">H0</span><span class="dhy-nom">hypothèse nulle</span></div>
      <p class="dhy-sous">tout le reste&#8239;: rien de spécial, ou l’inverse</p>
      <p class="dhy-ex">Mes pommes pèsent {POMMES.h0}&#8239;g ou moins en moyenne.</p>
      <p class="dhy-ex dhy-pol" class:dhy-vu={e >= 1}>L’intérêt pour la politique n’augmente pas avec l’âge.</p>
    </div>
  </div>
  <span class="dhy-src">d’après Arel-Bundock (2021, p. 63 et 67)</span>
</div>

<style>
  .deux-hyp { display: flex; flex-direction: column; gap: 0.9em; }
  .dhy-cartes { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; }
  .dhy-carte { display: flex; flex-direction: column; gap: 0.7em; padding: 0.9em 1.1em 1.1em; border: 3px solid var(--dk-filet); animation: dhy-monte 0.45s ease-out both; }
  .dhy-carte.dhy-nulle { border-color: var(--dk-encre); border-top: 0.35em solid var(--dk-accent); animation-delay: 0.15s; }
  .dhy-tete { display: flex; align-items: baseline; gap: 0.5em; }
  .dhy-h { font-size: 2.4em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; color: var(--dk-gris); }
  .dhy-nulle .dhy-h { color: var(--dk-accent); }
  .dhy-nom { font-size: 0.9em; font-weight: 600; color: var(--dk-gris); }
  .dhy-nulle .dhy-nom { color: var(--dk-encre); }
  .dhy-sous { margin: -0.3em 0 0; font-size: 0.85em; color: var(--dk-gris); }
  .dhy-ex { margin: 0; font-size: 1em; line-height: 1.4; color: var(--dk-encre); transition: color 0.4s; }
  .dhy-pol { padding-top: 0.6em; border-top: 2px solid var(--dk-filet); opacity: 0; visibility: hidden; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .dhy-pol.dhy-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.5s 0.2s, transform 0.5s 0.2s, visibility 0s; }
  .dhy-src { font-size: 0.6em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }
  @keyframes dhy-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .dhy-carte { animation: none; }
    .dhy-ex, .dhy-pol, .dhy-pol.dhy-vu { transition: none; }
    .dhy-pol { transform: none; }
  }
</style>
