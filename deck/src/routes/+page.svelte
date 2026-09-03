<script>
  import { base } from '$app/paths';
  // Une entrée par deck construit. Le site pol2000.com pointe directement sur
  // chaque deck via course_config.json; cette page n'est qu'un relais.
  const DECKS = [
    { chemin: 'seance-1', titre: 'Séance 1 — Introduction et les éléments fondamentaux de la recherche', date: 'jeudi 3 septembre 2026' }
  ];
</script>

<svelte:head><title>POL-2000 · Diapositives</title></svelte:head>

<main>
  <h1>POL-2000 · Méthodologie quantitative</h1>
  <p>Diapositives des séances, automne 2026. <a href="https://pol2000.com">Retour au site du cours</a>.</p>
  <ul>
    {#each DECKS as d}
      <li><a href="{base}/{d.chemin}/">{d.titre}</a> — {d.date}</li>
    {/each}
  </ul>
</main>

<style>
  main { max-width: 40rem; margin: 3rem auto; padding: 0 1.5rem; font-family: var(--police-texte); color: var(--ink); }
  h1 { font-family: var(--police-display); font-weight: 600; }
  a { color: var(--accent); }
</style>
