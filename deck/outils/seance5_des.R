# Les dés de la séance 5 : pourquoi les moyennes font une cloche. On lance
# 10 000 fois un dé, 10 000 fois deux dés, 10 000 fois dix dés, et on compte
# combien de lancers donnent chaque moyenne possible. Exporte
# src/lib/data/seance5_des.js. Rien n'est tapé à la main. Depuis deck/ :
#
#   Rscript outils/seance5_des.R
#
# Les tranches : une barre par moyenne possible.
#   - 1 dé : 1, 2, 3, 4, 5, 6 (6 barres);
#   - 2 dés : 1, 1,5, 2, ..., 6 (11 barres);
#   - 10 dés : 1, 1,1, 1,2, ..., 6 (51 barres, une par total de 10 à 60).
# On compte sur le total des dés (un entier) plutôt que sur la moyenne, pour
# éviter les arrondis : la moyenne, c'est le total divisé par le nombre de dés.
#
# Le premier lancer de chaque série est aussi exporté : ce sont les faces que
# la diapo dessine au-dessus de chaque panneau.
#
# Le hasard est fixé (set.seed) : la même commande redonne les mêmes chiffres.
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))

LANCERS <- 10000
set.seed(59)
DES <- lapply(c(1, 2, 10), function(k) {
  faces <- matrix(sample(1:6, LANCERS * k, replace = TRUE), nrow = LANCERS, ncol = k)
  totaux <- rowSums(faces)
  possibles <- k:(6 * k)
  list(des = k,
       n = LANCERS,
       valeurs = possibles / k,
       effectifs = as.integer(table(factor(totaux, levels = possibles))),
       premier = I(as.integer(faces[1, ])),  # I() : un tableau même pour un seul dé
       moyenne = mean(totaux / k))
})

# ---- Export.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_des.R (set.seed(59)). Des dés simulés dans R : 10 000 lancers",
  "   d'un dé, de deux dés et de dix dés. Aucune valeur ici n'est écrite à la main. */",
  "",
  "/* Pour chaque série : le nombre de dés, le nombre de lancers, chaque moyenne possible (valeurs),",
  "   combien de lancers la donnent (effectifs), les faces du premier lancer et la moyenne des moyennes. */",
  paste0("export const DES = ", J(DES), ";")
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_des.js"))
cat("ok\n")
