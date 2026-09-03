<script>
  /**
   * Du sujet à la question testable, en trois temps. Chaque clic descend
   * d'un étage et la bande se resserre; au dernier, les trois clés de la
   * question testable s'allument dessous — hors de la bande, pour ne rien
   * couper.
   */
  import { brancherTemps } from '../temps.js';
  const ETAGES = [
    { et: 'UN SUJET', t: 'La participation électorale des jeunes.', w: 100, note: 'On peut en parler. On ne peut pas y répondre.' },
    { et: 'UNE QUESTION', t: 'Pourquoi les jeunes votent-ils moins ?', w: 80, note: 'Mieux. Mais « pourquoi » ouvre sur mille réponses.' },
    { et: 'UNE QUESTION TESTABLE', t: 'L’âge est-il associé à la probabilité de voter, chez les électeur.rice.s du Québec en 2022 ?', w: 60, note: '' }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel entonnoir" bind:this={hote}>
  {#each ETAGES as et, i}
    <div class="etage" class:vu={e >= i} class:actif={e === i || (i === 2 && e === 3)} class:fin={i === 2} style="width: {et.w}%">
      <span class="et">{et.et}</span>
      <p>{et.t}</p>
      {#if et.note}<span class="note">{et.note}</span>{/if}
    </div>
    {#if i < 2}<div class="fl" class:vu={e > i}>↓</div>{/if}
  {/each}
  <div class="cles" class:vu={e === 3}>
    <div><span class="k">QUOI</span><strong>deux choses à mesurer</strong><small>l'âge · voter ou non</small></div>
    <div><span class="k">CHEZ QUI</span><strong>une population</strong><small>électeur.rice.s du Québec, 2022</small></div>
    <div><span class="k">QUEL LIEN</span><strong>une relation à vérifier</strong><small>« associé à »</small></div>
  </div>
</div>

<style>
  .entonnoir { display: flex; flex-direction: column; align-items: center; gap: 0.2em; }
  .etage { border: 3px solid var(--dk-filet); padding: 0.7em 1.2em; display: grid; grid-template-columns: auto 1fr auto; column-gap: 1.2em; align-items: baseline; background: var(--dk-fond-2); opacity: 0.18; transform: translateY(0.4em); transition: opacity 0.5s, transform 0.5s, border-color 0.4s; }
  .etage.vu { opacity: 1; transform: none; }
  .etage.actif { border-color: var(--dk-encre); }
  .etage.fin.actif { border-color: var(--dk-accent); background: var(--dk-fond); }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); white-space: nowrap; }
  .fin .et { color: var(--dk-accent); }
  .etage p { margin: 0; font-size: 1.1em; line-height: 1.35; }
  .note { font-size: 0.66em; color: var(--dk-gris); max-width: 14em; text-align: right; line-height: 1.3; }
  .fl { font-size: 1.4em; color: var(--dk-accent); line-height: 1; opacity: 0; transition: opacity 0.4s; }
  .fl.vu { opacity: 1; }
  .cles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; width: 100%; margin-top: 0.9em; opacity: 0; transform: translateY(0.5em); transition: opacity 0.5s, transform 0.5s; }
  .cles.vu { opacity: 1; transform: none; }
  .cles > div { border-top: 5px solid var(--dk-accent); padding-top: 0.5em; display: flex; flex-direction: column; gap: 0.15em; }
  .k { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-accent); }
  .cles strong { font-size: 1em; }
  .cles small { font-size: 0.72em; color: var(--dk-gris); }
</style>
