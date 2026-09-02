<script>
  /**
   * Un jeu de pictogrammes, au trait, dans la doctrine du deck.
   *
   * Ils existent pour une raison précise: remplacer de la prose. Une carte qui
   * explique en trois lignes ce qu'est un fichier binaire se lit; un cadenas
   * posé sur une page se regarde. La salle écoute pendant qu'elle regarde,
   * elle n'écoute plus pendant qu'elle lit.
   *
   * Tout est en currentColor et en trait: la couleur vient du contexte, et
   * rien n'a d'aplat ni d'angle arrondi.
   */
  let { nom, taille = '1.6em' } = $props();
</script>

<svg
  class="picto"
  viewBox="0 0 24 24"
  style="width: {taille}; height: {taille}"
  fill="none"
  stroke="currentColor"
  stroke-width="1.8"
  stroke-linecap="square"
  aria-hidden="true"
>
  {#if nom === 'page'}
    <path d="M6 2h8l4 4v16H6z" /><path d="M14 2v4h4" />
    <path d="M9 12h6M9 15h6M9 18h4" />
  {:else if nom === 'page-close'}
    <path d="M6 2h8l4 4v16H6z" /><path d="M14 2v4h4" />
    <rect x="9" y="13" width="6" height="5" /><path d="M10.5 13v-1.5a1.5 1.5 0 0 1 3 0V13" />
  {:else if nom === 'clic'}
    <path d="M5 3l6 16 2.2-6.2L19.5 10z" />
  {:else if nom === 'terminal'}
    <rect x="2" y="4" width="20" height="16" /><path d="M6 9l3 3-3 3M12 15h6" />
  {:else if nom === 'loupe'}
    <circle cx="10.5" cy="10.5" r="6.5" /><path d="M15.5 15.5L21 21" />
  {:else if nom === 'diff'}
    <rect x="2" y="3" width="9" height="18" /><rect x="13" y="3" width="9" height="18" />
    <path d="M4.5 12h4M17.5 9.5v5M15.5 12h4" />
  {:else if nom === 'git'}
    <circle cx="6" cy="5" r="2.4" /><circle cx="6" cy="19" r="2.4" /><circle cx="18" cy="12" r="2.4" />
    <path d="M6 7.4v9.2M6 12h9.6" />
  {:else if nom === 'grille'}
    <rect x="2" y="4" width="20" height="16" /><path d="M2 10h20M2 15h20M9 4v16M15 4v16" />
  {:else if nom === 'image'}
    <rect x="2" y="4" width="20" height="16" /><circle cx="8" cy="10" r="2" />
    <path d="M2 17l6-5 5 4 3-2 6 5" />
  {:else if nom === 'horloge'}
    <circle cx="12" cy="12" r="9" /><path d="M12 6.5V12l4 2.5" />
  {:else if nom === 'cadenas'}
    <rect x="4" y="10" width="16" height="11" /><path d="M8 10V7a4 4 0 0 1 8 0v3" />
  {:else if nom === 'humain'}
    <circle cx="12" cy="7.5" r="3.8" /><path d="M4 21v-2a8 8 0 0 1 16 0v2" />
  {:else if nom === 'retour'}
    <path d="M3 11a9 9 0 1 1 2.6 6.4" /><path d="M3 5v6h6" />
  {:else if nom === 'poubelle'}
    <path d="M4 6h16M9 6V3h6v3M6 6l1 15h10l1-15" /><path d="M10 10v7M14 10v7" />
  {:else if nom === 'oeil'}
    <path d="M1.5 12S5.5 5 12 5s10.5 7 10.5 7-4 7-10.5 7S1.5 12 1.5 12z" />
    <circle cx="12" cy="12" r="3.2" />
  {:else if nom === 'coche'}
    <path d="M3.5 13l5.5 5.5L20.5 6" />
  {:else if nom === 'croix'}
    <path d="M5 5l14 14M19 5L5 19" />
  {:else if nom === 'engrenage'}
    <circle cx="12" cy="12" r="3.4" />
    <path d="M12 1.5v3.6M12 18.9v3.6M22.5 12h-3.6M5.1 12H1.5M19.4 4.6l-2.5 2.5M7.1 16.9l-2.5 2.5M19.4 19.4l-2.5-2.5M7.1 7.1L4.6 4.6" />
  {:else if nom === 'boite'}
    <path d="M2 7l10-5 10 5v10l-10 5-10-5z" /><path d="M2 7l10 5 10-5M12 12v10" />
  {:else if nom === 'prise'}
    <rect x="7" y="8" width="10" height="9" /><path d="M2 12.5h5M17 12.5h5M10 8V4M14 8V4" />
  {:else if nom === 'eclair'}
    <path d="M13.5 2L4 14h7l-.5 8L20 10h-7z" />
  {/if}
</svg>

<style>
  .picto {
    display: block;
    flex: none;
  }
</style>
