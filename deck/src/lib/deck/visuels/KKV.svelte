<script>
  /**
   * Qui sont « KKV » ? Le livre et ses trois auteurs, juste avant les quatre
   * traits de la recherche scientifique qu'on leur emprunte. Trois temps.
   *
   *   0  Le livre : la couverture, en couleurs (c'est le seul objet coloré de
   *      la diapositive), son titre, son éditeur, son année.
   *   1  Les trois auteurs arrivent l'un après l'autre. L'initiale de chaque
   *      nom de famille est en rouge : King, Keohane, Verba. C'est de là que
   *      vient « KKV », qui se compose à droite.
   *   2  Le sous-titre du livre, et ce qu'il annonce : une même logique pour
   *      toute la recherche, qualitative ou quantitative.
   *
   * Faits : Designing Social Inquiry: Scientific Inference in Qualitative
   * Research, Princeton University Press, 1994. Sidney Verba, 1932-2019.
   * Les trois portraits sont recadrés et passés en gris pour former une
   * série ; les crédits figurent au bas de la diapositive.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const AUTEURS = [
    { prenom: 'Gary', initiale: 'K', reste: 'ing', ou: 'Harvard', img: 'kkv-king.jpg' },
    { prenom: 'Robert O.', initiale: 'K', reste: 'eohane', ou: 'Princeton', img: 'kkv-keohane.jpg' },
    { prenom: 'Sidney', initiale: 'V', reste: 'erba', ou: 'Harvard · 1932-2019', img: 'kkv-verba.jpg' }
  ];
</script>

<div class="visuel kkv-fig" bind:this={hote}>
  <div class="kkv-haut">
    <!-- Le livre. -->
    <figure class="kkv-livre">
      <img src="{base}/img/kkv-couverture.jpg" alt="Couverture du livre Designing Social Inquiry, de Gary King, Robert O. Keohane et Sidney Verba." />
      <figcaption>
        <span class="kkv-titre" lang="en">Designing Social Inquiry</span>
        <span class="kkv-edition">Princeton University Press · 1994</span>
      </figcaption>
    </figure>

    <!-- Les auteurs. -->
    <div class="kkv-droite">
      <div class="kkv-auteurs">
        {#each AUTEURS as a, i}
          <figure class="kkv-auteur" class:kkv-vu={e >= 1} style="--i: {i}">
            <img src="{base}/img/{a.img}" alt="Portrait de {a.prenom} {a.initiale}{a.reste}." />
            <figcaption>
              <span class="kkv-nom">{a.prenom} <b>{a.initiale}</b>{a.reste}</span>
              <span class="kkv-ou">{a.ou}</span>
            </figcaption>
          </figure>
        {/each}
      </div>

      <p class="kkv-sigle" class:kkv-vu={e >= 1} aria-label="KKV">
        <b>K</b><b>K</b><b>V</b><span>c’est eux</span>
      </p>
    </div>
  </div>

  <p class="kkv-bas" class:kkv-vu={e >= 2}>
    Sous-titre&#8239;: <span lang="en">“Scientific Inference in Qualitative Research”</span>. <em>Une seule logique, pour toute la recherche.</em>
  </p>

  <p class="kkv-credits">Photos&#8239;: gking.harvard.edu · Chatham House, CC BY 2.0 · Harvard file photo. Couverture&#8239;: Princeton University Press.</p>
</div>

<style>
  .kkv-fig { display: flex; flex-direction: column; gap: 0.7em; }
  .kkv-haut { display: grid; grid-template-columns: auto 1fr; gap: 2.2em; align-items: start; }

  figure { margin: 0; }

  /* Le livre : le seul objet en couleurs. Il penche un peu, comme posé. */
  .kkv-livre { display: flex; flex-direction: column; gap: 0.6em; animation: kkv-pose 0.6s cubic-bezier(0.34, 1.4, 0.64, 1) both; }
  .kkv-livre img { display: block; height: 46vh; width: auto; border: 3px solid var(--dk-encre); transform: rotate(-2deg); transform-origin: 50% 100%; }
  .kkv-livre figcaption { display: flex; flex-direction: column; gap: 0.15em; }
  .kkv-titre { font-size: 1.05em; font-weight: 600; line-height: 1.2; }
  .kkv-edition { font-size: 0.68em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); }

  .kkv-droite { display: flex; flex-direction: column; gap: 0.9em; min-width: 0; }
  .kkv-auteurs { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.1em; }

  .kkv-auteur { display: flex; flex-direction: column; gap: 0.45em; opacity: 0; transform: translateY(1.2em); transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.4, 0.64, 1); transition-delay: calc(var(--i) * 140ms); }
  .kkv-auteur.kkv-vu { opacity: 1; transform: none; }
  .kkv-auteur img { display: block; width: 100%; max-height: 32vh; aspect-ratio: 5 / 6; object-fit: cover; border: 3px solid var(--dk-encre); }
  .kkv-auteur figcaption { display: flex; flex-direction: column; gap: 0.1em; }
  .kkv-nom { font-size: 1em; font-weight: 600; line-height: 1.2; }
  .kkv-nom b { color: var(--dk-accent); font-weight: 600; font-size: 1.25em; }
  .kkv-ou { font-size: 0.66em; letter-spacing: 0.06em; color: var(--dk-gris); }

  /* Les trois initiales se rassemblent : KKV. */
  .kkv-sigle { margin: 0; display: flex; align-items: baseline; gap: 0.06em; opacity: 0; transform: translateX(-0.8em); transition: opacity 0.4s 0.5s, transform 0.5s cubic-bezier(0.34, 1.4, 0.64, 1) 0.5s; }
  .kkv-sigle.kkv-vu { opacity: 1; transform: none; }
  .kkv-sigle b { font-size: 2.6em; font-weight: 600; line-height: 1; letter-spacing: -0.02em; color: var(--dk-accent); }
  .kkv-sigle span { margin-left: 0.8em; font-size: 0.85em; color: var(--dk-gris); }

  .kkv-bas { margin: 0; min-height: 1.4em; font-size: 0.95em; line-height: 1.35; border-left: 0.34em solid var(--dk-accent); padding-left: 0.7em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.45s cubic-bezier(0.34, 1.4, 0.64, 1); }
  .kkv-bas.kkv-vu { opacity: 1; transform: none; }
  .kkv-bas em { font-style: normal; font-weight: 600; color: var(--dk-accent); }

  .kkv-credits { margin: 0; font-size: 0.5em; letter-spacing: 0.04em; color: var(--dk-gris-2); }

  @keyframes kkv-pose { from { opacity: 0; transform: translateY(-1em) rotate(3deg); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .kkv-livre { animation: none; }
    .kkv-auteur, .kkv-sigle, .kkv-bas { transition: none; }
  }
</style>
