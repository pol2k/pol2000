#!/usr/bin/env Rscript
# Séance 3, « Le vote, selon le groupe d'âge » : un diagramme à barres groupées
# (geom_bar, fill, position = "dodge") de l'intention de vote selon le groupe
# d'âge, Étude électorale canadienne 2025. Rien n'est tapé à la main.
#
# L'âge (cps25_age_in_years) devient une variable catégorielle avec cut() :
# 18-34, 35-54, 55 et plus. L'intention de vote (cps25_votechoice) garde les
# cinq partis que la séance montre déjà (codes 1 à 5) ; « un autre parti »
# (code 6) et le Parti populaire (code 8) sont réunis dans « Autre ». Le
# code 7 (« ne sait pas / préfère ne pas répondre ») et les valeurs
# manquantes sont écartés.
#
# Le code exporté (BARRES.code) est celui de la première vue. Le script
# l'exécute tel quel sur le tableau df, enregistre le graphique dans un fichier
# temporaire, puis vérifie que les hauteurs des barres calculées par ggplot2
# sont bien les effectifs exportés.
#
# La diapositive montre ensuite la MÊME table de quatre façons (BARRES.vues) :
#   A  effectifs          x = groupe_age, fill = parti, y = effectif
#   B  pourcentages       même disposition, y = % dans chaque groupe d'âge
#   C  on inverse         x = parti, fill = groupe_age, mêmes %
#   D  écart à l'ensemble x = parti, y = % du groupe moins % de tout l'échantillon
# Les quatre codes sont exécutés à la suite, dans une session qui ne contient que
# df (comme celle de l'étudiant.e) : C réutilise le tableau pct de B, D aussi.
# Chaque graphique est enregistré pour de vrai, puis ses barres (layer_data) sont
# comparées aux nombres exportés. L'échantillon n'est pas pondéré : « ensemble »
# veut dire l'ensemble de l'échantillon, pas une moyenne nationale.
#
# Usage, depuis deck/ :
#   CES2025_RDS=/chemin/vers/ces2025.rds Rscript outils/seance3_barres.R
# Écrit : src/lib/data/seance3_barres.js

suppressPackageStartupMessages({ library(ggplot2); library(dplyr); library(jsonlite) })

rds <- Sys.getenv("CES2025_RDS")
if (!nzchar(rds) || !file.exists(rds)) stop("CES2025_RDS doit pointer vers le .rds de l'ÉÉC 2025.")
ces <- readRDS(rds)

# --- Le tableau de l'étudiant.e : deux variables catégorielles -------------
GROUPES <- c("18-34", "35-54", "55 et plus")
PARTIS <- c("Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre")
# Codes de cps25_votechoice, dans l'ordre 1 à 8 ; le code 7 devient NA.
CODES <- c("Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre", NA, "Autre")

# Le code de préparation, exécuté tel quel lui aussi.
preparation <- 'df$groupe_age <- cut(df$age, breaks = c(18, 35, 55, Inf), right = FALSE,
                     labels = c("18-34", "35-54", "55 et plus"))'

# unclass() : les colonnes sont des haven_labelled ; on en garde les codes bruts,
# sans dépendre du paquet haven.
vote <- as.numeric(unclass(ces$cps25_votechoice))
df <- data.frame(
  age = as.numeric(unclass(ces$cps25_age_in_years)),
  parti = factor(CODES[vote], levels = PARTIS)
)
ecartes <- list(ne_sait_pas = sum(vote == 7, na.rm = TRUE), manquants = sum(is.na(vote)))
df <- df[!is.na(df$parti) & !is.na(df$age), ]
eval(parse(text = preparation))
stopifnot(identical(levels(df$groupe_age), GROUPES), !anyNA(df$groupe_age))

# --- Le code de la première vue, exécuté pour vrai -------------------------
code <- 'ggplot(df, aes(x = groupe_age, fill = parti)) +
  geom_bar(position = "dodge")'
g <- eval(parse(text = code))
png <- tempfile(fileext = ".png")
ggsave(png, g, width = 8, height = 4.5, dpi = 100)
stopifnot(file.exists(png), file.size(png) > 0)
cat("graphique de preuve :", png, "\n")

# --- Effectifs, totaux, pourcentages dans chaque groupe --------------------
tab <- table(df$groupe_age, df$parti)
totaux <- rowSums(tab)
pct <- round(100 * tab / totaux, 1)

# Les barres que ggplot2 dessine ont exactement ces hauteurs.
couche <- layer_data(g)
couche <- couche[order(couche$x, couche$group), ]
stopifnot(all(couche$count == as.vector(t(tab))))

print(addmargins(tab, 2))
print(pct)

# --- Quatre vues de la même table, chacune exécutée pour vrai --------------
VUES <- list(
  list(id = "effectifs", forts = c('fill = parti', 'position = "dodge"'), code = code),
  list(id = "pourcentages", forts = c("y = pct", "geom_col"), code =
'pct <- df |>
  count(groupe_age, parti) |>
  group_by(groupe_age) |>
  mutate(pct = 100 * n / sum(n))
ggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +
  geom_col(position = "dodge")'),
  list(id = "inverse", forts = c("x = parti", "fill = groupe_age"), code =
'# le même tableau pct
ggplot(pct, aes(x = parti, y = pct, fill = groupe_age)) +
  geom_col(position = "dodge")'),
  list(id = "ecart", forts = c("ecart = pct - ensemble", "y = ecart"), code =
'ecarts <- pct |>
  group_by(parti) |>
  mutate(ensemble = 100 * sum(n) / nrow(df),
         ecart = pct - ensemble)
ggplot(ecarts, aes(x = parti, y = ecart, fill = groupe_age)) +
  geom_col(position = "dodge")')
)

# Une session propre : df et rien d'autre. Les vues s'y exécutent dans l'ordre.
session <- new.env(parent = globalenv())
assign("df", df, envir = session)
graphiques <- lapply(VUES, function(v) {
  # Chaque morceau mis en rouge existe une seule fois dans le code affiché.
  for (f in v$forts) stopifnot(lengths(regmatches(v$code, gregexpr(f, v$code, fixed = TRUE))) == 1)
  gv <- eval(parse(text = v$code), envir = session)
  stopifnot(inherits(gv, "ggplot"))
  f <- tempfile(fileext = ".png")
  ggsave(f, gv, width = 8, height = 4.5, dpi = 100)
  stopifnot(file.exists(f), file.size(f) > 0)
  cat("vue", v$id, ": graphique de preuve", f, "\n")
  unlink(f)
  gv
})

# Les nombres exportés, calculés ici sans passer par le code des vues.
ensemble_brut <- 100 * colSums(tab) / sum(tab)
pct_brut <- 100 * tab / totaux
ecart_brut <- sweep(pct_brut, 2, ensemble_brut)
ensemble <- round(ensemble_brut, 1)
ecarts <- round(ecart_brut, 1)

# Les tableaux que le code des vues a construits disent la même chose.
tpct <- as.data.frame(get("pct", envir = session))
tec <- as.data.frame(get("ecarts", envir = session))
stopifnot(nrow(tpct) == length(tab), nrow(tec) == length(tab))
for (i in seq_len(nrow(tec))) {
  gr <- as.character(tec$groupe_age[i]); pa <- as.character(tec$parti[i])
  stopifnot(tec$n[i] == tab[gr, pa],
            isTRUE(all.equal(tpct$pct[i], pct_brut[gr, pa])),
            isTRUE(all.equal(tec$ensemble[i], unname(ensemble_brut[pa]))),
            isTRUE(all.equal(tec$ecart[i], ecart_brut[gr, pa])),
            # l'écart est bien le pourcentage du groupe moins celui de l'ensemble
            isTRUE(all.equal(tec$ecart[i], tec$pct[i] - tec$ensemble[i])))
}
# Et les barres que ggplot2 dessine ont ces hauteurs. B : x = groupe, group = parti ;
# C et D : x = parti, group = groupe d'âge.
cB <- layer_data(graphiques[[2]]); cB <- cB[order(cB$x, cB$group), ]
stopifnot(isTRUE(all.equal(cB$y, as.vector(t(pct_brut)))))
cC <- layer_data(graphiques[[3]]); cC <- cC[order(cC$x, cC$group), ]
stopifnot(isTRUE(all.equal(cC$y, as.vector(pct_brut))))
cD <- layer_data(graphiques[[4]]); cD <- cD[order(cD$x, cD$group), ]
stopifnot(isTRUE(all.equal(cD$y, as.vector(ecart_brut))))
# Pondérés par la taille des groupes, les écarts d'un parti s'annulent.
stopifnot(all(abs(colSums(ecart_brut * as.vector(totaux))) < 1e-8))
# L'arithmétique côté composant (pourcentage arrondi moins ensemble arrondi)
# ne s'éloigne jamais de plus d'un dixième de point de l'écart exporté.
cote_composant <- sweep(pct, 2, ensemble)
stopifnot(max(abs(cote_composant - ecarts)) <= 0.1 + 1e-9)
cat("différence maximale entre (pct - ensemble) arrondis et l'écart exporté :",
    max(abs(cote_composant - ecarts)), "\n")

cat("ensemble de l'échantillon (%) :\n"); print(ensemble)
cat("écarts (points de %) :\n"); print(ecarts)

res <- list(
  r = R.version.string,
  ggplot2 = as.character(packageVersion("ggplot2")),
  dplyr = as.character(packageVersion("dplyr")),
  n = nrow(df),
  ecartes = ecartes,
  partis = PARTIS,
  preparation = preparation,
  code = code,
  vues = VUES,
  ensemble = as.numeric(ensemble),
  groupes = lapply(GROUPES, function(gr) list(
    nom = gr,
    total = unname(totaux[gr]),
    effectifs = as.integer(tab[gr, ]),
    pourcentages = as.numeric(pct[gr, ]),
    ecarts = as.numeric(ecarts[gr, ])
  ))
)

cible <- file.path("src", "lib", "data", "seance3_barres.js")
writeLines(c(
  "// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.",
  "// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon",
  "// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6",
  "// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les",
  "// valeurs manquantes sont écartés. effectifs, pourcentages et ecarts suivent",
  "// l'ordre de partis ; les pourcentages sont calculés dans chaque groupe d'âge.",
  "// ensemble : part de chaque parti dans tout l'échantillon (non pondéré, ce n'est",
  "// pas une moyenne nationale) ; ecarts : pourcentage du groupe moins ensemble, en",
  "// points de pourcentage, arrondi après la soustraction. vues : le code de chaque",
  "// vue, exécuté tel quel et à la suite par le script, et ses morceaux en rouge.",
  paste0("export const BARRES = ", toJSON(res, auto_unbox = TRUE, pretty = TRUE), ";")
), cible)

unlink(png)
cat("écrit :", cible, "\n")
