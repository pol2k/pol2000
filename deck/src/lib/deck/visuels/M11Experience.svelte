<script>
  /**
   * Une vraie expérience, sur le même carrefour que Marie (M11Carrefour) :
   * l'expérience de sondage du professeur (article en évaluation, anonymisé :
   * ni titre ni auteurs sur la diapo; source locale ~/Projects/c2t, section
   * Data and Methods). Ici, les deux routes sont
   * observées : le hasard envoie chaque répondant sur l'une ou l'autre.
   *
   *   0  la question : une réponse écrite, codée par l'IA, mesure-t-elle
   *      la même chose qu'une case à cocher ?
   *   1  le même échantillon : 3 372 répondants d'un même panel;
   *   2  l'assignation aléatoire : une pièce au carrefour, chacun part sur
   *      une route (1 687 questions fermées, 1 685 questions ouvertes);
   *   3  ce qu'on mesure : la même question, mot pour mot, en deux formats
   *      (vraie réponse citée dans l'article : la taxe carbone); 12
   *      questions, 7 sur l'environnement, 5 sur l'immigration;
   *   4  pas besoin de contrôler : les bagages (ici, le diplôme
   *      universitaire, en rouge) se répartissent pareil des deux côtés.
   *      Dans l'article : moins de 0,1 écart-type d'écart sur chaque
   *      caractéristique, sauf le type de logement;
   *   5  une limite : l'abandon après l'assignation (93,7 % terminent avec
   *      les cases, 73,4 % avec la zone de texte);
   *   6  le résultat : la même attitude, un peu moins fiable à l'écrit
   *      (alpha de Cronbach, échelle environnement : 0,891 et 0,842).
   *
   * Les 24 silhouettes représentent les 3 372 répondants : leur route, leur
   * diplôme et leur abandon sont fixés à la main (aucun hasard dans le
   * dessin), 12 de chaque côté, 6 diplômés de chaque côté.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 6, lire: () => e, ecrire: (v) => (e = v) });
  });

  const LEG = [
    'Une réponse écrite, codée par l’IA, mesure-t-elle la même chose qu’une case à cocher ?',
    'Un seul échantillon : 3 372 répondants d’un même panel.',
    'Le hasard choisit la route de chacun.',
    'Ce qu’on mesure : 12 questions, mot pour mot les mêmes dans les deux groupes.',
    'Pas besoin de contrôler : le hasard donne les mêmes bagages aux deux groupes.',
    'Une limite : plus de gens abandonnent quand il faut écrire.',
    'Le résultat : la même attitude, mesurée un peu moins fiablement à l’écrit.'
  ];

  // route (0 : fermées, en haut; 1 : ouvertes, en bas), diplôme, abandon
  const ROUTE = [0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1];
  const DIPLOME = [1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0];
  const FOULE = ROUTE.map((r, i) => {
    const k = ROUTE.slice(0, i).filter((x) => x === r).length; // rang dans son groupe
    return {
      r,
      dipl: DIPLOME[i] === 1,
      x0: 70 + (i % 6) * 50,
      y0: 250 + Math.floor(i / 6) * 64,
      x1: 470 + (k % 6) * 50,
      y1: (r === 0 ? 176 : 510) + Math.floor(k / 6) * 64,
      part: r === 0 ? k === 9 : [2, 7, 10].includes(k)
    };
  });
  // contrôle : 6 diplômés par groupe
  const v = (n) => n.replace('.', ',');
</script>

{#snippet personne()}
  <g class="m11x-silh">
    <circle cx="0" cy="-96" r="17" />
    <path d="M0 -79 L0 -38 M0 -70 L-20 -50 M0 -70 L20 -50 M0 -38 L-16 0 M0 -38 L16 0" />
  </g>
{/snippet}

<div class="visuel m11x" bind:this={hote}>
  <svg viewBox="0 0 1400 680" role="img" aria-label="Une expérience de sondage. 3 372 répondants arrivent à un carrefour; le hasard envoie 1 687 d’entre eux vers des questions fermées, à cocher, et 1 685 vers les mêmes questions, ouvertes, à écrire, que l’IA code ensuite. Les deux groupes ont les mêmes caractéristiques. Plus de gens abandonnent à l’écrit. Les deux formats mesurent la même attitude, un peu moins fiablement à l’écrit.">
    <!-- les routes -->
    <path d="M 30 330 L 380 330 L 820 140" class="m11x-route" />
    <path d="M 380 330 L 820 520" class="m11x-route" />
    <path d="M 30 330 L 380 330 L 820 140" class="m11x-ligne" />
    <path d="M 380 330 L 820 520" class="m11x-ligne" />

    <!-- la pièce au carrefour -->
    <g class="m11x-piece" class:m11x-vu={e >= 2} transform="translate(380 330)">
      <g class="m11x-tourne"><circle r="34" /><text y="10">?</text></g>
      <text y="-50" class="m11x-hasard">au hasard</text>
    </g>

    <!-- la foule -->
    {#each FOULE as f, i (i)}
      <g class="m11x-pers" class:m11x-parti={e >= 2} class:m11x-dipl={e >= 4 && f.dipl} class:m11x-abandon={e >= 5 && f.part}
        style="--x0: {f.x0}px; --y0: {f.y0}px; --x1: {f.x1}px; --y1: {f.y1}px; --d: {(i % 12) * 0.07}s">
        <g transform="scale(0.42)">{@render personne()}</g>
      </g>
    {/each}

    <text x="215" y="210" class="m11x-tit" class:m11x-fondu={e >= 2}>3 372 répondants</text>
    <text x="215" y="510" class="m11x-sous" class:m11x-fondu={e >= 2}>un même panel</text>

    <!-- les groupes -->
    <g class="m11x-groupe" class:m11x-vu={e >= 2}>
      <text x="595" y="56" class="m11x-tit">Questions fermées</text>
      <text x="595" y="86" class="m11x-sous">{e >= 5 ? '1 580 terminent (93,7 %)' : '1 687 répondants'}</text>
      <text x="595" y="640" class="m11x-tit m11x-r">Questions ouvertes</text>
      <text x="595" y="668" class="m11x-sous">{e >= 5 ? '1 237 terminent (73,4 %)' : '1 685 répondants'}</text>
    </g>

    <!-- les bagages : mêmes proportions -->
    <g class="m11x-bag" class:m11x-vu={e === 4}>
      <text x="740" y="338" class="m11x-egal">=</text>
      <text x="215" y="440" class="m11x-sous m11x-r">en rouge :</text>
      <text x="215" y="468" class="m11x-sous m11x-r">diplôme universitaire</text>
    </g>

    <!-- ce qu'on mesure : la même question, deux formats -->
    <g class="m11x-carte" class:m11x-vu={e >= 3 && e < 6}>
      <rect x="860" y="30" width="520" height="270" />
      <text x="884" y="70" class="m11x-q">La taxe carbone fédérale devrait</text>
      <text x="884" y="98" class="m11x-q">être maintenue comme mesure</text>
      <text x="884" y="126" class="m11x-q">environnementale.</text>
      {#each ['Fortement en désaccord', 'Plutôt en désaccord', 'Plutôt d’accord', 'Fortement d’accord'] as o, k (o)}
        <rect x="886" y={152 + k * 34} width="20" height="20" class="m11x-case" />
        <text x="918" y={169 + k * 34} class="m11x-opt">{o}</text>
      {/each}

      <rect x="860" y="380" width="520" height="270" class="m11x-rouge" />
      <text x="884" y="420" class="m11x-q">La taxe carbone fédérale devrait</text>
      <text x="884" y="448" class="m11x-q">être maintenue comme mesure</text>
      <text x="884" y="476" class="m11x-q">environnementale.</text>
      <rect x="886" y="490" width="470" height="104" class="m11x-texte" />
      <text x="900" y="520" class="m11x-rep">« Oui si les taxes sont utilisées</text>
      <text x="900" y="548" class="m11x-rep">pour développer des technologies</text>
      <text x="900" y="576" class="m11x-rep">moins polluantes »</text>
      <text x="884" y="628" class="m11x-code">codée par l’IA : « plutôt d’accord »</text>
    </g>

    <!-- le résultat -->
    <g class="m11x-res" class:m11x-vu={e >= 6}>
      <text x="884" y="200" class="m11x-sous">fiabilité, échelle environnement</text>
      <rect x="884" y="216" width="400" height="36" class="m11x-j" />
      <rect x="884" y="216" width={400 * 0.891} height="36" class="m11x-jp" />
      <text x="1300" y="245" class="m11x-val">{v('0.891')}</text>
      <text x="884" y="460" class="m11x-sous">fiabilité, échelle environnement</text>
      <rect x="884" y="476" width="400" height="36" class="m11x-j" />
      <rect x="884" y="476" width={400 * 0.842} height="36" class="m11x-jp m11x-jr" />
      <text x="1300" y="505" class="m11x-val">{v('0.842')}</text>
      <text x="1084" y="350" class="m11x-tit">même attitude, mêmes liens</text>
      <text x="1084" y="378" class="m11x-sous m11x-centre">avec l’âge, la région et le vote</text>
    </g>
  </svg>
  <p class="m11x-legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="m11x-cap">Notre expérience de sondage, panel canadien, 2025 · article en évaluation</p>
</div>

<style>
  .m11x { width: 100%; display: flex; flex-direction: column; gap: 0.25em; }
  svg { width: 100%; height: auto; max-height: 60vh; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .m11x-route { fill: none; stroke: var(--dk-fond-2); stroke-width: 70; stroke-linejoin: round; stroke-linecap: round; }
  .m11x-ligne { fill: none; stroke: var(--dk-filet); stroke-width: 4; stroke-dasharray: 22 18; }

  .m11x-piece { opacity: 0; transition: opacity 0.4s; }
  .m11x-piece.m11x-vu { opacity: 1; }
  .m11x-piece circle { fill: var(--dk-accent); }
  .m11x-piece text { fill: white; font-size: 30px; font-weight: 700; text-anchor: middle; }
  .m11x-piece .m11x-hasard { fill: var(--dk-accent); font-size: 22px; }
  .m11x-vu .m11x-tourne { animation: m11x-tourne 0.5s linear 3; }
  @keyframes m11x-tourne { 0%, 100% { transform: scaleX(1); } 50% { transform: scaleX(0.05); } }

  .m11x-silh circle { fill: var(--dk-encre); transition: fill 0.5s; }
  .m11x-silh path { stroke: var(--dk-encre); stroke-width: 9; stroke-linecap: round; fill: none; transition: stroke 0.5s; }
  .m11x-dipl .m11x-silh circle { fill: var(--dk-accent); }
  .m11x-dipl .m11x-silh path { stroke: var(--dk-accent); }
  .m11x-pers { transform: translate(var(--x0), var(--y0)); transition: opacity 0.6s; }
  .m11x-pers.m11x-parti { animation: m11x-va 1.6s ease-in-out var(--d) forwards; }
  .m11x-pers.m11x-abandon { opacity: 0.12; }
  @keyframes m11x-va {
    0% { transform: translate(var(--x0), var(--y0)); }
    45% { transform: translate(380px, 380px); }
    100% { transform: translate(var(--x1), var(--y1)); }
  }

  .m11x-tit { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.4s; }
  .m11x-sous { font-size: 21px; text-anchor: middle; fill: var(--dk-gris); transition: opacity 0.4s; }
  .m11x-r { fill: var(--dk-accent); }
  .m11x-fondu { opacity: 0; }
  .m11x-groupe, .m11x-bag, .m11x-carte, .m11x-res { opacity: 0; transition: opacity 0.5s; }
  .m11x-groupe.m11x-vu, .m11x-bag.m11x-vu, .m11x-carte.m11x-vu, .m11x-res.m11x-vu { opacity: 1; }
  .m11x-groupe { transition-delay: 1.6s; }
  .m11x-egal { font-size: 80px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }

  .m11x-carte rect:first-child, .m11x-carte > rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m11x-carte rect.m11x-rouge { stroke: var(--dk-accent); }
  .m11x-q { font-size: 22px; font-weight: 700; fill: var(--dk-encre); }
  .m11x-carte rect.m11x-case { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; }
  .m11x-opt { font-size: 20px; fill: var(--dk-encre); }
  .m11x-carte rect.m11x-texte { fill: white; stroke: var(--dk-gris-2); stroke-width: 2; }
  .m11x-rep { font-size: 19px; fill: var(--dk-encre); font-style: italic; }
  .m11x-code { font-size: 21px; font-weight: 700; fill: var(--dk-accent); }

  .m11x-res text.m11x-sous { text-anchor: start; }
  .m11x-res text.m11x-sous.m11x-centre { text-anchor: middle; }
  .m11x-j { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m11x-jp { fill: var(--dk-encre); }
  .m11x-jp.m11x-jr { fill: var(--dk-accent); }
  .m11x-val { font-size: 30px; font-weight: 700; fill: var(--dk-encre); }

  .m11x-legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .m11x-legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .m11x-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .m11x-pers.m11x-parti { animation: none; transform: translate(var(--x1), var(--y1)); }
    .m11x-vu .m11x-tourne { animation: none; }
  }
</style>
