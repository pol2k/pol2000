<script>
  /**
   * Les trois chiffres que sondr::topdown_fa() imprime, et le seuil de
   * chacun (cours 5 de FAS1001). Une carte par clic. Aucune formule : ce que
   * chaque chiffre dit, en une phrase, et à partir de quand il est bon.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const C = [
    { nom: 'Alpha de Cronbach', seuil: '> 0,6', dit: 'Les énoncés répondent-ils ensemble ?', detail: 'La cohérence de tout le groupe. De 0 à 1.' },
    { nom: 'Première valeur propre', seuil: '> 1', dit: 'Y a-t-il un concept dominant ?', detail: 'La force de ce que les énoncés ont en commun.' },
    { nom: 'Coefficient de saturation', seuil: '> 0,3', dit: 'Cet énoncé en fait-il partie ?', detail: 'Un chiffre par énoncé : sa contribution au concept.' }
  ];
</script>

<div class="visuel m9t" bind:this={hote}>
  {#each C as c, i}
    <div class="m9t-carte" class:vu={e >= i + 1}>
      <span class="m9t-n">{i + 1}</span>
      <strong>{c.nom}</strong>
      <span class="m9t-seuil">{c.seuil}</span>
      <p class="m9t-dit">{c.dit}</p>
      <p class="m9t-detail">{c.detail}</p>
    </div>
  {/each}
</div>

<style>
  .m9t { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 64em; margin: 1.2em auto 0; }
  .m9t-carte { border: 3px solid var(--dk-encre); padding: 1.1em 1.2em 1.2em; display: flex; flex-direction: column; gap: 0.35em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .m9t-carte.vu { opacity: 1; transform: none; }
  .m9t-n { font-size: 0.7em; letter-spacing: 0.14em; color: var(--dk-gris); font-weight: 600; }
  .m9t-carte strong { font-size: 1.15em; line-height: 1.2; }
  .m9t-seuil { font-size: 2.6em; font-weight: 700; line-height: 1; color: var(--dk-accent); margin: 0.15em 0; }
  .m9t-dit { margin: 0; font-weight: 600; font-size: 0.95em; line-height: 1.3; }
  .m9t-detail { margin: 0; font-size: 0.78em; color: var(--dk-gris); line-height: 1.35; }
  @media (prefers-reduced-motion: reduce) { .m9t-carte { transition: none; } }
</style>
