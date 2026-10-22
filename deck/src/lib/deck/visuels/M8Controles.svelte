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
   *   3  un cas : l'âge. Son effet sur l'intérêt passe par deux chemins,
   *      tout droit et par la scolarité (les plus âgé.e.s ont moins
   *      étudié). Des points rouges partent de l'âge et arrivent à
   *      l'intérêt par les deux chemins (Flux.svelte);
   *   4  le modèle tient la scolarité égale : elle est encadrée (la même
   *      convention qu'à la diapo de M8Intuition), les points de l'âge
   *      s'arrêtent au cadre et plus rien ne repart de la scolarité pour
   *      le compte de l'âge. Seul le chemin direct arrive encore : c'est
   *      lui que mesure 0,349, qui n'est donc pas l'effet de l'âge. C'est
   *      l'exemple d'Arel-Bundock (2021, chap. 6, « Interprétation des
   *      variables de contrôle »). Le nom « piège du tableau 2 »
   *      (Westreich et Greenland, 2013) n'apparaît qu'en petit.
   *
   * La flèche scolarité → intérêt reste pleine au temps 4 : la scolarité
   * a toujours son effet (c'est la ligne qu'on interprète), seuls les
   * points de l'âge n'y passent plus. Le schéma de l'âge est un schéma
   * (aucune donnée). Flèches en polygones, pas de <marker> (les id SVG ne
   * sont pas isolés d'une diapo à l'autre). La géométrie ne bouge pas
   * entre les temps 3 et 4 : seul le cadre apparaît.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';
  import { MULTI as M } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
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

  // Le schéma : Âge en haut, Scolarité à gauche, Intérêt à droite. Chaque
  // nœud a un rectangle de dégagement (demi-largeur, demi-hauteur) : celui
  // de la scolarité est le bord extérieur de son cadre, même quand le cadre
  // n'est pas encore dessiné, pour que rien ne bouge au temps 4.
  const N = {
    age: { x: 270, y: 50, hw: 36, hh: 24 },
    sco: { x: 104, y: 226, hw: 100, hh: 38 },
    int: { x: 436, y: 226, hw: 66, hh: 24 }
  };
  const JEU = 6, POINTE = 16;
  // Distance du centre au bord du rectangle, dans la direction (ux, uy).
  const bord = (n, ux, uy) => Math.min(ux ? n.hw / Math.abs(ux) : Infinity, uy ? n.hh / Math.abs(uy) : Infinity);
  // Une flèche de la cause (a) vers l'effet (b). d : le trait seul, de la
  // cause jusqu'au pied de la pointe (Flux le suit dans le même sens).
  function fleche(a, b) {
    const dx = b.x - a.x, dy = b.y - a.y, L = Math.hypot(dx, dy), ux = dx / L, uy = dy / L;
    const r1 = bord(a, ux, uy) + JEU, r2 = bord(b, ux, uy) + JEU;
    const x1 = a.x + ux * r1, y1 = a.y + uy * r1;
    const bx = b.x - ux * r2, by = b.y - uy * r2;
    const x2 = bx - ux * POINTE, y2 = by - uy * POINTE;
    return {
      x1, y1, x2, y2, ux, uy,
      long: Math.hypot(x2 - x1, y2 - y1),
      d: `M ${x1} ${y1} L ${x2} ${y2}`,
      tri: `${bx},${by} ${x2 - uy * 8},${y2 + ux * 8} ${x2 + uy * 8},${y2 - ux * 8}`
    };
  }
  const F_AS = fleche(N.age, N.sco);
  const F_SI = fleche(N.sco, N.int);
  const F_AI = fleche(N.age, N.int);
  // Même vitesse sur les trois flèches (unités du viewBox par seconde).
  const VITESSE = 60;
  const duree = (F) => +(F.long / VITESSE).toFixed(2);
  // 0,349 : au milieu de la flèche directe, décalé vers l'extérieur.
  const VAL = { x: (F_AI.x1 + F_AI.x2) / 2 + F_AI.uy * 22, y: (F_AI.y1 + F_AI.y2) / 2 - F_AI.ux * 22 };
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
      <svg viewBox="0 0 520 300" role="img" aria-label="Schéma : l’effet de l’âge sur l’intérêt passe par deux chemins, directement et par la scolarité. Le modèle tient la scolarité égale : le chemin qui passe par elle s’arrête au cadre, seul le chemin direct arrive à l’intérêt.">
        <!-- Âge → Scolarité : coupé au temps 4, la scolarité est tenue égale -->
        <g class="m8c-as" class:m8c-coupe={e >= 4}>
          <line x1={F_AS.x1} y1={F_AS.y1} x2={F_AS.x2} y2={F_AS.y2} />
          <polygon points={F_AS.tri} />
        </g>
        <!-- Scolarité → Intérêt : la flèche reste, la scolarité garde son effet -->
        <line x1={F_SI.x1} y1={F_SI.y1} x2={F_SI.x2} y2={F_SI.y2} class="m8c-sco" />
        <polygon points={F_SI.tri} class="m8c-sco-p" />
        <!-- Âge → Intérêt : le chemin direct, ce que 0,349 garde -->
        <line x1={F_AI.x1} y1={F_AI.y1} x2={F_AI.x2} y2={F_AI.y2} class="m8c-garde" />
        <polygon points={F_AI.tri} class="m8c-garde-p" />

        <!-- Le flux de l'âge. Le chemin direct ne change pas d'un temps à l'autre. -->
        <Flux d={F_AI.d} actif={e >= 3} rouge n={3} duree={duree(F_AI)} r={7} />
        <Flux d={F_AS.d} actif={e >= 3} arret={e >= 4 ? 0.995 : 1} rouge n={3} duree={duree(F_AS)} r={7} />
        <Flux d={F_SI.d} actif={e === 3} rouge n={3} duree={duree(F_SI)} r={7} />

        <g class="m8c-ctl" class:m8c-vu={e >= 4}>
          <rect x={N.sco.x - N.sco.hw + 8} y={N.sco.y - N.sco.hh + 8} width={2 * N.sco.hw - 16} height={2 * N.sco.hh - 16} class="m8c-boite" />
          <rect x={N.sco.x - N.sco.hw} y={N.sco.y - N.sco.hh} width={2 * N.sco.hw} height={2 * N.sco.hh} class="m8c-cadre" />
          <text x={N.sco.x} y={N.sco.y + N.sco.hh + 28} class="m8c-n-petit">tenue égale</text>
        </g>
        <text x={N.sco.x} y={N.sco.y + 10} class="m8c-n">scolarité</text>
        <text x={N.age.x} y={N.age.y + 10} class="m8c-n m8c-n-fort">âge</text>
        <text x={N.int.x} y={N.int.y + 10} class="m8c-n">intérêt</text>
        <text x={VAL.x} y={VAL.y} class="m8c-val m8c-ctl" class:m8c-vu={e >= 4}>{f(AGE.b)}</text>
      </svg>
      <p class="m8c-moyen m8c-ctl" class:m8c-vu={e >= 4}><strong>{f(AGE.b)}</strong>&#8239;: l’âge, à scolarité égale. Pas l’effet de l’âge.</p>
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
  .m8c-cas { display: grid; grid-template-columns: minmax(0, 1.3fr) minmax(0, 1fr); gap: 1em; align-items: center; opacity: 0; transition: opacity 0.4s; }
  .m8c-cas svg { width: 100%; height: auto; display: block; }
  .m8c-moyen { margin: 0.25em 0 0; font-size: 0.95em; line-height: 1.35; }
  .m8c-ref { margin: 0; font-size: 0.6em; color: var(--dk-gris); opacity: 0; transition: opacity 0.4s; }
  .m8c-vu { opacity: 1; }

  svg text { font-family: var(--dk-mono); text-anchor: middle; }
  .m8c-n { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .m8c-n-fort { font-weight: 700; }
  .m8c-n-petit { font-size: 20px; font-weight: 600; fill: var(--dk-accent); }
  .m8c-val { font-size: 24px; font-weight: 700; fill: var(--dk-accent); text-anchor: start; }
  .m8c-boite { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .m8c-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .m8c-ctl { opacity: 0; transition: opacity 0.4s; }
  .m8c-ctl.m8c-vu { opacity: 1; }
  .m8c-garde { stroke: var(--dk-accent); stroke-width: 4; }
  .m8c-garde-p { fill: var(--dk-accent); }
  .m8c-as line { stroke: var(--dk-accent); stroke-width: 4; transition: stroke 0.4s, stroke-width 0.4s; }
  .m8c-as polygon { fill: var(--dk-accent); transition: fill 0.4s; }
  .m8c-as.m8c-coupe line { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 7; }
  .m8c-as.m8c-coupe polygon { fill: var(--dk-gris-2); }
  .m8c-sco { stroke: var(--dk-encre); stroke-width: 3; }
  .m8c-sco-p { fill: var(--dk-encre); }

  @media (prefers-reduced-motion: reduce) { td, .m8c-bloc, .m8c-cas, .m8c-ref, .m8c-ctl, .m8c-as line, .m8c-as polygon { transition: none; } }
</style>
