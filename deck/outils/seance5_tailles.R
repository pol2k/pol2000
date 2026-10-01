# « Une personne, une classe » et « Deux écarts types », séance 5 : deux
# sortes de variation. Une personne peut être petite ou grande, les gens
# varient beaucoup. Mais la taille moyenne d'une classe de 50 personnes tirées
# au hasard bouge à peine : les grands et les petits s'annulent. Exporte
# src/lib/data/seance5_tailles.js. Rien n'est tapé à la main. Depuis deck/ :
#
#   Rscript outils/seance5_tailles.R
#
# Source : l'enquête NHANES (États-Unis, 2009 à 2012), par le paquet R
# NHANES. Les adultes de 20 ans et plus dont la taille est mesurée, une
# ligne par personne (ID), hommes et femmes ensemble : la même population
# que la carte « adultes » de outils/seance5_normale.R. Taille en cm.
#
# Ce qui est exporté :
#   - POPULATION : n, moyenne, écart type, plus petite et plus grande taille,
#     et l'histogramme en tranches de 2 cm, [a, a + 2), de 134 à 202 cm;
#   - PERSONNES : six adultes tirés au hasard (leur taille);
#   - CLASSE : une « classe » de 50 adultes tirés au hasard, sans remise
#     (les 50 tailles et leur moyenne);
#   - CLASSES : 1 000 classes de 50, tirées de la même façon. Leurs moyennes
#     en tranches de 0,5 cm, [a, a + 0,5), bornes sur la même grille que la
#     population (multiples de 0,5 cm), leur écart type, leur plus petite et
#     leur plus grande moyenne.
#
# Le hasard est fixé (set.seed) bloc par bloc : la même commande redonne les
# mêmes chiffres. La graine des six personnes (5) a été choisie parmi
# quelques essais (1, 5, 50, 55, 2026) pour que les six figures ne se
# chevauchent pas à l'écran : c'est un vrai tirage au hasard, mais pas le
# premier essayé. Les autres graines (50 et 55) sont celles du premier essai.
#
# Le paquet NHANES doit être installé : install.packages("NHANES").
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))

nh <- NHANES::NHANES
nh <- nh[nh$Age >= 20 & !is.na(nh$Height) & !duplicated(nh$ID), ]
taille <- nh$Height

# Effectifs par tranche [a, a + largeur).
compter <- function(x, de, a, largeur) {
  bornes <- seq(de, a, by = largeur)
  list(bornes = bornes,
       effectifs = as.integer(table(cut(x, bornes, right = FALSE))))
}

# ---- 1. La population : les 4 613 adultes (ou ce que donne le filtre).
POPULATION <- c(list(n = length(taille), moyenne = mean(taille), ecartType = sd(taille),
                     min = min(taille), max = max(taille)),
                compter(taille, 134, 202, 2))
stopifnot(sum(POPULATION$effectifs) == POPULATION$n)

# ---- 2. Six personnes, tirées au hasard.
set.seed(5)
PERSONNES <- sample(taille, 6)

# ---- 3. Une classe de 50, tirée au hasard (sans remise).
set.seed(50)
une <- sample(taille, 50)
CLASSE <- list(n = 50, tailles = une, moyenne = mean(une))

# ---- 4. 1 000 classes de 50 : 1 000 moyennes.
set.seed(55)
moyennes <- replicate(1000, mean(sample(taille, 50)))
de <- floor(min(moyennes) * 2) / 2
a <- ceiling(max(moyennes) * 2) / 2
if (a == max(moyennes)) a <- a + 0.5
CLASSES <- c(list(nombre = 1000, n = 50, moyenne = mean(moyennes), ecartType = sd(moyennes),
                  min = min(moyennes), max = max(moyennes)),
             compter(moyennes, de, a, 0.5))
stopifnot(sum(CLASSES$effectifs) == 1000)

cat(sprintf("population : n = %d, moyenne = %.2f, écart type = %.2f, de %.1f à %.1f\n",
            POPULATION$n, POPULATION$moyenne, POPULATION$ecartType, POPULATION$min, POPULATION$max))
cat("six personnes :", PERSONNES, "\n")
cat(sprintf("une classe : moyenne = %.2f\n", CLASSE$moyenne))
cat(sprintf("1 000 classes : moyenne = %.2f, écart type = %.3f, de %.2f à %.2f\n",
            CLASSES$moyenne, CLASSES$ecartType, CLASSES$min, CLASSES$max))

# ---- Export.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_tailles.R. Source : NHANES (États-Unis, 2009 à 2012), paquet R",
  "   NHANES, adultes de 20 ans et plus, une ligne par personne, taille en cm. Aucune valeur ici",
  "   n'est écrite à la main. */",
  "",
  "/* Les adultes : n, moyenne, écart type, extrêmes, et l'histogramme en tranches de 2 cm, [a, a + 2). */",
  paste0("export const POPULATION = ", J(POPULATION), ";"),
  "/* Six adultes tirés au hasard (set.seed(5)) : leur taille. */",
  paste0("export const PERSONNES = ", J(PERSONNES), ";"),
  "/* Une classe de 50 adultes tirés au hasard (set.seed(50)) : les 50 tailles et leur moyenne. */",
  paste0("export const CLASSE = ", J(CLASSE), ";"),
  "/* 1 000 classes de 50 (set.seed(55)) : leurs moyennes en tranches de 0,5 cm, leur écart type. */",
  paste0("export const CLASSES = ", J(CLASSES), ";")
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_tailles.js"))
cat("ok\n")
