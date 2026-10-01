# Rend les graphiques ggplot2 de la séance 5 (la section « couche par
# couche ») dans static/img/s5-g-*.png, et écrit le code, les messages de R,
# la console des données et les deux erreurs classiques dans
# src/lib/data/seance5_ggplot.js. Depuis deck/ :
#
#   Rscript outils/seance5_ggplot.R
#
# Les données : Gapminder, par le package R gapminder (Bryan 2017), qui
# reprend un extrait des données de la Gapminder Foundation (gapminder.org) :
# espérance de vie, population et PIB par habitant, par pays, tous les cinq
# ans de 1952 à 2007. On garde 2007, et la population en millions.
#
# Chaque graphique est le code affiché sur la diapo, évalué tel quel; les
# messages et avertissements que R imprime en le dessinant sont gardés. La
# console et les erreurs viennent d'un vrai R, à options(width = 100). Aucune
# valeur ici n'est écrite à la main.
#
# Bryan, J. (2017). gapminder: Data from Gapminder. Package R,
# https://CRAN.R-project.org/package=gapminder
suppressPackageStartupMessages({ library(gapminder); library(dplyr); library(ggplot2) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
dossier_img <- file.path(ici, "..", "static", "img")

# ---- 1. La console des données, telle que la salle la tape.
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
CONSOLE <- c("library(gapminder)",
             "gap07 <- gapminder |>\n  filter(year == 2007) |>\n  mutate(pop = pop / 1000000)",
             "head(gap07)")
GG_CONSOLE <- lapply(CONSOLE, function(code) list(`in` = code, out = sortie(code)))

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

TITRE <- "  labs(title = \"Richesse et espérance de vie\",
       x = \"PIB par habitant ($ US, échelle log)\",
       y = \"Espérance de vie (années)\",
       colour = \"Continent\",
       size = \"Population (millions)\",
       caption = \"Source : Gapminder, 2007\")"

GG <- list(
  vide = rendre("vide", "ggplot(gap07)"),
  axes = rendre("axes", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp))"),
  points = rendre("points", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()"),
  log = rendre("log", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10()"),
  couleur = rendre("couleur", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp,
                  colour = continent)) +
  geom_point() +
  scale_x_log10()"),
  taille = rendre("taille", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp,
                  colour = continent, size = pop)) +
  geom_point() +
  scale_x_log10()"),
  bulles = rendre("bulles", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp,
                  colour = continent, size = pop)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  scale_size(range = c(2, 10))"),
  labs = rendre("labs", paste0("ggplot(gap07, aes(x = gdpPercap, y = lifeExp,
                  colour = continent, size = pop)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  scale_size(range = c(2, 10)) +
", TITRE)),
  theme = rendre("theme", paste0("ggplot(gap07, aes(x = gdpPercap, y = lifeExp,
                  colour = continent, size = pop)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  scale_size(range = c(2, 10)) +
", TITRE, " +
  theme_minimal()")),
  # Dans aes(), ou hors de aes() : la même couleur, à deux endroits.
  bleuAes = rendre("bleu-aes", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(colour = \"blue\"))", largeur = 5, hauteur = 3.6),
  bleu = rendre("bleu", "ggplot(gap07, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(colour = \"blue\")", largeur = 5, hauteur = 3.6)
)

# ---- 3. Deux erreurs classiques : un vrai Rscript, dont on garde le message
#      tel qu'il s'affiche, sans la trace d'appels (backtrace) que R ajoute
#      hors d'une session interactive. Exécuté dans un dossier temporaire :
#      le graphique que la première ligne affiche n'atterrit pas dans le dépôt.
erreur <- function(code) {
  f <- tempfile(fileext = ".R")
  writeLines(c("suppressPackageStartupMessages({ library(gapminder); library(dplyr); library(ggplot2) })",
               "options(rlang_backtrace_on_error = 'none', width = 100)",
               "gap07 <- gapminder |> filter(year == 2007) |> mutate(pop = pop / 1000000)", code), f)
  old <- setwd(tempdir()); on.exit(setwd(old))
  out <- suppressWarnings(system2("Rscript", f, stdout = TRUE, stderr = TRUE))
  out <- out[!grepl("^Execution halted|^Backtrace|^\\s*[▆█├└│]", out)]
  paste(out, collapse = "\n")
}
GG_ERREURS <- list(
  pipe = list(code = "ggplot(gap07, aes(x = gdpPercap, y = lifeExp)) |>
  geom_point()"),
  ligne = list(code = "ggplot(gap07, aes(x = gdpPercap, y = lifeExp))
  + geom_point()")
)
GG_ERREURS <- lapply(GG_ERREURS, function(e) c(e, sortie = erreur(e$code)))

# ---- Écrire le module.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_ggplot.R. Source : Gapminder, par le package R gapminder",
  sprintf("   (Bryan 2017, version %s), année 2007, %d pays. %s, ggplot2 %s.",
          packageVersion("gapminder"), nrow(gap07), R.version.string, packageVersion("ggplot2")),
  "   Aucune valeur ici n'est écrite à la main. */",
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
