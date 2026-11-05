<script>
  /**
   * Les côtés sombres de l'IA, en un coup d'œil : cinq tuiles, une par
   * thème, avec son pictogramme, son titre et son grand chiffre
   * ($lib/data/ia_risques.js). Pour l'ouverture de la section ou le rappel
   * à la fin.
   *
   * Pas de clic : les tuiles arrivent l'une après l'autre chaque fois que
   * la diapo entre à l'écran (IntersectionObserver). Sans animation, l'état
   * de repos est complet.
   */
  import { RISQUES } from '$lib/data/ia_risques.js';
  import M9RisquePicto from './M9RisquePicto.svelte';

  let joue = $state(false);
  let hote = $state(null);
  $effect(() => {
    if (!hote || typeof IntersectionObserver === 'undefined') return;
    const obs = new IntersectionObserver((vus) => (joue = vus[vus.length - 1].isIntersecting), { threshold: 0.5 });
    obs.observe(hote);
    return () => obs.disconnect();
  });
  const PAS = 0.4; // secondes entre deux tuiles
  // Un chiffre long passe à la ligne et rapetisse un peu.
  const taille = (n) => (String(n).length <= 9 ? 1.7 : String(n).length <= 14 ? 1.3 : 1.05);
</script>

<div class="visuel m9rs" class:joue bind:this={hote}>
  {#each RISQUES as r, i (r.cle)}
    <div class="m9rs-tuile" style="--i: {i}">
      <div class="m9rs-picto">
        <M9RisquePicto cle={r.cle} {joue} delai={0.2 + i * PAS} />
      </div>
      <strong class="m9rs-titre">{r.titre}</strong>
      <span class="m9rs-nombre" style="font-size: {taille(r.grand.nombre)}em">{r.grand.nombre}</span>
    </div>
  {/each}
</div>

<style>
  .m9rs { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 1.1em; max-width: 64em; margin: 1em auto 0; }
  .m9rs-tuile { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.5em; border: 3px solid var(--dk-encre); border-top-width: 8px; padding: 1em 0.7em 1.1em; }
  .m9rs-picto { width: 100%; aspect-ratio: 1; max-width: 7.5em; max-height: 24vh; }
  .m9rs-titre { font-size: 0.95em; line-height: 1.25; min-height: 2.5em; display: flex; align-items: center; }
  .m9rs-nombre { color: var(--dk-accent); font-weight: 700; line-height: 1.05; overflow-wrap: break-word; max-width: 100%; border-top: 2px solid var(--dk-encre); padding-top: 0.3em; }
  .joue .m9rs-tuile { animation: m9rs-arrive 0.45s ease-out both; animation-delay: calc(var(--i) * 0.4s); }
  @keyframes m9rs-arrive { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }
  /* Sur une diapo encre (ouverture de section) : filets en papier, chiffres en or. */
:global(.diapo.encre) .m9rs-tuile { border-color: var(--dk-fond); }
:global(.diapo.encre) .m9rs-nombre { color: var(--dk-accent-clair); border-top-color: var(--dk-fond); }
  @media (prefers-reduced-motion: reduce) { .joue .m9rs-tuile { animation: none; } }
</style>
