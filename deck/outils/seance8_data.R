# Les données de la séance 8 (la régression linéaire multiple), toutes dans
# src/lib/data/seance8.js, et les images static/img/s8-*.png. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds CHROMOTE_CHROME=/usr/sbin/chromium Rscript outils/seance8_data.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération.
#
# Deux moitiés, comme la séance (la première heure, Zotero, n'a pas de données).
#
# 1. Comprendre (avant la pause) : la suite exacte de la séance 7. Mêmes
#    variables, même préparation que outils/seance7_data.R, même sondage
#    (ces1000, graine 62, 1 000 personnes parmi les 20 180). On vérifie à la
#    fin que le modèle à plusieurs variables est celui de seance7.js
#    (MULTIPLE).
#
# 2. Blais en 2025 (après la pause) : Blais (2005, CJPS 38:4) trouve, en
#    Ontario et dans l'Atlantique de 1965 à 2004, que les catholiques ont
#    18 points de plus de chances de voter libéral. On le teste sur toute la
#    CES 2025 : deux variables nettoyées en classe (liberal, catho), les
#    contrôles fournis tout prêts. Le code affiché est une chaîne, et c'est
#    CETTE chaîne qui est exécutée (eval(parse())), dans un dossier
#    temporaire qui contient ces2025.rds, comme le dossier de la salle. La
#    syntaxe est celle de la séance 4 (df_raw, df_clean, case_when). Le
#    tableau est rendu par modelsummary lui-même. Rien n'est retapé à la
#    main, sauf les chiffres publiés de Blais (BLAIS, ci-dessous, cités).
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
    p = signif(s[i, 4], 3), bas = r(ci[i, 1]), haut = r(ci[i, 2]), etoiles = etoiles(s[i, 4])))
}
# Les étoiles de modelsummary(stars = TRUE) : + 0,1 · * 0,05 · ** 0,01 · *** 0,001.
etoiles <- function(p) if (p < 0.001) "***" else if (p < 0.01) "**" else if (p < 0.05) "*" else if (p < 0.1) "+" else ""

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

# ---- 1e. Le modèle de la séance 7, pour lire une seule ligne (la scolarité).
MULTI <- list(n_modele = nobs(m_multi), r2 = r(summary(m_multi)$r.squared, 3), coefs = coefs(m_multi), age_max = AGE_MAX)

# ======================================================================
# 2. BLAIS EN 2025 : le code exact de la salle, exécuté tel quel.
# ======================================================================
# Ce que Blais a publié : son tableau 1 (p. 824) et son tableau 2 (p. 826),
# recopiés de l'article. Logit, CES 1965-2004 empilées. « Impact » : la
# différence de probabilité de voter libéral (sa note 1).
BLAIS <- list(
  reference = "Blais, André. 2005. « Accounting for the Electoral Success of the Liberal Party in Canada ». Revue canadienne de science politique 38 (4) : 821-840.",
  doi = "10.1017/S0008423905050304",
  est = list(titre = "Ontario et Atlantique", n = 11157, lignes = list(
    list(nom = "Atlantique", coef = "0,00", impact = ""),
    list(nom = "Catholique", coef = "0,72**", impact = "0,18", cle = TRUE),
    list(nom = "Français", coef = "0,33**", impact = "0,08"),
    list(nom = "Europe de l'Est", coef = "0,03", impact = ""),
    list(nom = "Europe du Sud", coef = "0,53**", impact = "0,13"),
    list(nom = "Europe de l'Ouest", coef = "−0,20**", impact = "−0,05"),
    list(nom = "Asie, Amérique latine, Afrique", coef = "0,98**", impact = "0,23"),
    list(nom = "Constante", coef = "−0,48**", impact = ""))),
  catho = 0.18, catho_ouest = 0.12, n_ouest = 6736
)

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
  "library(haven)",
  "df_raw <- readRDS(\"ces2025.rds\")",
  "nrow(df_raw)",
  "df_clean <- data.frame(id = 1:nrow(df_raw))"
)
# Y : le vote libéral (intention de vote pendant la campagne).
ATELIER$vote <- console(
  "table(as_factor(df_raw$cps25_votechoice))"
)
ATELIER$liberal <- console(
  paste0("df_clean$liberal <- case_when(\n",
         "  df_raw$cps25_votechoice == 1 ~ 1,             # le Parti libéral\n",
         "  df_raw$cps25_votechoice %in% c(2:6, 8) ~ 0    # un autre parti\n",
         "  # 7 (ne sait pas) : aucune ligne, donc NA\n",
         ")"),
  "table(df_clean$liberal, useNA = \"ifany\")"
)
# X : catholique ou non.
ATELIER$religion <- console(
  "table(df_raw$cps25_religion)"
)
ATELIER$catho <- console(
  paste0("df_clean$catho <- case_when(\n",
         "  df_raw$cps25_religion == 10 ~ 1,   # catholique\n",
         "  df_raw$cps25_religion <= 22 ~ 0    # une autre religion, ou aucune\n",
         "  # 23 (ne sait pas) : aucune ligne, donc NA\n",
         ")"),
  "table(df_clean$catho, useNA = \"ifany\")"
)
# Les contrôles, fournis tout prêts (un bloc à copier).
CONTROLES <- paste0(
  "# Les contrôles, tout prêts : copiez-collez ce bloc\n",
  "df_clean$region <- case_when(\n",
  "  df_raw$cps25_province == 9 ~ \"Ontario\",\n",
  "  df_raw$cps25_province %in% c(4, 5, 7, 10) ~ \"Atlantique\",\n",
  "  df_raw$cps25_province %in% c(1, 2, 3, 12) ~ \"Ouest\"\n",
  "  # le Québec et les territoires : NA, comme chez Blais\n",
  ")\n",
  "df_clean$atlantique <- case_when(\n",
  "  df_clean$region == \"Atlantique\" ~ 1,\n",
  "  df_clean$region == \"Ontario\" ~ 0\n",
  ")\n",
  "df_clean$immigrant <- case_when(\n",
  "  df_raw$cps25_bornin_canada == 2 ~ 1,   # né.e hors du Canada\n",
  "  df_raw$cps25_bornin_canada == 1 ~ 0\n",
  ")")
ATELIER$controles <- console(CONTROLES, "table(df_clean$region, useNA = \"ifany\")")
ATELIER$filtrer <- console(
  "df_blais <- filter(df_clean, region %in% c(\"Ontario\", \"Atlantique\"))",
  "nrow(df_blais)"
)
ATELIER$modeles <- console(
  "modele1 <- lm(liberal ~ catho, data = df_blais)",
  "modele2 <- lm(liberal ~ catho + atlantique + immigrant, data = df_blais)",
  "nobs(modele1)",
  "nobs(modele2)"
)
MANQUANTS <- as.list(colSums(is.na(df_blais[, c("liberal", "catho", "atlantique", "immigrant")])))
# Garde-fou : l'essai exploratoire du 21 octobre (n = 5 835, b = 0,017).
stopifnot(nobs(modele2) == 5835, abs(coef(modele2)[["catho"]] - 0.017) < 0.002)

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
  "noms <- c(\"(Intercept)\" = \"Constante\", \"catho\" = \"Catholique\",\n",
  "  \"atlantique\" = \"Atlantique\", \"immigrant\" = \"Né.e hors du Canada\")\n",
  "modeles <- list(\"Catholique seul\" = modele1, \"Avec contrôles\" = modele2)\n",
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"))"), "s8-tableau.png")

# Le même tableau, dans un fichier Word (il faut le paquet pandoc; Positron
# fournit le programme pandoc lui-même).
WORD <- list(code = paste0(
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"), output = \"blais2025.docx\")"))
eval(parse(text = WORD$code), envir = globalenv())
stopifnot(file.exists("blais2025.docx"))

# Si on a le temps : l'Ouest (le tableau 2 de Blais : 12 points).
ATELIER$ouest <- console(
  "df_ouest <- filter(df_clean, region == \"Ouest\")",
  "modele3 <- lm(liberal ~ catho + immigrant, data = df_ouest)",
  "round(coef(modele3), 3)"
)
options(OutDec = ".")
# Le vote libéral chez les non-catholiques et chez les catholiques
# (modele1 : la constante, puis la constante + le coefficient).
parts <- tapply(model.frame(modele1)$liberal, model.frame(modele1)$catho, mean)
COEFS <- list(modele1 = coefs(modele1), modele2 = coefs(modele2), modele3 = coefs(modele3),
              manquants = MANQUANTS, n_ces = nrow(df_raw), n_blais = nrow(df_blais),
              parts = list(non = r(parts[["0"]]), catho = r(parts[["1"]])),
              n_groupes = as.list(table(model.frame(modele1)$catho)),
              n = list(modele1 = nobs(modele1), modele2 = nobs(modele2), modele3 = nobs(modele3)))
stopifnot(abs(COEFS$parts$catho - COEFS$parts$non - coef(modele1)[["catho"]]) < 1e-3)
setwd(ancien)

# ---- Le script complet de la salle : tout le code affiché, dans l'ordre, en
# cinq morceaux (une diapo chacun). Il doit tourner seul, dans une session R
# vierge (Rscript --vanilla), dans un dossier qui ne contient que
# ces2025.rds : c'est ce que la salle fera.
ins <- function(cle) paste(sapply(ATELIER[[cle]], `[[`, "in"), collapse = "\n")
SCRIPT <- c(
  paste0("# POL-2000 · séance 8 · Blais (2005) en 2025\n",
         "# À refaire chez vous, ligne par ligne, Ctrl + Entrée.\n\n",
         ins("charger"), "\n\n", ins("vote"), "\n", ins("liberal")),
  paste(ins("religion"), ins("catho"), sep = "\n\n"),
  ins("controles"),
  paste(ins("filtrer"), ins("modeles"), TABLEAU$code, WORD$code, sep = "\n\n"),
  paste0("# Si on a le temps : l'Ouest\n", ins("ouest"))
)
vierge <- tempfile("s8-vierge-"); dir.create(vierge)
saveRDS(d, file.path(vierge, "ces2025.rds"))
writeLines(paste(SCRIPT, collapse = "\n\n"), file.path(vierge, "seance8.R"))
statut <- system(sprintf("cd %s && Rscript --vanilla seance8.R > /dev/null 2>&1", shQuote(vierge)))
stopifnot(statut == 0, file.exists(file.path(vierge, "blais2025.docx")))

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
  "/* Le modèle à plusieurs variables de la séance 7. */",
  paste0("export const MULTI = ", J(MULTI), ";"),
  "/* Blais (2005), tableau 1 (p. 824) et tableau 2 (p. 826) : recopiés de l'article. */",
  paste0("export const BLAIS = ", J(BLAIS), ";"),
  "/* Blais en 2025 : toute la CES. Les consoles, à options(width = 100), dans l'ordre. */",
  paste0("export const ATELIER = ", J(ATELIER), ";"),
  paste0("export const CONTROLES = ", J(CONTROLES), ";"),
  "/* Le tableau à deux colonnes (image) et le même tableau dans Word. */",
  paste0("export const TABLEAU = ", J(TABLEAU), ";"),
  paste0("export const WORD = ", J(WORD), ";"),
  "/* Les coefficients des modèles, N et le vote libéral par groupe. */",
  paste0("export const COEFS = ", J(COEFS), ";"),
  "/* Le script complet, en cinq morceaux : vérifié dans une session R vierge. */",
  paste0("export const SCRIPT = ", J(SCRIPT), ";")
), file.path(ici, "..", "src", "lib", "data", "seance8.js"))

cat("PARALLELES n =", PARALLELES$n, " seule b1 =", PARALLELES$seule[[2]]$b, " deux :", sapply(PARALLELES$deux, `[[`, "b"), "\n")
cat("TRANCHES :", TRANCHES$b1_seul, "->", TRANCHES$b1_a_egal, "\n")
cat("ESCALIER :", sapply(ESCALIER$modeles, `[[`, "b"), "\n")
for (m in c("modele1", "modele2", "modele3")) cat(m, "n =", COEFS$n[[m]], ":", sapply(COEFS[[m]], function(c) paste0(c$terme, " ", c$b, c$etoiles, " [", c$bas, "; ", c$haut, "]")), "\n")
cat("parts :", unlist(COEFS$parts), " groupes :", unlist(COEFS$n_groupes), " manquants :", unlist(MANQUANTS), "\n")
cat("tableau", TABLEAU$l, "x", TABLEAU$h, "\n")
