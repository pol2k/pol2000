<script>
  /**
   * L'équation de la droite, en deux rangées alignées : en haut, la forme
   * générale (note = β0 + β1 × gauche_droite), en gris; en bas, les vrais
   * nombres, chacun dans sa case, sous son symbole. On voit ainsi qu'on
   * « remplace » β0 et β1 par des nombres. Le signe de β1 reste dans sa case
   * (« + −5,05 ») : c'est la substitution telle quelle.
   *
   * Utilisée par DroiteReglable (la droite qu'on règle) et LireLaPente.
   * `actif` ('b0' ou 'b1') met une case en rouge. Aucun calcul ici : les
   * nombres arrivent du parent.
   */
  let { b0, b1, actif = null } = $props();
  // Format québécois, vrai signe moins (U+2212), pas de trait d'union.
  const f = (v, d) => {
    const t = Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
    return (v < 0 && Number(t.replace(',', '.')) !== 0 ? '−' : '') + t;
  };
</script>

<div class="eq" aria-label="note égale {f(b0, 1)} plus {f(b1, 2)} fois gauche_droite">
  <span class="g">note</span><span class="g">=</span><span class="g s">β0</span><span class="g">+</span><span class="g s">β1</span><span class="g">×</span><span class="g">gauche_droite</span>
  <span>note</span><span>=</span><span class="case" class:on={actif === 'b0'}>{f(b0, 1)}</span><span>+</span><span class="case" class:on={actif === 'b1'}>{f(b1, 2)}</span><span>×</span><span>gauche_droite</span>
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
  .case.on { color: var(--dk-fond); background: var(--dk-accent); border-color: var(--dk-accent); }
</style>
