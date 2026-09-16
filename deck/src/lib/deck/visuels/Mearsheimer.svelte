<script>
  /**
   * Le test de Lakatos appliqué à un cas réel, célèbre et contesté. La leçon
   * est méthodologique, pas morale : une prévision conditionnelle dont la
   * condition ne s’est jamais réalisée n’est ni réfutée, ni confirmée.
   *
   *   0  La frise part de 1990. La prévision, avec la clause conditionnelle
   *      encadrée en rouge : c’est elle, le nœud de la diapositive.
   *      Source : Mearsheimer, « Back to the Future », International
   *      Security, vol. 15, no 1, été 1990, p. 5-56 ; la citation est de la
   *      p. 6, traduction libre.
   *   1  Il a écrit lui-même comment le réfuter : deux phrases du même
   *      article, p. 9 et p. 10, traduction libre.
   *   2  La branche supposée (le départ des États-Unis d’Europe de l’Ouest)
   *      se dessine en pointillé, grise, barrée : elle ne s’est pas
   *      produite. Note : dans le même article, p. 8, il recommandait que
   *      les États-Unis ne se retirent pas complètement d’Europe. Puis son
   *      propre constat, « Why is Europe Peaceful Today? », European
   *      Political Science, vol. 9, 2010, p. 388, traduction libre.
   *   3  Le verdict, qui est le point à enseigner : ni réfutée, ni
   *      confirmée.
   *   4  Deux reproches différents, à poids égal : sur la théorie (Edinger,
   *      International Affairs, vol. 98, no 6, 2022, p. 1873-1893) et sur le
   *      chercheur.
   *
   * Rien n’est ajouté à ces sources : aucune prédiction, aucune date,
   * aucune critique de plus. La diapositive vaut par sa retenue ; c’est
   * l’étudiant.e qui tranche.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel mh-fig" bind:this={hote}>
  <p class="mh-ref">
    John Mearsheimer, «&#8239;Back to the Future: Instability in Europe after the Cold War&#8239;»,
    <i>International Security</i>, vol. 15, no 1, été 1990, p. 5-56
  </p>

  {#if e < 4}
    <svg
      class="mh-frise"
      viewBox="0 0 1000 180"
      role="img"
      aria-label="Frise à partir de 1990&#8239;: une prévision y est posée. La branche supposée par son auteur, le départ des États-Unis d’Europe de l’Ouest, est dessinée en pointillé gris, barrée, et marquée comme ne s’étant pas produite."
    >
      <!-- La ligne du temps : elle part de 1990 et continue. -->
      <line x1="70" y1="132" x2="950" y2="132" class="mh-axe" />
      <path d="M 930 122 L 952 132 L 930 142" class="mh-axe mh-pointe" />
      <line x1="140" y1="132" x2="140" y2="150" class="mh-axe" />
      <text x="140" y="172" class="mh-an">1990</text>
      <rect x="130" y="122" width="20" height="20" class="mh-noeud" />
      <text x="140" y="112" class="mh-noeud-t">la prévision</text>

      <!-- La branche supposée, qui n’a pas été prise. -->
      <g class="mh-br" class:mh-vu={e >= 2}>
        <circle cx="520" cy="132" r="7" class="mh-fourche" />
        <path d="M 520 132 L 665 66 L 700 66" class="mh-branche" />
        <rect x="700" y="30" width="262" height="72" class="mh-boite" />
        <text x="831" y="58" class="mh-boite-t">les États-Unis quittent</text>
        <text x="831" y="82" class="mh-boite-t">l’Europe de l’Ouest</text>
        <path d="M 580 87 L 604 111 M 604 87 L 580 111" class="mh-croix" />
        <text x="831" y="124" class="mh-pas">ne s’est pas produit</text>
      </g>
    </svg>
  {/if}

  <div class="mh-temps">
    {#if e === 0}
      <blockquote class="mh-these">
        «&#8239;<span class="mh-cond">si la guerre froide prend fin et que ce scénario se réalise</span>,
        l’Europe sera nettement plus violente que durant les 45 années précédentes&#8239;»
        <span class="mh-p">p. 6, traduction libre</span>
      </blockquote>
    {:else if e === 1}
      <p class="mh-titre">Il a écrit lui-même comment le réfuter.</p>
      <div class="mh-duo">
        <blockquote class="mh-carte">
          «&#8239;Ceux qui se risquent à prédire, comme je le fais ici, devraient procéder avec humilité.&#8239;»
          <span class="mh-p">p. 9, traduction libre</span>
        </blockquote>
        <blockquote class="mh-carte">
          «&#8239;Les prédictions d’événements sur le point de survenir sont les meilleurs tests des théories en sciences sociales.&#8239;»
          <span class="mh-p">p. 10, traduction libre</span>
        </blockquote>
      </div>
    {:else if e === 2}
      <p class="mh-note">
        Dans le même article (p. 8), il recommandait que les États-Unis ne se retirent pas complètement d’Europe.
      </p>
      <blockquote class="mh-aveu">
        «&#8239;J’avais prédit que les États-Unis quitteraient l’Europe de l’Ouest. Mais les États-Unis n’ont pas quitté l’Europe.&#8239;»
        <span class="mh-p">
          John Mearsheimer, «&#8239;Why is Europe Peaceful Today?&#8239;»,
          <i>European Political Science</i>, vol. 9, 2010, p. 388 (traduction libre)
        </span>
      </blockquote>
    {:else if e === 3}
      <p class="mh-verdict">La condition ne s’est jamais réalisée. Donc&#8239;: ni réfutée, ni confirmée.</p>
      <p class="mh-sous">
        Une prévision dont le déclencheur n’a jamais été tiré n’apprend pas grand-chose, dans un sens comme dans l’autre.
      </p>
    {:else}
      <div class="mh-duo">
        <div class="mh-carte">
          <span class="mh-chef">Sur la théorie</span>
          <p class="mh-dit">Elle serait trop souple pour qu’un seul résultat puisse la réfuter.</p>
          <span class="mh-p">Harald Edinger, <i>International Affairs</i>, vol. 98, no 6, 2022, p. 1873-1893</span>
        </div>
        <div class="mh-carte">
          <span class="mh-chef">Sur le chercheur</span>
          <p class="mh-dit">
            Il date et signe ses prévisions, publiquement, ce que peu de théoriciens font&#8239;;
            et il a reconnu lui-même que sa prémisse avait échoué.
          </p>
        </div>
      </div>
      <p class="mh-cle">Deux reproches différents. Le second n’en est pas un.</p>
    {/if}
  </div>
</div>

<style>
  .mh-fig { display: flex; flex-direction: column; gap: 0.7em; }

  .mh-ref { margin: 0; font-size: 0.6em; line-height: 1.4; letter-spacing: 0.04em; color: var(--dk-gris); }
  .mh-ref i { font-style: italic; }

  .mh-frise { width: 100%; height: auto; max-height: 44vh; display: block; overflow: visible; }
  .mh-frise text { font-family: var(--dk-mono); }
  .mh-axe { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .mh-pointe { stroke-linejoin: miter; }
  .mh-an { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mh-noeud { fill: var(--dk-accent); }
  .mh-noeud-t { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .mh-br { opacity: 0; transition: opacity 0.5s; }
  .mh-br.mh-vu { opacity: 1; }
  .mh-fourche { fill: var(--dk-encre); }
  .mh-branche { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 10 8; }
  .mh-boite { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 10 8; }
  .mh-boite-t { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .mh-croix { fill: none; stroke: var(--dk-accent); stroke-width: 5; opacity: 0; }
  .mh-br.mh-vu .mh-croix { animation: mh-pop 0.4s ease-out 0.45s forwards; }
  .mh-pas { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; }
  .mh-br.mh-vu .mh-pas { animation: mh-pop 0.4s ease-out 0.7s forwards; }

  /* L’animation va sur les enfants : eux seuls sont remontés à chaque temps. */
  .mh-temps { display: flex; flex-direction: column; gap: 0.6em; min-height: 9.5em; }
  .mh-temps > * { animation: mh-monte 0.45s ease-out both; }
  .mh-temps > *:nth-child(2) { animation-delay: 0.12s; }

  .mh-these { margin: 0; font-size: 1.28em; line-height: 1.5; border-left: 0.3em solid var(--dk-encre); padding-left: 0.7em; }
  .mh-cond { border: 2.5px solid var(--dk-accent); color: var(--dk-accent); font-weight: 600; padding: 0.02em 0.22em; box-decoration-break: clone; -webkit-box-decoration-break: clone; }

  .mh-titre { margin: 0; font-size: 1.15em; font-weight: 600; }
  .mh-duo { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; align-items: stretch; }
  .mh-carte { margin: 0; display: flex; flex-direction: column; gap: 0.35em; border: 2px solid var(--dk-encre); padding: 0.75em 0.85em 0.65em; font-size: 0.95em; line-height: 1.45; }
  .mh-chef { font-size: 0.62em; letter-spacing: 0.14em; font-weight: 600; text-transform: uppercase; color: var(--dk-gris); }
  .mh-dit { margin: 0; line-height: 1.45; }
  .mh-p { margin-top: auto; padding-top: 0.4em; display: block; font-size: 0.56em; line-height: 1.35; letter-spacing: 0.05em; color: var(--dk-gris); }
  .mh-p i { font-style: italic; }

  .mh-note { margin: 0; font-size: 0.72em; line-height: 1.4; color: var(--dk-gris); }
  .mh-aveu { margin: 0; font-size: 1.18em; line-height: 1.5; border-left: 0.3em solid var(--dk-encre); padding-left: 0.7em; }

  .mh-verdict { margin: 0; font-size: 1.28em; font-weight: 600; line-height: 1.4; color: var(--dk-accent); border: 3px solid var(--dk-accent); padding: 0.6em 0.75em; }
  .mh-sous { margin: 0; font-size: 0.95em; line-height: 1.45; }
  .mh-cle { margin: 0; font-size: 1.12em; font-weight: 600; color: var(--dk-accent); }

  @keyframes mh-pop { from { opacity: 0; } to { opacity: 1; } }
  @keyframes mh-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .mh-temps > * { animation: none; }
    .mh-br { transition: none; }
    .mh-br.mh-vu .mh-croix, .mh-br.mh-vu .mh-pas { animation: none; opacity: 1; }
  }
</style>
