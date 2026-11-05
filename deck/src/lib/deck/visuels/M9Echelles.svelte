<script>
  /**
   * Des échelles qu'on utilise tous les jours sans y penser. Chacune met un
   * nombre sur une chose qu'on ne voit pas, à partir de plusieurs
   * ingrédients. Au clic :
   *
   *   0  le nom, ce qu'elle mesure, son nombre : ce que tout le monde connaît;
   *   1  ce qu'il y a dedans : plusieurs indicateurs.
   *
   * Composantes vérifiées à la source : PNUD (IDH), EIU (60 indicateurs,
   * 5 catégories, 0 à 10).
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const E = [
    { nom: 'IDH', long: 'Indice de développement humain', quoi: 'le développement d’un pays', nb: 'de 0 à 1', dedans: ['espérance de vie', 'années d’études', 'revenu par habitant'] },
    { nom: 'QI', long: 'Quotient intellectuel', quoi: 'l’intelligence', nb: '100 = la moyenne', dedans: ['vocabulaire', 'mémoire', 'raisonnement', 'vitesse'] },
    { nom: 'Démocratie', long: 'Indice de The Economist', quoi: 'la démocratie', nb: 'de 0 à 10', dedans: ['60 indicateurs', 'élections', 'libertés civiles', 'participation'] },
    { nom: 'Crédit', long: 'Cote d’Equifax et TransUnion', quoi: 'le risque de ne pas rembourser', nb: 'de 300 à 900', dedans: ['paiements à temps', 'dettes', 'âge du crédit'] }
  ];
</script>

<div class="visuel m9h" bind:this={hote}>
  <div class="m9h-grille">
    {#each E as s, i}
      <div class="m9h-tuile" style="--i: {i}">
        <div class="m9h-haut">
          <strong>{s.nom}</strong>
          <span class="m9h-nb">{s.nb}</span>
        </div>
        <span class="m9h-long">{s.long}</span>
        <span class="m9h-quoi">mesure <b>{s.quoi}</b></span>
        <div class="m9h-dedans" class:vu={e >= 1}>
          {#each s.dedans as d}<span>{d}</span>{/each}
        </div>
      </div>
    {/each}
  </div>
</div>

<style>
  .m9h { display: flex; flex-direction: column; gap: 0.7em; max-width: 64em; margin: 0.2em auto 0; }
  .m9h-grille { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.7em 1em; }
  .m9h-tuile { border: 3px solid var(--dk-encre); padding: 0.55em 0.8em; display: flex; flex-direction: column; gap: 0.15em; animation: m9h-fondu 0.45s both; animation-delay: calc(var(--i) * 0.12s); }
  .m9h-haut { display: flex; justify-content: space-between; align-items: baseline; gap: 0.6em; }
  .m9h-haut strong { font-size: 1.15em; line-height: 1.1; }
  .m9h-nb { font-size: 0.85em; font-weight: 700; color: var(--dk-accent); white-space: nowrap; }
  .m9h-long { font-size: 0.72em; color: var(--dk-gris); letter-spacing: 0.04em; }
  .m9h-quoi { font-size: 0.82em; line-height: 1.3; }
  .m9h-quoi b { color: var(--dk-accent); }
  .m9h-dedans { display: flex; flex-wrap: wrap; gap: 0.3em; margin-top: 0.2em; padding-top: 0.35em; border-top: 2px solid var(--dk-filet); opacity: 0; transform: translateY(0.3em); transition: opacity 0.4s, transform 0.4s; }
  .m9h-dedans.vu { opacity: 1; transform: none; }
  .m9h-dedans span { font-size: 0.68em; border: 2px solid var(--dk-encre); padding: 0.1em 0.45em; }
  @keyframes m9h-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9h-tuile { animation: none; } .m9h-dedans { transition: none; } }
</style>
