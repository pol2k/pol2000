<script>
  /**
   * Chaque variable coûte des lignes. PERTES (outils/seance4_data.R) : le
   * nombre de personnes qui ont une réponse à toutes les colonnes de
   * df_propre, ajoutées une à une. Une barre par clic; au dernier, ce que
   * garde drop_na(). Un seul NA dans une colonne, et la ligne entière part.
   */
  import { brancherTemps } from '../temps.js';
  import { PERTES as P } from '$lib/data/seance4.js';

  const N = P.etapes.length;
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: N, lire: () => e, ecrire: (v) => (e = v) });
  });

  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const fin = P.restants[N - 1];
  const pct = Math.round((fin / P.n) * 100);
</script>

<div class="visuel pertes" bind:this={hote}>
  {#each P.etapes as v, i}
    <div class="ligne" class:vu={i <= e}>
      <code>{i === 0 ? v : `+ ${v}`}</code>
      <div class="piste">
        <div class="barre" class:derniere={i === N - 1} style="width: {(P.restants[i] / P.n) * 100}%"></div>
      </div>
      <span class="n">{milliers(P.restants[i])}</span>
    </div>
  {/each}
  <p class="bilan" class:vu={e >= N}>drop_na() garde <strong>{milliers(fin)}</strong> personnes sur {milliers(P.n)} · {pct} %</p>
</div>

<style>
  .pertes { display: flex; flex-direction: column; gap: 0.55em; max-width: 52em; margin: 0 auto; width: 100%; }
  .ligne { display: grid; grid-template-columns: 9.5em 1fr 4.6em; gap: 0.8em; align-items: center; visibility: hidden; }
  .ligne.vu { visibility: visible; animation: fondu 0.35s both; }
  code { font-family: var(--dk-mono); font-size: 0.9em; font-weight: 600; text-align: right; }
  .piste { height: 1.5em; border-left: 3px solid var(--dk-encre); }
  .barre { height: 100%; background: var(--dk-gris-2); transform-origin: left; }
  .vu .barre { animation: pousse 0.6s cubic-bezier(0.34, 1.2, 0.64, 1) both; }
  .barre.derniere { background: var(--dk-accent); }
  .n { font-variant-numeric: tabular-nums; font-weight: 600; text-align: right; }
  .bilan { margin: 0.5em 0 0; padding-top: 0.5em; border-top: 2px solid var(--dk-encre); font-size: 1.1em; visibility: hidden; }
  .bilan.vu { visibility: visible; animation: fondu 0.4s both; }
  .bilan strong { color: var(--dk-accent); }
  @keyframes pousse { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .ligne.vu, .vu .barre, .bilan.vu { animation: none; } }
</style>
