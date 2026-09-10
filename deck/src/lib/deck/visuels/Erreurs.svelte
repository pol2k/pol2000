<script>
  /**
   * Lire une erreur. Un message de R 4.6.1, copié tel quel, et en face le
   * seul mot qui compte : on ne casse rien. Une erreur, c'est R qui dit
   * qu'il n'a pas compris ; on la lit, on corrige la ligne, on relance.
   * Pas de temps, pas de liste : une diapo qui se regarde.
   */
  import Picto from '../Picto.svelte';
</script>

<div class="visuel erreurs">
  <div class="gauche">
    <pre class="code"><i>1</i> library(dplyr)
<i>2</i> df &lt;- swiss
<i class="on">3</i> df |&gt; select(<span class="souligne">fertility</span>, Education)</pre>
    <pre class="err">Error in select(df, fertility, Education) :
  Can't select columns that don't exist.
✖ Column `fertility` doesn't exist.</pre>
    <div class="fix">
      <span class="mal">fertility</span>
      <span class="fl">→</span>
      <span class="bon">Fertility</span>
      <small>R distingue les majuscules</small>
    </div>
  </div>
  <div class="droite">
    <span class="et">UNE ERREUR</span>
    <strong class="calme">Vous ne casserez rien.</strong>
    <p>C’est R qui dit : « je n’ai pas compris ».</p>
    <ol class="gestes">
      <li><Picto nom="oeil" taille="1.5em" /><span>Lire le message</span></li>
      <li><Picto nom="page" taille="1.5em" /><span>Corriger la ligne</span></li>
      <li><Picto nom="retour" taille="1.5em" /><span>Relancer</span></li>
    </ol>
  </div>
</div>

<style>
  .erreurs { display: grid; grid-template-columns: 1.25fr 1fr; gap: 2em; align-items: center; }
  .gauche { display: flex; flex-direction: column; gap: 0.7em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.7; border: 3px solid var(--dk-encre); padding: 0.6em 0.9em; white-space: pre; }
  .code i { font-style: normal; color: var(--dk-gris-2); margin-right: 0.6em; }
  .code i.on { color: var(--dk-accent); font-weight: 600; }
  .souligne { color: var(--dk-accent); text-decoration: underline wavy var(--dk-accent); text-underline-offset: 0.25em; }
  .err { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.5; font-weight: 600; color: var(--dk-accent); background: var(--dk-fond-2); border-left: 0.4em solid var(--dk-accent); padding: 0.7em 0.9em; white-space: pre-wrap; }
  .fix { display: flex; align-items: center; gap: 0.6em; font-family: var(--dk-mono); font-weight: 600; font-size: 0.95em; }
  .fix .mal { color: var(--dk-accent); text-decoration: line-through; }
  .fix .fl { color: var(--dk-accent); }
  .fix .bon { border: 2px solid var(--dk-encre); padding: 0.1em 0.45em; }
  .fix small { font-size: 0.72em; font-weight: 400; color: var(--dk-gris); margin-left: 0.4em; }

  .droite { display: flex; flex-direction: column; gap: 0.6em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .calme { font-size: 2.3em; line-height: 1.1; letter-spacing: -0.01em; }
  .droite p { margin: 0; font-size: 1.1em; line-height: 1.4; color: var(--dk-gris); }
  .gestes { list-style: none; margin: 0.6em 0 0; padding: 0; display: flex; flex-direction: column; gap: 0.45em; }
  .gestes li { display: flex; align-items: center; gap: 0.7em; font-size: 1.1em; font-weight: 600; }
  .gestes li :global(.picto) { color: var(--dk-accent); flex: 0 0 auto; }
</style>
