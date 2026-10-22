<script>
  /**
   * Zotero, du DOI à la bibliographie, sur l'exemple qui court toute la
   * séance : Blais et Gélineau (2007). Un schéma, pas une capture.
   *
   *   0  trouver le DOI : la première page de l'article, la ligne doi surlignée;
   *   1  Zotero : la baguette magique (ajouter par identifiant), le DOI se tape,
   *      la référence entre dans la bibliothèque;
   *   2  Word, onglet Zotero : « Ajouter/Modifier une citation », la citation
   *      s'écrit dans le texte;
   *   3  « Ajouter/Modifier la bibliographie » : la référence complète en bas
   *      de page (APA, l'exemple; Zotero change de style en un clic).
   *
   * Toute la place est réservée dès le temps 0 : les fenêtres ont leur taille
   * finale, les éléments à venir sont masqués (visibility), jamais montés plus
   * tard. Rien ne bouge au clic, deborde.mjs mesure le bon état.
   *
   * Logos : static/img/zotero-logo.svg, s8-zotero-z.svg (le Z seul, tiré du
   * même fichier) et word-logo.svg, de Wikimedia Commons.
   * Volume, numéro et pages : BG.reference (src/lib/data/seance8.js).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  let { doi } = $props();
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const ETAPES = [
    { n: 1, nom: 'Trouver le DOI', logo: null },
    { n: 2, nom: 'L’ajouter à Zotero', logo: 'zotero' },
    { n: 3, nom: 'Citer dans Word', logo: 'word' },
    { n: 4, nom: 'Produire la bibliographie', logo: 'biblio' }
  ];
  const CITATION = '(Blais et Gélineau, 2007)';
</script>

<div class="visuel m8z" bind:this={hote} style="--doi-n: {doi.length}; --cit-n: {CITATION.length}">
  <!-- Le rail : quatre étapes, la ligne rouge avance avec les clics. -->
  <ol class="m8z-rail">
    {#each ETAPES as et, i}
      <li class:fait={e > i} class:ici={e === i}>
        {#if i < 3}<span class="m8z-lien"><span class="m8z-plein" class:on={e > i}></span></span>{/if}
        <span class="m8z-noeud">
          {#if et.logo === 'zotero'}
            <img src="{base}/img/s8-zotero-z.svg" alt="Zotero" />
          {:else if et.logo === 'word'}
            <img src="{base}/img/word-logo.svg" alt="Word" />
          {:else if et.logo === 'biblio'}
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M3 5 h18 M7 10 h14 M3 15 h18 M7 20 h14" /></svg>
            <img class="m8z-badge" src="{base}/img/word-logo.svg" alt="Word" />
          {:else}
            <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="10" cy="10" r="6.5" /><path d="M15 15 L21.5 21.5" /></svg>
          {/if}
        </span>
        <span class="m8z-nom"><b>{et.n}</b> {et.nom}</span>
      </li>
    {/each}
  </ol>

  <div class="m8z-scene">
    <div class="m8z-gauche">
      <!-- 1. La première page de l'article. -->
      <div class="m8z-article" class:actif={e === 0}>
        <p class="m8z-revue">Political Studies · 2007 · vol. 55, 425-441</p>
        <p class="m8z-titre">Winning, Losing and Satisfaction with Democracy</p>
        <p class="m8z-auteurs">André Blais et François Gélineau</p>
        <p class="m8z-doi" class:on={e === 0}><span>doi&#8239;:</span> {doi}</p>
      </div>

      <span class="m8z-fl bas" class:on={e === 1} aria-hidden="true">↓</span>

      <!-- 2. Une fenêtre Zotero, en schéma. -->
      <div class="m8z-fen m8z-zot" class:pale={e < 1} class:actif={e === 1}>
        <div class="m8z-barre">
          <img class="m8z-wordmark" src="{base}/img/zotero-logo.svg" alt="Zotero" />
          <span class="m8z-carres" aria-hidden="true"><i></i><i></i><i></i></span>
        </div>
        <div class="m8z-outils">
          <span class="m8z-bouton" aria-hidden="true">+</span>
          <span class="m8z-bouton m8z-baguette" class:on={e === 1} title="Ajouter un document par son identifiant">
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path class="baton" d="M4 20 L15 9" />
              <path class="eclat" d="M18 2 v4 M16 4 h4 M21 9 v3 M19.5 10.5 h3 M12 3 v2.4 M10.8 4.2 h2.4" />
            </svg>
          </span>
          <span class="m8z-recherche" aria-hidden="true"></span>
        </div>
        <div class="m8z-ident" class:vu={e >= 1}>
          <span class="m8z-etiq">Identifiant</span>
          <span class="m8z-champ"><span class="m8z-tape" class:on={e === 1}>{doi}</span></span>
        </div>
        <div class="m8z-corps">
          <div class="m8z-dossiers" aria-hidden="true">
            <span class="sel"></span><span></span><span></span>
          </div>
          <div class="m8z-liste">
            <div class="m8z-ligne tete"><span>Titre</span><span>Créateur</span><span>Année</span></div>
            <div class="m8z-ligne neuve" class:vu={e >= 1} class:on={e === 1}>
              <span class="t">Winning, Losing and Satisfaction with Democracy</span><span>Blais et Gélineau</span><span>2007</span>
            </div>
            <div class="m8z-ligne vide" aria-hidden="true"><span><i style="width: 80%"></i></span><span><i style="width: 70%"></i></span><span><i style="width: 90%"></i></span></div>
          </div>
        </div>
      </div>
    </div>

    <span class="m8z-fl droite" class:on={e === 2} aria-hidden="true">→</span>

    <!-- 3 et 4. Une page Word, onglet Zotero. -->
    <div class="m8z-fen m8z-word" class:pale={e < 2} class:actif={e >= 2}>
      <div class="m8z-barre">
        <img class="m8z-w" src="{base}/img/word-logo.svg" alt="Word" />
        <span class="m8z-fichier">travail.docx</span>
        <span class="m8z-carres" aria-hidden="true"><i></i><i></i><i></i></span>
      </div>
      <div class="m8z-onglets">
        <span>Accueil</span><span>Insertion</span>
        <span class="zot"><img src="{base}/img/s8-zotero-z.svg" alt="" />Zotero</span>
      </div>
      <div class="m8z-ruban">
        <span class="m8z-cmd" class:on={e === 2}>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7 h6 v6 h-3 l-2 5 h-1 l1.2 -5 h-1.2z M14 7 h6 v6 h-3 l-2 5 h-1 l1.2 -5 h-1.2z" /></svg>
          <span>Ajouter/Modifier<br />une citation</span>
        </span>
        <span class="m8z-cmd" class:on={e === 3}>
          <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 5 h16 M8 10 h12 M4 14 h16 M8 19 h12" /></svg>
          <span>Ajouter/Modifier<br />la bibliographie</span>
        </span>
        <span class="m8z-style">APA</span>
      </div>
      <div class="m8z-page">
        <span class="m8z-gris" style="width: 94%"></span>
        <p class="m8z-phrase">
          Les perdants sont moins satisfaits de la démocratie
          <span class="m8z-cit" class:vu={e >= 2} class:on={e === 2}>{CITATION}</span>.
        </p>
        <span class="m8z-gris" style="width: 70%"></span>
        <div class="m8z-biblio" class:vu={e >= 3} class:on={e === 3}>
          <p class="m8z-ref-tete">Références</p>
          <p class="m8z-ref">
            Blais, A. et Gélineau, F. (2007). Winning, losing and satisfaction with democracy.
            <i>Political Studies</i>, <i>55</i>(2), 425-441. https://doi.org/{doi}
          </p>
        </div>
      </div>
    </div>
  </div>

  <p class="m8z-pied">schéma · zotero.org, gratuit, en français</p>
</div>

<style>
  .m8z { display: flex; flex-direction: column; gap: 0.75em; margin: 0.2em auto 0; }

  /* ---------- le rail ---------- */
  .m8z-rail { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, 1fr); }
  .m8z-rail li { position: relative; display: flex; flex-direction: column; align-items: center; gap: 0.45em; }
  .m8z-noeud {
    position: relative; z-index: 1;
    width: 2.3em; height: 2.3em; display: grid; place-items: center;
    background: var(--dk-fond); border: 3px solid var(--dk-gris-2);
    transition: border-color 0.3s, transform 0.3s;
  }
  .m8z-noeud img { width: 1.4em; height: 1.4em; object-fit: contain; opacity: 0.45; transition: opacity 0.3s; }
  .m8z-noeud svg { width: 1.35em; height: 1.35em; fill: none; stroke: var(--dk-gris-2); stroke-width: 2.6; stroke-linecap: square; transition: stroke 0.3s; }
  img.m8z-badge { position: absolute; right: -0.55em; bottom: -0.55em; width: 1.15em; height: 1.15em; background: var(--dk-fond); padding: 0.08em; }
  .m8z-nom { font-size: 0.82em; color: var(--dk-gris-2); transition: color 0.3s; white-space: nowrap; }
  .m8z-nom b { display: inline-block; min-width: 1.4em; padding: 0 0.25em; margin-right: 0.2em; text-align: center; background: var(--dk-gris-2); color: var(--dk-fond); transition: background 0.3s; }
  .m8z-rail li.fait .m8z-noeud { border-color: var(--dk-encre); }
  .m8z-rail li.fait .m8z-noeud img, .m8z-rail li.ici .m8z-noeud img { opacity: 1; }
  .m8z-rail li.fait .m8z-noeud svg { stroke: var(--dk-encre); }
  .m8z-rail li.fait .m8z-nom { color: var(--dk-encre); }
  .m8z-rail li.fait .m8z-nom b { background: var(--dk-encre); }
  .m8z-rail li.ici .m8z-noeud { border-color: var(--dk-accent); transform: scale(1.12); }
  .m8z-rail li.ici .m8z-noeud svg { stroke: var(--dk-accent); }
  .m8z-rail li.ici .m8z-nom { color: var(--dk-accent); font-weight: 700; }
  .m8z-rail li.ici .m8z-nom b { background: var(--dk-accent); }
  .m8z-lien { position: absolute; top: 1.15em; left: 50%; width: 100%; height: 3px; margin-top: -1.5px; background: var(--dk-filet); }
  .m8z-plein { display: block; height: 100%; background: var(--dk-accent); transform: scaleX(0); transform-origin: left; transition: transform 0.6s ease-out; }
  .m8z-plein.on { transform: scaleX(1); }

  /* ---------- la scène ---------- */
  .m8z-scene { display: grid; grid-template-columns: minmax(0, 1.08fr) auto minmax(0, 1fr); gap: 0.7em; align-items: stretch; }
  .m8z-gauche { display: flex; flex-direction: column; gap: 0.15em; min-width: 0; }
  .m8z-fl { align-self: center; justify-self: center; font-size: 1.3em; line-height: 1; color: var(--dk-filet); font-weight: 700; transition: color 0.3s; }
  .m8z-fl.on { color: var(--dk-accent); animation: m8z-pousse 0.6s ease-out both; }
  .m8z-fl.bas.on { animation-name: m8z-pousse-bas; }

  /* 1. l'article */
  .m8z-article { background: #fff; border: 2px solid var(--dk-filet); padding: 0.6em 0.9em 0.65em; display: flex; flex-direction: column; gap: 0.25em; transition: border-color 0.3s; }
  .m8z-article.actif { border-color: var(--dk-encre); }
  .m8z-article p { margin: 0; }
  .m8z-revue { font-size: 0.7em; color: var(--dk-gris); letter-spacing: 0.04em; }
  .m8z-titre { font-size: 0.95em; font-weight: 700; line-height: 1.2; }
  .m8z-auteurs { font-size: 0.78em; color: var(--dk-gris); }
  .m8z-doi { font-size: 0.82em; margin-top: 0.25em !important; padding: 0.1em 0.3em; align-self: flex-start; outline: 3px solid transparent; transition: outline-color 0.3s, background 0.3s; white-space: nowrap; }
  .m8z-doi span { color: var(--dk-gris); }
  .m8z-doi.on { outline-color: var(--dk-accent); background: #fbe9ec; animation: m8z-pouls 0.9s 0.3s ease-out both; }

  /* fenêtres */
  .m8z-fen { background: #fff; border: 3px solid var(--dk-encre); display: flex; flex-direction: column; min-width: 0; transition: opacity 0.4s, border-color 0.3s; }
  .m8z-fen.pale { opacity: 0.3; }
  .m8z-fen.actif { border-color: var(--dk-accent); }
  .m8z-barre { display: flex; align-items: center; gap: 0.5em; padding: 0.35em 0.6em; border-bottom: 2px solid var(--dk-encre); background: var(--dk-fond-2); }
  .m8z-wordmark { height: 1.15em; width: auto; }
  .m8z-w { height: 1.25em; width: auto; }
  .m8z-fichier { font-size: 0.78em; color: var(--dk-gris); }
  .m8z-carres { margin-left: auto; display: flex; gap: 0.3em; }
  .m8z-carres i { width: 0.55em; height: 0.55em; border: 2px solid var(--dk-gris-2); }

  /* 2. Zotero */
  .m8z-zot { flex: 1 1 auto; }
  .m8z-outils { display: flex; align-items: center; gap: 0.45em; padding: 0.4em 0.6em; border-bottom: 2px solid var(--dk-filet); }
  .m8z-bouton { width: 1.7em; height: 1.7em; display: grid; place-items: center; border: 2px solid var(--dk-filet); font-weight: 700; color: var(--dk-gris); transition: border-color 0.3s, background 0.3s; }
  .m8z-baguette svg { width: 1.2em; height: 1.2em; fill: none; stroke-linecap: square; }
  .m8z-baguette .baton { stroke: var(--dk-encre); stroke-width: 3; }
  .m8z-baguette .eclat { stroke: var(--dk-accent); stroke-width: 1.8; }
  .m8z-baguette.on { border-color: var(--dk-accent); outline: 3px solid var(--dk-accent); outline-offset: 2px; animation: m8z-pouls 0.6s ease-out both; }
  .m8z-baguette.on .eclat { animation: m8z-scintille 0.6s ease-out both; }
  .m8z-recherche { margin-left: auto; width: 32%; height: 1.2em; border: 2px solid var(--dk-filet); }

  .m8z-ident { display: flex; align-items: center; gap: 0.6em; padding: 0.4em 0.6em; border-bottom: 2px solid var(--dk-filet); background: var(--dk-fond); visibility: hidden; }
  .m8z-ident.vu { visibility: visible; }
  .m8z-etiq { font-size: 0.72em; color: var(--dk-gris); text-transform: uppercase; letter-spacing: 0.08em; }
  .m8z-champ { flex: 1 1 auto; min-width: 0; border: 2px solid var(--dk-encre); background: #fff; padding: 0.15em 0.4em; font-size: 0.82em; white-space: nowrap; overflow: hidden; }
  .m8z-tape { display: inline-block; }
  .m8z-tape.on { animation: m8z-taper 0.9s steps(var(--doi-n)) both; }

  .m8z-corps { display: grid; grid-template-columns: 4.2em minmax(0, 1fr); flex: 1 1 auto; }
  .m8z-dossiers { border-right: 2px solid var(--dk-filet); padding: 0.5em 0.45em; display: flex; flex-direction: column; gap: 0.45em; }
  .m8z-dossiers span { height: 0.6em; background: var(--dk-filet); }
  .m8z-dossiers span.sel { background: var(--dk-gris-2); }
  .m8z-liste { display: flex; flex-direction: column; min-width: 0; }
  .m8z-ligne { display: grid; grid-template-columns: minmax(0, 1fr) 10.6em 3.6em; gap: 0.6em; padding: 0.3em 0.6em; font-size: 0.8em; align-items: center; }
  .m8z-ligne > span { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .m8z-ligne.tete { color: var(--dk-gris); border-bottom: 2px solid var(--dk-filet); text-transform: uppercase; letter-spacing: 0.06em; }
  .m8z-ligne.tete span { font-size: 0.85em; }
  .m8z-ligne.neuve { visibility: hidden; font-weight: 600; background: #fbe9ec; border-left: 4px solid var(--dk-accent); padding-left: calc(0.6em - 4px); }
  .m8z-ligne.neuve.vu { visibility: visible; }
  .m8z-ligne.neuve.on { animation: m8z-arrive 0.45s 0.95s ease-out both; }
  .m8z-ligne.vide i { display: block; height: 0.55em; background: var(--dk-fond-2); }

  /* 3 et 4. Word */
  .m8z-onglets { display: flex; gap: 1em; padding: 0.3em 0.6em 0; font-size: 0.74em; color: var(--dk-gris); border-bottom: 2px solid var(--dk-filet); }
  .m8z-onglets span { padding-bottom: 0.25em; display: inline-flex; align-items: center; gap: 0.3em; }
  .m8z-onglets .zot { color: var(--dk-encre); font-weight: 700; border-bottom: 3px solid var(--dk-accent); margin-bottom: -2px; }
  .m8z-onglets .zot img { height: 0.95em; width: auto; }
  .m8z-ruban { display: flex; align-items: stretch; gap: 0.5em; padding: 0.4em 0.6em; border-bottom: 2px solid var(--dk-filet); }
  .m8z-cmd { display: flex; align-items: center; gap: 0.35em; padding: 0.2em 0.4em; border: 2px solid var(--dk-filet); font-size: 0.68em; line-height: 1.2; transition: border-color 0.3s, background 0.3s; }
  .m8z-cmd svg { width: 1.6em; height: 1.6em; flex: 0 0 auto; fill: none; stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: miter; }
  .m8z-cmd.on { border-color: var(--dk-accent); outline: 3px solid var(--dk-accent); outline-offset: 1px; background: #fbe9ec; animation: m8z-pouls 0.5s ease-out both; }
  .m8z-style { margin-left: auto; align-self: center; font-size: 0.7em; font-weight: 700; padding: 0.15em 0.45em; border: 2px solid var(--dk-encre); }

  .m8z-page { flex: 1 1 auto; padding: 0.8em 1em 0.9em; display: flex; flex-direction: column; gap: 0.5em; }
  .m8z-gris { display: block; height: 0.55em; background: var(--dk-fond-2); }
  .m8z-phrase { margin: 0.1em 0; font-size: 0.84em; line-height: 1.45; }
  .m8z-cit { display: inline-block; visibility: hidden; color: var(--dk-accent); font-weight: 700; }
  .m8z-cit.vu { visibility: visible; }
  .m8z-cit.on { animation: m8z-taper 0.7s 0.35s steps(var(--cit-n)) both; }
  .m8z-biblio { margin-top: auto; border-top: 2px solid var(--dk-encre); padding-top: 0.5em; visibility: hidden; }
  .m8z-biblio.vu { visibility: visible; }
  .m8z-biblio.on { animation: m8z-deroule 0.9s 0.35s ease-out both; }
  .m8z-ref-tete { margin: 0 0 0.3em; font-size: 0.8em; font-weight: 700; }
  .m8z-ref { margin: 0; font-size: 0.74em; line-height: 1.4; padding-left: 2em; text-indent: -2em; overflow-wrap: anywhere; }

  .m8z-pied { margin: 0; color: var(--dk-gris); font-size: 0.7em; }

  /* ---------- animations ---------- */
  @keyframes m8z-taper { from { clip-path: inset(0 100% 0 0); } to { clip-path: inset(0 0 0 0); } }
  @keyframes m8z-arrive { from { opacity: 0; transform: translateY(-0.6em); } to { opacity: 1; transform: none; } }
  @keyframes m8z-deroule { from { clip-path: inset(0 0 100% 0); } to { clip-path: inset(0 0 0 0); } }
  @keyframes m8z-pouls { 0% { transform: scale(1); } 40% { transform: scale(1.08); } 100% { transform: scale(1); } }
  @keyframes m8z-scintille { 0% { opacity: 0; transform: scale(0.6); } 100% { opacity: 1; transform: none; } }
  @keyframes m8z-pousse { 0% { transform: translateX(-0.3em); opacity: 0.3; } 100% { transform: none; opacity: 1; } }
  @keyframes m8z-pousse-bas { 0% { transform: translateY(-0.3em); opacity: 0.3; } 100% { transform: none; opacity: 1; } }
  .m8z-baguette .eclat { transform-box: fill-box; transform-origin: center; }

  @media (prefers-reduced-motion: reduce) {
    .m8z *, .m8z *::before { animation: none !important; transition: none !important; }
  }
</style>
