<script>
  /**
   * Sous le titre de section « La régression linéaire », sur fond encre :
   * l'équation et la ligne de R qui l'estime. y et x sont en or dans les
   * deux, pour qu'on voie que ce sont les mêmes. Le code suit le style de la
   * formule de R : lm(y ~ x, data = df), sans df$ (avec data =, les df$ sont
   * de trop et nuisent à predict() plus tard). Aucun état : la diapo arrive
   * complète.
   */
</script>

<div class="rt">
  <p class="eq" aria-label="y égale bêta zéro plus bêta un x plus epsilon">
    <span class="v">y</span> <span class="op">=</span> β<sub>0</sub> <span class="op">+</span> β<sub>1</sub><span class="v">x</span> <span class="op">+</span> <span class="eps">ε</span>
  </p>
  <pre class="code"><span class="fn">lm</span>(<span class="v">y</span> <span class="op">~</span> <span class="v">x</span>, <span class="arg">data</span> <span class="op">=</span> df)</pre>
</div>

<style>
  .rt { display: flex; flex-direction: column; align-items: flex-start; gap: 0.7em; margin-top: 0.9em; }
  .eq { margin: 0; font-size: 2.6em !important; font-weight: 500; line-height: 1.1 !important; letter-spacing: -0.02em; white-space: nowrap; }
  .eq sub { font-size: 0.5em; vertical-align: -0.32em; margin-left: 0.03em; }
  .v { color: var(--dk-accent-clair); font-style: italic; font-weight: 600; }
  .op { color: var(--dk-gris-2); font-weight: 400; }
  .eps { color: var(--dk-gris-2); }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1.4em; padding: 0.4em 0.8em; border: 2px solid var(--dk-fond); white-space: pre; }
  .code .v { font-style: normal; }
  .fn { font-weight: 600; }
  .arg { color: var(--dk-gris-2); }
</style>
