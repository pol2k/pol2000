<script>
  /**
   * Dans aes(), ou hors de aes() ? Le même nuage de points (1 000
   * répondant.e.s de l'Étude électorale canadienne 2025 : l'opinion du Parti
   * conservateur et celle de Pierre Poilievre),
   * deux fois, avec colour = "blue" à deux endroits. Code et images réels :
   * GG.bleuAes et GG.bleu (src/lib/data/seance5_ggplot.js,
   * static/img/s5-g-bleu-aes.png et s5-g-bleu.png, rendus par
   * outils/seance5_ggplot.R).
   *
   *   0  À gauche, colour = "blue" dans aes() : R y voit une variable qui
   *      vaut toujours « blue ». Les points sortent saumon, avec une légende.
   *   1  À droite, colour = "blue" hors de aes() : une couleur fixe. Les
   *      points sortent bleus.
   *   2  Une ligne sous les deux : ce que fait aes().
   *
   * Dans les deux codes, colour = "blue" est encadré de rouge.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { GG } from '$lib/data/seance5_ggplot.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le code coupé en trois : avant, colour = "...", après. Surligné morceau par morceau.
  const decouper = (code) => {
    const m = code.match(/(?:colour|fill) = "[^"]*"/);
    const i = m ? m.index : code.length;
    const n = m ? m[0].length : 0;
    return [code.slice(0, i), code.slice(i, i + n), code.slice(i + n)].map(surlignerR);
  };

  const COLONNES = [
    {
      ...GG.bleuAes,
      ou: 'dans aes()',
      dit: 'R y voit une variable',
      alt: 'Nuage de points de l’opinion de Pierre Poilievre selon celle du Parti conservateur, aux points saumon, avec une légende colour qui affiche blue.'
    },
    {
      ...GG.bleu,
      ou: 'hors de aes()',
      dit: 'une couleur fixe',
      alt: 'Le même nuage de points, aux points bleus, sans légende.'
    }
  ].map((c) => ({ ...c, morceaux: decouper(c.code) }));
</script>

<div class="visuel dans-hors" bind:this={hote}>
  <div class="dh-colonnes">
    {#each COLONNES as c, i}
      <div class="dh-col" class:dh-vu={e >= i}>
        <div class="dh-titre"><b>{c.ou}</b>&#8239;: {c.dit}</div>
        <pre class="dh-code">{@html c.morceaux[0]}<span class="dh-cible">{@html c.morceaux[1]}</span>{@html c.morceaux[2]}</pre>
        <img class="dh-img" src="{base}/img/{c.image}" alt={c.alt} />
      </div>
    {/each}
  </div>
  <div class="dh-fin" class:dh-vu={e >= 2}><b>aes()</b> relie une variable à une propriété du dessin.</div>
</div>

<style>
  .dans-hors { display: flex; flex-direction: column; gap: 0.8em; }
  .dh-colonnes { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.4em; }
  .dh-col { display: flex; flex-direction: column; gap: 0.5em; min-width: 0; visibility: hidden; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s, visibility 0s 0.4s; }
  .dh-col.dh-vu { visibility: visible; opacity: 1; transform: none; transition: opacity 0.4s, transform 0.4s; }
  .dh-titre { font-size: 0.85em; line-height: 1.3; color: var(--dk-encre); }
  .dh-titre b { font-weight: 600; }
  .dh-code { margin: 0; font-family: var(--dk-mono); font-size: 0.72em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); padding: 0.55em 0.8em; color: var(--dk-encre); overflow: hidden; }
  .dh-cible { outline: 0.14em solid var(--dk-accent); outline-offset: 0.1em; }
  .dh-img { display: block; width: auto; height: auto; max-width: calc(100% - 4px); max-height: 19.6em; border: 2px solid var(--dk-encre); }
  .dh-fin { font-size: 0.9em; line-height: 1.4; color: var(--dk-encre); visibility: hidden; opacity: 0; transition: opacity 0.4s, visibility 0s 0.4s; }
  .dh-fin.dh-vu { visibility: visible; opacity: 1; transition: opacity 0.4s; }
  .dh-fin b { font-weight: 600; }

  @media (prefers-reduced-motion: reduce) {
    .dh-col, .dh-col.dh-vu, .dh-fin, .dh-fin.dh-vu { transition: none; transform: none; }
  }
</style>
