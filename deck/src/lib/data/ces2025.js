/* Généré par outils/ces_data.R à partir de ces::get_ces("2025"), l'Étude
   électorale canadienne 2025. R version 4.6.1 (2026-06-24). Aucune valeur ici n'est écrite à la main. */
export const N = 20180;
export const N_COLONNES = 1440;
export const N_QUEBEC = 4906;
/* hist(df$cps25_age_in_years) : bornes et effectifs, tels que R les choisit. */
export const HIST_AGE = { bornes: [15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100], effectifs: [563, 1392, 1468, 1923, 1756, 1699, 1540, 1630, 1789, 1942, 1605, 1365, 1002, 408, 87, 10, 1] };
export const MOY_AGE = 49.71511;
/* Part de chaque parti (codes 1 à 5) dans chaque groupe de scolarité :
   1 à 5 = secondaire ou moins, 6 à 7 = collégial, 8 à 11 = universitaire. */
export const BARRES = [
  { scolarite: "Secondaire ou moins", parti: "1. Liberal Party", n: 857, part: 0.3904 },
  { scolarite: "Secondaire ou moins", parti: "2. Conservative Party", n: 890, part: 0.4055 },
  { scolarite: "Secondaire ou moins", parti: "3. NDP", n: 196, part: 0.0893 },
  { scolarite: "Secondaire ou moins", parti: "4. Bloc Québécois", n: 201, part: 0.0916 },
  { scolarite: "Secondaire ou moins", parti: "5. Green Party", n: 51, part: 0.0232 },
  { scolarite: "Collégial", parti: "1. Liberal Party", n: 1805, part: 0.4126 },
  { scolarite: "Collégial", parti: "2. Conservative Party", n: 1719, part: 0.3929 },
  { scolarite: "Collégial", parti: "3. NDP", n: 416, part: 0.0951 },
  { scolarite: "Collégial", parti: "4. Bloc Québécois", n: 341, part: 0.0779 },
  { scolarite: "Collégial", parti: "5. Green Party", n: 94, part: 0.0215 },
  { scolarite: "Universitaire", parti: "1. Liberal Party", n: 3859, part: 0.5382 },
  { scolarite: "Universitaire", parti: "2. Conservative Party", n: 2026, part: 0.2826 },
  { scolarite: "Universitaire", parti: "3. NDP", n: 645, part: 0.09 },
  { scolarite: "Universitaire", parti: "4. Bloc Québécois", n: 468, part: 0.0653 },
  { scolarite: "Universitaire", parti: "5. Green Party", n: 172, part: 0.024 }
];
/* lm(conservateur ~ cps25_income), la droite de la séance 1. */
export const LM_REVENU = { constante: 0.283643, pente: 0.010014, n: 12816 };
