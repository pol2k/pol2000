<script>
  /**
   * Lire une erreur. Un message de R 4.6, copié tel quel, et en quatre
   * temps ce qu'on en fait : on le lit, on trouve la ligne, on vérifie les
   * suspects habituels, et seulement ensuite on demande. La panique n'est
   * pas dans la liste.
   */
  import { brancherTemps } from '../temps.js';
  const ETAPES = [
    ['UNE ERREUR', 'Rouge, en anglais, sec. Ce n’est pas une note. C’est R qui dit ce qu’il n’a pas compris.'],
    ['1 · LIRE', 'Le message dit presque toujours quoi : un objet introuvable, une fonction inconnue, un symbole inattendu.'],
    ['2 · LA LIGNE', 'Positron souligne l’endroit. Regardez cette ligne, pas tout le script.'],
    ['3 · LES SUSPECTS', 'Parenthèse, guillemet, virgule, majuscule, faute de frappe. Et library() : a-t-on chargé le package ?'],
    ['4 · DEMANDER', 'Message copié en entier, code copié en entier. À l’assistant d’IA d’abord, puis sur Slack, #aide-metho.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel erreurs" bind:this={hote}>
  <div class="gauche">
    <pre class="code"><i>1</i> library(dplyr)
<i>2</i> df &lt;- swiss
<i class:on={e === 2}>3</i> <span class:souligne={e === 2}>df |&gt; select(fertility, Education)</span></pre>
    <pre class="err">Error in select(df, fertility, Education) :
  Can't select columns that don't exist.
✖ Column `fertility` doesn't exist.</pre>
    <div class="suspects" class:vu={e === 3}>
      <span>( )</span><span>" "</span><span>,</span><span class="on">A ≠ a</span><span>library()</span>
    </div>
  </div>
  {#key e}
    <div class="legende">
      <span class="et">{ETAPES[e][0]}</span>
      <p>{ETAPES[e][1]}</p>
    </div>
  {/key}
</div>

<style>
  .erreurs { display: grid; grid-template-columns: 1.3fr 1fr; gap: 1.8em; align-items: center; }
  .gauche { display: flex; flex-direction: column; gap: 0.6em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 0.95em; line-height: 1.7; border: 3px solid var(--dk-encre); padding: 0.6em 0.9em; white-space: pre; }
  .code i { font-style: normal; color: var(--dk-gris-2); margin-right: 0.6em; transition: color 0.3s; }
  .code i.on { color: var(--dk-accent); font-weight: 600; }
  .souligne { text-decoration: underline wavy var(--dk-accent); text-underline-offset: 0.25em; }
  .err { margin: 0; font-family: var(--dk-mono); font-size: 0.85em; line-height: 1.5; color: var(--dk-accent); background: var(--dk-fond-2); border-left: 0.34em solid var(--dk-accent); padding: 0.6em 0.9em; white-space: pre-wrap; }
  .suspects { display: flex; gap: 0.5em; opacity: 0; transition: opacity 0.4s; }
  .suspects.vu { opacity: 1; }
  .suspects span { border: 2px solid var(--dk-encre); padding: 0.3em 0.7em; font-family: var(--dk-mono); font-weight: 600; font-size: 0.9em; }
  .suspects span.on { border: 3px solid var(--dk-accent); color: var(--dk-accent); }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.25em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
