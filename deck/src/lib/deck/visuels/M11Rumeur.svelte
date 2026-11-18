<script>
  /**
   * Le chiffre qui grossit (séance 11). Les cinq textes qu'on vient de
   * lire, dans l'ordre où ils ont paru, en escalier : chaque marche monte,
   * chaque phrase est plus grosse. L'article scientifique, la source, reste
   * au sol, et il arrive en troisième, après deux manchettes.
   *
   *   un clic par texte, dans l'ordre des dates.
   *
   * Toutes les phrases sont citées mot pour mot des pages montrées juste
   * avant (M11Presse, M11Article).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  const T = [
    { d: 'février 2025', qui: 'La Presse', t: 'Près d’un élève sur deux touché', h: 1 },
    { d: 'juin 2025', qui: 'Le Devoir, lettre', t: 'un étudiant sur deux doute de pouvoir manger à sa faim chaque jour', h: 2 },
    { d: 'août 2025', qui: 'L’article', t: '43,9 % des participants vivent une forme d’insécurité alimentaire', h: 0, source: true },
    { d: 'octobre 2025', qui: 'Radio-Canada, le chercheur', t: 'Ce sont des personnes qui ont faim', h: 3 },
    { d: 'octobre 2025', qui: 'Le Devoir, éditorial', t: 'Près d’un jeune Québécois sur deux vogue au cégep le ventre vide', h: 4 }
  ];
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: T.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel m11u" bind:this={hote} role="img" aria-label="Cinq textes, dans l’ordre où ils ont paru. Février 2025, La Presse : près d’un élève sur deux touché. Juin 2025, une lettre au Devoir : un étudiant sur deux doute de pouvoir manger à sa faim chaque jour. Août 2025, l’article : 43,9&#8239;% des participants vivent une forme d’insécurité alimentaire. Octobre 2025, Radio-Canada : des personnes qui ont faim. Octobre 2025, éditorial du Devoir : près d’un jeune Québécois sur deux vogue au cégep le ventre vide.">
  {#each T as x, i (i)}
    <div class="m11u-col" class:m11u-vu={e >= i} style="--h: {x.h}">
      <div class="m11u-carte" class:m11u-source={x.source}>
        <span class="m11u-qui">{x.qui}</span>
        <p class="m11u-t">«&#8239;{x.t}&#8239;»</p>
      </div>
      <div class="m11u-marche" class:m11u-sol={x.source}></div>
      <span class="m11u-d">{x.d}</span>
    </div>
  {/each}
</div>

<style>
  .m11u { width: 100%; display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 0.8em; align-items: end; margin-top: 0.6em; }
  .m11u-col { display: flex; flex-direction: column; justify-content: flex-end; gap: 0.4em; opacity: 0; transform: translateY(0.8em); transition: opacity 0.4s, transform 0.5s; }
  .m11u-col.m11u-vu { opacity: 1; transform: none; }
  .m11u-carte { border: 3px solid var(--dk-accent); background: var(--dk-fond); padding: 0.6em 0.7em; display: flex; flex-direction: column; gap: 0.3em; }
  .m11u-carte.m11u-source { border-color: var(--dk-encre); background: white; }
  .m11u-qui { font-size: 0.6em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m11u-t { margin: 0; font-weight: 700; line-height: 1.25; font-size: calc(0.72em + var(--h) * 0.12em); color: var(--dk-accent); }
  .m11u-source .m11u-t { color: var(--dk-encre); }
  .m11u-marche { height: calc(0.4em + var(--h) * 1.9em); background: var(--dk-accent); opacity: 0.85; }
  .m11u-marche.m11u-sol { background: var(--dk-encre); }
  .m11u-d { font-size: 0.7em; color: var(--dk-gris); text-align: center; border-top: 3px solid var(--dk-encre); padding-top: 0.3em; }
  @media (prefers-reduced-motion: reduce) { .m11u-col { transition: none; transform: none; } }
</style>
