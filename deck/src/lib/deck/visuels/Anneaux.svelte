<script>
  /**
   * Le lancer d'anneaux (Arel-Bundock 2021, p. 73-74, figure 4.4). La vraie
   * moyenne d'âge des 20 180 répondant.e.s est un piquet fixe. Chaque
   * échantillon de 50 lance un anneau : son intervalle de confiance à 95 %.
   * La plupart attrapent le piquet, quelques-uns le ratent.
   *
   *   0  La vraie moyenne (ligne pointillée) et le premier intervalle.
   *   1  Les dix premiers intervalles.
   *   2  Les cent. Ceux qui ratent la vraie moyenne passent au rouge. Le
   *      compte s'affiche : combien sur cent l'attrapent.
   *   3  Une phrase : la vérité ne bouge pas, c'est l'intervalle qui bouge.
   *
   * Ce que « 95 % » veut dire : si on répétait l'échantillonnage, 95 % des
   * intervalles construits ainsi contiendraient la vraie valeur (livre,
   * p. 73 et note 10). Pas « 95 % de chances que la vraie valeur soit dans
   * cet intervalle-ci ».
   *
   * Les nombres : ANNEAUX (cent échantillons de 50 tirés dans les 20 180,
   * t.test() pour chaque intervalle, outils/seance5_data.R, bloc 6) et POP
   * (la vraie moyenne et le nombre de répondant.e.s).
   */
  import { brancherTemps } from '../temps.js';
  import { ANNEAUX, POP } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const I = ANNEAUX.intervalles;
  const TOTAL = I.length;
  const VUS = [1, 10, TOTAL, TOTAL];
  const n = $derived(VUS[e]);
  const nPop = POP.n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const fr1 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });

  // L'âge de 36 à 64 ans sur la hauteur, les cent échantillons sur la largeur.
  const Y = (a) => 80 + ((64 - a) / 28) * 300;
  const X = (k) => 90 + k * 7;
  const YV = Y(POP.moyenne);
  const AGES = [40, 45, 50, 55, 60];
  // Délai d'apparition : chaque nouvel intervalle un peu après le précédent.
  const delai = (k, e) => (e === 0 ? 0 : e === 1 ? (k - 1) * 45 : Math.max(0, k - 10) * 9);
</script>

<div class="visuel anneaux" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="Cent échantillons de {ANNEAUX.n} personnes tirés parmi les {nPop} répondant.e.s. Chacun donne un intervalle de confiance à 95&#8239;%, un segment vertical. Une ligne pointillée marque la vraie moyenne d’âge, {fr1(POP.moyenne)} ans. {ANNEAUX.couvrent} intervalles sur {TOTAL} l’attrapent, les {TOTAL - ANNEAUX.couvrent} autres, en rouge, la ratent. La vérité ne bouge pas. C’est l’intervalle qui bouge.">
    <!-- Temps 2 : le compte. -->
    <text x="90" y="40" class="an-compte" class:an-vu={e >= 2}><tspan class="an-fort">{ANNEAUX.couvrent} sur {TOTAL}</tspan> attrapent la vraie moyenne</text>

    <!-- L'axe des âges. -->
    <line x1="76" y1={Y(64)} x2="76" y2={Y(36)} class="an-axe" />
    {#each AGES as a}
      <line x1="68" y1={Y(a)} x2="76" y2={Y(a)} class="an-axe" />
      <text x="62" y={Y(a) + 7} class="an-tick">{a}</text>
    {/each}
    <text x="76" y="68" class="an-age">âge</text>

    <!-- Les intervalles. -->
    {#each I as iv, k}
      <g class="an-iv" class:an-vu={k < n} class:an-rate={!iv.couvre && e >= 2} style="transition-delay: {k < n ? delai(k, e) : 0}ms">
        <line x1={X(k)} y1={Y(iv.haut)} x2={X(k)} y2={Y(iv.bas)} class="an-seg" />
        <circle cx={X(k)} cy={Y(iv.moyenne)} r="3.6" class="an-moy" />
      </g>
    {/each}

    <!-- La vraie moyenne : le piquet. -->
    <line x1="76" y1={YV} x2="792" y2={YV} class="an-vraie" />
    <text x="806" y={YV - 18} class="an-vraie-t">la vraie</text>
    <text x="806" y={YV + 8} class="an-vraie-t">moyenne</text>
    <text x="806" y={YV + 32} class="an-vraie-s">(les {nPop})</text>

    <!-- Combien d'échantillons sont lancés. -->
    <text x="90" y="414" class="an-n">{n} échantillon{n > 1 ? 's' : ''} de {ANNEAUX.n} personnes</text>

    <!-- Temps 3 : la phrase. -->
    <text x="90" y="458" class="an-fin" class:an-vu={e >= 3}>La vérité ne bouge pas. C’est l’intervalle qui bouge.</text>
  </svg>
  <p class="an-src">Étude électorale canadienne 2025, sans pondération · Arel-Bundock (2021, p.&#8239;73-74, figure 4.4)</p>
</div>

<style>
  .anneaux { display: flex; flex-direction: column; gap: 0.3em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .an-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .an-tick { font-size: 19px; text-anchor: end; fill: var(--dk-gris); }
  .an-age { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }

  .an-iv { opacity: 0; transition: opacity 0.2s; }
  .an-iv.an-vu { opacity: 1; transition: opacity 0.35s; }
  .an-seg { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s, stroke-width 0.4s; }
  .an-moy { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; transition: stroke 0.4s; }
  .an-rate .an-seg { stroke: var(--dk-accent); stroke-width: 4.5; }
  .an-rate .an-moy { stroke: var(--dk-accent); }

  .an-vraie { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 12 7; }
  .an-vraie-t { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .an-vraie-s { font-size: 18px; fill: var(--dk-gris); }

  .an-n { font-size: 20px; fill: var(--dk-gris); }
  .an-compte { font-size: 30px; fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s; }
  .an-compte.an-vu { opacity: 1; transition: opacity 0.5s 1s; }
  .an-fort { font-weight: 600; font-size: 38px; }
  .an-fin { font-size: 24px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s; }
  .an-fin.an-vu { opacity: 1; transition: opacity 0.5s; }

  .an-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .an-iv, .an-iv.an-vu, .an-seg, .an-moy, .an-compte, .an-compte.an-vu, .an-fin, .an-fin.an-vu { transition: none; }
  }
</style>
