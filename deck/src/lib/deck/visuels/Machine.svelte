<script>
  /**
   * La fonction comme machine : des ingrédients entrent, un résultat sort.
   * L'image vient du deck FAS1001 (mermaid en trois boîtes) ; ici elle est
   * au trait, avec la vraie fonction et le vrai résultat de R.
   */
</script>

<div class="visuel machine">
  <div class="boite entree">
    <span class="et">CE QU’ON DONNE</span>
    <code>c(24, 30, 19, 45)</code>
    <code>na.rm = TRUE</code>
    <small>les arguments</small>
  </div>
  <div class="fl">→</div>
  <div class="boite centre">
    <span class="et">LA MACHINE</span>
    <span class="nom">mean()</span>
    <small>la fonction</small>
    <div class="aide"><code>?mean</code> ouvre le mode d’emploi</div>
  </div>
  <div class="fl">→</div>
  <div class="boite sortie">
    <span class="et">CE QUI SORT</span>
    <span class="val">29.5</span>
    <small>le résultat, à ranger dans un objet ou à lire tel quel</small>
  </div>
</div>

<style>
  .machine { display: grid; grid-template-columns: 1fr auto 1.2fr auto 1fr; gap: 0.8em; align-items: stretch; }
  .boite { border: 2px solid var(--dk-encre); padding: 1em 1em 0.9em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; justify-content: center; }
  .centre { border: 4px solid var(--dk-accent); }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .centre .et { color: var(--dk-accent); }
  .boite code { background: var(--dk-fond-2); padding: 0.15em 0.4em; font-size: 0.9em; }
  .nom { font-family: var(--dk-mono); font-size: 2.6em; font-weight: 600; line-height: 1; margin: 0.15em 0; }
  .val { font-family: var(--dk-mono); font-size: 3em; font-weight: 600; color: var(--dk-accent); line-height: 1; }
  small { font-size: 0.7em; color: var(--dk-gris); line-height: 1.35; }
  .aide { margin-top: 0.5em; font-size: 0.72em; color: var(--dk-gris); }
  .aide code { font-size: 0.95em; }
  .fl { align-self: center; font-size: 2.6em; color: var(--dk-accent); }
</style>
