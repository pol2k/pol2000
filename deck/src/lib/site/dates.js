/**
 * Date arithmetic for the landing page: which séance is next, which
 * deadlines are close, how far along the session is. Pure functions of an
 * ISO date string so the build can prerender for the build day and the
 * browser can recompute for today.
 *
 * All dates are calendar days in Québec; comparisons are on the ISO string
 * (YYYY-MM-DD), so no time-zone conversion is involved.
 */
import { EVALUATIONS, SEANCES } from '$lib/data/cours.js';

const MS_JOUR = 86_400_000;

export function aujourdhui() {
  const d = new Date();
  // Local calendar date, not UTC: a student at 22h in Québec is still on
  // Thursday even though UTC has moved on.
  return [d.getFullYear(), String(d.getMonth() + 1).padStart(2, '0'), String(d.getDate()).padStart(2, '0')].join('-');
}

export function ecart(iso, ref) {
  return Math.round((Date.parse(iso) - Date.parse(ref)) / MS_JOUR);
}

/** « jeudi 10 septembre » — fr-CA, sans l'année. */
export function longue(iso) {
  const d = new Date(iso + 'T12:00:00');
  return d.toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' }).replace(/^(\w)/, (m) => m);
}

/** « 10 sept » */
export function courte(iso) {
  const d = new Date(iso + 'T12:00:00');
  return d.toLocaleDateString('fr-CA', { day: 'numeric', month: 'short' }).replace('.', '');
}

/** « dim. 4 oct. » */
export function moyenne(iso) {
  const d = new Date(iso + 'T12:00:00');
  return d.toLocaleDateString('fr-CA', { weekday: 'short', day: 'numeric', month: 'short' });
}

/** The next séance on or after `ref`, or null once the session is over. */
export function prochaineSeance(ref) {
  return SEANCES.find((s) => !s.lecture && s.date >= ref) ?? null;
}

/** Séances already given (strictly before `ref`). */
export function seancesFaites(ref) {
  return SEANCES.filter((s) => !s.lecture && s.date < ref).length;
}

/** Deadlines within the next `jours` days, nearest first. */
export function echeancesProches(ref, jours = 21) {
  return EVALUATIONS.filter((e) => e.date >= ref && ecart(e.date, ref) <= jours);
}

/** 'passe' · 'encours' · 'avenir' */
export function statut(e, ref) {
  if (e.date < ref) return 'passe';
  if (e.ouvre && e.ouvre <= ref) return 'encours';
  if (e.date === ref) return 'encours';
  return 'avenir';
}
