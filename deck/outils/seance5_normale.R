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
#   - Michelson (1879), 100 mesures de la vitesse de la lumière : morley (R);
#   - NYC Open Data, « Building Footprints » (jeu 5zhs-2jue, Office of
#     Technology and Innovation), colonne height_roof, en pieds, consulté le
#     30 septembre 2026. Nettoyage : on retire les hauteurs nulles (722) et
#     tout ce qui dépasse 1 600 pieds (une seule valeur, 2 130 353 pieds, une
#     erreur de saisie); la plus haute restante, 1 550 pieds, est le toit de la
#     Central Park Tower. Converties en mètres (× 0,3048);
#   - 189 naissances, Baystate Medical Center, Springfield (Massachusetts),
#     1986 : MASS::birthwt (Hosmer et Lemeshow);
#   - 141 grandes rivières d'Amérique du Nord (World Almanac, 1975) : rivers
#     (R), en milles, converties en km (× 1,609344);
#   - 272 attentes entre deux éruptions du geyser Old Faithful, Yellowstone :
#     faithful (R);
#   - l'âge des 20 180 répondant.e.s de l'Étude électorale canadienne 2025.
#
# Le verdict de chaque forme (cloche, longue queue, deux bosses, plateau) est
# lu à l'œil sur l'histogramme, comme on le demandera en classe. Aucun test
# de normalité.
#
# Le hasard est fixé (set.seed) bloc par bloc : la même commande redonne les
# mêmes chiffres.
suppressPackageStartupMessages({ library(ces); library(dplyr); library(haven); library(ggplot2) })
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

# ---- 1. Additionner des petits hasards : lancer k pièces, compter les piles,
#         recommencer 10 000 fois.
set.seed(51)
CLOCHE <- lapply(c(1, 2, 5, 20), function(k) {
  piles <- replicate(10000, sum(sample(0:1, k, replace = TRUE)))
  list(pieces = k, effectifs = as.integer(table(factor(piles, levels = 0:k))))
})

# ---- 2. Le quiz.
age <- as.numeric(df_raw$cps25_age_in_years)
QUIZ <- list(
  c(list(cle = "michelson", forme = "cloche"), compter(morley$Speed + 299000, 299600, 300120, 40)),
  c(list(cle = "nyc", forme = "queue"), compter(nyc, 0, 40, 2)),
  c(list(cle = "bebes", forme = "cloche"), compter(MASS::birthwt$bwt, 400, 5200, 400)),
  c(list(cle = "rivieres", forme = "queue"), compter(rivers * 1.609344, 0, 6000, 300)),
  c(list(cle = "geyser", forme = "bosses"), compter(faithful$waiting, 40, 100, 4)),
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
NYC_POP <- list(n = length(nyc), moyenne = mean(nyc), max = max(nyc),
                plusDe40 = sum(nyc >= 40), brut = NYC_BRUT)

# ---- 4. « 19 fois sur 20 » : 20 sondages de 1 000 personnes, tirés parmi les
#         répondant.e.s de l'EEC 2025 qui déclarent un parti (sans « ne sait
#         pas » ni réponse manquante). La marge d'erreur est celle que les
#         maisons de sondage publient : 1,96 × racine(p(1 − p) / n).
vote <- as_factor(df_raw$cps25_votechoice)
decide <- !is.na(vote) & as.numeric(vote) != 7
liberal <- as.numeric(as.numeric(vote[decide]) == 1)
set.seed(53)
sondages <- lapply(1:20, function(i) {
  x <- sample(liberal, 1000)
  p <- mean(x); marge <- 1.96 * sqrt(p * (1 - p) / 1000)
  list(p = round(p, 4), marge = round(marge, 4))
})
vrai <- mean(liberal)
for (i in seq_along(sondages)) {
  s <- sondages[[i]]
  sondages[[i]]$couvre <- abs(s$p - vrai) <= s$marge
}
SONDAGE <- list(population = length(liberal), vrai = round(vrai, 4), n = 1000,
                sondages = sondages, couvrent = sum(sapply(sondages, `[[`, "couvre")))

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
  geyser = rendre("geyser", "ggplot(faithful, aes(x = waiting)) +\n  geom_histogram(binwidth = 4)"),
  michelson = rendre("michelson", "ggplot(morley, aes(x = Speed + 299000)) +\n  geom_histogram(binwidth = 40)")
)

# ---- Export.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_normale.R. Sources : morley, rivers, faithful (R), MASS::birthwt,",
  "   NYC Open Data « Building Footprints » (5zhs-2jue, consulté le 30 septembre 2026), et",
  "   l'Étude électorale canadienne 2025 (ces::get_ces(\"2025\"), sans pondération).",
  "   Aucune valeur ici n'est écrite à la main. */",
  "",
  "/* Lancer k pièces, compter les piles, 10 000 fois : effectifs de 0 à k piles. */",
  paste0("export const CLOCHE = ", J(CLOCHE), ";"),
  "/* Le quiz : effectifs par tranche [a, a + largeur), n, ce qui déborde à droite. */",
  paste0("export const QUIZ = ", J(QUIZ), ";"),
  "/* Les bâtiments de New York (en mètres), et 1 000 moyennes d'échantillons de 10, 100 et 2 000. */",
  paste0("export const NYC_POP = ", J(NYC_POP), ";"),
  paste0("export const NYC_MOYENNES = ", J(NYC_MOYENNES), ";"),
  "/* Vingt sondages de 1 000 parmi les répondant.e.s qui déclarent un parti : la part libérale et sa marge. */",
  paste0("export const SONDAGE = ", J(SONDAGE), ";"),
  "/* Deux histogrammes du quiz, refaits dans R : le code, l'image, les messages de R. */",
  paste0("export const GGPLOT_NORMALE = ", J(GGPLOT_NORMALE), ";")
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_normale.js"))
cat("ok\n")
