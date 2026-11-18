# Séance 11 : les simulations d'Arel-Bundock (2021), chapitre 6, p. 132-136.
#
#   Rscript outils/seance11_data.R      (depuis deck/)
#
# Écrit src/lib/data/seance11.js. Chaque simulation est un bloc complet, tel
# qu'il paraît sur la diapo, avec set.seed() et n : un.e étudiant.e qui le
# recopie dans Positron obtient exactement les mêmes chiffres. Le texte
# affiché et le code exécuté sont la même chaîne : rien n'est tapé à la main.
#
# Différence avec le deck de 2024 : la sortie « sans contrôle » de la
# simulation de la fourchette y venait des données de la collision. Ici,
# chaque sortie vient de son propre bloc.

options(width = 100)

# Une entrée = ce qu'on révèle d'un clic dans Console.svelte.
BLOCS <- list(
  simple = c(
    "set.seed(2026)\nn <- 100000\nX <- rnorm(n)\nY <- 1.7 * X + rnorm(n)",
    "mod <- lm(Y ~ X)\ncoef(mod)"
  ),
  chaine = c(
    "set.seed(2026)\nn <- 100000\nX <- rnorm(n)\nZ <- 3 * X + rnorm(n)\nY <- 0.5 * Z + rnorm(n)",
    "mod <- lm(Y ~ X)\ncoef(mod)"
  ),
  collision = c(
    "set.seed(2026)\nn <- 100000\nX <- rnorm(n)\nY <- 1.7 * X + rnorm(n)\nZ <- 1.2 * X + 0.8 * Y + rnorm(n)",
    "mod <- lm(Y ~ X)\ncoef(mod)",
    "mod <- lm(Y ~ X + Z)\ncoef(mod)"
  ),
  fourchette = c(
    "set.seed(2026)\nn <- 100000\nZ2 <- rnorm(n)\nX <- Z2 + rnorm(n)\nZ1 <- 2 * X + rnorm(n)\nY <- 0.25 * Z1 + Z2 + rnorm(n)",
    "mod <- lm(Y ~ X + Z2)\ncoef(mod)",
    "mod <- lm(Y ~ X)\ncoef(mod)"
  ),
  complexe = c(
    "set.seed(2026)\nn <- 100000\nZ1 <- rnorm(n)\nX <- Z1 + rnorm(n)\nZ2 <- 2 * X + rnorm(n)\nY <- 0.5 * Z2 + Z1 + rnorm(n)\nZ3 <- Z2 + Y + rnorm(n)",
    "mod <- lm(Y ~ X + Z1)\ncoef(mod)",
    "mod <- lm(Y ~ X)\ncoef(mod)"
  )
)

executer <- function(entree, env) {
  out <- capture.output(source(textConnection(entree), local = env, echo = FALSE, print.eval = TRUE))
  paste(out, collapse = "\n")
}

SIMS <- list()
ENVS <- list()
for (nom in names(BLOCS)) {
  env <- new.env(parent = globalenv())
  SIMS[[nom]] <- lapply(BLOCS[[nom]], function(e) list(`in` = e, out = executer(e, env)))
  ENVS[[nom]] <- env
}

# Les huit modèles du tableau 6.1, sur les données de la simulation complexe.
d <- ENVS$complexe
FORMULES <- c(M1 = "Y ~ X + Z1", M2 = "Y ~ X", M3 = "Y ~ X + Z2", M4 = "Y ~ X + Z3",
              M5 = "Y ~ X + Z1 + Z2", M6 = "Y ~ X + Z1 + Z3", M7 = "Y ~ X + Z2 + Z3",
              M8 = "Y ~ X + Z1 + Z2 + Z3")
MODELES <- lapply(names(FORMULES), function(m) {
  b <- coef(lm(as.formula(FORMULES[[m]]), data = data.frame(X = d$X, Y = d$Y, Z1 = d$Z1, Z2 = d$Z2, Z3 = d$Z3)))[["X"]]
  list(nom = m, formule = FORMULES[[m]], x = round(b, 2))
})

# Les points de la collision, pour la figure des tranches (M11Tranches) :
# les 400 premières lignes des mêmes données (set.seed(2026)), et les deux
# droites estimées sur les 100 000 lignes.
dc <- ENVS$collision
m1 <- coef(lm(Y ~ X, data = data.frame(X = dc$X, Y = dc$Y)))
m2 <- coef(lm(Y ~ X + Z, data = data.frame(X = dc$X, Y = dc$Y, Z = dc$Z)))
TRANCHES <- list(
  points = lapply(1:400, function(i) list(x = round(dc$X[i], 3), y = round(dc$Y[i], 3), z = round(dc$Z[i], 3))),
  simple = list(a = unname(m1[1]), b = unname(m1[2])),
  controle = list(a = unname(m2[1]), b = unname(m2[2]), bz = unname(m2[3]))
)

VRAI <- list(simple = 1.7, chaine = 1.5, collision = 1.7, fourchette = 0.5, complexe = 1)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, digits = NA)
sortie <- file.path("src", "lib", "data", "seance11.js")
writeLines(c(
  "// Généré par outils/seance11_data.R : ne pas modifier à la main.",
  "// Simulations d'Arel-Bundock (2021), chapitre 6, avec set.seed(2026).",
  paste0("export const SIMS = ", J(SIMS), ";"),
  paste0("export const MODELES = ", J(MODELES), ";"),
  paste0("export const VRAI = ", J(VRAI), ";"),
  paste0("export const TRANCHES = ", J(TRANCHES), ";")
), sortie)

for (nom in names(SIMS)) {
  cat("\n==", nom, "\n")
  for (l in SIMS[[nom]]) if (nzchar(l$out)) cat(l$out, "\n")
}
cat("\n== MODELES\n"); for (m in MODELES) cat(m$nom, m$formule, m$x, "\n")
