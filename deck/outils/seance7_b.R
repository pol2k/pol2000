# Les données de l'introduction à la régression (séance 7, diapos « Pourquoi
# la régression ? », « Comment ça marche ? », « Corrélation ou régression ? »
# et l'équation en mots), dans src/lib/data/seance7_b.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_b.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Même recodage
# que outils/seance7_data.R, de 0 à 1 :
#   populisme (pes25_populism_8), 5 niveaux : 0, 0,25, 0,5, 0,75, 1;
#   satisfaction_dem (pes25_dem_sat, inversée), 4 niveaux : 0, 1/3, 2/3, 1.
# La population d'exercice : les 20 180 répondant.e.s de la CES 2025; R garde
# celles et ceux qui ont répondu aux deux questions. Le nuage en bulles et
# les moyennes viennent de POP dans seance7.js; ce script ajoute la
# prédiction et les trois droites essayées sur QUINZE. Aucune valeur n'est
# écrite à la main; les stopifnot vérifient l'accord avec seance7_data.R.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

ech <- function(v, k, inv = FALSE) {
  v <- as.numeric(v); v[!(v %in% 1:k)] <- NA
  z <- (v - 1) / (k - 1); if (inv) 1 - z else z
}
ces <- data.frame(
  satisfaction_dem = ech(d$pes25_dem_sat, 4, inv = TRUE),
  populisme = ech(d$pes25_populism_8, 5)
)
stopifnot(nrow(ces) == 20180)
complets <- function(x) x[!is.na(x$satisfaction_dem) & !is.na(x$populisme), ]
m_pop <- lm(satisfaction_dem ~ populisme, data = ces)
r <- function(x, k = 4) round(x, k)
stopifnot(nobs(m_pop) == 10993, r(coef(m_pop)[[2]]) == -0.3141)

# ---- 1. La corrélation et la prédiction, sur les 10 993 cas complets.
pop <- complets(ces)
CORR <- list(
  r = r(cor(pop$populisme, pop$satisfaction_dem)),
  # La corrélation ne dépend pas de l'ordre des variables.
  r_inverse = r(cor(pop$satisfaction_dem, pop$populisme)),
  b0 = r(coef(m_pop)[[1]]), b1 = r(coef(m_pop)[[2]]),
  # « Plutôt en accord » (0,75) : quelle satisfaction ? predict(), tel quel.
  x_pred = 0.75,
  pred = r(unname(predict(m_pop, newdata = data.frame(populisme = 0.75)))),
  # La vraie moyenne de celles et ceux qui ont répondu « plutôt en accord ».
  moyenne_pred = r(mean(pop$satisfaction_dem[abs(pop$populisme - 0.75) < 1e-9]))
)

# ---- 2. Les quinze personnes de QUINZE (seance7_data.R : notre sondage,
# graine 62, puis graine 15) : la somme des carrés des écarts pour trois
# droites. Les deux premières sont choisies pour la démonstration (une
# droite qui monte, puis la moyenne, la même satisfaction pour tout le
# monde); la troisième est celle de lm().
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
nous <- complets(ces1000)
set.seed(15)
q <- nous[sample(nrow(nous), 15), ]
m15 <- lm(satisfaction_dem ~ populisme, data = q)
stopifnot(r(coef(m15)[[2]]) == -0.5459)
somme <- function(b0, b1) sum((q$satisfaction_dem - (b0 + b1 * q$populisme))^2)
moy <- mean(q$satisfaction_dem)
DROITES <- list(
  list(cle = "monte", b0 = 0.2, b1 = 0.6, somme = r(somme(0.2, 0.6))),
  list(cle = "moyenne", b0 = r(moy), b1 = 0, somme = r(somme(moy, 0))),
  list(cle = "lm", b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
       somme = r(sum(resid(m15)^2)))
)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_b.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération; R garde les 10 993 cas complets. satisfaction_dem selon",
  "   populisme, les deux de 0 à 1. Ne pas modifier à la main. */",
  "",
  "/* La corrélation, la droite de la population et sa prédiction à 0,75. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* Quinze personnes (QUINZE de seance7.js) : trois droites et la somme des",
  "   carrés de leurs écarts. La dernière est celle de lm(), le minimum. */",
  paste0("export const DROITES = ", J(DROITES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_b.js"))

cat("r =", CORR$r, " r_inverse =", CORR$r_inverse, " pred =", CORR$pred, " moyenne =", CORR$moyenne_pred, "\n")
for (dd in DROITES) cat(dd$cle, dd$b0, dd$b1, dd$somme, "\n")
