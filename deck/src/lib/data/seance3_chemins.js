// GÉNÉRÉ par outils/seance3_chemins.R : ne pas modifier à la main.
// Transcription d'une vraie session R interactive, lancée dans un bac à
// sable de la forme Users/ral/Documents/pol2000. Seul le préfixe du
// dossier temporaire est retiré des chemins affichés.
export const CHEMINS = {
  "r": "R version 4.6.1 (2026-06-24)",
  "dossier": "/Users/ral/Documents/pol2000",
  "n": 20180,
  "consoles": {
    "ou": [
      {
        "in": "getwd()",
        "out": "[1] \"/Users/ral/Documents/pol2000\"",
        "note": ""
      },
      {
        "in": "list.files()",
        "out": "[1] \"data\"              \"plan-de-cours.pdf\" \"R\"                 \"resultats\"        ",
        "note": ""
      },
      {
        "in": "list.files(\"data\")",
        "out": "[1] \"codebook.pdf\" \"data.csv\"    ",
        "note": ""
      }
    ],
    "charger": [
      {
        "in": "df <- read.csv(\"data/data.csv\")",
        "out": "",
        "note": ""
      },
      {
        "in": "head(df, 3)",
        "out": "  age interet\n1  69       8\n2  61       8\n3  54       3",
        "note": ""
      }
    ],
    "ailleurs": [
      {
        "in": "file.exists(\"~/Downloads/data.csv\")",
        "out": "[1] TRUE",
        "note": ""
      },
      {
        "in": "df <- read.csv(\"~/Downloads/data.csv\")",
        "out": "",
        "note": ""
      },
      {
        "in": "nrow(df)",
        "out": "[1] 20180",
        "note": ""
      }
    ],
    "sauver": [
      {
        "in": "write.csv(df, \"resultats/data_propre.csv\", row.names = FALSE)",
        "out": "",
        "note": ""
      },
      {
        "in": "saveRDS(df, \"data/data.rds\")",
        "out": "",
        "note": ""
      },
      {
        "in": "list.files(\"resultats\")",
        "out": "[1] \"data_propre.csv\"",
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
        "out": "Saving 6.99 x 6.99 in image",
        "note": ""
      },
      {
        "in": "list.files(\"resultats\")",
        "out": "[1] \"age.png\"         \"data_propre.csv\"",
        "note": ""
      }
    ],
    "erreur": [
      {
        "in": "df <- read.csv(\"data.csv\")",
        "out": "Error in file(file, \"rt\") : cannot open the connection\nIn addition: Warning message:\nIn file(file, \"rt\") :\n  cannot open file 'data.csv': No such file or directory",
        "note": ""
      },
      {
        "in": "file.exists(\"data.csv\")",
        "out": "[1] FALSE",
        "note": ""
      },
      {
        "in": "file.exists(\"data/data.csv\")",
        "out": "[1] TRUE",
        "note": ""
      }
    ]
  },
  "apres": {
    "data": ["codebook.pdf", "data.csv", "data.rds"],
    "resultats": ["age.png", "data_propre.csv"]
  }
};
