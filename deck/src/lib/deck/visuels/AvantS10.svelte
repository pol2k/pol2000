<script>
  /**
   * Avant la séance 10 : l'examen 2 (en classe, sur papier, à livre
   * ouvert), ce qu'il faut préparer (vos notes), et le chapitre Datacamp de
   * la séance 9. Trois tuiles, comme AvantS9. Tout vient de cours.js.
   */
  import { base } from '$app/paths';
  import { DEVOIRS, EVALUATIONS } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen2');
  const dc = DEVOIRS.find((d) => d.seance === 9);
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
</script>

<div class="visuel avant-s10">
  <div class="tuile ex">
    <span class="poids">{ex.poids}&#8239;%</span>
    <strong>{ex.nom}</strong>
    <em>{jour(ex.date)}, {ex.heure}</em>
    <span>En classe, après le cours. Sur papier.</span>
  </div>
  <div class="tuile">
    <svg class="feuille" viewBox="0 0 40 48" aria-hidden="true"><rect x="3" y="3" width="34" height="42" fill="none" stroke="currentColor" stroke-width="3" /><line x1="10" y1="14" x2="30" y2="14" stroke="currentColor" stroke-width="3" /><line x1="10" y1="23" x2="30" y2="23" stroke="currentColor" stroke-width="3" /><line x1="10" y1="32" x2="22" y2="32" stroke="currentColor" stroke-width="3" /></svg>
    <strong>Vos notes</strong>
    <span>À livre ouvert : vos notes personnelles sont permises, aucun appareil. Préparez-les.</span>
  </div>
  <a class="tuile" href={dc.url} target="_blank" rel="noopener">
    <img src="{base}/img/datacamp.png" alt="Datacamp" />
    <strong>Datacamp</strong>
    <span>{dc.cours} · {dc.chapitre}</span>
  </a>
</div>

<style>
  .avant-s10 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 64em; margin: 1.2em auto 0; }
  .tuile { border: 3px solid var(--dk-encre); padding: 1.2em 1.3em; display: flex; flex-direction: column; gap: 0.45em; color: inherit; text-decoration: none; }
  .tuile.ex { border-color: var(--dk-accent); }
  .poids { font-size: 2.4em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
  .poids.gris { color: var(--dk-gris); }
  .tuile strong { font-size: 1.2em; line-height: 1.25; }
  .tuile em { font-style: normal; font-weight: 600; }
  .tuile span:not(.poids) { font-size: 0.82em; color: var(--dk-gris); line-height: 1.35; }
  .tuile img { height: 2.4em; width: auto; align-self: flex-start; }
  .feuille { height: 2.4em; width: auto; color: var(--dk-gris); }
</style>
