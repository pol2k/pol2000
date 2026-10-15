# Faire un beau tableau de régression avec modelsummary (séance 7, après
# « Lire un tableau en 4 questions »). Écrit src/lib/data/seance7_ms.js (le
# code, tel que la salle le tapera) et static/img/s7-ms-*.png (les vrais
# tableaux, rendus par modelsummary lui-même avec output = "….png", et une
# page du vrai fichier .docx, ouverte par LibreOffice). Depuis deck/ :
#
#   CES2025_RDS=/tmp/ces2025.rds CHROMOTE_CHROME=/usr/sbin/chromium Rscript outils/seance7_ms.R
#
# Il faut modelsummary (2.6.0 ici), pandoc (le paquet R et le programme),
# webshot2 et Chrome ou Chromium (pour le .png), LibreOffice (soffice),
# pdftoppm et ImageMagick (magick) pour l'aperçu du .docx, et le paquet png.
#
# Le principe : chaque bout de code affiché est une chaîne, et c'est CETTE
# chaîne qui est exécutée (eval(parse())). Pour l'image, on ajoute seulement
# output = "<fichier>.png" à l'appel : le tableau est celui que la salle
# obtient. Rien n'est retapé à la main.
#
# Les données : notre sondage, refait exactement comme dans
# outils/seance7_data.R (même préparation, set.seed(62), 1 000 tiré.e.s
# parmi les 20 180). modele = interet ~ scolarite, modele2 = le modèle à
# plusieurs variables (MULTIPLE). Les deux sont vérifiés contre seance7.js.
suppressPackageStartupMessages({ library(haven); library(modelsummary) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
cache <- Sys.getenv("CES2025_RDS")
d <- if (nzchar(cache) && file.exists(cache)) readRDS(cache) else ces::get_ces("2025")
if (!nzchar(Sys.getenv("CHROMOTE_CHROME"))) Sys.setenv(CHROMOTE_CHROME = "/usr/sbin/chromium")
IMG <- normalizePath(file.path(ici, "..", "static", "img"))

# ---- Les données, comme dans outils/seance7_data.R.
prov <- as.character(as_factor(d$cps25_province))
ans <- as.numeric(d$cps25_age_in_years)
int <- as.numeric(d$cps25_interest_gen_1); int[!is.na(int) & int < 0] <- NA
edu <- as.numeric(d$cps25_education); edu[!(edu %in% 1:11)] <- NA
niveau <- cut(edu, c(0, 4, 5, 7, 9, 11), labels = FALSE)
genre <- as.numeric(d$cps25_genderid)
rev <- as.numeric(d$cps25_income); rev[!(rev %in% 1:8)] <- NA
ces <- data.frame(
  interet = int / 10,
  scolarite = (niveau - 1) / 4,
  age = (ans - 18) / (max(ans, na.rm = TRUE) - 18),
  femme = ifelse(genre %in% c(1, 2), as.numeric(genre == 2), NA),
  revenu = (rev - 1) / 7,
  quebec = as.numeric(grepl("Quebec", prov))
)
stopifnot(nrow(ces) == 20180)
set.seed(62)
ces1000 <- ces[sample(nrow(ces), 1000), ]
modele <- lm(interet ~ scolarite, data = ces1000)
modele2 <- lm(interet ~ scolarite + age + femme + revenu + quebec, data = ces1000)

# Vérification contre seance7.js : mêmes coefficients, même N.
js <- readLines(file.path(ici, "..", "src", "lib", "data", "seance7.js"))
lire <- function(nom) jsonlite::fromJSON(sub(sprintf("^export const %s = (.*);$", nom), "\\1",
  grep(sprintf("^export const %s = ", nom), js, value = TRUE)))
notre <- lire("NOTRE"); multiple <- lire("MULTIPLE")
stopifnot(nobs(modele) == notre$n_modele, nobs(modele2) == multiple$n_modele,
          all(abs(round(coef(modele), 4) - notre$coefs$b) < 1e-9),
          all(abs(round(coef(modele2), 4) - multiple$coefs$b) < 1e-9))

# ---- Exécuter un bout de code tel quel, et rendre la dernière ligne en .png.
executer <- function(code) eval(parse(text = code), envir = globalenv())
rendre_png <- function(code, fichier) {
  ex <- parse(text = code)
  if (length(ex) > 1) for (e in ex[-length(ex)]) eval(e, envir = globalenv())
  appel <- ex[[length(ex)]]
  stopifnot(identical(appel[[1]], as.name("modelsummary")))
  chemin <- file.path(IMG, fichier)
  appel$output <- chemin
  eval(appel, envir = globalenv())
  taille <- file.size(chemin)
  stopifnot(taille < 300 * 1024)
  dim <- dim(png::readPNG(chemin))
  list(img = fichier, l = dim[2], h = dim[1], ko = round(taille / 1024))
}

# Les lignes de texte d'une image de tableau : des bandes de pixels foncés,
# séparées par du blanc. Les filets (traits pleins sur presque toute la
# largeur) ne comptent pas. Renvoie le haut et le bas de chaque bande, en
# fraction de la hauteur de l'image.
bandes <- function(fichier) {
  a <- png::readPNG(file.path(IMG, fichier))
  lum <- if (length(dim(a)) == 3) (a[, , 1] + a[, , 2] + a[, , 3]) / 3 else a
  if (length(dim(a)) == 3 && dim(a)[3] == 4) lum[a[, , 4] < 0.1] <- 1
  fonce <- rowMeans(lum < 0.5)
  texte <- fonce > 0 & fonce < 0.5
  r <- rle(texte); fin <- cumsum(r$lengths); debut <- fin - r$lengths + 1
  k <- which(r$values)
  data.frame(haut = round((debut[k] - 1) / nrow(lum), 4), bas = round(fin[k] / nrow(lum), 4))
}

# ---- 1. Une ligne : ce que modelsummary donne par défaut.
options(OutDec = ".")
DEFAUT <- list(code = "library(modelsummary)\nmodelsummary(modele, stars = TRUE)")
DEFAUT <- c(DEFAUT, rendre_png(DEFAUT$code, "s7-ms-defaut.png"))
# Les étiquettes des lignes, dans l'ordre de l'image : l'en-tête, les
# coefficients (et leur erreur type), les statistiques d'ajustement, la note.
df <- modelsummary(modele, stars = TRUE, output = "data.frame")
etiq <- c("(1)", ifelse(df$statistic == "std.error", "", df$term), "note")
b <- bandes("s7-ms-defaut.png")
stopifnot(nrow(b) == length(etiq))
DEFAUT$lignes <- lapply(seq_len(nrow(b)), function(i) list(etiquette = etiq[i], haut = b$haut[i], bas = b$bas[i]))

# ---- 2. Le rendre beau, un argument à la fois. Chaque étape est le code
# complet. La virgule décimale (options(OutDec)) vaut pour toute la session.
BEAU <- list(
  "modelsummary(modele, stars = TRUE)",
  paste0("modelsummary(modele, stars = TRUE,\n",
         "  coef_rename = c(\"(Intercept)\" = \"Constante\",\n",
         "                  \"scolarite\" = \"Scolarité (0 à 1)\"))"),
  paste0("modelsummary(modele, stars = TRUE,\n",
         "  coef_rename = c(\"(Intercept)\" = \"Constante\",\n",
         "                  \"scolarite\" = \"Scolarité (0 à 1)\"),\n",
         "  gof_map = c(\"nobs\", \"r.squared\"))"),
  paste0("options(OutDec = \",\")\n",
         "modelsummary(modele, stars = TRUE,\n",
         "  coef_rename = c(\"(Intercept)\" = \"Constante\",\n",
         "                  \"scolarite\" = \"Scolarité (0 à 1)\"),\n",
         "  gof_map = c(\"nobs\", \"r.squared\"))"),
  paste0("options(OutDec = \",\")\n",
         "modelsummary(modele, stars = TRUE,\n",
         "  coef_rename = c(\"(Intercept)\" = \"Constante\",\n",
         "                  \"scolarite\" = \"Scolarité (0 à 1)\"),\n",
         "  gof_map = c(\"nobs\", \"r.squared\"),\n",
         "  title = \"Intérêt pour la politique selon la scolarité\",\n",
         "  notes = \"CES 2025, 1000 personnes tirées au hasard.\")")
)
BEAU <- lapply(seq_along(BEAU), function(i) {
  options(OutDec = ".")
  c(list(code = BEAU[[i]]), rendre_png(BEAU[[i]], sprintf("s7-ms-beau-%d.png", i - 1)))
})

# ---- 3. Deux modèles côte à côte : une liste nommée, et les noms une fois pour toutes.
options(OutDec = ",")
DEUX <- list(code = paste0(
  "noms <- c(\"(Intercept)\" = \"Constante\",\n",
  "  \"scolarite\" = \"Scolarité (0 à 1)\", \"age\" = \"Âge (0 à 1)\",\n",
  "  \"femme\" = \"Femme\", \"revenu\" = \"Revenu (0 à 1)\",\n",
  "  \"quebec\" = \"Québec\")\n",
  "modeles <- list(\"Modèle 1\" = modele, \"Modèle 2\" = modele2)\n",
  "modelsummary(modeles, stars = TRUE, coef_rename = noms,\n",
  "  gof_map = c(\"nobs\", \"r.squared\"))"))
DEUX <- c(DEUX, rendre_png(DEUX$code, "s7-ms-deux.png"))

# ---- 4. L'exporter : le vrai .docx (aperçu de sa page par LibreOffice) et le vrai .png.
# Une seule fois. Le paquet pandoc ne contient pas le programme pandoc : il
# le trouve (RStudio, système) ou l'installe avec pandoc_install().
INSTALLER <- paste0("install.packages(c(\"modelsummary\", \"pandoc\"))\n",
                    "pandoc::pandoc_install()")
# Pour le .png : webshot2, qui pilote Google Chrome (ou Chromium).
INSTALLER_PNG <- "install.packages(\"webshot2\")"
# Le modèle est nommé (une liste) : sans nom, l'en-tête « (1) » disparaît du
# .docx (pandoc le lit comme le début d'une liste numérotée).
CODE_DOCX <- paste0(
  "modelsummary(list(\"Modèle 1\" = modele), stars = TRUE,\n",
  "  coef_rename = noms, gof_map = c(\"nobs\", \"r.squared\"),\n",
  "  output = \"tableau.docx\")")
CODE_PNG <- sub("tableau.docx", "tableau.png", CODE_DOCX, fixed = TRUE)
tmp <- tempfile("ms-"); dir.create(tmp); ancien <- setwd(tmp)
executer(CODE_DOCX)
executer(CODE_PNG)
stopifnot(file.exists("tableau.docx"), file.exists("tableau.png"))
system2("soffice", c("--headless", "--convert-to", "pdf", "tableau.docx"), stdout = FALSE, stderr = FALSE)
system2("pdftoppm", c("-r", "300", "-f", "1", "-l", "1", "-png", "tableau.pdf", "page"))
page <- list.files(pattern = "^page.*\\.png$")[1]
system2("magick", c(page, "-trim", "-bordercolor", "white", "-border", "40", file.path(IMG, "s7-ms-docx.png")))
file.copy("tableau.png", file.path(IMG, "s7-ms-png.png"), overwrite = TRUE)
# Ce que pandoc a fait du tableau dans Word (pour les notes de l'enseignant) :
# la légende des étoiles commence par « + », lu comme une puce de liste.
DOCX_TEXTE <- paste(system2("pandoc", c("tableau.docx", "-t", "plain"), stdout = TRUE), collapse = "\n")
setwd(ancien)
dim_png <- dim(png::readPNG(file.path(IMG, "s7-ms-png.png")))
stopifnot(file.size(file.path(IMG, "s7-ms-png.png")) < 300 * 1024)
dim_docx <- dim(png::readPNG(file.path(IMG, "s7-ms-docx.png")))
stopifnot(file.size(file.path(IMG, "s7-ms-docx.png")) < 300 * 1024)
EXPORT <- list(installer = INSTALLER, installer_png = INSTALLER_PNG, docx = CODE_DOCX, png = CODE_PNG,
               apercu = list(img = "s7-ms-docx.png", l = dim_docx[2], h = dim_docx[1]),
               image = list(img = "s7-ms-png.png", l = dim_png[2], h = dim_png[1]),
               docx_texte = DOCX_TEXTE,
               version = as.character(packageVersion("modelsummary")))

J <- function(x) jsonlite::toJSON(x, auto_unbox = TRUE, na = "null", digits = NA)
writeLines(c(
  "/* Généré par outils/seance7_ms.R. Le code est exactement celui qui a produit",
  "   les images static/img/s7-ms-*.png (modelsummary, output = \"….png\").",
  "   Données : notre sondage de la CES 2025 (1 000, graine 62). Ne pas modifier à la main. */",
  "",
  "/* Une ligne : le tableau par défaut. lignes = les bandes de texte de l'image",
  "   (haut, bas en fraction de la hauteur), pour les surligner. */",
  paste0("export const MS_DEFAUT = ", J(DEFAUT), ";"),
  "/* Le rendre beau : le code complet à chaque étape, et son tableau. */",
  paste0("export const MS_BEAU = ", J(BEAU), ";"),
  "/* Deux modèles côte à côte. */",
  paste0("export const MS_DEUX = ", J(DEUX), ";"),
  "/* L'exporter : l'installation (une fois), le .docx (aperçu de sa page) et le .png. */",
  paste0("export const MS_EXPORT = ", J(EXPORT), ";")
), file.path(ici, "..", "src", "lib", "data", "seance7_ms.js"))

cat("défaut :", DEFAUT$l, "x", DEFAUT$h, DEFAUT$ko, "Ko,", nrow(b), "bandes\n")
for (x in BEAU) cat(x$img, x$l, "x", x$h, x$ko, "Ko\n")
cat(DEUX$img, DEUX$l, "x", DEUX$h, DEUX$ko, "Ko | docx :", dim_docx[2], "x", dim_docx[1], "\n")
