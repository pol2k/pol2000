<script>
  /**
   * L'éducation rend-elle plus à droite ? Le GOA de la séance, construit
   * une variable à la fois, avec le code de couleurs des règles (M11Melange) :
   * l'éducation (X) en bleu, ce qui agit sur X et sur Y en rouge,
   * l'idéologie (Y) en violet tant que le rouge s'y mêle, en bleu une fois
   * les contrôles encadrés. Le revenu individuel (sur lequel X agit) reste
   * en encre : on ne l'encadre pas.
   *
   *   0  la question : éducation → idéologie;
   *   1  le revenu des parents agit sur les deux (l'idéologie devient violette);
   *   2  la région agit sur les deux;
   *   3  l'âge agit sur les deux;
   *   4  l'éducation agit sur le revenu individuel, qui agit sur l'idéologie;
   *   5  on encadre les trois variables rouges : leurs flux s'arrêtent au
   *      cadre, l'effet qui arrive à l'idéologie redevient bleu. Le revenu
   *      individuel reste ouvert.
   *
   * D'après Arel-Bundock (2021, p. 116), augmenté à la demande du
   * professeur. La flèche du livre « revenu des parents → revenu
   * individuel » est omise ici pour la lisibilité; elle ne change pas la
   * réponse (GOA.education, vérifié par goa.test.js, la garde). Schéma.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const BLEU = '#2f6db5';
  const VIOLET = '#7a3fa6';
  const LEG = [
    'La question : l’éducation a-t-elle un effet sur l’idéologie ?',
    'Le revenu des parents agit sur l’éducation et sur l’idéologie.',
    'La région aussi.',
    'L’âge aussi.',
    'L’éducation agit sur le revenu individuel, qui agit sur l’idéologie.',
    'On encadre ce qui agit sur l’éducation et sur l’idéologie. Pas le revenu individuel : l’éducation agit sur lui.'
  ];

  // les boîtes (viewBox 1400 × 640)
  const B = {
    parents: { x: 90, y: 40, l: 300, h: 100, t: ['Revenu', 'des parents'] },
    region: { x: 550, y: 40, l: 300, h: 100, t: ['Région'] },
    age: { x: 1010, y: 40, l: 300, h: 100, t: ['Âge'] },
    edu: { x: 40, y: 300, l: 300, h: 100, t: ['Éducation'] },
    ideo: { x: 1060, y: 300, l: 300, h: 100, t: ['Idéologie'] },
    revenu: { x: 550, y: 520, l: 300, h: 100, t: ['Revenu', 'individuel'] }
  };
  // les flèches : tracé, apparition, rouge (vient d'une variable à encadrer)
  const F = [
    { d: 'M 344 350 L 1052 350', vu: 0, sorte: 'xy' },
    { d: 'M 220 144 L 200 292', vu: 1, sorte: 'rouge' },
    { d: 'M 394 120 L 1052 318', vu: 1, sorte: 'rouge' },
    { d: 'M 620 144 L 330 296', vu: 2, sorte: 'rouge' },
    { d: 'M 780 144 L 1070 296', vu: 2, sorte: 'rouge' },
    { d: 'M 1006 120 L 348 318', vu: 3, sorte: 'rouge' },
    { d: 'M 1180 144 L 1200 292', vu: 3, sorte: 'rouge' },
    { d: 'M 290 404 L 552 540', vu: 4, sorte: 'bleu' },
    { d: 'M 854 540 L 1110 404', vu: 4, sorte: 'bleu' }
  ];
  const ctl = $derived(e >= 5);
  const melange = $derived(e >= 1 && !ctl);
  const couleurXY = $derived(melange ? VIOLET : BLEU);
  const marque = (s) => (s === 'rouge' ? 'r' : s === 'bleu' ? 'b' : melange ? 'v' : 'b');
</script>

{#snippet boite(b, cls, vu)}
  <g class="m11e-n {cls}" class:m11e-vu={vu}>
    <rect x={b.x} y={b.y} width={b.l} height={b.h} />
    {#if b.t.length === 1}
      <text x={b.x + b.l / 2} y={b.y + 62}>{b.t[0]}</text>
    {:else}
      <text x={b.x + b.l / 2} y={b.y + 44}>{b.t[0]}</text><text x={b.x + b.l / 2} y={b.y + 80}>{b.t[1]}</text>
    {/if}
  </g>
{/snippet}

<div class="visuel m11e" bind:this={hote} style="--bleu: {BLEU}; --violet: {VIOLET}">
  <svg viewBox="0 0 1400 640" role="img" aria-label="Le GOA de l’éducation et de l’idéologie, construit pas à pas. Le revenu des parents, la région et l’âge agissent sur l’éducation et sur l’idéologie. L’éducation agit aussi sur le revenu individuel, qui agit sur l’idéologie. On contrôle le revenu des parents, la région et l’âge, pas le revenu individuel.">
    <defs>
      {#each [['r', 'var(--dk-accent)'], ['b', BLEU], ['v', VIOLET]] as [k, c] (k)}
        <marker id="m11e-{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="4.5" markerHeight="4.5" orient="auto"><path d="M0 0 L10 5 L0 10 Z" style="fill: {c}" /></marker>
      {/each}
    </defs>

    {#each F as f, i (i)}
      <path d={f.d} class="m11e-f m11e-{f.sorte}" class:m11e-vu={e >= f.vu} class:m11e-eteint={ctl && f.sorte === 'rouge'}
        style={f.sorte === 'xy' ? `stroke: ${couleurXY}` : undefined} marker-end="url(#m11e-{marque(f.sorte)})" />
      {#if f.sorte === 'rouge'}
        <Flux d={f.d} actif={e >= f.vu} rouge n={2} duree={2.4} r={9} arret={ctl ? 0.06 : 1} />
      {:else if f.sorte === 'xy'}
        <Flux d={f.d} couleur={couleurXY} n={5} duree={2.8} r={10} />
      {:else}
        <Flux d={f.d} actif={e >= f.vu} couleur={BLEU} n={2} duree={2} r={9} />
      {/if}
    {/each}

    {@render boite(B.parents, 'm11e-z', e >= 1)}
    {@render boite(B.region, 'm11e-z', e >= 2)}
    {@render boite(B.age, 'm11e-z', e >= 3)}
    {@render boite(B.edu, 'm11e-x', true)}
    {@render boite(B.ideo, melange ? 'm11e-mel' : 'm11e-x', true)}
    {@render boite(B.revenu, 'm11e-ind', e >= 4)}

    {#each [B.parents, B.region, B.age] as b, i (i)}
      <rect x={b.x - 14} y={b.y - 14} width={b.l + 28} height={b.h + 28} class="m11e-cadre" class:m11e-vu={ctl} style="transition-delay: {i * 0.2}s" />
    {/each}
    <text x="210" y="452" class="m11e-l m11e-lx">X</text>
    <text x="1210" y="452" class="m11e-l" style="fill: {melange ? VIOLET : BLEU}">Y</text>
  </svg>
  <p class="m11e-legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="m11e-cap">D’après Arel-Bundock (2021), p. 116, augmenté · schéma, aucune donnée</p>
</div>

<style>
  .m11e { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 60vh; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .m11e-f { fill: none; stroke-width: 5; opacity: 0; transition: opacity 0.6s, stroke 0.8s; }
  .m11e-f.m11e-vu { opacity: 1; }
  .m11e-f.m11e-rouge { stroke: var(--dk-accent); }
  .m11e-f.m11e-bleu { stroke: var(--bleu); }
  .m11e-f.m11e-vu.m11e-eteint { opacity: 0.22; }

  .m11e-n { opacity: 0; transform: translateY(10px); transition: opacity 0.5s, transform 0.5s; }
  .m11e-n.m11e-vu { opacity: 1; transform: none; }
  .m11e-n rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.8s, fill 0.8s; }
  .m11e-n text { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.8s; }
  .m11e-z rect { stroke: var(--dk-accent); fill: color-mix(in srgb, var(--dk-accent) 7%, var(--dk-fond)); }
  .m11e-z text { fill: var(--dk-accent); }
  .m11e-x rect { stroke: var(--bleu); fill: color-mix(in srgb, var(--bleu) 10%, var(--dk-fond)); }
  .m11e-x text { fill: var(--bleu); }
  .m11e-mel rect { stroke: var(--violet); fill: color-mix(in srgb, var(--violet) 12%, var(--dk-fond)); }
  .m11e-mel text { fill: var(--violet); }
  .m11e-ind rect { stroke: var(--dk-encre); }
  .m11e-ind text { fill: var(--dk-encre); }

  .m11e-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 8; opacity: 0; transition: opacity 0.4s; }
  .m11e-cadre.m11e-vu { opacity: 1; }
  .m11e-l { font-size: 30px; font-weight: 700; text-anchor: middle; transition: fill 0.8s; }
  .m11e-lx { fill: var(--bleu); }

  .m11e-legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .m11e-legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .m11e-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11e-f, .m11e-n, .m11e-cadre { transition: none; transform: none; } }
</style>
