<script>
  /**
   * Une distribution, c'est des gens empilés. L'intérêt pour la politique
   * (0 à 10) des répondant.e.s de l'Étude électorale canadienne 2025, un
   * petit carré pour cent personnes (src/lib/data/seance3.js). La variable
   * est nommée en toutes lettres, en titre, dans la figure.
   *
   *   0  Les carrés tombent, colonne par colonne, et s'empilent au-dessus
   *      de leur valeur.
   *   1  Chaque pile se fond en une barre pleine ; l'effectif exact apparaît.
   *   2  La médiane s'allume (7), et le nombre de « ne sait pas » écartés.
   *   3  La moyenne (6,7) se pose sous l'axe, à sa vraie position, entre
   *      le 6 et le 7 : un peu à gauche de la médiane.
   */
  import { brancherTemps } from '../temps.js';
  import { FORMES } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const F = FORMES.interet;
  const PAR = 3;          // carrés par rangée
  const P = 24, C = 20;   // pas et côté d'un carré
  const X0 = 90, X1 = 930, Y0 = 460;
  const slot = (X1 - X0) / F.valeurs.length;
  const cx = (i) => X0 + slot * (i + 0.5);
  const colonnes = F.effectifs.map((n, i) => {
    const k = Math.round(n / 100);
    return {
      n,
      h: (n / (100 * PAR)) * P,
      carres: Array.from({ length: k }, (_, j) => ({
        x: cx(i) - (PAR * P) / 2 + (j % PAR) * P + (P - C) / 2,
        y: Y0 - (Math.floor(j / PAR) + 1) * P + (P - C) / 2,
        d: i * 120 + j * 22
      }))
    };
  });
  const iMed = F.valeurs.indexOf(F.mediane);
  // Séparateur de milliers : toujours l'espace fine insécable (U+202F).
  const fmt = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const hautMed = Y0 - colonnes[iMed].h;

  // La moyenne n'est pas un entier : on la place à sa vraie position sur
  // l'axe, par interpolation entre les centres des valeurs voisines.
  const pasValeur = F.valeurs[1] - F.valeurs[0];
  const xMoy = cx(0) + ((F.moyenne - F.valeurs[0]) / pasValeur) * slot;
  const moyTxt = F.moyenne.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
</script>

<div class="visuel empiler" bind:this={hote}>
  <div class="puces">
    <code class="code">hist(df$cps25_interest_gen_1)</code>
    <span class="leg"><i></i> = 100 personnes</span>
    <span class="sans" class:vu={e >= 2}>{fmt(F.sans)} «&#8239;ne sait pas&#8239;» écartés</span>
  </div>
  <svg viewBox="0 0 1000 540" role="img" aria-label="Intérêt pour la politique, de 0 (aucun) à 10 (beaucoup), Étude électorale canadienne 2025, {fmt(F.n)} répondant.e.s : la plupart des personnes se situent entre 6 et 10 ; médiane {F.mediane}, moyenne {moyTxt}.">
    <!-- La pluie de carrés reste dans la zone du graphique : elle ne passe
         pas sur le titre. -->
    <defs><clipPath id="empiler-zone"><rect x="0" y="72" width="1000" height={Y0 - 72} /></clipPath></defs>
    <text x={X0 - 10} y="28" class="titre">Intérêt pour la politique, de 0 (aucun) à 10 (beaucoup)</text>
    <text x={X0 - 10} y="58" class="sous">Étude électorale canadienne 2025 · {fmt(F.n)} répondant.e.s</text>

    {#each colonnes as col, i}
      <rect x={cx(i) - (PAR * P) / 2 + 2} y={Y0 - col.h} width={PAR * P - 4} height={col.h} class="barre" class:on={e >= 1} class:med={e >= 2 && i === iMed} />
      <text x={cx(i)} y={Y0 - col.h - 10} class="n" class:vu={e >= 1}>{fmt(col.n)}</text>
      <g class="carres" class:fondu={e >= 1} clip-path="url(#empiler-zone)">
        {#each col.carres as c}
          <rect x={c.x} y={c.y} width={C} height={C} class="carre" style="--d: {c.d}ms" />
        {/each}
      </g>
      <text x={cx(i)} y={Y0 + 32} class="tick" class:med={e >= 2 && i === iMed}>{F.valeurs[i]}</text>
    {/each}
    <line x1={X0 - 10} y1={Y0} x2={X1 + 10} y2={Y0} class="axe" />
    <text x={cx(0) - slot / 2} y={Y0 + 68} class="bout">0 · aucun intérêt</text>
    <text x={cx(10) + slot / 2} y={Y0 + 68} class="bout d">10 · beaucoup</text>

    <!-- La médiane : en rouge, au-dessus de sa barre. -->
    <g class="mediane" class:vu={e >= 2}>
      <text x={cx(iMed)} y="100" class="med-t">médiane · {F.mediane}</text>
      <line x1={cx(iMed)} y1="110" x2={cx(iMed)} y2={hautMed - 34} />
    </g>

    <!-- La moyenne : à l'encre, sous l'axe. Les deux étiquettes ne peuvent
         pas se toucher : l'une est en haut de la figure, l'autre en bas. -->
    <g class="moyenne" class:vu={e >= 3}>
      <polygon points="{xMoy},{Y0 + 3} {xMoy - 11},{Y0 + 24} {xMoy + 11},{Y0 + 24}" />
      <line x1={xMoy} y1={Y0 + 24} x2={xMoy} y2={Y0 + 46} />
      <text x={xMoy} y={Y0 + 68} class="moy-t">moyenne · {moyTxt}</text>
    </g>
  </svg>
</div>

<style>
  .empiler { display: flex; flex-direction: column; gap: 0.4em; }
  .puces { display: flex; align-items: center; gap: 1.2em; flex-wrap: wrap; }
  .code { font-family: var(--dk-mono); font-size: 0.72em; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.25em 0.6em; }
  .leg { display: inline-flex; align-items: center; gap: 0.4em; font-size: 0.72em; color: var(--dk-gris); }
  .leg i { display: inline-block; width: 0.8em; height: 0.8em; background: var(--dk-encre); }
  .sans { margin-left: auto; font-size: 0.66em; color: var(--dk-gris); opacity: 0; transition: opacity 0.4s; }
  .sans.vu { opacity: 1; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .sous { font-size: 20px; fill: var(--dk-gris); }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .carre { fill: var(--dk-encre); animation: pluie 0.6s cubic-bezier(0.3, 1.45, 0.55, 1) both; animation-delay: var(--d); }
  .carres { transition: opacity 0.45s; }
  .carres.fondu { opacity: 0; }
  .barre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; transform: scaleY(0); transition: transform 0.55s cubic-bezier(0.3, 1.3, 0.5, 1), fill 0.4s; }
  .barre.on { transform: scaleY(1); }
  .barre.med { fill: var(--dk-accent); }
  .n { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s 0.3s; }
  .n.vu { opacity: 1; }
  .tick { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.4s; }
  .tick.med { fill: var(--dk-accent); }
  .bout { font-size: 20px; fill: var(--dk-gris); }
  .bout.d { text-anchor: end; }
  .mediane, .moyenne { opacity: 0; transition: opacity 0.4s; }
  .mediane.vu, .moyenne.vu { opacity: 1; }
  .mediane line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .med-t { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .moyenne polygon { fill: var(--dk-encre); }
  .moyenne line { stroke: var(--dk-encre); stroke-width: 4; }
  .moy-t { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  @keyframes pluie {
    0% { transform: translateY(-420px); opacity: 0; }
    15% { opacity: 1; }
    100% { transform: none; opacity: 1; }
  }

  @media (prefers-reduced-motion: reduce) {
    .carre { animation: none; }
    .carres, .barre, .n, .mediane, .moyenne, .sans, .tick { transition: none; }
  }
</style>
