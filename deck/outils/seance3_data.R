# Exporte tout ce que la séance 3 dessine ou affiche vers
# src/lib/data/seance3.js : les distributions de quatre vraies variables de
# l'Étude électorale canadienne 2025, l'âge vu par ggplot2 (histogramme,
# boîte, densité, tels que ggplot_build() les calcule), l'âge par parti, le
# quartet d'Anscombe (datasets::anscombe), le tableau croisé du Titanic, et
# les sorties de console, capturées telles que R les imprime à
# options(width = 100). Aucune valeur n'est tapée à la main. Depuis deck/ :
#
#   CES2025_RDS=~/ces2025.rds TITANIC_CSV=chemin/titanic.csv Rscript outils/seance3_data.R
#
# Sans CES2025_RDS, les données sont téléchargées par ces::get_ces("2025").
# TITANIC_CSV : le fichier du cours d'hiver 2024 (1 313 passagers, colonnes
# femme et survie). Il n'est pas versionné ; seuls les quatre effectifs du
# tableau croisé sont exportés.
suppressPackageStartupMessages({ library(ces); library(dplyr); library(haven); library(ggplot2) })
options(width = 100)

cache <- Sys.getenv("CES2025_RDS")
df <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

# ---- 1. Quatre formes. -99 = « ne sait pas » : écarté ici, recodé à la séance 4.
valide <- function(v) { x <- as.numeric(df[[v]]); x[!is.na(x) & x >= 0] }
compte <- function(x, niveaux) as.integer(table(factor(x, levels = niveaux)))
lr <- valide("cps25_lr_scale_bef_1")
interet <- valide("cps25_interest_gen_1")
poil <- valide("cps25_lead_rating_24")
menage_tout <- as.numeric(df$cps25_household)
menage <- menage_tout[!is.na(menage_tout) & menage_tout >= 1]
h_poil <- hist(poil, breaks = seq(0, 100, 10), plot = FALSE)

forme <- function(nom, x, valeurs, effectifs, sans) sprintf(
  '  %s: { valeurs: [%s], effectifs: [%s], n: %d, sans: %d, moyenne: %s, mediane: %s }',
  nom, paste(valeurs, collapse = ", "), paste(effectifs, collapse = ", "),
  length(x), sans, round(mean(x), 3), median(x))

# ---- 2. Le centre : quelques repères.
demsat <- as.numeric(df$cps25_demsat)
vote <- as.numeric(df$cps25_votechoice)

# ---- 3. L'âge, vu par ggplot2.
age <- data.frame(age = as.numeric(df$cps25_age_in_years))
b_hist <- layer_data(ggplot(age, aes(x = age)) + geom_histogram(binwidth = 5, boundary = 15))
b_box <- layer_data(ggplot(age, aes(x = age)) + geom_boxplot())
b_dens <- layer_data(ggplot(age, aes(x = age)) + geom_density())
dens <- b_dens[seq(1, nrow(b_dens), length.out = 81), ]
q_age <- quantile(age$age)

# ---- 4. L'âge par parti : boîtes de ggplot2 et moyennes.
d_partis <- df |>
  filter(cps25_votechoice %in% 1:5) |>
  mutate(parti = as_factor(cps25_votechoice), age = as.numeric(cps25_age_in_years))
b_partis <- layer_data(ggplot(d_partis, aes(x = parti, y = age)) + geom_boxplot())
moy_partis <- d_partis |> group_by(parti) |> summarise(age = mean(age), n = n())

# ---- 5. Anscombe.
a <- datasets::anscombe
ans <- lapply(1:4, function(i) {
  x <- a[[paste0("x", i)]]; y <- a[[paste0("y", i)]]; m <- lm(y ~ x)
  sprintf('  { x: [%s], y: [%s], moyX: %s, moyY: %s, etX: %s, etY: %s, r: %s, constante: %s, pente: %s }',
          paste(x, collapse = ", "), paste(y, collapse = ", "),
          round(mean(x), 2), round(mean(y), 2), round(sd(x), 2), round(sd(y), 2),
          round(cor(x, y), 3), round(coef(m)[1], 2), round(coef(m)[2], 3))
})

# ---- 6. Titanic.
tcsv <- Sys.getenv("TITANIC_CSV")
tt <- table(read.csv(tcsv)[, c("femme", "survie")])

# ---- 7. Les consoles : chaque sortie est ce que R imprime, mot pour mot.
sortie <- function(code) {
  out <- capture.output(res <- withVisible(eval(parse(text = code), envir = globalenv())))
  if (res$visible) out <- c(out, capture.output(print(res$value)))
  paste(out, collapse = "\n")
}
assign("df", df, envir = globalenv())
CONSOLES <- list(
  resume = c("mean(df$cps25_age_in_years)", "median(df$cps25_age_in_years)", "summary(df$cps25_age_in_years)"),
  dispersion = c("sd(df$cps25_age_in_years)", "quantile(df$cps25_age_in_years)", "IQR(df$cps25_age_in_years)"),
  menage = c("summary(df$cps25_household)", "sort(df$cps25_household, decreasing = TRUE)[1:3]"),
  categ = c("table(df$cps25_demsat)", "levels(as_factor(df$cps25_demsat))")
)
js <- function(x) {
  x <- gsub("\\\\", "\\\\\\\\", x); x <- gsub("`", "\\\\`", x); x <- gsub("\\$\\{", "\\\\${", x)
  paste0("`", x, "`")
}
consoles <- sapply(names(CONSOLES), function(k) {
  lignes <- sapply(CONSOLES[[k]], function(code) sprintf("    { in: %s, out: %s }", js(code), js(sortie(code))))
  sprintf("  %s: [\n%s\n  ]", k, paste(lignes, collapse = ",\n"))
})

jsn <- function(v, d = 3) paste(round(v, d), collapse = ", ")
out <- c(
  "/* Généré par outils/seance3_data.R. Sources : ces::get_ces(\"2025\"), l'Étude électorale",
  "   canadienne 2025 ; datasets::anscombe ; les passagers du Titanic du cours d'hiver 2024.",
  sprintf("   %s. Aucune valeur ici n'est écrite à la main. */", R.version.string),
  "",
  "/* Quatre formes. valeurs = abscisses (pour poilievre, les bornes des tranches de 10) ;",
  "   sans = réponses « ne sait pas » (-99) ou hors échelle, écartées. */",
  "export const FORMES = {",
  paste(c(
    forme("gauche_droite", lr, 0:10, compte(lr, 0:10), nrow(df) - length(lr)),
    forme("interet", interet, 0:10, compte(interet, 0:10), nrow(df) - length(interet)),
    forme("poilievre", poil, h_poil$breaks, h_poil$counts, nrow(df) - length(poil)),
    forme("menage", menage, 1:12, compte(menage, 1:12), nrow(df) - length(menage))
  ), collapse = ",\n"),
  "};",
  sprintf("export const MENAGE = { max: %s, moyenneValide: %s, medianeValide: %s, plusGrands: [%s], n12: %d };",
          format(max(menage), scientific = FALSE), round(mean(menage), 1), median(menage),
          paste(format(sort(menage, decreasing = TRUE)[1:5], scientific = FALSE, trim = TRUE), collapse = ", "), sum(menage > 12)),
  sprintf("export const DEMSAT = { effectifs: [%s] };", paste(compte(demsat, 1:5), collapse = ", ")),
  sprintf("export const VOTE = { effectifs: [%s] };", paste(compte(vote, 1:8), collapse = ", ")),
  "",
  "/* L'âge. hist, boite et densite : ggplot_build() de geom_histogram(binwidth = 5, boundary = 15),",
  "   geom_boxplot() et geom_density(). */",
  sprintf("export const AGE = { n: %d, moyenne: %s, mediane: %s, et: %s, eiq: %s, quartiles: [%s] };",
          nrow(age), round(mean(age$age), 2), median(age$age), round(sd(age$age), 2), IQR(age$age), jsn(q_age)),
  "/* Les 101 centiles de l'âge, quantile(age, 0:100 / 100) : 0 %, 1 %, ..., 100 %. */",
  sprintf("export const AGE_CENTILES = [%s];", jsn(quantile(age$age, seq(0, 1, 0.01)), 2)),
  sprintf("export const AGE_HIST ={ debut: [%s], fin: [%s], effectifs: [%s] };", jsn(b_hist$xmin), jsn(b_hist$xmax), paste(b_hist$count, collapse = ", ")),
  sprintf("export const AGE_BOITE = { min: %s, q1: %s, med: %s, q3: %s, max: %s, horsNorme: %d };",
          b_box$xmin, b_box$xlower, b_box$xmiddle, b_box$xupper, b_box$xmax, length(b_box$outliers[[1]])),
  sprintf("export const AGE_DENSITE = { x: [%s], y: [%s] };", jsn(dens$x, 2), jsn(dens$density, 6)),
  "",
  "/* L'âge par parti (codes 1 à 5) : les boîtes de ggplot2 et les moyennes. */",
  "export const AGE_PARTIS = [",
  paste(sprintf('  { parti: "%s", n: %d, moyenne: %s, min: %s, q1: %s, med: %s, q3: %s, max: %s }',
                moy_partis$parti, moy_partis$n, round(moy_partis$age, 2),
                b_partis$ymin, b_partis$lower, b_partis$middle, b_partis$upper, b_partis$ymax), collapse = ",\n"),
  "];",
  "",
  "/* Le quartet d'Anscombe (1973), datasets::anscombe. */",
  "export const ANSCOMBE = [",
  paste(unlist(ans), collapse = ",\n"),
  "];",
  "",
  "/* Titanic : lignes femme (0 homme, 1 femme), colonnes survie (0 mort, 1 vivant). */",
  sprintf("export const TITANIC = { hommes: { morts: %d, vivants: %d }, femmes: { morts: %d, vivants: %d } };",
          tt["0", "0"], tt["0", "1"], tt["1", "0"], tt["1", "1"]),
  "",
  "/* Les consoles de la séance, à options(width = 100). */",
  "export const CONSOLES = {",
  paste(consoles, collapse = ",\n"),
  "};"
)
ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance3.js"))
cat("écrit : src/lib/data/seance3.js\n")
