<script>
  /**
   * L'équipe, en quatre cadres, comme dans le deck: qui, quel rôle, pour
   * quoi on lui écrit. Au-dessus, la règle du courriel et de Slack.
   */
  import { base } from '$app/paths';
  import { COURS, EQUIPE, LIENS } from '$lib/data/cours.js';
</script>

<div class="equipe">
  <div class="canal">
    <span class="hash">#</span>
    <div>
      <strong>Une question ? Slack d'abord.</strong>
      <span>Le courriel, c'est pour les deux premières semaines et pour les cas particuliers : <a href="mailto:{COURS.enseignant.courriel}">{COURS.enseignant.courriel}</a>.</span>
    </div>
    {#if LIENS.slack}<a class="bouton" href={LIENS.slack} rel="noopener">Rejoindre <span class="fl">→</span></a>{:else}<span class="etiq">invitation à venir</span>{/if}
  </div>
  <div class="cartes">
    {#each EQUIPE as g}
      <div class="carte" class:principal={g.principal}>
        <div class="avatar"><img src="{base}/img/{g.photo}" alt="" /></div>
        <span class="role">{g.role}</span>
        <strong>{g.nom}</strong>
        <span class="pour">{g.pour}</span>
        {#if g.courriel}<a href="mailto:{g.courriel}" class="mail">{g.courriel}</a>{/if}
      </div>
    {/each}
  </div>
  <p class="bas"><strong>Semaines du 8 octobre et du 26 novembre</strong> · rencontres individuelles avec toute l'équipe, pas de cours. Autrement, sur rendez-vous : écrivez-nous.</p>
</div>

<style>
  .equipe { display: flex; flex-direction: column; gap: 0.9rem; }
  .canal { display: flex; align-items: center; gap: 1rem; background: var(--encre); color: var(--fond); padding: 0.9rem 1.2rem; }
  .canal .hash { font-size: 2rem; color: var(--accent-clair); font-weight: 600; line-height: 1; }
  .canal div { display: flex; flex-direction: column; gap: 0.15rem; flex: 1; }
  .canal strong { font-size: 1.05rem; }
  .canal div > span { font-size: 0.8rem; color: var(--gris-2); }
  .canal a { color: var(--accent-clair); }
  .canal .bouton { border-color: var(--fond); color: var(--fond); }
  .canal .bouton:hover { background: var(--fond); color: var(--encre); }
  .canal .etiq { color: var(--accent-clair); }
  .cartes { display: grid; grid-template-columns: 1.3fr 1fr 1fr 1fr; gap: 0.8rem; }
  .carte { border: var(--trait); padding: 1.2rem 1rem; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.25rem; }
  .carte.principal { border-width: 3px; border-color: var(--accent); }
  .avatar { width: 5.4rem; height: 5.4rem; border-radius: 50%; border: 3px solid var(--encre); overflow: hidden; margin-bottom: 0.5rem; }
  .principal .avatar { border-color: var(--accent); }
  .avatar img { width: 100%; height: 100%; object-fit: cover; }
  .role { font-size: 0.62rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--gris); font-weight: 600; }
  .carte strong { font-size: 0.98rem; line-height: 1.2; }
  .pour { font-size: 0.76rem; color: var(--gris); line-height: 1.35; margin-top: 0.2rem; }
  .mail { font-size: 0.72rem; margin-top: 0.4rem; }
  .bas { font-size: 0.82rem; color: var(--gris); }
  .bas strong { color: var(--accent); }
  @media (max-width: 52rem) { .cartes { grid-template-columns: 1fr 1fr; } .canal { flex-wrap: wrap; } }
  @media (max-width: 30rem) { .cartes { grid-template-columns: 1fr; } }
</style>
