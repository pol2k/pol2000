<script>
  /**
   * Le vrai article en toile de fond : les pages 425 à 428 de Blais et
   * Gélineau (2007), empilées, défilent d'un passage à l'autre; le passage
   * est surligné là où il est imprimé, et l'explication se pose par-dessus
   * (même geste que le tableau 2, M8Tableau2). Pour montrer que ce qu'on
   * enseigne est écrit, noir sur blanc, dans un article publié.
   *
   *   etats   un tableau, un élément par temps (le premier est l'arrivée) :
   *           { passages: [{ phrase, ton, tag }], focus }
   *             phrase  le texte exact de l'article (article.js le retrouve;
   *                     une phrase absente fait échouer la page);
   *             ton     'rouge' (défaut), 'encre', 'x' ou 'y';
   *             tag     une courte étiquette (X, Y, 1…) dans la marge, à la
   *                     hauteur de la première ligne du passage;
   *             focus   l'indice du passage à centrer (défaut 0), ou
   *                     { page, y } en % pour viser un endroit sans surligner;
   *             vue     'page' : la première page entière, réduite pour
   *                     tenir dans la fenêtre (la une de l'article); le temps
   *                     suivant zoome dans le texte, sans coupure.
   *   note    snippet (e) : l'explication du temps e, posée sur la page.
   *   e       le temps en cours (bind:e), pour qu'un parent suive la marche
   *           (M8Fil change le titre et la bande des étapes avec lui).
   *
   * Une fois le passage montré, le document se promène librement à la
   * molette ou au doigt (libre.js); le temps suivant le ramène au passage.
   *
   * Pages et boîtes des mots : outils/seance8_article.py →
   * static/img/s8-art-p*.png et src/lib/data/seance8_article.js.
   */
  import { base } from '$app/paths';
  import { fly } from 'svelte/transition';
  import { brancherTemps } from '../temps.js';
  import { trouver } from '../article.js';
  import { defilementLibre } from '../libre.js';
  import { PAGES, MOTS } from '$lib/data/seance8_article.js';

  let { etats, note, e = $bindable(0) } = $props();

  // Chaque passage, retrouvé dans l'article une fois pour toutes.
  const RES = etats.map((et) => ({ ...et, passages: (et.passages || []).map((p) => ({ ton: 'rouge', ...p, ...trouver(MOTS, p.phrase) })) }));

  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: RES.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La géométrie, en pixels, d'après la largeur de la colonne.
  let larg = $state(0);
  let haut = $state(0);
  let largVue = $state(0);
  const ECART = 0.03; // l'espace entre deux pages, en fraction de la largeur
  const hauteurs = $derived(PAGES.map((p) => (larg * p.h) / p.l));
  const hauts = $derived(hauteurs.reduce((acc, h, i) => [...acc, i ? acc[i - 1] + hauteurs[i - 1] + larg * ECART : 0], []));
  const total = $derived(hauts.length ? hauts[hauts.length - 1] + hauteurs[hauteurs.length - 1] : 0);

  const cible = (et) => {
    if (et.focus && typeof et.focus === 'object') return { page: et.focus.page, y: et.focus.y, fin: et.focus.y };
    return et.passages[et.focus ?? 0] || { page: 0, y: 0, fin: 0 };
  };
  const etat = $derived(RES[e]);
  const borne = (y) => Math.max(0, Math.min(total - haut, y));
  const decalage = $derived.by(() => {
    if (!larg || !haut) return 0;
    const c = cible(etat);
    const y = hauts[c.page] + (((c.y + c.fin) / 2) * hauteurs[c.page]) / 100;
    return borne(y - haut * 0.42);
  });

  // La une : la première page entière, réduite et centrée à gauche de la
  // carte (la colonne du document commence à 2,5 % et la carte à 64,5 %).
  const pleine = $derived(etat.vue === 'page');
  const reduit = $derived.by(() => {
    if (!pleine || !larg || !haut) return null;
    const s = (haut * 0.94) / hauteurs[0];
    return { s, x: (largVue * 0.64 - s * larg) / 2 - largVue * 0.025, y: haut * 0.03 };
  });

  // Le défilement libre : un écart au passage, remis à zéro à chaque temps.
  let libre = $state(0);
  let glisse = $state(false);
  let minuterie;
  $effect(() => { e; libre = 0; glisse = false; });
  const y = $derived(borne(decalage + libre));
  let vue = $state(null);
  $effect(() => {
    if (!vue) return;
    return defilementLibre(vue, {
      actif: () => !pleine,
      deplacer: (dy) => {
        libre = borne(decalage + libre + dy) - decalage;
        glisse = true;
        clearTimeout(minuterie);
        minuterie = setTimeout(() => (glisse = false), 200);
      }
    });
  });
  // La page au milieu de la fenêtre (elle suit aussi le défilement libre).
  const pageVue = $derived.by(() => {
    if (pleine || !haut) return cible(etat).page;
    const m = y + haut * 0.42;
    let p = 0;
    hauts.forEach((h, i) => { if (h <= m) p = i; });
    return p;
  });
  const transforme = $derived(reduit ? `translate(${reduit.x}px, ${reduit.y}px) scale(${reduit.s})` : `translateY(${-y}px)`);
</script>

<div class="visuel m8a" bind:this={hote}>
  <div class="m8a-vue" class:m8a-pleine={pleine} bind:this={vue} bind:clientHeight={haut} bind:clientWidth={largVue}>
    <div class="m8a-doc" class:m8a-glisse={glisse} bind:clientWidth={larg} style="transform: {transforme}">
      {#each PAGES as p, i}
        <div class="m8a-page" style="aspect-ratio: {p.l} / {p.h}; margin-bottom: {i < PAGES.length - 1 ? larg * ECART : 0}px">
          <img src="{base}/img/{p.img}" alt="Blais et Gélineau (2007), page {425 + i}" />
          {#each etat.passages as pa, k (e + '-' + k)}
            {#each pa.rects.filter((r) => r.page === i) as r, j}
              <span class="m8a-surl m8a-{pa.ton}" style="left: {r.x - 0.4}%; top: {r.y - 0.25}%; width: {r.l + 0.8}%; height: {r.h + 0.5}%; --d: {0.9 + (k * 3 + j) * 0.12}s"></span>
            {/each}
            {#if pa.tag && pa.rects[0].page === i}
              <span class="m8a-tag m8a-tag-{pa.ton}" style="top: {pa.rects[0].y + pa.rects[0].h / 2}%; --d: {0.9 + k * 0.3}s">{pa.tag}</span>
            {/if}
          {/each}
        </div>
      {/each}
    </div>

    {#if note}
      <div class="m8a-note">
        {#key e}
          <div class="m8a-carte" in:fly={{ y: 14, delay: 850, duration: 450 }}>{@render note(e)}</div>
        {/key}
      </div>
    {/if}

    <div class="m8a-rail" aria-hidden="true">
      {#each PAGES as _, i}<span class:on={i === pageVue}>p. {425 + i}</span>{/each}
    </div>
  </div>
  <p class="m8a-src">Blais et Gélineau (2007), <em>Political Studies</em>, 55(2), p. {425 + pageVue}</p>
</div>

<style>
:global(.diapo-in:has(> .m8a)) { max-width: none; padding-bottom: 2.4em; justify-content: stretch; }

  .m8a { flex: 1 1 auto; min-height: 0; display: grid; grid-template-rows: minmax(0, 1fr) auto; gap: 0.3em; margin-top: 0.4em; }
  .m8a-vue { position: relative; min-height: 0; overflow: hidden; border-top: 2px solid var(--dk-filet); border-bottom: 2px solid var(--dk-filet); background: var(--dk-fond-2); touch-action: none; cursor: grab; }
  .m8a-vue.m8a-pleine { cursor: default; }
  .m8a-doc { position: absolute; top: 0; left: 2.5%; width: 60%; transform-origin: 0 0; transition: transform 1.3s cubic-bezier(0.65, 0, 0.35, 1); }
  .m8a-doc.m8a-glisse { transition: transform 0.15s ease-out; }
  .m8a-page { position: relative; background: #fff; border: 1px solid var(--dk-filet); }
  .m8a-page { transition: opacity 0.6s; }
  /* La une : les pages suivantes s'effacent, elles reviennent au zoom. */
  .m8a-pleine .m8a-page + .m8a-page { opacity: 0; }
  .m8a-page img { display: block; width: 100%; height: 100%; }

  /* Le surligneur : il balaie la ligne de gauche à droite, après le défilement. */
  .m8a-surl { position: absolute; mix-blend-mode: multiply; transform-origin: left center; animation: m8a-balai 0.45s ease-out var(--d) both; }
  .m8a-rouge { background: rgba(198, 16, 46, 0.24); }
  .m8a-encre { background: rgba(20, 20, 20, 0.13); }
  .m8a-x { background: rgba(20, 20, 20, 0.16); border-bottom: 3px solid var(--dk-encre); }
  .m8a-y { background: rgba(198, 16, 46, 0.24); border-bottom: 3px solid var(--dk-accent); }
  @keyframes m8a-balai { from { transform: scaleX(0); } to { transform: scaleX(1); } }

  .m8a-tag { position: absolute; left: -0.35em; transform: translate(-100%, -50%); font-size: 0.62em; font-weight: 700; line-height: 1; padding: 0.3em 0.55em; color: var(--dk-fond); background: var(--dk-accent); white-space: nowrap; animation: m8a-paraitre 0.35s ease-out var(--d) both; }
  .m8a-tag-encre, .m8a-tag-x { background: var(--dk-encre); }
  @keyframes m8a-paraitre { from { opacity: 0; } to { opacity: 1; } }

  /* L'explication, posée sur le bord de la page. */
  .m8a-note { position: absolute; top: 0; bottom: 0; left: 64.5%; right: 5.5%; display: flex; align-items: center; pointer-events: none; }
  .m8a-carte { width: 100%; background: var(--dk-fond); border: 2px solid var(--dk-encre); border-left: 8px solid var(--dk-accent); padding: 0.9em 1.1em; display: flex; flex-direction: column; gap: 0.5em; }

  .m8a-rail { position: absolute; right: 0.8%; top: 50%; transform: translateY(-50%); display: flex; flex-direction: column; gap: 0.5em; }
  .m8a-rail span { font-size: 0.55em; color: var(--dk-gris); border-left: 3px solid var(--dk-filet); padding-left: 0.4em; transition: color 0.4s, border-color 0.4s; }
  .m8a-rail span.on { color: var(--dk-accent); border-color: var(--dk-accent); font-weight: 700; }

  .m8a-src { margin: 0; font-size: 0.6em; color: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .m8a-doc { transition: none; }
    .m8a-surl, .m8a-tag { animation: none; }
  }
</style>
