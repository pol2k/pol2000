# Les données du tableau de régression (séance 7, partie G), dans
# src/lib/data/seance7_g.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_g.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Refait exactement notre sondage de outils/seance7_data.R (même préparation,
# set.seed(62), 1 000 tiré.e.s parmi les 20 180) pour dire QUI manque au
# modèle : R garde 783 lignes, les 217 autres n'ont pas répondu à l'une des
# deux questions, ou aux deux. Aussi : la moyenne de la note chez les 783
# (la ligne plate de la diapo du R²) et la part de la variation suivie par la
# droite, recalculée à la main pour vérifier summary(). Aucune valeur n'est
# écrite à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Préparation copiée telle quelle de outils/seance7_data.R.
na99 <- function(v) { v <- as.numeric(v); v[!is.na(v) & v < 0] <- NA; v }
prov <- as.character(as_factor(d$cps25_province))
edu <- as.numeric(d$cps25_education)
genre <- as.numeric(d$cps25_genderid)
ces <- data.frame(
  note_carney = na99(d$cps25_lead_rating_23),
  gauche_droite = na99(d$cps25_lr_scale_bef_1),
  age = na99(d$cps25_age_in_years),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  quebec = as.numeric(grepl("Quebec", prov)),
  universitaire = ifelse(is.na(edu) | edu < 1 | edu > 11, NA, as.numeric(edu >= 8))
)
stopifnot(nrow(ces) == 20180)
tirer <- function(pool, n = 1000) pool[sample(nrow(pool), n), ]

set.seed(62)
ces1000 <- tirer(ces)
m <- lm(note_carney ~ gauche_droite, data = ces1000)

sans_note <- is.na(ces1000$note_carney)
sans_gd <- is.na(ces1000$gauche_droite)
MANQUANTS <- list(
  n = nrow(ces1000),
  n_modele = nobs(m),
  # Exclusifs : seulement la note manque, seulement la position, les deux.
  sans_note = sum(sans_note & !sans_gd),
  sans_position = sum(sans_gd & !sans_note),
  sans_les_deux = sum(sans_note & sans_gd),
  # Rang (1 à 1 000) de chaque personne dans le tirage, et son statut :
  # 0 = dans le modèle, 1 = pas de note, 2 = pas de position, 3 = ni l'une ni l'autre.
  statut = as.integer(ifelse(sans_note & sans_gd, 3, ifelse(sans_note, 1, ifelse(sans_gd, 2, 0))))
)
stopifnot(MANQUANTS$n_modele == 783)
stopifnot(MANQUANTS$sans_note + MANQUANTS$sans_position + MANQUANTS$sans_les_deux == 1000 - 783)

nous <- ces1000[!sans_note & !sans_gd, ]
y <- nous$note_carney
total <- sum((y - mean(y))^2)
reste <- sum(resid(m)^2)
R2 <- list(
  moyenne = round(mean(y), 2),
  ecart_type = round(sd(y), 2),
  sigma = round(summary(m)$sigma, 2),
  r2 = round(summary(m)$r.squared, 4),
  # La même chose à la main : 1 - (écarts à la droite)² / (écarts à la moyenne)².
  r2_main = round(1 - reste / total, 4)
)
stopifnot(abs(R2$r2 - R2$r2_main) < 1e-4)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_g.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), notre sondage de 1 000 (graine 62, comme",
  "   outils/seance7_data.R), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Qui manque au modèle : les 217 sans note de Carney, sans position, ou ni l'une",
  "   ni l'autre. statut[i] : 0 dans le modèle, 1 pas de note, 2 pas de position, 3 les deux. */",
  paste0("export const MANQUANTS = ", J(MANQUANTS), ";"),
  "/* La note chez les 783 : sa moyenne (la ligne plate), son écart type, l'écart type",
  "   autour de la droite (sigma) et le R² (vérifié à la main). */",
  paste0("export const R2 = ", J(R2), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_g.js"))

cat("n_modele =", MANQUANTS$n_modele, " sans note =", MANQUANTS$sans_note,
    " sans position =", MANQUANTS$sans_position, " les deux =", MANQUANTS$sans_les_deux, "\n")
cat("moyenne =", R2$moyenne, " sd =", R2$ecart_type, " sigma =", R2$sigma, " r2 =", R2$r2, R2$r2_main, "\n")
