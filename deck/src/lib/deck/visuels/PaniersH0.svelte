<script>
  /**
   * Le lot juste à 100 g, construit panier par panier, pour une seule
   * question : si l'acheteur avait raison, un panier comme le sien serait-il
   * rare ? 100 g n'est pas le poids « normal » des pommes : c'est l'exigence
   * de l'acheteur, la limite. On imagine un lot pile à cette limite.
   * Une idée par temps, une phrase en haut (qui change à chaque temps), le
   * dessin au milieu, puis la conversation reprend en bulles : la
   * pomicultrice (à gauche) et l'acheteur (à droite), comme dans les diapos
   * d'avant. Tout vient de PANIERS (src/lib/data/seance5_normale.js,
   * simulation d'outils/seance5_normale.R, pommes fictives, dit à l'écran)
   * et de POMMES (src/lib/data/seance5.js : 50 pommes par panier, 100 g,
   * 105 g).
   *
   * C'est le lot à 100 g, pas « le monde de H0 » : H0 dit « 100 g ou
   * moins », et la diapo PourquoiH0 explique pourquoi on ne construit que
   * celui-là.
   *
   * Avec panier = 105 (la diapo principale), six temps :
   *   0  « Imaginons que l'acheteur a raison : un lot juste à 100 g » :
   *      l'axe des poids et la ligne pointillée de 100 g, vides.
   *   1  Un panier de 50 pommes tombe sur l'axe, à son poids moyen :
   *      PANIERS.moyennes[0] (100,7 g).
   *   2  Un autre panier, un autre poids : PANIERS.moyennes[1] (97,3 g). Le
   *      premier pâlit.
   *   3  Mille paniers : les deux paniers s'effacent, les bâtons montent en
   *      trois secondes (requestAnimationFrame), une cloche autour de 100 g.
   *      L'état final est fixé : dès le temps 4, ou après trois secondes, les
   *      1 000 paniers sont tous là, toujours les mêmes.
   *   4  Son panier, 105 g, en rouge; les bâtons de 105 g ou plus passent au
   *      rouge; le compte, PANIERS.auMoins105 (27) sur 1 000.
   *   5  La phrase du haut s'efface; la pomicultrice : « Si tu avais raison,
   *      un panier comme le mien arriverait environ 3 fois sur 100. »
   *   6  L'acheteur : « C'est rare. Je ne crois plus à la chance. » Et, en
   *      bas à gauche, la phrase du cours : « On rejette H0. », puis le
   *      seuil, à l'écran une seule fois dans le deck : « Si c'était le
   *      hasard, ça arriverait moins de 5 fois sur 100. », et le lien avec
   *      la marge d'erreur : « 5 sur 100, c'est le 1 sur 20 de la marge
   *      d'erreur. » (le 19 sur 20 de la diapo « 19 fois sur 20 »).
   * Avec panier = 102 (la diapo « et si »), le monde est déjà construit,
   * trois temps (ramenés à 3, 4 et 6 ci-dessus; la bulle de la
   * pomicultrice est sautée) :
   *   0  Les 1 000 paniers, la cloche.
   *   1  Un panier de 102 g, et le compte, PANIERS.auMoins102 (217) sur 1 000.
   *   2  L'acheteur : « 22 fois sur 100 ? Ça peut être la chance. Pas
   *      convaincu. » En bas : « On ne rejette pas H0 : on ne peut pas
   *      conclure. », puis la raison, comparée au seuil de la diapo
   *      principale : « 22 fois sur 100, c'est bien plus que 5. » (Ça ne
   *      prouve pas que le lot pèse 100 g ou moins, Arel-Bundock 2021,
   *      p. 75.)
   *
   * « Environ k fois sur 100 » est le compte sur 1 000 divisé par 10 et
   * arrondi : un seul chiffre à l'écran, celui de la simulation. Le seuil
   * de « rare », SEUIL (5 fois sur 100), décide de rare et donne le 5 et le
   * « 1 sur 20 » affichés : une seule constante.
   *
   * Les bulles : carrées, filet de 2, une petite pointe qui descend vers le
   * nom de qui parle. Leur largeur se calcule sur la plus longue ligne
   * (Plex Mono : 0,6 em par caractère).
   *
   * Remanié le 1er octobre 2026 : le professeur ne comprenait pas l'ancienne
   * version (dix paniers d'un coup, un titre long, un verdict technique).
   * Le même jour, plus rien ne laisse croire que 100 g est le poids moyen
   * connu des pommes : c'est l'exigence de l'acheteur. Les conclusions
   * passent en bulles.
   */
  import { brancherTemps } from '../temps.js';
  import { PANIERS } from '$lib/data/seance5_normale.js';
  import { POMMES } from '$lib/data/seance5.js';
  let { panier = POMMES.moyenne } = $props();
  const rapide = panier !== POMMES.moyenne;
  let e = $state(0);
  let hote = $state(null);
  const TOTAL = rapide ? 2 : 6;
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, '\u202f');
  const N = '\u202f';
  // Les temps, ramenés à ceux de la diapo principale (102 g : 3, 4, puis 6).
  const T = $derived(rapide ? [3, 4, 6][e] : e);

  const G0 = 90, G1 = 110, X0 = 70, X1 = 930, BASE = 350, HAUT = 200;
  const x = (g) => X0 + ((g - G0) / (G1 - G0)) * (X1 - X0);
  const B = PANIERS.bornes, M = PANIERS.moyennes;
  const L = x(B[1]) - x(B[0]);
  const tranche = (m) => Math.min(B.length - 2, Math.max(0, Math.floor((m - B[0]) / (B[1] - B[0]))));
  const MAX = Math.max(...PANIERS.effectifs);
  const H0 = POMMES.h0, NB_POMMES = POMMES.n, TOUS = f(PANIERS.n);

  // 1 et 2 : deux paniers, dessinés, posés sur l'axe à leur poids moyen.
  // Cinq rangées de dix pommes : POMMES.n = 50.
  const POMMES_PANIER = Array.from({ length: NB_POMMES }, (_, i) => ({ dx: ((i % 10) - 4.5) * 5, dy: -6 - Math.floor(i / 10) * 5.4 }));
  const DEUX = [0, 1].map((i) => ({ i, m: M[i], cx: x(M[i]) }));

  // 3 : les mille paniers arrivent en trois secondes; état final déterministe.
  const DUREE = 3000;
  let t = $state(0);
  $effect(() => {
    if (T !== 3 || rapide) return;
    t = 0;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const combien = $derived(T < 3 ? 0 : T > 3 || rapide ? M.length : Math.min(M.length, Math.round((t / DUREE) * M.length)));
  const COMPTES = $derived.by(() => {
    const c = new Array(B.length - 1).fill(0);
    for (let i = 0; i < combien; i++) c[tranche(M[i])]++;
    return c;
  });

  const XP = x(panier);
  const nb = panier === POMMES.moyenne ? PANIERS.auMoins105 : PANIERS.auMoins102;
  const sur100 = Math.round(nb / 10);
  // Le seuil de « rare » : moins de SEUIL fois sur 100.
  const SEUIL = 5;
  const rare = nb / PANIERS.n < SEUIL / 100;

  // La phrase du haut, une par temps : [principale, secondaire]. Plus de
  // phrase à partir du temps 5 : les bulles prennent le relais.
  const PHRASES = rapide
    ? {
        3: [`Le même lot, juste à ${H0} g.`, `${TOUS} paniers, une cloche autour de ${H0} g`],
        4: [`Un panier de ${panier} g.`, `Combien de ces paniers pèsent autant${N}?`]
      }
    : {
        0: ['Imaginons que l’acheteur a raison.', `Un lot juste à ${H0} g.`],
        1: [`On y prend un panier de ${NB_POMMES} pommes.`, `Il pèse ${f(M[0], 1)} g en moyenne.`],
        2: [`Un autre panier${N}: un autre poids.`, `Celui-ci pèse ${f(M[1], 1)} g.`],
        3: [`On remplit ${TOUS} paniers.`, `Ils s’empilent en cloche autour de ${H0} g.`],
        4: [`Son panier pèse ${panier} g.`, `Combien de ces paniers pèsent autant${N}?`]
      };
  const phrase = $derived(PHRASES[T]);

  // Les bulles. Plex Mono : 0,6 em par caractère, 21 unités, marges de 18.
  const FS = 21, LH = 28, MX = 18;
  const largeur = (lignes) => Math.ceil(Math.max(...lignes.map((l) => l.length)) * 0.6 * FS) + 2 * MX;
  const hauteur = (lignes) => lignes.length * LH + 20;
  const bulle = (qui, cote, lignes, xy) => {
    const w = largeur(lignes);
    return { qui, cote, lignes, w, h: hauteur(lignes), x: cote === 'g' ? xy[0] : xy[0] - w, y: xy[1] };
  };
  // 5 : la pomicultrice, en haut à gauche (la phrase du haut s'est effacée).
  const ELLE = bulle('la pomicultrice', 'g', ['Si tu avais raison, un panier comme le mien', `arriverait environ ${sur100} fois sur 100.`], [40, 30]);
  // 6 : l'acheteur, en bas à droite, sous le titre de l'axe.
  const LUI = rare
    ? bulle('l’acheteur', 'd', ['C’est rare.', 'Je ne crois plus à la chance.'], [980, 418])
    : bulle('l’acheteur', 'd', [`${sur100} fois sur 100${N}? Ça peut être la chance.`, 'Pas convaincu.'], [980, 418]);
  // 6 : la phrase du cours, en bas à gauche, puis sa raison en plus petit
  // (le seuil; pour 102 g, la comparaison au seuil). Le lien avec la marge
  // d'erreur, en gris, sur la diapo principale seulement.
  const COURS = rare ? ['On rejette H0.'] : [`On ne rejette pas H0${N}:`, 'on ne peut pas conclure.'];
  const RAISON = rare
    ? ['Si c’était le hasard, ça arriverait', `moins de ${SEUIL} fois sur 100.`]
    : [`${sur100} fois sur 100, c’est bien plus que ${SEUIL}.`];
  const LIEN = rare ? `${SEUIL} sur 100, c’est le 1 sur ${100 / SEUIL} de la marge d’erreur.` : '';
  // Sous la phrase du cours. Pour 102 g, la raison descend sous la bulle de
  // l'acheteur (elle est plus large que la bulle n'est loin).
  const Y_COURS = LUI.y + 30;
  const Y_RAISON = rare ? Y_COURS + 28 : LUI.y + LUI.h + 20;

  const ARIA = [
    'Simulation, pommes fictives.',
    `Imaginons que l’acheteur a raison${N}: un lot juste à ${H0} g.`,
    `On remplit ${TOUS} paniers de ${NB_POMMES} pommes. Ils forment une cloche autour de ${H0} g.`,
    `${f(nb)} paniers sur ${TOUS} pèsent ${panier} g ou plus.`,
    rapide ? '' : `La pomicultrice${N}: ${ELLE.lignes.join(' ')}`,
    `L’acheteur${N}: ${LUI.lignes.join(' ')}`,
    COURS.join(' '),
    RAISON.join(' '),
    LIEN
  ].filter(Boolean).join(' ');
</script>

<div class="visuel paniers-h0" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={ARIA}>
    {#snippet dire(b)}
      {@const bx = b.cote === 'g' ? b.x + 22 : b.x + b.w - 22}
      {@const s = b.cote === 'g' ? 1 : -1}
      <rect x={b.x} y={b.y} width={b.w} height={b.h} class="bu-cadre" />
      <path d="M {bx} {b.y + b.h - 1.5} L {bx} {b.y + b.h + 16} L {bx + s * 20} {b.y + b.h - 1.5}" class="bu-pointe" />
      {#each b.lignes as l, i}
        <text x={b.x + MX} y={b.y + 30 + i * LH} class="bu-t">{l}</text>
      {/each}
      <text x={bx} y={b.y + b.h + 35} class="bu-qui" class:bu-droite={b.cote === 'd'}>{b.qui}</text>
    {/snippet}

    <text x="990" y="22" class="ph-note">simulation · pommes fictives</text>

    <!-- La phrase du temps (jusqu'au temps 4). -->
    {#key T}
      {#if phrase}
        <g class="ph-phrase">
          <text x="40" y="54" class="ph-titre">{phrase[0]}</text>
          <text x="40" y="86" class="ph-sous">{phrase[1]}</text>
        </g>
      {/if}
    {/key}

    <!-- 3 : mille paniers. -->
    {#each COMPTES as c, j}
      {@const h = (c / MAX) * HAUT}
      <rect x={x(B[j]) + 1} y={BASE - h} width={L - 2} height={h} class="ph-baton" class:ph-rouge={T >= 4 && B[j] >= panier - 1e-9} />
    {/each}

    <!-- L'axe, et 100 g. -->
    <line x1={x(H0)} y1="112" x2={x(H0)} y2={BASE} class="ph-h0" />
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="ph-axe" />
    {#each [90, 95, 100, 105, 110] as g}
      <line x1={x(g)} y1={BASE} x2={x(g)} y2={BASE + 8} class="ph-axe" />
      <text x={x(g)} y={BASE + 30} class="ph-tick" class:ph-cent={g === H0}>{g} g</text>
    {/each}
    <text x={X1} y={BASE + 54} class="ph-tick ph-fin">poids moyen du panier</text>

    <!-- 1 et 2 : deux paniers, dessinés. -->
    {#each DEUX as d}
      <g class="ph-panier ph-etape" class:ph-vu={T >= d.i + 1 && T <= 2} class:ph-ancien={T === 2 && d.i === 0}>
        {#each POMMES_PANIER as p}
          <circle cx={d.cx + p.dx} cy={BASE + p.dy} r="2.3" class="ph-pomme" />
        {/each}
        <path d="M {d.cx - 32} {BASE - 34} L {d.cx - 25} {BASE} L {d.cx + 25} {BASE} L {d.cx + 32} {BASE - 34}" class="ph-osier" />
        <text x={d.cx} y={BASE - 48} class="ph-poids">{f(d.m, 1)} g</text>
      </g>
    {/each}

    <!-- 4 : son panier, et le compte. -->
    <g class="ph-etape" class:ph-vu={T >= 4}>
      <line x1={XP} y1="120" x2={XP} y2={BASE} class="ph-notre" />
      <circle cx={XP} cy={BASE} r="9" class="ph-point" />
      <text x={XP + 14} y="146" class="ph-lab">{rare ? 'son panier' : 'un panier'}&#8239;: {panier} g</text>
      <text x={XP + 14} y="180" class="ph-compte">{f(nb)} sur {TOUS}</text>
      <text x={XP + 14} y="206" class="ph-lab-s">pèsent {panier} g ou plus</text>
    </g>

    <!-- 5 : la pomicultrice répond (diapo principale seulement). -->
    {#if !rapide}
      <g class="ph-etape" class:ph-vu={T >= 5}>{@render dire(ELLE)}</g>
    {/if}

    <!-- 6 : l'acheteur, puis la phrase du cours. -->
    <g class="ph-etape" class:ph-vu={T >= 6}>{@render dire(LUI)}</g>
    <g class="ph-etape ph-apres" class:ph-vu={T >= 6}>
      {#each COURS as c, i}
        <text x="40" y={Y_COURS + i * LH} class="ph-cours">{c}</text>
      {/each}
      {#each RAISON as r, i}
        <text x="40" y={Y_RAISON + i * 22} class="ph-raison">{r}</text>
      {/each}
      {#if LIEN}
        <text x="40" y={Y_RAISON + RAISON.length * 22 + 4} class="ph-lien">{LIEN}</text>
      {/if}
    </g>
  </svg>
</div>

<style>
  .paniers-h0 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ph-note { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .ph-phrase { animation: ph-fondu 0.5s ease-out both; }
  @keyframes ph-fondu { from { opacity: 0; } to { opacity: 1; } }
  .ph-titre { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .ph-sous { font-size: 21px; fill: var(--dk-gris); }
  .ph-pomme { fill: var(--dk-gris); }
  .ph-osier { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .ph-poids { font-size: 26px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }
  .ph-panier { transition: opacity 0.4s; }
  .ph-panier.ph-vu.ph-ancien { opacity: 0.3; }
  .ph-baton { fill: var(--dk-encre); transition: fill 0.4s; }
  .ph-baton.ph-rouge { fill: var(--dk-accent); }
  .ph-h0 { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 8 6; }
  .ph-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .ph-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ph-cent { font-weight: 600; fill: var(--dk-encre); }
  .ph-fin { text-anchor: end; }
  .ph-notre { stroke: var(--dk-accent); stroke-width: 4; }
  .ph-point { fill: var(--dk-accent); }
  .ph-lab { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .ph-compte { font-size: 30px; font-weight: 600; fill: var(--dk-accent); }
  .ph-lab-s { font-size: 19px; fill: var(--dk-encre); }
  .ph-cours { font-size: 24px; font-weight: 600; fill: var(--dk-accent); }
  .ph-raison { font-size: 18px; fill: var(--dk-encre); }
  .ph-lien { font-size: 17px; fill: var(--dk-gris); }
  .bu-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .bu-pointe { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: miter; }
  .bu-t { font-size: 21px; fill: var(--dk-encre); }
  .bu-qui { font-size: 17px; font-weight: 600; fill: var(--dk-gris); }
  .bu-qui.bu-droite { text-anchor: end; }
  .ph-etape { opacity: 0; transition: opacity 0.2s; }
  .ph-etape.ph-vu { opacity: 1; transition: opacity 0.5s; }
  .ph-etape.ph-apres.ph-vu { transition: opacity 0.5s 0.7s; }
  @media (prefers-reduced-motion: reduce) {
    .ph-phrase { animation: none; }
    .ph-etape, .ph-etape.ph-vu, .ph-etape.ph-apres.ph-vu, .ph-panier, .ph-baton { transition: none; }
  }
</style>
