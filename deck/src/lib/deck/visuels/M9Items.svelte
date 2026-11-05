<script module>
  /** Les cinq questions de la CES 2025 (sondage de campagne), libellés français
   *  du questionnaire. Les quatre premières mesurent l'appui à l'environnement;
   *  le libre-échange est la question piège, posée dans le même bloc (c1). */
  export const ENONCES = [
    { cle: 'depenses', v: 'env_depenses', t: 'Combien le gouvernement fédéral devrait-il dépenser en environnement ?', r: 'moins · autant · plus' },
    { cle: 'carbone', v: 'env_carbone', t: 'Afin d’aider à réduire les émissions de gaz à effet de serre, le gouvernement fédéral devrait maintenir la taxe sur le carbone.', r: 'de fortement en désaccord à fortement d’accord' },
    { cle: 'pipelines', v: 'env_pipelines', t: 'Le gouvernement fédéral devrait en faire davantage afin d’aider la construction d’oléoducs.', r: 'de fortement en désaccord à fortement d’accord', envers: true },
    { cle: 'emplois', v: 'env_emplois', t: 'Lorsqu’il existe un conflit entre la protection de l’environnement et la création d’emplois, les emplois devraient avoir la priorité.', r: 'de fortement en désaccord à fortement d’accord', envers: true },
    { cle: 'libre_echange', v: 'libre_echange', t: 'Il devrait y avoir plus de libre-échange avec d’autres pays, même si cela nuit à certaines industries au Canada.', r: 'de fortement en désaccord à fortement d’accord', piege: true }
  ];
</script>

<script>
  /**
   * Les cinq questions, avec leur format de réponse. « À l'envers » : être
   * d'accord, c'est être contre l'environnement. Le libre-échange est séparé
   * par un filet : un autre sujet, glissé exprès.
   *
   *   marquer — clés à mettre en rouge, avec une courte raison sous chacune
   *   raisons — { cle: 'raison' }
   */
  let { marquer = [], raisons = {} } = $props();
</script>

<div class="visuel m9i">
  <ol class="m9i-liste">
    {#each ENONCES as it, i}
      <li class:rouge={marquer.includes(it.cle)} class:piege={it.piege} style="--i: {i}">
        <span class="m9i-n">{it.v}{#if it.envers}<em class="m9i-envers">à l’envers</em>{/if}{#if it.piege}<em class="m9i-envers">autre sujet</em>{/if}</span>
        <span class="m9i-t">« {it.t} »<small>{it.r}</small>{#if raisons[it.cle]}<em class="m9i-r">{raisons[it.cle]}</em>{/if}</span>
      </li>
    {/each}
  </ol>
  <p class="m9i-pied">Ne sait pas : NA. Les quatre questions d’accord sont posées à un tiers des répondant.e.s (bloc c1).</p>
</div>

<style>
  .m9i { display: flex; flex-direction: column; gap: 0.6em; max-width: 62em; margin: 0.3em auto 0; }
  .m9i-liste { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; }
  .m9i-liste li { display: grid; grid-template-columns: 10em 1fr; gap: 1em; align-items: baseline; font-size: 0.9em; line-height: 1.3; padding: 0.4em 0; border-bottom: 2px solid var(--dk-filet); animation: m9i-fondu 0.4s both; animation-delay: calc(var(--i) * 0.08s); }
  .m9i-liste li.piege { border-top: 3px solid var(--dk-encre); margin-top: 0.5em; padding-top: 0.6em; }
  .m9i-n { font-weight: 700; color: var(--dk-gris); font-size: 0.85em; display: flex; flex-direction: column; gap: 0.15em; }
  .m9i-envers { font-style: normal; font-size: 0.82em; font-weight: 700; color: var(--dk-accent); letter-spacing: 0.06em; text-transform: uppercase; }
  .m9i-t small { display: block; font-size: 0.78em; color: var(--dk-gris); margin-top: 0.15em; }
  .m9i-liste li.rouge .m9i-n, .m9i-liste li.rouge .m9i-t { color: var(--dk-accent); }
  .m9i-r { display: block; font-size: 0.85em; font-style: normal; font-weight: 700; color: var(--dk-accent); margin-top: 0.2em; }
  .m9i-pied { margin: 0.2em 0 0; font-size: 0.75em; color: var(--dk-gris); }
  @keyframes m9i-fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9i-liste li { animation: none; } }
</style>
