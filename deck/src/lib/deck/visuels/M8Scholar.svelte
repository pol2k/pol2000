<script>
  /**
   * Deux trucs de Google Scholar pour la revue de littérature. Un schéma,
   * pas une capture (Scholar refuse les navigateurs automatisés).
   *
   *   0  une seule fois : relier Scholar à la Bibliothèque de l'Université
   *      Laval (le chemin des guides de bibl.ulaval.ca);
   *   1  un résultat : le lien Obtenir@ULaval mène au texte intégral (IDUL);
   *   2  « Cité par » : les travaux publiés depuis, qui citent celui-ci.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const CHEMIN = ['☰ Menu', 'Paramètres', 'Liens vers des bibliothèques', 'Université Laval, Bibliothèque – Obtenir@ULaval', 'Enregistrer'];
</script>

<div class="visuel m8s" bind:this={hote}>
  <div class="chemin">
    <span class="tete">Une seule fois</span>
    {#each CHEMIN as c, i}
      <span class="etape" class:cle={i === 3}>{c}</span>{#if i < CHEMIN.length - 1}<span class="fl">→</span>{/if}
    {/each}
  </div>

  <div class="carte" class:vu={e >= 1}>
    <div class="haut">
      <div>
        <p class="titre">Winning, Losing and Satisfaction with Democracy</p>
        <p class="qui">A Blais, F Gélineau · Political Studies, 2007</p>
        <span class="barre"></span><span class="barre courte"></span>
      </div>
      <span class="lien" class:allume={e === 1}>Obtenir@ULaval</span>
    </div>
    <p class="actions"><span>☆ Enregistrer</span><span>❝ Citer</span><span class="cite" class:allume={e >= 2}>Cité par …</span><span>Autres articles</span></p>
  </div>

  <div class="bulles">
    <p class="bulle" class:vu={e === 1}><strong>Obtenir@ULaval</strong>{' '}: le texte intégral, avec votre IDUL</p>
    <p class="bulle" class:vu={e >= 2}><strong>Cité par</strong>{' '}: qui l’a lu et cité depuis. La littérature, vers l’avant.</p>
  </div>
  <p class="pied">schéma d’un résultat de Google Scholar</p>
</div>

<style>
  .m8s { max-width: 62em; margin: 1em auto 0; display: flex; flex-direction: column; gap: 1.1em; }
  .chemin { display: flex; flex-wrap: wrap; align-items: center; gap: 0.4em 0.5em; font-size: 0.85em; }
  .tete { font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-accent); margin-right: 0.4em; }
  .etape { border: 2px solid var(--dk-encre); padding: 0.2em 0.5em; }
  .etape.cle { border-color: var(--dk-accent); color: var(--dk-accent); font-weight: 600; }
  .fl { color: var(--dk-gris); }
  .carte { border: 3px solid var(--dk-encre); padding: 1em 1.2em; display: flex; flex-direction: column; gap: 0.6em; opacity: 0.15; transition: opacity 0.4s; }
  .carte.vu { opacity: 1; }
  .haut { display: flex; justify-content: space-between; gap: 1.2em; align-items: flex-start; }
  .titre { margin: 0; font-size: 1.15em; font-weight: 600; color: #1a0dab; }
  .qui { margin: 0.3em 0 0.5em; color: #006621; font-size: 0.85em; }
  .barre { display: block; height: 0.5em; background: var(--dk-filet); margin-top: 0.35em; width: 92%; }
  .barre.courte { width: 60%; }
  .lien { white-space: nowrap; font-size: 0.85em; padding: 0.2em 0.5em; border: 2px solid transparent; color: #1a0dab; transition: all 0.3s; }
  .actions { margin: 0; display: flex; gap: 1.6em; font-size: 0.85em; color: var(--dk-gris); }
  .cite { border: 2px solid transparent; padding: 0 0.3em; transition: all 0.3s; }
  .allume { border-color: var(--dk-accent) !important; color: var(--dk-accent) !important; font-weight: 700; }
  .bulles { display: grid; }
  .bulle { grid-area: 1 / 1; margin: 0; font-size: 1.15em; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); opacity: 0; transition: opacity 0.4s; }
  .bulle.vu { opacity: 1; }
  .bulle strong { color: var(--dk-accent-clair); }
  .pied { margin: 0; color: var(--dk-gris); font-size: 0.75em; }
  @media (prefers-reduced-motion: reduce) { .carte, .bulle, .lien, .cite { transition: none; } }
</style>
