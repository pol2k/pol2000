<script>
  /**
   * La phrase pour lire un coefficient d'une régression multiple, en
   * quatre cases à remplir. D'abord les cases vides (ce qu'il faut y
   * mettre), puis un clic par case. La même phrase pour une variable
   * continue, binaire ou catégorielle : seul le « mouvement » change.
   *
   *   0  la phrase à trous;
   *   1  les autres variables (« à … égaux »);
   *   2  le mouvement de X (de son minimum à son maximum, ou de 0 à 1);
   *   3  le coefficient, en mots (de plus, de moins);
   *   4  sur 10 points, comme la question du sondage (ou : pas d'étoile).
   *
   * Composant de mise en page : les nombres arrivent par les props, lus
   * dans src/lib/data/seance8.js par la diapo.
   *   autres     — « scolarité, genre, revenu et région »
   *   mouvement  — « passer de 18 à 96 ans »
   *   b          — le coefficient (échelle de 0 à 1)
   *   y          — « d'intérêt »
   *   echelle    — « sur 10 » (b × 10), ou '' pour ne pas convertir
   *   pp         — true : un Y de 0 ou 1, converti en points de pourcentage (b × 100)
   *   etoiles    — false : le coefficient n'a pas d'étoile
   */
  import { brancherTemps } from '../temps.js';
  let { autres, mouvement, b, y = 'd’intérêt', echelle = 'sur 10', pp = false, etoiles = true } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sens = $derived(b < 0 ? 'de moins' : 'de plus');
  const fois = $derived(pp ? 100 : 10);
  const dix = $derived(f(b * fois, 1));
  const point = $derived((Math.abs(b * fois) < 2 ? 'point' : 'points') + (pp ? ' de pourcentage' : ''));
</script>

<div class="visuel m8ph" bind:this={hote}>
  <p class="ligne">À <span class="case" class:pleine={e >= 1}><span class="vide">les autres variables</span><span class="mot">{autres}</span></span> égaux,</p>
  <p class="ligne"><span class="case" class:pleine={e >= 2}><span class="vide">X, de son minimum à son maximum</span><span class="mot">{mouvement}</span></span></p>
  <p class="ligne">est associé à <span class="case" class:pleine={e >= 3}><span class="vide">le coefficient</span><span class="mot">{f(b, pp || Math.abs(b) < 0.01 ? 3 : 2)} {sens}</span></span> {y} (sur 1).</p>
  <p class="fin" class:vu={e >= 4}>
    {#if pp}Soit <strong>{dix} {point} {sens}</strong>.{:else if etoiles && echelle}Soit <strong>{dix} {point} {sens}</strong> {echelle}.{/if}
    {#if !etoiles}<strong>Pas d’étoile</strong>{' '}: on ne peut pas le distinguer de zéro.{/if}
  </p>
</div>

<style>
  .m8ph { max-width: 46em; margin: 1.2em auto 0; display: flex; flex-direction: column; gap: 0.55em; font-size: 1.35em; line-height: 1.5; }
  .ligne { margin: 0; }
  .case { display: inline-grid; vertical-align: bottom; border-bottom: 4px solid var(--dk-gris-2); padding: 0 0.3em; transition: border-color 0.3s; }
  .case > span { grid-area: 1 / 1; transition: opacity 0.35s; }
  .vide { color: var(--dk-gris-2); font-style: italic; }
  .mot { opacity: 0; color: var(--dk-accent); font-weight: 700; }
  .case.pleine { border-bottom-color: var(--dk-accent); }
  .case.pleine .vide { opacity: 0; }
  .case.pleine .mot { opacity: 1; }
  .fin { margin: 0.8em 0 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); opacity: 0; transition: opacity 0.4s; }
  .fin.vu { opacity: 1; }
  .fin strong { color: var(--dk-accent-clair); }
  @media (prefers-reduced-motion: reduce) { .case > span, .fin, .case { transition: none; } }
</style>
