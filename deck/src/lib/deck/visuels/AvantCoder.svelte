<script>
  /**
   * Avant d'écrire une ligne : planifier, découper, commenter. Les trois
   * conseils des decks d'origine, portés par trois fichiers numérotés
   * plutôt que par trois paragraphes.
   */
</script>

<div class="visuel avant">
  <div class="conseil">
    <span class="et">1 · PLANIFIER</span>
    <strong>Quelle question, quelles variables ?</strong>
    <p>La plus grosse erreur : ouvrir Positron sans savoir ce qu’on cherche. Une phrase sur papier d’abord.</p>
  </div>
  <div class="conseil">
    <span class="et">2 · DÉCOUPER</span>
    <strong>Un script, une tâche</strong>
    <div class="fichiers">
      <span>1_lire.R</span><span>2_nettoyer.R</span><span>3_analyser.R</span><span>4_graphique.R</span>
    </div>
    <p>Des noms qui disent ce que le fichier fait, un chiffre qui dit dans quel ordre.</p>
  </div>
  <div class="conseil">
    <span class="et">3 · COMMENTER</span>
    <strong>Le pourquoi, pas le quoi</strong>
    <pre><span class="com"># seuil de 20 % : médiane des provinces</span>
df |&gt; filter(Education &gt; 20)</pre>
    <p>Une ligne qui commence par <code>#</code> est pour vous, pas pour R. Vous dans trois mois, surtout.</p>
  </div>
</div>

<style>
  .avant { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; align-items: stretch; }
  .conseil { border: 2px solid var(--dk-encre); padding: 1em 1em 0.9em; display: flex; flex-direction: column; gap: 0.45em; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-accent); }
  .conseil strong { font-size: 1.1em; line-height: 1.25; }
  .conseil p { margin: 0; font-size: 0.76em; line-height: 1.45; color: var(--dk-gris); }
  .fichiers { display: flex; flex-direction: column; gap: 0.25em; margin: 0.2em 0; }
  .fichiers span { font-family: var(--dk-mono); font-size: 0.85em; border: 2px solid var(--dk-filet); padding: 0.25em 0.6em; }
  .fichiers span:first-child { border-color: var(--dk-accent); }
  pre { margin: 0.2em 0; font-family: var(--dk-mono); font-size: 0.66em; line-height: 1.5; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.5em 0.7em; white-space: pre-wrap; }
  .com { color: var(--dk-gris); font-style: italic; }
  .conseil code { font-size: 0.95em; }
</style>
