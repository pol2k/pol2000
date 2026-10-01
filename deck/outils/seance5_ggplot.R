# Rend les graphiques ggplot2 de la séance 5 (la section « couche par
# couche » et la finale « Changer de géométrie ») dans
# static/img/s5-g-*.png, et écrit le code, les messages de R, la console des
# données et les deux erreurs classiques dans src/lib/data/seance5_ggplot.js.
# Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_ggplot.R
#
# Sans CES2025_RDS, ces::get_ces("2025").
#
# Les données : l'Étude électorale canadienne 2025, comme tout le cours.
# Deux thermomètres de 0 à 100 : l'opinion de Mark Carney
# (cps25_lead_rating_23) et celle de Pierre Poilievre (cps25_lead_rating_24).
# Le code -99 (pas de réponse) est écarté. L'intention de vote
# (cps25_votechoice) garde les cinq grands partis, codes 1 à 5 ; les autres
# codes (autre parti, ne sait pas, PPC) et les non-réponses sont écartés,
# pour une légende sans NA. Il reste 12 829 répondant.e.s (corrélation
# -0,62 : plus on aime l'un, moins on aime l'autre). Pour un graphique
# lisible, et pour faire écho au « budget de 1 000 » de la séance, on
# dessine 1 000 répondant.e.s tiré.e.s au hasard (set.seed fixé). Aucune
# pondération.
#
# as.numeric() sur les thermomètres : la colonne porte la question du
# sondage en attribut « label », que ggplot2 4 prend comme titre d'axe (la
# question anglaise, tronquée). as.numeric() l'enlève.
#
# Chaque graphique est le code affiché sur la diapo, évalué tel quel; les
# messages et avertissements que R imprime en le dessinant sont gardés. La
# console et les erreurs viennent d'un vrai R, à options(width = 100). Aucune
# valeur ici n'est écrite à la main.
suppressPackageStartupMessages({ library(ces); library(dplyr); library(haven); library(ggplot2) })
options(width = 100, pillar.advice = FALSE)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
dossier_img <- file.path(ici, "..", "static", "img")

cache <- Sys.getenv("CES2025_RDS")
df_raw <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

# ---- 1. La console des données, telle que la salle la tape.
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
CONSOLE <- c(
  "ces <- df_raw |>
  transmute(note_carney = as.numeric(cps25_lead_rating_23),
            note_poilievre = as.numeric(cps25_lead_rating_24),
            vote = factor(as.numeric(cps25_votechoice), levels = 1:5,
                          labels = c(\"Libéral\", \"Conservateur\", \"NPD\",
                                     \"Bloc\", \"Vert\"))) |>
  filter(note_carney >= 0, note_poilievre >= 0, !is.na(vote))",
  "set.seed(2025)
ces1000 <- slice_sample(ces, n = 1000)",
  "head(ces1000)")
GG_CONSOLE <- lapply(CONSOLE, function(code) list(`in` = code, out = sortie(code)))
stopifnot(nrow(ces) == 12829, nrow(ces1000) == 1000)

# ---- 2. Le graphique, couche par couche.
# set.seed() avant chaque rendu : si une géométrie tire au hasard, le même
# code redonne la même image, d'une diapo et d'une exécution à l'autre.
rendre <- function(nom, code, largeur = 6.4, hauteur = 4) {
  p <- eval(parse(text = code), envir = globalenv())
  msgs <- character()
  set.seed(2025)
  withCallingHandlers(
    ggsave(file.path(dossier_img, paste0("s5-g-", nom, ".png")), p, width = largeur, height = hauteur,
           dpi = 220, device = ragg::agg_png, bg = "white"),
    message = function(m) { msgs <<- c(msgs, trimws(conditionMessage(m))); invokeRestart("muffleMessage") },
    warning = function(w) { msgs <<- c(msgs, trimws(conditionMessage(w))); invokeRestart("muffleWarning") })
  list(code = code, image = paste0("s5-g-", nom, ".png"), messages = unique(msgs))
}

# Les morceaux qui reviennent d'une étape à l'autre.
# La couleur va dans le aes() de geom_point(), pas dans celui de ggplot() :
# dans ggplot(), elle vaudrait aussi pour geom_smooth(), qui tracerait une
# droite par parti (cinq droites et cinq bandes, illisible). Ici, les points
# prennent la couleur du vote et la tendance reste une seule droite, noire
# (une couleur fixe, hors de aes() : la diapo « Dans aes(), ou hors de
# aes() ? » suit).
AES <- "ggplot(ces1000, aes(x = note_carney, y = note_poilievre))"
POINTS <- "  geom_point(alpha = 0.3)"
POINTS_C <- "  geom_point(aes(colour = vote), alpha = 0.3)"
TENDANCE <- "  geom_smooth(method = \"lm\", colour = \"black\")"
PARTIS <- "  scale_colour_manual(values = c(\"red3\", \"navy\", \"orange\",
                                 \"deepskyblue\", \"green4\"))"
# Texte de l'image, lu par la salle : espace fine insécable (U+202F) avant
# le deux-points et dans « 1 000 ».
TITRE <- "  labs(title = \"Plus on aime Carney, moins on aime Poilievre\",
       subtitle = \"1 000 répondant.e.s tiré.e.s au hasard\",
       x = \"Mark Carney (0 à 100)\",
       y = \"Pierre Poilievre (0 à 100)\",
       colour = \"Vote\",
       caption = \"Source : Étude électorale canadienne 2025\")"
plus <- function(...) paste(c(...), collapse = " +\n")

GG <- list(
  vide = rendre("vide", "ggplot(ces1000)"),
  axes = rendre("axes", AES),
  points = rendre("points", plus(AES, "  geom_point()")),
  alpha = rendre("alpha", plus(AES, POINTS)),
  tendance = rendre("tendance", plus(AES, POINTS, TENDANCE)),
  couleur = rendre("couleur", plus(AES, POINTS_C, TENDANCE)),
  partis = rendre("partis", plus(AES, POINTS_C, TENDANCE, PARTIS)),
  labs = rendre("labs", plus(AES, POINTS_C, TENDANCE, PARTIS, TITRE)),
  theme = rendre("theme", plus(AES, POINTS_C, TENDANCE, PARTIS, TITRE, "  theme_minimal()")),
  # Dans aes(), ou hors de aes() : la même couleur, à deux endroits.
  bleuAes = rendre("bleu-aes", plus(AES, "  geom_point(aes(colour = \"blue\"))"), largeur = 5, hauteur = 3.6),
  bleu = rendre("bleu", plus(AES, "  geom_point(colour = \"blue\")"), largeur = 5, hauteur = 3.6)
)

# ---- 3. Changer de géométrie : les mêmes données. D'abord le même aes(),
#      seule la ligne geom_...() change; puis une autre question (une
#      variable, ou une catégorie), où aes() change aussi. Thème par défaut,
#      sans habillage : le code tient en deux lignes.
GG_GEOMS <- list(
  point = rendre("geom-point", plus(AES, "  geom_point()")),
  count = rendre("geom-count", plus(AES, "  geom_count()")),
  bin = rendre("geom-bin", plus(AES, "  geom_bin_2d()")),
  densite = rendre("geom-densite", plus(AES, "  geom_density_2d_filled()")),
  histo = rendre("geom-histo", plus("ggplot(ces1000, aes(x = note_carney))", "  geom_histogram()")),
  boite = rendre("geom-boite", plus("ggplot(ces1000, aes(x = vote, y = note_carney))", "  geom_boxplot()")),
  barres = rendre("geom-barres", plus("ggplot(ces1000, aes(x = vote))", "  geom_bar()"))
)

# ---- 4. Deux erreurs classiques : un vrai Rscript, dont on garde le message
#      tel qu'il s'affiche, sans la trace d'appels (backtrace) que R ajoute
#      hors d'une session interactive. Exécuté dans un dossier temporaire :
#      le graphique que la première ligne affiche n'atterrit pas dans le dépôt.
#      Les mêmes 1 000 répondant.e.s, relues depuis un .rds temporaire.
tmp_rds <- tempfile(fileext = ".rds"); saveRDS(ces1000, tmp_rds)
erreur <- function(code) {
  f <- tempfile(fileext = ".R")
  writeLines(c("suppressPackageStartupMessages(library(ggplot2))",
               "options(rlang_backtrace_on_error = 'none', width = 100)",
               sprintf('ces1000 <- readRDS("%s")', tmp_rds), code), f)
  old <- setwd(tempdir()); on.exit(setwd(old))
  out <- suppressWarnings(system2("Rscript", f, stdout = TRUE, stderr = TRUE))
  out <- out[!grepl("^Execution halted|^Backtrace|^\\s*[▆█├└│]", out)]
  paste(out, collapse = "\n")
}
GG_ERREURS <- list(
  pipe = list(code = paste0(AES, " |>\n  geom_point()")),
  ligne = list(code = paste0(AES, "\n  + geom_point()"))
)
GG_ERREURS <- lapply(GG_ERREURS, function(e) c(e, sortie = erreur(e$code)))

# ---- Écrire le module.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
virgule <- function(x) format(round(x, 2), decimal.mark = ",")
out <- c(
  "/* Généré par outils/seance5_ggplot.R. Source : l'Étude électorale canadienne 2025",
  sprintf("   (ces::get_ces(\"2025\")), sans pondération : %s répondant.e.s ont noté Mark Carney",
          format(nrow(ces), big.mark = " ")),
  sprintf("   et Pierre Poilievre et déclarent un vote pour l'un des cinq partis (corrélation %s);",
          virgule(cor(ces$note_carney, ces$note_poilievre))),
  sprintf("   1 000 tiré.e.s au hasard (set.seed(2025), corrélation %s).",
          virgule(cor(ces1000$note_carney, ces1000$note_poilievre))),
  sprintf("   %s, ggplot2 %s. Aucune valeur ici n'est écrite à la main. */",
          R.version.string, packageVersion("ggplot2")),
  "",
  "/* La console des données, à options(width = 100). */",
  sprintf("export const GG_CONSOLE = %s;", J(GG_CONSOLE)),
  "/* Le graphique couche par couche : le code, l'image rendue, les messages de R. */",
  sprintf("export const GG = %s;", J(GG)),
  "/* Changer de géométrie : les mêmes données, une autre géométrie. */",
  sprintf("export const GG_GEOMS = %s;", J(GG_GEOMS)),
  "/* Deux erreurs classiques, telles que R les affiche. */",
  sprintf("export const GG_ERREURS = %s;", J(GG_ERREURS))
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_ggplot.js"))
cat("écrit : src/lib/data/seance5_ggplot.js et static/img/s5-g-*.png\n")
