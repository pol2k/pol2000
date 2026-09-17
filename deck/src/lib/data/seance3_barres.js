// GÉNÉRÉ par outils/seance3_barres.R : ne pas modifier à la main.
// Étude électorale canadienne 2025 : intention de vote (cps25_votechoice) selon
// le groupe d'âge (cut() de cps25_age_in_years). « Autre » réunit les codes 6
// (un autre parti) et 8 (Parti populaire) ; le code 7 (« ne sait pas ») et les
// valeurs manquantes sont écartés. Dans chaque groupe, les vecteurs suivent
// l'ordre de partis. pctTotal : % de tout le tableau ; pourcentages : % dans le
// groupe d'âge ; pctParti : % dans le parti. ensemble : part de chaque parti dans
// tout l'échantillon ; part : part du groupe d'âge dans tout l'échantillon (non
// pondéré, ce n'est pas une moyenne nationale). ecarts : pourcentages moins
// ensemble ; ecartsParti : pctParti moins part ; en points de pourcentage,
// arrondis après la soustraction. vues : le code de chaque vue, exécuté tel quel
// et à la suite par le script, et ses morceaux à mettre en rouge.
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
      "id": "pct_total",
      "forts": ["y = pct", "geom_col"],
      "code": "pct <- df |>\n  count(groupe_age, parti) |>\n  mutate(pct = 100 * n / sum(n))\nggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "pct_groupe",
      "forts": ["group_by(groupe_age)"],
      "code": "pct <- df |>\n  count(groupe_age, parti) |>\n  group_by(groupe_age) |>\n  mutate(pct = 100 * n / sum(n))\nggplot(pct, aes(x = groupe_age, y = pct, fill = parti)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "inverse",
      "forts": ["x = parti", "fill = groupe_age"],
      "code": "# le même tableau pct\nggplot(pct, aes(x = parti, y = pct, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "pct_parti",
      "forts": ["group_by(parti)"],
      "code": "pct_parti <- df |>\n  count(parti, groupe_age) |>\n  group_by(parti) |>\n  mutate(pct = 100 * n / sum(n))\nggplot(pct_parti, aes(x = parti, y = pct, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "ecart_groupe",
      "forts": ["ecart = pct - ensemble", "y = ecart"],
      "code": "ecarts <- pct |>\n  group_by(parti) |>\n  mutate(ensemble = 100 * sum(n) / nrow(df),\n         ecart = pct - ensemble)\nggplot(ecarts, aes(x = parti, y = ecart, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    },
    {
      "id": "ecart_parti",
      "forts": ["pct_parti", "group_by(groupe_age)"],
      "code": "ecarts_parti <- pct_parti |>\n  group_by(groupe_age) |>\n  mutate(ensemble = 100 * sum(n) / nrow(df),\n         ecart = pct - ensemble)\nggplot(ecarts_parti, aes(x = parti, y = ecart, fill = groupe_age)) +\n  geom_col(position = \"dodge\")"
    }
  ],
  "ensemble": [46.6, 33.1, 9, 7.2, 2.3, 1.9],
  "totauxPartis": [6528, 4644, 1258, 1011, 317, 264],
  "groupes": [
    {
      "nom": "18-34",
      "total": 3201,
      "part": 22.8,
      "effectifs": [1382, 1024, 442, 200, 96, 57],
      "pctTotal": [9.9, 7.3, 3.2, 1.4, 0.7, 0.4],
      "pourcentages": [43.2, 32, 13.8, 6.2, 3, 1.8],
      "pctParti": [21.2, 22, 35.1, 19.8, 30.3, 21.6],
      "ecarts": [-3.4, -1.1, 4.8, -1, 0.7, -0.1],
      "ecartsParti": [-1.7, -0.8, 12.3, -3, 7.5, -1.2]
    },
    {
      "nom": "35-54",
      "total": 4587,
      "part": 32.7,
      "effectifs": [1868, 1737, 446, 303, 124, 109],
      "pctTotal": [13.3, 12.4, 3.2, 2.2, 0.9, 0.8],
      "pourcentages": [40.7, 37.9, 9.7, 6.6, 2.7, 2.4],
      "pctParti": [28.6, 37.4, 35.5, 30, 39.1, 41.3],
      "ecarts": [-5.8, 4.7, 0.8, -0.6, 0.4, 0.5],
      "ecartsParti": [-4.1, 4.7, 2.7, -2.7, 6.4, 8.6]
    },
    {
      "nom": "55 et plus",
      "total": 6234,
      "part": 44.5,
      "effectifs": [3278, 1883, 370, 508, 97, 98],
      "pctTotal": [23.4, 13.4, 2.6, 3.6, 0.7, 0.7],
      "pourcentages": [52.6, 30.2, 5.9, 8.1, 1.6, 1.6],
      "pctParti": [50.2, 40.5, 29.4, 50.2, 30.6, 37.1],
      "ecarts": [6, -2.9, -3, 0.9, -0.7, -0.3],
      "ecartsParti": [5.8, -3.9, -15, 5.8, -13.9, -7.3]
    }
  ]
};
