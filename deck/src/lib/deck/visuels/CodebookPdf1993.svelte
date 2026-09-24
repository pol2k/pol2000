<script>
  /**
   * Le vrai codebook de l'Étude électorale canadienne de 1993 (153 pages,
   * téléchargé par ces::download_pdf_codebook("1993") depuis
   * borealisdata.ca), feuilleté comme dans un lecteur PDF.
   *
   * Pas d'iframe : certains navigateurs téléchargent le PDF dès que le deck
   * s'ouvre au lieu de l'afficher. On montre donc de vraies pages du PDF,
   * rendues en images par Ghostscript (pas pdftoppm, qui écrase la police
   * non incorporée) :
   *   gs -q -dNOPAUSE -dBATCH -sDEVICE=pnggray -r130 -dTextAlphaBits=4
   *      -dGraphicsAlphaBits=4 -dFirstPage=1 -dLastPage=40
   *      -sOutputFile=codebook-1993-p%02d.png ces1993-codebook.pdf
   * puis optipng -o2 (40 pages, moins de 1 Mo au total).
   *
   * Le cadre s'ouvre à la page 1 et défile en continu à la molette jusqu'à
   * la page 40 (cpsg1, la TPS, est à la page 37). Les flèches du clavier
   * restent au deck : c'est Deck.svelte qui les capte sur window.
   * Le PDF complet n'est qu'au bout d'un lien.
   */
  import { base } from '$app/paths';

  const PDF = `${base}/img/ces1993-codebook.pdf`;
  const TOTAL_PDF = 153;
  const PAGES = Array.from({ length: 40 }, (_, i) => i + 1);
  const deux = (n) => String(n).padStart(2, '0');

  let ecran = $state(null);
  let courante = $state(1);

  // Page courante : la dernière dont le haut a passé le premier tiers du cadre.
  function suivre() {
    if (!ecran) return;
    const seuil = ecran.scrollTop + ecran.clientHeight / 3;
    let n = 1;
    for (const img of ecran.querySelectorAll('img')) {
      if (img.offsetTop <= seuil) n = Number(img.dataset.page);
      else break;
    }
    courante = n;
  }
</script>

<div class="visuel pdf93">
  <div class="barre">
    <span class="fichier">ces1993-codebook.pdf</span>
    <span class="nb">p. {courante} / {TOTAL_PDF}</span>
  </div>
  <div class="ecran" bind:this={ecran} onscroll={suivre}>
    {#each PAGES as p}
      <img
        data-page={p}
        src="{base}/img/codebook-1993-p{deux(p)}.png"
        width="1105"
        height="1430"
        loading={p <= 2 ? 'eager' : 'lazy'}
        alt={p === 37 ? "Codebook 1993, page 37 : l'entrée cpsg1 sur la TPS" : `Codebook 1993, page ${p}`}
      />
    {/each}
    <p class="suite">pages 41 à {TOTAL_PDF}&#8239;: <a href={PDF} target="_blank" rel="noopener">le PDF complet</a></p>
  </div>
  <p class="source">
    Étude électorale canadienne 1993 · cpsg1 (la TPS)&#8239;: p. 37 ·
    <a href={PDF} target="_blank" rel="noopener">le PDF complet</a>
  </p>
</div>

<style>
  .pdf93 { display: flex; flex-direction: column; flex: 1 1 auto; min-height: 0; }
  .barre { display: flex; justify-content: space-between; background: var(--dk-encre); color: var(--dk-fond); padding: 0.35em 0.8em; font-size: 0.62em; letter-spacing: 0.08em; flex: 0 0 auto; }
  .nb { font-variant-numeric: tabular-nums; }
  .ecran { position: relative; flex: 1 1 auto; min-height: 0; border: 3px solid var(--dk-encre); border-top: 0; background: #d9d9d4; overflow-y: auto; overscroll-behavior: contain; padding: 0.8em 0; display: flex; flex-direction: column; align-items: center; gap: 0.8em; }
  .ecran img { display: block; flex: 0 0 auto; width: min(94%, 40em); height: auto; background: #fff; border: 2px solid var(--dk-encre); }
  .suite { margin: 0.2em 0 0.4em; font-size: 0.62em; letter-spacing: 0.06em; color: var(--dk-gris); }
  .source { align-self: flex-end; margin: 0.4em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); flex: 0 0 auto; }
  a { color: inherit; text-decoration: none; border-bottom: 2px solid var(--dk-filet); }
</style>
