# Les données de l'introduction à la régression (séance 7, diapos « Pourquoi
# la régression ? », « Comment ça marche ? », « Corrélation ou régression ? »
# et l'équation en mots), dans src/lib/data/seance7_b.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_b.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Même recodage
# que outils/seance7_data.R, de 0 à 1 :
#   scolarite (cps25_education), 5 niveaux : 0, 0,25, 0,5, 0,75, 1
#     (codes 1-4, 5, 6-7, 8-9, 10-11);
#   interet (cps25_interest_gen_1), le curseur de 0 à 10 divisé par 10.
# La population d'exercice : les 20 180 répondant.e.s de la CES 2025; R garde
# celles et ceux qui ont répondu aux deux questions. Le nuage, les moyennes
# et QUINZE viennent de seance7.js; ce script ajoute la corrélation, la
# prédiction et les trois droites essayées sur QUINZE. Aucune valeur n'est
# écrite à la main; les stopifnot vérifient l'accord avec seance7_data.R.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
ces <- data.frame(interet = int / 10, scolarite = (niveau - 1) / 4)
stopifnot(nrow(ces) == 20180)
complets <- function(x) x[!is.na(x$interet) & !is.na(x$scolarite), ]
m_pop <- lm(interet ~ scolarite, data = ces)
r <- function(x, k = 4) round(x, k)
stopifnot(nobs(m_pop) == 19736, r(coef(m_pop)[[2]]) == 0.1717, round(coef(m_pop)[[1]], 2) == 0.56)

# ---- 1. La corrélation et la prédiction, sur les 19 736 cas complets.
pop <- complets(ces)
CORR <- list(
  r = r(cor(pop$scolarite, pop$interet)),
  # La corrélation ne dépend pas de l'ordre des variables.
  r_inverse = r(cor(pop$interet, pop$scolarite)),
  b1 = r(coef(m_pop)[[2]]),
  # « Université, 1er cycle » (0,75) : quel intérêt ? predict(), tel quel.
  x_pred = 0.75,
  pred = r(unname(predict(m_pop, newdata = data.frame(scolarite = 0.75)))),
  # La vraie moyenne de ce niveau, pour comparer.
  moyenne_pred = r(mean(pop$interet[abs(pop$scolarite - 0.75) < 1e-9]))
)

# ---- 2. Les quinze personnes de QUINZE (seance7_data.R : notre sondage,
# graine 62, puis la première graine à partir de 15 dont la pente est entre
# 0,1 et 0,3 et qui couvre au moins quatre niveaux, soit 28) : la somme des
# carrés des écarts pour trois droites. Les deux premières sont choisies pour
# la démonstration (une droite qui descend, à l'envers de la population, puis
# la moyenne, le même intérêt pour tout le monde); la troisième est celle de
# lm().
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
nous <- complets(ces1000)
for (g15 in 15:500) {
  set.seed(g15); q <- nous[sample(nrow(nous), 15), ]; m15 <- lm(interet ~ scolarite, data = q)
  if (coef(m15)[[2]] >= 0.1 && coef(m15)[[2]] <= 0.3 && length(unique(q$scolarite)) >= 4) break
}
stopifnot(g15 == 28, r(coef(m15)[[2]]) == 0.17, r(sum(resid(m15)^2)) == 1.2452)
somme <- function(b0, b1) sum((q$interet - (b0 + b1 * q$scolarite))^2)
moy <- mean(q$interet)
DROITES <- list(
  list(cle = "descend", b0 = 0.95, b1 = -0.5, somme = r(somme(0.95, -0.5))),
  list(cle = "moyenne", b0 = r(moy), b1 = 0, somme = r(somme(moy, 0))),
  list(cle = "lm", b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
       somme = r(sum(resid(m15)^2)))
)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_b.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération; R garde les 19 736 cas complets. interet selon scolarite,",
  "   les deux de 0 à 1. Ne pas modifier à la main. */",
  "",
  "/* La corrélation, la droite de la population et sa prédiction à 0,75. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* Quinze personnes (QUINZE de seance7.js) : trois droites et la somme des",
  "   carrés de leurs écarts. La dernière est celle de lm(), le minimum. */",
  paste0("export const DROITES = ", J(DROITES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_b.js"))

cat("r =", CORR$r, " r_inverse =", CORR$r_inverse, " pred =", CORR$pred, " moyenne =", CORR$moyenne_pred, "\n")
for (dd in DROITES) cat(dd$cle, dd$b0, dd$b1, dd$somme, "\n")
