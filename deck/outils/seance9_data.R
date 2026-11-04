# Exporte tout ce que la séance 9 montre de l'Étude électorale canadienne 2025
# vers src/lib/data/seance9.js et static/img/s9-*.png : la batterie de
# populisme du sondage postélectoral (huit énoncés, pes25_populism_1 à _8),
# ses corrélations, les deux analyses factorielles de sondr::topdown_fa()
# (tous les items, puis sans les deux qui détonnent), l'échelle et son
# histogramme, et une régression de l'échelle sur la scolarité.
#
#   CES2025_RDS=~/ces2025.rds Rscript outils/seance9_data.R
#
# Sans CES2025_RDS : CES2025_DTA (le .dta de la CES), sinon ces::get_ces("2025").
# Aucune pondération. Les sorties de la console sont capturées telles que R
# les imprime (options(width = 100)), messages et avertissements compris :
# rien n'est tapé à la main.
suppressPackageStartupMessages({ library(dplyr); library(haven) })
options(width = 100)
pdf(NULL)   # les appels hors png() ne doivent pas laisser un Rplots.pdf

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
ici <- normalizePath(ici)
rds <- Sys.getenv("CES2025_RDS"); dta <- Sys.getenv("CES2025_DTA")
d <- if (nzchar(rds) && file.exists(rds)) readRDS(rds) else
     if (nzchar(dta) && file.exists(dta)) read_dta(dta) else ces::get_ces("2025")
IMG <- normalizePath(file.path(ici, "..", "static", "img"))
r <- function(x, k = 2) round(x, k)

# ---- Les huit énoncés, tels que la CES les libelle (étiquettes Stata, 80
# caractères). Les versions françaises sont dans la diapo (M9Items).
ITEMS <- lapply(1:8, function(i) {
  v <- paste0("pes25_populism_", i)
  list(n = i, var = v, label = trimws(attr(d[[v]], "label")))
})
ECHELLE <- lapply(names(attr(d$pes25_populism_3, "labels")), function(x) x)

# ---- La salle travaille dans un dossier qui contient ces2025.rds (séance 2).
tmp <- tempfile("s9-"); dir.create(tmp)
saveRDS(d, file.path(tmp, "ces2025.rds"))
ancien <- setwd(tmp)
rm(list = intersect(ls(), c("df_raw", "df_clean", "df_fa", "df_fa2", "modele")))

# Capture ce que R imprime : la valeur visible, les messages (sondr parle par
# message()) et les avertissements, dans l'ordre où Positron les montre.
sortie <- function(code) {
  out <- character(0); msgs <- character(0); avert <- character(0)
  out <- capture.output(res <- withCallingHandlers(
    withVisible(eval(parse(text = code), envir = globalenv())),
    message = function(m) { msgs <<- c(msgs, sub("\n$", "", conditionMessage(m))); invokeRestart("muffleMessage") },
    warning = function(w) { avert <<- c(avert, conditionMessage(w)); invokeRestart("muffleWarning") }))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  if (length(avert) == 1) avert <- c("Warning message:", avert)
  else if (length(avert) > 1) avert <- c("Warning messages:", paste0(seq_along(avert), ": ", avert))
  paste(c(out, msgs, avert), collapse = "\n")
}
console <- function(...) lapply(c(...), function(code) list(`in` = code, out = sortie(code)))
pngs <- character(0)
# Un graphique de R, tel quel, en PNG : le code est évalué avec l'appareil
# png() ouvert, l'image va dans static/img.
rendre_png <- function(code, fichier, l = 1800, h = 1000) {
  chemin <- file.path(IMG, fichier)
  png(chemin, width = l, height = h, res = 200)
  on.exit(dev.off(), add = TRUE)
  out <- sortie(code)
  dev.off(); on.exit()
  stopifnot(file.size(chemin) < 400 * 1024)
  dim <- dim(png::readPNG(chemin))
  pngs <<- c(pngs, fichier)
  list(code = code, out = out, img = fichier, l = dim[2], h = dim[1])
}

ATELIER <- list()
ATELIER$charger <- console(
  "library(dplyr)",
  "library(haven)",
  "df_raw <- readRDS(\"ces2025.rds\")",
  "df_clean <- data.frame(id = 1:nrow(df_raw))"
)
# Un énoncé, tel que la CES le code : 1 à 5, et 6 = ne sait pas.
ATELIER$item <- console(
  "table(as_factor(df_raw$pes25_populism_3))"
)
# De 1-5 à 0-1, et 6 devient NA. Une fonction, huit fois.
ATELIER$echelle <- console(
  "echelle <- function(x) ifelse(x %in% 1:5, (x - 1) / 4, NA)",
  "df_clean$pop1 <- echelle(df_raw$pes25_populism_1)",
  "df_clean$pop2 <- echelle(df_raw$pes25_populism_2)",
  "df_clean$pop3 <- echelle(df_raw$pes25_populism_3)",
  "df_clean$pop4 <- echelle(df_raw$pes25_populism_4)",
  "df_clean$pop5 <- echelle(df_raw$pes25_populism_5)",
  "df_clean$pop6 <- echelle(df_raw$pes25_populism_6)",
  "df_clean$pop7 <- echelle(df_raw$pes25_populism_7)",
  "df_clean$pop8 <- echelle(df_raw$pes25_populism_8)",
  "table(df_clean$pop3, useNA = \"ifany\")"
)
# L'énoncé 4 dit le contraire des autres : on le retourne.
ATELIER$inverser <- console(
  "cor(df_clean$pop3, df_clean$pop4, use = \"complete.obs\")",
  "df_clean$pop4 <- 1 - df_clean$pop4",
  "cor(df_clean$pop3, df_clean$pop4, use = \"complete.obs\")"
)
# Les corrélations entre les huit (après le retournement), pour la figure.
items <- paste0("pop", 1:8)
CORR <- round(cor(df_clean[, items], use = "pairwise.complete.obs"), 2)
CORR <- lapply(1:8, function(i) unname(CORR[i, ]))

ATELIER$installer <- list(list(`in` = "install.packages(\"remotes\")                 # une seule fois", out = ""),
                          list(`in` = "remotes::install_github(\"clessnverse/sondr\")   # une seule fois", out = ""))
ATELIER$preparer <- console(
  "library(sondr)",
  "df_fa <- na.omit(df_clean[, c(\"pop1\", \"pop2\", \"pop3\", \"pop4\", \"pop5\", \"pop6\", \"pop7\", \"pop8\")])",
  "nrow(df_fa)"
)
FA1 <- rendre_png("topdown_fa(df_fa)", "s9-fa1.png")
res1 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa)))
FA2 <- rendre_png("df_fa2 <- df_fa[, c(\"pop2\", \"pop3\", \"pop4\", \"pop5\", \"pop7\", \"pop8\")]\ntopdown_fa(df_fa2)", "s9-fa2.png")
res2 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa2)))
SATURATIONS <- list(
  n = nrow(df_fa),
  un = list(alpha = res1$cronbachAlpha, eigen = res1$factor1stEigen, items = 1:8, loadings = r(res1$factorLoadings)),
  deux = list(alpha = res2$cronbachAlpha, eigen = res2$factor1stEigen, items = c(2, 3, 4, 5, 7, 8), loadings = r(res2$factorLoadings))
)

# L'échelle : la moyenne des six, de 0 à 1.
ATELIER$construire <- console(
  "df_clean$populisme <- (df_clean$pop2 + df_clean$pop3 + df_clean$pop4 +\n                       df_clean$pop5 + df_clean$pop7 + df_clean$pop8) / 6",
  "summary(df_clean$populisme)"
)
HIST <- rendre_png("hist(df_clean$populisme, main = \"\", xlab = \"Populisme (0 à 1)\", ylab = \"Personnes\")", "s9-hist.png", 1600, 1000)
h <- hist(df_clean$populisme, plot = FALSE)
HISTO <- list(bornes = h$breaks, comptes = h$counts, moyenne = r(mean(df_clean$populisme, na.rm = TRUE), 3),
              n = sum(!is.na(df_clean$populisme)))

# L'application : la scolarité réduit-elle le populisme ? Universitaire (8 à
# 11) ou non (1 à 7); 12 = ne sait pas, NA.
ATELIER$regression <- console(
  "df_clean$universitaire <- case_when(\n  df_raw$cps25_education %in% 8:11 ~ 1,\n  df_raw$cps25_education %in% 1:7 ~ 0\n)",
  "modele <- lm(populisme ~ universitaire, data = df_clean)",
  "modele"
)
m <- lm(populisme ~ universitaire, data = df_clean)
s <- coef(summary(m))
REG <- list(constante = r(s[1, 1], 3), pente = r(s[2, 1], 3), se = r(s[2, 2], 3), p = signif(s[2, 4], 2),
            n = nobs(m), r2 = r(summary(m)$r.squared, 3),
            moy_non = r(mean(df_clean$populisme[df_clean$universitaire == 0], na.rm = TRUE), 3),
            moy_uni = r(mean(df_clean$populisme[df_clean$universitaire == 1], na.rm = TRUE), 3))
ATELIER$sauver <- console("saveRDS(df_clean, \"df_clean.rds\")")

setwd(ancien)

# ---- Le script entier, tel que la salle le tape (seance9.R).
ins <- function(cle) paste(sapply(ATELIER[[cle]], `[[`, "in"), collapse = "\n")
SCRIPT <- paste(c(
  "# Séance 9 · mesurer un concept : le populisme dans la CES 2025",
  "# 1. Charger", ins("charger"),
  "# 2. Regarder un énoncé", ins("item"),
  "# 3. De 1-5 à 0-1, ne sait pas devient NA", ins("echelle"),
  "# 4. Retourner l'énoncé 4", ins("inverser"),
  "# 5. sondr, une seule fois", ins("installer"),
  "# 6. L'analyse factorielle : tous les énoncés", ins("preparer"), FA1$code,
  "# 7. Sans les deux qui détonnent", FA2$code,
  "# 8. L'échelle", ins("construire"), HIST$code,
  "# 9. L'appliquer", ins("regression"),
  "# 10. Sauvegarder", ins("sauver")), collapse = "\n")

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance9_data.R. Source : Étude électorale canadienne 2025,",
  "   sondage postélectoral (pes25_populism_1 à _8), sans pondération. Ne pas modifier à la main. */",
  "",
  "/* Les huit énoncés, libellés anglais de la CES (80 caractères), et l'échelle de réponse. */",
  paste0("export const ITEMS = ", J(ITEMS), ";"),
  paste0("export const ECHELLE = ", J(ECHELLE), ";"),
  "/* Corrélations entre pop1 et pop8, après le retournement de pop4 (ligne i, colonne j). */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* sondr::topdown_fa : alpha de Cronbach, première valeur propre, saturations. */",
  paste0("export const SATURATIONS = ", J(SATURATIONS), ";"),
  "/* L'histogramme de l'échelle, tel que hist() le découpe. */",
  paste0("export const HISTO = ", J(HISTO), ";"),
  "/* lm(populisme ~ universitaire). */",
  paste0("export const REG = ", J(REG), ";"),
  "/* La console : [{ in, out }] par étape, sorties capturées de R. */",
  paste0("export const ATELIER = ", J(ATELIER), ";"),
  paste0("export const FA1 = ", J(FA1), ";"),
  paste0("export const FA2 = ", J(FA2), ";"),
  paste0("export const HIST = ", J(HIST), ";"),
  paste0("export const SCRIPT = ", J(SCRIPT), ";")
), file.path(ici, "..", "src", "lib", "data", "seance9.js"))

cat("n (fa) :", nrow(df_fa), "\n")
cat("run 1 : alpha", res1$cronbachAlpha, "eigen", res1$factor1stEigen, ":", r(res1$factorLoadings), "\n")
cat("run 2 : alpha", res2$cronbachAlpha, "eigen", res2$factor1stEigen, ":", r(res2$factorLoadings), "\n")
cat("régression :", REG$constante, REG$pente, "n", REG$n, "\n")
cat("png :", pngs, "\n")
