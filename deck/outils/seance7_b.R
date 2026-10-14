# Les données de l'introduction à la régression (séance 7, diapos « Pourquoi
# la régression ? », « Comment ça marche ? », « Corrélation ou régression ? »
# et l'équation en mots), dans src/lib/data/seance7_b.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_b.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Même recodage
# que outils/seance7_data.R (le code -99 devient NA). La population
# d'exercice : les 20 180 répondant.e.s de la CES 2025; R garde les cas
# complets (15 993). Aucune valeur n'est écrite à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

na99 <- function(v) { v <- as.numeric(v); v[!is.na(v) & v < 0] <- NA; v }
ces <- data.frame(
  note_carney = na99(d$cps25_lead_rating_23),
  gauche_droite = na99(d$cps25_lr_scale_bef_1)
)
stopifnot(nrow(ces) == 20180)
complets <- ces[!is.na(ces$note_carney) & !is.na(ces$gauche_droite), ]
m_pop <- lm(note_carney ~ gauche_droite, data = ces)
r <- function(x, k = 4) round(x, k)

# ---- 1. Le nuage des 15 993 cas complets, en bulles (comme geom_count()) :
# combien de personnes à chaque cran de l'échelle et pour chaque tranche de
# note arrondie à la dizaine la plus proche (0, 10, ..., 100; 25 va à 30,
# 45 à 50). Pas round() : R arrondit les demis au pair (25 irait à 20 et 35
# à 40), ce qui ferait alterner la taille des bulles sans raison.
complets$tranche <- floor(complets$note_carney / 10 + 0.5) * 10
tab <- as.data.frame(table(x = complets$gauche_droite, y = complets$tranche))
tab <- tab[tab$Freq > 0, ]
BULLES <- list(
  n = nrow(complets),
  cases = lapply(seq_len(nrow(tab)), function(i) list(
    x = as.numeric(as.character(tab$x[i])), y = as.numeric(as.character(tab$y[i])),
    n = tab$Freq[i]))
)

# ---- 2. La corrélation et la prédiction, sur les mêmes 15 993 personnes.
CORR <- list(
  r = r(cor(complets$gauche_droite, complets$note_carney)),
  # La corrélation ne dépend pas de l'ordre des variables.
  r_inverse = r(cor(complets$note_carney, complets$gauche_droite)),
  b0 = r(coef(m_pop)[[1]]), b1 = r(coef(m_pop)[[2]]),
  # « Si je me place à 8, quelle note pour Carney ? » : predict(), tel quel.
  a8 = r(unname(predict(m_pop, newdata = data.frame(gauche_droite = 8))), 2),
  # La vraie moyenne de celles et ceux qui se placent à 8, pour comparer.
  moyenne8 = r(mean(complets$note_carney[complets$gauche_droite == 8]), 2)
)

# ---- 3. Les quinze personnes de QUINZE (seance7_data.R, graine 15) : la
# somme des carrés des écarts pour trois droites. Les deux premières sont
# choisies pour la démonstration (une droite qui monte, puis la moyenne,
# la même note pour tout le monde); la troisième est celle de lm().
set.seed(62)
tirer <- function(pool, n = 1000) pool[sample(nrow(pool), n), ]
ces1000 <- tirer(ces)
nous <- ces1000[!is.na(ces1000$note_carney) & !is.na(ces1000$gauche_droite), ]
set.seed(15)
q <- nous[sample(nrow(nous), 15), ]
m15 <- lm(note_carney ~ gauche_droite, data = q)
somme <- function(b0, b1) sum((q$note_carney - (b0 + b1 * q$gauche_droite))^2)
moy <- mean(q$note_carney)
DROITES <- list(
  list(cle = "monte", b0 = 20, b1 = 6, somme = r(somme(20, 6), 1)),
  list(cle = "moyenne", b0 = r(moy), b1 = 0, somme = r(somme(moy, 0), 1)),
  list(cle = "lm", b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
       somme = r(sum(resid(m15)^2), 1))
)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_b.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération; R garde les 15 993 cas complets. note_carney (0 à 100)",
  "   selon gauche_droite (0 à 10). Ne pas modifier à la main. */",
  "",
  "/* Le nuage en bulles : n personnes à chaque cran x, note arrondie à la dizaine y. */",
  paste0("export const BULLES = ", J(BULLES), ";"),
  "/* La corrélation, la droite de la population et sa prédiction à 8. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* Quinze personnes (QUINZE de seance7.js) : trois droites et la somme des",
  "   carrés de leurs écarts. La dernière est celle de lm(), le minimum. */",
  paste0("export const DROITES = ", J(DROITES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_b.js"))

cat("n =", BULLES$n, " cases =", length(BULLES$cases), " max =", max(tab$Freq), "\n")
cat("r =", CORR$r, " r_inverse =", CORR$r_inverse, " a8 =", CORR$a8, " moyenne8 =", CORR$moyenne8, "\n")
for (dd in DROITES) cat(dd$cle, dd$b0, dd$b1, dd$somme, "\n")
