// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.
// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon
// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6
// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les
// valeurs manquantes sont écartés. effectifs, pourcentages et ecarts suivent
// l'ordre de partis ; les pourcentages sont calculés dans chaque groupe d'âge.
// ensemble : part de chaque parti dans tout l'échantillon (non pondéré, ce n'est
// pas une moyenne nationale) ; ecarts : pourcentage du groupe moins ensemble, en
// points de pourcentage, arrondi après la soustraction. vues : le code de chaque
// vue, exécuté tel quel et à la suite par le script, et ses morceaux en rouge.
export const BARRES = {
  "r": "R version 4.6.1 (2026-06-24)",
  "ggplot2": "4.0.3",
  "dplyr": "1.2.1",
  "n": 14022,
  "ecartes": {
    "ne_sait_pas": 1887,
    "manquants": 4271
  },
  "partis": ["Libéral", "Conservateur", "NPD", "Bloc Québécois", "Vert", "Autre"],
  "preparation": "df$groupe_age <- cut(df$age, breaks = c(18, 35, 55, Inf), right = FALSE,\n                     labels = c(\"18-34\", \"35-54\", \"55 et plus\"))",
  "code": "ggplot(df, aes(x = groupe_age, fill = parti)) +\n  geom_bar(position = \"dodge\")",
  "vues": [
    {
      "id": "effectifs",
      "forts": ["fill = parti", "position = \"dodge\""],
      "code": "ggplot(df, aes(x = groupe_age, fill = parti)) +\n  geom_bar(position = \"dodge\")"
    },
    {
      "id": "pourcentages",
      "forts": ["y = pct", "geom_col"],
      "code": "pct <- df |>\n  count(groupe_age, parti) |>\n  group_by(groupe_age) |>\n  mutate(pct = 100 * n / sum(n))\nggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "inverse",
      "forts": ["x = parti", "fill = groupe_age"],
      "code": "# le même tableau pct\nggplot(pct, aes(x = parti, y = pct, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "ecart",
      "forts": ["ecart = pct - ensemble", "y = ecart"],
      "code": "ecarts <- pct |>\n  group_by(parti) |>\n  mutate(ensemble = 100 * sum(n) / nrow(df),\n         ecart = pct - ensemble)\nggplot(ecarts, aes(x = parti, y = ecart, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    }
  ],
  "ensemble": [46.6, 33.1, 9, 7.2, 2.3, 1.9],
  "groupes": [
    {
      "nom": "18-34",
      "total": 3201,
      "effectifs": [1382, 1024, 442, 200, 96, 57],
      "pourcentages": [43.2, 32, 13.8, 6.2, 3, 1.8],
      "ecarts": [-3.4, -1.1, 4.8, -1, 0.7, -0.1]
    },
    {
      "nom": "35-54",
      "total": 4587,
      "effectifs": [1868, 1737, 446, 303, 124, 109],
      "pourcentages": [40.7, 37.9, 9.7, 6.6, 2.7, 2.4],
      "ecarts": [-5.8, 4.7, 0.8, -0.6, 0.4, 0.5]
    },
    {
      "nom": "55 et plus",
      "total": 6234,
      "effectifs": [3278, 1883, 370, 508, 97, 98],
      "pourcentages": [52.6, 30.2, 5.9, 8.1, 1.6, 1.6],
      "ecarts": [6, -2.9, -3, 0.9, -0.7, -0.3]
    }
  ]
};
