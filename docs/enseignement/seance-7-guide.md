# Séance 7 · La régression linéaire simple · guide de l'enseignant

Guide d'étude pour préparer la séance du jeudi 15 octobre 2026. Il suit le
deck `slides/seance-7/` section par section : ce qu'il faut dire, d'où vient
chaque chiffre, les questions probables et les pièges. Les formules sont
ici, jamais sur les diapos. Ce fichier est dans le dépôt public, mais il ne
contient rien de confidentiel.

Référence : Arel-Bundock (2021), *Analyse causale et méthodes
quantitatives*, chapitre 5 (la régression) et chapitre 4 (l'inférence).
Sa figure p. 84 est exactement l'exemple de la crème glacée, avec le nœud
« Température (ε) ».

---

## 0. Le dispositif et l'exemple fil rouge

- **La question** : « Le populisme mine-t-il la satisfaction envers la
  démocratie ? » Les deux questions viennent du sondage post-électoral de
  la CES 2025 (même vague), recodées de 0 à 1 comme toujours dans le cours.
- **X** = `populisme` (`pes25_populism_8`, codebook p. 341) : « La plupart
  des politiciens se soucient uniquement des intérêts des gens riches et
  puissants. » Fortement en désaccord 0 · plutôt en désaccord 0,25 · ni
  l'un ni l'autre 0,5 · plutôt en accord 0,75 · fortement en accord 1.
- **Y** = `satisfaction_dem` (`pes25_dem_sat`, p. 229) : pas du tout
  satisfait 0 · pas très 1/3 · plutôt 2/3 · très satisfait 1. Les codes
  du codebook vont à l'envers (1 = très satisfait) : on retourne.
- « Je ne sais pas / Préfère ne pas répondre » devient NA.
- **La population d'exercice** : les 20 180 répondant.e.s, comme à la
  séance 5. 10 993 ont répondu aux deux questions. **Constante 0,79, pente
  −0,31**, R² 0,09, r −0,30. Moyennes de Y selon X : 0,74 · 0,70 · 0,64 ·
  0,59 · 0,42 (la chute est la plus forte à la fin).
- **Notre sondage** : 1 000 personnes tirées parmi les 20 180 (graine 62).
  R garde **564** cas complets : **constante 0,83, pente −0,37, erreur type
  0,044, t = −8,40, p = 3,7 × 10⁻¹⁶, IC à 95 % de −0,46 à −0,28, R² 0,11**,
  erreur type résiduelle 0,29.
- **Lire la pente** : de « fortement en désaccord » à « fortement en
  accord » (X de 0 à 1, tout l'éventail), la satisfaction baisse de 0,37
  sur une échelle de 0 à 1, un peu plus d'une catégorie de satisfaction
  (1/3). Un échelon de populisme (0,25) : environ −0,09.
- Pourquoi cet exemple : la constante (0,83) est une valeur que Y peut
  prendre; la variable confondante (le vote libéral), le biais (les 18 à
  34 ans) et le N manquant sont réels, dans la CES.
- Tout vient de `deck/outils/seance7_data.R` (→ `seance7.js`), puis
  `seance7_b.R`, `seance7_d.R`, `seance7_e.R` (crème glacée, fictive),
  `seance7_f.R`, `seance7_g.R`. Depuis `deck/` :
  `CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R`, puis les
  autres (`_b`, `_d`, `_f` et `_g` vérifient leurs tirages contre
  `seance7.js` et s'arrêtent s'ils divergent).
- Le deck traite des échelles ordinales recodées de 0 à 1 comme des
  nombres. C'est la pratique courante, mais à dire à voix haute si on
  demande.

## 1. L'examen 1

La diapo montre le poids, la date de remise et les deux auxiliaires qui
corrigent. On dit où en est la correction.

## 2. Le travail de mi-session

- Les sept étapes suivent les consignes. Une barre en haut de chaque diapo
  d'étape montre où on est.
- **Hypothèse** : la théorie (le populisme oppose un peuple honnête à des
  élites qui le trahissent; si les élu.e.s ne servent que les puissant.e.s,
  le système fonctionne mal) donne H1 : plus on pense que les politiciens
  ne servent que les riches, moins on est satisfait de la démocratie. H0 :
  le populisme ne change rien; dans la régression, β1 = 0. Aucune
  référence n'est citée sur la diapo.
- **Le niveau de mesure** : un Y nominal (le parti, oui/non) est refusé :
  « Y baisse de β1 quand X passe de 0 à 1 » n'a pas de sens pour des
  catégories. Ordinal accepté. La diapo dit « Votre X peut être nominale »
  (à confirmer).
- **Évalué par les pairs**, « beaucoup cité, **ou** récent », **APA** :
  comme avant.
- **La question fait la variable** : le libellé français officiel des deux
  questions, le recodage 0 à 1, le NA. Note réelle du codebook (p. 209 et
  210) : la question sur le populisme n'a été posée qu'à une partie du
  sondage post-électoral (blocs tirés au hasard). C'est une des raisons du
  N de 564.

## 3. La droite

- **Les moindres carrés.** Pour chaque personne, l'écart vertical entre sa
  satisfaction et la droite, au carré, additionné : Σ(y − β0 − β1x)². R
  choisit la droite qui rend cette somme la plus petite. Sur les 15
  répondant.e.s de « Comment ça marche ? » : 2,12 (une droite qui monte),
  0,77 (la moyenne), 0,45 (la droite de R). Six de ces 15 personnes sont
  dans la même case : la diapo les place côte à côte.
- Sur « Jouer avec la droite », avec les 564 : la moyenne (0,60) donne
  51,5, la droite de R 45,8. 1 − 45,8 / 51,5 = 0,111, exactement le R².
- **Corrélation et régression.** r = −0,30 : sens et force, sans unité,
  symétrique. La pente = r × (écart type de y / écart type de x) : la même
  information en unités de satisfaction. r² = 0,087 = le R² de la
  population. Prédiction à « plutôt en accord » (0,75) : 0,79 − 0,31 ×
  0,75 ≈ 0,56 (la vraie moyenne y est 0,59).
- **Lire la pente** : on compare des personnes différentes. « Est associé
  à », pas « cause ». Un échelon fait −0,09 « environ » : quatre fois
  −0,093 donne −0,37.
- **La constante** (0,83) : la satisfaction prédite pour quelqu'un
  « fortement en désaccord ». Les 22 personnes à 0 dans notre sondage ont
  en moyenne 0,85 : la droite est proche.
- **Le code** : `lm(y ~ x, data = df)` plutôt que `lm(df$y ~ df$x, data =
  df)`. Avec `data =`, les `df$` sont redondants et cassent `predict()`.

## 4. Le hasard et le biais

- **La vraie droite** (−0,31) n'est connue ici que parce que la CES joue la
  population. Notre sondage donne −0,37 : proche, pas pareil (à un peu plus
  d'une erreur type).
- **1 000 sondages au hasard** : une cloche centrée sur −0,316 (vraie pente
  −0,314; la diapo garde trois décimales pour ne pas créer un faux écart).
  C'est le hasard. **1 000 sondages chez les 18 à 34 ans seulement** : une
  cloche aussi nette, centrée sur −0,19. C'est le biais, et plus de
  sondages ne le corrigent pas. −0,19 est la bonne pente *pour les jeunes*
  et la mauvaise *pour le Canada*.
- **ε** : tout ce qui fait bouger la satisfaction à part le populisme.
  Chez les jeunes, ε monte avec le populisme : les jeunes non populistes
  sont moins satisfaits que la droite le prédit (−0,13 à « fortement en
  désaccord », sur seulement 33 personnes), les populistes sont sur la
  droite ou au-dessus. Cette pente cachée aplatit leur droite.
- Exactement : pente d'un sondage − vraie pente = pente de son ε contre x.
  Le hasard penche un peu, chaque fois dans un sens différent. Le biais
  penche toujours du même côté.

## 5. La variable confondante

- **La crème glacée** (fictive, `seance7_e.R`, graine 7) : pente naïve
  +8,4; dans chaque tranche de température +0,2, −0,4, +0,7; avec la
  chaleur dans le modèle 0,06 (p = 0,82). D'où vient le 8,4 : 0,06 + 2,00
  × 4,16 = 8,37 (formule du biais de variable omise, pour les notes).
- **Pourquoi ε est « théorique »** : les résidus de R ne sont jamais
  corrélés avec x, par construction (Arel-Bundock, note 5 p. 84). Aucune
  vérification des résidus ne montre ce qui se cache dans ε. Seul le
  raisonnement (le graphe) le dit. C'est la séance 11.
- **Dans la CES : le vote libéral** (les gagnant.e.s de l'élection). Les
  personnes qui ont voté libéral sont moins populistes (0,55 contre 0,67)
  et plus satisfaites de la démocratie (0,74 contre 0,48). Pente du
  populisme seule : −0,31. **À vote égal : −0,22.** Environ 0,09 passait
  par le vote, 0,22 reste. L'effet du vote, à populisme égal : +0,24. Sur
  les 9 650 qui ont répondu aux deux questions et déclaré un vote.
- **Ce qui reste n'est pas prouvé causal** : d'autres choses dans ε
  peuvent pousser les deux (scolarité, âge, région, intérêt pour la
  politique).
- **Le sens de la flèche** : la diapo dessine le vote qui pousse le
  populisme. La flèche pourrait aller dans l'autre sens (populisme → vote
  → satisfaction). Le vote serait alors un médiateur, et le tenir constant
  retirerait une partie d'un vrai effet. C'est pourquoi la diapo dit « le
  graphe est une hypothèse ».
- Vocabulaire : Arel-Bundock dit « biais par variable omise », « tiers
  facteur », « relations fallacieuses ». La diapo dit « variable
  confondante ».

## 6. L'erreur type

- **Définition** : la distance typique entre la pente d'un sondage et la
  vraie pente. 1 000 sondages : 0,045.
- **Les trois ingrédients**, à armes égales (chaque sondage tire des
  personnes qui ont répondu aux deux questions) :
  - moins de monde : 50 au lieu de 500, 0,146 au lieu de 0,045 (dix fois
    moins de monde, environ trois fois plus large : √10 ≈ 3,2);
  - de grosses erreurs de prédiction : chaque écart à la droite doublé
    (rangée fictive, étiquetée), 0,090, exactement deux fois;
  - X qui varie peu : seulement les gens à 0,5 ou 0,75, 0,096. Cette
    cloche est centrée sur −0,21 : on compare les largeurs.
- **Un seul sondage suffit** : R estime 0,044 avec notre seul sondage,
  presque la dispersion des 1 000 (0,045). ET(β1) ≈ σ / (écart type de x ×
  √(n − 1)) = 0,2855 / (0,2725 × √563) ≈ 0,0442.

## 7. t, p, l'intervalle

- **Le monde où H0 est vraie** : on garde la satisfaction de chacun et on
  mélange les réponses de populisme entre les 564 personnes (un test de
  permutation). 1 000 mélanges : une cloche autour de 0, large d'environ
  0,044. Aucun n'atteint −0,37.
- **t = β1 / ET** = −0,371 / 0,044 ≈ −8,4 (R : −8,397). Au-delà d'environ
  2 : rare si H0 était vraie. Le panier de pommes de la séance 5 était à
  2,04.
- **p** : si H0 était vraie, combien de fois verrait-on une pente au moins
  aussi loin de 0, des deux côtés ? Notre sondage : 0 sur 1 000, R donne
  3,7 × 10⁻¹⁶. **Le sondage de 50** (R en garde 21) : pente −0,39, t =
  −2,00, 63 mélanges sur 1 000, **p = 0,06** : on ne rejette pas H0. Or la
  vraie pente est −0,31 : « acquittée, pas innocente ». Avec 19 degrés de
  liberté, le seuil de 5 % est t ≈ 2,09, pas 2 : c'est pourquoi t = −2,00
  donne p = 0,06.
- Jamais « la probabilité que H0 soit vraie ».
- **Étoiles** : * < 0,05, ** < 0,01, *** < 0,001, « . » < 0,1.
- **L'intervalle** ≈ β1 ± 1,96 × ET = −0,37 ± 0,087, de −0,46 à −0,28.
  Le sondage de 50 : de −0,80 à +0,02, il touche 0 de justesse, comme p =
  0,06. 19 intervalles sur 20 attrapent la vraie pente; le raté de
  « 19 fois sur 20 » vient d'une graine cherchée pour ça (70). Jamais
  « 95 % de chances ».
- Écart avec pol-vjv : l'issue dit « environ 2 fois sur 100 » pour le
  panier, le deck de la séance 5 affiche « environ 3 fois sur 100 ». La
  diapo reprend 3.

## 8. Le tableau de régression

- Le tableau affiche trois décimales (−0,371, (0,044)) : à deux décimales,
  −0,37 / 0,04 donnerait 9,3, pas le t de R.
- **N = 564** : R retire en silence 436 des 1 000 personnes, surtout par
  construction du sondage : 278 n'ont pas fait le sondage post-électoral,
  106 l'ont fait sans recevoir la question sur le populisme, 52 ont
  répondu « je ne sais pas ». Toujours comparer N à la taille de
  l'échantillon et demander qui manque, et pourquoi.
- **R² = 0,11** : ce n'est pas une note de qualité, la pente reste très
  claire (t = −8,4). R² ajusté 0,1099.
- **Erreur type résiduelle** (0,2855 sur 562 degrés de liberté) : la
  droite rate une personne d'à peu près une catégorie de satisfaction.
- **F** (70,5) = t² avec un seul x : pour la séance 8.
- **Résidus** : Y n'a que quatre valeurs, les résidus forment des bandes.
- **Modèle 2** (aperçu) : 488 personnes, populisme −0,28***, vote libéral
  +0,23***, diplôme universitaire +0,07**, âge, femme et Québec non
  significatifs, R² 0,28. Le passage de −0,37 à −0,28 tient en partie à
  des personnes différentes (N différent).

## 9. Le graphique des coefficients

- Le même contenu que le tableau. Le point = le coefficient, la moustache
  = l'IC à 95 %, la ligne à 0 = H0. Une moustache qui croise 0 : p > 0,05
  (âge p = 0,67, femme 0,75, Québec 0,95).
- **Les unités** : tout va de 0 à 1, c'est pourquoi le cours code ainsi :
  chaque point se lit « du minimum au maximum », donc −0,28 (populisme) et
  +0,23 (vote libéral) se comparent à peu près. Mais 0 → 1 veut dire un
  oui/non pour le vote, le sexe, le Québec et le diplôme, cinq réponses
  pour le populisme, et de 18 à 96 ans pour l'âge.
- Pour le faire dans R (code exécuté le 14 octobre sur `ces1000`,
  reconstruit comme dans `seance7_data.R`) :

  ```r
  library(broom); library(ggplot2); library(dplyr)
  modele <- lm(satisfaction_dem ~ populisme + vote_liberal + age + femme + quebec + universitaire, data = ces1000)
  coefs <- tidy(modele, conf.int = TRUE)
  coefs <- filter(coefs, term != "(Intercept)")
  coefs <- mutate(coefs, term = factor(term, levels = rev(term)))   # garde l'ordre du tableau
  ggplot(coefs, aes(x = estimate, y = term, xmin = conf.low, xmax = conf.high)) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_pointrange() +
    labs(x = "Effet sur la satisfaction (de 0 à 1)", y = NULL)
  ```
