<script>
  /**
   * La planche de Galton : d'où vient la cloche. Des billes tombent à travers
   * douze rangées de clous. À chaque clou, la bille part à gauche ou à
   * droite, au hasard. En bas, elles s'empilent dans treize cases. Trois
   * temps.
   *
   *   0  La planche vide, et la règle en une ligne. En haut à gauche, la
   *      question qui relie la planche à l'histoire du budget : « La cloche
   *      de nos 1 000 sondages, d'où vient-elle ? » (les 1 000 sondages de
   *      la diapo « Et si on recommençait ? », Recommencer.svelte). Elle
   *      reste à l'écran jusqu'à la fin.
   *   1  Les billes tombent, une à une (environ six secondes); les cases se
   *      remplissent à mesure qu'elles arrivent.
   *   2  Toutes les billes sont tombées. La courbe normale, en rouge, se
   *      pose sur les cases, et la raison en une ligne.
   *
   * Une simulation, dite telle quelle à l'écran : les rebonds viennent d'un
   * petit générateur congruentiel à graine fixe (pas de Math.random), donc
   * la même planche à chaque fois. La courbe rouge est la courbe normale de
   * même centre et même largeur que 12 rebonds à une chance sur deux, mise à
   * l'échelle des cases : c'est la forme que la planche vise, pas une donnée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const R = 12, N = 400;
  const CX = 500, Y0 = 64, DX = 38, DY = 20;
  const YB = Y0 + R * DY + 16;            // haut des cases
  const BASE = 432, HCASE = BASE - YB - 6;

  function lcg(graine) {
    let s = graine >>> 0;
    return () => (s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 4294967296;
  }
  const alea = lcg(1886);
  // Chaque bille : ses douze rebonds (0 = gauche, 1 = droite) et sa case.
  const BILLES = Array.from({ length: N }, () => {
    const pas = Array.from({ length: R }, () => (alea() < 0.5 ? 0 : 1));
    return { pas, cse: pas.reduce((a, b) => a + b, 0) };
  });
  const xCase = (k) => CX + (k - R / 2) * DX;
  // Le chemin d'une bille : au-dessus du clou de chaque rangée, puis la case.
  const chemin = (b) => {
    const pts = [[CX, Y0 - 26]];
    let k = 0;
    for (let r = 0; r < R; r++) {
      pts.push([CX + (k - r / 2) * DX, Y0 + r * DY - 9]);
      k += b.pas[r];
    }
    pts.push([xCase(k), YB + 4]);
    return pts;
  };
  const CHEMINS = BILLES.map(chemin);
  const CLOUS = Array.from({ length: R }, (_, r) => Array.from({ length: r + 1 }, (_, k) => [CX + (k - r / 2) * DX, Y0 + r * DY])).flat();

  // Le temps : une bille part toutes les INTERVALLE ms, et met VOL ms à tomber.
  const INTERVALLE = 14, VOL = 900;
  let t = $state(0);
  $effect(() => {
    if (e !== 1) return;
    const debut = performance.now();
    let id;
    const tic = (now) => {
      t = now - debut;
      if (t < N * INTERVALLE + VOL) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  });
  const fini = $derived(e >= 2 || (e === 1 && t >= N * INTERVALLE + VOL));
  // Combien de billes ont atterri, et lesquelles sont en vol.
  const arrivees = $derived(e === 0 ? 0 : fini ? N : Math.max(0, Math.min(N, Math.floor((t - VOL) / INTERVALLE) + 1)));
  const COMPTES = $derived.by(() => {
    const c = new Array(R + 1).fill(0);
    for (let i = 0; i < arrivees; i++) c[BILLES[i].cse]++;
    return c;
  });
  const MAXFIN = (() => {
    const c = new Array(R + 1).fill(0);
    for (const b of BILLES) c[b.cse]++;
    return Math.max(...c);
  })();
  const enVol = $derived.by(() => {
    if (e !== 1 || fini) return [];
    const out = [];
    for (let i = arrivees; i < N; i++) {
      const u = (t - i * INTERVALLE) / VOL;
      if (u < 0) break;
      const pts = CHEMINS[i];
      const s = u * (pts.length - 1);
      const j = Math.min(pts.length - 2, Math.floor(s));
      const f = s - j;
      out.push([pts[j][0] + (pts[j + 1][0] - pts[j][0]) * f, pts[j][1] + (pts[j + 1][1] - pts[j][1]) * f]);
    }
    return out;
  });
  // La courbe visée : binomiale(12, 1/2), à l'échelle des cases.
  const COURBE = (() => {
    const pts = [];
    for (let s = 0; s <= R * 10; s++) {
      const k = s / 10;
      // Interpolation lisse : la normale de même moyenne et même écart type.
      const m = R / 2, sd = Math.sqrt(R) / 2;
      const d = Math.exp(-0.5 * ((k - m) / sd) ** 2) / (sd * Math.sqrt(2 * Math.PI));
      pts.push([xCase(k), BASE - ((d * N) / MAXFIN) * HCASE]);
    }
    return 'M ' + pts.map(([x, y]) => `${x.toFixed(1)} ${y.toFixed(1)}`).join(' L ');
  })();
</script>

<div class="visuel galton" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="La cloche de nos 1&#8239;000 sondages, d’où vient-elle&#8239;? La planche de Galton. Des billes tombent à travers douze rangées de clous et rebondissent à gauche ou à droite, au hasard. En bas, elles forment une cloche&#8239;: la courbe normale. Pour finir au bord, il faut rebondir douze fois du même côté, c’est rare.">
    <text x="980" y="22" class="ga-note">simulation</text>
    <!-- 0 : la question, qui renvoie aux 1 000 sondages du budget. -->
    <text x="20" y="40" class="ga-question">La cloche de nos 1&#8239;000 sondages,</text>
    <text x="20" y="68" class="ga-question">d’où vient-elle&#8239;?</text>
    <!-- L'entonnoir. -->
    <path d="M {CX - 40} {Y0 - 50} L {CX - 8} {Y0 - 22} M {CX + 40} {Y0 - 50} L {CX + 8} {Y0 - 22}" class="ga-cadre" />
    {#each CLOUS as [x, y]}
      <circle cx={x} cy={y} r="3.5" class="ga-clou" />
    {/each}
    <!-- Les cases. -->
    {#each COMPTES as c, k}
      <rect x={xCase(k) - DX / 2 + 3} y={BASE - (c / MAXFIN) * HCASE} width={DX - 6} height={(c / MAXFIN) * HCASE} class="ga-case" />
    {/each}
    {#each Array.from({ length: R + 2 }, (_, k) => xCase(k - 0.5)) as x}
      <line x1={x} y1={YB} x2={x} y2={BASE} class="ga-paroi" />
    {/each}
    <line x1={xCase(-0.5)} y1={BASE} x2={xCase(R + 0.5)} y2={BASE} class="ga-cadre" />
    <!-- Les billes en vol. -->
    {#each enVol as [x, y]}
      <circle cx={x} cy={y} r="6" class="ga-bille" />
    {/each}
    <!-- 2 : la courbe. -->
    <g class="ga-etape" class:ga-vu={e >= 2}>
      <path d={COURBE} class="ga-courbe" />
      <text x={xCase(R / 2 + 2.6)} y={BASE - HCASE - 2} class="ga-nom">la courbe normale</text>
    </g>
    <!-- Les phrases. -->
    <text x="500" y="474" class="ga-phrase" class:ga-cache={e >= 2}>À chaque clou, la bille part à gauche ou à droite, au hasard.</text>
    <text x="500" y="474" class="ga-phrase ga-etape" class:ga-vu={e >= 2}>Pour finir au bord, il faut rebondir 12 fois du même côté&#8239;: c’est rare.</text>
    <text x="500" y="496" class="ga-sous ga-etape" class:ga-vu={e >= 2}>La plupart des billes finissent au milieu.</text>
  </svg>
</div>

<style>
  .galton { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }
  .ga-note { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .ga-question { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .ga-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .ga-clou { fill: var(--dk-encre); }
  .ga-paroi { stroke: var(--dk-gris-2); stroke-width: 2; }
  .ga-case { fill: var(--dk-encre); }
  .ga-bille { fill: var(--dk-accent); }
  .ga-courbe { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .ga-nom { font-size: 22px; font-weight: 600; fill: var(--dk-accent); }
  .ga-phrase { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.3s; }
  .ga-sous { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .ga-cache { opacity: 0; }
  .ga-etape { opacity: 0; transition: opacity 0.2s; }
  .ga-etape.ga-vu { opacity: 1; transition: opacity 0.6s; }
  @media (prefers-reduced-motion: reduce) {
    .ga-phrase, .ga-etape, .ga-etape.ga-vu { transition: none; }
  }
</style>
