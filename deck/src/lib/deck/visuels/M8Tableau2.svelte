<script>
  /**
   * Le vrai tableau 2 de Blais et Gélineau (2007, p. 432), tel qu'imprimé,
   * à la largeur de la diapo. Trop haut pour tenir à l'écran : il défile
   * dans une fenêtre de la hauteur de la diapo, au clic, de haut en bas.
   *
   *   0  le haut : le titre, les deux modèles. (1) sans les groupes
   *      gagnant / perdant, (2) avec;
   *   1  leur X, cadré : quatre lignes, comparées au groupe de référence
   *      (gagner au pays et dans sa circonscription, absent du tableau).
   *      Tout le reste, voilé : des contrôles;
   *   2  une ligne : perdre au pays et dans sa circonscription, −0,447***.
   *      La ligne « Prior level of satisfaction » est rappelée : c'est elle
   *      qui fait dire « à satisfaction égale avant »;
   *   3  le bas : 1 922 répondants, et la légende des étoiles.
   *
   * Une barre à droite montre où l'on est dans le tableau. Après le
   * défilement, le tableau se promène librement à la molette ou au doigt
   * (libre.js); le temps suivant le ramène à sa place.
   *
   * Leur modèle est un probit ordonné (leur note 7), pas une régression
   * linéaire : on ne lit pas la taille du coefficient, seulement le signe
   * et les étoiles. Les auteurs commentent aussi certains contrôles dans
   * leur texte; on ne le dit pas sur la diapo.
   *
   * Image : outils/seance8_tableaux.sh (2011 × 3189, 400 ppp). Cadres et
   * voiles en % de la découpe (x 86 à 448 pt, y 54 à 628 pt), depuis
   * pdftotext -bbox : ils suivent l'image à toutes les tailles. Le
   * défilement est mesuré en pixels (hauteur de la fenêtre et de l'image).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { defilementLibre } from '../libre.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Hauteurs mesurées : la fenêtre (vue) et l'image entière (page).
  let hVue = $state(0);
  let hPage = $state(0);
  // Le haut de la fenêtre, en % de l'image, à chaque temps (3 = tout en bas).
  const HAUT = [0, 5.4, 5.4, 100];
  const borne = (y) => Math.max(0, Math.min(y, hPage - hVue));
  const cible = $derived(borne((HAUT[e] / 100) * hPage));

  // Le défilement libre : un écart à la cible, remis à zéro à chaque temps.
  let libre = $state(0);
  let glisse = $state(false);
  let minuterie;
  $effect(() => { e; libre = 0; glisse = false; });
  const decalage = $derived(borne(cible + libre));
  let vue = $state(null);
  $effect(() => {
    if (!vue) return;
    return defilementLibre(vue, {
      deplacer: (dy) => {
        libre = borne(cible + libre + dy) - cible;
        glisse = true;
        clearTimeout(minuterie);
        minuterie = setTimeout(() => (glisse = false), 200);
      }
    });
  });
  const pouce = $derived(hPage ? { y: (decalage / hPage) * 100, h: Math.min(100, (hVue / hPage) * 100) } : { y: 0, h: 100 });

  // [haut, bas] en % de la hauteur de l'image.
  const X = [12.85, 26.15];
  const PERDU = [19.45, 22.85];
  const PRIOR = [9.45, 12.8];
  const N = [81.8, 83.8];
  const ETOILES = [93.0, 94.9];
</script>

<div class="visuel m8t2" bind:this={hote}>
  <div class="m8t2-scene">
    <div class="m8t2-vue" bind:this={vue} bind:clientHeight={hVue}>
      <div class="m8t2-page" class:m8t2-glisse={glisse} bind:clientHeight={hPage} style="transform: translateY({-decalage}px)">
        <img src="{base}/img/s8-bg-tableau2.png" alt="Le tableau 2 de l’article, en anglais : deux modèles, une vingtaine de variables et leurs coefficients. Dans le modèle 2, perdre au pays et dans sa circonscription : −0,447, trois étoiles. 1 922 répondants." />

        <!-- temps 0 : les deux modèles -->
        <span class="m8t2-tag m8t2-mod" class:on={e === 0} style="left: 59.1%">sans gagner / perdre</span>
        <span class="m8t2-tag m8t2-mod m8t2-rouge" class:on={e === 0} style="left: 88.1%">avec gagner / perdre</span>

        <!-- temps 1 et 2 : les voiles (contrôles), puis les autres lignes du X -->
        <span class="m8t2-voile" class:on={e === 1 || e === 3} style="top: {PRIOR[0]}%; height: {PRIOR[1] - PRIOR[0]}%"></span>
        <span class="m8t2-voile" class:on={e >= 1} style="top: {X[1]}%; height: {N[0] - X[1]}%"></span>
        <span class="m8t2-voile" class:on={e === 3} style="top: {N[1]}%; height: {ETOILES[0] - N[1]}%"></span>
        <span class="m8t2-voile m8t2-leger" class:on={e === 2} style="top: {X[0]}%; height: {PERDU[0] - X[0]}%"></span>
        <span class="m8t2-voile m8t2-leger" class:on={e === 2} style="top: {PERDU[1]}%; height: {X[1] - PERDU[1]}%"></span>

        <!-- temps 1 : leur X -->
        <span class="m8t2-cadre" class:on={e === 1} style="top: {X[0]}%; height: {X[1] - X[0]}%"></span>
        <span class="m8t2-tag m8t2-sur m8t2-rouge" class:on={e === 1} style="top: {X[0]}%">leur X · comparé à « gagner partout »</span>
        <span class="m8t2-etiq" class:on={e === 1} style="top: 28.6%">le reste&#8239;: des contrôles, on ne les lit pas</span>

        <!-- temps 2 : une ligne -->
        <span class="m8t2-cadre m8t2-pointille" class:on={e === 2} style="top: {PRIOR[0]}%; height: {PRIOR[1] - PRIOR[0]}%"></span>
        <span class="m8t2-tag m8t2-sur m8t2-droite" class:on={e === 2} style="top: {PRIOR[0]}%">satisfaction avant l’élection&#8239;: contrôlée</span>
        <span class="m8t2-cadre" class:on={e === 2} style="top: {PERDU[0]}%; height: {PERDU[1] - PERDU[0]}%"></span>
        <span class="m8t2-teinte" class:on={e === 2}></span>
        <div class="m8t2-glose" class:on={e === 2} style="top: {X[1] + 1.2}%">
          <span class="m8t2-glose-t">Perdre au pays et dans sa circonscription</span>
          <span class="m8t2-glose-s"><b>moins satisfait</b> que gagner partout, à satisfaction égale avant l’élection</span>
        </div>

        <!-- temps 3 : le bas -->
        <span class="m8t2-cadre m8t2-encre" class:on={e === 3} style="top: {N[0]}%; height: {N[1] - N[0]}%"></span>
        <span class="m8t2-tag m8t2-dessous" class:on={e === 3} style="top: {N[1]}%">1&#8239;922 répondants</span>
        <span class="m8t2-cadre m8t2-encre m8t2-etoiles" class:on={e === 3} style="top: {ETOILES[0]}%; height: {ETOILES[1] - ETOILES[0]}%"></span>
        <span class="m8t2-tag m8t2-cote" class:on={e === 3} style="top: {(ETOILES[0] + ETOILES[1]) / 2}%">la légende des étoiles</span>
      </div>
    </div>
    <!-- où l'on est dans le tableau -->
    <div class="m8t2-rail" aria-hidden="true"><span style="top: {pouce.y}%; height: {pouce.h}%"></span></div>
  </div>
  <div class="m8t2-pied">
    <span>Blais et Gélineau (2007), tableau 2, p. 432 · CES 1997</span>
    <span class="m8t2-probit">probit ordonné&#8239;: on lit le signe et les étoiles</span>
  </div>
</div>

<style>
/* La diapo entière : le tableau prend toute la largeur sous le bandeau. */
:global(.diapo-in:has(> .m8t2)) { max-width: none; padding: 0.6em 1.6em 2.5em; justify-content: stretch; }

  .m8t2 { flex: 1 1 auto; min-height: 0; display: grid; grid-template-rows: minmax(0, 1fr) auto; gap: 0.35em; }
  .m8t2-scene { min-height: 0; display: grid; grid-template-columns: minmax(0, 1fr) 0.4em; gap: 0.4em; }
  .m8t2-vue { position: relative; min-height: 0; overflow: hidden; border: 2px solid var(--dk-filet); background: #fff; touch-action: none; cursor: grab; }
  .m8t2-page { position: absolute; left: 0; right: 0; top: 0; transition: transform 1.3s cubic-bezier(0.65, 0, 0.35, 1); }
  .m8t2-page.m8t2-glisse { transition: transform 0.15s ease-out; }
  .m8t2-page img { display: block; width: 100%; height: auto; }

  .m8t2-voile { position: absolute; left: 0; right: 0; background: rgba(255, 255, 255, 0.88); opacity: 0; transition: opacity 0.4s; }
  .m8t2-leger { background: rgba(255, 255, 255, 0.66); }
  .m8t2-voile.on { opacity: 1; }

  /* x 108 à 425 pt : des étiquettes de lignes à la colonne (2) */
  .m8t2-cadre { position: absolute; left: 6.1%; width: 87.5%; outline: 4px solid var(--dk-accent); outline-offset: -4px; opacity: 0; transition: opacity 0.35s 0.2s; }
  .m8t2-cadre.on { opacity: 1; }
  .m8t2-pointille { outline: 3px dashed var(--dk-encre); outline-offset: -3px; }
  .m8t2-encre { outline: 3px solid var(--dk-encre); outline-offset: -3px; }
  .m8t2-etoiles { left: 1.4%; width: 31.5%; }
  /* −0,447*** : x 390,9 à 421,8 pt, y 167,1 à 174,9 pt */
  .m8t2-teinte { position: absolute; left: 83.4%; width: 9.6%; top: 19.6%; height: 1.8%; background: rgba(198, 16, 46, 0.22); mix-blend-mode: multiply; opacity: 0; transition: opacity 0.35s 0.3s; }
  .m8t2-teinte.on { opacity: 1; }

  .m8t2-tag {
    position: absolute; font-size: 0.7em; font-weight: 600; white-space: nowrap; line-height: 1;
    padding: 0.3em 0.6em; background: var(--dk-encre); color: var(--dk-fond);
    opacity: 0; transition: opacity 0.35s 0.2s;
  }
  .m8t2-tag.on { opacity: 1; }
  .m8t2-rouge { background: var(--dk-accent); }
  /* au-dessus des en-têtes (1) et (2), y 93 pt */
  .m8t2-mod { top: 6.5%; transform: translate(-50%, -100%); }
  .m8t2-sur { left: 6.1%; transform: translateY(-100%); }
  .m8t2-dessous { left: 6.1%; }
  .m8t2-droite { left: auto; right: 6.4%; }
  /* à droite du cadre des étoiles (x 1,4 à 32,9 %) */
  .m8t2-cote { left: 34.2%; transform: translateY(-50%); }

  .m8t2-etiq {
    position: absolute; left: 6.1%; font-size: 0.8em; font-weight: 600; color: var(--dk-gris);
    border-left: 4px solid var(--dk-gris-2); padding: 0.25em 0.7em; background: #fff;
    opacity: 0; transition: opacity 0.35s 0.25s;
  }
  .m8t2-etiq { transform: translateY(-50%); }
  .m8t2-etiq.on { opacity: 1; }

  .m8t2-glose {
    position: absolute; left: 6.1%; width: 87.5%; box-sizing: border-box;
    display: flex; flex-direction: column; gap: 0.2em;
    padding: 0.5em 0.8em; border-left: 6px solid var(--dk-accent); background: var(--dk-fond);
    opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s 0.35s, transform 0.4s 0.35s;
  }
  .m8t2-glose.on { opacity: 1; transform: none; }
  .m8t2-glose-t { font-size: 1.05em; font-weight: 700; }
  .m8t2-glose-s { font-size: 0.95em; }
  .m8t2-glose-s b { color: var(--dk-accent); font-weight: 700; }

  .m8t2-rail { position: relative; background: var(--dk-filet); }
  .m8t2-rail span { position: absolute; left: 0; right: 0; background: var(--dk-accent); transition: top 1.3s cubic-bezier(0.65, 0, 0.35, 1), height 0.3s; }

  .m8t2-pied { display: flex; justify-content: space-between; gap: 1em; font-size: 0.62em; color: var(--dk-gris); }
  .m8t2-probit { color: var(--dk-encre); font-weight: 600; }

  @media (prefers-reduced-motion: reduce) {
    .m8t2-page, .m8t2-rail span, .m8t2-voile, .m8t2-cadre, .m8t2-teinte, .m8t2-tag, .m8t2-etiq, .m8t2-glose { transition: none; }
  }
</style>
