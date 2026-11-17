/**
 * Tous les graphes de la séance 11, au même endroit : les diapos les
 * dessinent (Goa.svelte) et les tests (src/lib/deck/goa.test.js) vérifient
 * les clés des exercices sur ces mêmes définitions.
 *
 * Un nœud : { id, label, x, y }. Les coordonnées sont libres (Goa.svelte
 * cadre le dessin sur ses nœuds); y descend. Dans un label, « \n » coupe la
 * ligne et « _1 » s'écrit en indice (Z₁).
 * Une arête : [cause, effet] ou [cause, effet, coefficient].
 *
 * Sources. Arel-Bundock (2021), chapitre 6 : éducation et idéologie
 * (p. 116), A → B → C (p. 117), cycles (p. 118), collision et descendant
 * (p. 123), combinaisons (p. 123-124), salaire (p. 125), itinérance
 * (p. 126), simulations 1 à 5 (p. 132-135). Le deck de 2024 (L.-O. M.
 * Foisy et A. Cloutier) : la ceinture, la crème glacée et le mercure, le
 * sucre, les quatre chaînes, les deux rappels et les trois exercices
 * (images goa17 à goa31). Exercice 3 : la clé de 2024 disait « Z3 »; le
 * poids (Z2) ferme aussi la porte arrière et n'est pas un descendant du
 * tabac : la clé devient « Z3 ou Z2 » (vérifié par goa.test.js).
 */

const ligne = (ids, pas = 250) => ids.map((id, i) => ({ id, label: id.replace(/(\d)$/, '_$1'), x: i * pas, y: 0 }));

export const GOA = {
  // ---------- dessiner un GOA (p. 116)
  education: {
    x: 'education', y: 'ideologie',
    noeuds: [
      { id: 'revenu_parents', label: 'Revenu\ndes parents', x: 0, y: 0 },
      { id: 'revenu_ind', label: 'Revenu\nindividuel', x: 450, y: 0 },
      { id: 'education', label: 'Éducation', x: 0, y: 260 },
      { id: 'ideologie', label: 'Idéologie\npolitique', x: 900, y: 260 }
    ],
    aretes: [
      ['education', 'revenu_ind'],
      ['revenu_ind', 'ideologie'],
      ['revenu_parents', 'education'],
      ['revenu_parents', 'revenu_ind'],
      ['education', 'ideologie']
    ]
  },

  // ---------- orienté, acyclique
  orienteCause: { noeuds: ligne(['A', 'B', 'C'], 300), aretes: [['A', 'B'], ['B', 'C']] },
  orientePasCause: { noeuds: ligne(['A', 'B', 'C'], 300), aretes: [['A', 'B'], ['C', 'B']] },
  acycliqueBon: {
    noeuds: [
      { id: 'A', label: 'A', x: 0, y: 0 },
      { id: 'B', label: 'B', x: 300, y: 0 },
      { id: 'D', label: 'D', x: 600, y: 0 },
      { id: 'C', label: 'C', x: 150, y: 220 }
    ],
    aretes: [['A', 'B'], ['B', 'D'], ['B', 'C']]
  },
  acycliqueMauvais: {
    noeuds: [
      { id: 'A', label: 'A', x: 0, y: 0 },
      { id: 'B', label: 'B', x: 300, y: 0 },
      { id: 'D', label: 'D', x: 600, y: 0 },
      { id: 'C', label: 'C', x: 150, y: 220 }
    ],
    aretes: [['A', 'B'], ['B', 'D'], ['B', 'C'], ['C', 'A']]
  },

  // ---------- effet causal et information statistique
  glace: {
    noeuds: [
      { id: 'temperature', label: 'Température', x: 0, y: 130 },
      { id: 'glace', label: 'Ventes de\ncrème glacée', x: 520, y: 0 },
      { id: 'mercure', label: 'Mercure', x: 520, y: 260 }
    ],
    aretes: [['temperature', 'glace'], ['temperature', 'mercure']]
  },
  ceinture: {
    noeuds: [
      { id: 'risque', label: 'Comportement\nrisqué', x: 0, y: 0 },
      { id: 'ceinture', label: 'Ne pas porter\nsa ceinture', x: 520, y: 0 },
      { id: 'blessure', label: 'Se blesser\ngravement', x: 1040, y: 0 }
    ],
    aretes: [['risque', 'ceinture'], ['ceinture', 'blessure']]
  },

  // ---------- les trois types de chemins
  fourchetteABC: { noeuds: ligne(['A', 'B', 'C'], 260), aretes: [['B', 'A'], ['B', 'C']] },
  chaineABC: { noeuds: ligne(['A', 'B', 'C'], 260), aretes: [['A', 'B'], ['B', 'C']] },
  collisionABC: { noeuds: ligne(['A', 'B', 'C'], 260), aretes: [['A', 'B'], ['C', 'B']] },
  sucre: {
    noeuds: [
      { id: 'sucre', label: 'Consommation\nde sucre', x: 0, y: 0 },
      { id: 'diabete', label: 'Diabète\nde type 2', x: 520, y: 0 },
      { id: 'coeur', label: 'Maladies\ncardiovasculaires', x: 1040, y: 0 }
    ],
    aretes: [['sucre', 'diabete'], ['diabete', 'coeur']]
  },
  arbitre: {
    noeuds: [
      { id: 'performance', label: 'Performance\nde l’équipe', x: 0, y: 0 },
      { id: 'victoire', label: 'Victoire', x: 520, y: 0 },
      { id: 'biais', label: 'Biais de\nl’arbitre', x: 1040, y: 0 }
    ],
    aretes: [['performance', 'victoire'], ['biais', 'victoire']]
  },
  collisionDescendant: {
    noeuds: [
      { id: 'A', label: 'A', x: 0, y: 0 },
      { id: 'B', label: 'B', x: 300, y: 0 },
      { id: 'C', label: 'C', x: 600, y: 0 },
      { id: 'D', label: 'D', x: 300, y: 220 }
    ],
    aretes: [['A', 'B'], ['C', 'B'], ['B', 'D']]
  },
  combinaisonOuverte: { noeuds: ligne(['A', 'B', 'C', 'D', 'E'], 230), aretes: [['B', 'A'], ['C', 'B'], ['D', 'C'], ['D', 'E']] },
  combinaisonFermee: { noeuds: ligne(['A', 'B', 'C', 'D', 'E'], 230), aretes: [['A', 'B'], ['C', 'B'], ['C', 'D'], ['D', 'E']] },

  // ---------- les deux conditions
  salaire: {
    x: 'sexe', y: 'salaire',
    noeuds: [
      { id: 'occupation', label: 'Occupation', x: 450, y: 0 },
      { id: 'sexe', label: 'Sexe', x: 0, y: 240 },
      { id: 'salaire', label: 'Salaire', x: 900, y: 240 }
    ],
    aretes: [['sexe', 'occupation'], ['occupation', 'salaire'], ['sexe', 'salaire']]
  },
  itinerance: {
    x: 'eclatement', y: 'itinerance',
    noeuds: [
      { id: 'sante', label: 'Santé mentale', x: 450, y: 0 },
      { id: 'eclatement', label: 'Éclatement\nfamilial', x: 0, y: 240 },
      { id: 'itinerance', label: 'Itinérance', x: 900, y: 240 }
    ],
    aretes: [['sante', 'eclatement'], ['sante', 'itinerance'], ['eclatement', 'itinerance']]
  },
  // La séance 8 (M8Escalier) : intérêt pour la politique selon la scolarité,
  // avec l'âge, puis le revenu, comme contrôles.
  escalier8: {
    x: 'scolarite', y: 'interet',
    noeuds: [
      { id: 'revenu', label: 'Revenu', x: 450, y: 0 },
      { id: 'scolarite', label: 'Scolarité', x: 0, y: 220 },
      { id: 'interet', label: 'Intérêt pour\nla politique', x: 900, y: 220 },
      { id: 'age', label: 'Âge', x: 450, y: 440 }
    ],
    aretes: [['scolarite', 'revenu'], ['revenu', 'interet'], ['scolarite', 'interet'], ['age', 'scolarite'], ['age', 'interet']]
  },

  // ---------- pratique : quatre chaînes (goa17, 19, 21, 23) et deux rappels (goa25, 26)
  drill1: { noeuds: ligne(['X', 'Z1', 'Z2', 'Z3', 'Y']), aretes: [['X', 'Z1'], ['Z1', 'Z2'], ['Z2', 'Z3'], ['Z3', 'Y']] },
  drill2: { noeuds: ligne(['X', 'Z1', 'Z2', 'Z3', 'Y']), aretes: [['X', 'Z1'], ['Z2', 'Z1'], ['Z2', 'Z3'], ['Z3', 'Y']] },
  drill3: { noeuds: ligne(['X', 'Z1', 'Z2', 'Z3', 'Y']), aretes: [['Z1', 'X'], ['Z2', 'Z1'], ['Z2', 'Z3'], ['Z3', 'Y']] },
  drill4: { noeuds: ligne(['X', 'Z1', 'Z2', 'Z3', 'Y']), aretes: [['X', 'Z1'], ['Z2', 'Z1'], ['Z2', 'Z3'], ['Y', 'Z3']] },

  // ---------- trois exercices (goa27, goa29, goa31)
  exercice1: {
    x: 'X', y: 'Y',
    noeuds: [
      { id: 'X', label: 'X', x: 0, y: 160 },
      { id: 'Z4', label: 'Z_4', x: 320, y: 0 },
      { id: 'Z1', label: 'Z_1', x: 320, y: 160 },
      { id: 'Z3', label: 'Z_3', x: 320, y: 320 },
      { id: 'Z5', label: 'Z_5', x: 680, y: 0 },
      { id: 'Z2', label: 'Z_2', x: 680, y: 160 },
      { id: 'Y', label: 'Y', x: 1000, y: 160 }
    ],
    aretes: [['X', 'Z4'], ['X', 'Z1'], ['Z4', 'Z5'], ['Z4', 'Z2'], ['Z2', 'Z1'], ['Z2', 'Y'], ['Z5', 'Y'], ['Z3', 'X'], ['Z3', 'Z2']]
  },
  exercice2: {
    x: 'X', y: 'Y',
    noeuds: [
      { id: 'Z4', label: 'Z_4', x: 260, y: 0 },
      { id: 'Z3', label: 'Z_3', x: 640, y: 50 },
      { id: 'X', label: 'X', x: 0, y: 200 },
      { id: 'Y', label: 'Y', x: 1000, y: 200 },
      { id: 'Z1', label: 'Z_1', x: 330, y: 380 },
      { id: 'Z2', label: 'Z_2', x: 680, y: 480 }
    ],
    aretes: [['Z4', 'X'], ['Z4', 'Z3'], ['X', 'Z3'], ['Z3', 'Y'], ['X', 'Y'], ['X', 'Z1'], ['Z1', 'Y'], ['Z1', 'Z2'], ['Y', 'Z2']]
  },
  exercice3: {
    x: 'fumer', y: 'arret',
    noeuds: [
      { id: 'arret', label: 'Arrêt cardiaque (Y)', x: 0, y: 0 },
      { id: 'cholesterol', label: 'Cholestérol (Z_1)', x: 0, y: 170 },
      { id: 'fumer', label: 'Fumer (X)', x: 0, y: 340 },
      { id: 'poids', label: 'Poids (Z_2)', x: 640, y: 170 },
      { id: 'vie', label: 'Vie malsaine (Z_3)', x: 640, y: 340 }
    ],
    aretes: [['cholesterol', 'arret'], ['fumer', 'cholesterol'], ['poids', 'cholesterol'], ['vie', 'fumer'], ['vie', 'poids']]
  },

  // ---------- simulations (p. 132-135), avec les coefficients
  sim1: { x: 'X', y: 'Y', noeuds: ligne(['X', 'Y'], 420), aretes: [['X', 'Y', 1.7]] },
  sim2: { x: 'X', y: 'Y', noeuds: ligne(['X', 'Z', 'Y'], 360), aretes: [['X', 'Z', 3], ['Z', 'Y', 0.5]] },
  sim3: {
    x: 'X', y: 'Y',
    noeuds: [
      { id: 'X', label: 'X', x: 0, y: 0 },
      { id: 'Y', label: 'Y', x: 600, y: 0 },
      { id: 'Z', label: 'Z', x: 300, y: 240 }
    ],
    aretes: [['X', 'Y', 1.7], ['X', 'Z', 1.2], ['Y', 'Z', 0.8]]
  },
  sim4: {
    x: 'X', y: 'Y',
    noeuds: [
      { id: 'Z2', label: 'Z_2', x: 360, y: 0 },
      { id: 'X', label: 'X', x: 0, y: 240 },
      { id: 'Z1', label: 'Z_1', x: 360, y: 240 },
      { id: 'Y', label: 'Y', x: 720, y: 240 }
    ],
    aretes: [['Z2', 'X', 1], ['X', 'Z1', 2], ['Z1', 'Y', 0.25], ['Z2', 'Y', 1]]
  },
  sim5: {
    x: 'X', y: 'Y',
    noeuds: [
      { id: 'Z1', label: 'Z_1', x: 360, y: 0 },
      { id: 'X', label: 'X', x: 0, y: 220 },
      { id: 'Z2', label: 'Z_2', x: 360, y: 220 },
      { id: 'Y', label: 'Y', x: 720, y: 220 },
      { id: 'Z3', label: 'Z_3', x: 540, y: 430 }
    ],
    aretes: [['Z1', 'X', 1], ['X', 'Z2', 2], ['Z2', 'Y', 0.5], ['Z1', 'Y', 1], ['Z2', 'Z3', 1], ['Y', 'Z3', 1]]
  }
};
