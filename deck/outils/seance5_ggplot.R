# Rend les graphiques ggplot2 de la séance 5 (la section « couche par
# couche ») dans static/img/s5-g-*.png, et écrit le code, les messages de R,
# la console des données et les deux erreurs classiques dans
# src/lib/data/seance5_ggplot.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_ggplot.R
#
# Sans CES2025_RDS, ces::get_ces("2025").
#
# Les données : l'Étude électorale canadienne 2025, comme tout le cours.
# Deux thermomètres de 0 à 100 : l'opinion du Parti conservateur
# (cps25_party_rating_24) et celle de son chef, Pierre Poilievre
# (cps25_lead_rating_24). Le code -99 (pas de réponse) est écarté : il reste
# 18 436 répondant.e.s, corrélation 0,89. L'intention de vote
# (cps25_votechoice) garde les cinq grands partis, codes 1 à 5 ; les autres
# codes et les non-réponses deviennent NA (en gris sur le graphique). Pour
# un graphique lisible, et pour faire écho au « budget de 1 000 » de la
# séance, on dessine 1 000 répondant.e.s tiré.e.s au hasard (set.seed fixé).
# Aucune pondération.
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
  transmute(note_parti = as.numeric(cps25_party_rating_24),
            note_poilievre = as.numeric(cps25_lead_rating_24),
            vote = factor(as.numeric(cps25_votechoice), levels = 1:5,
                          labels = c(\"Libéral\", \"Conservateur\", \"NPD\",
                                     \"Bloc\", \"Vert\"))) |>
  filter(note_parti >= 0, note_poilievre >= 0)",
  "set.seed(2025)
ces1000 <- slice_sample(ces, n = 1000)",
  "head(ces1000)")
GG_CONSOLE <- lapply(CONSOLE, function(code) list(`in` = code, out = sortie(code)))
stopifnot(nrow(ces) == 18436, nrow(ces1000) == 1000)

# ---- 2. Le graphique, couche par couche.
rendre <- function(nom, code, largeur = 6.4, hauteur = 4) {
  p <- eval(parse(text = code), envir = globalenv())
  msgs <- character()
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
# droite par parti (six droites et six bandes, illisible). Ici, les points
# prennent la couleur du vote et la tendance reste une seule droite, noire
# (une couleur fixe, hors de aes() : la diapo « Dans aes(), ou hors de
# aes() ? » suit).
AES <- "ggplot(ces1000, aes(x = note_parti, y = note_poilievre))"
POINTS <- "  geom_point(alpha = 0.3)"
POINTS_C <- "  geom_point(aes(colour = vote), alpha = 0.3)"
TENDANCE <- "  geom_smooth(method = \"lm\", colour = \"black\")"
PARTIS <- "  scale_colour_manual(values = c(\"red3\", \"navy\", \"orange\",
                                 \"deepskyblue\", \"green4\"))"
TITRE <- "  labs(title = \"Le parti et son chef\",
       subtitle = \"1 000 répondant.e.s tiré.e.s au hasard\",
       x = \"Le Parti conservateur (0 à 100)\",
       y = \"Pierre Poilievre (0 à 100)\",
       colour = \"Vote\",
       caption = \"Source : Étude électorale canadienne 2025\")"
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

# ---- 3. Deux erreurs classiques : un vrai Rscript, dont on garde le message
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
out <- c(
  "/* Généré par outils/seance5_ggplot.R. Source : l'Étude électorale canadienne 2025",
  sprintf("   (ces::get_ces(\"2025\")), sans pondération : %s répondant.e.s ont noté le Parti",
          format(nrow(ces), big.mark = " ")),
  sprintf("   conservateur et Pierre Poilievre (corrélation %s); 1 000 tiré.e.s au hasard (set.seed(2025)).",
          format(round(cor(ces$note_parti, ces$note_poilievre), 2), decimal.mark = ",")),
  sprintf("   %s, ggplot2 %s. Aucune valeur ici n'est écrite à la main. */",
          R.version.string, packageVersion("ggplot2")),
  "",
  "/* La console des données, à options(width = 100). */",
  sprintf("export const GG_CONSOLE = %s;", J(GG_CONSOLE)),
  "/* Le graphique couche par couche : le code, l'image rendue, les messages de R. */",
  sprintf("export const GG = %s;", J(GG)),
  "/* Deux erreurs classiques, telles que R les affiche. */",
  sprintf("export const GG_ERREURS = %s;", J(GG_ERREURS))
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_ggplot.js"))
cat("écrit : src/lib/data/seance5_ggplot.js et static/img/s5-g-*.png\n")
