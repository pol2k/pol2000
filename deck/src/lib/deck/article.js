/**
 * Retrouver une phrase dans un article découpé en mots (MOTS : [page, x, y,
 * largeur, hauteur, mot], en % de la page; voir outils/seance8_article.py)
 * et rendre les rectangles à surligner, un par ligne.
 *
 *   trouver(MOTS, 'For this reason, we expect')
 *     → { page, y, rects: [{ page, x, y, l, h }, ...] } ou null
 *
 * La recherche ignore la casse, les espaces, la ponctuation typographique
 * (’ ‘ “ ” deviennent ' et ") et les coupures de mots en fin de ligne
 * (« pre- » + « cisely » = « precisely »). Si la phrase n'est pas trouvée, la
 * fonction lance une erreur : une diapo ne surligne jamais un passage qui
 * n'est pas dans l'article.
 */
const norm = (s) => s.toLowerCase().replace(/[’‘]/g, "'").replace(/[“”]/g, '"').replace(/\s+/g, ' ').trim();

const caches = new WeakMap();

// Le texte continu de l'article, et pour chaque caractère l'indice de son mot.
function indexer(mots) {
  if (caches.has(mots)) return caches.get(mots);
  let texte = '';
  const qui = [];
  for (let i = 0; i < mots.length; i++) {
    const [p, , y, , h, m] = mots[i];
    const suivant = mots[i + 1];
    const finDeLigne = !suivant || suivant[0] !== p || Math.abs(suivant[2] - y) > h * 0.5;
    let t = norm(m);
    // Une coupure en fin de ligne : on recolle le mot, sans le tiret.
    const coupe = finDeLigne && /[a-zà-ÿ]-$/.test(t) && suivant;
    if (coupe) t = t.slice(0, -1);
    for (let c = 0; c < t.length; c++) qui.push(i);
    texte += t;
    if (!coupe) { texte += ' '; qui.push(i); }
  }
  const r = { texte, qui };
  caches.set(mots, r);
  return r;
}

export function trouver(mots, phrase) {
  const { texte, qui } = indexer(mots);
  const cible = norm(phrase);
  const k = texte.indexOf(cible);
  if (k < 0) throw new Error(`Passage introuvable dans l'article : « ${phrase} »`);
  const a = qui[k], b = qui[k + cible.length - 1];
  // Un rectangle par ligne (même page, même hauteur).
  const rects = [];
  for (let i = a; i <= b; i++) {
    const [p, x, y, l, h] = mots[i];
    const der = rects[rects.length - 1];
    if (der && der.page === p && Math.abs(der.y - y) < h * 0.5) {
      der.l = Math.max(der.x + der.l, x + l) - der.x;
      der.h = Math.max(der.h, h);
    } else rects.push({ page: p, x, y, l, h });
  }
  return { page: rects[0].page, y: rects[0].y, fin: rects[rects.length - 1].y + rects[rects.length - 1].h, rects };
}
