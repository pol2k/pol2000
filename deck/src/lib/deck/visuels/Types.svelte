<script>
  /**
   * Les quatre types de variables qu'on croisera cette session : un nombre,
   * un texte, un vrai-ou-faux, et rien. Les classes affichées sont celles
   * que R donne avec class(). NA est à part : il n'est pas un type, il est
   * le trou dans n'importe lequel. Pas de paragraphe : la valeur, la classe,
   * un mot ; le reste se dit.
   */
  const T = [
    { v: '25', c: 'numeric', q: 'un nombre' },
    { v: '"Québec"', c: 'character', q: 'du texte' },
    { v: 'TRUE', c: 'logical', q: 'vrai ou faux' },
    { v: 'NA', c: 'manquant', q: 'on ne sait pas' }
  ];
</script>

<div class="visuel types">
  {#each T as t, i}
    <div class="type" class:na={t.v === 'NA'} style="animation-delay: {i * 110}ms">
      <span class="val">{t.v}</span>
      <span class="cls">class() · {t.c}</span>
      <strong>{t.q}</strong>
    </div>
  {/each}
</div>

<style>
  .types { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.9em; }
  .type { border: 2px solid var(--dk-encre); padding: 1.6em 0.8em 1.3em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.45em; animation: fondu 0.5s both; }
  .type.na { border: 3px solid var(--dk-accent); }
  .val { font-family: var(--dk-mono); font-size: 2.6em; font-weight: 600; line-height: 1; letter-spacing: -0.02em; }
  .na .val { color: var(--dk-accent); }
  .cls { font-size: 0.6em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .type strong { font-size: 1.1em; margin-top: 0.3em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
