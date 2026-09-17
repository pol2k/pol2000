<script>
  /**
   * Quatre formes, quatre vraies variables de l'Étude électorale canadienne
   * 2025 (src/lib/data/seance3.js ; les « ne sait pas » sont écartés).
   *
   *   0  Les quatre diagrammes poussent, barre par barre.
   *   1  Gauche-droite : la silhouette se trace, « Symétrique ».
   *   2  Intérêt pour la politique : « Étirée vers la gauche ».
   *   3  Pierre Poilievre, thermomètre : « En U ».
   *   4  Personnes dans le ménage : « Étirée vers la droite ».
   *   5  Dans les quatre panneaux à la fois, deux traits verticaux : la
   *      moyenne (encre) et la médiane (rouge, tiretée), chacune avec sa
   *      valeur. Symétrique : elles se confondent. Étirée ou en U : elles
   *      s'écartent. Pour le ménage, la moyenne sort du graphique : une
   *      flèche pointe vers la droite.
   *
   * Les formes révélées restent ; la dernière porte le cadre rouge, sauf au
   * temps 5, où aucun panneau n'est mis en avant.
   *
   * Moyennes et médianes viennent de FORMES, sauf pour le ménage : on lit
   * celles de la sortie summary() que la diapositive « Dans les vraies
   * données » affiche (CONSOLES.menage), pour que le deck ne montre jamais
   * deux moyennes différentes pour la même variable.
   */
  import { brancherTemps } from '../temps.js';
  import { FORMES, CONSOLES } from '$lib/data/seance3.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });

  // summary() : Min. 1st Qu. Median Mean 3rd Qu. Max. ; on lit la ligne des
  // valeurs par position (la médiane est la 3e, la moyenne la 4e).
  function resumeMenage() {
    const lignes = CONSOLES.menage[0].out.trim().split('\n');
    const v = lignes[lignes.length - 1].trim().split(/\s+/).map(Number);
    if (v.length !== 6 || v.some(Number.isNaN)) throw new Error('Formes : sortie summary() du ménage illisible.');
    return { mediane: v[2], moyenne: v[3] };
  }
  const MENAGE = resumeMenage();
  const FINE = ' ';
  const fr = (n, dec) => n.toLocaleString('fr-CA', { minimumFractionDigits: dec, maximumFractionDigits: dec }).replace(/\s/g, FINE);

  const W = 460, X0 = 22, X1 = 438, Y0 = 176, Y1 = 12;
  const PANNEAUX = [
    { cle: 'gauche_droite', titre: 'Gauche-droite · 0 à 10', forme: 'Symétrique' },
    { cle: 'interet', titre: 'Intérêt pour la politique · 0 à 10', forme: 'Étirée vers la gauche' },
    { cle: 'poilievre', titre: 'Pierre Poilievre · thermomètre 0 à 100', forme: 'En U' },
    { cle: 'menage', titre: 'Personnes dans le ménage · 1 à 12', forme: 'Étirée vers la droite' }
  ];

  function lisse(p) {
    let d = `M ${p[0][0].toFixed(1)} ${p[0][1].toFixed(1)}`;
    for (let i = 0; i < p.length - 1; i++) {
      const p0 = p[i - 1] ?? p[i], p1 = p[i], p2 = p[i + 1], p3 = p[i + 2] ?? p2;
      const borne = (y) => Math.max(Y1 - 8, Math.min(Y0, y));
      const c1 = [p1[0] + (p2[0] - p0[0]) / 6, borne(p1[1] + (p2[1] - p0[1]) / 6)];
      const c2 = [p2[0] - (p3[0] - p1[0]) / 6, borne(p2[1] - (p3[1] - p1[1]) / 6)];
      d += ` C ${c1[0].toFixed(1)} ${c1[1].toFixed(1)}, ${c2[0].toFixed(1)} ${c2[1].toFixed(1)}, ${p2[0].toFixed(1)} ${p2[1].toFixed(1)}`;
    }
    return d;
  }

  const figures = PANNEAUX.map((p) => {
    const F = FORMES[p.cle];
    const k = F.effectifs.length;
    const pas = (X1 - X0) / k;
    const max = Math.max(...F.effectifs);
    const barres = F.effectifs.map((n, i) => {
      const h = (n / max) * (Y0 - Y1);
      return { x: X0 + i * pas + pas * 0.08, w: pas * 0.84, y: Y0 - h, h, cx: X0 + (i + 0.5) * pas };
    });
    // Le thermomètre est découpé en tranches : on gradue les bornes (0, 50, 100).
    const etiquettes = p.cle === 'poilievre'
      ? [0, 5, 10].map((j) => ({ x: X0 + j * pas, t: String(F.valeurs[j]) }))
      : F.valeurs.map((v, i) => ({ x: X0 + (i + 0.5) * pas, t: String(v) }));
    const pts = [[X0, Y0], ...barres.map((b) => [b.cx, b.y]), [X1, Y0]];

    // Où tombe une valeur sur l'axe. Le thermomètre est en tranches de 0 à
    // 100 ; les trois autres ont une barre par valeur entière, centrée.
    const xDe = p.cle === 'poilievre'
      ? (v) => X0 + (v / 100) * (X1 - X0)
      : (v) => X0 + (v - F.valeurs[0] + 0.5) * pas;
    const moy = p.cle === 'menage' ? MENAGE.moyenne : F.moyenne;
    const med = p.cle === 'menage' ? MENAGE.mediane : F.mediane;
    const horsChamp = xDe(moy) > X1;
    const reperes = {
      xMoy: horsChamp ? null : xDe(moy),
      xMed: xDe(med),
      tMoy: `moy. ${fr(moy, moy >= 1000 ? 0 : 1)}`,
      tMed: `méd. ${fr(med, 0)}`,
      // L'étiquette de la plus petite des deux va à gauche de son trait, l'autre à droite.
      moyAGauche: moy <= med,
      horsChamp
    };
    return { ...p, barres, etiquettes, contour: lisse(pts), reperes };
  });
</script>

<div class="visuel formes" bind:this={hote}>
  <div class="grille">
    {#each figures as f, i}
      <div class="panneau" class:actif={e === i + 1}>
        <div class="tete">
          <span class="titre">{f.titre}</span>
          <span class="forme" class:vue={e >= i + 1}>{f.forme}</span>
        </div>
        <svg viewBox="0 0 {W} 210" role="img" aria-label="{f.titre} : distribution de forme {f.forme.toLowerCase()}.">
          {#each f.barres as b, j}
            <rect x={b.x} y={b.y} width={b.w} height={b.h} class="barre" class:pale={e >= i + 1} style="--d: {i * 180 + j * 45}ms" />
          {/each}
          <line x1={X0 - 4} y1={Y0} x2={X1 + 4} y2={Y0} class="axe" />
          {#each f.etiquettes as t}
            <text x={t.x} y={Y0 + 22} class="tick">{t.t}</text>
          {/each}
          <path d={f.contour} pathLength="1" class="contour" class:vu={e >= i + 1} />

          <!-- Temps 5 : où tombent la moyenne et la médiane. -->
          {#if e >= 5}
            {@const r = f.reperes}
            <g class="reperes" style="--d: {i * 120}ms">
              <line x1={r.xMed} y1={Y1 - 4} x2={r.xMed} y2={Y0} class="rep-med" />
              {#if r.horsChamp}
                <!-- La moyenne est hors du graphique : une flèche vers la droite. -->
                <path d="M {X1 - 70} 20 H {X1 + 2} M {X1 - 12} 10 L {X1 + 4} 20 L {X1 - 12} 30" class="rep-fleche" />
                <text x={X1 - 78} y="26" class="rep-t rep-moy fin">{r.tMoy}</text>
                <text x={r.xMed + 7} y="48" class="rep-t rep-medt">{r.tMed}</text>
              {:else}
                <line x1={r.xMoy} y1={Y1 - 4} x2={r.xMoy} y2={Y0} class="rep-moyl" />
                <text x={r.xMoy + (r.moyAGauche ? -20 : 12)} y="26" class="rep-t rep-moy" class:fin={r.moyAGauche}>{r.tMoy}</text>
                <text x={r.xMed + (r.moyAGauche ? 7 : -7)} y="48" class="rep-t rep-medt" class:fin={!r.moyAGauche}>{r.tMed}</text>
              {/if}
            </g>
          {/if}
        </svg>
      </div>
    {/each}
  </div>
  <div class="pied">
    <p class="lecon" class:vue={e >= 5}>Symétrique&#8239;: elles se confondent. Étirée ou en U&#8239;: elles s’écartent.</p>
    <p class="source">Étude électorale canadienne 2025</p>
  </div>
</div>

<style>
  .formes { display: flex; flex-direction: column; gap: 0.35em; }
  .grille { display: grid; grid-template-columns: 1fr 1fr; gap: 0.7em 1.2em; }
  .panneau { border: 2px solid var(--dk-filet); padding: calc(0.4em + 1px) calc(0.7em + 1px) calc(0.3em + 1px); transition: border-color 0.3s; }
  .panneau.actif { border: 3px solid var(--dk-accent); padding: 0.4em 0.7em 0.3em; }
  .tete { display: flex; justify-content: space-between; align-items: baseline; gap: 0.8em; min-height: 1.6em; }
  .titre { font-size: 0.64em; letter-spacing: 0.04em; color: var(--dk-encre); font-weight: 600; }
  .forme { font-size: 1em; font-weight: 600; color: var(--dk-accent); white-space: nowrap; opacity: 0; }
  .forme.vue { animation: pop 0.55s cubic-bezier(0.3, 1.7, 0.5, 1) both; }
  svg { width: 100%; height: auto; max-height: 24vh; display: block; }
  text { font-family: var(--dk-mono); }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .barre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: bottom; animation: monte 0.5s cubic-bezier(0.3, 1.4, 0.5, 1) both; animation-delay: var(--d); transition: fill 0.4s; }
  .barre.pale { fill: var(--dk-gris-2); }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .contour { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: round; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .contour.vu { animation: trace 1.1s ease-in-out forwards; }
  .source { margin: 0; font-size: 0.56em; letter-spacing: 0.06em; color: var(--dk-gris); white-space: nowrap; }

  /* Le pied : la leçon à gauche, la source à droite, sur une seule ligne,
     pour que le temps 5 n'ajoute aucune hauteur à la diapositive. */
  .pied { display: flex; justify-content: space-between; align-items: baseline; gap: 1.5em; }
  .lecon { margin: 0; font-size: 0.82em; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.5s; }
  .lecon.vue { opacity: 1; }

  /* Temps 5 : la moyenne en encre, la médiane en rouge tireté. */
  .reperes { animation: fondu 0.4s ease-out both; animation-delay: var(--d); }
  .rep-moyl { stroke: var(--dk-encre); stroke-width: 4; }
  .rep-med { stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 9 6; }
  .rep-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  /* Halo couleur papier : les étiquettes passent devant les barres et la silhouette. */
  .rep-t { font-size: 17px; font-weight: 600; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }
  .rep-t.fin { text-anchor: end; }
  .rep-moy { fill: var(--dk-encre); }
  .rep-medt { fill: var(--dk-accent); }

  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes pop { from { opacity: 0; transform: scale(0.4); } to { opacity: 1; transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .barre { animation: none; transition: none; }
    .contour.vu { animation: none; stroke-dashoffset: 0; }
    .forme.vue { animation: none; opacity: 1; }
    .reperes { animation: none; }
    .lecon { transition: none; }
  }
</style>
