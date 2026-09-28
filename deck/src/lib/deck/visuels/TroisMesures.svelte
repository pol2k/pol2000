<script>
  /**
   * Trois façons de dire la même chose, sur l'exemple de la pomicultrice :
   * la statistique t, la valeur p et l'intervalle de confiance mènent au
   * même verdict. Trois tuiles, une par temps, puis le verdict commun.
   *
   *   0  La tuile t : t = 2,04, et la règle |t| ≥ 2.
   *   1  La tuile p : p = 0,047, et la règle p < 0,05.
   *   2  La tuile intervalle : de 100,1 à 109,9 g, et 100 est dehors.
   *   3  Une bande sous les trois : même verdict, on rejette H₀.
   *
   * Les nombres viennent de POMMES. Les verdicts sont calculés ici à partir
   * d'eux. Seuls 2 (la règle du pouce du livre, deux erreurs types) et 0,05
   * (la convention) sont écrits à la main.
   */
  import { brancherTemps } from '../temps.js';
  import { POMMES } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const fr = (v, d) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const REGLE_T = 2; // deux erreurs types (Arel-Bundock 2021, équation 4.6)
  const SEUIL = 0.05; // la convention
  const [BAS, HAUT] = POMMES.ic;
  const dehors = POMMES.h0 < BAS || POMMES.h0 > HAUT;

  const TUILES = [
    { quoi: 'la statistique t', val: `t = ${fr(POMMES.t, 2)}`, regle: `|t| ≥ ${REGLE_T}`, ok: Math.abs(POMMES.t) >= REGLE_T },
    { quoi: 'la valeur p', val: `p = ${fr(POMMES.p, 3)}`, regle: `p < ${fr(SEUIL, 2)}`, ok: POMMES.p < SEUIL },
    { quoi: 'l’intervalle à 95 %', val: `de ${fr(BAS, 1)} à ${fr(HAUT, 1)} g`, regle: `${POMMES.h0} est ${dehors ? 'dehors' : 'dedans'}`, ok: dehors }
  ];
  const tous = TUILES.every((t) => t.ok);
  const aucun = TUILES.every((t) => !t.ok);
  const verdict = tous ? 'on rejette H₀' : aucun ? 'on ne rejette pas H₀' : '';
</script>

<div class="visuel trois-mesures" bind:this={hote} role="img" aria-label="Trois façons de dire la même chose. La statistique t, {fr(POMMES.t, 2)}, dépasse {REGLE_T}. La valeur p, {fr(POMMES.p, 3)}, est sous {fr(SEUIL, 2)}. L’intervalle de confiance va de {fr(BAS, 1)} à {fr(HAUT, 1)} g, et {POMMES.h0} est {dehors ? 'dehors' : 'dedans'}. Même verdict&#8239;: {verdict}.">
  <div class="tm-tuiles">
    {#each TUILES as t, i}
      <div class="tm-tuile" class:tm-vu={e >= i} class:tm-ici={e === i}>
        <span class="tm-quoi">{t.quoi}</span>
        <span class="tm-val">{t.val}</span>
        <span class="tm-regle"><span class="tm-coche" class:tm-non={!t.ok}></span>{t.regle}</span>
      </div>
    {/each}
  </div>
  <div class="tm-verdict" class:tm-vu={e >= 3}>
    <span>{verdict ? 'même verdict' : 'verdicts différents'}{verdict ? ' : ' : ''}<strong>{verdict}</strong></span>
  </div>
</div>

<style>
  .trois-mesures { display: flex; flex-direction: column; gap: 1em; }
  .tm-tuiles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .tm-tuile { display: flex; flex-direction: column; align-items: flex-start; gap: 0.55em; border: 3px solid var(--dk-encre); padding: 0.9em 0.9em 1em; opacity: 0; visibility: hidden; transform: translateY(0.5em); transition: opacity 0.3s, transform 0.3s, visibility 0s 0.3s, border-color 0.3s; }
  .tm-tuile.tm-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.45s, transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1), visibility 0s, border-color 0.3s; }
  .tm-tuile.tm-ici { border-color: var(--dk-accent); }
  .tm-quoi { font-size: 0.66em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); }
  .tm-val { font-size: 1.4em; font-weight: 600; line-height: 1.15; white-space: nowrap; }
  .tm-regle { display: inline-flex; align-items: center; gap: 0.55em; font-size: 1em; font-weight: 600; color: var(--dk-accent); }
  /* La coche, dessinée : un L tourné. */
  .tm-coche { display: inline-block; width: 0.38em; height: 0.72em; margin: 0 0.15em 0.2em 0.1em; border-right: 0.16em solid var(--dk-accent); border-bottom: 0.16em solid var(--dk-accent); transform: rotate(45deg); }
  .tm-coche.tm-non { border-color: var(--dk-gris); }

  .tm-verdict { display: flex; justify-content: center; background: var(--dk-accent); color: var(--dk-fond); padding: 0.55em 1em; font-size: 1.25em; opacity: 0; visibility: hidden; transform: scaleX(0.9); transition: opacity 0.3s, transform 0.3s, visibility 0s 0.3s; }
  .tm-verdict.tm-vu { opacity: 1; visibility: visible; transform: none; transition: opacity 0.45s, transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1), visibility 0s; }
  .tm-verdict strong { font-weight: 600; }

  @media (prefers-reduced-motion: reduce) {
    .tm-tuile, .tm-tuile.tm-vu, .tm-verdict, .tm-verdict.tm-vu { transition: none; transform: none; }
  }
</style>
