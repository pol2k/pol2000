<script>
  /**
   * On n'interprète pas les variables de contrôle. Le vrai tableau du modèle
   * complet de la séance 7 (MULTI, src/lib/data/seance8.js, généré par
   * outils/seance8_data.R et vérifié contre seance7.js), dressé comme le
   * tableau modelsummary que les étudiant.e.s ont produit (mêmes noms que
   * coef_rename dans outils/seance7_ms.R, l'erreur type entre parenthèses
   * sous le coefficient, N et R² sous le filet, le seuil des étoiles).
   *
   *   0  le tableau, toutes les lignes pareilles;
   *   1  la ligne de la scolarité s'allume : c'est elle qu'on interprète;
   *   2  les contrôles pâlissent, une accolade, et la raison;
   *   3  un cas : l'âge. Son coefficient est estimé à scolarité égale, or
   *      l'âge agit aussi en passant par la scolarité (les plus âgé.e.s ont
   *      moins étudié) : 0,349 n'est pas l'effet de l'âge. C'est l'exemple
   *      d'Arel-Bundock (2021, chap. 6, « Interprétation des variables de
   *      contrôle »). Le nom « piège du tableau 2 » (Westreich et Greenland,
   *      2013) n'apparaît qu'en petit, comme référence.
   *
   * Le schéma de l'âge est un schéma (aucune donnée), et dit seulement ce
   * que le modèle tient égal. Flèches en polygones, pas de <marker> (les id
   * SVG ne sont pas isolés d'une diapo à l'autre).
   */
  import { brancherTemps } from '../temps.js';
  import { MULTI as M } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
  const NOMS = {
    '(Intercept)': 'Constante',
    scolarite: 'Scolarité (0 à 1)',
    age: 'Âge (0 à 1)',
    femme: 'Femme',
    revenu: 'Revenu (0 à 1)',
    quebec: 'Québec'
  };
  const CLE = 'scolarite';
  const role = (t) => (t === CLE ? 'cle' : t === '(Intercept)' ? 'constante' : 'controle');
  const AGE = M.coefs.find((c) => c.terme === 'age');

  // Le schéma : Âge en haut, Scolarité (tenue égale) à gauche, Intérêt à droite.
  const N = { age: [250, 46], sco: [90, 210], int: [410, 210] };
  function fleche([x1, y1], [x2, y2], r1 = 0, r2 = 0) {
    const dx = x2 - x1, dy = y2 - y1, d = Math.hypot(dx, dy), ux = dx / d, uy = dy / d;
    const a = [x1 + ux * r1, y1 + uy * r1], b = [x2 - ux * r2, y2 - uy * r2];
    const p = [b[0] - ux * 16, b[1] - uy * 16];
    return { x1: a[0], y1: a[1], x2: p[0], y2: p[1], tri: `${b[0]},${b[1]} ${p[0] - uy * 8},${p[1] + ux * 8} ${p[0] + uy * 8},${p[1] - ux * 8}` };
  }
  const F_AS = fleche(N.age, N.sco, 32, 34);
  const F_SI = fleche(N.sco, N.int, 92, 72);
  const F_AI = fleche(N.age, N.int, 32, 34);
</script>

<div class="visuel m8c" class:m8c-e1={e >= 1} class:m8c-e2={e >= 2} bind:this={hote}>
  <figure class="m8c-feuille">
    <table>
      <caption>Intérêt pour la politique</caption>
      <thead><tr><th></th><th>(1)</th></tr></thead>
      {#each M.coefs as c}
        <tbody class="m8c-{role(c.terme)}">
          <tr><td class="m8c-nom">{NOMS[c.terme] ?? c.terme}</td><td class="m8c-v">{f(c.b)}<span class="m8c-et">{c.etoiles}</span></td></tr>
          <tr class="m8c-se"><td></td><td class="m8c-v">({f(c.se)})<span class="m8c-et"></span></td></tr>
        </tbody>
      {/each}
      <tbody class="m8c-gof">
        <tr><td class="m8c-nom">Num.Obs.</td><td class="m8c-v">{M.n_modele}<span class="m8c-et"></span></td></tr>
        <tr><td class="m8c-nom">R2</td><td class="m8c-v">{f(M.r2)}<span class="m8c-et"></span></td></tr>
      </tbody>
    </table>
    <p class="m8c-seuils">+ p &lt; 0,1, * p &lt; 0,05, ** p &lt; 0,01, *** p &lt; 0,001</p>
    <figcaption>Notre sondage de la séance 7</figcaption>
  </figure>

  <div class="m8c-droite">
    <div class="m8c-bloc m8c-bloc-cle" class:m8c-vu={e >= 1}>
      <p class="m8c-etiq">La variable d’intérêt</p>
      <p class="m8c-gros">Scolarité&#8239;: <span class="m8c-rouge">on l’interprète.</span></p>
    </div>
    <div class="m8c-bloc m8c-bloc-ctl" class:m8c-vu={e >= 2}>
      <p class="m8c-etiq">Âge, femme, revenu, Québec</p>
      <p class="m8c-gros">Des contrôles&#8239;: on ne les interprète pas.</p>
      <p class="m8c-moyen">Ils sont là pour que la comparaison soit juste pour la scolarité.</p>
    </div>
    <div class="m8c-cas" class:m8c-vu={e >= 3}>
      <svg viewBox="0 0 500 290" role="img" aria-label="Schéma : l’âge agit sur l’intérêt directement et en passant par la scolarité. La scolarité est tenue égale dans le modèle, donc le chemin qui passe par elle est coupé.">
        <!-- Âge → Scolarité : coupé, la scolarité est tenue égale -->
        <line x1={F_AS.x1} y1={F_AS.y1} x2={F_AS.x2} y2={F_AS.y2} class="m8c-coupe" />
        <polygon points={F_AS.tri} class="m8c-coupe-p" />
        <line x1={F_SI.x1} y1={F_SI.y1} x2={F_SI.x2} y2={F_SI.y2} class="m8c-sco" />
        <polygon points={F_SI.tri} class="m8c-sco-p" />
        <!-- Âge → Intérêt : ce que 0,349 garde -->
        <line x1={F_AI.x1} y1={F_AI.y1} x2={F_AI.x2} y2={F_AI.y2} class="m8c-garde" />
        <polygon points={F_AI.tri} class="m8c-garde-p" />
        <rect x={N.sco[0] - 88} y={N.sco[1] - 28} width="176" height="56" class="m8c-boite" />
        <text x={N.sco[0]} y={N.sco[1] + 9} class="m8c-n">scolarité</text>
        <text x={N.sco[0]} y={N.sco[1] + 56} class="m8c-n-petit">tenue égale</text>
        <text x={N.age[0]} y={N.age[1] + 9} class="m8c-n m8c-n-fort">âge</text>
        <text x={N.int[0]} y={N.int[1] + 9} class="m8c-n">intérêt</text>
        <text x={N.age[0] + 112} y="108" class="m8c-val">{f(AGE.b)}</text>
      </svg>
      <p class="m8c-moyen"><strong>{f(AGE.b)}</strong>&#8239;: l’âge, à scolarité égale. Pas l’effet de l’âge.</p>
    </div>
    <p class="m8c-ref" class:m8c-vu={e >= 3}>schéma · Arel-Bundock (2021), chap. 6 · « le piège du tableau 2 », Westreich et Greenland (2013)</p>
  </div>
</div>

<style>
  .m8c { display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 2.6em; align-items: center; max-width: 64em; margin: 0 auto; }

  .m8c-feuille { margin: 0; background: #fff; outline: 2px solid var(--dk-filet); outline-offset: 0; padding: 0.7em 1.1em 0.6em; font-size: 0.86em; }
  .m8c-feuille table { border-collapse: collapse; font-variant-numeric: tabular-nums; width: 100%; font-size: 1em; }
  caption { text-align: left; font-size: 1em; padding-bottom: 0.35em; }
  .m8c-feuille th, .m8c-feuille td { border: none; background: none; }
  .m8c-feuille th { font-size: 1em; color: var(--dk-encre); letter-spacing: 0; text-transform: none; font-weight: 400; text-align: center; padding: 0.15em 0 0.2em; border-top: 2px solid var(--dk-encre); border-bottom: 2px solid var(--dk-encre); }
  .m8c-feuille td { padding: 0.06em 0.4em; line-height: 1.22; transition: opacity 0.4s, color 0.4s; }
  .m8c-feuille .m8c-nom { padding-left: 0.2em; padding-right: 2.2em; white-space: nowrap; }
  .m8c-feuille .m8c-v { text-align: right; white-space: nowrap; padding-right: 0.2em; }
  .m8c-et { display: inline-block; width: 1.9em; text-align: left; }
  .m8c-feuille .m8c-se td { padding-bottom: 0.32em; }
  .m8c-feuille .m8c-gof tr:first-child td { border-top: 2px solid var(--dk-encre); padding-top: 0.3em; }
  .m8c-feuille .m8c-gof tr:last-child td { border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; }
  .m8c-seuils { margin: 0.35em 0 0; font-size: 0.78em; }
  figcaption { margin-top: 0.5em; color: var(--dk-gris); font-size: 0.7em; }

  /* 1 : la scolarité s'allume. */
  tbody.m8c-cle td { transition: background 0.4s, color 0.4s; }
  .m8c-e1 tbody.m8c-cle td { background: var(--dk-accent); color: #fff; font-weight: 700; }
  /* 2 : le reste pâlit. */
  .m8c-e2 tbody.m8c-controle td, .m8c-e2 tbody.m8c-constante td { opacity: 0.28; }

  .m8c-droite { display: flex; flex-direction: column; gap: 1.5em; }
  .m8c-bloc { border-left: 6px solid var(--dk-accent); padding: 0.1em 0 0.15em 0.8em; opacity: 0; transition: opacity 0.4s; }
  .m8c-bloc-ctl { border-left-color: var(--dk-gris-2); }
  .m8c-etiq { margin: 0 0 0.2em; font-size: 0.72em; font-weight: 600; letter-spacing: 0.06em; color: var(--dk-gris); }
  .m8c-gros { margin: 0; font-size: 1.3em; font-weight: 600; line-height: 1.32; }
  .m8c-rouge { color: var(--dk-accent); }
  .m8c-cas { display: grid; grid-template-columns: minmax(0, 1.05fr) minmax(0, 1fr); gap: 1em; align-items: center; opacity: 0; transition: opacity 0.4s; }
  .m8c-cas svg { width: 100%; height: auto; display: block; }
  .m8c-moyen { margin: 0.25em 0 0; font-size: 0.95em; line-height: 1.35; }
  .m8c-ref { margin: 0; font-size: 0.6em; color: var(--dk-gris); opacity: 0; transition: opacity 0.4s; }
  .m8c-vu { opacity: 1; }

  svg text { font-family: var(--dk-mono); text-anchor: middle; }
  .m8c-n { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .m8c-n-fort { font-weight: 700; }
  .m8c-n-petit { font-size: 19px; fill: var(--dk-gris); }
  .m8c-val { font-size: 24px; font-weight: 700; fill: var(--dk-accent); text-anchor: start; }
  .m8c-boite { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .m8c-garde { stroke: var(--dk-accent); stroke-width: 4; }
  .m8c-garde-p { fill: var(--dk-accent); }
  .m8c-coupe { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 7; }
  .m8c-coupe-p { fill: var(--dk-gris-2); }
  .m8c-sco { stroke: var(--dk-encre); stroke-width: 3; }
  .m8c-sco-p { fill: var(--dk-encre); }

  @media (prefers-reduced-motion: reduce) { td, .m8c-bloc, .m8c-cas, .m8c-ref { transition: none; } }
</style>
