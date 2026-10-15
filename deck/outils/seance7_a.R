# Séance 7, partie A (le travail de mi-session, diapo « La question fait la
# variable ») : combien de personnes donnent chaque réponse aux deux questions
# de l'exemple fil rouge. Écrit src/lib/data/seance7_a.js. Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds Rscript outils/seance7_a.R
#
# Sans CES2025_RDS, ces::get_ces("2025"). Aucune pondération, aucun tirage.
#   cps25_education (codebook p. 41) : codes 1 à 11, 12 = « Ne sais pas /
#     Préfère ne pas répondre ». Sert à montrer pourquoi on regroupe : les
#     codes 1 à 3 ne comptent qu'une poignée de personnes sur 20 180.
#   cps25_interest_gen_1 (p. 45) : 0 à 10, -99 = « Je ne sais pas / Préfère
#     ne pas répondre ».
# Vérifie au passage que les effectifs regroupés concordent avec POP dans
# seance7.js (outils/seance7_data.R).
suppressPackageStartupMessages({ library(jsonlite) })

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")

edu <- as.numeric(d$cps25_education)
int <- as.numeric(d$cps25_interest_gen_1)
stopifnot(nrow(d) == 20180)

par_code <- sapply(1:12, function(k) sum(edu == k, na.rm = TRUE))
SCOL_CODES <- list(
  n = nrow(d),
  effectifs = par_code[1:11],          # codes 1 à 11
  ne_sait_pas = par_code[12],          # code 12
  codes_1_a_3 = sum(par_code[1:3])
)
INTERET_NSP <- sum(int == -99, na.rm = TRUE)

# Contrôle : les cinq niveaux regroupés, parmi qui a répondu aux deux questions,
# doivent redonner les n de POP.moyennes.
s7 <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"), encoding = "UTF-8")
pop <- fromJSON(sub("^export const POP = (.*);$", "\\1", grep("^export const POP = ", s7, value = TRUE)))
ok <- edu %in% 1:11 & !is.na(int) & int >= 0
niv <- cut(edu[ok], c(0, 4, 5, 7, 9, 11))
stopifnot(all(as.vector(table(niv)) == pop$moyennes$n))

js <- c(
  "/* Généré par outils/seance7_a.R. Source : Étude électorale canadienne 2025",
  "   (ces::get_ces(\"2025\")), les 20 180 répondant.e.s, sans pondération.",
  "   Effectifs bruts des réponses à cps25_education (codes 1 à 11, et 12 =",
  "   ne sait pas) et nombre de « je ne sais pas » (-99) à cps25_interest_gen_1.",
  "   Ne pas modifier à la main. */",
  "",
  paste0("export const SCOL_CODES = ", toJSON(SCOL_CODES, auto_unbox = TRUE), ";"),
  paste0("export const INTERET_NSP = ", INTERET_NSP, ";")
)
writeLines(js, file.path(ici, "..", "src", "lib", "data", "seance7_a.js"), useBytes = TRUE)
cat("codes :", par_code, "| 1 à 3 :", SCOL_CODES$codes_1_a_3, "| intérêt NSP :", INTERET_NSP, "\n")
