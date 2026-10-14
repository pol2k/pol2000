# Séance 7, le biais et l'erreur type de la pente (partie D du deck). Écrit
# src/lib/data/seance7_d.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_d.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Même dispositif et mêmes variables que outils/seance7_data.R (qu'il faut
# avoir roulé avant : on relit son MILLE pour vérifier qu'on refait bien les
# mêmes tirages). Les 20 180 répondant.e.s de la CES 2025 sont la population
# d'exercice; note_carney (0 à 100) selon gauche_droite (0 à 10).
#
# Ce que ce script ajoute :
#   GRILLE   la population en damier : combien de personnes à chaque cran de
#            gauche_droite et dans chaque tranche de 10 points de la note.
#   DROITES  les 1 000 sondages de 1 000 au hasard (graine 2025) et les 1 000
#            au Québec seulement (graine 2026) : les MÊMES tirages que
#            seance7_data.R, avec cette fois la constante et la pente de
#            chacun, pour dessiner les droites. Vérifié contre MILLE.
#   QUEBEC   la note moyenne des Québécois.e.s de la CES à chaque cran, et
#            leur droite : sous la vraie droite à gauche, au-dessus à droite.
#   DOUBLE   les 1 000 mêmes sondages au hasard, dans des données modifiées où
#            chaque personne est deux fois plus loin de la vraie droite
#            (note = droite + 2 × son erreur). Données fictives, pour montrer
#            ce que font de plus grosses erreurs de prédiction, le reste égal.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Mêmes variables que seance7_data.R (seulement celles dont on a besoin ici;
# les tirages ne dépendent que du nombre de lignes, 20 180).
na99 <- function(v) { v <- as.numeric(v); v[!is.na(v) & v < 0] <- NA; v }
prov <- as.character(as_factor(d$cps25_province))
ces <- data.frame(
  note_carney = na99(d$cps25_lead_rating_23),
  gauche_droite = na99(d$cps25_lr_scale_bef_1),
  quebec = as.numeric(grepl("Quebec", prov))
)
stopifnot(nrow(ces) == 20180)
BUDGET <- 1000
r <- function(x, k = 4) round(x, k)
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]
droite <- function(x) unname(coef(lm(note_carney ~ gauche_droite, data = x)))

# MILLE, tel qu'écrit par seance7_data.R, pour la vérification.
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"), encoding = "UTF-8")
lire <- function(nom) jsonlite::fromJSON(sub(paste0("^export const ", nom, " = (.*);$"), "\\1",
                                             grep(paste0("^export const ", nom, " = "), js, value = TRUE)))
MILLE7 <- lire("MILLE")
POP7 <- lire("POP")

# ---- 1. La population en damier.
m_pop <- lm(note_carney ~ gauche_droite, data = ces)
complets <- ces[!is.na(ces$note_carney) & !is.na(ces$gauche_droite), ]
stopifnot(nrow(complets) == POP7$n_modele)
# Tranches de 10 points : [0, 10), [10, 20) … [90, 100] (le 100 va dans la dernière).
tranche <- pmin(floor(complets$note_carney / 10), 9)
GRILLE <- list(
  n = nrow(complets),
  # comptes[[x + 1]][[t + 1]] = personnes au cran x, dans la tranche t.
  comptes = lapply(0:10, function(k) as.integer(table(factor(tranche[complets$gauche_droite == k], levels = 0:9))))
)
stopifnot(sum(unlist(GRILLE$comptes)) == nrow(complets))

# ---- 2. Les droites des 2 × 1 000 sondages (mêmes graines que seance7_data.R).
set.seed(2025)
hasard <- t(replicate(1000, droite(tirer(ces))))
qc <- ces[ces$quebec == 1, ]
set.seed(2026)
quebec <- t(replicate(1000, droite(tirer(qc))))
stopifnot(isTRUE(all.equal(r(hasard[, 2], 3), MILLE7$hasard)),
          isTRUE(all.equal(r(quebec[, 2], 3), MILLE7$quebec)))
DROITES <- list(
  hasard = list(b0 = r(hasard[, 1], 2), b1 = r(hasard[, 2], 3)),
  quebec = list(b0 = r(quebec[, 1], 2), b1 = r(quebec[, 2], 3))
)

# ---- 3. Les Québécois.e.s de la CES, cran par cran, et leur droite.
qcc <- complets[complets$quebec == 1, ]
m_qc <- lm(note_carney ~ gauche_droite, data = qcc)
# L'erreur (ε) de chaque Québécois.e par rapport à la VRAIE droite (celle des 20 180).
e_qc <- qcc$note_carney - predict(m_pop, newdata = qcc)
QUEBEC <- list(
  n = nrow(qc), n_modele = nobs(m_qc),
  b0 = r(coef(m_qc)[[1]]), b1 = r(coef(m_qc)[[2]]),
  # Le lien entre ces erreurs et gauche_droite, chez les Québécois.e.s (zéro sur les 20 180).
  correlation = r(cor(e_qc, qcc$gauche_droite), 2),
  moyennes = lapply(0:10, function(k) {
    v <- qcc$note_carney[qcc$gauche_droite == k]
    list(x = k, moyenne = r(mean(v), 2), n = length(v))
  })
)

# ---- 4. Les mêmes 1 000 sondages au hasard, erreurs doublées (données modifiées).
ces$note_double <- NA_real_
ok <- !is.na(ces$note_carney) & !is.na(ces$gauche_droite)
ces$note_double[ok] <- fitted(m_pop) + 2 * resid(m_pop)
set.seed(2025)
double <- replicate(1000, {
  s <- tirer(ces)
  unname(coef(lm(note_double ~ gauche_droite, data = s))[2])
})
DOUBLE <- list(
  # L'erreur typique (sigma) de la vraie droite, puis dans les données modifiées.
  sigma_vrai = r(summary(m_pop)$sigma, 1),
  sigma_double = r(summary(lm(note_double ~ gauche_droite, data = ces))$sigma, 1),
  pentes = r(double, 3), moyenne = r(mean(double), 3), ecart_type = r(sd(double), 3)
)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_d.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération. note_carney (0 à 100) selon gauche_droite (0 à 10).",
  "   Ne pas modifier à la main. */",
  "",
  "/* La population en damier : comptes[x][t] = personnes au cran x de gauche_droite",
  "   dont la note tombe dans la tranche [10t, 10t + 10) (100 compte dans la dernière). */",
  paste0("export const GRILLE = ", J(GRILLE), ";"),
  "/* Constante et pente des 1 000 sondages au hasard et des 1 000 au Québec seulement :",
  "   les mêmes tirages que MILLE dans seance7.js (vérifié par le script). */",
  paste0("export const DROITES = ", J(DROITES), ";"),
  "/* Les Québécois.e.s de la CES : note moyenne à chaque cran, et leur droite. */",
  paste0("export const QUEBEC = ", J(QUEBEC), ";"),
  "/* DONNÉES MODIFIÉES : les 1 000 sondages au hasard, chaque personne deux fois plus",
  "   loin de la vraie droite. Les pentes, leur moyenne et leur écart type. */",
  paste0("export const DOUBLE = ", J(DOUBLE), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_d.js"))

cat("GRILLE n =", GRILLE$n, " max =", max(unlist(GRILLE$comptes)), "\n")
cat("DROITES hasard b0 moy =", r(mean(hasard[, 1]), 2), " quebec b0 moy =", r(mean(quebec[, 1]), 2), "\n")
cat("QUEBEC n =", QUEBEC$n, " n_modele =", QUEBEC$n_modele, " b1 =", QUEBEC$b1, " cor =", QUEBEC$correlation, "\n")
print(sapply(QUEBEC$moyennes, `[[`, "moyenne"))
cat("DOUBLE moy =", DOUBLE$moyenne, " et =", DOUBLE$ecart_type, " sigma =", DOUBLE$sigma_vrai, "->", DOUBLE$sigma_double, "\n")
