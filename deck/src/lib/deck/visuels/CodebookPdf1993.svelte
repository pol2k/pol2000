<script>
  /**
   * Le vrai codebook de l'Étude électorale canadienne de 1993 (153 pages,
   * téléchargé par ces::download_pdf_codebook("1993") depuis
   * borealisdata.ca), ouvert à la page 37 : l'entrée cpsg1, la TPS.
   *
   * Piège du clavier : une iframe qui a le focus garde les flèches pour
   * elle, et le deck (qui écoute sur window) ne les reçoit plus; la
   * télécommande tombe à plat. Donc :
   *   - au repos, l'iframe ne capte ni la souris ni le Tab (pointer-events:
   *     none, tabindex -1) : impossible de lui donner le focus par erreur;
   *   - un clic sur la page l'active (on peut alors défiler dans le PDF);
   *   - dès que la souris sort du cadre, qu'on clique ailleurs ou qu'on
   *     quitte la diapo, elle se désactive et le focus revient au deck.
   */
  import { base } from '$app/paths';

  const PDF = `${base}/img/ces1993-codebook.pdf`;

  let actif = $state(false);
  let hote = $state(null);
  let cadre = $state(null);

  function activer(ev) {
    ev.stopPropagation();
    actif = true;
  }

  function desactiver() {
    if (!actif) return;
    actif = false;
    // Rendre le clavier au deck : on retire le focus de l'iframe.
    const deck = hote?.closest('.deck');
    if (document.activeElement && document.activeElement !== document.body) document.activeElement.blur();
    window.focus();
    deck?.focus({ preventScroll: true });
  }

  $effect(() => {
    if (!hote) return;
    const deck = hote.closest('.deck');
    const diapo = hote.closest('.diapo');
    if (!deck || !diapo) return;
    // Un clic ailleurs sur la diapo désactive aussi.
    const ailleurs = (ev) => { if (!cadre?.contains(ev.target)) desactiver(); };
    diapo.addEventListener('click', ailleurs);
    deck.addEventListener('scroll', desactiver, { passive: true });
    return () => {
      diapo.removeEventListener('click', ailleurs);
      deck.removeEventListener('scroll', desactiver);
    };
  });
</script>

<div class="visuel pdf93" bind:this={hote}>
  <!-- svelte-ignore a11y_click_events_have_key_events a11y_no_static_element_interactions -->
  <div class="ecran" role="presentation" class:actif bind:this={cadre} onclick={activer} onmouseleave={desactiver}>
    <iframe src="{PDF}#page=37&view=FitH&navpanes=0" title="Codebook de l'Étude électorale canadienne 1993, page 37 : l'entrée cpsg1 sur la TPS" tabindex="-1"></iframe>
  </div>
  <p class="source">
    <a href="{PDF}#page=37" target="_blank" rel="noopener">Étude électorale canadienne 1993 · questionnaire de la campagne, p. 37</a>
  </p>
</div>

<style>
  .pdf93 { display: flex; flex-direction: column; gap: 0.4em; }
  .ecran { border: 3px solid var(--dk-encre); background: #fff; height: 62vh; cursor: pointer; transition: border-color 0.2s; }
  .ecran.actif { border-color: var(--dk-accent); cursor: auto; }
  iframe { display: block; width: 100%; height: 100%; border: 0; pointer-events: none; }
  .ecran.actif iframe { pointer-events: auto; }
  .source { align-self: flex-end; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); }
  .source a { color: inherit; text-decoration: none; border-bottom: 2px solid var(--dk-filet); }
</style>
