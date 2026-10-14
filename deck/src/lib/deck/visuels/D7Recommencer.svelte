<script>
  /**
   * « Et si on recommençait ? », séance 7 : la même mécanique que
   * Recommencer (séance 5), sur la pente. On refait notre sondage de 1 000
   * personnes mille fois. À gauche, la droite de chaque sondage (populisme
   * et satisfaction_dem, de 0 à 1); à droite, sa pente, empilée en
   * histogramme (tranches de 0,01).
   *
   *   0  À gauche, la vraie droite (pointillé). À droite, l'axe des pentes
   *      et la vraie pente, POP.b1 (−0,314). Ici, trois décimales : la
   *      moyenne des 1 000 sondages (−0,316) et la vraie pente (−0,314)
   *      arrondies à deux décimales donneraient −0,32 et −0,31, une fausse
   *      différence. Les deux cloches se chevauchent : chacune a sa rangée
   *      (le hasard en haut, les jeunes en bas), sur le même axe des pentes.
   *   1  1 000 sondages de 1 000 au hasard : les droites arrivent en trois
   *      secondes (encre très pâle : là où elles s'accumulent, c'est foncé)
   *      et leurs pentes s'empilent en cloche autour de −0,31. C'est le
   *      hasard (la variance), pas un biais. L'état final est fixé dès le
   *      temps 2.
   *   2  1 000 sondages de 1 000 chez les 18 à 34 ans seulement (le sondage
   *      « facile », MILLE.facile_nom) : droites et cloche rouges, autour de
   *      MILLE.moyenne_facile (−0,19). Toujours du même côté : c'est le
   *      biais. État final fixé au temps 3.
   *   3  Les deux mots au-dessus des cloches (« le hasard », « le biais ») et
   *      la phrase de la séance 5 : plus de sondages ne corrigent pas une
   *      mauvaise méthode.
   *
   * Sources : les pentes, MILLE.hasard et MILLE.facile (src/lib/data/seance7.js,
   * outils/seance7_data.R, graines 2025 et 2026), dans l'ordre des tirages.
   * Les constantes de ces MÊMES sondages, pour tracer les droites :
   * DROITES (src/lib/data/seance7_d.js, outils/seance7_d.R, qui refait les
   * mêmes tirages et vérifie que ses pentes égalent MILLE). Le compteur de
   * moyenne en haut à droite est la moyenne des sondages déjà faits.
   */
  import { brancherTemps } from '../temps.js';
  import { VARS, POP, MILLE } from '$lib/data/seance7.js';
  import { DROITES } from '$lib/data/seance7_d.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');
  const QUI = MILLE.facile_nom.replace(/^les /, '').replace(/ seulement$/, '');

  // À gauche : le cadre des droites, X et Y de 0 à 1.
  const GX0 = 90, GX1 = 420, GY0 = 400, GY1 = 120;
  const gx = (v) => GX0 + v * (GX1 - GX0);
  const gy = (v) => GY0 - v * (GY0 - GY1);
  const ligne = (b0, b1) => ({ y0: gy(b0), y1: gy(b0 + b1) });
  const LH = DROITES.hasard.b0.map((b0, i) => ligne(b0, DROITES.hasard.b1[i]));
  const LQ = DROITES.facile.b0.map((b0, i) => ligne(b0, DROITES.facile.b1[i]));
  const VRAIE = ligne(POP.b0, POP.b1);

  // À droite : l'histogramme des pentes, de −0,5 à 0, tranches de 0,01.
  // Deux rangées sur le même axe : le hasard en haut, les jeunes en bas (les cloches se chevauchent).
  const A0 = -0.5, A1 = 0, HX0 = 560, HX1 = 960, AXE = 400, AXH = 262, HMAX = 112;
  const hx = (v) => HX0 + ((v - A0) / (A1 - A0)) * (HX1 - HX0);
  const L = 0.01;
  const NB = Math.round((A1 - A0) / L);
  const LARGE = hx(A0 + L) - hx(A0);
  const tranche = (p) => Math.min(NB - 1, Math.max(0, Math.floor((p - A0) / L + 1e-9)));
  const OH = MILLE.hasard.map(tranche), OQ = MILLE.facile.map(tranche);
  const compter = (o, k) => {
    const c = new Array(NB).fill(0);
    for (let i = 0; i < k; i++) c[o[i]]++;
    return c;
  };
  const YMAX = Math.max(...compter(OH, OH.length), ...compter(OQ, OQ.length));
  const h = (c) => (c / YMAX) * HMAX;
  const cumul = (P) => P.reduce((acc, v, i) => (acc.push(((i ? acc[i - 1] * i : 0) + v) / (i + 1)), acc), []);
  const MH = cumul(MILLE.hasard), MQ = cumul(MILLE.facile);
  const XV = hx(POP.b1);
  const TICKS = [-0.5, -0.4, -0.3, -0.2, -0.1, 0];

  // Trois secondes par série; mouvement réduit : tout est là d'emblée.
  const DUREE = 3000;
  const calme = () => typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches;
  const animer = (regler) => {
    if (calme()) { regler(DUREE); return () => {}; }
    regler(0);
    const debut = performance.now();
    let id;
    const tic = (now) => {
      regler(now - debut);
      if (now - debut < DUREE) id = requestAnimationFrame(tic);
    };
    id = requestAnimationFrame(tic);
    return () => cancelAnimationFrame(id);
  };
  let tH = $state(0);
  let tQ = $state(0);
  $effect(() => { if (e !== 1) return; return animer((v) => (tH = v)); });
  $effect(() => { if (e !== 2) return; return animer((v) => (tQ = v)); });
  const arrives = (t, n) => Math.max(1, Math.min(n, Math.round((t / DUREE) * n)));
  const kH = $derived(e < 1 ? 0 : e > 1 ? LH.length : arrives(tH, LH.length));
  const kQ = $derived(e < 2 ? 0 : e > 2 ? LQ.length : arrives(tQ, LQ.length));
  const effH = $derived(compter(OH, kH));
  const effQ = $derived(compter(OQ, kQ));
  const mH = $derived(kH ? MH[kH - 1] : POP.b1);
  const mQ = $derived(kQ ? MQ[kQ - 1] : MILLE.moyenne_facile);

  const ARIA =
    `On refait notre sondage de ${f(1000)} personnes mille fois. Au hasard, les droites se dispersent autour de la vraie droite ` +
    `et leurs pentes s’empilent en cloche autour de la vraie pente, ${f(POP.b1, 3)}${NN}: c’est le hasard. ` +
    `Chez ${MILLE.facile_nom}, les droites sont plus plates et les pentes s’empilent autour de ${f(MILLE.moyenne_facile, 2)}${NN}: c’est le biais. ` +
    `Plus de sondages ne corrigent pas une mauvaise méthode.`;
</script>

<div class="visuel d7-recommencer" bind:this={hote}>
  <svg viewBox="0 0 1000 540" role="img" aria-label={ARIA}>
    <defs>
      <clipPath id="d7r-cadre"><rect x={GX0} y={GY1 - 20} width={GX1 - GX0} height={GY0 - GY1 + 20} /></clipPath>
    </defs>

    <!-- Les compteurs. -->
    <text x={GX0 - 40} y="34" class="rc-compte rc-etape" class:rc-vu={e >= 1}>{f(Math.max(kH, 1))} sondages au hasard</text>
    <text x={HX1} y="34" class="rc-moy rc-etape" class:rc-vu={e >= 1}>moyenne des pentes{NN}: {f(mH, 3)}</text>
    <text x={GX0 - 40} y="68" class="rc-compte rc-rouge rc-etape" class:rc-vu={e >= 2}>{f(Math.max(kQ, 1))} sondages chez les {QUI}</text>
    <text x={HX1} y="68" class="rc-moy rc-rouge rc-etape" class:rc-vu={e >= 2}>moyenne des pentes{NN}: {f(mQ, 3)}</text>

    <!-- À gauche : les droites. -->
    <g clip-path="url(#d7r-cadre)">
      {#each LH as l, i}
        <line x1={gx(0)} y1={l.y0} x2={gx(1)} y2={l.y1} class="rc-l" style="opacity: {i < kH ? 0.06 : 0}" />
      {/each}
      {#each LQ as l, i}
        <line x1={gx(0)} y1={l.y0} x2={gx(1)} y2={l.y1} class="rc-l rc-lq" style="opacity: {i < kQ ? 0.06 : 0}" />
      {/each}
    </g>
    <line x1={gx(0)} y1={VRAIE.y0} x2={gx(1)} y2={VRAIE.y1} class="rc-halo" />
    <line x1={gx(0)} y1={VRAIE.y0} x2={gx(1)} y2={VRAIE.y1} class="rc-vrai" />
    <line x1={GX0} y1={GY0} x2={GX1} y2={GY0} class="rc-axe" />
    <line x1={GX0} y1={GY0} x2={GX0} y2={GY1 - 20} class="rc-axe" />
    {#each [0, 0.5, 1] as t}
      <text x={gx(t)} y={GY0 + 28} class="rc-tick">{f(t, t % 1 ? 1 : 0)}</text>
      <text x={GX0 - 10} y={gy(t) + 6} class="rc-tick rc-fin">{f(t, t % 1 ? 1 : 0)}</text>
    {/each}
    <text x={GX1} y={GY0 + 56} class="rc-tick rc-fin">{VARS.x.nom}</text>
    <text x={GX0 + 12} y={GY1 + 2} class="rc-tick rc-debut">{VARS.y.nom}</text>
    <text x={GX1 + 10} y={VRAIE.y1 + 2} class="rc-vrai-t rc-debut">la vraie</text>
    <text x={GX1 + 10} y={VRAIE.y1 + 26} class="rc-vrai-t rc-debut">droite</text>

    <!-- À droite : les pentes. -->
    {#each effH as c, j}
      {#if c}<rect x={hx(A0 + j * L) + 0.75} y={AXH - h(c)} width={LARGE - 1.5} height={h(c)} class="rc-baton" />{/if}
    {/each}
    {#each effQ as c, j}
      {#if c}<rect x={hx(A0 + j * L) + 0.75} y={AXE - h(c)} width={LARGE - 1.5} height={h(c)} class="rc-baton rc-rouge-f" />{/if}
    {/each}
    <line x1={HX0} y1={AXH} x2={HX1} y2={AXH} class="rc-base" />
    <line x1={XV} y1="130" x2={XV} y2={AXE} class="rc-vrai" />
    <text x={XV} y="118" class="rc-vrai-t">la vraie pente{NN}: {f(POP.b1, 3)}</text>
    <line x1={HX0} y1={AXE} x2={HX1} y2={AXE} class="rc-axe" />
    {#each TICKS as t}
      <line x1={hx(t)} y1={AXE} x2={hx(t)} y2={AXE + 8} class="rc-axe" />
      <text x={hx(t)} y={AXE + 30} class="rc-tick">{f(t, t ? 1 : 0)}</text>
    {/each}
    <text x={HX1} y={AXE + 56} class="rc-tick rc-fin">la pente de chaque sondage</text>

    <!-- 3 : les deux mots, et la leçon. -->
    <text x={HX1} y={AXH - 40} class="rc-mot rc-fin rc-etape" class:rc-vu={e >= 3}>le hasard</text>
    <text x={HX0 - 6} y={AXE - 40} class="rc-mot rc-debut rc-rouge rc-etape" class:rc-vu={e >= 3}>le biais</text>
    <text x="500" y="524" class="rc-lecon rc-etape" class:rc-vu={e >= 3}>Plus de sondages ne corrigent pas une mauvaise méthode.</text>
  </svg>
</div>

<style>
  .d7-recommencer { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }

  .rc-compte { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .rc-moy { font-size: 22px; font-weight: 700; text-anchor: end; fill: var(--dk-encre); }
  .rc-rouge { fill: var(--dk-accent); }

  .rc-l { stroke: var(--dk-encre); stroke-width: 2; }
  .rc-lq { stroke: var(--dk-accent); }
  .rc-baton { fill: var(--dk-encre); }
  .rc-baton.rc-rouge-f { fill: var(--dk-accent); }

  .rc-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .rc-halo { stroke: var(--dk-fond); stroke-width: 9; }
  .rc-vrai-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .rc-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .rc-base { stroke: var(--dk-filet); stroke-width: 2; }
  .rc-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .rc-fin { text-anchor: end; }
  .rc-debut { text-anchor: start; }

  .rc-mot { font-size: 24px; font-weight: 700; fill: var(--dk-encre); }
  .rc-mot.rc-rouge { fill: var(--dk-accent); }
  .rc-lecon { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .rc-etape { opacity: 0; transition: opacity 0.2s; }
  .rc-etape.rc-vu { opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .rc-etape, .rc-etape.rc-vu { transition: none; }
  }
</style>
