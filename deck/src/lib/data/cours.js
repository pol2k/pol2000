/**
 * Single source of truth for everything the site shows about the offering:
 * session facts, the fourteen séances, the seven evaluations, the team and
 * the outbound links. Dates and weights come from syllabus/plan-de-cours-A26.md;
 * when the two disagree, the syllabus wins and this file is wrong.
 *
 * Empty strings in LIENS are placeholders the instructor fills in later. The
 * site renders the item without a link until then.
 */

export const COURS = {
  sigle: 'POL-2000',
  titre: 'Méthodologie quantitative',
  session: 'Automne 2026',
  nrc: '87892',
  credits: 3,
  jour: 'jeudi',
  heures: '15h30 à 18h20',
  local: 'DKN-3159',
  pavillon: 'Pavillon Charles-De Koninck',
  debut: '2026-08-31',
  fin: '2026-12-11',
  lecture: { de: '2026-10-26', a: '2026-10-30' },
  site: 'https://pol2000.com',
  depot: 'https://github.com/pol2k/pol2000',
  enseignant: { nom: 'Laurence-Olivier M. Foisy', courriel: 'mail@mfoisy.com' }
};

export const LIENS = {
  r: 'https://cran.r-project.org',
  positron: 'https://positron.posit.co/download.html',
  livre: 'https://pum.umontreal.ca/catalogue/analyse_causale_et_methodes_quantitatives',
  syllabusPdf: 'syllabus/POL-2000_A26.pdf',
  datacamp: 'https://app.datacamp.com',
  // À remplir par l'enseignant.
  slack: '',
  monportail: '',
  datacampClasse: '',
  rencontres: ''
};

/**
 * partie: 1 concepts de base · 2 régression · 3 inférence causale ·
 * 0 hors matière (rencontres). La semaine de lecture est un élément à part
 * (lecture: true) pour que la frise la dessine sans la compter.
 */
export const SEANCES = [
  { n: 1, court: 'Intro', date: '2026-09-03', partie: 1, titre: 'Introduction et les éléments fondamentaux de la recherche', resume: "Une question, les mots pour la poser, et ce qu'il faut installer.", deck: 'slides/seance-1/' },
  { n: 2, court: 'R et Positron', date: '2026-09-10', partie: 1, titre: 'Introduction à R et à Positron', resume: 'R à partir de zéro, en direct.', note: "Apportez l'ordinateur, R et Positron installés." },
  { n: 3, court: 'Décrire', date: '2026-09-17', partie: 1, titre: 'Les statistiques descriptives et la visualisation des données', resume: "Décrire une variable : la forme d'une distribution, son centre, sa dispersion. Et la dessiner." },
  { n: 4, court: 'Données', date: '2026-09-24', partie: 1, titre: 'Préparer ses données avec R', resume: 'Lire un codebook, recoder, gérer les valeurs manquantes.', note: "L'examen 1 ouvre aujourd'hui." },
  { n: 5, court: 'Inférence', date: '2026-10-01', partie: 1, titre: "L'inférence statistique", resume: 'Ce que je vois dans un échantillon, puis-je le dire de toute la population ?', note: 'Examen 1 à remettre dimanche 4 octobre.' },
  { n: 6, court: 'Rencontres', date: '2026-10-08', partie: 0, titre: 'Rencontres individuelles', resume: "Pas de cours magistral : on se voit, un.e à la fois, avec les auxiliaires et le tuteur." },
  { n: 7, court: 'Régression', date: '2026-10-15', partie: 2, titre: 'La régression linéaire simple', resume: 'Une droite qui résume une relation, et ce que ses chiffres veulent dire.' },
  { n: 8, court: 'Examen 2', date: '2026-10-22', partie: 2, titre: 'Examen 2, puis atelier de mi-session', resume: "Une heure d'examen sur papier, puis on travaille votre devis, ensemble.", note: 'Mi-session à remettre dimanche 25 octobre.', examen: true },
  { lecture: true, date: '2026-10-29', titre: 'Semaine de lecture', resume: 'Aucun cours du 26 au 30 octobre.' },
  { n: 9, court: 'Multiple', date: '2026-11-05', partie: 2, titre: 'La régression linéaire multiple', resume: 'Plusieurs variables explicatives à la fois. Ce que « contrôler pour » veut dire.' },
  { n: 10, court: 'Main, puis IA', date: '2026-11-12', partie: 2, titre: "De la question au tableau de régression : à la main, puis avec l'IA", resume: "Le travail final, du début à la fin. D'abord vous, puis un agent d'IA, et on le vérifie." },
  { n: 11, court: 'GOA', date: '2026-11-19', partie: 3, titre: 'Les graphes orientés acycliques (GOA)', resume: 'Dessiner ses hypothèses causales. Décider quoi contrôler, ou pas.' },
  { n: 12, court: 'Causalité', date: '2026-11-26', partie: 3, titre: "Le problème fondamental de l'inférence causale", resume: 'On ne voit jamais les deux mondes à la fois. Tout part de là.' },
  { n: 13, court: 'Biais', date: '2026-12-03', partie: 3, titre: 'Les biais', resume: 'Variable omise, sélection, mesure, simultanéité : ce qui fausse une régression.' },
  { n: 14, court: 'Expériences', date: '2026-12-10', partie: 3, titre: 'Les expériences, et révision', resume: 'Le hasard comme méthode. Puis on revoit tout.', note: 'Examen 3 en classe · travail final vendredi 18 décembre.', examen: true }
];

export const PARTIES = [
  { n: 1, nom: 'Concepts de base', de: 1, a: 5 },
  { n: 2, nom: 'Régression', de: 7, a: 10 },
  { n: 3, nom: 'Inférence causale', de: 11, a: 14 }
];

/**
 * groupe: ex examens (45 %) · tr travaux (45 %) · dc Datacamp (10 %).
 * `ouvre` marks the first day an evaluation is available (examen 1 only);
 * between `ouvre` and `date` its status is « en cours ».
 */
export const EVALUATIONS = [
  { id: 'examen1', nom: 'Examen 1 · Analyser des données avec R', court: 'Examen 1', groupe: 'ex', poids: 15, ouvre: '2026-09-24', date: '2026-10-04', heure: '23h59', mode: 'À distance, sur ordinateur · boîte de dépôt' },
  { id: 'examen2', nom: 'Examen 2 · Les statistiques descriptives', court: 'Examen 2', groupe: 'ex', poids: 15, date: '2026-10-22', heure: '15h30 à 16h30', mode: 'En classe, sur papier, à livre ouvert · aucun appareil' },
  { id: 'misession', nom: 'Travail de mi-session', court: 'Mi-session', groupe: 'tr', poids: 20, date: '2026-10-25', heure: '23h59', mode: 'Individuel · PDF, boîte de dépôt' },
  { id: 'datacamp1', nom: 'Datacamp · 1re partie', court: 'DC 1', groupe: 'dc', poids: 5, date: '2026-10-25', heure: '23h59', mode: 'Tous les devoirs de la première moitié' },
  { id: 'examen3', nom: 'Examen 3 · Régressions linéaires simple et multiple', court: 'Examen 3', groupe: 'ex', poids: 15, date: '2026-12-10', heure: '15h30 à 16h30', mode: 'En classe, sur papier, à livre ouvert · aucun appareil' },
  { id: 'final', nom: 'Travail final', court: 'Final', groupe: 'tr', poids: 25, date: '2026-12-18', heure: '23h59', mode: 'Individuel · PDF, boîte de dépôt · Positron obligatoire' },
  { id: 'datacamp2', nom: 'Datacamp · 1re et 2e parties', court: 'DC 2', groupe: 'dc', poids: 5, date: '2026-12-18', heure: '23h59', mode: 'Tous les devoirs de la session' }
];

export const EQUIPE = [
  { nom: 'Laurence-Olivier M. Foisy', role: 'Enseignant', photo: 'photo-foisy.jpg', pour: 'le cours, le plan, les notes, les cas particuliers', courriel: 'mail@mfoisy.com', principal: true },
  { nom: 'Jules Piral', role: 'Auxiliaire', photo: 'photo-piral.jpg', pour: 'R, les exercices, les travaux' },
  { nom: 'Marc-Antoine Dupuis', role: 'Auxiliaire', photo: 'photo-dupuis.jpg', pour: 'R, les exercices, les travaux' },
  { nom: 'Adam Ménard', role: 'Tuteur', photo: 'photo-menard.jpg', pour: 'quand ça décroche : on reprend depuis le début' }
];

export const DATACAMP = [
  { groupe: 'Les bases de R', cours: [
    ['Introduction à R', 'https://app.datacamp.com/learn/courses/free-introduction-to-r'],
    ['R intermédiaire', 'https://app.datacamp.com/learn/courses/intermediate-r'],
    ['Introduction au tidyverse', 'https://app.datacamp.com/learn/courses/introduction-to-the-tidyverse']
  ] },
  { groupe: 'Décrire les données', cours: [
    ['Nettoyage de données', 'https://app.datacamp.com/learn/courses/cleaning-data-in-r'],
    ['Manipulation avec dplyr', 'https://app.datacamp.com/learn/courses/data-manipulation-with-dplyr'],
    ['Statistiques descriptives', 'https://app.datacamp.com/learn/courses/introduction-to-statistics-in-r'],
    ['Analyse exploratoire', 'https://app.datacamp.com/learn/courses/exploratory-data-analysis-in-r']
  ] },
  { groupe: 'Inférence et régression', cours: [
    ['Échantillonnage', 'https://app.datacamp.com/learn/courses/sampling-in-r'],
    ["Fondements de l'inférence", 'https://app.datacamp.com/learn/courses/foundations-of-inference-in-r'],
    ['Régression linéaire simple', 'https://app.datacamp.com/learn/courses/introduction-to-regression-in-r'],
    ['Régression multiple', 'https://app.datacamp.com/learn/courses/intermediate-regression-in-r']
  ] }
];
