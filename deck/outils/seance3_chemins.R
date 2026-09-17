#!/usr/bin/env Rscript
# Séance 3, retour sur les chemins : les sorties de console des diapositives
# « C'est quoi, un chemin ? ». Rien n'est tapé à la main.
#
# Le script bâtit un bac à sable qui a exactement la forme du dossier montré à
# la séance 2 (Users/ral/Documents/pol2000, avec data/, R/ et resultats/),
# y dépose un vrai extrait de l'Étude électorale canadienne 2025, puis lance
# une VRAIE session R interactive dans ce dossier et en découpe la
# transcription. Le message d'erreur est donc celui que R affiche dans la
# console, sans les lignes « Calls: » et « Execution halted » propres à Rscript.
#
# Seule transformation : le préfixe du dossier temporaire est retiré des
# chemins affichés, pour que getwd() montre /Users/ral/... et non
# /tmp/RtmpXXXX/Users/ral/... Tout le reste est la sortie brute.
#
# HOME pointe vers le Users/ral du bac à sable, pour que « ~ » s'y résolve :
# read.csv("~/Downloads/data.csv") lit donc bien la copie du bac à sable.
#
# Usage :
#   CES2025_RDS=/chemin/vers/ces2025.rds Rscript outils/seance3_chemins.R
# Écrit : src/lib/data/seance3_chemins.js

suppressPackageStartupMessages(library(jsonlite))

rds <- Sys.getenv("CES2025_RDS")
if (!nzchar(rds) || !file.exists(rds)) stop("CES2025_RDS doit pointer vers le .rds de l'ÉÉC 2025.")
ces <- readRDS(rds)

# --- Le bac à sable -------------------------------------------------------
racine <- normalizePath(tempfile("bac"), mustWork = FALSE)
maison <- file.path(racine, "Users", "ral")
projet <- file.path(maison, "Documents", "pol2000")
for (d in c("data", "R", "resultats")) dir.create(file.path(projet, d), recursive = TRUE)
dir.create(file.path(maison, "Downloads"), recursive = TRUE)
racine <- normalizePath(racine)
maison <- normalizePath(maison)
projet <- normalizePath(projet)

# Un extrait réel : l'âge et l'intérêt pour la politique, noms courts.
extrait <- data.frame(
  age = as.numeric(ces$cps25_age_in_years),
  interet = as.numeric(ces$cps25_interest_gen_1)
)
write.csv(extrait, file.path(projet, "data", "data.csv"), row.names = FALSE)
# La même chose, restée dans les téléchargements : le cas que tout le monde vit.
write.csv(extrait, file.path(maison, "Downloads", "data.csv"), row.names = FALSE)
file.create(file.path(projet, "data", "codebook.pdf"))
file.create(file.path(projet, "R", "seance3.R"))
file.create(file.path(projet, "plan-de-cours.pdf"))

# --- La session, groupe par groupe ----------------------------------------
GROUPES <- list(
  ou = c(
    'getwd()',
    'list.files()',
    'list.files("data")'
  ),
  charger = c(
    'df <- read.csv("data/data.csv")',
    'head(df, 3)'
  ),
  ailleurs = c(
    'file.exists("~/Downloads/data.csv")',
    'df <- read.csv("~/Downloads/data.csv")',
    'nrow(df)'
  ),
  sauver = c(
    'write.csv(df, "resultats/data_propre.csv", row.names = FALSE)',
    'saveRDS(df, "data/data.rds")',
    'list.files("resultats")'
  ),
  graphique = c(
    'library(ggplot2)',
    'ggplot(df, aes(x = age)) + geom_histogram(binwidth = 5)',
    'ggsave("resultats/age.png")',
    'list.files("resultats")'
  ),
  erreur = c(
    'df <- read.csv("data.csv")',
    'file.exists("data.csv")',
    'file.exists("data/data.csv")'
  )
)
commandes <- unlist(GROUPES, use.names = FALSE)

session <- file.path(racine, "session.R")
writeLines(c("options(width = 100)", commandes), session)

# Une vraie console : --interactive, l'entrée vient du fichier. En mode
# interactif, une erreur n'arrête pas la session et s'affiche comme à l'écran.
# system2 hérite du dossier courant : on se place dans le projet, comme
# Positron le fait quand on y ouvre le dossier pol2000.
vieux <- setwd(projet)
transcription <- system2(
  file.path(R.home("bin"), "R"),
  c("--interactive", "--no-save", "--no-restore", "--quiet"),
  stdin = session, stdout = TRUE, stderr = TRUE,
  # HOME : pour « ~ ». R_LIBS : ggplot2 vit dans la bibliothèque de l'usager
  # réel, que le faux HOME ferait perdre de vue.
  env = c(paste0("HOME=", maison), paste0("R_LIBS=", paste(.libPaths(), collapse = ":")))
)
setwd(vieux)

# --- Découper la transcription en paires { in, out } ----------------------
transcription <- gsub(racine, "", transcription, fixed = TRUE)
debuts <- which(startsWith(transcription, "> "))
# Par POSITION, pas par nom : la même commande peut revenir deux fois
# (list.files("resultats") avant et après le graphique) et ne donne pas la
# même chose.
entrees <- character(0)
sorties <- character(0)
for (k in seq_along(debuts)) {
  i <- debuts[k]
  fin <- if (k < length(debuts)) debuts[k + 1] - 1 else length(transcription)
  sortie <- if (fin > i) transcription[(i + 1):fin] else character(0)
  sortie <- sortie[!(sortie %in% c(">", "> "))]
  entrees <- c(entrees, sub("^> ", "", transcription[i]))
  sorties <- c(sorties, paste(sortie, collapse = "\n"))
}
# La première ligne de la session est options(width = 100) : on l'écarte.
# La dernière invite « > », à la fin de l'entrée, se lit comme une commande
# vide : on l'écarte aussi.
garde <- entrees != "options(width = 100)" & nzchar(trimws(entrees))
entrees <- entrees[garde]
sorties <- sorties[garde]
entrees <- trimws(enc2utf8(as.character(entrees)))
attendu <- trimws(enc2utf8(as.character(commandes)))
if (length(entrees) != length(attendu) || any(entrees != attendu)) {
  ecarts <- which(entrees[seq_along(attendu)] != attendu)
  stop("La transcription ne suit pas la session (", length(entrees), " lues, ",
       length(attendu), " attendues). Écarts aux positions : ", paste(ecarts, collapse = ", "),
       "\nlu      : ", paste(sprintf("[%s]", entrees[ecarts]), collapse = " "),
       "\nattendu : ", paste(sprintf("[%s]", attendu[ecarts]), collapse = " "))
}

consoles <- list()
curseur <- 0
for (g in names(GROUPES)) {
  idx <- curseur + seq_along(GROUPES[[g]])
  consoles[[g]] <- lapply(idx, function(j) list(`in` = entrees[j], out = sorties[j], note = ""))
  curseur <- max(idx)
}

# Ce que le dossier contient une fois la session finie : les fichiers que les
# commandes ont fait naître (la figure les fait apparaître un à un).
apres <- list(
  data = sort(list.files(file.path(projet, "data"))),
  resultats = sort(list.files(file.path(projet, "resultats")))
)
stopifnot("age.png" %in% apres$resultats, "data_propre.csv" %in% apres$resultats, "data.rds" %in% apres$data)

res <- list(
  r = R.version.string,
  dossier = sub(racine, "", projet, fixed = TRUE),
  n = nrow(extrait),
  consoles = consoles,
  apres = apres
)

cible <- file.path("src", "lib", "data", "seance3_chemins.js")
writeLines(c(
  "// GÉNÉRÉ par outils/seance3_chemins.R : ne pas modifier à la main.",
  "// Transcription d'une vraie session R interactive, lancée dans un bac à",
  "// sable de la forme Users/ral/Documents/pol2000. Seul le préfixe du",
  "// dossier temporaire est retiré des chemins affichés.",
  paste0("export const CHEMINS = ", toJSON(res, auto_unbox = TRUE, pretty = TRUE), ";")
), cible)

unlink(racine, recursive = TRUE)
cat("écrit :", cible, "\n")
