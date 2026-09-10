<script>
  /**
   * Quatre raisons, une par tuile, chacune portée par un pictogramme au
   * trait plutôt que par un paragraphe. Ce sont les quatre des decks
   * d'origine (libre, packages, reproductibilité, sciences sociales).
   * Le chiffre des packages est arrondi vers le bas : le CRAN en compte
   * plus de vingt mille depuis 2024, on ne prétend pas au compte du jour.
   */
  import Picto from '../Picto.svelte';
  const RAISONS = [
    { p: 'cadenas', t: 'Libre et gratuit', s: 'Le code est public. Personne ne vous vend une licence, ni à vous ni à votre futur employeur.' },
    { p: 'boite', t: 'Plus de 20 000 packages', s: 'Une boîte à outils par tâche : lire un sondage, dessiner une carte, estimer un modèle. Quelqu’un l’a déjà écrit.' },
    { p: 'retour', t: 'Reproductible', s: 'Un script se relit, se relance, se partage. On retrouve l’erreur. Le clic, lui, ne laisse pas de trace.' },
    { p: 'humain', t: 'La langue des sciences sociales', s: 'Les chercheur.e.s de votre domaine l’utilisent. Les tutoriels, les données et les collègues aussi.' }
  ];
</script>

<div class="visuel pourquoi">
  {#each RAISONS as r, i}
    <div class="raison" style="animation-delay: {i * 120}ms">
      <span class="pic"><Picto nom={r.p} taille="2.6em" /></span>
      <strong>{r.t}</strong>
      <p>{r.s}</p>
    </div>
  {/each}
</div>

<style>
  .pourquoi { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1em; }
  .raison { border: 2px solid var(--dk-encre); padding: 1em 1.1em 0.9em; display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto auto; gap: 0.2em 0.9em; align-items: center; animation: fondu 0.5s both; }
  .pic { grid-row: 1 / 3; color: var(--dk-accent); }
  .raison strong { font-size: 1.15em; }
  .raison p { margin: 0; font-size: 0.8em; line-height: 1.45; color: var(--dk-gris); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
