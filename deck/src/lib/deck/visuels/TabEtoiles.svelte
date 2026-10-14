<script>
  /**
   * Les étoiles : la valeur p, en raccourci. À gauche, le tableau d'article
   * (TabPublie). À droite, l'échelle de la légende, quatre cases, de « pas
   * d'étoile » à « *** ». Les seuils sont ceux de R (Signif. codes) et de la
   * plupart des revues.
   *
   *   0  Le tableau, les étoiles en rouge.
   *   1  L'échelle de la légende : plus il y a d'étoiles, plus p est petite,
   *      moins le hasard seul (H0) explique la pente.
   *   2  Notre pente tombe dans la case *** (p < 0,001; R imprime <2e-16).
   *   3  Le garde-fou : des étoiles ne veulent dire ni « important » ni
   *      « causal ».
   *
   * La valeur p vient de NOTRE.coefs[1].p (src/lib/data/seance7.js). On ne
   * l'écrit pas en entier : elle a 26 zéros après la virgule.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import TabPublie from './TabPublie.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const P = NOTRE.coefs[1].p;
  const CASES = [
    { et: '', seuil: 'p ≥ 0,05', test: (p) => p >= 0.05 },
    { et: '*', seuil: 'p < 0,05', test: (p) => p < 0.05 && p >= 0.01 },
    { et: '**', seuil: 'p < 0,01', test: (p) => p < 0.01 && p >= 0.001 },
    { et: '***', seuil: 'p < 0,001', test: (p) => p < 0.001 }
  ];
  const ICI = CASES.findIndex((c) => c.test(P));
  const ON = [['etoiles'], ['legende'], ['etoiles-gauche_droite'], ['etoiles-gauche_droite']];
</script>

<div class="visuel tab-etoiles" bind:this={hote}>
  <div class="tes-tab"><TabPublie on={ON[e]} /></div>

  <div class="tes-droite">
    <div class="tes-echelle" class:tes-vu={e >= 1}>
      {#each CASES as c, i}
        <div class="tes-case" class:tes-ici={e >= 2 && i === ICI} style="transition-delay: {i * 90}ms">
          <span class="tes-et" class:tes-aucune={!c.et}>{c.et || 'aucune'}</span>
          <span class="tes-seuil">{c.seuil}</span>
          {#if i === ICI}<span class="tes-nous" class:tes-vu={e >= 2}>gauche-droite</span>{/if}
        </div>
      {/each}
      <div class="tes-fleche">
        <span>le hasard peut l’expliquer</span>
        <span class="tes-fl"></span>
        <span>le hasard l’explique mal</span>
      </div>
    </div>
    <p class="tes-garde" class:tes-vu={e >= 3}>*** ≠ important<br />*** ≠ causal</p>
  </div>
</div>

<style>
  .tab-etoiles { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2em; align-items: center; }
  .tes-tab { font-size: 0.92em; }
  .tes-droite { display: flex; flex-direction: column; gap: 1.1em; }

  .tes-echelle { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.5em; }
  .tes-case { position: relative; display: flex; flex-direction: column; align-items: center; gap: 0.2em; padding: 0.6em 0.3em 0.7em; border: 2px solid var(--dk-encre); opacity: 0; transform: translateY(0.4em); transition: opacity 0.35s, transform 0.35s, background-color 0.3s, border-color 0.3s; }
  .tes-vu .tes-case { opacity: 1; transform: none; }
  .tes-et { font-size: 2em; font-weight: 700; line-height: 1; height: 1em; color: var(--dk-encre); }
  .tes-et.tes-aucune { font-size: 0.85em; font-weight: 600; color: var(--dk-gris); padding-top: 0.6em; height: 1.75em; }
  .tes-seuil { font-size: 0.78em; color: var(--dk-gris); white-space: nowrap; }
  .tes-case.tes-ici { background: var(--dk-accent); border-color: var(--dk-accent); }
  .tes-case.tes-ici .tes-et, .tes-case.tes-ici .tes-seuil { color: var(--dk-fond); }
  .tes-nous { position: absolute; top: calc(100% + 0.5em); left: 50%; transform: translateX(-50%); font-size: 0.75em; font-weight: 600; color: var(--dk-accent); white-space: nowrap; opacity: 0; transition: opacity 0.3s; }
  .tes-nous.tes-vu { opacity: 1; }

  .tes-fleche { grid-column: 1 / -1; display: grid; grid-template-columns: auto 1fr auto; align-items: center; gap: 0.6em; margin-top: 2em; font-size: 0.7em; color: var(--dk-gris); opacity: 0; transition: opacity 0.4s 0.4s; }
  .tes-vu .tes-fleche { opacity: 1; }
  .tes-fl { height: 2px; background: var(--dk-gris); position: relative; }
  .tes-fl::after { content: ''; position: absolute; right: -2px; top: -5px; border-left: 10px solid var(--dk-gris); border-top: 6px solid transparent; border-bottom: 6px solid transparent; }

  .tes-garde { margin: 0.4em 0 0; align-self: center; text-align: left; font-size: 1.3em; font-weight: 700; line-height: 1.35; color: var(--dk-accent); border: 3px solid var(--dk-accent); padding: 0.35em 0.8em; visibility: hidden; opacity: 0; transition: opacity 0.35s, visibility 0s 0.35s; }
  .tes-garde.tes-vu { visibility: visible; opacity: 1; transition: opacity 0.35s; }

  @media (prefers-reduced-motion: reduce) {
    .tes-case, .tes-nous, .tes-fleche, .tes-garde { transition: none; transform: none; }
  }
</style>
