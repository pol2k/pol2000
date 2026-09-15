<script>
  /**
   * Même centre, autre histoire. Deux groupes de quinze points sur la même
   * échelle de 0 à 100, avec exactement la même moyenne (50, vérifiée
   * ci-dessous). Valeurs fictives, dites telles sur la figure.
   *
   *   0  Les deux rangées arrivent identiques et serrées autour de 50.
   *   1  La rangée B s'étire vers l'extérieur, en ressort, pendant que A
   *      reste serrée ; l'accolade de B s'élargit, en rouge.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const ECARTS_A = [-6, -5, -4, -3, -2, -1, 0, 0, 0, 1, 2, 3, 4, 5, 6];
  const ECARTS_B = [-38, -30, -24, -18, -12, -8, -4, 0, 4, 8, 12, 18, 24, 30, 38];
  const A = ECARTS_A.map((d) => 50 + d);
  const B = ECARTS_B.map((d) => 50 + d);
  const moyenne = (v) => v.reduce((s, x) => s + x, 0) / v.length;
  const MOY = moyenne(A);
  if (MOY !== moyenne(B)) throw new Error('Etalement : les deux groupes doivent avoir la même moyenne.');

  const X0 = 130, X1 = 900;
  const x = (v) => X0 + (v / 100) * (X1 - X0);
  const YA = 120, YB = 270;
  const dy = (i) => ((i % 3) - 1) * 18;
  const demi = (v) => (x(Math.max(...v)) - x(Math.min(...v))) / 2;
  const wA = demi(A), wB = demi(B);
  const wBvu = $derived(e >= 1 ? wB : wA);
  const texteB = $derived(e >= 1 ? `de ${Math.min(...B)} à ${Math.max(...B)}` : `de ${Math.min(...A)} à ${Math.max(...A)}`);
</script>

<div class="visuel etalement" bind:this={hote}>
  <svg viewBox="0 0 1000 420" role="img" aria-label="Deux groupes de quinze points avec la même moyenne de 50 : le groupe A serré autour de 50, le groupe B étalé de 12 à 88. Exemple fictif.">
    <!-- La moyenne, commune aux deux rangées. -->
    <line x1={x(MOY)} y1="52" x2={x(MOY)} y2="338" class="moy" />
    <text x={x(MOY)} y="38" class="moy-t">moyenne · {MOY}</text>

    <text x="20" y={YA + 6} class="nom">Groupe A</text>
    <text x="20" y={YB + 6} class="nom">Groupe B</text>

    {#each A as v, i}
      <g class="pt" style="transform: translate({x(v)}px, {YA + dy(i)}px)">
        <circle r="10" style="--d: {i * 40}ms" />
      </g>
    {/each}
    {#each B as v, i}
      <g class="pt ressort" style="transform: translate({e >= 1 ? x(v) : x(A[i])}px, {YB + dy(i)}px); transition-delay: {Math.abs(ECARTS_B[i]) * 8}ms">
        <circle r="10" class="b" style="--d: {i * 40 + 120}ms" />
      </g>
    {/each}

    <!-- Les accolades : la largeur de chaque rangée. -->
    <g class="accolade" style="transform: translate({x(MOY)}px, {YA + 50}px)">
      <line x1="-1" x2="1" y1="0" y2="0" style="transform: scaleX({wA})" vector-effect="non-scaling-stroke" />
      <line x1="0" x2="0" y1="-9" y2="9" style="transform: translateX({-wA}px)" />
      <line x1="0" x2="0" y1="-9" y2="9" style="transform: translateX({wA}px)" />
      <text y="30" class="larg">de {Math.min(...A)} à {Math.max(...A)}</text>
    </g>
    <g class="accolade rouge" style="transform: translate({x(MOY)}px, {YB + 50}px)">
      <line x1="-1" x2="1" y1="0" y2="0" style="transform: scaleX({wBvu})" vector-effect="non-scaling-stroke" />
      <line x1="0" x2="0" y1="-9" y2="9" style="transform: translateX({-wBvu}px)" />
      <line x1="0" x2="0" y1="-9" y2="9" style="transform: translateX({wBvu}px)" />
      {#key texteB}<text y="30" class="larg">{texteB}</text>{/key}
    </g>

    <line x1={x(0)} y1="370" x2={x(100)} y2="370" class="axe" />
    {#each [0, 25, 50, 75, 100] as t}
      <line x1={x(t)} y1="370" x2={x(t)} y2="378" class="axe" />
      <text x={x(t)} y="398" class="tick">{t}</text>
    {/each}
    <text x={X1} y="416" class="note">exemple fictif</text>
  </svg>
</div>

<style>
  .etalement { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .moy { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 7; }
  .moy-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .nom { font-size: 17px; font-weight: 600; fill: var(--dk-encre); }
  .pt { transition: transform 0.9s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .pt circle { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: pop 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  .pt circle.b { fill: var(--dk-encre); }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  .accolade line { stroke: var(--dk-encre); stroke-width: 3; transition: transform 0.9s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .accolade.rouge line { stroke: var(--dk-accent); stroke-width: 4; }
  /* Un halo couleur papier : la ligne de la moyenne passe derrière le texte, pas à travers. */
  .larg { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; animation: fondu 0.4s both; }
  .accolade.rouge .larg { fill: var(--dk-accent); font-weight: 600; }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .note { font-size: 14px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }
  @media (prefers-reduced-motion: reduce) {
    .pt, .accolade line { transition: none; }
    .pt circle, .larg { animation: none; }
  }
</style>
