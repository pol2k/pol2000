<script>
  /**
   * L'équation de la droite, en deux rangées alignées : en haut, la forme
   * générale (intérêt = β0 + β1 × scolarité), en gris; en bas, les vrais
   * nombres, chacun dans sa case, sous son symbole. On voit ainsi qu'on
   * « remplace » β0 et β1 par des nombres. Le signe de β1 reste dans sa case et
   * le « + » s'efface quand β1 est négatif (« 0,50 −0,10 × … »), comme dans
   * RegEnMots.
   *
   * Utilisée par DroiteReglable (la droite qu'on règle) et LireLaPente.
   * `actif` ('b0' ou 'b1') met une case en rouge. Aucun calcul ici : les
   * nombres arrivent du parent, le nom de X vient de VARS.x.court (seance7.js).
   * Deux décimales partout : les variables vont de 0 à 1.
   */
  import { VARS } from '$lib/data/seance7.js';
  // Le mot affiché : « scolarité » (VARS.x.court, en minuscules), pas le nom de colonne.
  const X = VARS.x.court.toLowerCase();
  // grand = la version en-tête (DroiteReglable) : plus grosse, avec le nom de
  // chaque case dessous, le même que sur son curseur.
  let { b0, b1, actif = null, grand = false } = $props();
  // Format québécois, vrai signe moins (U+2212), pas de trait d'union.
  const f = (v, d) => {
    const t = Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
    return (v < 0 && Number(t.replace(',', '.')) !== 0 ? '−' : '') + t;
  };
</script>

<div class="eq" class:grand aria-label="intérêt égale {f(b0, 2)} {b1 < 0 ? '' : 'plus'} {f(b1, 2)} fois {X}">
  <span class="g">intérêt</span><span class="g">=</span><span class="g s">β0</span><span class="g">+</span><span class="g s">β1</span><span class="g">×</span><span class="g">{X}</span>
  <span>intérêt</span><span>=</span><span class="case" class:on={actif === 'b0'}>{f(b0, 2)}</span><span>{b1 < 0 ? '' : '+'}</span><span class="case" class:on={actif === 'b1'}>{f(b1, 2)}</span><span>×</span><span>{X}</span>
  {#if grand}
    <span></span><span></span><span class="nom" class:on={actif === 'b0'}>ordonnée à l’origine</span><span></span><span class="nom" class:on={actif === 'b1'}>pente</span><span></span><span></span>
  {/if}
</div>

<style>
  .eq {
    display: grid;
    grid-template-columns: repeat(7, auto);
    justify-content: center;
    align-items: center;
    column-gap: 0.45em;
    row-gap: 0.1em;
    font-family: var(--dk-mono);
    font-size: 1.25em;
    font-variant-numeric: tabular-nums;
    text-align: center;
  }
  .g { font-size: 0.62em; color: var(--dk-gris); letter-spacing: 0.04em; }
  .g.s { font-weight: 600; color: var(--dk-encre); }
  .case {
    display: inline-block;
    min-width: 4.6em;
    padding: 0.08em 0.35em;
    border: 2px solid var(--dk-encre);
    font-weight: 600;
    transition: color 0.25s, border-color 0.25s, background-color 0.25s;
  }
  .eq.grand { font-size: 1.75em; row-gap: 0.05em; }
  .eq.grand .case { min-width: 4.2em; border-width: 3px; }
  .nom { font-size: 0.4em; letter-spacing: 0.06em; color: var(--dk-gris); transition: color 0.25s; }
  .nom.on { color: var(--dk-accent); font-weight: 600; }
  .case.on { color: var(--dk-fond); background: var(--dk-accent); border-color: var(--dk-accent); }
</style>
