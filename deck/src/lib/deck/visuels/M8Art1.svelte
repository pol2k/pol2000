<script>
  /**
   * TP 1, étape 1 (la question), dans le vrai article : la question en une
   * phrase dans le résumé (p. 425), son X et son Y, puis la même question,
   * mot pour mot, au début du cadre théorique (p. 426). M8Article.
   */
  import M8Article from './M8Article.svelte';
  const Q = 'whether it is the fact of winning (losing), per se, that generates (dis)satisfaction with democracy';
  const ETATS = [
    { passages: [{ phrase: Q }], focus: { page: 0, y: 14 } },
    { passages: [{ phrase: 'winning (losing)', ton: 'x', tag: 'X' }, { phrase: '(dis)satisfaction with democracy', ton: 'y', tag: 'Y' }] },
    { passages: [{ phrase: 'But do we know whether it is the fact of winning (losing), per se, that generates (dis)satisfaction with democracy?' }] }
  ];
</script>

<M8Article etats={ETATS}>
  {#snippet note(e)}
    {#if e === 0}
      <span class="m8n-eti">La consigne</span>
      <p class="m8n-consigne">Une question de recherche qui met en relation une variable dépendante et une variable indépendante.</p>
      <span class="m8n-eti">Leur résumé, p. 425</span>
      <p class="m8n-grand">Gagner une élection rend-il plus satisfait de la démocratie&#8239;?</p>
    {:else if e === 1}
      <p class="m8n-ligne"><span class="m8n-tag">X</span><span><strong>Gagner ou perdre</strong> l’élection</span></p>
      <p class="m8n-ligne"><span class="m8n-tag m8n-y">Y</span><span><strong>La satisfaction</strong> envers la démocratie</span></p>
    {:else}
      <span class="m8n-eti">p. 426, au début du cadre théorique</span>
      <p class="m8n-grand">La même question, mot pour mot.</p>
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
</style>
