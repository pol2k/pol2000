<script>
  /**
   * Avant, après : la satisfaction envers la démocratie des gagnants, des
   * perdants et des abstentionnistes, pendant la campagne puis après
   * l'élection. 1997 (Blais et Gélineau, tableau 1 : les gagnants et les
   * perdants aux deux niveaux) à gauche, 2025 (la CES, nos calculs) à droite.
   *
   *   0  1997 : les trois lignes montent;
   *   1  2025 : les gagnants montent, les perdants et les abstentionnistes baissent;
   *   2  le verdict : l'écart se creuse toujours; la lune de miel, non.
   *
   * 1997 vient de BG, 2025 de AVANT_APRES (outils/seance8_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { BG, AVANT_APRES as A } from '$lib/data/seance8.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const t1 = (cle) => BG.tableau1.find((g) => g.cle === cle);
  const GROUPES = [
    { cle: 'gagnant', nom: 'gagnants', classe: 'g' },
    { cle: 'perdant', nom: 'perdants', classe: 'p' },
    { cle: 'abstention', nom: 'abstention', classe: 'a' }
  ];
  const P97 = GROUPES.map((g) => ({ ...g, avant: t1(g.cle).avant, apres: t1(g.cle).apres }));
  const C25 = { gagnant: A.gagnants, perdant: A.perdants, abstention: A.abstention };
  const P25 = GROUPES.map((g) => ({ ...g, avant: C25[g.cle].avant, apres: C25[g.cle].apres }));
  const MIN = 0.4, MAX = 0.8, Y0 = 380, H = 300;
  const py = (v) => Y0 - ((v - MIN) / (MAX - MIN)) * H;
  const PANNEAUX = [{ x: 110, an: '1997', pts: P97, vu: 0, noms: false }, { x: 570, an: '2025', pts: P25, vu: 1, noms: true }];
  const L = 240;
  // Les étiquettes trop proches s'écartent (24 px au moins), les points restent en place.
  const ecarter = (ys, gap = 24) => {
    const o = ys.map((y, i) => ({ y, i })).sort((a, b) => a.y - b.y);
    for (let k = 1; k < o.length; k++) if (o[k].y - o[k - 1].y < gap) o[k].y = o[k - 1].y + gap;
    const r = []; o.forEach((v) => (r[v.i] = v.y)); return r;
  };
  for (const pn of PANNEAUX) {
    const ga = ecarter(pn.pts.map((p) => py(p.avant))), dr = ecarter(pn.pts.map((p) => py(p.apres)));
    pn.pts.forEach((p, i) => { p.ya = ga[i]; p.yp = dr[i]; });
  }
</script>

<div class="visuel m8aa" bind:this={hote}>
  <svg viewBox="0 0 1000 450" role="img" aria-label="Satisfaction envers la démocratie avant et après l'élection. 1997 : gagnants de {f(P97[0].avant)} à {f(P97[0].apres)}, perdants de {f(P97[1].avant)} à {f(P97[1].apres)}, abstention de {f(P97[2].avant)} à {f(P97[2].apres)}. 2025 : gagnants de {f(P25[0].avant)} à {f(P25[0].apres)}, perdants de {f(P25[1].avant)} à {f(P25[1].apres)}, abstention de {f(P25[2].avant)} à {f(P25[2].apres)}.">
    {#each PANNEAUX as pn}
      <g class="etape" class:vu={e >= pn.vu}>
        <text x={pn.x + L / 2} y="34" class="an">{pn.an}</text>
        <line x1={pn.x} y1={py(MIN)} x2={pn.x} y2={py(MAX)} class="axe" />
        <line x1={pn.x + L} y1={py(MIN)} x2={pn.x + L} y2={py(MAX)} class="axe" />
        <text x={pn.x} y={Y0 + 32} class="moment">avant</text>
        <text x={pn.x + L} y={Y0 + 32} class="moment">après</text>
        {#each pn.pts as p}
          <line x1={pn.x} y1={py(p.avant)} x2={pn.x + L} y2={py(p.apres)} class="ligne {p.classe}" />
          <circle cx={pn.x} cy={py(p.avant)} r="7" class="pt {p.classe}" />
          <circle cx={pn.x + L} cy={py(p.apres)} r="7" class="pt {p.classe}" />
          <text x={pn.x - 12} y={p.ya + 6} class="val gauche {p.classe}">{f(p.avant)}</text>
          <text x={pn.x + L + 12} y={p.yp + 6} class="val {p.classe}">{f(p.apres)}{pn.noms ? ` ${p.nom}` : ''}</text>
        {/each}
      </g>
    {/each}
    <text x="0" y="444" class="source">1997 : Blais et Gélineau (2007), tableau 1 · 2025 : CES, mêmes personnes avant et après · satisfaction de 0 à 1</text>
  </svg>
  <p class="verdict" class:vu={e >= 2}>L’écart entre gagnants et perdants se creuse toujours. <strong>La lune de miel pour tout le monde, non.</strong></p>
</div>

<style>
  .m8aa { max-width: 64em; margin: 0 auto; display: flex; flex-direction: column; gap: 0.6em; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .an { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .axe { stroke: var(--dk-filet); stroke-width: 2; }
  .moment { font-size: 18px; fill: var(--dk-gris); text-anchor: middle; }
  .ligne { stroke-width: 5; fill: none; }
  .ligne.g, .pt.g { stroke: var(--dk-accent); fill: var(--dk-accent); }
  .ligne.p, .pt.p { stroke: var(--dk-encre); fill: var(--dk-encre); }
  .ligne.a, .pt.a { stroke: var(--dk-gris-2); fill: var(--dk-gris-2); }
  .ligne.a { stroke-dasharray: 8 6; }
  .val { font-size: 18px; font-weight: 600; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; }
  .val.gauche { text-anchor: end; }
  .val.g { fill: var(--dk-accent); }
  .val.p { fill: var(--dk-encre); }
  .val.a { fill: var(--dk-gris); }
  .source { font-size: 14px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  .verdict { margin: 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.2em; opacity: 0; transition: opacity 0.4s; }
  .verdict.vu { opacity: 1; }
  .verdict strong { color: var(--dk-accent-clair); }
  @media (prefers-reduced-motion: reduce) { .etape, .verdict { transition: none; } }
</style>
