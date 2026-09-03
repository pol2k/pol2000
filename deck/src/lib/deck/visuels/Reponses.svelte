<script>
  /**
   * Comment répondre à la question ? Six façons, en cercle, chacune avec son
   * glyphe. Un clic en allume une; le dernier temps ne garde que celle du
   * cours: compter, avec des données. Les autres ne sont pas fausses — elles
   * répondent à autre chose.
   */
  import { brancherTemps } from '../temps.js';

  const VOIES = [
    { k: 'voxpop', t: 'Un vox pop', s: 'dix personnes, un micro' },
    { k: 'articles', t: 'Lire ce qui est écrit', s: 'journaux, essais, chroniques' },
    { k: 'entrevues', t: 'Des entrevues', s: 'longues, en profondeur' },
    { k: 'opinion', t: 'Demander autour de soi', s: 'sa famille, ses ami.e.s' },
    { k: 'experts', t: 'Écouter les experts', s: 'ils ont sûrement un avis' },
    { k: 'compter', t: 'Compter', s: 'des milliers de personnes, des chiffres' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: VOIES.length, lire: () => e, ecrire: (v) => (e = v) });
  });
  const CX = 480, CY = 215, R = 150;
  // les rayons s'arrêtent à 92 px du centre, pour ne pas barrer le mot
  const stop = (i) => { const dx = CX - px(i), dy = CY - py(i), d = Math.hypot(dx, dy); return { x: dx - (dx / d) * 92, y: dy - (dy / d) * 92 }; };
  const ang = (i) => -Math.PI / 2 + (i / VOIES.length) * 2 * Math.PI;
  const px = (i) => CX + R * Math.cos(ang(i)) * 1.9;
  const py = (i) => CY + R * Math.sin(ang(i));
  const final = $derived(e >= VOIES.length);
</script>

<div class="visuel reponses" bind:this={hote}>
  <svg viewBox="0 0 960 460" role="img" aria-label="Six façons de répondre à une question, en cercle; à la fin, seule « compter » reste allumée.">
    <text x={CX} y={CY + 10} class="centre" class:pale={final}>La question</text>
    {#each VOIES as v, i}
      {@const on = final ? v.k === 'compter' : e === i + 1}
      {@const off = final && v.k !== 'compter'}
      <g class="voie" class:on class:off style="transform: translate({px(i)}px, {py(i)}px)">
        <line x1={stop(i).x} y1={stop(i).y} x2="0" y2="0" class="lien" />
        <circle r="44" class="disque" />
        <g class="glyphe">
          {#if v.k === 'voxpop'}
            <rect x="-6" y="-20" width="12" height="26" rx="6" /><line x1="0" y1="6" x2="0" y2="18" /><line x1="-10" y1="18" x2="10" y2="18" />
          {:else if v.k === 'articles'}
            <rect x="-18" y="-16" width="36" height="32" /><line x1="-11" y1="-7" x2="11" y2="-7" /><line x1="-11" y1="0" x2="11" y2="0" /><line x1="-11" y1="7" x2="4" y2="7" />
          {:else if v.k === 'entrevues'}
            <circle cx="-11" cy="-8" r="7" /><circle cx="11" cy="-8" r="7" /><path d="M -22 16 q 11 -14 22 0 q 11 -14 22 0" />
          {:else if v.k === 'opinion'}
            <path d="M -18 -14 h 26 v 18 h -14 l -8 8 v -8 h -4 z" /><path d="M 2 -4 h 18 v 14 h -4 v 6 l -7 -6 h -7 z" />
          {:else if v.k === 'experts'}
            <circle cx="0" cy="-10" r="8" /><path d="M -16 18 q 16 -22 32 0" /><rect x="-14" y="-24" width="28" height="4" />
          {:else}
            <rect x="-18" y="-16" width="9" height="32" /><rect x="-4" y="-6" width="9" height="22" /><rect x="10" y="-22" width="9" height="38" />
          {/if}
        </g>
        <text y="66" class="t">{v.t}</text>
        <text y="84" class="s">{v.s}</text>
      </g>
    {/each}
  </svg>
</div>

<style>
  .reponses { width: 100%; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  .centre { font-family: var(--dk-mono); font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.5s; }
  .centre.pale { opacity: 0.25; }
  .voie { transition: opacity 0.5s; }
  .voie.off { opacity: 0.18; }
  .lien { stroke: var(--dk-filet); stroke-width: 2; }
  .disque { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: fill 0.4s, stroke 0.4s; }
  .voie.on .disque { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .glyphe * { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: round; stroke-linecap: round; transition: stroke 0.4s; }
  .voie.on .glyphe * { stroke: var(--dk-fond); }
  .t { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .voie.on .t { fill: var(--dk-accent); }
  .s { font-family: var(--dk-mono); font-size: 13px; text-anchor: middle; fill: var(--dk-gris); }
</style>
