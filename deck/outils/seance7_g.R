# Qui manque au modèle de notre sondage, et pourquoi (séance 7, « Lire un
# tableau », diapo N). Écrit src/lib/data/seance7_g.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_g.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Refait exactement notre sondage de outils/seance7_data.R (même
# préparation, set.seed(62), 1 000 tiré.e.s parmi les 20 180), puis dit
# pourquoi R écarte des lignes, à partir des codes bruts du codebook :
#   - cps25_interest_gen_1 = -99 : la case « Je ne sais pas / Préfère ne
#     pas répondre » du curseur (note du codebook, p. 45);
#   - cps25_education = 12 (ou absent) : « Je ne sais pas / Préfère ne pas
#     répondre » à la scolarité.
# Vérifie que les comptes collent à seance7.js (NOTRE : n_modele, manquants)
# et que le R² de summary() se retrouve à la main. Aucune valeur n'est écrite
# à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Les deux variables, comme dans outils/seance7_data.R, plus les codes bruts.
int_brut <- as.numeric(d$cps25_interest_gen_1)
edu_brut <- as.numeric(d$cps25_education)
int <- int_brut; int[!is.na(int) & int < 0] <- NA
edu <- edu_brut; edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
ces <- data.frame(
  interet = int / 10,
  scolarite = (niveau - 1) / 4,
  int_brut = int_brut,
  edu_brut = edu_brut
)
stopifnot(nrow(ces) == 20180)

# Notre sondage : le même tirage que seance7_data.R (graine 62, aucun autre
# appel au hasard avant).
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
m <- lm(interet ~ scolarite, data = ces1000)

sans_x <- is.na(ces1000$scolarite); sans_y <- is.na(ces1000$interet)
garde <- !sans_x & !sans_y
MANQUANTS <- list(
  n = nrow(ces1000),
  n_modele = nobs(m),
  # Intérêt : la case « je ne sais pas / préfère ne pas répondre » (-99).
  interet_nsp = sum(ces1000$int_brut %in% -99),
  # Intérêt : autre chose qu'un -99 (question sautée, valeur absente).
  interet_autre = sum(sans_y & !(ces1000$int_brut %in% -99)),
  # Scolarité : « je ne sais pas / préfère ne pas répondre » ou absente.
  scolarite = sum(sans_x),
  # Rang (1 à 1 000) dans le tirage : 0 dans le modèle, 1 intérêt manquant,
  # 2 scolarité manquante, 3 les deux.
  statut = as.integer(ifelse(garde, 0, ifelse(sans_y & sans_x, 3, ifelse(sans_y, 1, 2))))
)

# Les vérifications : contre R, et contre seance7.js.
stopifnot(MANQUANTS$n_modele == sum(garde), sum(MANQUANTS$statut == 0) == MANQUANTS$n_modele)
stopifnot(MANQUANTS$interet_nsp + MANQUANTS$interet_autre == sum(sans_y))
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"))
notre <- jsonlite::fromJSON(sub("^export const NOTRE = (.*);$", "\\1", grep("^export const NOTRE = ", js, value = TRUE)))
stopifnot(notre$n_modele == MANQUANTS$n_modele)
stopifnot(notre$manquants$x_seulement == sum(sans_x & !sans_y),
          notre$manquants$y_seulement == sum(sans_y & !sans_x),
          notre$manquants$les_deux == sum(sans_x & sans_y))
# R le dit lui-même dans summary() : « (19 observations deleted due to missingness) ».
summ <- paste(capture.output(print(summary(m))), collapse = "\n")
stopifnot(grepl(sprintf("(%d observations deleted", 1000 - MANQUANTS$n_modele), summ, fixed = TRUE))
# Le R² à la main : 1 − (écarts à la droite)² / (écarts à la moyenne)².
y <- ces1000$interet[garde]
r2_main <- 1 - sum(resid(m)^2) / sum((y - mean(y))^2)
stopifnot(abs(r2_main - summary(m)$r.squared) < 1e-10, abs(round(r2_main, 4) - notre$r2) < 1e-9)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_g.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), notre sondage de 1 000 (graine 62, comme",
  "   outils/seance7_data.R), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Qui manque au modèle et pourquoi, d'après les codes bruts du codebook.",
  "   interet_nsp : la case « je ne sais pas / préfère ne pas répondre » (-99).",
  "   statut[i] : 0 dans le modèle, 1 intérêt manquant, 2 scolarité manquante, 3 les deux. */",
  paste0("export const MANQUANTS = ", J(MANQUANTS), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_g.js"))

cat("n_modele =", MANQUANTS$n_modele, " intérêt -99 =", MANQUANTS$interet_nsp,
    " intérêt autre =", MANQUANTS$interet_autre, " scolarité =", MANQUANTS$scolarite,
    " | R2 main =", round(r2_main, 4), "\n")
