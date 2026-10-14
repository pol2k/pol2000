<script>
  /**
   * La valeur p : vous connaissez l'idée, voici son nom. La séance 5 a fait
   * le raisonnement sans le nommer (décision de l'enseignant, pol-vjv) : la
   * pomicultrice disait « si tu avais raison, un panier comme le mien
   * arriverait environ 3 fois sur 100 ». Ce « 3 fois sur 100 », c'est une
   * valeur p. Puis la nôtre, et où R l'écrit. Trois temps.
   *
   *   0  La bulle de la pomicultrice, telle qu'à la séance 5 (PaniersH0) :
   *      « environ k fois sur 100 », k = PANIERS.auMoins105 (27) sur 1 000,
   *      divisé par 10 et arrondi, comme là-bas.
   *   1  « k fois sur 100 » passe au rouge; à droite, son nom : la valeur p.
   *      Dessous, la définition en une question : si H0 était vraie, combien
   *      de fois verrait-on un résultat au moins aussi loin que le nôtre ?
   *   2  Notre pente : H0.notre.aussi_loin (0) mélange sur 1 000 aussi loin.
   *      Dessous, l'en-tête et la ligne gauche_droite de summary(), telles
   *      que R les imprime (découpées dans SUMMARY, rien n'est retapé). Le
   *      titre de colonne Pr(>|t|) passe au rouge et la valeur est encadrée :
   *      « <2e-16 », pratiquement 0.
   *
   * Données : PANIERS (src/lib/data/seance5_normale.js), H0 et SUMMARY
   * (src/lib/data/seance7.js).
   */
  import { brancherTemps } from '../temps.js';
  import { PANIERS } from '$lib/data/seance5_normale.js';
  import { H0, SUMMARY } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const N = ' ';
  const SUR100 = Math.round(PANIERS.auMoins105 / 10);
  const TOUS = f(H0.notre.pentes.length);

  // Les deux lignes de R : l'en-tête des coefficients et la ligne gauche_droite.
  const LIGNES = SUMMARY.split('\n');
  const ENTETE = LIGNES.find((l) => /^\s+Estimate/.test(l)).trimEnd();
  const RANG = LIGNES.find((l) => l.startsWith('gauche_droite')).trimEnd();
  // La colonne p : sa position dans la ligne (Plex Mono, 0,6 em par caractère).
  const P_TXT = RANG.trim().split(/\s+/)[4];
  const P_COL = RANG.indexOf(P_TXT);
  const FR = 21, XR = 70, CH = 0.6 * FR;

  // La bulle (même dessin qu'à la séance 5).
  const FS = 22, LH = 30, MX = 18;
  const B1 = 'Si tu avais raison, un panier comme le mien';
  const B2a = 'arriverait environ ', B2b = `${SUR100} fois sur 100`, B2c = '.';
  const BW = Math.ceil(B1.length * 0.6 * FS) + 2 * MX;
  const BX = 40, BY = 24, BH = 2 * LH + 20;
</script>

<div class="visuel pente-valeur-p" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="À la séance 5, la pomicultrice{N}: si tu avais raison, un panier comme le mien arriverait environ {SUR100} fois sur 100. Ce {SUR100} fois sur 100 a un nom{N}: la valeur p. Si H0 était vraie, combien de fois verrait-on un résultat au moins aussi loin que le nôtre{N}? Notre pente{N}: {H0.notre.aussi_loin} mélange sur {TOUS} va aussi loin. Dans R, la colonne Pr(>|t|) donne {P_TXT}{N}: pratiquement 0.">
    <!-- 0 : la bulle de la séance 5. -->
    <rect x={BX} y={BY} width={BW} height={BH} class="vp-cadre" />
    <path d="M {BX + 22} {BY + BH - 1.5} L {BX + 22} {BY + BH + 16} L {BX + 42} {BY + BH - 1.5}" class="vp-pointe" />
    <text x={BX + MX} y={BY + 32} class="vp-bulle">{B1}</text>
    <text x={BX + MX} y={BY + 32 + LH} class="vp-bulle">{B2a}<tspan class="vp-morceau" class:vp-on={e >= 1}>{B2b}</tspan>{B2c}</text>
    <text x={BX + 22} y={BY + BH + 36} class="vp-qui">la pomicultrice · séance 5</text>

    <!-- 1 : son nom. -->
    <g class="vp-etape" class:vp-vu={e >= 1}>
      <path d="M {BX + BW + 18} {BY + 66} H {BX + BW + 62} M {BX + BW + 50} {BY + 56} L {BX + BW + 62} {BY + 66} L {BX + BW + 50} {BY + 76}" class="vp-fleche" />
      <text x={BX + BW + 80} y={BY + 40} class="vp-nom-s">son nom&#8239;:</text>
      <text x={BX + BW + 80} y={BY + 84} class="vp-nom">la valeur p</text>
      <text x="40" y="196" class="vp-def">Si H0 était vraie, combien de fois verrait-on</text>
      <text x="40" y="226" class="vp-def">un résultat au moins aussi loin que le nôtre&#8239;?</text>
    </g>

    <!-- 2 : la nôtre, et où R l'écrit. -->
    <g class="vp-etape" class:vp-vu={e >= 2}>
      <line x1="40" y1="258" x2="960" y2="258" class="vp-filet" />
      <text x="40" y="298" class="vp-notre">Notre pente&#8239;: {H0.notre.aussi_loin} mélange sur {TOUS} aussi loin.</text>
      <rect x={XR - 20} y="318" width="920" height="84" class="vp-console" />
      <text x={XR} y="350" class="vp-r">{ENTETE.slice(0, ENTETE.indexOf('Pr('))}<tspan class="vp-pr">Pr(&gt;|t|)</tspan>{ENTETE.slice(ENTETE.indexOf('Pr(') + 8)}</text>
      <text x={XR} y="384" class="vp-r vp-r-rang">{RANG}</text>
      <rect x={XR + P_COL * CH - 8} y="364" width={P_TXT.length * CH + 16} height="30" class="vp-cible" />
      <text x={XR + (P_COL + P_TXT.length / 2) * CH} y="436" class="vp-glose">la valeur p&#8239;: pratiquement 0</text>
      <text x="960" y="490" class="vp-src">summary(modele), notre sondage</text>
    </g>
  </svg>
</div>

<style>
  .pente-valeur-p { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .vp-cadre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .vp-pointe { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: miter; }
  .vp-bulle { font-size: 22px; fill: var(--dk-encre); }
  .vp-morceau { transition: fill 0.4s; }
  .vp-morceau.vp-on { fill: var(--dk-accent); font-weight: 600; }
  .vp-qui { font-size: 17px; font-weight: 600; fill: var(--dk-gris); }
  .vp-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-linejoin: miter; }
  .vp-nom-s { font-size: 21px; fill: var(--dk-gris); }
  .vp-nom { font-size: 40px; font-weight: 600; fill: var(--dk-accent); letter-spacing: -0.02em; }
  .vp-def { font-size: 25px; font-weight: 600; fill: var(--dk-encre); }
  .vp-filet { stroke: var(--dk-encre); stroke-width: 2; }
  .vp-notre { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .vp-console { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .vp-r { font-size: 21px; fill: var(--dk-gris); white-space: pre; }
  .vp-r-rang { fill: var(--dk-encre); font-weight: 600; }
  .vp-pr { fill: var(--dk-accent); font-weight: 600; }
  .vp-cible { fill: none; stroke: var(--dk-accent); stroke-width: 3; }
  .vp-glose { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .vp-src { font-size: 15px; text-anchor: end; fill: var(--dk-gris); }
  .vp-etape { opacity: 0; transition: opacity 0.2s; }
  .vp-etape.vp-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .vp-etape, .vp-etape.vp-vu, .vp-morceau { transition: none; }
  }
</style>
