<script>
  /**
   * De l'article aux médias (séance 11) : la phrase de l'article, puis
   * quatre reprises dans les médias, en escalier. Chaque marche est plus
   * haute et chaque phrase plus grosse : le même 43,9 % devient « le
   * ventre vide ». Un clic par texte.
   *
   * Toutes les phrases sont citées mot pour mot des pages montrées juste
   * avant (M11Presse) ou après (M11Article).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  const T = [
    { qui: 'L’article', t: '43,9 % des participants vivent une forme d’insécurité alimentaire', h: 0, source: true },
    { qui: 'La Presse', t: 'Près d’un élève sur deux touché', h: 1 },
    { qui: 'Le Devoir, lettre', t: 'un étudiant sur deux doute de pouvoir manger à sa faim chaque jour', h: 2 },
    { qui: 'Radio-Canada, le chercheur', t: 'Ce sont des personnes qui ont faim', h: 3 },
    { qui: 'Le Devoir, éditorial', t: 'Près d’un jeune Québécois sur deux vogue au cégep le ventre vide', h: 4 }
  ];
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: T.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel m11u" bind:this={hote} role="img" aria-label="La phrase de l’article, puis quatre reprises dans les médias, de plus en plus grosses. L’article : 43,9 % des participants vivent une forme d’insécurité alimentaire. La Presse : près d’un élève sur deux touché. Une lettre au Devoir : un étudiant sur deux doute de pouvoir manger à sa faim chaque jour. Le chercheur, à Radio-Canada : ce sont des personnes qui ont faim. L’éditorial du Devoir : près d’un jeune Québécois sur deux vogue au cégep le ventre vide.">
  {#each T as x, i (i)}
    <div class="m11u-col" class:m11u-vu={e >= i} style="--h: {x.h}">
      <div class="m11u-carte" class:m11u-source={x.source}>
        <span class="m11u-qui">{x.qui}</span>
        <p class="m11u-t">«&#8239;{x.t}&#8239;»</p>
      </div>
      <div class="m11u-marche" class:m11u-sol={x.source}></div>
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
  .m11u { border-bottom: 3px solid var(--dk-encre); padding-bottom: 0; }
  @media (prefers-reduced-motion: reduce) { .m11u-col { transition: none; transform: none; } }
</style>
