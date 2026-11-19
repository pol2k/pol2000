<script>
  /**
   * Règle 2 : contrôler les variables qui ont un effet sur X et sur Y. Le
   * code de couleurs du professeur : X en bleu, Z en rouge, Y en violet
   * (le mélange du bleu et du rouge). L'exemple du cours : le revenu des
   * parents (Z) agit sur l'éducation (X) et sur l'idéologie (Y).
   *
   *   0  Z envoie son effet, en rouge, vers X et vers Y. Ce qui va de X à Y
   *      est violet : l'effet de X et celui de Z, mélangés. Y est violet.
   *      Le réservoir de l'effet mesuré déborde : 175 %, il y a trop;
   *   1  on contrôle Z : il est encadré, ses points rouges s'arrêtent à son
   *      cadre. Ce qui va de X à Y devient bleu, Y devient bleu, le
   *      réservoir redescend à 100 % : seulement l'effet de X.
   *
   * Même facture que M11Debit (règle 1), qui coupe trop; ici, sans
   * contrôle, on mesure trop. Schéma, aucune donnée : 175 % est une
   * convention.
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

  const BLEU = '#2f6db5';
  const VIOLET = '#7a3fa6';
  const Z_X = 'M 600 150 L 290 372';
  const Z_Y = 'M 800 150 L 1110 372';
  const X_Y = 'M 350 430 L 966 430';
  const LEG = [
    'Le revenu des parents agit sur l’éducation et sur l’idéologie. Entre X et Y, on voit un mélange : l’effet de X et celui de Z.',
    'On contrôle le revenu des parents : il ne reste que l’effet de l’éducation sur l’idéologie.'
  ];
  const ctl = $derived(e >= 1);
</script>

<div class="visuel m11m" bind:this={hote} style="--bleu: {BLEU}; --violet: {VIOLET}">
  <svg viewBox="0 0 1400 560" role="img" aria-label="Le revenu des parents, en rouge, agit sur l’éducation, en bleu, et sur l’idéologie. Sans contrôle, ce qui va de l’éducation à l’idéologie est violet, un mélange, et l’effet mesuré déborde à 175 %. Quand on contrôle le revenu des parents, ses flèches s’arrêtent, l’effet devient bleu et l’effet mesuré revient à 100 %.">
    <defs>
      {#each [['r', 'var(--dk-accent)'], ['v', VIOLET], ['b', BLEU]] as [k, c] (k)}
        <marker id="m11m-p{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 L10 5 L0 10 Z" style="fill: {c}" /></marker>
      {/each}
    </defs>

    <!-- les flèches -->
    <path d={Z_X} class="m11m-f m11m-rouge" class:m11m-eteint={ctl} marker-end="url(#m11m-pr)" />
    <path d={Z_Y} class="m11m-f m11m-rouge" class:m11m-eteint={ctl} marker-end="url(#m11m-pr)" />
    <path d={X_Y} class="m11m-f" style="stroke: {ctl ? BLEU : VIOLET}" marker-end="url(#m11m-p{ctl ? 'b' : 'v'})" />

    <Flux d={Z_X} rouge n={3} duree={2.2} r={11} arret={ctl ? 0.04 : 1} />
    <Flux d={Z_Y} rouge n={3} duree={2.2} r={11} arret={ctl ? 0.04 : 1} />
    <Flux d={X_Y} couleur={ctl ? BLEU : VIOLET} n={5} duree={2.6} r={11} />

    <!-- les variables -->
    <g class="m11m-n m11m-z">
      <rect x="540" y="50" width="320" height="100" />
      <text x="700" y="96">Revenu</text><text x="700" y="130">des parents</text>
      <text x="488" y="112" class="m11m-l">Z</text>
    </g>
    <g class="m11m-cadre" class:m11m-vu={ctl}>
      <rect x="524" y="34" width="352" height="132" />
      <text x="890" y="110" class="m11m-ctl">contrôlé</text>
    </g>
    <g class="m11m-n m11m-x">
      <rect x="90" y="380" width="260" height="100" />
      <text x="220" y="442">Éducation</text>
      <text x="220" y="522" class="m11m-l">X</text>
    </g>
    <g class="m11m-n m11m-y" class:m11m-pur={ctl}>
      <rect x="970" y="380" width="260" height="100" />
      <text x="1100" y="442">Idéologie</text>
      <text x="1100" y="522" class="m11m-l">Y</text>
    </g>

    <!-- le réservoir de l'effet mesuré -->
    <g class="m11m-res">
      <text x="1320" y="60" class="m11m-ttl">effet</text>
      <text x="1320" y="88" class="m11m-ttl">mesuré</text>
      <rect x="1280" y="110" width="80" height="360" class="m11m-cuve" />
      <rect x="1280" y="110" width="80" height="360" class="m11m-eau" style="transform: scaleY({ctl ? 1 / 1.75 : 1}); fill: {ctl ? BLEU : VIOLET}" />
      <line x1="1266" y1="264" x2="1374" y2="264" class="m11m-cent" />
      <text x="1320" y="520" class="m11m-pct" style="fill: {ctl ? BLEU : VIOLET}">{ctl ? 100 : 175}&#8239;%</text>
    </g>
  </svg>
  <p class="m11m-legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="m11m-cap">Schéma, aucune donnée · 175&#8239;%, comme la simulation de la diapo suivante</p>
</div>

<style>
  .m11m { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 58vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .m11m-f { fill: none; stroke-width: 6; transition: stroke 0.8s, opacity 0.8s; }
  .m11m-f.m11m-rouge { stroke: var(--dk-accent); }
  .m11m-f.m11m-eteint { opacity: 0.25; }

  .m11m-n rect { fill: var(--dk-fond); stroke-width: 5; transition: stroke 0.8s, fill 0.8s; }
  .m11m-n text { font-size: 32px; font-weight: 700; text-anchor: middle; transition: fill 0.8s; }
  .m11m-n text.m11m-l { font-size: 28px; }
  .m11m-z rect { stroke: var(--dk-accent); }
  .m11m-z text { fill: var(--dk-accent); }
  .m11m-x rect { stroke: var(--bleu); fill: color-mix(in srgb, var(--bleu) 10%, var(--dk-fond)); }
  .m11m-x text { fill: var(--bleu); }
  .m11m-y rect { stroke: var(--violet); fill: color-mix(in srgb, var(--violet) 12%, var(--dk-fond)); }
  .m11m-y text { fill: var(--violet); }
  .m11m-y.m11m-pur rect { stroke: var(--bleu); fill: color-mix(in srgb, var(--bleu) 10%, var(--dk-fond)); }
  .m11m-y.m11m-pur text { fill: var(--bleu); }

  .m11m-cadre { opacity: 0; transition: opacity 0.4s; }
  .m11m-cadre.m11m-vu { opacity: 1; }
  .m11m-cadre rect { fill: none; stroke: var(--dk-accent); stroke-width: 9; }
  .m11m-ctl { font-size: 26px; font-weight: 700; fill: var(--dk-accent); }

  .m11m-ttl { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11m-cuve { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .m11m-eau { transform-box: fill-box; transform-origin: bottom; transition: transform 1.4s cubic-bezier(0.4, 0, 0.2, 1) 0.6s, fill 0.8s; }
  .m11m-cent { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 8 6; }
  .m11m-pct { font-size: 44px; font-weight: 700; text-anchor: middle; transition: fill 0.8s; }

  .m11m-legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .m11m-legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .m11m-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11m-eau, .m11m-cadre, .m11m-f, .m11m-n rect, .m11m-n text { transition: none; } }
</style>
