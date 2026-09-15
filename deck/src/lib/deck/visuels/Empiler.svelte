<script>
  /**
   * Une distribution, c'est des gens empilés. L'intérêt pour la politique
   * (0 à 10) des répondant.e.s de l'Étude électorale canadienne 2025, un
   * petit carré pour cent personnes (src/lib/data/seance3.js).
   *
   *   0  Les carrés tombent, colonne par colonne, et s'empilent au-dessus
   *      de leur valeur.
   *   1  Chaque pile se fond en une barre pleine ; l'effectif exact apparaît.
   *   2  La médiane s'allume (7), et le nombre de « ne sait pas » écartés.
   */
  import { brancherTemps } from '../temps.js';
  import { FORMES } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const F = FORMES.interet;
  const PAR = 3;          // carrés par rangée
  const P = 24, C = 20;   // pas et côté d'un carré
  const X0 = 90, X1 = 930, Y0 = 400;
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
  const fmt = (n) => n.toLocaleString('fr-CA');
  const hautMed = Y0 - colonnes[iMed].h;
</script>

<div class="visuel empiler" bind:this={hote}>
  <div class="puces">
    <code class="code">table(df$cps25_interest_gen_1)</code>
    <span class="leg"><i></i> = 100 personnes</span>
    <span class="sans" class:vu={e >= 2}>{fmt(F.sans)} «&#8239;ne sait pas&#8239;» écartés</span>
  </div>
  <svg viewBox="0 0 1000 480" role="img" aria-label="Intérêt pour la politique, de 0 à 10, Étude électorale canadienne 2025 : la plupart des personnes se situent entre 6 et 10 ; médiane 7.">
    {#each colonnes as col, i}
      <rect x={cx(i) - (PAR * P) / 2 + 2} y={Y0 - col.h} width={PAR * P - 4} height={col.h} class="barre" class:on={e >= 1} class:med={e >= 2 && i === iMed} />
      <text x={cx(i)} y={Y0 - col.h - 10} class="n" class:vu={e >= 1}>{fmt(col.n)}</text>
      <g class="carres" class:fondu={e >= 1}>
        {#each col.carres as c}
          <rect x={c.x} y={c.y} width={C} height={C} class="carre" style="--d: {c.d}ms" />
        {/each}
      </g>
      <text x={cx(i)} y={Y0 + 30} class="tick" class:med={e >= 2 && i === iMed}>{F.valeurs[i]}</text>
    {/each}
    <line x1={X0 - 10} y1={Y0} x2={X1 + 10} y2={Y0} class="axe" />
    <text x={cx(0) - slot / 2} y={Y0 + 66} class="bout">0 · aucun intérêt</text>
    <text x={cx(10) + slot / 2} y={Y0 + 66} class="bout d">10 · beaucoup</text>
    <g class="mediane" class:vu={e >= 2}>
      <text x={cx(iMed)} y="40" class="med-t">médiane · {F.mediane}</text>
      <line x1={cx(iMed)} y1="52" x2={cx(iMed)} y2={hautMed - 38} />
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

  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .carre { fill: var(--dk-encre); animation: pluie 0.6s cubic-bezier(0.3, 1.45, 0.55, 1) both; animation-delay: var(--d); }
  .carres { transition: opacity 0.45s; }
  .carres.fondu { opacity: 0; }
  .barre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; transform: scaleY(0); transition: transform 0.55s cubic-bezier(0.3, 1.3, 0.5, 1), fill 0.4s; }
  .barre.on { transform: scaleY(1); }
  .barre.med { fill: var(--dk-accent); }
  .n { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s 0.3s; }
  .n.vu { opacity: 1; }
  .tick { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.4s; }
  .tick.med { fill: var(--dk-accent); }
  .bout { font-size: 17px; fill: var(--dk-gris); }
  .bout.d { text-anchor: end; }
  .mediane { opacity: 0; transition: opacity 0.4s; }
  .mediane.vu { opacity: 1; }
  .mediane line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .med-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  @keyframes pluie {
    0% { transform: translateY(-460px); opacity: 0; }
    15% { opacity: 1; }
    100% { transform: none; opacity: 1; }
  }

  @media (prefers-reduced-motion: reduce) {
    .carre { animation: none; }
    .carres, .barre, .n, .mediane, .sans, .tick { transition: none; }
  }
</style>
