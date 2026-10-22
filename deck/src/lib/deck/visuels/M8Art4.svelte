<script>
  /**
   * TP 1, étape 4 (les données et les variables), dans le vrai article : la
   * section « Model and Data » (p. 428), lue dans l'ordre. Les données (la
   * CES 1997), le Y, la limite de la mesure, reconnue, le contrôle (la même
   * question avant l'élection), puis le X. M8Article.
   */
  import M8Article from './M8Article.svelte';
  const ETATS = [
    { passages: [
      { phrase: 'Model and Data', ton: 'encre' },
      { phrase: 'we use the 1997 Canadian Election Study (CES). The study includes a rolling campaign cross-section survey of 3,949 respondents and a post-election re-interview of 3,170 of them.' }
    ], focus: 1 },
    { passages: [{ phrase: 'dependent variable consists in the standard question tapping people’s degree of satisfaction with the way democracy works in Canada', ton: 'y', tag: 'Y' }] },
    { passages: [{ phrase: 'The variable ‘satisfaction with democracy’ is obviously an imperfect measure of support for the political regime.', ton: 'encre' }] },
    { passages: [
      { phrase: 'The question measuring satisfaction with democracy was asked in the campaign survey and repeated in the post-election questionnaire.' },
      { phrase: 'By including the pre-election measure in our model, we are effectively measuring change in satisfaction with democracy after the election.' }
    ] },
    { passages: [
      { phrase: 'Respondents who reported to have voted for the Liberal party are therefore construed to be ‘national winners’; those who voted for another party are identified as ‘national losers’.', ton: 'x', tag: 'X' },
      { phrase: 'We can thus distinguish ‘local’ from ‘national’ winners and losers.', ton: 'encre' }
    ] }
  ];
</script>

<M8Article etats={ETATS}>
  {#snippet note(e)}
    {#if e === 0}
      <span class="m8n-eti">Les données, p. 428</span>
      <p class="m8n-grand">La CES 1997</p>
      <p class="m8n-chiffre"><strong>3 949</strong><span>répondants pendant la campagne</span></p>
      <p class="m8n-chiffre"><strong>3 170</strong><span>réinterrogés après l’élection</span></p>
      <p class="m8n-vous"><span class="m8n-eti">Vous</span>La CES 2025</p>
    {:else if e === 1}
      <span class="m8n-eti">La consigne</span>
      <p class="m8n-consigne">Votre variable dépendante&#8239;: ratio, intervalle ou ordinale. Pas de Y nominal.</p>
      <p class="m8n-ligne"><span class="m8n-tag m8n-y">Y</span><strong>La satisfaction</strong></p>
      <p class="m8n-gris">envers la démocratie, en 4 choix, de «&#8239;pas du tout&#8239;» à «&#8239;très satisfait&#8239;»</p>
      <p class="m8n-ok">Ordinale ✓ <span class="m8n-eti">annexe, p. 437</span></p>
    {:else if e === 2}
      <span class="m8n-eti">Une limite reconnue</span>
      <p class="m8n-grand">Une mesure imparfaite, qu’ils défendent.</p>
      <p class="m8n-gris">Une bonne pratique&#8239;: nommer la limite de sa mesure.</p>
    {:else if e === 3}
      <span class="m8n-eti">Le contrôle principal</span>
      <p class="m8n-grand">La même question, avant l’élection</p>
      <p class="m8n-gris">Les mêmes personnes, interrogées deux fois. On mesure le changement.</p>
    {:else}
      <p class="m8n-ligne"><span class="m8n-tag">X</span><span><strong>Gagner ou perdre</strong></span></p>
      <p class="m8n-gris">Au pays&#8239;: a voté libéral</p>
      <p class="m8n-gris">Dans sa circonscription&#8239;: a voté pour le candidat élu</p>
      <p class="m8n-vous"><span class="m8n-eti">Vous, en 2025</span>A voté libéral = gagnant</p>
    {/if}
  {/snippet}
</M8Article>

<style>
  .m8n-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8n-consigne { margin: 0 0 0.4em; font-size: 0.85em; line-height: 1.4; font-style: italic; color: var(--dk-gris); }
  .m8n-grand { margin: 0; font-size: 1.35em; font-weight: 700; line-height: 1.3; }
  .m8n-ligne { margin: 0; display: flex; align-items: center; gap: 0.6em; font-size: 1.25em; }
  .m8n-tag { flex: none; display: inline-grid; place-items: center; width: 1.6em; height: 1.6em; font-weight: 700; background: var(--dk-encre); color: var(--dk-fond); }
  .m8n-y { background: var(--dk-accent); }
  .m8n-gris { margin: 0; font-size: 0.85em; line-height: 1.4; color: var(--dk-gris); }
  .m8n-chiffre { margin: 0; display: grid; grid-template-columns: 4.3em minmax(0, 1fr); align-items: baseline; gap: 0.5em; line-height: 1.3; }
  .m8n-chiffre strong { color: var(--dk-accent); font-size: 1.25em; }
  .m8n-chiffre span { font-size: 0.85em; color: var(--dk-gris); }
  .m8n-ok { margin: 0; display: flex; align-items: baseline; gap: 1em; font-weight: 700; color: var(--dk-accent); }
  .m8n-vous { margin: 0.3em 0 0; padding-top: 0.5em; border-top: 2px solid var(--dk-filet); display: flex; flex-direction: column; gap: 0.2em; font-size: 1em; font-weight: 700; }
  .m8n-vous .m8n-eti { font-size: 0.62em; }
</style>
