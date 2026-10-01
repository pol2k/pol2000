<script>
  /**
   * D'où viennent les répondant.e.s de l'Étude électorale canadienne 2025
   * (codebook, p. 9-10) : un échantillon en ligne tiré du panel de Léger,
   * avec des cibles par région et un équilibre de genre et d'âge (des
   * quotas), puis des poids calculés par ratissage (raking). Ces N
   * personnes sont un échantillon, pas la population.
   *
   *   0  Le chemin, en trois boîtes : le panel en ligne, les quotas,
   *      l'échantillon de N répondant.e.s. Une quatrième case est réservée.
   *   1  Un tampon rouge sur le chemin : « pas un échantillon aléatoire
   *      simple »; la quatrième boîte arrive, la pondération.
   *   2  L'âge moyen, en grands chiffres : Statistique Canada (adultes de
   *      18 ans et plus, 1er juillet 2025) contre la CES brute, et l'écart.
   *   3  La CES pondérée, et son écart, plus petit.
   *
   * Mêmes noms et mêmes couleurs que la diapositive suivante (EecCanada) :
   * gris pour Statistique Canada, rouge pour la CES brute, noir pour la CES
   * pondérée. Ce sont des estimations de population (tableau
   * 17-10-0005-01), pas le recensement.
   *
   * N vient de POP (src/lib/data/seance5.js). Les trois moyennes viennent
   * de RECENSEMENT (src/lib/data/seance5_normale.js,
   * outils/seance5_normale.R); les écarts sont calculés ici à partir d'elles.
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance5.js';
  import { RECENSEMENT as R } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, '\u202F');
  const n = f(POP.n);
  // L'écart à Statistique Canada, en mots : « 1,1 an de plus ».
  const ecart = (m) => {
    const d = Math.round((m - R.moyenneStatcan) * 10) / 10;
    if (d === 0) return 'le même âge';
    return `${f(Math.abs(d), 1)} ${Math.abs(d) < 2 ? 'an' : 'ans'} de ${d > 0 ? 'plus' : 'moins'}`;
  };

  // Quatre cases fixes : rien ne bouge quand la quatrième arrive.
  const W = 215, PAS = 255, BY = 40, BH = 130;
  const bx = (k) => 10 + k * PAS;
  const cx = (k) => bx(k) + W / 2;
  const YC = BY + BH / 2;
  // Le tampon : centré sous les trois premières boîtes.
  const TX = (bx(0) + bx(2) + W) / 2, TY = 196;

  // La comparaison : trois colonnes.
  const COL = [170, 500, 830];
  const MOY = [
    { nom: 'Statistique Canada', m: R.moyenneStatcan, trait: 'lg-bat', ecart: '' },
    { nom: 'CES brute', m: R.moyenneCes, trait: 'lg-brut', ecart: ecart(R.moyenneCes) },
    { nom: 'CES pondérée', m: R.moyenneCesPondere, trait: 'lg-pond', ecart: ecart(R.moyenneCesPondere) }
  ];
</script>

<div class="visuel leger2025" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Étude électorale canadienne 2025 : un panel en ligne de Léger, des quotas de région, de genre et d’âge, un échantillon de {n} répondant.e.s. Ce n’est pas un échantillon aléatoire simple : des poids corrigent les écarts. L’âge moyen des adultes : {f(R.moyenneStatcan, 1)} ans selon Statistique Canada, {f(R.moyenneCes, 1)} ans dans la CES brute, {f(R.moyenneCesPondere, 1)} ans dans la CES pondérée.">
    <!-- Les trois premières boîtes et leurs flèches. -->
    {#each [0, 1, 2] as k}
      <rect x={bx(k)} y={BY} width={W} height={BH} class="lg-boite" />
    {/each}
    {#each [0, 1] as k}
      <path d="M {bx(k) + W + 8} {YC} H {bx(k + 1) - 8} M {bx(k + 1) - 18} {YC - 8} L {bx(k + 1) - 8} {YC} L {bx(k + 1) - 18} {YC + 8}" class="lg-fleche" />
    {/each}

    <text x={cx(0)} y={YC - 22} class="lg-t lg-fort">un panel</text>
    <text x={cx(0)} y={YC + 6} class="lg-t lg-fort">en ligne</text>
    <text x={cx(0)} y={YC + 34} class="lg-t lg-gris">(Léger)</text>

    <text x={cx(1)} y={YC - 22} class="lg-t lg-fort">des quotas&#8239;:</text>
    <text x={cx(1)} y={YC + 6} class="lg-t">région,</text>
    <text x={cx(1)} y={YC + 34} class="lg-t">genre, âge</text>

    <text x={cx(2)} y={YC - 30} class="lg-t lg-fort lg-rouge">un échantillon</text>
    <text x={cx(2)} y={YC + 12} class="lg-n">{n}</text>
    <text x={cx(2)} y={YC + 42} class="lg-t">répondant.e.s</text>

    <!-- 1 : la pondération, puis le tampon. -->
    <g class="lg-quatre" class:lg-vu={e >= 1}>
      <path d="M {bx(2) + W + 8} {YC} H {bx(3) - 8} M {bx(3) - 18} {YC - 8} L {bx(3) - 8} {YC} L {bx(3) - 18} {YC + 8}" class="lg-fleche" />
      <rect x={bx(3)} y={BY} width={W} height={BH} class="lg-boite" />
      <text x={cx(3)} y={YC - 22} class="lg-t lg-fort">la pondération</text>
      <text x={cx(3)} y={YC + 6} class="lg-t">corrige</text>
      <text x={cx(3)} y={YC + 34} class="lg-t">les écarts</text>
    </g>
    <g transform="translate({TX} {TY}) rotate(-3)">
      <g class="lg-tampon" class:lg-vu={e >= 1}>
        <rect x="-246" y="-24" width="492" height="48" class="lg-tampon-r" />
        <text x="0" y="8" class="lg-tampon-t">pas un échantillon aléatoire simple</text>
      </g>
    </g>

    <!-- 2 et 3 : l'âge moyen, en grands chiffres. -->
    <g class="lg-bande" class:lg-vu={e >= 2}>
      <rect x="10" y="250" width="980" height="206" class="lg-fond" />
      <line x1="10" y1="250" x2="990" y2="250" class="lg-filet" />
      <text x="500" y="282" class="lg-t lg-gris">âge moyen des adultes</text>
    </g>
    {#each MOY as c, k}
      <g class="lg-col" class:lg-vu={e >= (k < 2 ? 2 : 3)} style="transition-delay: {e >= 2 && k === 1 ? 0.25 : 0}s">
        <text x={COL[k]} y="322" class="lg-t lg-fort">{c.nom}</text>
        <text x={COL[k]} y="392" class="lg-age">{f(c.m, 1)}<tspan class="lg-ans"> ans</tspan></text>
        {#if c.trait === 'lg-bat'}
          <rect x={COL[k] - 90} y="410" width="180" height="12" class="lg-bat" />
        {:else}
          <line x1={COL[k] - 90} y1="416" x2={COL[k] + 90} y2="416" class={c.trait} />
        {/if}
        {#if c.ecart}
          <text x={COL[k]} y="446" class="lg-t lg-gris">{c.ecart}</text>
        {/if}
      </g>
    {/each}

    <text x="10" y="490" class="lg-source">CES 2025, codebook, p. 9-10 · Statistique Canada, tableau 17-10-0005-01</text>
  </svg>
</div>

<style>
  .leger2025 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .lg-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .lg-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .lg-t { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .lg-fort { font-weight: 600; }
  .lg-gris { fill: var(--dk-gris); }
  .lg-rouge { fill: var(--dk-accent); }
  .lg-n { font-size: 42px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); letter-spacing: -0.02em; }

  .lg-quatre { opacity: 0; transition: opacity 0.2s; }
  .lg-quatre.lg-vu { opacity: 1; transition: opacity 0.4s 0.7s; }

  .lg-tampon { transform-box: fill-box; transform-origin: center; opacity: 0; transform: scale(1.4); transition: opacity 0.2s, transform 0.2s; }
  .lg-tampon.lg-vu { opacity: 1; transform: scale(1); transition: opacity 0.15s, transform 0.35s cubic-bezier(0.5, 0, 0.75, 0); }
  .lg-tampon-r { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .lg-tampon-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: 0.02em; }

  .lg-bande { opacity: 0; transition: opacity 0.2s; }
  .lg-bande.lg-vu { opacity: 1; transition: opacity 0.4s; }
  .lg-fond { fill: var(--dk-fond-2); }
  .lg-filet { stroke: var(--dk-encre); stroke-width: 3; }

  .lg-col { opacity: 0; transform: translateY(12px); transition: opacity 0.2s, transform 0.2s; }
  .lg-col.lg-vu { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .lg-age { font-size: 72px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); letter-spacing: -0.02em; }
  .lg-ans { font-size: 30px; font-weight: 400; letter-spacing: 0; }
  .lg-bat { fill: var(--dk-gris-2); }
  .lg-brut { stroke: var(--dk-accent); stroke-width: 6; }
  .lg-pond { stroke: var(--dk-encre); stroke-width: 6; }

  .lg-source { font-size: 17px; fill: var(--dk-gris-2); letter-spacing: 0.04em; }

  @media (prefers-reduced-motion: reduce) {
    .lg-quatre, .lg-quatre.lg-vu, .lg-tampon, .lg-tampon.lg-vu, .lg-bande, .lg-bande.lg-vu, .lg-col, .lg-col.lg-vu { transition: none; }
    .lg-tampon, .lg-col { transform: none; }
  }
</style>
