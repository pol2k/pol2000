<script>
  /**
   * « Et si Blais et Gélineau remettaient votre TP 1 ? » Les deux bouts de
   * la marche des sept étapes (TmParcours, séance 7). Les étapes 1 à 6 se
   * lisent dans le vrai article (M8Art1 à M8Art6, sur M8Article).
   *
   *   etape 0   la référence APA de l'article;
   *   etape 7   la consigne seule : la partie de droite reste vide (un
   *             article n'a pas cette section; demande du professeur).
   *
   * La consigne : les mots de travaux/pdf/travail-mi-session-A26.tex,
   * raccourcis.
   */
  import { BG } from '$lib/data/seance8.js';
  let { etape = 0 } = $props();
  const CONSIGNE = { 7: 'Expliquez-nous pourquoi vous avez choisi ce sujet.' };
</script>

<div class="visuel m8tp" class:seul={etape === 0}>
  {#if CONSIGNE[etape]}
    <aside class="consigne">
      <span class="eti">La consigne</span>
      <p>{CONSIGNE[etape]}</p>
    </aside>
  {/if}

  <div class="eux">
    {#if etape === 0}
      <p class="ref">Blais, A., &amp; Gélineau, F. (2007). Winning, losing and satisfaction with democracy. <em>Political Studies</em>, <em>55</em>(2), 425-441. <span class="doi">https://doi.org/{BG.doi}</span></p>
    {/if}
  </div>
</div>

<style>
  .m8tp { display: grid; grid-template-columns: 15em minmax(0, 1fr); gap: 2em; align-items: start; margin-top: 0.6em; }
  .m8tp.seul { grid-template-columns: minmax(0, 1fr); max-width: 54em; margin-left: auto; margin-right: auto; }
  .consigne { border-top: 4px solid var(--dk-gris-2); padding-top: 0.5em; color: var(--dk-gris); }
  .consigne p { margin: 0.4em 0 0; font-size: 0.9em; line-height: 1.4; font-style: italic; }
  .eti { display: block; font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .eux { border-top: 4px solid var(--dk-accent); padding-top: 0.5em; }
  .seul .eux { border-top: none; padding-top: 0; }
  .ref { margin: 0; border-left: 4px solid var(--dk-accent); padding-left: 0.8em; font-size: 1em; line-height: 1.5; }
  .doi { overflow-wrap: anywhere; }
</style>
