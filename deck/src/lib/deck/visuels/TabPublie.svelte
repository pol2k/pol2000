<script>
  /**
   * Le tableau de régression tel qu'on le voit dans un article : une colonne
   * par modèle, la variable expliquée en tête, le coefficient avec ses
   * étoiles, l'erreur type entre parenthèses dessous, puis N, R² et la
   * légende. Composant muet : il ne compte pas les clics. La diapo qui
   * l'emploie possède le temps et dit quoi surligner (prop `on`).
   *
   * Tous les nombres viennent de src/lib/data/seance7.js (outils/seance7_data.R) :
   *   modèle 1 : NOTRE  (interet ~ scolarite, les cas complets)
   *   modèle 2 : MULTIPLE (+ âge, femme, revenu, Québec)
   * Toutes les variables vont de 0 à 1 (convention du cours). Coefficients
   * et erreurs types à trois décimales (une erreur type de 0,032 arrondie à
   * 0,03 fausserait le t qu'on compte à la diapo suivante), R² à deux.
   * Virgule décimale, vrai signe moins. Les noms viennent de VARS.
   *
   *   on      — clés à surligner. Chaque cellule porte des clés : 'y' (la
   *             variable expliquée), 'col1' / 'col2' (une colonne), 'x' (les
   *             noms de variables), 'coef', 'se', 'etoiles' (toutes les
   *             lignes), 'b-<terme>', 'se-<terme>', 'etoiles-<terme>',
   *             'ligne-<terme>' (une seule ligne), 'n', 'r2', 'legende' (les
   *             étoiles), 'legende-se' (la note sur les parenthèses).
   *             Ce qui n'est pas surligné passe au gris quand `on` n'est pas vide.
   *   deux    — la colonne du modèle 2 et ses lignes existent (diapo de la
   *             semaine prochaine). `vu2` les fait apparaître.
   */
  import { NOTRE, MULTIPLE, VARS } from '$lib/data/seance7.js';

  let { on = [], deux = false, vu2 = false } = $props();

  const f = (v, d = 3) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  // Les seuils de la légende, ceux de R : *** p < 0,001, ** p < 0,01, * p < 0,05.
  const etoiles = (p) => (p < 0.001 ? '***' : p < 0.01 ? '**' : p < 0.05 ? '*' : '');

  // Les lignes, dans l'ordre de l'article : les variables, puis la constante.
  const NOMS = {
    [VARS.x.nom]: [VARS.x.court, '(0 à 1)'],
    age: ['Âge', `(0 = 18 ans, 1 = ${MULTIPLE.age_max} ans)`],
    femme: ['Femme', '(0 = non, 1 = oui)'],
    revenu: ['Revenu', '(8 tranches, de 0 à 1)'],
    quebec: ['Québec', '(0 = non, 1 = oui)'],
    '(Intercept)': ['Constante', '']
  };
  // Le nom de la variable expliquée sur deux lignes, coupé à l'espace du milieu.
  const coupe = (t) => { const m = t.lastIndexOf(' ', Math.ceil(t.length / 2)); return m > 0 ? [t.slice(0, m), t.slice(m + 1)] : [t, '']; };
  const Y = coupe(VARS.y.court);
  const ORDRE = [VARS.x.nom, 'age', 'femme', 'revenu', 'quebec', '(Intercept)'];
  const M1 = Object.fromEntries(NOTRE.coefs.map((c) => [c.terme, c]));
  const M2 = Object.fromEntries(MULTIPLE.coefs.map((c) => [c.terme, c]));
  const LIGNES = ORDRE.filter((t) => deux || M1[t]).map((t) => ({ terme: t, nom: NOMS[t], m1: M1[t], m2: M2[t], seul2: !M1[t] }));

  const actif = $derived(on.length > 0);
  const vu = (cles) => cles.some((k) => on.includes(k));
  const cellule = (t, col) => [`col${col}`, `ligne-${t}`];
</script>

<table class="tab-publie" class:tp-actif={actif} class:tp-deux={deux}>
  <thead>
    <tr>
      <th class="tp-vide"></th>
      <th class="tp-y" class:tp-on={vu(['y'])} colspan={deux ? 2 : 1}>{#if deux}{VARS.y.court}{:else}{Y[0]}<br />{Y[1]}{/if}<br /><span class="tp-sous">(0 à 1)</span></th>
    </tr>
    <tr class="tp-cols">
      <th></th>
      <th class:tp-on={vu(['col1'])}>Modèle 1</th>
      {#if deux}<th class="tp-m2" class:tp-vu2={vu2} class:tp-on={vu(['col2'])}>Modèle 2</th>{/if}
    </tr>
  </thead>
  <tbody>
    {#each LIGNES as l}
      {@const t = l.terme}
      <tr class="tp-b" class:tp-seul2={l.seul2} class:tp-vu2={vu2}>
        <th class="tp-nom" class:tp-on={vu(['x', `ligne-${t}`])}><span class="tp-plie">{l.nom[0]}</span></th>
        <td class:tp-on={vu([...cellule(t, 1), 'coef', `b-${t}`])}>
          {#if l.m1}<span class="tp-plie">{f(l.m1.b)}<span class="tp-et" class:tp-on={vu(['etoiles', `etoiles-${t}`])}>{etoiles(l.m1.p)}</span></span>{/if}
        </td>
        {#if deux}
          <td class="tp-m2" class:tp-vu2={vu2} class:tp-on={vu([...cellule(t, 2), 'coef', `b-${t}`])}>
            <span class="tp-plie">{f(l.m2.b)}<span class="tp-et" class:tp-on={vu(['etoiles', `etoiles-${t}`])}>{etoiles(l.m2.p)}</span></span>
          </td>
        {/if}
      </tr>
      <tr class="tp-se" class:tp-seul2={l.seul2} class:tp-vu2={vu2}>
        <th class="tp-nom tp-sous" class:tp-on={vu(['x', `ligne-${t}`])}><span class="tp-plie">{l.nom[1]}</span></th>
        <td class:tp-on={vu([...cellule(t, 1), 'se', `se-${t}`])}>
          {#if l.m1}<span class="tp-plie">({f(l.m1.se)})<span class="tp-et"></span></span>{/if}
        </td>
        {#if deux}
          <td class="tp-m2" class:tp-vu2={vu2} class:tp-on={vu([...cellule(t, 2), 'se', `se-${t}`])}>
            <span class="tp-plie">({f(l.m2.se)})<span class="tp-et"></span></span>
          </td>
        {/if}
      </tr>
    {/each}
  </tbody>
  <tbody class="tp-pied">
    <tr>
      <th class="tp-nom" class:tp-on={vu(['n'])}>N</th>
      <td class:tp-on={vu(['n', 'col1'])}>{NOTRE.n_modele}<span class="tp-et"></span></td>
      {#if deux}<td class="tp-m2" class:tp-vu2={vu2} class:tp-on={vu(['n', 'col2'])}>{MULTIPLE.n_modele}<span class="tp-et"></span></td>{/if}
    </tr>
    <tr>
      <th class="tp-nom" class:tp-on={vu(['r2'])}>R²</th>
      <td class:tp-on={vu(['r2', 'col1'])}>{f(NOTRE.r2, 2)}<span class="tp-et"></span></td>
      {#if deux}<td class="tp-m2" class:tp-vu2={vu2} class:tp-on={vu(['r2', 'col2'])}>{f(MULTIPLE.r2, 2)}<span class="tp-et"></span></td>{/if}
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td colspan={deux ? 3 : 2} class:tp-on={vu(['legende', 'etoiles'])}>
        <span class:tp-on={vu(['legende', 'etoiles'])}>*** p&#8239;&lt;&#8239;0,001 · ** p&#8239;&lt;&#8239;0,01 · * p&#8239;&lt;&#8239;0,05</span><br />
        <span class:tp-on={vu(['se', 'legende-se'])}>Erreurs types entre parenthèses.</span>
      </td>
    </tr>
  </tfoot>
</table>

<style>
  /* Le style des tableaux du deck (deck.css, .diapo th / td) est remis à zéro :
     un tableau d'article a ses propres filets, trois traits pleins. */
  .tab-publie { border-collapse: collapse; width: auto; font-size: 1em; font-variant-numeric: tabular-nums; line-height: 1.2; color: var(--dk-encre); }
  .tab-publie th, .tab-publie td { font-family: var(--dk-mono); font-size: 1em; font-weight: 400; letter-spacing: 0; text-transform: none; color: var(--dk-encre); border: 0; padding: 0.1em 0.7em; transition: color 0.3s, background-color 0.3s; }
  .tab-publie thead th { text-align: right; }
  .tab-publie .tp-y, .tab-publie .tp-vide { border-top: 2px solid var(--dk-encre); padding-top: 0.4em; padding-bottom: 0.1em; }
  .tab-publie .tp-y { text-align: center; font-weight: 600; }
  .tab-publie .tp-cols th { border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.35em; color: var(--dk-gris); text-align: center; }
  .tab-publie .tp-sous { font-weight: 400; font-size: 0.8em; color: var(--dk-gris); }
  .tab-publie .tp-nom { text-align: left; padding-right: 2em; white-space: nowrap; }
  .tab-publie td { text-align: right; white-space: nowrap; }
  .tab-publie .tp-b td, .tab-publie .tp-b th { padding-top: 0.45em; }
  .tab-publie .tp-se td { color: var(--dk-gris); }
  /* Les étoiles dans une case de largeur fixe : les virgules restent alignées. */
  .tp-et { display: inline-block; width: 2.1em; text-align: left; padding-left: 0.12em; }
  .tab-publie .tp-pied tr:first-child th, .tab-publie .tp-pied tr:first-child td { border-top: 2px solid var(--dk-encre); padding-top: 0.4em; }
  .tab-publie .tp-pied tr:last-child th, .tab-publie .tp-pied tr:last-child td { padding-bottom: 0.4em; }
  .tab-publie tfoot td { border-top: 2px solid var(--dk-encre); text-align: left; font-size: 0.62em; color: var(--dk-gris); padding: 0.5em 0.7em 0; line-height: 1.5; white-space: normal; }

  /* Le surlignage : ce qu'on lit passe au rouge, le reste se retire. */
  .tp-actif th, .tp-actif td, .tp-actif .tp-et, .tp-actif .tp-sous, .tp-actif tfoot span { color: var(--dk-gris-2); }
  .tab-publie.tp-actif .tp-on, .tp-actif .tp-on .tp-sous, .tp-actif .tp-on .tp-plie { color: var(--dk-accent); font-weight: 600; }
  .tab-publie.tp-actif td.tp-on, .tab-publie.tp-actif th.tp-on { background: rgba(198, 16, 46, 0.08); }
  .tab-publie.tp-actif tfoot td.tp-on { background: none; }
  .tp-actif .tp-on .tp-et:not(.tp-on) { color: var(--dk-gris-2); font-weight: 400; }

  /* Le modèle 2 : sa colonne et ses lignes apparaissent au clic. */
  .tab-publie .tp-m2 { opacity: 0; transition: opacity 0.45s 0.15s, color 0.3s, background-color 0.3s; }
  .tab-publie .tp-m2.tp-vu2 { opacity: 1; }
  .tp-seul2 .tp-plie { display: block; max-height: 0; overflow: hidden; transition: max-height 0.45s; }
  .tp-seul2.tp-vu2 .tp-plie { max-height: 1.5em; }
  .tab-publie .tp-seul2:not(.tp-vu2) td, .tab-publie .tp-seul2:not(.tp-vu2) th { padding-top: 0; padding-bottom: 0; }

  @media (prefers-reduced-motion: reduce) {
    .tab-publie th, .tab-publie td, .tab-publie .tp-m2, .tp-seul2 .tp-plie { transition: none; }
  }
</style>
