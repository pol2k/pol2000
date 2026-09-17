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
# La diapositive montre ensuite la MÊME table de sept façons (BARRES.vues), autour
# d'une question : un pourcentage de quoi ?
#   0  effectifs            x = groupe_age, fill = parti, y = effectif
#   1  % du total           même disposition, y = % de tout le tableau
#   2  % du groupe d'âge    une ligne de plus : group_by(groupe_age)
#   3  on inverse           x = parti, fill = groupe_age, mêmes %
#   4  % du parti           group_by(parti) : chaque parti fait 100 %
#   5  écart, par groupe    % du groupe d'âge moins la part du parti dans l'ensemble
#   6  écart, par parti     % du parti moins la part du groupe d'âge dans l'ensemble
# Les sept codes sont exécutés à la suite, dans une session qui ne contient que
# df (comme celle de l'étudiant.e) : la vue 2 réécrit le tableau pct de la vue 1
# (une seule ligne change), 3 et 5 le réutilisent, 6 part de pct_parti (vue 4).
# Chaque graphique est enregistré pour de vrai, puis son tableau et ses barres
# (layer_data) sont comparés aux nombres exportés. L'échantillon n'est pas
# pondéré : « ensemble » veut dire l'ensemble de l'échantillon, pas une moyenne
# nationale.
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

# --- Les nombres de chaque vue, calculés sans passer par le code des vues ---
N <- sum(tab)
total_brut <- 100 * tab / N                          # vue 1 : % du total
pct_brut <- 100 * tab / totaux                       # vues 2, 3 : % du groupe d'âge
parti_brut <- sweep(100 * tab, 2, colSums(tab), "/") # vue 4 : % du parti
ensemble_brut <- 100 * colSums(tab) / N              # part de chaque parti dans l'ensemble
part_age_brut <- 100 * totaux / N                    # part de chaque groupe d'âge
ecart_brut <- sweep(pct_brut, 2, ensemble_brut)      # vue 5
ecart_parti_brut <- sweep(parti_brut, 1, part_age_brut) # vue 6

# --- Sept vues de la même table, chacune exécutée pour vrai ----------------
# table : l'objet que le code crée ou utilise ; y : la colonne dessinée ;
# attendu : la matrice groupes x partis que cette colonne doit contenir ;
# par_parti : x = parti (sinon x = groupe d'âge).
VUES <- list(
  list(id = "effectifs", forts = c('fill = parti', 'position = "dodge"'), code = code,
       table = NULL, y = NULL, attendu = unclass(tab), par_parti = FALSE),
  list(id = "pct_total", forts = c("y = pct", "geom_col"), code =
'pct <- df |>
  count(groupe_age, parti) |>
  mutate(pct = 100 * n / sum(n))
ggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +
  geom_col(position = "dodge")',
       table = "pct", y = "pct", attendu = total_brut, par_parti = FALSE),
  list(id = "pct_groupe", forts = c("group_by(groupe_age)"), code =
'pct <- df |>
  count(groupe_age, parti) |>
  group_by(groupe_age) |>
  mutate(pct = 100 * n / sum(n))
ggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +
  geom_col(position = "dodge")',
       table = "pct", y = "pct", attendu = pct_brut, par_parti = FALSE),
  list(id = "inverse", forts = c("x = parti", "fill = groupe_age"), code =
'# le même tableau pct
ggplot(pct, aes(x = parti, y = pct, fill = groupe_age)) +
  geom_col(position = "dodge")',
       table = "pct", y = "pct", attendu = pct_brut, par_parti = TRUE),
  list(id = "pct_parti", forts = c("group_by(parti)"), code =
'pct_parti <- df |>
  count(parti, groupe_age) |>
  group_by(parti) |>
  mutate(pct = 100 * n / sum(n))
ggplot(pct_parti, aes(x = parti, y = pct, fill = groupe_age)) +
  geom_col(position = "dodge")',
       table = "pct_parti", y = "pct", attendu = parti_brut, par_parti = TRUE),
  list(id = "ecart_groupe", forts = c("ecart = pct - ensemble", "y = ecart"), code =
'ecarts <- pct |>
  group_by(parti) |>
  mutate(ensemble = 100 * sum(n) / nrow(df),
         ecart = pct - ensemble)
ggplot(ecarts, aes(x = parti, y = ecart, fill = groupe_age)) +
  geom_col(position = "dodge")',
       table = "ecarts", y = "ecart", attendu = ecart_brut, par_parti = TRUE),
  list(id = "ecart_parti", forts = c("pct_parti", "group_by(groupe_age)"), code =
'ecarts_parti <- pct_parti |>
  group_by(groupe_age) |>
  mutate(ensemble = 100 * sum(n) / nrow(df),
         ecart = pct - ensemble)
ggplot(ecarts_parti, aes(x = parti, y = ecart, fill = groupe_age)) +
  geom_col(position = "dodge")',
       table = "ecarts_parti", y = "ecart", attendu = ecart_parti_brut, par_parti = TRUE)
)

# Une session propre : df et rien d'autre. Les vues s'y exécutent dans l'ordre,
# et chacune est vérifiée tout de suite (la vue 2 réécrit le tableau de la vue 1).
session <- new.env(parent = globalenv())
assign("df", df, envir = session)
for (v in VUES) {
  # Chaque morceau mis en rouge existe une seule fois dans le code affiché.
  for (f in v$forts) stopifnot(lengths(regmatches(v$code, gregexpr(f, v$code, fixed = TRUE))) == 1)
  gv <- eval(parse(text = v$code), envir = session)
  stopifnot(inherits(gv, "ggplot"))
  f <- tempfile(fileext = ".png")
  ggsave(f, gv, width = 8, height = 4.5, dpi = 100)
  stopifnot(file.exists(f), file.size(f) > 0)
  unlink(f)

  # Le tableau que le code a construit, cellule par cellule.
  if (!is.null(v$table)) {
    tv <- as.data.frame(get(v$table, envir = session))
    stopifnot(nrow(tv) == length(tab))
    for (i in seq_len(nrow(tv))) {
      gr <- as.character(tv$groupe_age[i]); pa <- as.character(tv$parti[i])
      stopifnot(tv$n[i] == tab[gr, pa], isTRUE(all.equal(tv[[v$y]][i], v$attendu[gr, pa])))
      if (v$y == "ecart") stopifnot(isTRUE(all.equal(tv$ecart[i], tv$pct[i] - tv$ensemble[i])))
      if (v$id == "ecart_groupe") stopifnot(isTRUE(all.equal(tv$ensemble[i], unname(ensemble_brut[pa]))))
      if (v$id == "ecart_parti") stopifnot(isTRUE(all.equal(tv$ensemble[i], unname(part_age_brut[gr]))))
    }
  }
  # Les barres que ggplot2 dessine : x puis group. Par groupe d'âge, on lit la
  # matrice ligne par ligne ; par parti, colonne par colonne.
  cv <- layer_data(gv); cv <- cv[order(cv$x, cv$group), ]
  hauteurs <- if (is.null(v$y)) cv$count else cv$y
  stopifnot(isTRUE(all.equal(hauteurs, as.vector(if (v$par_parti) v$attendu else t(v$attendu)))))
  cat("vue", v$id, ": code exécuté, graphique enregistré, tableau et barres vérifiés\n")
}

# Un pourcentage de quoi ? Chaque dénominateur fait bien 100.
stopifnot(isTRUE(all.equal(sum(total_brut), 100)),
          isTRUE(all.equal(unname(rowSums(pct_brut)), rep(100, length(GROUPES)))),
          isTRUE(all.equal(unname(colSums(parti_brut)), rep(100, length(PARTIS)))),
          isTRUE(all.equal(sum(ensemble_brut), 100)), isTRUE(all.equal(sum(part_age_brut), 100)))
# % du total : le même dessin que les effectifs, à un facteur près.
stopifnot(isTRUE(all.equal(as.vector(total_brut) * N / 100, as.vector(tab))))
# Pondérés par la taille des groupes (vue 5) ou des partis (vue 6), les écarts s'annulent.
stopifnot(all(abs(colSums(ecart_brut * as.vector(totaux))) < 1e-8),
          all(abs(rowSums(sweep(ecart_parti_brut, 2, colSums(tab), "*"))) < 1e-8))

pct_total <- round(total_brut, 1)
pct_parti <- round(parti_brut, 1)
ensemble <- round(ensemble_brut, 1)
part_age <- round(part_age_brut, 1)
ecarts <- round(ecart_brut, 1)
ecarts_parti <- round(ecart_parti_brut, 1)

# L'arithmétique faite à la main sur les nombres arrondis ne s'éloigne jamais de
# plus d'un dixième de point de l'écart exporté (arrondi après la soustraction).
stopifnot(max(abs(sweep(pct, 2, ensemble) - ecarts)) <= 0.1 + 1e-9,
          max(abs(sweep(pct_parti, 1, part_age) - ecarts_parti)) <= 0.1 + 1e-9)

cat("% du total :\n"); print(pct_total)
cat("% du parti :\n"); print(pct_parti)
cat("part de chaque parti dans l'ensemble de l'échantillon (%) :\n"); print(ensemble)
cat("part de chaque groupe d'âge dans l'ensemble de l'échantillon (%) :\n"); print(part_age)
cat("écarts, par groupe d'âge (points de %) :\n"); print(ecarts)
cat("écarts, par parti (points de %) :\n"); print(ecarts_parti)

res <- list(
  r = R.version.string,
  ggplot2 = as.character(packageVersion("ggplot2")),
  dplyr = as.character(packageVersion("dplyr")),
  n = nrow(df),
  ecartes = ecartes,
  partis = PARTIS,
  preparation = preparation,
  code = code,
  vues = lapply(VUES, function(v) list(id = v$id, forts = I(v$forts), code = v$code)),
  ensemble = as.numeric(ensemble),
  totauxPartis = as.integer(colSums(tab)),
  groupes = lapply(GROUPES, function(gr) list(
    nom = gr,
    total = unname(totaux[gr]),
    part = unname(part_age[gr]),
    effectifs = as.integer(tab[gr, ]),
    pctTotal = as.numeric(pct_total[gr, ]),
    pourcentages = as.numeric(pct[gr, ]),
    pctParti = as.numeric(pct_parti[gr, ]),
    ecarts = as.numeric(ecarts[gr, ]),
    ecartsParti = as.numeric(ecarts_parti[gr, ])
  ))
)

cible <- file.path("src", "lib", "data", "seance3_barres.js")
writeLines(c(
  "// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.",
  "// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon",
  "// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6",
  "// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les",
  "// valeurs manquantes sont écartés. Dans chaque groupe, les vecteurs suivent",
  "// l'ordre de partis. pctTotal : % de tout le tableau ; pourcentages : % dans le",
  "// groupe d'âge ; pctParti : % dans le parti. ensemble : part de chaque parti dans",
  "// tout l'échantillon ; part : part du groupe d'âge dans tout l'échantillon (non",
  "// pondéré, ce n'est pas une moyenne nationale). ecarts : pourcentages moins",
  "// ensemble ; ecartsParti : pctParti moins part ; en points de pourcentage,",
  "// arrondis après la soustraction. vues : le code de chaque vue, exécuté tel quel",
  "// et à la suite par le script, et ses morceaux à mettre en rouge.",
  paste0("export const BARRES = ", toJSON(res, auto_unbox = TRUE, pretty = TRUE), ";")
), cible)

unlink(png)
cat("écrit :", cible, "\n")
