<script>
  /**
   * Un concept qu'on ne voit pas, et ce qu'on voit à la place : l'arbre de
   * la variable latente (d'après les figures « échelle de l'attitude
   * politique » du cours 5 de FAS1001). Il pousse au clic :
   *
   *   0  le concept seul, invisible (pointillé);
   *   1  ses dimensions;
   *   2  les questions qu'on pose, une par aspect mesurable;
   *   3  les réponses : la seule chose qu'on observe (en rouge).
   *
   * Le même composant dessine l'échelle de Merkley (2022) : on lui passe un
   * autre arbre, sans la rangée des réponses (reponses = false).
   *
   *   arbre    — { racine, sous, dims: [{ nom, qs: [{ q, r }] }] }
   *   reponses — dessiner la rangée des réponses (temps 3)
   */
  import { brancherTemps } from '../temps.js';
  let { arbre, reponses = true } = $props();

  let e = $state(0);
  let hote = $state(null);
  const TOTAL = $derived(reponses ? 3 : 2);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  const W = 1000, H = $derived(reponses ? 540 : 430);
  const RACINE = { y: 30, h: 80, w: 330 };
  const DIM = { y: 190, h: 60 };
  const Q = { y: 320, h: 52 };
  const R = { y: 450, h: 44 };
  // Les questions, réparties sur toute la largeur; chaque dimension au-dessus
  // du centre des siennes.
  const toutes = $derived(arbre.dims.flatMap((d, i) => d.qs.map((q) => ({ ...q, dim: i }))));
  const nq = $derived(toutes.length);
  const marge = 20;
  const pas = $derived((W - 2 * marge) / nq);
  const qw = $derived(Math.min(150, pas - 8));
  const fq = $derived(nq > 6 ? 13 : 16);
  const qx = (i) => marge + pas * (i + 0.5);
  const dims = $derived(arbre.dims.map((d, i) => {
    const idx = toutes.map((q, k) => (q.dim === i ? k : -1)).filter((k) => k >= 0);
    const cx = (qx(idx[0]) + qx(idx[idx.length - 1])) / 2;
    return { ...d, cx, w: Math.min(280, Math.max(170, pas * idx.length - 30)) };
  }));
  const NOTES = $derived([
    'On ne peut pas l’observer directement.',
    'Le concept a plusieurs facettes.',
    'Chaque facette se demande.',
    'Les réponses : la seule chose qu’on a vraiment.'
  ]);
</script>

<div class="visuel m9a" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Un arbre : le concept en haut, en pointillé parce qu'il est invisible, ses dimensions en dessous, puis les questions posées, puis les réponses observées, en rouge.">
    <!-- liens -->
    {#each dims as d, i}
      <line x1={W / 2} y1={RACINE.y + RACINE.h} x2={d.cx} y2={DIM.y} class="m9a-lien m9a-t" class:vu={e >= 1} />
    {/each}
    {#each toutes as q, k}
      <line x1={dims[q.dim].cx} y1={DIM.y + DIM.h} x2={qx(k)} y2={Q.y} class="m9a-lien m9a-t" class:vu={e >= 2} />
      {#if reponses}
        <line x1={qx(k)} y1={Q.y + Q.h} x2={qx(k)} y2={R.y} class="m9a-lien m9a-rouge m9a-t" class:vu={e >= 3} />
      {/if}
    {/each}

    <!-- racine -->
    <rect x={W / 2 - RACINE.w / 2} y={RACINE.y} width={RACINE.w} height={RACINE.h} class="m9a-racine" />
    <text x={W / 2} y={RACINE.y + 36} class="m9a-nom">{arbre.racine}</text>
    <text x={W / 2} y={RACINE.y + 64} class="m9a-sous">{arbre.sous}</text>

    <!-- dimensions -->
    {#each dims as d}
      <g class="m9a-t" class:vu={e >= 1}>
        <rect x={d.cx - d.w / 2} y={DIM.y} width={d.w} height={DIM.h} class="m9a-boite" />
        <text x={d.cx} y={DIM.y + 38} class="m9a-dim">{d.nom}</text>
      </g>
    {/each}

    <!-- questions -->
    {#each toutes as q, k}
      <g class="m9a-t" class:vu={e >= 2}>
        <rect x={qx(k) - qw / 2} y={Q.y} width={qw} height={Q.h} class="m9a-boite m9a-q" />
        {#if q.q.includes('\n')}
          <text x={qx(k)} y={Q.y + 22} class="m9a-qt" style="font-size: {fq}px">{q.q.split('\n')[0]}</text>
          <text x={qx(k)} y={Q.y + 42} class="m9a-qt" style="font-size: {fq}px">{q.q.split('\n')[1]}</text>
        {:else}
          <text x={qx(k)} y={Q.y + 32} class="m9a-qt" style="font-size: {fq}px">{q.q}</text>
        {/if}
      </g>
    {/each}

    <!-- réponses -->
    {#if reponses}
      {#each toutes as q, k}
        <g class="m9a-t" class:vu={e >= 3}>
          <rect x={qx(k) - qw / 2} y={R.y} width={qw} height={R.h} class="m9a-rep" />
          <text x={qx(k)} y={R.y + 28} class="m9a-rt">{q.r}</text>
        </g>
      {/each}
      <text x={marge} y={R.y + R.h + 34} class="m9a-obs m9a-t" class:vu={e >= 3}>ce qu’on observe</text>
    {/if}
    <text x={W - marge} y={RACINE.y + RACINE.h / 2 + 8} class="m9a-inv">invisible</text>
  </svg>
  {#key e}
    <p class="m9a-note">{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9a { display: flex; flex-direction: column; gap: 0.4em; align-items: center; }
  svg { width: 100%; max-width: 62em; height: auto; max-height: 62vh; display: block; }
  text { font-family: var(--dk-mono); text-anchor: middle; fill: var(--dk-encre); }
  .m9a-racine { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 12 8; }
  .m9a-nom { font-size: 28px; font-weight: 700; }
  .m9a-sous { font-size: 17px; fill: var(--dk-gris); }
  .m9a-inv { font-size: 17px; fill: var(--dk-gris); text-anchor: end; font-style: italic; }
  .m9a-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m9a-dim { font-size: 23px; font-weight: 700; }
  .m9a-q { fill: var(--dk-fond-2); }
  .m9a-qt { font-size: 16px; font-weight: 600; }
  .m9a-rep { fill: #fff; stroke: var(--dk-accent); stroke-width: 3; }
  .m9a-rt { font-size: 15px; fill: var(--dk-accent); font-weight: 600; }
  .m9a-obs { font-size: 17px; fill: var(--dk-accent); text-anchor: start; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; }
  .m9a-lien { stroke: var(--dk-encre); stroke-width: 3; }
  .m9a-rouge { stroke: var(--dk-accent); }
  .m9a-t { opacity: 0; transition: opacity 0.45s; }
  .m9a-t.vu { opacity: 1; }
  .m9a-note { margin: 0; font-size: 1.05em; font-weight: 600; animation: m9a-fondu 0.4s both; }
  @keyframes m9a-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .m9a-t { transition: none; } .m9a-note { animation: none; } }
</style>
