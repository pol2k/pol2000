<script>
  /**
   * Le bureau de Positron, en quatre zones schématiques, une par temps :
   * l'éditeur, la console, les variables, les graphiques et données. On ne
   * copie pas l'interface (elle change à chaque version) ; on en dessine
   * la logique, celle que la salle retrouvera sur son écran.
   */
  import { brancherTemps } from '../temps.js';
  const LEG = [
    ['LE BUREAU', 'Quatre zones. Vous passerez la séance à regarder de l’une à l’autre.'],
    ['L’ÉDITEUR', 'Là où vous écrivez. Un fichier .R : ça se garde, ça se relance, ça se corrige.'],
    ['LA CONSOLE', 'Là où R répond. Ce que vous y tapez s’exécute tout de suite, et s’oublie.'],
    ['LES VARIABLES', 'Ce que R a en mémoire en ce moment : vos objets, vos jeux de données.'],
    ['GRAPHIQUES ET DONNÉES', 'Ce que vous voyez : le graphique qui vient d’être dessiné, le tableau qu’on explore.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel bureau" bind:this={hote}>
  <div class="ecran">
    <div class="haut"><span class="titre">Positron</span><span class="fichier">seance2.R</span><span class="r">R 4.6</span></div>
    <div class="zones">
      <div class="zone editeur" class:on={e === 1}>
        <span class="et">Éditeur</span>
        <pre><i>1</i> <b>ages</b> <span class="op">&lt;-</span> c(24, 30, 19, 45)
<i>2</i> mean(ages)
<i>3</i> <span class="com"># Ctrl + Entrée : la ligne part dans la console</span></pre>
      </div>
      <div class="zone variables" class:on={e === 3}>
        <span class="et">Variables</span>
        <div class="var"><span>ages</span><span class="type">num [1:4]</span></div>
        <div class="var"><span>df</span><span class="type">47 × 6</span></div>
      </div>
      <div class="zone console" class:on={e === 2}>
        <span class="et">Console</span>
        <pre><span class="prompt">&gt;</span> mean(ages)
<span class="out">[1] 29.5</span>
<span class="prompt">&gt;</span> <b class="curseur">▍</b></pre>
      </div>
      <div class="zone graphiques" class:on={e === 4}>
        <span class="et">Graphiques · Données</span>
        <svg viewBox="0 0 120 60" aria-hidden="true">
          <line x1="10" y1="52" x2="115" y2="52" /><line x1="10" y1="52" x2="10" y2="5" />
          <rect x="18" y="38" width="12" height="14" /><rect x="34" y="22" width="12" height="30" /><rect x="50" y="10" width="12" height="42" /><rect x="66" y="16" width="12" height="36" /><rect x="82" y="30" width="12" height="22" /><rect x="98" y="44" width="12" height="8" />
        </svg>
      </div>
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
  .bureau { display: grid; grid-template-columns: 1.7fr 1fr; gap: 1.6em; align-items: center; }
  .ecran { border: 3px solid var(--dk-encre); background: var(--dk-fond); }
  .haut { display: flex; gap: 1em; align-items: center; padding: 0.35em 0.8em; border-bottom: 2px solid var(--dk-encre); background: var(--dk-fond-2); font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; }
  .haut .titre { font-weight: 600; }
  .haut .fichier { color: var(--dk-gris); }
  .haut .r { margin-left: auto; color: var(--dk-accent); font-weight: 600; }
  .zones { display: grid; grid-template-columns: 1.5fr 1fr; grid-template-rows: 1fr 1fr; gap: 0; }
  .zone { position: relative; padding: 1.5em 0.8em 0.6em; border: 1px solid var(--dk-filet); min-height: 6.4em; transition: box-shadow 0.3s, background 0.3s; }
  .zone.on { box-shadow: inset 0 0 0 4px var(--dk-accent); background: #fff; }
  .zone .et { position: absolute; top: 0.4em; left: 0.8em; font-size: 0.56em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; transition: color 0.3s; }
  .zone.on .et { color: var(--dk-accent); }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 0.7em; line-height: 1.6; white-space: pre; }
  pre i { font-style: normal; color: var(--dk-gris-2); }
  pre b { font-weight: 600; }
  .op { color: var(--dk-gris); }
  .com { color: var(--dk-gris); font-style: italic; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); }
  .curseur { color: var(--dk-accent); animation: clignote 1s steps(1) infinite; }
  @keyframes clignote { 50% { opacity: 0; } }
  .var { display: flex; justify-content: space-between; font-size: 0.7em; padding: 0.15em 0; border-bottom: 1px solid var(--dk-filet); }
  .var .type { color: var(--dk-gris); }
  .graphiques svg { width: 100%; height: auto; max-height: 4.6em; display: block; }
  .graphiques line { stroke: var(--dk-encre); stroke-width: 1.5; }
  .graphiques rect { fill: var(--dk-gris-2); }
  .graphiques .on rect { fill: var(--dk-accent); }
  .zone.on rect { fill: var(--dk-accent); }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et2 { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.3em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
