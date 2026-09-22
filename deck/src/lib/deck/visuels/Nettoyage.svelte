<script>
  /**
   * Du brut au propre, en trois panneaux : le schéma « cleaning » du cours 4
   * de FAS1001, redessiné avec les vraies données de l'Étude électorale
   * canadienne 2025. Mêmes quatre personnes à gauche et à droite (BRUT et
   * PROPRE, générés par outils/seance4_data.R).
   *
   *   0  Les données brutes : des noms et des codes illisibles.
   *   1  Le codebook : cps25_education veut dire scolarité, et voici la règle.
   *   2  Les données propres : des noms clairs, des catégories, NA au lieu de -99.
   */
  import { brancherTemps } from '../temps.js';
  import { BRUT, PROPRE, PERTES, SCOLARITE, DIMENSIONS } from '$lib/data/seance4.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Quatre personnes, dont une qui a répondu -99.
  const LIGNES = [0, 1, 2, 3];
  const colB = ['cps25_education', 'cps25_lr_scale_bef_1'].map((c) => BRUT.cols.indexOf(c));
  const colP = ['scolarite', 'gauche_droite'].map((c) => PROPRE.cols.indexOf(c));
  const nb = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const N = nb(PERTES.n);
  const NCOL_BRUT = nb(DIMENSIONS.brut[1]);
  const G = SCOLARITE.groupes;
  // Un nom de colonne R ne se coupe qu'après un « _ », jamais au milieu d'un mot.
  const morceaux = (c) => c.split('_').map((m, k, a) => (k < a.length - 1 ? m + '_' : m));
  const REGLES = [
    ['1 à 5', 'Secondaire ou moins'],
    ['6 et 7', 'Collégial'],
    ['8 à 11', 'Universitaire'],
    ['12', 'NA']
  ];
</script>

<div class="visuel nettoyage" bind:this={hote}>
  <section class="panneau brut">
    <span class="et"><b>1</b> DONNÉES BRUTES</span>
    <code class="obj">df</code>
    <table>
      <thead><tr>{#each colB as c}<th>{#each morceaux(BRUT.cols[c]) as m, k}{#if k > 0}<wbr />{/if}{m}{/each}</th>{/each}</tr></thead>
      <tbody>
        {#each LIGNES as i}<tr>{#each colB as c}<td class:rouge={BRUT.rows[i][c] === -99}>{BRUT.rows[i][c]}</td>{/each}</tr>{/each}
      </tbody>
    </table>
    <span class="dim">{N} lignes × {NCOL_BRUT} colonnes</span>
  </section>

  <div class="fl" class:vu={e >= 1}>→</div>

  <section class="panneau codebook" class:vu={e >= 1}>
    <span class="et"><b>2</b> LE CODEBOOK</span>
    <p class="def"><code>cps25_education</code> = scolarité</p>
    <ul>
      {#each REGLES as [codes, cat]}
        <li><span class="codes">{codes}</span><span class="fl2">→</span><span class="cat" class:na={cat === 'NA'}>{cat}</span><span class="n">{nb(G[cat])}</span></li>
      {/each}
    </ul>
  </section>

  <div class="fl" class:vu={e >= 2}>→</div>

  <section class="panneau propre" class:vu={e >= 2}>
    <span class="et"><b>3</b> DONNÉES PROPRES</span>
    <code class="obj">df_propre</code>
    <table>
      <thead><tr>{#each colP as c}<th>{#each morceaux(PROPRE.cols[c]) as m, k}{#if k > 0}<wbr />{/if}{m}{/each}</th>{/each}</tr></thead>
      <tbody>
        {#each LIGNES as i}<tr>{#each colP as c}<td class:na={PROPRE.rows[i][c] === null}>{PROPRE.rows[i][c] ?? 'NA'}</td>{/each}</tr>{/each}
      </tbody>
    </table>
    <span class="dim">{N} lignes × {PROPRE.cols.length} colonnes</span>
  </section>

  <p class="source">Étude électorale canadienne 2025 · quatre vraies personnes</p>
</div>

<style>
  .nettoyage { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.5em 0.6em; align-items: stretch; }
  .panneau { display: flex; flex-direction: column; gap: 0.5em; border: 3px solid var(--dk-encre); padding: 0.8em 0.8em 0.7em; min-width: 0; }
  .codebook, .propre { opacity: 0.12; transition: opacity 0.45s; }
  .codebook.vu, .propre.vu { opacity: 1; }
  .propre.vu { border-color: var(--dk-accent); }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .et b { display: inline-block; min-width: 1.5em; color: var(--dk-accent); }
  .obj { font-family: var(--dk-mono); font-weight: 600; font-size: 1em; }
  /* .nettoyage devant : l'emporter sur .diapo table / th / td de deck.css (majuscules, 0,72em). */
  .nettoyage table { border-collapse: collapse; font-size: 0.8em; width: 100%; font-variant-numeric: tabular-nums; }
  .nettoyage th { text-align: left; padding: 0.35em 0.7em 0.35em 0.45em; background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-weight: 600; font-size: 0.85em; letter-spacing: 0; text-transform: none; white-space: normal; overflow-wrap: normal; word-break: keep-all; border: 0; }
  .nettoyage .propre th { background: var(--dk-accent); }
  .nettoyage td { padding: 0.35em 0.7em 0.35em 0.45em; border-bottom: 1px solid var(--dk-filet); white-space: nowrap; }
  .nettoyage td.rouge { color: var(--dk-accent); font-weight: 600; }
  .nettoyage td.na { color: var(--dk-gris-2); }
  .dim { margin-top: auto; font-size: 0.66em; color: var(--dk-gris); }
  .def { margin: 0; font-size: 0.85em; }
  .def code { font-weight: 600; }
  ul { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.45em; }
  li { display: grid; grid-template-columns: 3.6em 1em 1fr auto; gap: 0.3em; align-items: baseline; font-size: 0.78em; }
  .codes { font-weight: 600; font-variant-numeric: tabular-nums; }
  .fl2 { color: var(--dk-accent); }
  .cat.na { color: var(--dk-gris-2); }
  .n { color: var(--dk-gris); font-size: 0.85em; font-variant-numeric: tabular-nums; }
  .fl { align-self: center; font-size: 2em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.3s; }
  .fl.vu { opacity: 1; }
  .source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @media (prefers-reduced-motion: reduce) { .codebook, .propre, .fl { transition: none; } }
</style>
