<script>
  /**
   * L'âge, parti par parti, en barres groupées : l'intention de vote selon le
   * groupe d'âge (Étude électorale canadienne 2025, src/lib/data/seance3_barres.js,
   * généré par outils/seance3_barres.R). La hauteur d'une barre est un effectif,
   * comme geom_bar() le dessine. Le contraste du dernier temps est choisi ici, à
   * partir des pourcentages exportés par R : le parti nommé dont la part change le
   * plus, en proportion, entre le groupe le plus jeune et le plus âgé.
   *
   *   0  Les barres poussent, groupe par groupe.
   *   1  Le code apparaît sous le graphique ; fill = parti et
   *      position = "dodge" sont en rouge.
   *   2  Un contraste reste allumé, avec ses deux pourcentages ; la phrase de
   *      clôture arrive.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { BARRES } from '$lib/data/seance3_barres.js';

  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 2,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  // Les couleurs de la diapositive « le mode » (PourquoiMode.svelte).
  const COUL = { 'Libéral': '#d71920', 'Conservateur': '#1a4782', 'NPD': '#f37021', 'Bloc Québécois': '#33b2cc', 'Vert': '#3d9b35', 'Autre': '#8b918f' };
  const PARTIS = BARRES.partis;
  const GROUPES = BARRES.groupes;
  const NG = GROUPES.length;

  // Le contraste : plus grand rapport entre la part chez les plus jeunes et chez
  // les plus âgés, parmi les partis nommés (« Autre » n'est pas un parti).
  const rapport = (k) => {
    const a = GROUPES[0].pourcentages[k], b = GROUPES[NG - 1].pourcentages[k];
    return Math.max(a, b) / Math.min(a, b);
  };
  const K = PARTIS.map((p, k) => k).filter((k) => PARTIS[k] !== 'Autre').sort((a, b) => rapport(b) - rapport(a))[0];
  const allume = (g, k) => k === K && (g === 0 || g === NG - 1);

  // L'échelle des effectifs : des graduations rondes, calculées sur le maximum.
  const MAXI = Math.max(...GROUPES.flatMap((g) => g.effectifs));
  const puissance = 10 ** Math.floor(Math.log10(MAXI));
  const PAS = MAXI / puissance < 3 ? puissance / 2 : puissance;
  const TICKS = Array.from({ length: Math.floor(MAXI / PAS) + 1 }, (_, i) => i * PAS);

  const W = 1000, H = 398, X0 = 96, X1 = 996, HAUT = 52, BAS = 340;
  const LG = (X1 - X0) / NG, PITCH = 40, LB = 38;
  const MARGE = (LG - PITCH * PARTIS.length) / 2;
  const y = (v) => BAS - (v / (MAXI * 1.03)) * (BAS - HAUT);
  const bx = (g, k) => X0 + g * LG + MARGE + k * PITCH;

  // La légende, sur une ligne : IBM Plex Mono, 0,6 em par caractère.
  const CAR = 22 * 0.6, CARRE = 22, ECART = 26;
  const largeurs = PARTIS.map((p) => CARRE + 8 + p.length * CAR);
  const totalLegende = largeurs.reduce((s, l) => s + l, 0) + ECART * (PARTIS.length - 1);
  const LEGENDE = PARTIS.map((p, k) => ({ nom: p, x: (W - totalLegende) / 2 + largeurs.slice(0, k).reduce((s, l) => s + l + ECART, 0) }));

  // Les étiquettes du contraste se posent au-dessus des barres courtes, à droite
  // de la barre allumée : là où le graphique est vide.
  const ETIQ_H = 60;
  const ETIQS = [0, NG - 1].map((g) => {
    const haut = Math.max(...GROUPES[g].effectifs.slice(K));
    return { g, x: bx(g, K), cx: bx(g, K) + LB / 2, bas: y(haut) - 16, sommet: y(GROUPES[g].effectifs[K]), l: PITCH * (PARTIS.length - K) + 20 };
  });

  const entier = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const pct = (p) => p.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + ' %';

  // Le code de R, découpé autour des deux morceaux qui sont la leçon.
  const FORTS = ['fill = parti', 'position = "dodge"'];
  const echappe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const MORCEAUX = BARRES.code.split(new RegExp('(' + FORTS.map(echappe).join('|') + ')')).map((t) => ({ t, fort: FORTS.includes(t) }));

  const ARIA = `Diagramme à barres groupées de l’intention de vote selon le groupe d’âge, Étude électorale canadienne 2025. `
    + GROUPES.map((g) => `${g.nom} : ` + PARTIS.map((p, k) => `${p} ${entier(g.effectifs[k])}`).join(', ')).join('. ')
    + `. ${PARTIS[K]} : ${pct(GROUPES[0].pourcentages[K])} des ${GROUPES[0].nom}, ${pct(GROUPES[NG - 1].pourcentages[K])} des ${GROUPES[NG - 1].nom}.`;
</script>

<div class="visuel bd-fig" bind:this={hote}>
  {#key tour}
    <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label={ARIA}>
      <!-- La légende : une couleur par parti, c'est ce que fait fill. -->
      {#each LEGENDE as l, k}
        <g class="bd-leg" class:bd-terne={e >= 2 && k !== K}>
          <rect x={l.x} y="6" width={CARRE} height={CARRE} fill={COUL[l.nom]} />
          <text x={l.x + CARRE + 8} y="25" class="bd-leg-t">{l.nom}</text>
        </g>
      {/each}

      {#each TICKS as t}
        <path d="M {X0} {y(t)} L {X1} {y(t)}" class="bd-grille" />
        <text x={X0 - 10} y={y(t) + 6} class="bd-tick">{entier(t)}</text>
      {/each}
      <text x="18" y={(HAUT + BAS) / 2} class="bd-axe-t" transform="rotate(-90 18 {(HAUT + BAS) / 2})">effectif</text>

      {#each GROUPES as g, i}
        {#each g.effectifs as n, k}
          <rect x={bx(i, k)} y={y(n)} width={LB} height={BAS - y(n)} fill={COUL[PARTIS[k]]} class="bd-barre" class:bd-terne={e >= 2 && !allume(i, k)} style="--g: {i}; --k: {k}" />
        {/each}
        <text x={X0 + i * LG + LG / 2} y={BAS + 30} class="bd-groupe">{g.nom}</text>
        <text x={X0 + i * LG + LG / 2} y={BAS + 53} class="bd-n">n = {entier(g.total)}</text>
      {/each}
      <path d="M {X0} {BAS} L {X1} {BAS}" class="bd-axe" />
      <path d="M {X0} {HAUT - 8} L {X0} {BAS}" class="bd-axe" />

      <!-- Temps 2 : les deux pourcentages, calculés dans chaque groupe d'âge. -->
      {#if e >= 2}
        {#each ETIQS as q, j}
          <g class="bd-etiq" style="--j: {j}">
            <path d="M {q.cx} {q.sommet - 4} L {q.cx} {q.bas}" class="bd-trait" />
            <rect x={q.x} y={q.bas - ETIQ_H} width={q.l} height={ETIQ_H} class="bd-cadre" />
            <text x={q.x + 12} y={q.bas - ETIQ_H + 28} class="bd-pct">{pct(GROUPES[q.g].pourcentages[K])}</text>
            <text x={q.x + 12} y={q.bas - 10} class="bd-de">des {GROUPES[q.g].nom}</text>
          </g>
        {/each}
      {/if}
    </svg>
  {/key}

  <!-- La place du code et de la phrase est réservée dès l'arrivée : rien ne saute. -->
  <pre class="bd-code" class:bd-vu={e >= 1}>{#each MORCEAUX as m}{#if m.fort}<span class="bd-fort">{m.t}</span>{:else}{m.t}{/if}{/each}</pre>
  <p class="bd-fin" class:bd-vu={e >= 2}><span class="bd-mot">fill</span> colore par parti&#8239;; <span class="bd-mot">dodge</span> met les barres côte à côte.</p>
  <p class="bd-source">Étude électorale canadienne 2025 · intentions de vote, sans les «&#8239;ne sait pas&#8239;»</p>
</div>

<style>
  .bd-fig { display: flex; flex-direction: column; gap: 0.5em; flex: 1 1 auto; min-height: 0; }
  svg { flex: 0 1 auto; min-height: 0; max-height: 50vh; width: 100%; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .bd-leg, .bd-barre { transition: opacity 0.5s; }
  .bd-terne { opacity: 0.16; }
  .bd-leg-t { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }

  .bd-grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .bd-axe { stroke: var(--dk-encre); stroke-width: 3; fill: none; }
  .bd-tick { font-size: 18px; text-anchor: end; fill: var(--dk-gris); font-variant-numeric: tabular-nums; }
  .bd-axe-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); letter-spacing: 0.06em; }
  .bd-groupe { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .bd-n { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }

  .bd-barre {
    transform-box: fill-box;
    transform-origin: center bottom;
    animation: bd-pousse 0.6s cubic-bezier(0.22, 1, 0.36, 1) backwards;
    animation-delay: calc(var(--g) * 420ms + var(--k) * 45ms + 120ms);
  }

  .bd-etiq {
    transform-box: fill-box;
    transform-origin: left bottom;
    animation: bd-pop 0.45s cubic-bezier(0.34, 1.6, 0.64, 1) backwards;
    animation-delay: calc(var(--j) * 350ms + 200ms);
  }
  .bd-trait { stroke: var(--dk-accent); stroke-width: 3; fill: none; }
  .bd-cadre { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3; }
  .bd-pct { font-size: 27px; font-weight: 600; fill: var(--dk-accent); font-variant-numeric: tabular-nums; }
  .bd-de { font-size: 18px; font-weight: 600; fill: var(--dk-encre); }

  .bd-code {
    flex: none;
    align-self: flex-start;
    margin: 0;
    font-family: var(--dk-mono);
    font-size: 0.8em;
    line-height: 1.45;
    border: 3px solid var(--dk-encre);
    padding: 0.4em 0.9em;
    white-space: pre;
    color: var(--dk-encre);
    opacity: 0;
    visibility: hidden;
    transform: translateY(0.5em);
    transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s;
  }
  .bd-fort { color: var(--dk-accent); font-weight: 600; }
  .bd-fin {
    flex: none;
    margin: 0;
    font-size: 0.9em;
    font-weight: 600;
    line-height: 1.3;
    color: var(--dk-accent);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s, visibility 0s 0.3s;
  }
  .bd-code.bd-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.4s, transform 0.4s, visibility 0s; }
  .bd-fin.bd-vu { opacity: 1; visibility: visible; transition: opacity 0.4s 0.5s, visibility 0s 0.5s; }
  .bd-mot { border-bottom: 3px solid var(--dk-accent); }
  .bd-source { flex: none; margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes bd-pousse { from { transform: scaleY(0); } }
  @keyframes bd-pop { from { opacity: 0; transform: scale(0.4); } }

  @media (prefers-reduced-motion: reduce) {
    .bd-leg, .bd-barre, .bd-etiq, .bd-code, .bd-fin { animation: none !important; transition: none !important; }
  }
</style>
