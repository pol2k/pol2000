<script>
  /**
   * « Et si on recommençait ? » Le même sondage de 1 000 personnes, refait
   * mille fois. Au hasard, les résultats s'empilent en cloche autour du vrai
   * vote conservateur. Au Québec seulement, ils s'empilent aussi en cloche,
   * mais loin de la vérité : répéter une mauvaise méthode ne la corrige pas.
   *
   * Tout vient de src/lib/data/seance5_budget.js (outils/seance5_budget.R,
   * Étude électorale canadienne 2025, répondant.e.s qui déclarent un parti) :
   * BUDGET.vrai (la ligne pointillée), BUDGET.n (la taille de chaque
   * sondage), MILLE.bornes (tranches d'un demi-point, [a, a + 0,005)),
   * MILLE.hasard.effectifs et MILLE.quebec.effectifs (1 000 sondages
   * chacun), MILLE.quebec.moyenne (l'étiquette de la cloche rouge).
   *
   * Le module ne donne que les effectifs, pas l'ordre des tirages. Pour
   * l'animation, les sondages arrivent dans un ordre fixe : la liste des
   * tranches (chaque tranche répétée autant de fois que son effectif),
   * parcourue par pas constant premier avec sa longueur. Rien d'aléatoire :
   * l'état final est toujours le même, il égale les effectifs de R.
   * L'échelle verticale est commune aux deux cloches (le plus haut bâton
   * des deux) et fixée dès le départ : les bâtons grandissent.
   *
   *   0  L'axe (part du vote conservateur, %) et la ligne pointillée du
   *      vrai vote, BUDGET.vrai.
   *   1  1 000 sondages de 1 000, au hasard : les bâtons montent en trois
   *      secondes (requestAnimationFrame), une cloche autour de la vérité.
   *      L'état final est fixé : dès le temps 2, ou après trois secondes,
   *      les 1 000 sondages sont tous là.
   *   2  1 000 sondages de 1 000, au Québec seulement : une cloche rouge
   *      monte loin à gauche, autour de MILLE.quebec.moyenne. Même
   *      animation, état final fixé au temps 3.
   *   3  La phrase : « Plus de sondages ne corrigent pas une mauvaise
   *      méthode. »
   *
   * Remplace MilleEchantillons et QuatreTailles (l'âge moyen) dans la
   * séance 5 : même mécanique, sur l'exemple du budget.
   */
  import { brancherTemps } from '../temps.js';
  import { BUDGET, MILLE } from '$lib/data/seance5_budget.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const pc = (p) => `${f(p * 100, 1)} %`;
  const N = ' ';

  // L'axe : de 15 à 46 % (toutes les tranches non vides y tiennent).
  const AMIN = 0.15, AMAX = 0.46, X0 = 70, X1 = 930;
  const x = (v) => X0 + ((v - AMIN) / (AMAX - AMIN)) * (X1 - X0);
  const AXE = 410, HMAX = 250;
  const B = MILLE.bornes;
  const LARGE = x(B[1]) - x(B[0]);
  const TICKS = [15, 20, 25, 30, 35, 40, 45];

  const H = MILLE.hasard.effectifs, Q = MILLE.quebec.effectifs;
  const YMAX = Math.max(...H, ...Q);
  const somme = (a) => a.reduce((s, v) => s + v, 0);
  const NB = somme(H), NBQ = somme(Q);
  const TAILLE = f(BUDGET.n);
  const XV = x(BUDGET.vrai);
  const XQ = x(MILLE.quebec.moyenne);

  // L'ordre d'arrivée : la liste des tranches, parcourue par pas fixe.
  const pgcd = (a, b) => (b ? pgcd(b, a % b) : a);
  const ordre = (eff) => {
    const liste = eff.flatMap((c, j) => Array(c).fill(j));
    const n = liste.length;
    let pas = Math.round(n * 0.618);
    while (pgcd(pas, n) !== 1) pas++;
    return liste.map((_, i) => liste[(i * pas) % n]);
  };
  const ORDRE_H = ordre(H), ORDRE_Q = ordre(Q);
  const compter = (o, k) => {
    const c = new Array(B.length - 1).fill(0);
    for (let i = 0; i < k; i++) c[o[i]]++;
    return c;
  };

  // Trois secondes par cloche; mouvement réduit : la cloche est là d'emblée.
  const DUREE = 3000;
  const calme = () => typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches;
  const animer = (regler) => {
    if (calme()) {
      regler(DUREE);
      return () => {};
    }
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
  $effect(() => {
    if (e !== 1) return;
    return animer((v) => (tH = v));
  });
  $effect(() => {
    if (e !== 2) return;
    return animer((v) => (tQ = v));
  });
  const arrives = (t, n) => Math.max(1, Math.min(n, Math.round((t / DUREE) * n)));
  const kH = $derived(e < 1 ? 0 : e > 1 ? NB : arrives(tH, NB));
  const kQ = $derived(e < 2 ? 0 : e > 2 ? NBQ : arrives(tQ, NBQ));
  const effH = $derived(compter(ORDRE_H, kH));
  const effQ = $derived(compter(ORDRE_Q, kQ));

  const BATONS = B.slice(0, -1).map((a, j) => ({ a, j })).filter((b) => b.a >= AMIN && b.a < AMAX);
  const h = (c) => (c / YMAX) * HMAX;
  const sondages = (k) => `${f(k)} sondage${k > 1 ? 's' : ''} de ${TAILLE}`;
</script>

<div class="visuel recommencer" bind:this={hote}>
  <svg viewBox="0 0 1000 524" role="img" aria-label="On refait le même sondage de {TAILLE} personnes {f(NB)} fois. Au hasard, les résultats s’empilent en cloche autour du vrai vote conservateur, {pc(BUDGET.vrai)}. Au Québec seulement, ils s’empilent aussi en cloche, mais autour de {pc(MILLE.quebec.moyenne)}, loin de la vérité. Plus de sondages ne corrigent pas une mauvaise méthode.">
    <!-- Les compteurs. -->
    <text x={X0} y="40" class="re-compte re-etape" class:re-vu={e >= 1}>{sondages(Math.max(kH, 1))}, au hasard</text>
    <text x={X0} y="76" class="re-compte re-quebec re-etape" class:re-vu={e >= 2}>{sondages(Math.max(kQ, 1))}, au Québec seulement</text>

    <!-- 1 : au hasard. -->
    {#each BATONS as b}
      <rect x={x(b.a) + 1.5} y={AXE - h(effH[b.j])} width={LARGE - 3} height={h(effH[b.j])} class="re-baton" />
    {/each}

    <!-- 2 : au Québec seulement. -->
    {#each BATONS as b}
      <rect x={x(b.a) + 1.5} y={AXE - h(effQ[b.j])} width={LARGE - 3} height={h(effQ[b.j])} class="re-baton re-rouge" />
    {/each}
    <text x={XQ} y={AXE - HMAX - 14} class="re-qc-t re-etape re-apres" class:re-vu={e >= 2}>autour de {pc(MILLE.quebec.moyenne)}</text>

    <!-- Le vrai vote. -->
    <line x1={XV} y1="130" x2={XV} y2={AXE} class="re-vrai" />
    <text x={XV} y="118" class="re-vrai-t">le vrai vote{N}: {pc(BUDGET.vrai)}</text>

    <!-- L'axe. -->
    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="re-axe" />
    {#each TICKS as t}
      <line x1={x(t / 100)} y1={AXE} x2={x(t / 100)} y2={AXE + 8} class="re-axe" />
      <text x={x(t / 100)} y={AXE + 32} class="re-tick">{t}</text>
    {/each}
    <text x={X1} y={AXE + 58} class="re-tick re-fin">part du vote conservateur dans chaque sondage (%)</text>

    <!-- 3 : la leçon. -->
    <text x="500" y="510" class="re-lecon re-etape" class:re-vu={e >= 3}>Plus de sondages ne corrigent pas une mauvaise méthode.</text>
  </svg>
</div>

<style>
  .recommencer { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .re-compte { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .re-quebec { fill: var(--dk-accent); }

  .re-baton { fill: var(--dk-encre); }
  .re-baton.re-rouge { fill: var(--dk-accent); }
  .re-qc-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .re-vrai { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 7; }
  .re-vrai-t { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .re-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .re-tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .re-fin { text-anchor: end; }

  .re-lecon { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .re-etape { opacity: 0; transition: opacity 0.2s; }
  .re-etape.re-vu { opacity: 1; transition: opacity 0.4s; }
  .re-etape.re-apres.re-vu { transition: opacity 0.5s 2.6s; }

  @media (prefers-reduced-motion: reduce) {
    .re-etape, .re-etape.re-vu, .re-etape.re-apres.re-vu { transition: none; }
  }
</style>
