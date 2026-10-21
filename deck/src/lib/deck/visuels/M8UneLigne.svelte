<script>
  /**
   * Le piège de la table 2 (Westreich et Greenland, 2013) : dans un tableau
   * de régression, une seule ligne répond à la question, celle de la
   * variable d'intérêt. Les autres sont des contrôles : leurs coefficients
   * ne se lisent pas comme des effets, même avec trois étoiles.
   *
   *   0  le tableau, toutes les lignes pareilles;
   *   1  la ligne de la variable d'intérêt s'allume, les contrôles pâlissent.
   *
   * Composant de mise en page : les coefficients arrivent par les props.
   *   coefs  — [{ terme, b, etoiles }] (seance8.js, généré par R)
   *   noms   — { terme: 'Nom affiché' }
   *   cle    — le terme de la variable d'intérêt
   *   n      — le nombre d'observations
   */
  import { brancherTemps } from '../temps.js';
  let { coefs, noms, cle, n, titre = '' } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const lignes = $derived(coefs.filter((c) => c.terme !== '(Intercept)'));
</script>

<div class="visuel m8u" bind:this={hote}>
  <table class:lire={e >= 1}>
    {#if titre}<caption>{titre}</caption>{/if}
    <tbody>
      {#each lignes as c}
        <tr class:cle={c.terme === cle}>
          <td class="nom">{noms[c.terme] ?? c.terme}</td>
          <td class="b">{f(c.b)}<span class="et">{c.etoiles}</span></td>
          <td class="dit">{c.terme === cle ? 'la question' : 'un contrôle : on ne lit pas'}</td>
        </tr>
      {/each}
      <tr class="n"><td class="nom">N</td><td class="b">{nb(n)}</td><td></td></tr>
    </tbody>
  </table>
  <p class="nom-piege" class:vu={e >= 1}>Le piège de la table 2<span class="ref">Westreich et Greenland, 2013</span></p>
</div>

<style>
  .m8u { max-width: 50em; margin: 1em auto 0; display: flex; flex-direction: column; gap: 1.2em; }
  table { border-collapse: collapse; width: 100%; font-size: 1.15em; }
  caption { text-align: left; color: var(--dk-gris); font-size: 0.7em; padding-bottom: 0.5em; }
  td { padding: 0.4em 0.7em; border-bottom: 1px solid var(--dk-filet); transition: opacity 0.4s, color 0.4s; }
  .b { text-align: right; font-variant-numeric: tabular-nums; white-space: nowrap; }
  .et { display: inline-block; width: 2.2em; text-align: left; padding-left: 0.15em; }
  .dit { color: var(--dk-gris); font-size: 0.75em; opacity: 0; transition: opacity 0.4s; }
  .n td { border-top: 2px solid var(--dk-encre); border-bottom: none; }
  .lire .dit { opacity: 1; }
  .lire tr:not(.cle):not(.n) .nom, .lire tr:not(.cle):not(.n) .b { opacity: 0.3; }
  .lire tr.cle td { color: var(--dk-accent); font-weight: 700; }
  .lire tr.cle { outline: 3px solid var(--dk-accent); }
  .nom-piege { margin: 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-accent-clair); font-weight: 600; font-size: 1.15em; opacity: 0; transition: opacity 0.4s; }
  .nom-piege.vu { opacity: 1; }
  .ref { color: var(--dk-gris-2); font-weight: 400; font-size: 0.8em; margin-left: 1.2em; }
  @media (prefers-reduced-motion: reduce) { td, .dit, .nom-piege { transition: none; } }
</style>
