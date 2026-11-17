/**
 * La logique des graphes orientés acycliques (GOA), d'après Arel-Bundock
 * (2021), Analyse causale et méthodes quantitatives, chapitre 6.
 *
 * Une arête est [de, vers] ou [de, vers, coef] : la cause, puis l'effet.
 * Rien ici ne dessine. Goa.svelte demande à ce module si un chemin est
 * ouvert ou fermé : le verdict affiché est toujours calculé, jamais écrit
 * à la main (le deck de 2024 avait dessiné une fourchette « fermée » qui
 * était en fait une collision contrôlée).
 *
 * Les règles (p. 119 à 124) :
 *   - fourchette A ← B → C et chaîne A → B → C : ouvertes, fermées si on
 *     contrôle le maillon central;
 *   - collision A → B ← C : fermée, ouverte si on contrôle le maillon
 *     central ou un de ses descendants (p. 123);
 *   - un chemin est ouvert si, et seulement si, tous ses maillons le sont.
 * L'identification (p. 124 à 126) : condition 1, ne pas contrôler un
 * descendant de X; condition 2, tous les chemins par la porte arrière
 * (une extrémité pointe vers X) sont fermés.
 */

const a = (aretes, de, vers) => aretes.some(([p, q]) => p === de && q === vers);

/** Les descendants de `id` : tout ce qui est en aval (sans `id`). */
export function descendants(aretes, id) {
  const vus = new Set();
  const pile = [id];
  while (pile.length) {
    const n = pile.pop();
    for (const [p, q] of aretes) {
      if (p === n && !vus.has(q)) {
        vus.add(q);
        pile.push(q);
      }
    }
  }
  vus.delete(id);
  return vus;
}

/** Le type du maillon central b entre ses voisins a et c sur un chemin. */
export function typeMaillon(aretes, x, b, y) {
  const versB1 = a(aretes, x, b);
  const versB2 = a(aretes, y, b);
  if (versB1 && versB2) return 'collision';
  if (!versB1 && !versB2) return 'fourchette';
  return 'chaine';
}

/**
 * L'état d'un chemin (liste de nœuds, d'une extrémité à l'autre) quand on
 * contrôle `controles`. Chaque maillon intérieur reçoit son type et son état.
 */
export function etatChemin(aretes, chemin, controles = []) {
  const c = new Set(controles);
  const maillons = [];
  for (let i = 1; i < chemin.length - 1; i++) {
    const id = chemin[i];
    const type = typeMaillon(aretes, chemin[i - 1], id, chemin[i + 1]);
    let ouvert;
    if (type === 'collision') {
      ouvert = c.has(id) || [...descendants(aretes, id)].some((d) => c.has(d));
    } else {
      ouvert = !c.has(id);
    }
    maillons.push({ id, type, ouvert });
  }
  return { ouvert: maillons.every((m) => m.ouvert), maillons };
}

/** Tous les chemins simples entre x et y, sans égard au sens des flèches. */
export function chemins(aretes, x, y) {
  const voisins = (n) => aretes.flatMap(([p, q]) => (p === n ? [q] : q === n ? [p] : []));
  const out = [];
  const marcher = (n, trajet) => {
    if (n === y) return out.push(trajet);
    for (const v of new Set(voisins(n))) if (!trajet.includes(v)) marcher(v, [...trajet, v]);
  };
  marcher(x, [x]);
  return out;
}

/** Les chemins par la porte arrière : ceux dont la première flèche pointe vers x. */
export function portesArriere(aretes, x, y) {
  return chemins(aretes, x, y).filter((p) => a(aretes, p[1], x));
}

/** Les deux conditions de l'identification de l'effet de x sur y. */
export function identifiable(aretes, x, y, controles = []) {
  const desc = descendants(aretes, x);
  const fautifs = controles.filter((c) => desc.has(c));
  const condition2 = portesArriere(aretes, x, y).every((p) => !etatChemin(aretes, p, controles).ouvert);
  return { condition1: fautifs.length === 0, condition2, fautifs };
}
