<script>
  /**
   * Des dominos pour la flèche d'un GOA (Arel-Bundock 2021, p. 117-118).
   *
   * mode « oriente » :
   *   0  trois dominos debout, A, B, C;
   *   1  on pousse A : A tombe sur B, B sur C. A cause B, B cause C, donc
   *      A cause C : un chemin;
   *   2  on relève tout et on pousse C : C tombe, rien ne tombe derrière.
   *      La flèche a un sens;
   *   3  le vocabulaire : B et C sont les descendants de A, A et B les
   *      ancêtres de C;
   *   4  acyclique : et si C faisait tomber A ? A est déjà par terre. Un
   *      domino tombé ne retombe pas : pas de boucle dans un GOA.
   * mode « controle » (la chaîne contrôlée, p. 121) :
   *   0  trois dominos, une main tient B (le cadre rouge : contrôlé);
   *   1  on pousse A : A s'appuie sur B, qui ne bouge pas. C reste debout.
   *      Contrôler le maillon central coupe la chaîne.
   *
   * Schéma, aucune donnée. Les chutes sont des animations CSS qui
   * finissent sur leur position de repos (forwards) : l'image de chaque
   * temps ne dépend que du temps.
   */
  import { brancherTemps } from '../temps.js';

  let { mode = 'oriente' } = $props();
  const TOTAL = mode === 'oriente' ? 4 : 1;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  const X = { A: 260, B: 470, C: 680 };
  const W = 44, H = 230, SOL = 470;
  // Angle d'appui : le haut du domino touche le suivant (écart 210 − 44 = 166).
  const APPUI = Math.round((Math.asin((X.B - X.A - W) / H) * 180) / Math.PI);

  // Ce qui tombe, et de combien, à chaque temps.
  const chute = $derived.by(() => {
    if (mode === 'controle') return e >= 1 ? { A: [APPUI, 0] } : {};
    if (e === 1 || e >= 3) return { A: [APPUI, 0], B: [APPUI, 0.35], C: [84, 0.7] };
    if (e === 2) return { C: [84, 0] };
    return {};
  });
  const LEG = $derived(
    mode === 'controle'
      ? ['On tient B.', 'A pousse, B ne bouge pas : C reste debout. La chaîne est coupée.'][e]
      : [
          'Trois dominos.',
          'On pousse A : A cause B, B cause C. Donc A cause C.',
          'On pousse C : rien ne tombe derrière. La flèche a un sens.',
          'B et C sont les descendants de A. A et B sont les ancêtres de C.',
          'Et si C faisait tomber A ? A est déjà par terre. Pas de boucle.'
        ][e]
  );
</script>

<div class="visuel m11o" bind:this={hote}>
  <svg viewBox="0 0 1000 560" role="img" aria-label="Trois dominos, A, B et C. On pousse A : A fait tomber B, qui fait tomber C. Pousser C ne fait rien tomber derrière lui.">
    <line x1="80" y1={SOL} x2="960" y2={SOL} class="sol" />

    <!-- la poussée -->
    {#if (mode === 'oriente' && (e === 1 || e >= 3)) || (mode === 'controle' && e >= 1)}
      <g class="pousse"><path d="M 120 290 L 220 290" /><polygon points="238,290 212,276 212,304" /><text x="150" y="270">poussée</text></g>
    {:else if mode === 'oriente' && e === 2}
      <g class="pousse"><path d="M 560 290 L 640 290" /><polygon points="658,290 632,276 632,304" /><text x="590" y="270">poussée</text></g>
    {/if}

    {#each ['A', 'B', 'C'] as d (d + e)}
      {@const c = chute[d]}
      <g class="domino" class:tombe={!!c} style="--x: {X[d]}px; --a: {c ? c[0] : 0}deg; --d: {c ? c[1] : 0}s">
        <rect x={X[d]} y={SOL - H} width={W} height={H} class="corps" class:accent={mode === 'oriente' && e === 3 && d !== 'A'} />
        <circle cx={X[d] + W / 2} cy={SOL - H + 50} r="7" class="point" />
        <circle cx={X[d] + W / 2} cy={SOL - 50} r="7" class="point" />
      </g>
      <text x={X[d] + W / 2} y={SOL + 50} class="nom" class:accent={mode === 'oriente' && e === 3 && d !== 'A'}>{d}</text>
    {/each}

    {#if mode === 'controle'}
      <rect x={X.B - 16} y={SOL - H - 16} width={W + 32} height={H + 16} class="cadre" />
      <text x={X.B + W / 2} y={SOL - H - 34} class="tenu">on tient B</text>
    {/if}

    {#if mode === 'oriente' && e === 3}
      <g class="etiq">
        <path d="M {X.B} {SOL + 70} L {X.C + W} {SOL + 70}" />
        <text x={(X.B + X.C + W) / 2} y={SOL + 104} class="t-acc">descendants de A</text>
      </g>
    {/if}

    {#if mode === 'oriente' && e === 4}
      <g class="boucle">
        <path d="M {X.C + 70} {SOL - 20} C {X.C + 140} {SOL - 300} {X.A - 60} {SOL - 360} {X.A - 50} {SOL - 40}" />
        <polygon points="{X.A - 50},{SOL - 14} {X.A - 64},{SOL - 46} {X.A - 34},{SOL - 44}" />
        <g transform="translate({(X.A + X.C) / 2 - 10} {SOL - 330})">
          <rect x="-26" y="-26" width="52" height="52" />
          <path d="M -13 -13 L 13 13 M 13 -13 L -13 13" />
        </g>
      </g>
    {/if}
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG}</p>
</div>

<style>
  .m11o { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; max-width: 46em; height: auto; max-height: 56vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .sol { stroke: var(--dk-encre); stroke-width: 4; }

  .domino .corps { fill: var(--dk-encre); }
  .domino .corps.accent { fill: var(--dk-accent); }
  .domino .point { fill: var(--dk-fond); }
  .domino { transform-box: view-box; transform-origin: calc(var(--x) + 44px) 470px; }
  .domino.tombe { animation: m11o-tombe 0.45s ease-in forwards; animation-delay: var(--d); }
  @keyframes m11o-tombe { from { transform: rotate(0deg); } to { transform: rotate(var(--a)); } }

  .nom { font-size: 40px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .nom.accent { fill: var(--dk-accent); }
  .pousse path { stroke: var(--dk-accent); stroke-width: 8; }
  .pousse polygon { fill: var(--dk-accent); }
  .pousse text { font-size: 24px; font-weight: 700; fill: var(--dk-accent); }
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 6; }
  .tenu { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .etiq path { stroke: var(--dk-accent); stroke-width: 5; fill: none; }
  .t-acc { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .boucle path { fill: none; stroke: var(--dk-gris-2); stroke-width: 6; stroke-dasharray: 14 10; }
  .boucle polygon { fill: var(--dk-gris-2); }
  .boucle rect { fill: var(--dk-accent); }
  .boucle g path { stroke: #fff; stroke-width: 6; stroke-dasharray: none; }

  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  @media (prefers-reduced-motion: reduce) { .domino.tombe { animation-duration: 0.01s; animation-delay: 0s; } }
</style>
