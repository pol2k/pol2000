# Exporte ce que les figures de la séance 2 dessinent de l'Étude électorale
# canadienne 2025 vers src/lib/data/ces2025.js : l'histogramme de l'âge tel
# que hist() le découpe, la part de chaque parti selon la scolarité, et la
# droite de lm() qui reprend la régression de la séance 1. Aucune valeur
# n'est tapée à la main. Relancer depuis deck/ :
#
#   Rscript outils/ces_data.R
#
# Les données viennent de ces::get_ces("2025") (téléchargement, ~30 s). Pour
# éviter de retélécharger, pointer CES2025_RDS vers une copie saveRDS() :
#
#   CES2025_RDS=~/ces2025.rds Rscript outils/ces_data.R
suppressPackageStartupMessages({ library(dplyr); library(haven) })

cache <- Sys.getenv("CES2025_RDS")
df <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

# 1. L'âge : hist() choisit les bornes, on les garde telles quelles.
h <- hist(as.numeric(df$cps25_age_in_years), plot = FALSE)

# 2. La part de chaque parti selon la scolarité, exactement le code montré
#    sur la diapo « Un graphique, couche par couche ».
d <- df |>
  filter(cps25_votechoice %in% 1:5, cps25_education <= 11) |>
  mutate(parti = as_factor(cps25_votechoice),
         scolarite = cut(cps25_education, c(0, 5, 7, 11),
                         labels = c("Secondaire ou moins", "Collégial", "Universitaire"))) |>
  count(scolarite, parti) |>
  group_by(scolarite) |>
  mutate(part = n / sum(n)) |>
  ungroup()

# 3. La régression de la séance 1 : voter conservateur selon la tranche de
#    revenu, chez celles et ceux qui nomment un parti (codes 1 à 5 et 8) et
#    donnent leur revenu (1 à 8 ; 9 = ne sait pas).
d2 <- df |>
  filter(cps25_votechoice %in% c(1:5, 8), cps25_income <= 8) |>
  mutate(conservateur = cps25_votechoice == 2)
m <- lm(conservateur ~ cps25_income, data = d2)

# 4. Les compteurs cités sur les diapos.
n_qc <- df |> filter(cps25_province == 11) |> nrow()

js <- function(x) sprintf('"%s"', gsub('"', '\\\\"', x))
barres <- sprintf('  { scolarite: %s, parti: %s, n: %d, part: %s }',
                  js(as.character(d$scolarite)), js(as.character(d$parti)), d$n, round(d$part, 4))
out <- c(
  "/* Généré par outils/ces_data.R à partir de ces::get_ces(\"2025\"), l'Étude",
  sprintf("   électorale canadienne 2025. %s. Aucune valeur ici n'est écrite à la main. */", R.version.string),
  sprintf("export const N = %d;", nrow(df)),
  sprintf("export const N_COLONNES = %d;", ncol(df)),
  sprintf("export const N_QUEBEC = %d;", n_qc),
  "/* hist(df$cps25_age_in_years) : bornes et effectifs, tels que R les choisit. */",
  sprintf("export const HIST_AGE = { bornes: [%s], effectifs: [%s] };",
          paste(h$breaks, collapse = ", "), paste(h$counts, collapse = ", ")),
  sprintf("export const MOY_AGE = %s;", round(mean(df$cps25_age_in_years), 5)),
  "/* Part de chaque parti (codes 1 à 5) dans chaque groupe de scolarité :",
  "   1 à 5 = secondaire ou moins, 6 à 7 = collégial, 8 à 11 = universitaire. */",
  "export const BARRES = [",
  paste(barres, collapse = ",\n"),
  "];",
  "/* lm(conservateur ~ cps25_income), la droite de la séance 1. */",
  sprintf("export const LM_REVENU = { constante: %s, pente: %s, n: %d };",
          round(coef(m)[1], 6), round(coef(m)[2], 6), nobs(m))
)
ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
writeLines(out, file.path(ici, "..", "src", "lib", "data", "ces2025.js"))
cat("écrit : src/lib/data/ces2025.js ·", nrow(df), "répondant.e.s ·", nrow(d), "barres\n")
