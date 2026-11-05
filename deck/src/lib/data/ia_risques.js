/* Le côté sombre de l’IA, pour la séance 9 (après l’empreinte environnementale).
   Cinq thèmes, un grand chiffre chacun, une frise courte et une ligne de débat
   attribuée. Vérifié aux sources primaires le 5 novembre 2026 (ticket
   pol-1gf). Ne rien ajouter de mémoire.

   Règles d’écriture : une prédiction n’est jamais présentée comme un fait, une
   allégation contestée garde son auteur, et chaque thème donne la parole à
   l’autre camp. Les espaces fines insécables (U+202F) sont déjà dans les
   chaînes, devant ? : ! et dans les nombres. */

export const RISQUES = [
  /* Livres piratés.
     Bartz c. Anthropic, ordonnance sur l’usage équitable, 23 juin 2025 (juge Alsup) :
       https://storage.courtlistener.com/recap/gov.uscourts.cand.434709/gov.uscourts.cand.434709.231.0.pdf
       p. 3 : « at least five million copies of books from Library Genesis » (juin 2021),
       « over seven million copies » au total (copies téléchargées, pas des œuvres distinctes).
     Approbation finale, 20 juillet 2026 (juge Martínez-Olguín, le juge Alsup ayant pris sa retraite) :
       https://www.anthropiccopyrightsettlement.com/
       https://pearlcohen.com/federal-court-approves-1-5-billion-anthropic-copyright-settlement-largest-in-history
       1,5 G$ US plus intérêts, 482 460 œuvres, environ 3 000 $ US par œuvre. Aucun aveu de responsabilité.
     Kadrey c. Meta, ordonnance du 25 juin 2025 (juge Chhabria) :
       https://storage.courtlistener.com/recap/gov.uscourts.cand.415175/gov.uscourts.cand.415175.598.0.pdf
     Toronto Star c. OpenAI, 2025 ONSC 6217, 7 novembre 2025 (juge Kimmel) :
       https://www.theglobeandmail.com/business/article-openai-chatgpt-media-outlets-win-motion-ontario-court
       https://www.litigate.com/canadian-news-media-companies-v-openai-jurisdiction-motion */
  {
    cle: 'livres',
    titre: 'Des livres piratés',
    grand: { nombre: '1,5 G$ US', legende: 'Règlement d’Anthropic, approuvé en juillet 2026' },
    frise: [
      { date: '2021-06', texte: 'Anthropic télécharge au moins 5 millions de copies de livres sur LibGen' },
      { date: '2025-06', texte: 'Juge Alsup : entraîner, oui. Garder des copies piratées, non' },
      { date: '2025-11', texte: 'Les médias canadiens peuvent poursuivre OpenAI en Ontario' },
      { date: '2026-07', texte: 'Règlement approuvé : 482 460 livres, environ 3 000 $ US chacun' }
    ],
    debat: 'Juge Alsup : entraîner est « transformateur ». Juge Chhabria (affaire Meta) : souvent illégal sans permission',
    sources: [
      'Bartz c. Anthropic, ordonnance du 23 juin 2025 (Californie du Nord)',
      'Site officiel du règlement Bartz, approbation finale du 20 juillet 2026',
      'Kadrey c. Meta, ordonnance du 25 juin 2025',
      'Toronto Star c. OpenAI, 2025 ONSC 6217'
    ]
  },

  /* Livres détruits.
     Bartz c. Anthropic, ordonnance du 23 juin 2025, p. 3-4, 12-13 et 30-31 :
       https://storage.courtlistener.com/recap/gov.uscourts.cand.434709/gov.uscourts.cand.434709.231.0.pdf
       « Anthropic spent many millions of dollars to purchase millions of print books, often in
       used condition. Then, its service providers stripped the books from their bindings, cut their
       pages to size, and scanned the books into digital form, discarding the paper originals » (tiret de l’original remplacé par une virgule).
       « The print original was destroyed. One replaced the other. » (usage équitable)
       Embauche de Tom Turvey, ex-chef des partenariats de Google Books, février 2024.
     Washington Post, 27 janvier 2026, « Projet Panama » (documents descellés), relayé par :
       https://www.infodocket.com/2026/01/27/washington-post-books-ai-train/
       https://lithub.com/anthropic-didnt-want-us-to-know-that-they-were-destroying-millions-of-books-to-feed-their-software
       « Project Panama is our effort to destructively scan all the books in the world. »
     Aucun nombre exact de livres détruits n’est public : le jugement dit « millions ». */
  {
    cle: 'detruits',
    titre: 'Des livres détruits',
    grand: { nombre: 'Des millions', legende: 'de livres achetés, découpés, numérisés, puis jetés' },
    frise: [
      { date: '2024-02', texte: 'Anthropic embauche l’ex-chef des partenariats de Google Books' },
      { date: '2025-06', texte: 'Juge Alsup : livres souvent usagés, achetés, découpés, numérisés, jetés' },
      { date: '2026-01', texte: 'Washington Post : le « Projet Panama » visait « tous les livres du monde »' }
    ],
    debat: 'Juge Alsup : permis justement parce que l’original est détruit, « l’un a remplacé l’autre »',
    sources: [
      'Bartz c. Anthropic, ordonnance du 23 juin 2025, p. 4 et 30-31',
      'Washington Post, 27 janvier 2026 (documents judiciaires descellés)'
    ]
  },

  /* Risque existentiel.
     Déclaration du Center for AI Safety, 30 mai 2023 (Hinton, Bengio, Altman, Amodei, Hassabis…) :
       https://aistatement.com/
       https://www.nytimes.com/2023/05/30/technology/ai-threat-warning.html
       « Mitigating the risk of extinction from AI should be a global priority alongside other
       societal-scale risks such as pandemics and nuclear war. »
     Grace et al., Thousands of AI Authors on the Future of AI, arXiv:2401.02843 (prépublication, v3 2025) :
       https://arxiv.org/abs/2401.02843
       2 778 répondant.e.s, automne 2023, taux de réponse de 15 %.
       « The median prediction for extremely bad outcomes, such as human extinction, was 5% (mean 9%). »
     International AI Safety Report, 29 janvier 2025 (96 experts, présidé par Yoshua Bengio) :
       https://internationalaisafetyreport.org/publication/international-ai-safety-report-2025
       « expert opinion on the likelihood of loss of control within the next several years varies greatly »
     International AI Safety Report 2026, 3 février 2026 (plus de 100 experts, plus de 30 pays et organisations) :
       https://internationalaisafetyreport.org/publication/international-ai-safety-report-2026
     Yann LeCun, alors à Meta, Wall Street Journal, octobre 2024 (« complete B.S. »), relayé par :
       https://www.techspot.com/news/105123-meta-ai-chief-yann-lecun-calls-ai-apocalypse.html */
  {
    cle: 'existentiel',
    titre: 'Un risque d’extinction ?',
    grand: { nombre: '5 %', legende: 'Médiane des chercheur.e.s : issue « extrêmement mauvaise »' },
    frise: [
      { date: '2023-05', texte: 'Hinton, Bengio, des PDG : réduire le risque d’extinction, priorité mondiale' },
      { date: '2024-01', texte: 'Sondage de 2 778 chercheur.e.s en IA, taux de réponse de 15 %' },
      { date: '2025-01', texte: 'Rapport présidé par Yoshua Bengio (Mila) : les avis divergent' },
      { date: '2026-02', texte: '2e rapport : plus de 100 expert.e.s, plus de 30 pays et organisations' }
    ],
    debat: 'Yann LeCun, alors chez Meta (2024) : ces craintes, c’est de la « foutaise »',
    sources: [
      'Center for AI Safety, déclaration du 30 mai 2023',
      'Grace et collab., arXiv 2401.02843 (prépublication)',
      'International AI Safety Report, 2025 et 2026',
      'Wall Street Journal, octobre 2024 (entrevue de Yann LeCun)'
    ]
  },

  /* Militaire.
     Résolution A/RES/80/57 de l’Assemblée générale, 1er décembre 2025 : 164 pour, 6 contre, 7 abstentions
     (contre : Bélarus, Burundi, Corée du Nord, Israël, Russie, États-Unis). Résolution non contraignante.
       https://digitallibrary.un.org/record/4095989
       https://un-project.org/votes/resolution/A-RES-80-57/
     +972 Magazine et Local Call, Yuval Abraham, 3 avril 2024 (six officiers du renseignement) :
       https://www.972mag.com/lavender-ai-israeli-army-gaza/
       « as many as 37,000 Palestinians as suspected militants ». Réponse de Tsahal dans le même article :
       outils « auxiliaires », examen indépendant par un analyste requis.
       https://siliconangle.com/2024/04/03/idf-denies-uses-ai-software-target-individuals-gaza-bombing-campaigns/
     Google, 4 février 2025 (Manyika et Hassabis) :
       https://blog.google/technology/ai/responsible-ai-2024-report-ongoing-work/
       https://www.dawn.com/news/1889887
     Pentagone (CDAO), 14 juillet 2025 : Anthropic, Google, OpenAI, xAI, plafond de 200 M$ US chacun :
       https://www.ai.mil/Latest/News-Press/PR-View/Article/4242822/cdao-announces-partnerships-with-frontier-ai-companies-to-address-national-secu/
       https://defensescoop.com/2025/07/14/pentagon-ai-contracts-musk-xai-google-openai-anthropic-cdao/
     Anthropic et le Pentagone, février-mars 2026 :
       https://www.anthropic.com/news/statement-department-of-war (26 février 2026)
       https://www.cbsnews.com/news/anthropic-ruling-judge-trump-pentagon-ai (injonction, 26 mars 2026)
     Ukraine (non retenu sur la diapo) : Reuters, 31 octobre 2024, « dozens of AI systems » :
       https://www.reuters.com/world/europe/ukraine-rolls-out-dozens-ai-systems-help-its-drones-hit-targets-2024-10-31/ */
  {
    cle: 'militaire',
    titre: 'L’IA à la guerre',
    grand: { nombre: '164 contre 6', legende: 'ONU, armes autonomes, déc. 2025 (non contraignant)' },
    frise: [
      { date: '2024-04', texte: 'Selon +972, « Lavender » a marqué jusqu’à 37 000 suspects à Gaza' },
      { date: '2025-02', texte: 'Google retire sa promesse de ne pas utiliser son IA pour des armes' },
      { date: '2025-07', texte: 'Pentagone : jusqu’à 200 M$ US chacun à 4 entreprises d’IA' },
      { date: '2026-02', texte: 'Anthropic refuse armes autonomes et surveillance de masse, puis sanctionnée' }
    ],
    debat: 'Tsahal : Lavender est un outil d’appoint, un analyste vérifie chaque cible',
    sources: [
      'ONU, résolution A/RES/80/57, 1er décembre 2025',
      '+972 Magazine et Local Call, 3 avril 2024',
      'Google, billet du 4 février 2025',
      'Pentagone (CDAO), 14 juillet 2025',
      'Anthropic, 26 février 2026 et CBS News, 26 mars 2026'
    ]
  },

  /* Surveillance de masse.
     Commissariats à la vie privée du Canada, du Québec (CAI), de la C.-B. et de l’Alberta, 3 février 2021 :
       https://www.priv.gc.ca/en/opc-news/news-and-announcements/2021/nr-c_210203/
       « Clearview AI's scraping of billions of images of people from across the Internet represented
       mass surveillance », « more than 3 billion images », « The RCMP became a paying customer. »
     GRC, rapport spécial au Parlement, 10 juin 2021 (Loi sur la protection des renseignements personnels) :
       https://www.priv.gc.ca/en/opc-news/speeches-and-statements/2021/s-d_20210610/
     Cadillac Fairview, 29 octobre 2020 : « 5 million images », « 12 shopping malls across Canada » :
       https://www.priv.gc.ca/en/opc-news/news-and-announcements/2020/nr-c_201029/
     Human Rights Watch, China’s Algorithms of Repression, 1er mai 2019 :
       https://www.hrw.org/report/2019/05/01/chinas-algorithms-repression/reverse-engineering-xinjiang-police-mass-surveillance
       « Our findings suggest the IJOP system surveils and collects data on everyone in Xinjiang. »
     Règlement (UE) 2024/1689 sur l’IA, art. 5 et 113 : en vigueur le 1er août 2024, interdictions
     applicables le 2 février 2025 (exceptions policières à l’art. 5(1)(h)) :
       https://eur-lex.europa.eu/eli/reg/2024/1689/oj
       https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai */
  {
    cle: 'surveillance',
    titre: 'La surveillance de masse',
    grand: { nombre: '3 milliards', legende: 'de photos et plus, aspirées par Clearview AI (2021)' },
    frise: [
      { date: '2019-05', texte: 'Human Rights Watch : l’appli policière du Xinjiang vise tout le monde' },
      { date: '2020-10', texte: 'Canada : 5 millions d’images de clients captées dans 12 centres commerciaux' },
      { date: '2021-02', texte: 'Commissaires (dont Québec) : Clearview AI fait de la surveillance de masse' },
      { date: '2025-02', texte: 'UE : notation sociale et moissonnage de visages interdits' }
    ],
    debat: 'Mais l’UE permet à la police l’identification en direct pour retrouver une victime ou contrer une menace',
    sources: [
      'Commissaires à la vie privée (Canada, Québec, C.-B., Alberta), 3 février 2021',
      'Commissaires à la vie privée (Canada, C.-B., Alberta), 29 octobre 2020',
      'Human Rights Watch, 1er mai 2019',
      'Règlement (UE) 2024/1689, art. 5 et 113'
    ]
  }
];
