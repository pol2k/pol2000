<script>
  /**
   * La moyenne de plusieurs dés : pourquoi les moyennes font une cloche.
   * Deux rangées. En haut, 2 dés, en bas, 10 dés. À gauche de chaque rangée,
   * les dés du lancer en cours, leur moyenne et le compteur de lancers. À
   * droite, un axe de 1 à 6 : chaque lancer y dépose un carré au-dessus de
   * sa moyenne, comme pour le dé seul de la diapo précédente.
   *
   *   0  Je lance 2 dés et je prends la moyenne : un lancer, un carré.
   *   1  1 000 fois : l'avance rapide (environ 2 s), un triangle. 3,5
   *      arrive de plusieurs façons, 1 d'une seule.
   *   2  Et avec 10 dés ? Un lancer, un carré (sa valeur écrite au-dessus,
   *      le carré est petit).
   *   3  1 000 fois : l'avance rapide (environ 2 s), une cloche, en rouge.
   *      Une moyenne de 1 demande dix 1 : presque jamais.
   *   4  La conclusion : un échantillon de 50 personnes, c'est comme 50 dés.
   *
   * Chaque animation a une fin fixe : au temps suivant, ou une fois la durée
   * écoulée, l'image est toujours la même (les effectifs de R). Avec
   * « réduire les animations », on saute à la fin.
   *
   * Tout vient de src/lib/data/seance5_des.js (outils/seance5_des.R) : les
   * faces de chaque lancer, dans l'ordre, et les effectifs des 1 000.
   */
  import { brancherTemps } from '../temps.js';
  import { DES } from '$lib/data/seance5_des.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie commune : l'axe des moyennes à droite, de X0 à X0 + LARGEUR.
  const X0 = 360, LARGEUR = 620, HAUT = 140, GAUCHE = 165;

  // Les points d'une face : positions en tiers de la face (−1, 0, 1).
  const POINTS = {
    1: [[0, 0]],
    2: [[-1, -1], [1, 1]],
    3: [[-1, -1], [0, 0], [1, 1]],
    4: [[-1, -1], [1, -1], [-1, 1], [1, 1]],
    5: [[-1, -1], [1, -1], [0, 0], [-1, 1], [1, 1]],
    6: [[-1, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [1, 1]]
  };

  // Une rangée par série. e0 : le temps où elle apparaît, avec un seul lancer.
  // dy : le décalage vertical de la rangée. vMin, vMax : les bords de l'axe.
  const RANGEES = [
    { des: 2, e0: 0, dy: 0, vMin: 0.75, vMax: 6.25, cote: 46, pasMax: 50, c: 64, ecart: 16, rouge: false },
    { des: 10, e0: 2, dy: 260, vMin: 0.95, vMax: 6.05, cote: 10, pasMax: 12, c: 34, ecart: 8, rouge: true }
  ].map((r) => {
    const serie = DES.find((d) => d.des === r.des);
    return {
      ...r,
      serie,
      faces: [...serie.faces].map(Number),
      base: 200 + r.dy,
      x: (v) => X0 + ((v - r.vMin) / (r.vMax - r.vMin)) * LARGEUR,
      titre: `${r.des} dés`
    };
  });

  // Le temps : 1 et 3 sont les avances rapides, de 1 à 1 000 lancers.
  const DUREE = { 1: 2000, 3: 2000 };
  let t = $state(0);
  let tPour = $state(-1); // le temps à qui appartient t (évite un éclair de l'image finale)
  $effect(() => {
    if (!DUREE[e]) return;
    const fin = DUREE[e];
    tPour = e;
    t = 0;
    if (typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches) {
      t = fin;
      return;
    }
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = Math.min(fin, now - debut);
      if (t < fin) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const tt = $derived(tPour === e ? t : 0);
  const fini = $derived(!DUREE[e] || tt >= DUREE[e]);

  const virgule = (v) => v.toFixed(1).replace('.', ',');
  const milliers = (n) => String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ' ');

  // Les dés d'un lancer : une rangée pour 2 dés, deux rangées de 5 pour 10.
  const placerDes = (faces, r) => {
    const parRangee = Math.min(5, faces.length);
    const rangees = Math.ceil(faces.length / parRangee);
    const larg = parRangee * r.c + (parRangee - 1) * r.ecart;
    const haut = rangees * r.c + (rangees - 1) * r.ecart;
    const x0 = GAUCHE - larg / 2, y0 = r.dy + 88 - haut / 2;
    return faces.map((f, i) => {
      const x = x0 + (i % parRangee) * (r.c + r.ecart);
      const y = y0 + Math.floor(i / parRangee) * (r.c + r.ecart);
      return {
        x, y,
        points: POINTS[f].map(([dx, dy]) => ({ cx: x + r.c / 2 + dx * r.c * 0.27, cy: y + r.c / 2 + dy * r.c * 0.27 }))
      };
    });
  };

  // L'état de chaque rangée : combien de lancers, les piles, la taille des carrés.
  const ETATS = $derived(
    RANGEES.map((r) => {
      const N = r.serie.n;
      let n;
      if (e < r.e0) n = 0;
      else if (e === r.e0) n = 1;
      else if (e === r.e0 + 1 && !fini) n = Math.min(N, Math.max(1, Math.round(N ** (tt / DUREE[e]))));
      else n = N;
      let piles;
      if (n === N) piles = r.serie.effectifs;
      else {
        piles = r.serie.valeurs.map(() => 0);
        for (let i = 0; i < n; i++) {
          let total = 0;
          for (let j = 0; j < r.des; j++) total += r.faces[i * r.des + j];
          piles[total - r.des]++;
        }
      }
      const pas = Math.min(r.pasMax, HAUT / Math.max(1, ...piles));
      const jeu = pas >= 20 ? 4 : pas >= 6 ? 2 : 0;
      const k = Math.max(0, n - 1); // le lancer affiché à gauche : le dernier
      const faces = r.faces.slice(k * r.des, (k + 1) * r.des);
      const moyenne = faces.reduce((a, b) => a + b, 0) / r.des;
      return {
        vu: n > 0,
        n,
        piles,
        pas,
        jeu,
        des: placerDes(faces, r),
        moyenne,
        compteur: `${milliers(Math.max(1, n))} ${n > 1 ? 'lancers' : 'lancer'}`
      };
    })
  );

  // La plus petite des 1 000 moyennes de 10 dés, lue dans les effectifs.
  const DIX = RANGEES[1].serie;
  const PLUS_PETITE = DIX.valeurs[DIX.effectifs.findIndex((c) => c > 0)];

  // Le récit, en bas : une ou deux lignes selon le temps.
  const recit = $derived.by(() => {
    if (e === 0) return ['Je lance 2 dés et je prends la moyenne.', ''];
    if ((e === 1 || e === 3) && !fini) return ['1 000 fois.', ''];
    if (e === 1) return ['3,5 arrive de plusieurs façons : 1 et 6, 2 et 5, 3 et 4.', 'Une moyenne de 1, une seule façon : deux 1.'];
    if (e === 2) return ['Et avec 10 dés ?', ''];
    if (e === 3) return ['Pour avoir une moyenne de 1, il faut dix 1. Presque jamais.', `En 1 000 lancers, aucune moyenne sous ${virgule(PLUS_PETITE)}.`];
    return ['Une moyenne de beaucoup de hasards : une cloche.', 'Un échantillon de 50 personnes, c’est comme 50 dés.'];
  });
</script>

<div class="visuel des-moyenne" bind:this={hote}>
  <svg viewBox="0 0 1000 585" role="img" aria-label="Je lance 2 dés et je pose un carré au-dessus de leur moyenne. Après 1 000 lancers, les carrés forment un triangle, avec 3,5 au sommet : 3,5 arrive de plusieurs façons, une moyenne de 1 d’une seule. Avec 10 dés, 1 000 lancers forment une cloche : une moyenne de 1 demande dix 1, presque jamais. Une moyenne de beaucoup de hasards fait une cloche. Un échantillon de 50 personnes, c’est comme 50 dés.">
    <text x="980" y="22" class="dm-note">simulation</text>
    {#each RANGEES as r, i}
      {@const s = ETATS[i]}
      <g class="dm-rangee" class:dm-vu={s.vu}>
        <!-- À gauche : le titre, les dés du lancer, leur moyenne, le compteur. -->
        <text x={GAUCHE} y={r.dy + 36} class="dm-titre" class:dm-rouge={r.rouge}>{r.titre}</text>
        {#each s.des as d}
          <rect x={d.x} y={d.y} width={r.c} height={r.c} class="dm-face" />
          {#each d.points as pt}
            <circle cx={pt.cx} cy={pt.cy} r={r.c * 0.09} class="dm-point" />
          {/each}
        {/each}
        <text x={GAUCHE} y={r.dy + 158} class="dm-moyenne">moyenne&#8239;: {virgule(s.moyenne)}</text>
        <text x={GAUCHE} y={r.dy + 192} class="dm-compteur">{s.compteur}</text>

        <!-- À droite : les piles au-dessus de chaque moyenne possible. -->
        {#each s.piles as c, k}
          {@const xc = r.x(r.serie.valeurs[k])}
          {#if s.jeu > 0}
            {#each { length: c } as _, j}
              <rect x={xc - r.cote / 2} y={r.base - (j + 1) * s.pas} width={r.cote} height={s.pas - s.jeu} class="dm-carre" class:dm-rouge={r.rouge || s.n === 1} />
            {/each}
          {:else}
            <rect x={xc - r.cote / 2} y={r.base - c * s.pas} width={r.cote} height={c * s.pas} class="dm-carre" class:dm-rouge={r.rouge} />
          {/if}
          {#if s.n === 1 && c > 0}
            <text x={xc} y={r.base - s.pas - 12} class="dm-valeur">{virgule(r.serie.valeurs[k])}</text>
          {/if}
        {/each}
        <line x1={X0} y1={r.base} x2={X0 + LARGEUR} y2={r.base} class="dm-sol" />
        {#each [1, 2, 3, 4, 5, 6] as v}
          <line x1={r.x(v)} y1={r.base} x2={r.x(v)} y2={r.base + 7} class="dm-sol" />
          <text x={r.x(v)} y={r.base + 30} class="dm-grad">{v}</text>
        {/each}
      </g>
    {/each}
    <line x1="30" y1="246" x2="970" y2="246" class="dm-filet dm-rangee" class:dm-vu={e >= 2} />

    <!-- Le récit. -->
    {#key recit[0] + recit[1]}
      <text x="500" y="536" class="dm-phrase">{recit[0]}</text>
      <text x="500" y="570" class="dm-sous" class:dm-lien={e === 4}>{recit[1]}</text>
    {/key}
  </svg>
</div>

<style>
  .des-moyenne { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .dm-note { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .dm-titre { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .dm-titre.dm-rouge { fill: var(--dk-accent); }
  .dm-face { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .dm-point { fill: var(--dk-encre); }
  .dm-moyenne { font-size: 22px; text-anchor: middle; fill: var(--dk-encre); }
  .dm-compteur { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .dm-carre { fill: var(--dk-encre); }
  .dm-carre.dm-rouge { fill: var(--dk-accent); }
  .dm-valeur { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .dm-sol { stroke: var(--dk-encre); stroke-width: 2; }
  .dm-filet { stroke: var(--dk-gris-2); stroke-width: 2; }
  .dm-grad { font-size: 18px; text-anchor: middle; fill: var(--dk-encre); }
  .dm-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); animation: dm-entree 0.5s; }
  .dm-sous { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); animation: dm-entree 0.5s; }
  .dm-sous.dm-lien { font-weight: 600; fill: var(--dk-accent); }
  .dm-rangee { opacity: 0; transition: opacity 0.3s; }
  .dm-rangee.dm-vu { opacity: 1; transition: opacity 0.6s; }
  @keyframes dm-entree { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .dm-rangee, .dm-rangee.dm-vu { transition: none; }
    .dm-phrase, .dm-sous { animation: none; }
  }
</style>
