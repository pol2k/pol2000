// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.
// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon
// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6
// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les
// valeurs manquantes sont écartés. effectifs et pourcentages suivent l'ordre de
// partis ; les pourcentages sont calculés dans chaque groupe d'âge.
export const BARRES = {
  "r": "R version 4.6.1 (2026-06-24)",
  "ggplot2": "4.0.3",
  "n": 14022,
  "ecartes": {
    "ne_sait_pas": 1887,
    "manquants": 4271
  },
  "partis": ["Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre"],
  "preparation": "df$groupe_age <- cut(df$age, breaks = c(18, 35, 55, Inf), right = FALSE,\n                     labels = c(\"18-34\", \"35-54\", \"55 et plus\"))",
  "code": "ggplot(df, aes(x = groupe_age, fill = parti)) +\n  geom_bar(position = \"dodge\")",
  "groupes": [
    {
      "nom": "18-34",
      "total": 3201,
      "effectifs": [1382, 1024, 442, 200, 96, 57],
      "pourcentages": [43.2, 32, 13.8, 6.2, 3, 1.8]
    },
    {
      "nom": "35-54",
      "total": 4587,
      "effectifs": [1868, 1737, 446, 303, 124, 109],
      "pourcentages": [40.7, 37.9, 9.7, 6.6, 2.7, 2.4]
    },
    {
      "nom": "55 et plus",
      "total": 6234,
      "effectifs": [3278, 1883, 370, 508, 97, 98],
      "pourcentages": [52.6, 30.2, 5.9, 8.1, 1.6, 1.6]
    }
  ]
};
