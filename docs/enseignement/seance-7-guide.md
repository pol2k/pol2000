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

- **Y** = `note_carney`, le thermomètre de Mark Carney (0 à 100,
  `cps25_lead_rating_23`). **X** = `gauche_droite`, l'autopositionnement
  (0 à 10, `cps25_lr_scale_bef_1`). Le code -99 devient NA.
- **La population d'exercice** : les 20 180 répondant.e.s de la CES 2025,
  comme à la séance 5. On y connaît la vraie droite :
  **constante 81,8, pente −5,27** (15 993 personnes ont répondu aux deux
  questions, R² = 0,145).
- **Notre sondage** : 1 000 personnes tirées parmi les 20 180 (graine 62,
  la même qu'à la séance 5). R garde les 783 qui ont répondu aux deux
  questions : **constante 79,81, pente −5,05, erreur type 0,45,
  t = −11,23, p ≈ 3 × 10⁻²⁷ (R imprime `<2e-16`), IC à 95 % de −5,93 à
  −4,17, R² = 0,139**.
- Les diapos 13 à 16 utilisent la population (−5,27); à partir de
  « Jouer avec la droite », c'est notre sondage (−5,05). À dire à voix
  haute : « dans la vraie vie, on n'a qu'un sondage ».
- Pourquoi Carney et pas Poilievre : pour Poilievre, la constante tombe à
  −5,8, une note impossible sur 0 à 100. Celle de Carney (81,8) est une
  note qui existe.
- Tout vient de `deck/outils/seance7_data.R` (→ `seance7.js`), plus
  `seance7_b.R`, `seance7_d.R`, `seance7_e.R` (fictif), `seance7_f.R`,
  `seance7_g.R`. Depuis `deck/` :
  `CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R`, puis les
  autres (`seance7_d.R`, `_f.R` et `_g.R` vérifient leurs tirages contre
  `seance7.js` et s'arrêtent s'ils divergent).

## 1. L'examen 1 (diapo à compléter)

Les trois cases « Ce qui a bien été », « Les pièges fréquents », « Votre
note » disent **[à compléter par le prof]**. Les remplir dans le tableau
`CASES` de `deck/src/lib/deck/visuels/TmExamen1.svelte`. Rien sur les
notes elles-mêmes : le dépôt est public.

## 2. Le travail de mi-session

- Les sept étapes suivent les consignes (`travaux/pdf/`). Une barre en haut
  de chaque diapo d'étape montre où on est.
- **H1 et H0** : H1 est ce que la théorie prédit (plus à droite, moins de
  sympathie pour Carney). H0 : aucune relation. On ne prouve jamais H1, on
  se demande si les données permettent de rejeter H0. Plus tard dans la
  séance, H0 devient « la pente vaut 0 », β1 = 0. Les consignes exigent
  les deux.
- **Le niveau de mesure** : avec un Y nominal (le parti, oui/non), « Y
  monte de β1 par unité de X » n'a pas de sens. La règle vise Y. X peut
  être nominale (à confirmer).
- **Évalué par les pairs** : d'autres spécialistes lisent l'article avant
  sa publication. Google Scholar mélange tout : regarder où c'est publié.
  « Cité par N » mesure l'influence, mais un article récent n'a pas eu le
  temps d'être cité, d'où « beaucoup cité, **ou** récent ».
- **APA** : (Nom, année) dans le texte. En bibliographie : Nom, I.
  (année). Titre. *Revue*, volume(numéro), pages. DOI s'il y en a un.
- **La question fait la variable** : le libellé français officiel est tiré
  du codebook (p. 73 et 77). Note réelle du codebook : pendant une partie
  de la campagne, la version française affichait « [new Liberal leader] »
  au lieu de « Mark Carney ». Le codebook écrit « Où placeriez-vous sur une
  échelle… » (sans « vous »); la diapo le reprend tel quel.
- Le code -99 (« Je ne connais pas », « Pas certain(e) ») n'est pas une
  note : laissé tel quel, il tire la moyenne et la droite vers le bas.

## 3. La droite

- **Les moindres carrés.** Pour chaque personne, l'écart vertical entre sa
  note et la droite, mis au carré, puis additionné :
  Σ(y − β0 − β1x)². R choisit la seule droite qui rend cette somme la plus
  petite. Le carré fait compter les écarts au-dessus et au-dessous, et
  pèse lourd sur les grosses erreurs. Sur les 15 répondant.e.s de « Comment
  ça marche ? » : 20 625 (droite montante), 11 254 (la moyenne), 9 366 (la
  droite de R). Sur « Jouer avec la droite », avec les 783 : la moyenne
  donne 843 798, la droite de R 726 559.
- **Le R² se cache dans ce compteur** : 1 − 726 559 / 843 798 = 0,1389,
  exactement le R² de R. C'est la part de la distance de la ligne plate
  que la meilleure droite fait disparaître.
- **Corrélation et régression.** r = −0,38 : sens et force, sans unité,
  symétrique. La pente = r × (écart type de y / écart type de x) : la même
  information, convertie en points de note par cran. Avec un seul x,
  R² = r² (0,38² ≈ 0,145). La corrélation n'avait pas été enseignée à la
  séance 3 : c'est sa première vraie apparition.
- **Lire la pente.** On compare des personnes différentes, à un cran
  d'écart : ce n'est pas une personne qui change d'idée. « Est associé à »,
  pas « cause ». Si on demande « vraiment 5 points à chaque cran ? » : en
  moyenne, le long d'une droite. Les vraies moyennes par cran sont plates
  de 0 à 4, puis chutent (de 4 à 5 : −15). La droite résume, elle ne colle
  pas.
- **La constante** (79,8) : la note que la droite prédit à 0. Les gens à 0
  dans notre sondage ont en moyenne 63,0 (n = 37). C'est souvent une
  extrapolation, rarement intéressante en soi.
- **Le code** : la diapo montre `lm(y ~ x, data = df)` plutôt que
  `lm(df$y ~ df$x, data = df)`. Avec `data =`, les `df$` sont redondants,
  et ils cassent `predict()` plus tard.

## 4. Le hasard et le biais

- **La vraie droite** (−5,27) n'est connue ici que parce que la CES joue
  la population. Notre sondage donne −5,05 : proche, pas pareil.
- **Recommencer 1 000 fois au hasard** : les pentes forment une cloche
  centrée sur −5,26. C'est le hasard (la variance). **1 000 fois au Québec
  seulement** : une cloche aussi nette, centrée sur −2,43. C'est le biais,
  et plus de sondages ne le corrigent pas. −2,43 est la bonne pente *pour
  le Québec* et la mauvaise *pour le Canada* : le biais se mesure toujours
  par rapport à la population qu'on veut décrire.
- **ε** est tout ce qui fait bouger la note à part la position
  gauche-droite. Dans les 20 180, ε ne penche pas avec x (c'est ainsi que
  R choisit la droite). Chez les Québécois.e.s, ε monte avec x : à gauche
  (Bloc, QS), on note Carney sous la droite, à droite au-dessus. Cette
  pente cachée aplatit la droite du Québec.
- Exactement : pente d'un sondage − vraie pente = pente de son ε contre x.
  Notre sondage rate de 0,22 parce que son ε penche un peu, par hasard.
  Le hasard penche un peu, chaque fois dans un sens différent. Le biais
  penche toujours du même côté.

## 5. La variable confondante (crème glacée, données fictives)

- 240 mois inventés (`outils/seance7_e.R`, graine 7). La chaleur fait
  vendre de la crème glacée et fait se baigner, donc se noyer. La crème
  glacée n'a **aucun** effet. Pente naïve : +8,4 noyades par million de
  cornets (R² 0,79). Dans chaque tranche de température : +0,2, −0,4,
  +0,7. Avec la chaleur dans le modèle : 0,06 (p = 0,82).
- **La supposition** : rien dans ε ne fait aussi bouger x (X ⊥ ε,
  Arel-Bundock éq. 5.4). La chaleur est dans ε et pousse x : la
  supposition tombe, β1 est biaisé. C'est une **relation fallacieuse**.
- **Pourquoi ε est « théorique »** : les résidus que R calcule ne sont
  jamais corrélés avec x, par construction (Arel-Bundock, note 5 p. 84).
  On ne peut donc pas vérifier la supposition en regardant les résidus.
  Seul le raisonnement (dessiner le graphe) dit ce qui peut s'y cacher.
  C'est la séance 11.
- D'où vient le 8,4 : pente naïve = pente à chaleur égale + (effet de la
  chaleur sur les noyades × δ), où δ est la pente de `lm(temperature ~
  cremes)` = 4,16. 0,06 + 2,00 × 4,16 = 8,37. C'est la formule du biais de
  variable omise. Pour les notes seulement.
- Vocabulaire : Arel-Bundock dit « biais par variable omise »,
  « tiers facteur », « relations fallacieuses ». La diapo dit « variable
  confondante » une fois. À harmoniser avec la séance 8 si désiré.
- La dernière diapo (« Et dans notre sondage ? ») pose une question sans
  affirmer : qu'est-ce qui pourrait pousser à la fois la position
  gauche-droite et la note de Carney (l'âge, la région, la scolarité, la
  partisanerie) ? Aucune affirmation sur un biais de −5,05.

## 6. L'erreur type

- **Définition à dire** : la distance typique entre la pente d'un sondage
  et la vraie pente. Même idée qu'à la séance 5 (« l'écart type = la
  distance typique »), appliquée aux pentes de 1 000 sondages : 0,47.
- **Les trois ingrédients**, sur la même échelle :
  - moins de monde : 100 personnes au lieu de 1 000, 1,54;
  - de grosses erreurs de prédiction : chaque écart à la droite doublé
    (rangée fictive, ainsi étiquetée), 0,94, exactement 2 × 0,47;
  - X qui varie peu : seulement les gens de 4 à 6, 1,19 (une règle tenue
    près du milieu bascule facilement). Cette cloche est centrée sur −8,86
    parce que la note chute entre 4 et 5 : on compare les largeurs.
- **Un seul sondage suffit** : R estime 0,45 à partir de notre seul
  sondage, presque l'écart type des 1 000 sondages (0,47). Formule :
  ET(β1) ≈ σ / (écart type de x × √n) = 30,5 / (2,425 × √782) ≈ 0,450.
  n sous une racine (quatre fois plus de monde, deux fois moins
  d'erreur, comme la marge d'erreur de la séance 5), σ en haut, la
  dispersion de x en bas.

## 7. t, p, l'intervalle

- **Le monde où H0 est vraie** : on garde la note de chacun et on mélange
  les positions gauche-droite entre les 783 personnes. Le lien disparaît,
  tout le reste reste (un test de permutation). 1 000 mélanges : une
  cloche autour de 0 (théorème central limite), large d'environ 0,48.
  Aucun mélange n'arrive à −5,05.
- **t = β1 / ET** = −5,05 / 0,45 ≈ −11,2 (R : −11,23). « Notre pente est à
  11 erreurs types de 0. » Au-delà d'environ 2 : rare si H0 était vraie.
  Le panier de pommes de la séance 5 était à 2,04 (5 g / 2,46 g).
- **p** : si H0 était vraie, combien de fois verrait-on une pente au moins
  aussi loin de 0, des deux côtés ? Notre sondage : 0 mélange sur 1 000
  (p < 0,001). **Le petit sondage de 50** (R en garde 37) : pente −4,22,
  92 mélanges sur 1 000, R donne p = 0,086 : on ne rejette pas H0. Or la
  vraie pente est −5,27 : H0 est fausse et on ne l'a pas rejetée,
  « acquittée, pas innocente ».
- Jamais « la probabilité que H0 soit vraie » : p se calcule en supposant
  H0 vraie.
- **Les étoiles** : * p < 0,05, ** p < 0,01, *** p < 0,001 (« . » < 0,1
  dans R, rarement dans les articles). Le seuil de 0,05 est une
  convention (Fisher, 1926).
- **L'intervalle** ≈ β1 ± 1,96 × ET = −5,05 ± 0,88 (R : `confint`, avec
  `qt(0.975, 781)`). Le 95 % décrit la méthode : 19 intervalles sur 20
  attrapent la vraie pente. Jamais « 95 % de chances ». Un intervalle qui
  exclut 0 va avec p < 0,05 : c'est le même test, lu sur l'axe.
- Le « un seul raté sur 20 » de « 19 fois sur 20 » vient d'une graine
  cherchée pour ça (71), comme à la séance 5. D'autres tirages en donnent
  0, 2 ou 3.
- Écart avec pol-vjv : l'issue dit « environ 2 fois sur 100 » pour le
  panier, mais le deck de la séance 5 affiche « environ 3 fois sur 100 »
  (27/1 000). La diapo reprend 3.

## 8. Le tableau de régression

- **R imprime, l'article publie** : les mêmes chiffres. Ce que l'article
  laisse de côté : Call, Residuals, t value, l'erreur type résiduelle, le
  R² ajusté, le F.
- **N = 783** : R retire en silence toute ligne qui a un NA en y ou en x
  (« 217 observations deleted due to missingness ») : 112 sans position,
  54 sans note, 51 ni l'une ni l'autre. Toujours vérifier N.
- **R² = 0,14** : la part de la variation de la note que la droite suit.
  Ordinaire pour une attitude qui en prédit une autre. Ce n'est pas une
  note de qualité : la pente reste très claire (t = −11).
- **R² ajusté** (0,1378) : une petite pénalité par variable ajoutée. Utile
  la semaine prochaine (0,1777 contre 0,1723 au modèle 2).
- **Erreur type résiduelle** (30,5 sur 781 degrés de liberté) : la droite
  rate une personne d'environ 30 points. 781 = 783 − 2 coefficients.
- **F** (126) : teste « toutes les pentes = 0 à la fois ». Avec un seul x,
  F = t² (11,23² ≈ 126). Rien de plus aujourd'hui : à garder pour la
  séance 8.
- **Résidus** : la médiane est +5,3, pas 0, parce que les notes
  s'empilent à 0 et à 100.
- **Modèle 2** (aperçu) : 772 personnes, pas 783 (des NA de plus). Le
  passage de −5,05 à −5,30 n'est donc pas une comparaison pure. Le point :
  le coefficient de gauche-droite bouge à peine.

## 9. Le graphique des coefficients

- Le même contenu que le tableau, une rangée par variable. Le point = le
  coefficient, la moustache = l'IC à 95 %, la ligne à 0 = H0. Une
  moustache qui croise 0 : p > 0,05 (femme p = 0,82, Québec p = 0,32).
  Largeur = précision.
- **Les unités** : chaque point est « des points de note par unité de x »,
  mais l'unité change (un cran sur 0 à 10, dix ans, un 0/1). Diplôme
  (+9,1) n'est pas « plus fort » que gauche-droite (−5,3) : sur toute
  l'échelle, gauche-droite fait bouger la note d'environ 53 points.
- Pour le faire dans R (sortie réelle vérifiée) :

  ```r
  library(broom); library(ggplot2); library(dplyr)
  ces1000$age10 <- ces1000$age / 10
  modele <- lm(note_carney ~ gauche_droite + age10 + femme + quebec + universitaire, data = ces1000)
  coefs <- tidy(modele, conf.int = TRUE) |> filter(term != "(Intercept)")
  ggplot(coefs, aes(x = estimate, y = term, xmin = conf.low, xmax = conf.high)) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_pointrange() +
    labs(x = "Effet sur la note de Carney (points)", y = NULL)
  ```

  ggplot range les variables par ordre alphabétique de bas en haut. Pour
  garder l'ordre du tableau, ajouter
  `mutate(term = factor(term, levels = rev(term)))` (non testé).
