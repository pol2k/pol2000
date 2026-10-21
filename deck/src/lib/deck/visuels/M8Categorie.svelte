<script>
  /**
   * Une variable catégorielle : le diplôme en cinq catégories, avec l'âge,
   * « femme », le revenu et le Québec. Toute la CES (modele4 de l'atelier :
   * on le refait après la pause). Une catégorie sert de référence (secondaire
   * non terminé) : elle n'a pas de coefficient, elle vaut 0. Chaque autre
   * coefficient est un écart avec elle.
   *
   *   0  la référence seule, posée sur 0;
   *   1  les quatre autres catégories : leur écart avec la référence, et
   *      l'intervalle de confiance à 95 %;
   *   2  une seule, le collégial, se lit en phrase.
   *
   * Tout vient de COEFS.modele4 et COEFS.diplomes (src/lib/data/seance8.js).
   */
  import { brancherTemps } from '../temps.js';
  import { COEFS } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const NOMS = Object.keys(COEFS.diplomes);
  const court = (n) => n.replace(/^\d\. /, '');
  const cats = NOMS.map((n, i) => {
    const c = COEFS.modele4.find((k) => k.terme === 'diplome' + n);
    return { nom: court(n), n: COEFS.diplomes[n], b: c ? c.b : 0, bas: c?.bas, haut: c?.haut, ref: i === 0 };
  });
  const Y0 = 390, H = 1500; // 0,2 → 300 px
  const py = (v) => Y0 - v * H;
  const bx = (i) => 110 + i * 180;
  const W = 120;
  const COL = 2; // le collégial
  // Les noms sur deux lignes, pour ne pas se chevaucher.
  const deux = (n) => (n.includes(', ') ? [n.split(', ')[0] + ',', n.split(', ')[1]] : n.includes(' non ') ? ['Secondaire', 'non terminé'] : [n]);
</script>

<div class="visuel m8c" bind:this={hote}>
  <svg viewBox="0 0 1000 520" role="img" aria-label="Le diplôme en cinq catégories. Référence : secondaire non terminé, à 0. {cats.slice(1).map((c) => `${c.nom} ${sg(c.b)}`).join(', ')}.">
    {#each [0.05, 0.1, 0.15] as t}
      <line x1="60" y1={py(t)} x2="980" y2={py(t)} class="grille" />
      <text x="52" y={py(t) + 6} class="tick">{f(t)}</text>
    {/each}
    <line x1="60" y1={Y0} x2="980" y2={Y0} class="zero" />
    <text x="52" y={Y0 + 6} class="tick">0</text>
    <text x="60" y="34" class="ent">écart d’intérêt avec la référence (sur 1), à âge, genre, revenu et région égaux</text>

    {#each cats as c, i}
      {#if c.ref}
        <rect x={bx(i)} y={Y0 - 4} width={W} height="8" class="ref" />
        <text x={bx(i) + W / 2} y={Y0 - 22} class="refl">référence</text>
      {:else}
        <g class="etape" class:vu={e >= 1}>
          <rect x={bx(i)} y={py(c.b)} width={W} height={Y0 - py(c.b)} class="barre" class:hors={e >= 2 && i !== COL} class:choisie={e >= 2 && i === COL} />
          <line x1={bx(i) + W / 2} y1={py(c.bas)} x2={bx(i) + W / 2} y2={py(c.haut)} class="ic" />
          <text x={bx(i) + W / 2} y={py(c.haut) - 12} class="val">{sg(c.b)}</text>
        </g>
      {/if}
      <text x={bx(i) + W / 2} y={Y0 + 30} class="cat" class:cat-ref={c.ref}>{#each deux(c.nom) as l, k}<tspan x={bx(i) + W / 2} dy={k ? 20 : 0}>{l}</tspan>{/each}</text>
      <text x={bx(i) + W / 2} y={Y0 + 78} class="n">{nb(c.n)}</text>
    {/each}

    <g class="etape" class:vu={e >= 2}>
      <text x="60" y="76" class="phrase">collégial plutôt que secondaire non terminé{' '}: <tspan class="rouge">{sg(cats[COL].b)}</tspan>, soit {f(cats[COL].b * 10, 1)} point sur 10</text>
    </g>
    <text x="0" y="514" class="source">Toute la CES · les {nb(COEFS.n.modele4)} personnes du modèle · on le refait à l’atelier</text>
  </svg>
</div>

<style>
  .m8c { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 66vh; display: block; }
  text { font-family: var(--dk-mono); }
  .grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .zero { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 16px; fill: var(--dk-gris); text-anchor: end; }
  .ent { font-size: 17px; fill: var(--dk-gris); }
  .ref { fill: var(--dk-accent); }
  .refl { font-size: 20px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .barre { fill: var(--dk-encre); transition: fill 0.3s, opacity 0.3s; }
  .barre.hors { opacity: 0.25; }
  .barre.choisie { fill: var(--dk-accent); }
  .ic { stroke: var(--dk-gris-2); stroke-width: 3; }
  .val { font-size: 22px; font-weight: 700; fill: var(--dk-encre); text-anchor: middle; }
  .cat { font-size: 16px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }
  .cat-ref { fill: var(--dk-accent); }
  .n { font-size: 14px; fill: var(--dk-gris); text-anchor: middle; }
  .phrase { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .rouge { fill: var(--dk-accent); font-weight: 700; }
  .source { font-size: 15px; fill: var(--dk-gris); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .etape, .barre { transition: none; } }
</style>
