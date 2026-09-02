/**
 * Le pilotage au clic, partagé par les schémas animés du deck.
 *
 * Trois composants le faisaient déjà chacun de leur côté, en quarante lignes
 * recopiées; à cinq de plus, une divergence était garantie. Le comportement
 * est donc défini une fois:
 *
 *   - un clic sur la diapositive avance d'un temps, et reboucle à la fin;
 *   - les touches « suivant » et « précédent » font de même tant qu'il reste
 *     un temps, puis rendent la main au deck — une télécommande de
 *     conférencier suffit, sans toucher au clavier;
 *   - on repart de zéro en arrivant sur la diapositive et en la quittant.
 *
 * L'écoute du clavier est en phase de capture sur window: le deck écoute en
 * bouillonnement, donc stopPropagation le neutralise tant qu'on en a besoin.
 *
 * `lire` et `ecrire` donnent accès à l'état du composant, qui doit rester
 * chez lui: les runes ne traversent pas un module.
 */
const AVANT = ['ArrowRight', 'ArrowDown', 'PageDown', ' '];
const ARRIERE = ['ArrowLeft', 'ArrowUp', 'PageUp'];

export function brancherTemps(hote, { total, lire, ecrire }) {
  const deck = hote.closest('.deck');
  const diapo = hote.closest('.diapo');
  if (!deck || !diapo) return () => {};

  const monIndex = [...deck.querySelectorAll('.diapo')].indexOf(diapo);
  const surCetteDiapo = () => Math.round(deck.scrollTop / deck.clientHeight) === monIndex;

  function avancer() {
    ecrire(lire() >= total ? 0 : lire() + 1);
  }
  diapo.addEventListener('click', avancer);

  function auClavier(ev) {
    if (!surCetteDiapo()) return;
    if (AVANT.includes(ev.key) && lire() < total) {
      ev.preventDefault();
      ev.stopPropagation();
      ecrire(lire() + 1);
    } else if (ARRIERE.includes(ev.key) && lire() > 0) {
      ev.preventDefault();
      ev.stopPropagation();
      ecrire(lire() - 1);
    }
  }
  window.addEventListener('keydown', auClavier, true);

  let ici = false;
  function verifier() {
    const y = surCetteDiapo();
    if (y !== ici) {
      ici = y;
      ecrire(0);
    }
  }
  deck.addEventListener('scroll', verifier, { passive: true });
  verifier();
  const t = setTimeout(verifier, 350);

  return () => {
    diapo.removeEventListener('click', avancer);
    deck.removeEventListener('scroll', verifier);
    window.removeEventListener('keydown', auClavier, true);
    clearTimeout(t);
  };
}
