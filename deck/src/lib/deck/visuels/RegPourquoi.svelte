<script>
  /**
   * Pourquoi la régression ? Pour décrire une relation en chiffres. Le nuage
   * de la population se résume, clic après clic, jusqu'à un seul nombre. À
   * droite, l'échelle de la compression : 10 993 personnes, 5 moyennes,
   * 1 droite, 1 nombre.
   *
   *   0  Le nuage en bulles : 10 993 personnes, 20 cases (RegBulles).
   *   1  Les cinq moyennes, une par niveau de populisme (POP.moyennes).
   *   2  La droite de la population (POP.b0, POP.b1).
   *   3  Le nombre : −0,31. De fortement en désaccord à fortement en
   *      accord (x de 0 à 1, toute l'échelle), la satisfaction baisse de
   *      0,31 sur une échelle de 0 à 1.
   *
   * Tout vient de la population d'exercice : les 20 180 de la CES 2025, dont
   * 10 993 ont répondu aux deux questions (POP, outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import RegBulles from './RegBulles.svelte';
  import { POP, VARS } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Format québécois, vrai signe moins.
  const virgule = (v, d) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const bas = VARS.x.niveaux[0].toLowerCase();
  const haut = VARS.x.niveaux[VARS.x.niveaux.length - 1].toLowerCase();

  const ECHELLE = [
    { n: milliers(POP.n_modele), t: 'personnes' },
    { n: String(POP.moyennes.length), t: 'moyennes' },
    { n: '1', t: 'droite' }
  ];
</script>

<div class="visuel rp" bind:this={hote}>
  <div class="graphe">
    <RegBulles moyennes={e >= 1} droite={e >= 2} pale={e >= 2} />
  </div>

  <div class="cote">
    {#each ECHELLE as l, i}
      <div class="marche" class:vu={e >= i} class:passe={e > i}>
        <span class="n">{l.n}</span><span class="t">{l.t}</span>
      </div>
      <span class="fleche" class:vu={e >= i + 1}>↓</span>
    {/each}
    <div class="nombre" class:vu={e >= 3}>
      <span class="de">de {bas}<br />à {haut}</span>
      <span class="grand">{virgule(POP.b1, 2)}</span>
      <span class="sous">de satisfaction<br />(sur 0 à 1)</span>
    </div>
    <p class="source">CES 2025 · plus la bulle est grosse, plus il y a de monde</p>
  </div>
</div>

<style>
  .rp { display: grid; grid-template-columns: 1.55fr 1fr; gap: 1.4em; align-items: center; }
  .graphe { min-width: 0; }
  .graphe :global(svg) { max-height: 66vh; }

  .cote { display: flex; flex-direction: column; align-items: flex-start; gap: 0.2em; }
  .marche { display: flex; align-items: baseline; gap: 0.5em; opacity: 0; transform: translateY(8px); transition: opacity 0.35s, transform 0.35s, color 0.35s; }
  .marche.vu { opacity: 1; transform: none; }
  .marche.passe { color: var(--dk-gris-2); }
  .marche .n { white-space: nowrap; font-size: 1.4em; font-weight: 600; font-variant-numeric: tabular-nums; }
  .marche .t { font-size: 0.92em; }
  .fleche { font-size: 1em; color: var(--dk-accent); padding-left: 0.4em; opacity: 0; transition: opacity 0.3s; line-height: 1; }
  .fleche.vu { opacity: 1; }

  .nombre { display: flex; flex-direction: column; gap: 0.2em; border-left: 0.32em solid var(--dk-accent); padding: 0.2em 0 0.2em 0.6em; margin-top: 0.15em;
    opacity: 0; transform: scale(0.9); transform-origin: left center; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .nombre.vu { opacity: 1; transform: none; }
  .de { font-size: 0.78em; line-height: 1.35; color: var(--dk-gris); }
  .grand { font-size: 3em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; white-space: nowrap; }
  .sous { font-size: 0.88em; line-height: 1.35; }

  .source { margin: 0.8em 0 0; font-size: 0.6em; line-height: 1.4; color: var(--dk-gris); max-width: 22em; }

  @media (prefers-reduced-motion: reduce) {
    .marche, .fleche, .nombre { transition: none; }
  }
</style>
