# Les dés de la séance 5 : pourquoi les moyennes font une cloche. On lance
# 1 000 fois un dé, 1 000 fois deux dés, 1 000 fois dix dés, et on compte
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
# Chaque lancer est aussi exporté, dans l'ordre : les diapos rejouent les
# lancers un à un (les dix premiers, puis l'avance rapide jusqu'à 1 000).
# Les faces sont écrites en une chaîne de chiffres, lancer après lancer :
# pour deux dés, "24..." veut dire 2 et 4 au premier lancer. Le composant
# découpe la chaîne par paquets de 1, 2 ou 10 chiffres.
#
# Le hasard est fixé (set.seed) : la même commande redonne les mêmes chiffres.
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))

LANCERS <- 1000
set.seed(59)
DES <- lapply(c(1, 2, 10), function(k) {
  faces <- matrix(sample(1:6, LANCERS * k, replace = TRUE), nrow = LANCERS, ncol = k)
  totaux <- rowSums(faces)
  possibles <- k:(6 * k)
  list(des = k,
       n = LANCERS,
       valeurs = possibles / k,
       effectifs = as.integer(table(factor(totaux, levels = possibles))),
       # t() : ligne par ligne, un lancer après l'autre (pas colonne par colonne).
       faces = paste(t(faces), collapse = ""))
})

# ---- Contrôle : la chaîne redonne bien les effectifs.
for (d in DES) {
  f <- as.integer(strsplit(d$faces, "")[[1]])
  tot <- rowSums(matrix(f, ncol = d$des, byrow = TRUE))
  stopifnot(identical(as.integer(table(factor(tot, levels = d$des:(6 * d$des)))), d$effectifs))
}

# ---- Export.
J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
out <- c(
  "/* Généré par outils/seance5_des.R (set.seed(59)). Des dés simulés dans R : 1 000 lancers",
  "   d'un dé, de deux dés et de dix dés. Aucune valeur ici n'est écrite à la main. */",
  "",
  "/* Pour chaque série : le nombre de dés, le nombre de lancers, chaque moyenne possible (valeurs),",
  "   combien de lancers la donnent (effectifs), et les faces de tous les lancers, dans l'ordre,",
  "   en une chaîne de chiffres (un chiffre par dé, lancer après lancer). */",
  paste0("export const DES = ", J(DES), ";")
)
writeLines(out, file.path(ici, "..", "src", "lib", "data", "seance5_des.js"))
cat("ok\n")
