<script>
  /**
   * La mentalité à adopter : on ne résout pas un problème d'un coup, on le
   * casse en morceaux et on les fait dans l'ordre. Quatre temps :
   *   0  la question, d'un bloc, trop grosse pour être codée ;
   *   1  le bloc se fend en quatre briques, une tâche chacune ;
   *   2  chaque brique devient une ligne de R, les vraies lignes de la
   *      séance (Étude électorale canadienne 2025) ;
   *   3  les trois règles, en autocollants.
   */
  import { brancherTemps } from '../temps.js';
  const BRIQUES = [
    { t: 'lire les données', code: 'df <- get_ces("2025")' },
    { t: 'nettoyer les données', code: 'd2 <- df |>\n  filter(cps25_votechoice %in% c(1:5, 8), cps25_income <= 8) |>\n  mutate(conservateur = cps25_votechoice == 2)' },
    { t: 'faire une régression', code: 'lm(conservateur ~ cps25_income, data = d2)' },
    { t: 'faire un graphique', code: 'ggplot(d2, aes(x = cps25_income, y = conservateur)) + geom_smooth(method = "lm")' }
  ];
  const REGLES = [
    ['Un morceau à la fois', 'Si une étape vous semble grosse, c’est qu’elle se coupe encore en deux.'],
    ['Une ligne, puis on vérifie', 'On tape une ligne, on regarde ce qu’elle a fait, on passe à la suivante. Jamais vingt lignes d’un coup.'],
    ['Ça va planter, c’est prévu', 'Une erreur n’abîme rien. On la lit, on corrige la ligne, on relance.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel mentalite" bind:this={hote}>
  {#if e === 0}
    <div class="bloc">
      <span class="q">Le revenu influence-t-il le vote ?</span>
      <span class="s">Personne ne code ça d’un coup.</span>
    </div>
  {:else}
    <div class="briques" class:code={e === 2}>
      {#each BRIQUES as b, i}
        <div class="brique" style="animation-delay: {i * 120}ms">
          <span class="n">{i + 1}</span>
          <div class="txt">
            <span class="t">{b.t}</span>
            {#if e === 2}<code>{b.code}</code>{/if}
          </div>
        </div>
      {/each}
    </div>
  {/if}
  <div class="bas">
    {#if e === 0}
      <p class="mot">Trop gros. <strong>Donc on coupe.</strong></p>
    {:else if e === 1}
      <p class="mot">Quatre petites tâches. Chacune se dit en français, en trois mots. <strong>Ça, ça se code.</strong></p>
    {:else if e === 2}
      <p class="mot">Chaque morceau tient en quelques lignes. Le code, ce n’est que ça : <strong>des petits morceaux, dans l’ordre.</strong></p>
    {:else}
      <div class="regles">
        {#each REGLES as [t, s], i}
          <div class="regle" style="--rot: {[-2, 1.5, -1][i]}deg; animation-delay: {i * 140}ms">
            <strong>{t}</strong>
            <span>{s}</span>
          </div>
        {/each}
      </div>
    {/if}
  </div>
</div>

<style>
  .mentalite { display: flex; flex-direction: column; gap: 1em; justify-content: center; }
  /* Le bloc, d'une pièce. */
  .bloc { border: 5px solid var(--dk-encre); background: var(--dk-encre); color: var(--dk-fond); padding: 1.6em 1.4em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.6em; animation: tremble 0.6s 0.4s ease-in-out 2; }
  .q { font-size: 2.4em; font-weight: 600; line-height: 1.1; letter-spacing: -0.03em; }
  .s { font-size: 0.9em; color: var(--dk-gris-2); }
  @keyframes tremble { 0%, 100% { transform: none; } 25% { transform: translateX(-0.3em) rotate(-0.6deg); } 75% { transform: translateX(0.3em) rotate(0.6deg); } }
  /* Les briques. */
  .briques { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.7em; }
  .briques.code { grid-template-columns: 1fr; gap: 0.45em; }
  .brique { border: 3px solid var(--dk-encre); background: var(--dk-accent); color: #fff; padding: 0.9em 0.8em; display: flex; flex-direction: column; align-items: center; gap: 0.4em; text-align: center; animation: eclate 0.55s cubic-bezier(0.2, 1.3, 0.4, 1) both; }
  .code .brique { flex-direction: row; text-align: left; background: var(--dk-fond); color: var(--dk-encre); padding: 0.5em 0.9em; gap: 0.9em; }
  .n { font-family: var(--dk-mono); font-size: 1.8em; font-weight: 600; line-height: 1; }
  .code .n { color: var(--dk-accent); font-size: 1.5em; width: 1.2em; }
  .txt { display: flex; flex-direction: column; gap: 0.15em; min-width: 0; }
  .t { font-size: 0.95em; font-weight: 600; line-height: 1.2; }
  .code .t { font-size: 0.72em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .brique code { background: none; padding: 0; font-size: 0.95em; line-height: 1.4; color: var(--dk-encre); white-space: pre-wrap; overflow-wrap: anywhere; }
  @keyframes eclate { from { opacity: 0; transform: scale(0.4) rotate(-8deg); } to { opacity: 1; transform: none; } }
  /* Le mot du bas, et les règles. */
  .bas { min-height: 4em; display: flex; align-items: center; }
  .mot { margin: 0; font-size: 1.3em; line-height: 1.35; border-left: 0.34em solid var(--dk-accent); padding-left: 0.8em; animation: fondu 0.4s both; }
  .mot strong { color: var(--dk-accent); }
  .regles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; width: 100%; }
  .regle { border: 3px solid var(--dk-encre); background: #fff; padding: 1em 1em 0.9em; display: flex; flex-direction: column; gap: 0.4em; transform: rotate(var(--rot)); animation: colle 0.5s cubic-bezier(0.2, 1.4, 0.4, 1) both; }
  .regle strong { font-size: 1.2em; line-height: 1.15; }
  .regle span { font-size: 0.78em; line-height: 1.4; color: var(--dk-gris); }
  @keyframes colle { from { opacity: 0; transform: rotate(var(--rot)) scale(0.6); } to { opacity: 1; transform: rotate(var(--rot)) scale(1); } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
