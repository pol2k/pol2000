# Les compléments de la séance 4, refaite après la relecture du 24 septembre
# 2026 : l'Étude électorale canadienne de 1993 (la scolarité, cpso3, et la
# question sur la TPS, cpsg1), les quatre façons de recoder, les trois
# opérationnalisations de la scolarité, la moyenne avant et après le -99,
# NaN, et le palmarès Billboard en un seul tableau. Tout est écrit dans
# src/lib/data/seance4_plus.js; aucune valeur n'est tapée à la main.
# Depuis deck/ :
#
#   CES2025_RDS=... CES1993_SAV=... Rscript outils/seance4_plus.R
#
# Sans ces variables, les données sont téléchargées : ces::get_ces("2025"),
# ces::get_ces("1993"), et le fichier SPSS de 1993 sur Borealis. Ce dernier
# est lu avec user_na = TRUE : c'est la seule façon de garder les codes 8
# (ne sait pas) et 9 (refus) que montre le codebook; get_ces() les change
# déjà en NA.
suppressPackageStartupMessages({ library(ces); library(dplyr); library(tidyr); library(haven) })
options(width = 100, pillar.advice = FALSE)

c25 <- Sys.getenv("CES2025_RDS")
df <- if (nzchar(c25) && file.exists(c25)) readRDS(c25) else get_ces("2025")
stopifnot(round(mean(as.numeric(df$cps25_lr_scale_bef_1)), 2) == -11.44)  # comme seance4.js
ces93 <- get_ces("1993")
sav <- Sys.getenv("CES1993_SAV")
if (!(nzchar(sav) && file.exists(sav))) {
  sav <- tempfile(fileext = ".sav")
  download.file("https://borealisdata.ca/api/access/datafile/563806", sav, mode = "wb", quiet = TRUE)
}
ces93_brut <- read_sav(sav, user_na = TRUE)
names(ces93_brut) <- tolower(names(ces93_brut))

sortie <- function(code, env) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = env)))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
# Chaque bloc s'exécute à la suite du précédent, dans son propre environnement.
executer <- function(codes, env) lapply(codes, function(code) list(`in` = code, out = sortie(code, env)))
nouvel <- function() { e <- new.env(parent = globalenv()); assign("df", df, e); assign("ces93", ces93, e); assign("ces93_brut", ces93_brut, e); e }

# ---- Le codebook de 1993, dans les données brutes : les 8 et les 9 y sont.
cb <- executer(c("table(ces93_brut$cpsg1)"), nouvel())

# ---- Poser une question à R : les onze codes de scolarité.
op <- executer(c("educ <- 1:11", "educ >= 9", "educ == 7", "educ %in% c(6, 7)", "educ <= 5",
                 "sum(ces93$cpso3 >= 9, na.rm = TRUE)"), nouvel())

# ---- case_when() en trois catégories, noms en snake_case.
cw_code <- 'ces93 <- ces93 |>
  mutate(ses_education = case_when(
    cpso3 <= 5  ~ "secondaire_ou_moins",
    cpso3 <= 7  ~ "collegial",
    cpso3 <= 11 ~ "universitaire"
  ))'
cw <- executer(c("count(ces93, cpso3)", cw_code, "count(ces93, ses_education)"), nouvel())

# ---- Quatre façons d'écrire la même variable : a fréquenté l'université (1) ou non (0).
STYLES <- list(
  base = 'ces93$universitaire <- NA
ces93$universitaire[ces93$cpso3 >= 8] <- 1
ces93$universitaire[ces93$cpso3 < 8] <- 0',
  ifelse = "ces93$universitaire <- ifelse(ces93$cpso3 >= 8, 1, 0)",
  if_else = "ces93 <- ces93 |>
  mutate(universitaire = if_else(cpso3 >= 8, 1, 0))",
  case_when = "ces93 <- ces93 |>
  mutate(universitaire = case_when(
    cpso3 >= 8 ~ 1,
    cpso3 < 8  ~ 0
  ))"
)
verif <- 'table(ces93$universitaire, useNA = "ifany")'
styles <- list(); resultats <- list()
for (k in names(STYLES)) {
  e <- nouvel()
  styles[[k]] <- executer(c(STYLES[[k]], verif), e)
  resultats[[k]] <- as.numeric(get("ces93", e)$universitaire)
}
identiques <- all(vapply(resultats, identical, logical(1), resultats[[1]]))
stopifnot(identiques)

# ---- Opérationnaliser : la même question, trois variables.
opz_code <- 'ces93 <- ces93 |>
  mutate(
    ses_universitaire = case_when(cpso3 >= 8 ~ 1, cpso3 < 8 ~ 0),
    ses_education = case_when(
      cpso3 <= 5  ~ "secondaire_ou_moins",
      cpso3 <= 7  ~ "collegial",
      cpso3 <= 11 ~ "universitaire"
    ),
    ses_education_detail = as_factor(cpso3)
  )'
e_opz <- nouvel()
opz <- executer(c(opz_code, "count(ces93, ses_universitaire)", "count(ces93, ses_education)",
                  "count(ces93, ses_education_detail)"), e_opz)
o93 <- get("ces93", e_opz)

# ---- La moyenne, pas à pas; puis NaN.
e_moy <- nouvel()
moy <- executer(c("mean(df$cps25_lr_scale_bef_1)",
                  "d <- df |> mutate(gauche_droite = na_if(cps25_lr_scale_bef_1, -99))",
                  "mean(d$gauche_droite)",
                  "mean(d$gauche_droite, na.rm = TRUE)"), e_moy)
nan <- executer(c("0 / 0",
                  "d |>
  filter(is.na(gauche_droite)) |>
  summarise(moyenne = mean(gauche_droite, na.rm = TRUE))",
                  "is.na(NaN)"), e_moy)

# ---- Billboard : un seul tableau, une ligne par chanson et par semaine.
bb_code <- 'billboard |>
  select(artist, track, starts_with("wk")) |>
  pivot_longer(starts_with("wk"), names_to = "semaine", names_prefix = "wk",
               values_to = "rang", values_drop_na = TRUE)'
e_bb <- nouvel()
bb <- executer(c(bb_code), e_bb)
bb_long <- eval(parse(text = bb_code))
tbl <- function(t, n = 4) list(cols = names(t), rows = lapply(seq_len(min(n, nrow(t))), function(i) unname(as.list(t[i, ]))))
bb_court <- function(t) mutate(t, track = substr(track, 1, 14))

# ---- Les chiffres des figures.
lab <- attr(ces93$cpso3, "labels")
lab <- lab[lab %in% 1:11]
compte <- function(x, niveaux) as.integer(table(factor(as.numeric(x), levels = niveaux)))
brut_g1 <- as.numeric(ces93_brut$cpsg1)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance4_plus.R. Sources : ces::get_ces(\"1993\") et le fichier SPSS de",
  "   l'Étude électorale canadienne 1993 (Borealis, lu avec user_na = TRUE) ; ces::get_ces(\"2025\") ;",
  "   tidyr::billboard.",
  sprintf("   %s. Aucune valeur ici n'est écrite à la main. */", R.version.string),
  "",
  "/* La scolarité en 1993 (cpso3) : codes 1 à 11, étiquettes du codebook, effectifs. Les NA",
  "   sont surtout les répondant.e.s du panel, interrogé.e.s au référendum de 1992 (cpspanel = 2),",
  "   et celles et ceux qui n'ont pas fait l'entrevue de campagne. */",
  sprintf("export const EDUC93 = %s;", J(list(
    codes = unname(as.numeric(lab)), etiquettes = names(lab),
    effectifs = compte(ces93$cpso3, 1:11), na = sum(is.na(ces93$cpso3)), n = nrow(ces93),
    panel = sum(as.numeric(ces93_brut$cpspanel) == 2, na.rm = TRUE),
    sansCampagne = sum(is.na(ces93_brut$cpspanel)),
    nspRefus = sum(as.numeric(ces93_brut$cpso3) %in% c(98, 99)),
    groupes = list(
      universitaire = as.list(setNames(count(o93, ses_universitaire)$n, ifelse(is.na(count(o93, ses_universitaire)$ses_universitaire), "NA", count(o93, ses_universitaire)$ses_universitaire))),
      education = as.list(setNames(count(o93, ses_education)$n, ifelse(is.na(count(o93, ses_education)$ses_education), "NA", count(o93, ses_education)$ses_education)))
    )))),
  "/* La TPS en 1993 (cpsg1), codes bruts : 1, 3, 5, 7, puis 8 (ne sait pas) et 9 (refus). */",
  sprintf("export const TPS93 = %s;", J(list(codes = c(1, 3, 5, 7, 8, 9), effectifs = compte(brut_g1, c(1, 3, 5, 7, 8, 9)),
    etiquettes = unname(names(attr(ces93_brut$cpsg1, "labels"))[match(c(1, 3, 5, 7, 8, 9), attr(ces93_brut$cpsg1, "labels"))]),
    na = sum(is.na(brut_g1))))),
  "/* Les quatre styles donnent exactement le même vecteur (identical() dans R). */",
  sprintf("export const STYLES_IDENTIQUES = %s;", J(identiques)),
  "/* Billboard, un seul tableau : l'avant (deux chansons, trois semaines) et l'après. */",
  sprintf("export const BILLBOARD = %s;", J(list(
    avant = tbl(billboard |> slice(1:2) |> bb_court() |> select(artist, track, wk1, wk2, wk3), 2), nAvant = dim(billboard),
    apres = tbl(bb_long |> bb_court(), 6), nApres = dim(bb_long)))),
  "",
  "/* Les consoles, à options(width = 100), telles que R les a imprimées. */",
  sprintf("export const CONSOLES_PLUS = %s;", J(list(
    codebook93 = cb, operateurs93 = op, casewhen93 = cw,
    style_base = styles$base, style_ifelse = styles$ifelse, style_if_else = styles$if_else, style_case_when = styles$case_when,
    operationnaliser = opz, moyenne = moy, nan = nan, billboard = bb)))
)
ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance4_plus.js"))
cat("écrit : src/lib/data/seance4_plus.js\n")
