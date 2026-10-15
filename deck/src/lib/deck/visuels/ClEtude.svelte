<script module>
  /**
   * Les six études classiques de « La régression est partout ». Chaque
   * nombre est recopié de l'article lui-même (page lue sur l'image de la
   * page, pas dans une source secondaire); le dossier complet, avec les
   * adresses des PDF, est dans le rapport de l'agent i (/tmp/s7/classiques/
   * DOSSIER.md, à verser dans docs/ si le prof le souhaite). Seuls changent
   * le séparateur décimal (virgule) et le zéro avant la virgule (.133 →
   * 0,133); le nombre de décimales est celui de l'article. Les noms de
   * variables sont traduits par nous, sauf Blais et coll. (édition
   * française officielle).
   *
   * Champs : domaine, annee, auteurs, revue, vignette, genre (le badge),
   * y et x (la régression en mots), piece ('tableau' | 'equation' |
   * 'image'), titre (tableau et page), tableau (ClTableau), grand et
   * lecture (le temps 2). Facultatifs, pour la frise (ClMur) et la diapo
   * de fin (ClFin) : court (nom court), mots (la question en trois mots),
   * fin ({ y, x } en deux ou trois mots). Sans eux, on les déduit de
   * auteurs, y et x.
   *
   * En réserve, sans diapo : Okun (la section garde six études), Tufte et
   * Gerber et Green (une seule étude de science politique est montrée,
   * Blais et al., à la demande du prof).
   *
   * Droits : Galton (1886) est du domaine public, d'où l'image de sa vraie
   * planche. Les autres ne sont pas sous licence libre : une vignette de la
   * première page, et seulement les lignes utiles du tableau, recomposées.
   */
  export const ETUDES = {
    // Galton, F. (1886). Regression towards mediocrity in hereditary stature.
    // J. of the Anthropological Institute, 15, 246–263. doi:10.2307/2841583.
    // Planche IX, fig. (a) : « The Deviates of the Children are to those of
    // their Mid-Parents as 2 to 3. » Texte, p. 252 : « two-thirds ».
    // La droite est tracée à la main sur des médianes groupées : pas encore
    // les moindres carrés.
    galton: {
      domaine: 'Hérédité', annee: 1886,
      mots: 'la taille des enfants', fin: { y: 'taille des enfants', x: 'taille des parents' },
      auteurs: 'Galton (1886)', revue: 'Journal of the Anthropological Institute',
      vignette: 's7-classique-galton-p1.png',
      genre: 'une droite tracée à la main',
      y: 'la taille des enfants', x: 'la taille des parents',
      piece: 'image', image: 's7-classique-galton-planche.png',
      alt: 'Planche IX de Galton : la droite des parents et la droite des enfants, moins pentue',
      // Le cadre rouge autour de « as 2 to 3 », en % de l'image recadrée.
      boite: { x: 55.6, y: 13.4, l: 12.6, h: 5.6 },
      titre: 'Planche IX, fig. a · domaine public',
      grand: '2/3',
      lecture: 'Des parents 3 pouces au-dessus de la moyenne, des enfants 2 pouces au-dessus. Ils « régressent » vers la moyenne.'
    },
    // Okun, A. M. (1962). Potential GNP: Its measurement and significance.
    // Proceedings of the Business and Economic Statistics Section, ASA.
    // Tiré à part : Cowles Foundation Paper 190, p. 2 (le tiré à part ne
    // porte pas la pagination des Proceedings). « Y = .30 - .30X (r=.79) »,
    // 55 trimestres, 1947-II à 1960-IV. Y : variation trimestrielle du taux
    // de chômage (points), X : variation trimestrielle du PNB réel (%).
    okun: {
      domaine: 'Économie', annee: 1962,
      mots: 'le chômage', fin: { y: 'chômage', x: 'croissance' },
      auteurs: 'Okun (1962)', revue: 'Proceedings of the American Statistical Association',
      vignette: 's7-classique-okun-p1.png',
      genre: 'régression simple · 55 trimestres',
      y: 'la variation du chômage (points)', x: 'la croissance du PIB réel (%)',
      piece: 'equation',
      equation: { debut: 'Y = 0,30', pente: '− 0,30 X', r: '(r = 0,79)' },
      titre: 'Équation, p. 2 du tiré à part · recomposée',
      grand: '−0,30',
      lecture: '1 % de croissance de plus, 0,3 point de chômage de moins.'
    },
    // Mincer, J. (1974). Schooling, experience, and earnings. NBER.
    // Tableau 5.1, p. 92, ligne S(1) : « ln Y = 7.58 + .070s », rapport t
    // (43.8), R² .067. Note du tableau : « Figures in parentheses are t
    // ratios. » Hommes blancs non agricoles, revenus de 1959.
    mincer: {
      domaine: 'Économie de l’éducation', annee: 1974,
      mots: 'le salaire', fin: { y: 'revenu', x: 'scolarité' },
      auteurs: 'Mincer (1974)', revue: 'Schooling, Experience, and Earnings',
      vignette: 's7-classique-mincer-p1.png',
      genre: 'régression simple',
      y: 'le revenu annuel', x: 'les années de scolarité',
      piece: 'tableau',
      titre: 'Tableau 5.1, ligne S(1), p. 92 · recomposé',
      tableau: {
        y: 'Revenu annuel 1959', ysous: '(en logarithme)',
        lignes: [
          { nom: 'Scolarité', sous: '(années)', b: '0,070', par: '(43,8)', cle: true },
          { nom: 'Constante', b: '7,58' }
        ],
        pied: [['R²', '0,067']],
        notes: ['Rapports t entre parenthèses.']
      },
      grand: '0,070',
      lecture: 'Une année d’école de plus, environ 7 % de revenu de plus.'
    },
    // Tufte, E. R. (1975). Determinants of the outcomes of midterm
    // congressional elections. APSR, 69(3), 812–826. doi:10.2307/1958391.
    // Tableau 2, p. 818 : β1 = .133* (.033), β2 = .035* (.006), constante
    // −11.083, R² = 0.912, * significatif à .01. N = 8 élections de
    // mi-mandat, 1938 à 1970 sans 1942 (tableau 1, p. 816). Sa lecture,
    // p. 818 : 10 points de popularité, 1,3 point de vote.
    tufte: {
      domaine: 'Science politique', annee: 1975,
      mots: 'les élections', fin: { y: 'vote', x: 'popularité + économie' },
      auteurs: 'Tufte (1975)', revue: 'American Political Science Review',
      vignette: 's7-classique-tufte-p1.png',
      genre: 'régression multiple · 2 X · 8 élections',
      y: 'le recul du parti du président', x: 'sa popularité, le revenu des ménages',
      piece: 'tableau',
      titre: 'Tableau 2, p. 818 · recomposé',
      tableau: {
        y: 'Vote du parti du président', ysous: '(écart à sa normale, en points)',
        lignes: [
          { nom: 'Popularité du président', sous: '(%)', b: '0,133', et: '*', par: '(0,033)', cle: true },
          { nom: 'Variation du revenu réel', sous: '($)', b: '0,035', et: '*', par: '(0,006)' },
          { nom: 'Constante', b: '−11,083' }
        ],
        pied: [['R²', '0,912']],
        notes: ['* significatif au seuil de 0,01.', 'Erreurs types entre parenthèses.']
      },
      grand: '0,133',
      lecture: '10 points de popularité de plus, 1,3 point de vote de plus.'
    },
    // Gerber, A. S., & Green, D. P. (2000). The effects of canvassing,
    // telephone calls, and direct mail on voter turnout. APSR, 94(3),
    // 653–663. doi:10.2307/2585837.
    // Tableau 5, p. 659, 1re colonne (« Two-stage least squares », sans
    // covariables) : contact en personne .087 (.026), envois .0058 (.0027),
    // téléphone −.047 (.023), constante .445, degrés de liberté 29,376.
    // Moindres carrés en deux étapes, pas les MCO simples : tout le monde
    // n'a pas ouvert sa porte. L'attribution est tirée au sort.
    gerber: {
      domaine: 'Science politique', annee: 2000,
      mots: 'le porte-à-porte', fin: { y: 'participation', x: 'porte-à-porte' },
      auteurs: 'Gerber et Green (2000)', revue: 'American Political Science Review',
      vignette: 's7-classique-gerber-green-p1.png',
      genre: 'expérience · tirage au sort',
      y: 'a voté ou non', x: 'une visite à la porte',
      piece: 'tableau',
      titre: 'Tableau 5, 1re colonne, p. 659 · recomposé',
      tableau: {
        y: 'A voté en 1998', ysous: '(1 = oui, 0 = non)',
        lignes: [
          { nom: 'Contact en personne', b: '0,087', par: '(0,026)', cle: true },
          { nom: 'Envois postaux', sous: '(0 à 3)', b: '0,0058', par: '(0,0027)' },
          { nom: 'Appel téléphonique', b: '−0,047', par: '(0,023)' },
          { nom: 'Constante', b: '0,445' }
        ],
        pied: [['Degrés de liberté', '29 376']],
        notes: ['Moindres carrés en deux étapes.', 'Erreurs types entre parenthèses.']
      },
      grand: '0,087',
      lecture: 'Une visite à la porte, 8,7 points de participation de plus.'
    },
    // Blais, A., Massicotte, L., & Dobrzynska, A. (2003). Pourquoi le taux
    // de participation est-il plus élevé dans certains pays que d'autres ?
    // Élections Canada (SE3-89/2003F). Tableau 2A, p. 10 (p. 9 en anglais) :
    // vote obligatoire avec sanctions 12,60*** (3,32), sans sanctions −3,82
    // (2,90), RP et mixte compensatoire 4,80** (2,19), constante 56,84***
    // (10,80), 148 cas, R² ajusté 0,40. Seuils : * 0,10, ** 0,05,
    // *** 0,01. Cinq lignes omises : Amérique du Nord, Europe de l'Est,
    // population (log), PIB par habitant (log), Mali.
    blais: {
      domaine: 'Politique comparée', annee: 2003,
      court: 'Blais et al.', mots: 'le vote obligatoire', fin: { y: 'participation', x: 'vote obligatoire' },
      auteurs: 'Blais, Massicotte et Dobrzynska (2003)', revue: 'Élections Canada',
      vignette: 's7-classique-blais-p1.png',
      genre: 'régression multiple · 148 élections',
      y: 'le taux de participation', x: 'le vote obligatoire',
      piece: 'tableau',
      titre: 'Tableau 2A, p. 10 · recomposé',
      tableau: {
        y: 'Taux de participation', ysous: '(% des électeurs inscrits)',
        lignes: [
          { nom: 'Vote obligatoire avec sanctions', b: '12,60', et: '***', par: '(3,32)', cle: true },
          { nom: 'Vote obligatoire sans sanctions', b: '−3,82', par: '(2,90)' },
          { nom: 'RP et mixte compensatoire', b: '4,80', et: '**', par: '(2,19)' },
          { nom: '… et 5 autres variables', ellipse: true },
          { nom: 'Constante', b: '56,84', et: '***', par: '(10,80)' }
        ],
        pied: [['Nombre de cas', '148'], ['R² ajusté', '0,40']],
        notes: ['*** significatif à 0,01 · ** à 0,05 · * à 0,10', 'Erreurs types entre parenthèses.']
      },
      grand: '12,60',
      lecture: 'Là où l’abstention est punie, 12,6 points de participation de plus.'
    },
    // Chetty, R., Hendren, N., Kline, P., & Saez, E. (2014). Where is the land
    // of opportunity? The geography of intergenerational mobility in the
    // United States. Quarterly Journal of Economics, 129(4), 1553–1623.
    // doi:10.1093/qje/qju022. (Document de travail NBER w19843, révisé en
    // juin 2014 : mêmes nombres au tableau I, p. 70 du PDF.)
    // Tableau I, p. 1571, ligne 4 (« Family income rank » sur « Family income
    // rank »), colonne 1 (« Core sample ») : 0.341 (0.0003). Nombre
    // d'observations, même colonne (p. 1572, suite du tableau) : 9,867,736.
    // Note du tableau, p. 1572 : « Each cell in this table reports the
    // coefficient from a univariate OLS regression [...] with standard
    // errors in parentheses. » Pas de constante ni de R² au tableau.
    // Échantillon : enfants nés de 1980 à 1982, revenu familial moyen
    // 2011-2012 (vers 30 ans), parents : revenu familial moyen 1996-2000.
    // Même pente, p. 1575 (texte) et figure II, panneau A, p. 1576
    // (« Rank-Rank Slope = 0.341 (0.0003) »). Lecture des auteurs, résumé,
    // p. 1553 : « a 10 percentile increase in parent income is associated
    // with a 3.4 percentile increase in a child's income ».
    // Selon la ville (tableau III, p. 1594-1595) : Salt Lake City 0.264,
    // Charlotte 0.397. Canada : 0.174 (0.005), figure II, panneau B, p. 1576.
    mobilite: {
      domaine: 'Politiques sociales', annee: 2014,
      mots: 'l’ascenseur social', fin: { y: 'rang de l’enfant', x: 'rang des parents' },
      auteurs: 'Chetty et al. (2014)', revue: 'Quarterly Journal of Economics',
      vignette: 's7-classique-mobilite-p1.png',
      genre: 'régression simple · 9,9 millions d’enfants',
      y: 'le rang de revenu de l’enfant, adulte', x: 'le rang de revenu des parents',
      piece: 'tableau',
      titre: 'Tableau I, p. 1571 · recomposé',
      tableau: {
        y: 'Rang de revenu de l’enfant', ysous: '(centile, vers 30 ans)',
        lignes: [
          { nom: 'Rang de revenu des parents', sous: '(centile)', b: '0,341', et: '', par: '(0,0003)', cle: true }
        ],
        pied: [['Nombre d’enfants', '9 867 736']],
        notes: ['Régression MCO à une seule variable X.', 'Erreur type entre parenthèses.', 'Données fiscales des États-Unis, enfants nés de 1980 à 1982.']
      },
      grand: '0,34',
      lecture: 'Des parents 10 rangs plus haut, un enfant 3,4 rangs plus haut.'
    },
    // Felitti, V. J., Anda, R. F., Nordenberg, D., Williamson, D. F., Spitz,
    // A. M., Edwards, V., Koss, M. P., & Marks, J. S. (1998). Relationship of
    // childhood abuse and household dysfunction to many of the leading causes
    // of death in adults: The Adverse Childhood Experiences (ACE) Study.
    // American Journal of Preventive Medicine, 14(4), 245–258.
    // doi:10.1016/S0749-3797(98)00017-8.
    // Tableau 4, p. 252 (lu sur l'image de la page), bloc « Two or more weeks
    // of depressed mood in the past year » : rapports de cotes ajustés (IC 95 %)
    // 0 = 1.0 (Referent), 1 = 1.5 (1.3–1.7), 2 = 2.4 (2.0–2.8),
    // 3 = 2.6 (2.1–3.2), 4 or more = 4.6 (3.8–5.6). N total du bloc 7,945.
    // Prévalences (même bloc, ajustées pour l'âge seulement) : 0 = 14.2 %,
    // 4 or more = 50.7 %. Note c du tableau : « Odds ratios adjusted for age,
    // gender, race, and educational attainment. »
    // Méthode, p. 249 : « Logistic regression analysis was employed to adjust
    // for the potential confounding effects of age, sex, race, and educational
    // attainment ». Régression logistique (une cousine de la régression
    // linéaire), pas des MCO : on lit des rapports de cotes, pas des b.
    // Droits : © 1998 American Journal of Preventive Medicine (Elsevier), pas
    // de licence libre. Lignes recomposées, vignette de la p. 245.
    ace: {
      domaine: 'Travail social', annee: 1998,
      mots: 'les blessures d’enfance', fin: { y: 'déprime', x: 'adversités de l’enfance' },
      auteurs: 'Felitti et al. (1998)', revue: 'American Journal of Preventive Medicine',
      vignette: 's7-classique-ace-p1.png',
      genre: 'régression logistique multiple · 7 945 adultes',
      y: 'avoir vécu deux semaines ou plus de déprime dans l’année', x: 'le nombre d’adversités vécues dans l’enfance',
      piece: 'tableau',
      titre: 'Tableau 4, p. 252 · recomposé',
      tableau: {
        y: 'Humeur dépressive', ysous: '(rapport de cotes ajusté)',
        lignes: [
          { nom: 'Aucune adversité', sous: '(référence)', b: '1,0' },
          { nom: 'Une adversité', b: '1,5', par: '(1,3 à 1,7)' },
          { nom: 'Deux adversités', b: '2,4', par: '(2,0 à 2,8)' },
          { nom: 'Trois adversités', b: '2,6', par: '(2,1 à 3,2)' },
          { nom: 'Quatre ou plus', b: '4,6', par: '(3,8 à 5,6)', cle: true }
        ],
        pied: [['N', '7 945']],
        notes: ['Ajusté pour l’âge, le sexe, l’origine ethnoraciale et la scolarité.', 'Intervalles de confiance à 95 % entre parenthèses.']
      },
      grand: '4,6',
      lecture: 'Quatre adversités ou plus : une cote de déprime 4,6 fois celle des enfances sans adversité.'
    },
    // Collier, P., & Hoeffler, A. (2004). Greed and grievance in civil war.
    // Oxford Economic Papers, 56(4), 563–595. doi:10.1093/oep/gpf064.
    // Tableau 5 (« Combined opportunity and grievance model »), pp. 578-579,
    // colonne 5 = le modèle de base (« baseline model of column 5 », p. 580).
    // Régression logistique (« through a logit regression », p. 572).
    // Col. 5 : exportations de produits primaires/PIB 18.937 (5.865)***,
    // leur carré −29.443 (11.781)***, scolarisation secondaire masculine
    // −0.031 (0.010)***, (croissance du PIB) t−1 −0.115 (0.043)***, plus
    // 5 autres variables (durée de la paix, dispersion géographique, ln
    // population, fractionnement social, dominance ethnique). N 688, 46
    // guerres, pseudo-R² 0.24 (p. 579). Constante incluse, non publiée.
    // *** significatif à 1 % (note du tableau, p. 579).
    // Y : début d'une guerre civile (≥ 1 000 morts au combat par an, p. 565)
    // pendant une période de cinq ans, 1965-69 à 1995-99 (p. 572).
    // Scolarisation : % des garçons à l'école secondaire (tableau 2, p. 568).
    // Lecture, p. 581 : « If the enrollment rate for secondary schooling is
    // ten percentage points higher than the average the risk of war is
    // reduced by about three percentage points (a decline in the risk from
    // 11.5% to 8.6%). »
    guerre: {
      domaine: 'Relations internationales', annee: 2004,
      court: 'Collier et Hoeffler', mots: 'la guerre civile', fin: { y: 'guerre civile', x: 'école, croissance' },
      auteurs: 'Collier et Hoeffler (2004)', revue: 'Oxford Economic Papers',
      vignette: 's7-classique-guerre-p1.png',
      genre: 'régression logistique · 688 périodes de 5 ans',
      y: 'une guerre civile éclate ou non', x: 'les garçons à l’école secondaire, la croissance',
      piece: 'tableau',
      titre: 'Tableau 5, col. 5, p. 578 · recomposé',
      tableau: {
        y: 'Début d’une guerre civile', ysous: '(dans les 5 ans, 1 = oui)',
        lignes: [
          { nom: 'Exportations primaires', sous: '(part du PIB)', b: '18,937', et: '***', par: '(5,865)' },
          { nom: 'Exportations primaires²', b: '−29,443', et: '***', par: '(11,781)' },
          { nom: 'Garçons au secondaire', sous: '(% scolarisés)', b: '−0,031', et: '***', par: '(0,010)', cle: true },
          { nom: 'Croissance du PIB', sous: '(période précédente)', b: '−0,115', et: '***', par: '(0,043)' },
          { nom: '… et 5 autres variables', ellipse: true }
        ],
        pied: [['N', '688'], ['Guerres', '46'], ['Pseudo-R²', '0,24']],
        notes: ['Régression logistique, une cousine de la régression linéaire.', '*** significatif à 0,01 · erreurs types entre parenthèses.']
      },
      grand: '−0,031',
      lecture: '10 points de garçons de plus au secondaire, le risque de guerre passe de 11,5 % à 8,6 %.'
    }
  };
</script>

<script>
  /**
   * Une étude classique, une diapo. À gauche, l'article (le domaine, la
   * vignette de la première page, la référence, le genre de
   * régression). À droite, la régression en mots (Y et X), puis la pièce
   * (le tableau recomposé, l'équation, ou la planche de Galton), puis la
   * lecture en une ligne. Deux temps.
   *
   *   0  L'article et sa régression en mots : Y, X.
   *   1  La pièce : le tableau tel que publié (ou l'équation, ou la planche).
   *   2  Le coefficient clé passe au rouge, le reste au gris; à côté, le
   *      nombre en grand et sa lecture en une ligne.
   *
   * Les données de chaque étude, avec leur page, sont dans le module
   * ci-dessus (ETUDES). `id` choisit l'étude.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import ClTableau from './ClTableau.svelte';

  let { id } = $props();
  const s = $derived(ETUDES[id]);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel cl-etude" bind:this={hote}>
  <aside class="cl-papier">
    <span class="cl-tag">{s.domaine}</span>
    <img class="cl-vignette" src="{base}/img/{s.vignette}" alt="Première page : {s.auteurs}" />
    <strong class="cl-auteurs">{s.auteurs}</strong>
    <em class="cl-revue">{s.revue}</em>
    <span class="cl-genre">{s.genre}</span>
  </aside>

  <div class="cl-droite">
    <div class="cl-yx">
      <span class="cl-k">Y</span><span class="cl-v">{s.y}</span>
      <span class="cl-k">X</span><span class="cl-v">{s.x}</span>
    </div>

    <div class="cl-bas">
      <figure class="cl-piece" class:vu={e >= 1}>
        {#if s.piece === 'tableau'}
          <ClTableau t={s.tableau} cle={e >= 2} />
        {:else if s.piece === 'equation'}
          <div class="cl-eq" class:cle={e >= 2}>
            <span>{s.equation.debut} <b>{s.equation.pente}</b></span>
            <span class="cl-r">{s.equation.r}</span>
          </div>
        {:else if s.piece === 'image'}
          <div class="cl-planche">
            <img src="{base}/img/{s.image}" alt={s.alt} />
            <span class="cl-boite" class:vu={e >= 2}
              style="left:{s.boite.x}%; top:{s.boite.y}%; width:{s.boite.l}%; height:{s.boite.h}%"></span>
          </div>
        {/if}
        <figcaption>{s.titre}</figcaption>
      </figure>

      <div class="cl-lecture" class:vu={e >= 2}>
        <span class="cl-grand">{s.grand}</span>
        <span class="cl-phrase">{s.lecture}</span>
      </div>
    </div>
  </div>
</div>

<style>
  .cl-etude { display: grid; grid-template-columns: 11.5em 1fr; gap: 1.8em; align-items: start; }

  /* L'article */
  .cl-papier { display: flex; flex-direction: column; align-items: flex-start; gap: 0.35em; }
  .cl-tag { font-size: 0.62em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-fond); background: var(--dk-accent); padding: 0.2em 0.55em; }
  .cl-vignette { display: block; width: auto; max-width: 100%; max-height: 13em; border: 2px solid var(--dk-encre); background: #fff; margin: 0.25em 0 0.2em; }
  .cl-auteurs { font-size: 0.82em; line-height: 1.3; }
  .cl-revue { font-size: 0.62em; line-height: 1.35; color: var(--dk-gris); }
  .cl-genre { font-size: 0.62em; line-height: 1.35; border: 2px solid var(--dk-encre); padding: 0.2em 0.5em; margin-top: 0.3em; }

  /* La régression en mots */
  .cl-droite { display: flex; flex-direction: column; gap: 1.1em; min-width: 0; }
  .cl-yx { display: grid; grid-template-columns: auto 1fr; column-gap: 0.7em; row-gap: 0.25em; align-items: baseline; font-size: 1.05em; }
  .cl-k { font-weight: 600; color: var(--dk-accent); }
  .cl-v { line-height: 1.3; }

  .cl-bas { display: grid; grid-template-columns: auto 1fr; gap: 1.8em; align-items: center; }

  /* La pièce */
  .cl-piece { margin: 0; opacity: 0; transform: translateY(10px); transition: opacity 0.45s, transform 0.45s; font-size: 0.86em; }
  .cl-piece.vu { opacity: 1; transform: none; }
  .cl-piece figcaption { margin-top: 0.5em; font-size: 0.66em; color: var(--dk-gris); }

  .cl-eq { display: flex; flex-direction: column; gap: 0.4em; border: 2px solid var(--dk-encre); background: #fff; padding: 0.8em 1.2em; font-size: 1.9em; white-space: nowrap; }
  .cl-eq b { font-weight: 400; transition: color 0.3s; }
  .cl-eq.cle b { color: var(--dk-accent); font-weight: 600; }
  .cl-r { font-size: 0.6em; color: var(--dk-gris); }

  .cl-planche { position: relative; line-height: 0; border: 2px solid var(--dk-encre); }
  .cl-planche img { display: block; height: 16em; width: auto; }
  .cl-boite { position: absolute; border: 3px solid var(--dk-accent); background: rgba(198, 16, 46, 0.1); opacity: 0; transform: scale(1.4); transition: opacity 0.35s, transform 0.45s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .cl-boite.vu { opacity: 1; transform: none; }

  /* La lecture */
  .cl-lecture { display: flex; flex-direction: column; gap: 0.35em; border-left: 0.32em solid var(--dk-accent); padding: 0.2em 0 0.2em 0.7em;
    opacity: 0; transform: scale(0.92); transform-origin: left center; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .cl-lecture.vu { opacity: 1; transform: none; }
  .cl-grand { font-size: 2.6em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; white-space: nowrap; }
  .cl-phrase { font-size: 0.92em; line-height: 1.4; }

  @media (prefers-reduced-motion: reduce) {
    .cl-piece, .cl-lecture, .cl-boite { transition: none; }
  }
</style>
