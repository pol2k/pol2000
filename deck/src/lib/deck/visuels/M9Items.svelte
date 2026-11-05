<script module>
  /** Les quatorze questions de la CES 2025 qu'on croit de gauche ou de droite.
   *  « court » va sur la diapo; « t » est le libellé français du questionnaire,
   *  mot pour mot, pour l'annexe. 0 = gauche, 1 = droite. « gauche » : être
   *  d'accord, c'est être à gauche, on retourne avec 1 − x. Les trois « paris »
   *  sont des questions qu'on croit liées à la gauche et à la droite, sans en
   *  être sûr. */
  export const GROUPES = [
    { cle: 'economie', t: 'L’économie' },
    { cle: 'societe', t: 'La société' },
    { cle: 'paris', t: 'Nos paris' }
  ];
  export const ENONCES = [
    { g: 'economie', v: 'ideo_niveau_vie', ces: 'pes25_stdofliving', court: 'L’État garantit un niveau de vie', gauche: true, t: 'Le gouvernement devrait : voir à ce que tout le monde ait un niveau de vie décent, ou laisser les gens avancer par eux-mêmes.' },
    { g: 'economie', v: 'ideo_inegalites', ces: 'pes25_govt_act_ineq', court: 'Réduire les écarts de revenus', gauche: true, t: 'Le gouvernement devrait prendre des mesures pour réduire les écarts entre les niveaux de revenus.' },
    { g: 'economie', v: 'ideo_prive', ces: 'pes25_privjobs', court: 'Le privé crée les emplois', t: 'Le gouvernement devrait laisser au secteur privé l’entière responsabilité de créer des emplois.' },
    { g: 'economie', v: 'ideo_merite', ces: 'pes25_blame', court: 'Échouer, c’est sa faute', t: 'Ceux qui ne réussissent pas dans la vie devraient se blâmer eux-mêmes, pas le système.' },
    { g: 'economie', v: 'ideo_prog_sociaux', ces: 'pes25_deserve2', court: 'Les programmes sociaux déresponsabilisent', t: 'Les programmes sociaux incitent les gens à moins se débrouiller par eux-mêmes.' },
    { g: 'societe', v: 'ideo_egalite', ces: 'pes25_equalrights', court: 'Trop loin pour les droits égaux', t: 'Nous sommes allés trop loin dans la promotion des droits égaux dans ce pays.' },
    { g: 'societe', v: 'ideo_femmes', ces: 'pes25_womenhome', court: 'Moins de femmes au travail', t: 'La société se porterait mieux si moins de femmes travaillaient à l’extérieur du foyer.' },
    { g: 'societe', v: 'ideo_integration', ces: 'pes25_fitin', court: 'Les immigrants ne s’intègrent pas', t: 'Un trop grand nombre d’immigrants récents ne veut tout simplement pas s’intégrer.' },
    { g: 'societe', v: 'ideo_immig_emplois', ces: 'pes25_immigjobs', court: 'Les immigrants enlèvent des emplois', t: 'Les immigrants enlèvent des emplois aux autres Canadiens.' },
    { g: 'societe', v: 'ideo_modes_vie', ces: 'pes25_newerlife', court: 'Les nouveaux modes de vie dégradent', t: 'Les nouveaux modes de vie contribuent à la dégradation de notre société.' },
    { g: 'societe', v: 'ideo_autochtones', ces: 'pes25_indig_deserve', court: 'Les Autochtones ont reçu moins', gauche: true, t: 'Les Peuples autochtones ont reçu moins que ce qu’ils méritent au cours des dernières années.' },
    { g: 'paris', v: 'ideo_commerce', ces: 'pes25_trade', court: 'Le commerce crée des emplois', pari: 'pro-marché, donc à droite ?', t: 'Le commerce international crée plus d’emplois au Canada qu’il n’en détruit.' },
    { g: 'paris', v: 'ideo_defense', ces: 'cps25_spend_defence', court: 'Dépenser plus en défense', pari: 'l’armée, donc à droite ?', t: 'Combien le gouvernement fédéral devrait-il dépenser en défense ? (moins, autant, plus)' },
    { g: 'paris', v: 'ideo_francais_qc', ces: 'pes25_langQC', court: 'Le français n’est pas menacé', pari: 'au Québec, un autre axe ?', t: 'Selon vous, la langue française est-elle menacée au Québec ? (oui, non)' }
  ];
</script>

<script>
  /**
   * Les quatorze questions, en trois groupes de pastilles. Une pastille : quelques
   * mots, le nom de la variable dans la CES, et « ⇄ » si être d'accord, c'est être à gauche.
   * « exact » : le libellé mot pour mot (annexe), pour les groupes demandés.
   */
  let { exact = null } = $props();
</script>

{#if exact}
  <ol class="visuel m9i-exact">
    {#each ENONCES.filter((x) => exact.includes(x.g)) as it}
      <li><b>{it.ces}<small class="m9i-recode">→ {it.v}</small></b><span>« {it.t} »{#if it.gauche}<small>d’accord = gauche : 1 − x</small>{/if}</span></li>
    {/each}
  </ol>
{:else}
  <div class="visuel m9i">
    {#each GROUPES as g, k}
      <div class="m9i-groupe" class:paris={g.cle === 'paris'} style="--k: {k}">
        <span class="m9i-gt">{g.t}</span>
        {#each ENONCES.filter((x) => x.g === g.cle) as it}
          <div class="m9i-pastille">
            <strong>{it.court}</strong>
            <span class="m9i-v">{it.ces}{#if it.gauche}<em class="m9i-tag">⇄ d’accord = gauche</em>{/if}</span>
            {#if it.pari}<span class="m9i-pari">{it.pari}</span>{/if}
          </div>
        {/each}
      </div>
    {/each}
  </div>
  <p class="m9i-pied">De 0 (gauche) à 1 (droite), comme l’auto-positionnement de 0 à 10.</p>
{/if}

<style>
  .m9i { display: grid; grid-template-columns: 1fr 1fr 0.9fr; gap: 1.2em; max-width: 64em; margin: 0.4em auto 0; align-items: start; }
  .m9i-groupe { display: flex; flex-direction: column; gap: 0.45em; animation: m9i-fondu 0.45s both; animation-delay: calc(var(--k) * 0.15s); }
  .m9i-gt { font-size: 0.75em; font-weight: 800; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris); border-bottom: 3px solid var(--dk-encre); padding-bottom: 0.2em; }
  .m9i-groupe.paris .m9i-gt { color: var(--dk-accent); border-color: var(--dk-accent); }
  .m9i-pastille { border: 2px solid var(--dk-encre); padding: 0.35em 0.6em; display: flex; flex-direction: column; gap: 0.1em; }
  .m9i-groupe.paris .m9i-pastille { border: 2px dashed var(--dk-accent); }
  .m9i-pastille strong { font-size: 0.86em; line-height: 1.2; }
  .m9i-v { font-size: 0.66em; color: var(--dk-gris); font-weight: 600; display: flex; justify-content: space-between; gap: 0.5em; flex-wrap: wrap; }
  .m9i-tag { font-style: normal; font-weight: 800; color: var(--dk-accent); }
  .m9i-pari { font-size: 0.72em; font-weight: 700; color: var(--dk-accent); }
  .m9i-pied { margin: 0.6em auto 0; max-width: 64em; font-size: 0.78em; color: var(--dk-gris); text-align: center; }
  .m9i-exact { list-style: none; margin: 0.4em auto 0; padding: 0; max-width: 62em; display: flex; flex-direction: column; }
  .m9i-exact li { display: grid; grid-template-columns: 10em 1fr; gap: 1em; padding: 0.35em 0; border-bottom: 2px solid var(--dk-filet); font-size: 0.85em; line-height: 1.3; }
  .m9i-exact b { color: var(--dk-gris); font-size: 0.85em; }
  .m9i-exact .m9i-recode { color: var(--dk-gris); font-weight: 600; margin-top: 0.2em; }
  .m9i-exact small { display: block; color: var(--dk-accent); font-size: 0.8em; margin-top: 0.1em; font-weight: 700; }
  @keyframes m9i-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9i-groupe { animation: none; } }
</style>
