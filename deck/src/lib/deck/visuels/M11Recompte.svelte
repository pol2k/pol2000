<script>
  /**
   * Le recompte : le tableau 2 de Richard et Régimbal (2026, p. 77), tel
   * quel, en une seule bande de 100 %, puis lu avec le mode d'emploi de
   * l'instrument qu'ils ont utilisé (USDA ERS 2024, Six-Item Short Form,
   * p. 4 : un score brut de 0 ou 1, c'est la sécurité alimentaire).
   *
   *   0  la lecture de l'article : les scores 1 à 6, « 43,9 % » en
   *      insécurité, sous une accolade rouge;
   *   1  le mode d'emploi : le bloc du score 1 change de camp (il glisse
   *      sous l'accolade grise de la sécurité), l'accolade rouge se
   *      resserre sur les scores 2 à 6 : 27,7 %;
   *   2  les deux manchettes possibles, côte à côte.
   *
   * Aucun calcul caché : 15,2 + 12,5 = 27,7 (scores 2 à 6), 56,1 + 16,2 =
   * 72,3. Les proportions sont celles du tableau 2.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const BLOCS = [
    { s: '0', p: 56.1, t: 'aucun « oui »' },
    { s: '1', p: 16.2, t: 'un seul « oui »' },
    { s: '2 à 4', p: 15.2, t: '' },
    { s: '5 ou 6', p: 12.5, t: '' }
  ];
  const X0 = 40, L = 1120, Y = 150, H = 110;
  const xs = BLOCS.reduce((a, b, i) => [...a, i ? a[i - 1] + (BLOCS[i - 1].p / 100) * L : X0], []);
  const w = (b) => (b.p / 100) * L;
  const fin = X0 + L;
  const v = (n) => n.toFixed(1).replace('.', ',');
  // l'accolade rouge : du début du bloc 1 (lecture de l'article) ou du bloc 2 (mode d'emploi)
  const debut = $derived(e >= 1 ? xs[2] : xs[1]);
  const part = $derived(e >= 1 ? 27.7 : 43.9);
  const accolade = (a, b, y, haut) => `M ${a} ${y} l 0 ${haut ? -18 : 18} L ${b} ${y + (haut ? -18 : 18)} l 0 ${haut ? 18 : -18}`;
</script>

<div class="visuel m11r" bind:this={hote}>
  <svg viewBox="0 0 1200 470" role="img" aria-label="Le tableau 2 de l’article en une bande : score 0, 56,1 %; score 1, 16,2 %; scores 2 à 4, 15,2 %; scores 5 et 6, 12,5 %. L’article classe le score 1 en insécurité : 43,9 %. Le mode d’emploi de l’instrument classe le score 1 en sécurité : 27,7 %.">
    <!-- l'accolade rouge : en insécurité -->
    <path d={accolade(debut + 4, fin - 4, Y - 14, true)} class="m11r-acc m11r-rouge" />
    <text x={(debut + fin) / 2} y={Y - 52} class="m11r-grand m11r-rouge">{v(part)} % en insécurité</text>
    <text x={(debut + fin) / 2} y={Y - 98} class="m11r-petit m11r-rouge">{e >= 1 ? 'selon le mode d’emploi de l’instrument' : 'selon l’article'}</text>

    {#each BLOCS as b, i (b.s)}
      <g class="m11r-bloc" class:m11r-insec={i >= 2 || (i === 1 && e === 0)} class:m11r-bascule={i === 1}>
        <rect x={xs[i]} y={Y} width={w(b) - 4} height={H} />
        <text x={xs[i] + w(b) / 2} y={Y + 50} class="m11r-pct">{v(b.p)} %</text>
        <text x={xs[i] + w(b) / 2} y={Y + 86} class="m11r-score">{w(b) > 220 ? 'score ' : ''}{b.s}</text>
      </g>
    {/each}

    <!-- l'accolade grise : en sécurité -->
    <path d={accolade(X0 + 4, (e >= 1 ? xs[2] : xs[1]) - 8, Y + H + 14, false)} class="m11r-acc" />
    <text x={(X0 + (e >= 1 ? xs[2] : xs[1])) / 2} y={Y + H + 66} class="m11r-moyen">{e >= 1 ? '72,3' : '56,1'} % en sécurité</text>

    <!-- le score 1 : un seul « oui » sur six questions -->
    <text x={xs[1] + w(BLOCS[1]) / 2} y={Y + H + 110} class="m11r-petit" class:m11r-on={e >= 1}>un seul « oui » sur six : la sécurité, d’après l’instrument</text>
  </svg>

  <div class="m11r-titres" class:m11r-on={e >= 2}>
    <p><span class="m11r-barre">Près d’un cégépien sur deux</span></p>
    <p class="m11r-vrai">Un peu plus d’un sur quatre, <em>dans six cégeps volontaires</em></p>
  </div>
  <p class="m11r-cap">Richard et Régimbal (2026), tableau 2, p. 77 · USDA ERS (2024), Six-Item Short Form, p. 4</p>
</div>

<style>
  .m11r { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.4em; }
  svg { width: 100%; max-width: 56em; height: auto; max-height: 52vh; overflow: visible; }
  text { font-family: var(--dk-mono); text-anchor: middle; fill: var(--dk-encre); }
  .m11r-bloc rect { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; transition: fill 0.6s; }
  .m11r-bloc.m11r-insec rect { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .m11r-bloc.m11r-insec text { fill: white; }
  .m11r-bloc.m11r-bascule rect { transition: fill 0.8s 0.3s; }
  .m11r-pct { font-size: 34px; font-weight: 700; transition: fill 0.6s; }
  .m11r-score { font-size: 22px; transition: fill 0.6s; }
  .m11r-acc { fill: none; stroke: var(--dk-gris); stroke-width: 4; transition: d 0.9s cubic-bezier(0.65, 0, 0.35, 1); }
  .m11r-acc.m11r-rouge { fill: none; stroke: var(--dk-accent); }
  .m11r-grand { font-size: 40px; font-weight: 700; }
  .m11r-moyen { font-size: 30px; font-weight: 700; fill: var(--dk-gris); }
  .m11r-petit { font-size: 22px; }
  .m11r-rouge { fill: var(--dk-accent); }
  text.m11r-petit:not(.m11r-rouge) { fill: var(--dk-gris); opacity: 0; transition: opacity 0.5s 0.6s; }
  text.m11r-petit.m11r-on { opacity: 1; }
  .m11r-titres { display: flex; gap: 2.5em; align-items: baseline; justify-content: center; flex-wrap: wrap; opacity: 0; transition: opacity 0.5s; font-size: 1.15em; font-weight: 700; }
  .m11r-titres.m11r-on { opacity: 1; }
  .m11r-titres p { margin: 0; }
  .m11r-barre { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 4px; color: var(--dk-gris); }
  .m11r-vrai em { font-style: normal; font-weight: 400; color: var(--dk-gris); }
  .m11r-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11r-acc, .m11r-bloc rect, .m11r-titres, text { transition: none; } }
</style>
