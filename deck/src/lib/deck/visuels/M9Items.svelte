<script module>
  /** Les huit énoncés, en français (traduction des libellés de la CES). */
  export const ENONCES = [
    { n: 1, t: 'Je comprends les enjeux politiques les plus importants de ce pays.' },
    { n: 2, t: 'Ce qu’on appelle un compromis en politique, c’est en fait trahir ses principes.' },
    { n: 3, t: 'La plupart des politicien.ne.s ne se soucient pas des gens.' },
    { n: 4, t: 'La plupart des politicien.ne.s sont dignes de confiance.' },
    { n: 5, t: 'Les politicien.ne.s sont le principal problème au Canada.' },
    { n: 6, t: 'Un leader fort au gouvernement est bon pour le Canada, même s’il contourne les règles.' },
    { n: 7, t: 'Le peuple, et non les politicien.ne.s, devrait prendre les décisions les plus importantes.' },
    { n: 8, t: 'La plupart des politicien.ne.s ne se soucient que des intérêts des riches et des puissants.' }
  ];
</script>

<script>
  /**
   * Les huit énoncés de populisme de la CES 2025 (sondage postélectoral,
   * pes25_populism_1 à _8), en français, avec l'échelle de réponse. Les
   * libellés anglais d'origine sont dans src/lib/data/seance9.js (ITEMS).
   *
   *   marquer — numéros d'énoncés à mettre en rouge (l'énoncé retourné, les
   *             deux qui détonnent), avec une courte raison sous chacun
   *   raisons — { n: 'raison' }
   */
  let { marquer = [], raisons = {}, echelle = true } = $props();
</script>

<div class="visuel m9i">
  <ol class="m9i-liste">
    {#each ENONCES as it, i}
      <li class:rouge={marquer.includes(it.n)} style="--i: {i}">
        <span class="m9i-n">pop{it.n}</span>
        <span class="m9i-t">{it.t}{#if raisons[it.n]}<em class="m9i-r">{raisons[it.n]}</em>{/if}</span>
      </li>
    {/each}
  </ol>
  {#if echelle}
    <p class="m9i-echelle">
      <span><b>1</b> fortement en désaccord</span>
      <span><b>2</b> plutôt en désaccord</span>
      <span><b>3</b> ni l’un ni l’autre</span>
      <span><b>4</b> plutôt d’accord</span>
      <span><b>5</b> fortement d’accord</span>
      <span class="nsp"><b>6</b> ne sait pas</span>
    </p>
  {/if}
</div>

<style>
  .m9i { display: flex; flex-direction: column; gap: 0.9em; max-width: 60em; margin: 0.6em auto 0; }
  .m9i-liste { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.3em; }
  .m9i-liste li { display: grid; grid-template-columns: 4.2em 1fr; gap: 0.8em; align-items: baseline; font-size: 0.92em; line-height: 1.3; padding: 0.2em 0; border-bottom: 2px solid var(--dk-filet); animation: m9i-fondu 0.4s both; animation-delay: calc(var(--i) * 0.08s); }
  .m9i-n { font-weight: 700; color: var(--dk-gris); font-size: 0.85em; }
  .m9i-liste li.rouge .m9i-n, .m9i-liste li.rouge .m9i-t { color: var(--dk-accent); }
  .m9i-r { display: block; font-size: 0.8em; font-style: normal; font-weight: 600; color: var(--dk-accent); }
  .m9i-echelle { margin: 0; display: flex; flex-wrap: wrap; gap: 0.5em 1.4em; font-size: 0.72em; color: var(--dk-gris); }
  .m9i-echelle b { color: var(--dk-encre); margin-right: 0.3em; }
  .m9i-echelle .nsp { color: var(--dk-accent); }
  .m9i-echelle .nsp b { color: var(--dk-accent); }
  @keyframes m9i-fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9i-liste li { animation: none; } }
</style>
