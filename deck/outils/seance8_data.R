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
# 2. Blais et Gélineau en 2025 (après la pause) : Blais et Gélineau (2007,
#    Political Studies 55:2) trouvent, dans la CES 1997, que les gagnants
#    d'une élection deviennent plus satisfaits de la démocratie que les
#    perdants, même à satisfaction égale avant l'élection. La CES 2025 pose
#    la même question pendant la campagne et après l'élection, aux mêmes
#    personnes : on le teste. Deux variables nettoyées en classe (apres,
#    gagnant), puis le contrôle (avant), même recette que Y. Le code affiché est une chaîne, et c'est
#    CETTE chaîne qui est exécutée (eval(parse())), dans un dossier
#    temporaire qui contient ces2025.rds, comme le dossier de la salle. La
#    syntaxe est celle de la séance 4 (df_raw, df_clean, case_when). Le
#    tableau est rendu par modelsummary lui-même. Rien n'est retapé à la
#    main, sauf les chiffres publiés de l'article (BG, ci-dessous, cités).
#
#    Deux façons de contribuer : VÉRIFIER (leur modèle, en 2025 : modele1,
#    modele2), puis FAIRE MIEUX. Leur note 1 (p. 439) dit qu'ils n'ont pas
#    contrôlé l'élection précédente : la satisfaction avant « capte » déjà
#    son influence, et le souvenir du vote est douteux. La CES 2025 demande,
#    pendant la campagne, le vote de 2021 (cps25_vote_2021) : modele3 ajoute
#    gagnant_2021 (les libéraux avaient aussi gagné en 2021). Si on a le
#    temps : X mesuré AVANT le résultat, l'intention de vote de la campagne
#    (cps25_votechoice; 7 = ne sait pas et 8 = PPC, pas les codes de
#    pes25_votechoice2025), à la place de gagnant (modele4).
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
# 2. BLAIS ET GÉLINEAU EN 2025 : le code exact de la salle, exécuté tel quel.
# ======================================================================
# Ce que l'article publie : son tableau 1 (p. 431), recopié. La satisfaction
# envers la démocratie de 0 à 1, avant et après l'élection de 1997, mêmes
# personnes (CES 1997). Et la ligne clé de son tableau 2 (p. 432, probit
# ordonné) : perdre aux deux niveaux, à satisfaction égale avant.
BG <- list(
  reference = "Blais, André et François Gélineau. 2007. « Winning, Losing and Satisfaction with Democracy ». Political Studies 55 (2) : 425-441.",
  doi = "10.1111/j.1467-9248.2007.00659.x",
  tableau1 = list(
    list(groupe = "Gagne au pays et dans sa circonscription", court = "gagnants", avant = 0.645, apres = 0.738, diff = "+0,09", n = 373, cle = "gagnant"),
    list(groupe = "Gagne au pays, perd dans sa circonscription", court = "", avant = 0.634, apres = 0.688, diff = "+0,05", n = 206),
    list(groupe = "Perd au pays, gagne dans sa circonscription", court = "", avant = 0.455, apres = 0.587, diff = "+0,13", n = 428),
    list(groupe = "Perd au pays et dans sa circonscription", court = "perdants", avant = 0.526, apres = 0.579, diff = "+0,05", n = 624, cle = "perdant"),
    list(groupe = "N'a pas voté", court = "abstention", avant = 0.493, apres = 0.577, diff = "+0,08", n = 503, cle = "abstention")),
  perdre = "−0,447***", n_tableau2 = 1922
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
# Y : la satisfaction envers la démocratie, APRÈS l'élection (sondage postélectoral).
ATELIER$question <- console(
  "table(as_factor(df_raw$pes25_dem_sat))"
)
ATELIER$apres <- console(
  paste0("df_clean$apres <- case_when(\n",
         "  df_raw$pes25_dem_sat == 1 ~ 1,      # très satisfait\n",
         "  df_raw$pes25_dem_sat == 2 ~ 0.67,   # plutôt satisfait\n",
         "  df_raw$pes25_dem_sat == 3 ~ 0.33,   # peu satisfait\n",
         "  df_raw$pes25_dem_sat == 4 ~ 0       # pas du tout satisfait\n",
         ")"),
  "table(df_clean$apres, useNA = \"ifany\")"
)
# X : a voté pour le parti gagnant (les libéraux) ou pour un autre.
ATELIER$vote <- console(
  "table(as_factor(df_raw$pes25_votechoice2025))"
)
ATELIER$gagnant <- console(
  paste0("df_clean$gagnant <- case_when(\n",
         "  df_raw$pes25_votechoice2025 == 1 ~ 1,          # les libéraux ont gagné\n",
         "  df_raw$pes25_votechoice2025 %in% 2:7 ~ 0       # un autre parti\n",
         "  # 8 (vote annulé), 9 (ne sait pas) : aucune ligne, donc NA\n",
         ")"),
  "table(df_clean$gagnant, useNA = \"ifany\")"
)
# Le contrôle : la même question, AVANT l'élection (sondage de campagne).
ATELIER$avant <- console(
  paste0("df_clean$avant <- case_when(\n",
         "  df_raw$cps25_demsat == 1 ~ 1,\n",
         "  df_raw$cps25_demsat == 2 ~ 0.67,\n",
         "  df_raw$cps25_demsat == 3 ~ 0.33,\n",
         "  df_raw$cps25_demsat == 4 ~ 0\n",
         ")"),
  "table(df_clean$avant, useNA = \"ifany\")"
)
# Le tableau 1 de l'article, en 2025 : les moyennes avant et après.
ATELIER$moyennes <- console(
  paste0("df_clean |>\n",
         "  filter(!is.na(gagnant), !is.na(apres), !is.na(avant)) |>\n",
         "  group_by(gagnant) |>\n",
         "  summarise(avant = mean(avant), apres = mean(apres), n = n())")
)
ATELIER$modeles <- console(
  "modele1 <- lm(apres ~ gagnant, data = df_clean)",
  "modele2 <- lm(apres ~ gagnant + avant, data = df_clean)",
  "nobs(modele1)",
  "nobs(modele2)"
)
# Garde-fou : l'essai exploratoire du 21 octobre (n = 11 632, b = 0,144).
stopifnot(nobs(modele2) == 11632, abs(coef(modele2)[["gagnant"]] - 0.144) < 0.003)

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
  "noms <- c(\"(Intercept)\" = \"Constante\", \"gagnant\" = \"Gagnant\",\n",
  "  \"avant\" = \"Satisfaction avant l'élection\")\n",
  "modeles <- list(\"Gagnant seul\" = modele1, \"À satisfaction égale avant\" = modele2)\n",
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"))"), "s8-tableau.png")

# Le même tableau, dans un fichier Word (il faut le paquet pandoc; Positron
# fournit le programme pandoc lui-même).
WORD <- list(code = paste0(
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"), output = \"gagnants2025.docx\")"))
eval(parse(text = WORD$code), envir = globalenv())
stopifnot(file.exists("gagnants2025.docx"))
# Étape 10 du plan : sauvegarder df_clean, pour ne pas tout refaire la
# prochaine fois.
SAUVER <- list(code = "saveRDS(df_clean, \"df_clean.rds\")")
eval(parse(text = SAUVER$code), envir = globalenv())
stopifnot(file.exists("df_clean.rds"))

# ---- Faire mieux : leur note 1. Le vote de 2021, demandé pendant la
# campagne de 2025 (avant le résultat), aux mêmes personnes.
ATELIER$vote2021 <- console(
  "table(as_factor(df_raw$cps25_vote_2021))"
)
ATELIER$gagnant2021 <- console(
  paste0("df_clean$gagnant_2021 <- case_when(\n",
         "  df_raw$cps25_vote_2021 == 1 ~ 1,          # les libéraux avaient gagné en 2021\n",
         "  df_raw$cps25_vote_2021 %in% 2:6 ~ 0       # un autre parti\n",
         "  # 7 (ne sait pas) ou pas voté en 2021 : NA\n",
         ")"),
  "table(df_clean$gagnant_2021, useNA = \"ifany\")"
)
ATELIER$modele3 <- console(
  "modele3 <- lm(apres ~ gagnant + avant + gagnant_2021, data = df_clean)",
  "nobs(modele3)"
)
stopifnot(nobs(modele3) == 10046, abs(coef(modele3)[["gagnant"]] - 0.122) < 0.003)
# Hors de la salle : leur modèle sur les mêmes personnes que modele3, pour
# montrer que la baisse vient du contrôle, pas des personnes perdues.
modele2_meme <- lm(apres ~ gagnant + avant, data = df_clean[!is.na(df_clean$gagnant_2021), ])
stopifnot(nobs(modele2_meme) == nobs(modele3))
TABLEAU3 <- rendre_png(paste0(
  "noms <- c(noms, \"gagnant_2021\" = \"Gagnant en 2021\")\n",
  "modeles <- list(\"Leur modèle\" = modele2, \"+ gagnant en 2021\" = modele3)\n",
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"))"), "s8-tableau3.png")

# ---- Si on a le temps : X mesuré avant le résultat (l'intention de vote
# pendant la campagne), à la place de gagnant. Une variable à la fois :
# on compare à modele2.
ATELIER$intention <- console(
  "table(as_factor(df_raw$cps25_votechoice))"
)
ATELIER$campagne <- console(
  paste0("df_clean$gagnant_campagne <- case_when(\n",
         "  df_raw$cps25_votechoice == 1 ~ 1,             # pensait voter libéral\n",
         "  df_raw$cps25_votechoice %in% c(2:6, 8) ~ 0    # un autre parti (8 : le PPC)\n",
         "  # 7 (ne sait pas) : NA\n",
         ")"),
  "modele4 <- lm(apres ~ gagnant_campagne + avant, data = df_clean)",
  "round(coef(modele4), 3)"
)
stopifnot(nobs(modele4) == 9764, abs(coef(modele4)[["gagnant_campagne"]] - 0.137) < 0.003)

# Si on a le temps : les perdants sont-ils tous pareils ? (le tableau 4 de
# l'article : les perdants qui pouvaient gouverner, PC et Réforme, contre
# les autres).
ATELIER$perdants <- console(
  paste0("df_clean$camp <- case_when(\n",
         "  df_raw$pes25_votechoice2025 == 1 ~ \"1. Gagnant\",\n",
         "  df_raw$pes25_votechoice2025 == 2 ~ \"2. Conservateur\",\n",
         "  df_raw$pes25_votechoice2025 %in% 3:7 ~ \"3. Autre parti\"\n",
         ")"),
  "modele5 <- lm(apres ~ camp + avant, data = df_clean)",
  "round(coef(modele5), 3)"
)
options(OutDec = ".")

# La figure avant/après : les trois groupes de l'article, en 2025. Les
# abstentionnistes (pes25_turnout2025 de 2 à 5) ne sont pas dans le code de
# la salle; calculés ici, de la même façon.
s01 <- function(v) ifelse(v == 1, 1, ifelse(v == 2, 0.67, ifelse(v == 3, 0.33, ifelse(v == 4, 0, NA))))
to <- as.numeric(d$pes25_turnout2025)
abst <- data.frame(apres = s01(as.numeric(d$pes25_dem_sat)), avant = s01(as.numeric(d$cps25_demsat)))[to %in% 2:5, ]
abst <- abst[complete.cases(abst), ]
k <- df_clean[!is.na(df_clean$gagnant) & !is.na(df_clean$apres) & !is.na(df_clean$avant), ]
groupe <- function(g) list(avant = r(mean(g$avant), 3), apres = r(mean(g$apres), 3), n = nrow(g))
AVANT_APRES <- list(gagnants = groupe(k[k$gagnant == 1, ]), perdants = groupe(k[k$gagnant == 0, ]), abstention = groupe(abst))

COEFS <- list(modele1 = coefs(modele1), modele2 = coefs(modele2), modele3 = coefs(modele3),
              modele2_meme = coefs(modele2_meme), modele4 = coefs(modele4), modele5 = coefs(modele5),
              n_ces = nrow(df_raw),
              n = list(modele1 = nobs(modele1), modele2 = nobs(modele2), modele3 = nobs(modele3),
                       modele2_meme = nobs(modele2_meme), modele4 = nobs(modele4), modele5 = nobs(modele5)))
setwd(ancien)

# ---- Le script complet de la salle : tout le code affiché, dans l'ordre, en
# cinq morceaux (une diapo chacun). Il doit tourner seul, dans une session R
# vierge (Rscript --vanilla), dans un dossier qui ne contient que
# ces2025.rds : c'est ce que la salle fera.
ins <- function(cle) paste(sapply(ATELIER[[cle]], `[[`, "in"), collapse = "\n")
SCRIPT <- c(
  paste0("# POL-2000 · séance 8 · Blais et Gélineau (2007) en 2025\n",
         "# À refaire chez vous, ligne par ligne, Ctrl + Entrée.\n\n",
         ins("charger"), "\n\n", ins("question"), "\n", ins("apres")),
  paste(ins("vote"), ins("gagnant"), ins("avant"), sep = "\n\n"),
  paste(ins("moyennes"), ins("modeles"), TABLEAU$code, WORD$code, sep = "\n\n"),
  paste0("# Faire mieux : leur note 1, l'élection de 2021\n",
         paste(ins("vote2021"), ins("gagnant2021"), ins("modele3"), TABLEAU3$code, sep = "\n\n")),
  paste0("# Si on a le temps : X mesuré avant le résultat\n", ins("intention"), "\n", ins("campagne"), "\n\n",
         "# Si on a le temps : les perdants sont-ils tous pareils ?\n", ins("perdants"), "\n\n",
         "# Sauvegarder df_clean\n", SAUVER$code)
)
vierge <- tempfile("s8-vierge-"); dir.create(vierge)
saveRDS(d, file.path(vierge, "ces2025.rds"))
writeLines(paste(SCRIPT, collapse = "\n\n"), file.path(vierge, "seance8.R"))
statut <- system(sprintf("cd %s && Rscript --vanilla seance8.R > /dev/null 2>&1", shQuote(vierge)))
stopifnot(statut == 0, file.exists(file.path(vierge, "gagnants2025.docx")), file.exists(file.path(vierge, "df_clean.rds")))

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
  "/* Blais et Gélineau (2007), tableau 1 (p. 431) et une ligne du tableau 2 : recopiés de l'article. */",
  paste0("export const BG = ", J(BG), ";"),
  "/* Blais et Gélineau en 2025 : toute la CES. Les consoles, à options(width = 100), dans l'ordre. */",
  paste0("export const ATELIER = ", J(ATELIER), ";"),
  "/* Le tableau à deux colonnes (image) et le même tableau dans Word. */",
  paste0("export const TABLEAU = ", J(TABLEAU), ";"),
  paste0("export const WORD = ", J(WORD), ";"),
  paste0("export const SAUVER = ", J(SAUVER), ";"),
  "/* Faire mieux : le tableau à trois colonnes (+ gagnant en 2021). */",
  paste0("export const TABLEAU3 = ", J(TABLEAU3), ";"),
  "/* La satisfaction avant et après, par groupe, en 2025. */",
  paste0("export const AVANT_APRES = ", J(AVANT_APRES), ";"),
  "/* Les coefficients des modèles et N. */",
  paste0("export const COEFS = ", J(COEFS), ";"),
  "/* Le script complet, en cinq morceaux : vérifié dans une session R vierge. */",
  paste0("export const SCRIPT = ", J(SCRIPT), ";")
), file.path(ici, "..", "src", "lib", "data", "seance8.js"))

cat("ESCALIER :", sapply(ESCALIER$modeles, `[[`, "b"), "\n")
for (m in c("modele1", "modele2", "modele3", "modele2_meme", "modele4", "modele5")) cat(m, "n =", COEFS$n[[m]], ":", sapply(COEFS[[m]], function(c) paste0(c$terme, " ", c$b, c$etoiles, " [", c$bas, "; ", c$haut, "]")), "\n")
str(AVANT_APRES)
cat("tableau", TABLEAU$l, "x", TABLEAU$h, "\n")
