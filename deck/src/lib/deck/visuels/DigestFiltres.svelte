<script>
  /**
   * Quel était le problème en 1936 ? L'électorat en 400 carrés, du moins
   * aisé (à gauche) au plus aisé (à droite), et le filet du Literary Digest
   * qui n'en attrape qu'un coin. Schéma : la disposition est inventée pour
   * l'explication, les pourcentages affichés sont les vrais (DIGEST dans
   * src/lib/data/seance5.js, Squire 1988, p. 126-127). Une idée par clic.
   *
   *   0  L'électorat seul, en gris, une étiquette. La question est dans le
   *      titre de la diapositive.
   *   1  Les carrés prennent la couleur du vrai vote (Roosevelt 61 %,
   *      Landon 37 %, autres 2 %). Landon est plus fréquent du côté aisé
   *      (le schéma le montre, sans chiffre). Légende, axe, avertissement.
   *   2  Le filet du Digest, ses listes : un cadre sur le côté aisé, le
   *      reste pâlit.
   *   3  Dans le cadre, seuls ceux qui ont répondu restent : environ un sur
   *      quatre, surtout des partisans de Landon. Selon Squire, cette
   *      non-réponse a fait plus de dégâts que les listes.
   *   4  À droite, en gros : ce que le Digest a vu (Landon 55 %) contre la
   *      réalité (Roosevelt 61 %).
   *   5  La chute : des millions de réponses, mais pas les bonnes.
   *
   * Les carrés sont placés par un petit générateur à graine fixe (pas de
   * Math.random) : la même image à chaque fois. Les comptes visent les vrais
   * pourcentages (148 Landon, 8 autres sur 400 au départ, puis 20 Landon,
   * 15 Roosevelt, 2 autres parmi les répondants). Ne pas toucher à COLS,
   * RANGS, CADRE ni à la graine : les votes et les répondants en dépendent.
   */
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  const COLS = 25, RANGS = 16, N = COLS * RANGS;
  const GX = 50, GY = 130, PX = 22, PY = 20.5, R = 7;
  const CADRE = 15; // colonnes 15 à 24 : sur les listes
  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(1936);
  const POINTS = Array.from({ length: N }, (_, i) => {
    const c = i % COLS, r = Math.floor(i / COLS);
    return { c, r, u: alea(), vote: alea() < 0.2 + (0.36 * c) / (COLS - 1) ? 'L' : 'R' };
  });
  // Les totaux exacts : 148 Landon (37 %), 8 autres (2 %), le reste Roosevelt.
  const CIBLE_L = Math.round((N * DIGEST.resultat.Landon) / 100);
  const AUTRES = N - CIBLE_L - Math.round((N * DIGEST.resultat.Roosevelt) / 100);
  (() => {
    let L = POINTS.filter((p) => p.vote === 'L');
    if (L.length > CIBLE_L) {
      L.sort((a, b) => a.c - b.c || a.u - b.u).slice(0, L.length - CIBLE_L).forEach((p) => (p.vote = 'R'));
    } else if (L.length < CIBLE_L) {
      POINTS.filter((p) => p.vote === 'R').sort((a, b) => b.c - a.c || a.u - b.u).slice(0, CIBLE_L - L.length).forEach((p) => (p.vote = 'L'));
    }
    POINTS.filter((p) => p.vote === 'R').sort((a, b) => a.u - b.u).slice(0, AUTRES).forEach((p) => (p.vote = 'A'));
  })();
  // Les répondants : dans le cadre, 20 Landon, 15 Roosevelt, 2 autres.
  (() => {
    const dans = POINTS.filter((p) => p.c >= CADRE);
    const prendre = (v, k) => dans.filter((p) => p.vote === v).sort((a, b) => a.u - b.u).slice(0, k).forEach((p) => (p.repond = true));
    prendre('L', 20); prendre('R', 15); prendre('A', 2);
  })();
  const X = (p) => GX + p.c * PX;
  const Y = (p) => GY + p.r * PY;
  const pale = (p) => (e >= 2 && p.c < CADRE) || (e >= 3 && !p.repond);
  const CX0 = GX + CADRE * PX - PX / 2 - 2, CX1 = GX + (COLS - 1) * PX + PX / 2 + 2;
  const UN_SUR = Math.round(1 / DIGEST.taux);
  const MILLIONS = (DIGEST.retournes / 1e6).toLocaleString('fr-CA', { maximumFractionDigits: 1 });
</script>

<div class="visuel digest-filtres" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="Schéma. L’électorat de 1936, du moins aisé au plus aisé : {DIGEST.resultat.Roosevelt} % Roosevelt, {DIGEST.resultat.Landon} % Landon. Les listes du Digest n’attrapent que le côté aisé. Là-dedans, environ 1 sur {UN_SUR} a répondu, surtout des partisans de Landon. Le Digest a vu Landon à {DIGEST.prevision.Landon} %, la réalité a été Roosevelt à {DIGEST.resultat.Roosevelt} %. {MILLIONS} millions de réponses, mais pas les bonnes.">
    <!-- 0 : l'électorat, seul. -->
    <text x={GX - 8} y="34" class="df-titre">l’électorat de 1936</text>
    {#each POINTS as p}
      <rect x={X(p) - R} y={Y(p) - R} width={R * 2} height={R * 2} class="df-pt df-{p.vote}" class:df-n={e < 1} class:df-pale={pale(p)} />
    {/each}

    <!-- 1 : le vrai vote. -->
    <g class="df-etape" class:df-vu={e >= 1}>
      <text x={GX - 8} y="68" class="df-leg"><tspan class="df-r">■</tspan> Roosevelt {DIGEST.resultat.Roosevelt}&#8239;% · <tspan class="df-l">■</tspan> Landon {DIGEST.resultat.Landon}&#8239;% · <tspan class="df-a">■</tspan> autres</text>
      <text x="980" y="34" class="df-note">schéma · les % sont les vrais</text>
      <text x={GX - 8} y={GY + RANGS * PY + 14} class="df-axe-t">← moins aisés</text>
      <text x={CX1} y={GY + RANGS * PY + 14} class="df-axe-t df-fin">plus aisés →</text>
    </g>

    <!-- 2 : le filet du Digest. -->
    <g class="df-etape" class:df-vu={e >= 2}>
      <rect x={CX0} y={GY - 16} width={CX1 - CX0} height={RANGS * PY + 12} class="df-cadre" />
    </g>
    <g class="df-etape" class:df-vu={e === 2}>
      <text x={CX0} y={GY - 26} class="df-f">les listes du Digest</text>
    </g>

    <!-- 3 : qui répond. -->
    <g class="df-etape" class:df-vu={e >= 3}>
      <text x={CX0} y={GY - 26} class="df-f">1 sur {UN_SUR} a répondu</text>
    </g>

    <!-- 4 : ce qu'il a vu, ce qui est arrivé. -->
    <g class="df-etape" class:df-vu={e >= 4}>
      <text x="620" y="178" class="df-bloc-t">le Digest a vu</text>
      <text x="620" y="228" class="df-gros df-l">Landon {DIGEST.prevision.Landon}&#8239;%</text>
      <text x="620" y="300" class="df-bloc-t">la réalité</text>
      <text x="620" y="350" class="df-gros">Roosevelt {DIGEST.resultat.Roosevelt}&#8239;%</text>
    </g>

    <!-- 5 : la chute. -->
    <g class="df-etape" class:df-vu={e >= 5}>
      <text x="620" y="418" class="df-chute">{MILLIONS} millions de réponses,</text>
      <text x="620" y="446" class="df-chute">mais pas les bonnes.</text>
    </g>
  </svg>
</div>

<style>
  .digest-filtres { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }
  .df-titre { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .df-leg { font-size: 18px; fill: var(--dk-encre); }
  .df-note { font-size: 17px; fill: var(--dk-gris); text-anchor: end; }
  .df-r { fill: var(--dk-encre); }
  .df-l { fill: var(--dk-accent); }
  .df-a { fill: var(--dk-gris-2); }
  .df-pt { transition: opacity 0.6s, fill 0.6s; }
  .df-R { fill: var(--dk-encre); }
  .df-L { fill: var(--dk-accent); }
  .df-A { fill: var(--dk-gris-2); }
  /* Après les couleurs du vote : à égalité de spécificité, l'ordre décide. */
  .df-n { fill: var(--dk-gris-2); }
  .df-pale { opacity: 0.12; }
  .df-axe-t { font-size: 17px; fill: var(--dk-gris); }
  .df-fin { text-anchor: end; }
  .df-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .df-f { font-size: 20px; font-weight: 700; fill: var(--dk-encre); }
  .df-bloc-t { font-size: 22px; fill: var(--dk-gris); }
  .df-gros { font-size: 42px; font-weight: 700; fill: var(--dk-encre); }
  .df-gros.df-l { fill: var(--dk-accent); }
  .df-chute { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .df-etape { opacity: 0; transition: opacity 0.3s; }
  .df-etape.df-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .df-etape, .df-etape.df-vu, .df-pt { transition: none; }
  }
</style>
