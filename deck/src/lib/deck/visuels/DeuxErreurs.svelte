<script>
  /**
   * Deux façons de se tromper (Arel-Bundock 2021, p. 75-76). Un tableau de
   * deux sur deux : en colonnes, la réalité (H₀ vraie ou fausse), qu'on ne
   * connaît pas; en rangées, notre décision (rejeter H₀ ou non). Deux cases
   * sont de bonnes décisions, deux sont des erreurs.
   *
   *   0  Le tableau : erreur de type 1 (rejeter une H₀ vraie) et erreur de
   *      type 2 (ne pas rejeter une H₀ fausse) en rouge, les deux bonnes
   *      décisions cochées.
   *   1  Sous chaque erreur, l'analogie du tribunal, où H₀ est l'innocence :
   *      condamner une innocente, acquitter un coupable.
   *
   * Schéma, aucune donnée. Une grille CSS plutôt qu'un <table>, pour rester
   * à l'écart des styles de tableau du deck.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel deux-erreurs" bind:this={hote}>
  <div class="de-grille" role="img" aria-label="Deux façons de se tromper. Si on rejette H₀ alors qu’elle est vraie, c’est une erreur de type 1, comme condamner une innocente. Si on ne rejette pas H₀ alors qu’elle est fausse, c’est une erreur de type 2, comme acquitter un coupable. Les deux autres cases sont de bonnes décisions.">
    <div class="de-groupe de-realite"><span>la réalité</span></div>
    <div class="de-groupe de-decision"><span>notre décision</span></div>
    <div class="de-tete de-c1"><span>H₀ est vraie</span></div>
    <div class="de-tete de-c2"><span>H₀ est fausse</span></div>

    <div class="de-rangee de-r1"><span>on rejette H₀</span></div>
    <div class="de-case de-erreur de-r1 de-c1">
      <span class="de-nom">erreur de type 1</span>
      <span class="de-glose" class:de-vu={e >= 1}>condamner une innocente</span>
    </div>
    <div class="de-case de-r1 de-c2">
      <span class="de-bon"><span class="de-coche"></span>bonne décision</span>
    </div>

    <div class="de-rangee de-r2"><span>on ne rejette pas H₀</span></div>
    <div class="de-case de-r2 de-c1">
      <span class="de-bon"><span class="de-coche"></span>bonne décision</span>
    </div>
    <div class="de-case de-erreur de-r2 de-c2">
      <span class="de-nom">erreur de type 2</span>
      <span class="de-glose" class:de-vu={e >= 1}>acquitter un coupable</span>
    </div>
  </div>
  <p class="de-src">Arel-Bundock (2021, p.&#8239;75-76)</p>
</div>

<style>
  .deux-erreurs { display: flex; flex-direction: column; gap: 0.5em; max-width: 52em; margin: 0 auto; }
  .de-grille { display: grid; grid-template-columns: auto 1fr 1fr; grid-template-rows: auto auto auto auto; gap: 0.5em; }
  .de-realite { grid-column: 2 / 4; grid-row: 1; }
  .de-decision { grid-column: 1; grid-row: 2; align-self: end; }
  .de-c1 { grid-column: 2; }
  .de-c2 { grid-column: 3; }
  .de-tete { grid-row: 2; }
  .de-r1 { grid-row: 3; }
  .de-r2 { grid-row: 4; }
  .de-rangee { grid-column: 1; }

  .de-groupe { font-size: 0.66em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); }
  .de-realite { text-align: center; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; }
  .de-decision { border-right: 2px solid var(--dk-encre); padding: 0 0.8em 0.3em 0; }
  .de-tete { display: flex; align-items: flex-end; justify-content: center; font-weight: 600; font-size: 1.05em; padding: 0.2em 0 0.3em; }
  .de-rangee { display: flex; align-items: center; justify-content: flex-end; text-align: right; font-weight: 600; font-size: 1.05em; padding-right: 0.8em; border-right: 2px solid var(--dk-encre); }

  .de-case { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.35em; min-height: 4.6em; padding: 0.7em 0.8em; border: 3px solid var(--dk-encre); text-align: center; animation: de-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .de-case.de-r2 { animation-delay: 0.12s; }
  .de-erreur { border-color: var(--dk-accent); }
  .de-nom { font-size: 1.25em; font-weight: 600; color: var(--dk-accent); }
  .de-bon { display: inline-flex; align-items: center; gap: 0.6em; font-size: 1.05em; color: var(--dk-encre); }
  /* La coche, dessinée : un L tourné. */
  .de-coche { display: inline-block; width: 0.4em; height: 0.78em; margin: 0 0.1em 0.22em; border-right: 0.17em solid var(--dk-encre); border-bottom: 0.17em solid var(--dk-encre); transform: rotate(45deg); }
  .de-glose { font-size: 0.95em; color: var(--dk-encre); opacity: 0; visibility: hidden; transform: translateY(0.3em); transition: opacity 0.25s, transform 0.25s, visibility 0s 0.25s; }
  .de-glose.de-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.45s, transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1), visibility 0s; }
  .de-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }
  @keyframes de-monte { from { opacity: 0; transform: scale(0.96); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .de-case { animation: none; }
    .de-glose, .de-glose.de-vu { transition: none; transform: none; }
  }
</style>
