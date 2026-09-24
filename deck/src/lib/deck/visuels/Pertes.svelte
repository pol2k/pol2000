<script>
  /**
   * Chaque variable coûte des lignes. PERTES (outils/seance4_data.R) : le
   * nombre de personnes qui ont une réponse à toutes les colonnes de
   * df_clean, ajoutées une à une. Une barre par clic; puis ce que garde
   * drop_na() et ce qu'il retire; puis les deux leçons :
   *   1. retirer les NA seulement sur les variables de l'analyse
   *      (restants[2] = drop_na() sur age, ses_education, gauche_droite, par
   *      construction dans seance4_data.R; la colonne id de df_clean n'a
   *      aucun NA, le compte est donc le même);
   *   2. les personnes retirées peuvent être différentes de celles qui restent.
   * Tous les nombres viennent de PERTES; aucun n'est tapé ici.
   */
  import { brancherTemps } from '../temps.js';
  import { PERTES as P } from '$lib/data/seance4.js';

  const N = P.etapes.length;
  // Temps : 0 à N-1 les barres, N le bilan, N+1 la leçon 1, N+2 la leçon 2.
  const TOTAL = N + 2;
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const fin = P.restants[N - 1];
  const perdus = P.n - fin;
  const pctPerdus = Math.round((perdus / P.n) * 100);

  // Leçon 1 : une analyse qui n'utilise que les trois premières colonnes.
  const K = 2;
  const cols = P.etapes.slice(0, K + 1).join(', ');
</script>

<div class="visuel pertes" bind:this={hote}>
  {#each P.etapes as v, i}
    <div class="ligne" class:vu={i <= e} class:choisie={i === K && e >= N + 1}>
      <code>{i === 0 ? v : `+ ${v}`}</code>
      <div class="piste">
        <div class="barre" class:derniere={i === N - 1} style="width: {(P.restants[i] / P.n) * 100}%"></div>
        {#if i === N - 1}
          <div class="perte" class:vu={e >= N} style="left: {(fin / P.n) * 100}%">
            <span>−{milliers(perdus)}</span>
          </div>
        {/if}
      </div>
      <span class="n">{milliers(P.restants[i])}</span>
    </div>
  {/each}

  <p class="bilan" class:vu={e >= N}>
    drop_na() garde <strong>{milliers(fin)}</strong> personnes sur {milliers(P.n)} · <strong>{milliers(perdus)}</strong> retirées ({pctPerdus} %)
  </p>

  <ol class="lecons">
    <li class:vu={e >= N + 1}>
      <span>Retirer les NA seulement sur les variables de votre analyse<br />
        <code>drop_na(df_clean, {cols})</code> garde <strong class="encre">{milliers(P.restants[K])}</strong></span>
    </li>
    <li class:vu={e >= N + 2}>
      <span>Les personnes retirées ne sont pas tirées au hasard : elles peuvent être différentes de celles qui restent</span>
    </li>
  </ol>
</div>

<style>
  .pertes { display: flex; flex-direction: column; gap: 0.5em; max-width: 56em; margin: 0 auto; width: 100%; }
  .ligne { display: grid; grid-template-columns: 9.5em 1fr 5em; gap: 0.8em; align-items: center; visibility: hidden; font-size: 1.15em; }
  .ligne.vu { visibility: visible; animation: fondu 0.35s both; }
  code { font-family: var(--dk-mono); font-weight: 600; }
  .ligne code { text-align: right; }
  .piste { position: relative; height: 1.4em; border-left: 3px solid var(--dk-encre); }
  .barre { height: 100%; background: var(--dk-gris-2); transform-origin: left; transition: background 0.3s; }
  .vu .barre { animation: pousse 0.6s cubic-bezier(0.34, 1.2, 0.64, 1) both; }
  .barre.derniere { background: var(--dk-accent); }
  .choisie .barre { background: var(--dk-encre); }
  .choisie .n, .choisie code { color: var(--dk-encre); text-decoration: underline; text-decoration-thickness: 2px; text-underline-offset: 0.2em; }
  .n { font-variant-numeric: tabular-nums; font-weight: 600; text-align: right; }

  /* Ce que drop_na() retire : la place vide au bout de la dernière barre. */
  .perte { position: absolute; top: 0; right: 0; bottom: 0; box-sizing: border-box; border: 2px dashed var(--dk-accent); border-left: none; display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity 0.4s; }
  .perte.vu { opacity: 1; }
  .perte span { color: var(--dk-accent); font-weight: 600; font-variant-numeric: tabular-nums; }

  .bilan { margin: 0.3em 0 0; padding-top: 0.45em; border-top: 2px solid var(--dk-encre); font-size: 1.1em; visibility: hidden; }
  .bilan.vu { visibility: visible; animation: fondu 0.4s both; }
  .bilan strong { color: var(--dk-accent); }

  .lecons { list-style: none; padding: 0; margin: 0.2em 0 0; counter-reset: l; display: flex; flex-direction: column; gap: 0.45em; }
  .lecons li { counter-increment: l; display: grid; grid-template-columns: 1.3em 1fr; gap: 0.5em; align-items: baseline; font-size: 1.1em; line-height: 1.35; visibility: hidden; }
  .lecons li::before { content: counter(l); color: var(--dk-accent); font-weight: 600; }
  .lecons li.vu { visibility: visible; animation: fondu 0.4s both; }
  .lecons code { background: var(--dk-fond-2); padding: 0 0.25em; }
  .lecons strong.encre { color: var(--dk-encre); }

  @keyframes pousse { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .ligne.vu, .vu .barre, .bilan.vu, .lecons li.vu { animation: none; } .perte, .barre { transition: none; } }
</style>
