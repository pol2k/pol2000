<script>
  /**
   * Pourquoi se donner la peine de faire de la science ? Pas pour avoir
   * raison : pour s'empêcher de croire ce qu'on a envie de croire.
   * Trois temps.
   *
   *   0  L'épisode Millikan, en schéma. Robert Millikan a mesuré la charge
   *      de l'électron et a obtenu une valeur légèrement fausse. Les
   *      mesures publiées ensuite ne sautent pas à la vraie valeur : elles
   *      s'en approchent lentement, parce que celui qui trouvait loin de
   *      Millikan supposait s'être trompé et cherchait son erreur, tandis
   *      que celui qui trouvait proche publiait sans rien vérifier.
   *   1  On nomme la chose : ce n'est pas de la malhonnêteté, c'est humain.
   *   2  La phrase de Feynman, qui est le point de la diapositive, puis la
   *      ligne rouge : la méthode nous protège de nous-mêmes.
   *
   * Aucune donnée réelle : les douze positions sont fixes et servent
   * seulement à montrer la dérive. La scène est légendée « schéma ».
   * La citation vient de Richard Feynman, « Cargo Cult Science »,
   * Engineering and Science, vol. 37, no 7, juin 1974 (traduction libre).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie (viewBox 1000 × 350).
  const VRAIE = 100, SOL = 300, GAUCHE = 90;

  // Les mesures publiées, l'une après l'autre. La première est celle de
  // Millikan, nettement sous la vraie valeur; les suivantes remontent vers
  // elle sans jamais l'atteindre. Positions fixes, aucune donnée réelle.
  const MESURES = [
    { x: 150, y: 252 },
    { x: 218, y: 246 },
    { x: 286, y: 234 },
    { x: 354, y: 238 },
    { x: 422, y: 220 },
    { x: 490, y: 208 },
    { x: 558, y: 198 },
    { x: 626, y: 182 },
    { x: 694, y: 168 },
    { x: 762, y: 150 },
    { x: 830, y: 134 },
    { x: 898, y: 120 }
  ];
  const TRACE = MESURES.map((m, i) => `${i ? 'L' : 'M'} ${m.x} ${m.y}`).join(' ');
</script>

<div class="visuel pq-fig" bind:this={hote}>
  <div class="pq-scene" class:pq-recule={e >= 2}>
    <svg
      viewBox="0 0 1000 350"
      role="img"
      aria-label="Schéma : la charge de l’électron, mesure après mesure. La première mesure, celle de Millikan, est nettement sous la vraie valeur. Les mesures publiées ensuite ne se répartissent pas autour de la vraie valeur : elles s’en approchent lentement, parce qu’on ne cherche son erreur que lorsque le résultat surprend."
    >
      <!-- Les deux axes : le temps en bas, la valeur mesurée à gauche. -->
      <line x1={GAUCHE} y1="64" x2={GAUCHE} y2={SOL} class="pq-axe" />
      <line x1={GAUCHE} y1={SOL} x2="960" y2={SOL} class="pq-axe" />
      <text x="40" y="192" class="pq-axe-t" transform="rotate(-90 40 192)">la charge de l’électron</text>
      <text x="520" y="330" class="pq-axe-t">mesures publiées, les unes après les autres</text>

      <!-- La vraie valeur, qu'on ne connaît qu'après coup. -->
      <line x1={GAUCHE} y1={VRAIE} x2="960" y2={VRAIE} class="pq-vraie" />
      <text x="960" y="86" class="pq-vraie-t">la vraie valeur</text>

      <!-- La dérive, tracée sous les points. -->
      <path d={TRACE} pathLength="1" class="pq-derive" />

      {#each MESURES as m, i}
        <circle cx={m.x} cy={m.y} r={i === 0 ? 12 : 10} class="pq-pt" class:pq-mil={i === 0} style="--k: {i}" />
      {/each}
      <text x="172" y="284" class="pq-mil-t">la première mesure de Millikan</text>

      <!-- Le motif, nommé une fois les points posés. -->
      <text x="500" y="44" class="pq-motif">on cherche l’erreur seulement quand le résultat nous surprend</text>
    </svg>
    <p class="pq-legende">schéma</p>
  </div>

  <p class="pq-humain" class:pq-vu={e >= 1}>Ce n’est pas de la malhonnêteté. C’est humain.</p>

  <div class="pq-bloc" class:pq-vu={e >= 2}>
    <p class="pq-cit">«&#8239;Le premier principe, c’est qu’il ne faut pas se leurrer soi-même&#8239;; et vous êtes la personne la plus facile à leurrer.&#8239;»</p>
    <p class="pq-attr">Richard Feynman, «&#8239;Cargo Cult Science&#8239;», <i>Engineering and Science</i>, vol. 37, no 7, juin 1974 (traduction libre)</p>
    <p class="pq-chute">La méthode, c’est ce qui nous protège de nous-mêmes.</p>
  </div>
</div>

<style>
  /* .pq-bloc est masqué par opacity, pas retiré du flux : la diapositive a donc
     la même hauteur dès le temps 0. Ce qui se resserre ici doit se resserrer
     partout, sinon le débordement survit au dernier temps. */
  .pq-fig { display: flex; flex-direction: column; gap: 0.35em; }
  .pq-scene { display: flex; flex-direction: column; gap: 0.1em; transition: opacity 0.5s; }
  .pq-scene.pq-recule { opacity: 0.3; }
  svg { width: 100%; height: auto; max-height: 44vh; display: block; overflow: visible; transition: max-height 0.5s; }
  /* Au dernier temps la scène est déjà estompée et personne ne la lit : on la
     resserre là, et seulement là, pour que la citation tienne dans la
     diapositive. La rapetisser à tous les temps rendrait ses étiquettes
     illisibles du fond de la salle. */
  .pq-scene.pq-recule svg { max-height: 34vh; }
  text { font-family: var(--dk-mono); }

  .pq-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .pq-axe-t { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }

  .pq-vraie { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 10 8; }
  .pq-vraie-t { font-size: 17px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }

  .pq-derive {
    fill: none;
    stroke: var(--dk-gris-2);
    stroke-width: 3;
    stroke-dasharray: 1;
    stroke-dashoffset: 1;
    animation: pq-trace 1.6s ease-out 0.5s both;
  }

  .pq-pt {
    fill: var(--dk-encre);
    stroke: var(--dk-fond);
    stroke-width: 2.5;
    animation: pq-tombe 0.5s cubic-bezier(0.34, 1.5, 0.64, 1) both;
    animation-delay: calc(var(--k) * 110ms + 200ms);
  }
  .pq-pt.pq-mil { fill: var(--dk-accent); stroke-width: 3; }
  /* Halo couleur papier : l'axe passe derrière les étiquettes, pas au travers. */
  .pq-mil-t {
    font-size: 15px;
    font-weight: 600;
    fill: var(--dk-accent);
    paint-order: stroke;
    stroke: var(--dk-fond);
    stroke-width: 7px;
    stroke-linejoin: round;
    animation: pq-monte 0.5s ease-out 0.7s both;
  }
  .pq-motif {
    font-size: 18px;
    font-weight: 600;
    text-anchor: middle;
    fill: var(--dk-accent);
    animation: pq-monte 0.6s ease-out 1.9s both;
  }

  .pq-legende { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris-2); }

  .pq-humain {
    margin: 0;
    min-height: 1.4em;
    font-size: 1.15em;
    font-weight: 600;
    color: var(--dk-encre);
    border-left: 4px solid var(--dk-encre);
    padding-left: 0.6em;
    opacity: 0;
    transform: translateY(0.5em);
    transition: opacity 0.4s, transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  .pq-humain.pq-vu { opacity: 1; transform: none; }

  .pq-bloc {
    display: flex;
    flex-direction: column;
    gap: 0.35em;
    border-top: 3px solid var(--dk-filet);
    padding-top: 0.6em;
    opacity: 0;
    transition: opacity 0.4s, border-color 0.4s;
  }
  .pq-bloc.pq-vu { opacity: 1; border-top-color: var(--dk-encre); }

  .pq-cit {
    margin: 0;
    font-size: 1.4em;
    line-height: 1.24;
    font-weight: 600;
    color: var(--dk-encre);
    transform: scale(0.96);
    transform-origin: 0 50%;
    transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s;
  }
  .pq-bloc.pq-vu .pq-cit { transform: none; }

  .pq-attr { margin: 0; font-size: 0.68em; line-height: 1.35; color: var(--dk-gris); }
  .pq-attr i { font-style: italic; }

  .pq-chute {
    margin: 0.15em 0 0;
    font-size: 1.05em;
    font-weight: 600;
    color: var(--dk-accent);
    opacity: 0;
    transition: opacity 0.45s 0.45s;
  }
  .pq-bloc.pq-vu .pq-chute { opacity: 1; }

  @keyframes pq-trace { to { stroke-dashoffset: 0; } }
  @keyframes pq-tombe { from { opacity: 0; transform: translateY(-40px); } to { opacity: 1; transform: none; } }
  @keyframes pq-monte { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pq-pt, .pq-mil-t, .pq-motif { animation: none; }
    .pq-derive { animation: none; stroke-dashoffset: 0; }
    svg, .pq-scene, .pq-humain, .pq-bloc, .pq-cit, .pq-chute { transition: none; }
  }
</style>
