<script>
  /**
   * Quatre façons, un résultat : la même variable (universitaire = 1 si
   * cpso3 >= 8, sinon 0, Étude électorale 1993) recodée dans quatre styles
   * qu'on croise dans le code des autres. Le cours enseigne le tidyverse et
   * case_when(); les trois autres, il faut savoir les lire. Six temps :
   *
   *   1  R de base (crochets)     2  ifelse()
   *   3  if_else() (tidyverse)    4  case_when() (tidyverse)
   *   5  le tableau, une seule fois : les quatre donnent le même
   *   6  case_when() est celle du cours
   *
   * Code et tableau : CONSOLES_PLUS.style_* (outils/seance4_plus.R), tels
   * que R les a exécutés. Les quatre vecteurs sont identiques selon
   * identical() (STYLES_IDENTIQUES); la coche n'apparaît que si c'est vrai
   * et si les quatre tableaux imprimés sont bien les mêmes.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import Copier from '../Copier.svelte';
  import { CONSOLES_PLUS, STYLES_IDENTIQUES } from '$lib/data/seance4_plus.js';

  const STYLES = [
    { cle: 'style_base', nom: 'R de base (crochets)' },
    { cle: 'style_ifelse', nom: 'ifelse()' },
    { cle: 'style_if_else', nom: 'if_else() (tidyverse)' },
    { cle: 'style_case_when', nom: 'case_when() (tidyverse)', cours: true }
  ].map((s) => ({ ...s, code: CONSOLES_PLUS[s.cle][0].in, tableau: CONSOLES_PLUS[s.cle][1] }));

  // Le tableau n'est montré qu'une fois : il doit être le même pour les quatre.
  const verif = STYLES[0].tableau;
  const memes = STYLES_IDENTIQUES && STYLES.every((s) => s.tableau.in === verif.in && s.tableau.out === verif.out);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 6, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel quatre" bind:this={hote}>
  <div class="grille">
    {#each STYLES as s, i}
      <figure class="carte-f" class:vue={e >= i + 1} class:cours={s.cours && e >= 6} class:efface={!s.cours && e >= 6}>
        <figcaption>
          <span class="nom">{s.nom}</span>
          {#if memes}<span class="coche" class:vue={e >= 5}>✓</span>{/if}
        </figcaption>
        <div class="enveloppe">
          <pre><code>{@html surlignerR(s.code)}</code></pre>
          <Copier texte={s.code} />
        </div>
      </figure>
    {/each}
  </div>

  <div class="bas" class:vue={e >= 5}>
    <div class="resultat">
      {#if memes}<span class="coches" aria-label="les quatre">✓ ✓ ✓ ✓</span>{/if}
      <pre class="sortie"><span class="prompt">&gt;</span> {@html surlignerR(verif.in)}<span class="out">{verif.out}</span></pre>
    </div>
    <p class="cours-l" class:vue={e >= 6}>Dans ce cours : le tidyverse, <b>case_when()</b>.</p>
  </div>
</div>

<style>
  .quatre { display: flex; flex-direction: column; gap: 0.8em; }
  .grille { display: grid; grid-template-columns: 1fr 1fr; gap: 0.7em 1em; align-items: stretch; }

  .carte-f { margin: 0; display: flex; flex-direction: column; gap: 0.3em; opacity: 0; transform: translateY(0.3em); transition: opacity 0.35s, transform 0.35s; }
  .carte-f.vue { opacity: 1; transform: none; }
  .carte-f.efface { opacity: 0.5; }
  figcaption { display: flex; justify-content: space-between; align-items: baseline; font-size: 0.78em; letter-spacing: 0.1em; font-weight: 600; color: var(--dk-gris); }
  .cours figcaption { color: var(--dk-accent); }

  .enveloppe { position: relative; flex: 1 1 auto; display: flex; }
  .enveloppe :global(.copier) { position: absolute; top: 0.4em; right: 0.4em; opacity: 0; }
  .enveloppe:hover :global(.copier) { opacity: 1; }
  pre { margin: 0; font-family: var(--dk-mono); line-height: 1.45; white-space: pre; }
  .enveloppe pre { flex: 1 1 auto; font-size: 0.84em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.34em solid var(--dk-gris-2); padding: 0.55em 0.8em; overflow-x: auto; transition: border-color 0.3s, background 0.3s; }
  .cours .enveloppe pre { background: #fff; border-color: var(--dk-accent); border-width: 3px; border-left-width: 0.34em; }
  /* deck.css habille tout <code> comme du code en ligne : fond, marge, taille. Pas ici. */
  .enveloppe code { background: none; padding: 0; font-size: 1em; }

  .coche { color: var(--dk-accent); font-size: 1.3em; opacity: 0; transition: opacity 0.3s; }
  .coche.vue { opacity: 1; }

  .bas { display: flex; flex-direction: column; gap: 0.55em; opacity: 0; transition: opacity 0.4s; }
  .bas.vue { opacity: 1; }
  .resultat { display: flex; align-items: center; gap: 1em; }
  .coches { color: var(--dk-accent); font-weight: 700; font-size: 1.1em; letter-spacing: 0.1em; white-space: nowrap; }
  .coches::after { content: ' ='; color: var(--dk-encre); }
  .sortie { flex: 1 1 auto; font-size: 0.86em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.34em solid var(--dk-accent); padding: 0.35em 0.8em 0.45em; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); }

  .cours-l { margin: 0; font-size: 1.15em; opacity: 0; transition: opacity 0.4s; }
  .cours-l.vue { opacity: 1; }
  .cours-l b { color: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) { .carte-f { transform: none; transition: none; } }
</style>
