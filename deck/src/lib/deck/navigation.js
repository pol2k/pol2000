/** Navigation de diapos, en fonctions pures: aucun état global, aucun DOM. */

export function creerDeck(total) {
  if (!Number.isInteger(total) || total < 1) {
    throw new Error('creerDeck: le total doit être un entier supérieur à zéro.');
  }
  return { total, index: 0 };
}

const borner = (n, total) => Math.min(Math.max(n, 0), total - 1);

export function allerA(deck, n) {
  return { ...deck, index: borner(n, deck.total) };
}

export function suivant(deck) {
  return allerA(deck, deck.index + 1);
}

export function precedent(deck) {
  return allerA(deck, deck.index - 1);
}

export function progression(deck) {
  return (deck.index + 1) / deck.total;
}

export function etiquette(deck) {
  return `${deck.index + 1} / ${deck.total}`;
}
