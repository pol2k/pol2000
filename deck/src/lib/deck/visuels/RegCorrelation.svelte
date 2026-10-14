<script>
  /**
   * Corrélation ou régression ? Le même nuage (RegBulles, les 10 993 de la
   * CES 2025 qui ont répondu aux deux questions), deux façons de le résumer.
   *
   *   0  Le nuage seul.
   *   1  La corrélation : r = −0,30, posé sur une règle de −1 à +1. Le signe
   *      donne le sens, la distance à ±1 donne la force. Un nombre sans
   *      unité, le même dans les deux sens (populisme ↔ satisfaction).
   *   2  La régression : la droite, et sa pente dans les unités de la
   *      satisfaction, −0,31 de fortement en désaccord à fortement en
   *      accord. Elle a un sens : populisme → satisfaction.
   *   3  Elle prédit : « plutôt en accord » (0,75), environ 0,56 de
   *      satisfaction (predict() donne 0,5579; 0,79 − 0,31 × 0,75 de la
   *      diapo suivante donne aussi 0,56).
   *   4  Et elle peut garder d'autres variables constantes : « à vote
   *      égal », plus loin dans la séance (le vote libéral, PARTI).
   *
   * r et la prédiction : CORR (outils/seance7_b.R, cor() et predict() sur
   * les 10 993 cas complets; r = POP.r). La pente : POP.b1
   * (outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import RegBulles from './RegBulles.svelte';
  import { POP, VARS } from '$lib/data/seance7.js';
  import { CORR } from '$lib/data/seance7_b.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const virgule = (v, d) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  // Position de r sur la règle de −1 à +1, en pour cent de la largeur.
  const ou = (r) => ((r + 1) / 2) * 100;
  const NIVEAU = VARS.x.niveaux[VARS.x.valeurs.indexOf(CORR.x_pred)].toLowerCase();
</script>

<div class="visuel rc" bind:this={hote}>
  <div class="graphe">
    <RegBulles droite={e >= 2} pred={CORR.x_pred} predire={e >= 3} pale={e >= 2} />
  </div>

  <div class="cartes">
    <section class="carte" class:vu={e >= 1}>
      <h3>La corrélation</h3>
      <p class="chiffre"><span class="r">r</span> = {virgule(CORR.r, 2)}</p>
      <div class="regle">
        <span class="trait"></span>
        <span class="zero"></span>
        <span class="marque" style="left: {ou(e >= 1 ? CORR.r : 0)}%"></span>
        <span class="bout g">−1</span><span class="bout m">0</span><span class="bout d">+1</span>
      </div>
      <p class="sens">populisme <span class="f">↔</span> satisfaction</p>
    </section>

    <section class="carte reg" class:vu={e >= 2}>
      <h3>La régression</h3>
      <p class="chiffre">{virgule(POP.b1, 2)} <span class="unite">de satisfaction, d’un bout à l’autre</span></p>
      <p class="pred" class:vu={e >= 3}>{NIVEAU} <span class="f">→</span> environ {virgule(CORR.pred, 2)}</p>
      <p class="sens">populisme <span class="f">→</span> satisfaction</p>
    </section>

    <p class="suite" class:vu={e >= 4}>et plus loin aujourd’hui, <strong>à vote égal</strong></p>
  </div>
</div>

<style>
  .rc { display: grid; grid-template-columns: 1.3fr 1fr; gap: 1.4em; align-items: center; }
  .graphe { min-width: 0; }
  .graphe :global(svg) { max-height: 64vh; }

  .cartes { display: flex; flex-direction: column; gap: 0.7em; }
  .carte { border: 2px solid var(--dk-encre); padding: 0.55em 0.8em 0.6em; display: flex; flex-direction: column; gap: 0.3em;
    opacity: 0; transform: translateY(10px); transition: opacity 0.4s, transform 0.4s; }
  .carte.vu { opacity: 1; transform: none; }
  .carte.reg { border-color: var(--dk-accent); }
  h3 { font-size: 0.7em !important; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600 !important; color: var(--dk-gris); margin: 0 !important; }
  .reg h3 { color: var(--dk-accent); }
  .chiffre { font-size: 1.6em !important; font-weight: 600; line-height: 1.1 !important; font-variant-numeric: tabular-nums; }
  .chiffre .r { font-style: italic; }
  .reg .chiffre { color: var(--dk-accent); }
  .unite { font-size: 0.45em; font-weight: 400; color: var(--dk-encre); letter-spacing: 0; }
  .sens { font-size: 0.72em !important; color: var(--dk-gris); }
  .f { color: var(--dk-encre); font-weight: 600; }
  .pred { font-size: 0.9em !important; font-weight: 600; opacity: 0; transition: opacity 0.4s 0.5s; }
  .pred.vu { opacity: 1; }
  .pred .f { color: var(--dk-accent); }

  /* La règle de −1 à +1. */
  .regle { position: relative; height: 2.2em; margin: 0.2em 0.6em 0.1em; }
  .trait { position: absolute; left: 0; right: 0; top: 0.5em; height: 2px; background: var(--dk-encre); }
  .zero { position: absolute; left: 50%; top: 0.2em; width: 2px; height: 0.65em; background: var(--dk-encre); }
  .marque { position: absolute; top: 0.1em; width: 0.85em; height: 0.85em; margin-left: -0.425em; background: var(--dk-encre);
    transition: left 0.9s cubic-bezier(0.34, 1.3, 0.64, 1) 0.2s; }
  .bout { position: absolute; top: 1.15em; font-size: 0.68em; color: var(--dk-gris); transform: translateX(-50%); }
  .bout.g { left: 0; } .bout.m { left: 50%; } .bout.d { left: 100%; }

  .suite { font-size: 0.78em !important; line-height: 1.4; border-left: 0.3em solid var(--dk-accent); padding-left: 0.6em; opacity: 0; transition: opacity 0.4s; }
  .suite.vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .carte, .pred, .marque, .suite { transition: none; }
  }
</style>
