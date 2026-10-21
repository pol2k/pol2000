<script>
  /**
   * Le tableau 1 de Blais (2005, p. 824), recopié et traduit : un logit du
   * vote libéral en Ontario et dans l'Atlantique, CES 1965-2004 empilées.
   *
   *   0  le tableau entier;
   *   1  une seule ligne se lit : « Catholique », et son impact, 0,18.
   *
   * Les chiffres viennent de BLAIS (src/lib/data/seance8.js), recopiés de
   * l'article dans outils/seance8_data.R.
   */
  import { brancherTemps } from '../temps.js';
  import { BLAIS } from '$lib/data/seance8.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const T = BLAIS.est;
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
</script>

<div class="visuel m8b" bind:this={hote}>
  <div class="tableau">
    <table class:lire={e >= 1}>
      <caption>Tableau 1 · le vote libéral, {T.titre}</caption>
      <thead><tr><th>Variable</th><th>Coefficient (logit)</th><th>Impact</th></tr></thead>
      <tbody>
        {#each T.lignes as l}
          <tr class:cle={l.cle}><td>{l.nom}</td><td>{l.coef}</td><td>{l.impact}</td></tr>
        {/each}
        <tr class="n"><td>N</td><td>{nb(T.n)}</td><td></td></tr>
      </tbody>
    </table>
    <p class="source">Blais (2005), tableau 1, p. 824 · CES 1965-2004 · ** significatif au seuil de 1 %</p>
  </div>
  <div class="lecture" class:vu={e >= 1}>
    <span class="grand">18</span>
    <span class="mots">points de plus de chances de voter libéral, quand on est catholique</span>
    <span class="petit">« Impact » : sa propre traduction du logit en probabilité</span>
  </div>
</div>

<style>
  .m8b { display: grid; grid-template-columns: 1.25fr 1fr; gap: 2.4em; align-items: center; max-width: 66em; margin: 0.6em auto 0; }
  table { border-collapse: collapse; width: 100%; font-size: 0.88em; }
  caption { text-align: left; font-weight: 600; padding-bottom: 0.5em; }
  th { text-align: left; border-bottom: 2px solid var(--dk-encre); padding: 0.3em 0.6em; font-size: 0.85em; color: var(--dk-gris); font-weight: 600; }
  td { padding: 0.22em 0.6em; border-bottom: 1px solid var(--dk-filet); transition: opacity 0.4s, color 0.4s; }
  td:not(:first-child), th:not(:first-child) { text-align: right; }
  .n td { border-top: 2px solid var(--dk-encre); border-bottom: none; }
  .lire tr:not(.cle) td { opacity: 0.25; }
  .lire tr.cle td { color: var(--dk-accent); font-weight: 700; }
  .lire tr.cle { outline: 3px solid var(--dk-accent); }
  .source { margin: 0.6em 0 0; color: var(--dk-gris); font-size: 0.72em; }
  .lecture { display: flex; flex-direction: column; gap: 0.4em; opacity: 0; transform: translateX(0.5em); transition: opacity 0.4s, transform 0.4s; }
  .lecture.vu { opacity: 1; transform: none; }
  .grand { font-size: 6em; line-height: 1; font-weight: 700; color: var(--dk-accent); }
  .mots { font-size: 1.3em; line-height: 1.35; }
  .petit { color: var(--dk-gris); font-size: 0.85em; }
  @media (prefers-reduced-motion: reduce) { td, .lecture { transition: none; transform: none; } }
</style>
