# Les données de la diapo « Pourquoi des carrés ? » (séance 7, juste après
# « Comment ça marche ? »), dans src/lib/data/seance7_j.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_j.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Même recodage
# que outils/seance7_data.R, de 0 à 1 :
#   scolarite (cps25_education), 5 niveaux : 0, 0,25, 0,5, 0,75, 1
#     (codes 1-4, 5, 6-7, 8-9, 10-11);
#   interet (cps25_interest_gen_1), le curseur de 0 à 10 divisé par 10.
# Les quinze personnes sont celles de QUINZE (seance7_data.R : notre sondage,
# graine 62, puis la graine 28). Deux droites très différentes qui passent
# toutes deux par le point moyen (scolarité moyenne, intérêt moyen) :
#   « monte »   la droite de lm() (pente +0,17);
#   « descend » une droite de pente −0,5 qui passe par le même point moyen.
# Pour chacune : les écarts signés (point moins droite), leur somme (zéro
# pour les deux : les écarts au-dessus et au-dessous s'annulent), la somme
# des écarts au-dessus, celle des écarts au-dessous, et l'aire totale des
# carrés. Aucune valeur n'est écrite à la main; les stopifnot vérifient
# l'accord avec seance7_data.R et seance7_b.R.
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
r <- function(x, k = 4) round(x, k)

# ---- Les quinze personnes (exactement comme seance7_data.R et seance7_b.R).
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
nous <- complets(ces1000)
stopifnot(nrow(nous) == 981)
for (g15 in 15:500) {
  set.seed(g15); q <- nous[sample(nrow(nous), 15), ]; m15 <- lm(interet ~ scolarite, data = q)
  if (coef(m15)[[2]] >= 0.1 && coef(m15)[[2]] <= 0.3 && length(unique(q$scolarite)) >= 4) break
}
stopifnot(g15 == 28, r(coef(m15)[[2]]) == 0.17, r(sum(resid(m15)^2)) == 1.2452)

# ---- Deux droites par le point moyen.
xm <- mean(q$scolarite); ym <- mean(q$interet)
pente_b <- -0.5
droite <- function(cle, b0, b1, e = q$interet - (b0 + b1 * q$scolarite)) {
  list(cle = cle, b0 = r(b0), b1 = r(b1),
       # La somme des écarts signés : zéro (à l'arrondi près) pour toute
       # droite qui passe par le point moyen.
       somme = r(sum(e)) + 0,  # + 0 : pas de « −0 »
       # Arrondis à deux décimales, comme sur la diapo.
       dessus = r(sum(e[e > 0]), 2), dessous = r(sum(e[e < 0]), 2),
       distances = r(sum(abs(e))),
       carres = r(sum(e^2)))
}
DEUX <- list(
  # Pour lm(), les écarts sont ses résidus, tels quels.
  droite("monte", coef(m15)[[1]], coef(m15)[[2]], resid(m15)),
  droite("descend", ym - pente_b * xm, pente_b)
)
stopifnot(abs(sum(resid(m15))) < 1e-12,
          abs(DEUX[[2]]$somme) < 1e-12,
          DEUX[[1]]$carres == 1.2452,
          DEUX[[2]]$carres > DEUX[[1]]$carres)

# La droite de lm() est la seule à avoir la plus petite aire : on vérifie
# que toutes les pentes essayées par pas de 0,01 (droites par le point moyen,
# les meilleures pour chaque pente) donnent plus que lm(), sauf lm() elle-même.
pentes <- seq(-1, 1, by = 0.01)
aires <- sapply(pentes, function(b) sum((q$interet - (ym + b * (q$scolarite - xm)))^2))
stopifnot(abs(pentes[which.min(aires)] - 0.17) < 1e-9)

POURQUOI <- list(
  point_moyen = list(x = r(xm), y = r(ym)),
  droites = DEUX,
  # L'exemple du gros écart : un écart de 2 contre deux écarts de 1.
  gros = list(un = 2, deux = c(1, 1), aire_un = 2^2, aire_deux = 1^2 + 1^2)
)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_j.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les quinze personnes de QUINZE (seance7.js), sans",
  "   pondération. interet selon scolarite, les deux de 0 à 1. Ne pas modifier",
  "   à la main. */",
  "",
  "/* Deux droites par le point moyen : celle de lm() (« monte ») et une droite",
  "   de pente −0,5 (« descend »). Pour chacune, la somme des écarts signés (0),",
  "   les écarts au-dessus et au-dessous, et l'aire totale des carrés. */",
  paste0("export const POURQUOI = ", J(POURQUOI), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_j.js"))

for (dd in DEUX) cat(dd$cle, " b0 =", dd$b0, " b1 =", dd$b1, " somme =", dd$somme,
                     " dessus =", dd$dessus, " dessous =", dd$dessous,
                     " distances =", dd$distances, " carres =", dd$carres, "\n")
cat("point moyen :", r(xm), r(ym), "\n")
