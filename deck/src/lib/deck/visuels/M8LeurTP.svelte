<script>
  /**
   * L'étape 7 du TP 1 (« Vous ») : la consigne seule, la partie de droite
   * reste vide (un article n'a pas cette section; demande du professeur).
   * La une, l'intro et les étapes 1 à 6 se lisent dans le vrai article
   * (M8Fil).
   *
   * La consigne : les mots de travaux/pdf/travail-mi-session-A26.tex,
   * raccourcis.
   */
  let { etape = 0 } = $props();
  const CONSIGNE = { 7: 'Expliquez-nous pourquoi vous avez choisi ce sujet.' };
</script>

<div class="visuel m8tp">
  {#if CONSIGNE[etape]}
    <aside class="consigne">
      <span class="eti">La consigne</span>
      <p>{CONSIGNE[etape]}</p>
    </aside>
  {/if}

  <div class="eux"></div>
</div>

<style>
  .m8tp { display: grid; grid-template-columns: 15em minmax(0, 1fr); gap: 2em; align-items: start; margin-top: 0.6em; }
  .consigne { border-top: 4px solid var(--dk-gris-2); padding-top: 0.5em; color: var(--dk-gris); }
  .consigne p { margin: 0.4em 0 0; font-size: 0.9em; line-height: 1.4; font-style: italic; }
  .eti { display: block; font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .eux { border-top: 4px solid var(--dk-accent); padding-top: 0.5em; }
</style>
