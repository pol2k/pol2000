<script>
  /**
   * TP 1, étape 3 (l'hypothèse), dans le vrai article : comment Blais et
   * Gélineau tirent leurs hypothèses de la littérature. La théorie (p. 426)
   * donne l'hypothèse principale; une prémisse sur le régime parlementaire
   * donne, « for this reason », la deuxième (p. 427); la théorie des
   * anticipations rationnelles donne la troisième (p. 427). Le résumé
   * (p. 425) dit ensuite lesquelles tiennent. M8Article.
   */
  import M8Article from './M8Article.svelte';

  const THEORIE = 'Citizens who cast their vote for the winning party are more inclined to display faith in the way democracy works, because they like and/or trust the party/individual who has been elected.';
  const PREMISSE = 'In a parliamentary regime, the stakes are arguably higher in the national contest. After all, it is the party that elects the most candidates that forms the government.';
  const NATIONAL = 'For this reason, we expect that winning/losing in the national contest will have a greater effect on satisfaction than winning/losing in the local constituency.';
  const MUTH = 'as proposed by the rational expectations theory (Muth, 1961)';
  const ATTENTES = 'we suggest that only voters who wrongly assessed the chances of their party to win or lose will change their assessment of democracy after the election.';

  const ETATS = [
    { passages: [{ phrase: THEORIE, ton: 'encre' }] },
    { passages: [{ phrase: PREMISSE, ton: 'encre' }] },
    { passages: [{ phrase: PREMISSE, ton: 'encre' }, { phrase: NATIONAL }], focus: 1 },
    { passages: [{ phrase: MUTH, ton: 'encre' }, { phrase: ATTENTES }], focus: 1 },
    {
      passages: [
        { phrase: 'the effect of winning and losing on voters’ satisfaction with democracy is significant even when controlling for ex ante satisfaction before the election takes place', ton: 'encre', tag: '✓' },
        { phrase: 'the outcome of the election in the local constituency matters as much as the outcome of the national election', tag: '✕' },
        { phrase: 'They fail to show, however, that expectations about the outcome of the election play a significant role in shaping satisfaction with democracy', tag: '✕' }
      ],
      focus: 1
    }
  ];
</script>

{#snippet fleche()}
  <div class="m8n-donc">
    <svg viewBox="0 0 20 44" aria-hidden="true"><path d="M10 2 V40 M3 32 L10 41 L17 32" /></svg>
    <span>donc</span>
  </div>
{/snippet}

<M8Article etats={ETATS}>
  {#snippet note(e)}
    {#if e === 0}
      <span class="m8n-eti">La consigne</span>
      <p class="m8n-consigne">Énoncez votre hypothèse. Énoncez aussi votre hypothèse nulle.</p>
      <div class="m8n-premisse"><span class="m8n-eti">Théorie, p. 426</span><p>On aime le parti qu’on a élu.</p></div>
      {@render fleche()}
      <div class="m8n-hyp m8n-hyp-0">
        <p><strong>Hypothèse&#8239;:</strong> à satisfaction égale avant l’élection, les gagnants deviennent plus satisfaits que les perdants.</p>
        <p class="m8n-nulle"><strong>Hypothèse nulle&#8239;:</strong> gagner ou perdre ne change rien.</p>
      </div>
    {:else if e === 1}
      <div class="m8n-premisse"><span class="m8n-eti">Prémisse, p. 427</span><p>Le gouvernement se joue à l’échelle du pays.</p></div>
    {:else if e === 2}
      <div class="m8n-premisse"><span class="m8n-eti">Prémisse, p. 427</span><p>Le gouvernement se joue à l’échelle du pays.</p></div>
      {@render fleche()}
      <div class="m8n-hyp"><span class="m8n-eti">Hypothèse</span><p class="m8n-grand">Gagner au pays compte plus que gagner dans sa circonscription.</p></div>
    {:else if e === 3}
      <div class="m8n-premisse"><span class="m8n-eti">Théorie, p. 427</span><p>Les anticipations rationnelles (Muth, 1961)</p></div>
      {@render fleche()}
      <div class="m8n-hyp"><span class="m8n-eti">Hypothèse</span><p class="m8n-grand">Seuls ceux qui se sont trompés sur l’issue changent d’avis.</p></div>
    {:else}
      <span class="m8n-eti">Leur résumé, p. 425</span>
      <p class="m8n-res"><span class="m8n-oui">✓</span><span>Gagner rend plus satisfait, à satisfaction égale avant.</span></p>
      <p class="m8n-res"><span class="m8n-non">✕</span><span>La circonscription compte autant que le pays.</span></p>
      <p class="m8n-res"><span class="m8n-non">✕</span><span>Pas d’effet significatif des attentes.</span></p>
      <p class="m8n-dit">Une hypothèse peut tomber. C’est un résultat.</p>
    {/if}
  {/snippet}
</M8Article>

<style>
  .m8n-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-consigne { margin: 0 0 0.3em; font-size: 0.85em; line-height: 1.4; font-style: italic; color: var(--dk-gris); }
  .m8n-grand { margin: 0; font-size: 1.25em; font-weight: 700; line-height: 1.3; }

  /* La chaîne : prémisse, flèche « donc », hypothèse. */
  .m8n-premisse, .m8n-hyp { display: flex; flex-direction: column; gap: 0.25em; padding-left: 0.7em; }
  .m8n-premisse { border-left: 4px solid var(--dk-gris-2); }
  .m8n-premisse p { margin: 0; font-size: 1.05em; line-height: 1.35; }
  .m8n-hyp { border-left: 4px solid var(--dk-accent); }
  .m8n-hyp p { margin: 0; line-height: 1.3; }
  .m8n-hyp-0 { font-size: 0.92em; gap: 0.35em; }
  .m8n-nulle { color: var(--dk-gris); }
  .m8n-donc { display: flex; align-items: center; gap: 0.5em; padding-left: 0.2em; color: var(--dk-accent); font-weight: 700; font-size: 0.85em; }
  .m8n-donc svg { width: 1.1em; height: 2.4em; flex: none; }
  .m8n-donc path { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 60; stroke-dashoffset: 60; animation: m8n-trait 0.5s ease-out 1.4s forwards; }
  .m8n-donc span { opacity: 0; animation: m8n-voir 0.3s ease-out 1.7s forwards; }
  .m8n-donc ~ .m8n-hyp { opacity: 0; animation: m8n-voir 0.4s ease-out 1.85s forwards; }
  @keyframes m8n-trait { to { stroke-dashoffset: 0; } }
  @keyframes m8n-voir { to { opacity: 1; } }

  /* Les résultats. */
  .m8n-res { margin: 0; display: flex; align-items: baseline; gap: 0.6em; font-size: 0.95em; line-height: 1.3; }
  .m8n-oui, .m8n-non { flex: none; font-weight: 700; width: 1em; }
  .m8n-non { color: var(--dk-accent); }
  .m8n-dit { margin: 0.3em 0 0; padding-top: 0.5em; border-top: 2px solid var(--dk-filet); font-weight: 700; font-size: 1em; line-height: 1.3; }

  @media (prefers-reduced-motion: reduce) {
    .m8n-donc path { animation: none; stroke-dashoffset: 0; }
    .m8n-donc span, .m8n-donc ~ .m8n-hyp { animation: none; opacity: 1; }
  }
</style>
