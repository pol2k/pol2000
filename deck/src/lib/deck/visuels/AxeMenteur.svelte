<script>
  /**
   * Un axe qui ment, sur de vraies moyennes : l'âge moyen des personnes qui
   * comptent voter libéral et conservateur (Étude électorale canadienne
   * 2025, src/lib/data/seance3.js).
   *
   *   0  L'axe part de 0 : deux barres presque pareilles.
   *   1  Le plancher de l'axe monte à 48 : les barres s'étirent, la
   *      libérale paraît plusieurs fois plus haute. Mêmes chiffres.
   *
   * Les graduations glissent avec l'axe : celles qui sortent s'effacent.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { AGE_PARTIS } from '$lib/data/seance3.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 1,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  const BARRES = [
    { nom: 'Libéral', v: AGE_PARTIS[0].moyenne, c: '#d71920', x: 190 },
    { nom: 'Conservateur', v: AGE_PARTIS[1].moyenne, c: '#1a4782', x: 400 }
  ];
  const LARGE = 150;
  const W = 640, H = 420, X0 = 110, Y0 = 350, Y1 = 40, HAUT = 54;
  const PLANCHERS = [0, 48];
  const TICKS = [[0, 10, 20, 30, 40, 50], [48, 50, 52, 54]];
  const TOUS = [0, 10, 20, 30, 40, 48, 50, 52, 54];

  const f = $derived(PLANCHERS[e]);
  const k = (v, fl) => Math.max(0, (v - fl) / (HAUT - fl));
  const ty = (v, fl) => Y0 - ((v - fl) / (HAUT - fl)) * (Y0 - Y1);
  const ans = (v) => `${v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 })} ans`;
</script>

<div class="visuel axe-m" bind:this={hote}>
  {#key tour}
    <svg viewBox="0 0 {W} {H}" role="img" aria-label="Âge moyen : 52,6 ans chez les libéraux, 49,7 ans chez les conservateurs. Avec un axe qui part de 0, les barres sont presque égales ; avec un axe qui part de 48, la barre libérale paraît plusieurs fois plus haute.">
      <text transform="translate(28 {(Y0 + Y1) / 2}) rotate(-90)" class="lab">Âge moyen</text>
      {#each TOUS as t}
        {@const vis = TICKS[e].includes(t)}
        <g class="tick" class:vis class:plancher={e === 1 && t === 48} style="transform: translateY({ty(t, f)}px)">
          <path d="M {X0 - 10} 0 L {X0} 0" class="axe" />
          <text x={X0 - 16} y="6">{t}</text>
        </g>
      {/each}

      {#each BARRES as b, i}
        <g class="pousse" style="--i: {i}">
          <rect x={b.x} y={Y1} width={LARGE} height={Y0 - Y1} fill={b.c} class="barre" style="transform: scaleY({k(b.v, f)})" />
        </g>
        <text x={b.x + LARGE / 2} y={Y1 - 12} class="val" style="transform: translateY({(1 - k(b.v, f)) * (Y0 - Y1)}px)">{ans(b.v)}</text>
        <text x={b.x + LARGE / 2} y={Y0 + 36} class="nom" fill={b.c}>{b.nom}</text>
      {/each}

      <path d="M {X0} {Y1 - 14} L {X0} {Y0} L {W - 20} {Y0}" class="axe" />
    </svg>
  {/key}

  <div class="verdict">
    {#key `${tour}-${e}`}
      {#if e === 0}
        <div class="tag ok"><span class="signe">✓</span><span>l’axe part de 0</span></div>
      {:else}
        <div class="tag faux"><span class="signe">✗</span><span>l’axe part de 48</span></div>
      {/if}
    {/key}
  </div>

  <p class="legende">Mêmes données · Étude électorale canadienne 2025</p>
</div>

<style>
  .axe-m { display: grid; grid-template-columns: 1.5fr 1fr; gap: 0.6em 1.8em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .lab { font-size: 18px; text-anchor: middle; fill: var(--dk-encre); }

  .tick {
    opacity: 0;
    transition: transform 1s cubic-bezier(0.65, 0, 0.35, 1), opacity 0.5s;
  }
  .tick.vis { opacity: 1; }
  .tick text { font-size: 19px; text-anchor: end; fill: var(--dk-gris); transition: fill 0.4s; }
  .tick.plancher text { fill: var(--dk-accent); font-weight: 600; font-size: 22px; }

  .pousse {
    transform-box: fill-box;
    transform-origin: bottom;
    animation: monte 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) backwards;
    animation-delay: calc(var(--i) * 140ms + 100ms);
  }
  .barre {
    transform-box: fill-box;
    transform-origin: bottom;
    transition: transform 1s cubic-bezier(0.34, 1.3, 0.64, 1);
  }
  .val {
    font-size: 22px;
    font-weight: 600;
    text-anchor: middle;
    fill: var(--dk-encre);
    transition: transform 1s cubic-bezier(0.34, 1.3, 0.64, 1);
  }
  .nom { font-size: 21px; font-weight: 600; text-anchor: middle; }

  .verdict { display: flex; justify-content: center; }
  .tag {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.2em;
    padding: 0.7em 1.1em 0.9em;
    border: 4px solid var(--dk-encre);
    font-size: 1.1em;
    font-weight: 600;
    text-align: center;
  }
  .signe { font-size: 3.2em; line-height: 1; }
  .ok { animation: fondu 0.5s ease-out backwards; }
  .faux {
    color: var(--dk-accent);
    border-color: var(--dk-accent);
    transform: rotate(-6deg);
    animation: tampon 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) 0.8s backwards;
  }

  .legende { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes monte { from { transform: scaleY(0); } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.5em); } }
  @keyframes tampon { from { opacity: 0; transform: scale(2.6) rotate(-16deg); } }

  @media (prefers-reduced-motion: reduce) {
    .tick, .pousse, .barre, .val, .ok, .faux { animation: none !important; transition: none !important; }
  }
</style>
