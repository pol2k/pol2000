<script>
  /**
   * Un seul projet, en deux temps. Au premier temps, le devis de mi-session:
   * quatre sections. Un clic: le document s'allonge et quatre sections
   * s'ajoutent, en rouge — c'est le travail final. Le mi-session revient
   * corrigé entre les deux.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const BASE = ['La question', 'X et Y', 'Les hypothèses, et leur nulle', 'La base de données'];
  const PLUS = ['Un graphe orienté acyclique', 'Les statistiques descriptives', 'La régression et son tableau', "L'interprétation, les biais, les limites"];
</script>

<div class="visuel projet" bind:this={hote}>
  <div class="colonne">
    <div class="etq" class:acc={e === 1}>
      {#if e === 0}MI-SESSION · 20 % · DIM. 25 OCT.{:else}TRAVAIL FINAL · 25 % · VEN. 18 DÉC.{/if}
    </div>
    <div class="doc" class:long={e === 1}>
      <div class="coin"></div>
      {#each BASE as b, i}
        <div class="sec"><span class="n">{i + 1}</span><span>{b}</span></div>
      {/each}
      <div class="plus" class:vu={e === 1}>
        {#each PLUS as p, i}
          <div class="sec acc"><span class="n">{i + 5}</span><span>{p}</span></div>
        {/each}
      </div>
    </div>
  </div>
  <div class="cote">
    <div class="pas" class:on={e === 0}><span class="num">1</span><strong>Le devis</strong><small>Vous posez la question. Je corrige.</small></div>
    <div class="fl">↓</div>
    <div class="pas" class:on={e === 1}><span class="num">2</span><strong>Le projet complet</strong><small>Le même document, quatre sections de plus.</small></div>
    <p class="cle">La rétroaction arrive <strong>avant</strong> que vous écriviez la suite.</p>
  </div>
</div>

<style>
  .projet { display: grid; grid-template-columns: 1fr 1fr; gap: 2.4em; align-items: start; }
  .colonne { display: flex; flex-direction: column; gap: 0.5em; }
  .etq { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .etq.acc { color: var(--dk-accent); }
  .doc { position: relative; border: 3px solid var(--dk-encre); padding: 1em 1.1em 0.8em; background: var(--dk-fond); display: flex; flex-direction: column; gap: 0.45em; transition: border-color 0.5s; }
  .doc.long { border-color: var(--dk-accent); }
  .coin { position: absolute; top: -3px; right: -3px; width: 1.6em; height: 1.6em; background: linear-gradient(225deg, var(--dk-fond-2) 50%, var(--dk-encre) 50%); }
  .sec { display: grid; grid-template-columns: 1.6em 1fr; gap: 0.5em; align-items: baseline; font-size: 0.92em; }
  .sec .n { font-family: var(--dk-mono); font-weight: 600; color: var(--dk-gris); }
  .sec.acc { color: var(--dk-accent); font-weight: 600; }
  .sec.acc .n { color: var(--dk-accent); }
  .plus { display: flex; flex-direction: column; gap: 0.45em; max-height: 0; overflow: hidden; opacity: 0; transition: max-height 0.8s cubic-bezier(0.65, 0, 0.25, 1), opacity 0.5s 0.2s; }
  .plus.vu { max-height: 12em; opacity: 1; }
  .cote { display: flex; flex-direction: column; gap: 0.4em; padding-top: 1.6em; }
  .pas { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; display: grid; grid-template-columns: auto 1fr; column-gap: 0.7em; align-items: baseline; transition: border-color 0.4s; }
  .pas.on { border-color: var(--dk-accent); border-width: 3px; }
  .pas .num { font-family: var(--dk-mono); font-size: 1.6em; font-weight: 600; color: var(--dk-accent); grid-row: 1 / 3; }
  .pas strong { font-size: 1.05em; }
  .pas small { display: block; font-size: 0.72em; color: var(--dk-gris); }
  .fl { text-align: center; font-size: 1.6em; color: var(--dk-accent); line-height: 1; }
  .cle { margin: 0.8em 0 0; font-size: 0.95em; }
</style>
