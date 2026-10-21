<script>
  /**
   * Le verdict : le chiffre de Blais (1965-2004) et le nôtre (2025), sur la
   * même règle, en points de pourcentage.
   *
   *   0  Blais : 18 points (il ne publie pas d'intervalle : un point seul);
   *   1  2025 : le coefficient de « catholique » avec contrôles, et son
   *      intervalle de confiance à 95 %;
   *   2  l'intervalle touche zéro (pas d'étoile), mais il est loin de 18 :
   *      on peut exclure le chiffre de Blais.
   *
   * Blais vient de BLAIS (recopié de l'article), 2025 de COEFS.modele2.
   */
  import { brancherTemps } from '../temps.js';
  import { BLAIS, COEFS } from '$lib/data/seance8.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const C = COEFS.modele2.find((c) => c.terme === 'catho');
  const b = C.b * 100, bas = C.bas * 100, haut = C.haut * 100, bl = BLAIS.catho * 100;
  const X0 = 120, LX = 760, MIN = -5, MAX = 20;
  const px = (v) => X0 + ((v - MIN) / (MAX - MIN)) * LX;
  const TICKS = [-5, 0, 5, 10, 15, 20];
</script>

<div class="visuel m8v" bind:this={hote}>
  <svg viewBox="0 0 1000 400" role="img" aria-label="Catholiques et vote libéral, en points de pourcentage. Blais, 1965 à 2004 : {f(bl, 0)}. CES 2025, avec contrôles : {f(b)}, intervalle de confiance de {f(bas)} à {f(haut)}. L'intervalle contient zéro mais pas {f(bl, 0)}.">
    <line x1={px(MIN)} y1="300" x2={px(MAX)} y2="300" class="axe" />
    {#each TICKS as t}
      <line x1={px(t)} y1="300" x2={px(t)} y2="308" class="axe" />
      <text x={px(t)} y="334" class="tick">{t > 0 ? '+' : ''}{f(t, 0)}</text>
    {/each}
    <line x1={px(0)} y1="40" x2={px(0)} y2="300" class="zero" />
    <text x={px(MAX)} y="370" class="titre-axe">points de pourcentage de plus pour les catholiques</text>

    <g>
      <circle cx={px(bl)} cy="100" r="13" class="pt-blais" />
      <text x={px(bl)} y="70" class="lab-fort fin">Blais{' '}: +{f(bl, 0)}</text>
      <text x={px(bl)} y="138" class="lab fin">1965-2004</text>
    </g>

    <g class="etape" class:vu={e >= 1}>
      <line x1={px(bas)} y1="220" x2={px(haut)} y2="220" class="ic" />
      <line x1={px(bas)} y1="208" x2={px(bas)} y2="232" class="ic" />
      <line x1={px(haut)} y1="208" x2={px(haut)} y2="232" class="ic" />
      <circle cx={px(b)} cy="220" r="13" class="pt-nous" />
      <text x={px(haut) + 22} y="214" class="lab-fort rouge">2025{' '}: {b > 0 ? '+' : ''}{f(b)}</text>
      <text x={px(haut) + 22} y="242" class="lab">de {f(bas)} à {f(haut)}, à 95 %</text>
    </g>

    <g class="etape" class:vu={e >= 2}>
      <line x1={px(haut) + 8} y1="160" x2={px(bl) - 18} y2="160" class="ecart" />
      <text x={(px(haut) + px(bl)) / 2} y="150" class="lab-fort mid">loin hors de l’intervalle</text>
    </g>
  </svg>
  <p class="fin-p" class:vu={e >= 2}>Pas d’étoile : on ne distingue pas 2025 de zéro. Mais <strong>on peut exclure les 18 points de Blais</strong>.</p>
</div>

<style>
  .m8v { max-width: 62em; margin: 0.6em auto 0; display: flex; flex-direction: column; gap: 0.8em; }
  svg { width: 100%; height: auto; max-height: 54vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .zero { stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 6 5; }
  .tick { font-size: 18px; fill: var(--dk-gris); text-anchor: middle; }
  .titre-axe { font-size: 18px; fill: var(--dk-gris); text-anchor: end; }
  .pt-blais { fill: var(--dk-encre); }
  .pt-nous { fill: var(--dk-accent); }
  .ic { stroke: var(--dk-accent); stroke-width: 4; }
  .ecart { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 4 4; }
  .lab-fort { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .lab { font-size: 18px; fill: var(--dk-gris); }
  .fin { text-anchor: middle; }
  .mid { text-anchor: middle; font-size: 19px; }
  .rouge { fill: var(--dk-accent); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  .fin-p { margin: 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.2em; opacity: 0; transition: opacity 0.4s; }
  .fin-p.vu { opacity: 1; }
  .fin-p strong { color: var(--dk-accent-clair); }
  @media (prefers-reduced-motion: reduce) { .etape, .fin-p { transition: none; } }
</style>
