/**
 * Les noms de modèles et les quotas changent plus vite que le cours. Le
 * matériel enseigne donc une interface stable et garde les choix volatils ici.
 */
export const FOURNISSEURS = {
  gemini: {
    id: 'gemini',
    nom: 'Google AI Studio',
    fonctionR: 'chat_google_gemini',
    modele: 'gemini-3.5-flash',
    variableEnv: 'GEMINI_API_KEY',
    urlCle: 'https://aistudio.google.com/apikey',
    carteRequise: false,
    quota: "variable selon le modèle et le projet; le diagnostic vérifie l'accès réel"
  },
  openrouter: {
    id: 'openrouter',
    nom: 'OpenRouter',
    fonctionR: 'chat_openrouter',
    modele: 'google/gemini-3.5-flash-lite',
    variableEnv: 'OPENROUTER_API_KEY',
    urlCle: 'https://openrouter.ai/settings/keys',
    carteRequise: false,
    quota: "variable selon le modèle; quelques crédits sont recommandés pour éviter l'attente"
  }
};

export const FOURNISSEUR = FOURNISSEURS.gemini;
export const FOURNISSEUR_SECOURS = FOURNISSEURS.openrouter;

export const URL_VERIFICATEUR = 'https://eiom-ia.github.io/verifier.R';
export const URL_OUTILS_R = 'https://eiom-ia.github.io/eiom.R';

export const CONTACT = 'mail@mfoisy.com';
