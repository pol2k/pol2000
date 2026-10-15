<script module>
  /**
   * Les six études classiques de « La régression est partout ». Chaque
   * nombre est recopié de l'article lui-même, lu sur l'image de la page.
   * Le dossier complet (adresses des PDF, tableaux, pages, droits) :
   * /tmp/s7/classiques/DOSSIER.md et dossier-{ace,guerre,mobilite}.md.
   *
   * Chaque diapo montre la VRAIE page : la région de la page où le
   * tableau ou le graphique de la régression est imprimé, rendue depuis le
   * PDF à 300 ppp, recadrée serré, en gris (static/img/s7-classique-<id>-
   * page.png, moins de 110 Ko, nette à 2x). Le prof l'a demandé même pour
   * les articles sous droits; la référence complète, le tableau et la page
   * sont écrits sous l'image. `boite` : le cadre rouge autour du
   * coefficient clé, en % de l'image, calculé à partir des coordonnées des
   * mots dans le PDF (pdftotext -bbox), sauf Galton (planche gravée, sans
   * texte : placé à l'œil et vérifié). `zoom` : le grossissement de la
   * page au temps 2, centré sur le cadre (1 = pas de zoom), pour lire le
   * chiffre dans les tableaux serrés.
   *
   * Champs du récit (le prof n'a pas lu les articles : la diapo doit se
   * suffire) : genre (simple, multiple, logistique), donnees (qui, où,
   * quand, combien), y et x en mots, grand (le nombre encadré), lecture (le
   * résultat en une phrase), sens (ce que veut dire le nombre, et la
   * prudence qui va avec). Pour la diapo de fin (ClFin) : court, fin.
   */
  // cite : le nombre de citations selon OpenAlex (api.openalex.org, par DOI
  // ou par titre pour le livre de Mincer), relevé le 15 octobre 2026. Le
  // rapport de Blais et coll. (Élections Canada) n'y est pas indexé : pas de
  // nombre plutôt qu'un nombre non vérifié. importance : une phrase, ajoutée
  // à la demande du prof le même jour.
  export const ETUDES = {
    // Galton, F. (1886). Regression towards mediocrity in hereditary stature.
    // Journal of the Anthropological Institute, 15, 246–263.
    // doi:10.2307/2841583. Domaine public. Planche IX, fig. (a) : « The
    // Deviates of the Children are to those of their Mid-Parents as 2 to
    // 3. » Tableau I, p. 248 : 928 enfants adultes de 205 « mid-parents »
    // (moyenne du père et de 1,08 fois la mère). Droite tracée à la main sur
    // des médianes groupées : pas encore les moindres carrés.
    galton: {
      cite: '1 455',
      importance: 'L’article qui a donné son nom à la régression.',
      domaine: 'Hérédité', annee: 1886,
      auteurs: 'Galton (1886)', mots: 'la taille des enfants',
      fin: { y: 'taille des enfants', x: 'taille des parents' },
      genre: 'une droite, tracée à la main',
      donnees: '928 enfants adultes et leurs parents (205 couples), familles britanniques.',
      y: 'la taille des enfants, adultes', x: 'la taille moyenne des deux parents',
      page: 's7-classique-galton-page.png',
      boite: { x: 55.6, y: 13.4, l: 12.6, h: 5.6 }, zoom: 1,
      alt: 'Planche IX de Galton : la droite des parents, et celle des enfants, moins pentue',
      credit: 'Galton, F. (1886). Regression towards mediocrity in hereditary stature. Journal of the Anthropological Institute, 15, 246–263. Planche IX, fig. a. Domaine public.',
      grand: '2/3',
      lecture: 'Des parents 3 pouces plus grands que la moyenne ont des enfants 2 pouces plus grands, en moyenne.',
      sens: 'Les enfants « régressent » vers la moyenne. D’où le mot régression.'
    },
    // Mincer, J. (1974). Schooling, experience, and earnings. NBER.
    // Tableau 5.1, p. 92, ligne S(1) : « ln Y = 7.58 + .070s », rapport t
    // (43.8), R² .067. Note : « Figures in parentheses are t ratios. »
    // Hommes blancs non agricoles, revenus annuels de 1959 (titre du
    // tableau), échantillon du recensement de 1960.
    mincer: {
      cite: '5 906',
      importance: 'L’« équation de Mincer » : la façon standard de mesurer ce que rapporte l’école.',
      domaine: 'Économie de l’éducation', annee: 1974,
      auteurs: 'Mincer (1974)', mots: 'le salaire',
      fin: { y: 'revenu', x: 'scolarité' },
      genre: 'régression simple',
      donnees: 'Hommes blancs, hors agriculture, au recensement des États-Unis de 1960 (revenus de 1959).',
      y: 'le revenu annuel (en logarithme)', x: 'les années d’école',
      page: 's7-classique-mincer-page.png',
      boite: { x: 27.0, y: 22.8, l: 8.4, h: 7.0 }, zoom: 1,
      alt: 'Tableau 5.1 de Mincer : dix équations de revenu, la première est ln Y = 7.58 + .070s',
      credit: 'Mincer, J. (1974). Schooling, experience, and earnings. NBER. Tableau 5.1, ligne S(1), p. 92.',
      grand: '0,070',
      lecture: 'Une année d’école de plus : environ 7 % de revenu de plus.',
      sens: 'Le revenu est en logarithme, donc 0,070 se lit à peu près comme 7 %. Entre parenthèses, le t (43,8) : pas le hasard.'
    },
    // Felitti, V. J., Anda, R. F., et al. (1998). Relationship of childhood
    // abuse and household dysfunction to many of the leading causes of death
    // in adults: The Adverse Childhood Experiences (ACE) Study. American
    // Journal of Preventive Medicine, 14(4), 245–258.
    // doi:10.1016/S0749-3797(98)00017-8. Tableau 4, p. 252, bloc « Two or
    // more weeks of depressed mood in the past year », « 4 or more » :
    // 542 personnes, rapport de cotes ajusté 4.6 (IC 95 % 3.8–5.6), N du
    // bloc 7,945. Régression logistique (p. 249), ajustée pour l'âge, le
    // sexe, l'origine et la scolarité. Échantillon (p. 249) : 13 494
    // membres de Kaiser Permanente (San Diego) sollicités, 9 508 réponses.
    ace: {
      cite: '18 853',
      importance: 'Le point de départ du score ACE, utilisé aujourd’hui en santé publique et en travail social.',
      domaine: 'Travail social', annee: 1998,
      auteurs: 'Felitti et al. (1998)', mots: 'les blessures d’enfance',
      fin: { y: 'déprime', x: 'adversités de l’enfance' },
      genre: 'régression logistique',
      donnees: '9 508 adultes d’une assurance santé de San Diego (Kaiser Permanente), 7 945 pour cette ligne.',
      y: 'deux semaines ou plus de déprime dans l’année (oui ou non)', x: 'le nombre d’adversités vécues enfant (violence, négligence, parent en prison…)',
      page: 's7-classique-ace-page.png',
      boite: { x: 74.4, y: 78.3, l: 24.2, h: 3.2 }, zoom: 1,
      alt: 'Tableau 4 de Felitti et al. : rapports de cotes selon le nombre d’adversités, pour cinq problèmes de santé',
      credit: 'Felitti, V. J., Anda, R. F., et al. (1998). Relationship of childhood abuse and household dysfunction to many of the leading causes of death in adults. American Journal of Preventive Medicine, 14(4), 245–258. Tableau 4, p. 252.',
      grand: '4,6',
      lecture: 'Avec 4 adversités ou plus, la cote de déprime est 4,6 fois celle d’une enfance sans adversité.',
      sens: 'Un rapport de cotes : 1 veut dire aucune différence. À âge, sexe, origine et scolarité égaux. Une association, pas une preuve.'
    },
    // Blais, A., Massicotte, L., & Dobrzynska, A. (2003). Pourquoi le taux
    // de participation est-il plus élevé dans certains pays que d'autres ?
    // Élections Canada. Tableau 2A, p. 10 : vote obligatoire avec sanctions
    // 12,60*** (3,32), sans sanctions −3,82 (2,90), 148 cas, R² ajusté
    // 0,40. L'étude couvre 151 élections dans 61 démocraties depuis 1990.
    blais: {
      cite: null,
      importance: 'Un rapport pour Élections Canada : la régression au service d’une décision publique.',
      domaine: 'Politique comparée', annee: 2003,
      auteurs: 'Blais, Massicotte et Dobrzynska (2003)', court: 'Blais et al.', mots: 'le vote obligatoire',
      fin: { y: 'participation', x: 'vote obligatoire' },
      genre: 'régression multiple',
      donnees: '148 élections dans 61 démocraties, depuis 1990. Trois chercheurs de l’Université de Montréal.',
      y: 'le taux de participation (% des inscrits)', x: 'le vote obligatoire, avec ou sans amende, et le mode de scrutin, la région, la taille, la richesse',
      page: 's7-classique-blais-page.png',
      boite: { x: 43.9, y: 51.9, l: 39.8, h: 4.9 }, zoom: 1,
      alt: 'Tableau 2A de Blais et al. : les déterminants de la participation électorale',
      credit: 'Blais, A., Massicotte, L., & Dobrzynska, A. (2003). Pourquoi le taux de participation est-il plus élevé dans certains pays que d’autres ? Élections Canada. Tableau 2A, p. 10.',
      grand: '12,60',
      lecture: 'Là où l’abstention est punie d’une amende, la participation est 12,6 points plus haute.',
      sens: 'À pays comparables. Une obligation sans amende ne change rien (−3,82, sans étoile).'
    },
    // Collier, P., & Hoeffler, A. (2004). Greed and grievance in civil war.
    // Oxford Economic Papers, 56(4), 563–595. doi:10.1093/oep/gpf064.
    // Tableau 5, p. 578 (imprimé de côté, tourné ici), colonne 5 (le modèle
    // de base, p. 580) : scolarisation secondaire masculine −0.031
    // (0.010)***. Régression logistique (p. 572). N 688 périodes de cinq
    // ans, 46 guerres (p. 579). 161 pays, 1960-1999. Lecture des auteurs,
    // p. 581 : 10 points de plus, le risque passe de 11,5 % à 8,6 %.
    guerre: {
      cite: '6 101',
      importance: 'A lancé le grand débat sur les causes des guerres civiles : l’appât du gain ou les injustices ?',
      domaine: 'Relations internationales', annee: 2004,
      auteurs: 'Collier et Hoeffler (2004)', court: 'Collier et Hoeffler', mots: 'la guerre civile',
      fin: { y: 'guerre civile', x: 'école, croissance' },
      genre: 'régression logistique',
      donnees: '161 pays, de 1960 à 1999, en 688 périodes de cinq ans. 46 guerres civiles éclatent.',
      y: 'une guerre civile éclate ou non dans les cinq ans', x: 'la part des garçons à l’école secondaire, la croissance, les exportations',
      page: 's7-classique-guerre-page.png',
      boite: { x: 88.4, y: 64.1, l: 10.9, h: 13.5 }, zoom: 1,
      alt: 'Tableau 5 de Collier et Hoeffler : le modèle combiné, colonnes 1 à 5',
      credit: 'Collier, P., & Hoeffler, A. (2004). Greed and grievance in civil war. Oxford Economic Papers, 56(4), 563–595. Tableau 5, col. 5, p. 578.',
      grand: '−0,031',
      lecture: 'Plus il y a de garçons à l’école secondaire, moins une guerre civile risque d’éclater.',
      sens: '10 points de garçons scolarisés de plus : le risque passe de 11,5 % à 8,6 %. Une association, pas une preuve.'
    },
    // Chetty, R., Hendren, N., Kline, P., & Saez, E. (2014). Where is the
    // land of opportunity? Quarterly Journal of Economics, 129(4),
    // 1553–1623. doi:10.1093/qje/qju022. Figure II, panneau A, p. 1576
    // (imprimée de côté, tournée ici) : « Rank-Rank Slope = 0.341
    // (0.0003) », MCO (légende de la figure). Même pente au tableau I,
    // p. 1571 : 9 867 736 enfants nés de 1980 à 1982, données fiscales.
    // Canada : 0.174 (0.005), panneau B, même page.
    mobilite: {
      cite: '2 910',
      importance: 'A montré que l’ascenseur social dépend de l’endroit où l’on grandit.',
      domaine: 'Politiques sociales', annee: 2014,
      auteurs: 'Chetty et al. (2014)', mots: 'l’ascenseur social',
      fin: { y: 'rang de l’enfant', x: 'rang des parents' },
      genre: 'régression simple',
      donnees: '9,9 millions d’enfants nés aux États-Unis de 1980 à 1982, suivis dans les déclarations de revenus.',
      y: 'le rang de revenu de l’enfant, vers 30 ans (0 à 100)', x: 'le rang de revenu de ses parents (0 à 100)',
      page: 's7-classique-mobilite-page.png',
      boite: { x: 63.7, y: 75.8, l: 33.6, h: 11.5 }, zoom: 1,
      alt: 'Figure II, panneau A de Chetty et al. : le rang moyen des enfants monte en ligne droite avec le rang des parents',
      credit: 'Chetty, R., Hendren, N., Kline, P., & Saez, E. (2014). Where is the land of opportunity? Quarterly Journal of Economics, 129(4), 1553–1623. Figure II, panneau A, p. 1576.',
      grand: '0,341',
      lecture: 'Des parents 10 rangs plus haut : un enfant 3,4 rangs plus haut, une fois adulte.',
      sens: 'Les points sont presque sur la droite. Au Canada, la pente est d’environ 0,17 : la moitié.'
    }
  };
</script>

<script>
  /**
   * Une étude classique, une diapo qui se suffit : la vraie page de
   * l'article en grand, et le récit en clair à côté. Deux temps.
   *
   *   0  Le récit : le genre de régression, les données (qui, où, quand,
   *      combien), Y et X en mots. La place de la page est vide.
   *   1  La page : la région du tableau ou du graphique, telle qu'imprimée,
   *      avec la référence complète, le tableau et la page dessous.
   *   2  Le coefficient clé encadré en rouge (la page grossit autour de lui
   *      si le tableau est serré), puis le nombre en grand, le résultat en
   *      une phrase et ce que veut dire le nombre.
   *
   * Les données de chaque étude sont dans le module ci-dessus (ETUDES).
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  let { id } = $props();
  const s = $derived(ETUDES[id]);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le zoom se fait autour du cadre : son centre, sauf s'il touche un bord
  // de l'image, auquel cas on ancre à ce bord pour que le cadre reste
  // entier à l'écran.
  const axe = (debut, long) => (debut + long > 85 ? 100 : debut < 15 ? 0 : debut + long / 2);
  const origine = $derived(`${axe(s.boite.x, s.boite.l)}% ${axe(s.boite.y, s.boite.h)}%`);
</script>

<div class="visuel cl-etude" bind:this={hote}>
  <div class="cl-recit">
    <span class="cl-genre">{s.genre}</span>
    <p class="cl-poids"><span class="cl-cite">{s.cite ? `cité ${s.cite} fois` : 'rapport d’Élections Canada'}</span> {s.importance}</p>
    <p class="cl-donnees"><span class="cl-k">Données</span> {s.donnees}</p>
    <p class="cl-yx"><span class="cl-k">Y</span><span>{s.y}</span></p>
    <p class="cl-yx"><span class="cl-k">X</span><span>{s.x}</span></p>

    <div class="cl-lecture" class:vu={e >= 2}>
      <span class="cl-grand">{s.grand}</span>
      <span class="cl-phrase">{s.lecture}</span>
      <span class="cl-sens">{s.sens}</span>
    </div>
  </div>

  <figure class="cl-page" class:vu={e >= 1}>
    <div class="cl-cadre">
      <div class="cl-loupe" style="transform-origin: {origine}; transform: scale({e >= 2 ? s.zoom : 1})">
        <img src="{base}/img/{s.page}" alt={s.alt} />
        <span class="cl-boite" class:vu={e >= 2}
          style="left:{s.boite.x}%; top:{s.boite.y}%; width:{s.boite.l}%; height:{s.boite.h}%"></span>
      </div>
    </div>
    <figcaption>{s.credit}</figcaption>
  </figure>
</div>

<style>
  .cl-etude { display: grid; grid-template-columns: minmax(15em, 0.8fr) 1.45fr; gap: 1.6em; align-items: start; }

  /* Le récit */
  .cl-recit { display: flex; flex-direction: column; align-items: flex-start; gap: 0.5em; }
  .cl-genre { font-size: 0.66em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-fond); background: var(--dk-accent); padding: 0.25em 0.6em; }
  .cl-recit p { margin: 0; font-size: 0.8em; line-height: 1.4; }
  .cl-k { font-weight: 600; color: var(--dk-accent); }
  .cl-donnees .cl-k { display: block; margin-bottom: 0.1em; font-size: 0.8em; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris); }
  .cl-donnees { padding-bottom: 0.3em; border-bottom: 2px solid var(--dk-filet); }
  .cl-yx { display: grid; grid-template-columns: 1.4em 1fr; }

  .cl-lecture { display: flex; flex-direction: column; gap: 0.3em; margin-top: 0.4em; border-left: 0.32em solid var(--dk-accent); padding: 0.15em 0 0.15em 0.7em;
    opacity: 0; transform: translateY(8px); transition: opacity 0.45s 0.35s, transform 0.45s 0.35s; }
  .cl-lecture.vu { opacity: 1; transform: none; }
  .cl-grand { font-size: 2.3em; font-weight: 600; line-height: 1; letter-spacing: -0.04em; color: var(--dk-accent); font-variant-numeric: tabular-nums; white-space: nowrap; }
  .cl-phrase { font-size: 0.86em; line-height: 1.38; font-weight: 600; }
  .cl-sens { font-size: 0.72em; line-height: 1.4; color: var(--dk-gris); }

  /* La page */
  .cl-page { margin: 0; opacity: 0; transform: translateY(12px); transition: opacity 0.5s, transform 0.5s; min-width: 0; }
  .cl-page.vu { opacity: 1; transform: none; }
  .cl-cadre { overflow: hidden; border: 2px solid var(--dk-encre); background: #fff; line-height: 0; width: fit-content; max-width: 100%; }
  .cl-loupe { position: relative; transition: transform 0.9s cubic-bezier(0.3, 0.7, 0.2, 1); }
  .cl-loupe img { display: block; max-width: 100%; max-height: 62vh; width: auto; height: auto; }
  .cl-boite { position: absolute; border: 3px solid var(--dk-accent); background: rgba(198, 16, 46, 0.1); opacity: 0; transition: opacity 0.4s 0.5s; }
  .cl-boite.vu { opacity: 1; }
  .cl-page figcaption { margin-top: 0.45em; font-size: 0.56em; line-height: 1.4; color: var(--dk-gris); max-width: 62em; }

  @media (prefers-reduced-motion: reduce) {
    .cl-page, .cl-lecture, .cl-loupe, .cl-boite { transition: none; }
  }
  .cl-poids { margin: 0; font-size: 0.78em; line-height: 1.35; color: var(--dk-encre); }
  .cl-cite { display: inline-block; font-weight: 700; color: var(--dk-accent); margin-right: 0.35em; }
</style>
