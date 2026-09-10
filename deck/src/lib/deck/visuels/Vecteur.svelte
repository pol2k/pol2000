<script>
  /**
   * Un vecteur, rendu visible. Quatre ami.e.s, quatre âges sur quatre
   * cartes ; c() les range dans une seule boîte à cases, et tout ce qu'on
   * fait ensuite se fait à la boîte : une case, la moyenne, une question
   * posée à chaque case. Quatre temps. Les réponses de R viennent d'un
   * vrai R 4.6.1, pas d'un clavier.
   */
  import { brancherTemps } from '../temps.js';
  import Picto from '../Picto.svelte';
  const AGES = [24, 30, 19, 45];
  // Penchées un peu, chacune à sa façon : des cartes posées sur une table.
  const POSE = ['-4deg', '3deg', '-2deg', '5deg'];
  const TEMPS = [
    { code: '# quatre personnes, quatre âges', lignes: [], et: 'QUATRE VALEURS', txt: 'Quatre ami.e.s, quatre âges. Des valeurs qui vont ensemble, mais encore en vrac.' },
    { code: 'ages <- c(24, 30, 19, 45)', lignes: [{ in: 'ages', out: '[1] 24 30 19 45' }], et: 'C COMME COMBINER', txt: 'c() met plusieurs valeurs dans une même boîte à cases. Cette boîte, c’est un vecteur. Un seul nom pour quatre valeurs.' },
    { code: 'ages[2]', lignes: [{ in: 'ages[2]', out: '[1] 30' }], et: 'UNE CASE', txt: 'Les crochets désignent une case par son numéro. La case 2, pas la valeur 2.' },
    { code: 'mean(ages)', lignes: [{ in: 'mean(ages)', out: '[1] 29.5' }, { in: 'length(ages)', out: '[1] 4' }], et: 'TOUTE LA BOÎTE', txt: 'mean() lit les quatre cases d’un coup. length() les compte. On travaille sur la boîte entière, pas case par case.' },
    { code: 'ages > 25', lignes: [{ in: 'ages > 25', out: '[1] FALSE  TRUE FALSE  TRUE' }], et: 'UNE QUESTION PAR CASE', txt: 'Une question posée à chaque case. Quatre réponses, dans le même ordre.' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TEMPS.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel vecteur" bind:this={hote}>
  {#key e}
    <pre class="code" class:com={e === 0}>{TEMPS[e].code}</pre>
  {/key}

  <div class="scene">
    <span class="nom" class:vu={e >= 1}>ages</span>
    <div class="cases" class:groupe={e >= 1}>
      {#each AGES as a, i}
        <div
          class="case"
          class:cible={e === 2 && i === 1}
          class:tous={e === 3}
          class:vrai={e === 4 && a > 25}
          class:faux={e === 4 && a <= 25}
          style="--r: {POSE[i]}"
        >
          <span class="qui"><Picto nom="humain" taille="1.1em" /></span>
          <span class="v">{a}</span>
          <span class="idx" class:vu={e >= 2} class:on={e === 2 && i === 1}>[{i + 1}]</span>
          <span class="rep" class:vu={e === 4}>{a > 25 ? 'TRUE' : 'FALSE'}</span>
        </div>
      {/each}
    </div>
    <div class="resultat" class:vu={e === 3}>
      <span class="fl">→</span>
      <span class="val">29.5</span>
    </div>
  </div>

  <div class="bas">
    <pre class="console">{#each TEMPS[e].lignes as l}<span class="in"><span class="prompt">&gt;</span> {l.in}</span><span class="out">{l.out}</span>{:else}<span class="in"><span class="prompt">&gt;</span> <b class="curseur">▍</b></span>{/each}</pre>
    {#key e}
      <div class="legende">
        <span class="et">{TEMPS[e].et}</span>
        <p>{TEMPS[e].txt}</p>
      </div>
    {/key}
  </div>
</div>

<style>
  .vecteur { display: flex; flex-direction: column; gap: 0.7em; }

  /* La ligne de R du moment, très grande, comme dans l'anatomie d'une ligne. */
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1.7em; font-weight: 500; white-space: pre; border: 3px solid var(--dk-encre); padding: 0.35em 0.7em; animation: fondu 0.3s both; }
  .code.com { color: var(--dk-gris); font-weight: 400; }

  /* La scène : le nom à gauche, les cases, le résultat à droite. */
  .scene { display: flex; align-items: center; gap: 1em; padding: 0.6em 0 3em; min-height: 5.4em; }
  .nom { font-family: var(--dk-mono); font-size: 1.6em; font-weight: 600; color: var(--dk-accent); opacity: 0; transform: translateX(-0.5em); transition: opacity 0.5s, transform 0.5s; width: 3.2em; text-align: right; }
  .nom.vu { opacity: 1; transform: none; }
  .cases { display: flex; align-items: center; }
  .case { position: relative; width: 5.4em; height: 4.4em; border: 3px solid var(--dk-encre); background: var(--dk-fond); display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.15em; margin: 0 1.1em; transform: rotate(var(--r)) translateY(0.15em); transition: margin 0.6s ease, transform 0.6s ease, border-color 0.3s, color 0.3s, background 0.3s; box-sizing: border-box; }
  .groupe .case { margin: 0 -1.5px; transform: none; }
  .qui { color: var(--dk-gris-2); line-height: 0; }
  .v { font-family: var(--dk-mono); font-size: 1.9em; font-weight: 600; line-height: 1; }

  /* Une case pointée, toutes les cases, chaque case questionnée. */
  .case.cible { border-color: var(--dk-accent); color: var(--dk-accent); transform: translateY(-0.4em); z-index: 1; }
  .case.tous { border-color: var(--dk-accent); background: var(--dk-fond-2); }
  .case.vrai { border-color: var(--dk-accent); color: var(--dk-accent); background: var(--dk-fond-2); }
  .case.faux .v, .case.faux .qui { opacity: 0.4; }

  /* Sous chaque case : son numéro, puis la réponse de R. */
  .idx, .rep { position: absolute; left: 0; right: 0; text-align: center; font-family: var(--dk-mono); font-weight: 600; opacity: 0; transition: opacity 0.4s, color 0.3s; }
  .idx { top: calc(100% + 0.3em); font-size: 0.8em; color: var(--dk-gris-2); }
  .idx.vu { opacity: 1; }
  .idx.on { color: var(--dk-accent); }
  .rep { top: calc(100% + 1.55em); font-size: 0.9em; color: var(--dk-gris-2); }
  .rep.vu { opacity: 1; }
  .vrai .rep { color: var(--dk-accent); }

  .resultat { display: flex; align-items: center; gap: 0.5em; opacity: 0; transform: translateX(-0.6em); transition: opacity 0.5s, transform 0.5s; }
  .resultat.vu { opacity: 1; transform: none; }
  .fl { font-size: 2em; color: var(--dk-accent); }
  .val { font-family: var(--dk-mono); font-size: 2.4em; font-weight: 600; color: var(--dk-accent); border: 3px solid var(--dk-accent); padding: 0.1em 0.4em; line-height: 1.1; }

  /* En bas : la vraie console à gauche, le mot à droite. */
  .bas { display: grid; grid-template-columns: 1.1fr 1fr; gap: 1.4em; align-items: start; }
  .console { margin: 0; font-family: var(--dk-mono); font-size: 0.95em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.55em 0.9em; min-height: 3.6em; animation: fondu 0.3s both; }
  .in, .out { display: block; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  .curseur { color: var(--dk-accent); font-weight: 400; animation: clignote 1s steps(1) infinite; }
  .legende { display: flex; flex-direction: column; gap: 0.3em; }
  .et { font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1em; line-height: 1.4; animation: fondu 0.4s both; }
  @keyframes clignote { 50% { opacity: 0; } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
