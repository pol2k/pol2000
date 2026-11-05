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

/* L'électricité de quelques usages du numérique, en Wh. Deux familles de
   mesures qui ne comptent pas la même chose : l'IA, le centre de données
   seulement; le streaming, l'écran (72 %), le réseau (23 %) et le centre de
   données (5 %). */
const J = (joules) => joules / 3600; // Wh
const STREAM_H = 77; // Wh par heure, moyenne 2019 (AIE)
const STREAM_TEL_H = 37; // Wh par heure, téléphone, SD, wifi (AIE)
export const ACTIVITES = [
  { cle: 'llama8', nom: 'Réponse texte, petit modèle', wh: J(114), ia: true,
    source: 'MIT Technology Review (mai 2025) : Llama 3.1 8B, 114 joules par réponse' },
  { cle: 'gemini', nom: 'Requête texte à Gemini', wh: 0.24, ia: true,
    source: 'Google (août 2025) : requête texte médiane, 0,24 Wh' },
  { cle: 'reel', nom: 'Reel de 30 s sur un téléphone', wh: STREAM_TEL_H / 120,
    source: 'AIE (2020) : 37 Wh par heure de vidéo sur un téléphone, ramené à 30 secondes' },
  { cle: 'chatgpt', nom: 'Requête à ChatGPT', wh: 0.34, ia: true,
    source: 'OpenAI, Sam Altman (juin 2025) : 0,34 Wh en moyenne, sans méthode publiée' },
  { cle: 'image', nom: 'Image générée par IA', wh: J(2282), ia: true,
    source: 'MIT Technology Review (mai 2025) : Stable Diffusion 3 Medium, 2 282 joules' },
  { cle: 'llama405', nom: 'Réponse texte, gros modèle', wh: J(6706), ia: true,
    source: 'MIT Technology Review (mai 2025) : Llama 3.1 405B, 6 706 joules par réponse' },
  { cle: 'video10', nom: 'Vidéo de 10 min (YouTube…)', wh: STREAM_H / 6,
    source: 'AIE (2020) : 77 Wh par heure de streaming en 2019, ramené à 10 minutes' },
  { cle: 'film', nom: 'Film de 2 h sur Netflix', wh: STREAM_H * 2,
    source: 'AIE (2020) : 77 Wh par heure de streaming en 2019, deux heures' },
  { cle: 'video_ia', nom: 'Vidéo de 5 s générée par IA', wh: J(3.4e6), ia: true,
    source: 'MIT Technology Review (mai 2025) : CogVideoX, 3,4 millions de joules' }
];
