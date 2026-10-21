<script>
  /**
   * Zotero en trois morceaux, puis l'essai en direct : ajouter Blais et
   * Gélineau (2007) par son DOI. Un schéma, pas une capture.
   *
   *   0  le navigateur (le connecteur), Zotero (la bibliothèque), Word (le module);
   *   1  la démo : la baguette magique, puis le DOI de Blais;
   *   2  dans Word : citer, puis la bibliographie se fait seule; un clic change le style.
   */
  import { brancherTemps } from '../temps.js';
  let { doi } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const BOITES = [
    { nom: 'Le navigateur', dit: 'le connecteur Zotero : un clic sur un article l’enregistre' },
    { nom: 'Zotero', dit: 'votre bibliothèque : auteurs, titre, revue, année, PDF' },
    { nom: 'Word', dit: 'le module Zotero : la citation, puis la bibliographie' }
  ];
</script>

<div class="visuel m8z" bind:this={hote}>
  <div class="flux">
    {#each BOITES as b, i}
      <div class="boite" class:centre={i === 1} class:allume={(e === 1 && i === 1) || (e === 2 && i === 2)}>
        <strong>{b.nom}</strong>
        <span>{b.dit}</span>
      </div>
      {#if i < 2}<span class="fl">→</span>{/if}
    {/each}
  </div>

  <div class="bas">
    <div class="demo" class:vu={e === 1}>
      <span class="tete">Essayons</span>
      <span>la baguette magique : ajouter par identifiant</span>
      <code>{doi}</code>
    </div>
    <div class="demo" class:vu={e >= 2}>
      <span class="tete">Dans Word</span>
      <span>(Blais et Gélineau, 2007) dans le texte, la référence complète à la fin</span>
      <span class="style">un clic change le style pour tout le travail</span>
    </div>
  </div>
  <p class="pied">zotero.org · gratuit, libre, en français</p>
</div>

<style>
  .m8z { max-width: 64em; margin: 1.2em auto 0; display: flex; flex-direction: column; gap: 1.4em; }
  .flux { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.8em; align-items: stretch; }
  .boite { border: 3px solid var(--dk-encre); padding: 1.1em 1.1em; display: flex; flex-direction: column; gap: 0.4em; transition: border-color 0.3s, background 0.3s; }
  .boite strong { font-size: 1.3em; }
  .boite span { color: var(--dk-gris); font-size: 0.9em; }
  .boite.centre { border-color: var(--dk-accent); }
  .boite.allume { background: var(--dk-fond-2); border-color: var(--dk-accent); }
  .fl { align-self: center; font-size: 1.6em; color: var(--dk-gris); }
  .bas { display: grid; }
  .demo { grid-area: 1 / 1; display: flex; flex-direction: column; gap: 0.5em; padding: 0.9em 1.1em; background: var(--dk-encre); color: var(--dk-fond); opacity: 0; transition: opacity 0.4s; }
  .demo.vu { opacity: 1; }
  .tete { font-size: 0.8em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-accent-clair); font-weight: 600; }
  .demo code { font-family: var(--dk-mono); font-size: 1.5em; color: var(--dk-accent-clair); background: none; padding: 0; }
  .style { color: var(--dk-gris-2); }
  .pied { margin: 0; color: var(--dk-gris); font-size: 0.8em; }
  @media (prefers-reduced-motion: reduce) { .demo, .boite { transition: none; } }
</style>
