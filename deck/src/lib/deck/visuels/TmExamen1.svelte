<script>
  /**
   * Retour sur l'examen 1 : un gabarit à remplir par l'enseignant, pas une
   * diapo finie. Le dépôt est public : aucune note, aucune moyenne, aucune
   * donnée d'étudiant.e ne doit y entrer. Chaque case pointillée porte la
   * mention « à compléter par le prof »; on la remplace par le texte voulu
   * (ou on retire la case) dans le tableau CASES ci-dessous.
   *
   * En haut, ce qui est déjà vrai et vient de cours.js (EVALUATIONS, id
   * 'examen1') : le poids et la date de remise. En dessous, trois cases :
   *
   *   1  Ce qui a bien été (une ou deux forces de la classe);
   *   2  Les pièges fréquents (les erreurs à ne pas refaire au travail final);
   *   3  Votre note : où et quand la voir, et à qui écrire.
   *
   * Trois temps : chaque clic allume une case, dans l'ordre.
   */
  import { brancherTemps } from '../temps.js';
  import { EVALUATIONS } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { day: 'numeric', month: 'long' });

  // `texte` vide = la case reste en gabarit, avec la mention ci-dessous.
  const A_COMPLETER = '[à compléter par le prof]';
  const CASES = [
    { et: 'CE QUI A BIEN ÉTÉ', texte: '' },
    { et: 'LES PIÈGES FRÉQUENTS', texte: '' },
    { et: 'VOTRE NOTE', texte: '' }
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: CASES.length, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tm-ex1" bind:this={hote}>
  <div class="tm-ex1-bande">
    <span class="tm-ex1-poids">{ex.poids}&#8239;%</span>
    <span class="tm-ex1-nom">{ex.court} · remis le {jour(ex.date)}</span>
    <span class="tm-ex1-corr">la correction</span>
  </div>
  <div class="tm-ex1-cases">
    {#each CASES as c, i}
      <div class="tm-ex1-case" class:tm-vide={!c.texte} class:tm-on={e > i} class:tm-actif={e === i + 1}>
        <span class="tm-ex1-num">{i + 1}</span>
        <span class="tm-ex1-et">{c.et}</span>
        {#if c.texte}<p>{c.texte}</p>{:else}<p class="tm-ex1-a">{A_COMPLETER}</p>{/if}
      </div>
    {/each}
  </div>
</div>

<style>
  .tm-ex1 { display: flex; flex-direction: column; gap: 1.2em; max-width: 58em; margin: 0 auto; }
  .tm-ex1-bande { display: flex; align-items: baseline; gap: 1.2em; border-bottom: 3px solid var(--dk-encre); padding-bottom: 0.45em; animation: tm-ex1-f 0.5s both; }
  .tm-ex1-poids { font-size: 2.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .tm-ex1-nom { font-size: 1.05em; font-weight: 600; }
  .tm-ex1-corr { margin-left: auto; font-size: 0.85em; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-fond); background: var(--dk-encre); padding: 0.2em 0.6em; }
  .tm-ex1-cases { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.1em; }
  .tm-ex1-case { display: flex; flex-direction: column; gap: 0.5em; min-height: 11em; border: 3px solid var(--dk-encre); padding: 0.9em 1em; opacity: 0.25; transition: opacity 0.4s, border-color 0.4s, transform 0.4s; }
  .tm-ex1-case.tm-vide { border-style: dashed; }
  .tm-ex1-case.tm-on { opacity: 1; }
  .tm-ex1-case.tm-actif { border-color: var(--dk-accent); transform: translateY(-0.25em); }
  .tm-ex1-num { font-size: 2em; font-weight: 600; line-height: 1; color: var(--dk-gris-2); }
  .tm-actif .tm-ex1-num { color: var(--dk-accent); }
  .tm-ex1-et { font-size: 0.7em; font-weight: 600; letter-spacing: 0.14em; }
  .tm-ex1-case p { margin: 0; font-size: 1em; line-height: 1.4; }
  .tm-ex1-case p.tm-ex1-a { font-size: 0.8em; color: var(--dk-accent); background: var(--dk-fond-2); padding: 0.3em 0.5em; align-self: flex-start; }
  @keyframes tm-ex1-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .tm-ex1-bande { animation: none; } .tm-ex1-case { transition: none; } }
</style>
