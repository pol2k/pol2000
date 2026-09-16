<script>
  /**
   * Réfuter une théorie, ce n'est pas si simple. La diapositive précédente
   * dit qu'une bonne théorie est réfutable; celle-ci complique, honnêtement:
   * quand un test rate, il ne dit pas lequel des maillons a cédé.
   * Quatre temps.
   *
   *   0  La chaîne: la théorie, l'instrument, la mesure, l'échantillon.
   *      Chaque maillon est une supposition dont le test dépend. Au bout,
   *      une flèche vers la prédiction.
   *   1  Le test rate: la prédiction passe au rouge et se raye
   *      (« le résultat ne colle pas »). Les quatre maillons clignotent
   *      ENSEMBLE, puis restent cernés de rouge, aucun désigné — c'est tout
   *      le propos. Un point d'interrogation reste au-dessus de la chaîne.
   *   2  Duhem, cité dans l'original français. Source donnée à l'écran:
   *      Pierre Duhem, La théorie physique (1906), p. 307.
   *   3  Kuhn remplace Duhem (une citation à la fois, sinon c'est un mur de
   *      texte). Source donnée à l'écran: Thomas Kuhn, The Structure of
   *      Scientific Revolutions (2e éd., 1970), p. 146, traduction libre.
   *      Puis la question qui ouvre la diapositive suivante.
   *
   * Aucune donnée, aucun hasard: coordonnées fixes. Les deux citations sont
   * reproduites telles que fournies, avec leur page; rien n'est ajouté.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La chaîne: quatre maillons de 168 de large, espacés de 190.
  const MAILLONS = ['la théorie', 'l’instrument', 'la mesure', 'l’échantillon'];
  const LARG = 168;
  const PAS = 190;
  const X0 = 4;
  const bx = (i) => X0 + i * PAS;
  // Les joints tombent entre deux maillons.
  const JOINTS = [0, 1, 2].map((i) => bx(i) + LARG + (PAS - LARG) / 2);
  const FIN = bx(3) + LARG; // 742
  const MILIEU = (X0 + FIN) / 2;
</script>

<div class="visuel ps-fig" bind:this={hote}>
  <svg
    class="ps-scene"
    class:ps-recule={e >= 2}
    viewBox="0 0 1000 210"
    role="img"
    aria-label="Une chaîne de quatre maillons — la théorie, l’instrument, la mesure, l’échantillon — mène à une prédiction. Le résultat ne colle pas: la prédiction est rayée et les quatre maillons deviennent rouges en même temps. L’expérience ne dit pas lequel a cédé."
  >
    <!-- Le doute, au-dessus de la chaîne. -->
    <text x={MILIEU} y="64" class="ps-doute" class:ps-vu={e >= 1}>?</text>

    <!-- Les joints, derrière les maillons. -->
    {#each JOINTS as j, i}
      <g class="ps-joint" class:ps-casse={e >= 1} style="--d: {i * 90}ms">
        <line x1={j - 11} y1="125" x2={j + 11} y2="125" />
        <rect x={j - 7} y="118" width="14" height="14" />
      </g>
    {/each}

    <!-- Les quatre maillons: quatre suppositions, pas une. -->
    {#each MAILLONS as nom, i}
      <g class="ps-maillon" class:ps-casse={e >= 1} style="--d: {i * 90}ms">
        <rect x={bx(i)} y="88" width={LARG} height="74" class="ps-boite" />
        <text x={bx(i) + LARG / 2} y="132" class="ps-nom">{nom}</text>
      </g>
    {/each}

    <!-- Vers la prédiction. -->
    <path d="M 750 125 L 804 125 M 790 114 L 804 125 L 790 136" pathLength="1" class="ps-fleche" />

    <g class="ps-pred" class:ps-rate={e >= 1}>
      <rect x="812" y="88" width="184" height="74" class="ps-boite" />
      <text x="904" y="132" class="ps-nom">la prédiction</text>
      <line x1="820" y1="125" x2="988" y2="125" pathLength="1" class="ps-rature" />
    </g>

    <text x="890" y="194" class="ps-verdict" class:ps-vu={e >= 1}>le résultat ne colle pas</text>
    <text x={MILIEU} y="194" class="ps-cede" class:ps-vu={e >= 1}>quelque chose a cédé</text>
  </svg>

  <div class="ps-mot" class:ps-place={e >= 2}>
    {#if e === 2}
      <blockquote class="ps-cite">
        <p>«&#8239;le physicien ne peut jamais soumettre au contrôle de l’expérience une hypothèse isolée, mais seulement tout un ensemble d’hypothèses&#8239;»</p>
        <p class="ps-suite">«&#8239;mais elle ne lui désigne pas celle qui doit être changée.&#8239;»</p>
        <cite>Pierre Duhem, <i>La théorie physique</i> (1906), p. 307</cite>
      </blockquote>
    {:else if e >= 3}
      <blockquote class="ps-cite">
        <p>«&#8239;Si le moindre écart suffisait à rejeter une théorie, toutes les théories devraient être rejetées en tout temps.&#8239;»</p>
        <cite>Thomas Kuhn, <i>The Structure of Scientific Revolutions</i> (2e éd., 1970), p. 146 (traduction libre)</cite>
      </blockquote>
      <p class="ps-chute">On ne jette pas une théorie au premier accroc. Alors quand&#8239;?</p>
    {/if}
  </div>
</div>

<style>
  .ps-fig { display: flex; flex-direction: column; gap: 0.7em; }
  .ps-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; transition: max-height 0.5s ease; }
  /* La chaîne recule quand la citation prend la parole: le texte tient sous elle. */
  .ps-scene.ps-recule { max-height: 24vh; }
  text { font-family: var(--dk-mono); }

  .ps-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .ps-nom { font-size: 21px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .ps-maillon { animation: ps-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  .ps-maillon .ps-boite { fill: var(--dk-accent); fill-opacity: 0; transition: stroke 0.35s, fill-opacity 0.35s; }
  /* Les quatre clignotent en même temps: l'expérience n'en désigne aucun. */
  .ps-maillon.ps-casse .ps-boite { stroke: var(--dk-accent); animation: ps-clignote 0.42s ease-in-out 3; }
  .ps-maillon.ps-casse .ps-nom { fill: var(--dk-accent); }
  .ps-nom { transition: fill 0.35s; }

  .ps-joint line { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.35s; }
  .ps-joint rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.35s; }
  .ps-joint { animation: ps-fondu 0.4s both; animation-delay: var(--d); }
  .ps-joint.ps-casse line, .ps-joint.ps-casse rect { stroke: var(--dk-accent); }

  .ps-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; animation: ps-trace 0.5s ease-out 0.4s forwards; }

  .ps-pred { animation: ps-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) 0.4s both; }
  .ps-pred .ps-boite { transition: stroke 0.3s; }
  .ps-pred.ps-rate .ps-boite { stroke: var(--dk-accent); }
  .ps-pred.ps-rate .ps-nom { fill: var(--dk-accent); }
  .ps-rature { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.45s ease-out; }
  .ps-pred.ps-rate .ps-rature { stroke-dashoffset: 0; }

  .ps-doute { font-size: 62px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transform-box: fill-box; transform-origin: center; transform: scale(0.3); transition: opacity 0.3s 0.5s, transform 0.5s cubic-bezier(0.34, 1.7, 0.64, 1) 0.5s; }
  .ps-doute.ps-vu { opacity: 1; transform: none; }

  .ps-cede { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.8s; }
  .ps-cede.ps-vu { opacity: 1; }
  .ps-verdict { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.3s; }
  .ps-verdict.ps-vu { opacity: 1; }

  .ps-mot { display: flex; flex-direction: column; gap: 0.5em; }
  .ps-place { min-height: 7.2em; }
  .ps-cite { margin: 0; border-left: 6px solid var(--dk-accent); padding: 0.1em 0 0.1em 0.9em; animation: ps-monte 0.45s ease-out both; }
  .ps-cite p { margin: 0; font-size: 0.95em; line-height: 1.4; }
  .ps-cite .ps-suite { margin-top: 0.25em; animation: ps-monte 0.45s ease-out 0.35s both; }
  .ps-cite cite { display: block; margin-top: 0.5em; font-style: normal; font-size: 0.62em; letter-spacing: 0.1em; color: var(--dk-gris); animation: ps-fondu 0.4s 0.5s both; }
  .ps-cite i { font-style: italic; }
  .ps-chute { margin: 0; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); animation: ps-monte 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.6s both; }

  @keyframes ps-monte { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @keyframes ps-fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes ps-trace { to { stroke-dashoffset: 0; } }
  @keyframes ps-clignote { 0%, 100% { fill-opacity: 0; } 50% { fill-opacity: 0.2; } }

  @media (prefers-reduced-motion: reduce) {
    .ps-scene { transition: none; }
    .ps-maillon, .ps-joint, .ps-pred, .ps-cite, .ps-cite .ps-suite, .ps-cite cite, .ps-chute { animation: none; }
    .ps-maillon.ps-casse .ps-boite { animation: none; }
    .ps-fleche { animation: none; stroke-dashoffset: 0; }
    .ps-maillon .ps-boite, .ps-joint line, .ps-joint rect, .ps-nom, .ps-pred .ps-boite, .ps-rature, .ps-doute, .ps-cede, .ps-verdict { transition: none; }
  }
</style>
