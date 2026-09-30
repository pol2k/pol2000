<script>
  /**
   * Deux hypothèses : H1, l'hypothèse, et H0, l'hypothèse nulle
   * (Arel-Bundock 2021, p. 67). Deux cartes côte à côte; celle de H0 porte
   * le filet rouge, c'est elle qu'on teste. Trois temps.
   *
   *   0  L'exemple de la pomicultrice. H1, ce qu'elle veut prouver : ses
   *      pommes pèsent plus de POMMES.h0 grammes. H0, le sceptique : des
   *      pommes ordinaires, POMMES.h0 grammes, le reste est du hasard.
   *   1  Un exemple politique, dans le même sens : H1, un lien; H0, pas de
   *      lien. Les deux exemples restent visibles, côte à côte.
   *   (La stratégie, « on présume H0 et on cherche à la rejeter », a sa propre
   *   diapo depuis le 30 septembre 2026 : PourquoiH0.svelte.)
   *
   * Remanié le 30 septembre 2026 : l'ancienne H1 (« n'est pas de 100 g »)
   * se lisait à l'envers de l'exemple politique.
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
      <div class="dhy-tete"><span class="dhy-h">H1</span><span class="dhy-nom">· ce qu’on veut prouver</span></div>
      <p class="dhy-ex">Mes pommes pèsent plus de {POMMES.h0}&#8239;g.</p>
      <p class="dhy-ex dhy-pol" class:dhy-vu={e >= 1}>L’intérêt pour la politique augmente avec l’âge.</p>
    </div>
    <div class="dhy-carte dhy-nulle">
      <div class="dhy-tete"><span class="dhy-h">H0</span><span class="dhy-nom">· rien de spécial, c’est le hasard</span></div>
      <p class="dhy-ex">Mes pommes pèsent {POMMES.h0}&#8239;g, comme n’importe quelles pommes.</p>
      <p class="dhy-ex dhy-pol" class:dhy-vu={e >= 1}>L’âge et l’intérêt pour la politique ne sont pas liés.</p>
    </div>
  </div>
  <span class="dhy-src">Arel-Bundock (2021, p. 67)</span>
</div>

<style>
  .deux-hyp { display: flex; flex-direction: column; gap: 0.9em; }
  .dhy-cartes { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; }
  .dhy-carte { display: flex; flex-direction: column; gap: 0.7em; padding: 0.9em 1.1em 1.1em; border: 3px solid var(--dk-filet); animation: dhy-monte 0.45s ease-out both; }
  .dhy-carte.dhy-nulle { border-color: var(--dk-encre); border-top: 0.35em solid var(--dk-accent); animation-delay: 0.15s; }
  .dhy-tete { display: flex; align-items: baseline; gap: 0.4em; }
  .dhy-h { font-size: 2.4em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; color: var(--dk-gris); }
  .dhy-nulle .dhy-h { color: var(--dk-accent); }
  .dhy-nom { font-size: 0.9em; font-weight: 600; color: var(--dk-gris); }
  .dhy-nulle .dhy-nom { color: var(--dk-encre); }
  .dhy-ex { margin: 0; font-size: 1em; line-height: 1.4; color: var(--dk-encre); transition: color 0.4s; }
  .dhy-pol { padding-top: 0.6em; border-top: 2px solid var(--dk-filet); opacity: 0; visibility: hidden; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .dhy-pol.dhy-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.5s 0.2s, transform 0.5s 0.2s, visibility 0s; }
  .dhy-ligne { margin: 0.2em 0 0; font-size: 1.25em; font-weight: 600; opacity: 0; visibility: hidden; transition: opacity 0.4s, visibility 0s 0.4s; }
  .dhy-ligne.dhy-vu { opacity: 1; visibility: visible; transition: opacity 0.5s, visibility 0s; }
  .dhy-rouge { color: var(--dk-accent); }
  .dhy-src { font-size: 0.6em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }
  @keyframes dhy-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .dhy-carte { animation: none; }
    .dhy-ex, .dhy-pol, .dhy-pol.dhy-vu, .dhy-ligne, .dhy-ligne.dhy-vu { transition: none; }
    .dhy-pol { transform: none; }
  }
</style>
