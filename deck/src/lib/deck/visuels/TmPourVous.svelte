<script>
  /**
   * Étape 7 du travail : la justification personnelle. Pourquoi ce sujet,
   * pour vous ? Deux moitiés, deux silhouettes : vous (le personnel) et
   * vous en chercheur.e (le professionnel, la loupe à la main). Les
   * questions viennent des consignes (partie 4) et du plan de l'enseignant.
   * Trois temps :
   *
   *   0  les deux silhouettes;
   *   1  le personnel : pourquoi ce sujet, pourquoi c'est important pour vous;
   *   2  le professionnel : ce que le sujet apporte à votre parcours.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const COTES = [
    { et: 'PERSONNEL', qs: ['Pourquoi ce sujet ?', 'Pourquoi c’est important pour vous ?'], loupe: false },
    { et: 'PROFESSIONNEL', qs: ['Qu’apporte-t-il à votre parcours ?'], loupe: true }
  ];
</script>

<div class="visuel tm-pv" bind:this={hote}>
  <div class="tm-pv-cotes">
    {#each COTES as c, i}
      <div class="tm-pv-cote" class:tm-on={e >= i + 1} class:tm-actif={e === i + 1}>
        <svg viewBox="0 0 160 150" aria-hidden="true">
          <circle cx="70" cy="42" r="26" class="tm-pv-sil" />
          <path d="M 22 146 Q 22 82 70 82 Q 118 82 118 146 Z" class="tm-pv-sil" />
          {#if c.loupe}
            <g class="tm-pv-loupe">
              <line x1="128" y1="104" x2="150" y2="132" />
              <circle cx="116" cy="88" r="22" />
            </g>
          {/if}
        </svg>
        <span class="tm-pv-et">{c.et}</span>
        <ul>
          {#each c.qs as q, k}<li style="--k: {k}">{q}</li>{/each}
        </ul>
      </div>
      {#if i === 0}<div class="tm-pv-sep" aria-hidden="true"></div>{/if}
    {/each}
  </div>
</div>

<style>
  .tm-pv { display: flex; flex-direction: column; gap: 1.2em; max-width: 58em; margin: 0 auto; }
  .tm-pv-cotes { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.6em; align-items: stretch; }
  .tm-pv-sep { width: 3px; background: var(--dk-encre); }
  .tm-pv-cote { display: flex; flex-direction: column; align-items: flex-start; gap: 0.4em; animation: tm-pv-f 0.45s both; }
  .tm-pv-cote svg { width: 8em; height: auto; }
  .tm-pv-sil { fill: var(--dk-gris-2); transition: fill 0.4s; }
  .tm-pv-cote.tm-on .tm-pv-sil { fill: var(--dk-encre); }
  .tm-pv-cote.tm-actif .tm-pv-sil { fill: var(--dk-accent); }
  .tm-pv-loupe line { stroke: var(--dk-encre); stroke-width: 9; stroke-linecap: square; }
  .tm-pv-loupe circle { fill: #fff; fill-opacity: 0.8; stroke: var(--dk-encre); stroke-width: 7; }
  .tm-pv-et { font-size: 0.8em; font-weight: 600; letter-spacing: 0.16em; color: var(--dk-gris); }
  .tm-pv-cote.tm-actif .tm-pv-et { color: var(--dk-accent); }
  .tm-pv-cote ul { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.35em; min-height: 5.6em; }
  .tm-pv-cote li { margin: 0; font-size: 1.15em; line-height: 1.3; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; transition-delay: calc(var(--k) * 200ms); }
  .tm-pv-cote.tm-on li { opacity: 1; transform: none; }
  @keyframes tm-pv-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .tm-pv-cote { animation: none; } .tm-pv-cote li, .tm-pv-sil { transition: none; } }
</style>
