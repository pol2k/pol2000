# Exporte ce que la séance 9 montre de la question ouverte cps25_imp_iss de
# l'Étude électorale canadienne 2025 (« l'enjeu le plus important ») vers les
# quatre démos EnjeuxMur, EnjeuxDictionnaire, EnjeuxClassifieur et
# EnjeuxExtractions (src/lib/deck/demos/enjeux-*.json).
#
#   CES2025_DTA=~/ces2025_project/ces2025.dta Rscript outils/seance9_enjeux.R
#
# 1. Tire 300 réponses non vides au hasard (set.seed(2025)).
# 2. L'ancienne façon : un dictionnaire de mots-clés bilingue, appliqué ici.
# 3. La nouvelle façon : les catégories attribuées par Claude (Anthropic) dans
#    Claude Code, le 5 novembre 2026, en suivant CONSIGNE ci-dessous. Elles
#    sont lues dans seance9_enjeux_claude.csv (une ligne par réponse) et
#    seance9_enjeux_claude_extractions.json (six consignes, une réponse).
#    Ce ne sont pas des appels d'API : les 300 réponses ont été classées dans
#    une même session. Le script vérifie que chaque texte correspond à la
#    donnée et que deux réponses identiques ont reçu la même catégorie.
# Tous les comptes affichés sur les diapositives sortent de ce script.
suppressPackageStartupMessages({ library(haven); library(stringi); library(jsonlite) })
options(width = 100)

ici <- dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))
ici <- normalizePath(ici)
DEMOS <- normalizePath(file.path(ici, "..", "src", "lib", "deck", "demos"))
rds <- Sys.getenv("CES2025_RDS"); dta <- Sys.getenv("CES2025_DTA")
d <- if (nzchar(rds) && file.exists(rds)) readRDS(rds) else
     if (nzchar(dta) && file.exists(dta)) read_dta(dta, col_select = c(cps25_imp_iss, cps25_UserLanguage)) else
     ces::get_ces("2025")

# ---- 1. L'échantillon -------------------------------------------------------
x <- trimws(as.character(zap_labels(d$cps25_imp_iss)))
ok <- which(!is.na(x) & !(x %in% c("", "-99")))
set.seed(2025)
s <- sort(sample(ok, 300))
donnees <- data.frame(ligne = s, langue = d$cps25_UserLanguage[s], cps25_imp_iss = x[s],
                      stringsAsFactors = FALSE)
cat("Réponses non vides :", length(ok), "sur", nrow(d), "\n")
print(table(langue = d$cps25_UserLanguage[ok]))

# ---- Les douze catégories (ordre de la consigne) ---------------------------
CATS <- c(intl = "Affaires internationales et défense", econ = "Économie et travail",
          crime = "Loi et crime", gouv = "Gouvernements et gouvernance",
          sante = "Santé et politiques sociales", terres = "Terres publiques et agriculture",
          env = "Environnement et énergie", tech = "Technologie", immig = "Immigration",
          droits = "Droits, libertés, minorités et discrimination",
          culture = "Culture et nationalisme", educ = "Éducation")
AUCUNE <- "Aucune"

# ---- 2. L'ancienne façon : le dictionnaire ---------------------------------
# Écrit d'après les définitions de la consigne (les mêmes règles que celles
# données au modèle), en anglais et en français, sans accents ni majuscules.
# « mot* » attrape tout mot qui commence par « mot » ; sans étoile, le mot
# exact. Une entrée de plusieurs mots doit apparaître dans cet ordre.
dictionnaire <- list(
  intl = c("trump*", "tarif*", "souverain*", "americ*", "usa", "u s", "united states",
           "etats unis", "sovereign*", "annex*", "51*", "trade*", "commerc*", "foreign*",
           "etranger*", "international*", "defen*", "militar*", "militaire*", "armee*", "army",
           "war", "wars", "guerre*", "nato", "otan", "ukrain*", "russi*", "china", "chine",
           "israel*", "gaza", "palestin*", "allie*", "ally", "alliance*", "imperialis*",
           "diploma*", "national secur*", "securite nationale"),
  econ = c("econom*", "inflation*", "cost of liv*", "living cost*", "cout de la vie",
           "couts de la vie", "afford*", "price*", "prix", "tax*", "impot*", "debt*", "dette*",
           "deficit*", "budget*", "spending", "depense*", "job*", "emploi*", "employ*",
           "unemploy*", "chomage", "wage*", "salair*", "salary", "pay", "income*", "revenu*",
           "grocer*", "epicerie*", "interest rate*", "taux d interet", "business*",
           "entreprise*", "industr*", "recession*", "growth", "croissance", "financ*",
           "fiscal*", "money", "argent", "worker*", "labour", "labor", "travail*", "invest*",
           "productiv*"),
  crime = c("crim*", "drug*", "drogue*", "fentanyl", "police", "policing", "gun", "guns",
            "firearm*", "arme a feu", "armes a feu", "justice", "bail", "violen*", "safety",
            "securite", "security", "securite publique", "prison*", "jail*", "gang", "gangs",
            "theft", "law and order", "loi et ordre", "offend*", "terroris*", "fraud*"),
  gouv = c("govern*", "gouvern*", "corrupt*", "transparen*", "accountab*", "democra*",
           "election*", "electoral*", "elire", "leader*", "chef*", "honest*", "honnetete",
           "integrit*", "lie", "lies", "lying", "mensonge*", "trust", "confiance", "liberal*",
           "conservat*", "ndp", "npd", "n d p", "bloc", "party", "parties", "parti", "partis",
           "trudeau", "carney", "poilievre", "singh", "politici*", "parliament*", "parlement*",
           "senat*", "bureaucra*", "scrutin", "ballot*", "first past the post",
           "proportional*", "proportionnel*", "provinc*", "federalis*", "equalization",
           "perequation", "jurisdiction*", "crook*", "populis*", "wast*", "gaspill*"),
  sante = c("health*", "sante", "hospital*", "hopita*", "doctor*", "medecin*", "nurse*",
            "infirmi*", "medic*", "pharma*", "dental", "dentaire*", "dentist*", "mental",
            "soins", "long term care", "child care", "daycare", "garderie*", "senior*", "aine",
            "aines", "elder*", "pension*", "retire*", "retraite*", "old age", "cpp", "rrq",
            "poverty", "poor", "pauvre*", "pauvrete", "homeless*", "itineran*", "housing",
            "logement*", "loyer*", "rent", "rents", "rental*", "social", "sociale*", "sociaux",
            "welfare", "disabilit*", "handicap*", "inequalit*", "inegalit*", "redistribut*",
            "famil*"),
  terres = c("agricult*", "farm*", "fermier*", "dairy", "laitier*", "supply management",
             "gestion de l offre", "fish*", "peche*", "forest*", "foret*", "land", "lands",
             "terre", "terres", "national park*", "parcs nationaux", "rural*", "crown land*",
             "wildlife", "faune", "food security", "securite alimentaire", "water", "eau"),
  env = c("environ*", "climat*", "carbon*", "pollut*", "emission*", "energ*", "oil",
          "petrol*", "pipeline*", "gas", "gaz", "renewab*", "renouvelable*", "hydro*",
          "nuclear", "nucleaire", "fossil*", "planet*", "sustainab*", "durable*",
          "green energy", "wildfire*", "feux de foret", "natural resource*",
          "ressources naturelles", "ecolog*"),
  tech = c("technolog*", "tech", "internet", "digital*", "numerique*", "ai", "ia",
           "artificial intelligence", "intelligence artificielle", "cyber*", "telecom*",
           "broadband", "innovation*", "science*", "research*", "recherche*", "social media",
           "medias sociaux", "reseaux sociaux", "crypto*", "algorithm*", "data", "donnees"),
  immig = c("immigr*", "migra*", "refugee*", "refugi*", "asylum", "asile",
            "border*", "frontiere*", "newcomer*", "nouveaux arrivants", "foreign worker*",
            "travailleurs etrangers", "temporary foreign*", "international student*",
            "etudiants etrangers", "visa*", "citizenship", "citoyennete", "deport*",
            "population growth"),
  droits = c("right", "rights", "droit", "droits", "freedom*", "libert*", "discrimin*",
             "racis*", "minorit*", "equalit*", "egalite*", "equity", "equite", "lgbt*",
             "2slgbt*", "gay", "trans", "transgender*", "abortion*", "avortement*", "women*",
             "woman*", "femme*", "gender*", "genre", "indigenous", "autochton*",
             "first nation*", "premieres nations", "reconcil*", "free speech", "censor*",
             "censure", "privacy", "vie privee", "inclusi*", "diversit*", "antisemit*",
             "islamophob*", "charter", "charte"),
  culture = c("cultur*", "multicultur*", "nationalis*", "patriot*", "identit*", "pride",
              "fierte", "unity", "unite nationale", "national unity", "quebec*", "french",
              "francais*", "langue*", "language*", "francophon*", "anglophon*", "bilingu*",
              "separat*", "independan*", "heritage", "patrimoine*", "religio*", "laicite",
              "values", "valeurs"),
  educ = c("educat*", "school*", "ecole*", "universit*", "college*", "cegep*", "student*",
           "etudiant*", "teacher*", "enseign*", "tuition", "scolar*", "literacy",
           "alphabetisation", "apprentissage")
)
stopifnot(identical(names(dictionnaire), names(CATS)))
entrees <- do.call(rbind, lapply(names(dictionnaire), function(k)
  data.frame(categorie = unname(CATS[k]), motif = dictionnaire[[k]], stringsAsFactors = FALSE)))
stopifnot(!anyDuplicated(entrees$motif))
cat("Dictionnaire :", nrow(entrees), "mots-clés pour", length(CATS), "catégories\n")

# Un mot du texte correspond-il à un mot de l'entrée ?
pareil <- function(mot, m) if (endsWith(m, "*")) startsWith(mot, sub("\\*$", "", m)) else mot == m

# Toutes les entrées trouvées dans une liste de mots : position, mot(s), motif
# et catégorie.
chercher <- function(mots, dictionnaire) {
  mots <- mots[nzchar(mots)]
  res <- list()
  for (j in seq_len(nrow(entrees))) {
    morceaux <- strsplit(entrees$motif[j], " ")[[1]]
    k <- length(morceaux)
    for (i in seq_len(max(0, length(mots) - k + 1))) {
      if (all(mapply(pareil, mots[i:(i + k - 1)], morceaux))) {
        res[[length(res) + 1]] <- data.frame(debut = i, fin = i + k - 1,
          mot = paste(mots[i:(i + k - 1)], collapse = " "), motif = entrees$motif[j],
          categorie = entrees$categorie[j], stringsAsFactors = FALSE)
      }
    }
  }
  if (length(res)) do.call(rbind, res) else
    data.frame(debut = integer(), fin = integer(), mot = character(), motif = character(),
               categorie = character())
}

# Le geste montré sur la diapositive, ligne par ligne.
donnees$enjeu <- NA_character_
donnees$n_cats <- NA_integer_
for (i in seq_len(nrow(donnees))) {
  texte <- donnees$cps25_imp_iss[i]
  mots <- stri_trans_general(tolower(texte), "Latin-ASCII")
  mots <- strsplit(mots, "[^a-z0-9]+")[[1]]
  trouve <- chercher(mots, dictionnaire)
  cats <- unique(trouve$categorie)
  donnees$enjeu[i] <- if (length(cats) == 1) cats else NA
  donnees$n_cats[i] <- length(cats)
}
donnees$statut <- ifelse(donnees$n_cats == 1, "classée",
                         ifelse(donnees$n_cats > 1, "ambiguë", "aucun mot"))
print(table(statut = donnees$statut))

# ---- 3. La nouvelle façon : la consigne et les réponses de Claude ----------
CONSIGNE <- list(
  question = "Pour vous personnellement, quel est l'enjeu le plus important de cette élection fédérale\u202f?",
  tache = "Classe cette réponse dans une seule des 12 catégories, ou Aucune.",
  multiple = "Plusieurs enjeux\u202f: garde le premier nommé.",
  regles = list(
    c("Trump, États-Unis, tarifs, commerce extérieur, souveraineté, annexion", CATS[["intl"]]),
    c("Coût de la vie, inflation, impôts, dette, dépenses publiques, emploi", CATS[["econ"]]),
    c("Logement, pauvreté, inégalités, aînés, pensions", CATS[["sante"]]),
    c("Partis, chefs, honnêteté, démocratie, mode de scrutin, fédéralisme", CATS[["gouv"]]),
    c("Identité, fierté, unité du pays, langue", CATS[["culture"]]),
    c("Oui, rien, je ne sais pas, réponse trop vague", AUCUNE)),
  format = "Réponds en JSON\u202f: {\"categorie\": \"…\"}"
)
consigne_texte <- paste(c(
  paste0("Réponse à la question « ", CONSIGNE$question, " »."),
  CONSIGNE$tache,
  paste0("Catégories\u202f: ", paste(CATS, collapse = " · "), "."),
  CONSIGNE$multiple,
  vapply(CONSIGNE$regles, function(r) paste(r[1], "→", r[2]), ""),
  CONSIGNE$format), collapse = "\n")
cat("\n---- Consigne\n", consigne_texte, "\n----\n", sep = "")

f_claude <- file.path(ici, "seance9_enjeux_claude.csv")
if (!file.exists(f_claude)) {
  write.csv(data.frame(ligne = donnees$ligne, categorie = "", texte = donnees$cps25_imp_iss),
            f_claude, row.names = FALSE, fileEncoding = "UTF-8")
  stop("Gabarit écrit dans ", f_claude, " : remplir la colonne categorie, puis relancer.")
}
claude <- read.csv(f_claude, stringsAsFactors = FALSE, encoding = "UTF-8")
stopifnot(nrow(claude) == 300, identical(claude$ligne, donnees$ligne),
          identical(claude$texte, donnees$cps25_imp_iss),
          all(claude$categorie %in% c(CATS, AUCUNE)))
donnees$claude <- claude$categorie
# Deux réponses identiques (à la casse, aux accents et à la ponctuation près)
# doivent avoir reçu la même catégorie.
cle <- trimws(gsub("[^a-z0-9]+", " ", stri_trans_general(tolower(donnees$cps25_imp_iss), "Latin-ASCII")))
incoherent <- tapply(donnees$claude, cle, function(v) length(unique(v)) > 1)
if (any(incoherent)) stop("Catégories différentes pour : ", paste(names(incoherent)[incoherent], collapse = " | "))
cat("Réponses distinctes :", length(unique(cle)), "· toutes cohérentes\n")

distribution <- table(factor(donnees$claude, levels = c(CATS, AUCUNE)))
print(sort(distribution, decreasing = TRUE))
# Accord : la case du dictionnaire est la même que celle de Claude. Un « aucun
# mot » du dictionnaire compte comme Aucune ; une case ambiguë n'est jamais
# d'accord.
dico_case <- ifelse(donnees$statut == "classée", donnees$enjeu,
                    ifelse(donnees$statut == "aucun mot", AUCUNE, NA))
accord <- sum(!is.na(dico_case) & dico_case == donnees$claude)
accord_classees <- sum(donnees$statut == "classée" & donnees$enjeu == donnees$claude)
cat("Accord dictionnaire / Claude :", accord, "sur 300 ·",
    accord_classees, "sur", sum(donnees$statut == "classée"), "réponses classées par le dictionnaire\n")
cat("Le dictionnaire ne trouve rien, Claude trouve un enjeu :",
    sum(donnees$statut == "aucun mot" & donnees$claude != AUCUNE), "\n")

# ---- Les trois lignes animées : un échec de chaque type --------------------
# Choisies parmi les échecs mesurés ci-dessus ; le script vérifie le type.
ANIMEES <- c(faux = 327L, ambigue = 9388L, aucun = 17567L)
a <- donnees[match(ANIMEES, donnees$ligne), ]
stopifnot(a$statut[1] == "classée", a$enjeu[1] != a$claude[1],
          a$statut[2] == "ambiguë", a$statut[3] == "aucun mot", a$claude[3] != AUCUNE)
cat("\nEchecs par type : faux", sum(donnees$statut == "classée" & donnees$enjeu != donnees$claude),
    "· ambigus", sum(donnees$statut == "ambiguë"),
    "· aucun mot alors qu'il y a un enjeu", sum(donnees$statut == "aucun mot" & donnees$claude != AUCUNE), "\n")

echecs <- donnees[(donnees$statut == "classée" & donnees$enjeu != donnees$claude) |
                  (donnees$statut == "aucun mot" & donnees$claude != AUCUNE),
                  c("ligne", "cps25_imp_iss", "statut", "enjeu", "claude")]
print(echecs, row.names = FALSE)

lignes_dico <- lapply(seq_len(nrow(a)), function(i) {
  mots <- strsplit(stri_trans_general(tolower(a$cps25_imp_iss[i]), "Latin-ASCII"), "[^a-z0-9]+")[[1]]
  mots <- mots[nzchar(mots)]
  tr <- chercher(mots, dictionnaire)
  tr <- tr[order(tr$debut), ]
  list(id = as.character(a$ligne[i]), langue = a$langue[i], texte = a$cps25_imp_iss[i],
       jetons = I(mots),
       touche = lapply(seq_along(mots), function(p) {
         h <- tr[tr$debut <= p & tr$fin >= p, ]
         if (nrow(h)) list(motif = h$motif[1], categorie = h$categorie[1]) else NULL
       }),
       trouves = lapply(seq_len(nrow(tr)), function(j) as.list(tr[j, c("mot", "motif", "categorie")])),
       cats = I(unique(tr$categorie)), statut = a$statut[i],
       valeur = if (is.na(a$enjeu[i])) NULL else a$enjeu[i])
})

J <- function(x, f) writeLines(toJSON(x, auto_unbox = TRUE, pretty = TRUE, null = "null", na = "null", digits = NA),
                               file.path(DEMOS, f), useBytes = TRUE)
SOURCE <- "Étude électorale canadienne 2025 · sondage préélectoral · cps25_imp_iss"
pct <- function(n) round(100 * n / 300)

# ---- enjeux-mur.json --------------------------------------------------------
MUR <- c(1510L, 6247L, 6790L, 11407L, 8812L, 17245L)
m <- donnees[match(MUR, donnees$ligne), ]
langues <- table(d$cps25_UserLanguage[ok])
J(list(source = SOURCE, variable = "cps25_imp_iss",
       question = "Pour vous personnellement, quel est l'enjeu le plus important de cette élection fédérale\u202f?",
       total = length(ok), repondants = nrow(d),
       langues = list(en = unname(langues[["EN"]]), fr = unname(langues[["FR-CA"]])),
       exemples = lapply(seq_len(nrow(m)), function(i)
         list(ligne = m$ligne[i], langue = m$langue[i], texte = m$cps25_imp_iss[i])),
       categories = unname(CATS)), "enjeux-mur.json")

# ---- enjeux-dictionnaire.json ----------------------------------------------
n_statut <- table(factor(donnees$statut, levels = c("classée", "ambiguë", "aucun mot")))
J(list(source = SOURCE, echantillon = 300, graine = 2025,
       mots_cles = nrow(entrees),
       par_categorie = lapply(names(CATS), function(k)
         list(categorie = unname(CATS[k]), n = length(dictionnaire[[k]]),
              extrait = dictionnaire[[k]][seq_len(min(5, length(dictionnaire[[k]])))])),
       lignes = lignes_dico,
       bilan = list(classees = unname(n_statut[["classée"]]), ambigues = unname(n_statut[["ambiguë"]]),
                    aucun = unname(n_statut[["aucun mot"]]),
                    p_classees = pct(n_statut[["classée"]]), p_ambigues = pct(n_statut[["ambiguë"]]),
                    p_aucun = pct(n_statut[["aucun mot"]]))), "enjeux-dictionnaire.json")

# ---- enjeux-classifieur.json -----------------------------------------------
dist <- sort(distribution, decreasing = TRUE)
J(list(source = SOURCE, fichier = "ces2025", total = 300,
       colonnes = c("ligne", "cps25_imp_iss", "langue"),
       lignes = lapply(seq_len(nrow(a)), function(i)
         list(id = as.character(a$ligne[i]), langue = a$langue[i], texte = a$cps25_imp_iss[i],
              categorie = a$claude[i])),
       modele = "Claude (Anthropic)",
       mesure = "Claude Code, 5 novembre 2026 · les 300 réponses dans une même session, pas un appel d'API par ligne",
       consigne = CONSIGNE, consigne_texte = consigne_texte, categories = unname(CATS),
       distribution = lapply(names(dist), function(k) list(categorie = k, n = unname(dist[[k]]))),
       accord = list(n = accord, total = 300, classees = accord_classees,
                     sur = unname(n_statut[["classée"]]))), "enjeux-classifieur.json")

# ---- enjeux-extractions.json -----------------------------------------------
ex <- fromJSON(file.path(ici, "seance9_enjeux_claude_extractions.json"), simplifyVector = FALSE)
stopifnot(ex$ligne %in% donnees$ligne,
          identical(ex$texte, donnees$cps25_imp_iss[donnees$ligne == ex$ligne]),
          length(ex$taches) == 6)
for (t in ex$taches) invisible(fromJSON(t$reponse))   # chaque réponse est du JSON valide
J(c(list(source = SOURCE), ex), "enjeux-extractions.json")
cat("Écrit :", paste0("enjeux-", c("mur", "dictionnaire", "classifieur", "extractions"), ".json"), "\n")
