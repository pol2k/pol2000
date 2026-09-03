<script>
  /**
   * Quatre cadres, quatre outils: R, Positron, Slack, le livre. Un lien
   * chacun; quand il manque, on le dit plutôt que de mener nulle part.
   * Sous les cadres, la règle sur l'IA en trois feux, celle du plan de
   * cours.
   */
  import { base } from '$app/paths';
  import { LIENS } from '$lib/data/cours.js';
  const OUTILS = [
    { k: 'r', nom: 'R', quoi: 'Le langage. Gratuit, sur Windows, macOS et Linux.', lien: LIENS.r, action: 'Télécharger' },
    { k: 'positron', nom: 'Positron', quoi: "L'environnement de travail, par Posit. Là où on écrit le R.", lien: LIENS.positron, action: 'Télécharger' },
    { k: 'slack', nom: 'Slack', quoi: "Un seul endroit pour les questions, pour toute l'équipe, en tout temps.", lien: LIENS.slack, action: 'Rejoindre' },
    { k: 'livre', nom: 'Le livre', quoi: 'Arel-Bundock, Analyse causale et méthodes quantitatives. Référence, non obligatoire, gratuit en PDF.', lien: LIENS.livre, action: 'Lire le PDF' }
  ];
</script>

<div class="outils">
  {#each OUTILS as o}
    <div class="cadre outil {o.k}">
      <div class="visuel">
        {#if o.k === 'r'}<span class="grosR">R</span>
        {:else if o.k === 'positron'}<img src="{base}/img/positron-logo.png" alt="" />
        {:else if o.k === 'slack'}<img src="{base}/img/slack.png" alt="" />
        {:else}<img src="{base}/img/acmq_couverture.png" alt="" class="couv" />{/if}
      </div>
      <h3>{o.nom}</h3>
      <p>{o.quoi}</p>
      {#if o.lien}
        <a class="bouton" href={o.lien} rel="noopener">{o.action} <span class="fl">→</span></a>
      {:else}
        <span class="etiq gris">lien à venir</span>
      {/if}
    </div>
  {/each}
</div>

<div class="ia">
  <div class="feu ok"><span class="signe">✓</span><strong>Permis, à condition de le déclarer</strong><small>Obtenir de l'aide pour écrire, comprendre ou déboguer du code R.</small></div>
  <div class="feu non"><span class="signe">✕</span><strong>Non permis</strong><small>L'interprétation des résultats et la rédaction des travaux. Ce que vous affirmez, vous devez pouvoir le défendre.</small></div>
  <div class="feu selon"><span class="signe">?</span><strong>Selon l'évaluation</strong><small>Chaque évaluation précise ses consignes. La question de base : l'aurais-je accepté d'un assistant humain sans vérifier ?</small></div>
</div>

<style>
  .outils { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.8rem; }
  .outil { display: flex; flex-direction: column; gap: 0.5rem; align-items: flex-start; }
  .visuel { height: 4.2rem; display: flex; align-items: center; margin-bottom: 0.4rem; }
  .visuel img { height: 3.6rem; width: auto; }
  .visuel .couv { height: 4.2rem; border: 2px solid var(--encre); }
  .grosR { font-size: 3.6rem; font-weight: 600; line-height: 1; color: var(--accent); letter-spacing: -0.05em; }
  h3 { font-size: 1.15rem; }
  .outil p { font-size: 0.82rem; color: var(--gris); line-height: 1.45; flex: 1; }
  .ia { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.8rem; margin-top: 2.2rem; }
  .feu { display: flex; flex-direction: column; gap: 0.3rem; padding: 1.1rem 1.2rem; border: var(--trait); }
  .feu.non { border-color: var(--accent); border-width: 3px; }
  .signe { font-size: 2.4rem; font-weight: 600; line-height: 1; margin-bottom: 0.3rem; }
  .feu.non .signe { color: var(--accent); }
  .feu.selon .signe { color: var(--gris); }
  .feu strong { font-size: 0.95rem; line-height: 1.25; }
  .feu small { font-size: 0.78rem; color: var(--gris); line-height: 1.45; }
  @media (max-width: 52rem) { .outils { grid-template-columns: repeat(2, 1fr); } .ia { grid-template-columns: 1fr; } }
  @media (max-width: 30rem) { .outils { grid-template-columns: 1fr; } }
</style>
