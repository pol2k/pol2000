# Exporte tout ce que la séance 9 montre de l'Étude électorale canadienne 2025
# vers src/lib/data/seance9.js et static/img/s9-*.png : la confiance envers
# dix institutions (sondage postélectoral, pes25_conf_inst1_1 à _4 et
# pes25_conf_inst2_1 à _6, posées à la moitié des répondant.e.s), les deux
# analyses factorielles de sondr::topdown_fa() (les dix, puis sans celle qui
# détonne), l'échelle et son histogramme, et une régression de l'échelle sur
# la scolarité.
#
#   CES2025_DTA=~/ces2025_project/ces2025.dta Rscript outils/seance9_data.R
#
# Sans CES2025_DTA : CES2025_RDS (une copie saveRDS), sinon ces::get_ces("2025").
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

# ---- Les dix institutions, telles que la CES les libelle (étiquettes Stata).
# Les libellés français du questionnaire sont dans la diapo (M9Items).
V <- c(fed = "pes25_conf_inst1_1", prov = "pes25_conf_inst1_2", medias = "pes25_conf_inst1_3",
       elections = "pes25_conf_inst1_4", tribunaux = "pes25_conf_inst2_1", religion = "pes25_conf_inst2_2",
       armee = "pes25_conf_inst2_3", ecoles = "pes25_conf_inst2_4", fonction = "pes25_conf_inst2_5",
       police = "pes25_conf_inst2_6")
ITEMS <- lapply(names(V), function(k) list(cle = k, var = unname(V[k]), label = trimws(attr(d[[V[k]]], "label"))))
ECHELLE <- lapply(names(attr(d$pes25_conf_inst1_1, "labels")), function(x) x)

# ---- La salle travaille dans un dossier qui contient ces2025.rds (séance 2).
tmp <- tempfile("s9-"); dir.create(tmp)
saveRDS(d, file.path(tmp, "ces2025.rds"))
ancien <- setwd(tmp)
rm(list = intersect(ls(), c("df_raw", "df_clean", "df_fa", "df_fa2", "modele", "confiance")))

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
# Une institution, telle que la CES la code : 1 = beaucoup … 4 = pas du tout, 5 = ne sait pas.
ATELIER$item <- console(
  "table(as_factor(df_raw$pes25_conf_inst1_1))"
)
# De 1-4 à 1-0 (beaucoup = 1), et 5 devient NA. Une fonction, dix fois.
ATELIER$echelle <- console(
  "confiance <- function(x) ifelse(x %in% 1:4, (4 - x) / 3, NA)",
  "df_clean$conf_fed <- confiance(df_raw$pes25_conf_inst1_1)",
  "df_clean$conf_prov <- confiance(df_raw$pes25_conf_inst1_2)",
  "df_clean$conf_medias <- confiance(df_raw$pes25_conf_inst1_3)",
  "df_clean$conf_elections <- confiance(df_raw$pes25_conf_inst1_4)",
  "df_clean$conf_tribunaux <- confiance(df_raw$pes25_conf_inst2_1)",
  "df_clean$conf_religion <- confiance(df_raw$pes25_conf_inst2_2)",
  "df_clean$conf_armee <- confiance(df_raw$pes25_conf_inst2_3)",
  "df_clean$conf_ecoles <- confiance(df_raw$pes25_conf_inst2_4)",
  "df_clean$conf_fonction <- confiance(df_raw$pes25_conf_inst2_5)",
  "df_clean$conf_police <- confiance(df_raw$pes25_conf_inst2_6)",
  "table(df_clean$conf_fed, useNA = \"ifany\")"
)
# Le sens : deux institutions, la même direction.
ATELIER$sens <- console(
  "cor(df_clean$conf_fed, df_clean$conf_tribunaux, use = \"complete.obs\")"
)
items <- paste0("conf_", names(V))
CORR <- round(cor(df_clean[, items], use = "pairwise.complete.obs"), 2)
CORR <- lapply(seq_along(items), function(i) unname(CORR[i, ]))

ATELIER$installer <- list(list(`in` = "install.packages(\"remotes\")                 # une seule fois", out = ""),
                          list(`in` = "remotes::install_github(\"clessnverse/sondr\")   # une seule fois", out = ""))
ATELIER$preparer <- console(
  "library(sondr)",
  "df_fa <- na.omit(select(df_clean, starts_with(\"conf_\")))",
  "nrow(df_fa)"
)
FA1 <- rendre_png("topdown_fa(df_fa)", "s9-fa1.png")
res1 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa)))
FA2 <- rendre_png("df_fa2 <- select(df_fa, -conf_religion)\ntopdown_fa(df_fa2)", "s9-fa2.png")
res2 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa2)))
SATURATIONS <- list(
  n = nrow(df_fa),
  un = list(alpha = res1$cronbachAlpha, eigen = res1$factor1stEigen, items = names(V), loadings = r(res1$factorLoadings)),
  deux = list(alpha = res2$cronbachAlpha, eigen = res2$factor1stEigen, items = setdiff(names(V), "religion"), loadings = r(res2$factorLoadings))
)

# L'échelle : la moyenne des neuf, de 0 à 1.
ATELIER$construire <- console(
  "df_clean$confiance <- rowMeans(select(df_clean, starts_with(\"conf_\"), -conf_religion))",
  "summary(df_clean$confiance)"
)
HIST <- rendre_png("hist(df_clean$confiance, main = \"\", xlab = \"Confiance envers les institutions (0 à 1)\", ylab = \"Personnes\")", "s9-hist.png", 1600, 1000)
h <- hist(df_clean$confiance, plot = FALSE)
HISTO <- list(bornes = h$breaks, comptes = h$counts, moyenne = r(mean(df_clean$confiance, na.rm = TRUE), 3),
              n = sum(!is.na(df_clean$confiance)))

# L'application : la scolarité augmente-t-elle la confiance ? Universitaire
# (8 à 11) ou non (1 à 7); 12 = ne sait pas, NA.
ATELIER$regression <- console(
  "df_clean$universitaire <- case_when(\n  df_raw$cps25_education %in% 8:11 ~ 1,\n  df_raw$cps25_education %in% 1:7 ~ 0\n)",
  "modele <- lm(confiance ~ universitaire, data = df_clean)",
  "modele"
)
m <- lm(confiance ~ universitaire, data = df_clean)
s <- coef(summary(m))
REG <- list(constante = r(s[1, 1], 3), pente = r(s[2, 1], 3), se = r(s[2, 2], 3), p = signif(s[2, 4], 2),
            n = nobs(m), r2 = r(summary(m)$r.squared, 3),
            moy_non = r(mean(df_clean$confiance[df_clean$universitaire == 0], na.rm = TRUE), 3),
            moy_uni = r(mean(df_clean$confiance[df_clean$universitaire == 1], na.rm = TRUE), 3))
ATELIER$sauver <- console("saveRDS(df_clean, \"df_clean.rds\")")

setwd(ancien)

# ---- Gauche-droite : le même parti, placé par deux camps (sondage de campagne).
# Se placer soi-même de 0 (gauche) à 10 (droite), puis placer les partis.
# -99 = pas certain.e ou sans réponse : NA. Pondéré (cps25_weight_general_all),
# sans les poids manquants. Camps : 0 à 2 et 8 à 10.
g <- d %>% select(soi = cps25_lr_scale_bef_1, lib = cps25_lr_parties_1, con = cps25_lr_parties_2,
                  w = cps25_weight_general_all) %>% zap_labels() %>%
  mutate(across(c(soi, lib, con), ~ ifelse(.x %in% 0:10, .x, NA))) %>% filter(!is.na(w), !is.na(soi))
wm <- function(x, w) { k <- !is.na(x); sum(x[k] * w[k]) / sum(w[k]) }
camp <- function(k) { x <- g[k, ]; list(n = nrow(x), lib = r(wm(x$lib, x$w), 1), con = r(wm(x$con, x$w), 1),
                                        n_lib = sum(!is.na(x$lib)), n_con = sum(!is.na(x$con))) }
GAUCHE <- list(gauche = camp(g$soi <= 2), droite = camp(g$soi >= 8))

# ---- Le script entier, tel que la salle le tape (seance9.R).
ins <- function(cle) paste(sapply(ATELIER[[cle]], `[[`, "in"), collapse = "\n")
SCRIPT <- paste(c(
  "# Séance 9 · mesurer un concept : la confiance envers les institutions, CES 2025",
  "# 1. Charger", ins("charger"),
  "# 2. Regarder une institution", ins("item"),
  "# 3. De 1-4 à 0-1 (1 = beaucoup), ne sait pas devient NA", ins("echelle"),
  "# 4. Le sens : deux institutions, la même direction", ins("sens"),
  "# 5. sondr, une seule fois", ins("installer"),
  "# 6. L'analyse factorielle : les dix institutions", ins("preparer"), FA1$code,
  "# 7. Sans celle qui détonne", FA2$code,
  "# 8. L'échelle", ins("construire"), HIST$code,
  "# 9. L'appliquer", ins("regression"),
  "# 10. Sauvegarder", ins("sauver")), collapse = "\n")

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance9_data.R. Source : Étude électorale canadienne 2025,",
  "   sondage postélectoral (pes25_conf_inst1_1 à _4, pes25_conf_inst2_1 à _6), sans pondération. GAUCHE : sondage de campagne,",
  "   pondéré (cps25_weight_general_all). Ne pas modifier à la main. */",
  "",
  "/* Les dix institutions (clé, variable, libellé anglais de la CES) et l'échelle de réponse. */",
  paste0("export const ITEMS = ", J(ITEMS), ";"),
  paste0("export const ECHELLE = ", J(ECHELLE), ";"),
  "/* Corrélations entre les dix (ligne i, colonne j), dans l'ordre de ITEMS. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* sondr::topdown_fa : alpha de Cronbach, première valeur propre, saturations (items = clés). */",
  paste0("export const SATURATIONS = ", J(SATURATIONS), ";"),
  "/* L'histogramme de l'échelle, tel que hist() le découpe. */",
  paste0("export const HISTO = ", J(HISTO), ";"),
  "/* lm(confiance ~ universitaire). */",
  paste0("export const REG = ", J(REG), ";"),
  "/* Gauche-droite (cps25_lr_scale_bef_1, cps25_lr_parties_1 et _2), pondéré : où chaque camp place le PLC et le PCC. */",
  paste0("export const GAUCHE = ", J(GAUCHE), ";"),
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
cat("gauche-droite :", unlist(GAUCHE), "\n")
cat("régression :", REG$constante, REG$pente, "n", REG$n, "\n")
cat("png :", pngs, "\n")
