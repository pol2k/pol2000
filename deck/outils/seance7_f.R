# Séance 7, partie F (t, valeur p, intervalle de confiance) : ce qui manque à
# src/lib/data/seance7.js pour ces diapos, dans src/lib/data/seance7_f.js.
# Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_f.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# L'exemple fil rouge : l'intérêt pour la politique (interet, de 0 à 1)
# selon la scolarité (scolarite, cinq niveaux de 0 à 1). On refait exactement
# les tirages d'outils/seance7_data.R (mêmes graines, même code), puis on
# vérifie qu'on retombe sur les mêmes nombres :
#   - notre sondage (graine 62), ses cas complets (`nous`);
#   - le premier mélange du monde où H0 est vraie (graine 7) : la scolarité
#     de chaque personne de `nous` est remplacée par celle d'une autre. On
#     exporte les scolarités mélangées (dans l'ordre de NOTRE.points) et la
#     droite de R sur ces données mélangées;
#   - le petit sondage de 50 (graine 67, celle que seance7_data.R retient :
#     H0.cinquante.graine), ajusté sous le nom ces50 pour que la ligne
#     « Call: » de R ait le style du cours.
# Puis la sortie de summary() et de confint(), telles que R les imprime.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# ---- Copié d'outils/seance7_data.R (les deux variables utiles ici).
int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
ces <- data.frame(interet = int / 10, scolarite = (niveau - 1) / 4)
stopifnot(nrow(ces) == 20180)
BUDGET <- 1000
r <- function(x, k = 4) round(x, k)
pente <- function(x) unname(coef(lm(interet ~ scolarite, data = x))[2])
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]
complets <- function(x) x[!is.na(x$interet) & !is.na(x$scolarite), ]

# ---- Notre sondage, et la vérification contre seance7.js.
set.seed(62)
ces1000 <- tirer(ces)
modele <- lm(interet ~ scolarite, data = ces1000)
nous <- complets(ces1000)
stopifnot(nrow(nous) == 981, abs(coef(modele)[[2]] - 0.2032) < 1e-4)

# ---- Le premier mélange (graine 7, premier tour du replicate de seance7_data.R).
set.seed(7)
z <- nous
z$scolarite <- sample(z$scolarite)
m_melange <- lm(interet ~ scolarite, data = z)
# Les 1 000 mélanges de seance7_data.R : le premier est H0$notre$pentes[1].
set.seed(7)
h0 <- replicate(1000, { w <- nous; w$scolarite <- sample(w$scolarite); pente(w) })
stopifnot(abs(coef(m_melange)[[2]] - h0[1]) < 1e-12, sum(abs(h0) >= abs(coef(modele)[[2]])) == 0)
MELANGE <- list(
  # scolarité mélangée, personne par personne, dans l'ordre de NOTRE.points (et de `nous`).
  x = z$scolarite,
  b0 = r(coef(m_melange)[[1]]), b1 = r(coef(m_melange)[[2]])
)

# ---- Le petit sondage de 50 (graine 67, H0.cinquante.graine).
set.seed(67)
ces50 <- tirer(ces, 50)
modele50 <- lm(interet ~ scolarite, data = ces50)
stopifnot(nobs(modele50) == 46, abs(coef(modele50)[[2]] - 0.224) < 1e-4,
          abs(coef(summary(modele50))[2, 4] - 0.0782) < 1e-4)

# ---- Les sorties de R.
sortie <- function(x) paste(capture.output(print(x)), collapse = "\n")
SORTIES <- list(
  code_lm50 = "modele50 <- lm(interet ~ scolarite, data = ces50)",
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
  "/* Le premier mélange du monde où H0 est vraie : la scolarité de chacune des",
  "   personnes de notre sondage (NOTRE.n_modele), mélangée (même ordre que",
  "   NOTRE.points), et la droite de R sur ces données. b1 = H0.notre.pentes[0]. */",
  paste0("export const MELANGE = ", J(MELANGE), ";"),
  "/* Les sorties de R (width = 100) : summary() du sondage de 50, confint() des deux. */",
  paste0("export const SORTIES = ", J(SORTIES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_f.js"))

cat("MELANGE b1 =", MELANGE$b1, "\n")
cat(SORTIES$summary50, "\n\n", SORTIES$confint, "\n\n", SORTIES$confint50, "\n")
