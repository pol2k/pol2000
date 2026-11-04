<script module>
  /** Les dix institutions de la CES 2025 (sondage postélectoral, pes25_conf_inst1 et
   *  pes25_conf_inst2), libellés français du questionnaire. La question : « Quelle
   *  confiance accordez-vous aux institutions suivantes ? » */
  export const ENONCES = [
    { cle: 'fed', t: 'Le gouvernement fédéral' },
    { cle: 'prov', t: 'Votre gouvernement provincial ou territorial' },
    { cle: 'medias', t: 'Les médias' },
    { cle: 'elections', t: 'Élections Canada' },
    { cle: 'tribunaux', t: 'Les tribunaux' },
    { cle: 'religion', t: 'La religion organisée' },
    { cle: 'armee', t: 'Les forces armées' },
    { cle: 'ecoles', t: 'Les écoles publiques' },
    { cle: 'fonction', t: 'La fonction publique' },
    { cle: 'police', t: 'La police' }
  ];
</script>

<script>
  /**
   * Les dix institutions, avec la question et l'échelle de réponse. Les
   * libellés anglais d'origine sont dans src/lib/data/seance9.js (ITEMS).
   *
   *   marquer — clés à mettre en rouge (celle qui détonne), avec une courte
   *             raison sous chacune
   *   raisons — { cle: 'raison' }
   */
  let { marquer = [], raisons = {}, echelle = true } = $props();
</script>

<div class="visuel m9i">
  <p class="m9i-q">« Quelle confiance accordez-vous aux institutions suivantes ? »</p>
  <ol class="m9i-liste">
    {#each ENONCES as it, i}
      <li class:rouge={marquer.includes(it.cle)} style="--i: {i}">
        <span class="m9i-n">conf_{it.cle}</span>
        <span class="m9i-t">{it.t}{#if raisons[it.cle]}<em class="m9i-r">{raisons[it.cle]}</em>{/if}</span>
      </li>
    {/each}
  </ol>
  {#if echelle}
    <p class="m9i-echelle">
      <span><b>1</b> beaucoup</span>
      <span><b>2</b> assez</span>
      <span><b>3</b> peu</span>
      <span><b>4</b> pas du tout</span>
      <span class="nsp"><b>5</b> ne sait pas</span>
    </p>
  {/if}
</div>

<style>
  .m9i { display: flex; flex-direction: column; gap: 0.7em; max-width: 60em; margin: 0.4em auto 0; }
  .m9i-q { margin: 0; font-size: 1.05em; font-weight: 600; }
  .m9i-liste { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: 1fr 1fr; gap: 0.25em 2em; }
  .m9i-liste li { display: grid; grid-template-columns: 7.4em 1fr; gap: 0.6em; align-items: baseline; font-size: 0.92em; line-height: 1.3; padding: 0.25em 0; border-bottom: 2px solid var(--dk-filet); animation: m9i-fondu 0.4s both; animation-delay: calc(var(--i) * 0.06s); }
  .m9i-n { font-weight: 700; color: var(--dk-gris); font-size: 0.82em; }
  .m9i-liste li.rouge .m9i-n, .m9i-liste li.rouge .m9i-t { color: var(--dk-accent); }
  .m9i-r { display: block; font-size: 0.8em; font-style: normal; font-weight: 600; color: var(--dk-accent); }
  .m9i-echelle { margin: 0.3em 0 0; display: flex; flex-wrap: wrap; gap: 0.5em 1.6em; font-size: 0.78em; color: var(--dk-gris); }
  .m9i-echelle b { color: var(--dk-encre); margin-right: 0.3em; }
  .m9i-echelle .nsp { color: var(--dk-accent); }
  .m9i-echelle .nsp b { color: var(--dk-accent); }
  @keyframes m9i-fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9i-liste li { animation: none; } }
</style>
