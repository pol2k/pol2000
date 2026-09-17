<script>
  /**
   * Une prévision conditionnelle, dessinée comme un circuit : un
   * interrupteur, un fil, une lampe. C’est la seule idée de la diapositive,
   * et elle est méthodologique, jamais personnelle : une prévision de la
   * forme « si X, alors Y » n’apprend rien quand X ne se produit pas.
   *
   *   0  La prévision, en deux boîtes : SI (l’interrupteur, ouvert) et
   *      ALORS (la lampe, éteinte). Source à l’écran : John Mearsheimer,
   *      International Security, 1990.
   *   1  L’interrupteur ne s’est jamais fermé : le levier tressaute, puis
   *      retombe. La coupure du fil est marquée en rouge et reste béante.
   *   2  À côté de la lampe éteinte, deux petites lampes également
   *      éteintes : « réfutée » et « confirmée ». Ni l’une ni l’autre ne
   *      s’allume.
   *   3  Le verdict, et la leçon transférable.
   *
   * Aucun jugement sur le chercheur : la diapositive se sert d’une de ses
   * prévisions comme d’un exemple logique propre, et rappelle qu’il a
   * lui-même constaté que la prémisse ne s’était pas réalisée. Rien d’autre
   * n’est ajouté. Tracés fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel mh-fig" bind:this={hote}>
  <svg
    class="mh-scene"
    class:mh-recule={e >= 3}
    viewBox="0 0 1200 360"
    role="img"
    aria-label="Un circuit schématique&#8239;: à gauche un interrupteur ouvert, son levier relevé, laissant le fil coupé&#8239;; à droite, au bout du fil, une lampe éteinte. À côté d’elle, deux petites lampes éteintes elles aussi, étiquetées «&#8239;réfutée&#8239;» et «&#8239;confirmée&#8239;». Sous l’interrupteur et sous la lampe, deux boîtes reliées par une flèche, marquées SI et ALORS."
  >
    <!-- ——— Le circuit : interrupteur, fil, lampe ——— -->
    <line x1="40" y1="90" x2="200" y2="90" class="mh-fil" />
    <line x1="380" y1="90" x2="744" y2="90" class="mh-fil" />

    <!-- Le levier, dessiné à plat puis relevé : l’interrupteur est ouvert. -->
    <line
      x1="200"
      y1="90"
      x2="370"
      y2="90"
      class="mh-levier"
      class:mh-tremble={e === 1}
    />
    <circle cx="200" cy="90" r="9" class="mh-borne" class:mh-vif={e >= 1} />
    <circle cx="380" cy="90" r="9" class="mh-borne" class:mh-vif={e >= 1} />

    <!-- La coupure : elle reste vide, on ne fait que la mesurer. -->
    <g class="mh-coupure" class:mh-vu={e >= 1}>
      <path d="M 200 108 L 200 122 L 380 122 L 380 108" class="mh-crochet" />
      <text x="290" y="154" class="mh-rouge">ne s’est pas produit</text>
    </g>

    <!-- La lampe, éteinte. -->
    <circle cx="800" cy="90" r="56" class="mh-lampe" />
    <path d="M 760 50 L 840 130 M 840 50 L 760 130" class="mh-filament" />

    <!-- Les deux verdicts, éteints eux aussi. -->
    <g class="mh-duo" class:mh-vu={e >= 2}>
      <circle cx="960" cy="90" r="38" class="mh-lampe mh-petite" />
      <path d="M 933 63 L 987 117 M 987 63 L 933 117" class="mh-filament mh-fin" />
      <text x="960" y="162" class="mh-etiq">réfutée</text>

      <circle cx="1110" cy="90" r="38" class="mh-lampe mh-petite" />
      <path d="M 1083 63 L 1137 117 M 1137 63 L 1083 117" class="mh-filament mh-fin" />
      <text x="1110" y="162" class="mh-etiq">confirmée</text>
    </g>

    <!-- ——— La prévision, en deux boîtes ——— -->
    <rect x="30" y="196" width="540" height="144" class="mh-boite" />
    <text x="300" y="256" class="mh-mot">les États-Unis quittent</text>
    <text x="300" y="300" class="mh-mot">l’Europe</text>
    <rect x="54" y="176" width="78" height="36" class="mh-puce" />
    <text x="93" y="201" class="mh-puce-t">SI</text>

    <path d="M 578 268 L 622 268 M 610 258 L 622 268 L 610 278" class="mh-fleche" />

    <rect x="630" y="196" width="540" height="144" class="mh-boite" />
    <text x="900" y="256" class="mh-mot">l’Europe redevient</text>
    <text x="900" y="300" class="mh-mot">beaucoup plus violente</text>
    <rect x="654" y="176" width="126" height="36" class="mh-puce" />
    <text x="717" y="201" class="mh-puce-t">ALORS</text>
  </svg>

  <p class="mh-src">John Mearsheimer, <i>International Security</i>, 1990</p>

  {#if e === 1}
    <p class="mh-note">les États-Unis sont restés</p>
  {:else if e === 2}
    <p class="mh-ligne">on n’a jamais pu savoir</p>
  {:else if e >= 3}
    <div class="mh-fin-mot">
      <p class="mh-verdict">Ni réfutée, ni confirmée.</p>
      <p class="mh-lecon">
        Une prévision dont le «&#8239;si&#8239;» ne s’est jamais produit n’apprend rien,
        dans un sens comme dans l’autre.
      </p>
      <p class="mh-note">Il l’a reconnu lui-même en 2010.</p>
    </div>
  {/if}
</div>

<style>
  .mh-fig { display: flex; flex-direction: column; gap: 0.7em; }

  /* Le circuit est large et plat (viewBox 1200 × 360) : il gagne en largeur
     ce qu’il ne prend pas en hauteur, et recule quand le verdict parle. */
  .mh-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; transition: max-height 0.5s ease; }
  .mh-scene.mh-recule { max-height: 30vh; }
  .mh-scene text { font-family: var(--dk-mono); }

  .mh-fil { stroke: var(--dk-encre); stroke-width: 8; }
  .mh-levier {
    stroke: var(--dk-encre);
    stroke-width: 8;
    transform-box: view-box;
    transform-origin: 200px 90px;
    transform: rotate(-24deg);
  }
  .mh-levier.mh-tremble { animation: mh-tremble 1.2s ease-in-out 0.25s 1; }
  .mh-borne { fill: var(--dk-encre); transition: fill 0.4s; }
  .mh-borne.mh-vif { fill: var(--dk-accent); }

  .mh-coupure { opacity: 0; transition: opacity 0.4s; }
  .mh-coupure.mh-vu { opacity: 1; transition-delay: 1.45s; }
  .mh-crochet { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .mh-rouge { font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .mh-lampe { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 5; }
  .mh-lampe.mh-petite { stroke-width: 4; }
  .mh-filament { fill: none; stroke: var(--dk-encre); stroke-width: 5; }
  .mh-filament.mh-fin { stroke-width: 4; }

  .mh-duo { opacity: 0; transition: opacity 0.45s; }
  .mh-duo.mh-vu { opacity: 1; }
  .mh-etiq { font-size: 26px; text-anchor: middle; fill: var(--dk-gris); }

  .mh-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .mh-mot { font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .mh-puce { fill: var(--dk-accent); }
  .mh-puce-t { font-size: 24px; font-weight: 600; letter-spacing: 0.1em; text-anchor: middle; fill: var(--dk-fond); }
  .mh-fleche { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }

  .mh-src { margin: 0; font-size: 0.6em; line-height: 1.4; letter-spacing: 0.05em; color: var(--dk-gris); }
  .mh-src i { font-style: italic; }

  .mh-note { margin: 0; font-size: 0.68em; line-height: 1.4; color: var(--dk-gris); animation: mh-monte 0.4s ease-out both; }
  .mh-ligne { margin: 0; font-size: 1.05em; line-height: 1.4; animation: mh-monte 0.4s ease-out both; }

  .mh-fin-mot { display: flex; flex-direction: column; gap: 0.45em; }
  .mh-verdict { margin: 0; font-size: 1.6em; font-weight: 600; line-height: 1.3; color: var(--dk-accent); animation: mh-monte 0.45s ease-out both; }
  /* 0.95em et non 1em : la ligne fait 101 caractères, et en Plex Mono
     (0,6em d'avance) elle dépasse la mesure de la diapo d'un caractère à
     1em. Le dernier mot tomberait seul sur sa ligne, sur les deux tailles
     de projecteur. */
  .mh-lecon { margin: 0; font-size: 0.95em; line-height: 1.45; animation: mh-monte 0.45s ease-out 0.15s both; }
  .mh-fin-mot .mh-note { animation-delay: 0.3s; }

  @keyframes mh-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes mh-tremble {
    0% { transform: rotate(-24deg); }
    16% { transform: rotate(-9deg); }
    32% { transform: rotate(-24deg); }
    48% { transform: rotate(-14deg); }
    66% { transform: rotate(-24deg); }
    100% { transform: rotate(-24deg); }
  }

  @media (prefers-reduced-motion: reduce) {
    .mh-scene { transition: none; }
    .mh-levier.mh-tremble { animation: none; }
    .mh-borne { transition: none; }
    .mh-coupure { transition: none; }
    .mh-note, .mh-ligne, .mh-verdict, .mh-lecon { animation: none; }
    .mh-duo { transition: none; }
  }
</style>
