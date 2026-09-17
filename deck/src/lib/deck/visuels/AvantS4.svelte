<script>
  /**
   * Avant la séance 4 : le chapitre Datacamp de la séance 3 et l'examen 1
   * qui ouvre à la séance 4. Deux tuiles, comme DeuxChoses à la séance 2.
   * Le chapitre et la date viennent de cours.js, comme sur le site : rien
   * n'est recopié à la main.
   */
  import { base } from '$app/paths';
  import { DEVOIRS, EVALUATIONS } from '$lib/data/cours.js';
  const dc = DEVOIRS.find((d) => d.seance === 3);
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
</script>

<div class="visuel avant-s4">
  <a class="tuile" href={dc.url} target="_blank" rel="noopener">
    <img src="{base}/img/datacamp.png" alt="Datacamp" />
    <strong>Datacamp</strong>
    <span>{dc.cours} · {dc.chapitre}</span>
  </a>
  <div class="tuile ex">
    <span class="poids">{ex.poids} %</span>
    <strong>{ex.court} ouvre</strong>
    <span>{jour(ex.ouvre)}</span>
    <em>à remettre {jour(ex.date)}, {ex.heure}</em>
  </div>
</div>

<style>
  .avant-s4 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.4em; max-width: 42em; margin: 0 auto; }
  .tuile { display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; gap: 0.45em; border: 3px solid var(--dk-encre); padding: 1.6em 1.2em 1.4em; color: inherit; text-decoration: none; transition: transform 0.2s, border-color 0.2s; animation: fondu 0.5s both; }
  .tuile:nth-child(2) { animation-delay: 0.15s; border-color: var(--dk-accent); }
  a.tuile:hover { transform: translateY(-0.2em); border-color: var(--dk-accent); }
  .tuile img { width: 6.4em; height: 6.4em; object-fit: contain; border: 2px solid var(--dk-encre); margin-bottom: 0.5em; background: #fff; }
  .poids { font-size: 3.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); margin-bottom: 0.2em; }
  .tuile strong { font-size: 1.5em; }
  .tuile span:not(.poids) { font-size: 0.85em; color: var(--dk-gris); line-height: 1.4; }
  .tuile em { margin-top: 0.4em; font-size: 0.72em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
</style>
