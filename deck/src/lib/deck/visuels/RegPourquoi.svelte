<script>
  /**
   * Pourquoi la régression ? Pour décrire une relation en chiffres. La
   * foule de la population se résume, clic après clic, jusqu'à un seul
   * nombre (demande de l'enseignant, 15 octobre : les points apparaissent,
   * s'écartent, se regroupent, puis les moyennes, puis la droite). À
   * droite, l'échelle de la compression : 19 736 personnes, 5 moyennes,
   * 1 droite, 1 nombre.
   *
   *   0  Les axes seuls (RegFoule).
   *   1  Les 19 736 personnes tombent à leur place exacte : empilées, elles
   *      ne font que 55 points.
   *   2  Elles s'écartent : la foule apparaît.
   *   3  Elles se regroupent : on voit où sont les gens.
   *   4  Les cinq moyennes, une par niveau de scolarité (POP.moyennes).
   *   5  La droite de la population (POP.b0, POP.b1), et le nombre : +0,17.
   *      Du secondaire non terminé à la maîtrise ou au doctorat (x de 0 à 1,
   *      toute l'échelle), l'intérêt monte de 0,17 sur une échelle de 0 à 1.
   *
   * Tout vient de la population d'exercice : les 20 180 de la CES 2025, dont
   * 19 736 ont répondu aux deux questions (POP, outils/seance7_data.R). La
   * phrase « du … à la … » est écrite ici (la grammaire l'exige), sur les
   * deux bouts de VARS.x.niveaux.
   */
  import { brancherTemps } from '../temps.js';
  import RegFoule from './RegFoule.svelte';
  import { POP } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Format québécois, signe explicite (vrai signe moins).
  const signe = (v, d) => (v < 0 ? '−' : '+') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');

  // Chaque marche de l'échelle et le temps où elle arrive.
  const ECHELLE = [
    { n: milliers(POP.n_modele), t: 'personnes', a: 1 },
    { n: String(POP.moyennes.length), t: 'moyennes', a: 4 },
    { n: '1', t: 'droite', a: 5 }
  ];
  // Ce qu'on voit, en une ligne, aux temps 1 à 3.
  const LEGENDE = ['', 'mais on ne voit que 55 points', 'on les écarte', 'on les regroupe'];
</script>

<div class="visuel rp" bind:this={hote}>
  <div class="graphe">
    <RegFoule etape={e} />
  </div>

  <div class="cote">
    {#each ECHELLE as l, i}
      <div class="marche" class:vu={e >= l.a} class:passe={i < 2 ? e >= ECHELLE[i + 1].a : e >= 5}>
        <span class="n">{l.n}</span><span class="t">{l.t}</span>
      </div>
      {#if i === 0}
        <p class="legende">{#each LEGENDE as t, k}{#if k > 0}<span class:vu={e === k}>{t}</span>{/if}{/each}</p>
      {/if}
      <span class="fleche" class:vu={e >= (i < 2 ? ECHELLE[i + 1].a : 5)}>↓</span>
    {/each}
    <div class="nombre" class:vu={e >= 5}>
      <span class="de">du secondaire non terminé<br />à la maîtrise ou au doctorat</span>
      <span class="grand">{signe(POP.b1, 2)}</span>
      <span class="sous">d’intérêt<br />(sur 0 à 1)</span>
    </div>
    <p class="source">CES 2025 · un carré par personne</p>
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

  /* Les trois légendes empilées dans la même case : pas de saut. */
  .legende { display: grid; margin: 0 0 0 0.1em; font-size: 0.78em; color: var(--dk-accent); min-height: 1.4em; }
  .legende span { grid-area: 1 / 1; opacity: 0; transition: opacity 0.4s 0.3s; }
  .legende span.vu { opacity: 1; }
  .source { margin: 0.8em 0 0; font-size: 0.6em; line-height: 1.4; color: var(--dk-gris); max-width: 22em; }

  @media (prefers-reduced-motion: reduce) {
    .marche, .fleche, .nombre { transition: none; }
  }
</style>
