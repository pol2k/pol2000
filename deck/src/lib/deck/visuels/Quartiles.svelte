<script>
  /**
   * « J’ai eu 78 %. C’est bon ? » Une note ne se lit que parmi les autres :
   * les quartiles servent à la situer. Deux classes fictives de 41
   * étudiant.e.s, notes sur 100, valeurs fixes ci-dessous. Q1, médiane et
   * Q3 sont calculés ici avec la convention par défaut de quantile() dans R
   * (type 7) ; les moustaches suivent la règle de geom_boxplot() (1,5 fois
   * l’écart interquartile). Rien n’est tapé à la main, rien n’est mesuré :
   * la figure est légendée « exemple fictif ».
   *
   *   0  La question, seule et grande. Les notes de la classe en points
   *      sur un axe, la note de 78 en rouge (« vous · 78 »).
   *   1  Couper en quatre : trois séparateurs tombent (Q1, médiane, Q3),
   *      quatre étiquettes « 25 % », l’accolade de l’écart interquartile,
   *      et le verdict : dans quel quart tombe 78.
   *   2  Une seconde classe, plus forte, tombe sous la première. Le même
   *      trait rouge à 78 traverse les deux : ici dans le meilleur quart,
   *      là sous la médiane.
   *   3  Les points s’aplatissent, deux boîtes à moustaches se dessinent,
   *      l’étiquette geom_boxplot() et la phrase de clôture apparaissent.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Notes fictives, triées. 41 valeurs : les quartiles de type 7 tombent
  // alors pile sur la 11e, la 21e et la 31e note.
  const NOTES_A = [
    42, 45, 47, 49, 50, 52, 53, 55, 56, 57,
    58,
    59, 60, 61, 62, 62, 63, 64, 65, 65,
    66,
    67, 68, 68, 69, 70, 71, 72, 73, 73,
    74,
    75, 76, 77, 78, 80, 82, 84, 87, 90, 94
  ];
  const NOTES_B = [
    58, 59, 60, 62, 64, 66, 68, 70, 72, 74,
    76,
    77, 78, 79, 79, 80, 81, 81, 82, 82,
    83,
    84, 84, 85, 85, 86, 86, 87, 88, 88,
    89,
    90, 90, 91, 92, 93, 94, 95, 96, 97, 98
  ];
  const VOUS = 78;

  const X0 = 60, PAS = 14, VMIN = 40, VMAX = 100;
  const x = (v) => X0 + (v - VMIN) * PAS;
  const X1 = x(VMAX);
  const XV = x(VOUS);
  const COL = 930;

  // quantile() de R, type 7 : position (n - 1) p, interpolation linéaire.
  function quantile7(tri, p) {
    const h = (tri.length - 1) * p;
    const bas = Math.floor(h);
    const haut = Math.min(bas + 1, tri.length - 1);
    return tri[bas] + (h - bas) * (tri[haut] - tri[bas]);
  }

  function verdict(v, q1, med, q3) {
    if (v > q3) return 'dans le meilleur quart';
    if (v >= med) return 'au-dessus de la médiane';
    if (v >= q1) return 'sous la médiane';
    return 'dans le dernier quart';
  }

  function classe(nom, notes, g) {
    const tri = [...notes].sort((a, b) => a - b);
    const q1 = quantile7(tri, 0.25), med = quantile7(tri, 0.5), q3 = quantile7(tri, 0.75);
    const eiq = q3 - q1;
    // Moustaches de geom_boxplot() : la note la plus loin à l'intérieur de 1,5 EIQ.
    const dedans = tri.filter((v) => v >= q1 - 1.5 * eiq && v <= q3 + 1.5 * eiq);
    const bas = dedans[0], haut = dedans[dedans.length - 1];
    const hors = tri.filter((v) => v < bas || v > haut);
    // Empilement déterministe : les notes identiques montent d'un cran.
    const vus = new Map();
    let marque = false;
    const points = tri.map((v, i) => {
      const k = vus.get(v) ?? 0;
      vus.set(v, k + 1);
      const moi = !marque && v === VOUS;
      if (moi) marque = true;
      const quart = v < q1 ? 0 : v < med ? 1 : v < q3 ? 2 : 3;
      const borne = v === q1 || v === med || v === q3;
      return { i, v, k, moi, pale: !borne && quart % 2 === 1 };
    });
    return {
      nom, ...g, q1, med, q3, eiq, bas, haut, hors, points,
      min: tri[0], max: tri[tri.length - 1],
      verdict: verdict(VOUS, q1, med, q3),
      seps: [
        { v: q1, nom: 'Q1' },
        { v: med, nom: 'médiane' },
        { v: q3, nom: 'Q3' }
      ]
    };
  }

  // Géométrie de chaque rangée : axe, étiquettes des séparateurs, boîte, colonne de droite.
  const A = classe('classe A', NOTES_A, { base: 250, yNom: 120, yVal: 146, yHaut: 154, yBoite: 208, yCol: 196 });
  const B = classe('classe B', NOTES_B, { base: 492, yNom: 384, yVal: 410, yHaut: 418, yBoite: 450, yCol: 438 });
  const bornesA = [A.min, A.q1, A.med, A.q3, A.max];
  const TICKS = [40, 50, 60, 70, 80, 90, 100];

  const fr = (v) => String(v).replace('.', ',');
  const QUESTION = 'J’ai eu 78 %. C’est bon ?';
  const aria =
    `Exemple fictif. La même note de ${VOUS} sur 100 dans deux classes de ${NOTES_A.length} étudiant.e.s. ` +
    `Classe A : Q1 ${fr(A.q1)}, médiane ${fr(A.med)}, Q3 ${fr(A.q3)}, écart interquartile de ${fr(A.eiq)} points ; ${VOUS} est ${A.verdict}. ` +
    `Classe B : Q1 ${fr(B.q1)}, médiane ${fr(B.med)}, Q3 ${fr(B.q3)} ; ${VOUS} est ${B.verdict}. ` +
    `Les deux rangées de points deviennent deux boîtes à moustaches.`;
</script>

{#snippet rangee(c, tombe)}
  <!-- La boîte, dessinée au dernier temps. -->
  <g class="qt-boite" class:qt-vu={e >= 3}>
    <path d="M {x(c.q1)} {c.yBoite - 22} H {x(c.q3)} V {c.yBoite + 22} H {x(c.q1)} Z" pathLength="1" class="qt-cadre" />
    <path d="M {x(c.q1)} {c.yBoite} H {x(c.bas)}" pathLength="1" class="qt-moust" />
    <path d="M {x(c.q3)} {c.yBoite} H {x(c.haut)}" pathLength="1" class="qt-moust" />
    <path d="M {x(c.bas)} {c.yBoite - 13} V {c.yBoite + 13} M {x(c.haut)} {c.yBoite - 13} V {c.yBoite + 13}" class="qt-cap" />
    <line x1={x(c.med)} y1={c.yBoite - 28} x2={x(c.med)} y2={c.yBoite + 28} class="qt-med" />
    {#each c.hors as v}
      <circle cx={x(v)} cy={c.yBoite} r="6" class="qt-hors" />
    {/each}
    <text x={x(c.min) - 14} y={c.yBoite + 8} class="qt-bout qt-fin">{c.min}</text>
    <text x={x(c.max) + 14} y={c.yBoite + 8} class="qt-bout">{c.max}</text>
  </g>

  {#each c.points as p}
    <g class="qt-pt" style="transform: translate({x(p.v)}px, {e >= 3 ? c.yBoite : c.base - 12 - p.k * 13.5}px); transition-delay: {e >= 3 ? p.i * 8 : 0}ms">
      <circle r={p.moi ? 8 : 6} class:qt-pluie={tombe} class:qt-moi={p.moi} class:qt-pale={e >= 1 && p.pale} class:qt-efface={e >= 3 && !p.moi} style="--d: {p.i * 14}ms" />
    </g>
  {/each}

  {#each c.seps as s, j}
    <g class="qt-sep" class:qt-vu={e >= 1} class:qt-fond={e >= 3} style="transition-delay: {e >= 1 && e < 3 ? j * 150 : 0}ms">
      <line x1={x(s.v)} y1={c.yHaut} x2={x(s.v)} y2={c.base} />
      <text x={x(s.v)} y={c.yNom} class="qt-nom">{s.nom}</text>
      <text x={x(s.v)} y={c.yVal} class="qt-val">{fr(s.v)}</text>
    </g>
  {/each}

  <line x1={X0} y1={c.base} x2={X1} y2={c.base} class="qt-axe" />
  {#each TICKS as t}
    <line x1={x(t)} y1={c.base} x2={x(t)} y2={c.base + 8} class="qt-axe" />
    <text x={x(t)} y={c.base + 30} class="qt-tick">{t}</text>
  {/each}
{/snippet}

<div class="visuel qt-fig" bind:this={hote}>
  <svg viewBox="0 0 1300 580" role="img" aria-label={aria}>
    <text x={X0} y="46" class="qt-question">{QUESTION}</text>
    <text x={X0} y="86" class="qt-note">exemple fictif · 1 point = 1 étudiant.e</text>

    {@render rangee(A, false)}

    {#each [0, 1, 2, 3] as g}
      <text x={(x(bornesA[g]) + x(bornesA[g + 1])) / 2} y="192" class="qt-pct" class:qt-vu={e >= 1 && e < 3} style="transition-delay: {e >= 1 && e < 3 ? 450 + g * 90 : 0}ms">25&#8239;%</text>
    {/each}

    <g class="qt-eiq" class:qt-vu={e >= 1}>
      <path d="M {x(A.q1)} 288 V 300 H {x(A.q3)} V 288" pathLength="1" />
      <text x={(x(A.q1) + x(A.q3)) / 2} y="326">écart interquartile</text>
      <text x={(x(A.q1) + x(A.q3)) / 2} y="352">{fr(A.eiq)} points</text>
    </g>

    {#if e >= 2}
      <g class="qt-rangee-b">
        {@render rangee(B, true)}
      </g>
    {/if}

    <!-- La même note, le même trait rouge, à travers les deux classes. -->
    <line x1={XV} y1="62" x2={XV} y2={A.base} class="qt-trait" />
    <path d="M {XV} {A.base} V {B.base}" pathLength="1" class="qt-trait qt-suite" class:qt-vu={e >= 2} />
    <text x={XV + 12} y="86" class="qt-vous">vous · {VOUS}</text>

    <!-- Colonne de droite : la classe, puis le verdict. -->
    <text x={COL} y={A.yCol} class="qt-classe" class:qt-vu={e >= 2}>{A.nom}</text>
    <text x={COL} y={A.yCol + 36} class="qt-verdict" class:qt-vu={e >= 1}>{A.verdict}</text>
    <text x={COL} y={B.yCol} class="qt-classe" class:qt-vu={e >= 2}>{B.nom}</text>
    <text x={COL} y={B.yCol + 36} class="qt-verdict qt-tard" class:qt-vu={e >= 2}>{B.verdict}</text>

    <g class="qt-fn" class:qt-vu={e >= 3}>
      <rect x="1046" y="12" width="244" height="44" />
      <text x="1168" y="42">geom_boxplot()</text>
    </g>

    <text x="650" y="568" class="qt-cloture" class:qt-vu={e >= 3}>Une note ne veut rien dire seule. Elle veut dire quelque chose parmi les autres.</text>
  </svg>
</div>

<style>
  .qt-fig { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .qt-question { font-size: 42px; font-weight: 600; fill: var(--dk-encre); letter-spacing: -0.02em; }
  .qt-note { font-size: 22px; fill: var(--dk-gris); }
  .qt-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .qt-tick { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }

  .qt-pt { transition: transform 0.7s cubic-bezier(0.5, 0, 0.3, 1.3); }
  .qt-pt circle { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; transition: fill 0.4s, opacity 0.5s; }
  .qt-pt circle.qt-pluie { animation: qt-pluie 0.6s cubic-bezier(0.3, 1.4, 0.6, 1) both; animation-delay: var(--d); }
  .qt-pt circle.qt-pale { fill: var(--dk-gris-2); }
  .qt-pt circle.qt-moi { fill: var(--dk-accent); }
  .qt-pt circle.qt-efface { opacity: 0.2; }
  @keyframes qt-pluie { from { transform: translateY(-120px); opacity: 0; } 40% { opacity: 1; } to { transform: none; opacity: 1; } }
  .qt-rangee-b { animation: qt-entre 0.4s ease-out both; }
  @keyframes qt-entre { from { opacity: 0; } to { opacity: 1; } }

  .qt-sep { opacity: 0; transform: translateY(-30px); transition: opacity 0.35s, transform 0.55s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .qt-sep.qt-vu { opacity: 1; transform: none; }
  .qt-sep line { stroke: var(--dk-encre); stroke-width: 4; transition: opacity 0.4s; }
  .qt-sep.qt-fond line { opacity: 0.2; }
  .qt-nom { font-size: 24px; text-anchor: middle; fill: var(--dk-encre); }
  .qt-val { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .qt-pct { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); opacity: 0; transition: opacity 0.4s; }
  .qt-pct.qt-vu { opacity: 1; }

  .qt-eiq path { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out 0.5s; }
  .qt-eiq.qt-vu path { stroke-dashoffset: 0; }
  .qt-eiq text { font-size: 24px; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s 1s; }
  .qt-eiq.qt-vu text { opacity: 1; }

  .qt-trait { stroke: var(--dk-accent); stroke-width: 4; fill: none; }
  .qt-suite { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.7s ease-out; }
  .qt-suite.qt-vu { stroke-dashoffset: 0; }
  .qt-vous { font-size: 26px; font-weight: 600; fill: var(--dk-accent); }

  .qt-classe { font-size: 26px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .qt-verdict { font-size: 26px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.9s; }
  .qt-verdict.qt-tard { transition-delay: 1.1s; }
  .qt-classe.qt-vu, .qt-verdict.qt-vu { opacity: 1; }

  .qt-boite .qt-cadre { fill: var(--dk-fond-2); fill-opacity: 0; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out 0.5s, fill-opacity 0.4s 1.1s; }
  .qt-boite .qt-moust { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.6s ease-out 1.2s; }
  .qt-boite .qt-cap { stroke: var(--dk-encre); stroke-width: 4; opacity: 0; transition: opacity 0.3s 1.7s; }
  .qt-boite .qt-med { stroke: var(--dk-encre); stroke-width: 8; opacity: 0; transition: opacity 0.3s 1s; }
  .qt-boite .qt-hors { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; opacity: 0; transition: opacity 0.3s 1.7s; }
  .qt-boite .qt-bout { font-size: 24px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s 1.8s; }
  .qt-boite .qt-bout.qt-fin { text-anchor: end; }
  .qt-boite.qt-vu .qt-cadre { stroke-dashoffset: 0; fill-opacity: 1; }
  .qt-boite.qt-vu .qt-moust { stroke-dashoffset: 0; }
  .qt-boite.qt-vu .qt-cap, .qt-boite.qt-vu .qt-med, .qt-boite.qt-vu .qt-hors, .qt-boite.qt-vu .qt-bout { opacity: 1; }

  .qt-fn { opacity: 0; transform: translateY(-8px); transition: opacity 0.4s 1.9s, transform 0.4s 1.9s; }
  .qt-fn.qt-vu { opacity: 1; transform: none; }
  .qt-fn rect { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3; }
  .qt-fn text { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .qt-cloture { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s 2.1s; }
  .qt-cloture.qt-vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .qt-pt circle.qt-pluie, .qt-rangee-b { animation: none; }
    .qt-pt, .qt-pt circle, .qt-sep, .qt-sep line, .qt-pct, .qt-eiq path, .qt-eiq text, .qt-suite, .qt-classe, .qt-verdict, .qt-boite *, .qt-fn, .qt-cloture { transition: none; }
  }
</style>
