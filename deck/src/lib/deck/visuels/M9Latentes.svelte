<script>
  /**
   * Des concepts qu'on ne voit jamais, et ce qu'on mesure à leur place.
   * Six exemples classiques de variables latentes : trois de la psychologie
   * (rangée du haut), trois de la science politique (rangée du bas). Le
   * concept est en pointillé, comme dans M9Arbre et M9Visible : il est
   * invisible. Ses indicateurs sont des boîtes pleines : on les observe. Au
   * clic :
   *
   *   0  les six concepts, seuls, en pointillé;
   *   1  les flèches et trois indicateurs par concept.
   *
   * Les indicateurs sont des questions réelles des grandes échelles
   * (sous-tests de QI, Big Five, bien-être subjectif, CES, ESS, ANES).
   * Un schéma, sans donnée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Chaque exemple : le concept, une précision facultative, trois indicateurs.
  const L = [
    { nom: 'L’intelligence', ind: ['vocabulaire', 'mémoire', 'raisonnement'] },
    { nom: 'L’extraversion', sous: 'Big Five', ind: ['bavard.e', 'sociable', 'énergique'] },
    { nom: 'Le bien-être', ind: ['satisfaction de vie', 'joie', 'optimisme'] },
    { nom: 'L’idéologie', sous: 'gauche-droite', ind: ['rôle de l’État', 'immigration', 'avortement'] },
    { nom: 'La confiance politique', ind: ['le Parlement', 'les partis', 'les élu.e.s'] },
    { nom: 'L’autoritarisme', ind: ['obéissance', 'bonnes manières', 'respect des aînés'] }
  ];
  // Les flèches partent du centre du concept vers le centre de chaque colonne.
  const BOUTS = [50, 150, 250];
</script>

<div class="visuel m9lat" bind:this={hote}>
  <div class="m9lat-grille">
    {#each L as c, i}
      <div class="m9lat-carte" style="--i: {i}" role="img" aria-label="{c.nom}{c.sous ? ` (${c.sous})` : ''}, indicateurs : {c.ind.join(', ')}">
        <div class="m9lat-concept">
          <strong>{c.nom}</strong>
          {#if c.sous}<span class="m9lat-sous">{c.sous}</span>{/if}
        </div>
        <svg viewBox="0 0 300 40" preserveAspectRatio="none" class="m9lat-fleches" class:vu={e >= 1} aria-hidden="true">
          {#each BOUTS as x}
            <line x1="150" y1="0" x2={x} y2="40" vector-effect="non-scaling-stroke" />
          {/each}
        </svg>
        <div class="m9lat-ind" class:vu={e >= 1}>
          {#each c.ind as t}
            <span class="m9lat-cell"><span class="m9lat-puce"><i class="m9lat-pointe"></i>{t}</span></span>
          {/each}
        </div>
      </div>
    {/each}
  </div>
</div>

<style>
  .m9lat { width: 100%; max-width: 62em; margin: 0.6em auto 0; }
  .m9lat-grille { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em 1.2em; }
  .m9lat-carte { display: flex; flex-direction: column; border: 2px solid var(--dk-filet); padding: 0.65em 0.35em 0.75em; animation: m9lat-fondu 0.5s both; animation-delay: calc(var(--i) * 0.12s); }
  .m9lat-concept { align-self: center; display: flex; flex-direction: column; align-items: center; padding: 0.35em 0.9em; border: 3px dashed var(--dk-encre); background: var(--dk-fond); text-align: center; line-height: 1.2; }
  .m9lat-concept strong { font-size: 1.1em; }
  .m9lat-sous { font-size: 0.66em; color: var(--dk-gris); letter-spacing: 0.06em; }
  .m9lat-fleches { display: block; width: 100%; flex: 1 0 2.2em; min-height: 2.2em; overflow: visible; opacity: 0; transition: opacity 0.45s; }
  .m9lat-fleches line { stroke: var(--dk-encre); stroke-width: 2.5; }
  .m9lat-ind { display: grid; grid-template-columns: repeat(3, 1fr); opacity: 0; transform: translateY(0.3em); transition: opacity 0.45s 0.15s, transform 0.45s 0.15s; }
  .m9lat-cell { display: flex; justify-content: center; padding: 0 0.1em; }
  .m9lat-puce { position: relative; width: 100%; display: flex; align-items: center; justify-content: center; padding: 0.35em 0.15em; border: 2px solid var(--dk-encre); background: var(--dk-fond-2); font-size: 0.68em; font-weight: 600; line-height: 1.2; text-align: center; hyphens: manual; }
  .m9lat-pointe { position: absolute; left: 50%; top: -2px; transform: translate(-50%, -100%); width: 0; height: 0; border-left: 0.4em solid transparent; border-right: 0.4em solid transparent; border-top: 0.55em solid var(--dk-encre); }
  .m9lat-fleches.vu, .m9lat-ind.vu { opacity: 1; transform: none; }
  @keyframes m9lat-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9lat-carte { animation: none; } .m9lat-fleches, .m9lat-ind { transition: none; } }
</style>
