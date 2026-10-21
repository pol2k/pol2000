# Les données de la séance 8 (la régression linéaire multiple), toutes dans
# src/lib/data/seance8.js, et les images static/img/s8-*.png. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds CHROMOTE_CHROME=/usr/sbin/chromium Rscript outils/seance8_data.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Deux moitiés, comme la séance.
#
# 1. Comprendre (avant la pause) : la suite exacte de la séance 7. Mêmes
#    variables, même préparation que outils/seance7_data.R, même sondage
#    (ces1000, graine 62, 1 000 personnes parmi les 20 180). On vérifie à la
#    fin que le modèle à plusieurs variables est celui de seance7.js
#    (MULTIPLE).
#
# 2. L'atelier (après la pause) : toute la CES, comme dans le travail. Le
#    code affiché est une chaîne, et c'est CETTE chaîne qui est exécutée
#    (eval(parse())), dans un dossier temporaire qui contient ces2025.rds,
#    comme le dossier de la salle. La syntaxe est celle de la séance 4
#    (df_raw, df_clean, case_when). Les tableaux et le graphique sont rendus
#    par modelsummary et modelplot eux-mêmes. Rien n'est retapé à la main.
suppressPackageStartupMessages({ library(haven); library(modelsummary); library(ggplot2) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
ici <- normalizePath(ici)
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")
if (!nzchar(Sys.getenv("CHROMOTE_CHROME"))) Sys.setenv(CHROMOTE_CHROME = "/usr/sbin/chromium")
IMG <- normalizePath(file.path(ici, "..", "static", "img"))

r <- function(x, k = 4) round(x, k)
coefs <- function(m) {
  s <- coef(summary(m)); ci <- confint(m)
  lapply(seq_len(nrow(s)), function(i) list(
    terme = rownames(s)[i], b = r(s[i, 1]), se = r(s[i, 2]), t = r(s[i, 3], 2),
    p = signif(s[i, 4], 3), bas = r(ci[i, 1]), haut = r(ci[i, 2])))
}

# ======================================================================
# 1. COMPRENDRE : la préparation de outils/seance7_data.R, à l'identique.
# ======================================================================
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
NX <- c(0, 0.25, 0.5, 0.75, 1)
NIVEAUX <- c("Secondaire non terminé", "Secondaire", "Collégial", "Université, 1er cycle", "Maîtrise, doctorat")
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]

# Vérification : le modèle à plusieurs variables de la séance 7.
m_multi <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)
js7 <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"))
multiple7 <- jsonlite::fromJSON(sub("^export const MULTIPLE = (.*);$", "\\1",
  grep("^export const MULTIPLE = ", js7, value = TRUE)))
stopifnot(nobs(m_multi) == multiple7$n_modele,
          all(abs(round(coef(m_multi), 4) - multiple7$coefs$b) < 1e-9))

# ---- 1a. Deux droites parallèles : interet ~ scolarite + femme, notre sondage.
# Les personnes qui ont répondu aux trois questions.
k <- ces1000[!is.na(ces1000$interet) & !is.na(ces1000$scolarite) & !is.na(ces1000$femme), ]
m_seule <- lm(interet ~ scolarite, data = k)
m_femme <- lm(interet ~ scolarite + femme, data = k)
set.seed(800)
PARALLELES <- list(
  n = nrow(k),
  seule = coefs(m_seule), deux = coefs(m_femme),
  # La moyenne de l'intérêt à chaque niveau, chez les hommes et chez les femmes.
  moyennes = lapply(c(0, 1), function(fm) lapply(NX, function(a) {
    v <- k$interet[abs(k$scolarite - a) < 1e-9 & k$femme == fm]
    list(femme = fm, x = a, moyenne = r(mean(v)), n = length(v)) })),
  # Les points, étalés un peu pour le dessin seulement (jx, jy).
  points = lapply(seq_len(nrow(k)), function(i) list(
    x = k$scolarite[i], y = k$interet[i], femme = k$femme[i],
    jx = r(k$scolarite[i] + runif(1, -0.07, 0.07)),
    jy = r(k$interet[i] + runif(1, -0.025, 0.025))))
)

# ---- 1b. À âge égal, par tranches : les 20 180 (cas complets), comme TIERS
# à la séance 7. Trois tranches d'âge. Dans chacune, la droite de la
# scolarité. Puis la pente seule et la pente à âge égal (l'âge de 0 à 1).
pc <- ces[!is.na(ces$interet) & !is.na(ces$scolarite) & !is.na(ces$age), ]
TR <- list(c(18, 34, "18 à 34 ans"), c(35, 54, "35 à 54 ans"), c(55, AGE_MAX, "55 ans et plus"))
TRANCHES <- list(
  n = nrow(pc),
  b1_seul = r(coef(lm(interet ~ scolarite, data = pc))[[2]]),
  b1_a_egal = r(coef(lm(interet ~ scolarite + age, data = pc))[["scolarite"]]),
  tranches = lapply(TR, function(t) {
    g <- pc[pc$ans >= as.numeric(t[1]) & pc$ans <= as.numeric(t[2]), ]
    m <- lm(interet ~ scolarite, data = g)
    list(nom = t[3], n = nrow(g), b0 = r(coef(m)[[1]]), b1 = r(coef(m)[[2]]),
         scolarite = r(mean(g$scolarite)), interet = r(mean(g$interet)),
         moyennes = lapply(NX, function(a) r(mean(g$interet[abs(g$scolarite - a) < 1e-9]))))
  })
)

# ---- 1c. L'escalier : la pente de la scolarité quand on ajoute les
# variables une à une, toujours sur les mêmes personnes (les 877 du modèle
# complet, pour que seule la liste de variables change).
k5 <- ces1000[complete.cases(ces1000[, c("interet", "scolarite", "age", "femme", "revenu", "quebec")]), ]
FORMULES <- c("interet ~ scolarite", "interet ~ scolarite + age", "interet ~ scolarite + age + femme",
              "interet ~ scolarite + age + femme + revenu", "interet ~ scolarite + age + femme + revenu + quebec")
AJOUT <- c("seule", "+ âge", "+ femme", "+ revenu", "+ Québec")
ESCALIER <- list(n = nrow(k5), modeles = lapply(seq_along(FORMULES), function(i) {
  m <- lm(as.formula(FORMULES[i]), data = k5)
  s <- coef(summary(m))["scolarite", ]; ci <- confint(m)["scolarite", ]
  list(formule = FORMULES[i], ajout = AJOUT[i], b = r(s[[1]]), se = r(s[[2]]),
       bas = r(ci[[1]]), haut = r(ci[[2]]), r2 = r(summary(m)$r.squared, 3), sigma = r(summary(m)$sigma))
}))
stopifnot(ESCALIER$n == nobs(m_multi))

# ---- 1e. La constante et des profils : predict() sur le modèle de la
# séance 7 (MULTIPLE). Les âges en années, convertis comme les données.
a01 <- function(a) (a - 18) / (AGE_MAX - 18)
PROFILS_DEF <- list(
  list(nom = "Tout à zéro", desc = c("homme", "18 ans", "secondaire non terminé", "revenu le plus bas", "hors Québec"),
       x = data.frame(scolarite = 0, age = a01(18), femme = 0, revenu = 0, quebec = 0)),
  list(nom = "Camille", desc = c("femme", "24 ans", "collégial", "60 001 $ à 90 000 $", "au Québec"),
       x = data.frame(scolarite = 0.5, age = a01(24), femme = 1, revenu = 3 / 7, quebec = 1)),
  list(nom = "Robert", desc = c("homme", "70 ans", "maîtrise, doctorat", "110 001 $ à 150 000 $", "en Ontario"),
       x = data.frame(scolarite = 1, age = a01(70), femme = 0, revenu = 5 / 7, quebec = 0))
)
PROFILS <- lapply(PROFILS_DEF, function(p) list(nom = p$nom, desc = p$desc,
  valeurs = lapply(as.list(p$x), function(v) r(v)), prediction = r(unname(predict(m_multi, p$x)))))
stopifnot(abs(PROFILS[[1]]$prediction - r(coef(m_multi)[[1]])) < 1e-9)
MULTI <- list(n_modele = nobs(m_multi), r2 = r(summary(m_multi)$r.squared, 3), coefs = coefs(m_multi), age_max = AGE_MAX)

# ======================================================================
# 2. L'ATELIER : le code exact de la salle, exécuté tel quel.
# ======================================================================
tmp <- tempfile("s8-"); dir.create(tmp)
saveRDS(d, file.path(tmp, "ces2025.rds"))
ancien <- setwd(tmp)
rm(list = intersect(ls(), c("df_raw", "df_clean")))
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
console <- function(...) lapply(c(...), function(code) list(`in` = code, out = sortie(code)))

ATELIER <- list()
ATELIER$charger <- console(
  "library(dplyr)",
  "df_raw <- readRDS(\"ces2025.rds\")",
  "nrow(df_raw)",
  "df_clean <- data.frame(id = 1:nrow(df_raw))"
)
ATELIER$interet <- console(
  "table(df_raw$cps25_interest_gen_1)",
  paste0("df_clean$interet <- case_when(\n",
         "  df_raw$cps25_interest_gen_1 >= 0 ~ df_raw$cps25_interest_gen_1 / 10\n",
         ")"),
  "table(df_clean$interet, useNA = \"ifany\")"
)
ATELIER$scolarite <- console(
  paste0("df_clean$scolarite <- case_when(\n",
         "  df_raw$cps25_education <= 4  ~ 0,     # secondaire non terminé\n",
         "  df_raw$cps25_education == 5  ~ 0.25,  # secondaire\n",
         "  df_raw$cps25_education <= 7  ~ 0.5,   # collégial\n",
         "  df_raw$cps25_education <= 9  ~ 0.75,  # université, 1er cycle\n",
         "  df_raw$cps25_education <= 11 ~ 1     # maîtrise, doctorat\n",
         ")"),
  "table(df_clean$scolarite, useNA = \"ifany\")"
)
ATELIER$age <- console(
  "summary(df_raw$cps25_age_in_years)",
  "df_clean$age <- (df_raw$cps25_age_in_years - 18) / (96 - 18)",
  "summary(df_clean$age)"
)
ATELIER$femme <- console(
  paste0("df_clean$femme <- case_when(\n",
         "  df_raw$cps25_genderid == 2 ~ 1,   # une femme\n",
         "  df_raw$cps25_genderid == 1 ~ 0    # un homme\n",
         ")"),
  "table(df_clean$femme, useNA = \"ifany\")"
)
ATELIER$revenu <- console(
  "table(df_raw$cps25_income)",
  paste0("df_clean$revenu <- case_when(\n",
         "  df_raw$cps25_income <= 8 ~ (df_raw$cps25_income - 1) / 7\n",
         ")"),
  "table(round(df_clean$revenu, 2), useNA = \"ifany\")"
)
ATELIER$quebec <- console(
  paste0("df_clean$quebec <- case_when(\n",
         "  df_raw$cps25_province == 11 ~ 1,\n",
         "  df_raw$cps25_province != 11 ~ 0\n",
         ")"),
  "table(df_clean$quebec, useNA = \"ifany\")"
)
ATELIER$verifier <- console(
  "colSums(is.na(df_clean))"
)
MANQUANTS <- as.list(colSums(is.na(df_clean)))
# Le nettoyage de la salle donne-t-il les mêmes variables que la première moitié ?
for (v in c("interet", "scolarite", "age", "femme", "revenu", "quebec"))
  stopifnot(isTRUE(all.equal(as.numeric(df_clean[[v]]), as.numeric(ces[[v]]))))
ATELIER$modeles <- console(
  "modele1 <- lm(interet ~ scolarite, data = df_clean)",
  "modele2 <- lm(interet ~ scolarite + age + femme, data = df_clean)",
  "modele3 <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = df_clean)",
  "nobs(modele1)",
  "nobs(modele2)",
  "nobs(modele3)"
)

# Une image rendue par modelsummary : on ajoute seulement output = "….png" à
# la dernière ligne, comme dans outils/seance7_ms.R.
rendre_png <- function(code, fichier) {
  ex <- parse(text = code)
  if (length(ex) > 1) for (e in ex[-length(ex)]) eval(e, envir = globalenv())
  appel <- ex[[length(ex)]]
  stopifnot(identical(appel[[1]], as.name("modelsummary")))
  chemin <- file.path(IMG, fichier)
  appel$output <- chemin
  eval(appel, envir = globalenv())
  stopifnot(file.size(chemin) < 300 * 1024)
  dim <- dim(png::readPNG(chemin))
  list(code = code, img = fichier, l = dim[2], h = dim[1])
}
TABLEAU <- rendre_png(paste0(
  "library(modelsummary)\n",
  "options(OutDec = \",\")\n",
  "noms <- c(\"(Intercept)\" = \"Constante\",\n",
  "  \"scolarite\" = \"Scolarité (0 à 1)\", \"age\" = \"Âge (0 à 1)\",\n",
  "  \"femme\" = \"Femme\", \"revenu\" = \"Revenu (0 à 1)\",\n",
  "  \"quebec\" = \"Québec\")\n",
  "modeles <- list(\"Modèle 1\" = modele1, \"Modèle 2\" = modele2,\n",
  "                \"Modèle 3\" = modele3)\n",
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"))"), "s8-tableau.png")

# Le graphique des coefficients, en une ligne. ggsave() l'enregistre.
# Piège réel : avec options(OutDec = ","), modelplot() dessine un graphique
# vide (« NAs introduced by coercion »). On revient au point avant.
GRAPHIQUE <- list(code = paste0(
  "options(OutDec = \".\")   # modelplot() n'aime pas la virgule\n",
  "modelplot(modeles, coef_rename = noms, coef_omit = \"Intercept\") +\n",
  "  labs(x = \"Coefficient et intervalle de confiance à 95 %\", caption = NULL)"))
g <- eval(parse(text = GRAPHIQUE$code), envir = globalenv())
GRAPHIQUE$enregistrer <- "ggsave(\"coefficients.png\", width = 8, height = 5)"
# Pour la diapo : le même graphique, exporté plus petit (6 × 3,75 po à 200 ppp),
# pour que le texte se lise du fond de la salle.
ggsave(file.path(IMG, "s8-modelplot.png"), g, width = 6, height = 3.75, dpi = 200)
eval(parse(text = GRAPHIQUE$enregistrer), envir = globalenv())   # dans le dossier temporaire
stopifnot(file.exists("coefficients.png"))
dg <- dim(png::readPNG(file.path(IMG, "s8-modelplot.png")))
GRAPHIQUE <- c(GRAPHIQUE, list(img = "s8-modelplot.png", l = dg[2], h = dg[1]))

# Une variable catégorielle : le diplôme en mots. Les numéros en tête
# fixent l'ordre (R prend la première en ordre alphabétique comme référence).
ATELIER$categorie <- console(
  paste0("df_clean$diplome <- case_when(\n",
         "  df_raw$cps25_education <= 4  ~ \"1. Secondaire non terminé\",\n",
         "  df_raw$cps25_education == 5  ~ \"2. Secondaire\",\n",
         "  df_raw$cps25_education <= 7  ~ \"3. Collégial\",\n",
         "  df_raw$cps25_education <= 9  ~ \"4. Université, 1er cycle\",\n",
         "  df_raw$cps25_education <= 11 ~ \"5. Maîtrise, doctorat\"\n",
         ")"),
  "modele4 <- lm(interet ~ diplome + age + femme + revenu + quebec, data = df_clean)",
  "round(coef(modele4), 3)"
)

# À vous : la satisfaction envers la démocratie (recodée à la séance 4).
ATELIER$satisfaction <- console(
  paste0("df_clean$satisfaction <- case_when(\n",
         "  df_raw$cps25_demsat == 1 ~ 1,\n",
         "  df_raw$cps25_demsat == 2 ~ 0.67,\n",
         "  df_raw$cps25_demsat == 3 ~ 0.33,\n",
         "  df_raw$cps25_demsat == 4 ~ 0\n",
         ")"),
  "table(df_clean$satisfaction, useNA = \"ifany\")"
)
EXERCICE <- rendre_png(paste0(
  "options(OutDec = \",\")\n",
  "modele5 <- lm(satisfaction ~ scolarite + age + femme + revenu + quebec,\n",
  "              data = df_clean)\n",
  "modelsummary(list(\"Intérêt\" = modele3, \"Satisfaction\" = modele5),\n",
  "  stars = TRUE, coef_rename = noms, gof_map = c(\"nobs\", \"r.squared\"))"), "s8-exercice.png")
# Les coefficients des deux modèles, pour écrire les phrases de la diapo.
options(OutDec = ".")
COEFS <- list(modele1 = coefs(modele1), modele2 = coefs(modele2), modele3 = coefs(modele3),
              modele4 = coefs(modele4), modele5 = coefs(modele5),
              manquants = MANQUANTS, n_ces = nrow(df_raw),
              diplomes = as.list(table(model.frame(modele4)$diplome)),
              n = list(modele1 = nobs(modele1), modele2 = nobs(modele2), modele3 = nobs(modele3),
                       modele4 = nobs(modele4), modele5 = nobs(modele5)),
              r2 = list(modele1 = r(summary(modele1)$r.squared, 3), modele2 = r(summary(modele2)$r.squared, 3),
                        modele3 = r(summary(modele3)$r.squared, 3), modele5 = r(summary(modele5)$r.squared, 3)))
setwd(ancien)

# ---- Écriture.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance8_data.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Comprendre : notre sondage de la séance 7 (1 000, graine 62). Deux droites",
  "   parallèles : interet ~ scolarite + femme, sur celles et ceux qui ont répondu aux trois. */",
  paste0("export const PARALLELES = ", J(PARALLELES), ";"),
  "/* À âge égal, par tranches d'âge : les 20 180 (cas complets). */",
  paste0("export const TRANCHES = ", J(TRANCHES), ";"),
  "/* La pente de la scolarité, variable ajoutée par variable ajoutée, sur les mêmes 877. */",
  paste0("export const ESCALIER = ", J(ESCALIER), ";"),
  "/* Le modèle à plusieurs variables de la séance 7, et trois profils (predict()). */",
  paste0("export const MULTI = ", J(MULTI), ";"),
  paste0("export const PROFILS = ", J(PROFILS), ";"),
  "/* L'atelier : toute la CES. Les consoles, à options(width = 100), dans l'ordre. */",
  paste0("export const ATELIER = ", J(ATELIER), ";"),
  "/* Le tableau à trois colonnes, le graphique des coefficients et l'exercice (images). */",
  paste0("export const TABLEAU = ", J(TABLEAU), ";"),
  paste0("export const GRAPHIQUE = ", J(GRAPHIQUE), ";"),
  paste0("export const EXERCICE = ", J(EXERCICE), ";"),
  "/* Les coefficients des modèles de l'atelier, N et R². */",
  paste0("export const COEFS = ", J(COEFS), ";")
), file.path(ici, "..", "src", "lib", "data", "seance8.js"))

cat("PARALLELES n =", PARALLELES$n, " seule b1 =", PARALLELES$seule[[2]]$b, " deux :", sapply(PARALLELES$deux, `[[`, "b"), "\n")
cat("TRANCHES :", TRANCHES$b1_seul, "->", TRANCHES$b1_a_egal, " | ", sapply(TRANCHES$tranches, function(t) paste(t$nom, t$n, t$b1)), "\n")
cat("ESCALIER :", sapply(ESCALIER$modeles, `[[`, "b"), " r2", sapply(ESCALIER$modeles, `[[`, "r2"), "\n")
cat("PROFILS :", sapply(PROFILS, `[[`, "prediction"), "\n")
cat("ATELIER N :", unlist(COEFS$n), "\n")
cat("tableau", TABLEAU$l, "x", TABLEAU$h, " exercice", EXERCICE$l, "x", EXERCICE$h, " graphique", GRAPHIQUE$l, "x", GRAPHIQUE$h, "\n")
