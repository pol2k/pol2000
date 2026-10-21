<script>
  /**
   * La constante, puis des profils. Le modèle de la séance 7 (notre sondage,
   * MULTI) prédit l'intérêt de n'importe quel profil : on remplit chaque
   * variable, R fait le calcul (predict()).
   *
   *   0  « tout à zéro » : homme, 18 ans, secondaire non terminé, revenu le
   *      plus bas, hors Québec. Sa prédiction, c'est la constante;
   *   1  Camille;
   *   2  Robert.
   *
   * Les prénoms et les profils sont fictifs; les prédictions sont celles de
   * R (PROFILS, src/lib/data/seance8.js). Sur 10, comme la question.
   */
  import { brancherTemps } from '../temps.js';
  import { PROFILS, MULTI } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: PROFILS.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
</script>

<div class="visuel m8pr" bind:this={hote}>
  {#each PROFILS as p, i}
    <div class="carte" class:vu={e >= i} class:zero={i === 0}>
      <strong class="nom">{p.nom}</strong>
      <ul>{#each p.desc as d}<li>{d}</li>{/each}</ul>
      <div class="pred">
        <span class="chiffre">{f(p.prediction * 10)}</span><span class="sur">sur 10</span>
      </div>
      <div class="jauge"><span style="width: {p.prediction * 100}%"></span></div>
      {#if i === 0}<em>= la constante</em>{/if}
    </div>
  {/each}
</div>
<p class="m8pr-source">Profils et prénoms fictifs · prédictions de R, modèle de la séance 7 ({MULTI.n_modele} personnes de notre sondage)</p>

<style>
  .m8pr { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 60em; margin: 1em auto 0; }
  .carte { border: 3px solid var(--dk-encre); padding: 1.2em 1.3em; display: flex; flex-direction: column; gap: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .carte.vu { opacity: 1; transform: none; }
  .carte.zero { border-color: var(--dk-accent); }
  .nom { font-size: 1.35em; }
  ul { list-style: none; margin: 0; padding: 0; font-size: 0.85em; color: var(--dk-gris); line-height: 1.5; }
  .pred { display: flex; align-items: baseline; gap: 0.4em; margin-top: 0.3em; }
  .chiffre { font-size: 2.8em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .sur { font-size: 0.9em; color: var(--dk-gris); }
  .jauge { height: 0.6em; background: var(--dk-fond-2); }
  .jauge span { display: block; height: 100%; background: var(--dk-encre); }
  em { font-style: normal; font-weight: 600; color: var(--dk-accent); }
  .m8pr-source { margin: 0.9em auto 0; max-width: 60em; font-size: 0.6em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .carte { transition: none; transform: none; } }
</style>
