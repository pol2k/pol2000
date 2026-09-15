/* Généré par outils/seance3_data.R. Sources : ces::get_ces("2025"), l'Étude électorale
   canadienne 2025 ; datasets::anscombe ; les passagers du Titanic du cours d'hiver 2024.
   R version 4.6.1 (2026-06-24). Aucune valeur ici n'est écrite à la main. */

/* Quatre formes. valeurs = abscisses (pour poilievre, les bornes des tranches de 10) ;
   sans = réponses « ne sait pas » (-99) ou hors échelle, écartées. */
export const FORMES = {
  gauche_droite: { valeurs: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], effectifs: [721, 668, 1344, 1956, 1939, 3643, 2283, 1941, 1278, 520, 703], n: 16996, sans: 3184, moyenne: 4.967, mediane: 5 },
  interet: { valeurs: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], effectifs: [506, 448, 725, 977, 908, 1738, 2270, 3551, 3622, 2374, 2657], n: 19776, sans: 404, moyenne: 6.702, mediane: 7 },
  poilievre: { valeurs: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100], effectifs: [6682, 1313, 1174, 1098, 976, 1223, 1372, 1468, 1279, 2204], n: 18789, sans: 1391, moyenne: 39.619, mediane: 33 },
  menage: { valeurs: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], effectifs: [3944, 7823, 3260, 2955, 1096, 362, 126, 53, 22, 6, 4, 1], n: 19662, sans: 518, moyenne: 5088.565, mediane: 2 }
};
export const MENAGE = { max: 100000000, moyenneValide: 5088.6, medianeValide: 2, plusGrands: [100000000, 500, 123, 120, 51], n12: 10 };
export const DEMSAT = { effectifs: [2971, 10576, 4313, 1594, 726] };
export const VOTE = { effectifs: [6528, 4644, 1258, 1011, 317, 82, 1887, 182] };

/* L'âge. hist, boite et densite : ggplot_build() de geom_histogram(binwidth = 5, boundary = 15),
   geom_boxplot() et geom_density(). */
export const AGE = { n: 20180, moyenne: 49.72, mediane: 50, et: 17.54, eiq: 29, quartiles: [18, 35, 50, 64, 96] };
/* Les 101 centiles de l'âge, quantile(age, 0:100 / 100) : 0 %, 1 %, ..., 100 %. */
export const AGE_CENTILES = [18, 19, 20, 21, 22, 22, 23, 24, 24, 25, 26, 26, 27, 28, 29, 29, 30, 31, 31, 32, 32, 33, 33, 34, 34, 35, 35, 36, 36, 37, 38, 38, 39, 39, 40, 40, 41, 42, 42, 43, 44, 44, 45, 45, 46, 46, 47, 48, 48, 49, 50, 50, 51, 52, 52, 53, 54, 54, 55, 55, 56, 56, 57, 58, 58, 59, 59, 60, 60, 61, 61, 62, 62, 63, 63, 64, 64, 65, 66, 66, 67, 68, 68, 69, 69, 70, 71, 71, 72, 73, 74, 75, 75, 76, 77, 77, 78, 80, 81, 84, 96];
export const AGE_HIST ={ debut: [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95], fin: [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100], effectifs: [563, 1392, 1468, 1923, 1756, 1699, 1540, 1630, 1789, 1942, 1605, 1365, 1002, 408, 87, 10, 1] };
export const AGE_BOITE = { min: 18, q1: 35, med: 50, q3: 64, max: 96, horsNorme: 0 };
export const AGE_DENSITE = { x: [18, 18.92, 19.83, 20.9, 21.82, 22.73, 23.8, 24.72, 25.78, 26.7, 27.62, 28.68, 29.6, 30.67, 31.59, 32.5, 33.57, 34.49, 35.4, 36.47, 37.39, 38.45, 39.37, 40.29, 41.35, 42.27, 43.34, 44.25, 45.17, 46.24, 47.15, 48.22, 49.14, 50.05, 51.12, 52.04, 52.95, 54.02, 54.94, 56.01, 56.92, 57.84, 58.91, 59.82, 60.89, 61.81, 62.72, 63.79, 64.71, 65.62, 66.69, 67.61, 68.68, 69.59, 70.51, 71.58, 72.49, 73.56, 74.48, 75.39, 76.46, 77.38, 78.45, 79.36, 80.28, 81.35, 82.26, 83.18, 84.25, 85.16, 86.23, 87.15, 88.06, 89.13, 90.05, 91.12, 92.03, 92.95, 94.02, 94.93, 96], y: [0.005873, 0.007594, 0.009162, 0.010749, 0.011917, 0.012889, 0.013707, 0.014112, 0.014337, 0.0145, 0.014808, 0.01546, 0.016226, 0.017194, 0.017919, 0.018417, 0.018622, 0.01849, 0.018179, 0.017764, 0.017466, 0.017208, 0.017032, 0.016888, 0.016798, 0.016819, 0.01691, 0.016932, 0.016796, 0.016406, 0.015954, 0.015461, 0.015199, 0.015158, 0.015401, 0.015794, 0.01625, 0.016725, 0.017034, 0.017315, 0.017555, 0.017836, 0.01822, 0.018561, 0.018886, 0.018999, 0.018867, 0.018368, 0.017738, 0.017088, 0.016486, 0.016127, 0.015761, 0.015367, 0.014856, 0.014198, 0.0137, 0.013268, 0.012954, 0.012534, 0.01173, 0.010737, 0.009341, 0.008093, 0.006911, 0.005682, 0.004758, 0.003933, 0.003077, 0.002433, 0.001792, 0.00134, 0.000978, 0.000661, 0.000465, 0.000304, 0.000209, 0.00014, 8.4e-05, 5.2e-05, 2.9e-05] };

/* L'âge par parti (codes 1 à 5) : les boîtes de ggplot2 et les moyennes. */
export const AGE_PARTIS = [
  { parti: "1. Liberal Party", n: 6528, moyenne: 52.55, min: 18, q1: 37, med: 55, q3: 67, max: 92 },
  { parti: "2. Conservative Party", n: 4644, moyenne: 49.68, min: 18, q1: 36, med: 50, q3: 63, max: 93 },
  { parti: "3. NDP", n: 1258, moyenne: 44.69, min: 18, q1: 31, med: 41, q3: 58, max: 92 },
  { parti: "4. Bloc Québécois", n: 1011, moyenne: 52.9, min: 18, q1: 39, med: 55, q3: 68, max: 90 },
  { parti: "5. Green Party", n: 317, moyenne: 45.79, min: 18, q1: 33, med: 43, q3: 59, max: 89 }
];

/* Le quartet d'Anscombe (1973), datasets::anscombe. */
export const ANSCOMBE = [
  { x: [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5], y: [8.04, 6.95, 7.58, 8.81, 8.33, 9.96, 7.24, 4.26, 10.84, 4.82, 5.68], moyX: 9, moyY: 7.5, etX: 3.32, etY: 2.03, r: 0.816, constante: 3, pente: 0.5 },
  { x: [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5], y: [9.14, 8.14, 8.74, 8.77, 9.26, 8.1, 6.13, 3.1, 9.13, 7.26, 4.74], moyX: 9, moyY: 7.5, etX: 3.32, etY: 2.03, r: 0.816, constante: 3, pente: 0.5 },
  { x: [10, 8, 13, 9, 11, 14, 6, 4, 12, 7, 5], y: [7.46, 6.77, 12.74, 7.11, 7.81, 8.84, 6.08, 5.39, 8.15, 6.42, 5.73], moyX: 9, moyY: 7.5, etX: 3.32, etY: 2.03, r: 0.816, constante: 3, pente: 0.5 },
  { x: [8, 8, 8, 8, 8, 8, 8, 19, 8, 8, 8], y: [6.58, 5.76, 7.71, 8.84, 8.47, 7.04, 5.25, 12.5, 5.56, 7.91, 6.89], moyX: 9, moyY: 7.5, etX: 3.32, etY: 2.03, r: 0.817, constante: 3, pente: 0.5 }
];

/* Titanic : lignes femme (0 homme, 1 femme), colonnes survie (0 mort, 1 vivant). */
export const TITANIC = { hommes: { morts: 709, vivants: 142 }, femmes: { morts: 154, vivants: 308 } };

/* Les consoles de la séance, à options(width = 100). */
export const CONSOLES = {
  resume: [
    { in: `mean(df$cps25_age_in_years)`, out: `[1] 49.71511` },
    { in: `median(df$cps25_age_in_years)`, out: `[1] 50` },
    { in: `summary(df$cps25_age_in_years)`, out: `   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  18.00   35.00   50.00   49.72   64.00   96.00 ` }
  ],
  dispersion: [
    { in: `sd(df$cps25_age_in_years)`, out: `[1] 17.54052` },
    { in: `quantile(df$cps25_age_in_years)`, out: `  0%  25%  50%  75% 100% 
  18   35   50   64   96 ` },
    { in: `IQR(df$cps25_age_in_years)`, out: `[1] 29` }
  ],
  menage: [
    { in: `summary(df$cps25_household)`, out: `     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
      -99         2         2      4955         3 100000000 ` },
    { in: `sort(df$cps25_household, decreasing = TRUE)[1:3]`, out: `[1] 1.00e+08 5.00e+02 1.23e+02` }
  ],
  categ: [
    { in: `table(df$cps25_demsat)`, out: `
    1     2     3     4     5 
 2971 10576  4313  1594   726 ` },
    { in: `levels(as_factor(df$cps25_demsat))`, out: `[1] "1. Very satisfied"                   "2. Fairly satisfied"                
[3] "3. Not very satisfied"               "4. Not at all satisfied"            
[5] "5. Don't know/ Prefer not to answer"` }
  ]
};
