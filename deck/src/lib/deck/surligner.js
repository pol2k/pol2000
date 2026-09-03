/**
 * Coloration syntaxique du R, sans dépendance et sans JavaScript côté client.
 * La fonction s'exécute au rendu statique: le HTML produit part déjà colorié,
 * ce qui garde les decks lisibles même si aucun script ne s'exécute.
 */

const MOTS_CLES = new Set([
  'if', 'else', 'for', 'while', 'repeat', 'break', 'next', 'function',
  'in', 'return', 'library', 'require', 'TRUE', 'FALSE', 'NULL', 'NA', 'Inf'
]);

const echapper = (s) =>
  s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

/** Découpe en jetons puis enveloppe chacun dans une classe. */
export function surlignerR(source) {
  const motif = new RegExp(
    [
      '(#[^\\n]*)',                          // 1 commentaire
      '("(?:\\\\.|[^"\\\\])*"|\'(?:\\\\.|[^\'\\\\])*\')', // 2 chaîne
      '(\\b\\d+\\.?\\d*\\b)',                // 3 nombre
      '([A-Za-z._][A-Za-z0-9._]*)(?=\\s*\\()', // 4 appel de fonction
      '([A-Za-z._][A-Za-z0-9._]*)',          // 5 identifiant
      '(<-|->|\\|>|%[^%\\s]*%|[=+\\-*/<>!&|~?:$@])' // 6 opérateur
    ].join('|'),
    'g'
  );

  let sortie = '';
  let dernier = 0;
  let m;

  while ((m = motif.exec(source)) !== null) {
    sortie += echapper(source.slice(dernier, m.index));
    const [txt, com, chaine, nombre, fonction, ident, operateur] = m;

    if (com) sortie += `<span class="r-com">${echapper(com)}</span>`;
    else if (chaine) sortie += `<span class="r-str">${echapper(chaine)}</span>`;
    else if (nombre) sortie += `<span class="r-num">${echapper(nombre)}</span>`;
    else if (fonction)
      sortie += MOTS_CLES.has(fonction)
        ? `<span class="r-cle">${echapper(fonction)}</span>`
        : `<span class="r-fn">${echapper(fonction)}</span>`;
    else if (ident)
      sortie += MOTS_CLES.has(ident)
        ? `<span class="r-cle">${echapper(ident)}</span>`
        : echapper(ident);
    else if (operateur) sortie += `<span class="r-op">${echapper(operateur)}</span>`;
    else sortie += echapper(txt);

    dernier = m.index + txt.length;
  }
  sortie += echapper(source.slice(dernier));
  return sortie;
}
