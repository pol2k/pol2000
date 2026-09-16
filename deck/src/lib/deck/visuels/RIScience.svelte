<script>
  /**
   * « On me dit que les RI, ce n'est pas une vraie science. Je réponds quoi ? »
   * La réponse n'est pas une consolation : la dispute a déjà lieu, à
   * l'intérieur du champ, dans sa revue phare, entre ses plus grands noms,
   * et elle se mène avec l'outil qu'on vient d'apprendre. Quatre temps.
   *
   *   0  L'accusation, en gris, hors champ : « Les RI, ce n'est pas
   *      vraiment une science. » Dessous, « on l'entend souvent ».
   *   1  Le forum. Le sommaire d'un numéro : American Political Science
   *      Review, vol. 91, no 4, décembre 1997, et quatre entrées qui
   *      arrivent l'une après l'autre (Vasquez p. 899-912, Waltz
   *      p. 913-917, Walt p. 931-935, et trois autres réponses).
   *      L'accusation rapetisse : elle est déjà dans la salle.
   *   2  Ce que chacun dit, en trois cartes. Vasquez applique le critère;
   *      Waltz rejette le test; Walt rejette l'étalon. Le sommaire se
   *      replie sur son bandeau pour leur laisser la place. Les citations
   *      françaises sont des traductions libres; les deux citations
   *      anglaises sont données dans l'original, donc sans mention.
   *   3  La réponse à donner : personne ne tranche de l'extérieur, et
   *      King, Keohane et Verba (1994, p. 9) en rouge.
   *
   * Le titre de Vasquez est rendu ici par une description de son argument,
   * en italique : ce n'est pas son titre original, donc pas de guillemets.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Espace fine insécable, pour les chaînes de caractères.
  const N = ' ';

  const ENTREES = [
    { qui: 'John Vasquez', quoi: 'Le paradigme réaliste est dégénératif', pp: 'p. 899-912' },
    { qui: 'Kenneth Waltz', quoi: 'Evaluating Theories', pp: 'p. 913-917' },
    { qui: 'Stephen Walt', quoi: 'The Progressive Power of Realism', pp: 'p. 931-935' }
  ];
</script>

<div class="visuel ri-sci" bind:this={hote}>
  {#if e < 2}
    <!-- L'accusation, hors champ. -->
    <div class="ri-charge" class:ri-mini={e >= 1}>
      <div class="ri-bulle">
        <p class="ri-dit-on">«{N}Les RI, ce n’est pas vraiment une science.{N}»</p>
        <!-- La queue de la bulle : un fond qui recouvre le filet du bas,
             puis les deux seules arêtes qui doivent se voir. -->
        <svg class="ri-queue" viewBox="0 0 40 30" aria-hidden="true">
          <path d="M 4 0 L 36 0 L 2 28 Z" class="ri-q-fond" />
          <path d="M 4 0 L 2 28 L 36 0" class="ri-q-trait" />
        </svg>
      </div>
      <span class="ri-souvent">on l’entend souvent</span>
    </div>
  {/if}

  {#if e >= 1}
    <!-- Le forum : un numéro de revue, et son sommaire. -->
    <div class="ri-revue">
      <div class="ri-tete">
        <span class="ri-titre">American Political Science Review</span>
        <span class="ri-numero">vol. 91, no 4, décembre 1997</span>
      </div>

      {#if e === 1}
        <ul class="ri-sommaire">
          {#each ENTREES as en, k}
            <li style="--k: {k}">
              <span class="ri-qui">{en.qui}</span>
              <span class="ri-quoi"><i>{en.quoi}</i></span>
              <span class="ri-pp">{en.pp}</span>
            </li>
          {/each}
          <li class="ri-reste" style="--k: 3"><span>et trois autres réponses</span></li>
        </ul>
      {/if}
    </div>
  {/if}

  {#if e === 2}
    <!-- Ce que chacun dit. -->
    <div class="ri-cartes">
      <article class="ri-carte" style="--k: 0">
        <svg class="ri-glyphe" viewBox="0 0 140 56" role="img" aria-label="Une règle posée sur un paradigme, et une flèche qui applique le critère.">
          <path d="M 70 2 L 70 14" class="ri-tr" />
          <path d="M 63 8 L 70 16 L 77 8" class="ri-tr ri-rg" />
          <rect x="12" y="22" width="116" height="20" class="ri-tr" />
          <path d="M 34 22 L 34 32 M 56 22 L 56 32 M 78 22 L 78 32 M 100 22 L 100 32" class="ri-tr ri-fin" />
        </svg>
        <span class="ri-nom">Vasquez</span>
        <span class="ri-tag">applique le critère</span>
        <p class="ri-txt">«{N}une réticence à préciser ce qui, s’il était réfuté, ferait rejeter le paradigme{N}»</p>
        <p class="ri-txt">«{N}l’adoption continuelle de propositions auxiliaires pour expliquer les ratés{N}»</p>
        <!-- La mention porte sur les deux citations ci-dessus, pas sur le
             résumé qui suit. -->
        <p class="ri-tl">(traduction libre)</p>
        <p class="ri-gloss">le programme réaliste dégénère</p>
      </article>

      <article class="ri-carte" style="--k: 1">
        <svg class="ri-glyphe" viewBox="0 0 140 56" role="img" aria-label="Un test coché, barré de rouge.">
          <rect x="52" y="8" width="36" height="36" class="ri-tr" />
          <path d="M 60 26 L 68 36 L 82 16" class="ri-tr" />
          <path d="M 18 8 L 122 48 M 122 8 L 18 48" class="ri-tr ri-rg" />
        </svg>
        <span class="ri-nom">Waltz</span>
        <span class="ri-tag">en réponse</span>
        <p class="ri-txt">«{N}Explanation, not prediction, is the ultimate criterion of good theory.{N}»</p>
        <p class="ri-gloss">il rejette le test lui-même</p>
      </article>

      <article class="ri-carte" style="--k: 2">
        <svg class="ri-glyphe" viewBox="0 0 140 56" role="img" aria-label="Une règle graduée, barrée de rouge.">
          <rect x="12" y="18" width="116" height="20" class="ri-tr" />
          <path d="M 34 18 L 34 28 M 56 18 L 56 28 M 78 18 L 78 28 M 100 18 L 100 28" class="ri-tr ri-fin" />
          <path d="M 18 8 L 122 48 M 122 8 L 18 48" class="ri-tr ri-rg" />
        </svg>
        <span class="ri-nom">Walt</span>
        <span class="ri-tag">en réponse</span>
        <p class="ri-txt">«{N}the Lakatosian model has been largely rejected by contemporary historians and philosophers of science{N}»</p>
        <p class="ri-gloss">il rejette l’étalon</p>
      </article>
    </div>
  {/if}

  {#if e >= 3}
    <div class="ri-fin">
      <p class="ri-encre">La question se débat à l’intérieur du champ, dans sa revue phare, entre ses plus grands noms. Personne ne tranche de l’extérieur.</p>
      <p class="ri-rouge">«{N}Le plus grand gain des règles de l’inférence survient précisément quand les données sont rares, les instruments imparfaits, les mesures incertaines.{N}»</p>
      <p class="ri-src">King, Keohane et Verba (1994), <i>Designing Social Inquiry</i>, p. 9 (traduction libre)</p>
      <p class="ri-rouge ri-clou">Ce n’est pas malgré la difficulté. C’est à cause d’elle.</p>
    </div>
  {/if}
</div>

<style>
  .ri-sci { display: flex; flex-direction: column; gap: 0.9em; }

  /* L'accusation. */
  /* Pas de transform dans l'animation d'arrivée : elle écraserait le
     rapetissement de .ri-mini, qui est une transition. */
  .ri-charge { display: flex; flex-direction: column; gap: 0.5em; align-items: flex-start; transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.5, 0.64, 1); transform-origin: 0 0; animation: ri-fondu 0.5s ease-out both; }
  .ri-charge.ri-mini { opacity: 0.42; transform: scale(0.72); }
  .ri-bulle { position: relative; border: 3px solid var(--dk-gris-2); padding: 0.6em 1em 0.7em; background: var(--dk-fond-2); }
  .ri-dit-on { margin: 0; font-size: 1.15em; font-weight: 600; color: var(--dk-gris); }
  .ri-queue { position: absolute; left: 2.2em; bottom: -27px; width: 40px; height: 30px; max-height: 44vh; display: block; overflow: visible; }
  .ri-q-fond { fill: var(--dk-fond-2); stroke: none; }
  .ri-q-trait { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-linejoin: miter; }
  .ri-souvent { margin-left: 3.4em; font-size: 0.66em; letter-spacing: 0.08em; color: var(--dk-gris-2); }

  /* Le forum. */
  .ri-revue { border: 3px solid var(--dk-encre); padding: 0.7em 1em 0.8em; animation: ri-entre 0.5s ease-out both; }
  .ri-tete { display: flex; flex-direction: column; gap: 0.15em; padding-bottom: 0.4em; border-bottom: 3px solid var(--dk-encre); }
  .ri-titre { font-size: 1.15em; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; }
  .ri-numero { font-size: 0.68em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }
  .ri-sommaire { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; }
  .ri-sommaire li { display: grid; grid-template-columns: 11em 1fr auto; gap: 0.8em; align-items: baseline; padding: 0.35em 0; border-bottom: 2px solid var(--dk-filet); animation: ri-monte 0.45s ease-out both; animation-delay: calc(var(--k) * 180ms + 150ms); }
  .ri-qui { font-size: 0.82em; font-weight: 600; }
  .ri-quoi { font-size: 0.78em; color: var(--dk-gris); }
  .ri-quoi i { font-style: italic; }
  .ri-pp { font-size: 0.7em; color: var(--dk-gris-2); }
  .ri-reste { display: block; border-bottom: none; }
  .ri-reste span { font-size: 0.72em; color: var(--dk-gris-2); }

  /* Les trois positions. */
  .ri-cartes { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .ri-carte { display: flex; flex-direction: column; gap: 0.3em; padding: 0.7em 0.8em 0.9em; border: 3px solid var(--dk-encre); animation: ri-monte 0.5s cubic-bezier(0.34, 1.5, 0.64, 1) both; animation-delay: calc(var(--k) * 160ms); }
  .ri-glyphe { width: 100%; max-height: 44vh; display: block; overflow: visible; }
  .ri-tr { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; stroke-dasharray: 1; stroke-dashoffset: 1; animation: ri-trace 0.6s ease-out both; animation-delay: calc(var(--k) * 160ms + 250ms); }
  .ri-tr.ri-fin { stroke-width: 2.5; }
  .ri-tr.ri-rg { stroke: var(--dk-accent); stroke-width: 5; animation-delay: calc(var(--k) * 160ms + 550ms); }
  .ri-nom { font-size: 1.15em; font-weight: 600; line-height: 1; }
  .ri-tag { align-self: flex-start; font-size: 0.6em; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-accent); border: 2px solid var(--dk-accent); padding: 0.15em 0.5em; }
  .ri-txt { margin: 0.15em 0 0; font-size: 0.72em; line-height: 1.35; color: var(--dk-encre); }
  .ri-gloss { margin: auto 0 0; padding-top: 0.4em; font-size: 0.72em; line-height: 1.3; font-weight: 600; color: var(--dk-accent); }
  .ri-tl { margin: 0.1em 0 0; font-size: 0.56em; letter-spacing: 0.04em; color: var(--dk-gris-2); }

  /* La réponse à donner. */
  .ri-fin { display: flex; flex-direction: column; gap: 0.35em; border-left: 6px solid var(--dk-accent); padding: 0.3em 0 0.3em 0.9em; }
  .ri-encre { margin: 0; font-size: 1em; line-height: 1.35; font-weight: 600; color: var(--dk-encre); animation: ri-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) both; }
  .ri-rouge { margin: 0; font-size: 1em; line-height: 1.35; font-weight: 600; color: var(--dk-accent); animation: ri-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) 0.25s both; }
  .ri-src { margin: 0; font-size: 0.58em; line-height: 1.3; letter-spacing: 0.03em; color: var(--dk-gris); animation: ri-monte 0.4s ease-out 0.45s both; }
  .ri-src i { font-style: italic; }
  .ri-clou { font-size: 1.15em; animation-delay: 0.65s; }

  @keyframes ri-fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes ri-entre { from { opacity: 0; transform: translateX(-1em); } to { opacity: 1; transform: none; } }
  @keyframes ri-monte { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }
  @keyframes ri-trace { to { stroke-dashoffset: 0; } }

  @media (prefers-reduced-motion: reduce) {
    .ri-charge, .ri-revue, .ri-sommaire li, .ri-carte, .ri-encre, .ri-rouge, .ri-src { animation: none; }
    .ri-tr { animation: none; stroke-dashoffset: 0; }
    .ri-charge { transition: none; }
  }
</style>
