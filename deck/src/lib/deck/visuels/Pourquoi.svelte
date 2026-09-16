<script>
  /**
   * Pourquoi se donner la peine de faire de la science ? Pas pour avoir
   * raison : pour s'empêcher de croire ce qu'on a envie de croire.
   * Trois temps.
   *
   *   0  Le biais de confirmation, en schéma. On part d'une croyance —
   *      « les jeunes ne votent pas » — et d'un champ de vingt-quatre cas.
   *      À l'arrivée, seuls les huit cas qui confirment la croyance sont
   *      encrés, chacun marqué d'un « +1 » pendant qu'un compteur grimpe;
   *      les seize autres sont tracés si pâles qu'ils passent pour absents.
   *      Puis, sans clic, ils remontent à l'encre pleine : ce qui était là
   *      aussi, et qu'on n'avait pas compté.
   *   1  On nomme la chose : ce n'est pas de la malhonnêteté, c'est humain.
   *   2  La phrase de Feynman, qui est le point de la diapositive, puis la
   *      ligne rouge : la méthode nous protège de nous-mêmes.
   *
   * Aucune donnée réelle : les vingt-quatre jetons sont des positions fixes
   * et ne disent rien du vote des jeunes. La scène est légendée « schéma ».
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

  // Géométrie (viewBox 1000 × 350). Deux rangées de douze, bien plus larges
  // que hautes : la diapositive n'a pas un pixel de hauteur à donner.
  const COLONNES = 12;
  const X0 = 104, DX = 72;
  const RANGS = [82, 178];

  // Les cas qui confirment la croyance. Choix fixe, réparti sur les deux
  // rangées; huit sur vingt-quatre, donc nettement minoritaires.
  const CONFIRME = new Set([0, 3, 4, 9, 12, 17, 18, 22]);

  const GENS = [];
  let rang = 0;
  for (let i = 0; i < COLONNES * RANGS.length; i++) {
    const vu = CONFIRME.has(i);
    GENS.push({
      x: X0 + (i % COLONNES) * DX,
      y: RANGS[Math.floor(i / COLONNES)],
      vu,
      // j : rang d'apparition parmi les cas remarqués (−1 pour les autres).
      j: vu ? rang++ : -1
    });
  }
  const REMARQUES = GENS.filter((g) => g.vu);
  const NB_VUS = REMARQUES.length;
  const NB_TOTAL = GENS.length;
  // Les valeurs successives du compteur : 1, 2, … 8.
  const COMPTE = Array.from({ length: NB_VUS }, (_, k) => k + 1);
</script>

<div class="visuel pq-fig" bind:this={hote}>
  <div class="pq-scene" class:pq-recule={e >= 2}>
    <svg
      viewBox="0 0 1000 350"
      role="img"
      aria-label="Schéma&#8239;: vingt-quatre cas, et la croyance «&#8239;les jeunes ne votent pas&#8239;». D’abord, seuls les huit cas qui donnent raison à la croyance sont tracés à l’encre, chacun marqué d’un plus un pendant qu’un compteur grimpe jusqu’à huit&#8239;; les seize autres sont presque de la couleur du papier. Puis les vingt-quatre cas apparaissent à l’encre pleine&#8239;: ce qui était là aussi, et que le compte de huit avait laissé de côté."
    >
      <!-- La croyance de départ, celle qu'on va « vérifier ». -->
      <text x="500" y="32" class="pq-croyance">«&#8239;Les jeunes ne votent pas.&#8239;»</text>

      <!-- Le champ : vingt-quatre cas, tous là depuis le début. -->
      {#each GENS as g}
        <g class="pq-jeton" class:pq-net={g.vu} class:pq-flou={!g.vu} style="--j: {g.j}">
          <circle cx={g.x} cy={g.y + 9} r="9" />
          <line x1={g.x} y1={g.y + 19} x2={g.x} y2={g.y + 40} />
          <line x1={g.x - 13} y1={g.y + 28} x2={g.x + 13} y2={g.y + 28} />
          <line x1={g.x} y1={g.y + 40} x2={g.x - 10} y2={g.y + 56} />
          <line x1={g.x} y1={g.y + 40} x2={g.x + 10} y2={g.y + 56} />
        </g>
      {/each}

      <!-- Un « +1 » rouge sur chaque cas qu'on remarque, et sur eux seuls. -->
      {#each REMARQUES as g}
        <text x={g.x} y={g.y - 8} class="pq-plus" style="--j: {g.j}">+1</text>
      {/each}

      <line x1="90" y1="258" x2="910" y2="258" class="pq-regle" />

      <!-- Le compteur : un chiffre par temps, le dernier reste. -->
      {#each COMPTE as v, k}
        <text x="90" y="302" class="pq-n" class:pq-n-fin={k === NB_VUS - 1} style="--j: {k}">{v}</text>
      {/each}
      <text x="150" y="302" class="pq-etiq pq-etiq-a">ce qu’on remarque</text>

      <!-- Ce qui était là aussi, révélé sans clic, une fois le compte fait. -->
      <g class="pq-rev">
        <text x="470" y="302" class="pq-gros">{NB_TOTAL}</text>
        <text x="546" y="302" class="pq-etiq">ce qui était là aussi</text>
      </g>

      <!-- Le motif, nommé une fois la scène retournée. -->
      <text x="500" y="334" class="pq-motif">On ne compte que les cas qui nous donnent raison.</text>
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

  .pq-croyance { font-size: 24px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  /* Le trait seul : la couleur est posée par .pq-net ou .pq-flou, et rien
     dans le groupe ne redéclare stroke, sinon l'encrage ne descendrait pas
     jusqu'aux membres. */
  .pq-jeton { fill: none; stroke-width: 3; }
  .pq-net {
    stroke: var(--dk-encre);
    animation: pq-pose 0.4s ease-out both;
    animation-delay: calc(var(--j) * 160ms + 250ms);
  }
  /* Presque la couleur du papier : ils sont là, on ne les voit pas. */
  .pq-flou { stroke: var(--dk-filet); animation: pq-encrer 0.9s ease-out 2.3s forwards; }

  .pq-plus {
    font-size: 18px;
    font-weight: 700;
    text-anchor: middle;
    fill: var(--dk-accent);
    animation: pq-monte 0.35s ease-out both;
    animation-delay: calc(var(--j) * 160ms + 320ms);
  }

  .pq-regle { stroke: var(--dk-filet); stroke-width: 2; }

  /* Un chiffre à la fois : chaque texte n'est visible que pendant sa fenêtre
     de 160 ms, exactement le pas du compteur. Pas de fill-mode ici — avec
     « backwards » les huit chiffres seraient empilés dès l'arrivée. */
  .pq-n {
    font-size: 44px;
    font-weight: 700;
    fill: var(--dk-accent);
    opacity: 0;
    animation: pq-cpt 160ms linear calc(var(--j) * 160ms + 300ms);
  }
  .pq-n-fin { animation-fill-mode: forwards; }

  .pq-gros { font-size: 44px; font-weight: 700; fill: var(--dk-encre); }
  .pq-etiq { font-size: 18px; fill: var(--dk-gris); }
  .pq-etiq-a { opacity: 0; animation: pq-monte 0.4s ease-out 0.25s forwards; }

  .pq-rev { opacity: 0; animation: pq-monte 0.5s ease-out 2.6s forwards; }

  .pq-motif {
    font-size: 22px;
    font-weight: 600;
    text-anchor: middle;
    fill: var(--dk-accent);
    opacity: 0;
    animation: pq-monte 0.5s ease-out 3.1s forwards;
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

  @keyframes pq-pose { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: none; } }
  @keyframes pq-encrer { to { stroke: var(--dk-encre); } }
  @keyframes pq-cpt { from, to { opacity: 1; } }
  @keyframes pq-monte { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pq-net, .pq-plus, .pq-etiq-a, .pq-rev, .pq-motif, .pq-flou, .pq-n { animation: none; }
    .pq-net, .pq-plus, .pq-etiq-a, .pq-rev, .pq-motif { opacity: 1; }
    .pq-flou { stroke: var(--dk-encre); }
    .pq-n { opacity: 0; }
    .pq-n-fin { opacity: 1; }
    svg, .pq-scene, .pq-humain, .pq-bloc, .pq-cit, .pq-chute { transition: none; }
  }
</style>
