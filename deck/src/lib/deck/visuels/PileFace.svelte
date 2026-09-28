<script>
  /**
   * La loi des grands nombres, deux fois. Deux panneaux superposés, avec le
   * même axe horizontal en échelle logarithmique (1, 10, 100, 1 000, 2 000),
   * pour que les premiers tirages, où tout bouge, aient de la place.
   *
   *   0  En haut : la part de « pile » après chacun de 1 000 lancers d'une
   *      pièce (PILE_FACE.proportion), et la ligne d'une chance sur deux.
   *      Les valeurs après 10 et après 1 000 lancers sont lues dans les
   *      données. La place du panneau du bas est réservée.
   *   1  En bas : l'âge moyen à mesure qu'on tire au hasard des
   *      répondant.e.s de l'Étude électorale canadienne 2025, jusqu'à 2 000
   *      (MOYENNE_COURANTE.moyenne), et la ligne de l'âge moyen des N
   *      (POP.moyenne, sans pondération). Valeurs après 10 et après 2 000,
   *      lues dans les données. Une phrase.
   *
   * Tout vient de src/lib/data/seance5.js (outils/seance5_data.R, graines 1
   * et 2 : la même commande redonne les mêmes courbes).
   */
  import { brancherTemps } from '../temps.js';
  import { POP, PILE_FACE, MOYENNE_COURANTE } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const pct = (p) => Math.round(p * 100) + ' %';

  // L'axe commun : log10, de 1 à 2 000.
  const X0 = 110, X1 = 950, NMAX = 2000;
  const x = (n) => X0 + (Math.log10(n) / Math.log10(NMAX)) * (X1 - X0);

  // Haut : une part, de 0 à 1.
  const T0 = 46, T1 = 186;
  const yT = (p) => T0 + (1 - p) * (T1 - T0);
  // Bas : un âge, de 35 à 85 ans.
  const B0 = 276, B1 = 416, AMIN = 35, AMAX = 85;
  const yB = (v) => B0 + ((AMAX - v) / (AMAX - AMIN)) * (B1 - B0);

  // Le tracé : on saute les points à moins d'un demi-pixel du précédent.
  function trace(vals, y) {
    let d = '', dernier = -Infinity;
    vals.forEach((v, i) => {
      const px = x(i + 1);
      if (px - dernier < 0.5 && i < vals.length - 1) return;
      d += (d ? ' L ' : 'M ') + px.toFixed(1) + ' ' + y(v).toFixed(1);
      dernier = px;
    });
    return d;
  }
  const PF = PILE_FACE.proportion;
  const MC = MOYENNE_COURANTE.moyenne;
  const D_HAUT = trace(PF, yT);
  const D_BAS = trace(MC, yB);

  const H10 = PF[9], HFIN = PF[PF.length - 1], NH = PF.length;
  const B10 = MC[9], BFIN = MC[MC.length - 1], NB = MC.length;
</script>

<div class="visuel pile-face" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="En haut, la part de pile après chacun de {f(NH)} lancers : {pct(H10)} après 10 lancers, {pct(HFIN)} après {f(NH)}, tout près d’une chance sur deux. En bas, l’âge moyen de répondant.e.s tiré.e.s au hasard : {f(B10, 1)} ans après 10 personnes, {f(BFIN, 1)} ans après {f(NB)}, tout près de l’âge moyen des {f(POP.n)}, {f(POP.moyenne, 1)} ans.">
    <!-- En haut : pile ou face. -->
    <text x={X0} y="28" class="pf-titre">part de pile, après chaque lancer</text>
    {#each [0, 0.5, 1] as p}
      <text x={X0 - 12} y={yT(p) + 6} class="pf-tick pf-gauche">{pct(p)}</text>
    {/each}
    <line x1={X0} y1={T0} x2={X0} y2={T1} class="pf-axe" />
    <line x1={X0} y1={T1} x2={x(NH)} y2={T1} class="pf-axe" />
    {#each [1, 10, 100, 1000] as t}
      <line x1={x(t)} y1={T1} x2={x(t)} y2={T1 + 7} class="pf-axe" />
      <text x={x(t)} y={T1 + 26} class="pf-tick">{f(t)}</text>
    {/each}
    <line x1={X0} y1={yT(0.5)} x2={X1} y2={yT(0.5)} class="pf-ref" />
    <text x={X1} y={yT(0.5) + 30} class="pf-ref-t">une chance sur deux</text>
    <path d={D_HAUT} pathLength="1" class="pf-ligne" />
    <g class="pf-note">
      <circle cx={x(10)} cy={yT(H10)} r="6" class="pf-pt" />
      <text x={x(10) + 12} y={yT(H10) - 14} class="pf-lu">10 lancers&#8239;: <tspan class="pf-val">{pct(H10)}</tspan></text>
      <circle cx={x(NH)} cy={yT(HFIN)} r="6" class="pf-pt" />
      <text x={x(NH)} y={yT(HFIN) - 22} class="pf-lu pf-droite">{f(NH)} lancers&#8239;: <tspan class="pf-val">{pct(HFIN)}</tspan></text>
    </g>

    <!-- En bas : l'âge moyen. La place est réservée dès le temps 0. -->
    {#if e >= 1}
      <g class="pf-bas">
        <text x={X0} y="258" class="pf-titre">âge moyen, après chaque personne tirée au hasard</text>
        {#each [40, 60, 80] as v}
          <text x={X0 - 12} y={yB(v) + 6} class="pf-tick pf-gauche">{v}</text>
        {/each}
        <line x1={X0} y1={B0} x2={X0} y2={B1} class="pf-axe" />
        <line x1={X0} y1={B1} x2={x(NB)} y2={B1} class="pf-axe" />
        {#each [1, 10, 100, 1000, 2000] as t}
          <line x1={x(t)} y1={B1} x2={x(t)} y2={B1 + 7} class="pf-axe" />
          <text x={x(t)} y={B1 + 26} class="pf-tick">{f(t)}</text>
        {/each}
        <line x1={X0} y1={yB(POP.moyenne)} x2={X1} y2={yB(POP.moyenne)} class="pf-ref" />
        <text x={X1} y={yB(POP.moyenne) + 26} class="pf-ref-t">l’âge moyen des {f(POP.n)}</text>
      </g>
      <path d={D_BAS} pathLength="1" class="pf-ligne" />
      <g class="pf-note">
        <circle cx={x(10)} cy={yB(B10)} r="6" class="pf-pt" />
        <text x={x(10) + 12} y={yB(B10) - 14} class="pf-lu">10 personnes&#8239;: <tspan class="pf-val">{f(B10, 1)} ans</tspan></text>
        <circle cx={x(NB)} cy={yB(BFIN)} r="6" class="pf-pt" />
        <text x={x(NB)} y={yB(BFIN) - 18} class="pf-lu pf-droite">{f(NB)} personnes&#8239;: <tspan class="pf-val">{f(BFIN, 1)} ans</tspan></text>
      </g>
      <text x={X0} y="486" class="pf-phrase">Plus on tire, plus on s’approche de la vraie valeur.</text>
    {/if}
  </svg>
</div>

<style>
  .pile-face { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .pf-titre { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .pf-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .pf-gauche { text-anchor: end; }
  .pf-axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .pf-ref { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 10 7; }
  .pf-ref-t { font-size: 18px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }

  .pf-ligne { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; stroke-linejoin: round; stroke-dasharray: 1; stroke-dashoffset: 1; animation: pf-trace 0.8s ease-out 0.15s forwards; }
  .pf-note { opacity: 0; animation: pf-fondu 0.4s ease-out 0.9s forwards; }
  .pf-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2; }
  .pf-lu { font-size: 18px; fill: var(--dk-encre); }
  .pf-droite { text-anchor: end; }
  .pf-val { font-weight: 600; }

  .pf-bas { opacity: 0; animation: pf-fondu 0.3s ease-out forwards; }
  .pf-phrase { font-size: 22px; font-weight: 600; fill: var(--dk-encre); opacity: 0; animation: pf-fondu 0.4s ease-out 1.2s forwards; }

  @keyframes pf-trace { to { stroke-dashoffset: 0; } }
  @keyframes pf-fondu { to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .pf-ligne { animation: none; stroke-dashoffset: 0; }
    .pf-note, .pf-bas, .pf-phrase { animation: none; opacity: 1; }
  }
</style>
