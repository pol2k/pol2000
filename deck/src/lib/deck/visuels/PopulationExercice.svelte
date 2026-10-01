<script>
  /**
   * Pour s'exercer : faire comme si. Dans la vraie vie, on a un seul
   * échantillon et on ne connaît jamais la vraie valeur. Pour voir comment
   * se comportent les échantillons, on fait comme si les N répondant.e.s de
   * l'Étude électorale canadienne 2025 étaient toute la population : leur
   * âge moyen devient la vraie valeur, connue, et on peut y tirer au hasard
   * autant de petits échantillons qu'on veut. Un schéma, sans autres données
   * que N, l'âge moyen et la taille des petits échantillons.
   *
   *   0  La vraie vie : à gauche, la population (le Canada, des millions
   *      d'adultes), sa vraie valeur inconnue (un grand « ? »). Une flèche
   *      vers un seul échantillon : la CES, N répondant.e.s.
   *   1  Le truc : la population pâlit. La CES devient « population
   *      d'exercice » (cadre rouge), et son âge moyen, la vraie valeur, connue.
   *   2  Trois petits échantillons tirés au hasard dans la CES : trois
   *      cases de 50 points (une grille, pas des âges), des flèches, « … ».
   *   3  Une phrase : on connaît la réponse, les échantillons la trouvent-ils ?
   *
   * N et l'âge moyen viennent de POP (src/lib/data/seance5.js, sans
   * pondération); la taille des petits échantillons, de TROIS (même fichier,
   * outils/seance5_data.R), pour qu'elle suive les diapositives suivantes.
   */
  import { brancherTemps } from '../temps.js';
  import { POP, TROIS } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const n = f(POP.n);
  const age = f(POP.moyenne, 1);
  const k50 = TROIS[0].ages.length;

  // Deux grandes boîtes et une colonne de petites.
  const BY = 70, BH = 230;
  const B1 = { x: 20, w: 280 }, B2 = { x: 370, w: 260 }, B3 = { x: 720, w: 260 };
  const c = (b) => b.x + b.w / 2;
  const YM = BY + BH / 2;

  // Les petits échantillons : trois cases, une grille de points dans chacune.
  const PH = 64, PG = 14;
  const py = (k) => BY + k * (PH + PG);
  const COLS = 10;
  const RANGS = Math.ceil(k50 / COLS);
  const points = Array.from({ length: k50 }, (_, i) => ({
    x: B3.x + 31 + (i % COLS) * 22,
    y: 12 + Math.floor(i / COLS) * (40 / Math.max(RANGS - 1, 1))
  }));

  // Une flèche droite, la pointe calculée selon l'angle.
  const fleche = (x1, y1, x2, y2) => {
    const L = Math.hypot(x2 - x1, y2 - y1);
    const ux = (x2 - x1) / L, uy = (y2 - y1) / L;
    const bx = x2 - ux * 11, by = y2 - uy * 11;
    return `M ${x1} ${y1} L ${x2} ${y2} M ${bx - uy * 8} ${by + ux * 8} L ${x2} ${y2} L ${bx + uy * 8} ${by - ux * 8}`;
  };
</script>

<div class="visuel population-exercice" bind:this={hote}>
  <svg viewBox="0 0 1000 465" role="img" aria-label="Dans la vraie vie, la population, le Canada, a une vraie valeur qu’on ne connaît pas, et on n’a qu’un seul échantillon, l’Étude électorale canadienne, {n} répondant.e.s. Pour s’exercer, on fait comme si ces {n} personnes étaient la population : leur âge moyen, {age} ans, devient la vraie valeur, connue. On y tire au hasard des échantillons de {k50}. On connaît la réponse : les échantillons la trouvent-ils ?">
    <!-- 0 : la population, la vraie valeur inconnue. Pâlit en 1. -->
    <g class="pe-reel" class:pe-pale={e >= 1}>
      <text x={c(B1)} y="48" class="pe-titre">la population</text>
      <rect x={B1.x} y={BY} width={B1.w} height={BH} class="pe-boite" />
      <text x={c(B1)} y={BY + 50} class="pe-nom">le Canada</text>
      <text x={c(B1)} y={BY + 88} class="pe-t">des millions</text>
      <text x={c(B1)} y={BY + 114} class="pe-t">d’adultes</text>
      <line x1={B1.x + 30} y1={BY + 140} x2={B1.x + B1.w - 30} y2={BY + 140} class="pe-filet" />
      <text x={c(B1)} y={BY + 212} class="pe-inconnu">?</text>
      <text x={c(B1)} y={BY + BH + 30} class="pe-sous">la vraie valeur, inconnue</text>
      <path d={fleche(B1.x + B1.w + 8, YM, B2.x - 8, YM)} class="pe-fleche" />
    </g>

    <!-- 0 : un seul échantillon. 1 : la population d'exercice. -->
    <text x={c(B2)} y="48" class="pe-titre pe-bascule" class:pe-vu={e < 1}>un seul échantillon</text>
    <text x={c(B2)} y="48" class="pe-titre pe-rouge pe-bascule" class:pe-vu={e >= 1}>population d’exercice</text>
    <rect x={B2.x} y={BY} width={B2.w} height={BH} class="pe-boite" class:pe-exercice={e >= 1} />
    <text x={c(B2)} y={BY + 50} class="pe-nom">la CES</text>
    <text x={c(B2)} y={BY + 92} class="pe-n">{n}</text>
    <text x={c(B2)} y={BY + 120} class="pe-t">répondant.e.s</text>
    <g class="pe-bascule" class:pe-vu={e >= 1}>
      <line x1={B2.x + 30} y1={BY + 140} x2={B2.x + B2.w - 30} y2={BY + 140} class="pe-filet" />
      <text x={c(B2)} y={BY + 168} class="pe-t pe-gris">âge moyen</text>
      <text x={c(B2)} y={BY + 212} class="pe-age">{age} ans</text>
      <text x={c(B2)} y={BY + BH + 30} class="pe-sous pe-rouge">la vraie valeur, connue</text>
    </g>

    <!-- 2 : des petits échantillons, tirés au hasard. -->
    <g class="pe-tirages" class:pe-vu={e >= 2}>
      <text x={c(B3)} y="48" class="pe-titre">{k50} au hasard</text>
      {#each [0, 1, 2] as k}
        <g class="pe-tirage" style="transition-delay: {e >= 2 ? k * 0.18 : 0}s">
          <path d={fleche(B2.x + B2.w + 8, YM, B3.x - 8, py(k) + PH / 2)} class="pe-fleche" />
          <rect x={B3.x} y={py(k)} width={B3.w} height={PH} class="pe-boite" />
          {#each points as p}
            <circle cx={p.x} cy={py(k) + p.y} r="3.5" class="pe-pt" />
          {/each}
        </g>
      {/each}
      <text x={c(B3)} y={BY + BH + 30} class="pe-suite">…</text>
    </g>

    <!-- 3 : la phrase. -->
    <text x="500" y="400" class="pe-phrase pe-bascule" class:pe-vu={e >= 3}>On connaît la réponse. Les échantillons la trouvent-ils&#8239;?</text>

    <text x="10" y="452" class="pe-source">Étude électorale canadienne 2025, sans pondération</text>
  </svg>
</div>

<style>
  .population-exercice { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .pe-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .pe-boite.pe-exercice { stroke: var(--dk-accent); stroke-width: 5; }
  .pe-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .pe-filet { stroke: var(--dk-fond-2); stroke-width: 2; }

  .pe-titre { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pe-nom { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pe-t { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .pe-gris { fill: var(--dk-gris); }
  .pe-rouge { fill: var(--dk-accent); }
  .pe-n { font-size: 36px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); letter-spacing: -0.02em; }
  .pe-inconnu { font-size: 72px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .pe-age { font-size: 40px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .pe-sous { font-size: 19px; text-anchor: middle; fill: var(--dk-gris); }
  .pe-pt { fill: var(--dk-encre); }
  .pe-suite { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .pe-phrase { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pe-source { font-size: 17px; fill: var(--dk-gris-2); letter-spacing: 0.04em; }

  .pe-reel { transition: opacity 0.5s; }
  .pe-reel.pe-pale { opacity: 0.22; }

  .pe-bascule { opacity: 0; transition: opacity 0.25s; }
  .pe-bascule.pe-vu { opacity: 1; transition: opacity 0.5s 0.2s; }

  .pe-tirages .pe-tirage { opacity: 0; transform: translateX(-14px); transition: opacity 0.2s, transform 0.2s; }
  .pe-tirages.pe-vu .pe-tirage { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .pe-tirages > text { opacity: 0; transition: opacity 0.2s; }
  .pe-tirages.pe-vu > text { opacity: 1; transition: opacity 0.4s 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .pe-boite, .pe-reel, .pe-bascule, .pe-bascule.pe-vu,
    .pe-tirages .pe-tirage, .pe-tirages.pe-vu .pe-tirage,
    .pe-tirages > text, .pe-tirages.pe-vu > text { transition: none; }
    .pe-tirages .pe-tirage { transform: none; }
  }
</style>
