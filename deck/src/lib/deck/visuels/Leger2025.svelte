<script>
  /**
   * D'où viennent les répondant.e.s de l'Étude électorale canadienne 2025
   * (codebook, p. 9-10) : un échantillon en ligne tiré du panel de Léger,
   * avec des cibles par région et un équilibre de genre et d'âge (des
   * quotas), puis des poids calculés par ratissage (raking). N et l'âge
   * moyen viennent de POP (src/lib/data/seance5.js), sans pondération.
   *
   *   0  Le chemin, en trois boîtes : le panel en ligne, les quotas, les
   *      N répondant.e.s. Une quatrième case est réservée, vide.
   *   1  Un tampon rouge sur le chemin : « pas un échantillon aléatoire
   *      simple »; la quatrième boîte arrive, la pondération.
   *   2  Une bande à part : aujourd'hui, pour apprendre, ces N
   *      répondant.e.s sont notre population, et on connaît leur âge moyen.
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const n = f(POP.n);
  const age = f(POP.moyenne, 1);

  // Quatre cases fixes : rien ne bouge quand la quatrième arrive.
  const W = 215, PAS = 255, BY = 40, BH = 130;
  const bx = (k) => 10 + k * PAS;
  const cx = (k) => bx(k) + W / 2;
  const YC = BY + BH / 2;
  // Le tampon : centré sous les trois premières boîtes.
  const TX = (bx(0) + bx(2) + W) / 2, TY = 196;
</script>

<div class="visuel leger2025" bind:this={hote}>
  <svg viewBox="0 0 1000 450" role="img" aria-label="Étude électorale canadienne 2025 : un panel en ligne de Léger, des quotas de région, de genre et d’âge, {n} répondant.e.s. Ce n’est pas un échantillon aléatoire simple : des poids corrigent les écarts. Aujourd’hui, ces {n} répondant.e.s sont notre population. Leur âge moyen est de {age} ans.">
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

    <text x={cx(2)} y={YC + 2} class="lg-n">{n}</text>
    <text x={cx(2)} y={YC + 34} class="lg-t">répondant.e.s</text>

    <!-- 1 : la pondération, puis le tampon. -->
    <g class="lg-quatre" class:lg-vu={e >= 1}>
      <path d="M {bx(2) + W + 8} {YC} H {bx(3) - 8} M {bx(3) - 18} {YC - 8} L {bx(3) - 8} {YC} L {bx(3) - 18} {YC + 8}" class="lg-fleche" />
      <rect x={bx(3)} y={BY} width={W} height={BH} class="lg-boite" />
      <text x={cx(3)} y={YC - 30} class="lg-t lg-fort">la pondération&#8239;:</text>
      <text x={cx(3)} y={YC - 2} class="lg-t">des poids</text>
      <text x={cx(3)} y={YC + 24} class="lg-t">corrigent</text>
      <text x={cx(3)} y={YC + 50} class="lg-t">les écarts</text>
    </g>
    <g transform="translate({TX} {TY}) rotate(-3)">
      <g class="lg-tampon" class:lg-vu={e >= 1}>
        <rect x="-246" y="-24" width="492" height="48" class="lg-tampon-r" />
        <text x="0" y="8" class="lg-tampon-t">pas un échantillon aléatoire simple</text>
      </g>
    </g>

    <!-- 2 : la bande à part. -->
    <g class="lg-bande" class:lg-vu={e >= 2}>
      <rect x="10" y="252" width="980" height="156" class="lg-fond" />
      <line x1="10" y1="252" x2="990" y2="252" class="lg-filet" />
      <text x="40" y="292" class="lg-phrase lg-fort">Aujourd’hui, pour apprendre&#8239;:</text>
      <text x="40" y="324" class="lg-phrase">les {n} répondant.e.s sont notre population.</text>
      <text x="40" y="382" class="lg-phrase">Leur âge moyen, on le connaît&#8239;: <tspan class="lg-age">{age} ans</tspan></text>
    </g>

    <text x="10" y="440" class="lg-source">Étude électorale canadienne 2025, codebook, p. 9-10</text>
  </svg>
</div>

<style>
  .leger2025 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }

  .lg-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .lg-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .lg-t { font-size: 20px; text-anchor: middle; fill: var(--dk-encre); }
  .lg-fort { font-weight: 600; }
  .lg-gris { fill: var(--dk-gris); }
  .lg-n { font-size: 42px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); letter-spacing: -0.02em; }

  .lg-quatre { opacity: 0; transition: opacity 0.2s; }
  .lg-quatre.lg-vu { opacity: 1; transition: opacity 0.4s 0.7s; }

  .lg-tampon { transform-box: fill-box; transform-origin: center; opacity: 0; transform: scale(1.4); transition: opacity 0.2s, transform 0.2s; }
  .lg-tampon.lg-vu { opacity: 1; transform: scale(1); transition: opacity 0.15s, transform 0.35s cubic-bezier(0.5, 0, 0.75, 0); }
  .lg-tampon-r { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .lg-tampon-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: 0.02em; }

  .lg-bande { opacity: 0; transform: translateY(12px); transition: opacity 0.2s, transform 0.2s; }
  .lg-bande.lg-vu { opacity: 1; transform: none; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
  .lg-fond { fill: var(--dk-fond-2); }
  .lg-filet { stroke: var(--dk-encre); stroke-width: 3; }
  .lg-phrase { font-size: 24px; fill: var(--dk-encre); }
  .lg-age { font-size: 34px; font-weight: 600; fill: var(--dk-accent); }
  .lg-source { font-size: 17px; fill: var(--dk-gris-2); letter-spacing: 0.04em; }

  @media (prefers-reduced-motion: reduce) {
    .lg-quatre, .lg-quatre.lg-vu, .lg-tampon, .lg-tampon.lg-vu, .lg-bande, .lg-bande.lg-vu { transition: none; }
    .lg-tampon, .lg-bande { transform: none; }
  }
</style>
