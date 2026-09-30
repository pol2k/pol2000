<script>
  /**
   * Même code, deux tailles d'échantillon. Le graphique des intervalles de
   * confiance de la position gauche-droite moyenne par parti, dessiné par R
   * deux fois avec le même code : sur tou.te.s les partisan.e.s de l'Étude
   * électorale canadienne 2025, puis sur 200 d'entre elles et eux tiré.e.s
   * au hasard (GGPLOT.ic et GGPLOT.icPetit dans src/lib/data/seance5.js,
   * images static/img/s5-ic.png et s5-ic-petit.png, outils/seance5_data.R).
   *
   *   0  À gauche, le graphique complet ; sa légende donne le nombre total
   *      de partisan.e.s (somme de GGPLOT.ic.n).
   *   1  À droite, le petit échantillon (somme de GGPLOT.icPetit.n), et la
   *      taille du plus petit groupe (le minimum de GGPLOT.icPetit.n).
   *   2  Une ligne sous les deux.
   *
   * Côte à côte plutôt qu'empilées : à 16:9, deux images de 16:9 sont bien
   * plus grandes l'une à côté de l'autre.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { GGPLOT } from '$lib/data/seance5.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const somme = (n) => Object.values(n).reduce((s, v) => s + v, 0);
  const fr = (x) => x.toLocaleString('fr-CA');
  // Les partis tels que R les nomme (« 5. Green Party »), en français.
  const PARTIS = {
    'Liberal Party': 'Parti libéral',
    'Conservative Party': 'Parti conservateur',
    NDP: 'NPD',
    'Bloc Québécois': 'Bloc québécois',
    'Green Party': 'Parti vert'
  };
  const [nomMin, nMin] = Object.entries(GGPLOT.icPetit.n).sort((a, b) => a[1] - b[1])[0];
  const brut = nomMin.replace(/^\d+\.\s*/, '');
  const PLUS_PETIT = { nom: PARTIS[brut] ?? brut, n: nMin };

  const IMAGES = [
    {
      image: GGPLOT.ic.image,
      legende: `${fr(somme(GGPLOT.ic.n))} partisan.e.s`,
      alt: 'La position gauche-droite moyenne de chaque parti, avec son intervalle de confiance, calculée sur toutes les personnes partisanes : des intervalles très courts.'
    },
    {
      image: GGPLOT.icPetit.image,
      legende: `${fr(somme(GGPLOT.icPetit.n))} tiré.e.s au hasard`,
      alt: 'Le même graphique sur 200 personnes tirées au hasard : des intervalles bien plus larges, surtout pour le Parti vert.'
    }
  ];
</script>

<div class="visuel deux-ic" bind:this={hote}>
  <div class="di-paire">
    {#each IMAGES as im, i}
      <figure class="di-fig" class:di-vu={e >= i}>
        <figcaption>
          <span class="di-leg">{im.legende}</span>
          <!-- La ligne de note existe des deux côtés : les deux images partent à la même hauteur. -->
          <span class="di-note">{#if i === 1}dont <b>{PLUS_PETIT.n}</b> pour le {PLUS_PETIT.nom}{:else}&nbsp;{/if}</span>
        </figcaption>
        <img class="di-img" src="{base}/img/{im.image}" alt={im.alt} />
      </figure>
    {/each}
  </div>
  <div class="di-fin" class:di-vu={e >= 2}>Moins de monde, des fourchettes plus larges : plus dur de dire que ce n’est pas le hasard.</div>
</div>

<style>
  .deux-ic { display: flex; flex-direction: column; gap: 0.9em; }
  .di-paire { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.2em; }
  .di-fig { margin: 0; display: flex; flex-direction: column; gap: 0.4em; min-width: 0; visibility: hidden; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .di-fig.di-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.4s, transform 0.4s; }
  figcaption { display: flex; flex-direction: column; gap: 0.1em; }
  .di-leg { font-size: 1.05em; font-weight: 600; line-height: 1.25; color: var(--dk-encre); }
  .di-note { font-size: 0.72em; line-height: 1.3; color: var(--dk-gris); }
  .di-note b { color: var(--dk-accent); font-weight: 700; }
  .di-img { display: block; width: auto; height: auto; max-width: calc(100% - 4px); max-height: 20em; border: 2px solid var(--dk-encre); }
  .di-fin { font-size: 0.95em; font-weight: 600; line-height: 1.35; color: var(--dk-encre); visibility: hidden; opacity: 0; transition: opacity 0.4s, visibility 0s 0.4s; }
  .di-fin.di-vu { visibility: visible; opacity: 1; transition: opacity 0.4s; }

  @media (prefers-reduced-motion: reduce) {
    .di-fig, .di-fig.di-vu, .di-fin, .di-fin.di-vu { transition: none; transform: none; }
  }
</style>
