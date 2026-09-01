# POL-2000 — Méthodologie quantitative — plan de cours (référence)

> **Source of truth for course content.** Extracted from
> `reference/POL-2000_H24_18043.pdf` (NRC 18043, Hiver 2024).
> That PDF is a *previous* offering taught by another instructor. The
> **course description, objectives and three-part content structure are
> institutionally fixed** and carry over. The **calendar, dates, NRC,
> teaching staff and evaluation weights are from H24 and must be
> re-confirmed** for the current offering before anything student-facing
> is published.
>
> When course content is in question, this file wins over anything found
> in `slides/`. See `AGENTS.md`.

## Identification

- **Sigle** : POL-2000 — Méthodologie quantitative
- **Établissement** : Université Laval, Faculté des sciences sociales,
  Département de science politique
- **Crédits** : 3 — temps consacré 3-0-6
- **Enseignant (offre actuelle)** : Laurence-Olivier M. Foisy — mail@mfoisy.com
- **Cycle** : premier cycle (undergraduate)
- **Préalables** : POL 1000-4999 (9 crédits) ET POL 1010, ou équivalents
  (SOC 1005, SVS 1004, ANT 1002, LNG 1002, ORT 1001, GPL 1001, GPL 1009)

## Description officielle

Introduction aux méthodes de la recherche quantitative en sciences
sociales. Survol des notions de base (échantillon et population, variable
et constante, niveaux de mesure, types de données), puis les techniques
statistiques permettant de décrire une variable (analyse univariée), de
dégager les relations entre deux ou plusieurs variables (analyses bivariée
et multivariée) et de tirer des conclusions sur une population à partir
d'un échantillon (statistiques inférentielles).

**Contrainte pédagogique centrale : aucune connaissance avancée des
mathématiques n'est nécessaire.** Aucun cours de mathématique ni de
statistique au-delà du secondaire n'est prérequis. Les fondements
mathématiques ne sont pas approfondis.

## Objectifs

Au terme du cours, l'étudiant.e sera en mesure de :

1. Maîtriser les concepts et techniques propres à l'analyse statistique;
2. Utiliser les fonctions de base de R et de RStudio pour le traitement de
   données;
3. Comprendre et critiquer des articles scientifiques faisant appel à des
   techniques statistiques;
4. Comprendre la logique de l'analyse causale et ses limites;
5. Concevoir et réaliser son propre projet de recherche.

## Contenu — trois thématiques

### Partie 1 — Introduction aux concepts statistiques de base

- Opérationnaliser une question de recherche de façon quantitative
- Les types de variables
- Les distributions de fréquences et de pourcentages
- Les mesures de tendance centrale
- Les mesures de variation

### Partie 2 — Régression linéaire bivariée et multiple

- La logique derrière la régression linéaire
- Interpréter des coefficients de variables continues, binaires et
  catégoriques
- Interpréter le niveau de signification statistique
- Interpréter les tableaux bivariés
- La régression et la corrélation simple avec R
- Interpréter des coefficients lorsqu'il y a plus d'une variable
  explicative
- L'analyse tabulaire multivariée

### Partie 3 — L'inférence causale

- Le problème fondamental de l'inférence causale
- Les variables de contrôle : lesquelles ajouter (ou pas) à une régression
- Les graphes orientés acycliques (GOA / DAG)
- Les biais possibles et leurs effets sur la régression linéaire

## Calendrier H24 (gabarit — dates à refaire)

15 semaines. Dates ci-dessous = offre H24, conservées pour la **structure**
seulement.

| Sem. | Titre | Date H24 |
|---|---|---|
| 1 | Introduction | 17 janv. 2024 |
| 2 | Les éléments fondamentaux de la recherche | 24 janv. 2024 |
| 3 | Les statistiques descriptives | 31 janv. 2024 |
| 4 | Introduction à R | 7 févr. 2024 |
| 5 | L'inférence statistique | 14 févr. 2024 |
| 6 | Rencontres individuelles | 21 févr. 2024 |
| 7 | Régression linéaire simple | 28 févr. 2024 |
| 8 | Semaine de lecture (aucun cours) | 6 mars 2024 |
| 9 | Régression linéaire multiple | 13 mars 2024 |
| 10 | Régression linéaire avec R | 20 mars 2024 |
| 11 | Les graphes orientés acycliques (GOA) | 27 mars 2024 |
| 12 | Le problème fondamental de l'inférence causale | 3 avr. 2024 |
| 13 | Rencontres individuelles | 10 avr. 2024 |
| 14 | Les biais | 17 avr. 2024 |
| 15 | Les expériences et révision | 24 avr. 2024 |

Note : l'ordre H24 introduit R à la semaine 4, après les statistiques
descriptives à la semaine 3.

## Évaluations H24 (à reconfirmer)

| Regroupement | Évaluation | Pondération | Modalité |
|---|---|---|---|
| Examens (45 %) | Examen 1 — Analyser des données avec R | 15 % | À distance, boîte de dépôt, fenêtre de ~10 jours |
| | Examen 2 — Les statistiques descriptives | 15 % | En classe, 1 h, papier et crayon seulement |
| | Examen 3 — Régressions simple et multiple | 15 % | En classe, 1 h, papier et crayon seulement |
| Travaux (45 %) | Travail de mi-session | 20 % | Individuel, PDF |
| | Travail final | 25 % | Individuel, PDF, RStudio obligatoire |
| Exercices (10 %) | Datacamp 1re partie | 5 % | Datacamp.com |
| | Datacamp 1re + 2e partie | 5 % | Datacamp.com |

### Travail de mi-session (20 %)

Version courte du travail final, à l'image d'un devis de recherche, pour
obtenir une rétroaction avant la remise finale. L'étudiant.e doit :

- Concevoir une question de recherche mettant en relation une variable
  dépendante et une variable indépendante;
- Présenter une courte revue de la littérature permettant de dériver des
  hypothèses testables;
- Formuler une ou des hypothèses (et leur hypothèse nulle);
- Présenter la base de données et les variables sélectionnées;
- Justifier la pertinence et l'originalité de la question;
- Énoncer la contribution souhaitée à la littérature;
- Conclure par une justification personnelle du choix de recherche.

### Travail final (25 %)

Projet de recherche complet sur une banque de données fournie. S'ajoute au
mi-session :

- Inclure un graphe orienté acyclique (GOA);
- Présenter des statistiques descriptives;
- Exécuter une régression linéaire et présenter le tableau de régression;
- Interpréter les résultats;
- Considérer les biais potentiels, discuter des limites, et réfléchir à
  une méthode alternative pour estimer l'effet causal d'intérêt.

## Matériel

- **Livre obligatoire** : Arel-Bundock, Vincent. 2021. *Analyse causale et
  méthodes quantitatives : Une introduction avec R, Stata et SPSS*.
  Presses de l'Université de Montréal. Disponible gratuitement en PDF.
- **Logiciels** : R et RStudio.
- **Exercices** : Datacamp (H24 — à reconfirmer, licence institutionnelle
  requise).

## Approche pédagogique

Cours magistral, échanges encouragés. Les étudiant.e.s suivent le cours sur
leur ordinateur personnel; le professeur fait régulièrement des
démonstrations avec R et RStudio à suivre en direct. Chaque semaine
présente : objectifs spécifiques, lectures préalables, exercices, et les
diapositives. Un glossaire des notions clefs accompagne le cours.

## Décisions ouvertes pour l'offre actuelle

Ces points ne sont **pas** tranchés par le PDF H24 et attendent une
décision de l'enseignant — voir les issues beads correspondantes.

- Session et dates exactes (le PDF est H24; `course_config.json` contient
  encore un calendrier hérité de janvier 2026).
- Maintien ou non de Datacamp.
- Maintien du format des examens en présence (papier et crayon).
- Banque de données imposée pour le travail final.
- Formule d'enseignement (H24 : à distance, classe virtuelle synchrone).
