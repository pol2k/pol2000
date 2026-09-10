<script>
  /**
   * Chemin absolu contre chemin relatif, puis le piège de Windows. Deux
   * temps : les deux chemins, puis l'avertissement. Le message d'erreur est
   * celui de R 4.6.1, copié tel quel : « C:\Users » fait planter R parce que
   * la barre oblique inverse y est un caractère spécial.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel chemins" bind:this={hote}>
  <div class="deux">
    <div class="col">
      <span class="et">ABSOLU · depuis la racine de l’ordinateur</span>
      <code class="c"><i>/Users/vous/Documents/pol2000/</i>data/ces2025.csv</code>
      <code class="c"><i>C:/Users/vous/Documents/pol2000/</i>data/ces2025.csv</code>
      <p>Complet, mais fragile : il ne marche que sur <strong>votre</strong> ordinateur. Chez moi, chez l’auxiliaire, sur le portable de l’examen : erreur.</p>
    </div>
    <div class="col bon">
      <span class="et">RELATIF · depuis le dossier ouvert dans Positron</span>
      <code class="c">data/ces2025.csv</code>
      <p>Court, et il marche partout où le dossier <code>pol2000</code> existe. Ouvrez le dossier du cours dans Positron, puis écrivez tous vos chemins à partir de lui.</p>
      <em>c’est celui-là</em>
    </div>
  </div>
  <div class="win" class:vu={e === 1}>
    <span class="et">ATTENTION, WINDOWS</span>
    <div class="win-corps">
      <div>
        <p>Windows écrit ses chemins avec la barre inverse :</p>
        <code class="c mal">C:\Users\vous\Documents\pol2000\data\ces2025.csv</code>
        <pre class="err">Error: '\U' used without hex digits in character string</pre>
      </div>
      <div>
        <p>Dans R, <code>\</code> est un caractère spécial. Remplacez chaque <code>\</code> par <code>/</code> : R comprend la barre normale, même sur Windows.</p>
        <code class="c">C:/Users/vous/Documents/pol2000/data/ces2025.csv</code>
        <p class="mieux">Ou mieux : un chemin relatif, et le problème disparaît.</p>
      </div>
    </div>
  </div>
</div>

<style>
  .chemins { display: flex; flex-direction: column; gap: 0.9em; }
  .deux { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .col { border: 2px solid var(--dk-encre); padding: 0.9em 1em; display: flex; flex-direction: column; gap: 0.5em; }
  .col.bon { border: 3px solid var(--dk-accent); }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .bon .et { color: var(--dk-accent); }
  .c { display: block; background: var(--dk-fond-2); padding: 0.4em 0.7em; font-size: 0.85em; word-break: break-all; }
  .c i { color: var(--dk-gris-2); font-style: normal; }
  .bon .c { font-size: 1.2em; font-weight: 600; }
  .col p { margin: 0; font-size: 0.78em; line-height: 1.45; color: var(--dk-gris); }
  .col em { margin-top: auto; font-style: normal; font-size: 0.72em; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
  .win { border: 3px dashed var(--dk-accent); padding: 0.7em 1em 0.8em; display: flex; flex-direction: column; gap: 0.4em; opacity: 0.12; transition: opacity 0.4s; }
  .win.vu { opacity: 1; }
  .win .et { color: var(--dk-accent); }
  .win-corps { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .win-corps > div { display: flex; flex-direction: column; gap: 0.4em; }
  .win p { margin: 0; font-size: 0.78em; line-height: 1.45; }
  .c.mal { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 3px; color: var(--dk-gris); }
  .err { margin: 0; font-family: var(--dk-mono); font-size: 0.66em; color: var(--dk-accent); background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.4em 0.6em; white-space: pre-wrap; }
  .mieux { color: var(--dk-accent); font-weight: 600; }
</style>
