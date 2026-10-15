<script>
  /**
   * Lire un graphique des coefficients en trois questions. Trois cartes,
   * chacune avec un petit dessin tiré du modèle à cinq variables de notre
   * sondage (MULTIPLE, src/lib/data/seance7.js, généré par
   * outils/seance7_data.R), chaque carte avec son échelle (seul le 0 est
   * marqué) : −0,2 à +0,45, puis −0,1 à +0,2, puis −0,15 à +0,3, pour
   * que les moustaches se voient bien.
   *
   *   0  Les trois questions seules.
   *   1  Où est le point ? Femme (−0,09) à gauche, âge (+0,35) à
   *      droite : le sens et la taille de l'effet.
   *   2  La moustache croise-t-elle 0 ? Revenu : non. Québec : oui, en
   *      rouge. Si elle croise : pas significatif à 5 %.
   *   3  Est-elle large ? Femme (étroite) contre scolarité (large) : plus
   *      elle est large, moins on est précis.
   */
  import { brancherTemps } from '../temps.js';
  import { MULTIPLE } from '$lib/data/seance7.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const C = Object.fromEntries(MULTIPLE.coefs.map((c) => [c.terme, c]));
  const L = 250; // largeur du petit axe
  const CARTES = [
    {
      q: ['Où est', 'le point\u202F?'],
      r: ['Le sens et la taille', 'de l’effet.'],
      bornes: [-0.2, 0.45],
      rangs: [['femme', C.femme, false], ['âge', C.age, false]]
    },
    {
      q: ['La moustache', 'croise-t-elle 0\u202F?'],
      r: ['Si oui\u202F: pas', 'significatif à 5 %.'],
      bornes: [-0.1, 0.2],
      rangs: [['revenu', C.revenu, false], ['Québec', C.quebec, true]]
    },
    {
      q: ['Est-elle', 'large\u202F?'],
      r: ['Plus elle est large,', 'moins on est précis.'],
      bornes: [-0.15, 0.3],
      rangs: [['femme', C.femme, false], ['scolarité', C.scolarite, false]]
    }
  ];
  const LARG = 300, ECART = 30, X0 = 20;
  const ox = (k) => X0 + k * (LARG + ECART);
  const x = (k, v) => { const [a, b] = CARTES[k].bornes; return ox(k) + 25 + ((v - a) / (b - a)) * L; };
  const YM = [236, 300]; // les deux rangées du petit dessin
</script>

<div class="visuel coef-trois" bind:this={hote}>
  <svg viewBox="0 0 1000 480" role="img" aria-label="Lire un graphique des coefficients en trois questions. Un&#8239;: où est le point&#8239;? Le sens et la taille de l’effet. Deux&#8239;: la moustache croise-t-elle 0&#8239;? Si oui, pas significatif à 5&#8239;%. Trois&#8239;: est-elle large&#8239;? Plus elle est large, moins on est précis.">
    {#each CARTES as c, k}
      <rect x={ox(k)} y="4" width={LARG} height="470" class="cq-carte" class:cq-ici={e === k + 1} />
      <rect x={ox(k)} y="4" width="52" height="52" class="cq-num-f" class:cq-ici-f={e === k + 1} />
      <text x={ox(k) + 26} y="41" class="cq-num">{k + 1}</text>
      <text x={ox(k) + 24} y="100" class="cq-q">{c.q[0]}</text>
      <text x={ox(k) + 24} y="132" class="cq-q">{c.q[1]}</text>

      <g class="cq-etape" class:cq-vu={e >= k + 1}>
        <!-- Le petit dessin : la ligne à 0 et deux rangées. -->
        <line x1={x(k, 0)} y1="186" x2={x(k, 0)} y2="330" class="cq-zero" />
        <text x={x(k, 0)} y="176" class="cq-zero-t">0</text>
        {#each c.rangs as [nom, r, rouge], j}
          <g class:cq-rouge={rouge}>
            <!-- Un fond couleur papier : la ligne à 0 passe derrière le nom. -->
            <rect x={ox(k) + 18} y={YM[j] - 36} width={nom.length * 10.8 + 12} height="26" class="cq-fond" />
            <text x={ox(k) + 24} y={YM[j] - 17} class="cq-nom">{nom}</text>
            <line x1={x(k, r.bas)} y1={YM[j]} x2={x(k, r.haut)} y2={YM[j]} class="cq-moustache" />
            <circle cx={x(k, r.b)} cy={YM[j]} r="7" class="cq-point" />
          </g>
        {/each}
        <text x={ox(k) + 24} y="398" class="cq-r">{c.r[0]}</text>
        <text x={ox(k) + 24} y="428" class="cq-r">{c.r[1]}</text>
      </g>
    {/each}
  </svg>
</div>

<style>
  .coef-trois { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .cq-carte { fill: none; stroke: var(--dk-encre); stroke-width: 2; transition: stroke 0.4s; }
  .cq-carte.cq-ici { stroke: var(--dk-accent); }
  .cq-num-f { fill: var(--dk-encre); transition: fill 0.4s; }
  .cq-num-f.cq-ici-f { fill: var(--dk-accent); }
  .cq-num { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .cq-q { font-size: 25px; font-weight: 600; fill: var(--dk-encre); }
  .cq-r { font-size: 20px; fill: var(--dk-encre); }
  .cq-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 6 5; }
  .cq-zero-t { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .cq-nom { font-size: 18px; fill: var(--dk-gris); }
  .cq-fond { fill: var(--dk-fond); }
  .cq-moustache { stroke: var(--dk-encre); stroke-width: 5; }
  .cq-point { fill: var(--dk-encre); }
  .cq-rouge .cq-moustache { stroke: var(--dk-accent); }
  .cq-rouge .cq-point, .cq-rouge .cq-nom { fill: var(--dk-accent); }
  .cq-etape { opacity: 0; transition: opacity 0.3s; }
  .cq-etape.cq-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .cq-etape, .cq-etape.cq-vu, .cq-carte, .cq-num-f { transition: none; }
  }
</style>
