# Exporte tout ce que la séance 9 montre de l'Étude électorale canadienne 2025
# vers src/lib/data/seance9.js et static/img/s9-*.png : une échelle d'appui à
# l'environnement (sondage de campagne, cps25_spend_env, cps25_pos_carbon,
# cps25_pos_energy, cps25_pos_jobs; les trois « pos » sont posées au bloc c1, un
# tiers des répondant.e.s), les deux analyses factorielles de sondr::topdown_fa()
# (d'abord sans retourner les deux questions à l'envers, puis retournées),
# l'échelle et son histogramme, une régression de l'échelle sur
# la scolarité, et les placements gauche-droite (GAUCHE).
#
#   CES2025_DTA=~/ces2025_project/ces2025.dta Rscript outils/seance9_data.R
#
# sondr doit être la version locale (~/Projects/sondr, R CMD INSTALL) tant que
# le nouveau graphique de topdown_fa() n'est pas sur GitHub.
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

# ---- Les cinq questions, telles que la CES les libelle (étiquettes Stata).
# Les libellés français du questionnaire sont dans la diapo (M9Items).
V <- c(depenses = "cps25_spend_env", carbone = "cps25_pos_carbon", pipelines = "cps25_pos_energy",
       emplois = "cps25_pos_jobs")
ITEMS <- lapply(names(V), function(k) list(cle = k, var = unname(V[k]), label = gsub("\\s+", " ", trimws(attr(d[[V[k]]], "label")))))

# ---- La salle travaille dans un dossier qui contient ces2025.rds (séance 2).
tmp <- tempfile("s9-"); dir.create(tmp)
saveRDS(d, file.path(tmp, "ces2025.rds"))
ancien <- setwd(tmp)
rm(list = intersect(ls(), c("df_raw", "df_clean", "df_fa", "modele", "accord")))

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
# Une question, telle que la CES la code : 1 = fortement en désaccord … 5 =
# fortement d'accord, 6 = ne sait pas, NA = pas au bloc c1.
ATELIER$item <- console(
  "table(as_factor(df_raw$cps25_pos_carbon), useNA = \"ifany\")"
)
# De 0 à 1, la même recette pour les quatre. Ne sait pas devient NA. On
# oublie, comme tout le monde, que deux questions vont à l'envers.
ATELIER$echelle <- console(
  "df_clean$env_depenses <- case_when(\n  df_raw$cps25_spend_env == 1 ~ 0,\n  df_raw$cps25_spend_env == 2 ~ 0.5,\n  df_raw$cps25_spend_env == 3 ~ 1\n)",
  "accord <- function(x) ifelse(x %in% 1:5, (x - 1) / 4, NA)",
  "df_clean$env_carbone <- accord(df_raw$cps25_pos_carbon)",
  "df_clean$env_pipelines <- accord(df_raw$cps25_pos_energy)",
  "df_clean$env_emplois <- accord(df_raw$cps25_pos_jobs)"
)
ATELIER$installer <- list(list(`in` = "install.packages(\"remotes\")                 # une seule fois", out = ""),
                          list(`in` = "remotes::install_github(\"clessnverse/sondr\")   # une seule fois", out = ""))
ATELIER$preparer <- console(
  "library(sondr)",
  "df_fa <- na.omit(select(df_clean, starts_with(\"env_\")))",
  "nrow(df_fa)"
)
FA1 <- rendre_png("topdown_fa(df_fa)", "s9-fa1.png")
res1 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa)))
# Le sens : d'accord avec plus d'oléoducs, c'est contre l'environnement.
ATELIER$sens <- console(
  "cor(df_clean$env_carbone, df_clean$env_pipelines, use = \"complete.obs\")",
  "df_clean$env_pipelines <- 1 - df_clean$env_pipelines",
  "df_clean$env_emplois <- 1 - df_clean$env_emplois",
  "cor(df_clean$env_carbone, df_clean$env_pipelines, use = \"complete.obs\")"
)
items <- paste0("env_", names(V))
CORR <- round(cor(df_clean[, items], use = "pairwise.complete.obs"), 2)
CORR <- lapply(seq_along(items), function(i) unname(CORR[i, ]))
FA2 <- rendre_png("df_fa <- na.omit(select(df_clean, starts_with(\"env_\")))\ntopdown_fa(df_fa)", "s9-fa2.png")
res2 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa)))
SATURATIONS <- list(
  n = nrow(df_fa),
  un = list(alpha = res1$cronbachAlpha, eigen = res1$factor1stEigen, items = names(V), loadings = r(res1$factorLoadings)),
  deux = list(alpha = res2$cronbachAlpha, eigen = res2$factor1stEigen, items = names(V), loadings = r(res2$factorLoadings))
)

# L'échelle : la moyenne des quatre, de 0 à 1.
ATELIER$construire <- console(
  "df_clean$environnement <- rowMeans(select(df_clean, starts_with(\"env_\")))",
  "summary(df_clean$environnement)"
)
HIST <- rendre_png("hist(df_clean$environnement, main = \"\", xlab = \"Appui à l'environnement (0 à 1)\", ylab = \"Personnes\")", "s9-hist.png", 1600, 1000)
h <- hist(df_clean$environnement, plot = FALSE)
HISTO <- list(bornes = h$breaks, comptes = h$counts, moyenne = r(mean(df_clean$environnement, na.rm = TRUE), 3),
              n = sum(!is.na(df_clean$environnement)))

# L'application : la scolarité augmente-t-elle l'appui à l'environnement ?
# Universitaire (8 à 11) ou non (1 à 7); 12 = ne sait pas, NA.
ATELIER$regression <- console(
  "df_clean$universitaire <- case_when(\n  df_raw$cps25_education %in% 8:11 ~ 1,\n  df_raw$cps25_education %in% 1:7 ~ 0\n)",
  "modele <- lm(environnement ~ universitaire, data = df_clean)",
  "modele"
)
m <- lm(environnement ~ universitaire, data = df_clean)
s <- coef(summary(m))
REG <- list(constante = r(s[1, 1], 3), pente = r(s[2, 1], 3), se = r(s[2, 2], 3), p = signif(s[2, 4], 2),
            n = nobs(m), r2 = r(summary(m)$r.squared, 3),
            moy_non = r(mean(df_clean$environnement[df_clean$universitaire == 0], na.rm = TRUE), 3),
            moy_uni = r(mean(df_clean$environnement[df_clean$universitaire == 1], na.rm = TRUE), 3))
# La validité, côté « autres mesures » : l'échelle est-elle plus haute chez
# qui compte voter pour un parti qui défend l'environnement ? Intention de
# vote (cps25_votechoice), sans pondération, partis avec n >= 50 dans l'échelle.
P <- c("1" = "PLC", "2" = "PCC", "3" = "NPD", "4" = "Bloc", "5" = "Verts", "8" = "PPC")
vv <- data.frame(p = as.character(zap_labels(df_raw$cps25_votechoice)), e = df_clean$environnement)
vv <- vv[!is.na(vv$e) & vv$p %in% names(P), ]
VALIDITE <- lapply(names(P), function(k) list(parti = unname(P[k]), n = sum(vv$p == k), moyenne = r(mean(vv$e[vv$p == k]), 2)))
VALIDITE <- VALIDITE[order(-sapply(VALIDITE, `[[`, "moyenne"))]
VALIDITE <- Filter(function(x) x$n >= 50, VALIDITE)
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
  "# Séance 9 · mesurer un concept : l'appui à l'environnement, CES 2025",
  "# 1. Charger", ins("charger"),
  "# 2. Regarder une question", ins("item"),
  "# 3. De 0 à 1, ne sait pas devient NA", ins("echelle"),
  "# 4. sondr, une seule fois", ins("installer"),
  "# 5. L'analyse factorielle", ins("preparer"), FA1$code,
  "# 6. Le sens : retourner les questions à l'envers", ins("sens"),
  "# 7. L'analyse factorielle, encore", FA2$code,
  "# 8. L'échelle", ins("construire"), HIST$code,
  "# 9. L'appliquer", ins("regression"),
  "# 10. Sauvegarder", ins("sauver")), collapse = "\n")

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance9_data.R. Source : Étude électorale canadienne 2025, sondage de campagne",
  "   (cps25_spend_env, cps25_pos_carbon, _energy, _jobs), sans pondération. GAUCHE : pondéré",
  "   (cps25_weight_general_all). Ne pas modifier à la main. */",
  "",
  "/* Les quatre questions (clé, variable, libellé anglais de la CES). */",
  paste0("export const ITEMS = ", J(ITEMS), ";"),
  "/* Corrélations entre les quatre, une fois retournées (ligne i, colonne j), dans l'ordre de ITEMS. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* sondr::topdown_fa : alpha de Cronbach, première valeur propre, saturations (items = clés). */",
  paste0("export const SATURATIONS = ", J(SATURATIONS), ";"),
  "/* L'histogramme de l'échelle, tel que hist() le découpe. */",
  paste0("export const HISTO = ", J(HISTO), ";"),
  "/* Moyenne de l'échelle selon l'intention de vote (partis avec n >= 50). */",
  paste0("export const VALIDITE = ", J(VALIDITE), ";"),
  "/* lm(environnement ~ universitaire). */",
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
cat("validité :", sapply(VALIDITE, function(x) paste(x$parti, x$moyenne, x$n)), "\n")
cat("régression :", REG$constante, REG$pente, "n", REG$n, "\n")
cat("png :", pngs, "\n")
