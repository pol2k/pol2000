# Les données de la séance 7 (la régression linéaire simple), toutes dans
# src/lib/data/seance7.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# L'exemple fil rouge : la note donnée à Mark Carney (thermomètre de 0 à 100,
# cps25_lead_rating_23) selon la position gauche-droite (0 à 10,
# cps25_lr_scale_bef_1). Le code -99 (pas de réponse) devient NA.
#
# Le dispositif est celui de la séance 5 : les 20 180 répondant.e.s de la CES
# 2025 sont la population d'exercice. On y connaît la vraie droite. Chaque
# sondage tire 1 000 personnes parmi les 20 180 (comme le « budget de 1 000 »),
# puis la régression se fait sur celles et ceux qui ont répondu aux deux
# questions : R garde donc moins de 1 000 lignes (NOTRE$n_modele).
#
# Le hasard est fixé bloc par bloc (set.seed). Notre sondage est la graine 62,
# comme à la séance 5. Aucune valeur n'est écrite à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

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
N_POP <- nrow(ces)
BUDGET <- 1000

r <- function(x, k = 4) round(x, k)
coefs <- function(m) {
  s <- coef(summary(m)); ci <- confint(m)
  lapply(seq_len(nrow(s)), function(i) list(
    terme = rownames(s)[i], b = r(s[i, 1]), se = r(s[i, 2]), t = r(s[i, 3], 2),
    p = signif(s[i, 4], 3), bas = r(ci[i, 1]), haut = r(ci[i, 2])))
}
pente <- function(x) unname(coef(lm(note_carney ~ gauche_droite, data = x))[2])
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]

# ---- 1. La population : les 20 180, la vraie droite.
m_pop <- lm(note_carney ~ gauche_droite, data = ces)
complets <- ces[!is.na(ces$note_carney) & !is.na(ces$gauche_droite), ]
POP <- list(
  n = N_POP, n_modele = nobs(m_pop),
  b0 = r(coef(m_pop)[[1]]), b1 = r(coef(m_pop)[[2]]),
  r2 = r(summary(m_pop)$r.squared),
  # La moyenne de la note de Carney à chaque cran de l'échelle, et combien de monde.
  moyennes = lapply(0:10, function(k) {
    v <- complets$note_carney[complets$gauche_droite == k]
    list(x = k, moyenne = r(mean(v), 2), n = length(v))
  })
)

# ---- 2. Notre sondage : 1 000 personnes parmi les 20 180 (graine 62).
set.seed(62)
ces1000 <- tirer(ces)
m <- lm(note_carney ~ gauche_droite, data = ces1000)
nous <- ces1000[!is.na(ces1000$note_carney) & !is.na(ces1000$gauche_droite), ]
set.seed(620)
NOTRE <- list(
  n = BUDGET, n_modele = nobs(m), coefs = coefs(m),
  r2 = r(summary(m)$r.squared), sigma = r(summary(m)$sigma, 2),
  ecart_x = r(sd(nous$gauche_droite), 3),
  # Les points du nuage. gauche_droite est un entier : `jx` l'étale de ± 0,3
  # pour le dessin seulement (le modèle utilise `x`).
  points = lapply(seq_len(nrow(nous)), function(i) list(
    x = nous$gauche_droite[i], jx = r(nous$gauche_droite[i] + runif(1, -0.3, 0.3), 3),
    y = nous$note_carney[i]))
)

# La sortie de summary(), telle que R l'imprime.
CODE_LM <- "modele <- lm(note_carney ~ gauche_droite, data = ces1000)"
CODE_SUMMARY <- "summary(modele)"
modele <- m
SUMMARY <- paste(capture.output(print(summary(modele))), collapse = "\n")

# ---- 3. Quinze personnes de notre sondage : la droite qui passe le plus près.
set.seed(15)
q <- nous[sample(nrow(nous), 15), ]
m15 <- lm(note_carney ~ gauche_droite, data = q)
QUINZE <- list(
  points = lapply(seq_len(nrow(q)), function(i) list(x = q$gauche_droite[i], y = q$note_carney[i])),
  b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
  # La somme des carrés des écarts verticaux, à son minimum (la droite de R).
  somme_carres = r(sum(resid(m15)^2), 1)
)

# ---- 4. Mille sondages de 1 000 au hasard, puis mille au Québec seulement.
set.seed(2025)
hasard <- replicate(1000, pente(tirer(ces)))
qc <- ces[ces$quebec == 1, ]
set.seed(2026)
quebec <- replicate(1000, pente(tirer(qc)))
MILLE <- list(
  hasard = r(hasard, 3), quebec = r(quebec, 3),
  moyenne_hasard = r(mean(hasard), 3), moyenne_quebec = r(mean(quebec), 3),
  ecart_type_hasard = r(sd(hasard), 3),
  n_quebec_pop = nrow(qc),
  b1_quebec_pop = r(coef(lm(note_carney ~ gauche_droite, data = qc))[[2]], 3)
)

# ---- 5. Ce qui fait grandir l'erreur-type (vraies données).
#   taille : 1 000 sondages de 100 personnes (contre MILLE$hasard, 1 000);
#   centre : 1 000 sondages de 1 000 personnes tirées parmi celles qui se placent
#            de 4 à 6 seulement (X varie peu).
set.seed(100)
petits <- replicate(1000, pente(tirer(ces, 100)))
centre_pool <- ces[!is.na(ces$gauche_droite) & ces$gauche_droite >= 4 & ces$gauche_droite <= 6, ]
set.seed(456)
centre <- replicate(1000, pente(tirer(centre_pool)))
ERREUR_TYPE <- list(
  cent = list(n = 100, pentes = r(petits, 3), ecart_type = r(sd(petits), 3)),
  mille = list(n = 1000, ecart_type = r(sd(hasard), 3)),
  centre = list(n = 1000, bornes = c(4, 6), n_pool = nrow(centre_pool),
                pentes = r(centre, 3), ecart_type = r(sd(centre), 3)),
  # L'erreur-type que R calcule avec UN seul sondage (le nôtre) : proche de
  # l'écart type des 1 000 pentes, sans avoir fait 1 000 sondages.
  notre_se = NOTRE$coefs[[2]]$se
)

# ---- 6. Le monde où H0 est vraie : on mélange gauche_droite dans notre
# sondage (le lien disparaît, tout le reste reste), 1 000 fois.
set.seed(7)
h0 <- replicate(1000, { z <- nous; z$gauche_droite <- sample(z$gauche_droite); pente(z) })
b1 <- coef(m)[[2]]
# Un petit sondage de 50 personnes (graine 62), pour une valeur p qui n'est pas 0.
set.seed(62)
p50 <- tirer(ces, 50)
m50 <- lm(note_carney ~ gauche_droite, data = p50)
p50c <- p50[!is.na(p50$note_carney) & !is.na(p50$gauche_droite), ]
set.seed(8)
h0_50 <- replicate(1000, { z <- p50c; z$gauche_droite <- sample(z$gauche_droite); pente(z) })
b50 <- coef(m50)[[2]]
H0 <- list(
  notre = list(b1 = r(b1), pentes = r(h0, 3), aussi_loin = sum(abs(h0) >= abs(b1)),
               ecart_type = r(sd(h0), 3)),
  cinquante = list(n = 50, n_modele = nobs(m50), coefs = coefs(m50), pentes = r(h0_50, 3),
                   aussi_loin = sum(abs(h0_50) >= abs(b50)), ecart_type = r(sd(h0_50), 3))
)

# ---- 7. Vingt sondages et leurs intervalles de confiance à 95 %. Le premier
# est notre sondage. Pour les 19 autres, la première graine à partir de 70 qui
# donne exactement un raté sur 20 (comme « 19 fois sur 20 » à la séance 5).
ic <- function(x) { mm <- lm(note_carney ~ gauche_droite, data = x); ci <- confint(mm)[2, ]
  list(b1 = r(coef(mm)[[2]]), bas = r(ci[[1]]), haut = r(ci[[2]]),
       couvre = ci[[1]] <= POP$b1 & POP$b1 <= ci[[2]]) }
premier <- ic(ces1000)
for (g in 70:500) {
  set.seed(g)
  autres <- lapply(1:19, function(i) ic(tirer(ces)))
  if (sum(!sapply(c(list(premier), autres), `[[`, "couvre")) == 1) break
}
VINGT <- list(graine = g, sondages = c(list(premier), autres))

# ---- 8. Un modèle à plusieurs variables, pour le tableau et le graphique des
# coefficients. Même sondage (ces1000). Âge en dizaines d'années.
ces1000$age10 <- ces1000$age / 10
m2 <- lm(note_carney ~ gauche_droite + age10 + femme + quebec + universitaire, data = ces1000)
MULTIPLE <- list(
  code = "lm(note_carney ~ gauche_droite + age10 + femme + quebec + universitaire, data = ces1000)",
  n_modele = nobs(m2), r2 = r(summary(m2)$r.squared), coefs = coefs(m2),
  summary = paste(capture.output(print(summary(m2))), collapse = "\n")
)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_data.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération. Exemple fil rouge : note_carney (0 à 100) selon",
  "   gauche_droite (0 à 10). Ne pas modifier à la main. */",
  "",
  "/* La population : la vraie droite, et la moyenne de la note à chaque cran. */",
  paste0("export const POP = ", J(POP), ";"),
  "/* Notre sondage : 1 000 tiré.e.s parmi les 20 180 (graine 62), le modèle sur les",
  "   cas complets (n_modele). coefs[0] = constante, coefs[1] = gauche_droite. */",
  paste0("export const NOTRE = ", J(NOTRE), ";"),
  "/* Le code et la sortie de summary(), tels que R les imprime (width = 100). */",
  paste0("export const CODE_LM = ", J(CODE_LM), ";"),
  paste0("export const CODE_SUMMARY = ", J(CODE_SUMMARY), ";"),
  paste0("export const SUMMARY = ", J(SUMMARY), ";"),
  "/* Quinze personnes de notre sondage et leur droite des moindres carrés. */",
  paste0("export const QUINZE = ", J(QUINZE), ";"),
  "/* 1 000 sondages de 1 000 au hasard, et 1 000 au Québec seulement : les pentes. */",
  paste0("export const MILLE = ", J(MILLE), ";"),
  "/* Ce qui fait grandir l'erreur-type : moins de monde, X qui varie peu. */",
  paste0("export const ERREUR_TYPE = ", J(ERREUR_TYPE), ";"),
  "/* Le monde où H0 est vraie (gauche_droite mélangée) : 1 000 pentes, pour notre",
  "   sondage et pour un petit sondage de 50. aussi_loin = pentes au moins aussi loin de 0. */",
  paste0("export const H0 = ", J(H0), ";"),
  "/* Vingt sondages et leur intervalle de confiance à 95 % pour la pente. */",
  paste0("export const VINGT = ", J(VINGT), ";"),
  "/* Le modèle à plusieurs variables (même sondage), pour le tableau et le graphique. */",
  paste0("export const MULTIPLE = ", J(MULTIPLE), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7.js"))

cat("POP b0 =", POP$b0, " b1 =", POP$b1, " n_modele =", POP$n_modele, "\n")
cat("NOTRE n_modele =", NOTRE$n_modele, " b1 =", NOTRE$coefs[[2]]$b, " se =", NOTRE$coefs[[2]]$se, "\n")
cat("MILLE sd hasard =", MILLE$ecart_type_hasard, " moy quebec =", MILLE$moyenne_quebec, "\n")
cat("ET : 100 ->", ERREUR_TYPE$cent$ecart_type, " centre ->", ERREUR_TYPE$centre$ecart_type, "\n")
cat("H0 notre aussi_loin =", H0$notre$aussi_loin, " | 50 : b1 =", H0$cinquante$coefs[[2]]$b,
    " p =", H0$cinquante$coefs[[2]]$p, " aussi_loin =", H0$cinquante$aussi_loin, "\n")
cat("VINGT graine =", g, " rates =", sum(!sapply(VINGT$sondages, `[[`, "couvre")), "\n")
cat("MULTIPLE n =", MULTIPLE$n_modele, "\n"); print(round(coef(summary(m2)), 3))
