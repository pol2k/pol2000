<script>
  /**
   * Un graphique ggplot2 qui se construit couche par couche. À gauche, le code
   * exact qui a dessiné l'image de droite ; à droite, l'image que R a rendue
   * avec ce code (GGPLOT dans src/lib/data/seance5.js, images
   * static/img/s5-*.png, les deux produits par outils/seance5_data.R). Rien
   * n'est redessiné ici : c'est la sortie de R.
   *
   *   etapes   : les clés de GGPLOT, dans l'ordre. La première est l'état 0,
   *              chaque clic passe à la suivante (total = etapes.length - 1).
   *   depart   : la clé de l'étape d'avant la première (facultatif). Sans
   *              elle, toutes les lignes de la première étape sont nouvelles.
   *   messages : montrer, sous le code, ce que R a répondu en dessinant
   *              (messages et avertissements réels, laissés en anglais).
   *
   * Les lignes nouvelles depuis l'étape précédente du même tableau `etapes`
   * portent une règle rouge à gauche. La comparaison ignore le « + » final :
   * ajouter une couche ne rend pas neuve la ligne d'avant.
   *
   * Toutes les images et tous les blocs de code sont rendus d'emblée, empilés
   * dans la même case : un seul est visible. Le passage d'une étape à l'autre
   * ne fait pas clignoter l'image et la mise en page ne saute pas. La colonne
   * de code prend la largeur de sa plus longue ligne (toutes étapes
   * confondues) ; l'image prend tout le reste, aussi haute que la diapo le
   * permet.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { GGPLOT } from '$lib/data/seance5.js';

  let { etapes = [], messages = true, depart = '' } = $props();

  const lignesDe = (k) => GGPLOT[k].code.split('\n');
  // Une ligne « déjà vue » : même texte, au « + » final et aux espaces près.
  const norme = (l) => l.trim().replace(/\s*\+$/, '');

  const ETAPES = $derived(
    etapes.map((k, i) => {
      const avant = i > 0 ? etapes[i - 1] : depart;
      const vues = new Set(avant && GGPLOT[avant] ? lignesDe(avant).map(norme) : []);
      return {
        cle: k,
        image: GGPLOT[k].image,
        lignes: lignesDe(k).map((l) => ({ html: surlignerR(l) || '&nbsp;', neuve: !vues.has(norme(l)) })),
        // Un seul message arrive comme une chaîne, plusieurs comme un tableau.
        messages: [].concat(GGPLOT[k].messages ?? [])
      };
    })
  );
  // La plus longue ligne, en caractères : fixe la largeur de la colonne de code.
  const CAR = $derived(Math.max(1, ...etapes.flatMap((k) => lignesDe(k).map((l) => [...l].length))));
  const total = $derived(Math.max(0, etapes.length - 1));

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || total === 0) return;
    e = 0;
    return brancherTemps(hote, { total, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel couches" bind:this={hote} style="--cc-car: {CAR}">
  <div class="cc-gauche">
    {#each ETAPES as s, i}
      <div class="cc-etape" class:cc-vu={i === e} aria-hidden={i !== e}>
        <div class="cc-code">
          {#each s.lignes as l}<div class="cc-l" class:cc-neuve={l.neuve}>{@html l.html}</div>{/each}
        </div>
        {#if messages && s.messages.length}
          <div class="cc-msg">
            <span class="cc-dit">R dit&#8239;:</span>
            {#each s.messages as m}<span class="cc-m">{m}</span>{/each}
          </div>
        {/if}
      </div>
    {/each}
  </div>
  <div class="cc-droite">
    {#each ETAPES as s, i}
      <img
        class="cc-img"
        class:cc-vu={i === e}
        src="{base}/img/{s.image}"
        alt="Le graphique que R dessine avec le code de gauche"
        aria-hidden={i !== e}
        decoding="async"
      />
    {/each}
  </div>
</div>

<style>
  .couches { display: flex; gap: 1em; align-items: flex-start; }

  /* La colonne de code : sa taille de police porte aussi le « ch » de la largeur. */
  .cc-gauche {
    flex: 0 0 auto;
    display: grid;
    font-size: 0.62em;
    /* La plus longue ligne, les marges de la règle et du bloc, un demi-caractère de jeu. */
    width: calc((var(--cc-car) + 0.5) * 1ch + 1.8em + 4px);
    max-width: 48%;
  }
  .cc-etape { grid-area: 1 / 1; display: flex; flex-direction: column; gap: 0.7em; visibility: hidden; opacity: 0; transition: opacity 0.3s, visibility 0s 0.3s; }
  .cc-etape.cc-vu { visibility: visible; opacity: 1; transition: opacity 0.3s; }

  .cc-code { background: var(--dk-fond-2); border: 2px solid var(--dk-encre); padding: 0.6em 0.9em 0.6em 0; color: var(--dk-encre); }
  .cc-l { white-space: pre-wrap; overflow-wrap: anywhere; line-height: 1.5; border-left: 0.3em solid var(--dk-fond-2); padding-left: 0.6em; }
  .cc-l.cc-neuve { border-left-color: var(--dk-accent); background: var(--dk-fond); }

  /* Ce que R répond : petit, gris, tel quel. */
  .cc-msg { display: flex; flex-direction: column; gap: 0.25em; font-size: 0.82em; line-height: 1.35; color: var(--dk-gris); }
  .cc-dit { font-weight: 600; letter-spacing: 0.04em; }
  .cc-m { white-space: pre-wrap; overflow-wrap: anywhere; padding-left: 1em; }

  /* L'image : toute la place qui reste, aussi haute que la diapo le permet. */
  .cc-droite { flex: 1 1 0; min-width: 0; display: grid; grid-template-columns: minmax(0, 1fr); }
  .cc-img {
    grid-area: 1 / 1;
    justify-self: start;
    display: block;
    width: auto;
    height: auto;
    max-width: calc(100% - 4px);
    max-height: min(68vh, 24.5em);
    border: 2px solid var(--dk-encre);
    opacity: 0;
    visibility: hidden;
    transition: opacity 0s 0.35s, visibility 0s 0.35s;
  }
  /* La nouvelle image se pose sur l'ancienne, qui ne s'efface qu'ensuite : pas d'éclair. */
  .cc-img.cc-vu { opacity: 1; visibility: visible; z-index: 1; transition: opacity 0.3s; }

  @media (prefers-reduced-motion: reduce) {
    .cc-etape, .cc-etape.cc-vu, .cc-img, .cc-img.cc-vu { transition: none; }
  }
</style>
