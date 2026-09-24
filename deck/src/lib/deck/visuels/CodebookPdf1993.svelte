<script>
  /**
   * Le vrai codebook de l'Étude électorale canadienne de 1993 (153 pages,
   * téléchargé par ces::download_pdf_codebook("1993") depuis
   * borealisdata.ca), ouvert à la page 37 : l'entrée cpsg1, la TPS.
   *
   * Pas d'iframe : certains navigateurs téléchargent le PDF dès que le deck
   * s'ouvre au lieu de l'afficher. On montre donc de vraies pages du PDF,
   * rendues en images par Ghostscript (gs -sDEVICE=pnggray -r110) : la
   * couverture, puis les pages 36 à 38. Le cadre défile à la molette et
   * s'ouvre à la page 37. Le PDF complet n'est qu'au bout d'un lien.
   */
  import { base } from '$app/paths';

  const PDF = `${base}/img/ces1993-codebook.pdf`;
  const PAGES = [1, 36, 37, 38];
  const CIBLE = 37;

  let ecran = $state(null);
  let cible = $state(null);

  // Ouvrir à la page 37 : on place le haut de la page en haut du cadre.
  function placer() {
    if (!ecran || !cible) return;
    const dy = cible.getBoundingClientRect().top - ecran.getBoundingClientRect().top;
    ecran.scrollTop += dy - 12;
  }
  // Si l'image est déjà en cache, onload peut partir avant le montage.
  $effect(() => { if (cible?.complete) placer(); });
</script>

<div class="visuel pdf93">
  <div class="barre">
    <span class="fichier">ces1993-codebook.pdf</span>
    <span class="nb">p. {CIBLE} / 153</span>
  </div>
  <div class="ecran" bind:this={ecran}>
    {#each PAGES as p, i}
      {#if i > 0 && p - PAGES[i - 1] > 1}
        <p class="saut">pages {PAGES[i - 1] + 1} à {p - 1}</p>
      {/if}
      {#if p === CIBLE}
        <img bind:this={cible} src="{base}/img/codebook-1993-p{p}.png" alt="Codebook 1993, page {p} : l'entrée cpsg1 sur la TPS" onload={placer} />
      {:else}
        <img src="{base}/img/codebook-1993-p{p}.png" alt="Codebook 1993, page {p}" />
      {/if}
    {/each}
  </div>
  <p class="source">
    Étude électorale canadienne 1993 · questionnaire de la campagne, p. 37 ·
    <a href={PDF} target="_blank" rel="noopener">le PDF complet</a>
  </p>
</div>

<style>
  .pdf93 { display: flex; flex-direction: column; }
  .barre { display: flex; justify-content: space-between; background: var(--dk-encre); color: var(--dk-papier, #f4f4f0); padding: 0.35em 0.8em; font-size: 0.62em; letter-spacing: 0.08em; }
  .ecran { border: 3px solid var(--dk-encre); border-top: 0; background: #d9d9d4; height: 58vh; overflow-y: auto; padding: 0.8em 0; display: flex; flex-direction: column; align-items: center; gap: 0.8em; }
  .ecran img { display: block; width: 72%; height: auto; background: #fff; border: 2px solid var(--dk-encre); }
  .saut { margin: 0; font-size: 0.6em; letter-spacing: 0.08em; color: var(--dk-gris); }
  .source { align-self: flex-end; margin: 0.4em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); }
  .source a { color: inherit; text-decoration: none; border-bottom: 2px solid var(--dk-filet); }
</style>
