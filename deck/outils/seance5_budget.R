# « Notre budget : 1 000 personnes. » L'histoire qui porte la première moitié
# de la séance 5 : les 20 180 répondant.e.s de la CES 2025 sont la population
# d'exercice, et on veut estimer la part du vote conservateur (parmi celles et
# ceux qui déclarent un vote, comme dans un vrai sondage) avec 1 000 personnes.
# La vraie réponse (BUDGET.vrai) est connue ici, pas du sondeur. Exporte
# src/lib/data/seance5_budget.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance5_budget.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération. Le hasard est
# fixé (set.seed) bloc par bloc. Un seul sondage au hasard traverse l'histoire
# (graine 62) : HASARD, et le premier des vingt SONDAGES. Les sondages
# « faciles » tirent 1 000 personnes au hasard, mais seulement dans un sous-groupe :
#   - nos voisins : la province de Québec (cps25_province);
#   - si on était à Calgary : l'Alberta;
#   - le campus : les diplômé.e.s universitaires (cps25_education 8 à 11,
#     le recodage de la séance 4);
#   - les 65 ans et plus (cps25_age_in_years).
suppressPackageStartupMessages({ library(ces); library(haven) })

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else get_ces("2025")

# La population : les 20 180 répondant.e.s, toutes et tous. Comme dans un
# vrai sondage, certain.e.s ne déclarent pas de vote (NA ou « ne sait pas ») :
# la part conservatrice se calcule parmi celles et ceux qui en déclarent un.
vote <- as_factor(d$cps25_votechoice)
pop <- data.frame(
  decide = !is.na(vote) & as.numeric(vote) != 7,
  cons = as.numeric(!is.na(vote) & as.numeric(vote) == 2),
  prov = as.character(as_factor(d$cps25_province)),
  edu = as.numeric(d$cps25_education),
  age = as.numeric(d$cps25_age_in_years)
)
N <- 1000
part_cons <- function(x) sum(x$cons) / sum(x$decide)
VRAI <- part_cons(pop)

tirer <- function(sous, n = N) sous[sample(nrow(sous), n), ]
part <- function(sous, graine) { set.seed(graine); part_cons(tirer(sous)) }
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
# Un sondage : sa part conservatrice, sa marge d'erreur (1,96 × racine(p(1 − p)/n),
# n = celles et ceux qui déclarent un vote), et s'il attrape la vraie réponse.
sonder <- function(x) {
  p <- part_cons(x); marge <- 1.96 * sqrt(p * (1 - p) / sum(x$decide))
  list(p = round(p, 4), marge = round(marge, 4), couvre = abs(p - VRAI) <= marge, declares = sum(x$decide))
}
# NOTRE sondage au hasard : 1 000 personnes, parmi tout le monde. Le même
# sondage revient à « La marge d'erreur » et dans le journal de « 19 fois sur 20 ».
set.seed(62); notre <- sonder(tirer(pop))
HASARD <- list(part = notre$p, declares = notre$declares, marge = notre$marge)

# Recommencer 1 000 fois : au hasard dans tout le monde, puis seulement au
# Québec. Effectifs par tranche d'un demi-point, de 10 % à 45 %.
bornes <- seq(0.10, 0.45, by = 0.005)
# Un epsilon : 29 personnes sur 100 donne 0,29, que cut() lirait 0,2899…
compte <- function(x, b = bornes) as.integer(table(cut(x + 1e-9, b, right = FALSE)))
set.seed(63); mille_h <- replicate(1000, part_cons(tirer(pop)))
qc <- groupes$quebec$sous
set.seed(64); mille_q <- replicate(1000, part_cons(tirer(qc)))
# dedans35 : combien des 1 000 sondages tombent à ± HASARD.marge (la marge de
# notre sondage, arrondie comme à l'écran) de la vraie réponse.
MILLE <- list(bornes = bornes,
              hasard = list(effectifs = compte(mille_h), moyenne = mean(mille_h), ecartType = sd(mille_h),
                            dedans35 = sum(abs(mille_h - VRAI) <= HASARD$marge)),
              quebec = list(effectifs = compte(mille_q), moyenne = mean(mille_q), ecartType = sd(mille_q)))

# Et si le budget changeait : 1 000 sondages de 100, de 1 000 et de 4 000
# personnes. Axe large, de 0 à 70 %, par demi-point : avec 100 personnes, les
# parts s'étalent loin; aucune n'est ramenée dans la dernière tranche.
bornes_t <- seq(0, 0.70, by = 0.005)
TAILLES <- list(bornes = bornes_t, rangees = lapply(c(100, 1000, 4000), function(n) {
  set.seed(65); m <- replicate(1000, part_cons(tirer(pop, n)))
  stopifnot(min(m) >= 0, max(m) < 0.70)
  list(n = n, effectifs = compte(m, bornes_t), ecartType = sd(m), min = min(m), max = max(m))
}))

# Vingt sondages de 1 000 au hasard, chacun avec sa marge d'erreur. Le premier
# est NOTRE sondage (graine 62, le même que HASARD). Les 19 autres viennent
# d'une graine choisie, pas tirée : la première à partir de 66 où exactement
# un des 20 rate la vraie réponse (le cas typique du « 19 fois sur 20 »).
stopifnot(notre$couvre)
sans_n <- function(x) x[c("p", "marge", "couvre")]
graine <- 66
repeat {
  set.seed(graine); autres <- lapply(1:19, function(i) sonder(tirer(pop)))
  if (sum(!sapply(autres, `[[`, "couvre")) == 1) break
  graine <- graine + 1
}
SONDAGES <- list(graine = graine, sondages = lapply(c(list(notre), autres), sans_n))

BUDGET <- list(population = nrow(pop), declares = sum(pop$decide), vrai = round(VRAI, 4), n = N)

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance5_budget.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s, sans pondération. Les parts se",
  "   calculent parmi celles et ceux qui déclarent un vote, dans chaque sondage.",
  "   La part du vote conservateur, estimée avec un budget de 1 000 personnes. */",
  "",
  "/* La population d'exercice, la vraie réponse (part conservatrice), la taille du budget. */",
  paste0("export const BUDGET = ", J(BUDGET), ";"),
  "/* Quatre sondages faciles de 1 000 : la part conservatrice dans chacun. */",
  paste0("export const FACILES = ", J(FACILES), ";"),
  "/* Notre sondage au hasard : 1 000 personnes, et sa marge d'erreur (1,96 × racine(p(1 − p)/n)). */",
  paste0("export const HASARD = ", J(HASARD), ";"),
  "/* 1 000 sondages au hasard, puis 1 000 au Québec : effectifs par demi-point de %.",
  "   dedans35 : combien tombent à ± HASARD.marge de la vraie réponse. */",
  paste0("export const MILLE = ", J(MILLE), ";"),
  "/* 1 000 sondages de 100, de 1 000 et de 4 000 personnes, par demi-point de 0 à 70 %. */",
  paste0("export const TAILLES = ", J(TAILLES), ";"),
  "/* Vingt sondages de 1 000 au hasard, avec leur marge. Le premier est notre sondage",
  "   (HASARD); un seul des 20 rate (graine choisie pour les 19 autres). */",
  paste0("export const SONDAGES = ", J(SONDAGES), ";")
), file.path(ici, "..", "src", "lib", "data", "seance5_budget.js"))
cat("ok\n")
