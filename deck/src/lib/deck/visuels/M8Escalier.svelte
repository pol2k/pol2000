<script>
  /**
   * Une variable à la fois : la pente de la scolarité quand on ajoute l'âge,
   * puis « femme », le revenu et le Québec. Toujours les mêmes personnes
   * (ESCALIER.n, les 877 du modèle complet de la séance 7), pour que seule
   * la liste de variables change. Chaque rangée : le coefficient et son
   * intervalle de confiance à 95 %, et à droite le R².
   *
   *   0  la scolarité seule;
   *   1 à 4  une variable de plus à chaque clic.
   *
   * Ce qu'on dit : le coefficient bouge (l'âge le fait monter, le revenu le
   * fait redescendre) et le R² grimpe. Rien n'est calculé ici : tout vient
   * de ESCALIER (src/lib/data/seance8.js).
   */
  import { brancherTemps } from '../temps.js';
  import { ESCALIER as E } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: E.modeles.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  const X0 = 300, X1 = 760, MAX = 0.3;
  const gx = (v) => X0 + (v / MAX) * (X1 - X0);
  const RY = (i) => 90 + i * 74;
</script>

<div class="visuel m8e" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La pente de la scolarité, variable par variable : {E.modeles.map((m) => `${m.ajout} ${sg(m.b)} (R² ${f(m.r2)})`).join(', ')}.">
    <text x="0" y="36" class="ent">variables dans le modèle</text>
    <text x={(X0 + X1) / 2} y="36" class="ent c">pente de la scolarité</text>
    <text x="930" y="36" class="ent c">R²</text>
    {#each [0, 0.1, 0.2, 0.3] as t}
      <line x1={gx(t)} y1="56" x2={gx(t)} y2={RY(4) + 30} class="grille" class:zero={t === 0} />
      <text x={gx(t)} y={RY(4) + 58} class="tick">{f(t, 1)}</text>
    {/each}
    {#each E.modeles as m, i}
      <g class="rang" class:vu={e >= i}>
        <text x="0" y={RY(i) + 8} class="aj" class:neuf={i === e && i > 0}>{i === 0 ? 'scolarité seule' : m.ajout}</text>
        <line x1={gx(m.bas)} y1={RY(i)} x2={gx(m.haut)} y2={RY(i)} class="ic" />
        <circle cx={gx(m.b)} cy={RY(i)} r="10" class="pt" class:pt-neuf={i === e} />
        <text x={gx(m.haut) + 14} y={RY(i) + 8} class="b">{sg(m.b)}</text>
        <rect x="880" y={RY(i) - 16} width={m.r2 / 0.2 * 100} height="32" class="r2" />
        <text x="930" y={RY(i) + 8} class="r2t">{f(m.r2)}</text>
      </g>
    {/each}
    <text x="0" y="494" class="source">Notre sondage de la séance 7 · toujours les mêmes {E.n} personnes · les traits : intervalle de confiance à 95{' '}%</text>
  </svg>
</div>

<style>
  .m8e { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ent { font-size: 18px; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .c { text-anchor: middle; }
  .grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .grille.zero { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 17px; fill: var(--dk-gris); text-anchor: middle; }
  .aj { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .aj.neuf { fill: var(--dk-accent); }
  .ic { stroke: var(--dk-encre); stroke-width: 4; }
  .pt { fill: var(--dk-encre); }
  .pt.pt-neuf { fill: var(--dk-accent); }
  .b { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .r2 { fill: var(--dk-fond-2); }
  .r2t { font-size: 22px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }
  .source { font-size: 15px; fill: var(--dk-gris); }
  .rang { opacity: 0; transition: opacity 0.4s; }
  .rang.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .rang { transition: none; } }
</style>
