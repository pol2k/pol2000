<script>
  /**
   * Qui utilise R : des marques que la salle connaît, avec un mot sur ce
   * qu'elles en font. La liste vient du deck FAS1001 (Airbnb, BBC, MLB,
   * Vox Pop Labs, Google, Meta, Amazon) plus le New York Times, dont
   * l'équipe graphique travaille en R. Les logos sont ceux des marques ;
   * BBC et Vox Pop Labs sont en typographie faute de fichier propre.
   */
  import { base } from '$app/paths';
  const O = [
    { img: 'org-airbnb.svg', nom: 'Airbnb', quoi: 'analyse de données à grande échelle' },
    { txt: 'BBC', nom: 'BBC', quoi: 'tous ses graphiques d’actualité' },
    { img: 'org-nyt.png', nom: 'The New York Times', quoi: 'infographies et cartes électorales' },
    { img: 'org-mlb.svg', nom: 'MLB', quoi: 'statistiques du baseball' },
    { txt: 'Vox Pop Labs', nom: 'Vox Pop Labs', quoi: 'la Boussole électorale' },
    { img: 'org-google.svg', nom: 'Google', quoi: 'analyse et prévision' },
    { img: 'org-meta.svg', nom: 'Meta', quoi: 'expérimentation et statistiques' },
    { img: 'org-amazon.svg', nom: 'Amazon', quoi: 'prévision de la demande' }
  ];
</script>

<div class="visuel orgs">
  {#each O as o, i}
    <div class="tuile" style="animation-delay: {i * 90}ms; --rot: {[-2, 1.5, -1, 2, -1.5, 1, -2, 1.5][i]}deg">
      <span class="logo">
        {#if o.img}<img src="{base}/img/{o.img}" alt={o.nom} />{:else}<b class="typo">{o.txt}</b>{/if}
      </span>
      <span class="quoi">{o.quoi}</span>
    </div>
  {/each}
</div>

<style>
  .orgs { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .tuile { border: 2px solid var(--dk-encre); background: #fff; padding: 1em 0.9em 0.8em; display: flex; flex-direction: column; align-items: center; gap: 0.5em; transform: rotate(var(--rot)); animation: colle 0.5s cubic-bezier(0.2, 1.4, 0.4, 1) both; transition: transform 0.2s; }
  .tuile:hover { transform: rotate(0deg) scale(1.04); }
  .logo { height: 3.6em; display: flex; align-items: center; justify-content: center; width: 100%; }
  .logo img { max-height: 3.2em; max-width: 9em; object-fit: contain; }
  .typo { font-family: var(--dk-mono); font-size: 1.6em; font-weight: 600; letter-spacing: -0.02em; }
  .quoi { font-size: 0.72em; color: var(--dk-gris); text-align: center; line-height: 1.3; }
  @keyframes colle { from { opacity: 0; transform: rotate(var(--rot)) scale(0.7); } to { opacity: 1; transform: rotate(var(--rot)) scale(1); } }
</style>
