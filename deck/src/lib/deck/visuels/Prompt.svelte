<script>
  /**
   * Demander à un assistant d'IA : une mauvaise question, puis une bonne,
   * pièce par pièce. L'assistant n'est pas montré ; seule la question l'est,
   * parce que c'est la seule chose que la salle contrôle.
   */
  import { brancherTemps } from '../temps.js';
  const LEG = [
    ['LA MAUVAISE QUESTION', 'Rien à quoi répondre. L’assistant devinera, et il devinera avec assurance.'],
    ['1 · LE CONTEXTE', 'Qui vous êtes, quel outil, quel niveau. L’assistant adapte son vocabulaire et arrête de supposer que vous savez.'],
    ['2 · LE BUT', 'Ce que vous essayez d’obtenir, en français. Pas la commande : le résultat voulu.'],
    ['3 · LE CODE ET L’ERREUR', 'Collés en entier, tels quels. Le message d’erreur contient presque toujours la réponse.'],
    ['4 · LA CONSIGNE', 'Explique-moi, ne fais pas à ma place. C’est la différence entre apprendre R et le sous-traiter.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel prompt" bind:this={hote}>
  <div class="bulles">
    <div class="bulle mauvaise" class:pale={e >= 1}>
      <span class="et">non</span>
      <p>ça marche pas, pourquoi ?</p>
    </div>
    <div class="bulle bonne" class:vu={e >= 1}>
      <span class="et">oui</span>
      <p class="morceau" class:on={e === 1} class:vu={e >= 1}>Je suis étudiant.e en science politique, débutant.e en R, dans Positron.</p>
      <p class="morceau" class:on={e === 2} class:vu={e >= 2}>Je veux garder seulement les provinces dont la scolarité dépasse 20 %.</p>
      <p class="morceau code" class:on={e === 3} class:vu={e >= 3}>Voici mon code : <code>df |&gt; filter(education &gt; 20)</code><br />Et l’erreur : <code>object 'education' not found</code></p>
      <p class="morceau" class:on={e === 4} class:vu={e >= 4}>Explique-moi ce qui cloche et pourquoi. Ne réécris pas tout le script.</p>
    </div>
  </div>
  {#key e}
    <div class="legende">
      <span class="et2">{LEG[e][0]}</span>
      <p>{LEG[e][1]}</p>
    </div>
  {/key}
</div>

<style>
  .prompt { display: grid; grid-template-columns: 1.4fr 1fr; gap: 1.8em; align-items: center; }
  .bulles { display: flex; flex-direction: column; gap: 0.8em; }
  .bulle { border: 2px solid var(--dk-encre); padding: 0.8em 1em; display: flex; flex-direction: column; gap: 0.3em; transition: opacity 0.4s; }
  .mauvaise p { margin: 0; font-size: 1.3em; font-weight: 500; }
  .mauvaise.pale { opacity: 0.3; }
  .bonne { border: 3px solid var(--dk-accent); opacity: 0.15; }
  .bonne.vu { opacity: 1; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .bonne .et { color: var(--dk-accent); }
  .morceau { margin: 0; font-size: 0.92em; line-height: 1.45; color: var(--dk-gris-2); transition: color 0.3s; }
  .morceau.vu { color: var(--dk-encre); }
  .morceau.on { color: var(--dk-accent); font-weight: 600; }
  .morceau code { font-size: 0.9em; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et2 { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.25em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
