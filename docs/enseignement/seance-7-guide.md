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

- **La question** : « Plus on est scolarisé, plus on s'intéresse à la
  politique ? » Un classique, dans la CES 2025, tout recodé de 0 à 1.
- **X** = `scolarite` (`cps25_education`, codebook p. 41, « Quel est votre
  plus haut niveau de scolarité complété ? »), regroupée en cinq niveaux :
  secondaire non terminé 0 (codes 1 à 4) · secondaire 0,25 (5) · collégial
  0,5 (6 et 7) · université, 1er cycle 0,75 (8 et 9) · maîtrise, doctorat 1
  (10 et 11). Pourquoi regrouper : les codes 1 à 3 ne comptent que 77
  personnes sur 20 180. Le code 12 (ne sais pas) devient NA. Le codebook
  français écrit « collègue » au code 6 (coquille) : la diapo écrit
  « collège ».
- **Y** = `interet` (`cps25_interest_gen_1`, p. 45) : le curseur de 0
  (aucun intérêt) à 10 (beaucoup d'intérêt), divisé par 10. -99 devient NA
  (404 personnes dans la CES).
- **La population d'exercice** : les 20 180, comme à la séance 5. 19 736
  ont répondu aux deux questions. **Constante 0,56, pente +0,17**, t = 24,
  R² 0,03, r 0,17. Moyennes par niveau : **0,56 · 0,61 · 0,65 · 0,69 ·
  0,74**, presque exactement sur la droite.
- **Notre sondage** : 1 000 personnes tirées parmi les 20 180 (graine 62).
  R garde **981** (19 « je ne sais pas » à l'intérêt). **Constante 0,54,
  pente +0,20, erreur type 0,032, t = 6,32, p = 3,9 × 10⁻¹⁰, IC à 95 % de
  0,14 à 0,27, R² 0,04**, erreur type résiduelle 0,25.
- **Lire la pente** : du secondaire non terminé à la maîtrise ou au
  doctorat (X de 0 à 1), l'intérêt monte de 0,20 sur une échelle de 0 à 1,
  soit 2 points sur 10. Un niveau (0,25) : environ +0,05.
- **La constante** (0,54) : l'intérêt prédit sans diplôme d'études
  secondaires, 5,4 sur 10. Les 25 personnes de ce niveau dans notre
  sondage ont en moyenne 0,46 (dans la population, 0,56).
- **Le R² est petit** (0,04) et c'est une leçon : la scolarité n'explique
  qu'une petite part des différences d'intérêt, mais la pente est très
  claire (t = 6,3). Un petit R² n'efface pas une pente.
- Tout vient de `deck/outils/seance7_data.R` (→ `seance7.js`), puis
  `seance7_a.R`, `seance7_b.R`, `seance7_d.R`, `seance7_e.R` (crème glacée,
  fictive), `seance7_f.R`, `seance7_g.R`. Depuis `deck/` :
  `CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R`, puis les
  autres (ils vérifient leurs tirages contre `seance7.js` et s'arrêtent
  s'ils divergent).
- Le curseur de 0 à 10 est traité comme une échelle à intervalles égaux;
  la scolarité en cinq niveaux est ordinale. À dire si on demande.

## 1. L'examen 1

La diapo montre le poids, la date de remise et les deux auxiliaires qui
corrigent. On dit où en est la correction.

## 2. Le travail de mi-session

- **Hypothèse** (théorie en mots, sans référence citée) : l'école donne
  des ressources (compétences, information, réseaux); avec ces ressources,
  suivre la politique coûte moins d'effort. H1 : plus on est scolarisé,
  plus on s'intéresse à la politique. H0 : la scolarité ne change rien;
  dans la régression, β1 = 0.
- **La question fait la variable** : les onze réponses officielles, leur
  regroupement en cinq niveaux, le curseur divisé par 10, les NA, et le
  compte de chaque code (pourquoi regrouper).
- **Le niveau de mesure** : un Y nominal (le parti, oui/non) est refusé.
  Le curseur (intervalle) et la scolarité (ordinale) sont acceptés. La
  diapo dit « Votre X peut être nominale » (à confirmer).

## 3. La droite

- **Les moindres carrés** : Σ(y − β0 − β1x)², la somme des écarts au
  carré, la plus petite possible. Sur les 15 personnes de « Comment ça
  marche ? » (graine 28, choisie et documentée : première graine dont la
  pente va dans le sens de la population) : 1,67 (une droite qui descend),
  1,27 (la moyenne), 1,25 (la droite de R). La droite de R fait à peine
  mieux que la moyenne : c'est le petit R², à dire.
- **Jouer avec la droite** (les 981) : la moyenne (0,67) donne 63,0, la
  droite de R 60,5. 1 − 60,5 / 63,0 = 0,039, le R².
- **Corrélation** : r = 0,17. La pente vaut aussi 0,17 par hasard (les
  deux variables de 0 à 1 ont presque le même écart type). La diapo le
  dit en petit. r² = 0,029 = le R² de la population.
- **Prédiction** à « université, 1er cycle » (0,75) : 0,56 + 0,17 × 0,75
  ≈ 0,69 (la vraie moyenne y est 0,694).
- On compare des personnes différentes, pas une personne qui retourne aux
  études. « Est associé à », pas « cause ».
- **Le code** : `lm(y ~ x, data = df)`, pas `lm(df$y ~ df$x, data = df)`
  (les `df$` sont redondants avec `data =` et cassent `predict()`).

## 4. Le hasard et le biais

- **La vraie droite** (+0,17) n'est connue ici que parce que la CES joue la
  population. Notre sondage : +0,20, à environ une erreur type.
- **1 000 sondages au hasard** : une cloche centrée sur +0,171 (vraie pente
  +0,172). **1 000 sondages de gens déjà intéressés (6 sur 10 ou plus)** :
  une cloche centrée sur +0,05. C'est le biais : une sélection sur Y.
- **Pourquoi la sélection sur Y aplatit la pente** : presque tous les
  diplômé.e.s des cycles supérieurs sont déjà intéressé.e.s (on en garde
  82 %); chez les gens sans diplôme secondaire, on n'en garde que 56 %, et
  ce sont les plus intéressé.e.s de leur niveau (ε moyen +0,21, contre
  +0,09 en haut). La coupe soulève la gauche plus que la droite : la pente
  s'écrase. L'ε des gens gardés est lié à la scolarité (corrélation
  −0,22).
- Pente d'un sondage − vraie pente = pente de son ε contre x. Le hasard
  penche un peu, chaque fois autrement. Le biais penche toujours pareil.

## 5. La variable confondante

- **La crème glacée** (fictive) : pente naïve +8,4; dans chaque tranche de
  température +0,2, −0,4, +0,7; avec la chaleur 0,06. 8,37 = 0,06 + 2,00 ×
  4,16 (formule du biais de variable omise, pour les notes).
- **ε est théorique** : les résidus de R ne sont jamais corrélés avec x,
  par construction (Arel-Bundock, note 5 p. 84). Seul le raisonnement (le
  graphe) dit ce qui s'y cache. C'est la séance 11.
- **Dans la CES : l'âge masque une partie du lien.** Les 65 ans et plus
  ont un peu moins de scolarité (0,59 contre 0,63 chez les 35 ans et
  moins), mais beaucoup plus d'intérêt (0,76 contre 0,60). Laissé dans ε,
  l'âge pousse la scolarité vers le bas et l'intérêt vers le haut : il tire
  la pente vers zéro. **Seule : +0,17. À âge égal : +0,19.** L'effet de
  l'âge, à scolarité égale : +0,28 (de 18 à 96 ans).
- **La leçon** : une troisième variable peut gonfler un lien (la crème
  glacée) ou le masquer (l'âge). Tout dépend des signes de ses deux
  flèches.
- **Les autres essais** (`TIERS.essais`) : le genre (0,172 → 0,168) et le
  Québec (0,172 → 0,172) ne changent rien. **Le revenu, si** : 0,171 →
  0,150. Le revenu va avec la scolarité et avec l'intérêt, et il gonfle
  probablement une partie de la pente. Ce n'est pas sur les diapos. Si on
  demande : +0,19 n'est pas prouvé causal, d'autres variables comptent.
- La flèche âge → scolarité représente des différences entre générations
  (accès à l'école), pas un effet de vieillir. Le pied de la diapo dit
  « le graphe est une hypothèse ».
- Vocabulaire : Arel-Bundock dit « biais par variable omise », « tiers
  facteur », « relations fallacieuses ». La diapo dit « variable
  confondante ».

## 6. L'erreur type

- **Définition** : la distance typique entre la pente d'un sondage et la
  vraie pente. 1 000 sondages : 0,033.
- **Les trois ingrédients** (sondages de cas complets) : 500 personnes
  0,045; 50 personnes 0,146 (√10 ≈ 3,2 fois plus large); erreurs doublées
  (rangée fictive, étiquetée) 0,089; X qui varie peu (collégial et
  université 1er cycle seulement) 0,087.
- **Un seul sondage suffit** : R estime 0,032, presque la dispersion des
  1 000 (0,033). ET(β1) ≈ σ / (écart type de x × √(n − 1)) = 0,2486 /
  (0,2473 × √980) ≈ 0,032. R² petit parce que σ est grand, t grand parce
  que n est grand.

## 7. t, p, l'intervalle

- **Le monde où H0 est vraie** : on mélange les niveaux de scolarité entre
  les 981 personnes (test de permutation). 1 000 mélanges : une cloche
  autour de 0, large d'environ 0,033. Aucun n'atteint +0,20.
- **t = β1 / ET** = 0,203 / 0,032 ≈ 6,3 (R : 6,324). Au-delà d'environ 2 :
  rare si H0 était vraie.
- **p** : notre sondage, 0 mélange sur 1 000, R donne 3,9 × 10⁻¹⁰. **Le
  sondage de 50** (graine 67, documentée; R en garde 46) : pente +0,22,
  t = 1,80, **p = 0,078**, 76 mélanges sur 1 000 : on ne rejette pas H0,
  alors que la vraie pente est +0,17. C'est le cas typique : avec 50
  personnes, environ 8 sondages sur 10 ne rejettent pas H0. « Acquittée,
  pas innocente. »
- Jamais « la probabilité que H0 soit vraie ».
- **Étoiles** : * < 0,05, ** < 0,01, *** < 0,001, « . » < 0,1.
- **L'intervalle** ≈ β1 ± 1,96 × ET = 0,20 ± 0,063, de 0,14 à 0,27. Le
  sondage de 50 : de −0,03 à +0,47, il touche 0 de justesse, comme p =
  0,078. 19 intervalles sur 20 attrapent la vraie pente (graine 70,
  cherchée pour un seul raté). Jamais « 95 % de chances ».
- Écart avec pol-vjv : l'issue dit « environ 2 fois sur 100 » pour le
  panier, le deck de la séance 5 affiche « environ 3 fois sur 100 ». La
  diapo reprend 3.

## 8. Le tableau de régression

- Le tableau affiche trois décimales (0,203 (0,032)) pour que 0,203 /
  0,032 redonne le t de R.
- **N = 981** : seulement 19 personnes manquent, toutes à la question sur
  l'intérêt. Le réflexe reste : R retire des lignes en silence, toujours
  comparer N à l'échantillon.
- **R² = 0,04** : la vedette de la diapo, « 4 % seulement, et pourtant
  t = 6,3 ». R² ajusté 0,0383.
- **Erreur type résiduelle** (0,2486 sur 979 degrés de liberté) : la
  droite rate une personne d'environ 2,5 points sur 10.
- **F** (39,99) = t² avec un seul x : pour la séance 8.
- **Résidus** : l'intérêt s'empile en haut du curseur, les résidus sont
  asymétriques (médiane +0,06).
- **Modèle 2** (aperçu) : 877 personnes (revenu et genre manquants),
  scolarité +0,19***, âge +0,35***, femme −0,09***, revenu +0,085**,
  Québec non significatif, R² 0,18.

## 9. Le graphique des coefficients

- Le même contenu que le tableau. Point = coefficient (0,20), moustache =
  IC à 95 % (0,14 à 0,27), ligne à 0 = H0. Seul le Québec croise 0 (p =
  0,91).
- **Les unités** : tout va de 0 à 1, chaque point se lit « du minimum au
  maximum ». Mais 0 → 1 veut dire 78 ans d'écart pour l'âge, oui/non pour
  femme et Québec, huit tranches pour le revenu, cinq diplômes pour la
  scolarité. Le gros point de l'âge (+0,35) tient en partie à l'étendue
  de 18 à 96 ans.
- Pour le faire dans R (code exécuté le 14 octobre sur `ces1000`,
  reconstruit comme dans `seance7_data.R`) :

  ```r
  library(broom); library(ggplot2); library(dplyr)
  modele <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)
  coefs <- tidy(modele, conf.int = TRUE)
  coefs <- filter(coefs, term != "(Intercept)")
  coefs <- mutate(coefs, term = factor(term, levels = rev(term)))   # garde l'ordre du tableau
  ggplot(coefs, aes(x = estimate, y = term, xmin = conf.low, xmax = conf.high)) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_pointrange() +
    labs(x = "Effet sur l'intérêt pour la politique (de 0 à 1)", y = NULL)
  ```
