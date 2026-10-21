<script>
  /**
   * L'exercice de l'atelier : quatre gestes, la même recette que
   * l'exemple, avec une autre variable dépendante (la satisfaction envers
   * la démocratie, recodée à la séance 4). Pas de temps.
   */
  const GESTES = [
    ['Recodez', 'cps25_demsat, de 0 à 1, comme à la séance 4'],
    ['Modélisez', 'les mêmes cinq variables que modele3'],
    ['Comparez', 'un tableau, modele3 et le vôtre côte à côte'],
    ['Écrivez', 'une phrase pour « femme », une pour « Québec »']
  ];
</script>

<div class="visuel m8av">
  <ol>
    {#each GESTES as g, i}
      <li style="--i: {i}"><span class="n">{i + 1}</span><span><strong>{g[0]}</strong> <span class="dit">{g[1]}</span></span></li>
    {/each}
  </ol>
  <p class="minutes">10 minutes · à deux, c’est permis</p>
</div>

<style>
  .m8av { max-width: 50em; margin: 0.8em auto 0; }
  ol { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.7em; }
  li { display: grid; grid-template-columns: 2.2em 1fr; align-items: baseline; gap: 0.6em; font-size: 1.25em; border-top: 2px solid var(--dk-filet); padding-top: 0.5em; animation: m8av-f 0.4s both; animation-delay: calc(var(--i) * 0.12s); }
  .n { font-size: 1.5em; font-weight: 600; color: var(--dk-accent); }
  .dit { color: var(--dk-gris); }
  .minutes { margin: 1.4em 0 0; display: inline-block; background: var(--dk-encre); color: var(--dk-fond); padding: 0.4em 0.9em; font-weight: 600; }
  @keyframes m8av-f { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { li { animation: none; } }
</style>
