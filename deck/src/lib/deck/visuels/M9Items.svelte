<script module>
  /** Les quatre questions de la CES 2025 (sondage de campagne). « court » va sur
   *  la diapo; « t » est le libellé français du questionnaire, mot pour mot,
   *  pour l'annexe. Les deux dernières vont à l'envers : être d'accord, c'est
   *  être contre l'environnement. */
  export const ENONCES = [
    { cle: 'depenses', v: 'env_depenses', court: 'Dépenser plus pour l’environnement', r: 'moins · autant · plus', t: 'Combien le gouvernement fédéral devrait-il dépenser en environnement ?' },
    { cle: 'carbone', v: 'env_carbone', court: 'Garder la taxe carbone', r: 'en désaccord … d’accord', t: 'Afin d’aider à réduire les émissions de gaz à effet de serre, le gouvernement fédéral devrait maintenir la taxe sur le carbone.' },
    { cle: 'pipelines', v: 'env_pipelines', court: 'Aider à construire des oléoducs', r: 'en désaccord … d’accord', envers: true, t: 'Le gouvernement fédéral devrait en faire davantage afin d’aider la construction d’oléoducs.' },
    { cle: 'emplois', v: 'env_emplois', court: 'Les emplois avant l’environnement', r: 'en désaccord … d’accord', envers: true, t: 'Lorsqu’il existe un conflit entre la protection de l’environnement et la création d’emplois, les emplois devraient avoir la priorité.' }
  ];
</script>

<script>
  /**
   * Les quatre questions, en tuiles : un pictogramme, quelques mots, le nom
   * de la variable. « exact » : la liste mot pour mot du questionnaire (annexe).
   */
  let { exact = false } = $props();
</script>

{#if exact}
  <ol class="visuel m9i-exact">
    {#each ENONCES as it}
      <li><b>{it.v}</b><span>« {it.t} »<small>{it.r}{#if it.envers} · à l’envers{/if}</small></span></li>
    {/each}
  </ol>
{:else}
  <div class="visuel m9i">
    {#each ENONCES as it, i}
      <div class="m9i-tuile" class:envers={it.envers} style="--i: {i}">
        <svg viewBox="0 0 120 90" aria-hidden="true">
          {#if it.cle === 'depenses'}
            <circle cx="60" cy="45" r="32" class="m9i-tr" />
            <text x="60" y="60" class="m9i-sym">$</text>
          {:else if it.cle === 'carbone'}
            <path d="M 18 80 L 18 46 L 40 58 L 40 46 L 62 58 L 62 30 L 76 30 L 76 80 Z" class="m9i-tr" />
            <path d="M 70 24 Q 64 12 76 8 Q 88 2 96 12 Q 110 12 106 24 Z" class="m9i-tr pale" />
            <text x="92" y="48" class="m9i-co2">CO₂</text>
          {:else if it.cle === 'pipelines'}
            <rect x="6" y="36" width="108" height="20" class="m9i-tr" />
            {#each [30, 60, 90] as cx}<rect x={cx - 5} y="28" width="10" height="36" class="m9i-plein" />{/each}
            <path d="M 98 64 Q 100 76 104 80 Q 108 76 106 64" class="m9i-plein" />
          {:else}
            <line x1="60" y1="16" x2="60" y2="80" class="m9i-l" />
            <line x1="28" y1="80" x2="92" y2="80" class="m9i-l" />
            <line x1="20" y1="34" x2="100" y2="22" class="m9i-l" />
            <path d="M 20 34 L 8 54 L 32 54 Z" class="m9i-tr" />
            <path d="M 100 22 L 88 42 L 112 42 Z" class="m9i-tr" />
            <path d="M 20 46 L 14 54 L 26 54 Z M 20 38 L 15 46 L 25 46 Z" class="m9i-plein vert" />
            <rect x="93" y="30" width="14" height="10" rx="4" class="m9i-plein" />
          {/if}
        </svg>
        <strong>{it.court}</strong>
        <span class="m9i-r">{it.r}</span>
        <span class="m9i-v">{it.v}</span>
        {#if it.envers}<span class="m9i-tag">⇄ à l’envers</span>{/if}
      </div>
    {/each}
  </div>
{/if}

<style>
  .m9i { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.2em; max-width: 62em; margin: 0.8em auto 0; }
  .m9i-tuile { border: 3px solid var(--dk-encre); padding: 1em 0.9em; display: flex; flex-direction: column; align-items: center; gap: 0.4em; text-align: center; animation: m9i-fondu 0.45s both; animation-delay: calc(var(--i) * 0.12s); }
  .m9i-tuile.envers { border-color: var(--dk-accent); }
  .m9i-tuile svg { width: 70%; height: auto; max-height: 15vh; }
  .m9i-tr { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: round; }
  .m9i-tr.pale { stroke: var(--dk-gris); stroke-width: 3; }
  .m9i-plein { fill: var(--dk-encre); }
  .m9i-plein.vert { fill: var(--dk-gris); }
  .m9i-l { stroke: var(--dk-encre); stroke-width: 4; }
  .m9i-sym { font-family: var(--dk-mono); font-size: 44px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m9i-co2 { font-family: var(--dk-mono); font-size: 16px; font-weight: 700; text-anchor: middle; fill: var(--dk-gris); }
  .m9i-tuile strong { font-size: 1.1em; line-height: 1.25; min-height: 2.5em; }
  .m9i-r { font-size: 0.75em; color: var(--dk-gris); }
  .m9i-v { font-size: 0.8em; font-weight: 700; color: var(--dk-gris); border-top: 2px solid var(--dk-filet); padding-top: 0.35em; width: 100%; }
  .m9i-tag { font-size: 0.75em; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; color: #fff; background: var(--dk-accent); padding: 0.1em 0.5em; }
  .m9i-exact { list-style: none; margin: 0.6em auto 0; padding: 0; max-width: 62em; display: flex; flex-direction: column; }
  .m9i-exact li { display: grid; grid-template-columns: 9em 1fr; gap: 1em; padding: 0.5em 0; border-bottom: 2px solid var(--dk-filet); font-size: 0.92em; line-height: 1.35; }
  .m9i-exact b { color: var(--dk-gris); font-size: 0.85em; }
  .m9i-exact small { display: block; color: var(--dk-gris); font-size: 0.8em; margin-top: 0.15em; }
  @keyframes m9i-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9i-tuile { animation: none; } }
</style>
