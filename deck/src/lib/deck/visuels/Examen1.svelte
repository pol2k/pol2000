<script>
  /**
   * L'examen 1 ouvre aujourd'hui. Tout vient de EVALUATIONS dans cours.js,
   * comme sur le site : le poids, l'ouverture, la remise. Aucun contenu
   * d'examen ici.
   */
  import { EVALUATIONS } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  // Deux lignes voulues : le jour de la semaine, puis la date.
  const d = (iso) => new Date(iso + 'T12:00:00');
  const semaine = (iso) => d(iso).toLocaleDateString('fr-CA', { weekday: 'long' });
  const quantieme = (iso) => d(iso).toLocaleDateString('fr-CA', { day: 'numeric', month: 'long' });
</script>

<div class="visuel examen1">
  <div class="boite poids">
    <span class="gros">{ex.poids} %</span>
    <span class="quoi">Individuel</span>
    <span class="quoi">À la maison, sur ordinateur</span>
  </div>
  <div class="boite date">
    <span class="et">OUVRE</span>
    <strong>{semaine(ex.ouvre)}</strong>
    <strong>{quantieme(ex.ouvre)}</strong>
  </div>
  <div class="fl">→</div>
  <div class="boite date rouge">
    <span class="et">À REMETTRE</span>
    <strong>{semaine(ex.date)}</strong>
    <strong>{quantieme(ex.date)}</strong>
    <span class="h">{ex.heure}</span>
  </div>
</div>

<style>
  .examen1 { display: grid; grid-template-columns: auto 1fr auto 1fr; gap: 1.4em 1em; align-items: stretch; max-width: 54em; margin: 0 auto; animation: fondu 0.5s both; }
  .boite { display: flex; flex-direction: column; justify-content: center; gap: 0.3em; border: 3px solid var(--dk-encre); padding: 1em 1.3em; }
  .poids { border-color: var(--dk-accent); margin-right: 1em; }
  .gros { font-size: 3.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); letter-spacing: -0.03em; margin-bottom: 0.15em; }
  .quoi { font-size: 0.9em; font-weight: 600; white-space: nowrap; }
  .date.rouge { border-color: var(--dk-accent); }
  .et { font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-gris); margin-bottom: 0.2em; }
  .date strong { font-size: 1.25em; line-height: 1.2; white-space: nowrap; }
  .h { font-size: 0.9em; font-weight: 600; color: var(--dk-accent); }
  .fl { align-self: center; font-size: 1.8em; font-weight: 600; color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .examen1 { animation: none; } }
</style>
