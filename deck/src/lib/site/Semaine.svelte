<script>
  /**
   * « Cette semaine »: ce qui compte maintenant, calculé d'après la date.
   * La prochaine séance, ce qu'il faut apporter, les remises à moins de
   * trois semaines, et l'avancement de la session. Prérendu à la date de
   * la construction, recalculé dans le navigateur au chargement.
   */
  import { base } from '$app/paths';
  import { COURS, SEANCES } from '$lib/data/cours.js';
  import { aujourdhui, ecart, echeancesProches, longue, moyenne, prochaineSeance, seancesFaites } from './dates.js';

  let ref = $state(aujourdhui());
  $effect(() => { ref = aujourdhui(); });

  const seance = $derived(prochaineSeance(ref));
  const faites = $derived(seancesFaites(ref));
  const echeances = $derived(echeancesProches(ref, 21));
  const dans = $derived(seance ? ecart(seance.date, ref) : null);
  const total = SEANCES.filter((s) => !s.lecture).length;
  const quand = $derived(dans === 0 ? "Aujourd'hui" : dans === 1 ? 'Demain' : dans != null && dans < 7 ? `Dans ${dans} jours` : 'Prochaine séance');
  const lectureProche = $derived(ref < COURS.lecture.a && ecart(COURS.lecture.de, ref) <= 14 && ecart(COURS.lecture.de, ref) >= -4);
</script>

<section class="semaine" aria-label="Cette semaine">
  {#if seance}
    <div class="haut">
      <div class="num">
        <span class="quand">{quand}</span>
        <span class="n">{seance.n}</span>
        <span class="sur">sur {total}</span>
      </div>
      <div class="corps">
        <p class="date">{longue(seance.date)} · {COURS.heures} · {COURS.local}</p>
        <h3>{seance.titre}</h3>
        <p class="resume">{seance.resume}</p>
        {#if seance.note}<p class="note"><span class="etiq">à retenir</span> {seance.note}</p>{/if}
        <div class="actions">
          {#if seance.deck}
            <a class="bouton plein" href="{base}/{seance.deck}">Diapositives <span class="fl">→</span></a>
          {:else}
            <span class="bouton inactif">Diapositives · à venir</span>
          {/if}
          {#if seance.n > 1}<span class="apporte">Apportez l'ordinateur.</span>{/if}
        </div>
      </div>
    </div>
  {:else}
    <div class="haut fin">
      <div class="num"><span class="n">14</span><span class="sur">sur {total}</span></div>
      <div class="corps">
        <h3>La session est terminée.</h3>
        <p class="resume">Merci. Le travail final est attendu le vendredi 18 décembre à 23h59.</p>
      </div>
    </div>
  {/if}

  <div class="bas">
    <div class="avance" aria-label="{faites} séances données sur {total}">
      {#each SEANCES.filter((s) => !s.lecture) as s}
        <i class:fait={s.date < ref} class:on={seance && s.n === seance.n}></i>
      {/each}
      <span>{faites} / {total}</span>
    </div>
    <div class="remises">
      {#if echeances.length}
        <span class="etiq gris">Remises à venir</span>
        {#each echeances as e}
          <a href="#eval-{e.id}" class="remise"><strong>{e.court}</strong><span>{moyenne(e.date)} · {e.heure}</span></a>
        {/each}
      {:else if lectureProche}
        <span class="etiq gris">Semaine de lecture</span><span class="remise"><strong>26 au 30 octobre</strong><span>aucun cours</span></span>
      {:else}
        <span class="etiq gris">Aucune remise dans les trois prochaines semaines</span>
      {/if}
    </div>
  </div>
</section>

<style>
  .semaine { border: 3px solid var(--encre); }
  .haut { display: grid; grid-template-columns: 9.5rem 1fr; }
  .num { display: flex; flex-direction: column; justify-content: center; padding: 1.4rem 1.2rem; border-right: var(--trait); background: var(--encre); color: var(--fond); }
  .quand { font-size: 0.62rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--accent-clair); font-weight: 600; }
  .num .n { font-size: 4.6rem; font-weight: 600; line-height: 1; letter-spacing: -0.05em; margin: 0.1em 0 0; }
  .sur { font-size: 0.68rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--gris-2); }
  .corps { padding: 1.3rem 1.5rem 1.4rem; display: flex; flex-direction: column; gap: 0.5rem; }
  .date { font-size: 0.68rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--accent); font-weight: 600; }
  h3 { font-size: clamp(1.25rem, 2.4vw, 1.7rem); line-height: 1.12; }
  .resume { max-width: var(--mesure); }
  .note { font-size: 0.86rem; color: var(--gris); }
  .actions { display: flex; align-items: center; gap: 1.2rem; flex-wrap: wrap; margin-top: 0.5rem; }
  .apporte { font-size: 0.86rem; font-weight: 600; }
  .bas { display: grid; grid-template-columns: auto 1fr; border-top: var(--trait); align-items: center; }
  .avance { display: flex; gap: 3px; align-items: center; padding: 0.7rem 1.2rem; border-right: var(--trait); }
  .avance i { width: 4px; height: 12px; background: var(--filet); flex: 0 0 auto; }
  .avance i.fait { background: var(--encre); }
  .avance i.on { background: var(--accent); }
  .avance span { margin-left: 0.5rem; font-size: 0.66rem; color: var(--gris); letter-spacing: 0.08em; white-space: nowrap; }
  .remises .etiq { white-space: normal; }
  .remises { display: flex; align-items: center; gap: 1.2rem; flex-wrap: wrap; padding: 0.6rem 1.5rem; }
  .remise { display: flex; flex-direction: column; color: var(--encre); text-decoration: none; line-height: 1.3; }
  .remise strong { font-size: 0.86rem; }
  .remise span { font-size: 0.7rem; color: var(--gris); }
  a.remise:hover strong { color: var(--accent); }
  @media (max-width: 40rem) {
    .haut, .bas { grid-template-columns: 1fr; }
    .num { flex-direction: row; align-items: baseline; gap: 0.8rem; border-right: 0; border-bottom: var(--trait); padding: 0.9rem 1.2rem; }
    .num .n { font-size: 2.6rem; margin: 0; }
    .avance { border-right: 0; border-bottom: var(--trait-fin); }
  }
</style>
