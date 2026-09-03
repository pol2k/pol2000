<script>
  /**
   * slides/ — la liste des decks construits. Le site pointe directement sur
   * chaque deck; cette page n'est qu'un relais pour qui tape l'adresse.
   */
  import { base } from '$app/paths';
  import { SEANCES } from '$lib/data/cours.js';
  import Bandeau from '$lib/site/Bandeau.svelte';
  import Pied from '$lib/site/Pied.svelte';
  import { longue } from '$lib/site/dates.js';
  const DECKS = SEANCES.filter((s) => s.deck);
</script>

<svelte:head><title>Diapositives · POL-2000</title></svelte:head>

<Bandeau liens={[{ href: `${base}/`, texte: 'Le site', phare: true }]} retour />

<main>
  <p class="sur">POL-2000 · Automne 2026</p>
  <h1>Diapositives</h1>
  <hr class="filet" />
  <ol class="decks">
    {#each DECKS as d}
      <li><a href="{base}/{d.deck}"><span class="n">{d.n}</span><span class="t">{d.titre}</span><span class="d">{longue(d.date)}</span><span class="fl">→</span></a></li>
    {/each}
  </ol>
  <p class="gris petit">Les autres decks paraissent ici au fil de la session.</p>
</main>

<Pied />

<style>
  main { max-width: 52rem; margin: 0 auto; padding: clamp(36px, 7vh, 72px) var(--marge) 0; display: flex; flex-direction: column; gap: 1rem; }
  .sur { font-size: 0.66rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--gris); }
  h1 { font-size: clamp(2.4rem, 6vw, 4.2rem); letter-spacing: -0.05em; line-height: 0.96; }
  .decks { list-style: none; padding: 0; margin: 1rem 0 0; border-top: var(--trait); }
  .decks a { display: grid; grid-template-columns: 3rem minmax(0, 1fr) auto 1.5rem; gap: 1rem; align-items: baseline; padding: 1.1rem 0.4rem; border-bottom: var(--trait-fin); color: var(--encre); text-decoration: none; }
  .decks a:hover { background: var(--fond-2); }
  .n { font-size: 1.8rem; font-weight: 600; color: var(--accent); line-height: 1; }
  .t { font-size: 1rem; font-weight: 600; }
  .d { font-size: 0.7rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--gris); }
  .fl { color: var(--accent); }
</style>
