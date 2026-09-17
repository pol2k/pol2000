#!/usr/bin/env Rscript
# Séance 3, « L'écart type » : ce que le nombre dit de vraies personnes.
# L'âge (cps25_age_in_years) de l'Étude électorale canadienne 2025 : la moyenne,
# l'écart type (sd()), la bande d'un écart type de chaque côté de la moyenne, et
# la part des répondant.e.s dont l'âge tombe dans cette bande. Rien n'est tapé
# à la main.
#
# Le script vérifie que n, la moyenne et l'écart type sont bien ceux que la
# séance publie déjà dans src/lib/data/seance3.js (AGE.n, AGE.moyenne, AGE.et),
# à deux décimales, et s'arrête sinon.
#
# L'âge est un nombre entier d'années : la phrase de la diapositive (« entre a et
# b ans ») nomme donc le plus jeune et le plus vieil âge entier DANS la bande
# (ageMin, ageMax), et non les bornes arrondies. Arrondir 32,18 à 32 ferait
# entrer les 32 ans, qui sont hors de la bande, et la part affichée deviendrait
# fausse. Le script vérifie que la part entre ageMin et ageMax est exactement la
# part à moins d'un écart type.
#
# Usage, depuis deck/ :
#   CES2025_RDS=/chemin/vers/ces2025.rds Rscript outils/seance3_ecart.R
# Écrit : src/lib/data/seance3_ecart.js

suppressPackageStartupMessages(library(jsonlite))

rds <- Sys.getenv("CES2025_RDS")
if (!nzchar(rds) || !file.exists(rds)) stop("CES2025_RDS doit pointer vers le .rds de l'ÉÉC 2025.")
ces <- readRDS(rds)

# unclass() : la colonne est un haven_labelled ; on en garde les valeurs brutes,
# sans dépendre du paquet haven.
age <- as.numeric(unclass(ces$cps25_age_in_years))
age <- age[!is.na(age)]

m <- mean(age)
s <- sd(age)
part <- mean(abs(age - m) <= s)

# --- Contre-vérification avec ce que la séance publie déjà -----------------
publie <- paste(readLines(file.path("src", "lib", "data", "seance3.js"), warn = FALSE), collapse = "\n")
ligne <- regmatches(publie, regexpr("export const AGE = \\{[^}]*\\}", publie))
if (length(ligne) != 1) stop("AGE introuvable dans src/lib/data/seance3.js.")
champ <- function(nom) as.numeric(sub(paste0(".*\\b", nom, ": *([0-9.]+).*"), "\\1", ligne))
if (length(age) != champ("n"))
  stop("n (", length(age), ") ne concorde pas avec AGE.n (", champ("n"), ").")
if (!isTRUE(all.equal(round(m, 2), champ("moyenne"))))
  stop("La moyenne (", round(m, 2), ") ne concorde pas avec AGE.moyenne (", champ("moyenne"), ").")
if (!isTRUE(all.equal(round(s, 2), champ("et"))))
  stop("L'écart type (", round(s, 2), ") ne concorde pas avec AGE.et (", champ("et"), ").")

# --- La phrase affichée : les âges entiers dans la bande -------------------
age_min <- ceiling(m - s)
age_max <- floor(m + s)
stopifnot(all(age == round(age)))
if (!isTRUE(all.equal(part, mean(age >= age_min & age <= age_max))))
  stop("La part entre ageMin et ageMax n'est pas la part à moins d'un écart type.")

res <- list(
  n = length(age),
  moyenne = round(m, 2),
  et = round(s, 2),
  bas = round(m - s, 2),
  haut = round(m + s, 2),
  ageMin = age_min,
  ageMax = age_max,
  partDansUnEt = round(part, 4)
)
print(unlist(res))

cible <- file.path("src", "lib", "data", "seance3_ecart.js")
writeLines(c(
  "// GÉNÉRÉ par outils/seance3_ecart.R : ne pas modifier à la main.",
  "// Étude électorale canadienne 2025, âge (cps25_age_in_years), valeurs manquantes",
  "// écartées : moyenne, écart type (sd()), bornes moyenne - et et moyenne + et, et",
  "// part des répondant.e.s dont l'âge est à moins d'un écart type de la moyenne,",
  "// mean(abs(age - m) <= s), en proportion de 0 à 1. ageMin et ageMax : le plus",
  "// jeune et le plus vieil âge entier dans la bande (la part est exactement celle",
  "// des répondant.e.s de ageMin à ageMax ans).",
  paste0("export const ECART = ", toJSON(res, auto_unbox = TRUE, pretty = TRUE, digits = NA), ";")
), cible)
cat("écrit :", cible, "\n")
