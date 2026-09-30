<script>
  /**
   * Qu'est-ce qui a mal tourné en 1936 ? L'électorat en 400 points, du moins
   * aisé (à gauche) au plus aisé (à droite), et le filet du Literary Digest
   * qui n'en attrape qu'un coin. Schéma : la disposition est inventée pour
   * l'explication; les pourcentages affichés sont les vrais (DIGEST dans
   * src/lib/data/seance5.js, Squire 1988, p. 126-127). Quatre temps.
   *
   *   0  L'électorat : 400 points colorés selon le vrai résultat (Roosevelt
   *      61 %, Landon 37 %, autres 2 %). Landon est plus fréquent du côté
   *      aisé (le schéma le montre, sans chiffre).
   *   1  Premier filtre, les listes (lecteurs, automobiles, téléphone) : un
   *      cadre sur le côté aisé; le reste pâlit.
   *   2  Second filtre, qui répond : environ un sur quatre dans le cadre,
   *      surtout des partisans de Landon (la non-réponse, le filtre qui a
   *      fait le plus de dégâts selon Squire). À droite : ce que le Digest a
   *      vu (Landon 55 %) contre la réalité (Roosevelt 61 %).
   *   3  Gallup, environ 50 000 personnes choisies pour ressembler à
   *      l'électorat, prédit Roosevelt; le Digest disparaît peu après
   *      (Wikipédia, « The Literary Digest », consulté le 30 septembre 2026).
   *      La leçon.
   *
   * Les points sont placés par un petit générateur à graine fixe (pas de
   * Math.random) : la même image à chaque fois. Les comptes de points
   * visent les vrais pourcentages (148 Landon, 8 autres sur 400 au départ;
   * 20 Landon, 15 Roosevelt, 2 autres parmi les répondants).
   */
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const COLS = 25, RANGS = 16, N = COLS * RANGS;
  const GX = 50, GY = 96, PX = 22, PY = 20.5, R = 7;
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
  const pale = (p) => (e >= 1 && p.c < CADRE) || (e >= 2 && !p.repond);
  const CX0 = GX + CADRE * PX - PX / 2 - 2, CX1 = GX + (COLS - 1) * PX + PX / 2 + 2;
</script>

<div class="visuel digest-filtres" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Schéma. L’électorat de 1936, du moins aisé au plus aisé : {DIGEST.resultat.Roosevelt} % Roosevelt, {DIGEST.resultat.Landon} % Landon. Premier filtre, les listes du Digest : seulement le côté aisé. Second filtre, qui répond : environ un sur quatre, surtout des partisans de Landon. Le Digest voit {DIGEST.prevision.Landon} % Landon. Pendant ce temps, George Gallup interroge environ 50 000 personnes choisies pour ressembler à l’électorat et prédit Roosevelt. Mieux vaut un petit échantillon bien choisi qu’un énorme échantillon biaisé.">
    <text x={GX - 8} y="30" class="df-titre">l’électorat de 1936</text>
    <text x={GX - 8} y="56" class="df-leg"><tspan class="df-r">■</tspan> Roosevelt {DIGEST.resultat.Roosevelt}&#8239;% · <tspan class="df-l">■</tspan> Landon {DIGEST.resultat.Landon}&#8239;% · <tspan class="df-a">■</tspan> autres</text>
    <text x="620" y="30" class="df-note">schéma · les pourcentages sont les vrais</text>

    {#each POINTS as p}
      <rect x={X(p) - R} y={Y(p) - R} width={R * 2} height={R * 2} class="df-pt df-{p.vote}" class:df-pale={pale(p)} />
    {/each}
    <text x={GX - 8} y={GY + RANGS * PY + 10} class="df-axe-t">← moins aisés</text>
    <text x={GX + (COLS - 1) * PX + 8} y={GY + RANGS * PY + 10} class="df-axe-t df-fin">plus aisés →</text>

    <!-- 1 : les listes. -->
    <g class="df-etape" class:df-vu={e >= 1}>
      <rect x={CX0} y={GY - 16} width={CX1 - CX0} height={RANGS * PY + 12} class="df-cadre" />
      <text x={CX0} y={GY - 24} class="df-f"><tspan class="df-num">1</tspan> sur les listes&#8239;: autos, téléphone</text>
    </g>
    <!-- 2 : qui répond. -->
    <g class="df-etape" class:df-vu={e >= 2}>
      <text x={CX0} y={GY + RANGS * PY + 40} class="df-f"><tspan class="df-num">2</tspan> qui répond&#8239;: 1 sur 4, surtout pro-Landon</text>
      <text x="620" y="110" class="df-bloc-t">Ce que le Digest a vu</text>
      <text x="620" y="150" class="df-gros df-l">Landon {DIGEST.prevision.Landon}&#8239;%</text>
      <text x="620" y="200" class="df-bloc-t">La réalité</text>
      <text x="620" y="240" class="df-gros">Roosevelt {DIGEST.resultat.Roosevelt}&#8239;%</text>
      <text x="620" y="272" class="df-mini">le 2e filtre, la non-réponse, a fait</text>
      <text x="620" y="292" class="df-mini">le plus de dégâts (Squire, 1988)</text>
    </g>
    <!-- 3 : Gallup, et la leçon. -->
    <g class="df-etape" class:df-vu={e >= 3}>
      <rect x="610" y="316" width="370" height="112" class="df-gallup" />
      <text x="626" y="346" class="df-bloc-t">George Gallup&#8239;: environ 50 000</text>
      <text x="626" y="372" class="df-mini">personnes, choisies pour ressembler</text>
      <text x="626" y="394" class="df-mini">à l’électorat. Il prédit Roosevelt.</text>
      <text x="626" y="418" class="df-mini">Le Digest disparaît peu après.</text>
      <text x="500" y="492" class="df-lecon">Mieux vaut un petit échantillon bien choisi qu’un énorme biaisé.</text>
    </g>
  </svg>
</div>

<style>
  .digest-filtres { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }
  .df-titre { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .df-leg { font-size: 17px; fill: var(--dk-encre); }
  .df-note { font-size: 14px; fill: var(--dk-gris); }
  .df-r { fill: var(--dk-encre); }
  .df-l { fill: var(--dk-accent); }
  .df-a { fill: var(--dk-gris-2); }
  .df-pt { transition: opacity 0.6s; }
  .df-R { fill: var(--dk-encre); }
  .df-L { fill: var(--dk-accent); }
  .df-A { fill: var(--dk-gris-2); }
  .df-pale { opacity: 0.12; }
  .df-axe-t { font-size: 16px; fill: var(--dk-gris); }
  .df-fin { text-anchor: end; }
  .df-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .df-f { font-size: 17px; font-weight: 600; fill: var(--dk-encre); }
  .df-num { fill: var(--dk-accent); }
  .df-bloc-t { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .df-gros { font-size: 32px; font-weight: 700; fill: var(--dk-encre); }
  .df-gros.df-l { fill: var(--dk-accent); }
  .df-mini { font-size: 16px; fill: var(--dk-gris); }
  .df-gallup { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2.5; }
  .df-lecon { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .df-etape { opacity: 0; transition: opacity 0.3s; }
  .df-etape.df-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .df-etape, .df-etape.df-vu, .df-pt { transition: none; }
  }
</style>
