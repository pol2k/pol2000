<script>
  /**
   * Deux façons de contribuer avec l'article de Blais et Gélineau, en 2025
   * (demande du professeur) : VÉRIFIER (leur résultat tient-il, 28 ans
   * plus tard ?) puis FAIRE MIEUX (répondre à une faiblesse qu'ils
   * reconnaissent : leur note 1). Le lien avec l'étape 6 du TP 1, la
   * contribution.
   *
   *   ici  0  les deux à égalité (après « Leur conclusion »);
   *        1  vérifier, en rouge;
   *        2  vérifier est fait (coché), faire mieux en rouge.
   */
  let { ici = 0 } = $props();
  const VOIES = [
    { n: '1', verbe: 'Vérifier', dit: '1997 → 2025 : leur résultat tient-il encore ?' },
    { n: '2', verbe: 'Faire mieux', dit: 'Répondre à une faiblesse qu’ils reconnaissent eux-mêmes' }
  ];
</script>

<div class="visuel m8v">
  <div class="m8v-voies">
    {#each VOIES as v, i}
      {@const k = i + 1}
      <div class="m8v-voie" class:on={ici === k} class:fait={ici > k} style="--i: {i}">
        <svg viewBox="0 0 120 120" aria-hidden="true">
          {#if i === 0}
            <rect x="14" y="14" width="92" height="92" class="m8v-trait" />
            <path d="M 34 62 L 54 82 L 88 38" class="m8v-trait m8v-epais" />
          {:else}
            <line x1="20" y1="100" x2="100" y2="100" class="m8v-trait" />
            <rect x="26" y="66" width="18" height="34" class="m8v-plein m8v-gris" />
            <rect x="52" y="48" width="18" height="52" class="m8v-plein m8v-gris" />
            <rect x="78" y="22" width="18" height="78" class="m8v-plein" />
          {/if}
        </svg>
        <span class="m8v-n">{v.n}{#if ici > k}&nbsp;✓{/if}</span>
        <strong>{v.verbe}</strong>
        <p>{v.dit}</p>
      </div>
    {/each}
  </div>
  <p class="m8v-tp">Votre TP 1, étape 6&#8239;: la contribution. Les deux comptent.</p>
</div>

<style>
  .m8v { max-width: 54em; margin: 1em auto 0; display: flex; flex-direction: column; gap: 1.2em; }
  .m8v-voies { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; }
  .m8v-voie { border: 3px solid var(--dk-encre); padding: 1.2em 1.4em; display: flex; flex-direction: column; gap: 0.35em; animation: m8v-entre 0.5s both; animation-delay: calc(var(--i) * 0.25s); transition: border-color 0.4s, color 0.4s; }
  .m8v-voie svg { width: 4.2em; height: 4.2em; margin-bottom: 0.4em; }
  .m8v-trait { fill: none; stroke: currentColor; stroke-width: 6; }
  .m8v-epais { stroke-width: 10; }
  .m8v-plein { fill: currentColor; }
  .m8v-gris { opacity: 0.35; }
  .m8v-n { font-size: 2.6em; font-weight: 600; line-height: 1; }
  .m8v-voie strong { font-size: 1.6em; line-height: 1.2; }
  .m8v-voie p { margin: 0.2em 0 0; font-size: 1em; line-height: 1.4; }
  .m8v-voie.on { border-color: var(--dk-accent); color: var(--dk-accent); }
  .m8v-voie.on p { color: var(--dk-encre); }
  .m8v-voie.fait { border-color: var(--dk-gris-2); color: var(--dk-gris); }
  .m8v-tp { margin: 0; text-align: center; color: var(--dk-gris); font-size: 0.9em; }
  @keyframes m8v-entre { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m8v-voie { animation: none; transition: none; } }
</style>
