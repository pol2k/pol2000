/* L'empreinte environnementale de l'IA, pour la séance 9. Chaque chiffre garde
   sa source, son année et son unité d'origine; les conversions sont faites ici.
   Vérifié le 5 novembre 2026. Ne rien ajouter de mémoire.

   Les centres de données ne sont pas que l'IA : ni le LBNL ni l'AIE ne donnent
   la part de l'IA. Les diapos disent « centres de données ». */

const GALLON = 3.785411784; // litres
const ACRE_PIED = 325851; // gallons
const parJour = (gallonsParAn) => gallonsParAn / 365;
const gL = (gallonsParJour) => (gallonsParJour * GALLON) / 1e9; // milliards de litres par jour

/* L'eau consommée aux États-Unis (pas prélevée : une centrale thermique rend
   presque tout ce qu'elle prélève). Milliards de litres par jour. */
export const EAU = [
  { cle: 'irrigation', nom: 'Irrigation agricole', an: 2015, gLj: gL(73.2e9),
    source: 'USGS, Estimated use of water in the United States in 2015 (consommation : 73,2 milliards de gallons par jour)' },
  { cle: 'thermique', nom: 'Centrales thermiques', an: 2015, gLj: gL(4.31e9),
    source: 'USGS, 2015 (consommation : 4,31 milliards de gallons par jour)' },
  { cle: 'golf', nom: 'Terrains de golf', an: 2024, gLj: gL(parJour(1.63e6 * ACRE_PIED)),
    source: 'GCSAA, enquête 2024 : 1,63 million d’acres-pieds d’arrosage par an' },
  { cle: 'cd_total', nom: 'Centres de données (+ électricité)', an: 2023, gLj: gL(parJour(17.4e9 + 211e9)), ia: true,
    source: 'LBNL 2024 : 17,4 milliards de gallons sur place + environ 211 milliards par l’électricité (inclut l’évaporation des réservoirs hydroélectriques)' },
  { cle: 'cd_direct', nom: 'Centres de données (sur place)', an: 2023, gLj: gL(parJour(17.4e9)), ia: true,
    source: 'LBNL, 2024 United States Data Center Energy Usage Report : 17,4 milliards de gallons en 2023' }
];

/* L'électricité consommée dans le monde, en TWh par an. */
export const ENERGIE = [
  { cle: 'clim', nom: 'Climatisation', an: 2022, twh: 2100, approx: false,
    source: 'AIE, citée par Our World in Data : environ 2 100 TWh en 2022, 7 % de l’électricité mondiale' },
  { cle: 'alu', nom: 'Production d’aluminium', an: 2023, twh: 900, approx: true,
    source: 'Estimations de l’industrie : plus de 900 TWh en 2023, environ 4 % de l’électricité mondiale' },
  { cle: 'cd', nom: 'Centres de données', an: 2024, twh: 415, en2030: 945, ia: true,
    source: 'AIE, Energy and AI (2025) : 415 TWh en 2024, 1,5 % de l’électricité mondiale; 945 TWh prévus en 2030' },
  { cle: 'btc', nom: 'Bitcoin', an: 2025, twh: 138, approx: false,
    source: 'Cambridge Bitcoin Electricity Consumption Index : 138 TWh par an' }
];

/* Une requête texte médiane à Gemini, mesurée par Google (mai 2025). */
export const REQUETE = {
  wh: 0.24, ml: 0.26, gco2: 0.03,
  tele: 'moins de 9 secondes de télé', gouttes: 'environ 5 gouttes',
  exclu: ['l’entraînement du modèle', 'les images et la vidéo', 'l’eau des centrales électriques'],
  source: 'Google, Measuring the environmental impact of AI inference (août 2025), arXiv 2508.15734. Non vérifié par un tiers.'
};
