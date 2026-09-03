<script>
  /**
   * La fiche d'une recherche. Mode « remplie »: chaque clic écrit une ligne
   * de plus, avec l'exemple du cours (le revenu et l'idéologie). Mode
   * « vide »: la même fiche, grande, avec des lignes pointillées à remplir à
   * voix haute avec la salle.
   */
  import { brancherTemps } from '../temps.js';
  let { mode = 'remplie' } = $props();
  const LIGNES = [
    ['La question', 'Le revenu influence-t-il le vote ?'],
    ['Y · dépendante', 'voter conservateur, oui ou non'],
    ['X · indépendante', 'revenu du ménage, 8 tranches'],
    ['Population', 'les électeur.rice.s canadien.ne.s, 2025'],
    ['Unité d’analyse', 'la personne sondée'],
    ['Niveaux de mesure', 'Y : nominal (oui/non) · X : ordinal'],
    ['H₁ · H₀', 'plus riche, plus conservateur · aucune relation']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || mode !== 'remplie') return;
    e = 0;
    return brancherTemps(hote, { total: LIGNES.length, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel fiche {mode}" bind:this={hote}>
  <div class="entete"><span class="titre">FICHE D'UNE RECHERCHE</span><span class="coin"></span></div>
  <dl>
    {#each LIGNES as [k, v], i}
      <div class="ligne" class:vu={mode === 'vide' || e > i}>
        <dt><span class="num">{i + 1}</span>{k}</dt>
        <dd>{#if mode === 'remplie'}<span class="val" class:vu={e > i}>{v}</span>{:else}<span class="trait"></span>{/if}</dd>
      </div>
    {/each}
  </dl>
  {#if mode === 'remplie'}
    <p class="bas" class:vu={e >= LIGNES.length}>Votre travail de mi-session, c'est cette fiche — remplie, et justifiée.</p>
  {/if}
</div>

<style>
  .fiche { border: 3px solid var(--dk-accent); background: var(--dk-fond); padding: 0 0 0.8em; display: flex; flex-direction: column; }
  .entete { display: flex; justify-content: space-between; align-items: center; background: var(--dk-accent); color: var(--dk-fond); padding: 0.45em 1.1em; }
  .titre { font-size: 0.68em; letter-spacing: 0.2em; font-weight: 600; }
  .coin { width: 1.4em; height: 1.4em; background: linear-gradient(225deg, var(--dk-fond) 50%, transparent 50%); }
  dl { margin: 0; padding: 0.4em 1.1em 0; display: flex; flex-direction: column; }
  .ligne { display: grid; grid-template-columns: 11em 1fr; gap: 1.2em; align-items: baseline; padding: 0.5em 0; border-bottom: 1px solid var(--dk-filet); opacity: 0.3; transition: opacity 0.4s; }
  .ligne.vu { opacity: 1; }
  .vide .ligne { padding: 0.75em 0; }
  dt { display: flex; gap: 0.6em; align-items: baseline; font-weight: 600; color: var(--dk-gris); font-size: 0.85em; }
  .num { font-family: var(--dk-mono); color: var(--dk-accent); }
  dd { margin: 0; font-size: 1em; }
  .val { display: inline-block; opacity: 0; transform: translateX(-0.4em); transition: opacity 0.4s, transform 0.4s; }
  .val.vu { opacity: 1; transform: none; }
  .trait { display: block; height: 1.3em; border-bottom: 2px dotted var(--dk-gris-2); }
  .bas { margin: 0.8em 1.1em 0; font-size: 0.95em; opacity: 0; transition: opacity 0.5s; }
  .bas.vu { opacity: 1; }
</style>
