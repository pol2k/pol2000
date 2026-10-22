# Les chiffres des trois diapositives « Sortir une variable du bruit » de la
# séance 8 (M8Bruit, M8Paralleles, M8Pente), dans src/lib/data/seance8_bruit.js.
# Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance8_bruit.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# La préparation est celle de outils/seance8_data.R, section 1, à l'identique
# (donc celle de la séance 7) : même sondage (graine 62, 1 000 personnes
# parmi les 20 180). On vérifie à la fin que nos modèles sont ceux de
# PARALLELES et d'ESCALIER (src/lib/data/seance8.js), et que nos points
# sont, dans le même ordre, ceux de PARALLELES : les diapos 13 et 14
# montrent les mêmes personnes, avec le même étalement.
#
#   GENRE  les 877 d'ESCALIER (toutes les variables du modèle de la séance 7) :
#          la scolarité seule, puis avec « femme » (deux droites parallèles),
#          et l'intérêt moyen par niveau et par genre;
#   AGE    les mêmes 877 :
#          la droite de la scolarité seule, puis avec l'âge (ordonnée à
#          l'origine et pente), et la droite du modèle à 18, 50 et 80 ans;
#   SAVOIR les mêmes 877, moins celles qui préfèrent ne pas répondre : la
#          scolarité seule, puis avec « connaît le nom de la gouverneure
#          générale » (cps25_govgen_name == 3, Mary Simon; « je ne sais pas »
#          et les mauvais noms = 0). Elle change beaucoup la pente, mais
#          c'est un descendant de la scolarité (règle 1 : on ne la contrôle
#          pas). Aucune variable d'avant la scolarité de la CES ne la change
#          autant (essai du 22 octobre : l'âge, +9 %, est celle qui la change
#          le plus);
#   POINTS pour chacune des 969 personnes de PARALLELES, dans le même ordre :
#          son âge en années et si elle fait partie des 877.
suppressPackageStartupMessages(library(haven))

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
ici <- normalizePath(ici)
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")
r <- function(x, k = 4) round(x, k)

# ---- La préparation de seance8_data.R (section 1), à l'identique.
prov <- as.character(as_factor(d$cps25_province))
ans <- as.numeric(d$cps25_age_in_years)
int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
genre <- as.numeric(d$cps25_genderid)
rev <- as.numeric(d$cps25_income); rev[!(rev %in% 1:8)] <- NA
AGE_MAX <- max(ans, na.rm = TRUE)
ces <- data.frame(
  interet = int / 10,
  scolarite = (niveau - 1) / 4,
  age = (ans - 18) / (AGE_MAX - 18),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  revenu = (rev - 1) / 7,
  quebec = as.numeric(grepl("Quebec", prov)),
  niveau = niveau,
  ans = ans
)
stopifnot(nrow(ces) == 20180)
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]

# ---- Les 969 de PARALLELES (mêmes personnes, même ordre, même étalement).
k <- ces1000[!is.na(ces1000$interet) & !is.na(ces1000$scolarite) & !is.na(ces1000$femme), ]
m_seule <- lm(interet ~ scolarite, data = k)
m_femme <- lm(interet ~ scolarite + femme, data = k)
set.seed(800)
jit <- t(sapply(seq_len(nrow(k)), function(i) c(
  jx = r(k$scolarite[i] + runif(1, -0.07, 0.07)),
  jy = r(k$interet[i] + runif(1, -0.025, 0.025)))))

# ---- Les 877 d'ESCALIER.
VARS <- c("interet", "scolarite", "age", "femme", "revenu", "quebec")
dans5 <- complete.cases(k[, VARS])
k5 <- ces1000[complete.cases(ces1000[, VARS]), ]
stopifnot(nrow(k5) == sum(dans5))
a_seule <- lm(interet ~ scolarite, data = k5)
a_age <- lm(interet ~ scolarite + age, data = k5)
ag <- function(an) (an - 18) / (AGE_MAX - 18)
ligne_a <- function(an) list(ans = an, b0 = r(coef(a_age)[[1]] + coef(a_age)[["age"]] * ag(an)), b1 = r(coef(a_age)[["scolarite"]]))

# Le genre, sur les mêmes 877 (pour que la droite seule soit la même sur
# les deux diapos, et la même que la première marche de l'escalier).
g_seule <- lm(interet ~ scolarite, data = k5)
g_femme <- lm(interet ~ scolarite + femme, data = k5)
NX <- c(0, 0.25, 0.5, 0.75, 1)
GENRE <- list(
  n = nrow(k5),
  seule = list(b0 = r(coef(g_seule)[[1]]), b1 = r(coef(g_seule)[[2]])),
  deux = list(b0 = r(coef(g_femme)[[1]]), b1 = r(coef(g_femme)[["scolarite"]]), femme = r(coef(g_femme)[["femme"]])),
  # L'intérêt moyen à chaque niveau, chez les hommes et chez les femmes.
  moyennes = do.call(c, lapply(c(0, 1), function(fm) lapply(NX, function(a) {
    v <- k5$interet[abs(k5$scolarite - a) < 1e-9 & k5$femme == fm]
    list(femme = fm, x = a, moyenne = r(mean(v)), n = length(v)) }))),
  sigma_seule = r(summary(g_seule)$sigma), sigma_deux = r(summary(g_femme)$sigma)
)
AGE <- list(
  n = nrow(k5), age_max = AGE_MAX, age_moyen = r(mean(k5$ans), 1),
  seule = list(b0 = r(coef(a_seule)[[1]]), b1 = r(coef(a_seule)[[2]])),
  avec = list(b0 = r(coef(a_age)[[1]]), b1 = r(coef(a_age)[["scolarite"]]), age = r(coef(a_age)[["age"]])),
  lignes = lapply(c(18, 50, 80), ligne_a),
  sigma_seule = r(summary(a_seule)$sigma), sigma_age = r(summary(a_age)$sigma)
)
# Connaît le nom de la gouverneure générale, pour les mêmes personnes (le
# numéro de ligne de ces1000 est celui de la CES).
gg <- as.numeric(d$cps25_govgen_name); gg[!(gg %in% 1:5)] <- NA
ks <- k5; ks$sait <- as.numeric(gg == 3)[as.numeric(rownames(k5))]
ks <- ks[!is.na(ks$sait), ]
s_seule <- lm(interet ~ scolarite, data = ks)
s_avec <- lm(interet ~ scolarite + sait, data = ks)
ligne_s <- function(v, nom) list(nom = nom, b0 = r(coef(s_avec)[[1]] + coef(s_avec)[["sait"]] * v), b1 = r(coef(s_avec)[["scolarite"]]))
SAVOIR <- list(
  n = nrow(ks), part = r(mean(ks$sait), 2),
  seule = list(b0 = r(coef(s_seule)[[1]]), b1 = r(coef(s_seule)[[2]])),
  avec = list(b0 = r(coef(s_avec)[[1]]), b1 = r(coef(s_avec)[["scolarite"]]), sait = r(coef(s_avec)[["sait"]])),
  lignes = list(ligne_s(0, "ne sait pas"), ligne_s(1, "sait"))
)
stopifnot(SAVOIR$avec$b1 < 0.8 * SAVOIR$seule$b1)
POINTS <- lapply(seq_len(nrow(k)), function(i) list(ans = k$ans[i], m = as.numeric(dans5[i])))

# ---- Vérifications : PARALLELES et ESCALIER de seance8.js.
js8 <- readLines(file.path(ici, "..", "src", "lib", "data", "seance8.js"))
lit <- function(nom) jsonlite::fromJSON(sub(paste0("^export const ", nom, " = (.*);$"), "\\1",
  grep(paste0("^export const ", nom, " = "), js8, value = TRUE)))
P <- lit("PARALLELES"); E <- lit("ESCALIER")
stopifnot(P$n == nrow(k),
          all(abs(round(coef(m_seule), 4) - P$seule$b) < 1e-9),
          all(abs(round(coef(m_femme), 4) - P$deux$b) < 1e-9),
          all(abs(P$points$jx - jit[, "jx"]) < 1e-9), all(abs(P$points$jy - jit[, "jy"]) < 1e-9),
          all(P$points$y == k$interet), all(P$points$femme == k$femme),
          E$n == nrow(k5),
          abs(E$modeles$b[1] - AGE$seule$b1) < 1e-9, abs(GENRE$seule$b1 - AGE$seule$b1) < 1e-9, abs(E$modeles$b[2] - AGE$avec$b1) < 1e-9)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance8_bruit.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Les 877 d'ESCALIER : la scolarité seule, puis avec « femme », et l'intérêt moyen par niveau et par genre. */",
  paste0("export const GENRE = ", J(GENRE), ";"),
  "/* Les 877 d'ESCALIER : la scolarité seule, puis avec l'âge, et la droite du modèle à 18, 50 et 80 ans. */",
  paste0("export const AGE = ", J(AGE), ";"),
  "/* Les 877, moins « préfère ne pas répondre » : la scolarité seule, puis avec « connaît le nom de la gouverneure générale » (un descendant). */",
  paste0("export const SAVOIR = ", J(SAVOIR), ";"),
  "/* Pour chacune des 969 de PARALLELES.points, dans le même ordre : l'âge (ans) et m = 1 si elle est dans les 877. */",
  paste0("export const POINTS = ", J(POINTS), ";")
), file.path(ici, "..", "src", "lib", "data", "seance8_bruit.js"))

str(GENRE); str(AGE); str(SAVOIR)
