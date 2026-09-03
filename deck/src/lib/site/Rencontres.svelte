<script>
  /**
   * Rencontres individuelles: l'agenda de rendez-vous Google de l'enseignant,
   * incrusté tel quel. Les plages ouvertes s'y réservent sans intermédiaire;
   * l'enseignant les ouvre depuis son agenda. Même adresse que sur le site
   * de FAS1001. Si le lien est vide, la section explique comment écrire.
   */
  import { LIENS, EQUIPE } from '$lib/data/cours.js';
</script>

<div class="rencontres">
  {#if LIENS.rencontres}
    <div class="agenda">
      <iframe src={LIENS.rencontres} title="Prendre rendez-vous" loading="lazy"></iframe>
    </div>
  {:else}
    <p class="cadre">Écrivez à {EQUIPE[0].courriel} pour convenir d'un moment.</p>
  {/if}
</div>

<style>
  .rencontres { display: flex; flex-direction: column; gap: 0.8rem; }
  .agenda { border: var(--trait); background: #fff; }
  iframe { display: block; width: 100%; height: 640px; border: 0; }
  @media (max-width: 46rem) { iframe { height: 560px; } }
</style>
