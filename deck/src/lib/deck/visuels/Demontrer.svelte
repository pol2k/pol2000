<script>
  /**
   * La sortie de la section « c’est quoi, la science ? » et l’entrée dans
   * les statistiques descriptives. Trois temps.
   *
   *   0  L’opinion : une grosse bulle qui prend toute la place et ne dit
   *      rien. Le texte y est un gribouillis gris, illisible exprès : une
   *      opinion n’offre rien à inspecter.
   *   1  La démonstration : à côté, un petit tableau de nombres avec ses
   *      en-têtes, et sous lui la méthode, écrite. Petit, plat, vérifiable.
   *      La bulle se dégonfle et grisonne. La phrase de King, Keohane et
   *      Verba (1994), Designing Social Inquiry, en anglais, dans le texte
   *      original (le tiret long est le leur).
   *   2  Le passage de relais vers la suite du cours : décrire une variable.
   *
   * Aucune donnée : le tableau est un schéma, dit tel, et ses en-têtes comme
   * ses lignes de méthode sont des barres, pas des mots. Rien n’y est une
   * quantité mesurée, rien n’y prétend être un résultat. Tracés fixes,
   * aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le gribouillis de la bulle : une onde régulière, calculée, jamais tirée
  // au hasard. Une ligne par entrée : hauteur et longueur.
  const GRIBOUILLIS = [
    { y: 118, l: 400 },
    { y: 150, l: 368 },
    { y: 182, l: 416 },
    { y: 214, l: 256 }
  ];
  function onde(y, l) {
    const pas = 16;
    let d = `M 52 ${y}`;
    for (let x = 52, k = 0; x < 52 + l; x += pas, k++) {
      d += ` Q ${x + pas / 2} ${y + (k % 2 === 0 ? -5 : 5)} ${x + pas} ${y}`;
    }
    return d;
  }

  // Le tableau : des nombres quelconques, trois colonnes, quatre lignes.
  const RANGS = [
    ['18', '42', '0,31'],
    ['24', '37', '0,58'],
    ['31', '29', '0,44'],
    ['12', '51', '0,27']
  ];
  const COL = [614, 762, 910];
  // Les en-têtes et la méthode : des barres, pour ne rien prétendre.
  const ENTETES = [
    { x: 560, w: 76 },
    { x: 708, w: 64 },
    { x: 856, w: 84 }
  ];
  const METHODE = [
    [{ x: 540, w: 120 }, { x: 672, w: 180 }],
    [{ x: 560, w: 90 }, { x: 662, w: 140 }, { x: 814, w: 70 }],
    [{ x: 560, w: 150 }, { x: 722, w: 100 }],
    [{ x: 540, w: 200 }]
  ];
</script>

<div class="visuel dt-fig" bind:this={hote}>
  <svg
    class="dt-scene"
    viewBox="0 0 1000 300"
    role="img"
    aria-label="À gauche, une grosse bulle de parole où l’on lit «&#8239;je pense que&#8239;» suivi de lignes illisibles. À droite, plus petit, un tableau de nombres schématique et quelques lignes de méthode&#8239;; la bulle se dégonfle et pâlit."
  >
    <!-- L’opinion : grosse, impressionnante, vide. -->
    <g class="dt-bulle" class:dt-plat={e >= 1}>
      <rect x="16" y="16" width="470" height="216" class="dt-cadre" />
      <path d="M 110 232 L 110 280 L 182 232 Z" class="dt-cadre dt-queue" />
      <text x="52" y="80" class="dt-pense">je pense que…</text>
      {#each GRIBOUILLIS as g, i}
        <path d={onde(g.y, g.l)} class="dt-onde" style="--k: {i}" />
      {/each}
    </g>

    <!-- La démonstration : petite, plate, inspectable. -->
    <g class="dt-bloc" class:dt-vu={e >= 1}>
      <rect x="540" y="16" width="444" height="152" class="dt-tab" />
      <line x1="540" y1="52" x2="984" y2="52" class="dt-tab-l" />
      <line x1="688" y1="16" x2="688" y2="168" class="dt-tab-c" />
      <line x1="836" y1="16" x2="836" y2="168" class="dt-tab-c" />
      {#each ENTETES as h}
        <rect x={h.x} y="27" width={h.w} height="11" class="dt-entete" />
      {/each}
      {#each RANGS as r, i}
        {#each r as v, j}
          <text x={COL[j]} y={76 + i * 24} class="dt-num">{v}</text>
        {/each}
      {/each}

      <text x="540" y="196" class="dt-meth">méthode</text>
      {#each METHODE as ligne, i}
        {#each ligne as b}
          <rect x={b.x} y={208 + i * 20} width={b.w} height="10" class="dt-regle" />
        {/each}
      {/each}
      <text x="984" y="294" class="dt-schema">schéma</text>
    </g>
  </svg>

  <blockquote class="dt-cit" class:dt-vu={e >= 1}>
    <span lang="en">“no one cares what we think—the scholarly community only cares what we can demonstrate.”</span>
    <span class="dt-src">King, Keohane and Verba (1994), <i>Designing Social Inquiry</i></span>
  </blockquote>

  <div class="dt-relais" class:dt-vu={e >= 2}>
    <p class="dt-final">Alors, démontrons.</p>
    <p class="dt-suite">Et ça commence par décrire une variable.</p>
  </div>
</div>

<style>
  .dt-fig { display: flex; flex-direction: column; gap: 0.7em; }

  .dt-scene { width: 100%; height: auto; max-height: 44vh; display: block; overflow: visible; }
  .dt-scene text { font-family: var(--dk-mono); }

  .dt-bulle { transform-box: view-box; transform-origin: 110px 280px; transition: transform 0.7s cubic-bezier(0.33, 0, 0.2, 1), opacity 0.7s; }
  .dt-bulle.dt-plat { transform: scale(0.72); opacity: 0.5; }
  .dt-cadre { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.7s; }
  .dt-queue { stroke-linejoin: miter; }
  .dt-plat .dt-cadre { stroke: var(--dk-gris-2); }
  .dt-pense { font-size: 38px; font-weight: 600; fill: var(--dk-encre); transition: fill 0.7s; }
  .dt-plat .dt-pense { fill: var(--dk-gris); }
  .dt-onde { fill: none; stroke: var(--dk-gris-2); stroke-width: 5; stroke-linecap: round; animation: dt-trace 0.6s ease-out both; animation-delay: calc(var(--k) * 120ms + 200ms); }

  .dt-bloc { opacity: 0; transform: translateX(26px); transition: opacity 0.5s 0.25s, transform 0.5s 0.25s; }
  .dt-bloc.dt-vu { opacity: 1; transform: none; }
  .dt-tab { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; }
  .dt-tab-l { stroke: var(--dk-encre); stroke-width: 2.5; }
  .dt-tab-c { stroke: var(--dk-gris-2); stroke-width: 1.5; }
  .dt-entete { fill: var(--dk-encre); }
  .dt-num { font-size: 19px; text-anchor: middle; fill: var(--dk-encre); font-variant-numeric: tabular-nums; }
  .dt-meth { font-size: 14px; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; fill: var(--dk-gris); }
  .dt-regle { fill: var(--dk-gris-2); }
  .dt-schema { font-size: 13px; text-anchor: end; letter-spacing: 0.06em; fill: var(--dk-gris-2); }

  .dt-cit { margin: 0; font-size: 1.05em; line-height: 1.5; border-left: 0.3em solid var(--dk-accent); padding-left: 0.8em; opacity: 0; transition: opacity 0.5s 0.5s; }
  .dt-cit.dt-vu { opacity: 1; }
  .dt-src { display: block; margin-top: 0.4em; font-size: 0.56em; letter-spacing: 0.05em; color: var(--dk-gris); }
  .dt-src i { font-style: italic; }

  .dt-relais { display: flex; flex-direction: column; gap: 0.15em; min-height: 3.4em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s; }
  .dt-relais.dt-vu { opacity: 1; transform: none; }
  .dt-final { margin: 0; font-size: 1.7em; font-weight: 600; color: var(--dk-accent); }
  .dt-suite { margin: 0; font-size: 0.95em; }

  @keyframes dt-trace { from { opacity: 0; } to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .dt-bulle, .dt-cadre, .dt-pense, .dt-bloc, .dt-cit, .dt-relais { transition: none; }
    .dt-onde { animation: none; }
  }
</style>
