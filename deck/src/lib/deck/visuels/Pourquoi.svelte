<script>
  /**
   * Pourquoi se donner la peine de faire de la science ? Parce que « tout le
   * monde autour de moi » n'est pas une preuve. La salle est pleine
   * d'étudiant.e.s en science politique : leurs ami.e.s votent, donc de là
   * où ils sont assis, « les jeunes ne votent pas » a l'air faux. Le piège :
   * n'avoir demandé qu'aux gens autour de soi. Trois temps.
   *
   *   0  La phrase de l'étudiant.e, en bulle. Dessous, un champ de
   *      quatre-vingt-huit jeunes, dont seul un coin est encré : la poche
   *      autour de « moi », des étudiant.e.s en science politique, où
   *      presque tout le monde vote. Le reste du champ est si pâle qu'il
   *      passe pour absent.
   *   1  Le reste du champ monte à l'encre : « tous les jeunes ». Hors de
   *      la poche, le mélange est visiblement autre. La poche devient ce
   *      qu'elle est, un coin, et la ligne rouge le dit.
   *   2  La question, rendue à la salle : « Alors, comment le prouver ? »,
   *      et une seule piste, qui ouvre sur les quatre traits de la
   *      recherche scientifique (diapositive suivante).
   *
   * Aucune donnée réelle : les positions et les remplissages sont fixes,
   * choisis à la main, et ne disent rien du taux de vote des jeunes. Aucun
   * chiffre n'est affiché. La scène est légendée « schéma ».
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Géométrie (viewBox 1000 × 270). Quatre rangées de vingt-deux, bien plus
  // larges que hautes : la diapositive n'a pas un pixel de hauteur à donner.
  const X0 = 90, DX = 41;
  const Y0 = 48, DY = 48;

  // Le champ, fixé à la main. V = vote, n = ne vote pas.
  const CHAMP = [
    'nVnnVnnnVnnVnnnVnnVnnn',
    'nnVnnnVnnVnnnVnnnnVnVn',
    'VVVVVnnVnnnVnnVnnnVnnV',
    'VVVVVnVnnVnnnnVnnVnnnn'
  ];
  // La poche : le coin en bas à gauche, cinq colonnes sur deux rangées.
  const POCHE = { c0: 0, c1: 4, r0: 2, r1: 3 };
  const MOI = { c: 0, r: 2 };

  const GENS = [];
  CHAMP.forEach((ligne, r) => {
    [...ligne].forEach((k, c) => {
      const dedans = c >= POCHE.c0 && c <= POCHE.c1 && r >= POCHE.r0 && r <= POCHE.r1;
      GENS.push({
        x: X0 + c * DX,
        y: Y0 + r * DY,
        vote: k === 'V',
        dedans,
        moi: c === MOI.c && r === MOI.r,
        // d : distance à la poche, pour que l'encre gagne le champ de proche en proche.
        d: dedans ? 0 : Math.max(0, c - POCHE.c1) + Math.max(0, POCHE.r0 - r)
      });
    });
  });

  // Le cadre de la poche, autour de ses dix personnages.
  const CADRE = {
    x: X0 + POCHE.c0 * DX - 22,
    y: Y0 + POCHE.r0 * DY - 8,
    w: (POCHE.c1 - POCHE.c0) * DX + 44,
    h: (POCHE.r1 - POCHE.r0) * DY + 34 + 16
  };

  // Un personnage : une tête (cercle) et un buste (trapèze), 34 unités de haut.
  const buste = (x, y) => `M${x - 11} ${y + 34}L${x - 7} ${y + 17}L${x + 7} ${y + 17}L${x + 11} ${y + 34}Z`;
</script>

<div class="visuel pq-fig" bind:this={hote}>
  <p class="pq-bulle">«&#8239;On dit que les jeunes ne votent pas. Mais j’ai parlé à tout le monde autour de moi, et tout le monde vote.&#8239;»</p>

  <div class="pq-scene">
    <svg
      viewBox="0 0 1000 270"
      preserveAspectRatio="xMinYMid meet"
      class:pq-ouvert={e >= 1}
      role="img"
      aria-label="Schéma&#8239;: un champ de jeunes, dessinés en petits personnages, pleins pour ceux qui votent, vides pour ceux qui ne votent pas. D’abord, seul un coin du champ est tracé à l’encre&#8239;: la poche autour de «&#8239;moi&#8239;», des étudiant.e.s en science politique, où presque tout le monde vote. Puis le reste du champ apparaît, «&#8239;tous les jeunes&#8239;»&#8239;: hors de la poche, beaucoup plus de personnages ne votent pas. La poche n’est qu’un coin du champ."
    >
      <!-- La clé : deux remplissages, rien d'autre. -->
      <g class="pq-gens">
        <circle cx="79" cy="9" r="5" class="pq-oui" />
        <path d="M71 28L74 16L84 16L87 28Z" class="pq-oui" />
        <circle cx="189" cy="9" r="5" class="pq-non" />
        <path d="M181 28L184 16L194 16L197 28Z" class="pq-non" />
      </g>
      <text x="98" y="26" class="pq-cle">vote</text>
      <text x="208" y="26" class="pq-cle">ne vote pas</text>

      <!-- Le tout, nommé seulement quand il apparaît. -->
      <g class="pq-tous">
        <text x="969" y="24" class="pq-nom pq-nom-fin">tous les jeunes</text>
        <path d="M72 44V36H969V44" class="pq-accolade" />
      </g>

      <!-- Le champ : tout le monde est là depuis le début. -->
      <g class="pq-gens">
        {#each GENS as g}
          <g
            class:pq-oui={g.vote}
            class:pq-non={!g.vote}
            class:pq-dehors={!g.dedans}
            class:pq-moi={g.moi}
            style="--d: {g.d}"
          >
            <circle cx={g.x} cy={g.y + 7} r="7" />
            <path d={buste(g.x, g.y)} />
          </g>
        {/each}
      </g>

      <!-- La poche : celles et ceux à qui on a parlé. -->
      <rect x={CADRE.x} y={CADRE.y} width={CADRE.w} height={CADRE.h} class="pq-cadre" />
      <text x="60" y={Y0 + MOI.r * DY + 26} class="pq-etiq-moi">moi</text>
      <text x={CADRE.x} y="262" class="pq-nom">autour de moi&#8239;: des étudiant.e.s en science politique</text>
    </svg>
    <p class="pq-legende">schéma, pas des données</p>
  </div>

  <!-- Hauteur réservée : les lignes arrivent par {#if}, rien ne bouge autour. -->
  <div class="pq-bas">
    {#if e >= 1}
      <p class="pq-poche">Ma poche n’est pas la population.</p>
    {/if}
    {#if e >= 2}
      <p class="pq-question">Alors, comment le prouver&#8239;?</p>
      <p class="pq-piste">il faudrait demander à des jeunes qu’on n’a pas choisis</p>
    {/if}
  </div>
</div>

<style>
  .pq-fig { display: flex; flex-direction: column; gap: 0.4em; }

  /* La bulle : un cadre à angles droits et une pointe carrée, vers le champ. */
  .pq-bulle {
    position: relative;
    align-self: flex-start;
    margin: 0 0 0.35em;
    padding: 0.4em 0.75em;
    border: 2px solid var(--dk-encre);
    background: var(--dk-fond);
    font-family: var(--dk-mono);
    font-size: 1.05em;
    line-height: 1.4;
    font-weight: 500;
    color: var(--dk-encre);
  }
  .pq-bulle::after {
    content: '';
    position: absolute;
    left: 2.2em;
    bottom: -0.42em;
    width: 0.7em;
    height: 0.7em;
    box-sizing: border-box;
    background: var(--dk-fond);
    border-right: 2px solid var(--dk-encre);
    border-bottom: 2px solid var(--dk-encre);
    transform: rotate(45deg);
  }

  .pq-scene { display: flex; flex-direction: column; gap: 0.1em; }
  svg { width: 100%; height: auto; max-height: 36vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  /* Deux remplissages : plein = vote, vide = ne vote pas. */
  .pq-gens { stroke: var(--dk-encre); stroke-width: 3; }
  .pq-oui { fill: var(--dk-encre); }
  .pq-non { fill: var(--dk-fond); }
  .pq-moi { fill: var(--dk-accent); stroke: var(--dk-accent); }

  /* Hors de la poche : presque la couleur du papier, puis l'encre gagne le
     champ de proche en proche à partir de la poche. */
  .pq-dehors { opacity: 0.07; transition: opacity 0.5s ease-out; transition-delay: calc(var(--d) * 28ms); }
  .pq-ouvert .pq-dehors { opacity: 1; }

  .pq-cle { font-size: 20px; fill: var(--dk-gris); }
  .pq-nom { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .pq-nom-fin { text-anchor: end; }
  .pq-etiq-moi { font-size: 22px; font-weight: 700; text-anchor: end; fill: var(--dk-accent); }

  .pq-tous { opacity: 0; transition: opacity 0.5s 0.3s; }
  .pq-ouvert .pq-tous { opacity: 1; }
  .pq-accolade { fill: none; stroke: var(--dk-encre); stroke-width: 3; }

  /* Le cadre : à l'encre tant qu'il est tout ce qu'on voit, rouge quand on
     voit qu'il n'est qu'un coin. */
  .pq-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.5s; }
  .pq-ouvert .pq-cadre { stroke: var(--dk-accent); }

  .pq-legende { margin: 0; font-size: 0.6em; line-height: 1.3; letter-spacing: 0.06em; color: var(--dk-gris-2); }

  .pq-bas { height: 5em; display: flex; flex-direction: column; gap: 0.15em; }
  .pq-poche {
    margin: 0;
    font-size: 1.1em;
    line-height: 1.3;
    font-weight: 600;
    color: var(--dk-accent);
    animation: pq-monte 0.45s ease-out both;
  }
  .pq-question {
    margin: 0;
    font-size: 1.7em;
    line-height: 1.15;
    font-weight: 600;
    color: var(--dk-encre);
    animation: pq-monte 0.45s ease-out both;
  }
  .pq-piste {
    margin: 0;
    font-size: 0.8em;
    line-height: 1.4;
    color: var(--dk-gris);
    animation: pq-monte 0.45s ease-out 0.35s both;
  }

  @keyframes pq-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pq-poche, .pq-question, .pq-piste { animation: none; }
    .pq-dehors, .pq-tous, .pq-cadre { transition: none; }
  }
</style>
