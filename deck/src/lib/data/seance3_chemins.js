// GÉNÉRÉ par outils/seance3_chemins.R : ne pas modifier à la main.
// Transcription d'une vraie session R interactive, lancée dans un bac à
// sable de la forme Users/camille/Documents/pol2000. Seul le préfixe du
// dossier temporaire est retiré des chemins affichés.
export const CHEMINS = {
  "r": "R version 4.6.1 (2026-06-24)",
  "dossier": "/Users/camille/Documents/pol2000",
  "n": 20180,
  "consoles": {
    "ou": [
      {
        "in": "getwd()",
        "out": "[1] \"/Users/camille/Documents/pol2000\"",
        "note": ""
      },
      {
        "in": "list.files()",
        "out": "[1] \"data\"              \"plan-de-cours.pdf\" \"R\"                 \"resultats\"        ",
        "note": ""
      },
      {
        "in": "list.files(\"data\")",
        "out": "[1] \"ces2025.csv\"  \"codebook.pdf\"",
        "note": ""
      }
    ],
    "charger": [
      {
        "in": "df <- read.csv(\"data/ces2025.csv\")",
        "out": "",
        "note": ""
      },
      {
        "in": "head(df, 3)",
        "out": "  age interet\n1  69       8\n2  61       8\n3  54       3",
        "note": ""
      }
    ],
    "sauver": [
      {
        "in": "write.csv(df, \"resultats/ces_propre.csv\", row.names = FALSE)",
        "out": "",
        "note": ""
      },
      {
        "in": "saveRDS(df, \"data/ces2025.rds\")",
        "out": "",
        "note": ""
      },
      {
        "in": "list.files(\"resultats\")",
        "out": "[1] \"ces_propre.csv\"",
        "note": ""
      }
    ],
    "graphique": [
      {
        "in": "library(ggplot2)",
        "out": "",
        "note": ""
      },
      {
        "in": "ggplot(df, aes(x = age)) + geom_histogram(binwidth = 5)",
        "out": "",
        "note": ""
      },
      {
        "in": "ggsave(\"resultats/age.png\")",
        "out": "Saving 6.54 x 10.8 in image",
        "note": ""
      },
      {
        "in": "list.files(\"resultats\")",
        "out": "[1] \"age.png\"        \"ces_propre.csv\"",
        "note": ""
      }
    ],
    "erreur": [
      {
        "in": "df <- read.csv(\"ces2025.csv\")",
        "out": "Error in file(file, \"rt\") : cannot open the connection\nIn addition: Warning message:\nIn file(file, \"rt\") :\n  cannot open file 'ces2025.csv': No such file or directory",
        "note": ""
      },
      {
        "in": "file.exists(\"ces2025.csv\")",
        "out": "[1] FALSE",
        "note": ""
      },
      {
        "in": "file.exists(\"data/ces2025.csv\")",
        "out": "[1] TRUE",
        "note": ""
      }
    ]
  },
  "apres": {
    "data": ["ces2025.csv", "ces2025.rds", "codebook.pdf"],
    "resultats": ["age.png", "ces_propre.csv"]
  }
};
