<script>
  /**
   * Une fonction, c'est une machine. Trois temps.
   *
   *   0  La boîte noire : mean(). Quatre nombres entrent à gauche sur un
   *      tapis, 29.5 sort à droite. On ne voit pas dedans, et c'est correct.
   *   1  Le rideau se lève et on voit les rouages, ce que mean fait
   *      vraiment : additionner (sum), compter (length), diviser.
   *   2  La vraie console : les deux chemins donnent 29.5.
   *
   * Tout est en SVG et en images-clés CSS, sur un cycle de six secondes
   * qui boucle : la salle peut regarder deux fois. Rien d'aléatoire, rien
   * d'inventé : 118 ÷ 4 = 29.5 est ce que R répond.
   */
  import { brancherTemps } from '../temps.js';
  const AGES = [24, 30, 19, 45];
  const TEMPS = [
    ['LA BOÎTE NOIRE', 'Des valeurs entrent, un résultat sort. On ne voit pas dedans, et c’est correct : c’est une fonction.'],
    ['DEDANS', 'Ce que mean() fait vraiment : additionner les cases, les compter, diviser. Trois gestes que vous savez déjà faire.'],
    ['VOUS N’AUREZ JAMAIS À OUVRIR LA BOÎTE', 'Mais maintenant vous savez qu’il y a quelque chose dedans.']
  ];
  const LIGNES = [
    { in: 'mean(ages)', out: '[1] 29.5' },
    { in: 'sum(ages) / length(ages)', out: '[1] 29.5' }
  ];

  /** Un engrenage à n dents carrées, en polygone. Déterministe. */
  function engrenage(cx, cy, r, n = 8) {
    const pts = [];
    const pas = (Math.PI * 2) / n;
    const ri = r * 0.72;
    for (let i = 0; i < n; i++) {
      const a = i * pas;
      for (const [k, rr] of [[0, r], [0.5, r], [0.5, ri], [1, ri]]) {
        const t = a + k * pas;
        pts.push(`${(cx + rr * Math.cos(t)).toFixed(1)},${(cy + rr * Math.sin(t)).toFixed(1)}`);
      }
    }
    return pts.join(' ');
  }

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel machine" bind:this={hote}>
  <svg viewBox="0 0 1000 340" class:ouverte={e >= 1} class:fermee={e === 0} aria-hidden="true">
    <!-- Le tapis d'entrée : quatre jetons, un à la fois, vers la boîte. -->
    <text class="et" x="30" y="178">CE QU’ON DONNE</text>
    <line class="tapis" x1="30" y1="252" x2="318" y2="252" />
    {#each AGES as a, i}
      <g class="jeton" style="--d: {i * 0.36}s; --dx: {262 - i * 66}px">
        <rect x={30 + i * 66} y="198" width="52" height="44" />
        <text x={56 + i * 66} y="229">{a}</text>
      </g>
    {/each}

    <g class="boite">
      <rect class="corps" x="320" y="62" width="360" height="264" />

      <!-- Dedans : les rouages, visibles quand le rideau est levé. -->
      <g class="dedans">
        <polygon class="roue a" points={engrenage(352, 94, 20)} />
        <circle class="axe" cx="352" cy="94" r="5" />
        <polygon class="roue b" points={engrenage(648, 94, 20)} />
        <circle class="axe" cx="648" cy="94" r="5" />
        <text class="nom-p" x="500" y="102">mean()</text>

        <text class="etape" x="340" y="130">1 · ADDITIONNER · sum()</text>
        {#each AGES as a, i}
          <g class="somme" style="--d: {i * 0.18}s">
            <rect x={340 + i * 62} y="138" width="44" height="34" />
            <text x={362 + i * 62} y="162">{a}</text>
          </g>
          {#if i < 3}
            <text class="plus somme" style="--d: {i * 0.18 + 0.09}s" x={393 + i * 62} y="162">+</text>
          {/if}
        {/each}
        <text class="total" x="588" y="162">= 118</text>

        <text class="etape" x="340" y="204">2 · COMPTER · length()</text>
        {#each AGES as _, i}
          <rect class="coche" style="--d: {i * 0.14}s" x={340 + i * 34} y="212" width="24" height="24" />
        {/each}
        <text class="nombre" x="490" y="232">= 4 cases</text>

        <text class="etape" x="340" y="272">3 · DIVISER</text>
        <text class="division" x="340" y="306">118 ÷ 4</text>
        <text class="quotient" x="470" y="306">= 29.5</text>
      </g>

      <!-- Le rideau : la face avant, qui s'enroule vers le haut au temps 1. -->
      <g class="rideau">
        <rect x="320" y="64" width="360" height="262" />
        <text class="nom" x="500" y="208">mean()</text>
        <text class="sous" x="500" y="246">une fonction</text>
        <text class="points" x="500" y="296">• • •</text>
      </g>
      <rect class="rail" x="314" y="50" width="372" height="14" />
    </g>

    <!-- La sortie : le résultat saute hors de la boîte. -->
    <text class="et" x="800" y="178">CE QUI SORT</text>
    <line class="tapis sortie" x1="682" y1="252" x2="790" y2="252" />
    <g class="resultat">
      <rect x="800" y="192" width="160" height="64" />
      <text x="880" y="236">29.5</text>
    </g>
  </svg>

  <div class="bas">
    {#key e}
      <div class="legende">
        <span class="et-l">{TEMPS[e][0]}</span>
        <p>{TEMPS[e][1]}</p>
      </div>
    {/key}
    {#if e === 2}
      <pre class="console">{#each LIGNES as l}<span class="in"><span class="prompt">&gt;</span> {l.in}</span><span class="out">{l.out}</span>{/each}</pre>
    {/if}
  </div>
</div>

<style>
  .machine { display: flex; flex-direction: column; align-items: center; gap: 0.5em; }
  svg { width: 86%; height: auto; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  /* Dehors : encre et rouge sur papier. */
  .et { font-size: 15px; letter-spacing: 2.4px; font-weight: 600; fill: var(--dk-gris); }
  .tapis { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 14 10; animation: defiler 1.2s linear infinite; }
  .tapis.sortie { stroke: var(--dk-accent); }
  .jeton rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .jeton text { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .jeton { animation: entrer 6s ease-in-out infinite both; animation-delay: var(--d); }

  /* La boîte : encre, papier et or dedans. */
  .corps { fill: var(--dk-encre); }
  .rail { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; }
  .rideau rect { fill: var(--dk-encre); }
  .rideau { transform-box: fill-box; transform-origin: 50% 0; transition: transform 0.9s ease-in-out; }
  .ouverte .rideau { transform: scaleY(0.02); }
  .nom { font-size: 48px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent-clair); }
  .sous { font-size: 18px; text-anchor: middle; fill: var(--dk-fond); }
  .points { font-size: 22px; text-anchor: middle; fill: var(--dk-accent-clair); opacity: 0; }
  .fermee .points { animation: clignoter 6s linear infinite; }
  .fermee .boite { animation: travailler 6s linear infinite; }

  .dedans { opacity: 0; transition: opacity 0.4s 0.5s; }
  .ouverte .dedans { opacity: 1; }
  .roue { fill: none; stroke: var(--dk-accent-clair); stroke-width: 3; stroke-linejoin: miter; transform-box: fill-box; transform-origin: center; animation: tourner 5s linear infinite; }
  .roue.b { animation-direction: reverse; }
  .axe { fill: var(--dk-accent-clair); }
  .nom-p { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent-clair); }
  .etape { font-size: 15px; letter-spacing: 2px; font-weight: 600; fill: var(--dk-accent-clair); }
  .somme rect { fill: none; stroke: var(--dk-fond); stroke-width: 2.5; }
  .somme text, .plus { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .plus { fill: var(--dk-accent-clair); }
  .total, .nombre, .quotient { font-size: 24px; font-weight: 600; fill: var(--dk-accent-clair); }
  .division { font-size: 26px; font-weight: 600; fill: var(--dk-fond); }
  .coche { fill: var(--dk-accent-clair); stroke: var(--dk-fond); stroke-width: 2.5; }

  /* Les rouages ne tournent que boîte ouverte : chaque geste dans l'ordre. */
  .ouverte .somme { animation: apparaitre 6s linear infinite both; animation-delay: var(--d); }
  .ouverte .total { animation: sauter 6s linear infinite both; --t0: 56%; }
  .ouverte .coche { animation: cocher 6s linear infinite both; animation-delay: var(--d); }
  .ouverte .nombre { animation: sauter2 6s linear infinite both; }
  .ouverte .division { animation: apparaitre2 6s linear infinite both; }
  .ouverte .quotient { animation: sauter3 6s linear infinite both; }
  .total, .nombre, .quotient { transform-box: fill-box; transform-origin: center; }

  /* Le résultat : dans les deux états, il saute à cinq secondes. */
  .resultat rect { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .resultat text { font-size: 36px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .resultat { transform-box: fill-box; transform-origin: center; animation: resultat 6s ease-out infinite both; }

  @keyframes defiler { to { stroke-dashoffset: -24; } }
  @keyframes tourner { to { transform: rotate(360deg); } }
  /* Un jeton : apparaît, glisse jusqu'à la boîte, y entre. 0 à 2,4 s. */
  @keyframes entrer {
    0% { transform: translateX(0); opacity: 0; }
    4% { opacity: 1; }
    20% { transform: translateX(var(--dx)); opacity: 1; }
    26% { transform: translateX(calc(var(--dx) + 46px)); opacity: 0; }
    100% { transform: translateX(calc(var(--dx) + 46px)); opacity: 0; }
  }
  /* Boîte fermée : elle tremble pendant qu'elle travaille, 2,5 à 4,8 s. */
  @keyframes travailler {
    0%, 41% { transform: none; }
    43% { transform: translate(-3px, 1px); }
    46% { transform: translate(3px, -1px); }
    49% { transform: translate(-3px, 0); }
    52% { transform: translate(3px, 1px); }
    55% { transform: translate(-2px, -1px); }
    58% { transform: translate(3px, 0); }
    61% { transform: translate(-3px, 1px); }
    64% { transform: translate(2px, -1px); }
    67% { transform: translate(-3px, 0); }
    70% { transform: translate(3px, 1px); }
    73% { transform: translate(-2px, 0); }
    76% { transform: translate(2px, -1px); }
    79%, 100% { transform: none; }
  }
  @keyframes clignoter {
    0%, 41% { opacity: 0; }
    42% { opacity: 1; } 50% { opacity: 0.2; } 58% { opacity: 1; } 66% { opacity: 0.2; } 74% { opacity: 1; }
    80%, 100% { opacity: 0; }
  }
  /* Dedans : additionner à 2,5 s, total à 3,4 s, compter à 3,7 s, 4 à 4,3 s,
     diviser à 4,5 s, quotient à 4,8 s. Le résultat sort à 5 s. */
  @keyframes apparaitre { 0%, 41% { opacity: 0; transform: translateY(6px); } 44%, 100% { opacity: 1; transform: none; } }
  @keyframes sauter { 0%, 56% { opacity: 0; transform: scale(0.6); } 59% { opacity: 1; transform: scale(1.12); } 62%, 100% { opacity: 1; transform: scale(1); } }
  @keyframes cocher { 0%, 61% { fill-opacity: 0; } 63%, 100% { fill-opacity: 1; } }
  @keyframes sauter2 { 0%, 71% { opacity: 0; transform: scale(0.6); } 74% { opacity: 1; transform: scale(1.12); } 77%, 100% { opacity: 1; transform: scale(1); } }
  @keyframes apparaitre2 { 0%, 74% { opacity: 0; transform: translateY(6px); } 77%, 100% { opacity: 1; transform: none; } }
  @keyframes sauter3 { 0%, 79% { opacity: 0; transform: scale(0.6); } 82% { opacity: 1; transform: scale(1.12); } 85%, 100% { opacity: 1; transform: scale(1); } }
  @keyframes resultat { 0%, 82% { opacity: 0; transform: scale(0.5); } 86% { opacity: 1; transform: scale(1.12); } 90%, 100% { opacity: 1; transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .jeton, .boite, .points, .roue, .tapis, .somme, .total, .coche, .nombre, .division, .quotient, .resultat { animation: none; }
    .rideau { transition: none; }
  }

  /* En bas : le mot à gauche, la vraie console à droite au dernier temps. */
  .bas { width: 100%; display: grid; grid-template-columns: 1.2fr 1fr; gap: 1.4em; align-items: start; min-height: 4.4em; }
  .legende { display: flex; flex-direction: column; gap: 0.3em; }
  .et-l { font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.05em; line-height: 1.4; animation: fondu 0.4s both; }
  .console { margin: 0; font-family: var(--dk-mono); font-size: 0.95em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.5em 0.9em; animation: fondu 0.3s both; }
  .in, .out { display: block; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
