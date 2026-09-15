<script>
  /**
   * La vraie valeur extrême : combien de personnes vivent dans votre ménage ?
   * À gauche, la console, sortie de R mot pour mot (CONSOLES.menage, généré
   * par outils/seance3_data.R). À droite, les réponses de 1 à 12 personnes
   * (FORMES.menage) et la médiane, tracée à l'arrivée. Trois temps.
   *
   *   0  Les barres montent, la médiane (2) se trace.
   *   1  Le 4955 de « Mean » s'allume ; une flèche rouge file hors du
   *      graphique : la moyenne n'y tient pas.
   *   2  La coupable arrive : une seule réponse, 100 000 000 personnes. La
   *      seconde ligne de console le montre.
   */
  import { brancherTemps } from '../temps.js';
  import { CONSOLES, FORMES, MENAGE } from '$lib/data/seance3.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const [l1, l2] = CONSOLES.menage;
  const i = l1.out.indexOf('4955');
  const avant = l1.out.slice(0, i);
  const apres = l1.out.slice(i + 4);

  const F = FORMES.menage;
  const X0 = 70, X1 = 560, Y0 = 330, Y1 = 50;
  const pas = (X1 - X0) / F.valeurs.length;
  const MAX = 8000;
  const y = (n) => Y0 - (n / MAX) * (Y0 - Y1);
  const cx = (k) => X0 + (k + 0.5) * pas;
  const xMed = cx(F.valeurs.indexOf(F.mediane));
  const graduations = [0, 2000, 4000, 6000, 8000];
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const grand = milliers(MENAGE.max);
</script>

<div class="visuel menage" bind:this={hote}>
  <pre class="console"><span class="in"><span class="prompt">&gt;</span> {l1.in}</span><span class="out">{avant}<mark class:on={e >= 1}>4955</mark>{apres}</span>{#if e >= 2}<span class="suite"><span class="in"><span class="prompt">&gt;</span> {l2.in}</span><span class="out">{l2.out}</span></span>{/if}</pre>

  <div class="graphe">
    <svg viewBox="0 0 640 400" role="img" aria-label="Diagramme à barres : nombre de personnes dans le ménage, de 1 à 12. La plupart des ménages comptent 1 à 4 personnes, la médiane est de 2. La moyenne affichée par R, 4 955, sort du graphique à cause d'une réponse de 100 000 000.">
      {#each graduations as g}
        <line x1={X0 - 8} y1={y(g)} x2={X0} y2={y(g)} class="axe" />
        <text x={X0 - 14} y={y(g) + 5} class="tick d">{milliers(g)}</text>
      {/each}
      <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="axe" />
      <line x1={X0} y1={Y0} x2={X0} y2={Y1 - 10} class="axe" />
      {#each F.effectifs as n, k}
        <rect x={X0 + k * pas + 4} y={y(n)} width={pas - 8} height={Y0 - y(n)} class="barre" style="animation-delay: {k * 60}ms" />
        <text x={cx(k)} y={Y0 + 24} class="tick">{F.valeurs[k]}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={Y0 + 56} class="lab">personnes dans le ménage</text>

      <g class="med">
        <line x1={xMed} y1={Y0} x2={xMed} y2={Y1 - 6} />
        <text x={xMed + 12} y={Y1 + 4}>médiane · 2</text>
      </g>

      <g class="fleche" class:vu={e >= 1}>
        <line x1={xMed} y1="140" x2="626" y2="140" />
        <path d="M 610 128 L 628 140 L 610 152" />
        <text x="626" y="124">moyenne · 4{' '}955 →</text>
      </g>
    </svg>

    {#if e >= 2}
      <div class="carte">
        <span class="gros">{grand}</span>
        <span class="quoi">personnes dans un ménage</span>
        <span class="une">une seule réponse</span>
      </div>
    {/if}
  </div>

  <p class="source">Étude électorale canadienne 2025</p>
</div>

<style>
  .menage { display: grid; grid-template-columns: 1.1fr 1fr; gap: 0.4em 1.4em; align-items: center; }
  .console { margin: 0; font-family: var(--dk-mono); font-size: 0.66em; line-height: 1.55; white-space: pre; overflow-x: auto; background: var(--dk-fond-2); border: 3px solid var(--dk-encre); border-left-width: 0.5em; border-left-color: var(--dk-accent); padding: 0.7em 0.9em; align-self: center; }
  .in, .out { display: block; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); margin-bottom: 0.5em; }
  mark { background: none; color: inherit; padding: 0 0.1em; transition: background 0.3s, color 0.3s; }
  mark.on { background: var(--dk-accent); color: var(--dk-fond); font-weight: 600; animation: clin 0.45s ease-in-out 2; }
  @keyframes clin { 50% { background: transparent; color: var(--dk-accent); } }
  .suite { display: block; animation: fondu 0.4s 0.6s both; }
  .suite .out { color: var(--dk-encre); font-weight: 600; }

  .graphe { position: relative; min-width: 0; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .lab { font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }
  .barre { fill: var(--dk-gris-2); animation: monte 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: bottom; transform-box: fill-box; }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }

  .med { animation: fondu 0.4s 0.9s both; }
  .med line { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 10 8; }
  .med text { font-size: 17px; font-weight: 600; fill: var(--dk-accent); }

  .fleche line { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 560; stroke-dashoffset: 560; }
  .fleche path { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; opacity: 0; }
  .fleche text { font-size: 19px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); opacity: 0; }
  .fleche.vu line { animation: file 0.55s cubic-bezier(0.7, 0, 0.9, 0.6) forwards; }
  .fleche.vu path { animation: fondu 0.1s 0.5s forwards; }
  .fleche.vu text { animation: glisse 0.5s cubic-bezier(0.34, 1.6, 0.64, 1) 0.5s forwards; }
  @keyframes file { to { stroke-dashoffset: 0; } }
  @keyframes glisse { from { opacity: 0; transform: translateX(-40px); } to { opacity: 1; transform: none; } }

  .carte { position: absolute; right: -0.4em; bottom: 16%; display: flex; flex-direction: column; align-items: flex-start; gap: 0.1em; background: var(--dk-fond); border: 4px solid var(--dk-accent); padding: 0.5em 0.9em 0.6em; transform: rotate(-2deg); animation: claque 0.55s cubic-bezier(0.34, 1.7, 0.64, 1) both; }
  .gros { font-size: 2.3em; line-height: 1; font-weight: 600; color: var(--dk-accent); letter-spacing: -0.03em; white-space: nowrap; }
  .quoi { font-size: 0.95em; font-weight: 600; color: var(--dk-encre); }
  .une { font-size: 0.72em; color: var(--dk-gris); letter-spacing: 0.06em; }
  @keyframes claque { from { opacity: 0; transform: scale(2.4) rotate(-9deg); } 60% { opacity: 1; } to { opacity: 1; transform: rotate(-2deg); } }

  .source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }

  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .barre, .med, .suite, .carte, mark.on { animation: none; }
    .fleche.vu line, .fleche.vu path, .fleche.vu text { animation: none; stroke-dashoffset: 0; opacity: 1; }
  }
</style>
