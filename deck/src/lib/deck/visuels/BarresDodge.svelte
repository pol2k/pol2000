<script>
  /**
   * Une seule table, quatre histoires : l'intention de vote selon le groupe d'âge
   * (Étude électorale canadienne 2025, src/lib/data/seance3_barres.js, généré par
   * outils/seance3_barres.R). Les dix-huit barres sont les mêmes d'un bout à
   * l'autre : à chaque clic elles changent d'échelle, de voisines ou de ligne de
   * base, et l'histoire que raconte le graphique change avec elles. Le code de
   * chaque vue vient du générateur, qui l'a exécuté ; ce qui a changé depuis la
   * vue précédente est en rouge. L'état de repos de chaque temps ne dépend que
   * de e : on peut reculer.
   *
   *   0  Effectifs : x = groupe d'âge, une couleur par parti.
   *   1  Pourcentages dans chaque groupe d'âge : les barres changent d'échelle ;
   *      le contraste du NPD (18-34 contre 55 et plus) s'affiche.
   *   2  On inverse : x = parti, un gris par groupe d'âge. Mêmes pourcentages,
   *      nouvelles voisines.
   *   3  L'écart à l'ensemble de l'échantillon, en points de pourcentage : les
   *      barres partent d'une ligne de zéro, vers le haut ou vers le bas.
   *   4  La morale, en rouge.
   */
  import { brancherTemps } from '../temps.js';
  import { BARRES } from '$lib/data/seance3_barres.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
  const vue = $derived(Math.min(e, 3));

  // Les couleurs de la diapositive « le mode » (PourquoiMode.svelte).
  const COUL = { 'Libéral': '#d71920', 'Conservateur': '#1a4782', 'NPD': '#f37021', 'Bloc Québécois': '#33b2cc', 'Vert': '#3d9b35', 'Autre': '#8b918f' };
  // Les groupes d'âge : une échelle de gris, du plus jeune (clair) au plus âgé (encre).
  const GRIS = ['#b4b8b5', '#6f7679', '#0c0e0f'];
  const PARTIS = BARRES.partis;
  const GROUPES = BARRES.groupes;
  const NG = GROUPES.length, NP = PARTIS.length;
  const NOMS_VUES = ['effectifs', 'pourcentages', 'on inverse', 'écart à l’ensemble'];

  // Le contraste de la vue en pourcentages : plus grand rapport entre la part chez
  // les plus jeunes et chez les plus âgés, parmi les partis nommés.
  const rapport = (k) => {
    const a = GROUPES[0].pourcentages[k], b = GROUPES[NG - 1].pourcentages[k];
    return Math.max(a, b) / Math.min(a, b);
  };
  const K = PARTIS.map((p, k) => k).filter((k) => PARTIS[k] !== 'Autre').sort((a, b) => rapport(b) - rapport(a))[0];

  const W = 1000, H = 324, X0 = 96, X1 = 996, HAUT = 50, BAS = 262, PH = BAS - HAUT, ZERO = (HAUT + BAS) / 2;
  const PITCH = 40, LB = 38;
  const LG_G = (X1 - X0) / NG, LG_P = (X1 - X0) / NP;
  const M_G = (LG_G - PITCH * NP) / 2, M_P = (LG_P - PITCH * NG) / 2;

  // Trois échelles. Effectifs : graduations rondes calculées sur le maximum.
  const MAXI = Math.max(...GROUPES.flatMap((g) => g.effectifs));
  const puissance = 10 ** Math.floor(Math.log10(MAXI));
  const PAS = MAXI / puissance < 3 ? puissance / 2 : puissance;
  const PCT_MAX = 60;
  // Écarts : une échelle symétrique autour de zéro, en multiples de 4 points.
  const LIM = Math.ceil(Math.max(...GROUPES.flatMap((g) => g.ecarts.map(Math.abs))) / 4) * 4;

  const entier = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const pct = (p) => p.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + ' %';
  const signe = (v) => (v > 0 ? '+' + v : v < 0 ? '−' + -v : '0');

  const ECHELLES = [
    { vues: [0], titre: 'effectif', ticks: Array.from({ length: Math.floor(MAXI / PAS) + 1 }, (_, i) => i * PAS).map((t) => ({ y: BAS - (t / (MAXI * 1.03)) * PH, t: entier(t) })) },
    { vues: [1, 2], titre: '% du groupe d’âge', ticks: [0, 20, 40, 60].map((t) => ({ y: BAS - (t / PCT_MAX) * PH, t: t + ' %' })) },
    { vues: [3], titre: 'points de %', ticks: [-LIM, -LIM / 2, 0, LIM / 2, LIM].map((t) => ({ y: ZERO - (t / LIM) * (PH / 2), t: signe(t) })) }
  ];

  // La hauteur (vers le haut) de la barre (g, k) dans chaque vue, et sa place.
  const hauteur = (g, k, v) => v === 0 ? (GROUPES[g].effectifs[k] / (MAXI * 1.03)) * PH
    : v === 3 ? (GROUPES[g].ecarts[k] / LIM) * (PH / 2)
    : (GROUPES[g].pourcentages[k] / PCT_MAX) * PH;
  const bx = (g, k, v) => v < 2 ? X0 + g * LG_G + M_G + k * PITCH : X0 + k * LG_P + M_P + g * PITCH;
  const BARS = GROUPES.flatMap((gr, g) => PARTIS.map((p, k) => ({
    g, k, i: g * NP + k,
    poses: [0, 1, 2, 3].map((v) => `translate(${bx(g, k, v)}px, ${v === 3 ? ZERO : BAS}px) scale(1, ${(-hauteur(g, k, v)).toFixed(3)})`)
  })));

  // Les deux légendes, sur une ligne : IBM Plex Mono, 0,6 em par caractère.
  const CAR = 22 * 0.6, CARRE = 22, ECART = 26;
  const legende = (noms) => {
    const l = noms.map((n) => CARRE + 8 + n.length * CAR);
    const total = l.reduce((s, x) => s + x, 0) + ECART * (noms.length - 1);
    return noms.map((nom, j) => ({ nom, x: (W - total) / 2 + l.slice(0, j).reduce((s, x) => s + x + ECART, 0) }));
  };
  const LEG_PARTIS = legende(PARTIS);
  const LEG_AGES = legende(GROUPES.map((g) => g.nom));

  // Le contraste (vue 1) : deux étiquettes posées au-dessus des barres courtes, à
  // droite de la barre du parti, là où le graphique est vide.
  const ETIQ_H = 60;
  const yPct = (p) => BAS - (p / PCT_MAX) * PH;
  const ETIQS = [0, NG - 1].map((g) => ({
    g, x: bx(g, K, 1), cx: bx(g, K, 1) + LB / 2,
    bas: yPct(Math.max(...GROUPES[g].pourcentages.slice(K))) - 16,
    sommet: yPct(GROUPES[g].pourcentages[K]),
    l: PITCH * (NP - K) + 20
  }));

  // Le code de chaque vue, découpé autour des morceaux qui ont changé.
  const echappe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const CODES = BARRES.vues.map((v) => v.code.split(new RegExp('(' + v.forts.map(echappe).join('|') + ')')).map((t) => ({ t, fort: v.forts.includes(t) })));

  const ARIA = `Dix-huit barres, quatre vues de la même table : l’intention de vote selon le groupe d’âge, Étude électorale canadienne 2025. `
    + `En effectifs, puis en pourcentages dans chaque groupe d’âge, puis regroupées par parti, puis en écart à l’ensemble de l’échantillon. `
    + GROUPES.map((g) => `${g.nom} : ` + PARTIS.map((p, k) => `${p} ${entier(g.effectifs[k])}, soit ${pct(g.pourcentages[k])}, écart ${signe(g.ecarts[k])}`).join(' ; ')).join('. ')
    + `. Ensemble de l’échantillon : ` + PARTIS.map((p, k) => `${p} ${pct(BARRES.ensemble[k])}`).join(', ') + '.';
</script>

<div class="visuel bd-fig" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label={ARIA}>
    <!-- La légende suit fill : les partis, puis les groupes d'âge. -->
    <g class="bd-fondu" class:bd-vu={vue < 2}>
      {#each LEG_PARTIS as l}
        <rect x={l.x} y="4" width={CARRE} height={CARRE} fill={COUL[l.nom]} />
        <text x={l.x + CARRE + 8} y="23" class="bd-leg-t">{l.nom}</text>
      {/each}
    </g>
    <g class="bd-fondu" class:bd-vu={vue >= 2}>
      {#each LEG_AGES as l, j}
        <rect x={l.x} y="4" width={CARRE} height={CARRE} fill={GRIS[j]} />
        <text x={l.x + CARRE + 8} y="23" class="bd-leg-t">{l.nom}</text>
      {/each}
    </g>

    <!-- L'axe vertical : effectifs, pourcentages, ou points autour de zéro. -->
    {#each ECHELLES as ech}
      <g class="bd-fondu" class:bd-vu={ech.vues.includes(vue)}>
        {#each ech.ticks as t}
          <path d="M {X0} {t.y} L {X1} {t.y}" class="bd-grille" />
          <text x={X0 - 10} y={t.y + 6} class="bd-tick">{t.t}</text>
        {/each}
        <text x="18" y={ZERO} class="bd-axe-t" transform="rotate(-90 18 {ZERO})">{ech.titre}</text>
      </g>
    {/each}

    {#each BARS as b (b.i)}
      <rect x="0" y="0" width={LB} height="1" class="bd-barre" style:transform={b.poses[vue]} style:fill={vue < 2 ? COUL[PARTIS[b.k]] : GRIS[b.g]} style:--i={b.i} />
    {/each}

    <path d="M {X0} {HAUT - 8} L {X0} {BAS}" class="bd-axe" />
    <path d="M {X0} 0 L {X1} 0" class="bd-axe bd-base" style:transform="translateY({vue === 3 ? ZERO : BAS}px)" />

    <!-- L'axe horizontal : les groupes d'âge, puis les partis. -->
    <g class="bd-fondu" class:bd-vu={vue < 2}>
      {#each GROUPES as g, i}
        <text x={X0 + i * LG_G + LG_G / 2} y={BAS + 30} class="bd-cat">{g.nom}</text>
        <text x={X0 + i * LG_G + LG_G / 2} y={BAS + 53} class="bd-n">n = {entier(g.total)}</text>
      {/each}
    </g>
    <g class="bd-fondu" class:bd-vu={vue >= 2}>
      {#each PARTIS as p, k}
        <text x={X0 + k * LG_P + LG_P / 2} y={BAS + 30} class="bd-cat">{p}</text>
      {/each}
    </g>
    <!-- Vue 3 : ce que vaut le zéro, parti par parti. -->
    <g class="bd-fondu" class:bd-vu={vue === 3}>
      <text x={X1} y={HAUT + 14} class="bd-zero">0 = la part du parti dans l’ensemble de l’échantillon</text>
      <text x={X0 - 10} y={BAS + 53} class="bd-n bd-n-fin">ensemble</text>
      {#each PARTIS as p, k}
        <text x={X0 + k * LG_P + LG_P / 2} y={BAS + 53} class="bd-n">{pct(BARRES.ensemble[k])}</text>
      {/each}
    </g>

    <!-- Vue 1 : le contraste que seuls les pourcentages rendent visible. -->
    {#if e === 1}
      {#each ETIQS as q}
        <g class="bd-etiq">
          <path d="M {q.cx} {q.sommet - 4} L {q.cx} {q.bas}" class="bd-trait" />
          <rect x={q.x} y={q.bas - ETIQ_H} width={q.l} height={ETIQ_H} class="bd-cadre" />
          <text x={q.x + 12} y={q.bas - ETIQ_H + 28} class="bd-pct">{pct(GROUPES[q.g].pourcentages[K])} {PARTIS[K]}</text>
          <text x={q.x + 12} y={q.bas - 10} class="bd-de">des {GROUPES[q.g].nom}</text>
        </g>
      {/each}
    {/if}
  </svg>

  <!-- Codes et lectures sont empilés dans une même case : la place du plus grand
       est réservée dès l'arrivée, rien ne saute. -->
  <div class="bd-bas">
    <div class="bd-pile bd-codes">
      {#each CODES as morceaux, v}
        <pre class="bd-code bd-fondu" class:bd-vu={vue === v}>{#each morceaux as m}{#if m.fort}<span class="bd-fort">{m.t}</span>{:else}{m.t}{/if}{/each}</pre>
      {/each}
    </div>
    <div class="bd-dit">
      <ol class="bd-vues">
        {#each NOMS_VUES as nom, v}
          <li class:bd-ici={vue === v && e < 4} class:bd-toutes={e >= 4}>{v + 1} {nom}</li>
        {/each}
      </ol>
      <div class="bd-pile">
        <p class="bd-lecture bd-fondu" class:bd-vu={vue === 0}><b>En effectifs</b>&#8239;: les 55 ans et plus dominent tout, parce qu’ils sont plus nombreux dans l’échantillon.</p>
        <p class="bd-lecture bd-fondu" class:bd-vu={vue === 1}><b>En pourcentages</b>&#8239;: les groupes deviennent comparables.</p>
        <p class="bd-lecture bd-fondu" class:bd-vu={vue === 2}><b>Mêmes chiffres, regroupés par parti</b>&#8239;: on compare maintenant les âges entre eux.</p>
        <p class="bd-lecture bd-fondu" class:bd-vu={vue === 3}><b>Par rapport à l’ensemble</b>&#8239;: qui vote plus, ou moins, que tout le monde pour ce parti.</p>
      </div>
      <p class="bd-morale bd-fondu" class:bd-vu={e >= 4}>Une seule table, quatre histoires.<br />Le graphique est un choix.</p>
    </div>
  </div>
  <p class="bd-source">Étude électorale canadienne 2025 · intentions de vote, sans les «&#8239;ne sait pas&#8239;»</p>
</div>

<style>
  .bd-fig { display: flex; flex-direction: column; gap: 0.5em; flex: 1 1 auto; min-height: 0; }
  svg { flex: 0 1 auto; min-height: 0; max-height: 50vh; width: 100%; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  /* Tout ce qui change avec la vue se fond : on sort vite, on entre ensuite. */
  .bd-fondu { opacity: 0; visibility: hidden; transition: opacity 0.25s, visibility 0s 0.25s; }
  .bd-fondu.bd-vu { opacity: 1; visibility: visible; transition: opacity 0.45s 0.25s, visibility 0s 0.25s; }

  .bd-leg-t { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .bd-grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .bd-axe { stroke: var(--dk-encre); stroke-width: 3; fill: none; }
  .bd-base { transition: transform 0.9s cubic-bezier(0.65, 0, 0.35, 1); }
  .bd-tick { font-size: 18px; text-anchor: end; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .bd-axe-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .bd-cat { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .bd-n { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .bd-n-fin { text-anchor: end; font-weight: 600; }
  .bd-zero { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }

  /* Une barre : un rectangle de hauteur 1, posé et étiré par transform. C'est
     transform qui bouge d'une vue à l'autre, donc la même barre voyage. */
  .bd-barre {
    transition: transform 0.9s cubic-bezier(0.65, 0, 0.35, 1), fill 0.6s;
    transition-delay: calc(var(--i) * 14ms);
  }

  .bd-etiq { animation: bd-arrive 0.4s 0.8s backwards; }
  .bd-trait { stroke: var(--dk-accent); stroke-width: 3; fill: none; }
  .bd-cadre { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3; }
  .bd-pct { font-size: 24px; font-weight: 600; fill: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .bd-de { font-size: 18px; font-weight: 600; fill: var(--dk-encre); }

  .bd-bas { flex: none; display: grid; grid-template-columns: auto minmax(0, 1fr); gap: 1.4em; align-items: start; }
  .bd-pile { display: grid; }
  .bd-pile > * { grid-area: 1 / 1; }
  .bd-codes { border: 3px solid var(--dk-encre); padding: 0.3em 0.7em; }
  .bd-code {
    margin: 0;
    font-family: var(--dk-mono);
    font-size: 0.7em;
    line-height: 1.45;
    white-space: pre;
    color: var(--dk-encre);
  }
  .bd-fort { color: var(--dk-accent); font-weight: 600; }

  .bd-dit { display: flex; flex-direction: column; gap: 0.45em; min-width: 0; }
  .bd-vues { list-style: none; margin: 0; padding: 0; display: flex; flex-wrap: wrap; gap: 0 1.3em; }
  .bd-vues li {
    margin: 0;
    font-size: 0.62em;
    font-weight: 600;
    line-height: 1.5;
    letter-spacing: 0.04em;
    color: var(--dk-gris-2);
    border-bottom: 3px solid transparent;
    transition: color 0.3s, border-color 0.3s;
  }
  .bd-vues li.bd-ici { color: var(--dk-encre); border-bottom-color: var(--dk-accent); }
  .bd-vues li.bd-toutes { color: var(--dk-encre); }
  .bd-lecture { margin: 0; font-size: 0.8em; line-height: 1.35; color: var(--dk-encre); }
  .bd-morale { margin: 0; font-size: 0.95em; font-weight: 600; line-height: 1.25; color: var(--dk-accent); }
  .bd-source { flex: none; margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes bd-arrive { from { opacity: 0; } }

  @media (prefers-reduced-motion: reduce) {
    .bd-fondu, .bd-barre, .bd-base, .bd-etiq, .bd-vues li { animation: none !important; transition: none !important; }
  }
</style>
