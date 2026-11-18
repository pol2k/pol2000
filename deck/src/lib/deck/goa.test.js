// Tests de la logique des graphes orientés acycliques (goa.js) et des clés
// des exercices de la séance 11 (seance11-goa.js). Lancer :
//   cd deck && node --test src/lib/deck/goa.test.js
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { descendants, typeMaillon, etatChemin, chemins, portesArriere, identifiable, propagation } from './goa.js';
import { GOA } from '../data/seance11-goa.js';

const A = (g) => GOA[g].aretes;
const cle = (p) => p.join('-');

test('typeMaillon : fourchette, chaîne, collision', () => {
  assert.equal(typeMaillon([['B', 'A'], ['B', 'C']], 'A', 'B', 'C'), 'fourchette');
  assert.equal(typeMaillon([['A', 'B'], ['B', 'C']], 'A', 'B', 'C'), 'chaine');
  assert.equal(typeMaillon([['C', 'B'], ['B', 'A']], 'A', 'B', 'C'), 'chaine');
  assert.equal(typeMaillon([['A', 'B'], ['C', 'B']], 'A', 'B', 'C'), 'collision');
});

test('etatChemin : contrôler le maillon central renverse le flot', () => {
  const f = [['B', 'A'], ['B', 'C']];
  assert.equal(etatChemin(f, ['A', 'B', 'C'], []).ouvert, true);
  assert.equal(etatChemin(f, ['A', 'B', 'C'], ['B']).ouvert, false);
  const ch = [['A', 'B'], ['B', 'C']];
  assert.equal(etatChemin(ch, ['A', 'B', 'C'], []).ouvert, true);
  assert.equal(etatChemin(ch, ['A', 'B', 'C'], ['B']).ouvert, false);
  const co = [['A', 'B'], ['C', 'B']];
  assert.equal(etatChemin(co, ['A', 'B', 'C'], []).ouvert, false);
  assert.equal(etatChemin(co, ['A', 'B', 'C'], ['B']).ouvert, true);
  const m = etatChemin(co, ['A', 'B', 'C'], []).maillons;
  assert.deepEqual(m, [{ id: 'B', type: 'collision', ouvert: false }]);
});

test('contrôler le descendant d’une collision ouvre le chemin (p. 123)', () => {
  assert.equal(etatChemin(A('collisionDescendant'), ['A', 'B', 'C'], []).ouvert, false);
  assert.equal(etatChemin(A('collisionDescendant'), ['A', 'B', 'C'], ['D']).ouvert, true);
});

test('combinaisons (p. 123-124)', () => {
  const o = ['A', 'B', 'C', 'D', 'E'];
  assert.equal(etatChemin(A('combinaisonOuverte'), o, []).ouvert, true);
  assert.equal(etatChemin(A('combinaisonFermee'), o, []).ouvert, false);
  assert.equal(etatChemin(A('combinaisonOuverte'), o, ['D']).ouvert, false);
  assert.equal(etatChemin(A('combinaisonFermee'), o, ['B']).ouvert, true);
});

test('un nœud prend son type chemin par chemin (figure 6.1 G)', () => {
  const g = A('sim5');
  assert.equal(etatChemin(g, ['X', 'Z2', 'Y'], []).maillons[0].type, 'chaine');
  const m = etatChemin(g, ['X', 'Z2', 'Z3', 'Y'], []).maillons;
  assert.deepEqual(m.map((x) => x.type), ['chaine', 'collision']);
});

test('descendants', () => {
  assert.deepEqual(descendants(A('education'), 'education'), new Set(['revenu_ind', 'ideologie']));
  assert.deepEqual(descendants(A('orienteCause'), 'A'), new Set(['B', 'C']));
});

test('figure 6.1 G : trois chemins, une porte arrière, contrôler Z1 seulement', () => {
  const g = A('sim5');
  const cs = chemins(g, 'X', 'Y').map(cle).sort();
  assert.deepEqual(cs, ['X-Z1-Y', 'X-Z2-Y', 'X-Z2-Z3-Y']);
  assert.deepEqual(portesArriere(g, 'X', 'Y').map(cle), ['X-Z1-Y']);
  assert.deepEqual(identifiable(g, 'X', 'Y', ['Z1']), { condition1: true, condition2: true, fautifs: [] });
  assert.equal(identifiable(g, 'X', 'Y', ['Z1', 'Z2']).condition1, false);
  assert.deepEqual(identifiable(g, 'X', 'Y', ['Z1', 'Z2']).fautifs, ['Z2']);
  assert.equal(identifiable(g, 'X', 'Y', []).condition2, false);
});

const ok = (g, x, y, c) => {
  const r = identifiable(A(g), x, y, c);
  return r.condition1 && r.condition2;
};

test('éducation : contrôler le revenu des parents, pas le revenu individuel', () => {
  assert.equal(ok('education', 'education', 'ideologie', ['revenu_parents']), true);
  assert.equal(ok('education', 'education', 'ideologie', ['revenu_ind']), false);
  assert.equal(ok('education', 'education', 'ideologie', []), false);
});

test('séance 8 : contrôler le revenu était une erreur', () => {
  assert.equal(ok('escalier8', 'scolarite', 'interet', ['age']), true);
  assert.equal(ok('escalier8', 'scolarite', 'interet', ['age', 'revenu']), false);
  assert.equal(identifiable(A('escalier8'), 'scolarite', 'interet', ['age', 'revenu']).fautifs[0], 'revenu');
});

test('les quatre chaînes et les deux rappels', () => {
  const o = ['X', 'Z1', 'Z2', 'Z3', 'Y'];
  assert.equal(etatChemin(A('drill1'), o, []).ouvert, true);
  assert.equal(etatChemin(A('drill2'), o, []).ouvert, false);
  assert.equal(etatChemin(A('drill3'), o, []).ouvert, true);
  assert.equal(etatChemin(A('drill4'), o, []).ouvert, false);
  assert.equal(etatChemin(A('drill2'), o, ['Z1']).ouvert, true);
  assert.equal(etatChemin(A('drill3'), o, ['Z2']).ouvert, false);
});

test('exercice 1 (goa27) : contrôler Z3', () => {
  assert.deepEqual(descendants(A('exercice1'), 'X'), new Set(['Z1', 'Z2', 'Z4', 'Z5', 'Y']));
  assert.deepEqual(portesArriere(A('exercice1'), 'X', 'Y').map(cle).sort(), ['X-Z3-Z2-Y', 'X-Z3-Z2-Z4-Z5-Y']);
  assert.equal(ok('exercice1', 'X', 'Y', ['Z3']), true);
  assert.equal(ok('exercice1', 'X', 'Y', []), false);
});

test('exercice 2 (goa29) : contrôler Z4', () => {
  const d = descendants(A('exercice2'), 'X');
  for (const z of ['Z1', 'Z2', 'Z3']) assert.ok(d.has(z), z);
  assert.equal(d.has('Z4'), false);
  assert.equal(ok('exercice2', 'X', 'Y', ['Z4']), true);
  assert.equal(ok('exercice2', 'X', 'Y', []), false);
});

test('exercice 3 (le tabac) : contrôler Z3 ou Z2, jamais Z1', () => {
  assert.equal(ok('exercice3', 'fumer', 'arret', ['vie']), true);
  assert.equal(ok('exercice3', 'fumer', 'arret', ['poids']), true);
  assert.equal(ok('exercice3', 'fumer', 'arret', ['cholesterol']), false);
  assert.equal(ok('exercice3', 'fumer', 'arret', []), false);
});

test('chaque graphe : arêtes entre nœuds déclarés, aucun cycle', () => {
  for (const [nom, g] of Object.entries(GOA)) {
    const ids = new Set(g.noeuds.map((n) => n.id));
    for (const [a, b] of g.aretes) assert.ok(ids.has(a) && ids.has(b), `${nom} : ${a}→${b}`);
    if (nom === 'acycliqueMauvais') continue;
    for (const n of ids) assert.equal(descendants(g.aretes, n).has(n), false, `${nom} : cycle par ${n}`);
  }
});

// Les cadrans (M11Cadrans) : on fait bouger le premier bout, qui suit ?
// 1 = même sens, -1 = sens contraire, 0 = immobile.
const sens = (aretes, chemin, controles = []) => propagation(aretes, chemin, controles).map((n) => n.sens);
const fl = (txt) => {
  const t = txt.split(/\s*([←→])\s*/);
  const n = t.filter((_, i) => i % 2 === 0);
  const ar = t.filter((_, i) => i % 2 === 1).map((f, i) => (f === '→' ? [n[i], n[i + 1]] : [n[i + 1], n[i]]));
  return [ar, n];
};

test('propagation : fourchette et chaîne, le milieu suit, puis le bout', () => {
  assert.deepEqual(sens(...fl('A ← B → C')), [1, 1, 1]);
  assert.deepEqual(sens(...fl('A → B → C')), [1, 1, 1]);
});

test('propagation : fourchette et chaîne fixées, rien ne passe le milieu', () => {
  assert.deepEqual(sens(...fl('A ← B → C'), ['B']), [1, 0, 0]);
  assert.deepEqual(sens(...fl('A → B → C'), ['B']), [1, 0, 0]);
  const p = propagation(...fl('A → B → C'), ['B']);
  assert.deepEqual(p.map((n) => n.fixe), [false, true, false]);
});

test('propagation : collision, le milieu bouge, l’autre bout non', () => {
  assert.deepEqual(sens(...fl('A → B ← C')), [1, 1, 0]);
});

test('propagation : collision fixée, l’autre bout bouge en sens contraire (p. 122)', () => {
  assert.deepEqual(sens(...fl('A → B ← C'), ['B']), [1, 0, -1]);
});

test('propagation : un descendant contrôlé ouvre la collision sans la fixer', () => {
  const ar = A('collisionDescendant');
  assert.deepEqual(sens(ar, ['A', 'B', 'C'], []), [1, 1, 0]);
  assert.deepEqual(sens(ar, ['A', 'B', 'C'], ['D']), [1, 1, -1]);
});

test('propagation : les quatre chemins de l’exercice', () => {
  assert.deepEqual(sens(...fl('X → Z1 → Z2 → Z3 → Y')), [1, 1, 1, 1, 1]);
  assert.deepEqual(sens(...fl('X → Z1 ← Z2 → Z3 → Y')), [1, 1, 0, 0, 0]);
  assert.deepEqual(sens(...fl('X ← Z1 ← Z2 → Z3 → Y')), [1, 1, 1, 1, 1]);
  assert.deepEqual(sens(...fl('X → Z1 ← Z2 → Z3 ← Y')), [1, 1, 0, 0, 0]);
  assert.deepEqual(sens(...fl('X → Z1 ← Z2 → Z3 → Y'), ['Z1']), [1, 0, -1, -1, -1]);
  assert.deepEqual(sens(...fl('X ← Z1 ← Z2 → Z3 → Y'), ['Z2']), [1, 1, 0, 0, 0]);
});

test('propagation : le bout d’arrivée bouge si et seulement si le chemin est ouvert', () => {
  for (const ch of ['A ← B ← C ← D → E', 'A → B ← C → D → E']) {
    for (const c of [[], ['B'], ['C'], ['B', 'D']]) {
      const [ar, n] = fl(ch);
      assert.equal(propagation(ar, n, c).at(-1).sens !== 0, etatChemin(ar, n, c).ouvert, `${ch} ${c}`);
    }
  }
});

test('l’article du début (faim) : trois portes arrière, ouvertes puis fermées', () => {
  const a = A('faim');
  const portes = portesArriere(a, 'insecurite', 'satisfaction').map(cle).sort();
  assert.deepEqual(portes, ['insecurite-age-satisfaction', 'insecurite-enfants-satisfaction', 'insecurite-naissance-satisfaction']);
  for (const z of ['age', 'enfants', 'naissance']) {
    assert.equal(etatChemin(a, ['insecurite', z, 'satisfaction'], []).ouvert, true);
    assert.equal(etatChemin(a, ['insecurite', z, 'satisfaction'], ['age', 'enfants', 'naissance']).ouvert, false);
  }
  assert.equal(identifiable(a, 'insecurite', 'satisfaction', []).condition2, false);
  assert.equal(identifiable(a, 'insecurite', 'satisfaction', ['age', 'enfants', 'naissance']).condition2, true);
});
