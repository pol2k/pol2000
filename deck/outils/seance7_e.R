# Séance 7, la variable confondante : crème glacée et noyades. DONNÉES FICTIVES.
# Écrit src/lib/data/seance7_e.js. Depuis deck/ :
#
#   Rscript outils/seance7_e.R
#
# Aucune donnée réelle : l'exemple d'Arel-Bundock (2021, chap. 5, p. 84), « le
# nombre de crèmes glacées vendues et le nombre de noyades mensuelles », rendu
# en chiffres inventés pour qu'on puisse le dessiner. Les diapos le disent
# (« Données fictives »).
#
# Le monde fictif, écrit ici une fois pour toutes : 240 mois (20 ans).
#   - la température moyenne du mois suit les saisons (de -11 à 19 °C environ),
#     plus un peu de hasard;
#   - la crème glacée vendue (millions de cornets) monte avec la chaleur;
#   - les noyades montent avec la chaleur (on se baigne plus).
# La crème glacée n'a AUCUN effet sur les noyades : il n'y a pas de terme
# `cremes` dans la formule des noyades. Tout le lien passe par la chaleur.
#
# Ce que R calcule, et que les diapos montrent :
#   NAIF      lm(noyades ~ cremes) : la pente naïve, forte et biaisée.
#   TRANCHES  la même régression, mais seulement parmi les mois d'une même
#             chaleur (à 2 °C près autour de -10, 4 et 19 °C) : presque plate.
#             Elle n'est pas exactement 0 : à 2 °C près n'est pas « exactement
#             la même chaleur », et chaque tranche a peu de mois (d'où le
#             hasard d'une tranche à l'autre, de l'ordre de ± 1).
#   EGALE     lm(noyades ~ cremes + temperature) : ce que fera la régression
#             multiple (séance 8). Pour les notes, pas pour la diapo.
#   CHALEUR   les deux flèches de la chaleur, estimées par R (pour les notes).
#
# La graine est fixée (set.seed(7)). Avec ces réglages, sur 200 graines, la
# pente naïve vaut environ 8 et les pentes par tranche environ 0,5 (écart-type
# d'environ 0,8) : la graine 7 n'est pas un cas d'exception.
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
r <- function(x, k = 4) round(x, k)

set.seed(7)
n <- 240
mois_annee <- rep(1:12, n / 12)
temperature <- round(4 + 15 * sin(2 * pi * (mois_annee - 4.2) / 12) + rnorm(n, 0, 2.5), 1)
cremes <- round(pmax(0.1, 5.5 + 0.2 * temperature + rnorm(n, 0, 1)), 1)
noyades <- round(pmax(0, 35 + 2 * temperature + rnorm(n, 0, 4)))
mois <- data.frame(cremes, noyades, temperature)

# ---- La régression naïve, et sa sortie telle que R l'imprime.
CODE <- "modele <- lm(noyades ~ cremes, data = mois)"
m <- lm(noyades ~ cremes, data = mois)
COEF <- paste(capture.output(coef(m)), collapse = "\n")
s <- coef(summary(m))
NAIF <- list(
  n = nobs(m), b0 = r(s[1, 1]), b1 = r(s[2, 1]), se = r(s[2, 2]),
  r2 = r(summary(m)$r.squared), cor = r(cor(mois$cremes, mois$noyades), 3)
)

# ---- À chaleur (presque) égale : trois tranches de 4 °C.
TRANCHES <- lapply(c(-10, 4, 19), function(centre) {
  k <- abs(mois$temperature - centre) <= 2
  d <- mois[k, ]
  mk <- lm(noyades ~ cremes, data = d)
  list(centre = centre, bas = centre - 2, haut = centre + 2, n = nrow(d),
       b0 = r(coef(mk)[[1]]), b1 = r(coef(mk)[[2]]),
       xmin = min(d$cremes), xmax = max(d$cremes))
})

# ---- Pour les notes : la régression multiple et les deux flèches de la chaleur.
m2 <- lm(noyades ~ cremes + temperature, data = mois)
s2 <- coef(summary(m2))
EGALE <- list(code = "lm(noyades ~ cremes + temperature, data = mois)",
              b1 = r(s2["cremes", 1]), se = r(s2["cremes", 2]), p = signif(s2["cremes", 4], 3),
              chaleur = r(s2["temperature", 1]))
CHALEUR <- list(
  cremes = r(coef(lm(cremes ~ temperature, data = mois))[[2]]),
  noyades = r(coef(lm(noyades ~ temperature, data = mois))[[2]]),
  # Pour les notes : la chaleur selon la crème glacée. Identité exacte des moindres
  # carrés : pente naïve = pente à chaleur égale + effet de la chaleur × delta.
  delta = r(coef(lm(temperature ~ cremes, data = mois))[[2]])
)

POINTS <- lapply(seq_len(n), function(i) list(c = cremes[i], n = noyades[i], t = temperature[i]))

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_e.R. DONNÉES FICTIVES : 240 mois inventés pour",
  "   l'exemple d'Arel-Bundock (2021, chap. 5), crème glacée et noyades. La chaleur",
  "   pousse les deux, la crème glacée n'a aucun effet sur les noyades.",
  "   Ne pas modifier à la main. */",
  "",
  "/* Les 240 mois : c = crème glacée vendue (millions de cornets),",
  "   n = noyades dans le mois, t = température moyenne du mois (°C). */",
  paste0("export const MOIS = ", J(POINTS), ";"),
  "/* La régression naïve, lm(noyades ~ cremes). */",
  paste0("export const NAIF = ", J(NAIF), ";"),
  "/* Le code et la sortie de coef(modele), tels que R les imprime (width = 100). */",
  paste0("export const CODE_NAIF = ", J(CODE), ";"),
  paste0("export const COEF_NAIF = ", J(COEF), ";"),
  "/* La même régression parmi les mois d'une même chaleur (à 2 °C près). */",
  paste0("export const TRANCHES = ", J(TRANCHES), ";"),
  "/* Pour les notes : lm(noyades ~ cremes + temperature), et les pentes de la",
  "   chaleur sur chaque variable (lm(cremes ~ temperature), lm(noyades ~ temperature)). */",
  paste0("export const EGALE = ", J(EGALE), ";"),
  paste0("export const CHALEUR = ", J(CHALEUR), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_e.js"))

cat(CODE, "\n"); cat(COEF, "\n")
cat("NAIF b1 =", NAIF$b1, " se =", NAIF$se, " r2 =", NAIF$r2, " cor =", NAIF$cor, "\n")
for (t in TRANCHES) cat("TRANCHE", t$centre, "n =", t$n, " b1 =", t$b1, " x:", t$xmin, "-", t$xmax, "\n")
cat("EGALE b1 =", EGALE$b1, " se =", EGALE$se, " p =", EGALE$p, " chaleur =", EGALE$chaleur, "\n")
cat("CHALEUR cremes =", CHALEUR$cremes, " noyades =", CHALEUR$noyades, " delta =", CHALEUR$delta, "\n")
cat("Décomposition :", EGALE$b1, "+", EGALE$chaleur, "x", CHALEUR$delta, "=", EGALE$b1 + EGALE$chaleur * CHALEUR$delta, " (naïve :", NAIF$b1, ")\n")
cat("ranges: cremes", range(cremes), " noyades", range(noyades), " temp", range(temperature), "\n")
