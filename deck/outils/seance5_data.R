# Exporte tout ce que la séance 5 dessine ou affiche vers
# src/lib/data/seance5.js, et rend les graphiques ggplot2 de la séance dans
# static/img/s5-*.png. Aucune valeur n'est tapée à la main, sauf les trois
# exceptions dites plus bas. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_data.R
#
# Sans CES2025_RDS, les données sont téléchargées par ces::get_ces("2025").
#
# Le dispositif de la séance : les 20 180 répondant.e.s de l'Étude électorale
# canadienne 2025 servent de « population » d'exercice. On connaît donc la
# vraie réponse (l'âge moyen des 20 180), et on tire des échantillons dedans
# pour voir comment les estimés se comportent. Les diapos le disent. Aucune
# pondération : tout est calculé sans les poids du sondage.
#
# Le hasard est fixé (set.seed) bloc par bloc : la même commande redonne les
# mêmes chiffres. En classe, sans set.seed, chacun obtient les siens.
#
# Trois exceptions, faute de jeu de données :
#   - la pomicultrice (exemple fictif) : n = 50, moyenne 105 g, variance 300,
#     Arel-Bundock (2021, p. 62-63). Tout le reste (erreur type, t, p,
#     intervalle) est calculé ici;
#   - le sondage du Literary Digest, 1936 : plus de 10 millions de bulletins
#     postés, plus de 2,3 millions retournés (moins de 25 %), Landon 55 %,
#     Roosevelt 41 %, Lemke 4 % ; résultat : Roosevelt 61 %, Landon 37 %.
#     Squire (1988, p. 126-127), vérifié dans l'article le 28 septembre 2026;
#   - les deux études de la diapo « significatif n'est pas important » :
#     Bertrand et Mullainathan (2004), 50 % plus de rappels, p < 0,001 ; Sevi,
#     Arel-Bundock et Blais (2019), 0,5 point de pourcentage, p < 0,001, tels
#     que rapportés par Arel-Bundock (2021, p. 76).
suppressPackageStartupMessages({ library(ces); library(dplyr); library(haven); library(ggplot2) })
options(width = 100, pillar.advice = FALSE)

cache <- Sys.getenv("CES2025_RDS")
df_raw <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

# ---- df_clean, exactement comme à la fin de la séance 4 (seance4.R, sections 2 à 7).
df_clean <- data.frame(id = 1:nrow(df_raw))
df_clean$satisfaction <- case_when(
  df_raw$cps25_demsat == 1 ~ 1,
  df_raw$cps25_demsat == 2 ~ 0.67,
  df_raw$cps25_demsat == 3 ~ 0.33,
  df_raw$cps25_demsat == 4 ~ 0
)
df_clean$ses_education <- case_when(
  df_raw$cps25_education <= 5  ~ "secondaire_ou_moins",
  df_raw$cps25_education <= 7  ~ "collegial",
  df_raw$cps25_education <= 11 ~ "universitaire"
)
df_clean$ne_canada <- case_when(
  df_raw$cps25_bornin_canada == 1 ~ 1,
  df_raw$cps25_bornin_canada == 2 ~ 0
)
df_clean$gauche_droite <- na_if(df_raw$cps25_lr_scale_bef_1, -99)
df_clean$age <- as.numeric(df_raw$cps25_age_in_years)
df_clean$vote <- as_factor(df_raw$cps25_votechoice)
assign("df_clean", df_clean, envir = globalenv())

age <- df_clean$age
POP <- list(n = length(age), moyenne = mean(age), ecartType = sd(age))
r <- function(x, k = 2) round(x, k)

# ---- 1. Le hasard : pile ou face, puis la moyenne qui se stabilise.
set.seed(1)
pieces <- rbinom(1000, 1, 0.5)
pile_face <- list(piles = pieces, proportion = r(cumsum(pieces) / seq_along(pieces), 3))
set.seed(2)
ordre <- sample(age)
moyenne_courante <- list(moyenne = r(cumsum(ordre[1:2000]) / seq_len(2000), 2))

# ---- 2. Trois échantillons de 50 : trois moyennes.
set.seed(3)
trois <- lapply(1:3, function(k) { a <- sample(age, 50); list(ages = a, moyenne = r(mean(a), 2)) })

# ---- 3. Mille échantillons, pour quatre tailles.
bornes <- seq(30, 70, by = 1)
compter <- function(x) as.integer(table(cut(x, bornes, right = FALSE)))
tailles <- c(10, 50, 200, 1000)
set.seed(4)
mille <- lapply(tailles, function(n) replicate(1000, mean(sample(age, n))))
DISTRIBUTIONS <- lapply(seq_along(tailles), function(k) list(
  n = tailles[k], effectifs = compter(mille[[k]]),
  moyenne = r(mean(mille[[k]]), 2),
  ecartTypeDesMoyennes = r(sd(mille[[k]]), 2),
  erreurType = r(POP$ecartType / sqrt(tailles[k]), 2),
  min = r(min(mille[[k]]), 2), max = r(max(mille[[k]]), 2)))
moyennes50 <- r(mille[[2]], 2)  # dans l'ordre du tirage, pour les voir s'empiler

# ---- 4. Dans l'échantillon, entre les échantillons : quatre échantillons de 5.
set.seed(5)
quatre <- lapply(1:4, function(k) sample(age, 5))
dans_entre <- list(
  echantillons = lapply(quatre, function(a) list(ages = a, moyenne = r(mean(a), 1), ecartType = r(sd(a), 1))),
  ecartTypeEntre = r(sd(sapply(quatre, mean)), 1))

# ---- 5. Un échantillon biaisé : on ne sonde que les gens très intéressés par
#      la politique (8, 9 ou 10 sur 10 à cps25_interest_gen_1).
interet <- as.numeric(df_raw$cps25_interest_gen_1)
interesses <- age[!is.na(interet) & interet >= 8]
set.seed(6)
moy_biais <- replicate(1000, mean(sample(interesses, 50)))
BIAIS <- list(nSousGroupe = length(interesses), moyenneSousGroupe = r(mean(interesses), 2),
              effectifs = compter(moy_biais), moyenne = r(mean(moy_biais), 2),
              ecartTypeDesMoyennes = r(sd(moy_biais), 2))

# ---- 6. Cent intervalles de confiance : le lancer d'anneaux.
set.seed(7)
anneaux <- lapply(1:100, function(k) {
  a <- sample(age, 50)
  ic <- t.test(a)$conf.int
  list(moyenne = r(mean(a), 2), bas = r(ic[1], 2), haut = r(ic[2], 2),
       couvre = ic[1] <= POP$moyenne && POP$moyenne <= ic[2])
})
ANNEAUX <- list(intervalles = anneaux, n = 50, couvrent = sum(sapply(anneaux, `[[`, "couvre")))

# ---- 7. La pomicultrice (Arel-Bundock 2021, p. 62-74), refaite par R.
pom_n <- 50; pom_moy <- 105; pom_var <- 300; pom_h0 <- 100
pom_et <- sqrt(pom_var / pom_n)
pom_t <- (pom_moy - pom_h0) / pom_et
POMMES <- list(
  n = pom_n, moyenne = pom_moy, variance = pom_var, ecartType = r(sqrt(pom_var), 1), h0 = pom_h0,
  ecart = pom_moy - pom_h0, erreurType = r(pom_et, 2), t = r(pom_t, 2),
  p = r(2 * pt(-abs(pom_t), df = pom_n - 1), 3),
  seuilCritique = r(qt(0.975, df = pom_n - 1), 3),
  # L'intervalle du livre : l'estimé, plus ou moins deux erreurs types (équation 4.6).
  ic = r(pom_moy + c(-2, 2) * pom_et, 1))
# La loi de Student à 49 degrés de liberté, de -4 à 4 : la courbe de la figure 4.2.
grille <- seq(-4, 4, by = 0.02)
STUDENT <- list(dl = pom_n - 1, t = grille, densite = r(dt(grille, df = pom_n - 1), 5))

# ---- 8. Les tests sur l'Étude électorale : complets, puis sur un petit échantillon.
tt <- function(x) list(t = r(unname(x$statistic), 2), p = signif(x$p.value, 3),
                       ic = r(unname(x$conf.int), 3), estimes = r(unname(x$estimate), 3), dl = r(unname(x$parameter), 1))
ok <- df_clean |> filter(!is.na(gauche_droite), !is.na(ne_canada))
set.seed(8)
puissance <- mean(replicate(1000, t.test(gauche_droite ~ ne_canada, data = slice_sample(ok, n = 100))$p.value < 0.05))
TESTS <- list(
  centre = tt(t.test(df_clean$gauche_droite, mu = 5)),
  naissance = tt(t.test(gauche_droite ~ ne_canada, data = df_clean)),
  satisfaction = tt(t.test(satisfaction ~ ne_canada, data = df_clean)),
  nGaucheDroite = sum(!is.na(df_clean$gauche_droite)),
  # Sur 1 000 petits échantillons de 100, la part où p < 0,05.
  puissance100 = r(puissance, 3))

# ---- 9. Les consoles, dans l'ordre de la séance : chaque bloc s'exécute à la
#      suite du précédent, dans le même environnement, comme en classe.
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
# Les erreurs : un vrai Rscript, dont on garde le message tel qu'il s'affiche,
# sans la trace d'appels (backtrace) que R ajoute hors d'une session interactive.
tmp_rds <- tempfile(fileext = ".rds"); saveRDS(df_clean, tmp_rds)
erreur <- function(code) {
  f <- tempfile(fileext = ".R")
  writeLines(c("suppressPackageStartupMessages(library(ggplot2))",
               "options(rlang_backtrace_on_error = 'none')",
               sprintf('df_clean <- readRDS("%s")', tmp_rds), code), f)
  out <- suppressWarnings(system2("Rscript", f, stdout = TRUE, stderr = TRUE))
  out <- out[!grepl("^Execution halted|^Backtrace|^\\s*[▆█├└│]", out)]
  paste(out, collapse = "\n")
}

CONSOLES <- list(
  pvaleur = c("pt(-2.04, df = 49) + (1 - pt(2.04, df = 49))"),
  echantillon = c("echantillon <- slice_sample(df_clean, n = 50)", "mean(echantillon$age)",
                  "echantillon <- slice_sample(df_clean, n = 50)", "mean(echantillon$age)",
                  "mean(df_clean$age)"),
  mille = c("moyennes <- replicate(1000, mean(slice_sample(df_clean, n = 50)$age))",
            "mean(moyennes)", "sd(moyennes)", "sd(df_clean$age) / sqrt(50)"),
  centre = c("t.test(df_clean$gauche_droite, mu = 5)"),
  naissance = c("t.test(gauche_droite ~ ne_canada, data = df_clean)"),
  petit = c("petit <- slice_sample(df_clean, n = 100)", "t.test(gauche_droite ~ ne_canada, data = petit)"),
  partis = c("partis <- df_clean |>
  filter(as.numeric(vote) <= 5, !is.na(gauche_droite))",
             "moyennes_partis <- partis |>
  group_by(vote) |>
  summarise(moyenne = mean(gauche_droite),
            et = sd(gauche_droite) / sqrt(n()),
            n = n())", "moyennes_partis"),
  sauver = c('ggsave("gauche_droite_partis.png", width = 8, height = 5)')
)
graines <- c(echantillon = 9, mille = 10, petit = 11)
executer <- function(cle) {
  if (!is.na(graines[cle])) set.seed(graines[cle])
  lapply(CONSOLES[[cle]], function(code) list(`in` = code, out = sortie(code)))
}
# Toutes sauf ggsave(), qui attend le dernier graphique dessiné (section 10).
consoles_brutes <- sapply(setdiff(names(CONSOLES), "sauver"), executer, simplify = FALSE)

# ---- 10. Les graphiques ggplot2, rendus pour de vrai. Chaque étape est le
#      code affiché sur la diapo, évalué tel quel; les messages et
#      avertissements que R imprime en le dessinant sont gardés aussi.
ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
dossier_img <- file.path(ici, "..", "static", "img")
rendre <- function(nom, code, graine = 12, largeur = 6.4, hauteur = 4) {
  set.seed(graine)  # geom_jitter() tire au hasard : même graine, même nuage
  p <- eval(parse(text = code), envir = globalenv())
  msgs <- character()
  withCallingHandlers(
    ggsave(file.path(dossier_img, paste0("s5-", nom, ".png")), p, width = largeur, height = hauteur,
           dpi = 220, device = ragg::agg_png, bg = "white"),
    message = function(m) { msgs <<- c(msgs, trimws(conditionMessage(m))); invokeRestart("muffleMessage") },
    warning = function(w) { msgs <<- c(msgs, trimws(conditionMessage(w))); invokeRestart("muffleWarning") })
  assign("dernier_graphique", p, envir = globalenv())
  list(code = code, image = paste0("s5-", nom, ".png"), messages = unique(msgs))
}
GGPLOT <- list(
  vide = rendre("vide", "ggplot(df_clean)"),
  axes = rendre("axes", "ggplot(df_clean, aes(x = age, y = gauche_droite))"),
  points = rendre("points", "ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_point()"),
  jitter = rendre("jitter", "ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_jitter(alpha = 0.1)"),
  smooth = rendre("smooth", "ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_jitter(alpha = 0.1) +
  geom_smooth()"),
  labs = rendre("labs", "ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_jitter(alpha = 0.1) +
  geom_smooth() +
  labs(title = \"L'âge et la position gauche-droite\",
       x = \"Âge\",
       y = \"Gauche (0) à droite (10)\",
       caption = \"Source : Étude électorale canadienne 2025\")"),
  theme = rendre("theme", "ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_jitter(alpha = 0.1) +
  geom_smooth() +
  labs(title = \"L'âge et la position gauche-droite\",
       x = \"Âge\",
       y = \"Gauche (0) à droite (10)\",
       caption = \"Source : Étude électorale canadienne 2025\") +
  theme_minimal()"),
  couleur = rendre("couleur", "ggplot(partis, aes(x = age, y = gauche_droite, colour = vote)) +
  geom_smooth() +
  labs(x = \"Âge\", y = \"Gauche (0) à droite (10)\", colour = NULL) +
  theme_minimal()"),
  bleuAes = rendre("bleu-aes", "ggplot(df_clean, aes(x = age, fill = \"blue\")) +
  geom_histogram(binwidth = 5)", largeur = 5, hauteur = 3.6),
  bleu = rendre("bleu", "ggplot(df_clean, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = \"blue\")", largeur = 5, hauteur = 3.6),
  histo = rendre("histo", "ggplot(data.frame(moyennes), aes(x = moyennes)) +
  geom_histogram(binwidth = 0.5)"),
  ic = rendre("ic", "ggplot(moyennes_partis, aes(x = moyenne, y = vote)) +
  geom_pointrange(aes(xmin = moyenne - 1.96 * et,
                      xmax = moyenne + 1.96 * et)) +
  xlim(0, 10) +
  labs(x = \"Gauche (0) à droite (10)\", y = NULL)", largeur = 6.4, hauteur = 3.6)
)
# Le même graphique sur un petit échantillon de 200 partisan.e.s.
set.seed(13)
petit_partis <- slice_sample(get("partis", envir = globalenv()), n = 200) |>
  group_by(vote) |>
  summarise(moyenne = mean(gauche_droite), et = sd(gauche_droite) / sqrt(n()), n = n())
assign("petit_partis", petit_partis, envir = globalenv())
GGPLOT$icPetit <- rendre("ic-petit", "ggplot(petit_partis, aes(x = moyenne, y = vote)) +
  geom_pointrange(aes(xmin = moyenne - 1.96 * et,
                      xmax = moyenne + 1.96 * et)) +
  xlim(0, 10) +
  labs(x = \"Gauche (0) à droite (10)\", y = NULL)", largeur = 6.4, hauteur = 3.6)
GGPLOT$icPetit$n <- as.list(setNames(petit_partis$n, as.character(petit_partis$vote)))
mp <- get("moyennes_partis", envir = globalenv())
GGPLOT$ic$n <- as.list(setNames(mp$n, as.character(mp$vote)))

# ggsave() enregistre le dernier graphique affiché : celui des intervalles.
pdf(NULL); print(get("dernier_graphique", envir = globalenv())); invisible(dev.off())
old <- setwd(tempdir())  # le ggsave de la console écrit ici, pas dans le dépôt
consoles_brutes$sauver <- executer("sauver")
setwd(old)

ERREURS <- list(
  pipe = list(code = "ggplot(df_clean, aes(x = age, y = gauche_droite)) |>
  geom_point()"),
  ligne = list(code = "ggplot(df_clean, aes(x = age, y = gauche_droite))
  + geom_point()")
)
ERREURS <- lapply(ERREURS, function(e) c(e, sortie = erreur(e$code)))

# ---- Écrire le module.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_data.R. Sources : ces::get_ces(\"2025\"), l'Étude électorale",
  "   canadienne 2025, dont les 20 180 répondant.e.s servent de population d'exercice (sans",
  "   pondération) ; la pomicultrice d'Arel-Bundock (2021, p. 62-74) ; Squire (1988, p. 126-127)",
  "   pour le Literary Digest ; Arel-Bundock (2021, p. 76) pour les deux études citées.",
  sprintf("   %s, ggplot2 %s. Aucune valeur ici n'est écrite à la main. */", R.version.string, packageVersion("ggplot2")),
  "",
  "/* La population d'exercice : l'âge des 20 180 répondant.e.s. */",
  sprintf("export const POP = %s;", J(lapply(POP, r))),
  "/* Mille lancers de pièce (1 = pile), et la part de piles après chaque lancer. */",
  sprintf("export const PILE_FACE = %s;", J(pile_face)),
  "/* La moyenne d'âge, à mesure qu'on ajoute des répondant.e.s tiré.e.s au hasard (2 000 premiers). */",
  sprintf("export const MOYENNE_COURANTE = %s;", J(moyenne_courante)),
  "/* Trois échantillons aléatoires de 50 personnes : leurs âges et leur moyenne. */",
  sprintf("export const TROIS = %s;", J(trois)),
  "/* Mille échantillons pour chaque taille : effectifs des moyennes par tranche d'un an, de 30 à 70. */",
  sprintf("export const BORNES = %s;", J(bornes)),
  sprintf("export const DISTRIBUTIONS = %s;", J(DISTRIBUTIONS)),
  "/* Les 1 000 moyennes des échantillons de 50, dans l'ordre du tirage. */",
  sprintf("export const MOYENNES_50 = %s;", J(moyennes50)),
  "/* Quatre échantillons de 5 : l'écart dans chaque échantillon, et l'écart entre leurs moyennes. */",
  sprintf("export const DANS_ENTRE = %s;", J(dans_entre)),
  "/* Mille échantillons de 50, tirés seulement chez les gens très intéressés par la politique (8 à 10). */",
  sprintf("export const BIAIS = %s;", J(BIAIS)),
  "/* Cent échantillons de 50 et leur intervalle de confiance à 95 % (t.test). */",
  sprintf("export const ANNEAUX = %s;", J(ANNEAUX)),
  "/* La pomicultrice, recalculée. */",
  sprintf("export const POMMES = %s;", J(POMMES)),
  sprintf("export const STUDENT = %s;", J(STUDENT)),
  "/* Les tests de la séance sur l'Étude électorale, sans pondération. */",
  sprintf("export const TESTS = %s;", J(TESTS)),
  "/* Le Literary Digest, 1936 (Squire 1988, p. 126-127). */",
  sprintf("export const DIGEST = %s;", J(list(postes = 10e6, retournes = 2.3e6, taux = 0.25,
    prevision = list(Landon = 55, Roosevelt = 41, Lemke = 4), resultat = list(Roosevelt = 61, Landon = 37)))),
  "/* Les graphiques ggplot2 : le code, l'image rendue, les messages de R. */",
  sprintf("export const GGPLOT = %s;", J(GGPLOT)),
  "/* Deux erreurs classiques, telles que R les affiche. */",
  sprintf("export const ERREURS = %s;", J(ERREURS)),
  "",
  "/* Les consoles de la séance, à options(width = 100), dans l'ordre où R les a exécutées. */",
  sprintf("export const CONSOLES = %s;", J(consoles_brutes))
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5.js"))
cat("écrit : src/lib/data/seance5.js et static/img/s5-*.png\n")
