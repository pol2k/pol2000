# Séance 7, le biais et l'erreur type de la pente (partie D du deck). Écrit
# src/lib/data/seance7_d.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_d.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Même dispositif et mêmes variables que outils/seance7_data.R, QU'IL FAUT
# AVOIR ROULÉ AVANT : on relit son seance7.js (POP, MILLE, ERREUR_TYPE) pour
# vérifier qu'on refait bien les mêmes tirages, et le script s'arrête sinon.
# Les 20 180 répondant.e.s de la CES 2025 sont la population d'exercice;
# interet (0 à 1) selon scolarite (0 à 1).
#
# Ce que ce script ajoute :
#   DROITES    les 1 000 sondages de 1 000 au hasard (graine 2025) et les
#              1 000 sondages d'électeurs et électrices conservateurs
#              (intention de vote, cps25_votechoice = 2, graine 2026) : les
#              MÊMES tirages que MILLE, avec cette fois la constante et la pente
#              de chacun, pour dessiner les droites. Vérifié contre MILLE.
#   CONSERVATEURS  les conservateurs de la CES, niveau par niveau : leur
#              intérêt moyen, leur ε moyen (distance à la VRAIE droite, celle
#              des 20 180), la part de conservateurs à chaque niveau de
#              scolarité, et leur droite. Vérifié contre MILLE$moyennes_facile
#              et b1_facile_pop. Plus l'intérêt moyen des conservateurs et des
#              autres : le vote conservateur est lié à X (plus fréquent chez
#              les moins scolarisé.e.s) et à Y (plus d'intérêt).
#   DOUBLE     les 1 000 sondages de 500 de ERREUR_TYPE$base (graine 500, parmi
#              les cas complets), dans des données modifiées où chaque personne
#              est deux fois plus loin de la vraie droite (intérêt = droite +
#              2 × son erreur). Données fictives, pour montrer ce que font de
#              plus grosses erreurs de prédiction, le reste égal. Vérifié : sans
#              la modification, les pentes égalent ERREUR_TYPE$base$pentes.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Mêmes variables que seance7_data.R (seulement celles dont on a besoin ici;
# les tirages ne dépendent que du nombre de lignes de chaque bassin).
int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
ces <- data.frame(interet = int / 10, scolarite = (niveau - 1) / 4,
                  vote_conservateur = as.numeric(as.numeric(d$cps25_votechoice) %in% 2))
stopifnot(nrow(ces) == 20180)
BUDGET <- 1000
NX <- c(0, 0.25, 0.5, 0.75, 1)
r <- function(x, k = 4) round(x, k)
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]
complets <- function(x) x[!is.na(x$interet) & !is.na(x$scolarite), ]
droite <- function(x) unname(coef(lm(interet ~ scolarite, data = x)))

# seance7.js, tel qu'écrit par seance7_data.R, pour les vérifications.
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"), encoding = "UTF-8")
lire <- function(nom) jsonlite::fromJSON(sub(paste0("^export const ", nom, " = (.*);$"), "\\1",
                                             grep(paste0("^export const ", nom, " = "), js, value = TRUE)))
POP7 <- lire("POP"); MILLE7 <- lire("MILLE"); ET7 <- lire("ERREUR_TYPE")

m_pop <- lm(interet ~ scolarite, data = ces)
stopifnot(nobs(m_pop) == POP7$n_modele, isTRUE(all.equal(r(coef(m_pop)[[2]]), POP7$b1)))

# ---- 1. Les droites des 2 × 1 000 sondages (mêmes graines que seance7_data.R).
set.seed(2025)
hasard <- t(replicate(1000, droite(tirer(ces))))
conserv <- ces[ces$vote_conservateur %in% 1, ]
stopifnot(nrow(conserv) == MILLE7$n_facile_pop)
set.seed(2026)
facile <- t(replicate(1000, droite(tirer(conserv))))
stopifnot(isTRUE(all.equal(r(hasard[, 2]), MILLE7$hasard)),
          isTRUE(all.equal(r(facile[, 2]), MILLE7$facile)))
DROITES <- list(
  hasard = list(b0 = r(hasard[, 1]), b1 = r(hasard[, 2])),
  facile = list(b0 = r(facile[, 1]), b1 = r(facile[, 2]))
)

# ---- 2. Les conservateurs, niveau par niveau.
pc <- complets(ces)
cc <- complets(conserv)
m_c <- lm(interet ~ scolarite, data = cc)
stopifnot(isTRUE(all.equal(r(coef(m_c)[[2]]), MILLE7$b1_facile_pop)))
# L'erreur (ε) de chaque conservateur par rapport à la VRAIE droite.
e_c <- cc$interet - predict(m_pop, newdata = cc)
CONSERVATEURS <- list(
  n = nrow(conserv), n_modele = nobs(m_c),
  b0 = r(coef(m_c)[[1]]), b1 = r(coef(m_c)[[2]]),
  # Le lien entre ces erreurs et la scolarité, chez les conservateurs (zéro sur les 20 180).
  correlation = r(cor(e_c, cc$scolarite), 2),
  # Intérêt moyen : conservateurs et autres (lien avec Y).
  interet_moyen = list(conservateurs = r(mean(cc$interet)),
                       autres = r(mean(pc$interet[pc$vote_conservateur == 0]))),
  moyennes = lapply(NX, function(a) {
    k <- abs(cc$scolarite - a) < 1e-9
    tous <- abs(pc$scolarite - a) < 1e-9
    # part = la part de conservateurs parmi les gens de ce niveau (lien avec X).
    list(x = a, moyenne = r(mean(cc$interet[k])), epsilon = r(mean(e_c[k])), n = sum(k),
         part = r(mean(pc$vote_conservateur[tous]), 3))
  })
)
stopifnot(isTRUE(all.equal(sapply(CONSERVATEURS$moyennes, `[[`, "moyenne"), MILLE7$moyennes_facile$moyenne)))

# ---- 3. Les 1 000 sondages de 500 de ERREUR_TYPE$base, erreurs doublées.
pool <- pc
pool$interet_double <- fitted(m_pop) + 2 * resid(m_pop)
set.seed(500)
deux <- t(replicate(1000, {
  s <- tirer(pool, 500)
  c(droite(s)[2], unname(coef(lm(interet_double ~ scolarite, data = s))[2]))
}))
stopifnot(isTRUE(all.equal(r(deux[, 1]), ET7$base$pentes)))
DOUBLE <- list(
  n = 500,
  # L'erreur typique (sigma) de la vraie droite, puis dans les données modifiées.
  sigma_vrai = r(summary(m_pop)$sigma),
  sigma_double = r(summary(lm(interet_double ~ scolarite, data = pool))$sigma),
  pentes = r(deux[, 2]), moyenne = r(mean(deux[, 2])), ecart_type = r(sd(deux[, 2]))
)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_d.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération. interet (0 à 1) selon scolarite (0 à 1).",
  "   Ne pas modifier à la main. */",
  "",
  "/* Constante et pente des 1 000 sondages au hasard et des 1 000 sondages d'électeurs",
  "   conservateurs : les mêmes tirages que MILLE dans seance7.js (vérifié par le script). */",
  paste0("export const DROITES = ", J(DROITES), ";"),
  "/* Les conservateurs : intérêt moyen, ε moyen (distance à la vraie droite) et part de",
  "   conservateurs à chaque niveau de scolarité, leur droite, intérêt moyen comparé. */",
  paste0("export const CONSERVATEURS = ", J(CONSERVATEURS), ";"),
  "/* DONNÉES MODIFIÉES (fictives) : les sondages de 500 de ERREUR_TYPE.base, chaque",
  "   personne deux fois plus loin de la vraie droite. Les pentes et leur écart type. */",
  paste0("export const DOUBLE = ", J(DOUBLE), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_d.js"))

cat("DROITES b0 moy hasard =", r(mean(hasard[, 1])), " facile =", r(mean(facile[, 1])), "\n")
cat("CONSERVATEURS n =", CONSERVATEURS$n, " n_modele =", CONSERVATEURS$n_modele, " b0 =", CONSERVATEURS$b0,
    " b1 =", CONSERVATEURS$b1, " cor =", CONSERVATEURS$correlation, "\n")
print(unlist(CONSERVATEURS$interet_moyen))
print(do.call(rbind, lapply(CONSERVATEURS$moyennes, unlist)))
cat("DOUBLE moy =", DOUBLE$moyenne, " et =", DOUBLE$ecart_type, " (base", ET7$base$ecart_type, ")",
    " sigma =", DOUBLE$sigma_vrai, "->", DOUBLE$sigma_double, "\n")
