# Exporte tout ce que la séance 4 dessine ou affiche vers
# src/lib/data/seance4.js : les codes bruts de quatre variables de l'Étude
# électorale canadienne 2025, ce qu'ils deviennent une fois recodés, six vraies
# lignes avant et après le ménage, les cinq exemples de données désordonnées
# (Wickham 2014 : tidyr::relig_income, tidyr::who2, la station MX17004,
# tidyr::billboard, puis les sièges de 2021 et 2025), et les sorties de
# console, capturées telles que R les imprime à options(width = 100). Aucune
# valeur n'est tapée à la main. Depuis deck/ :
#
#   CES2025_RDS=~/ces2025.rds Rscript outils/seance4_data.R
#
# Sans CES2025_RDS, les données sont téléchargées par ces::get_ces("2025").
#
# Deux exceptions, faute de jeu de données dans un package : la station
# MX17004 (février 2010, tmax et tmin des jours 1 à 4) est recopiée du
# fichier weather.csv de la vignette « Tidy data » de tidyr (Global
# Historical Climatology Network ; vérifié le 22 septembre 2026), et les sièges sont les résultats officiels d'Élections
# Canada (2021 : 160, 119, 32, 25, 2 ; 2025 : 169, 144, 22, 7, 1).
suppressPackageStartupMessages({ library(ces); library(dplyr); library(tidyr); library(haven) })
options(width = 100, pillar.advice = FALSE)

cache <- Sys.getenv("CES2025_RDS")
df <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

# ---- Les consoles, dans l'ordre de la séance : chaque bloc s'exécute à la
#      suite du précédent, dans le même environnement, comme en classe.
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
assign("df", df, envir = globalenv())

meteo_code <- 'meteo <- tribble(
  ~id,       ~mesure, ~d1, ~d2,  ~d3,  ~d4,
  "MX17004", "tmax",  NA,  27.3, 24.1, NA,
  "MX17004", "tmin",  NA,  14.4, 14.4, NA
)'
sieges_code <- 'sieges_2021 <- tibble(parti = c("PLC", "PCC", "BQ", "NPD", "PV"), sieges = c(160, 119, 32, 25, 2))
sieges_2025 <- tibble(parti = c("PLC", "PCC", "BQ", "NPD", "PV"), sieges = c(169, 144, 22, 7, 1))'

CONSOLES <- list(
  # Le mystère : une échelle de 0 à 10, une moyenne négative.
  mystere = c("summary(df$cps25_lr_scale_bef_1)"),
  # Le codebook est dans R : la question et ce que chaque code veut dire.
  codebook = c('attr(df$cps25_demsat, "label")', "count(df, cps25_demsat)"),
  # Les opérateurs : les huit premiers codes de scolarité de l'échantillon.
  operateurs = c("scol <- c(9, 9, 11, 9, 8, 8, 7, 9)", "scol >= 9", "scol == 7", "scol %in% 6:7", "sum(scol >= 9)"),
  # Recoder en trois catégories, comme à la séance 2.
  scolarite = c('d <- df |>
  mutate(scolarite = case_when(
    cps25_education <= 5  ~ "Secondaire ou moins",
    cps25_education <= 7  ~ "Collégial",
    cps25_education <= 11 ~ "Universitaire"
  ))', "count(d, scolarite)"),
  # Inverser et ramener de 0 à 1.
  satisfaction = c("d <- d |>
  mutate(satisfaction = case_when(
    cps25_demsat == 1 ~ 1,
    cps25_demsat == 2 ~ 0.67,
    cps25_demsat == 3 ~ 0.33,
    cps25_demsat == 4 ~ 0
  ))", "count(d, satisfaction)"),
  # Le piège de if_else : deux issues seulement.
  piege = c("count(df, cps25_bornin_canada)",
            "d <- d |> mutate(ne_canada = if_else(cps25_bornin_canada == 1, 1, 0))",
            "count(d, ne_canada)"),
  corrige = c("d <- d |>
  mutate(ne_canada = case_when(
    cps25_bornin_canada == 1 ~ 1,
    cps25_bornin_canada == 2 ~ 0
  ))", "count(d, ne_canada)"),
  # Les valeurs manquantes.
  na = c("d <- d |> mutate(gauche_droite = na_if(cps25_lr_scale_bef_1, -99))",
         "mean(d$gauche_droite)",
         "mean(d$gauche_droite, na.rm = TRUE)",
         "sum(is.na(d$gauche_droite))"),
  nonpose = c("sum(is.na(df$cps25_votechoice))", "count(df, cps25_v_likely)"),
  # La base propre.
  propre = c("df_propre <- d |>
  mutate(age = as.numeric(cps25_age_in_years),
         vote = as_factor(cps25_votechoice)) |>
  select(age, scolarite, gauche_droite, satisfaction, ne_canada, vote)",
             "head(df_propre)",
             'saveRDS(df_propre, "ces2025_propre.rds")'),
  pertes = c("nrow(df_propre)", "df_propre |> drop_na() |> nrow()"),
  # Les cinq problèmes de Wickham (2014).
  relig = c("relig_income",
            'relig_income |>
  pivot_longer(!religion, names_to = "revenu", values_to = "n")'),
  who = c('who2 |>
  pivot_longer(!c(country, year),
               names_to = c("diagnostic", "sexe", "age"), names_sep = "_",
               values_to = "cas", values_drop_na = TRUE)'),
  meteo = c(meteo_code,
            'meteo |>
  pivot_longer(d1:d4, names_to = "jour", values_to = "temp", values_drop_na = TRUE) |>
  pivot_wider(names_from = mesure, values_from = temp)'),
  billboard = c('chansons <- billboard |> distinct(artist, track)',
                'classement <- billboard |>
  pivot_longer(starts_with("wk"), names_to = "semaine", values_to = "rang", values_drop_na = TRUE) |>
  select(artist, track, semaine, rang)',
                "nrow(chansons)", "nrow(classement)"),
  sieges = c(sieges_code, 'bind_rows("2021" = sieges_2021, "2025" = sieges_2025, .id = "annee")')
)
old <- setwd(tempdir())  # le saveRDS de la console écrit ici, pas dans le dépôt
consoles_brutes <- lapply(CONSOLES, function(codes) lapply(codes, function(code) list(`in` = code, out = sortie(code))))
setwd(old)

# ---- Les chiffres des figures.
d <- get("d", envir = globalenv())
df_propre <- get("df_propre", envir = globalenv())
compte <- function(x, niveaux) as.integer(table(factor(as.numeric(x), levels = niveaux)))
lr <- as.numeric(df$cps25_lr_scale_bef_1)

# Six vraies personnes : les trois premières lignes, puis la première qui
# répond -99 à l'échelle gauche-droite, la première « ne sait pas » à la
# satisfaction, et la première sans intention de vote.
choix <- unique(c(1:3, which(lr == -99)[1], which(as.numeric(df$cps25_demsat) == 5)[1],
                  which(is.na(df$cps25_votechoice))[1]))
brut <- df[choix, c("cps25_age_in_years", "cps25_education", "cps25_lr_scale_bef_1", "cps25_demsat", "cps25_bornin_canada", "cps25_votechoice")] |>
  mutate(across(everything(), as.numeric))
propre <- df_propre[choix, ] |> mutate(vote = as.character(vote))

# Ce que deviennent les réponses : pertes à chaque colonne ajoutée.
etapes <- c("age", "scolarite", "gauche_droite", "satisfaction", "ne_canada", "vote")
restants <- sapply(seq_along(etapes), function(k) nrow(drop_na(df_propre[, etapes[1:k]])))

# Les exemples de données désordonnées : un extrait de l'avant et de l'après.
tbl <- function(t, n = 4) list(cols = names(t), rows = lapply(seq_len(min(n, nrow(t))), function(i) unname(as.list(t[i, ]))))
relig_apres <- relig_income |> pivot_longer(!religion, names_to = "revenu", values_to = "n")
who_apres <- who2 |> pivot_longer(!c(country, year), names_to = c("diagnostic", "sexe", "age"), names_sep = "_", values_to = "cas", values_drop_na = TRUE)
meteo <- get("meteo", envir = globalenv())
meteo_apres <- meteo |> pivot_longer(d1:d4, names_to = "jour", values_to = "temp", values_drop_na = TRUE) |> pivot_wider(names_from = mesure, values_from = temp)
bb <- billboard |> slice(1:2) |> mutate(track = substr(track, 1, 14))
chansons <- bb |> distinct(artist, track)
classement <- bb |> pivot_longer(starts_with("wk"), names_to = "semaine", values_to = "rang", values_drop_na = TRUE) |> select(artist, track, semaine, rang)
sieges <- bind_rows("2021" = get("sieges_2021", envir = globalenv()), "2025" = get("sieges_2025", envir = globalenv()), .id = "annee")
who_premiere <- who2 |> filter(country == "Canada", year == 2010) |> select(country, year, sp_m_014, sp_m_1524, sp_f_014, sp_f_1524)
who_apres_ca <- who_apres |> filter(country == "Canada", year == 2010)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance4_data.R. Sources : ces::get_ces(\"2025\"), l'Étude électorale",
  "   canadienne 2025 ; tidyr::relig_income, tidyr::who2, tidyr::billboard ; la station MX17004",
  "   de weather.csv (vignette « Tidy data » de tidyr) ; les sièges d'Élections Canada, 2021 et 2025.",
  sprintf("   %s. Aucune valeur ici n'est écrite à la main. */", R.version.string),
  "",
  "/* Les dimensions de la base brute et de la base propre. */",
  sprintf("export const DIMENSIONS = %s;", J(list(brut = dim(df), propre = dim(df_propre)))),
  "/* L'échelle gauche-droite (cps25_lr_scale_bef_1) : -99, puis 0 à 10. */",
  sprintf("export const GAUCHE_DROITE = %s;", J(list(
    valeurs = c(-99, 0:10), effectifs = compte(lr, c(-99, 0:10)), n = length(lr),
    moyenneBrute = round(mean(lr), 2), moyennePropre = round(mean(lr[lr != -99]), 2),
    n99 = sum(lr == -99)))),
  "/* La scolarité (cps25_education), codes 1 à 12, et ses trois catégories. */",
  sprintf("export const SCOLARITE = %s;", J(list(
    codes = 1:12, etiquettes = unname(names(attr(df$cps25_education, "labels"))),
    effectifs = compte(df$cps25_education, 1:12),
    groupes = as.list(count(d, scolarite)$n) |> setNames(ifelse(is.na(count(d, scolarite)$scolarite), "NA", count(d, scolarite)$scolarite))))),
  "/* La satisfaction envers la démocratie (cps25_demsat), codes 1 à 5. */",
  sprintf("export const SATISFACTION = %s;", J(list(
    codes = 1:5, etiquettes = unname(names(attr(df$cps25_demsat, "labels"))),
    effectifs = compte(df$cps25_demsat, 1:5)))),
  "/* Né au Canada (cps25_bornin_canada), codes 1 à 3. */",
  sprintf("export const NE_CANADA = %s;", J(list(effectifs = compte(df$cps25_bornin_canada, 1:3)))),
  "/* L'intention de vote : les « ne sait pas » (code 7) et les NA, selon cps25_v_likely. */",
  sprintf("export const VOTE_VIDE = %s;", J(list(
    n = nrow(df), nsp = sum(as.numeric(df$cps25_votechoice) == 7, na.rm = TRUE), na = sum(is.na(df$cps25_votechoice)),
    raisons = as.list(table(as.numeric(df$cps25_v_likely)[is.na(df$cps25_votechoice)]))))),
  "/* Six vraies personnes, avant et après le ménage. */",
  sprintf("export const BRUT = %s;", J(tbl(brut, 6))),
  sprintf("export const PROPRE = %s;", J(tbl(propre, 6))),
  "/* Combien de lignes restent si on exige une réponse à chaque colonne, ajoutées une à une. */",
  sprintf("export const PERTES = %s;", J(list(etapes = etapes, restants = restants, n = nrow(df_propre)))),
  "",
  "/* Les cinq problèmes : un extrait de l'avant et de l'après. */",
  sprintf("export const TIDY = %s;", J(list(
    relig = list(avant = tbl(relig_income[, 1:4], 3), nAvant = dim(relig_income), apres = tbl(relig_apres, 5), nApres = dim(relig_apres)),
    who = list(avant = tbl(who_premiere, 1), nAvant = dim(who2), apres = tbl(who_apres_ca |> filter(diagnostic == "sp", age %in% c("014", "1524")), 4), nApres = dim(who_apres)),
    meteo = list(avant = tbl(meteo, 2), apres = tbl(meteo_apres, 2)),
    billboard = list(avant = tbl(bb |> select(artist, track, wk1, wk2, wk3), 2), nAvant = dim(billboard),
                     chansons = tbl(chansons, 2), classement = tbl(classement, 3)),
    sieges = list(a2021 = tbl(get("sieges_2021", envir = globalenv()), 5), a2025 = tbl(get("sieges_2025", envir = globalenv()), 5),
                  apres = tbl(sieges, 10))
  ))),
  "",
  "/* Les consoles de la séance, à options(width = 100), dans l'ordre où R les a exécutées. */",
  sprintf("export const CONSOLES = %s;", J(consoles_brutes))
)
ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance4.js"))
cat("écrit : src/lib/data/seance4.js\n")
