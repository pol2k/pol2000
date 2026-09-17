#!/usr/bin/env Rscript
# Séance 3, « L'âge, parti par parti » : un diagramme à barres groupées
# (geom_bar, fill, position = "dodge") de l'intention de vote selon le groupe
# d'âge, Étude électorale canadienne 2025. Rien n'est tapé à la main.
#
# L'âge (cps25_age_in_years) devient une variable catégorielle avec cut() :
# 18-34, 35-54, 55 et plus. L'intention de vote (cps25_votechoice) garde les
# cinq partis que la séance montre déjà (codes 1 à 5) ; « un autre parti »
# (code 6) et le Parti populaire (code 8) sont réunis dans « Autre ». Le
# code 7 (« ne sait pas / préfère ne pas répondre ») et les valeurs
# manquantes sont écartés.
#
# Le code exporté (BARRES.code) est celui que la diapositive affiche. Le script
# l'exécute tel quel sur le tableau df, enregistre le graphique dans un fichier
# temporaire, puis vérifie que les hauteurs des barres calculées par ggplot2
# sont bien les effectifs exportés.
#
# Usage, depuis deck/ :
#   CES2025_RDS=/chemin/vers/ces2025.rds Rscript outils/seance3_barres.R
# Écrit : src/lib/data/seance3_barres.js

suppressPackageStartupMessages({ library(ggplot2); library(jsonlite) })

rds <- Sys.getenv("CES2025_RDS")
if (!nzchar(rds) || !file.exists(rds)) stop("CES2025_RDS doit pointer vers le .rds de l'ÉÉC 2025.")
ces <- readRDS(rds)

# --- Le tableau de l'étudiant.e : deux variables catégorielles -------------
GROUPES <- c("18-34", "35-54", "55 et plus")
PARTIS <- c("Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre")
# Codes de cps25_votechoice, dans l'ordre 1 à 8 ; le code 7 devient NA.
CODES <- c("Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre", NA, "Autre")

# Le code de préparation, exécuté tel quel lui aussi.
preparation <- 'df$groupe_age <- cut(df$age, breaks = c(18, 35, 55, Inf), right = FALSE,
                     labels = c("18-34", "35-54", "55 et plus"))'

# unclass() : les colonnes sont des haven_labelled ; on en garde les codes bruts,
# sans dépendre du paquet haven.
vote <- as.numeric(unclass(ces$cps25_votechoice))
df <- data.frame(
  age = as.numeric(unclass(ces$cps25_age_in_years)),
  parti = factor(CODES[vote], levels = PARTIS)
)
ecartes <- list(ne_sait_pas = sum(vote == 7, na.rm = TRUE), manquants = sum(is.na(vote)))
df <- df[!is.na(df$parti) & !is.na(df$age), ]
eval(parse(text = preparation))
stopifnot(identical(levels(df$groupe_age), GROUPES), !anyNA(df$groupe_age))

# --- Le code de la diapositive, exécuté pour vrai --------------------------
code <- 'ggplot(df, aes(x = groupe_age, fill = parti)) +
  geom_bar(position = "dodge")'
g <- eval(parse(text = code))
png <- tempfile(fileext = ".png")
ggsave(png, g, width = 8, height = 4.5, dpi = 100)
stopifnot(file.exists(png), file.size(png) > 0)
cat("graphique de preuve :", png, "\n")

# --- Effectifs, totaux, pourcentages dans chaque groupe --------------------
tab <- table(df$groupe_age, df$parti)
totaux <- rowSums(tab)
pct <- round(100 * tab / totaux, 1)

# Les barres que ggplot2 dessine ont exactement ces hauteurs.
couche <- layer_data(g)
couche <- couche[order(couche$x, couche$group), ]
stopifnot(all(couche$count == as.vector(t(tab))))

print(addmargins(tab, 2))
print(pct)

res <- list(
  r = R.version.string,
  ggplot2 = as.character(packageVersion("ggplot2")),
  n = nrow(df),
  ecartes = ecartes,
  partis = PARTIS,
  preparation = preparation,
  code = code,
  groupes = lapply(GROUPES, function(gr) list(
    nom = gr,
    total = unname(totaux[gr]),
    effectifs = as.integer(tab[gr, ]),
    pourcentages = as.numeric(pct[gr, ])
  ))
)

cible <- file.path("src", "lib", "data", "seance3_barres.js")
writeLines(c(
  "// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.",
  "// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon",
  "// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6",
  "// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les",
  "// valeurs manquantes sont écartés. effectifs et pourcentages suivent l'ordre de",
  "// partis ; les pourcentages sont calculés dans chaque groupe d'âge.",
  paste0("export const BARRES = ", toJSON(res, auto_unbox = TRUE, pretty = TRUE), ";")
), cible)

unlink(png)
cat("écrit :", cible, "\n")
