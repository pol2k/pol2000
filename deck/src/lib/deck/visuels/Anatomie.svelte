<script>
  /**
   * L'anatomie d'une ligne de R, en cinq temps : l'objet, la flèche, la
   * fonction, l'argument, l'option. Une seule ligne, très grande, et une
   * partie qui s'allume à la fois. C'est la ligne que la salle vient de
   * taper ; rien de nouveau, seulement des noms sur ce qu'elle a fait.
   */
  import { brancherTemps } from '../temps.js';
  const PARTIES = [
    ['LA LIGNE ENTIÈRE', 'Lue de droite à gauche : calcule ceci, range-le là.'],
    ['L’OBJET', 'Un nom que vous choisissez. Minuscules, sans accent, sans espace. Il apparaît dans « Variables ».'],
    ['LA FLÈCHE', 'Range le résultat dans l’objet. Tapez < puis - ; Positron peut l’écrire d’un raccourci.'],
    ['LA FONCTION', 'Un verbe, suivi de parenthèses. Toujours les parenthèses, même vides.'],
    ['L’ARGUMENT', 'Ce qu’on donne à la fonction. Ici, le vecteur des âges.'],
    ['L’OPTION', 'Un réglage, nommé. Ici : ignore les valeurs manquantes. Les arguments se séparent par des virgules.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel anatomie" bind:this={hote}>
  <pre class="ligne"><span class="p" class:on={e === 1}>moyenne</span> <span class="p" class:on={e === 2}>&lt;-</span> <span class="p" class:on={e === 3}>mean</span><span class="p" class:on={e === 3}>(</span><span class="p" class:on={e === 4}>ages</span>, <span class="p" class:on={e === 5}>na.rm = TRUE</span><span class="p" class:on={e === 3}>)</span></pre>
  <div class="reperes">
    {#each PARTIES.slice(1) as p, i}
      <span class="rep" class:on={e === i + 1}>{i + 1}</span>
    {/each}
  </div>
  {#key e}
    <div class="legende">
      <span class="et">{PARTIES[e][0]}</span>
      <p>{PARTIES[e][1]}</p>
    </div>
  {/key}
</div>

<style>
  .anatomie { display: flex; flex-direction: column; gap: 0.9em; align-items: flex-start; }
  .ligne { margin: 0; font-family: var(--dk-mono); font-size: 2.3em; font-weight: 500; letter-spacing: -0.02em; white-space: pre; border: 3px solid var(--dk-encre); padding: 0.45em 0.7em; width: 100%; box-sizing: border-box; overflow-x: auto; }
  .p { transition: color 0.3s, background 0.3s; padding: 0.05em 0.02em; }
  .p.on { color: var(--dk-accent); background: var(--dk-fond-2); box-shadow: inset 0 -0.14em 0 var(--dk-accent); }
  .reperes { display: flex; gap: 0.5em; }
  .rep { width: 1.8em; height: 1.8em; display: flex; align-items: center; justify-content: center; border: 2px solid var(--dk-filet); color: var(--dk-gris-2); font-weight: 600; font-size: 0.8em; transition: all 0.3s; }
  .rep.on { border-color: var(--dk-accent); color: var(--dk-accent); }
  .legende { display: flex; flex-direction: column; gap: 0.35em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.3em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
