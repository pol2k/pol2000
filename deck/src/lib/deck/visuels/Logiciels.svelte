<script>
  /**
   * Le paysage des logiciels d'analyse, en cinq tuiles typographiques :
   * pas de logos de marque à recolorer, les noms suffisent. R est au centre
   * et plus grand, comme dans les decks d'origine. Aucune part de marché
   * n'est dessinée : on n'a pas mesuré ça.
   */
  const AUTRES = [
    ['SPSS', 'payant · menus et clics', 'IBM'],
    ['Stata', 'payant · commandes', 'StataCorp'],
    ['Python', 'gratuit · généraliste', 'tout faire, dont des données'],
    ['Excel', 'payant · le tableur', 'jusqu’à ce que ça casse']
  ];
</script>

<div class="visuel logiciels">
  <div class="tuile" class:r={true}>
    <span class="nom">R</span>
    <span class="quoi">gratuit · libre · fait pour les données</span>
    <span class="qui">1993 · Auckland, puis le monde</span>
  </div>
  {#each AUTRES as [n, q, qui]}
    <div class="tuile">
      <span class="nom">{n}</span>
      <span class="quoi">{q}</span>
      <span class="qui">{qui}</span>
    </div>
  {/each}
</div>

<style>
  .logiciels { display: grid; grid-template-columns: 1.6fr 1fr 1fr; grid-template-rows: 1fr 1fr; gap: 1em; }
  .tuile { border: 2px solid var(--dk-encre); padding: 1em 1em 0.9em; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; gap: 0.25em; }
  .tuile.r { grid-row: 1 / 3; border: 4px solid var(--dk-accent); }
  .nom { font-family: var(--dk-mono); font-size: 2em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; }
  .r .nom { font-size: 7em; color: var(--dk-accent); }
  .quoi { font-size: 0.8em; margin-top: 0.3em; }
  .r .quoi { font-size: 0.95em; font-weight: 600; margin-top: 0.4em; }
  .qui { font-size: 0.68em; color: var(--dk-gris); }
</style>
