# Séance 5 · L'inférence statistique · guide de l'enseignant

Guide d'étude pour préparer la séance du jeudi 1er octobre 2026. Il suit le
deck `slides/seance-5/` diapo par diapo : ce qu'il faut dire, d'où vient
chaque chiffre, les questions probables et les pièges. Ce fichier est dans
le dépôt public, mais il ne contient rien de confidentiel.

Référence principale : Arel-Bundock (2021), *Analyse causale et méthodes
quantitatives*, chapitre 4 « Inférence statistique », p. 61-76. Le PDF est
gratuit sur le site des Presses de l'Université de Montréal. Lire les
p. 61-76 une fois avant la séance suffit : tout le deck en découle.

---

## 0. L'idée en une phrase

> On observe un **échantillon**, on veut parler de la **population**.
> L'inférence statistique, c'est mesurer à quel point on peut se fier à ce
> saut, parce que le hasard du tirage fait varier nos résultats.

Tout le reste de la séance décline cette phrase :

1. Un échantillon tiré au hasard donne une réponse **un peu différente** à
   chaque tirage (le hasard).
2. Ces réponses se répartissent autour de la vraie valeur, avec une
   dispersion qu'on sait mesurer : **l'erreur type**.
3. Avec l'erreur type, on peut se demander : « si rien ne se passait
   (H0), mon résultat serait-il surprenant ? » C'est le **test
   d'hypothèse nulle** (t, p, intervalle de confiance).

Si un étudiant ne retient qu'une chose : **l'erreur type mesure combien
une estimation bouge d'un échantillon à l'autre.** t, p et l'intervalle de
confiance sont trois façons de s'en servir.

---

## 1. Minutage suggéré (155 minutes utiles)

| Bloc | Diapos | Durée |
|---|---|---|
| Ouverture (titre, frise, questions, aujourd'hui) | 1-4 | 5 min |
| L'inférence : vocabulaire, échantillon, hasard, erreur type, biais | 5-18 | 35 min |
| Le test d'hypothèse nulle : pomicultrice, t, p, intervalle, limites | 19-33 | 40 min |
| Pause | 34 | 15 min |
| ggplot2, couche par couche | 35-45 | 35 min |
| L'inférence en direct dans R | 46-55 | 25 min |
| Script, mi-session, avant le 15 octobre | 56-68 | 10 min |

**Si le temps manque**, coupez dans cet ordre : « Quel graphique ? »
(rappel de la séance 3), « Sauvegarder le graphique », « Le même test, sur
100 personnes », puis « Le test, en huit étapes ». Ne coupez pas
ggplot2 : c'est la demande explicite de cette séance.

---

## 2. Le dispositif de la séance (à dire tôt, et une seule fois)

Pour voir l'inférence fonctionner, il faut connaître la vraie réponse. On
fait donc **comme si les 20 180 répondant.e.s de l'Étude électorale
canadienne 2025 étaient toute la population**. Leur âge moyen est connu :
**49,7 ans** (écart type 17,5 ans). Ensuite, on tire des échantillons de
50 personnes dedans et on regarde ce que donnent leurs moyennes.

La diapo « Et l'Étude électorale canadienne ? » l'annonce. À dire aussi :

- L'Étude électorale 2025 **n'est pas un échantillon aléatoire simple** :
  c'est un panel en ligne de la firme Léger, avec des quotas par région,
  genre et âge (codebook, p. 9-10). Les chercheurs fournissent des **poids**
  (pondération par *raking*) pour corriger les écarts connus.
- Aujourd'hui, **rien n'est pondéré**. C'est un choix pédagogique, pas une
  pratique à imiter dans un article.

C'est aussi la réponse à la question qu'Adrien posait en H24 : « Est-ce que
l'échantillon probabiliste existe ? » Presque plus, en pratique. On s'en
approche et on corrige.

---

## 3. Partie 1 · L'inférence

### « Le but : l'inférence » (rappel de la séance 3)

Même figure qu'à la séance 3 (KKV, 1994, p. 46). Une phrase :
« À la séance 3, on a dit que le but de la science, c'est l'inférence.
Aujourd'hui, on apprend à la faire avec des chiffres. »

### « Quatre mots »

| Mot | Définition à dire | Exemple |
|---|---|---|
| **Population** | Tout le monde qu'on veut décrire. | Tout l'électorat canadien. |
| **Échantillon** | Le sous-groupe qu'on observe vraiment. | Les personnes sondées. |
| **Paramètre** | La vraie valeur dans la population. Inconnue. | Le vrai âge moyen de l'électorat. |
| **Estimé** | Ce qu'on calcule dans l'échantillon pour deviner le paramètre. | L'âge moyen des personnes sondées. |

Le livre distingue aussi **l'estimateur** (la recette, par exemple « faire
la moyenne ») et **l'estimé** (le nombre obtenu, par exemple « 105
grammes »), p. 63. Pas besoin d'insister, mais si un étudiant demande :
l'estimateur est la formule, l'estimé est son résultat.

### « Au hasard »

**Échantillon aléatoire simple** : chaque membre de la population a **la
même chance** d'être tiré (p. 62). Le deuxième clic montre le contraire :
ne sonder que les plus faciles à joindre. Question à poser à la salle :
« Qui est facile à joindre pour un sondage ? » (les gens chez eux le jour,
les gens intéressés, les gens en ligne…).

### « 1936 : 2,3 millions de réponses »

Le *Literary Digest* a posté plus de **10 millions** de bulletins, tirés
surtout des **listes d'immatriculation d'automobiles et des annuaires
téléphoniques**. Plus de **2,3 millions** sont revenus (moins de 25 %).
Prévision : Landon 55 %, Roosevelt 41 %. Résultat : **Roosevelt 61 %,
Landon 37 %**. Source vérifiée : Squire (1988, p. 126-127).

Le message : **un échantillon énorme mais biaisé reste faux**. En 1936,
posséder une voiture ou un téléphone, c'était être plutôt aisé, et les
gens aisés votaient plus pour Landon. Squire montre que le biais venait à
la fois de **la liste** (qui est tiré) et de **la réponse** (qui répond).

Anecdote utile si le temps le permet : les sondages concurrents de
Gallup, Roper et Crossley, beaucoup plus petits mais mieux construits, ont
prévu l'élection de 1936 « with reasonable accuracy » (Squire 1988,
p. 127-128). La taille ne remplace pas le hasard.

### « La loi des grands nombres »

Haut : 1 000 lancers de pièce (simulés dans R, `set.seed(1)`). Après 10
lancers, 60 % de piles. Après 1 000, 48 %. Bas : on ajoute des
répondant.e.s un à un, au hasard ; la moyenne d'âge part à 58,6 ans après
10 personnes et finit à 49,8 après 2 000.

À dire : **la probabilité, c'est ce qui arrive à la longue**. Avec peu
d'essais, le hasard domine. Avec beaucoup, on s'approche de la vraie
valeur. C'est la **loi des grands nombres** (la séance 3 l'avait reportée
à aujourd'hui).

Piège : la loi des grands nombres ne dit pas que la pièce « se rattrape »
après une série de faces. Chaque lancer reste à une chance sur deux. C'est
la **proportion** qui se stabilise, parce que les premiers lancers pèsent
de moins en moins.

### « Trois échantillons, trois moyennes »

Trois échantillons de 50 : 47,6 ans, 51,2 ans, 50,3 ans. La vraie moyenne
est 49,7. **Aucun n'est « faux »** : c'est le hasard du tirage.

### « Mille échantillons »

On refait le tirage 1 000 fois (`set.seed(4)`) et on empile les 1 000
moyennes : 1, puis 10, puis 100, puis 1 000. La forme en cloche qui
apparaît s'appelle la **distribution d'échantillonnage** (*sampling
distribution*). Deux choses à pointer :

1. Elle est **centrée sur la vraie moyenne** (49,6 contre 49,7) : la
   moyenne d'un échantillon aléatoire est un estimateur **non biaisé**
   (p. 63-64).
2. Elle a une **largeur** : c'est l'incertitude.

C'est la diapo la plus importante de la première heure. Prenez le temps.

### « Plus l'échantillon est grand… »

Même expérience pour n = 10, 50, 200 et 1 000. La cloche se resserre.
L'écart entre les moyennes passe de 5,3 ans (n = 10) à 2,5 (n = 50), 1,2
(n = 200) et 0,5 (n = 1 000).

Règle à retenir : **pour diviser l'erreur par 2, il faut 4 fois plus de
monde** (50 → 200 : 2,55 → 1,19). C'est pour ça qu'un sondage de 1 000
personnes coûte cher à améliorer : pour diviser la marge d'erreur par
deux, il en faudrait 4 000.

### « L'erreur type »

- **Définition** : l'erreur type est **l'écart type des moyennes, d'un
  échantillon à l'autre**. (Le livre : la racine carrée de la variance
  échantillonnale, p. 65.)
- **Le raccourci** (équation 4.2, p. 65) : écart type de la variable ÷
  racine carrée de n. Ici : 17,54 ÷ √50 = **2,48 ans**.
- **Le moment « wow »** : les 1 000 échantillons donnent 2,55, le calcul
  sur un seul échantillon donne 2,48. **On n'a pas besoin de tirer mille
  échantillons : un seul, et ce calcul, suffisent.** C'est exactement ce
  que font `t.test()` et, plus tard, `lm()`.

Question probable : « Pourquoi 2,55 et pas exactement 2,48 ? » Parce que
1 000 échantillons, c'est beaucoup mais pas l'infini : la simulation
elle-même a un peu de hasard. En direct plus tard, la console donnera 2,49
avec un autre tirage. C'est normal, et c'est la même leçon.

### « Dans l'échantillon, entre les échantillons »

C'est la distinction qui mélange le plus les étudiant.e.s (Adrien la
signalait déjà en H24, et le livre y consacre le tableau 4.1, p. 65).

- **Dans** l'échantillon : l'écart type des âges de 5 personnes (19,1 ans,
  9,0, 12,7, 18,7). C'est la dispersion de la séance 3.
- **Entre** les échantillons : l'écart type des **4 moyennes** (6,3 ans).
  C'est la **variance échantillonnale**. Sa racine carrée est l'erreur
  type.

Phrase à dire : « La séance 3 mesurait à quel point les **personnes**
diffèrent. Aujourd'hui, on mesure à quel point les **moyennes** diffèrent
d'un échantillon à l'autre. »

### « Le biais et la variance » (la cible)

Figure 4.1 du livre (p. 66), étendue à quatre cibles. Chaque X est
l'estimé d'un échantillon.

- **Biais** = viser à côté **en moyenne** (la justesse).
- **Variance** = s'éparpiller d'un tir à l'autre (la précision).

Un bon estimateur est **non biaisé** et a **une faible variance** (p. 63).
Augmenter n réduit la variance. **Augmenter n ne réduit pas le biais.**

### « Ne sonder que les passionné.e.s »

Démonstration du biais avec les vraies données : 1 000 échantillons de 50
tirés **seulement** parmi les 8 653 répondant.e.s qui se disent très
intéressé.e.s par la politique (8, 9 ou 10 sur 10). Leur âge moyen est
54,3 ans, soit **4,6 ans de trop**. La cloche rouge est aussi étroite que
la grise, mais elle est **décalée**.

Lien avec 1936 : les gens qui répondent à un sondage politique sont ceux
que la politique intéresse, et ils ne ressemblent pas aux autres. **Mille
échantillons de plus n'y changent rien.**

---

## 4. Partie 2 · Le test d'hypothèse nulle

### La pomicultrice, de bout en bout

Exemple fictif du livre (p. 62-74). À connaître par cœur, parce que tout le
bloc s'appuie dessus.

| Étape | Calcul | Résultat |
|---|---|---|
| La situation | Un verger, des centaines de milliers de pommes. L'acheteur exige un poids moyen **de plus de 100 g**. | |
| Échantillon | 50 pommes tirées au hasard | n = 50 |
| Estimé | poids moyen dans l'échantillon | **105 g** |
| Dispersion | variance 300, donc écart type √300 | 17,3 g |
| H0 | le vrai poids moyen est de 100 g | 100 g |
| Écart | 105 − 100 | **5 g** |
| Erreur type | √(300 ÷ 50) = √6 | **2,45 g** |
| t | 5 ÷ 2,45 | **2,04** |
| p | aire au-delà de ±2,04 sous une loi de Student à 49 degrés de liberté | **0,047** |
| Intervalle à 95 % | 105 ± 2 × 2,45 | **de 100,1 à 109,9 g** |
| Verdict | p < 0,05, t ≥ 2, et 100 est hors de l'intervalle | **on rejette H0** |

Tous ces chiffres sont recalculés par `outils/seance5_data.R` à partir de
n = 50, 105 et 300 (les seules données du livre).

### « Deux hypothèses »

- **H1** (l'hypothèse de recherche) : ce qu'on croit. « Le poids moyen
  n'est pas de 100 g. »
- **H0** (l'hypothèse nulle) : l'absence d'effet, d'écart ou de relation.
  « Le poids moyen est de 100 g. »

Le livre (p. 67) : H0 est une phrase **déclarative et quantitative** qu'un
test pourrait infirmer. **On teste H0, pas H1.** On cherche à rejeter H0.

Lien direct avec le travail de mi-session : les étudiant.e.s doivent
formuler **une hypothèse et son hypothèse nulle**. L'exemple politique de
la diapo (âge et intérêt pour la politique) est un modèle à suivre.

### « Présumée vraie » (le tribunal)

L'analogie n'est pas dans le livre, mais elle est classique et elle marche :

| Au tribunal | En statistique |
|---|---|
| L'accusée est présumée innocente | H0 est présumée vraie |
| Les preuves | Les données |
| Coupable hors de tout doute raisonnable | On rejette H0 |
| Pas assez de preuves : acquittée, pas « innocente » | On ne rejette pas H0. On ne l'**accepte** jamais. |

La dernière ligne est la plus importante (p. 75) : **ne pas rejeter H0, ce
n'est pas prouver H0.** C'est seulement ne pas avoir assez de preuves.

### « Si H0 était vraie… »

La question qui fonde tout le test : **si le vrai poids moyen était de
100 g, un échantillon de 50 pommes pesant 105 g en moyenne serait-il
surprenant ?** La courbe montre où tomberaient les moyennes de 50 pommes
dans ce monde-là (centrée sur 100, largeur donnée par l'erreur type de
2,45 g). Notre 105 g est dans la queue.

### « La statistique t »

**t = (estimé − H0) ÷ erreur type.** En mots : **à combien d'erreurs types
notre estimé se trouve-t-il de H0 ?** Ici, 5 g ÷ 2,45 g = 2,04 erreurs
types.

Deux choses font grandir t (p. 68) :

1. un **écart plus grand** entre l'estimé et H0 ;
2. une **erreur type plus petite** (plus de monde, ou des données moins
   dispersées).

Règle du pouce : **|t| ≥ 2**, c'est surprenant si H0 était vraie.
Citation utile du livre (p. 69) : « plus t s'éloigne de zéro, plus il
serait surprenant d'observer un échantillon comme le nôtre, si
l'hypothèse nulle était vraie ».

### « La valeur p »

**Définition exacte (p. 71)** : la probabilité d'obtenir une statistique t
**au moins aussi extrême que la nôtre, si H0 était vraie**. Ici, 0,047 :
si le vrai poids était 100 g, moins de 5 % des échantillons de 50 pommes
donneraient un t aussi loin de zéro.

Dans R : `pt(-2.04, df = 49) + (1 - pt(2.04, df = 49))` donne 0,04676. Les
deux morceaux sont les deux queues de la courbe. Pas besoin d'expliquer
`pt()` plus loin : c'est la seule fois qu'on le voit.

**Piège majeur à éviter en parlant** : ne dites jamais « il y a 4,7 % de
chances que H0 soit vraie ». La valeur p se calcule **en supposant** que H0
est vraie ; elle ne peut pas donner la probabilité que H0 le soit.

### « Le seuil de 0,05 »

- Si p < 0,05 : on rejette H0, le résultat est **statistiquement
  significatif**.
- Les étoiles des tableaux de régression : * p < 0,05, ** p < 0,01,
  *** p < 0,001. Les étudiant.e.s les reverront à la séance 7.
- 0,05 est une **convention arbitraire**. Le livre (p. 71, note 9) rappelle
  qu'elle vient d'une préférence personnelle de Fisher (1926).

### « L'intervalle de confiance »

L'estimé ± environ 2 erreurs types : de 100,1 à 109,9 g. Si H0 (100) est
**hors** de l'intervalle à 95 %, on rejette H0 au seuil de 5 %. C'est le
même verdict que p < 0,05, dit autrement.

Sur le « 2 » : le livre utilise 2 pour la pomicultrice (équation 4.6). La
valeur exacte pour n = 50 est 2,01 (`qt(0.975, 49)`), et pour un grand
échantillon, 1,96 (p. 74). C'est pourquoi le code ggplot2 de la fin
utilise `1.96 * et`. Trois arrondis, une seule idée.

### « Le lancer d'anneaux »

C'est **la** diapo pour bien interpréter un intervalle (figure 4.4 du
livre, p. 74). 100 échantillons de 50 dans les 20 180, 100 intervalles à
95 % : **94** attrapent la vraie moyenne (49,7 ans), 6 la ratent (en
rouge). On s'attendait à environ 95.

Phrase à dire : **« La vérité ne bouge pas. C'est l'intervalle qui
bouge. »** Le « 95 % » décrit la méthode : 95 % des intervalles construits
ainsi attrapent la vraie valeur.

**Piège** (le livre insiste, p. 73, note 10) : ne dites pas « il y a 95 %
de chances que la vraie valeur soit dans **cet** intervalle ». Une fois
l'intervalle calculé, la vraie valeur y est ou n'y est pas.

Attention : la note des diapos de H24 disait « confiance que la valeur
réelle se trouve dans cet intervalle ». C'est justement la formulation à
éviter. Et une phrase du livre (p. 73) dit que les intervalles couvrent
« la véritable valeur de X̄ » : il faut lire « la vraie moyenne de la
population ». Le deck suit la bonne formulation.

### « Trois façons de dire la même chose »

Pour la pomicultrice : t = 2,04 (≥ 2), p = 0,047 (< 0,05), 100 hors de
l'intervalle. **Même verdict.** Ce n'est pas une coïncidence : les trois
utilisent l'estimé, H0 et l'erreur type.

### « Le test, en huit étapes » (p. 74-75)

1. Choisir H0. 2. Choisir un seuil. 3. Tirer un échantillon aléatoire.
4. Estimer. 5. Calculer l'erreur type. 6. Calculer t. 7. Calculer p.
8. Comparer p au seuil.

Utile comme résumé à relire chez soi. En classe, 2 minutes suffisent.

### « Deux façons de se tromper »

| | H0 est vraie | H0 est fausse |
|---|---|---|
| On rejette H0 | **Erreur de type 1** (condamner une innocente) | bonne décision |
| On ne rejette pas H0 | bonne décision | **Erreur de type 2** (acquitter un coupable) |

Avec un seuil de 0,05, on accepte de commettre une erreur de type 1 dans
5 % des cas où H0 est vraie. Pour mémoriser : type 1, on voit un effet
qui n'existe pas. Type 2, on rate un effet qui existe.

### « Ce que p ne dit pas »

Trois lectures fausses, barrées :

1. **La probabilité que H0 soit vraie.** Non (voir plus haut).
2. **La taille ou l'importance de l'effet.** Non : un effet minuscule
   devient significatif avec assez de monde.
3. **La preuve d'une cause.** Non : c'était déjà l'avertissement d'Adrien
   en H24, et c'est toute la troisième partie du cours.

Ce qu'elle dit : à quel point nos données seraient surprenantes si H0 était
vraie. Source pour les deux premières : l'énoncé de l'American Statistical
Association sur la valeur p (Wasserstein et Lazar 2016).

### « Significatif n'est pas important » (p. 76)

- **Bertrand et Mullainathan (2004)** : des CV identiques, sauf le nom.
  Les noms perçus comme blancs reçoivent **50 % plus de rappels**.
  p < 0,001. Significatif **et** important.
- **Sevi, Arel-Bundock et Blais (2019)** : aux élections fédérales
  canadiennes, les candidates reçoivent **0,5 point de pourcentage** de
  moins que les candidats. p < 0,001. Significatif, mais minuscule. Leur
  conclusion : les partis devraient recruter plus de candidates, qui ne
  subissent pas de pénalité électorale considérable.
- **Nos données** : la satisfaction envers la démocratie diffère de 3,7
  points sur 100 entre personnes nées ailleurs et nées au Canada,
  p < 0,001. Significatif, parce que n est énorme. Important ? À discuter
  avec la salle.

---

## 5. Partie 3 · ggplot2

Contexte : jusqu'ici, les étudiant.e.s ont **copié** du code ggplot2
(séance 3) sans le comprendre. Aujourd'hui, on le construit. Les chapitres
Datacamp sur ggplot2 viennent aux séances 7 et 8 : cette partie est leur
première vraie rencontre.

### « La grammaire des graphiques »

Un graphique = **des données** + **des esthétiques** (quelle variable va
sur quel axe, quelle couleur) + **des géométries** (points, barres,
lignes), empilées en **couches**. Idée de Wilkinson, mise en code par
Wickham (2010). Le « gg » de ggplot veut dire *grammar of graphics*.

### « Le gabarit »

```r
ggplot(data = <DONNÉES>, aes(<CORRESPONDANCES>)) +
  <GEOM>()
```

Trois questions : **quel tableau ? quelle variable va où ? quelle forme ?**
Le `+` ajoute une couche. (Gabarit tiré de *R for Data Science*, 2e éd.,
chap. 1.)

### Couche par couche (trois diapos)

Chaque image est la vraie sortie de R pour le code affiché à côté.

1. `ggplot(df_clean)` : **une toile grise vide**. R connaît les données,
   mais pas quoi en faire.
2. `+ aes(x = age, y = gauche_droite)` : **les axes**. Remarquez le titre
   de l'axe y : c'est la question du sondage, en anglais, tirée du
   codebook. `haven` l'a gardée dans la colonne (lien avec la séance 4 :
   `attr(df_raw$cps25_demsat, "label")`).
3. `geom_point()` : 11 lignes de points. La position gauche-droite ne prend
   que 11 valeurs (0 à 10), donc les 17 000 points **se superposent**.
4. `geom_jitter(alpha = 0.1)` : on **secoue** un peu chaque point et on le
   rend transparent. On voit enfin où il y a du monde.
5. `+ geom_smooth()` : une **deuxième couche**, la tendance. Elle est
   presque plate : l'âge dit peu de chose de la position gauche-droite.
6. `+ labs(...)` : les titres, en français. Le titre anglais disparaît.
7. `+ theme_minimal()` : l'apparence.

Les messages de R sous le code sont réels :

- « Removed 3184 rows containing missing values » : les 3 184 « -99 »
  devenus `NA` à la séance 4. ggplot2 les enlève et le dit. **Ce n'est pas
  une erreur**, c'est un avertissement.
- « `geom_smooth()` using method = 'gam' » : ggplot2 annonce comment il a
  tracé la courbe. On l'ignore pour l'instant.

### « Une troisième variable : la couleur »

`colour = vote` **dans** `aes()` : une courbe par parti. Les conservateurs
se placent nettement plus à droite, le NPD plus à gauche. Contraste avec la
diapo précédente : **le parti dit beaucoup plus que l'âge**. (La séance 8,
régression multiple, reviendra à ce genre de comparaison.)

La ligne `filter(as.numeric(vote) <= 5, ...)` garde les codes 1 à 5 du
vote : libéral, conservateur, NPD, Bloc, vert.

### « Dans aes(), ou hors de aes() ? »

L'erreur la plus fréquente de toute la vie d'une personne qui fait du
ggplot2. `aes(fill = "blue")` donne des barres **saumon** avec une légende
« blue » : R a cru que « blue » était une **variable** (une colonne dont
toutes les valeurs valent « blue ») et lui a donné la première couleur par
défaut. `geom_histogram(fill = "blue")`, **hors** de `aes()`, donne du
bleu. Règle : **dans `aes()`, une variable. Hors de `aes()`, une valeur
fixe.**

### « Deux erreurs classiques »

Messages réels de R :

1. `|>` au lieu de `+` : « Did you use `%>%` or `|>` instead of `+`? ».
   Le pipe sert à dplyr, le `+` à ggplot2.
2. Le `+` au début de la ligne suivante : « Did you accidentally put `+`
   on a new line? ». R exécute la première ligne seule, puis ne comprend
   pas un `+` orphelin. **Le `+` va toujours à la fin de la ligne.**

---

## 6. Partie 4 · L'inférence, dans R (en direct)

### « Votre échantillon de 50 »

Faites-le taper à toute la salle. **Chaque personne obtient une moyenne
différente** : c'est la variance échantillonnale en chair et en os.
Demandez à cinq ou six personnes de crier leur moyenne. Elles tourneront
autour de 49,7, entre 45 et 55 environ.

La console du deck montre 49,44 puis 51,74 (tirage figé avec `set.seed`
pour que la diapo ne change pas). **Les étudiant.e.s n'utilisent pas
`set.seed`**, exprès.

### « Mille échantillons, en une ligne »

`replicate(1000, ...)` répète 1 000 fois. `sd(moyennes)` donne l'erreur
type par simulation (2,49), `sd(df_clean$age) / sqrt(50)` la donne par le
calcul (2,48). La diapo de la première heure disait 2,55 : autre tirage,
même leçon.

### « Lire la sortie de t.test() »

`t.test(df_clean$gauche_droite, mu = 5)` : la position gauche-droite
moyenne est-elle de 5, le centre de l'échelle ?

- t = −1,808 : l'estimé (4,97) est à 1,8 erreur type sous 5.
- p = 0,071 : plus grand que 0,05.
- intervalle à 95 % : de 4,931 à 5,003. **5 est dedans.**
- Verdict : **on ne rejette pas H0.** La moyenne pourrait être 5.

Belle occasion de redire : même avec 17 000 personnes, on ne rejette pas
H0 ici, et **ça ne prouve pas** que la moyenne est exactement 5.

Ignorer dans la sortie : `df = 16995` (les degrés de liberté, n − 1) et
« alternative hypothesis » (c'est H1, écrite par R en anglais).

### « Né.e.s ici, né.e.s ailleurs »

`t.test(gauche_droite ~ ne_canada, data = df_clean)` : les personnes nées
ailleurs se placent à 5,41, celles nées au Canada à 4,86. Écart de 0,55
point sur une échelle de 0 à 10. **p < 2.2e-16** : R écrit ça quand p est
si petit qu'il ne vaut pas la peine de l'afficher (plus petit que
0,0000000000000002). À dire : « p est pratiquement zéro ».

Notes techniques si quelqu'un demande :

- **Welch** : la version du test t qui ne suppose pas que les deux groupes
  ont la même dispersion. C'est le défaut de R. Rien à changer.
- « group 0 / group 1 » : les valeurs de `ne_canada` (0 = né.e ailleurs,
  1 = né.e au Canada).
- L'intervalle (0,46 à 0,64) porte sur **la différence** entre les
  groupes. 0 n'est pas dedans, donc on rejette H0 (« aucune différence »).

### « Le même test, sur 100 personnes »

Même test sur 100 personnes tirées au hasard : p = 0,53, et l'écart change
même de sens. **La différence existe dans les 20 180, mais 100 personnes
ne suffisent pas à la voir.** Sur 1 000 petits échantillons de 100, seuls
15 % la trouvent (p < 0,05). C'est une erreur de type 2 dans 85 % des cas.

Leçon : **la significativité dépend de n.** Avec beaucoup de monde, tout
devient significatif (voir « Significatif n'est pas important ») ; avec
peu, presque rien.

### « Une moyenne par parti » puis « Même code, deux tailles d'échantillon »

`group_by(vote) |> summarise(...)` : c'est le chapitre Datacamp de la
semaine (Grouping and Summarizing). `et = sd(...) / sqrt(n())` est
l'erreur type, exactement le raccourci de la première heure.

Puis `geom_pointrange()` avec `moyenne ± 1.96 * et` : **un point, une
barre, pour chaque parti**. Sur les 12 173 partisan.e.s, les barres sont si
courtes qu'on les voit à peine. Sur 200 personnes, elles sont larges et
se chevauchent (les Verts n'ont que 5 personnes). **Même code, moins de
monde, plus d'incertitude.** Les deux graphiques ont le même axe de 0 à 10
(`xlim(0, 10)`) pour que la comparaison soit honnête.

### « Sauvegarder le graphique »

`ggsave("gauche_droite_partis.png", width = 8, height = 5)` enregistre le
**dernier graphique affiché** dans le dossier de travail (séance 3 : où
suis-je ?). Utile pour le travail final.

---

## 7. Fin de séance

- **Travail de mi-session** : la diapo reprend **uniquement** la liste du
  plan de cours (20 %, 25 octobre à 23h59). Les consignes détaillées ne
  sont pas encore écrites (issue `pol-u2z.3`). Le point 3, « une hypothèse
  et son hypothèse nulle », est marqué « aujourd'hui ».
- **Trois choses avant le 15 octobre** : l'examen 1 à remettre dimanche 4
  octobre à 23h59, les rencontres individuelles du 8 octobre (pas de
  cours, lien de prise de rendez-vous), le chapitre Datacamp de la séance
  5.

---

## 8. Questions probables et réponses courtes

**« Si on connaît la vraie moyenne, pourquoi faire un échantillon ? »**
Dans la vraie vie, on ne la connaît pas. Aujourd'hui, on triche exprès
pour vérifier que la méthode fonctionne.

**« Pourquoi 50 personnes ? »** Pour l'exemple, et parce que c'est le n de
la pomicultrice. Un vrai sondage en a souvent 1 000 ou plus.

**« Un sondage de 1 000 personnes peut-il représenter 30 millions de
Canadien.ne.s ? »** Oui, si le tirage est aléatoire : l'erreur type dépend
de la taille de l'**échantillon**, pas de celle de la population (tant que
la population est beaucoup plus grande). Une cuillère de soupe bien
brassée suffit, que la marmite soit petite ou grande.

**« C'est quoi la différence entre écart type et erreur type ? »** L'écart
type décrit les **personnes** (séance 3). L'erreur type décrit les
**moyennes**, d'un échantillon à l'autre. L'erreur type = l'écart type ÷
√n.

**« Si p = 0,06, il n'y a pas d'effet ? »** Non. On n'a pas assez de
preuves pour rejeter H0 au seuil de 5 %. 0,049 et 0,051 disent presque la
même chose.

**« Pourquoi pas un seuil de 0,01 ? »** On peut. C'est une convention. Un
seuil plus sévère réduit les erreurs de type 1 mais augmente les erreurs
de type 2.

**« Pourquoi 95 % ? »** Parce que le seuil est 0,05 (1 − 0,05 = 0,95).
Un intervalle à 99 % va avec un seuil de 0,01 (p. 72).

**« Un résultat significatif, c'est vrai ? »** Pas forcément : quand H0
est vraie, on obtient quand même p < 0,05 une fois sur vingt (l'erreur de
type 1). Et significatif ne veut dire ni important ni causal.

**« On peut accepter H0 ? »** Jamais. On la rejette ou on ne la rejette
pas (p. 75).

---

## 9. Glossaire français-anglais

Pour les étudiant.e.s qui cherchent de l'aide en ligne ou lisent une
sortie de R.

| Français | English |
|---|---|
| population | population |
| échantillon aléatoire simple | simple random sample |
| paramètre | parameter |
| estimateur, estimé | estimator, estimate |
| biais | bias |
| variance échantillonnale | sampling variance |
| distribution d'échantillonnage | sampling distribution |
| erreur type | standard error (SE) |
| loi des grands nombres | law of large numbers |
| hypothèse nulle (H0) | null hypothesis |
| statistique t | t statistic |
| valeur p | p-value |
| seuil de signification | significance level (alpha) |
| statistiquement significatif | statistically significant |
| intervalle de confiance | confidence interval |
| erreur de type 1, de type 2 | type I error, type II error |
| degrés de liberté | degrees of freedom (df) |

---

## 10. D'où vient chaque chiffre

Tout est produit par `deck/outils/seance5_data.R` (graines fixées :
`set.seed(1)` à `set.seed(13)`), qui écrit `deck/src/lib/data/seance5.js`
et les images `deck/static/img/s5-*.png`. Pour tout refaire :

```bash
cd deck
CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_data.R
```

Trois exceptions, faute de jeu de données, documentées dans l'en-tête du
script : la pomicultrice (n, moyenne, variance du livre), le *Literary
Digest* (Squire 1988, vérifié dans l'article) et les deux études de la
p. 76 du livre.

Le script des étudiant.e.s (`seance5.R`, sur les diapos « Le script
entier ») a été exécuté de bout en bout dans R 4.6.1 avec ggplot2 4.0.3,
y compris le bloc de secours pour qui n'a pas `ces2025_clean.rds`.

## Sources

- Arel-Bundock, Vincent. 2021. *Analyse causale et méthodes quantitatives :
  une introduction avec R, Stata et SPSS*. Presses de l'Université de
  Montréal. Chapitre 4, p. 61-76. PDF gratuit sur le site des PUM.
- Bertrand, Marianne, et Sendhil Mullainathan. 2004. « Are Emily and Greg
  More Employable Than Lakisha and Jamal? » *American Economic Review*
  94 (4) : 991-1013.
- King, Gary, Robert O. Keohane et Sidney Verba. 1994. *Designing Social
  Inquiry*. Princeton University Press.
- Sevi, Semra, Vincent Arel-Bundock et André Blais. 2019. « Do Women Get
  Fewer Votes? No. » *Revue canadienne de science politique* 52 (1) :
  201-210.
- Squire, Peverill. 1988. « Why the 1936 Literary Digest Poll Failed ».
  *Public Opinion Quarterly* 52 (1) : 125-133.
- Wasserstein, Ronald L., et Nicole A. Lazar. 2016. « The ASA Statement on
  p-Values: Context, Process, and Purpose ». *The American Statistician*
  70 (2) : 129-133.
- Wickham, Hadley. 2010. « A Layered Grammar of Graphics ». *Journal of
  Computational and Graphical Statistics* 19 (1) : 3-28.
- Wickham, Hadley, Mine Çetinkaya-Rundel et Garrett Grolemund. 2023.
  *R for Data Science*, 2e éd. O'Reilly.
- Étude électorale canadienne 2025, codebook, p. 9-10 (plan
  d'échantillonnage et pondération).
