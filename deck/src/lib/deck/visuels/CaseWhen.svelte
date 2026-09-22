<script>
  /**
   * Si…, alors… : l'anatomie d'une règle de case_when(), puis sa lecture en
   * français, comme « Anatomie d'une ligne de code » et « En langage
   * naturel » du cours 4 de FAS1001. Le code est celui que R a exécuté
   * (CONSOLES.scolarite). Quatre temps :
   *
   *   1  la condition        2  le ~ : « alors »
   *   3  la nouvelle valeur  4  la phrase en français
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { CONSOLES } from '$lib/data/seance4.js';

  const lignes = CONSOLES.scolarite[0].in.split('\n');
  const iRegle = lignes.findIndex((l) => l.includes('~'));
  const regle = lignes[iRegle];
  const [gauche, droite] = regle.split('~');
  const retrait = gauche.match(/^\s*/)[0];
  const condition = gauche.trim();
  const valeur = droite.trim();
  const avantR = lignes.slice(0, iRegle).join('\n');
  const apresR = lignes.slice(iRegle + 1).join('\n');

  const LEG = [
    ['UNE RÈGLE', 'Une ligne par catégorie.'],
    ['LA CONDITION', 'Une question à R : TRUE ou FALSE.'],
    ['ALORS', 'Le ~ se lit « alors ».'],
    ['LA NOUVELLE VALEUR', 'Ce qu’on écrit dans la nouvelle colonne.'],
    ['EN FRANÇAIS', '']
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel casewhen" bind:this={hote}>
  <pre class="code"><span class="autour">{@html surlignerR(avantR)}</span>
<span class="regle" class:vue={e >= 1}>{retrait}<span class="p" class:on={e === 1}>{@html surlignerR(condition)}</span>  <span class="p tilde" class:on={e === 2}>~</span> <span class="p" class:on={e === 3}>{@html surlignerR(valeur)}</span></span>
<span class="autour">{@html surlignerR(apresR)}</span></pre>

  {#key e}
    <div class="legende">
      <span class="et">{LEG[e][0]}</span>
      {#if e < 4}
        <p>{LEG[e][1]}</p>
      {:else}
        <p class="phrase">Si la scolarité vaut 5 ou moins, <b>alors</b> écrire « Secondaire ou moins ».</p>
        <p class="suite">Sinon, essayer la règle suivante. Aucune règle ne marche ? <b>NA</b>.</p>
      {/if}
    </div>
  {/key}
</div>

<style>
  .casewhen { display: flex; flex-direction: column; gap: 1em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1.25em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 3px solid var(--dk-encre); border-left: 0.3em solid var(--dk-accent); padding: 0.6em 0.9em; overflow-x: auto; }
  .autour { opacity: 0.55; }
  .regle { display: inline-block; transition: background 0.3s; }
  .regle.vue { background: #fff; outline: 2px solid var(--dk-encre); outline-offset: 0.1em; }
  .p { transition: background 0.3s, box-shadow 0.3s; padding: 0 0.05em; }
  .p.on { background: var(--dk-accent-clair); box-shadow: inset 0 -0.16em 0 var(--dk-accent); }
  .tilde.on { color: var(--dk-accent); font-weight: 700; }
  .legende { display: flex; flex-direction: column; gap: 0.35em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.4em; line-height: 1.35; animation: fondu 0.4s both; }
  .legende .phrase { font-size: 1.5em; }
  .legende .suite { font-size: 1.1em; color: var(--dk-gris); animation-delay: 0.3s; }
  .legende b { color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .legende p { animation: none; } }
</style>
