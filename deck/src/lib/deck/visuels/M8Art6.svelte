<script module>
  /**
   * TP 1, étape 6 (la contribution), dans le vrai article : la contribution
   * annoncée dès le résumé (p. 425), théorique et méthodologique, puis, dans
   * le texte, la limite des études antérieures (p. 426) et les trois apports
   * de l'étude (p. 427), un par temps. La carte de M8Fil.
   */
  const C1 = 'The current study, contrary to previous ones, looks at satisfaction with democracy immediately before and immediately after an election.';
  const C2 = 'it is important to consider as well those that are neither winners nor losers, that is, those who did not vote.';
  const C3 = 'There is no comparable analysis for parliamentary regimes, distinguishing winners and losers at the local and national levels. The current study fills that gap.';
  export const ETATS = [
    {
      passages: [
        { phrase: 'It makes a theoretical and methodological contribution to our understanding of the factors that foster satisfaction with democracy.' },
        { phrase: 'At the theoretical level, we argue that voters gain different utility from winning at the constituency and national levels in a parliamentary system', ton: 'x' },
        { phrase: 'On the methodological front, our analysis includes a control group (non-voters) and incorporates a control for the level of satisfaction prior to the election.', ton: 'x' }
      ]
    },
    { passages: [{ phrase: 'Almost all prior studies are cross-sectional and compare the views of winners and losers after the election.' }] },
    { passages: [{ phrase: C1, tag: '1' }] },
    { passages: [{ phrase: C1, ton: 'encre', tag: '1' }, { phrase: C2, tag: '2' }], focus: 1 },
    { passages: [{ phrase: C1, ton: 'encre', tag: '1' }, { phrase: C2, ton: 'encre', tag: '2' }, { phrase: C3, tag: '3' }], focus: 2 }
  ];
  const APPORTS = [
    { txt: 'Avant <strong>et</strong> après l’élection, chez les mêmes personnes', type: 'méthode' },
    { txt: 'Ceux qui n’ont pas voté, pour comparer', type: 'méthode' },
    { txt: 'Gagner dans la circonscription, gagner au pays', type: 'théorie' }
  ];
</script>

<script>
  // e : le temps de cette étape (0 = son premier passage). M8Fil.
  let { e = 0 } = $props();
</script>

{#snippet temps(plein)}
  <svg class="m8n-temps" viewBox="0 0 300 64" aria-hidden="true">
    <line x1="20" y1="24" x2="280" y2="24" class="m8n-axe" />
    <line x1="150" y1="8" x2="150" y2="40" class="m8n-elec" />
    <circle cx="70" cy="24" r="9" class={plein ? 'm8n-pt-on' : 'm8n-pt-off'} />
    <circle cx="230" cy="24" r="9" class={plein ? 'm8n-pt-on' : 'm8n-pt-encre'} />
    <text x="70" y="60">avant</text>
    <text x="150" y="60">élection</text>
    <text x="230" y="60">après</text>
  </svg>
{/snippet}

{#if e === 0}
  <span class="m8n-eti">La consigne</span>
  <p class="m8n-consigne">Comment voulez-vous contribuer à la littérature&#8239;? Quelle limite voulez-vous combler&#8239;?</p>
  <span class="m8n-eti">Leur résumé, p. 425</span>
  <p class="m8n-grand">La contribution, annoncée dès le résumé</p>
  <p class="m8n-deux"><span class="m8n-chip">Théorique</span><span class="m8n-chip">Méthodologique</span></p>
{:else if e === 1}
  <span class="m8n-eti">La limite qu’ils comblent, p. 426</span>
  <p class="m8n-grand">Une seule mesure, après l’élection</p>
  {@render temps(false)}
{:else}
  <span class="m8n-eti">Leurs trois apports, p. 427</span>
  <ol class="m8n-liste">
    {#each APPORTS.slice(0, e - 1) as a, i}
      <li class:on={i === e - 2}>
        <span class="m8n-num">{i + 1}</span>
        <span class="m8n-txt">{@html a.txt}</span>
        <span class="m8n-type">{a.type}</span>
      </li>
    {/each}
  </ol>
  {#if e === 2}{@render temps(true)}{/if}
{/if}

<style>
  .m8n-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-consigne { margin: 0 0 0.4em; font-size: 0.85em; line-height: 1.4; font-style: italic; color: var(--dk-gris); }
  .m8n-grand { margin: 0; font-size: 1.35em; font-weight: 700; line-height: 1.3; }
  .m8n-deux { margin: 0.1em 0 0; display: flex; flex-wrap: wrap; gap: 0.5em; }
  .m8n-chip { font-size: 0.85em; font-weight: 700; padding: 0.25em 0.6em; background: var(--dk-encre); color: var(--dk-fond); }

  .m8n-liste { margin: 0; padding: 0; list-style: none; display: flex; flex-direction: column; gap: 0.55em; }
  .m8n-liste li { display: grid; grid-template-columns: 1.6em minmax(0, 1fr); column-gap: 0.6em; align-items: start; font-size: 1.05em; line-height: 1.3; color: var(--dk-encre); }
  .m8n-num { grid-row: span 2; display: inline-grid; place-items: center; width: 1.6em; height: 1.6em; font-weight: 700; background: var(--dk-encre); color: var(--dk-fond); }
  .m8n-type { font-size: 0.6em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-liste li.on .m8n-num { background: var(--dk-accent); }
  .m8n-liste li.on .m8n-txt { color: var(--dk-accent); font-weight: 700; }
  .m8n-liste li.on .m8n-txt :global(strong) { font-weight: 800; }

  .m8n-temps { width: 100%; max-width: 16em; height: auto; margin-top: 0.2em; overflow: visible; }
  .m8n-temps text { font-family: inherit; font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .m8n-axe { stroke: var(--dk-gris-2); stroke-width: 2; }
  .m8n-elec { stroke: var(--dk-encre); stroke-width: 3; }
  .m8n-pt-off { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 4 3; }
  .m8n-pt-encre { fill: var(--dk-encre); }
  .m8n-pt-on { fill: var(--dk-accent); }
</style>
