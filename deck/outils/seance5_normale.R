# La courbe normale, le quiz « Normale ou pas ? », les moyennes de bâtiments
# de New York et le sondage « 19 fois sur 20 » de la séance 5. Exporte
# src/lib/data/seance5_normale.js et rend static/img/s5-n-*.png. Rien n'est
# tapé à la main : tous les nombres viennent des données ci-dessous. Depuis
# deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds NYC_CSV=/tmp/nyc_hauteurs.csv Rscript outils/seance5_normale.R
#
# Sans NYC_CSV, les hauteurs sont téléchargées de NYC Open Data (environ
# 1,1 million de lignes). Sans CES2025_RDS, ces::get_ces("2025").
#
# Les jeux de données du quiz :
#   - la taille des adultes de 20 ans et plus de l'enquête NHANES
#     (États-Unis, 2009 à 2012), paquet R NHANES, une ligne par personne
#     (ID) : les hommes seuls, puis hommes et femmes mélangés;
#   - la longueur des pétales de 150 iris (Anderson, 1935; iris dans R),
#     trois espèces, dont deux cueillies en Gaspésie;
#   - 189 naissances, Baystate Medical Center, Springfield (Massachusetts),
#     1986 : MASS::birthwt (Hosmer et Lemeshow);
#   - NYC Open Data, « Building Footprints » (jeu 5zhs-2jue, Office of
#     Technology and Innovation), colonne height_roof, en pieds, consulté le
#     30 septembre 2026. Nettoyage : on retire les hauteurs nulles (722) et
#     tout ce qui dépasse 1 600 pieds (une seule valeur, 2 130 353 pieds, une
#     erreur de saisie); la plus haute restante, 1 550 pieds, est le toit de la
#     Central Park Tower. Converties en mètres (× 0,3048);
#   - l'âge des 20 180 répondant.e.s de l'Étude électorale canadienne 2025.
#
# Le verdict de chaque forme (cloche, longue queue, deux bosses, plateau) est
# lu à l'œil sur l'histogramme, comme on le demandera en classe. Aucun test
# de normalité.
#
# Le hasard est fixé (set.seed) bloc par bloc : la même commande redonne les
# mêmes chiffres.
suppressPackageStartupMessages({ library(ces); library(dplyr); library(haven); library(ggplot2) })
# Le paquet NHANES doit être installé : install.packages("NHANES").
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
dossier_img <- file.path(ici, "..", "static", "img")

cache <- Sys.getenv("CES2025_RDS")
df_raw <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

nyc_csv <- Sys.getenv("NYC_CSV")
if (!nzchar(nyc_csv) || !file.exists(nyc_csv)) {
  nyc_csv <- file.path(tempdir(), "nyc_hauteurs.csv")
  download.file("https://data.cityofnewyork.us/resource/5zhs-2jue.csv?$select=height_roof&$limit=2000000",
                nyc_csv, quiet = TRUE)
}
pieds <- read.csv(nyc_csv)$height_roof
NYC_BRUT <- list(n = length(pieds), nuls = sum(pieds == 0), trop = sum(pieds > 1600))
nyc <- pieds[pieds > 0 & pieds <= 1600] * 0.3048

# Effectifs par tranche [a, a + largeur), et ce qui déborde à droite.
compter <- function(x, de, a, largeur) {
  bornes <- seq(de, a, by = largeur)
  x <- x[!is.na(x)]
  list(bornes = bornes,
       effectifs = as.integer(table(cut(x[x >= de & x < a], bornes, right = FALSE))),
       n = length(x), au_dela = sum(x >= a), max = max(x), moyenne = mean(x))
}

# ---- 2. Le quiz.
age <- as.numeric(df_raw$cps25_age_in_years)
nh <- NHANES::NHANES
nh <- nh[nh$Age >= 20 & !is.na(nh$Height) & !duplicated(nh$ID), ]
hommes <- nh$Height[nh$Gender == "male"]
femmes <- nh$Height[nh$Gender == "female"]
TAILLES <- list(ecart = mean(hommes) - mean(femmes),
                hommes95 = unname(quantile(hommes, c(0.025, 0.975))))
# Les bâtiments : tout le spectre, de 0 à 480 m, et un trait par mètre où se
# trouve au moins un bâtiment de 40 m ou plus.
nyc_q <- compter(nyc, 0, 480, 4)
nyc_q$traits <- sort(unique(floor(nyc[nyc >= 40])))
nyc_q$plus40 <- sum(nyc >= 40); nyc_q$plus100 <- sum(nyc >= 100); nyc_q$plus200 <- sum(nyc >= 200)
QUIZ <- list(
  c(list(cle = "hommes", forme = "cloche"), compter(hommes, 150, 206, 2)),
  c(list(cle = "adultes", forme = "cloche"), compter(nh$Height, 134, 206, 2)),
  c(list(cle = "iris", forme = "bosses"), compter(iris$Petal.Length, 1, 7.25, 0.25)),
  c(list(cle = "bebes", forme = "cloche"), compter(MASS::birthwt$bwt, 400, 5200, 400)),
  c(list(cle = "nyc", forme = "queue"), nyc_q),
  c(list(cle = "age", forme = "plateau"), compter(age, 15, 100, 5))
)

# ---- 3. Même les bâtiments de New York : 1 000 moyennes d'échantillons de
#         10, 100 et 2 000 bâtiments. Chaque rangée a son propre axe (30
#         tranches du minimum au maximum de ses moyennes).
set.seed(52)
NYC_MOYENNES <- lapply(c(10, 100, 2000), function(n) {
  m <- replicate(1000, mean(sample(nyc, n)))
  bornes <- seq(min(m), max(m), length.out = 31)
  list(n = n, bornes = round(bornes, 3),
       effectifs = as.integer(table(cut(m, bornes, include.lowest = TRUE))))
})
# Pour la diapo des moyennes : les bâtiments de 0 à 40 m, en tranches de 2 m.
NYC_POP <- c(list(plusDe40 = sum(nyc >= 40), brut = NYC_BRUT), compter(nyc, 0, 40, 2))

# ---- 4. « 19 fois sur 20 » : 20 sondages de 1 000 personnes, tirés parmi les
#         répondant.e.s de l'EEC 2025 qui déclarent un parti (sans « ne sait
#         pas » ni réponse manquante). La marge d'erreur est celle que les
#         maisons de sondage publient : 1,96 × racine(p(1 − p) / n).
vote <- as_factor(df_raw$cps25_votechoice)
decide <- !is.na(vote) & as.numeric(vote) != 7
liberal <- as.numeric(as.numeric(vote[decide]) == 1)
sonder <- function(graine) {
  set.seed(graine)
  lapply(1:20, function(i) {
    x <- sample(liberal, 1000)
    p <- mean(x); marge <- 1.96 * sqrt(p * (1 - p) / 1000)
    list(p = round(p, 4), marge = round(marge, 4))
  })
}
vrai <- mean(liberal)
rate <- function(s) abs(s$p - vrai) > s$marge
# La graine : la première à partir de 53 pour laquelle exactement 1 sondage
# sur 20 rate la vraie valeur (le cas typique, celui que la diapo raconte)
# et où le premier sondage l'attrape. Choisie, pas tirée : c'est dit ici.
graine <- 53
repeat {
  sondages <- sonder(graine)
  if (sum(sapply(sondages, rate)) == 1 && !rate(sondages[[1]])) break
  graine <- graine + 1
}
for (i in seq_along(sondages)) sondages[[i]]$couvre <- !rate(sondages[[i]])
SONDAGE <- list(population = length(liberal), vrai = round(vrai, 4), n = 1000, graine = graine,
                sondages = sondages, couvrent = sum(sapply(sondages, `[[`, "couvre")))

# ---- 4 bis. La pomicultrice, unilatérale : elle veut prouver que ses
#      pommes pèsent PLUS de 100 g. Mêmes nombres que seance5_data.R (n = 50,
#      moyenne 105 g, variance 300, Arel-Bundock 2021, p. 62-63); ici, la
#      valeur p d'un seul côté.
t_pom <- (105 - 100) / (sqrt(300) / sqrt(50))
POMME_UNI <- list(t = t_pom, p = pt(t_pom, df = 49, lower.tail = FALSE))

# ---- 5. Le quiz dans R, en direct : deux histogrammes que la salle refait.
rendre <- function(nom, code, largeur = 6.4, hauteur = 4) {
  messages <- character(0)
  p <- withCallingHandlers(eval(parse(text = code)),
                           message = function(m) { messages <<- c(messages, trimws(conditionMessage(m))); invokeRestart("muffleMessage") })
  withCallingHandlers(
    ggsave(file.path(dossier_img, paste0("s5-n-", nom, ".png")), p, width = largeur, height = hauteur,
           dpi = 220, device = ragg::agg_png, bg = "white"),
    message = function(m) { messages <<- c(messages, trimws(conditionMessage(m))); invokeRestart("muffleMessage") })
  list(code = code, image = paste0("s5-n-", nom, ".png"), messages = unique(messages))
}
GGPLOT_NORMALE <- list(
  iris = rendre("iris", "ggplot(iris, aes(x = Petal.Length)) +\n  geom_histogram(binwidth = 0.25)"),
  irisEspeces = rendre("iris-especes", "ggplot(iris, aes(x = Petal.Length, fill = Species)) +\n  geom_histogram(binwidth = 0.25)")
)

# ---- Export.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_normale.R. Sources : NHANES (paquet R), iris (R), MASS::birthwt,",
  "   NYC Open Data « Building Footprints » (5zhs-2jue, consulté le 30 septembre 2026), et",
  "   l'Étude électorale canadienne 2025 (ces::get_ces(\"2025\"), sans pondération).",
  "   Aucune valeur ici n'est écrite à la main. */",
  "",
  "/* Le quiz : effectifs par tranche [a, a + largeur), n, ce qui déborde à droite. */",
  paste0("export const QUIZ = ", J(QUIZ), ";"),
  "/* La taille des adultes (NHANES) : l'écart hommes-femmes et l'étendue de 95 % des hommes, en cm. */",
  paste0("export const TAILLES = ", J(TAILLES), ";"),
  "/* Les bâtiments de New York (en mètres), et 1 000 moyennes d'échantillons de 10, 100 et 2 000. */",
  paste0("export const NYC_POP = ", J(NYC_POP), ";"),
  paste0("export const NYC_MOYENNES = ", J(NYC_MOYENNES), ";"),
  "/* Vingt sondages de 1 000 parmi les répondant.e.s qui déclarent un parti : la part libérale et sa marge. */",
  paste0("export const SONDAGE = ", J(SONDAGE), ";"),
  "/* La pomicultrice, d'un seul côté (plus lourdes que 100 g) : t et p calculés par R. */",
  paste0("export const POMME_UNI = ", J(POMME_UNI), ";"),
  "/* Les pétales d'iris, refaits dans R : le code, l'image, les messages de R. */",
  paste0("export const GGPLOT_NORMALE = ", J(GGPLOT_NORMALE), ";")
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_normale.js"))
cat("ok\n")
