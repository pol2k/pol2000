/* Généré par ces_fit2.R sur l'Étude électorale canadienne 2025 (Dataverse 13958997).
   Y = 1 si la personne compte voter conservateur, 0 sinon (parmi celles qui ont un choix);
   X = tranche de revenu du ménage, 1 à 8. Aucune valeur ici n'est écrite à la main. */
export const REG = {
  "n": 12816,
  "r2": 0.0014,
  "n_total": 20180,
  "n_cols": 1440,
  "y": "conservateur",
  "x": "income",
  "coefs": [
    {
      "term": "(Intercept)",
      "estimate": 0.2836,
      "se": 0.0117,
      "t": 24.31,
      "p": 1.25e-127
    },
    {
      "term": "income",
      "estimate": 0.01,
      "se": 0.0023,
      "t": 4.3,
      "p": 0
    }
  ],
  "income_labels": [
    "1 · aucun revenu",
    "2 · 1 $ à 30 000 $",
    "3 · 30 001 $ à 60 000 $",
    "4 · 60 001 $ à 90 000 $",
    "5 · 90 001 $ à 110 000 $",
    "6 · 110 001 $ à 150 000 $",
    "7 · 150 001 $ à 200 000 $",
    "8 · plus de 200 000 $"
  ]
};
export const MOYENNES = [
  {
    "income": 1,
    "pct": 25.7,
    "n": 70
  },
  {
    "income": 2,
    "pct": 29.5,
    "n": 1340
  },
  {
    "income": 3,
    "pct": 30.4,
    "n": 2470
  },
  {
    "income": 4,
    "pct": 33.6,
    "n": 2629
  },
  {
    "income": 5,
    "pct": 34.4,
    "n": 1816
  },
  {
    "income": 6,
    "pct": 36.1,
    "n": 2166
  },
  {
    "income": 7,
    "pct": 31.2,
    "n": 1350
  },
  {
    "income": 8,
    "pct": 36.9,
    "n": 975
  }
];
