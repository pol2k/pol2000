# Qui manque au modèle de notre sondage, et pourquoi (séance 7, « Lire un
# tableau », diapo N). Écrit src/lib/data/seance7_g.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_g.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Refait exactement notre sondage de outils/seance7_data.R (même
# préparation, set.seed(62), 1 000 tiré.e.s parmi les 20 180), puis classe
# les personnes que R écarte selon la PREMIÈRE raison qui s'applique :
#   1  n'a pas répondu au sondage post-électoral (pes25_startdate vide) :
#      les deux questions viennent de ce sondage;
#   2  y a répondu, mais la question sur le populisme ne lui a pas été posée
#      (pes25_populism_8 vide : elle n'est posée qu'à une partie du sondage);
#   3  « Je ne sais pas / Préfère ne pas répondre » à l'une des deux questions.
# Vérifie que les comptes collent à seance7.js (NOTRE : n_modele, manquants)
# et que le R² de summary() se retrouve à la main. Aucune valeur n'est écrite
# à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Les deux variables, comme dans outils/seance7_data.R.
ech <- function(v, k, inv = FALSE) {
  v <- as.numeric(v); v[!(v %in% 1:k)] <- NA
  z <- (v - 1) / (k - 1); if (inv) 1 - z else z
}
ces <- data.frame(
  satisfaction_dem = ech(d$pes25_dem_sat, 4, inv = TRUE),
  populisme = ech(d$pes25_populism_8, 5),
  # Pour la raison du manque : le sondage post-électoral, et la réponse brute.
  post = !is.na(d$pes25_startdate),
  pop_brut = as.numeric(d$pes25_populism_8)
)
stopifnot(nrow(ces) == 20180)

# Notre sondage : le même tirage que seance7_data.R (graine 62, aucun autre
# appel au hasard avant).
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
m <- lm(satisfaction_dem ~ populisme, data = ces1000)

sans_x <- is.na(ces1000$populisme); sans_y <- is.na(ces1000$satisfaction_dem)
garde <- !sans_x & !sans_y
pas_post <- !ces1000$post
pas_posee <- ces1000$post & is.na(ces1000$pop_brut)
statut <- ifelse(garde, 0L, ifelse(pas_post, 1L, ifelse(pas_posee, 2L, 3L)))

MANQUANTS <- list(
  n = nrow(ces1000),
  n_modele = nobs(m),
  pas_post = sum(statut == 1),
  pas_posee = sum(statut == 2),
  ne_sait_pas = sum(statut == 3),
  # Rang (1 à 1 000) dans le tirage : 0 dans le modèle, 1 pas de sondage
  # post-électoral, 2 question sur le populisme pas posée, 3 « je ne sais pas ».
  statut = statut
)

# Les vérifications : contre R, et contre seance7.js.
stopifnot(MANQUANTS$n_modele == sum(garde))
stopifnot(MANQUANTS$pas_post + MANQUANTS$pas_posee + MANQUANTS$ne_sait_pas == 1000 - MANQUANTS$n_modele)
# Les 3 raisons sont mutuellement exclusives et couvrent tout le monde.
stopifnot(all(statut[!garde] %in% 1:3), sum(statut == 0) == MANQUANTS$n_modele)
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"))
notre <- jsonlite::fromJSON(sub("^export const NOTRE = (.*);$", "\\1", grep("^export const NOTRE = ", js, value = TRUE)))
stopifnot(notre$n_modele == MANQUANTS$n_modele)
stopifnot(notre$manquants$x_seulement == sum(sans_x & !sans_y),
          notre$manquants$y_seulement == sum(sans_y & !sans_x),
          notre$manquants$les_deux == sum(sans_x & sans_y))
# Le R² à la main : 1 − (écarts à la droite)² / (écarts à la moyenne)².
y <- ces1000$satisfaction_dem[garde]
r2_main <- 1 - sum(resid(m)^2) / sum((y - mean(y))^2)
stopifnot(abs(r2_main - summary(m)$r.squared) < 1e-10, abs(round(r2_main, 4) - notre$r2) < 1e-9)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_g.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), notre sondage de 1 000 (graine 62, comme",
  "   outils/seance7_data.R), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Qui manque au modèle, selon la première raison : pas de sondage post-électoral,",
  "   question sur le populisme pas posée, « je ne sais pas » à l'une des deux.",
  "   statut[i] : 0 dans le modèle, 1, 2 ou 3 selon la raison. */",
  paste0("export const MANQUANTS = ", J(MANQUANTS), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_g.js"))

cat("n_modele =", MANQUANTS$n_modele, " pas post =", MANQUANTS$pas_post,
    " pas posée =", MANQUANTS$pas_posee, " ne sait pas =", MANQUANTS$ne_sait_pas,
    " | R2 main =", round(r2_main, 4), "\n")
