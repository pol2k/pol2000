/**
 * Crédits des images d'archives, tirés de Wikimedia Commons.
 * Licences vérifiées à la source; toute image ajoutée doit l'être ici.
 */
export const CREDITS_IMAGES = {
  "prix-anthropic": {
    "licence": "Capture de la page de tarification publique, reproduite en contexte pédagogique",
    "auteur": "Anthropic",
    "page": "https://www.anthropic.com/pricing",
    "fichier": "prix-anthropic.jpg"
  },
  "centre-donnees": {
    "licence": "CC BY 2.0",
    "auteur": "Carl Lender",
    "page": "https://commons.wikimedia.org/wiki/File:Datacenter_Server_Racks_(22370909788).jpg",
    "fichier": "centre-donnees.jpg"
  },
  "ellmer": {
    "licence": "MIT, logo du paquet R ellmer",
    "auteur": "Posit / tidyverse",
    "page": "https://ellmer.tidyverse.org/",
    "fichier": "ellmer.png"
  },
  "google-maps": {
    "licence": "Public domain (marque déposée de Google — usage nominatif)",
    "auteur": "Google Inc.",
    "page": "https://commons.wikimedia.org/wiki/File:Google_Maps_icon_(2026).svg",
    "fichier": "google-maps.png"
  },
  "turing": {
    "licence": "Public domain",
    "auteur": "Elliott & Fry",
    "page": "https://commons.wikimedia.org/wiki/File:Alan_Turing_(1951)_(crop).jpg",
    "fichier": "turing.jpg"
  },
  "perceptron": {
    "licence": "Public domain",
    "auteur": "John C. Hay, Albert E. Murray",
    "page": "https://commons.wikimedia.org/wiki/File:Mark_I_Perceptron,_Figure_2_of_operator%27s_manual.png",
    "fichier": "perceptron.jpg"
  },
  "bengio": {
    "licence": "CC BY 4.0",
    "auteur": "Maryse Boyce",
    "page": "https://commons.wikimedia.org/wiki/File:Yoshua_Bengio_2019_cropped.jpg",
    "fichier": "bengio.jpg"
  },
  "mccarthy": {
    "licence": "CC BY-SA 2.0",
    "auteur": "\"null0\"",
    "page": "https://commons.wikimedia.org/wiki/File:John_McCarthy_Stanford.jpg",
    "fichier": "mccarthy.jpg"
  },
  "openai": {
    "licence": "Public domain",
    "auteur": "OpenAI",
    "page": "https://commons.wikimedia.org/wiki/File:OpenAI_logo_2025.svg",
    "fichier": "openai.png"
  },
  "anthropic": {
    "licence": "Public domain",
    "auteur": "Anthropic",
    "page": "https://commons.wikimedia.org/wiki/File:Anthropic_logo.svg",
    "fichier": "anthropic.png"
  },
  "deepmind": {
    "licence": "Public domain",
    "auteur": "DeepMind Technologies Limited (Alphabet, Inc.).",
    "page": "https://commons.wikimedia.org/wiki/File:Google_DeepMind_logo.png",
    "fichier": "deepmind.png"
  },
  "deepblue": {
    "licence": "CC BY 2.0",
    "auteur": "James the photographer",
    "page": "https://commons.wikimedia.org/wiki/File:Deep_Blue.jpg",
    "fichier": "deepblue.jpg"
  },
  "hinton": {
    "licence": "CC BY-SA 4.0",
    "auteur": "Jay Dixit",
    "page": "https://commons.wikimedia.org/wiki/File:Geoffrey_Hinton_at_the_2024_Nobel_Lectures.jpg",
    "fichier": "hinton.jpg"
  },
  "feifei": {
    "licence": "CC BY 2.0",
    "auteur": "ITU Pictures",
    "page": "https://commons.wikimedia.org/wiki/File:Fei-Fei_Li_at_AI_for_Good_2017.jpg",
    "fichier": "feifei.jpg"
  },
  "hassabis": {
    "licence": "CC BY-SA 4.0",
    "auteur": "Alain Herzog",
    "page": "https://commons.wikimedia.org/wiki/File:Demis_Hassabis.jpg",
    "fichier": "hassabis.jpg"
  }
};

/**
 * Photo du restaurant. Aucune image sous licence n'existe pour La Ligne Rouge:
 * ni Wikimedia Commons ni Openverse n'en ont, et emprunter la photo d'un autre
 * casse-croûte serait une fausse représentation sur une diapositive qui ne
 * montre par ailleurs que des données réelles.
 *
 * Pour l'ajouter: déposer le fichier dans static/img/ et remplacer null par
 * { fichier, auteur, licence }. La diapositive s'en passe tant que c'est null.
 */
export const PHOTO_RESTAURANT = {
  fichier: 'ligne-rouge.jpg',
  auteur: 'Fiche Pages Jaunes du restaurant',
  licence: 'reproduit en contexte pédagogique',
  page: 'https://www.yellowpages.ca/'
};
