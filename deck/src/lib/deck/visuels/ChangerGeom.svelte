<script>
  /**
   * Changer de géométrie : les mêmes données, un autre graphique, en
   * changeant un mot du code. En haut, le code exact ; dessous, l'image
   * que R a rendue avec ce code (GG_GEOMS dans src/lib/data/seance5_ggplot.js,
   * images static/img/s5-g-geom-*.png, produits par outils/seance5_ggplot.R).
   * Rien n'est redessiné ici : c'est la sortie de R.
   *
   *   etapes : [{ cle, cibles }] dans l'ordre. cle est une clé de GG_GEOMS ;
   *            cibles, les morceaux du code qui ont changé, encadrés de
   *            rouge. La première étape est l'état 0, chaque clic passe à la
   *            suivante.
   *
   * Le code tient en deux lignes : il va en haut, gros, lisible du fond de
   * la salle. Dessous, l'image, et à sa droite la liste des géométries de
   * la diapo, celle qu'on voit en rouge. Comme Couches.svelte, toutes les
   * images et tous les blocs de code sont rendus d'emblée, empilés dans la
   * même case, un seul visible : pas d'éclair, pas de saut de mise en page.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { GG_GEOMS } from '$lib/data/seance5_ggplot.js';

  let { etapes = [], source = GG_GEOMS } = $props();

  // Le code coupé en morceaux : [{ html, cible }], dans l'ordre du texte.
  const decouper = (code, cibles) => {
    const morceaux = [];
    let reste = code;
    while (reste.length) {
      let premier = null;
      for (const c of cibles) {
        const i = reste.indexOf(c);
        if (i >= 0 && (!premier || i < premier.i)) premier = { i, c };
      }
      if (!premier) { morceaux.push({ html: surlignerR(reste), cible: false }); break; }
      if (premier.i > 0) morceaux.push({ html: surlignerR(reste.slice(0, premier.i)), cible: false });
      morceaux.push({ html: surlignerR(premier.c), cible: true });
      reste = reste.slice(premier.i + premier.c.length);
    }
    return morceaux;
  };

  const ETAPES = $derived(
    etapes.map(({ cle, cibles = [] }) => ({
      cle,
      image: source[cle].image,
      morceaux: decouper(source[cle].code, cibles),
      // Le nom de la géométrie, pour la liste : geom_point, geom_bar…
      nom: (source[cle].code.match(/geom_\w+/) || [cle])[0]
    }))
  );
  const total = $derived(Math.max(0, etapes.length - 1));

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || total === 0) return;
    e = 0;
    return brancherTemps(hote, { total, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel changer-geom" bind:this={hote}>
  <div class="cg-pile">
    {#each ETAPES as s, i}
      <pre class="cg-code" class:cg-vu={i === e} aria-hidden={i !== e}>{#each s.morceaux as m}{#if m.cible}<span class="cg-cible">{@html m.html}</span>{:else}{@html m.html}{/if}{/each}</pre>
    {/each}
  </div>
  <div class="cg-bas">
    <div class="cg-images">
      {#each ETAPES as s, i}
        <img
          class="cg-img"
          class:cg-vu={i === e}
          src="{base}/img/{s.image}"
          alt="Le graphique que R dessine avec le code du haut"
          aria-hidden={i !== e}
          decoding="async"
        />
      {/each}
    </div>
    <ol class="cg-liste">
      {#each ETAPES as s, i}
        <li class:cg-ici={i === e} class:cg-passe={i < e}>{s.nom}()</li>
      {/each}
    </ol>
  </div>
</div>

<style>
  /* Le code en haut, gros : deux lignes, lisibles du fond de la salle. Dessous,
     l'image et, à sa droite, la liste des géométries de la diapo. */
  .changer-geom { display: flex; flex-direction: column; gap: 0.8em; align-items: flex-start; }

  .cg-pile { display: grid; max-width: 100%; }
  .cg-code {
    grid-area: 1 / 1;
    margin: 0;
    font-family: var(--dk-mono);
    font-size: 0.95em;
    line-height: 1.5;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
    background: var(--dk-fond-2);
    border: 2px solid var(--dk-encre);
    border-left: 0.3em solid var(--dk-accent);
    padding: 0.35em 0.9em;
    color: var(--dk-encre);
    visibility: hidden;
    opacity: 0;
    transition: opacity 0.3s, visibility 0s 0.3s;
  }
  .cg-code.cg-vu { visibility: visible; opacity: 1; transition: opacity 0.3s; }
  .cg-cible { outline: 0.12em solid var(--dk-accent); outline-offset: 0.08em; background: var(--dk-fond); }

  .cg-bas { display: flex; gap: 1.4em; align-items: flex-start; width: 100%; }

  /* L'image : aussi haute que la diapo le permet sous le code. */
  .cg-images { flex: 0 1 auto; min-width: 0; display: grid; grid-template-columns: minmax(0, 1fr); }
  .cg-img {
    grid-area: 1 / 1;
    justify-self: start;
    display: block;
    width: auto;
    height: auto;
    max-width: calc(100% - 4px);
    max-height: min(57vh, 21.5em);
    border: 2px solid var(--dk-encre);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0s 0.35s, visibility 0s 0.35s;
  }
  .cg-img.cg-vu { opacity: 1; visibility: visible; z-index: 1; transition: opacity 0.3s; }

  /* Les géométries de la diapo, en colonne : celle qu'on voit en rouge. */
  .cg-liste { flex: 0 0 auto; list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.5em; font-family: var(--dk-mono); }
:global(.diapo) .cg-liste li { font-size: 0.8em; color: var(--dk-gris-2); padding-left: 0.6em; border-left: 0.3em solid transparent; transition: color 0.3s, border-color 0.3s; }
:global(.diapo) .cg-liste li.cg-passe { color: var(--dk-gris); }
:global(.diapo) .cg-liste li.cg-ici { color: var(--dk-accent); font-weight: 600; border-left-color: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .cg-code, .cg-code.cg-vu, .cg-img, .cg-img.cg-vu, .cg-liste li { transition: none; }
  }
</style>
