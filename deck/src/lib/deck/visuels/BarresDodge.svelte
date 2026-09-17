<script>
  /**
   * Une seule table, sept graphiques : l'intention de vote selon le groupe d'âge
   * (Étude électorale canadienne 2025, src/lib/data/seance3_barres.js, généré par
   * outils/seance3_barres.R). Les dix-huit barres sont les mêmes d'un bout à
   * l'autre : à chaque clic une seule chose change (l'axe, le dénominateur, les
   * voisines ou la ligne de base), et l'histoire change avec elle. La question
   * qui tient le tout : un pourcentage de quoi ? Rien n'est écrit sous le
   * graphique : l'enseignant parle. Sept carrés numérotés disent où l'on est, la
   * légende et l'axe disent le reste ; la morale est la seule phrase. Le code de
   * chaque vue (BARRES.vues, exécuté par le générateur) reste dans les données,
   * pour l'aide-mémoire et le script étudiant. L'état de repos de chaque temps
   * ne dépend que de e : on peut reculer.
   *
   *   0  Effectifs : x = groupe d'âge, une couleur par parti.
   *   1  % du total : les barres ne bougent pas, seul l'axe change.
   *   2  % du groupe d'âge : chaque groupe fait 100 % ; le contraste du NPD
   *      (18-34 contre 55 et plus) s'affiche.
   *   3  On inverse : x = parti, un gris par groupe d'âge. Mêmes pourcentages,
   *      nouvelles voisines.
   *   4  % du parti : chaque parti fait 100 %.
   *   5  Écart à l'ensemble, par groupe d'âge : % du groupe moins la part du parti
   *      dans l'ensemble de l'échantillon. Ligne de zéro, points de pourcentage.
   *   6  Écart à l'ensemble, par parti : % du parti moins la part du groupe d'âge
   *      dans l'ensemble. Même axe que la vue 5 : les barres grandissent pour vrai.
   *   7  La morale, en rouge.
   */
  import { brancherTemps } from '../temps.js';
  import { BARRES } from '$lib/data/seance3_barres.js';

  const NV = 7;
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: NV, lire: () => e, ecrire: (v) => (e = v) });
  });
  const vue = $derived(Math.min(e, NV - 1));

  // Les couleurs de la diapositive « le mode » (PourquoiMode.svelte).
  const COUL = { 'Libéral': '#d71920', 'Conservateur': '#1a4782', 'NPD': '#f37021', 'Bloc Québécois': '#33b2cc', 'Vert': '#3d9b35', 'Autre': '#8b918f' };
  // Les groupes d'âge : une échelle de gris, du plus jeune (clair) au plus âgé (encre).
  const GRIS = ['#b4b8b5', '#6f7679', '#0c0e0f'];
  const PARTIS = BARRES.partis;
  const GROUPES = BARRES.groupes;
  const NG = GROUPES.length, NP = PARTIS.length;
  const NOMS_VUES = ['effectifs', '% du total', '% du groupe d’âge', 'on inverse', '% du parti', 'écart, par groupe d’âge', 'écart, par parti'];
  const TITRES_Y = ['effectif', '% du total', '% du groupe d’âge', '% du groupe d’âge', '% du parti', 'points de %', 'points de %'];
  // À partir de la vue 3, x = parti ; à partir de la vue 5, on part de zéro.
  const parParti = (v) => v >= 3;
  const enEcart = (v) => v >= 5;

  // Le contraste de la vue 2 : plus grand rapport entre la part chez les plus
  // jeunes et chez les plus âgés, parmi les partis nommés.
  const rapport = (k) => {
    const a = GROUPES[0].pourcentages[k], b = GROUPES[NG - 1].pourcentages[k];
    return Math.max(a, b) / Math.min(a, b);
  };
  const K = PARTIS.map((p, k) => k).filter((k) => PARTIS[k] !== 'Autre').sort((a, b) => rapport(b) - rapport(a))[0];

  const W = 1000, H = 368, X0 = 96, X1 = 996, HAUT = 52, BAS = 304, PH = BAS - HAUT, ZERO = (HAUT + BAS) / 2;
  const PITCH = 40, LB = 38;
  const LG_G = (X1 - X0) / NG, LG_P = (X1 - X0) / NP;
  const M_G = (LG_G - PITCH * NP) / 2, M_P = (LG_P - PITCH * NG) / 2;

  // Effectifs : graduations rondes calculées sur le maximum.
  const MAXI = Math.max(...GROUPES.flatMap((g) => g.effectifs));
  const puissance = 10 ** Math.floor(Math.log10(MAXI));
  const PAS = MAXI / puissance < 3 ? puissance / 2 : puissance;
  const yEff = (n) => BAS - (n / (MAXI * 1.03)) * PH;
  // % du total : le même dessin, donc la même échelle, graduée en pourcentages.
  const TOT_MAX = Math.floor((100 * MAXI) / BARRES.n / 5) * 5;
  const PCT_MAX = 60;
  // Écarts : UNE échelle symétrique pour les vues 5 et 6, en multiples de 4 points.
  const LIM = Math.ceil(Math.max(...GROUPES.flatMap((g) => [...g.ecarts, ...g.ecartsParti].map(Math.abs))) / 4) * 4;

  const entier = (n) => n.toLocaleString('fr-CA').replace(/\s/g, '\u202f');
  const pct = (p) => p.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + '\u202f%';
  const signe = (v) => (v > 0 ? '+' + v : v < 0 ? '−' + -v : '0');

  const ECHELLES = [
    { vues: [0], ticks: Array.from({ length: Math.floor(MAXI / PAS) + 1 }, (_, i) => i * PAS).map((t) => ({ y: yEff(t), t: entier(t) })) },
    { vues: [1], ticks: Array.from({ length: TOT_MAX / 5 + 1 }, (_, i) => i * 5).map((t) => ({ y: yEff((t / 100) * BARRES.n), t: t + '\u202f%' })) },
    { vues: [2, 3, 4], ticks: [0, 20, 40, 60].map((t) => ({ y: BAS - (t / PCT_MAX) * PH, t: t + '\u202f%' })) },
    { vues: [5, 6], ticks: [-LIM, -LIM / 2, 0, LIM / 2, LIM].map((t) => ({ y: ZERO - (t / LIM) * (PH / 2), t: signe(t) })) }
  ];
  // Un titre d'axe par libellé distinct : il ne clignote pas quand il ne change pas.
  const TITRES = [...new Set(TITRES_Y)].map((t) => ({ t, vues: TITRES_Y.flatMap((x, v) => (x === t ? [v] : [])) }));

  // La hauteur (vers le haut) de la barre (g, k) dans chaque vue, et sa place. En
  // % du total la hauteur est celle de l'effectif : n et 100 * n / N dessinent la
  // même chose (le générateur le vérifie).
  const hauteur = (g, k, v) => v <= 1 ? (GROUPES[g].effectifs[k] / (MAXI * 1.03)) * PH
    : v <= 3 ? (GROUPES[g].pourcentages[k] / PCT_MAX) * PH
    : v === 4 ? (GROUPES[g].pctParti[k] / PCT_MAX) * PH
    : ((v === 5 ? GROUPES[g].ecarts[k] : GROUPES[g].ecartsParti[k]) / LIM) * (PH / 2);
  const bx = (g, k, v) => parParti(v) ? X0 + k * LG_P + M_P + g * PITCH : X0 + g * LG_G + M_G + k * PITCH;
  const BARS = GROUPES.flatMap((gr, g) => PARTIS.map((p, k) => ({
    g, k, i: g * NP + k,
    poses: Array.from({ length: NV }, (_, v) => `translate(${bx(g, k, v)}px, ${enEcart(v) ? ZERO : BAS}px) scale(1, ${(-hauteur(g, k, v)).toFixed(3)})`)
  })));

  // Les légendes, sur une ligne : IBM Plex Mono, 0,6 em par caractère.
  const CAR = 24 * 0.6, CARRE = 24, ECART = 26;
  const legende = (noms) => {
    const l = noms.map((n) => CARRE + 8 + n.length * CAR);
    const total = l.reduce((s, x) => s + x, 0) + ECART * (noms.length - 1);
    return noms.map((nom, j) => ({ nom, x: (W - total) / 2 + l.slice(0, j).reduce((s, x) => s + x + ECART, 0) }));
  };
  const LEGENDES = [
    { vues: [0, 1, 2], items: legende(PARTIS).map((l) => ({ ...l, c: COUL[l.nom] })) },
    { vues: [3, 4, 5], items: legende(GROUPES.map((g) => g.nom)).map((l, j) => ({ ...l, c: GRIS[j] })) },
    // Vue 6 : la référence appartient aux groupes d'âge, la légende la porte.
    { vues: [6], items: legende(GROUPES.map((g) => `${g.nom} (${pct(g.part)})`)).map((l, j) => ({ ...l, c: GRIS[j] })) }
  ];

  // Le contraste (vue 2) : deux étiquettes posées au-dessus des barres courtes, à
  // droite de la barre du parti, là où le graphique est vide.
  const ETIQ_H = 64;
  const yPct = (p) => BAS - (p / PCT_MAX) * PH;
  const ETIQS = [0, NG - 1].map((g) => ({
    g, x: bx(g, K, 2), cx: bx(g, K, 2) + LB / 2,
    bas: yPct(Math.max(...GROUPES[g].pourcentages.slice(K))) - 16,
    sommet: yPct(GROUPES[g].pourcentages[K]),
    l: PITCH * (NP - K) + 24
  }));

  const ARIA = `Dix-huit barres, sept graphiques de la même table : l’intention de vote selon le groupe d’âge, Étude électorale canadienne 2025. `
    + `Effectifs, pourcentage du total, pourcentage du groupe d’âge, les mêmes regroupés par parti, pourcentage du parti, puis deux écarts à l’ensemble de l’échantillon. `
    + GROUPES.map((g) => `${g.nom}, ${pct(g.part)} de l’échantillon : ` + PARTIS.map((p, k) => `${p} ${entier(g.effectifs[k])}, soit ${pct(g.pourcentages[k])} du groupe et ${pct(g.pctParti[k])} du parti`).join(' ; ')).join('. ')
    + `. Ensemble de l’échantillon : ` + PARTIS.map((p, k) => `${p} ${pct(BARRES.ensemble[k])}`).join(', ') + '.';
</script>

<div class="visuel bd-fig" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label={ARIA}>
    <!-- La légende suit fill : les partis, puis les groupes d'âge. -->
    {#each LEGENDES as leg}
      <g class="bd-fondu" class:bd-vu={leg.vues.includes(vue)}>
        {#each leg.items as l}
          <rect x={l.x} y="2" width={CARRE} height={CARRE} fill={l.c} />
          <text x={l.x + CARRE + 8} y="22" class="bd-leg-t">{l.nom}</text>
        {/each}
      </g>
    {/each}

    <!-- L'axe vertical : effectifs, pourcentages, ou points autour de zéro. -->
    {#each ECHELLES as ech}
      <g class="bd-fondu" class:bd-vu={ech.vues.includes(vue)}>
        {#each ech.ticks as t}
          <path d="M {X0} {t.y} L {X1} {t.y}" class="bd-grille" />
          <text x={X0 - 10} y={t.y + 6} class="bd-tick">{t.t}</text>
        {/each}
      </g>
    {/each}
    {#each TITRES as ti}
      <text x="18" y={ZERO} class="bd-axe-t bd-fondu" class:bd-vu={ti.vues.includes(vue)} transform="rotate(-90 18 {ZERO})">{ti.t}</text>
    {/each}

    {#each BARS as b (b.i)}
      <rect x="0" y="0" width={LB} height="1" class="bd-barre" style:transform={b.poses[vue]} style:fill={parParti(vue) ? GRIS[b.g] : COUL[PARTIS[b.k]]} style:--i={b.i} />
    {/each}

    <path d="M {X0} {HAUT - 8} L {X0} {BAS}" class="bd-axe" />
    <path d="M {X0} 0 L {X1} 0" class="bd-axe bd-base" style:transform="translateY({enEcart(vue) ? ZERO : BAS}px)" />

    <!-- L'axe horizontal : les groupes d'âge, puis les partis. -->
    <g class="bd-fondu" class:bd-vu={!parParti(vue)}>
      {#each GROUPES as g, i}
        <text x={X0 + i * LG_G + LG_G / 2} y={BAS + 32} class="bd-cat">{g.nom}</text>
        <text x={X0 + i * LG_G + LG_G / 2} y={BAS + 58} class="bd-n">n = {entier(g.total)}</text>
      {/each}
    </g>
    <g class="bd-fondu" class:bd-vu={parParti(vue)}>
      {#each PARTIS as p, k}
        <text x={X0 + k * LG_P + LG_P / 2} y={BAS + 32} class="bd-cat bd-cat-p">{p}</text>
      {/each}
    </g>
    <!-- Vue 4 : chaque parti fait 100 %, de combien de personnes. -->
    <g class="bd-fondu" class:bd-vu={vue === 4}>
      {#each BARRES.totauxPartis as n, k}
        <text x={X0 + k * LG_P + LG_P / 2} y={BAS + 58} class="bd-n">n = {entier(n)}</text>
      {/each}
    </g>
    <!-- Vue 5 : ce que vaut le zéro, parti par parti. -->
    <g class="bd-fondu" class:bd-vu={vue === 5}>
      <text x={X1} y={HAUT + 14} class="bd-zero">0 = la part du parti dans l’ensemble de l’échantillon</text>
      <text x={X0 - 10} y={BAS + 58} class="bd-n bd-n-fin">ensemble</text>
      {#each PARTIS as p, k}
        <text x={X0 + k * LG_P + LG_P / 2} y={BAS + 58} class="bd-n">{pct(BARRES.ensemble[k])}</text>
      {/each}
    </g>
    <!-- Vue 6 : le zéro appartient aux groupes d'âge (leurs parts sont dans la légende). -->
    <text x={X1} y={HAUT + 14} class="bd-zero bd-fondu" class:bd-vu={vue === 6}>0 = la part du groupe d’âge dans l’ensemble de l’échantillon</text>

    <!-- Vue 2 : le contraste que seul ce dénominateur rend visible. -->
    {#if e === 2}
      {#each ETIQS as q}
        <g class="bd-etiq">
          <path d="M {q.cx} {q.sommet - 4} L {q.cx} {q.bas}" class="bd-trait" />
          <rect x={q.x} y={q.bas - ETIQ_H} width={q.l} height={ETIQ_H} class="bd-cadre" />
          <text x={q.x + 12} y={q.bas - ETIQ_H + 30} class="bd-pct">{pct(GROUPES[q.g].pourcentages[K])} {PARTIS[K]}</text>
          <text x={q.x + 12} y={q.bas - 10} class="bd-de">des {GROUPES[q.g].nom}</text>
        </g>
      {/each}
    {/if}
  </svg>

  <!-- Sous le graphique, une seule ligne : où l'on est (sept carrés numérotés,
       seul celui de la vue courante déplie son nom) et, au dernier clic, la morale.
       Sa place est réservée dès l'arrivée : rien ne saute. -->
  <div class="bd-bas">
    <ol class="bd-vues">
      {#each NOMS_VUES as nom, v}
        <li class:bd-ici={vue === v || e >= NV}><span class="bd-no">{v + 1}</span>{#if vue === v && e < NV}<span class="bd-nom">{nom}</span>{/if}</li>
      {/each}
    </ol>
    <p class="bd-morale bd-fondu" class:bd-vu={e >= NV}>Une seule table, sept graphiques.<br />Toujours demander&#8239;: un pourcentage de quoi&#8239;?</p>
  </div>
  <p class="bd-source">Étude électorale canadienne 2025 · intentions de vote, sans les «&#8239;ne sait pas&#8239;»</p>
</div>

<style>
  .bd-fig { display: flex; flex-direction: column; gap: 0.5em; flex: 1 1 auto; min-height: 0; }
  svg { flex: 0 1 auto; min-height: 0; max-height: 62vh; width: 100%; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  /* Tout ce qui change avec la vue se fond : on sort vite, on entre ensuite. */
  .bd-fondu { opacity: 0; visibility: hidden; transition: opacity 0.25s, visibility 0s 0.25s; }
  .bd-fondu.bd-vu { opacity: 1; visibility: visible; transition: opacity 0.45s 0.25s, visibility 0s 0.25s; }

  .bd-leg-t { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .bd-grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .bd-axe { stroke: var(--dk-encre); stroke-width: 3; fill: none; }
  .bd-base { transition: transform 0.9s cubic-bezier(0.65, 0, 0.35, 1); }
  .bd-tick { font-size: 20px; text-anchor: end; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .bd-axe-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .bd-cat { font-size: 25px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  /* Six noms de partis dans la largeur : un cran plus petit que les trois groupes. */
  .bd-cat-p { font-size: 22px; }
  .bd-n { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .bd-n-fin { font-size: 18px; text-anchor: end; font-weight: 600; }
  .bd-zero { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }

  /* Une barre : un rectangle de hauteur 1, posé et étiré par transform. C'est
     transform qui bouge d'une vue à l'autre, donc la même barre voyage. */
  .bd-barre {
    transition: transform 0.9s cubic-bezier(0.65, 0, 0.35, 1), fill 0.6s;
    transition-delay: calc(var(--i) * 14ms);
  }

  .bd-etiq { animation: bd-arrive 0.4s 0.8s backwards; }
  .bd-trait { stroke: var(--dk-accent); stroke-width: 3; fill: none; }
  .bd-cadre { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3; }
  .bd-pct { font-size: 26px; font-weight: 600; fill: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .bd-de { font-size: 18px; font-weight: 600; fill: var(--dk-encre); }

  .bd-bas { flex: none; display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 1.4em; align-items: center; }
  .bd-vues { list-style: none; margin: 0; padding: 0; display: flex; flex-wrap: nowrap; gap: 0.35em; }
  .bd-vues li {
    margin: 0;
    display: flex;
    align-items: center;
    font-size: 0.8em;
    font-weight: 600;
    line-height: 1.7;
    letter-spacing: 0.03em;
    white-space: nowrap;
    color: var(--dk-gris-2);
  }
  .bd-no {
    box-sizing: border-box;
    width: 1.9em;
    text-align: center;
    border: 2px solid var(--dk-gris-2);
    transition: color 0.3s, background-color 0.3s, border-color 0.3s;
  }
  .bd-ici .bd-no { color: var(--dk-fond); background: var(--dk-encre); border-color: var(--dk-encre); }
  .bd-nom { margin: 0 0.6em 0 0.55em; color: var(--dk-encre); border-bottom: 3px solid var(--dk-accent); line-height: 1.4; }
  .bd-morale { margin: 0; font-size: 1.05em; font-weight: 600; line-height: 1.25; color: var(--dk-accent); }
  .bd-source { flex: none; margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes bd-arrive { from { opacity: 0; } }

  @media (prefers-reduced-motion: reduce) {
    .bd-fondu, .bd-barre, .bd-base, .bd-etiq, .bd-no { animation: none !important; transition: none !important; }
  }
</style>
