# « Notre budget : 1 000 personnes. » L'histoire qui porte la première moitié
# de la séance 5 : la CES 2025 sert de population d'exercice (les
# répondant.e.s qui déclarent un parti, sans « ne sait pas » ni réponse
# manquante), et on veut estimer la part du vote conservateur avec 1 000
# personnes. Exporte src/lib/data/seance5_budget.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_budget.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Le hasard est
# fixé (set.seed) bloc par bloc. Les échantillons « faciles » tirent 1 000
# personnes au hasard, mais seulement dans un sous-groupe :
#   - nos voisins : la province de Québec (cps25_province);
#   - si on était à Calgary : l'Alberta;
#   - le campus : les diplômé.e.s universitaires (cps25_education 8 à 11,
#     le recodage de la séance 4);
#   - les 65 ans et plus (cps25_age_in_years).
suppressPackageStartupMessages({ library(ces); library(haven) })

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

vote <- as_factor(d$cps25_votechoice)
decide <- !is.na(vote) & as.numeric(vote) != 7
pop <- data.frame(
  cons = as.numeric(as.numeric(vote) == 2),
  prov = as.character(as_factor(d$cps25_province)),
  edu = as.numeric(d$cps25_education),
  age = as.numeric(d$cps25_age_in_years)
)[decide, ]
N <- 1000
VRAI <- mean(pop$cons)

part <- function(sous, graine) { set.seed(graine); mean(sous$cons[sample(nrow(sous), N)]) }
groupes <- list(
  quebec = list(nom = "nos voisins : le Québec", sous = pop[grepl("Quebec", pop$prov), ]),
  alberta = list(nom = "si on était à Calgary : l'Alberta", sous = pop[grepl("Alberta", pop$prov), ]),
  campus = list(nom = "le campus : les diplômé.e.s universitaires", sous = pop[!is.na(pop$edu) & pop$edu >= 8 & pop$edu <= 11, ]),
  aines = list(nom = "les 65 ans et plus", sous = pop[!is.na(pop$age) & pop$age >= 65, ])
)
FACILES <- lapply(names(groupes), function(k) {
  g <- groupes[[k]]
  list(cle = k, nom = g$nom, bassin = nrow(g$sous), part = round(part(g$sous, 61), 4))
})
HASARD <- list(part = round(part(pop, 62), 4))
HASARD$marge <- round(1.96 * sqrt(HASARD$part * (1 - HASARD$part) / N), 4)

# Recommencer 1 000 fois : au hasard dans tout le monde, puis seulement au
# Québec. Effectifs par tranche d'un demi-point, de 10 % à 45 %.
bornes <- seq(0.10, 0.45, by = 0.005)
# Un epsilon : 29 personnes sur 100 donne 0,29, que cut() lirait 0,2899…
compte <- function(x) as.integer(table(cut(x + 1e-9, bornes, right = FALSE)))
set.seed(63); mille_h <- replicate(1000, mean(pop$cons[sample(nrow(pop), N)]))
qc <- groupes$quebec$sous
set.seed(64); mille_q <- replicate(1000, mean(qc$cons[sample(nrow(qc), N)]))
marge_h <- 1.96 * sd(mille_h)
MILLE <- list(bornes = bornes,
              hasard = list(effectifs = compte(mille_h), moyenne = mean(mille_h), ecartType = sd(mille_h),
                            dedans = sum(abs(mille_h - VRAI) <= marge_h), marge = marge_h),
              quebec = list(effectifs = compte(mille_q), moyenne = mean(mille_q), ecartType = sd(mille_q)))

# Et si le budget changeait : 1 000 échantillons de 100, de 1 000 et de 4 000.
TAILLES <- lapply(c(100, 1000, 4000), function(n) {
  set.seed(65); m <- replicate(1000, mean(pop$cons[sample(nrow(pop), n)]))
  list(n = n, effectifs = compte(pmin(pmax(m, 0.10), 0.4499)), ecartType = sd(m))
})

# Vingt sondages de 1 000 au hasard, chacun avec sa marge d'erreur. La graine
# est la première à partir de 66 où exactement 1 sondage sur 20 rate la vraie
# valeur et où le premier l'attrape (le cas typique; choisie, pas tirée).
sonder <- function(g) { set.seed(g); lapply(1:20, function(i) {
  p <- mean(pop$cons[sample(nrow(pop), N)]); list(p = round(p, 4), marge = round(1.96 * sqrt(p * (1 - p) / N), 4)) }) }
rate <- function(s) abs(s$p - VRAI) > s$marge
graine <- 66
repeat { s <- sonder(graine); if (sum(sapply(s, rate)) == 1 && !rate(s[[1]])) break; graine <- graine + 1 }
for (i in seq_along(s)) s[[i]]$couvre <- !rate(s[[i]])
SONDAGES <- list(graine = graine, sondages = s)

BUDGET <- list(population = nrow(pop), vrai = round(VRAI, 4), n = N)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance5_budget.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), répondant.e.s qui déclarent un parti, sans pondération.",
  "   La part du vote conservateur, estimée avec un budget de 1 000 personnes. */",
  "",
  "/* La population d'exercice, la vraie part conservatrice, la taille du budget. */",
  paste0("export const BUDGET = ", J(BUDGET), ";"),
  "/* Quatre échantillons faciles de 1 000 : la part conservatrice dans chacun. */",
  paste0("export const FACILES = ", J(FACILES), ";"),
  "/* Un échantillon de 1 000 au hasard, et sa marge d'erreur (1,96 × racine(p(1 − p)/n)). */",
  paste0("export const HASARD = ", J(HASARD), ";"),
  "/* 1 000 échantillons au hasard, puis 1 000 au Québec : effectifs par demi-point de %. */",
  paste0("export const MILLE = ", J(MILLE), ";"),
  "/* 1 000 échantillons de 100, de 1 000 et de 4 000 personnes. */",
  paste0("export const TAILLES = ", J(TAILLES), ";"),
  "/* Vingt sondages de 1 000 au hasard, avec leur marge; un seul rate (graine choisie). */",
  paste0("export const SONDAGES = ", J(SONDAGES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance5_budget.js"))
cat("ok\n")
