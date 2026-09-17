<script>
  /**
   * Pis, le mode, ça sert à quoi ? Un soir d'élection. Les intentions de
   * vote de l'Étude électorale canadienne 2025 (VOTE, seance3.js), sans les
   * « ne sait pas » (code 7) : le parti le plus fréquent, c'est le mode, et
   * au scrutin majoritaire uninominal, c'est lui qui gagne, même sous 50 %.
   *
   *   0  Les barres filent, les pourcentages comptent jusqu'à leur valeur.
   *   1  Un tampon « le mode » tombe sur la première barre.
   *   2  La ligne des 50 % se trace : la barre s'arrête avant. « Pas une
   *      majorité. »
   *
   * Les parts sont calculées ici à partir des effectifs exportés par R.
   */
  import { untrack } from 'svelte';
  import { Tween } from 'svelte/motion';
  import { cubicOut } from 'svelte/easing';
  import { brancherTemps } from '../temps.js';
  import { VOTE } from '$lib/data/seance3.js';
  import Pis from './Pis.svelte';

  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 2,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  // Codes 1 à 6 et 8 ; le code 7 (« ne sait pas ») est écarté.
  const PARTIS = [
    { code: 1, nom: 'Libéral', c: '#d71920' },
    { code: 2, nom: 'Conservateur', c: '#1a4782' },
    { code: 3, nom: 'NPD', c: '#f37021' },
    { code: 4, nom: 'Bloc Québécois', c: '#33b2cc' },
    { code: 5, nom: 'Vert', c: '#3d9b35' },
    { code: 8, nom: 'PPC', c: '#4b2e83' },
    { code: 6, nom: 'Autre', c: '#8b918f' }
  ];
  const total = PARTIS.reduce((s, p) => s + VOTE.effectifs[p.code - 1], 0);
  const RANGS = PARTIS.map((p) => ({ ...p, part: (VOTE.effectifs[p.code - 1] / total) * 100 })).sort((a, b) => b.part - a.part);

  const reduit = typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches;
  const prog = new Tween(0, { duration: reduit ? 0 : 1300, easing: cubicOut });
  $effect(() => {
    tour;
    untrack(() => {
      prog.set(0, { duration: 0 });
      prog.set(1);
    });
  });

  const LX = 230, X0 = 250, X1 = 960, MAX = 70, HAUT = 70, RANG = 44;
  const x = (p) => X0 + (p / MAX) * (X1 - X0);
  const yr = (i) => HAUT + i * RANG;
  const fmt = (p) => p.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + ' %';
  const BAS = yr(RANGS.length) + 6;
</script>

<Pis stat="le mode" reponse="Dans une circonscription, le gagnant, c'est le mode. Pas la majorité." vu={e >= 2} source="Étude électorale canadienne 2025 · intentions de vote, sans les « ne sait pas »">
  {#snippet children()}
    <svg bind:this={hote} viewBox="0 0 1000 {BAS + 20}" preserveAspectRatio="xMidYMid meet" role="img" aria-label="Intentions de vote : {RANGS.map((r) => `${r.nom} ${fmt(r.part)}`).join(', ')}. Le Parti libéral est le mode, sans atteindre la majorité.">
      <!-- La ligne des 50 % : elle se trace au dernier temps. -->
      <g class="majorite" class:vu={e >= 2}>
        <line x1={x(50)} y1={HAUT - 30} x2={x(50)} y2={BAS} pathLength="1" class="maj-l" />
        <text x={x(50)} y={HAUT - 40} class="maj-t">majorité · 50 %</text>
      </g>

      {#each RANGS as r, i}
        {@const w = (x(r.part) - X0) * prog.current}
        <text x={LX} y={yr(i) + 21} class="nom-m" style="fill: {r.c === '#8b918f' ? 'var(--dk-gris)' : r.c}">{r.nom}</text>
        <rect x={X0} y={yr(i) + 4} width={Math.max(w, 0)} height={RANG - 10} fill={r.c} class="barre-m" />
        {#if r.part > 12}
          <text x={X0 + w - 12} y={yr(i) + 28} class="pct-m dedans">{fmt(r.part * prog.current)}</text>
        {:else}
          <text x={X0 + w + 10} y={yr(i) + 28} class="pct-m">{fmt(r.part * prog.current)}</text>
        {/if}
      {/each}
      <line x1={X0} y1={HAUT - 6} x2={X0} y2={BAS} class="axe-m" />

      <!-- Temps 1 : le tampon sur la barre la plus longue. -->
      <g style="transform: translate({X0 + (x(RANGS[0].part) - X0) * 0.25}px, {yr(0) + 21}px)">
        <g class="tampon" class:vu={e >= 1}>
          <rect x="-78" y="-24" width="156" height="48" />
          <text x="0" y="9">le mode</text>
        </g>
      </g>
      <!-- Temps 2 : la barre s'arrête avant la ligne. Le tampon se pose dans le vide
           à droite des petites barres, sur la ligne des 50 %, sans dépasser le cadre. -->
      <g style="transform: translate(800px, {yr(2) + 40}px)">
        <g class="tampon non" class:vu={e >= 2} style="--delai: 0.55s">
          <rect x="-129" y="-24" width="258" height="48" />
          <text x="0" y="9">pas une majorité</text>
        </g>
      </g>
    </svg>
  {/snippet}
</Pis>

<style>
  svg { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .nom-m { font-size: 19px; font-weight: 600; text-anchor: end; }
  .barre-m { opacity: 0.92; }
  .pct-m { font-size: 18px; font-weight: 600; fill: var(--dk-encre); font-variant-numeric: tabular-nums; }
  .pct-m.dedans { fill: var(--dk-fond); text-anchor: end; }
  .axe-m { stroke: var(--dk-encre); stroke-width: 3; }

  .majorite { opacity: 0; transition: opacity 0.2s; }
  .majorite.vu { opacity: 1; }
  .maj-l { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 0.02 0.015; stroke-dashoffset: 0; }
  .majorite .maj-l { clip-path: inset(0 0 100% 0); transition: clip-path 0.6s ease-out; }
  .majorite.vu .maj-l { clip-path: inset(0 0 0 0); }
  .maj-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .tampon { opacity: 0; transform: scale(2.4) rotate(-14deg); transform-box: fill-box; transform-origin: center; transition: opacity 0.2s var(--delai, 0s), transform 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) var(--delai, 0s); }
  .tampon.vu { opacity: 1; transform: rotate(-6deg); }
  .tampon rect { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 4; }
  .tampon text { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); letter-spacing: 0.02em; }
  .tampon.non rect { fill: var(--dk-accent); }
  .tampon.non text { fill: var(--dk-fond); }

  @media (prefers-reduced-motion: reduce) {
    .tampon, .majorite, .majorite .maj-l { transition: none; }
  }
</style>
