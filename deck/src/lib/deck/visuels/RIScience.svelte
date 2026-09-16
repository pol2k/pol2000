<script>
  /**
   * « On me dit que les RI, ce n'est pas une vraie science. Je réponds quoi ? »
   * La réponse n'est pas une consolation : la dispute a déjà lieu, à
   * l'intérieur du champ, entre ses plus grands noms, et elle se mène avec
   * l'outil qu'on vient d'apprendre (Lakatos). Quatre temps.
   *
   *   0  L'accusation, en gris, hors champ : « Les RI, ce n'est pas
   *      vraiment une science. » Dessous, « on l'entend souvent ».
   *   1  La salle. Une pièce encadrée, LES RELATIONS INTERNATIONALES, et
   *      dedans trois personnes qui s'engueulent déjà, chacune avec sa
   *      bulle. Les queues de bulles penchent vers les voisins : c'est une
   *      dispute, pas une liste. L'accusation rapetisse, elle est dépassée.
   *      L'ordre est celui de l'escalade : Vasquez applique le critère,
   *      Waltz rejette le test, Walt rejette l'étalon.
   *   2  La référence, petite, sous la salle : c'est la revue phare du
   *      champ, pas une chicane de corridor.
   *   3  La réponse à donner : personne ne tranche de l'extérieur, et
   *      King, Keohane et Verba (1994, p. 9) en rouge. Les trois reculent
   *      (bulles repliées, silhouettes atténuées) mais restent visibles :
   *      on parle d'eux pendant ce temps-là.
   *
   * Les citations françaises sont des traductions libres et le disent; les
   * deux citations anglaises sont données dans l'original, donc sans
   * mention. Rien n'est tiré au hasard : coordonnées fixes.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Espace fine insécable (U+202F), pour les chaînes de caractères.
  const N = ' ';

  // La queue de bulle penche vers un voisin : deux tracés fixes, un par
  // sens. Le fond recouvre le filet du bas, le trait n'en montre que les
  // deux arêtes utiles.
  const QUEUE = {
    d: { fond: 'M 2 0 L 30 0 L 42 28 Z', trait: 'M 2 0 L 42 28 L 30 0' },
    g: { fond: 'M 14 0 L 42 0 L 2 28 Z', trait: 'M 42 0 L 2 28 L 14 0' }
  };

  const GENS = [
    {
      qui: 'John Vasquez',
      dit: `«${N}le programme réaliste dégénère${N}: il ne dit jamais ce qui, s’il était réfuté, ferait abandonner le paradigme${N}»`,
      tl: true,
      tag: 'applique le critère de Lakatos',
      vers: 'd'
    },
    {
      qui: 'Kenneth Waltz',
      dit: `«${N}Explanation, not prediction, is the ultimate criterion of good theory.${N}»`,
      tl: false,
      tag: 'rejette le test lui-même',
      vers: 'g'
    },
    {
      qui: 'Stephen Walt',
      dit: `«${N}the Lakatosian model has been largely rejected by contemporary historians and philosophers of science${N}»`,
      tl: false,
      tag: 'rejette l’étalon',
      vers: 'g'
    }
  ];
</script>

<div class="visuel ri-sci" bind:this={hote}>
  <div class="ri-scene">
    <!-- L'accusation, hors champ. Elle ne disparaît jamais : c'est à elle
         qu'on répond. Elle rapetisse pour de bon (font-size), donc elle
         rend aussi sa place en largeur. -->
    <div class="ri-charge" class:ri-mini={e >= 1}>
      <div class="ri-bulle">
        <p class="ri-dit-on">«{N}Les RI, ce n’est pas vraiment une science.{N}»</p>
        <svg class="ri-queue" viewBox="0 0 44 30" aria-hidden="true">
          <path d={QUEUE.g.fond} class="ri-q-fond" />
          <path d={QUEUE.g.trait} class="ri-q-trait" />
        </svg>
      </div>
      <span class="ri-souvent">on l’entend souvent</span>
    </div>

    {#if e >= 1}
      <!-- La salle : la dispute est déjà à l'intérieur. -->
      <div class="ri-salle" class:ri-recule={e >= 3}>
        <span class="ri-salle-nom">Les relations internationales</span>

        <div class="ri-gens">
          {#each GENS as g, k (g.qui)}
            <article class="ri-perso" style="--k: {k}">
              {#if e < 3}
                <div class="ri-bulle-p">
                  <p class="ri-dit">{g.dit}</p>
                  {#if g.tl}<p class="ri-tl">(traduction libre)</p>{/if}
                  <svg class="ri-queue-p" viewBox="0 0 44 30" aria-hidden="true">
                    <path d={QUEUE[g.vers].fond} class="ri-q-fond" />
                    <path d={QUEUE[g.vers].trait} class="ri-q-trait ri-q-encre" />
                  </svg>
                </div>
              {/if}

              <div class="ri-pied">
                <svg class="ri-silhouette" viewBox="0 0 34 40" aria-hidden="true">
                  <circle cx="17" cy="10" r="8" />
                  <path d="M 4 40 L 4 32 L 11 26 L 23 26 L 30 32 L 30 40" />
                </svg>
                <span class="ri-nom">{g.qui}</span>
                <span class="ri-tag">{g.tag}</span>
              </div>
            </article>
          {/each}
        </div>
      </div>
    {/if}
  </div>

  {#if e >= 2}
    <!-- La référence arrive après coup, et petite : elle prouve la scène,
         elle n'est pas la scène. -->
    <p class="ri-cred">
      <span class="ri-revue"><i>American Political Science Review</i>, vol. 91, no 4, décembre 1997</span>
      <span class="ri-voix">Ce n’est pas une chicane de corridor. C’est la revue phare du champ.</span>
    </p>
  {/if}

  {#if e >= 3}
    <div class="ri-reponse">
      <p class="ri-encre">La question se débat à l’intérieur du champ, entre ses plus grands noms. Personne ne tranche de l’extérieur.</p>
      <p class="ri-rouge">«{N}Le plus grand gain des règles de l’inférence survient précisément quand les données sont rares, les instruments imparfaits, les mesures incertaines.{N}»</p>
      <p class="ri-src">King, Keohane et Verba (1994), <i>Designing Social Inquiry</i>, p. 9 (traduction libre)</p>
      <p class="ri-rouge ri-clou">Ce n’est pas malgré la difficulté. C’est à cause d’elle.</p>
    </div>
  {/if}
</div>

<style>
  .ri-sci { display: flex; flex-direction: column; gap: 0.7em; }
  .ri-scene { display: flex; align-items: flex-end; gap: 1.1em; }

  /* ——— L'accusation, hors champ ——— */
  /* Elle rapetisse par la taille de police, pas par un transform : tout ce
     qu'elle contient est dimensionné en em, donc le bloc rend aussi sa
     largeur à la salle, et aucune animation d'arrivée n'entre en conflit
     avec le rapetissement. */
  .ri-charge { flex: 0 0 auto; max-width: 15em; display: flex; flex-direction: column; gap: 0.5em; align-items: flex-start; transition: opacity 0.45s, font-size 0.5s; animation: ri-fondu 0.5s ease-out both; }
  .ri-charge.ri-mini { font-size: 0.58em; opacity: 0.55; }
  .ri-bulle { position: relative; border: 3px solid var(--dk-gris-2); padding: 0.6em 0.9em 0.7em; background: var(--dk-fond-2); }
  .ri-dit-on { margin: 0; font-size: 1.1em; font-weight: 600; line-height: 1.3; color: var(--dk-gris); }
  .ri-queue { position: absolute; left: 1.6em; bottom: calc(3px - 1.45em); width: 2.1em; height: 1.45em; max-height: 44vh; display: block; overflow: visible; }
  .ri-q-fond { fill: var(--dk-fond-2); stroke: none; }
  .ri-q-trait { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-linejoin: miter; vector-effect: non-scaling-stroke; }
  .ri-q-encre { stroke: var(--dk-encre); }
  /* La queue descend de 1.6em à 3.7em : la mention passe après, sinon le
     tracé lui mange sa première lettre. */
  .ri-souvent { margin-left: 4.3em; font-size: 0.66em; letter-spacing: 0.08em; color: var(--dk-gris-2); }

  /* ——— La salle ——— */
  /* L'étiquette coupe le filet du haut : une pièce, pas un en-tête de revue. */
  .ri-salle { position: relative; flex: 1 1 auto; min-width: 0; border: 3px solid var(--dk-encre); padding: 1.1em 1em 0.9em; transition: padding 0.45s; animation: ri-entre 0.5s ease-out both; }
  .ri-salle.ri-recule { padding: 1em 1em 0.7em; }
  .ri-salle-nom { position: absolute; top: -0.66em; left: 1.1em; padding: 0 0.5em; background: var(--dk-fond); font-size: 0.6em; font-weight: 600; letter-spacing: 0.18em; text-transform: uppercase; color: var(--dk-gris); }

  .ri-gens { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; }
  /* Les bulles n'ont pas la même hauteur : on les pose toutes sur le même
     fond de colonne, juste au-dessus des personnes. */
  .ri-perso { display: flex; flex-direction: column; justify-content: flex-end; gap: 0.9em; height: 100%; animation: ri-monte 0.5s cubic-bezier(0.34, 1.5, 0.64, 1) both; animation-delay: calc(var(--k) * 180ms + 120ms); }

  .ri-bulle-p { position: relative; border: 3px solid var(--dk-encre); background: var(--dk-fond-2); padding: 0.5em 0.65em 0.55em; }
  .ri-dit { margin: 0; font-size: 0.72em; line-height: 1.4; color: var(--dk-encre); }
  .ri-tl { margin: 0.3em 0 0; font-size: 0.55em; letter-spacing: 0.04em; color: var(--dk-gris-2); }
  /* La queue s'ancre du côté de la personne qui parle et penche vers les
     autres. Le sens est dans le tracé, pas dans le style: Vasquez penche
     vers la droite, les deux qui lui répondent penchent vers la gauche. */
  .ri-queue-p { position: absolute; left: 1.4em; bottom: calc(3px - 1.25em); width: 1.8em; height: 1.25em; max-height: 44vh; display: block; overflow: visible; }

  .ri-pied { display: flex; flex-direction: column; align-items: flex-start; gap: 0.25em; }
  .ri-silhouette { width: auto; height: 2em; max-height: 44vh; display: block; overflow: visible; fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; transition: height 0.45s, opacity 0.45s; }
  .ri-nom { font-size: 0.92em; font-weight: 600; line-height: 1.15; transition: opacity 0.45s; }
  .ri-tag { font-size: 0.58em; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; line-height: 1.25; color: var(--dk-accent); border-top: 2px solid var(--dk-accent); padding-top: 0.25em; transition: opacity 0.45s; }
  /* Au dernier temps, les trois reculent sans s'effacer : on les nomme à
     voix haute pendant que la réponse est à l'écran. */
  .ri-recule .ri-silhouette { height: 1.5em; opacity: 0.5; }
  .ri-recule .ri-nom { opacity: 0.8; }
  .ri-recule .ri-tag { opacity: 0.72; }

  /* ——— La référence, petite ——— */
  .ri-cred { margin: 0; display: flex; flex-wrap: wrap; align-items: baseline; gap: 0.15em 0.9em; border-left: 3px solid var(--dk-filet); padding-left: 0.7em; animation: ri-fondu 0.45s ease-out both; }
  .ri-revue { font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }
  .ri-revue i { font-style: italic; }
  .ri-voix { font-size: 0.7em; line-height: 1.3; color: var(--dk-gris); }

  /* ——— La réponse à donner ——— */
  .ri-reponse { display: flex; flex-direction: column; gap: 0.3em; border-left: 6px solid var(--dk-accent); padding: 0.25em 0 0.25em 0.9em; }
  .ri-encre { margin: 0; font-size: 0.95em; line-height: 1.35; font-weight: 600; color: var(--dk-encre); animation: ri-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) both; }
  .ri-rouge { margin: 0; font-size: 0.95em; line-height: 1.35; font-weight: 600; color: var(--dk-accent); animation: ri-monte 0.45s cubic-bezier(0.34, 1.55, 0.64, 1) 0.25s both; }
  .ri-src { margin: 0; font-size: 0.56em; line-height: 1.3; letter-spacing: 0.03em; color: var(--dk-gris); animation: ri-monte 0.4s ease-out 0.45s both; }
  .ri-src i { font-style: italic; }
  .ri-clou { font-size: 1.05em; animation-delay: 0.65s; }

  @keyframes ri-fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes ri-entre { from { opacity: 0; transform: translateX(-1em); } to { opacity: 1; transform: none; } }
  @keyframes ri-monte { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .ri-charge, .ri-salle, .ri-perso, .ri-cred, .ri-encre, .ri-rouge, .ri-src { animation: none; }
    .ri-charge, .ri-salle, .ri-silhouette, .ri-nom, .ri-tag { transition: none; }
  }
</style>
