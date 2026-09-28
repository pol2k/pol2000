<script>
  /**
   * Avant la séance 7 : l'examen 1 à remettre le dimanche 4 octobre, les
   * rencontres individuelles de la séance 6 (pas de cours) et le chapitre
   * Datacamp de la séance 5. Trois tuiles, comme AvantS5.
   * Tout vient de cours.js, comme sur le site : rien n'est recopié à la main.
   */
  import { base } from '$app/paths';
  import { DEVOIRS, EVALUATIONS, LIENS, SEANCES } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  const rv = SEANCES.find((s) => s.n === 6);
  const dc = DEVOIRS.find((d) => d.seance === 5);
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
</script>

<div class="visuel avant-s7">
  <div class="tuile ex">
    <span class="poids">{ex.poids}&#8239;%</span>
    <strong>{ex.court}</strong>
    <em>à remettre {jour(ex.date)}, {ex.heure}</em>
  </div>
  <a class="tuile" href={LIENS.rencontres} target="_blank" rel="noopener">
    <span class="date">{new Date(rv.date + 'T12:00:00').getDate()}</span>
    <strong>{rv.titre}</strong>
    <span>{jour(rv.date)} · pas de cours</span>
    <em>prendre rendez-vous</em>
  </a>
  <a class="tuile" href={dc.url} target="_blank" rel="noopener">
    <img src="{base}/img/datacamp.png" alt="Datacamp" />
    <strong>Datacamp</strong>
    <span>{dc.cours} · {dc.chapitre}</span>
  </a>
</div>

<style>
  .avant-s7 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 60em; margin: 0 auto; }
  .tuile { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; gap: 0.45em; border: 3px solid var(--dk-encre); padding: 1.6em 1.2em 1.4em; color: inherit; text-decoration: none; transition: transform 0.2s, border-color 0.2s; animation: fondu 0.5s both; }
  .tuile:nth-child(2) { animation-delay: 0.15s; }
  .tuile:nth-child(3) { animation-delay: 0.3s; }
  .tuile.ex { border-color: var(--dk-accent); }
  a.tuile:hover { transform: translateY(-0.2em); border-color: var(--dk-accent); }
  .tuile img { width: 6.4em; height: 6.4em; object-fit: contain; border: 2px solid var(--dk-encre); margin-bottom: 0.5em; background: #fff; }
  .poids, .date { font-size: 3.4em; font-weight: 600; line-height: 1; margin-bottom: 0.2em; }
  .poids { color: var(--dk-accent); }
  .tuile strong { font-size: 1.3em; }
  .tuile span:not(.poids):not(.date) { font-size: 0.85em; color: var(--dk-gris); line-height: 1.4; }
  .tuile em { margin-top: 0.4em; font-size: 0.72em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tuile { animation: none; transition: none; }
  }
</style>
