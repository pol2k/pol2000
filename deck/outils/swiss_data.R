# Exporte le jeu de données `swiss` (livré avec R) vers src/lib/data/swiss.js,
# pour que les figures de la séance 2 dessinent les vraies valeurs, pas des
# points inventés. Relancer depuis deck/ : Rscript outils/swiss_data.R
#
# swiss : 47 provinces francophones de Suisse, vers 1888. Fertility est un
# indice de fécondité standardisé; les autres colonnes sont des pourcentages
# (hommes en agriculture, meilleure note à l'examen militaire, scolarité
# au-delà du primaire, catholiques, mortalité infantile).
df <- swiss
h <- hist(df$Fertility, plot = FALSE)
lignes <- sprintf(
  '  { nom: "%s", fertilite: %s, agriculture: %s, examen: %s, education: %s, catholique: %s, mortalite: %s }',
  rownames(df), df$Fertility, df$Agriculture, df$Examination, df$Education, df$Catholic, df$Infant.Mortality
)
out <- c(
  "/* Généré par outils/swiss_data.R à partir du jeu `swiss` livré avec R.",
  sprintf("   %s. Aucune valeur ici n'est écrite à la main. */", R.version.string),
  "export const SWISS = [",
  paste(lignes, collapse = ",\n"),
  "];",
  "/* hist(swiss$Fertility) : bornes et effectifs, tels que R les choisit. */",
  sprintf("export const HIST = { bornes: [%s], effectifs: [%s] };",
          paste(h$breaks, collapse = ", "), paste(h$counts, collapse = ", ")),
  sprintf("export const MOY_FERTILITE = %s;", round(mean(df$Fertility), 5)),
  sprintf("export const COR_EDUCATION = %s;", round(cor(df$Education, df$Fertility), 4)),
  sprintf("export const LM_EDUCATION = { constante: %s, pente: %s };",
          round(coef(lm(Fertility ~ Education, df))[1], 4), round(coef(lm(Fertility ~ Education, df))[2], 4))
)
writeLines(out, file.path(dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE))), "..", "src", "lib", "data", "swiss.js"))
cat("écrit : src/lib/data/swiss.js ·", nrow(df), "lignes\n")
