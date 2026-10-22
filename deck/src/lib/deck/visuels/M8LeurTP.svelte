<script>
  /**
   * « Et si Blais et Gélineau remettaient votre TP 1 ? » Les sept étapes du
   * travail de mi-session (les mêmes que TmParcours, séance 7), remplies
   * avec leur article. À gauche, la consigne (les mots de
   * travaux/pdf/travail-mi-session-A26.tex, raccourcis); à droite, leur
   * réponse, en clair, avec la page de l'article.
   *
   *   etape 0     l'article, et la règle du jeu (17 pages contre 2);
   *   etape 1-7   une étape;
   *   etape 8     le TP 1 s'arrête aux données : ce que le travail final
   *               ajoute, et où le trouver dans leur article.
   *
   * Deux étapes ont un temps (un clic) : 2 (ce qu'on sait, puis ce qu'on ne
   * sait pas) et 3 (leurs trois hypothèses, dont deux tombent).
   *
   * Tout vient de Blais et Gélineau (2007), Political Studies 55(2),
   * 425-441 : les pages sont indiquées. Rien n'est prêté aux auteurs qui ne
   * soit dans l'article; l'étape 7 le dit (un article n'a pas de
   * justification personnelle). Les variables de 2025 sont celles de
   * l'atelier (outils/seance8_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { BG } from '$lib/data/seance8.js';
  let { etape = 0 } = $props();

  const TEMPS = { 2: 1, 3: 1 };
  const total = TEMPS[etape] || 0;
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || !total) return;
    e = 0;
    return brancherTemps(hote, { total, lire: () => e, ecrire: (v) => (e = v) });
  });

  const CONSIGNE = {
    1: 'Une question de recherche qui met en relation une variable dépendante et une variable indépendante.',
    2: 'Deux paragraphes, quatre références scientifiques. Dégagez une théorie.',
    3: 'Énoncez votre hypothèse. Énoncez aussi votre hypothèse nulle.',
    4: 'Votre variable dépendante : ratio, intervalle ou ordinale. Pas de Y nominal.',
    5: 'Justifiez la pertinence et l’originalité de votre question.',
    6: 'Comment voulez-vous contribuer à la littérature ? Quelle limite voulez-vous combler ?',
    7: 'Expliquez-nous pourquoi vous avez choisi ce sujet.'
  };
</script>

<div class="visuel m8tp" class:seul={etape === 0 || etape === 8} bind:this={hote}>
  {#if CONSIGNE[etape]}
    <aside class="consigne">
      <span class="eti">La consigne</span>
      <p>{CONSIGNE[etape]}</p>
    </aside>
  {/if}

  <div class="eux">
    {#if etape === 0}
      <div class="ref">
        <p>Blais, A. et Gélineau, F. (2007). Winning, losing and satisfaction with democracy. <em>Political Studies</em>, <em>55</em>(2), 425-441. <span class="doi">https://doi.org/{BG.doi}</span></p>
      </div>
      <div class="pages">
        <div class="pg"><span class="nb">17</span><span>pages, leur article</span></div>
        <div class="pg rouge"><span class="nb">2</span><span>pages, votre TP 1</span></div>
      </div>
      <p class="dit">Les sept étapes de votre TP 1. Leurs réponses, en clair.</p>

    {:else if etape === 1}
      <span class="eti">Blais et Gélineau</span>
      <p class="question">Gagner une élection <span class="tag x">X</span> rend-il plus satisfait de la démocratie <span class="tag y">Y</span>&#8239;?</p>
      <p class="src">p. 425-426</p>

    {:else if etape === 2}
      <span class="eti">Blais et Gélineau</span>
      <div class="deux">
        <div class="boite">
          <span class="mini">Ce qu’on sait</span>
          <p>Après une élection, les gagnants sont plus satisfaits que les perdants.</p>
          <ul class="refs">
            <li>Anderson et Guillory (1997)</li>
            <li>Anderson et al. (2005)</li>
            <li>Nadeau et Blais (1993)</li>
            <li>Norris (1999a)</li>
          </ul>
        </div>
        <div class="boite trou" class:vu={e >= 1}>
          <span class="mini">Ce qu’on ne sait pas</span>
          <p>Est-ce l’élection qui crée cet écart&#8239;? Ou existait-il déjà avant&#8239;?</p>
        </div>
      </div>
      <p class="theorie"><strong>La théorie&#8239;:</strong> on aime le parti qu’on a choisi et on lui fait confiance. S’il gagne, la démocratie «&#8239;fonctionne&#8239;».</p>
      <p class="src">p. 426</p>

    {:else if etape === 3}
      <span class="eti">Blais et Gélineau</span>
      <div class="hyp">
        <p><strong>Hypothèse&#8239;:</strong> à satisfaction égale avant l’élection, les gagnants deviennent plus satisfaits que les perdants.</p>
        <p><strong>Hypothèse nulle&#8239;:</strong> gagner ou perdre ne change rien.</p>
      </div>
      <div class="autres" class:vu={e >= 1}>
        <p class="mini">Ils en avaient deux autres</p>
        <p><span class="non">✕</span> Gagner au pays compte plus que gagner dans sa circonscription. <span class="gris">Non&#8239;: autant.</span></p>
        <p><span class="non">✕</span> Ceux qui ne s’attendaient pas à gagner réagissent plus. <span class="gris">Non.</span></p>
        <p class="dit-petit">Une hypothèse peut tomber. C’est un résultat.</p>
      </div>
      <p class="src">p. 427, 431, 435</p>

    {:else if etape === 4}
      <span class="eti">Blais et Gélineau</span>
      <div class="vars">
        <div class="var"><span class="tag y">Y</span><div><strong>La satisfaction envers la démocratie</strong><span class="gris">4 choix, de «&#8239;pas du tout&#8239;» à «&#8239;très satisfait&#8239;»</span></div><span class="ok">ordinale ✓</span></div>
        <div class="var"><span class="tag x">X</span><div><strong>Gagner ou perdre, au pays et dans sa circonscription</strong><span class="gris">vous, en 2025 : au pays seulement (a voté libéral)</span></div><span class="ok">binaire, pour un X ✓</span></div>
        <div class="var"><span class="tag c">+</span><div><strong>Leur contrôle principal : la même question, avant l’élection</strong><span class="gris">les mêmes personnes, interrogées deux fois</span></div></div>
      </div>
      <p class="donnees">Eux&#8239;: la CES 1997 (3 949 personnes, 3 170 réinterrogées après). Vous&#8239;: la CES 2025.</p>
      <p class="src">p. 428, 437</p>

    {:else if etape === 5}
      <span class="eti">Blais et Gélineau</span>
      <p class="grand">Toute élection fait des perdants.</p>
      <p class="grand">La démocratie tient si les perdants <span class="rouge nowrap">acceptent de perdre.</span></p>
      <p class="moyen">La satisfaction envers la démocratie va de pair avec la légitimité du régime.</p>
      <p class="src">p. 426 · Anderson et al. (2005) · Nadeau et Blais (1993)</p>

    {:else if etape === 6}
      <span class="eti">Blais et Gélineau</span>
      <p class="moyen">La limite&#8239;: presque toutes les études regardent <strong>après</strong> l’élection seulement.</p>
      <ol class="apports">
        <li><span>Avant <strong>et</strong> après, chez les mêmes personnes</span></li>
        <li><span>Ceux qui n’ont pas voté, pour comparer</span></li>
        <li><span>Deux élections en une&#8239;: la circonscription et le pays</span></li>
      </ol>
      <p class="src">p. 426-427</p>

    {:else if etape === 7}
      <span class="eti">Blais et Gélineau</span>
      <p class="grand">Leur article n’en dit rien.</p>
      <p class="moyen">Un article n’a pas cette section. Votre TP 1, oui.</p>
      <p class="dit">Ici, vous en direz plus qu’eux.</p>

    {:else if etape === 8}
      <div class="final">
        <div class="f"><strong>Statistiques descriptives</strong><span>leur tableau 1</span></div>
        <div class="f"><strong>Un GOA</strong><span class="gris">à vous</span></div>
        <div class="f"><strong>Une régression linéaire et son tableau</strong><span>leur tableau 2, en plus simple</span></div>
        <div class="f"><strong>Interpréter</strong><span>leur conclusion</span></div>
        <div class="f"><strong>Biais et limites</strong><span class="gris">à vous</span></div>
      </div>
      <p class="dit">Le TP 1 s’arrête aux données. Positron n’y est pas obligatoire.</p>
    {/if}
  </div>
</div>

<style>
  .m8tp { display: grid; grid-template-columns: 15em minmax(0, 1fr); gap: 2em; align-items: start; margin-top: 0.6em; }
  .m8tp.seul { grid-template-columns: minmax(0, 1fr); max-width: 54em; margin-left: auto; margin-right: auto; }
  .consigne { border-top: 4px solid var(--dk-gris-2); padding-top: 0.5em; color: var(--dk-gris); }
  .consigne p { margin: 0.4em 0 0; font-size: 0.9em; line-height: 1.4; font-style: italic; }
  .eti { display: block; font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .eux { border-top: 4px solid var(--dk-accent); padding-top: 0.5em; display: flex; flex-direction: column; gap: 0.6em; }
  .seul .eux { border-top: none; padding-top: 0; }
  .eux p { margin: 0; }
  .src { color: var(--dk-gris); font-size: 0.62em; }
  .gris { color: var(--dk-gris); }
  .rouge { color: var(--dk-accent); }
  .nowrap { white-space: nowrap; }
  .doi { overflow-wrap: anywhere; }
  .question { font-size: 1.75em; font-weight: 700; line-height: 1.35; }
  .tag { display: inline-block; min-width: 1.5em; padding: 0 0.3em; text-align: center; font-size: 0.6em; vertical-align: 0.25em; font-weight: 700; color: var(--dk-fond); background: var(--dk-encre); }
  .tag.y { background: var(--dk-accent); }
  .tag.c { background: var(--dk-gris); }
  .deux { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .boite { border: 2px solid var(--dk-encre); padding: 0.6em 0.8em; display: flex; flex-direction: column; gap: 0.4em; }
  .boite p { font-size: 0.95em; line-height: 1.35; }
  .boite.trou { border-color: var(--dk-accent); background: var(--dk-fond-2); opacity: 0; transition: opacity 0.4s; }
  .boite.trou p { font-size: 1.15em; font-weight: 700; }
  .vu { opacity: 1 !important; }
  .mini { font-size: 0.62em; letter-spacing: 0.06em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .refs { margin: 0; padding: 0; list-style: none; font-size: 0.8em; color: var(--dk-gris); line-height: 1.45; }
  .theorie { font-size: 1em; line-height: 1.4; padding: 0.5em 0.8em; background: var(--dk-encre); color: var(--dk-fond); }
  .hyp { display: flex; flex-direction: column; gap: 0.5em; font-size: 1.2em; line-height: 1.35; }
  .autres { border-left: 6px solid var(--dk-gris-2); padding: 0.2em 0 0.2em 0.8em; display: flex; flex-direction: column; gap: 0.3em; font-size: 0.9em; opacity: 0; transition: opacity 0.4s; }
  .non { color: var(--dk-accent); font-weight: 700; margin-right: 0.3em; }
  .dit-petit { font-weight: 700; margin-top: 0.2em !important; }
  .vars { display: flex; flex-direction: column; gap: 0.55em; }
  .var { display: grid; grid-template-columns: 2.2em minmax(0, 1fr) auto; gap: 0.7em; align-items: center; border-bottom: 1px solid var(--dk-filet); padding-bottom: 0.45em; }
  .var .tag { font-size: 0.9em; vertical-align: 0; padding: 0.15em 0; }
  .var div { display: flex; flex-direction: column; gap: 0.1em; }
  .var div span { font-size: 0.75em; }
  .ok { font-size: 0.75em; font-weight: 700; color: var(--dk-accent); white-space: nowrap; }
  .donnees { font-size: 0.85em; }
  .grand { font-size: 1.6em; font-weight: 700; line-height: 1.3; }
  .moyen { font-size: 1.1em; line-height: 1.4; }
  .apports { margin: 0.2em 0 0; padding: 0; list-style: none; counter-reset: a; display: flex; flex-direction: column; gap: 0.5em; }
  .apports li { counter-increment: a; display: grid; grid-template-columns: 1.8em minmax(0, 1fr); gap: 0.5em; font-size: 1.2em; align-items: baseline; }
  .apports li::before { content: counter(a); font-weight: 700; color: var(--dk-fond); background: var(--dk-accent); text-align: center; }
  .dit { padding: 0.55em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.05em; }
  .ref { border-left: 6px solid var(--dk-accent); padding: 0.3em 0 0.3em 0.9em; font-size: 1.05em; line-height: 1.45; }
  .pages { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .pg { border: 2px solid var(--dk-encre); padding: 0.5em 0.8em; display: flex; align-items: baseline; gap: 0.5em; }
  .pg .nb { font-size: 2.6em; font-weight: 700; line-height: 1; }
  .pg.rouge { border-color: var(--dk-accent); }
  .pg.rouge .nb { color: var(--dk-accent); }
  .final { display: grid; grid-template-columns: repeat(5, 1fr); gap: 0.8em; }
  .f { border-top: 4px solid var(--dk-encre); padding-top: 0.5em; display: flex; flex-direction: column; gap: 0.3em; }
  .f strong { font-size: 1.05em; line-height: 1.3; }
  .f span { color: var(--dk-accent); font-weight: 600; font-size: 0.85em; }
  .f span.gris { color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .boite.trou, .autres { transition: none; } }
</style>
