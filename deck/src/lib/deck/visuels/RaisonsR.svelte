<script>
  /**
   * Pourquoi R : dix raisons, dix tuiles qui arrivent une à une, chacune
   * portée par un pictogramme et une phrase courte. Le compte des packages
   * est celui du CRAN le jour de la vérification (9 septembre 2026 :
   * « Currently, the CRAN package repository features 24957 available
   * packages »). Les ressources, le package ces, ggplot2 et les
   * organisations ont chacun leur diapo ensuite.
   */
  import Picto from '../Picto.svelte';
  const R = [
    { p: 'cadenas', t: 'Libre', s: 'Le code est ouvert. Tout le monde peut le lire, le vérifier, le modifier.' },
    { p: 'coche', t: 'Gratuit', s: 'Pour toujours, pour tout le monde. Pas de licence à payer, pas d’abonnement.' },
    { p: 'humain', t: 'Une communauté active', s: 'Des millions de personnes. Votre problème a déjà été résolu, et la réponse est en ligne.' },
    { p: 'engrenage', t: 'Fait par ses utilisateurs', s: 'Pour ses utilisateurs. Un besoin apparaît, quelqu’un écrit l’outil.' },
    { p: 'boite', t: 'Facile à étendre', s: 'Écrire une nouvelle fonction, l’empaqueter, la donner aux autres : c’est prévu.' },
    { p: 'grille', t: '24 957 packages', s: 'Sur le CRAN, le dépôt officiel, comptés cette semaine. Des milliers d’autres ailleurs.' },
    { p: 'oeil', t: 'Le langage des sciences sociales', s: 'Le plus utilisé dans votre domaine. Vos collègues, vos profs, vos futures données.' },
    { p: 'retour', t: 'Reproductible', s: 'Un script se relance et redonne le même résultat. À vous, à moi, dans dix ans.' },
    { p: 'page', t: 'Le code se partage', s: 'Un fichier texte. On l’envoie, on le lit, on le corrige ensemble.' },
    { p: 'loupe', t: 'On retrouve ses erreurs', s: 'Chaque étape est écrite. Une erreur a une ligne, et la ligne se corrige.' }
  ];
</script>

<div class="visuel raisons-r">
  {#each R as r, i}
    <div class="tuile" class:num={i === 5} style="animation-delay: {i * 110}ms">
      <span class="pic"><Picto nom={r.p} taille="2.2em" /></span>
      <strong>{r.t}</strong>
      <p>{r.s}</p>
    </div>
  {/each}
</div>

<style>
  .raisons-r { display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.7em; }
  .tuile { border: 2px solid var(--dk-encre); padding: 0.85em 0.8em 0.75em; display: flex; flex-direction: column; gap: 0.3em; animation: pop 0.45s cubic-bezier(0.2, 1.4, 0.4, 1) both; transition: transform 0.2s, border-color 0.2s; }
  .tuile:hover { transform: translateY(-0.2em) rotate(-1deg); border-color: var(--dk-accent); }
  .tuile.num { border: 3px solid var(--dk-accent); }
  .pic { color: var(--dk-accent); }
  .tuile strong { font-size: 0.95em; line-height: 1.2; }
  .num strong { font-size: 1.25em; color: var(--dk-accent); letter-spacing: -0.02em; }
  .tuile p { margin: 0; font-size: 0.66em; line-height: 1.4; color: var(--dk-gris); }
  @keyframes pop { from { opacity: 0; transform: scale(0.85) translateY(0.4em); } to { opacity: 1; transform: none; } }
</style>
