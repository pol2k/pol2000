# Fact-check : séance 9, diapos 51 (pol-yfy) et 52 (pol-eaw)

Vérifié le 5 novembre 2026. Module audité : `deck/src/lib/data/ia_environnement.js` (non modifié).
Tous les accès aux sources datent du **5 novembre 2026**.

Grades :
- **A** : source primaire vérifiée deux fois (deux passages ou documents primaires distincts, ou primaire + seconde source indépendante).
- **B** : source primaire vérifiée une fois.
- **C** : source secondaire seulement.

Les valeurs **[DÉRIVÉ]** sont des conversions ou des mises à l'échelle que j'ai calculées, pas des valeurs publiées.
Facteurs de conversion : 1 gal = 3,785411784 L ; 1 acre-pied = 1 233,48 m³.

---

## 0. Erreurs bloquantes dans le module actuel

1. **Le golf est compté deux fois avec l'irrigation USGS 2015.** USGS PP 1894-D, p. 41 : « In the 2015 and previous USGS water-use reports, irrigation water use included water used for crops and recreational land including golf courses. »
   - Correctif : utiliser l'irrigation **des cultures** de l'année hydrologique 2020 (PP 1894-D). Elle exclut le golf.
2. **Pour le golf, c'est de l'eau appliquée, pas consommée.** La GCSAA publie de l'« applied water ». Le panneau parle d'eau « consommée ».
3. **Les chiffres LBNL en gallons ne sont pas ceux du rapport.** Le LBNL écrit **66 milliards de litres** (consommation directe, 2023) et « **nearly 800 billion liters** » (indirecte).
   - Les 17,4 et 211 milliards de gallons sont des conversions faites par des sources secondaires.
4. **Bitcoin : la source et l'année sont fausses.** Le chiffre de 138 TWh ne vient pas du CBECI et ne date pas de 2025.
   - Il vient du *Cambridge Digital Mining Industry Report* (avril 2025) : 138,2 TWh **en rythme annualisé au 30 juin 2024**, estimé par enquête. Le CBECI donnait 137,4 TWh à la même date.
5. **Aluminium : aucune source primaire n'a pu être obtenue.** L'IAI et l'AIE n'étaient pas accessibles, et la presse spécialisée se contredit (plus de 900 TWh contre plus de 1 100 TWh).
6. **Climatisation : le « 7 % » est une cible de l'AIE pour 2030, pas une valeur de 2022.** La page AIE « Space cooling » (26 sept. 2023) donne la part de la climatisation dans l'électricité finale : 9 % en 2022 et 7 % en 2030, dans le scénario net zéro. Le commentaire AIE de 2026 parle d'environ 10 %. Le « ~2 100 TWh en 2022 » est exact (2 111 TWh dans les données AIE diffusées par OWID).
7. **Le commentaire d'en-tête du module est périmé** (« ni le LBNL ni l'AIE ne donnent la part de l'IA »).
   - L'AIE (2026) projette **environ 465 TWh pour les centres de données « axés sur l'IA » en 2030**.
   - La mise à jour LBNL 2025 projette que les serveurs d'IA représenteront **55 % de l'énergie des centres de données américains en 2030**.
   - Ce sont des projections ; pour l'historique, seul le chiffre de 2025 lu dans un graphique (155 TWh, OWID) existe, de grade C.
8. **Diapo 52 : « YouTube » est faux.** La valeur de l'AIE est une moyenne Netflix. Le reel s'appuie sur le scénario C de l'AIE, **en wifi**, et le libellé doit le dire.

---

## 1. Diapo 51 (a) : eau consommée aux États-Unis

### 1.1 Irrigation et centrales thermiques, USGS 2015 (valeurs actuelles du module)

- **Valeurs** : irrigation **73,2 Bgal/d** ; thermoélectrique **4,31 Bgal/d** (consommation).
- **Conversion [DÉRIVÉ]** : 277,1 et 16,3 milliards de litres par jour (GL/j).
- **Année et territoire** : 2015, 50 États + DC + PR + VI.
- **Ce que ça inclut** : l'irrigation inclut les terrains de golf et les espaces récréatifs. Le thermoélectrique couvre la consommation totale de toutes les sources d'eau.
- **Citation** (Circular 1441, résumé) : « Total consumptive use for thermoelectric power was 4.31 Bgal/d in 2015 » ; « Total consumptive use for irrigation was 73.2 Bgal/d in 2015 or 62 percent of the total use ».
- **Source primaire** : https://pubs.usgs.gov/circ/1441/circ1441.pdf (Dieter et al., 2018)
- **Seconde vérification** : relecture du même PDF, tableau de l'irrigation par État (ligne TOTAL : 73 200 Mgal/d de consommation) et chapitre thermoélectrique (« 4,310 Mgal/d, about 3 percent of total thermoelectric-power … »). Voir aussi https://pubs.usgs.gov/publication/cir1441.
- **Grade** : A.
- **Statut** : **remplacé**. Ce n'est plus la dernière année disponible, et il y a un double compte avec le golf.

### 1.2 Irrigation des cultures, année hydrologique 2020 (USGS, modèle), RECOMMANDÉ

- **Valeur** : **78 400 Mgal/d** de consommation. Le prélèvement est de 108 723 Mgal/d.
- **Conversion [DÉRIVÉ]** : environ 297 GL/j, soit environ 108 000 GL/an.
- **Année et territoire** : année hydrologique 2020 (oct. 2019 à sept. 2020), **États-Unis contigus seulement**.
- **Ce que ça inclut** : les cultures seulement. Le golf est exclu, et l'estimation vient d'un modèle.
- **Citation** : « Model estimates for water withdrawals and consumptive use for crop irrigation for the CONUS in water year 2020 were 108,723 and 78,400 Mgal/d »
- **Source primaire** : USGS Professional Paper 1894-D (2025), *Water Use Across the Conterminous United States, Water Years 2010–20*. https://pubs.usgs.gov/pp/1894/d/pp1894D.pdf ; page de notice : https://pubs.usgs.gov/publication/pp1894D
- **Seconde vérification** :
  - Relecture du même PDF : moyenne 2010–2020 de 75 698 Mgal/d (résumé et tableau 1), cohérente.
  - La page https://www.usgs.gov/water-use n'a pas confirmé ce chiffre à la lecture. La seconde vérification repose donc sur la relecture du PDF.
- **Grade** : A.

### 1.3 Centrales thermoélectriques, année hydrologique 2020 (USGS, modèle), RECOMMANDÉ

- **Valeur** : **2 382 Mgal/d** de consommation.
- **Conversion [DÉRIVÉ]** : environ 9,0 GL/j.
- **Année et territoire** : 2020, États-Unis contigus.
- **Ce que ça inclut** : eau surtout douce. La consommation n'est pas estimée pour les centrales refroidies à l'eau salée, et l'hydroélectricité est exclue.
- **Citation** : « Consumptive use for thermoelectric power, overwhelmingly fresh water, was 2,382 Mgal/d in 2020 and 2,904 Mgal/d averaged over water years 2010–20 for the CONUS »
- **Source primaire** : PP 1894-D, même URL.
- **Seconde vérification** :
  - Relecture du PDF, tableau 3 (moyenne 2010–2020 : 2 904).
  - Relecture du PDF, texte du chapitre : « 2,904 Mgal/d … or 4 percent of thermoelectric freshwater withdrawals ».
- **Grade** : A.
- **Note** : ne pas mélanger 2015 (Circular 1441, compilation par États) et 2020 (modèle). Les méthodes et les périmètres diffèrent.

### 1.4 Terrains de golf (GCSAA)

- **Valeur** : **1,63 million d'acres-pieds** d'eau **appliquée** en 2024.
- **Conversion [DÉRIVÉ]** : environ 2 010 GL/an, soit 5,5 GL/j.
- **Année et territoire** : 2024, États-Unis. Projection nationale tirée d'environ 1 700 installations.
- **Ce que ça inclut** : toute l'eau d'arrosage, y compris l'eau recyclée (environ 19 %). **Ce n'est pas une consommation.**
- **Citation** : « applied a projected 1.63 million acre-feet of water in 2024, representing a 3.2% reduction since 2020 and a 31% reduction since 2005 »
- **Source primaire** : https://www.gcsaa.org/who-we-are/media/news-release/2025/12/30/golf-courses-reduce-water-usage-by-31-percent-according-to-national-survey (30 déc. 2025)
- **Article évalué par les pairs** : Shaddox et al., *HortTechnology* 35(5):848–857 (2025). Non consulté (accès refusé, 403).
- **Seconde vérification** :
  - https://www.gcmonline.com/research/news/from-acre-feet-to-outcomes-interpreting-the-2024-gcep-water-survey : méthode, n = 1 766, « 3% fewer acre-feet in 2024 than reported in 2020 ».
  - TurfNet, 5 janv. 2026 (page lue) : « U.S. golf facilities used 1.63 million acre-feet of water in 2024 », https://turfnet.com/news/survey-says-water-use-is-down-by-30-percent-plus-since-2005/
- **Grade** : A pour le chiffre, mais c'est de l'eau appliquée.
- **Mise en garde** : un site de vérification évoque 1,69 Macre-pied dans *HortTechnology*. Ce n'est pas vérifié ; la GCSAA dit 1,63.
- **Recommandation** :
  - Soit libeller « Golf (eau d'arrosage) » et marquer la barre d'un astérisque.
  - Soit retirer le golf du panneau « consommée ».
  - Ne pas appliquer de facteur de consommation (le 80 % qui circule vient d'un site de vérification, pas d'une source).

### 1.5 Centres de données, consommation directe sur place (LBNL), RECOMMANDÉ (en litres)

- **Valeur** : **66 milliards de litres** en 2023.
- **Conversion [DÉRIVÉ]** : 66 milliards de litres = 17,4 milliards de gallons, soit environ 0,18 GL/j.
- **Année et territoire** : 2023, États-Unis.
- **Ce que ça inclut** : l'eau consommée sur place, surtout pour le refroidissement.
- **Citation** (p. 55) : « By 2023, hyperscale and colocation account for 84% of the 66-billion-liter total »
- **Source primaire** : Shehabi et al. (déc. 2024), *2024 United States Data Center Energy Usage Report*, LBNL-2001637.
  - Notice officielle : https://eta-publications.lbl.gov/publications/2024-united-states-data-center-energy
  - PDF lu sur un miroir tiers : https://legalectric.org/f/2025/09/lbnl-2024-united-states-data-center-energy-usage-report_1.pdf (le PDF du MIT renvoyait « Access Denied »).
- **Seconde vérification** :
  - Relecture du PDF p. 55 : en 2014, 21,2 milliards de litres ; projection 2028 pour les hyperscalers de 60 à 124 milliards de litres. Cohérent.
  - Non consulté, d'après un résumé de recherche : ITIF, https://itif.org/publications/the-data-center-water-problem-is-soluble (17,4 Bgal).
- **Grade** : A.
- **Données plus récentes ?** Non. La *mise à jour 2025* du LBNL (publiée le 18 juin 2026, DOI 10.71468/P1RP4F, https://escholarship.org/uc/item/33m6w3x0) **ne contient aucune estimation d'eau**. Le mot « water » n'y apparaît que deux fois, en passant. **2023 reste la dernière année d'eau publiée par le LBNL.**

### 1.6 Centres de données, eau indirecte liée à l'électricité (LBNL)

- **Valeur** : « **nearly 800 billion liters** », 2023, États-Unis.
- **Calcul sous-jacent** : 176 TWh × 4,52 L/kWh ≈ 795 milliards de litres [DÉRIVÉ, vérification de cohérence]. 800 milliards de litres ≈ 211 milliards de gallons [DÉRIVÉ].
- **Citation** (p. 57) : « The total indirect water footprint of U.S. data centers is nearly 800 billion liters, attributed to water consumed indirectly through electricity use ».
  - Sur ce qui est compté (p. 56) : « Thermoelectric plants require significant cooling, while hydroelectric reservoirs lose water through open surface evaporation ».
- **Ce que ça inclut** :
  - **l'évaporation des réservoirs hydroélectriques** ;
  - la consommation des centrales selon le mix de chaque autorité d'équilibrage.
  - Ce que ça exclut : les contrats d'achat d'électricité (PPA) et la production derrière le compteur.
- **Seconde vérification** : relecture p. 57 (4,52 L/kWh ; la moyenne américaine est de 4,35 L/kWh). Cohérence interne : 176 TWh × 4,52 L/kWh ≈ 795 milliards de litres. Latitude Media (non consulté, d'après un résumé de recherche) parle de « 12 times » la consommation directe, ce qui est cohérent avec 800/66.
- **Grade** : A pour le chiffre publié.
- **Mises en garde obligatoires** :
  - Cette barre **chevauche** celle des centrales thermiques. Les deux ne s'additionnent pas.
  - Le total inclut l'hydroélectricité, que l'USGS exclut.
  - Il repose sur 176 TWh pour 2023. **La mise à jour LBNL 2025 a révisé à la baisse l'électricité des années passées** (« revised estimates of electricity use in prior years falling slightly below 2024 Report estimates ») : 192 TWh en 2024, +14 % par rapport à 2023. L'eau indirecte de 2023 est donc probablement un peu surestimée. Ne pas recalculer.

---

## 2. Diapo 51 (b) : électricité consommée dans le monde (TWh/an)

### 2.1 Centres de données (AIE)

**2024 : 415 TWh**
- **Citation** : « Data centres accounted for around 1.5% of the world's electricity consumption in 2024, or 415 terawatt-hours (TWh). »
- **Source** : https://www.iea.org/reports/energy-and-ai/executive-summary (avril 2025)
- **Seconde vérification** : AIE, *Key Questions on Energy and AI* (2026), PDF, chapitre 1 : « around 415 TWh in 2024 » ; tableau A.4 : 416.
- **Grade** : A.

**2025 : 485 TWh (RECOMMANDÉ, dernière année)**
- **Citation** : « electricity consumption from data centres roughly doubling from 485 TWh in 2025 to 950 TWh in 2030 ».
- **Source** : https://www.iea.org/reports/key-questions-on-energy-and-ai/executive-summary ; PDF : https://iea.blob.core.windows.net/assets/3179f7f8-01f6-4dd6-bffa-c9f7b73f1dc9/KeyQuestionsonEnergyandAI.pdf
- **Seconde vérification** :
  - Tableau A.4 du PDF (Monde : 360 / 416 / 485 / 945 pour 2023 / 2024 / 2025 / 2030).
  - OWID (Hannah Ritchie, 20 juil. 2026) : https://ourworldindata.org/how-much-energy-do-data-centers-and-artificial-intelligence-use
- **Grade** : A.
- **Note** : le texte de l'AIE dit aussi « almost 500 TWh, or slightly more than 1.5% ».

**2030 : 945 TWh**
- Tableau A.4 et rapport 2025 : 945. Le résumé de 2026 arrondit à 950.
- Le communiqué AIE du 10 avril 2025 ajoute : « slightly more than the entire electricity consumption of Japan today ».
- **Grade** : A.

**Périmètre** :
- **Exclut les cryptomonnaies.** OWID : « IEA … (excludes crypto mining) » ; la série Energy Institute/S&P qui les inclut atteint environ 790 TWh en 2025. La barre Bitcoin n'est donc pas un double compte.
- Couvre **tous les usages**, pas seulement l'IA.

**Part de l'IA** :
- « AI-focused data centres » : environ **465 TWh en 2030** (KQ, p. 25, texte). **Grade B.**
- 155 TWh en 2025 (OWID, lu sur un graphique de l'AIE, absent du texte et des tableaux). **Grade C.**

### 2.2 Climatisation (AIE)

**2022 : 2 111 TWh (RECOMMANDÉ)**
- **Source** : série AIE « Buildings », diffusée par OWID, CSV téléchargé : https://ourworldindata.org/grapher/electricity-air-conditioning
- **Ce que ça inclut** : « Electricity use for "space cooling", which includes fans but is mostly air conditioning ».
- **Grade** : C, au sens strict (la donnée primaire de l'AIE n'a pas été consultée directement).

**Estimation AIE la plus récente : ~2 900 TWh**
- **Citation** : « Global electricity demand for space cooling has grown by 50% since 2015, rising to around 2 900 terawatt-hours ».
- **Source** : https://www.iea.org/commentaries/cooling-a-hotter-world-el-nino-meets-strong-growth-in-global-electricity-demand (10 juil. 2026). Exclut les centres de données (note 1).
- **Grade** : B, mais **l'année n'est pas indiquée**.
- **Incompatible avec la série OWID** : 1 611 TWh en 2015 × 1,5 = environ 2 420, pas 2 900. Il s'agit d'une série révisée ou différente.
- **Ne jamais placer les deux chiffres côte à côte.**

**Recommandation** :
- Afficher 2 111 TWh (2022).
- Mentionner l'AIE 2026 (~2 900 TWh) seulement dans la note.
- **Supprimer « 7 % »**. C'est le jalon de 2030 du scénario net zéro. Pour 2022, l'AIE donne 9 % : « Share of space cooling in final electricity consumption | 9% | 7% | 6% | 5% » (2022 / 2030 / 2035 / 2050), https://www.iea.org/reports/space-cooling-2, page lue.

### 2.3 Aluminium : RETIRER

- **Ce qui a été tenté** :
  - Les pages statistiques de l'IAI sont générées en JavaScript, et l'API de l'IAI n'a pas été utilisée.
  - Le graphique de l'AIE (2010 et 2021) n'est pas téléchargeable.
  - Le WEF (« around 4% of global power consumption ») a renvoyé 403.
  - AlCircle (presse spécialisée) donne « well over 900 TWh » dans un article et « more than 1,100 TWh » dans un autre.
- **Grade** : C, contradictoire. **Ne pas afficher.**
- **Remplacement possible (vérifié)** : **Québec, 184,9 TWh (2025)**.
  - Citation : « Les ventes d'électricité au Québec ont atteint un sommet de 184,9 TWh, en hausse de 7,7 TWh par rapport à 2024 ».
  - Source : Hydro-Québec, *Rapport annuel 2025*, https://pannes.hydroquebec.com/data/documents-donnees/pdf/hq-rapport-annuel-2025-francais.pdf
  - Seconde vérification : présentation des résultats du 26 févr. 2026, https://pannes.hydroquebec.com/data/documents-donnees/pdf/26-02-2026-presentation-rapport-annuel-2025-vf.pdf
  - **Grade** : A.
  - Mise en garde : il s'agit des **ventes** d'Hydro-Québec au Québec, pas de la consommation totale de la province.

### 2.4 Bitcoin (Cambridge)

**138,2 TWh (rythme annualisé au 30 juin 2024)**
- **Citation** (rapport, section « Electricity Consumption ») : « the annualised electricity consumption of the Bitcoin network is estimated at 138.2 TWh as of 30 June 2024 … approximately 0.54% of the world's total annual electricity consumption … close alignment with the CBECI model (137.4 TWh) ».
- **Source** : *Cambridge Digital Mining Industry Report* (CCAF, avril 2025), https://www.jbs.cam.ac.uk/wp-content/uploads/2025/04/2025-04-cambridge-digital-mining-industry-report.pdf
- **Seconde vérification** : communiqué JBS du 28 avril 2025, https://jbs.cam.ac.uk/2025/cambridge-study-sustainable-energy-rising-in-bitcoin-mining/ (« 138 TWh … about 0.5% »).
- **Grade** : A.

**183 TWh (rythme au 31 déc. 2024, modèle CBECI)**
- **Citation** : « By the end of December 2024 … electricity consumption rose to 183 TWh ».
- **Source** : même PDF.
- **Grade** : B.

**~190 TWh (rythme en décembre 2025)**
- Chiffre préliminaire de la 2e édition, présenté en juillet 2026 et rapporté par la presse seulement : https://www.theenergymag.com/news/market-news/bitcoin-energy-consumption-mix-cambridge-eif
- **Grade** : C.

**Ce qu'il faut savoir** :
- Ce sont des **rythmes annualisés à une date donnée**, pas des totaux d'une année civile.
- Le CBECI en direct (https://ccaf.io/cbnsi/cbeci) nécessite JavaScript et n'a pas pu être lu.
- **Recommandation (règle de la dernière année)** : afficher **183 TWh, « fin 2024 »**. C'est la valeur publiée la plus récente dans une source primaire.
  - Note : 138 TWh à la mi-2024, où deux méthodes concordent (enquête 138,2, CBECI 137,4) ; environ 190 TWh en décembre 2025, chiffre préliminaire.
  - Si l'on préfère la valeur la plus robuste plutôt que la plus récente, garder 138 « mi-2024 ». **Ne pas l'afficher à côté du Québec** (voir § 4 bis).

---

## 3. Diapo 52 : électricité par usage numérique (Wh)

### 3.1 Valeurs publiées par les entreprises (centre de données seulement)

**Gemini, requête texte médiane : 0,24 Wh**
- **Source** : Elsworth et al. (Google), arXiv 2508.15734, 21 août 2025, https://arxiv.org/abs/2508.15734
- **Citation** : « the median Gemini Apps text prompt consumes 0.24 Wh of energy ».
- **Ce que ça inclut** : « active AI accelerator power, host system energy, idle machine capacity, and data center energy overhead ».
- **Ce que ça exclut** : le résumé ne mentionne ni le réseau, ni l'appareil de l'utilisateur, ni l'entraînement. Ces éléments sont donc hors périmètre, selon ma lecture du résumé ; l'article complet n'a pas été lu.
- **Seconde vérification** : AIE KQ 2026, encadré 2.1 (« Google reports that the median Gemini text prompt consumes 0.24 Wh »).
- **Grade** : A.

**ChatGPT, requête moyenne : 0,34 Wh**
- **Source** : Altman, « The Gentle Singularity », https://blog.samaltman.com/the-gentle-singularity. La page n'affiche pas de date. L'AIE le cite comme « Altman (2025) », et la presse le date du 10 juin 2025 (Benzinga, Simon Willison ; non consultés directement).
- **Citation** : « the average query uses about 0.34 watt-hours ».
- **Méthode** : **aucune publiée**. Le périmètre est inconnu.
- **Seconde vérification** : AIE KQ 2026, encadré 2.1 (« OpenAI puts the average ChatGPT query at 0.34 Wh (Altman, 2025) »).
- **Grade** : A pour l'attribution ; la méthode est invérifiable.

### 3.2 Estimations externes des grands modèles fermés ou de taille « frontière »

**Epoch AI (indépendant) : environ 0,3 Wh par requête GPT-4o typique**
- **Source** : J. You, 7 févr. 2025, https://epoch.ai/gradient-updates/how-much-energy-does-chatgpt-use
- **Citation** : « typical ChatGPT queries using GPT-4o likely consume roughly 0.3 watt-hours ».
- **Ce que ça inclut** : le GPU, plus les frais généraux du serveur et du centre de données (10 à 20 %).
- **Grade** : B.

**Microsoft Research (Oviedo et al.)**
- **Source** : arXiv 2509.20241 **v2, 9 juin 2026**, https://arxiv.org/abs/2509.20241
- **Citations** :
  - « median energy of 0.31 Wh/query » (intervalle interquartile 0,16–0,60) pour les modèles de plus de 200 milliards de paramètres sur H100 ;
  - « test-time scaling scenarios 15x longer … 3.91 Wh ».
- **Version 1** (sept. 2025) : 0,34 Wh et 4,32 Wh. **L'AIE cite la v1 (0,34)**. La coïncidence avec les 0,34 Wh d'Altman ne veut rien dire.
- **Le même article** affirme que des montages expérimentaux hors production surestiment l'énergie de **4 à 20 fois**.
- **Grade** : B. **Ce n'est pas une source indépendante** de l'industrie : Microsoft exploite des services d'IA.

**Hugging Face, AI Energy Score v2** (4 déc. 2025), https://huggingface.co/blog/sasha/ai-energy-score-v2
- Énergie du GPU seulement : DeepSeek-R1-Distill-Llama-70B, 49,53 Wh pour 1 000 requêtes sans raisonnement, contre **7 626,53 Wh pour 1 000 requêtes avec raisonnement** (« 154x »). Cela donne 0,05 Wh contre 7,6 Wh par requête [DÉRIVÉ].
- **Grade** : B.

### 3.3 Mesures de laboratoire sur modèles ouverts (MIT Technology Review)

- **Source** : O'Donnell et Crownhart, 20 mai 2025, https://www.technologyreview.com/2025/05/20/1116327/ai-energy-usage-climate-footprint-big-tech/
- **Qui a mesuré** :
  - Jae-Won Chung (ML.Energy, U. Michigan) pour le texte et l'image ;
  - Sasha Luccioni (Hugging Face, Code Carbon) pour la vidéo.

| Usage | Valeur publiée | Wh [DÉRIVÉ] |
|---|---|---|
| Llama 3.1 8B | « about 57 joules per response, or an estimated 114 joules » | 0,032 |
| Llama 3.1 405B | « 3,353 joules, or an estimated 6,706 joules total » | 1,86 |
| SD3 Medium | « about 1,141 joules of GPU energy … an estimated 2,282 joules total » | 0,63 |
| CogVideoX, 5 s | « about 3.4 million joules » | 944 |

- **Méthode** :
  - Texte et image : énergie du GPU **× 2**, selon une règle empirique tirée d'un article de Microsoft.
  - Vidéo : mesurée avec Code Carbon. **L'article ne dit pas si le chiffre a été doublé**, donc ce n'est pas la même méthode.
- **Grade** : B pour les quatre (article lu deux fois ; les données brutes de ML.Energy ne sont pas consultées).
- **Pourquoi « Réponse texte, gros modèle » est trompeur** : le 405B (1,86 Wh) apparaît **au-dessus** de ChatGPT et de Gemini. C'est un artefact du montage : un banc d'essai, une petite taille de lot et la règle du ×2. Oviedo et al. disent que ces montages surestiment de 4 à 20 fois. **Retirer les deux barres Llama.**

### 3.4 Vidéo en ligne (appareil + réseau + centre de données)

**AIE (Kamiya, 10 déc. 2020) : 0,077 kWh/h, 0,037 kWh/h et répartition 72/23/5**
- **Source** : https://www.iea.org/commentaries/the-carbon-footprint-of-streaming-video-fact-checking-the-headlines
- **Citations** :
  - « streaming a Netflix video in 2019 typically consumed around 0.077 kWh of electricity per hour » ;
  - « Streaming an hour-long SD video through a phone on WiFi (Scenario C) uses just 0.037 kWh » ;
  - répartition : appareils 72 %, transmission 23 %, centres de données 5 %.
  - Pour les téléphones, la transmission compte pour plus de 80 %.
- **Seconde vérification** : Carbon Brief, page lue (mise à jour du 25 nov. 2020), https://www.carbonbrief.org/factcheck-what-is-the-carbon-footprint-of-streaming-video-on-netflix. Elle confirme 0,077 kWh et 72/23/5, mais **pas** les 0,037 kWh du téléphone.
- **Grade** : A pour 0,077 et la répartition ; **B** pour 0,037 (téléphone).
- **Valeurs dérivées [DÉRIVÉ]** : reel de 30 s en wifi = 37/120 = **0,31 Wh** ; vidéo de 10 min = 77/6 = **12,8 Wh** ; film de 2 h = **154 Wh**.

**Carbon Trust (juin 2021, financé en partie par Netflix) : 188 Wh/h, Europe 2020**
- **Source** : https://ctprodstorageaccountp.blob.core.windows.net/prod-drupal-files/documents/resource/public/Carbon-impact-of-video-streaming.pdf, pp. 48–49.
- **Citation** : « The equivalent energy consumption is a European average of 188Wh per hour of video streaming ».
- **Répartition** :
  - centres de données « approximately 1Wh/hour » (environ 1 %) ;
  - réseau 20 Wh/h ;
  - routeur domestique 71 Wh/h ;
  - appareils 96 Wh/h.
- **Grade** : B.
- **Pourquoi c'est 2,4 fois l'AIE** : le Carbon Trust compte le routeur domestique, et son parc d'appareils comprend beaucoup de téléviseurs.

**Rien de plus récent et validé n'a été trouvé.**
- Netflix ne publie pas de Wh par heure.
- TRG Datacenters (0,12 kWh/h, 2025) n'est pas évalué par les pairs : à ne pas utiliser.
- **Garder l'AIE (2019, mondial).**

**Comparaison équitable** : la part « centre de données seulement » d'une heure de vidéo est d'environ **1 Wh** (Carbon Trust) ou environ **5 %** de 77 Wh (AIE), soit **environ 3,9 Wh [DÉRIVÉ]**. C'est **cela** qui se compare aux chiffres de l'IA, pas les 77 Wh.

---

## 4. JEUX DE DONNÉES RECOMMANDÉS

### Diapo 51 (a) : eau consommée aux États-Unis

Unité suggérée : milliards de litres par an. L'échelle logarithmique ou un zoom est inévitable.

| Libellé (FR, ≤ 5 mots) | Valeur | Année | Source | Grade |
|---|---|---|---|---|
| Irrigation des cultures | ≈ 108 000 G L/an [DÉRIVÉ de 78 400 Mgal/j] | 2020 | USGS PP 1894-D | A |
| Centrales thermiques | ≈ 3 300 G L/an [DÉRIVÉ de 2 382 Mgal/j] | 2020 | USGS PP 1894-D | A |
| Golf (eau d'arrosage)* | ≈ 2 010 G L/an [DÉRIVÉ de 1,63 Macre-pied] | 2024 | GCSAA | A (appliquée) |
| Centres de données : électricité† | ≈ 800 G L/an | 2023 | LBNL 2024 | A |
| Centres de données : sur place | 66 G L/an | 2023 | LBNL 2024 | A |

*Eau appliquée, pas consommée. On peut aussi retirer la barre.
†Inclut l'évaporation des barrages ; chevauche la barre des centrales thermiques.

*(La mise en garde commune aux deux panneaux est sous le tableau (b).)*

### Diapo 51 (b) : électricité dans le monde (TWh/an)

| Libellé | Valeur | Année | Source | Grade |
|---|---|---|---|---|
| Climatisation | 2 111 | 2022 | Données AIE via OWID | C (fidèle à l'AIE) |
| Centres de données | 485 | 2025 | AIE 2026 | A |
| Centres de données, prévision | 945 | 2030 | AIE | A |
| Bitcoin (fin 2024) | 183 | 31 déc. 2024 (annualisé) | Cambridge CCAF (modèle CBECI) | B |
| *Option* : Québec (Hydro-Québec) | 184,9 | 2025 | HQ, rapport annuel | A |

**Mise en garde unique pour la diapo 51 (≤ 2 lignes)** :
> Eau : États-Unis, 2020–2024 ; l'eau « par l'électricité » inclut les barrages et chevauche les centrales. Électricité : monde, 2022–2025.
> Centres de données : tous usages (pas seulement l'IA), hors cryptomonnaies ; Bitcoin : rythme annualisé.

### Diapo 52 : électricité par usage (Wh)

Deux familles de couleurs, ou deux panneaux, avec une légende qui dit ce que chaque famille compte.

**Famille IA : centre de données seulement**

| Libellé | Wh | Source | Grade |
|---|---|---|---|
| Requête Gemini (Google) | 0,24 | Google, arXiv 2508.15734 | A |
| Requête ChatGPT (OpenAI) | 0,34 | Altman 2025, méthode non publiée | A (attribution) |
| Requête, estimation indépendante | ≈ 0,3 | Epoch AI, févr. 2025 | B |
| Requête avec raisonnement long | 3,91 | Microsoft Research, v2, juin 2026 | B |
| Image IA (mesure labo) | 0,63 [DÉRIVÉ de 2 282 J] | MIT TR 2025 | B |
| Vidéo IA 5 s (labo) | 944 [DÉRIVÉ de 3,4 MJ] | MIT TR 2025 | B |

**Famille vidéo en ligne : écran + réseau + centre de données**

| Libellé | Wh | Source | Grade |
|---|---|---|---|
| Reel 30 s (téléphone, wifi) | 0,31 [DÉRIVÉ] | AIE 2020 (scénario C) | B |
| Vidéo en ligne, 10 min | 12,8 [DÉRIVÉ] | AIE 2020 (moyenne Netflix 2019) | A |
| Film de 2 h | 154 [DÉRIVÉ] | AIE 2020 | A |

**Mise en garde (≤ 2 lignes)** :
> IA : centre de données seulement ; vidéo : surtout l'écran et le réseau (centre de données ≈ 5 %). Chiffres d'entreprises non vérifiés ; image et vidéo IA : mesures de labo.

**Variante plus simple si la diapo est trop chargée** : Gemini, ChatGPT, raisonnement, image IA, vidéo IA 5 s, reel, film de 2 h (7 barres).

### 4 bis. Peut-on mélanger les années et les territoires ?

**Les années**
- Le mélange est défendable quand les barres diffèrent de plusieurs fois.
  - Climatisation (2022, 2 111 TWh) contre centres de données (2025, 485 TWh) : un rapport de plus de 4 fois. Une croissance de quelques années ne change pas la conclusion.
  - Irrigation contre centres de données : plus de 100 fois.
- Le mélange **n'est pas défendable** quand deux barres sont à moins d'environ 30 % l'une de l'autre.
  - Bitcoin 138 TWh (mi-2024) contre Québec 184,9 TWh (2025) se lirait « Bitcoin < Québec ».
  - Avec 183 TWh (fin 2024) ou environ 190 TWh (fin 2025), les deux sont à peu près égaux.
  - D'où le choix de 183 TWh si le Québec est affiché. Sinon, ne pas afficher le Québec.
- Les années doivent apparaître sur la diapo, par exemple en petit sous chaque barre.

**Les territoires**
- Ne pas mélanger dans un même panneau. Le panneau eau est entièrement américain ; le panneau électricité est mondial.
- L'exception est le Québec, une référence locale. Il faut alors l'étiqueter « Québec » explicitement.

**Les méthodes**
- USGS 2015 (compilation par États) et USGS 2020 (modèle) ne se mélangent pas. Utiliser 2020 seulement.
- Eau appliquée (golf) et eau consommée (le reste) ne se comparent qu'avec un astérisque.

---

## 5. À RETIRER

1. Aluminium : aucune source primaire, et les sources secondaires se contredisent.
2. Irrigation et centrales thermiques USGS **2015** : à remplacer par 2020, ce qui supprime aussi le double compte avec le golf.
3. Les gallons du LBNL (17,4 et 211 milliards) : citer les litres du rapport (66 et environ 800 milliards).
4. « 7 % » pour la climatisation.
5. « CBECI, 2025 » pour Bitcoin : remplacer par « Cambridge (CCAF), rythme annualisé au 31 déc. 2024 : 183 TWh » (ou 138 TWh au 30 juin 2024).
6. « Réponse texte, petit modèle » (Llama 3.1 8B) et « Réponse texte, gros modèle » (Llama 3.1 405B) : artefacts de banc d'essai. Si on les garde, il faut un libellé « modèle ouvert, mesure de labo ».
7. « (YouTube…) » dans le libellé de la vidéo de 10 min : la source est une moyenne Netflix.
8. Ne pas utiliser : TRG Datacenters (0,12 kWh/h), le « 531 milliards de gallons » pour le golf, et le chiffre de 190 TWh pour Bitcoin (presse seulement, grade C).

## 6. Points non résolus

- Données IAI sur l'aluminium (pages en JavaScript ; API non utilisée).
- Résumé de l'article *HortTechnology* sur le golf (403).
- Valeur en direct du CBECI (JavaScript).
- Année du chiffre de climatisation de l'AIE 2026 (~2 900 TWh).
- Part historique de l'IA dans l'électricité des centres de données : seulement 155 TWh pour 2025, lus par OWID sur un graphique.
