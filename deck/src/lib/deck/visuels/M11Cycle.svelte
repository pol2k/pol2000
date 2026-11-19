<script>
  /**
   * Acyclique : l'effet ne revient jamais sur ses pas. Un GOA complet, avec
   * ses rôles écrits sous chaque boîte : l'éducation (X) agit sur l'intérêt
   * pour la politique (Y) directement, et en passant par la lecture des
   * nouvelles (Z1) et les discussions politiques (Z2).
   *
   *   0  le GOA : tout l'effet va de X vers Y, dans un seul sens;
   *   1  on ajoute « l'intérêt pousse à lire les nouvelles » : Z1 → Y → Z1,
   *      la boucle s'allume en rouge et les points y tournent en rond. Ce
   *      n'est plus un GOA;
   *   2  il faut trancher : on retire une des deux flèches de la boucle,
   *      celle qu'on croit la moins importante. Le GOA revient.
   *
   * Schéma, aucune donnée. Même code de couleurs que les règles : X et Y en
   * bleu, la boucle en rouge.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const BLEU = '#2f6db5';
  const LEG = [
    'L’éducation agit sur l’intérêt directement, et par la lecture des nouvelles et les discussions. L’effet va dans un seul sens.',
    'Mais l’intérêt pousse aussi à lire les nouvelles : l’effet tourne en rond. Ce n’est plus un GOA.',
    'Il faut trancher : on garde la flèche qu’on croit la plus importante, et on retire l’autre.'
  ];
  const B = {
    x: { x: 40, y: 250, t: ['Éducation'], r: 'X' },
    y: { x: 1060, y: 250, t: ['Intérêt pour', 'la politique'], r: 'Y' },
    z1: { x: 550, y: 40, t: ['Lecture des', 'nouvelles'], r: 'Z₁' },
    z2: { x: 550, y: 470, t: ['Discussions', 'politiques'], r: 'Z₂' }
  };
  const L = 300, H = 100;
  const XY = 'M 344 300 L 1052 300';
  const XZ1 = 'M 300 246 L 546 124';
  const Z1Y = 'M 854 124 L 1100 246';
  const XZ2 = 'M 300 354 L 546 476';
  const Z2Y = 'M 854 476 L 1100 354';
  const RETOUR = 'M 1220 246 C 1240 40 1000 20 858 70';
  const BOUCLE = 'M 854 124 L 1100 246 L 1220 246 C 1240 40 1000 20 858 70 L 854 124';
  const cycle = $derived(e === 1);
</script>

{#snippet boite(b, cls)}
  <g class="m11y-n {cls}">
    <rect x={b.x} y={b.y} width={L} height={H} />
    {#if b.t.length === 1}
      <text x={b.x + L / 2} y={b.y + 62}>{b.t[0]}</text>
    {:else}
      <text x={b.x + L / 2} y={b.y + 44}>{b.t[0]}</text><text x={b.x + L / 2} y={b.y + 80}>{b.t[1]}</text>
    {/if}
    <text x={b.x + L / 2} y={b.y > 300 ? b.y + H + 36 : b.y - 14} class="m11y-r">{b.r}</text>
  </g>
{/snippet}

<div class="visuel m11y" bind:this={hote} style="--bleu: {BLEU}">
  <svg viewBox="0 0 1400 620" role="img" aria-label="Un GOA : l’éducation, X, agit sur l’intérêt pour la politique, Y, directement, et en passant par la lecture des nouvelles, Z1, et les discussions politiques, Z2. Si l’intérêt pousse aussi à lire les nouvelles, l’effet tourne en rond entre Z1 et Y : ce n’est plus un GOA. Il faut retirer une des deux flèches.">
    <defs>
      {#each [['n', 'var(--dk-encre)'], ['r', 'var(--dk-accent)'], ['b', BLEU]] as [k, c] (k)}
        <marker id="m11y-{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="4.5" markerHeight="4.5" orient="auto"><path d="M0 0 L10 5 L0 10 Z" style="fill: {c}" /></marker>
      {/each}
    </defs>

    <path d={XY} class="m11y-f m11y-b" marker-end="url(#m11y-b)" />
    <path d={XZ1} class="m11y-f" marker-end="url(#m11y-n)" />
    <path d={XZ2} class="m11y-f" marker-end="url(#m11y-n)" />
    <path d={Z2Y} class="m11y-f" marker-end="url(#m11y-n)" />
    <path d={Z1Y} class="m11y-f" class:m11y-rouge={cycle} marker-end="url(#m11y-{cycle ? 'r' : 'n'})" />
    <path d={RETOUR} class="m11y-f m11y-rouge m11y-retour" class:m11y-vu={cycle} marker-end="url(#m11y-r)" />

    {#if !cycle}
      <Flux d={XY} couleur={BLEU} n={5} duree={2.8} r={10} />
      <Flux d={XZ1} n={2} duree={1.6} r={9} />
      <Flux d={Z1Y} n={2} duree={1.6} r={9} />
      <Flux d={XZ2} n={2} duree={1.6} r={9} />
      <Flux d={Z2Y} n={2} duree={1.6} r={9} />
    {:else}
      <Flux d={BOUCLE} rouge n={6} duree={4} r={10} />
    {/if}

    {@render boite(B.x, 'm11y-xy')}
    {@render boite(B.y, 'm11y-xy')}
    {@render boite(B.z1, cycle ? 'm11y-zr' : '')}
    {@render boite(B.z2, '')}

    <g class="m11y-boucle" class:m11y-vu={cycle}>
      <text x="1200" y="40" class="m11y-cy">une boucle</text>
    </g>
  </svg>
  <p class="m11y-legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="m11y-cap">Schéma, aucune donnée</p>
</div>

<style>
  .m11y { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 58vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .m11y-f { fill: none; stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.6s, opacity 0.6s; }
  .m11y-f.m11y-b { stroke: var(--bleu); }
  .m11y-f.m11y-rouge { stroke: var(--dk-accent); }
  .m11y-retour { opacity: 0; }
  .m11y-retour.m11y-vu { opacity: 1; }
  .m11y-n rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.6s, fill 0.6s; }
  .m11y-n text { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.6s; }
  .m11y-n text.m11y-r { font-size: 28px; fill: var(--dk-gris); }
  .m11y-xy rect { stroke: var(--bleu); fill: color-mix(in srgb, var(--bleu) 10%, var(--dk-fond)); }
  .m11y-xy text, .m11y-xy text.m11y-r { fill: var(--bleu); }
  .m11y-zr rect { stroke: var(--dk-accent); }
  .m11y-zr text, .m11y-zr text.m11y-r { fill: var(--dk-accent); }
  .m11y-boucle { opacity: 0; transition: opacity 0.4s; }
  .m11y-boucle.m11y-vu { opacity: 1; }
  .m11y-cy { font-size: 26px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .m11y-legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .m11y-legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .m11y-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11y-f, .m11y-n rect, .m11y-boucle { transition: none; } }
</style>
