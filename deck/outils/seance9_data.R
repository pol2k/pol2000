# Exporte tout ce que la séance 9 montre de l'Étude électorale canadienne 2025
# vers src/lib/data/seance9.js et static/img/s9-*.png : une échelle
# gauche-droite construite à partir de quatorze questions qu'on croit de
# gauche ou de droite (sondage postélectoral, plus cps25_spend_defence), les
# deux analyses factorielles de sondr::topdown_fa() (les quatorze, puis sans
# les trois qui ne collent pas), l'échelle et son histogramme, sa validité
# (partis, auto-positionnement), une régression sur la scolarité, et les
# placements gauche-droite (GAUCHE).
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

# ---- Les quatorze questions (clé : variable de la CES). 0 = gauche, 1 = droite.
V <- c(niveau_vie = "pes25_stdofliving", inegalites = "pes25_govt_act_ineq", prive = "pes25_privjobs",
       merite = "pes25_blame", prog_sociaux = "pes25_deserve2", egalite = "pes25_equalrights",
       femmes = "pes25_womenhome", integration = "pes25_fitin", immig_emplois = "pes25_immigjobs",
       modes_vie = "pes25_newerlife", autochtones = "pes25_indig_deserve", commerce = "pes25_trade",
       defense = "cps25_spend_defence", francais_qc = "pes25_langQC")
RATES <- c("commerce", "defense", "francais_qc")
ITEMS <- lapply(names(V), function(k) list(cle = k, var = unname(V[k]), label = gsub("\\s+", " ", trimws(attr(d[[V[k]]], "label")))))

# ---- La salle travaille dans un dossier qui contient ces2025.rds (séance 2).
tmp <- tempfile("s9-"); dir.create(tmp)
saveRDS(d, file.path(tmp, "ces2025.rds"))
ancien <- setwd(tmp)
rm(list = intersect(ls(), c("df_raw", "df_clean", "df_fa", "df_fa2", "modele", "accord", "soi")))

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
# fortement d'accord, 6 = ne sait pas, NA = pas au sondage postélectoral.
ATELIER$item <- console(
  "table(as_factor(df_raw$pes25_equalrights), useNA = \"ifany\")"
)
# De 0 (gauche) à 1 (droite). D'accord = droite : accord(x). D'accord =
# gauche : 1 - accord(x). Ne sait pas devient NA.
ATELIER$economie <- console(
  "accord <- function(x) ifelse(x %in% 1:5, (x - 1) / 4, NA)",
  "df_clean$ideo_niveau_vie <- case_when(\n  df_raw$pes25_stdofliving == 1 ~ 0,\n  df_raw$pes25_stdofliving == 2 ~ 1\n)",
  "df_clean$ideo_inegalites <- 1 - accord(df_raw$pes25_govt_act_ineq)",
  "df_clean$ideo_prive <- accord(df_raw$pes25_privjobs)",
  "df_clean$ideo_merite <- accord(df_raw$pes25_blame)",
  "df_clean$ideo_prog_sociaux <- accord(df_raw$pes25_deserve2)"
)
ATELIER$societe <- console(
  "df_clean$ideo_egalite <- accord(df_raw$pes25_equalrights)",
  "df_clean$ideo_femmes <- accord(df_raw$pes25_womenhome)",
  "df_clean$ideo_integration <- accord(df_raw$pes25_fitin)",
  "df_clean$ideo_immig_emplois <- accord(df_raw$pes25_immigjobs)",
  "df_clean$ideo_modes_vie <- accord(df_raw$pes25_newerlife)",
  "df_clean$ideo_autochtones <- 1 - accord(df_raw$pes25_indig_deserve)"
)
ATELIER$paris <- console(
  "df_clean$ideo_commerce <- accord(df_raw$pes25_trade)",
  "df_clean$ideo_defense <- case_when(\n  df_raw$cps25_spend_defence == 1 ~ 0,\n  df_raw$cps25_spend_defence == 2 ~ 0.5,\n  df_raw$cps25_spend_defence == 3 ~ 1\n)",
  "df_clean$ideo_francais_qc <- case_when(\n  df_raw$pes25_langQC == 2 ~ 1,\n  df_raw$pes25_langQC == 1 ~ 0\n)"
)
items <- paste0("ideo_", names(V))
CORR <- round(cor(df_clean[, items], use = "pairwise.complete.obs"), 2)
CORR <- lapply(seq_along(items), function(i) unname(CORR[i, ]))

ATELIER$installer <- list(list(`in` = "install.packages(\"remotes\")                 # une seule fois", out = ""),
                          list(`in` = "remotes::install_github(\"clessnverse/sondr\")   # une seule fois", out = ""))
ATELIER$preparer <- console(
  "library(sondr)",
  "df_fa <- na.omit(select(df_clean, starts_with(\"ideo_\")))",
  "nrow(df_fa)"
)
FA1 <- rendre_png("topdown_fa(df_fa)", "s9-fa1.png", 1800, 1100)
res1 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa)))
FA2 <- rendre_png("df_fa2 <- select(df_fa, -ideo_commerce, -ideo_defense, -ideo_francais_qc)\ntopdown_fa(df_fa2)", "s9-fa2.png", 1800, 1000)
res2 <- suppressWarnings(suppressMessages(sondr::topdown_fa(df_fa2)))
SATURATIONS <- list(
  n = nrow(df_fa), eigen2 = r(eigen(cor(df_fa2))$values[2]),
  un = list(alpha = res1$cronbachAlpha, eigen = res1$factor1stEigen, items = names(V), loadings = r(res1$factorLoadings)),
  deux = list(alpha = res2$cronbachAlpha, eigen = res2$factor1stEigen, items = setdiff(names(V), RATES), loadings = r(res2$factorLoadings))
)

# L'échelle : on retire les trois, puis la moyenne des onze, de 0 à 1.
ATELIER$construire <- console(
  "df_clean <- select(df_clean, -ideo_commerce, -ideo_defense, -ideo_francais_qc)",
  "df_clean$ideologie <- rowMeans(select(df_clean, starts_with(\"ideo_\")))",
  "summary(df_clean$ideologie)"
)
HIST <- rendre_png("hist(df_clean$ideologie, main = \"\", xlab = \"Idéologie (0 = gauche, 1 = droite)\", ylab = \"Personnes\")", "s9-hist.png", 1600, 1000)
h <- hist(df_clean$ideologie, plot = FALSE)
HISTO <- list(bornes = h$breaks, comptes = h$counts, moyenne = r(mean(df_clean$ideologie, na.rm = TRUE), 3),
              n = sum(!is.na(df_clean$ideologie)))

# La validité : l'échelle va-t-elle dans le même sens que l'auto-positionnement ?
ATELIER$valider <- console(
  "soi <- ifelse(df_raw$cps25_lr_scale_bef_1 %in% 0:10, df_raw$cps25_lr_scale_bef_1, NA)",
  "cor(df_clean$ideologie, soi, use = \"complete.obs\")"
)
VALID_SOI <- r(cor(df_clean$ideologie, ifelse(df_raw$cps25_lr_scale_bef_1 %in% 0:10, df_raw$cps25_lr_scale_bef_1, NA), use = "complete.obs"))

# L'application : la scolarité rend-elle plus à gauche ? Universitaire (8 à
# 11) ou non (1 à 7); 12 = ne sait pas, NA.
ATELIER$regression <- console(
  "df_clean$universitaire <- case_when(\n  df_raw$cps25_education %in% 8:11 ~ 1,\n  df_raw$cps25_education %in% 1:7 ~ 0\n)",
  "modele <- lm(ideologie ~ universitaire, data = df_clean)",
  "modele"
)
m <- lm(ideologie ~ universitaire, data = df_clean)
s <- coef(summary(m))
REG <- list(constante = r(s[1, 1], 3), pente = r(s[2, 1], 3), se = r(s[2, 2], 3), p = signif(s[2, 4], 2),
            n = nobs(m), r2 = r(summary(m)$r.squared, 3),
            moy_non = r(mean(df_clean$ideologie[df_clean$universitaire == 0], na.rm = TRUE), 3),
            moy_uni = r(mean(df_clean$ideologie[df_clean$universitaire == 1], na.rm = TRUE), 3))
# Les partis, de gauche à droite selon l'échelle. Intention de vote
# (cps25_votechoice), sans pondération, partis avec n >= 50 dans l'échelle.
P <- c("1" = "PLC", "2" = "PCC", "3" = "NPD", "4" = "Bloc", "5" = "Verts", "8" = "PPC")
vv <- data.frame(p = as.character(zap_labels(df_raw$cps25_votechoice)), e = df_clean$ideologie)
vv <- vv[!is.na(vv$e) & vv$p %in% names(P), ]
VALIDITE <- lapply(names(P), function(k) list(parti = unname(P[k]), n = sum(vv$p == k), moyenne = r(mean(vv$e[vv$p == k]), 2)))
VALIDITE <- VALIDITE[order(sapply(VALIDITE, `[[`, "moyenne"))]
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
  "# Séance 9 · mesurer un concept : l'idéologie gauche-droite, CES 2025",
  "# 1. Charger", ins("charger"),
  "# 2. Regarder une question", ins("item"),
  "# 3. De 0 (gauche) à 1 (droite) : l'économie, la société, nos paris", ins("economie"), ins("societe"), ins("paris"),
  "# 4. sondr, une seule fois", ins("installer"),
  "# 5. L'analyse factorielle : les quatorze", ins("preparer"), FA1$code,
  "# 6. Sans celles qui ne collent pas", FA2$code,
  "# 7. L'échelle", ins("construire"), HIST$code,
  "# 8. La validité", ins("valider"),
  "# 9. L'appliquer", ins("regression"),
  "# 10. Sauvegarder", ins("sauver")), collapse = "\n")

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance9_data.R. Source : Étude électorale canadienne 2025, sondage de campagne",
  "   et sondage postélectoral (quatorze questions, voir ITEMS), sans pondération. GAUCHE : pondéré",
  "   (cps25_weight_general_all). Ne pas modifier à la main. */",
  "",
  "/* Les quatorze questions (clé, variable, libellé anglais de la CES). */",
  paste0("export const ITEMS = ", J(ITEMS), ";"),
  "/* Corrélations entre les quatorze (ligne i, colonne j), dans l'ordre de ITEMS. */",
  paste0("export const CORR = ", J(CORR), ";"),
  "/* sondr::topdown_fa : alpha de Cronbach, première valeur propre, saturations (items = clés). */",
  paste0("export const SATURATIONS = ", J(SATURATIONS), ";"),
  "/* L'histogramme de l'échelle, tel que hist() le découpe. */",
  paste0("export const HISTO = ", J(HISTO), ";"),
  "/* Moyenne de l'échelle selon l'intention de vote, de gauche à droite (partis avec n >= 50); corrélation avec l'auto-positionnement. */",
  paste0("export const VALID_SOI = ", J(VALID_SOI), ";"),
  paste0("export const VALIDITE = ", J(VALIDITE), ";"),
  "/* lm(ideologie ~ universitaire). */",
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
