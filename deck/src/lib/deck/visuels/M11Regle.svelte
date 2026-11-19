<script>
  /**
   * Les deux règles dans R, pas à pas (demande du professeur : le code de R,
   * avec le GOA en haut et l'effet écrit sur chaque flèche). Un seul
   * compteur fait avancer le GOA et les deux consoles : à gauche, on crée
   * les données; à droite, on estime. À côté du GOA, le calcul que fait le
   * modèle.
   *
   *   regle 1  l'éducation → idéologie (× 1), l'éducation → revenu (× 2),
   *            revenu → idéologie (× 0,5). Sans contrôle, le modèle prend les
   *            deux chemins : 1 + 2 × 0,5 = 2. Avec le revenu, il ne garde que
   *            la flèche directe : 1; le 0,5 va au revenu.
   *            revenu des parents → éducation (× 1), → idéologie (× 3);
   *            éducation → idéologie (× 2). Une étape de plus : R montre
   *            qu'un point d'éducation vient avec 0,5 de revenu des parents.
   *            Sans contrôle, le modèle compare des gens qui diffèrent d'un
   *            point d'éducation ET de 0,5 de revenu des parents :
   *            2 + 3 × 0,5 = 3,5. Avec le contrôle : 2. Chiffres tous
   *            différents (demande du professeur), pour qu'aucun raccourci
   *            ne tombe juste.
   *
   *   1-3  une variable par clic (console de gauche), sa boîte et ses
   *        flèches paraissent dans le GOA;
   *   4    lm sans contrôle (console de droite) : les flèches que le modèle
   *        additionne s'épaississent, le calcul s'écrit;
   *   5    lm avec le contrôle : la variable est encadrée, ses flèches
   *        pâlissent, le calcul change.
   *
   * Code et sorties : outils/seance11_data.R (SIMS.regle1, SIMS.regle2);
   * les nombres du calcul : REGLES (même exécution de R).
   */
  import { brancherTemps } from '../temps.js';
  import Console from './Console.svelte';
  import { SIMS, REGLES } from '$lib/data/seance11.js';

  let { regle = 1 } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: sim.length, lire: () => e, ecrire: (v) => (e = v) });
  });

  const R1 = regle === 1;
  const sim = R1 ? SIMS.regle1 : SIMS.regle2;
  const val = R1 ? REGLES.regle1 : REGLES.regle2;
  const BLEU = '#2f6db5';
  const v2 = (x) => x.toFixed(2).replace('.', ',');
  const creer = sim.slice(0, 3).map((l) => ({ ...l, note: '' }));
  const estimer = sim.slice(3).map((l) => ({ ...l, note: '' }));

  // le GOA (viewBox 1400 × 300)
  const W = 250, H = 84;
  const N = R1
    ? { x: { x: 20, y: 30, t: ['Éducation'] }, z: { x: 400, y: 200, t: ['Revenu'] }, y: { x: 780, y: 30, t: ['Idéologie'] } }
    : { z: { x: 330, y: 0, w: 390, t: ['Revenu des parents'] }, x: { x: 20, y: 200, t: ['Éducation'] }, y: { x: 780, y: 200, t: ['Idéologie'] } };
  const A = R1
    ? { xy: { d: 'M 274 72 L 772 72', c: '× 1', lx: 523, ly: 56, vu: 3 },
        xz: { d: 'M 200 118 L 400 220', c: '× 2', lx: 268, ly: 196, vu: 2 },
        zy: { d: 'M 650 220 L 850 118', c: '× 0,5', lx: 790, ly: 196, vu: 3 } }
    : {
        zx: { d: 'M 420 88 L 210 196', c: '× 1', lx: 300, ly: 128, vu: 2 },
        zy: { d: 'M 630 88 L 840 196', c: '× 3', lx: 780, ly: 128, vu: 3 },
        xy: { d: 'M 274 242 L 772 242', c: '× 2', lx: 523, ly: 226, vu: 3 } };
  // les étapes : créer (1-3), [règle 2 : le lien entre X et Z], sans contrôle, avec
  const SANS = sim.length - 1;
  const ctl = $derived(e >= sim.length);
  const modele = $derived(e >= SANS);
  // les flèches que le modèle additionne pour l'éducation
  const pris = (k) => {
    if (!R1 && e === 4) return k === 'zx'; // lm(education ~ revenu_parents) : la flèche × 1
    if (!modele) return false;
    if (k === 'xy') return true;
    return !ctl; // sans contrôle, l'autre chemin (règle 1) ou la porte du revenu des parents (règle 2) est pris aussi
  };
</script>

{#snippet boite(n, cls, vu)}
  <g class="m11g-n {cls}" class:m11g-vu={vu}>
    <rect x={n.x} y={n.y} width={n.w ?? W} height={H} />
    <text x={n.x + (n.w ?? W) / 2} y={n.y + 54}>{n.t[0]}</text>
  </g>
{/snippet}

<div class="visuel m11g" bind:this={hote} style="--bleu: {BLEU}">
  <div class="m11g-haut">
    <svg viewBox="0 -14 1050 314" role="img" aria-label={R1 ? 'GOA : l’éducation agit sur l’idéologie (fois 1) et sur le revenu (fois 2); le revenu agit sur l’idéologie (fois 0,5).' : 'GOA : le revenu des parents agit sur l’éducation (fois 1) et sur l’idéologie (fois 3); l’éducation agit sur l’idéologie (fois 2).'}>
      <defs>
        {#each [['n', 'var(--dk-encre)'], ['r', 'var(--dk-accent)'], ['b', BLEU]] as [k, c] (k)}
          <marker id="m11g-{regle}-{k}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="4.5" markerHeight="4.5" orient="auto"><path d="M0 0 L10 5 L0 10 Z" style="fill: {c}" /></marker>
        {/each}
      </defs>
      {#each Object.entries(A) as [k, a] (k)}
        {@const rouge = !R1 && k !== 'xy'}
        {@const p = pris(k)}
        <g class="m11g-f" class:m11g-vu={e >= a.vu} class:m11g-pale={ctl && k !== 'xy'}>
          <path d={a.d} class:m11g-rouge={rouge} class:m11g-pris={p} class:m11g-bleu={p && !rouge} marker-end="url(#m11g-{regle}-{rouge ? 'r' : p ? 'b' : 'n'})" />
          <text x={a.lx} y={a.ly} class="m11g-coef" class:m11g-rouge={rouge}>{a.c}</text>
        </g>
      {/each}
      {@render boite(N.x, 'm11g-x', R1 ? e >= 1 : e >= 2)}
      {@render boite(N.z, R1 ? '' : 'm11g-z', R1 ? e >= 2 : e >= 1)}
      {@render boite(N.y, '', e >= 3)}
      <rect x={N.z.x - 12} y={N.z.y - 12} width={(N.z.w ?? W) + 24} height={H + 24} class="m11g-cadre" class:m11g-vu={ctl} />
    </svg>

    <div class="m11g-calcul">
      {#if e < 3}
        <span class="m11g-eti">le vrai effet de l’éducation</span>
        <p class="m11g-gris">On crée les données.</p>
      {:else if e === 3}
        <span class="m11g-eti">le vrai effet de l’éducation</span>
        {#if R1}<p class="m11g-grand">1 + 2 × 0,5 = 2</p><p class="m11g-gris">directement, et par le revenu</p>
        {:else}<p class="m11g-grand">2</p><p class="m11g-gris">la flèche de l’éducation</p>{/if}
      {:else if !R1 && e === 4}
        <span class="m11g-eti">l’effet du revenu des parents sur l’éducation</span>
        <p class="m11g-grand"><span class="m11g-r">{v2(val.lien)}</span></p>
        <p class="m11g-gris">R retrouve la flèche × 1.</p>
      {:else if e === SANS}
        <span class="m11g-eti">sans contrôle, le modèle additionne</span>
        {#if R1}<p class="m11g-grand"><span class="m11g-b">1</span> + <span class="m11g-b">2 × 0,5</span> = {v2(val.sans)}</p><p class="m11g-gris">les deux chemins de l’éducation&#8239;: juste</p>
        {:else}<p class="m11g-ligne"><span>l’effet de l’éducation</span><b class="m11g-b">2</b></p><p class="m11g-ligne"><span>un morceau de l’effet du revenu des parents</span><b class="m11g-r">{v2(val.sans - val.vrai)}</b></p><p class="m11g-grand">R donne {v2(val.sans)} à l’éducation</p><p class="m11g-gris">au lieu de 2&#8239;: trop</p>{/if}
      {:else}
        <span class="m11g-eti">avec le contrôle</span>
        {#if R1}<p class="m11g-grand">education&#8239;: <span class="m11g-b">{v2(val.avec)}</span></p><p class="m11g-grand">revenu&#8239;: {v2(val.z)}</p><p class="m11g-gris">le chemin par le revenu est coupé&#8239;: la moitié</p>
        {:else}<p class="m11g-grand">education&#8239;: <span class="m11g-b">{v2(val.avec)}</span></p><p class="m11g-grand"><span class="m11g-r">revenu_parents&#8239;: {v2(val.z)}</span></p>{/if}
      {/if}
    </div>
  </div>

  <div class="m11g-bas">
    <div><span class="m11g-eti">créer les données</span><Console lignes={creer} pilote={Math.min(e, 3)} /></div>
    <div><span class="m11g-eti">estimer</span><Console lignes={estimer} pilote={Math.max(0, e - 3)} /></div>
  </div>
</div>

<style>
  .m11g { width: 100%; display: flex; flex-direction: column; gap: 0.35em; }
  .m11g-haut { display: grid; grid-template-columns: minmax(0, 1.5fr) minmax(0, 1fr); gap: 1.2em; align-items: center; }
  .m11g-haut svg { width: 100%; height: auto; max-height: 21vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .m11g-n, .m11g-f { opacity: 0; transition: opacity 0.5s; }
  .m11g-vu { opacity: 1; }
  .m11g-f.m11g-vu.m11g-pale { opacity: 0.25; }
  .m11g-n rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .m11g-n text { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m11g-x rect { stroke: var(--bleu); fill: color-mix(in srgb, var(--bleu) 10%, var(--dk-fond)); }
  .m11g-x text { fill: var(--bleu); }
  .m11g-z rect { stroke: var(--dk-accent); }
  .m11g-z text { fill: var(--dk-accent); }
  .m11g-f path { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: stroke-width 0.4s, stroke 0.4s; }
  .m11g-f path.m11g-rouge { stroke: var(--dk-accent); }
  .m11g-f path.m11g-bleu { stroke: var(--bleu); }
  .m11g-f path.m11g-pris { stroke-width: 9; }
  .m11g-coef { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; }
  .m11g-coef.m11g-rouge { fill: var(--dk-accent); }
  .m11g-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 7; opacity: 0; transition: opacity 0.4s; }
  .m11g-cadre.m11g-vu { opacity: 1; }

  .m11g-calcul { border-left: 4px solid var(--dk-encre); padding: 0.3em 0 0.3em 0.9em; display: flex; flex-direction: column; gap: 0.2em; }
  .m11g-eti { font-size: 0.6em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m11g-grand { margin: 0; font-size: 1.15em; font-weight: 700; line-height: 1.3; font-family: var(--dk-mono); }
  .m11g-gris { margin: 0; font-size: 0.8em; color: var(--dk-gris); }
  .m11g-b { color: var(--bleu); }
  .m11g-ligne { margin: 0; display: flex; justify-content: space-between; gap: 1em; font-size: 0.85em; border-bottom: 1px solid var(--dk-filet); padding-bottom: 0.15em; }
  .m11g-ligne b { font-family: var(--dk-mono); }
  .m11g-r { color: var(--dk-accent); }

  .m11g-bas { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1fr); gap: 1em; align-items: start; }
  .m11g-bas > div { display: flex; flex-direction: column; gap: 0.2em; min-width: 0; }
  @media (prefers-reduced-motion: reduce) { .m11g-n, .m11g-f, .m11g-cadre, .m11g-f path { transition: none; } }
</style>
