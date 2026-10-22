<script module>
  /**
   * TP 1, étape 2 (la littérature et une théorie), dans le vrai article :
   * leur revue de la littérature (p. 425-427) lue comme une partie de Risk
   * (même métaphore que TmRisque, séance 7). La carte de droite est un petit
   * plateau qui se construit au rythme des passages surlignés :
   *
   *   0  p. 425  le camp établi : les gagnants sont plus satisfaits;
   *   1  p. 426  ses armées : les 10 articles cités, un pion chacun;
   *   2  p. 426  sa théorie : on aime le gagnant, on lui fait confiance;
   *   3  p. 426  le front : presque tout est mesuré après l'élection; à la
   *              frontière, deux exceptions (Anderson et LoTempio 2002, panel
   *              sur la confiance; Anderson et al. 2005, déjà parmi les 10);
   *   4  p. 427  leur coup : avant et après l'élection, leur drapeau.
   *
   * Le plateau est un schéma, mais les noms et le compte (10 références dans
   * la parenthèse de la p. 426) sont ceux de l'article. Aucun camp rival :
   * l'article n'en présente pas. Le plateau est redessiné à chaque temps
   * (M8Article remonte la carte à chaque temps) : ce qui est acquis est statique, seul ce
   * qui arrive au temps e s'anime.
   */

  export const ETATS = [
    { passages: [
      { phrase: 'The extant literature has provided ample empirical evidence', ton: 'encre' },
      { phrase: 'those who vote for the winning party in electoral contests are generally more satisfied with democracy than those who vote for the losing parties' }
    ], focus: 1 },
    { passages: [
      { phrase: 'Electoral outcomes have been found to have an impact on citizens’ attitudes towards democratic institutions', ton: 'encre' },
      { phrase: '(Anderson and Guillory, 1997; Anderson and Tverdova, 2001; Anderson et al., 2005; Bowler and Donovan, 2002; Clarke and Kornberg, 1992; Fuchs et al., 1995; Ginsberg and Weissberg, 1978; Joslyn, 1999; Listhaug, 1995; Norris, 1999a)' }
    ], focus: 1 },
    { passages: [
      { phrase: 'because they like and/or trust the party/individual who has been elected' },
      { phrase: 'The pattern is well established and makes sense theoretically', ton: 'encre' }
    ] },
    { passages: [
      { phrase: 'Almost all prior studies are cross-sectional and compare the views of winners and losers after the election' },
      { phrase: 'Two notable exceptions are Christopher Anderson and Andrew LoTempio’s (2002) panel study, which deals with political trust rather than with satisfaction with democracy', ton: 'encre' },
      { phrase: 'Anderson et al.’s (2005) analysis', ton: 'encre' }
    ] },
    { passages: [
      { phrase: 'The current study, contrary to previous ones, looks at satisfaction with democracy immediately before and immediately after an election' }
    ] }
  ];

  const ETI = ['p. 425 · le camp établi', 'p. 426 · ses armées', 'p. 426 · sa théorie', 'p. 426 · le front', 'p. 427 · leur coup'];

  // Le plateau (viewBox 320 × 246). Le camp établi à gauche, le territoire
  // inexploré à droite; la frontière commune est le front.
  const CAMP = '8,14 180,6 196,104 172,214 22,238 4,120';
  const INCONNU = '180,6 314,20 310,226 172,214 196,104';
  const FRONT = 'M 180 6 L 196 104 L 172 214';

  // Les 10 pions : un par référence de la parenthèse, p. 426. Le cinquième,
  // contre le front, est Anderson et al. (2005).
  const PIONS = [36, 66, 96, 126, 156].flatMap((x) => [100, 128].map((y) => ({ x, y })))
    .sort((a, b) => a.y - b.y || a.x - b.x);
  const I2005 = 4;
</script>

<script>
  // e : le temps de cette étape (0 = son premier passage). M8Fil.
  let { e = 0 } = $props();
</script>

<span class="m8n-eti">{ETI[e]}</span>
<svg class="m8r" viewBox="0 0 320 246" role="img" aria-label="Plateau schématique de leur revue de la littérature : le camp établi et ses dix articles, sa théorie, le front avec le territoire inexploré, et leur drapeau.">
  <defs>
    <pattern id="m8r-hach" width="9" height="9" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
      <rect width="9" height="9" class="m8r-hach-fond" />
      <line x1="0" y1="0" x2="0" y2="9" class="m8r-hach" />
    </pattern>
  </defs>

  <!-- Le territoire inexploré : dessiné en filet, rempli au temps 3. -->
  <polygon points={INCONNU} class="m8r-vide" class:m8r-explore={e >= 3} class:m8r-neuf={e === 3} />

  <!-- 0 · le camp établi -->
  <g class:m8r-neuf={e === 0}>
    <polygon points={CAMP} class="m8r-camp" />
    <text x="96" y="36" class="m8r-t-camp">gagner →</text>
    <text x="96" y="55" class="m8r-t-camp">plus satisfait</text>
  </g>

  <!-- 1 · ses armées -->
  {#if e >= 1}
    {#each PIONS as p, i}
      <rect x={p.x - 9} y={p.y - 9} width="18" height="18" class="m8r-pion" class:m8r-rouge={e >= 3 && i === I2005} class:m8r-tombe={e === 1} style="--i: {i}" />
    {/each}
    <text x="96" y="160" class="m8r-t-compte" class:m8r-neuf={e === 1}>10 articles</text>
  {/if}

  <!-- 2 · sa théorie -->
  {#if e >= 2}
    <g class:m8r-neuf={e === 2}>
      <rect x="18" y="172" width="148" height="42" class="m8r-banniere" />
      <text x="92" y="189" class="m8r-t-ban">on fait confiance</text>
      <text x="92" y="206" class="m8r-t-ban">au gagnant</text>
    </g>
  {/if}

  <!-- 3 · le front et les deux exceptions -->
  {#if e >= 3}
    <path d={FRONT} class="m8r-front" class:m8r-trace={e === 3} pathLength="1" />
    <g class:m8r-neuf={e === 3}>
      <text x="254" y="48" class="m8r-t-zone">avant</text>
      <text x="254" y="68" class="m8r-t-zone">l’élection&#8239;?</text>
      <text x="156" y="82" class="m8r-t-an">2005</text>
      <rect x="207" y="111" width="18" height="18" class="m8r-pion m8r-rouge" />
      <text x="232" y="118" class="m8r-t-an m8r-g">LoTempio</text>
      <text x="232" y="134" class="m8r-t-an m8r-g">2002</text>
      <text x="207" y="158" class="m8r-t-exc">2 exceptions</text>
    </g>
  {/if}

  <!-- 4 · leur coup -->
  {#if e >= 4}
    <g class="m8r-drapeau" class:m8r-plante={e === 4}>
      <line x1="262" y1="166" x2="262" y2="216" class="m8r-mat" />
      <rect x="262" y="166" width="46" height="26" class="m8r-toile" />
      <text x="285" y="184" class="m8r-t-toile">2007</text>
    </g>
  {/if}
</svg>
<div class="m8n-bas">
{#if e === 0}
  <span class="m8n-eti">La consigne</span>
  <p class="m8n-consigne">Deux paragraphes, quatre références scientifiques. Dégagez une théorie.</p>
{:else}
<p class="m8n-legende">
  {#if e === 1}<b>Un territoire</b> = un camp<br /><b>Un pion</b> = un article cité
  {:else if e === 2}<b>La théorie</b> = pourquoi le camp tient
  {:else if e === 3}<b>Le front</b> = presque tout est mesuré après l’élection
  {:else}<b>Leur drapeau</b> = avant et après l’élection
  {/if}
</p>
{/if}
</div>
<span class="m8n-note">Schéma. Années et compte réels.</span>

<style>
  .m8n-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-bas { min-height: 4.3em; display: flex; flex-direction: column; justify-content: center; gap: 0.2em; }
  .m8n-legende { margin: 0; font-size: 0.95em; line-height: 1.3; display: block; }
  .m8n-consigne { margin: 0; font-size: 0.8em; line-height: 1.35; font-style: italic; color: var(--dk-gris); }
  .m8n-legende b { font-weight: 700; color: var(--dk-accent); }
  .m8n-note { font-size: 0.55em; letter-spacing: 0.04em; color: var(--dk-gris); }

  .m8r { display: block; width: 100%; height: auto; overflow: visible; }
  .m8r text { font-family: var(--dk-mono); }

  .m8r-vide { fill: var(--dk-fond); stroke: var(--dk-filet); stroke-width: 2.5; stroke-dasharray: 6 5; stroke-linejoin: round; }
  .m8r-explore { fill: url(#m8r-hach); stroke: var(--dk-gris-2); stroke-dasharray: none; }
  .m8r-hach-fond { fill: var(--dk-fond); }
  .m8r-hach { stroke: var(--dk-filet); stroke-width: 3; }
  .m8r-camp { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; stroke-linejoin: round; }

  .m8r-t-camp { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .m8r-t-compte { font-size: 14px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .m8r-t-ban { font-size: 13.5px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .m8r-t-zone { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }
  .m8r-t-an { font-size: 14px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent-clair); }
  .m8r-t-an.m8r-g { text-anchor: start; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }
  .m8r-t-exc { font-size: 13px; font-weight: 600; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }
  .m8r-t-toile { font-size: 14px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }

  .m8r-pion { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .m8r-pion.m8r-rouge { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2.5; }
  .m8r-banniere { fill: var(--dk-fond); }
  .m8r-front { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 0.035 0.025; }
  .m8r-mat { stroke: var(--dk-encre); stroke-width: 4; }
  .m8r-toile { fill: var(--dk-accent); stroke: var(--dk-encre); stroke-width: 2; }

  /* Ce qui arrive au temps e s'anime, après l'arrivée de la carte (~1,3 s). */
  .m8r-neuf { animation: m8r-paraitre 0.5s ease-out 1.35s both; }
  .m8r-tombe { transform-box: fill-box; animation: m8r-tomber 0.4s cubic-bezier(0.34, 1.6, 0.64, 1) calc(1.35s + var(--i) * 0.07s) both; }
  .m8r-trace { animation: m8r-paraitre 0.6s ease-out 1.35s both; }
  .m8r-plante { transform-box: fill-box; transform-origin: 0 100%; animation: m8r-planter 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) 1.4s both; }
  @keyframes m8r-paraitre { from { opacity: 0; } to { opacity: 1; } }
  @keyframes m8r-tomber { from { opacity: 0; transform: translateY(-22px); } to { opacity: 1; transform: none; } }
  @keyframes m8r-planter { from { opacity: 0; transform: scaleY(0); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .m8r-neuf, .m8r-tombe, .m8r-trace, .m8r-plante { animation: none; }
  }
</style>
