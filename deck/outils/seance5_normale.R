# La courbe normale, le quiz « Normale ou pas ? », les moyennes de bâtiments
# de New York et le sondage « 19 fois sur 20 » de la séance 5. Exporte
# src/lib/data/seance5_normale.js et rend static/img/s5-n-*.png. Rien n'est
# tapé à la main : tous les nombres viennent des données ci-dessous. Depuis
# deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds NYC_CSV=/tmp/nyc_hauteurs.csv \
#   STATCAN_CSV=/tmp/17100005.csv Rscript outils/seance5_normale.R
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
# Ce que les répondant.e.s pensent de Pierre Poilievre, de 0 à 100
# (cps25_lead_rating_24 : le chef que les électeurs conservateurs notent 80
# en moyenne, vérifié par vote le 1er octobre 2026). Valeurs négatives
# (ne sait pas, refus) retirées.
poilievre <- as.numeric(df_raw$cps25_lead_rating_24)
poilievre <- poilievre[!is.na(poilievre) & poilievre >= 0]
QUIZ <- list(
  c(list(cle = "hommes", forme = "cloche"), compter(hommes, 150, 206, 2)),
  c(list(cle = "adultes", forme = "cloche"), compter(nh$Height, 134, 206, 2)),
  c(list(cle = "iris", forme = "bosses"), compter(iris$Petal.Length, 1, 7.25, 0.25)),
  c(list(cle = "poilievre", forme = "bosses"), compter(poilievre, 0, 105, 5)),
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
#         répondant.e.s de la CES 2025 qui déclarent un parti (sans « ne sait
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

# ---- 4 zéro. La courbe normale elle-même : la part des valeurs à moins
#      d'un, puis de deux écarts types du centre (pnorm).
NORMALE <- list(un = pnorm(1) - pnorm(-1), deux = pnorm(2) - pnorm(-2))

# ---- 4 bis. Le monde de H0, pour la pomicultrice (exemple fictif
#      d'Arel-Bundock 2021, p. 62-63 : paniers de 50 pommes, variance 300).
#      Si H0 était vraie, ses pommes seraient ordinaires : 100 g en moyenne.
#      On simule 1 000 paniers de 50 pommes fictives dans ce monde-là, et on
#      compte ceux qui pèsent autant que son panier (105 g), puis 102 g.
#      Poids des pommes : loi normale de moyenne 100 g et d'écart type
#      racine(300) g, comme dans le livre. Le compte est celui que la graine
#      donne, sans retouche.
set.seed(54)
paniers <- replicate(1000, mean(rnorm(50, mean = 100, sd = sqrt(300))))
PANIERS <- c(list(moyennes = round(paniers, 2),
                  auMoins105 = sum(paniers >= 105), auMoins102 = sum(paniers >= 102)),
             compter(paniers, 90, 110, 0.5))

# Les mondes plus légers que 100 g (98 et 99 g) : 1 000 paniers chacun, et combien
# pèsent 105 g ou plus. H0 dit « 100 g ou moins » : le monde à 100 g est le
# plus favorable à H0.
MONDES <- c(lapply(c(98, 99), function(mu) {
  set.seed(58)
  m <- replicate(1000, mean(rnorm(50, mean = mu, sd = sqrt(300))))
  list(moyenne = mu, auMoins105 = sum(m >= 105))
}), list(list(moyenne = 100, auMoins105 = PANIERS$auMoins105)))  # le même monde que PANIERS

# ---- 4 ter. Le théorème central limite, sur trois formes : les moyennes de
#      1 000 échantillons de 50 pétales d'iris (sans remise, parmi les 150).
set.seed(56)
m_iris <- replicate(1000, mean(sample(iris$Petal.Length, 50)))
b_iris <- seq(min(m_iris), max(m_iris), length.out = 31)
IRIS_MOYENNES <- list(n = 50, bornes = round(b_iris, 3),
                      effectifs = as.integer(table(cut(m_iris, b_iris, include.lowest = TRUE))))

set.seed(57)
m_poil <- replicate(1000, mean(sample(poilievre, 50)))
b_poil <- seq(min(m_poil), max(m_poil), length.out = 31)
POILIEVRE_MOYENNES <- list(n = 50, bornes = round(b_poil, 3),
                           effectifs = as.integer(table(cut(m_poil, b_poil, include.lowest = TRUE))))

# ---- 4 quater. La CES ressemble-t-elle au Canada ? L'âge des répondant.e.s
#      (brut, puis pondéré par cps25_weight_general_all, 61 poids manquants
#      retirés) contre Statistique Canada, tableau 17-10-0005-01, estimations
#      au 1er juillet 2025, 18 ans et plus, téléchargé le 30 septembre 2026.
#      Le fichier (39 Mo) reste dans /tmp : seuls les pourcentages sont
#      exportés.
statcan_csv <- Sys.getenv("STATCAN_CSV")
if (!nzchar(statcan_csv) || !file.exists(statcan_csv)) {
  zip <- file.path(tempdir(), "17100005-eng.zip")
  download.file("https://www150.statcan.gc.ca/n1/tbl/csv/17100005-eng.zip", zip, quiet = TRUE)
  statcan_csv <- unzip(zip, "17100005.csv", exdir = tempdir())
}
sc <- read.csv(statcan_csv, check.names = FALSE)
names(sc)[1] <- "REF_DATE"
sc <- sc[sc$REF_DATE == 2025 & sc$GEO == "Canada" & sc$Gender == "Total - gender" &
         grepl("^[0-9]+ years?$|^100 years and older$", sc$`Age group`), ]
sc$age <- as.numeric(sub(" .*", "", sc$`Age group`))
sc <- sc[sc$age >= 18, ]
br <- c(seq(18, 88, 5), 200)
parts <- function(v, poids) {
  ok <- !is.na(v) & !is.na(poids)
  t <- tapply(poids[ok], cut(v[ok], br, right = FALSE), sum)
  round(100 * as.numeric(t) / sum(t), 1)
}
poids_eec <- as.numeric(df_raw$cps25_weight_general_all)
RECENSEMENT <- list(
  groupes = c(paste0(head(br, -2), " à ", head(br, -2) + 4), paste0(br[length(br) - 1], " et +")),
  statcan = parts(sc$age, sc$VALUE),
  eecBrut = parts(age, rep(1, length(age))),
  eecPondere = parts(age, poids_eec),
  moyenneStatcan = round(weighted.mean(sc$age, sc$VALUE), 1),
  moyenneCes = round(mean(age), 1),
  moyenneCesPondere = round(weighted.mean(age[!is.na(poids_eec)], poids_eec[!is.na(poids_eec)]), 1)
)

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
# ---- 4 quinquies. Le poids, une colonne de df_clean. Les six premières
#      lignes, puis la moyenne d'âge brute et pondérée, telles que R les
#      imprime (options(width = 100)). 61 répondant.e.s n'ont pas de poids :
#      weighted.mean() rendrait NA, d'où le filter().
df_p <- data.frame(id = 1:nrow(df_raw))
df_p$age <- as.numeric(df_raw$cps25_age_in_years)
df_p$gauche_droite <- na_if(as.numeric(df_raw$cps25_lr_scale_bef_1), -99)
df_p$poids <- as.numeric(df_raw$cps25_weight_general_all)
POIDS_LIGNES <- lapply(1:6, function(i) list(id = df_p$id[i], age = df_p$age[i],
  gauche_droite = if (is.na(df_p$gauche_droite[i])) "NA" else as.character(df_p$gauche_droite[i]),
  poids = sprintf("%.2f", df_p$poids[i])))
sortie <- function(code) {
  out <- capture.output(eval(parse(text = code), envir = list2env(list(df_clean = df_p), parent = globalenv())))
  paste(out, collapse = "\n")
}
old_w <- options(width = 100)
code_moy <- "df_clean |>\n  filter(!is.na(poids)) |>\n  summarise(brute = mean(age),\n            ponderee = weighted.mean(age, poids))"
CONSOLE_POIDS <- list(
  list(`in` = "df_clean$poids <- df_raw$cps25_weight_general_all", out = ""),
  list(`in` = code_moy, out = sortie(code_moy))
)
options(old_w)

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
  "/* La courbe normale : part des valeurs à moins d'un et de deux écarts types du centre. */",
  paste0("export const NORMALE = ", J(NORMALE), ";"),
  "/* Le monde de H0 : 1 000 paniers de 50 pommes fictives de 100 g en moyenne. */",
  paste0("export const PANIERS = ", J(PANIERS), ";"),
  "/* Des mondes à 98, 99 et 100 g : combien de 1 000 paniers pèsent 105 g ou plus. */",
  paste0("export const MONDES = ", J(MONDES), ";"),
  "/* Les moyennes de 1 000 échantillons de 50 notes de Pierre Poilievre. */",
  paste0("export const POILIEVRE_MOYENNES = ", J(POILIEVRE_MOYENNES), ";"),
  "/* Les moyennes de 1 000 échantillons de 50 pétales d'iris. */",
  paste0("export const IRIS_MOYENNES = ", J(IRIS_MOYENNES), ";"),
  "/* L'âge : Statistique Canada (1er juillet 2025) contre la CES brute et pondérée, en %. */",
  paste0("export const RECENSEMENT = ", J(RECENSEMENT), ";"),
  "/* Le poids dans df_clean : six lignes, et la console de la moyenne brute et pondérée. */",
  paste0("export const POIDS_LIGNES = ", J(POIDS_LIGNES), ";"),
  paste0("export const CONSOLE_POIDS = ", J(CONSOLE_POIDS), ";"),
  "/* (Les histogrammes refaits en direct dans R ont été retirés le 1er octobre 2026.) */"
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_normale.js"))
cat("ok\n")
