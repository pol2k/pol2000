# Les données de la séance 7 (la régression linéaire simple), toutes dans
# src/lib/data/seance7.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_data.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# L'exemple fil rouge (choisi par le prof le 14 octobre 2026) : un classique,
# la scolarité et l'intérêt pour la politique, recodés de 0 à 1 comme
# toujours dans le cours.
#   X = scolarite (cps25_education, codebook p. 41) : le plus haut niveau de
#       scolarité complété, regroupé en cinq niveaux (les trois premiers codes
#       du codebook ne comptent qu'une soixantaine de personnes) :
#         codes 1 à 4  « Secondaire non terminé »        0
#         code 5       « Secondaire »                    0,25
#         codes 6 et 7 « Collégial »                     0,5
#         codes 8 et 9 « Université, 1er cycle »         0,75
#         codes 10, 11 « Maîtrise, doctorat »            1
#   Y = interet (cps25_interest_gen_1, p. 45) : le curseur de 0 (aucun
#       intérêt) à 10 (beaucoup d'intérêt), divisé par 10.
# « Ne sais pas / Préfère ne pas répondre » (code 12, ou -99) devient NA.
#
# Le dispositif est celui de la séance 5 : les 20 180 répondant.e.s de la CES
# 2025 sont la population d'exercice. On y connaît la vraie droite. Chaque
# sondage tire 1 000 personnes parmi les 20 180 (comme le « budget de 1 000 »),
# puis la régression se fait sur celles et ceux qui ont répondu aux deux
# questions (NOTRE$n_modele).
#
# Le hasard est fixé bloc par bloc (set.seed). Notre sondage est la graine 62,
# comme à la séance 5. Aucune valeur n'est écrite à la main.
suppressPackageStartupMessages({ library(haven) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

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
  # Les variables du modèle à plusieurs variables, toutes de 0 à 1.
  age = (ans - 18) / (max(ans, na.rm = TRUE) - 18),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  revenu = (rev - 1) / 7,
  quebec = as.numeric(grepl("Quebec", prov)),
  # Pour le sondage « facile » : l'intention de vote conservatrice.
  vote_conservateur = as.numeric(as.numeric(d$cps25_votechoice) %in% 2)
)
stopifnot(nrow(ces) == 20180)
N_POP <- nrow(ces)
BUDGET <- 1000
NX <- c(0, 0.25, 0.5, 0.75, 1)

VARS <- list(
  x = list(nom = "scolarite", court = "Scolarité", code = "cps25_education", page = 41,
           question = "Quel est votre plus haut niveau de scolarité complété ?",
           valeurs = NX,
           niveaux = c("Secondaire non terminé", "Secondaire", "Collégial", "Université, 1er cycle", "Maîtrise, doctorat"),
           # Les codes du codebook regroupés dans chaque niveau.
           codes = list(1:4, 5, 6:7, 8:9, 10:11),
           reponses = c("Aucune scolarité", "Quelques années d'école primaire", "École primaire terminée",
                        "Quelques années d'école secondaire", "École secondaire terminée",
                        "Quelques années d'études au collège, au cégep ou au collège classique",
                        "Études terminées au collège, au cégep, ou au collège classique",
                        "Quelques années d'études universitaires", "Baccalauréat", "Maîtrise",
                        "Diplôme professionnel ou doctorat")),
  y = list(nom = "interet", court = "Intérêt pour la politique", code = "cps25_interest_gen_1", page = 45,
           question = "Quel est votre niveau d'intérêt pour la politique en général ? Veuillez glisser le curseur sur un chiffre de 0 à 10, où 0 indique aucun intérêt du tout et 10 indique beaucoup d'intérêt.",
           min = 0, max = 10, bornes = c("Aucun intérêt", "Beaucoup d'intérêt"))
)

r <- function(x, k = 4) round(x, k)
coefs <- function(m) {
  s <- coef(summary(m)); ci <- confint(m)
  lapply(seq_len(nrow(s)), function(i) list(
    terme = rownames(s)[i], b = r(s[i, 1]), se = r(s[i, 2]), t = r(s[i, 3], 2),
    p = signif(s[i, 4], 3), bas = r(ci[i, 1]), haut = r(ci[i, 2])))
}
pente <- function(x) unname(coef(lm(interet ~ scolarite, data = x))[2])
tirer <- function(pool, n = BUDGET) pool[sample(nrow(pool), n), ]
complets <- function(x) x[!is.na(x$interet) & !is.na(x$scolarite), ]
# La moyenne de l'intérêt à chaque niveau de scolarité (le « dot plot »).
moyennes <- function(x) {
  x <- complets(x)
  lapply(NX, function(a) { v <- x$interet[abs(x$scolarite - a) < 1e-9]
    list(x = a, moyenne = r(mean(v)), n = length(v)) })
}
# Combien de personnes à chaque niveau de scolarité × chaque valeur d'intérêt (0 à 10).
cases <- function(x) {
  x <- complets(x); out <- list()
  for (a in NX) for (b in (0:10) / 10) out[[length(out) + 1]] <- list(x = a, y = b,
    n = sum(abs(x$scolarite - a) < 1e-9 & abs(x$interet - b) < 1e-9))
  out
}

# ---- 1. La population : les 20 180, la vraie droite.
m_pop <- lm(interet ~ scolarite, data = ces)
POP <- list(
  n = N_POP, n_modele = nobs(m_pop),
  b0 = r(coef(m_pop)[[1]]), b1 = r(coef(m_pop)[[2]]),
  r2 = r(summary(m_pop)$r.squared),
  r = r(cor(ces$scolarite, ces$interet, use = "complete.obs")),
  moyennes = moyennes(ces), cases = cases(ces)
)

# ---- 2. Notre sondage : 1 000 personnes parmi les 20 180 (graine 62).
set.seed(62)
ces1000 <- tirer(ces)
m <- lm(interet ~ scolarite, data = ces1000)
nous <- complets(ces1000)
manque_x <- is.na(ces1000$scolarite); manque_y <- is.na(ces1000$interet)
set.seed(620)
NOTRE <- list(
  n = BUDGET, n_modele = nobs(m), coefs = coefs(m),
  r2 = r(summary(m)$r.squared), sigma = r(summary(m)$sigma),
  ecart_x = r(sd(nous$scolarite)), moyenne_y = r(mean(nous$interet)),
  manquants = list(x_seulement = sum(manque_x & !manque_y), y_seulement = sum(manque_y & !manque_x),
                   les_deux = sum(manque_x & manque_y)),
  moyennes = moyennes(ces1000), cases = cases(ces1000),
  # Les points du nuage. La scolarité n'a que 5 valeurs et l'intérêt 11 :
  # `jx` et `jy` les étalent un peu (± 0,06 et ± 0,025) pour le dessin
  # seulement, en colonnes. Le modèle utilise `x` et `y`.
  points = lapply(seq_len(nrow(nous)), function(i) list(
    x = nous$scolarite[i], y = nous$interet[i],
    jx = r(nous$scolarite[i] + runif(1, -0.06, 0.06)),
    jy = r(nous$interet[i] + runif(1, -0.025, 0.025))))
)

# La sortie de summary(), telle que R l'imprime.
CODE_LM <- "modele <- lm(interet ~ scolarite, data = ces1000)"
CODE_SUMMARY <- "summary(modele)"
modele <- m
SUMMARY <- paste(capture.output(print(summary(modele))), collapse = "\n")

# ---- 3. Quinze personnes de notre sondage : la droite qui passe le plus près.
# Quinze personnes au hasard peuvent donner n'importe quelle pente. Pour une
# diapo qui montre la méthode, on prend la première graine à partir de 15 dont
# la pente va dans le sens de la population (entre 0,1 et 0,3) et qui couvre
# au moins quatre niveaux de scolarité : documenté ici, comme pour VINGT.
for (g15 in 15:500) {
  set.seed(g15); q <- nous[sample(nrow(nous), 15), ]; m15 <- lm(interet ~ scolarite, data = q)
  if (coef(m15)[[2]] >= 0.1 && coef(m15)[[2]] <= 0.3 && length(unique(q$scolarite)) >= 4) break
}
set.seed(150)
QUINZE <- list(graine = g15,
  points = lapply(seq_len(nrow(q)), function(i) list(x = q$scolarite[i], y = q$interet[i],
    jx = r(q$scolarite[i] + runif(1, -0.04, 0.04)))),
  b0 = r(coef(m15)[[1]]), b1 = r(coef(m15)[[2]]),
  # La somme des carrés des écarts verticaux, à son minimum (la droite de R).
  somme_carres = r(sum(resid(m15)^2))
)

# ---- 4. Mille sondages de 1 000 au hasard, puis mille sondages « faciles » :
# seulement des électeurs et électrices conservateurs (intention de vote
# pendant la campagne, cps25_votechoice = 2). Choix du prof (15 octobre) :
# un sondage « au Québec seulement » donnait 0,159 contre 0,172, un écart trop
# petit devant le hasard. Chez les conservateurs, la pente tombe à 0,124.
set.seed(2025)
hasard <- replicate(1000, pente(tirer(ces)))
conserv <- ces[ces$vote_conservateur %in% 1, ]
set.seed(2026)
facile <- replicate(1000, pente(tirer(conserv)))
MILLE <- list(
  hasard = r(hasard), facile = r(facile),
  facile_nom = "seulement des électeurs conservateurs",
  moyenne_hasard = r(mean(hasard)), moyenne_facile = r(mean(facile)),
  ecart_type_hasard = r(sd(hasard)), ecart_type_facile = r(sd(facile)),
  n_facile_pop = nrow(conserv),
  b1_facile_pop = r(coef(lm(interet ~ scolarite, data = conserv))[[2]]),
  # La moyenne de l'intérêt à chaque niveau, chez les conservateurs.
  moyennes_facile = moyennes(conserv)
)

# ---- 5. Ce qui fait grandir l'erreur type (vraies données). Chaque sondage
# tire ici des personnes qui ont répondu aux deux questions.
#   base : 1 000 sondages de 500 personnes;
#   petit : 1 000 sondages de 50 personnes;
#   centre : 1 000 sondages de 500 personnes du collégial et de l'université,
#            1er cycle, seulement (0,5 et 0,75 : X varie peu).
pool <- complets(ces)
set.seed(500)
base <- replicate(1000, pente(tirer(pool, 500)))
set.seed(50)
petits <- replicate(1000, pente(tirer(pool, 50)))
centre_pool <- pool[pool$scolarite >= 0.5 & pool$scolarite <= 0.75, ]
set.seed(456)
centre <- replicate(1000, pente(tirer(centre_pool, 500)))
ERREUR_TYPE <- list(
  base = list(n = 500, pentes = r(base), ecart_type = r(sd(base)), ecart_x = r(sd(pool$scolarite))),
  petit = list(n = 50, pentes = r(petits), ecart_type = r(sd(petits))),
  centre = list(n = 500, bornes = c(0.5, 0.75), n_pool = nrow(centre_pool), ecart_x = r(sd(centre_pool$scolarite)),
                pentes = r(centre), ecart_type = r(sd(centre))),
  notre_se = NOTRE$coefs[[2]]$se
)

# ---- 6. Le monde où H0 est vraie : on mélange la scolarité dans notre
# sondage (le lien disparaît, tout le reste reste), 1 000 fois.
set.seed(7)
h0 <- replicate(1000, { z <- nous; z$scolarite <- sample(z$scolarite); pente(z) })
b1 <- coef(m)[[2]]
# Un petit sondage de 50 personnes. Avec 50 personnes, environ 8 sondages sur
# 10 ne rejettent pas H0 (rejet_a_50, sur 1 000 graines). On prend la première
# graine à partir de 62 dont la pente est positive et la valeur p dépasse 0,05 :
# un cas typique, pas un accident.
rejet50 <- mean(sapply(1:1000, function(g) { set.seed(g); z <- tirer(ces, 50)
  coef(summary(lm(interet ~ scolarite, data = z)))[2, 4] < 0.05 }))
for (g50 in 62:500) {
  set.seed(g50); p50 <- tirer(ces, 50); m50 <- lm(interet ~ scolarite, data = p50)
  if (coef(m50)[[2]] > 0 && coef(summary(m50))[2, 4] > 0.05) break
}
p50c <- complets(p50)
set.seed(8)
h0_50 <- replicate(1000, { z <- p50c; z$scolarite <- sample(z$scolarite); pente(z) })
b50 <- coef(m50)[[2]]
H0 <- list(
  notre = list(b1 = r(b1), pentes = r(h0), aussi_loin = sum(abs(h0) >= abs(b1)),
               ecart_type = r(sd(h0))),
  cinquante = list(n = 50, graine = g50, rejet_a_50 = rejet50, n_modele = nobs(m50), coefs = coefs(m50),
                   pentes = r(h0_50), aussi_loin = sum(abs(h0_50) >= abs(b50)), ecart_type = r(sd(h0_50)))
)

# ---- 7. Vingt sondages et leurs intervalles de confiance à 95 %. Le premier
# est notre sondage. Pour les 19 autres, la première graine à partir de 70 qui
# donne exactement un raté sur 20 (comme « 19 fois sur 20 » à la séance 5).
ic <- function(x) { mm <- lm(interet ~ scolarite, data = x); ci <- confint(mm)[2, ]
  list(b1 = r(coef(mm)[[2]]), bas = r(ci[[1]]), haut = r(ci[[2]]),
       couvre = ci[[1]] <= POP$b1 & POP$b1 <= ci[[2]]) }
premier <- ic(ces1000)
for (g in 70:500) {
  set.seed(g)
  autres <- lapply(1:19, function(i) ic(tirer(ces)))
  if (sum(!sapply(c(list(premier), autres), `[[`, "couvre")) == 1) break
}
VINGT <- list(graine = g, sondages = c(list(premier), autres))

# ---- 8. Une troisième variable, dans la vraie CES : l'âge. Les plus âgé.e.s
# ont en moyenne moins de scolarité, mais plus d'intérêt pour la politique.
# Laissé dans ε, l'âge CACHE donc une partie du lien : à âge égal, la pente de
# la scolarité monte. Une troisième variable peut aussi masquer un lien.
# Les 20 180, cas complets.
pc <- complets(ces); pc <- pc[!is.na(pc$age), ]
a35 <- (35 - 18) / (max(ans, na.rm = TRUE) - 18); a65 <- (65 - 18) / (max(ans, na.rm = TRUE) - 18)
m_seul <- lm(interet ~ scolarite, data = pc)
m_z <- lm(interet ~ scolarite + age, data = pc)
TIERS <- list(
  nom = "age", court = "l'âge", n = nrow(pc),
  b1_seul = r(coef(m_seul)[[2]]), b1_a_egal = r(coef(m_z)[["scolarite"]]),
  effet_tiers = r(coef(m_z)[["age"]]),
  cor_x_tiers = r(cor(pc$scolarite, pc$age)),
  # La scolarité moyenne et l'intérêt moyen des 35 ans et moins et des 65 ans et plus.
  jeunes = list(scolarite = r(mean(pc$scolarite[pc$age <= a35])), interet = r(mean(pc$interet[pc$age <= a35]))),
  aines = list(scolarite = r(mean(pc$scolarite[pc$age >= a65])), interet = r(mean(pc$interet[pc$age >= a65]))),
  # Les autres troisièmes variables essayées, et la pente de la scolarité à chacune égale.
  essais = lapply(c("age", "femme", "revenu", "quebec"), function(z) {
    k <- complets(ces); k <- k[!is.na(k[[z]]), ]
    list(variable = z, b1_seul = r(coef(lm(interet ~ scolarite, data = k))[[2]]),
         b1_a_egal = r(coef(lm(as.formula(paste("interet ~ scolarite +", z)), data = k))[["scolarite"]])) })
)

# ---- 9. Un modèle à plusieurs variables, pour le tableau et le graphique des
# coefficients. Même sondage (ces1000). Tout de 0 à 1 (l'âge : 0 = 18 ans,
# 1 = l'âge le plus élevé de la CES).
m2 <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)
MULTIPLE <- list(
  code = "lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)",
  n_modele = nobs(m2), r2 = r(summary(m2)$r.squared), coefs = coefs(m2),
  age_max = max(ans, na.rm = TRUE),
  summary = paste(capture.output(print(summary(m2))), collapse = "\n")
)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_data.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s comme population d'exercice,",
  "   sans pondération. Exemple fil rouge : interet (0 à 1) selon scolarite (cinq",
  "   niveaux, 0 à 1). Ne pas modifier à la main. */",
  "",
  "/* Les deux variables : nom, question du codebook (page), niveaux et codes regroupés. */",
  paste0("export const VARS = ", J(VARS), ";"),
  "/* La population : la vraie droite, la moyenne de l'intérêt à chaque niveau, et le",
  "   nombre de personnes à chaque niveau × chaque valeur d'intérêt. */",
  paste0("export const POP = ", J(POP), ";"),
  "/* Notre sondage : 1 000 tiré.e.s parmi les 20 180 (graine 62), le modèle sur les",
  "   cas complets (n_modele). coefs[0] = constante, coefs[1] = scolarite. */",
  paste0("export const NOTRE = ", J(NOTRE), ";"),
  "/* Le code et la sortie de summary(), tels que R les imprime (width = 100). */",
  paste0("export const CODE_LM = ", J(CODE_LM), ";"),
  paste0("export const CODE_SUMMARY = ", J(CODE_SUMMARY), ";"),
  paste0("export const SUMMARY = ", J(SUMMARY), ";"),
  "/* Quinze personnes de notre sondage et leur droite des moindres carrés. */",
  paste0("export const QUINZE = ", J(QUINZE), ";"),
  "/* 1 000 sondages de 1 000 au hasard, et 1 000 parmi les gens déjà intéressés : les pentes. */",
  paste0("export const MILLE = ", J(MILLE), ";"),
  "/* Ce qui fait grandir l'erreur type : moins de monde, X qui varie peu (sondages de cas complets). */",
  paste0("export const ERREUR_TYPE = ", J(ERREUR_TYPE), ";"),
  "/* Le monde où H0 est vraie (scolarité mélangée) : 1 000 pentes, pour notre sondage et",
  "   pour un petit sondage de 50. aussi_loin = pentes au moins aussi loin de 0. */",
  paste0("export const H0 = ", J(H0), ";"),
  "/* Vingt sondages et leur intervalle de confiance à 95 % pour la pente. */",
  paste0("export const VINGT = ", J(VINGT), ";"),
  "/* Une troisième variable réelle (l'âge) : elle masque une partie du lien. */",
  paste0("export const TIERS = ", J(TIERS), ";"),
  "/* Le modèle à plusieurs variables (même sondage), pour le tableau et le graphique. */",
  paste0("export const MULTIPLE = ", J(MULTIPLE), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7.js"))

cat("POP b0 =", POP$b0, " b1 =", POP$b1, " n_modele =", POP$n_modele, " r2 =", POP$r2, "\n")
cat("moyennes :", sapply(POP$moyennes, `[[`, "moyenne"), "\n")
cat("NOTRE n_modele =", NOTRE$n_modele, " b0 =", NOTRE$coefs[[1]]$b, " b1 =", NOTRE$coefs[[2]]$b,
    " se =", NOTRE$coefs[[2]]$se, " t =", NOTRE$coefs[[2]]$t, " r2 =", NOTRE$r2, "\n")
cat("manquants :", unlist(NOTRE$manquants), "\n")
cat("MILLE sd hasard =", MILLE$ecart_type_hasard, " moy hasard =", MILLE$moyenne_hasard,
    " moy facile =", MILLE$moyenne_facile, " (pop", MILLE$b1_facile_pop, ")\n")
cat("ET : 500 ->", ERREUR_TYPE$base$ecart_type, " 50 ->", ERREUR_TYPE$petit$ecart_type, " centre ->", ERREUR_TYPE$centre$ecart_type, "\n")
cat("H0 notre aussi_loin =", H0$notre$aussi_loin, " | 50 : graine", g50, "rejet", rejet50, "n =", H0$cinquante$n_modele, " b1 =",
    H0$cinquante$coefs[[2]]$b, " p =", H0$cinquante$coefs[[2]]$p, " aussi_loin =", H0$cinquante$aussi_loin, "\n")
cat("VINGT graine =", g, " rates =", sum(!sapply(VINGT$sondages, `[[`, "couvre")), "\n")
cat("TIERS :", TIERS$b1_seul, "->", TIERS$b1_a_egal, " cor", TIERS$cor_x_tiers, " jeunes", unlist(TIERS$jeunes), " aines", unlist(TIERS$aines), "\n")
cat("QUINZE graine", g15, "b1 =", QUINZE$b1, "\n")
cat("MULTIPLE n =", MULTIPLE$n_modele, "\n"); print(round(coef(summary(m2)), 3))
