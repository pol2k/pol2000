# Les données de la séance 7 (la régression linéaire simple), toutes dans
# src/lib/data/seance7.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# L'exemple fil rouge (choisi par le prof le 14 octobre 2026) : le populisme
# et la satisfaction envers la démocratie, deux questions du sondage
# post-électoral de la CES 2025, recodées de 0 à 1 comme toujours dans le
# cours.
#   X = populisme (pes25_populism_8) : « La plupart des politiciens se
#       soucient uniquement des intérêts des gens riches et puissants. »
#       Fortement en désaccord 0 · Plutôt en désaccord 0,25 · Ni l'un ni
#       l'autre 0,5 · Plutôt en accord 0,75 · Fortement en accord 1.
#   Y = satisfaction_dem (pes25_dem_sat) : satisfaction envers le
#       fonctionnement de la démocratie au Canada. Pas du tout satisfait 0 ·
#       Pas très 1/3 · Plutôt 2/3 · Très satisfait 1.
# « Je ne sais pas / Préfère ne pas répondre » devient NA. Les deux
# questions viennent de la même vague (après l'élection). La question sur le
# populisme n'a été posée qu'à une partie du sondage post-électoral (bloc
# tiré au hasard), d'où beaucoup de NA.
#
# Le dispositif est celui de la séance 5 : les 20 180 répondant.e.s de la CES
# 2025 sont la population d'exercice. On y connaît la vraie droite. Chaque
# sondage tire 1 000 personnes parmi les 20 180 (comme le « budget de 1 000 »),
# puis la régression se fait sur celles et ceux qui ont répondu aux deux
# questions : R garde donc bien moins de 1 000 lignes (NOTRE$n_modele).
#
# Le hasard est fixé bloc par bloc (set.seed). Notre sondage est la graine 62,
# comme à la séance 5. Aucune valeur n'est écrite à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# Échelle à k niveaux valides (1 à k) ramenée de 0 à 1; inv = TRUE inverse le sens.
ech <- function(v, k, inv = FALSE) {
  v <- as.numeric(v); v[!(v %in% 1:k)] <- NA
  z <- (v - 1) / (k - 1); if (inv) 1 - z else z
}
prov <- as.character(as_factor(d$cps25_province))
edu <- as.numeric(d$cps25_education)
genre <- as.numeric(d$cps25_genderid)
age <- as.numeric(d$cps25_age_in_years)
vote <- as.numeric(d$pes25_votechoice2025)
ces <- data.frame(
  satisfaction_dem = ech(d$pes25_dem_sat, 4, inv = TRUE),
  populisme = ech(d$pes25_populism_8, 5),
  # Les variables du modèle à plusieurs variables, toutes de 0 à 1.
  vote_liberal = ifelse(vote %in% 1:8, as.numeric(vote == 1), NA),
  age = (age - 18) / (max(age, na.rm = TRUE) - 18),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  quebec = as.numeric(grepl("Quebec", prov)),
  universitaire = ifelse(is.na(edu) | edu < 1 | edu > 11, NA, as.numeric(edu >= 8)),
  jeune = as.numeric(age <= 34)
)
stopifnot(nrow(ces) == 20180)
N_POP <- nrow(ces)
BUDGET <- 1000
NX <- c(0, 0.25, 0.5, 0.75, 1)
NY <- c(0, 1/3, 2/3, 1)

VARS <- list(
  x = list(nom = "populisme", court = "Populisme", code = "pes25_populism_8", page = 341,
           question = "La plupart des politiciens se soucient uniquement des intérêts des gens riches et puissants.",
           valeurs = NX,
           niveaux = c("Fortement en désaccord", "Plutôt en désaccord", "Ni en accord, ni en désaccord",
                       "Plutôt en accord", "Fortement en accord")),
  y = list(nom = "satisfaction_dem", court = "Satisfaction envers la démocratie", code = "pes25_dem_sat", page = 229,
           question = "Dans l’ensemble, êtes-vous très satisfait, assez satisfait, pas très satisfait ou pas du tout satisfait du fonctionnement de la démocratie au Canada ?",
           valeurs = round(NY, 4),
           niveaux = c("Pas du tout satisfait", "Pas très satisfait", "Plutôt satisfait", "Très satisfait")),
  age = list(min = 18, max = max(age, na.rm = TRUE))
)

r <- function(x, k = 4) round(x, k)
coefs <- function(m) {
  s <- coef(summary(m)); ci <- confint(m)
  lapply(seq_len(nrow(s)), function(i) list(
    terme = rownames(s)[i], b = r(s[i, 1]), se = r(s[i, 2]), t = r(s[i, 3], 2),
    p = signif(s[i, 4], 3), bas = r(ci[i, 1]), haut = r(ci[i, 2])))
}
pente <- function(x) unname(coef(lm(satisfaction_dem ~ populisme, data = x))[2])
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]
complets <- function(x) x[!is.na(x$satisfaction_dem) & !is.na(x$populisme), ]
# Combien de personnes dans chacune des 5 × 4 cases (populisme × satisfaction).
cases <- function(x) {
  x <- complets(x); out <- list()
  for (a in NX) for (b in NY) out[[length(out) + 1]] <- list(x = a, y = r(b),
    n = sum(abs(x$populisme - a) < 1e-9 & abs(x$satisfaction_dem - b) < 1e-9))
  out
}
moyennes <- function(x) {
  x <- complets(x)
  lapply(NX, function(a) { v <- x$satisfaction_dem[abs(x$populisme - a) < 1e-9]
    list(x = a, moyenne = r(mean(v)), n = length(v)) })
}

# ---- 1. La population : les 20 180, la vraie droite.
m_pop <- lm(satisfaction_dem ~ populisme, data = ces)
POP <- list(
  n = N_POP, n_modele = nobs(m_pop),
  b0 = r(coef(m_pop)[[1]]), b1 = r(coef(m_pop)[[2]]),
  r2 = r(summary(m_pop)$r.squared),
  r = r(cor(ces$populisme, ces$satisfaction_dem, use = "complete.obs")),
  moyennes = moyennes(ces), cases = cases(ces)
)

# ---- 2. Notre sondage : 1 000 personnes parmi les 20 180 (graine 62).
set.seed(62)
ces1000 <- tirer(ces)
m <- lm(satisfaction_dem ~ populisme, data = ces1000)
nous <- complets(ces1000)
# Pourquoi R ne garde pas les 1 000 : qui manque, et pourquoi.
manque_x <- is.na(ces1000$populisme); manque_y <- is.na(ces1000$satisfaction_dem)
set.seed(620)
NOTRE <- list(
  n = BUDGET, n_modele = nobs(m), coefs = coefs(m),
  r2 = r(summary(m)$r.squared), sigma = r(summary(m)$sigma),
  ecart_x = r(sd(nous$populisme)), moyenne_y = r(mean(nous$satisfaction_dem)),
  manquants = list(x_seulement = sum(manque_x & !manque_y), y_seulement = sum(manque_y & !manque_x),
                   les_deux = sum(manque_x & manque_y)),
  moyennes = moyennes(ces1000), cases = cases(ces1000),
  # Les points du nuage. Les deux variables n'ont que 5 et 4 valeurs : `jx` et
  # `jy` les étalent un peu (± 0,08 et ± 0,1) pour le dessin seulement, en
  # grappes autour de chaque case. Le modèle utilise `x` et `y`.
  points = lapply(seq_len(nrow(nous)), function(i) list(
    x = nous$populisme[i], y = r(nous$satisfaction_dem[i]),
    jx = r(nous$populisme[i] + runif(1, -0.08, 0.08)),
    jy = r(nous$satisfaction_dem[i] + runif(1, -0.1, 0.1))))
)

# La sortie de summary(), telle que R l'imprime.
CODE_LM <- "modele <- lm(satisfaction_dem ~ populisme, data = ces1000)"
CODE_SUMMARY <- "summary(modele)"
modele <- m
SUMMARY <- paste(capture.output(print(summary(modele))), collapse = "\n")

# ---- 3. Quinze personnes de notre sondage : la droite qui passe le plus près.
set.seed(15)
q <- nous[sample(nrow(nous), 15), ]
m15 <- lm(satisfaction_dem ~ populisme, data = q)
set.seed(150)
QUINZE <- list(
  points = lapply(seq_len(nrow(q)), function(i) list(x = q$populisme[i], y = r(q$satisfaction_dem[i]),
    jx = r(q$populisme[i] + runif(1, -0.05, 0.05)))),
  b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
  # La somme des carrés des écarts verticaux, à son minimum (la droite de R).
  somme_carres = r(sum(resid(m15)^2))
)

# ---- 4. Mille sondages de 1 000 au hasard, puis mille chez les 18 à 34 ans
# seulement (un sondage « facile », comme à la séance 5).
set.seed(2025)
hasard <- replicate(1000, pente(tirer(ces)))
jeunes <- ces[ces$jeune %in% 1, ]
set.seed(2026)
facile <- replicate(1000, pente(tirer(jeunes)))
MILLE <- list(
  hasard = r(hasard, 4), facile = r(facile, 4),
  facile_nom = "les 18 à 34 ans seulement",
  moyenne_hasard = r(mean(hasard)), moyenne_facile = r(mean(facile)),
  ecart_type_hasard = r(sd(hasard)), ecart_type_facile = r(sd(facile)),
  n_facile_pop = nrow(jeunes),
  b1_facile_pop = r(coef(lm(satisfaction_dem ~ populisme, data = jeunes))[[2]])
)

# ---- 5. Ce qui fait grandir l'erreur type (vraies données). Pour comparer
# à armes égales, chaque sondage tire ici des personnes qui ont répondu aux
# deux questions (sinon le nombre de cas complets change d'un pool à l'autre).
#   base : 1 000 sondages de 500 personnes;
#   petit : 1 000 sondages de 50 personnes;
#   centre : 1 000 sondages de 500 personnes, seulement parmi celles qui ont
#            répondu « ni en accord, ni en désaccord » ou « plutôt en accord »
#            (0,5 et 0,75 : X varie peu).
pool <- complets(ces)
set.seed(500)
base <- replicate(1000, pente(tirer(pool, 500)))
set.seed(50)
petits <- replicate(1000, pente(tirer(pool, 50)))
centre_pool <- pool[pool$populisme >= 0.5 & pool$populisme <= 0.75, ]
set.seed(456)
centre <- replicate(1000, pente(tirer(centre_pool, 500)))
ERREUR_TYPE <- list(
  base = list(n = 500, pentes = r(base), ecart_type = r(sd(base)), ecart_x = r(sd(pool$populisme))),
  petit = list(n = 50, pentes = r(petits), ecart_type = r(sd(petits))),
  centre = list(n = 500, bornes = c(0.5, 0.75), n_pool = nrow(centre_pool), ecart_x = r(sd(centre_pool$populisme)),
                pentes = r(centre), ecart_type = r(sd(centre))),
  # L'erreur type que R calcule avec UN seul sondage (le nôtre) : proche de
  # l'écart type des 1 000 pentes de MILLE$hasard, sans avoir fait 1 000 sondages.
  notre_se = NOTRE$coefs[[2]]$se
)

# ---- 6. Le monde où H0 est vraie : on mélange le populisme dans notre
# sondage (le lien disparaît, tout le reste reste), 1 000 fois.
set.seed(7)
h0 <- replicate(1000, { z <- nous; z$populisme <- sample(z$populisme); pente(z) })
b1 <- coef(m)[[2]]
# Un petit sondage de 50 personnes (graine 62) : la valeur p dépasse 0,05.
set.seed(62)
p50 <- tirer(ces, 50)
m50 <- lm(satisfaction_dem ~ populisme, data = p50)
p50c <- complets(p50)
set.seed(8)
h0_50 <- replicate(1000, { z <- p50c; z$populisme <- sample(z$populisme); pente(z) })
b50 <- coef(m50)[[2]]
H0 <- list(
  notre = list(b1 = r(b1), pentes = r(h0), aussi_loin = sum(abs(h0) >= abs(b1)),
               ecart_type = r(sd(h0))),
  cinquante = list(n = 50, n_modele = nobs(m50), coefs = coefs(m50), pentes = r(h0_50),
                   aussi_loin = sum(abs(h0_50) >= abs(b50)), ecart_type = r(sd(h0_50)))
)

# ---- 7. Vingt sondages et leurs intervalles de confiance à 95 %. Le premier
# est notre sondage. Pour les 19 autres, la première graine à partir de 70 qui
# donne exactement un raté sur 20 (comme « 19 fois sur 20 » à la séance 5).
ic <- function(x) { mm <- lm(satisfaction_dem ~ populisme, data = x); ci <- confint(mm)[2, ]
  list(b1 = r(coef(mm)[[2]]), bas = r(ci[[1]]), haut = r(ci[[2]]),
       couvre = ci[[1]] <= POP$b1 & POP$b1 <= ci[[2]]) }
premier <- ic(ces1000)
for (g in 70:500) {
  set.seed(g)
  autres <- lapply(1:19, function(i) ic(tirer(ces)))
  if (sum(!sapply(c(list(premier), autres), `[[`, "couvre")) == 1) break
}
VINGT <- list(graine = g, sondages = c(list(premier), autres))

# ---- 8. La variable confondante, dans la vraie CES : le vote libéral (les
# gagnant.e.s de l'élection). Les 20 180, cas complets.
pc <- complets(ces); pc <- pc[!is.na(pc$vote_liberal), ]
m_seul <- lm(satisfaction_dem ~ populisme, data = pc)
m_vote <- lm(satisfaction_dem ~ populisme + vote_liberal, data = pc)
lib <- pc$vote_liberal == 1
PARTI <- list(
  n = nrow(pc),
  b1_seul = r(coef(m_seul)[[2]]), b1_a_vote_egal = r(coef(m_vote)[["populisme"]]),
  effet_vote = r(coef(m_vote)[["vote_liberal"]]),
  populisme_moyen = list(liberal = r(mean(pc$populisme[lib])), autre = r(mean(pc$populisme[!lib]))),
  satisfaction_moyenne = list(liberal = r(mean(pc$satisfaction_dem[lib])), autre = r(mean(pc$satisfaction_dem[!lib]))),
  b1_liberaux = r(coef(lm(satisfaction_dem ~ populisme, data = pc[lib, ]))[[2]]),
  b1_autres = r(coef(lm(satisfaction_dem ~ populisme, data = pc[!lib, ]))[[2]])
)

# ---- 9. Un modèle à plusieurs variables, pour le tableau et le graphique des
# coefficients. Même sondage (ces1000). Tout de 0 à 1 (l'âge : 0 = 18 ans,
# 1 = l'âge le plus élevé de la CES).
m2 <- lm(satisfaction_dem ~ populisme + vote_liberal + age + femme + quebec + universitaire, data = ces1000)
MULTIPLE <- list(
  code = "lm(satisfaction_dem ~ populisme + vote_liberal + age + femme + quebec + universitaire, data = ces1000)",
  n_modele = nobs(m2), r2 = r(summary(m2)$r.squared), coefs = coefs(m2),
  summary = paste(capture.output(print(summary(m2))), collapse = "\n")
)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_data.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération. Exemple fil rouge : satisfaction_dem (0 à 1) selon",
  "   populisme (0 à 1). Ne pas modifier à la main. */",
  "",
  "/* Les deux variables : nom, question du codebook (page), valeurs et libellés. */",
  paste0("export const VARS = ", J(VARS), ";"),
  "/* La population : la vraie droite, la moyenne de Y à chaque valeur de X, et le",
  "   nombre de personnes dans chacune des 5 × 4 cases. */",
  paste0("export const POP = ", J(POP), ";"),
  "/* Notre sondage : 1 000 tiré.e.s parmi les 20 180 (graine 62), le modèle sur les",
  "   cas complets (n_modele). coefs[0] = constante, coefs[1] = populisme. */",
  paste0("export const NOTRE = ", J(NOTRE), ";"),
  "/* Le code et la sortie de summary(), tels que R les imprime (width = 100). */",
  paste0("export const CODE_LM = ", J(CODE_LM), ";"),
  paste0("export const CODE_SUMMARY = ", J(CODE_SUMMARY), ";"),
  paste0("export const SUMMARY = ", J(SUMMARY), ";"),
  "/* Quinze personnes de notre sondage et leur droite des moindres carrés. */",
  paste0("export const QUINZE = ", J(QUINZE), ";"),
  "/* 1 000 sondages de 1 000 au hasard, et 1 000 chez les 18 à 34 ans : les pentes. */",
  paste0("export const MILLE = ", J(MILLE), ";"),
  "/* Ce qui fait grandir l'erreur type : moins de monde, X qui varie peu (sondages de cas complets). */",
  paste0("export const ERREUR_TYPE = ", J(ERREUR_TYPE), ";"),
  "/* Le monde où H0 est vraie (populisme mélangé) : 1 000 pentes, pour notre",
  "   sondage et pour un petit sondage de 50. aussi_loin = pentes au moins aussi loin de 0. */",
  paste0("export const H0 = ", J(H0), ";"),
  "/* Vingt sondages et leur intervalle de confiance à 95 % pour la pente. */",
  paste0("export const VINGT = ", J(VINGT), ";"),
  "/* La variable confondante réelle : le vote libéral, dans les 20 180. */",
  paste0("export const PARTI = ", J(PARTI), ";"),
  "/* Le modèle à plusieurs variables (même sondage), pour le tableau et le graphique. */",
  paste0("export const MULTIPLE = ", J(MULTIPLE), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7.js"))

cat("POP b0 =", POP$b0, " b1 =", POP$b1, " n_modele =", POP$n_modele, " r2 =", POP$r2, "\n")
cat("NOTRE n_modele =", NOTRE$n_modele, " b0 =", NOTRE$coefs[[1]]$b, " b1 =", NOTRE$coefs[[2]]$b,
    " se =", NOTRE$coefs[[2]]$se, " t =", NOTRE$coefs[[2]]$t, " r2 =", NOTRE$r2, "\n")
cat("manquants :", unlist(NOTRE$manquants), "\n")
cat("MILLE sd hasard =", MILLE$ecart_type_hasard, " moy hasard =", MILLE$moyenne_hasard,
    " moy facile =", MILLE$moyenne_facile, " (pop jeunes", MILLE$b1_facile_pop, ")\n")
cat("ET : 500 ->", ERREUR_TYPE$base$ecart_type, " 50 ->", ERREUR_TYPE$petit$ecart_type, " centre ->", ERREUR_TYPE$centre$ecart_type, "\n")
cat("H0 notre aussi_loin =", H0$notre$aussi_loin, " | 50 : n =", H0$cinquante$n_modele, " b1 =",
    H0$cinquante$coefs[[2]]$b, " p =", H0$cinquante$coefs[[2]]$p, " aussi_loin =", H0$cinquante$aussi_loin, "\n")
cat("VINGT graine =", g, " rates =", sum(!sapply(VINGT$sondages, `[[`, "couvre")), "\n")
cat("PARTI :", PARTI$b1_seul, "->", PARTI$b1_a_vote_egal, " vote", PARTI$effet_vote, "\n")
cat("QUINZE b1 =", QUINZE$b1, "\n")
cat("MULTIPLE n =", MULTIPLE$n_modele, "\n"); print(round(coef(summary(m2)), 3))
