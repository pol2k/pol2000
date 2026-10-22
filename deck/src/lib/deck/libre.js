/**
 * Le défilement libre d'un document qui défile au clic (M8Article,
 * M8Tableau2) : une fois le passage montré, la personne qui enseigne peut
 * encore promener le document à la molette, au pavé tactile ou en le
 * glissant (souris, doigt), pour montrer autre chose.
 *
 *   defilementLibre(el, { deplacer, actif })
 *     deplacer(dy)  déplace le document de dy pixels (positif = vers le bas
 *                   du document); le composant borne lui-même;
 *     actif()       faux : on laisse passer (le document ne défile pas).
 *
 * La molette est interceptée (non passive) : elle ne fait plus changer de
 * diapo tant qu'on est sur le document. Un glissé ne compte pas comme un
 * clic : le clic qui le termine n'avance pas le temps (brancherTemps).
 * Retourne la fonction de nettoyage.
 */
export function defilementLibre(el, { deplacer, actif = () => true }) {
  function molette(ev) {
    if (!actif() || ev.ctrlKey) return;
    ev.preventDefault();
    ev.stopPropagation();
    const k = ev.deltaMode === 1 ? 40 : ev.deltaMode === 2 ? el.clientHeight : 1;
    deplacer(ev.deltaY * k);
  }

  let y = null;
  let glisse = false;
  function bas(ev) {
    if (ev.button !== 0 || !actif()) return;
    y = ev.clientY;
    glisse = false;
  }
  function bouge(ev) {
    if (y === null) return;
    const dy = ev.clientY - y;
    if (!glisse && Math.abs(dy) < 6) return;
    if (!glisse) { glisse = true; el.setPointerCapture?.(ev.pointerId); }
    y = ev.clientY;
    deplacer(-dy);
  }
  function haut() { y = null; }
  // Le clic qui termine un glissé ne va pas jusqu'à la diapo.
  function clic(ev) {
    if (glisse) { ev.stopPropagation(); glisse = false; }
  }

  // Une image glissée lancerait le glisser-déposer du navigateur (et
  // annulerait le geste) : on l'empêche.
  const sansDepot = (ev) => ev.preventDefault();

  el.addEventListener('wheel', molette, { passive: false });
  el.addEventListener('dragstart', sansDepot);
  el.addEventListener('pointerdown', bas);
  el.addEventListener('pointermove', bouge);
  el.addEventListener('pointerup', haut);
  el.addEventListener('pointercancel', haut);
  el.addEventListener('click', clic);
  return () => {
    el.removeEventListener('wheel', molette);
    el.removeEventListener('dragstart', sansDepot);
    el.removeEventListener('pointerdown', bas);
    el.removeEventListener('pointermove', bouge);
    el.removeEventListener('pointerup', haut);
    el.removeEventListener('pointercancel', haut);
    el.removeEventListener('click', clic);
  };
}
