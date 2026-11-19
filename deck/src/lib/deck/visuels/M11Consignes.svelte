<script>
  /**
   * Les consignes (travail final, examen 2), lues en classe par le
   * professeur, à son rythme : aucun défilement automatique, aucun
   * surlignage imposé (demande du professeur). Le PDF défile à la molette
   * ou au pavé tactile, sans changer de diapo (overscroll contenu). Un clic
   * sur une ligne la surligne en rouge; un deuxième clic l'efface. Le
   * bouton « effacer » retire tout.
   *
   *   doc  'tpfinal'  le travail final (travaux/POL-2000_A26_travail_final.pdf);
   *        'examen2'  l'examen 2 (ouvre le jeudi 19 novembre 2026 à 18h30 :
   *                   ne pas publier avant).
   *
   * Pages et boîtes des mots : outils/seance11_article.py. Les lignes
   * cliquables sont regroupées à partir des boîtes des mots.
   */
  import { base } from '$app/paths';
  import * as TP from '$lib/data/seance11_tpfinal.js';

  let { doc = 'tpfinal' } = $props();
  const D = { d: TP, nom: 'Travail final, consignes', source: 'Travail final · consignes · POL-2000, automne 2026' };

  // Les lignes : les mots d'une même page à la même hauteur, côte à côte.
  const LIGNES = [];
  for (const [p, x, y, l, h] of D.d.MOTS) {
    const der = LIGNES.find((g) => g.p === p && Math.abs(g.y - y) < h * 0.5 && x - (g.x + g.l) < 6);
    if (der) {
      der.l = Math.max(der.x + der.l, x + l) - Math.min(der.x, x);
      der.x = Math.min(der.x, x);
      der.h = Math.max(der.h, h);
    } else LIGNES.push({ p, x, y, l, h });
  }

  let surlignees = $state(new Set());
  const basculer = (i, ev) => {
    ev.stopPropagation();
    const s = new Set(surlignees);
    s.has(i) ? s.delete(i) : s.add(i);
    surlignees = s;
  };
  const effacer = (ev) => { ev.stopPropagation(); surlignees = new Set(); };
</script>

<div class="visuel m11k">
  <div class="m11k-vue">
    {#each D.d.PAGES as pg, i (i)}
      <div class="m11k-page" style="aspect-ratio: {pg.l} / {pg.h}">
        <img src="{base}/img/{pg.img}" alt="{D.nom}, page {i + 1}" draggable="false" />
        {#each LIGNES as g, k (k)}
          {#if g.p === i}
            <button class="m11k-ligne" class:on={surlignees.has(k)} style="left: {g.x - 0.4}%; top: {g.y - 0.3}%; width: {g.l + 0.8}%; height: {g.h + 0.6}%" onclick={(ev) => basculer(k, ev)} aria-label="Surligner cette ligne"></button>
          {/if}
        {/each}
      </div>
    {/each}
  </div>
  <div class="m11k-bas">
    <span>{D.source}</span>
    {#if surlignees.size}<button class="m11k-effacer" onclick={effacer}>effacer les surlignés</button>{/if}
  </div>
</div>

<style>
:global(.diapo-in:has(> .m11k)) { max-width: none; padding-bottom: 2.4em; justify-content: stretch; }

  .m11k { flex: 1 1 auto; min-height: 0; display: grid; grid-template-rows: minmax(0, 1fr) auto; gap: 0.3em; margin-top: 0.4em; }
  .m11k-vue { min-height: 0; overflow-y: auto; overscroll-behavior: contain; background: var(--dk-fond-2); border-top: 2px solid var(--dk-filet); border-bottom: 2px solid var(--dk-filet); padding: 1.2em 0; display: flex; flex-direction: column; align-items: center; gap: 1.2em; }
  .m11k-page { position: relative; width: min(100%, 46em); flex: none; background: #fff; border: 1px solid var(--dk-filet); }
  .m11k-page img { display: block; width: 100%; height: 100%; user-select: none; }
  .m11k-ligne { position: absolute; padding: 0; margin: 0; border: 0; background: transparent; cursor: pointer; mix-blend-mode: multiply; }
  .m11k-ligne:hover { background: rgba(20, 20, 20, 0.05); }
  .m11k-ligne.on { background: rgba(198, 16, 46, 0.24); }
  .m11k-bas { display: flex; justify-content: space-between; align-items: baseline; font-size: 0.6em; color: var(--dk-gris); }
  .m11k-effacer { font: inherit; color: var(--dk-accent); background: none; border: 1px solid var(--dk-accent); padding: 0.2em 0.6em; cursor: pointer; }
</style>
