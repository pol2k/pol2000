<script>
  /**
   * Les côtés sombres de l'IA : un thème par diapo, choisi par `cle`
   * (livres, detruits, existentiel, militaire, surveillance). Les faits
   * viennent de $lib/data/ia_risques.js. Au clic :
   *
   *   0  le pictogramme et le grand chiffre, avec sa légende;
   *   1  la frise : trois ou quatre événements datés;
   *   2  l'autre côté du débat, en encadré.
   *
   * Les sources, en petit, au pied. Le pictogramme se dessine à chaque
   * entrée de la diapo (IntersectionObserver); sans animation, l'état de
   * repos est complet.
   */
  import { brancherTemps } from '../temps.js';
  import { RISQUES } from '$lib/data/ia_risques.js';
  import M9RisquePicto from './M9RisquePicto.svelte';

  let { cle } = $props();
  const r = $derived(RISQUES.find((x) => x.cle === cle));

  let e = $state(0);
  let joue = $state(false);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  $effect(() => {
    if (!hote || typeof IntersectionObserver === 'undefined') return;
    const obs = new IntersectionObserver((vus) => (joue = vus[vus.length - 1].isIntersecting), { threshold: 0.5 });
    obs.observe(hote);
    return () => obs.disconnect();
  });

  // « 2025-06 » devient « juin 2025 »; une année seule reste telle quelle.
  const MOIS = ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'];
  function quand(d) {
    const [an, mois, jour] = String(d).split('-');
    if (!mois) return an;
    const m = MOIS[Number(mois) - 1] ?? mois;
    return jour ? `${Number(jour)} ${m} ${an}` : `${m} ${an}`;
  }
  // Un chiffre court s'affiche en très grand; un long, un peu moins, et passe à la ligne.
  const taille = (n) => (String(n).length <= 12 ? 4.4 : String(n).length <= 18 ? 3.4 : 2.6);
</script>

{#if r}
  <div class="visuel m9r" bind:this={hote}>
    <div class="m9r-haut">
      <div class="m9r-picto" role="img" aria-label={r.titre}>
        <M9RisquePicto cle={r.cle} {joue} />
      </div>
      <div class="m9r-grand" class:joue>
        <strong class="m9r-nombre" style="font-size: {taille(r.grand.nombre)}em">{r.grand.nombre}</strong>
        <span class="m9r-legende">{r.grand.legende}</span>
      </div>
    </div>

    <ol class="m9r-frise" class:vu={e >= 1} style="--n: {r.frise.length}">
      {#each r.frise as f, i}
        <li style="--i: {i}" class:dernier={i === r.frise.length - 1}>
          <span class="m9r-date">{quand(f.date)}</span>
          <span class="m9r-point" aria-hidden="true"></span>
          <span class="m9r-texte">{f.texte}</span>
        </li>
      {/each}
    </ol>

    {#if r.sources?.length}
      <p class="credits m9r-src">Sources&#8239;: {r.sources.join(' · ')}</p>
    {/if}
  </div>
{/if}

<style>
  .m9r { display: flex; flex-direction: column; gap: 1.1em; max-width: 64em; margin: 0.4em auto 0; }

  /* Le haut : le pictogramme, le grand chiffre. */
  .m9r-haut { display: grid; grid-template-columns: auto 1fr; align-items: center; gap: 2.2em; }
  .m9r-picto { width: 11em; height: 11em; max-height: 26vh; max-width: 26vh; }
  .m9r-grand { display: flex; flex-direction: column; gap: 0.35em; min-width: 0; }
  .m9r-nombre { color: var(--dk-accent); font-weight: 700; line-height: 1; letter-spacing: -0.02em; overflow-wrap: break-word; }
  .m9r-legende { font-size: 1.15em; line-height: 1.35; max-width: 34em; border-top: 3px solid var(--dk-encre); padding-top: 0.45em; }
  .m9r-grand.joue .m9r-nombre { animation: m9r-monte 0.6s ease-out both; animation-delay: 0.35s; }
  .m9r-grand.joue .m9r-legende { animation: m9r-fondu 0.5s both; animation-delay: 0.7s; }

  /* La frise : un axe (::before) qui se trace, des événements qui arrivent dans l'ordre. */
  .m9r-frise { list-style: none; margin: 0; padding: 0; position: relative; display: grid; grid-template-columns: repeat(var(--n), minmax(0, 1fr)); gap: 0 1.2em; }
  .m9r-frise::before { content: ''; position: absolute; left: calc(50% / var(--n)); right: calc(50% / var(--n)); top: calc(1.87em - 1.5px); height: 3px; background: var(--dk-encre); transform: scaleX(0); transform-origin: left; transition: transform 0.9s ease-in-out; }
  .m9r-frise.vu::before { transform: none; }
  .m9r-frise li { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; font-size: 1em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .m9r-frise.vu li { opacity: 1; transform: none; transition-delay: calc(0.15s + var(--i) * 0.28s); }
  .m9r-date { font-size: 0.85em; font-weight: 700; color: var(--dk-accent); line-height: 1.2; height: 1.2em; white-space: nowrap; }
  .m9r-point { width: 0.8em; height: 0.8em; background: var(--dk-encre); position: relative; z-index: 1; margin: 0.1em 0; }
  .dernier .m9r-point { background: var(--dk-accent); }
  .m9r-texte { font-size: 0.8em; line-height: 1.35; max-width: 18em; }

  /* L'autre côté. */
  .m9r-debat { display: grid; grid-template-columns: auto 1fr; align-items: stretch; border: 3px solid var(--dk-encre); opacity: 0; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s; }
  .m9r-debat.vu { opacity: 1; transform: none; }
  .m9r-etiq { display: flex; align-items: center; padding: 0 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 0.75em; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; white-space: nowrap; }
  .m9r-phrase { margin: 0; padding: 0.55em 0.9em; font-size: 1em; line-height: 1.4; }


  /* Sur une diapo encre : filets en papier, rouge remplacé par l'or. */
:global(.diapo.encre) .m9r-nombre, :global(.diapo.encre) .m9r-date { color: var(--dk-accent-clair); }
:global(.diapo.encre) .m9r-legende { border-top-color: var(--dk-fond); }
:global(.diapo.encre) .m9r-frise::before, :global(.diapo.encre) .m9r-point { background: var(--dk-fond); }
:global(.diapo.encre) .dernier .m9r-point { background: var(--dk-accent-clair); }
:global(.diapo.encre) .m9r-debat { border-color: var(--dk-fond); }
:global(.diapo.encre) .m9r-etiq { background: var(--dk-fond); color: var(--dk-encre); }

  @keyframes m9r-monte { from { opacity: 0; transform: translateY(0.25em); } to { opacity: 1; transform: none; } }
  @keyframes m9r-fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) {
    .m9r-grand.joue .m9r-nombre, .m9r-grand.joue .m9r-legende { animation: none; }
    .m9r-frise::before, .m9r-frise li, .m9r-debat { transition: none; }
    .m9r-frise.vu li { transition-delay: 0s; }
  }
</style>
