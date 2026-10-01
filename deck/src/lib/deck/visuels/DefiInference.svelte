<script>
  /**
   * Le défi de l'inférence : la diapositive d'accueil de la section. Peu
   * d'éléments, en grand, un par clic. Un petit groupe (mon échantillon),
   * une grande foule (la population), et la question qui les relie.
   *
   *   0  Mon échantillon : six personnes dessinées, « 20 180 répondant.e.s »,
   *      CES 2025. Ce qu'on y trouve, en une phrase : les personnes nées hors
   *      du Canada se placent un peu plus à droite. Une règle de 0 à 10, deux
   *      carrés qui glissent jusqu'à leur moyenne (4,9 et 5,4).
   *   1  Une flèche vers la population, une grande foule grise qui apparaît
   *      de gauche à droite, et la question en rouge : est-ce vrai pour tous
   *      les Canadien.ne.s ?
   *   2  Carte 1 : mon échantillon ressemble-t-il à la population ?
   *   3  Carte 2 : ce résultat pourrait-il venir du hasard ?
   *   4  « Aujourd'hui : comment y répondre. »
   *
   * Données (src/lib/data/seance5.js, généré par outils/seance5_data.R) :
   *   - POP.n : le nombre de répondant.e.s de la CES 2025.
   *   - INTERET_AGE (src/lib/data/seance5_normale.js, outils/seance5_normale.R) :
   *     l'intérêt moyen pour la politique, de 0 à 10, chez les 18 à 34 ans et
   *     chez les 55 ans et plus. Sans pondération. Exemple choisi le 1er
   *     octobre 2026 à la demande de l'enseignant, pour une relation neutre
   *     (il remplace la position gauche-droite selon le lieu de naissance).
   * Les personnes dessinées sont des pictogrammes : leur nombre ne veut
   * rien dire. Positions fixes, pas de Math.random.
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance5.js';
  import { INTERET_AGE } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const n = f(POP.n);
  const { jeunes: JEUNES, aines: AINES } = INTERET_AGE;

  // Mon échantillon : un petit groupe, 3 × 2.
  const GROUPE = Array.from({ length: 6 }, (_, i) => ({ x: 58 + (i % 3) * 26, y: 44 + Math.floor(i / 3) * 40 }));

  // La règle de 0 à 10, en bas du panneau.
  const RX0 = 44, RX1 = 416, RY = 238;
  const px = (v) => RX0 + (v / 10) * (RX1 - RX0);
  const POINTS = [
    { v: JEUNES, rouge: false, ty: RY - 18, ancre: 'end', dx: -16, nom: '18-34 ans ' },
    { v: AINES, rouge: true, ty: RY - 18, ancre: 'start', dx: 16, nom: '55+ ' }
  ].map((p) => ({ ...p, x: px(p.v), etiq: f(p.v, 1) }));

  // La population : une grande foule, rangées décalées.
  const FX0 = 600, FY0 = 84, PASX = 25, PASY = 36;
  const FOULE = [];
  for (let r = 0; r < 5; r++) {
    const cols = r % 2 ? 14 : 15;
    for (let c = 0; c < cols; c++) {
      FOULE.push({ x: FX0 + c * PASX + (r % 2 ? PASX / 2 : 0), y: FY0 + r * PASY, d: c * 45 + r * 30 });
    }
  }

  // La flèche, du panneau vers la foule.
  const AY = 160, AX0 = 462, AX1 = 572;

  const aria = `Mon échantillon : ${n} répondant.e.s de l’Étude électorale canadienne 2025. Les 55 ans et plus s’intéressent plus à la politique : ${POINTS[1].etiq} sur 10, contre ${POINTS[0].etiq} chez les 18 à 34 ans. Est-ce vrai pour tous les Canadien.ne.s ? Un : mon échantillon ressemble-t-il à la population ? Deux : ce résultat pourrait-il venir du hasard ? Aujourd’hui : comment y répondre.`;
</script>

{#snippet personne(x, y, cls)}
  <circle cx={x} cy={y} r="6" class={cls} />
  <rect x={x - 8} y={y + 9} width="16" height="18" class={cls} />
{/snippet}

<div class="visuel defi-inference" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={aria}>
    <!-- 0 : mon échantillon, et ce qu'on y trouve. -->
    <rect x="20" y="12" width="420" height="262" class="di-panneau" />
    {#each GROUPE as p}
      {@render personne(p.x, p.y, 'di-encre')}
    {/each}
    <text x="152" y="56" class="di-titre">mon échantillon</text>
    <text x="152" y="88" class="di-t"><tspan class="di-fort">{n}</tspan> répondant.e.s</text>
    <text x="152" y="114" class="di-gris">CES 2025</text>

    <text x={RX0} y="160" class="di-t di-fort di-accent">Intérêt pour la politique&#8239;:</text>
    <text x={RX0} y="188" class="di-t">plus fort chez les 55+.</text>

    <line x1={RX0} y1={RY} x2={RX1} y2={RY} class="di-regle" />
    <text x={RX0} y="264" class="di-gris">0 · pas du tout</text>
    <text x={RX1} y="264" class="di-gris" text-anchor="end">10 · beaucoup</text>
    {#each POINTS as p, k}
      <g class="di-point" style="--dx: {p.x - RX0}px; animation-delay: {200 + k * 250}ms">
        <rect x={p.x - 8} y={RY - 8} width="16" height="16" class={p.rouge ? 'di-rouge' : 'di-encre'} />
        <text x={p.x + p.dx} y={p.ty} class="di-valeur" class:di-accent={p.rouge} text-anchor={p.ancre}>{p.nom}{p.etiq}</text>
      </g>
    {/each}

    <!-- 1 : le saut vers la population, et la question. -->
    {#if e >= 1}
      <path d="M {AX0} {AY} H {AX1 - 4}" pathLength="1" class="di-saut" />
      <path d="M {AX1 - 18} {AY - 14} L {AX1 - 2} {AY} L {AX1 - 18} {AY + 14}" pathLength="1" class="di-saut di-pointe" />
    {/if}
    <g class="di-apparait" class:di-vu={e >= 1}>
      <text x={FX0 - 8} y="44" class="di-titre">la population</text>
      {#each FOULE as p}
        <g class="di-fige" style="animation-delay: {p.d}ms">
          {@render personne(p.x, p.y, 'di-foule')}
        </g>
      {/each}
    </g>
    <g class="di-monte" class:di-vu={e >= 1}>
      <text x="500" y="314" class="di-question">Est-ce vrai pour tous les Canadien.ne.s&#8239;?</text>
    </g>

    <!-- 2, 3 : les deux vérifications, deux cartes. -->
    <g class="di-monte" class:di-vu={e >= 2}>
      <rect x="20" y="336" width="470" height="130" class="di-carte" />
      <text x="64" y="422" class="di-num">1</text>
      <text x="124" y="378" class="di-carte-t">Mon échantillon</text>
      <text x="124" y="410" class="di-carte-t">ressemble-t-il</text>
      <text x="124" y="442" class="di-carte-t">à la population&#8239;?</text>
    </g>
    <g class="di-monte" class:di-vu={e >= 3}>
      <rect x="510" y="336" width="470" height="130" class="di-carte" />
      <text x="554" y="422" class="di-num">2</text>
      <text x="614" y="378" class="di-carte-t">Ce résultat</text>
      <text x="614" y="410" class="di-carte-t">pourrait-il venir</text>
      <text x="614" y="442" class="di-carte-t">du hasard&#8239;?</text>
    </g>

    <!-- 4 : la promesse. -->
    <g class="di-monte" class:di-vu={e >= 4}>
      <text x="500" y="524" class="di-promesse">Aujourd’hui&#8239;: comment y répondre.</text>
    </g>
  </svg>
</div>

<style>
  .defi-inference { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .di-titre { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .di-t { font-size: 22px; fill: var(--dk-encre); }
  .di-fort { font-weight: 600; }
  .di-gris { font-size: 18px; fill: var(--dk-gris); }
  .di-accent, .di-valeur.di-accent { fill: var(--dk-accent); }
  .di-valeur { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .di-question { font-size: 36px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .di-carte-t { font-size: 28px; font-weight: 600; fill: var(--dk-encre); }
  .di-num { font-size: 56px; font-weight: 600; fill: var(--dk-encre); }
  .di-promesse { font-size: 32px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .di-panneau { fill: var(--dk-fond-2); }
  .di-carte { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .di-encre { fill: var(--dk-encre); }
  .di-rouge { fill: var(--dk-accent); }
  .di-foule { fill: var(--dk-gris-2); }
  .di-regle { stroke: var(--dk-gris-2); stroke-width: 2; }

  .di-point { animation: di-glisse 0.9s cubic-bezier(0.34, 1.3, 0.64, 1) both; }
  .di-saut { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; animation: di-trace 0.5s ease-out forwards; }
  .di-saut.di-pointe { animation-delay: 0.4s; }

  .di-apparait { opacity: 0; transition: opacity 0.2s; }
  .di-apparait.di-vu { opacity: 1; transition: opacity 0.3s; }
  .di-apparait .di-fige { opacity: 0; }
  .di-apparait.di-vu .di-fige { animation: di-fondu 0.4s ease-out both; }
  .di-monte { opacity: 0; transform: translateY(10px); transition: opacity 0.2s, transform 0.2s; }
  .di-monte.di-vu { opacity: 1; transform: none; transition: opacity 0.4s 0.2s, transform 0.5s 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }

  @keyframes di-glisse { from { transform: translateX(calc(-1 * var(--dx))); } to { transform: none; } }
  @keyframes di-trace { to { stroke-dashoffset: 0; } }
  @keyframes di-fondu { from { opacity: 0; } to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .di-point { animation: none; }
    .di-saut { animation: none; stroke-dashoffset: 0; }
    .di-apparait.di-vu .di-fige { animation: none; opacity: 1; }
    .di-apparait, .di-apparait.di-vu, .di-monte, .di-monte.di-vu { transition: none; }
    .di-monte { transform: none; }
  }
</style>
