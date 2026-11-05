/* L'empreinte environnementale de l'IA, pour la séance 9. Chaque chiffre garde
   sa source, son année et son unité d'origine; les conversions sont faites ici.
   Vérifié deux fois, de façon indépendante, aux sources primaires le 5 novembre
   2026 (résumés dans docs/plan-de-cours.md).
   Ne rien ajouter de mémoire.

   Les centres de données ne sont pas que l'IA : ils servent aussi le web, le
   nuage, la vidéo. Les diapos disent « centres de données ». */

const GALLON = 3.785411784; // litres
const ACRE_PIED = 1233.48184; // m³
const annuel = (mgalParJour) => (mgalParJour * 1e6 * 365 * GALLON) / 1e9; // milliards de litres par an

/* L'eau consommée aux États-Unis, en milliards de litres par an. */
export const EAU = [
  { cle: 'irrigation', nom: 'Irrigation des cultures', an: 2020, gL: annuel(78400),
    source: 'USGS, Professional Paper 1894-D (2020, 48 États contigus) : 78 400 millions de gallons par jour consommés par l’irrigation des cultures (le golf est estimé à part)' },
  { cle: 'thermique', nom: 'Centrales thermiques', an: 2020, gL: annuel(2382),
    source: 'USGS, Professional Paper 1894-D (2020) : 2 382 millions de gallons par jour consommés' },
  { cle: 'golf', nom: 'Terrains de golf (arrosage)', an: 2024, gL: (1.63e6 * ACRE_PIED * 1000) / 1e9, note: 'eau d’arrosage appliquée, pas mesurée comme consommée',
    source: 'GCSAA, enquête 2024 : 1,63 million d’acres-pieds d’eau d’arrosage' },
  { cle: 'cd_elec', nom: 'Électricité des centres de données', an: 2023, gL: 800, ia: true, note: 'comprend l’évaporation des barrages, chevauche les centrales',
    source: 'LBNL, 2024 United States Data Center Energy Usage Report, p. 57 : « nearly 800 billion liters »' },
  { cle: 'cd', nom: 'Centres de données', an: 2023, gL: 66, ia: true,
    source: 'LBNL, 2024 United States Data Center Energy Usage Report, p. 55 : 66 milliards de litres sur place' }
];

/* L'électricité consommée, en TWh par an. */
export const ENERGIE = [
  { cle: 'clim', nom: 'Climatisation (monde)', an: 2022, twh: 2111,
    source: 'AIE, données reprises par Our World in Data : 2 111 TWh en 2022' },
  { cle: 'cd', nom: 'Centres de données (monde)', an: 2025, twh: 485, en2030: 945, ia: true,
    source: 'AIE, Key Questions on Energy and AI (2026) : 485 TWh en 2025; Energy and AI (2025) : 945 TWh prévus en 2030' },
  { cle: 'qc', nom: 'Le Québec, tout entier', an: 2025, twh: 184.9,
    source: 'Hydro-Québec, rapport annuel 2025 : ventes d’électricité au Québec, 184,9 TWh' },
  { cle: 'btc', nom: 'Bitcoin (monde)', an: 2024, twh: 183, note: 'rythme annualisé, fin 2024',
    source: 'Cambridge Centre for Alternative Finance, Cambridge Digital Mining Industry Report (avril 2025) : 183 TWh annualisés au 31 décembre 2024' }
];

/* L'électricité de quelques usages du numérique, en Wh. Deux familles qui ne
   comptent pas la même chose : l'IA, le centre de données seulement; la vidéo
   en ligne, l'écran (72 %), le réseau (23 %) et le centre de données (5 %). */
const J = (joules) => joules / 3600; // Wh
const VIDEO_H = 77; // Wh par heure, moyenne 2019 (AIE)
const VIDEO_TEL_H = 37; // Wh par heure, téléphone, définition standard, wifi (AIE)
export const ACTIVITES = [
  { cle: 'gemini', nom: 'Requête Gemini', wh: 0.24, ia: true,
    source: 'Google, arXiv 2508.15734 (août 2025) : requête texte médiane, mai 2025' },
  { cle: 'epoch', nom: 'Requête GPT-4o (estimation)', wh: 0.3, ia: true,
    source: 'Epoch AI (février 2025) : environ 0,3 Wh, estimation indépendante' },
  { cle: 'reel', nom: 'Reel de 30 s (téléphone, wifi)', wh: VIDEO_TEL_H / 120,
    source: 'AIE (2020) : 37 Wh par heure de vidéo sur téléphone, ramené à 30 secondes' },
  { cle: 'chatgpt', nom: 'Requête ChatGPT', wh: 0.34, ia: true,
    source: 'OpenAI, Sam Altman (juin 2025) : 0,34 Wh en moyenne, méthode non publiée' },
  { cle: 'image', nom: 'Image générée (labo)', wh: J(2282), ia: true,
    source: 'MIT Technology Review (mai 2025) : Stable Diffusion 3 Medium, 2 282 joules' },
  { cle: 'raison', nom: 'Requête longue (raisonnement)', wh: 3.91, ia: true,
    source: 'Microsoft Research, arXiv 2509.20241 v2 (juin 2026) : 3,91 Wh pour des requêtes 15 fois plus longues que la normale (0,31 Wh pour une requête typique), modélisé' },
  { cle: 'video10', nom: 'Vidéo en ligne, 10 min', wh: VIDEO_H / 6,
    source: 'AIE (2020) : 77 Wh par heure de streaming en 2019, ramené à 10 minutes' },
  { cle: 'film', nom: 'Film de 2 h en streaming', wh: VIDEO_H * 2,
    source: 'AIE (2020) : 77 Wh par heure de streaming en 2019, deux heures' },
  { cle: 'video_ia', nom: 'Vidéo générée de 5 s (labo)', wh: J(3.4e6), ia: true,
    source: 'MIT Technology Review (mai 2025) : CogVideoX, 3,4 millions de joules' }
];
