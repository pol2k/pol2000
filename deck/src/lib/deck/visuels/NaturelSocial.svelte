<script>
  /**
   * Les sciences sociales sont-elles différentes des sciences de la nature ?
   * La logique de l'inférence est la même; les conditions sont plus dures.
   * La différence la plus nette : ce que les sciences sociales étudient
   * entend ce qu'on dit de lui, et change. Quatre temps.
   *
   *   0  Deux colonnes. À gauche, la nature : une comète sur son arc
   *      orbital, et une particule, « un quark ». À droite, le social :
   *      une personne, debout sur une petite échelle.
   *   1  On nomme. À gauche, deux étiquettes tombent : « comète de Halley »
   *      sur la comète, « quark » sur la particule. Rien ne bouge : la
   *      comète continue exactement le même tour. Deux citations, en
   *      anglais, dans le texte original : Merton (1948, p. 194) sur
   *      l'orbite de Halley, Hacking (1999, p. 105) sur le quark qu'on
   *      appelle un quark.
   *   2  La boucle. À droite, l'étiquette « électeur indécis » tombe sur la
   *      personne, une flèche revient de l'étiquette vers elle, et la
   *      personne se déplace le long de l'échelle : l'effet de boucle.
   *      Citation de Hacking (1999, p. 32), en anglais, texte original.
   *   3  Le verdict, qui n'est pas défaitiste : même logique, conditions
   *      plus dures, et King, Keohane et Verba (1994, p. 9-10) en rouge,
   *      en anglais, texte original.
   *      Les colonnes reculent pour lui laisser la place.
   *
   * Tout est schématique : aucune donnée, aucune position tirée au hasard.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les graduations de la petite échelle sur laquelle la personne se tient.
  const CRANS = [100, 185, 270, 355, 440];
</script>

<div class="visuel ns-deux" bind:this={hote}>
  <div class="ns-cols" class:ns-recule={e >= 3}>
    <!-- La nature : on la nomme, elle ne s'en aperçoit pas. -->
    <section class="ns-col">
      <span class="ns-t">les sciences de la nature</span>

      <svg class="ns-scene" viewBox="0 0 480 215" role="img" aria-label="Une comète parcourt son arc orbital et une particule attend à côté. On leur pose une étiquette : l’orbite continue exactement pareil.">
        <!-- L'arc orbital, et la comète qui le parcourt sans fin. -->
        <path d="M 2 190 A 150 150 0 0 1 278 190" class="ns-orbite" />
        <g class="ns-comete">
          <path d="M 130 94 L 84 84" class="ns-queue" />
          <path d="M 129 100 L 70 100" class="ns-queue" />
          <path d="M 130 106 L 84 116" class="ns-queue" />
          <circle cx="140" cy="100" r="9" class="ns-noyau" />
        </g>

        <!-- La particule. -->
        <circle cx="385" cy="118" r="26" class="ns-halo" />
        <circle cx="385" cy="118" r="11" class="ns-part" />
        <text x="385" y="172" class="ns-leg">un quark</text>

        {#if e >= 1}
          <g class="ns-etq">
            <line x1="140" y1="44" x2="140" y2="84" class="ns-fil" />
            <rect x="35" y="6" width="210" height="36" class="ns-boite" />
            <text x="140" y="31" class="ns-mot">comète de Halley</text>
          </g>
          <g class="ns-etq ns-tard">
            <line x1="386" y1="56" x2="386" y2="88" class="ns-fil" />
            <rect x="328" y="18" width="116" height="36" class="ns-boite" />
            <text x="386" y="43" class="ns-mot">quark</text>
          </g>
        {/if}
      </svg>

      {#if e >= 1 && e < 3}
        <div class="ns-bloc">
          <p class="ns-cite" lang="en">“Predictions of the return of Halley’s comet do not influence its orbit.”</p>
          <p class="ns-src">Robert Merton, “The Self-Fulfilling Prophecy”, <i>The Antioch Review</i>, vol. 8, no 2, 1948, p. 194</p>
          <p class="ns-cite ns-pince" lang="en">“calling a quark a quark makes no difference to the quark”</p>
          <p class="ns-src">Ian Hacking, <i>The Social Construction of What?</i>, Harvard University Press, 1999, p. 105</p>
        </div>
      {/if}
    </section>

    <!-- Le social : on la nomme, elle lit l'étiquette, elle bouge. -->
    <section class="ns-col">
      <span class="ns-t">les sciences sociales</span>

      <svg class="ns-scene" viewBox="0 0 480 215" role="img" aria-label="Une personne debout sur une petite échelle. Une étiquette lui tombe dessus, une flèche revient de l’étiquette vers elle, et la personne se déplace : c’est l’effet de boucle.">
        <!-- La petite échelle. -->
        <line x1="100" y1="196" x2="440" y2="196" class="ns-regle" />
        {#each CRANS as c}
          <line x1={c} y1="196" x2={c} y2="204" class="ns-regle" />
        {/each}

        <g class="ns-pers" class:ns-bouge={e >= 2}>
          <circle cx="200" cy="74" r="21" class="ns-corps" />
          <path d="M 200 95 L 200 150" class="ns-corps" />
          {#if e >= 2}
            <path d="M 174 128 L 200 114 L 226 128" class="ns-corps" />
          {:else}
            <path d="M 170 114 L 230 114" class="ns-corps" />
          {/if}
          <path d="M 200 150 L 180 192" class="ns-corps" />
          <path d="M 200 150 L 220 192" class="ns-corps" />
        </g>

        {#if e >= 2}
          <g class="ns-etq">
            <rect x="246" y="4" width="222" height="36" class="ns-boite" />
            <text x="357" y="29" class="ns-mot">électeur indécis</text>
          </g>
          <g class="ns-boucle">
            <path d="M 248 24 C 120 0 34 64 62 124 C 84 174 150 158 180 124" class="ns-arc" />
            <path d="M 168 112 L 182 123 L 164 130" class="ns-arc" />
          </g>
          <text x="95" y="96" class="ns-nom-boucle">l’effet de boucle</text>
        {/if}
      </svg>

      {#if e >= 2 && e < 3}
        <div class="ns-bloc">
          <p class="ns-cite" lang="en">“The classifications of the social sciences are interactive. The classifications and concepts of the natural sciences are not.”</p>
          <p class="ns-src">Ian Hacking, <i>The Social Construction of What?</i>, Harvard University Press, 1999, p. 32</p>
        </div>
      {/if}
    </section>
  </div>

  {#if e >= 3}
    <div class="ns-verdict">
      <p class="ns-dur">Même logique. Conditions plus dures.</p>
      <p class="ns-clou" lang="en">“Complexity is likely to make our inferences less certain but should not make them any less scientific.”</p>
      <p class="ns-src">King, Keohane and Verba (1994), <i>Designing Social Inquiry</i>, p. 9-10</p>
    </div>
  {/if}
</div>

<style>
  .ns-deux { display: flex; flex-direction: column; gap: 0.8em; }
  .ns-cols { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; transition: opacity 0.45s; }
  .ns-cols.ns-recule { opacity: 0.3; }
  .ns-col { display: flex; flex-direction: column; gap: 0.45em; padding: 0.7em 0.9em 0.9em; border: 3px solid var(--dk-encre); }
  .ns-t { font-size: 0.72em; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris); }

  .ns-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; }
  .ns-scene text { font-family: var(--dk-mono); }

  /* La nature. */
  .ns-orbite { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 10 8; }
  /* La comète tourne autour du centre de l'arc (140, 250, rayon 150), qui
     est hors du viewBox : ce point suit le viewBox « 0 0 480 215 » du
     schéma, et changer l'un sans l'autre envoie la comète hors champ. */
  .ns-comete { transform-box: view-box; transform-origin: 140px 250px; animation: ns-tourne 7s ease-in-out infinite; }
  .ns-noyau { fill: var(--dk-encre); }
  .ns-queue { stroke: var(--dk-encre); stroke-width: 3; fill: none; }
  .ns-halo { fill: none; stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 4 6; }
  .ns-part { fill: var(--dk-encre); }
  .ns-leg { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }

  /* Les étiquettes qui tombent. */
  .ns-etq { animation: ns-tombe 0.5s cubic-bezier(0.34, 1.55, 0.64, 1) both; }
  .ns-etq.ns-tard { animation-delay: 0.35s; }
  .ns-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .ns-mot { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .ns-fil { stroke: var(--dk-encre); stroke-width: 2.5; stroke-dasharray: 5 5; }

  /* Le social. */
  .ns-regle { stroke: var(--dk-gris-2); stroke-width: 3; }
  .ns-corps { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-linecap: round; transition: stroke 0.5s 0.9s; }
  .ns-pers { transition: transform 0.9s cubic-bezier(0.34, 1.4, 0.64, 1) 0.9s; }
  .ns-pers.ns-bouge { transform: translateX(112px); }
  .ns-pers.ns-bouge .ns-corps { stroke: var(--dk-accent); }
  .ns-arc { fill: none; stroke: var(--dk-accent); stroke-width: 4.5; stroke-linecap: round; stroke-linejoin: round; stroke-dasharray: 1; stroke-dashoffset: 1; animation: ns-trace 0.9s ease-out 0.3s forwards; }
  .ns-boucle { pointer-events: none; }
  /* Halo couleur papier : la boucle passe derrière son nom, pas à travers. */
  .ns-nom-boucle { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; animation: ns-monte 0.5s ease-out 0.9s both; }

  /* Les citations. */
  .ns-bloc { display: flex; flex-direction: column; gap: 0.25em; animation: ns-monte 0.5s ease-out both; }
  .ns-cite { margin: 0; font-size: 0.8em; line-height: 1.35; font-weight: 600; color: var(--dk-encre); }
  /* La blague de Hacking garde l'encre et le gras : elle doit se lire comme
     une pointe, pas comme une note de bas de page. L'italique suffit. */
  .ns-cite.ns-pince { margin-top: 0.3em; font-style: italic; }
  .ns-src { margin: 0; font-size: 0.58em; line-height: 1.3; letter-spacing: 0.03em; color: var(--dk-gris); }
  .ns-src i { font-style: italic; }

  /* Le verdict. */
  .ns-verdict { display: flex; flex-direction: column; gap: 0.3em; border-left: 6px solid var(--dk-accent); padding: 0.3em 0 0.3em 0.9em; }
  .ns-dur { margin: 0; font-size: 1.15em; font-weight: 600; color: var(--dk-encre); animation: ns-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) both; }
  .ns-clou { margin: 0; font-size: 1em; line-height: 1.35; font-weight: 600; color: var(--dk-accent); animation: ns-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) 0.25s both; }
  .ns-verdict .ns-src { animation: ns-monte 0.4s ease-out 0.5s both; }

  @keyframes ns-tourne {
    0% { transform: rotate(-62deg); }
    50% { transform: rotate(62deg); }
    100% { transform: rotate(-62deg); }
  }
  @keyframes ns-tombe { from { opacity: 0; transform: translateY(-28px); } to { opacity: 1; transform: none; } }
  @keyframes ns-trace { to { stroke-dashoffset: 0; } }
  @keyframes ns-monte { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .ns-comete, .ns-etq, .ns-nom-boucle, .ns-bloc, .ns-dur, .ns-clou, .ns-verdict .ns-src { animation: none; }
    .ns-arc { animation: none; stroke-dashoffset: 0; }
    .ns-cols, .ns-pers, .ns-corps { transition: none; }
  }
</style>
