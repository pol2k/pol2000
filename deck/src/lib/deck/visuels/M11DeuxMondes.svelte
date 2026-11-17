<script>
  /**
   * Le problème fondamental de l'inférence causale, en image (le pont avec
   * la séance 10, reportée par la grève). Le fil du cours : la scolarité et
   * l'intérêt pour la politique (séances 7 et 8). Exemple fictif : Marie
   * n'existe pas, ses chiffres non plus.
   *
   * mode « un » (une personne, deux mondes) :
   *   0  Marie;
   *   1  le monde où elle va à l'université : son intérêt, 7 sur 10, observé;
   *   2  le monde où elle n'y va pas : un « ? » gris, jamais observé;
   *   3  l'effet pour Marie : la différence entre les deux mondes, 7 − ?.
   * mode « deux » (on compare des personnes différentes) :
   *   0  Marie à l'université (7), Julie sans université (4) : un écart de 3;
   *   1  mais Julie n'est pas Marie : d'autres différences apparaissent
   *      autour d'elle (revenu des parents, âge, région). L'écart de 3
   *      mélange l'université et tout le reste.
   *
   * Coordonnées fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  let { mode = 'un' } = $props();
  const TOTAL = mode === 'un' ? 3 : 1;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

{#snippet personne(x, y, nom, rouge = false)}
  <g class="m11d-p" class:rouge>
    <circle cx={x} cy={y - 62} r="34" />
    <path d="M {x - 58} {y + 40} Q {x - 58} {y - 20} {x} {y - 20} Q {x + 58} {y - 20} {x + 58} {y + 40} Z" />
    <text x={x} y={y + 86} class="m11d-nom">{nom}</text>
  </g>
{/snippet}

<div class="visuel m11d" bind:this={hote}>
  <svg viewBox="0 0 1400 560" role="img" aria-label={mode === 'un'
    ? 'Marie, deux mondes. Dans le premier, elle va à l’université et son intérêt pour la politique est de 7 sur 10. Dans le second, elle n’y va pas : on ne le verra jamais. L’effet pour Marie est la différence entre les deux.'
    : 'Marie va à l’université, intérêt 7. Julie n’y va pas, intérêt 4. Mais Julie diffère aussi par le revenu de ses parents, son âge et sa région.'}>
    {#if mode === 'un'}
      {@render personne(150, 300, 'Marie')}

      <!-- monde 1 -->
      <g class="m11d-etape" class:vu={e >= 1}>
        <path d="M 240 270 C 330 270 330 130 420 130" class="m11d-l" />
        <rect x="430" y="80" width="500" height="100" class="m11d-b" />
        <text x="680" y="142" class="m11d-t">va à l’université</text>
        <line x1="930" y1="130" x2="1020" y2="130" class="m11d-l" />
        <rect x="1030" y="80" width="300" height="100" class="m11d-b" />
        <text x="1180" y="142" class="m11d-t">intérêt : 7</text>
      </g>

      <!-- monde 2 -->
      <g class="m11d-etape" class:vu={e >= 2}>
        <path d="M 240 330 C 330 330 330 430 420 430" class="m11d-l m11d-gris" />
        <rect x="430" y="380" width="500" height="100" class="m11d-b m11d-gris" />
        <text x="680" y="442" class="m11d-t m11d-gris-t">n’y va pas</text>
        <line x1="930" y1="430" x2="1020" y2="430" class="m11d-l m11d-gris" />
        <rect x="1030" y="380" width="300" height="100" class="m11d-b m11d-gris" />
        <text x="1180" y="448" class="m11d-t m11d-q">?</text>
        <text x="1180" y="525" class="m11d-petit">jamais observé</text>
      </g>

      <!-- l'effet -->
      <g class="m11d-etape" class:vu={e >= 3}>
        <text x="1180" y="290" class="m11d-effet">effet = 7 − ?</text>
      </g>
    {:else}
      {@render personne(200, 160, 'Marie')}
      {@render personne(200, 430, 'Julie')}
      <line x1="290" y1="140" x2="430" y2="140" class="m11d-l" />
      <line x1="290" y1="410" x2="430" y2="410" class="m11d-l" />
      <line x1="930" y1="140" x2="1030" y2="140" class="m11d-l" />
      <line x1="930" y1="410" x2="1030" y2="410" class="m11d-l" />
      <rect x="430" y="90" width="500" height="100" class="m11d-b" />
      <text x="680" y="152" class="m11d-t">va à l’université</text>
      <rect x="1030" y="90" width="300" height="100" class="m11d-b" />
      <text x="1180" y="152" class="m11d-t">intérêt : 7</text>
      <rect x="430" y="360" width="500" height="100" class="m11d-b" />
      <text x="680" y="422" class="m11d-t">n’y va pas</text>
      <rect x="1030" y="360" width="300" height="100" class="m11d-b" />
      <text x="1180" y="422" class="m11d-t">intérêt : 4</text>
      <text x="1180" y="290" class="m11d-effet" class:barre={e >= 1}>écart = 3</text>

      <g class="m11d-etape" class:vu={e >= 1}>
        {#each [['revenu des parents', 440, 515], ['âge', 770, 515], ['région', 870, 515]] as [t, x, y] (t)}
          <text {x} {y} class="m11d-chip">{t}</text>
        {/each}
        <line x1="1060" y1="282" x2="1300" y2="282" class="m11d-barre" />
      </g>
    {/if}
  </svg>
  <p class="m11d-cap">Exemple fictif</p>
</div>

<style>
  .m11d { display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; max-width: 50em; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .m11d-p circle, .m11d-p path { fill: var(--dk-encre); }
  .m11d-nom { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11d-b { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m11d-l { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .m11d-gris { stroke: var(--dk-gris-2); stroke-dasharray: 12 10; }
  .m11d-t { font-size: 34px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11d-gris-t { fill: var(--dk-gris); }
  .m11d-q { font-size: 56px; fill: var(--dk-gris-2); }
  .m11d-petit { font-size: 24px; text-anchor: middle; fill: var(--dk-gris); }
  .m11d-effet { font-size: 40px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .m11d-chip { font-size: 26px; font-weight: 700; fill: var(--dk-accent); }
  .m11d-barre { stroke: var(--dk-accent); stroke-width: 5; }
  .m11d-etape { opacity: 0; transition: opacity 0.4s; }
  .m11d-etape.vu { opacity: 1; }
  .m11d-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11d-etape { transition: none; } }
</style>
