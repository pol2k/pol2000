# Séance 7, partie F (t, valeur p, intervalle de confiance) : ce qui manque à
# src/lib/data/seance7.js pour ces diapos, dans src/lib/data/seance7_f.js.
# Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_f.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# On refait exactement les tirages d'outils/seance7_data.R (mêmes graines,
# même code), puis on vérifie qu'on retombe sur les mêmes nombres :
#   - notre sondage (graine 62), ses cas complets (`nous`);
#   - le premier mélange du monde où H0 est vraie (graine 7) : la position
#     gauche-droite de chaque personne de `nous` est remplacée par celle
#     d'une autre. On exporte les positions mélangées (dans l'ordre de
#     NOTRE.points) et la droite de R sur ces données mélangées;
#   - le petit sondage de 50 (graine 62), ajusté sous le nom ces50 pour que
#     la ligne « Call: » de R ait le style du cours.
# Puis la sortie de summary() et de confint(), telles que R les imprime.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# ---- Copié tel quel d'outils/seance7_data.R.
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
BUDGET <- 1000
r <- function(x, k = 4) round(x, k)
pente <- function(x) unname(coef(lm(note_carney ~ gauche_droite, data = x))[2])
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]

# ---- Notre sondage, et la vérification contre seance7.js.
set.seed(62)
ces1000 <- tirer(ces)
modele <- lm(note_carney ~ gauche_droite, data = ces1000)
nous <- ces1000[!is.na(ces1000$note_carney) & !is.na(ces1000$gauche_droite), ]
stopifnot(nrow(nous) == 783, abs(coef(modele)[[2]] - (-5.0484)) < 1e-4)

# ---- Le premier mélange (graine 7, premier tour du replicate de seance7_data.R).
set.seed(7)
z <- nous
z$gauche_droite <- sample(z$gauche_droite)
m_melange <- lm(note_carney ~ gauche_droite, data = z)
# Le premier des 1 000 mélanges de seance7_data.R : H0$notre$pentes[1].
set.seed(7)
h0 <- replicate(1000, { w <- nous; w$gauche_droite <- sample(w$gauche_droite); pente(w) })
stopifnot(abs(coef(m_melange)[[2]] - h0[1]) < 1e-12)
MELANGE <- list(
  # x mélangé, personne par personne, dans l'ordre de NOTRE.points (et de `nous`).
  x = z$gauche_droite,
  b0 = r(coef(m_melange)[[1]]), b1 = r(coef(m_melange)[[2]])
)

# ---- Le petit sondage de 50 (graine 62).
set.seed(62)
ces50 <- tirer(ces, 50)
modele50 <- lm(note_carney ~ gauche_droite, data = ces50)
stopifnot(nobs(modele50) == 37, abs(coef(modele50)[[2]] - (-4.2162)) < 1e-4)

# ---- Les sorties de R.
sortie <- function(x) paste(capture.output(print(x)), collapse = "\n")
SORTIES <- list(
  code_lm50 = "modele50 <- lm(note_carney ~ gauche_droite, data = ces50)",
  summary50 = sortie(summary(modele50)),
  code_confint = "confint(modele)",
  confint = sortie(confint(modele)),
  code_confint50 = "confint(modele50)",
  confint50 = sortie(confint(modele50))
)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_f.R (séance 7 : t, valeur p, intervalle de confiance).",
  "   Source : Étude électorale canadienne 2025, les 20 180 répondant.e.s comme",
  "   population d'exercice, sans pondération. Mêmes tirages que seance7_data.R.",
  "   Ne pas modifier à la main. */",
  "",
  "/* Le premier mélange du monde où H0 est vraie : la position gauche-droite de",
  "   chacune des 783 personnes de notre sondage, mélangée (même ordre que",
  "   NOTRE.points), et la droite de R sur ces données. b1 = H0.notre.pentes[0]. */",
  paste0("export const MELANGE = ", J(MELANGE), ";"),
  "/* Les sorties de R (width = 100) : summary() du sondage de 50, confint() des deux. */",
  paste0("export const SORTIES = ", J(SORTIES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_f.js"))

cat("MELANGE b1 =", MELANGE$b1, "\n")
cat(SORTIES$summary50, "\n\n", SORTIES$confint, "\n\n", SORTIES$confint50, "\n")
