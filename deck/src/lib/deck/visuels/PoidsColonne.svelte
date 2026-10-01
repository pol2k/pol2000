<script>
  /**
   * Le poids, une variable comme les autres. Après « Pondérer » : on montre
   * où le poids vit dans les données, et ce qu'on en fait. Quatre temps.
   *
   *   0  df_clean, six vraies lignes (id, age, gauche_droite) et « … » :
   *      une ligne par répondant.e.
   *   1  La ligne de R qui ajoute le poids, et la colonne poids qui arrive, en
   *      rouge, avec les vrais poids de ces six personnes.
   *   2  À gauche, la console : la moyenne d'âge brute, puis pondérée, telle
   *      que R l'imprime (le filter() retire les 61 répondant.e.s sans poids).
   *   3  Les fonctions de R prennent le poids : weights = poids dans lm(), et
   *      weight = poids dans aes() de ggplot(). Du code seulement, sans sortie :
   *      la régression vient le 15 octobre.
   *
   * Les lignes et la console viennent de POIDS_LIGNES et CONSOLE_POIDS
   * (src/lib/data/seance5_normale.js, produits par outils/seance5_normale.R,
   * variable cps25_weight_general_all de la CES 2025). Les deux appels du
   * temps 3 sont écrits ici : ce sont des gabarits, pas des sorties.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { POIDS_LIGNES, CONSOLE_POIDS } from '$lib/data/seance5_normale.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const AJOUT = CONSOLE_POIDS[0].in;
  const MOYENNE = CONSOLE_POIDS[1];
  const LM = 'lm(gauche_droite ~ age, data = df_clean,\n   weights = poids)';
  const GG = 'ggplot(df_clean, aes(x = age, y = gauche_droite,\n                     weight = poids))';
</script>

<div class="visuel poids-colonne" bind:this={hote}>
  <!-- 1 : la ligne qui ajoute le poids. -->
  <pre class="code ajout" class:vu={e >= 1}><span class="prompt">&gt;</span> {@html surlignerR(AJOUT)}</pre>

  <div class="rangee">
    <!-- 0 et 1 : la table. -->
    <div class="table-bloc">
      <table class="df">
        <thead>
          <tr><th>id</th><th>age</th><th>gauche_droite</th><th class="poids" class:vu={e >= 1}>poids</th></tr>
        </thead>
        <tbody>
          {#each POIDS_LIGNES as l, i}
            <tr>
              <td>{l.id}</td><td>{l.age}</td><td class:na={l.gauche_droite === 'NA'}>{l.gauche_droite}</td>
              <td class="poids" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 300 + i * 80 : 0}ms">{l.poids}</td>
            </tr>
          {/each}
          <tr class="suite"><td>…</td><td>…</td><td>…</td><td class="poids" class:vu={e >= 1}>…</td></tr>
        </tbody>
      </table>
      <p class="legende">{e >= 1 ? 'le poids : une variable comme les autres' : 'df_clean : une ligne par répondant.e'}</p>
    </div>

    <!-- 2 puis 3 : ce qu'on en fait. -->
    <div class="usages">
      <div class="bloc" class:vu={e >= 2}>
        <p class="titre">la moyenne d’âge, brute puis pondérée</p>
        <pre class="code"><span class="prompt">&gt;</span> {@html surlignerR(MOYENNE.in)}</pre>
        <pre class="code sortie">{MOYENNE.out}</pre>
      </div>
      <div class="bloc" class:vu={e >= 3}>
        <p class="titre">les fonctions de R l’acceptent</p>
        <pre class="code">{@html surlignerR(LM)}</pre>
        <pre class="code">{@html surlignerR(GG)}</pre>
        <p class="note">la régression&#8239;: le 15 octobre</p>
      </div>
    </div>
  </div>
</div>

<style>
  .poids-colonne { display: flex; flex-direction: column; gap: 0.6em; font-size: 0.82em; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.45; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left: 0.3em solid var(--dk-accent); padding: 0.35em 0.7em; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .sortie { color: var(--dk-encre); font-weight: 600; border-left-color: var(--dk-encre); background: var(--dk-fond); }
  .ajout { opacity: 0; transition: opacity 0.4s; }
  .ajout.vu { opacity: 1; }
  .rangee { display: grid; grid-template-columns: auto 1fr; gap: 1.6em; align-items: start; }
  .df { border-collapse: collapse; font-family: var(--dk-mono); font-size: 1.05em; }
  .df th, .df td { border: 2px solid var(--dk-encre); padding: 0.15em 0.7em; text-align: right; line-height: 1.3; }
  .df th { background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; text-transform: none; letter-spacing: 0; font-size: 1em; }
  .df td.na { color: var(--dk-gris); }
  .df .suite td { color: var(--dk-gris); text-align: center; padding: 0.05em 0.7em; line-height: 1.2; }
  .table-bloc { padding-bottom: 0.2em; }
  .df tr:last-child td { border-bottom: 2px solid var(--dk-encre); }
  .df tr:last-child td.poids { border-bottom-color: var(--dk-accent); }
  .df .poids { opacity: 0; transform: translateX(1.2em); transition: opacity 0.4s, transform 0.4s; }
  .df .poids.vu { opacity: 1; transform: none; }
  .df th.poids { background: var(--dk-accent); border-color: var(--dk-accent); }
  .df td.poids { color: var(--dk-accent); font-weight: 700; border-color: var(--dk-accent); }
  .legende { margin: 0.4em 0 0; color: var(--dk-gris); font-size: 0.9em; }
  .usages { display: flex; flex-direction: column; gap: 0.9em; }
  .bloc { display: flex; flex-direction: column; gap: 0.3em; opacity: 0; transition: opacity 0.4s; }
  .bloc.vu { opacity: 1; }
  .titre { margin: 0; font-weight: 700; font-size: 0.95em; }
  .note { margin: 0; color: var(--dk-accent); font-weight: 600; font-size: 0.85em; }
  @media (prefers-reduced-motion: reduce) {
    .ajout, .df .poids, .bloc { transition: none; }
  }
</style>
