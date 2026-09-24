<script>
  /**
   * Du brut au propre, une colonne à la fois. Un petit tableau de quatre
   * vraies personnes de l'Étude électorale canadienne 2025 : on lit la colonne
   * dans le codebook, on la renomme, on traduit ses codes, puis le -99
   * devient NA. Même idée que le schéma « cleaning » du cours 4 de FAS1001,
   * mais animé. La règle du cours : df_raw ne change jamais; chaque colonne
   * propre est écrite dans df_clean (qui compte aussi la colonne id). Au
   * dernier temps, les deux objets sont côte à côte : df_raw inchangé,
   * df_clean nouveau.
   *
   *   0  Les données brutes : des noms cryptiques et des codes.
   *   1  cps25_education : la fiche du codebook s'ouvre (ce que veut dire chaque code).
   *   2  Le nom devient ses_education.
   *   3  Les codes deviennent des catégories.
   *   4  cps25_lr_scale_bef_1 : la fiche change (0 = gauche, 10 = droite, -99 = non-réponse).
   *   5  Le nom devient gauche_droite.
   *   6  Les -99 deviennent NA.
   *   7  cps25_age_in_years devient age : df_clean est prêt, df_raw n'a pas bougé.
   *
   * Valeurs avant/après : BRUT et PROPRE de seance4.js (outils/seance4_data.R),
   * mêmes personnes sur les mêmes lignes. Les noms français des codes de
   * scolarité abrègent le codebook; les catégories (secondaire_ou_moins,
   * collegial, universitaire) viennent de PROPRE.
   */
  import { brancherTemps } from '../temps.js';
  import { BRUT, PROPRE, DIMENSIONS, SCOLARITE } from '$lib/data/seance4.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 7, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Quatre personnes : des codes de scolarité tous différents (9, 8, 4, 7) et deux -99.
  const LIGNES = [0, 3, 4, 5];

  // Chaque colonne : son nom brut, son nom propre, et le temps où chaque chose arrive.
  const COLONNES = [
    { brut: 'cps25_age_in_years', propre: 'age', lire: null, nom: 7, val: null },
    { brut: 'cps25_education', propre: 'ses_education', lire: 1, nom: 2, val: 3 },
    { brut: 'cps25_lr_scale_bef_1', propre: 'gauche_droite', lire: 4, nom: 5, val: 6 }
  ].map((c) => {
    const ib = BRUT.cols.indexOf(c.brut);
    const ip = PROPRE.cols.indexOf(c.propre);
    const cellules = LIGNES.map((i) => {
      const avant = BRUT.rows[i][ib];
      const apres = PROPRE.rows[i][ip];
      return { avant: String(avant), apres: apres === null ? 'NA' : String(apres), change: String(avant) !== String(apres ?? 'NA'), na: apres === null };
    });
    return { ...c, cellules };
  });

  // La colonne sur laquelle on travaille.
  const actif = (c) => c.lire !== null && e >= c.lire && e <= c.val;

  // Le rail des quatre gestes, et le geste de chaque temps.
  const GESTES = ['Lire le codebook', 'Renommer', 'Traduire les codes', '-99 devient NA'];
  const GESTE = [null, 0, 1, 2, 0, 1, 3, 1];

  // La fiche de la scolarité : les codes présents dans le tableau, du plus petit au plus grand,
  // chacun avec sa catégorie tirée de PROPRE.
  const NOMS = ['Aucune scolarité', 'Primaire commencé', 'Primaire', 'Secondaire commencé', 'Secondaire', 'Cégep commencé', 'Cégep', 'Université commencée', 'Baccalauréat', 'Maîtrise', 'Doctorat, prof.', 'Ne sait pas'];
  const EDU = COLONNES[1];
  const FICHE_EDU = [...new Map(EDU.cellules.map((c) => [Number(c.avant), c.apres])).entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([code, cat]) => ({ code, nom: NOMS[SCOLARITE.codes.indexOf(code)], cat }));
  const NCODES = SCOLARITE.codes.length;

  const nb = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const NLIG = nb(DIMENSIONS.brut[0]);
  const NCOL_BRUT = nb(DIMENSIONS.brut[1]);
  const NCOL_PROPRE = nb(DIMENSIONS.propre[1]);
</script>

<div class="visuel nettoyage2" class:fini={e >= 7} bind:this={hote}>
  <ol class="rail">
    {#each GESTES as g, k}
      <li class:ici={GESTE[e] === k} class:fait={e >= 7}><b>{k + 1}</b>{g}</li>
    {/each}
  </ol>

  <div class="scene">
    <section class="bloc">
      <div class="objet">
        <span class="brut"><code>df_raw</code><span class="dim">{NLIG} lignes × {NCOL_BRUT} colonnes</span><span class="etat" class:vu={e >= 7}>inchangé</span></span>
        <span class="ap" class:vu={e >= 7}><code>df_clean</code><span class="dim">{NLIG} lignes × {NCOL_PROPRE} colonnes</span><span class="etat">nouveau</span></span>
      </div>

      <div class="table">
        {#each COLONNES as c}
          <div class="col" class:actif={actif(c)}>
            <div class="th" class:renomme={e >= c.nom}>
              <span class="av" class:parti={e >= c.nom}>{c.brut}</span>
              <span class="ap" class:vu={e >= c.nom}>{c.propre}</span>
            </div>
            {#each c.cellules as v, r}
              <div class="td">
                {#if c.val !== null && v.change}
                  <span class="av" class:alerte={v.na && e >= c.lire} class:parti={e >= c.val} style="transition-delay: {r * 120}ms">{v.avant}</span>
                  <span class="ap" class:na={v.na} class:vu={e >= c.val} class:flash={e >= c.val} style="transition-delay: {r * 120}ms; animation-delay: {r * 120}ms">{v.apres}</span>
                {:else}
                  <span>{v.avant}</span>
                {/if}
              </div>
            {/each}
          </div>
        {/each}
      </div>
    </section>

    <aside class="fiche" class:vu={e >= 1 && e <= 6}>
      <span class="tete">CODEBOOK</span>
      <div class="pile corps">
        <div class="ctn" class:vu={e >= 1 && e <= 3}>
          <code class="var">cps25_education</code>
          <p class="quoi">scolarité · codes 1 à {NCODES}</p>
          <ul>
            {#each FICHE_EDU as l}
              <li>
                <span class="code">{l.code}</span><span class="nom">{l.nom}</span>
                <span class="cat" class:vu={e >= 3}>→ {l.cat}</span>
              </li>
            {/each}
          </ul>
        </div>
        <div class="ctn" class:vu={e >= 4 && e <= 6}>
          <code class="var">cps25_lr_scale_bef_1</code>
          <p class="quoi">échelle gauche-droite</p>
          <ul>
            <li><span class="code">0</span><span class="nom">gauche</span><span></span></li>
            <li><span class="code">10</span><span class="nom">droite</span><span></span></li>
            <li class="rouge"><span class="code">-99</span><span class="nom">non-réponse</span><span class="cat" class:vu={e >= 6}>→ NA</span></li>
          </ul>
        </div>
      </div>
    </aside>
  </div>

  <p class="source">Étude électorale canadienne 2025 · quatre vraies personnes</p>
</div>

<style>
  .nettoyage2 { display: flex; flex-direction: column; gap: 0.9em; }

  /* Le rail des quatre gestes : le geste en cours en rouge. */
  .rail { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, auto); justify-content: start; gap: 0 1.6em; }
  .nettoyage2 .rail li { font-size: 0.72em; line-height: 1.2; color: var(--dk-gris-2); padding-bottom: 0.3em; border-bottom: 3px solid var(--dk-filet); transition: color 0.3s, border-color 0.3s; white-space: nowrap; }
  .rail li b { display: inline-block; min-width: 1.5em; }
  .nettoyage2 .rail li.fait { color: var(--dk-encre); border-color: var(--dk-encre); }
  .nettoyage2 .rail li.ici { color: var(--dk-accent); border-color: var(--dk-accent); font-weight: 600; }

  .scene { display: grid; grid-template-columns: auto 1fr; gap: 1.2em; align-items: start; }
  .bloc { display: flex; flex-direction: column; gap: 0.5em; }

  /* Deux états empilés dans la même case : la largeur ne bouge pas pendant le fondu. */
  .pile, .th, .td { display: grid; }
  .pile > *, .th > *, .td > * { grid-area: 1 / 1; }
  .av { transition: opacity 0.35s, transform 0.35s; }
  .av.parti { opacity: 0; transform: translateY(-0.45em); }
  .ap { opacity: 0; transform: translateY(0.45em); transition: opacity 0.35s, transform 0.35s; }
  .ap.vu { opacity: 1; transform: none; }

  /* Les deux objets : df_raw reste, df_clean arrive dessous (place réservée). */
  .objet { font-size: 0.8em; display: grid; grid-template-columns: auto auto auto; justify-content: start; gap: 0.15em 0; align-items: baseline; }
  .objet > span { display: contents; }
  .objet code { font-family: var(--dk-mono); font-weight: 600; font-size: 1.15em; }
  .objet .ap > * { opacity: 0; transition: opacity 0.35s; }
  .objet .ap.vu > * { opacity: 1; }
  .objet .ap code { color: var(--dk-accent); }
  .dim { color: var(--dk-gris); font-size: 0.85em; margin-left: 0.6em; }
  .etat { font-size: 0.85em; font-weight: 600; margin-left: 1em; }
  .brut .etat { opacity: 0; transition: opacity 0.35s; }
  .brut .etat.vu { opacity: 1; }
  .ap .etat { color: var(--dk-accent); }

  /* Le tableau, colonne par colonne : une colonne active se cerne de rouge. */
  .table { display: grid; grid-template-columns: repeat(3, auto); border: 3px solid var(--dk-encre); transition: border-color 0.4s; }
  .fini .table { border-color: var(--dk-accent); }
  .col { display: grid; grid-template-rows: auto; outline: 4px solid transparent; outline-offset: -4px; transition: outline-color 0.3s, background 0.3s; }
  .col.actif { outline-color: var(--dk-accent); background: #fff; z-index: 1; }
  .th { white-space: nowrap; background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; font-size: 0.78em; padding: 0.55em 0.9em; align-items: center; transition: background 0.35s; }
  .th.renomme { background: var(--dk-accent); }
  .td { font-size: 1.05em; padding: 0.4em 0.9em 0.4em 0.75em; border-top: 2px solid var(--dk-filet); font-variant-numeric: tabular-nums; white-space: nowrap; }
  .td .alerte { color: var(--dk-accent); font-weight: 600; }
  .td .na { color: var(--dk-gris-2); font-weight: 600; }
  .td .flash { animation: flash 1.1s ease-out both; }
  @keyframes flash {
    0%, 35% { background: var(--dk-accent); color: var(--dk-fond); }
    100% { background: transparent; }
  }

  /* La fiche du codebook : ouverte pendant qu'on lit une colonne. */
  .fiche { border: 3px solid var(--dk-accent); background: #fff; opacity: 0; transform: translateX(0.6em); transition: opacity 0.4s, transform 0.4s; }
  .fiche.vu { opacity: 1; transform: none; }
  .tete { display: block; background: var(--dk-accent); color: var(--dk-fond); font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; padding: 0.4em 1.1em; }
  .corps { padding: 0.7em 1em 0.8em; }
  .ctn { opacity: 0; transition: opacity 0.35s; }
  .ctn.vu { opacity: 1; }
  .var { font-family: var(--dk-mono); font-weight: 600; font-size: 0.8em; color: var(--dk-accent); background: none; padding: 0; }
  .quoi { margin: 0.2em 0 0.55em; font-size: 0.72em; color: var(--dk-gris); }
  .fiche ul { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: auto auto 1fr; gap: 0.35em 0.6em; align-items: baseline; }
  .nettoyage2 .fiche li { display: contents; font-size: 1em; }
  .code, .nom, .cat { font-size: 0.8em; line-height: 1.3; white-space: nowrap; }
  .code { font-weight: 600; text-align: right; font-variant-numeric: tabular-nums; }
  .cat { color: var(--dk-accent); font-weight: 600; opacity: 0; transition: opacity 0.35s 0.2s; white-space: nowrap; }
  .cat.vu { opacity: 1; }
  li.rouge .code, li.rouge .nom { color: var(--dk-accent); }

  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .av, .ap, .col, .th, .fiche, .ctn, .cat, .rail li, .table, .objet .ap > *, .brut .etat { transition: none; }
    .td .flash { animation: none; }
  }
</style>
