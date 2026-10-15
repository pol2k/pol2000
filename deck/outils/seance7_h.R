# Séance 7, graphique des coefficients : deux ajouts, tous deux dans
# src/lib/data/seance7_h.js (et deux images dans static/img/). Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_h.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# 1. NIVEAUX : le modèle à plusieurs variables de seance7_data.R (MULTIPLE),
#    refait à l'identique, avec ses intervalles de confiance à 95 %, 99 % et
#    99,9 % (confint(m2, level = ...)). Sert à « 95 %, 99 %, 99,9 % » : les
#    étoiles de R, ce sont les moustaches.
# 2. GABARIT : un graphique des coefficients propre, à réutiliser dans les
#    travaux. Le code montré sur les diapos est exactement le code exécuté
#    ici (eval(parse(...)) des mêmes chaînes), et les images
#    static/img/s7-gabarit-ggplot.png et s7-gabarit-modelplot.png sont ce
#    qu'il produit.
#
# ces1000 est reconstruit exactement comme dans seance7_data.R (mêmes
# recodages, graine 62), puis vérifié contre src/lib/data/seance7.js.
suppressPackageStartupMessages({
  library(haven); library(broom); library(dplyr); library(ggplot2); library(modelsummary)
})
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# ---- Les données, comme dans seance7_data.R.
prov <- as.character(as_factor(d$cps25_province))
ans <- as.numeric(d$cps25_age_in_years)
int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
genre <- as.numeric(d$cps25_genderid)
rev <- as.numeric(d$cps25_income); rev[!(rev %in% 1:8)] <- NA
ces <- data.frame(
  interet = int / 10,
  scolarite = (niveau - 1) / 4,
  age = (ans - 18) / (max(ans, na.rm = TRUE) - 18),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  revenu = (rev - 1) / 7,
  quebec = as.numeric(grepl("Quebec", prov))
)
stopifnot(nrow(ces) == 20180)
tirer <- function(pool, n = 1000) pool[sample(nrow(pool), n), ]
set.seed(62)
ces1000 <- tirer(ces)
m2 <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)

# ---- Vérification contre seance7.js : même modèle, mêmes nombres.
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"), encoding = "UTF-8")
lire <- function(nom) {
  l <- grep(paste0("^export const ", nom, " = "), js, value = TRUE)
  jsonlite::fromJSON(sub(";$", "", sub(paste0("^export const ", nom, " = "), "", l)))
}
M <- lire("MULTIPLE")
stopifnot(nobs(m2) == M$n_modele)
stopifnot(all(abs(round(coef(m2), 4) - M$coefs$b) < 1e-9))
stopifnot(all(abs(round(coef(summary(m2))[, 2], 4) - M$coefs$se) < 1e-9))
N <- lire("NOTRE")
stopifnot(nobs(lm(interet ~ scolarite, data = ces1000)) == N$n_modele)

# ---- 1. Trois niveaux de confiance.
r <- function(x, k = 4) round(x, k)
ic <- lapply(c(0.95, 0.99, 0.999), function(l) confint(m2, level = l))
s <- coef(summary(m2))
termes <- rownames(s)[-1]
NIVEAUX <- list(
  n_modele = nobs(m2),
  niveaux = c(0.95, 0.99, 0.999),
  coefs = lapply(termes, function(t) list(
    terme = t, b = r(s[t, 1]), se = r(s[t, 2]), p = signif(s[t, 4], 3),
    # bas et haut à 95 %, 99 %, 99,9 %, dans cet ordre.
    bas = sapply(ic, function(x) r(x[t, 1])),
    haut = sapply(ic, function(x) r(x[t, 2]))))
)
# La règle des étoiles, vérifiée : autant d'étoiles que de moustaches qui évitent 0.
for (k in NIVEAUX$coefs) {
  evite <- sum(k$bas > 0 | k$haut < 0)
  etoiles <- (k$p < 0.05) + (k$p < 0.01) + (k$p < 0.001)
  stopifnot(evite == etoiles)
}

# ---- 2. Le gabarit. Ces chaînes sont le code montré sur les diapos.
modele <- m2
PREPARER <- 'library(broom)
library(dplyr)

# Des noms en français, dans l\'ordre du tableau
noms <- c(scolarite = "Scolarité", age = "Âge",
          femme = "Femme", revenu = "Revenu",
          quebec = "Québec")

coefs <- tidy(modele, conf.int = TRUE) |>
  filter(term != "(Intercept)") |>
  mutate(variable = factor(noms[term],
                           levels = rev(noms)))'
DESSINER <- 'library(ggplot2)

ggplot(coefs, aes(x = estimate, y = variable)) +
  geom_vline(xintercept = 0, linetype = "dashed",
             colour = "grey60") +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high),
                  size = 0.7, linewidth = 1) +
  scale_x_continuous(labels = scales::label_number(
    decimal.mark = ",")) +
  labs(x = "Effet sur l\'intérêt pour la politique (0 à 1)",
       y = NULL,
       caption = "Intervalles de confiance à 95 %.") +
  theme_minimal(base_size = 15) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.text.y = element_text(colour = "black"),
        plot.caption = element_text(colour = "grey40"))'
ENREGISTRER <- 'ggsave("graphique.png", width = 7, height = 4, dpi = 300)'
EN_UNE_LIGNE <- 'library(modelsummary)

modelplot(modele, coef_map = rev(noms)) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(x = "Effet sur l\'intérêt pour la politique (0 à 1)")'

img <- normalizePath(file.path(ici, "..", "static", "img"))
tmp <- tempfile("gabarit"); dir.create(tmp)
vieux <- setwd(tmp)
eval(parse(text = PREPARER))
print(coefs)
print(eval(parse(text = DESSINER)))
eval(parse(text = ENREGISTRER))
file.copy("graphique.png", file.path(img, "s7-gabarit-ggplot.png"), overwrite = TRUE)
g2 <- eval(parse(text = EN_UNE_LIGNE))
ggsave("modelplot.png", g2, width = 5.6, height = 3.2, dpi = 300)
file.copy("modelplot.png", file.path(img, "s7-gabarit-modelplot.png"), overwrite = TRUE)
setwd(vieux)

GABARIT <- list(preparer = PREPARER, dessiner = DESSINER, enregistrer = ENREGISTRER,
                en_une_ligne = EN_UNE_LIGNE,
                image = "s7-gabarit-ggplot.png", image_modelplot = "s7-gabarit-modelplot.png",
                largeur = 2100, hauteur = 1200, largeur_modelplot = 1680, hauteur_modelplot = 960)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_h.R. Source : Étude électorale canadienne 2025, notre",
  "   sondage (1 000 tiré.e.s parmi les 20 180, graine 62), le modèle à plusieurs",
  "   variables de seance7.js (MULTIPLE). Ne pas modifier à la main. */",
  "",
  "/* Les intervalles de confiance à 95 %, 99 % et 99,9 % de chaque coefficient",
  "   (bas[k], haut[k] pour niveaux[k]), constante exclue. */",
  paste0("export const NIVEAUX = ", J(NIVEAUX), ";"),
  "/* Le gabarit du graphique des coefficients : le code exact qui a produit",
  "   static/img/s7-gabarit-ggplot.png et s7-gabarit-modelplot.png. */",
  paste0("export const GABARIT = ", J(GABARIT), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_h.js"), useBytes = TRUE)
cat("seance7_h.js écrit\n")
