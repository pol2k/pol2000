<script>
  /**
   * Crème glacée et noyades : 240 mois inventés (« Données fictives »), un
   * point par mois. En x, la crème glacée vendue (millions de cornets); en y,
   * les noyades du mois. Le même nuage sert deux diapos, selon `mode`.
   *
   * mode = 'naif' (« Interdire la crème glacée ? »), quatre temps :
   *   0  Les axes seuls.
   *   1  Les 240 mois arrivent.
   *   2  La droite de R se trace, avec le code et la pente (+8,4 noyades par
   *      million de cornets).
   *   3  La question : « Interdire la crème glacée ? »
   *
   * mode = 'tranches' (« À chaleur égale »), cinq temps :
   *   0  Le nuage et la droite naïve, comme à la fin de la diapo précédente.
   *   1  Les mois froids seulement (autour de -10 °C, à 2 °C près) : leurs
   *      points en rouge, les autres pâlissent, et leur droite à eux, presque
   *      plate.
   *   2  Les mois doux (autour de 4 °C), même chose.
   *   3  Les mois chauds (autour de 19 °C), même chose.
   *   4  Les trois droites ensemble, et la leçon : une relation biaisée.
   *
   * Tout vient de src/lib/data/seance7_e.js (outils/seance7_e.R) : MOIS (les
   * points), NAIF (lm(noyades ~ cremes) sur les 240 mois), TRANCHES (la même
   * régression dans chaque tranche de chaleur : pente, constante, et l'étendue
   * de la crème glacée pour ne tracer la droite que là où il y a des points).
   * Rien n'est tiré au hasard ici.
   */
  import { brancherTemps } from '../temps.js';
  import { MOIS, NAIF, TRANCHES } from '$lib/data/seance7_e.js';

  let { mode = 'naif' } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: mode === 'naif' ? 3 : 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' '; // espace fine insécable, avant « : ? ! »
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const signe = (v, d = 1) => (v < 0 ? '−' : '+') + f(Math.abs(v), d);

  // Repères : crème glacée de 0 à 12 millions de cornets, noyades de 0 à 95.
  const XMAX = 12, YMAX = 95;
  const X0 = 100, X1 = 900, Y0 = 450, Y1 = 30;
  const x = (v) => X0 + (v / XMAX) * (X1 - X0);
  const y = (v) => Y0 - (v / YMAX) * (Y0 - Y1);
  const TX = [0, 2, 4, 6, 8, 10, 12];
  const TY = [0, 20, 40, 60, 80];

  // La droite naïve, tracée seulement là où elle reste dans le cadre (la
  // constante de R est négative : on part de y = 0).
  const cmin = Math.min(...MOIS.map((m) => m.c)), cmax = Math.max(...MOIS.map((m) => m.c));
  const da = Math.max(cmin, -NAIF.b0 / NAIF.b1), db = Math.min(cmax, (YMAX - NAIF.b0) / NAIF.b1);
  const NAIVE = { x1: x(da), y1: y(NAIF.b0 + NAIF.b1 * da), x2: x(db), y2: y(NAIF.b0 + NAIF.b1 * db) };

  // Les tranches de chaleur : la droite de chaque tranche, sur l'étendue de ses points.
  const T = TRANCHES.map((t, k) => ({
    ...t, k,
    x1: x(t.xmin), y1: y(t.b0 + t.b1 * t.xmin),
    x2: x(t.xmax), y2: y(t.b0 + t.b1 * t.xmax)
  }));
  const tranche = (m) => T.findIndex((t) => Math.abs(m.t - t.centre) <= 2);
  const PTS = MOIS.map((m, i) => ({ ...m, i, k: tranche(m) }));
  const deg = (v) => (v < 0 ? '−' : '') + Math.abs(v) + ' °C';

  // Quelle tranche est en avant (mode tranches, temps 1 à 3).
  const active = $derived(mode === 'tranches' && e >= 1 && e <= 3 ? e - 1 : -1);
</script>

<div class="visuel gn" class:gn-tranches={mode === 'tranches'} bind:this={hote}>
  {#if mode === 'naif'}
    <pre class="gn-code" class:gn-vu={e >= 2}><span class="gn-fn">lm</span>(noyades <span class="gn-op">~</span> cremes, <span class="gn-arg">data</span> = mois)</pre>
  {/if}

  <svg viewBox="0 0 1100 520" role="img" aria-label="Nuage de points, données fictives : 240 mois, la crème glacée vendue et les noyades. Plus on vend de crème glacée, plus il y a de noyades : la pente de R est de {signe(NAIF.b1)} noyades par million de cornets.{mode === 'tranches' ? ` Parmi les mois d’une même chaleur, la pente est presque nulle : ${T.map((t) => `${signe(t.b1)} autour de ${deg(t.centre)}`).join(', ')}.` : ''}">
    <!-- Les axes. -->
    <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="gn-axe" />
    <line x1={X0} y1={Y0} x2={X0} y2={Y1} class="gn-axe" />
    {#each TX as v}
      <line x1={x(v)} y1={Y0} x2={x(v)} y2={Y0 + 8} class="gn-axe" />
      <text x={x(v)} y={Y0 + 30} class="gn-tick">{v}</text>
    {/each}
    {#each TY as v}
      <line x1={X0 - 8} y1={y(v)} x2={X0} y2={y(v)} class="gn-axe" />
      <text x={X0 - 14} y={y(v) + 6} class="gn-tick gn-d">{v}</text>
    {/each}
    <text x={X1} y={Y0 + 62} class="gn-lab gn-fin">crème glacée vendue (millions de cornets)</text>
    <text transform="translate(30 {(Y0 + Y1) / 2}) rotate(-90)" class="gn-lab">noyades dans le mois</text>

    <!-- Les 240 mois. -->
    {#each PTS as p}
      <circle
        cx={x(p.c)} cy={y(p.n)} r="5.5"
        class="gn-pt"
        class:gn-vu={mode === 'tranches' || e >= 1}
        class:gn-pale={mode === 'tranches' && e >= 1 && (e === 4 ? p.k < 0 : p.k !== active)}
        class:gn-rouge={p.k >= 0 && p.k === active}
        style="transition-delay: {mode === 'naif' && e === 1 ? p.i * 5 : 0}ms"
      />
    {/each}

    <!-- La droite naïve. -->
    {#if mode === 'naif'}
      <line {...NAIVE} pathLength="1" class="gn-naive gn-trace" class:gn-vu={e >= 2} />
      <g class="gn-etape gn-tard" class:gn-vu={e >= 2}>
        <text x={X0 + 30} y={Y1 + 26} class="gn-pente">{signe(NAIF.b1)} noyades</text>
        <text x={X0 + 30} y={Y1 + 56} class="gn-pente-s">par million de cornets</text>
      </g>
      <text x={x(8.9)} y={y(17)} class="gn-q gn-etape" class:gn-vu={e >= 3}>Interdire</text>
      <text x={x(8.9)} y={y(17) + 46} class="gn-q gn-etape" class:gn-vu={e >= 3}>la crème glacée{N}?</text>
    {:else}
      <line {...NAIVE} class="gn-naive" class:gn-recule={e >= 1} />
      <text x={X0 + 30} y={Y1 + 26} class="gn-pente" class:gn-recule-t={e >= 1}>toute l’année{N}: {signe(NAIF.b1)}</text>
      <g class="gn-etape" class:gn-vu={e >= 4}>
        <text x={X0 + 30} y={Y1 + 66} class="gn-pente">à chaleur égale{N}: ≈ 0</text>
        <text x={X0 + 30} y={Y1 + 100} class="gn-lecon">une relation biaisée</text>
      </g>

      <!-- Les tranches : leur droite reste une fois tracée. -->
      {#each T as t}
        <line x1={t.x1} y1={t.y1} x2={t.x2} y2={t.y2} pathLength="1" class="gn-tr gn-trace" class:gn-vu={e >= t.k + 1} class:gn-actif={t.k === active || e === 4} />
        <g class="gn-etape" class:gn-vu={e >= t.k + 1}>
          <text x={t.x2 + 16} y={t.y2 - 4} class="gn-t" class:gn-actif-t={t.k === active || e === 4}>mois à {deg(t.centre)}</text>
          <text x={t.x2 + 16} y={t.y2 + 24} class="gn-ts" class:gn-actif-t={t.k === active || e === 4}>pente{N}: {signe(t.b1)}</text>
        </g>
      {/each}

    {/if}

    <text x={X0} y={Y0 + 62} class="gn-source">Données fictives · 240 mois</text>
  </svg>
</div>

<style>
  .gn { display: flex; flex-direction: column; gap: 0.4em; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); }

  .gn-code { margin: 0; align-self: flex-start; font-family: var(--dk-mono); font-size: 1em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.35em 0.8em; opacity: 0; transition: opacity 0.4s; }
  .gn-code.gn-vu { opacity: 1; }
  .gn-fn { color: var(--dk-accent-clair); font-weight: 600; } .gn-op { color: var(--dk-accent-clair); } .gn-arg { color: var(--dk-gris-2); }

  .gn-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .gn-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .gn-d { text-anchor: end; }
  .gn-lab { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .gn-fin { text-anchor: end; }
  .gn-source { font-size: 17px; fill: var(--dk-gris); }

  .gn-pt { fill: var(--dk-encre); fill-opacity: 0.7; opacity: 0; transition: opacity 0.3s, fill 0.4s, fill-opacity 0.4s; }
  .gn-pt.gn-vu { opacity: 1; }
  .gn-pt.gn-pale { fill: var(--dk-gris-2); fill-opacity: 0.22; }
  .gn-pt.gn-rouge { fill: var(--dk-accent); fill-opacity: 0.9; }

  .gn-trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.9s ease-out; }
  .gn-trace.gn-vu { stroke-dashoffset: 0; }
  .gn-naive { stroke: var(--dk-accent); stroke-width: 5; transition: stroke 0.4s, stroke-width 0.4s, stroke-dashoffset 0.9s ease-out; }
  .gn-tranches .gn-naive { stroke: var(--dk-accent); }
  .gn-naive.gn-recule { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 10 8; }
  .gn-pente { font-size: 30px; font-weight: 700; fill: var(--dk-accent); transition: fill 0.4s; }
  .gn-pente.gn-recule-t { fill: var(--dk-gris-2); }
  .gn-pente-s { font-size: 21px; fill: var(--dk-accent); }

  .gn-tr { stroke: var(--dk-encre); stroke-width: 6; stroke-linecap: square; transition: stroke 0.4s, stroke-dashoffset 0.8s ease-out 0.3s; }
  .gn-tr.gn-actif { stroke: var(--dk-accent); }
  .gn-t { font-size: 24px; font-weight: 700; fill: var(--dk-encre); transition: fill 0.4s; }
  .gn-ts { font-size: 20px; fill: var(--dk-encre); transition: fill 0.4s; }
  .gn-actif-t { fill: var(--dk-accent); }

  .gn-q { font-size: 38px; font-weight: 700; fill: var(--dk-accent); }
  .gn-lecon { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }

  .gn-etape { opacity: 0; transition: opacity 0.3s; }
  .gn-etape.gn-vu { opacity: 1; transition: opacity 0.5s; }
  .gn-etape.gn-tard.gn-vu { transition: opacity 0.5s 0.7s; }

  @media (prefers-reduced-motion: reduce) {
    .gn-pt, .gn-trace, .gn-naive, .gn-tr, .gn-etape, .gn-etape.gn-vu, .gn-etape.gn-tard.gn-vu { transition: none; }
  }
</style>
