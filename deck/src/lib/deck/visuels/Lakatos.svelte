<script>
  /**
   * Quand faut-il abandonner une théorie ? On ne juge pas une version, on
   * juge une série de versions, dans le temps. Deux couloirs, quatre temps.
   *
   *   0  Les deux couloirs arrivent avec leur seule version 1, sans verdict:
   *      rien ne les distingue encore.
   *   1  Le couloir du haut, PROGRESSIF (rouge): à chaque version, une
   *      flèche part VERS L'AVANT, vers un fait nouveau que personne n'avait
   *      regardé — et le cercle se remplit, le fait se vérifie.
   *   2  Le couloir du bas, DÉGÉNÉRATIF (gris): à chaque version, un trou
   *      apparaît DERRIÈRE, et la nouvelle version se contente d'y poser une
   *      rustine. Jamais une seule flèche vers l'avant.
   *   3  Le critère, dans les mots de Lakatos. Source donnée à l'écran:
   *      Imre Lakatos, « Falsification and the Methodology of Scientific
   *      Research Programmes », dans Lakatos et Musgrave (dir.), Criticism
   *      and the Growth of Knowledge, Cambridge University Press, 1970,
   *      p. 118, traduction libre. Puis l'objection honnête: le verdict ne
   *      vient qu'après coup.
   *
   * Tout le poids est sur le contraste: flèches vers l'avant et cochées en
   * haut, rustines vers l'arrière en bas. Les deux couloirs sont dessinés en
   * miroir exact, à des coordonnées fixes. Aucune donnée, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const LARG = 150;
  const R = 24;
  const Y_HAUT = 74, Y_BAS = 240, H = 54;
  const CY_HAUT = Y_HAUT + H / 2;
  const CY_BAS = Y_BAS + H / 2;

  // En miroir: en haut la cible est APRÈS la version, en bas le trou est AVANT.
  const HAUT = [{ x: 20, c: 250 }, { x: 330, c: 560 }, { x: 640, c: 870 }];
  const BAS = [{ x: 124, c: 44 }, { x: 434, c: 354 }, { x: 744, c: 664 }];
</script>

<div class="visuel lk-fig" bind:this={hote}>
  <svg
    class="lk-scene"
    class:lk-recule={e >= 3}
    viewBox="0 0 1000 360"
    role="img"
    aria-label="Deux couloirs dans le temps. En haut, un programme progressif: chaque version lance une flèche vers l’avant, vers un fait nouveau, et le fait se vérifie. En bas, un programme dégénératif: chaque version pose une rustine sur un trou apparu derrière elle, sans jamais rien annoncer."
  >
    <!-- Le temps, de gauche à droite. -->
    <path d="M 20 20 L 890 20 M 876 12 L 890 20 L 876 28" pathLength="1" class="lk-temps" />
    <text x="902" y="26" class="lk-temps-t">le temps</text>

    <!-- ——— Couloir du haut: progressif ——— -->
    {#if e >= 1}
      <text x="20" y="54" class="lk-tete lk-prog">PROGRESSIF</text>
      {#each HAUT as p, i}
        <g style="--d: {i * 480}ms">
          <path
            d="M {p.x + LARG + 6} {CY_HAUT} L {p.c - R - 6} {CY_HAUT} M {p.c - R - 20} {CY_HAUT - 10} L {p.c - R - 6} {CY_HAUT} L {p.c - R - 20} {CY_HAUT + 10}"
            pathLength="1"
            class="lk-avant"
          />
          <circle cx={p.c} cy={CY_HAUT} r={R} class="lk-attente" />
          <circle cx={p.c} cy={CY_HAUT} r={R} class="lk-plein" />
          <path d="M {p.c - 11} {CY_HAUT} L {p.c - 3} {CY_HAUT + 9} L {p.c + 12} {CY_HAUT - 10}" pathLength="1" class="lk-coche" />
          <text x={p.c} y={CY_HAUT + R + 26} class="lk-etiquette lk-prog">fait nouveau</text>
        </g>
      {/each}
      <text x="20" y="182" class="lk-phrase lk-prog">à chaque version, elle annonce un fait nouveau, et on le trouve</text>
    {/if}

    {#each HAUT as p, i}
      {#if i === 0 || e >= 1}
        <g class="lk-v" class:lk-v-prog={e >= 1} style="--d: {i * 480}ms">
          <rect x={p.x} y={Y_HAUT} width={LARG} height={H} />
          <text x={p.x + LARG / 2} y={CY_HAUT + 7}>version {i + 1}</text>
        </g>
      {/if}
    {/each}

    <!-- ——— Couloir du bas: dégénératif ——— -->
    {#if e >= 2}
      <text x="20" y="222" class="lk-tete lk-degen">DÉGÉNÉRATIF</text>
      {#each BAS as p, i}
        <g style="--d: {i * 480}ms">
          <circle cx={p.c} cy={CY_BAS} r={R} class="lk-trou" />
          <path
            d="M {p.x - 6} {CY_BAS} L {p.c + R + 6} {CY_BAS} M {p.c + R + 20} {CY_BAS - 10} L {p.c + R + 6} {CY_BAS} L {p.c + R + 20} {CY_BAS + 10}"
            pathLength="1"
            class="lk-arriere"
          />
          <rect x={p.c - 21} y={CY_BAS - 21} width="42" height="42" class="lk-rustine" style="--dx: {p.x - p.c}px" />
          <text x={p.c} y={CY_BAS + R + 26} class="lk-etiquette lk-degen">rustine</text>
        </g>
      {/each}
      <text x="20" y="348" class="lk-phrase lk-degen">à chaque version, elle rattrape ce qui vient de rater</text>
    {/if}

    {#each BAS as p, i}
      {#if i === 0 || e >= 2}
        <g class="lk-v" class:lk-v-degen={e >= 2} style="--d: {i * 480}ms">
          <rect x={p.x} y={Y_BAS} width={LARG} height={H} />
          <text x={p.x + LARG / 2} y={CY_BAS + 7}>version {i + 1}</text>
        </g>
      {/if}
    {/each}
  </svg>

  {#if e >= 3}
    <div class="lk-mot">
      <blockquote class="lk-cite">
        <p>«&#8239;Une série de théories est progressive si chaque nouvelle version prédit un fait nouveau, inattendu jusque-là&#8239;; et si une partie de ces faits nouveaux se vérifie. Sinon, elle est dégénérative.&#8239;»</p>
        <cite>Imre Lakatos, «&#8239;Falsification and the Methodology of Scientific Research Programmes&#8239;», dans Lakatos et Musgrave (dir.), <i>Criticism and the Growth of Knowledge</i>, Cambridge University Press, 1970, p. 118 (traduction libre)</cite>
      </blockquote>
      <p class="lk-objection">L’objection&#8239;: le verdict ne vient qu’après coup.</p>
    </div>
  {/if}
</div>

<style>
  .lk-fig { display: flex; flex-direction: column; gap: 0.7em; }
  .lk-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; transition: max-height 0.5s ease; }
  /* Les couloirs reculent quand le critère prend la parole: le texte tient dessous. */
  .lk-scene.lk-recule { max-height: 31vh; }
  text { font-family: var(--dk-mono); }

  .lk-temps { fill: none; stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 1; stroke-dashoffset: 1; animation: lk-trace 0.9s ease-out 0.2s forwards; }
  .lk-temps-t { font-size: 15px; fill: var(--dk-gris-2); letter-spacing: 0.08em; animation: lk-fondu 0.5s 0.9s both; }

  /* Les versions, communes aux deux couloirs. */
  .lk-v rect { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .lk-v text { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: fill 0.4s; }
  .lk-v { animation: lk-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; animation-delay: var(--d); }
  .lk-v-prog rect { stroke: var(--dk-accent); }
  .lk-v-prog text { fill: var(--dk-accent); }
  .lk-v-degen rect { stroke: var(--dk-gris-2); }
  .lk-v-degen text { fill: var(--dk-gris); }

  .lk-tete { font-size: 18px; font-weight: 600; letter-spacing: 0.22em; animation: lk-monte 0.45s ease-out both; }
  .lk-phrase { font-size: 18px; animation: lk-monte 0.45s ease-out 1.5s both; }
  .lk-etiquette { font-size: 15px; font-weight: 600; text-anchor: middle; }
  text.lk-prog { fill: var(--dk-accent); }
  text.lk-degen { fill: var(--dk-gris); }

  /* Haut: vers l'avant, et le fait se vérifie. */
  .lk-avant { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; animation: lk-trace 0.45s ease-out forwards; animation-delay: var(--d); }
  .lk-attente { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 6 6; animation: lk-attendre 1s both; animation-delay: calc(var(--d) + 200ms); }
  .lk-plein { fill: var(--dk-accent); stroke: var(--dk-accent); stroke-width: 3; animation: lk-pop 0.45s cubic-bezier(0.34, 1.7, 0.64, 1) both; animation-delay: calc(var(--d) + 900ms); transform-box: fill-box; transform-origin: center; }
  .lk-coche { fill: none; stroke: var(--dk-fond); stroke-width: 5; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; animation: lk-trace 0.35s ease-out forwards; animation-delay: calc(var(--d) + 1150ms); }
  .lk-etiquette.lk-prog { animation: lk-fondu 0.4s both; animation-delay: calc(var(--d) + 1000ms); }

  /* Bas: le trou est derrière, et la rustine vient s'y poser. */
  .lk-trou { fill: var(--dk-fond-2); stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 6 6; animation: lk-pop 0.4s ease-out both; animation-delay: calc(var(--d) + 150ms); transform-box: fill-box; transform-origin: center; }
  .lk-arriere { fill: none; stroke: var(--dk-gris); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; animation: lk-trace 0.45s ease-out forwards; animation-delay: calc(var(--d) + 350ms); }
  .lk-rustine { fill: var(--dk-gris-2); stroke: var(--dk-gris); stroke-width: 3; animation: lk-poser 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) both; animation-delay: calc(var(--d) + 650ms); }
  .lk-etiquette.lk-degen { animation: lk-fondu 0.4s both; animation-delay: calc(var(--d) + 1000ms); }

  .lk-mot { display: flex; flex-direction: column; gap: 0.45em; }
  .lk-cite { margin: 0; border-left: 6px solid var(--dk-accent); padding: 0.1em 0 0.1em 0.9em; animation: lk-monte 0.45s ease-out both; }
  .lk-cite p { margin: 0; font-size: 0.95em; line-height: 1.4; }
  .lk-cite cite { display: block; margin-top: 0.5em; font-style: normal; font-size: 0.58em; line-height: 1.5; letter-spacing: 0.06em; color: var(--dk-gris); animation: lk-fondu 0.4s 0.45s both; }
  .lk-cite i { font-style: italic; }
  .lk-objection { margin: 0; font-size: 0.82em; color: var(--dk-gris); animation: lk-monte 0.45s ease-out 0.7s both; }

  @keyframes lk-trace { to { stroke-dashoffset: 0; } }
  @keyframes lk-fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes lk-monte { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @keyframes lk-pop { from { opacity: 0; transform: scale(0.3); } to { opacity: 1; transform: none; } }
  @keyframes lk-attendre { 0% { opacity: 0; } 18% { opacity: 1; } 72% { opacity: 1; } 100% { opacity: 0; } }
  @keyframes lk-poser { from { opacity: 0; transform: translateX(var(--dx)); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .lk-scene { transition: none; }
    .lk-temps-t, .lk-v, .lk-tete, .lk-phrase, .lk-plein, .lk-trou, .lk-rustine, .lk-cite, .lk-cite cite, .lk-objection { animation: none; }
    .lk-etiquette.lk-prog, .lk-etiquette.lk-degen { animation: none; }
    .lk-attente { animation: none; opacity: 0; }
    .lk-temps, .lk-avant, .lk-coche, .lk-arriere { animation: none; stroke-dashoffset: 0; }
    .lk-v rect, .lk-v text { transition: none; }
  }
</style>
