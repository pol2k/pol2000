<script>
  /**
   * Retour sur la séance 8 (M8Escalier) : la pente de la scolarité sur
   * l'intérêt pour la politique, un contrôle de plus par rangée, les mêmes
   * 877 personnes. La rangée « + revenu » est mise en évidence : le revenu
   * est un descendant de la scolarité (scolarité → revenu → intérêt), le
   * contrôler coupe une partie de l'effet (condition 1, Arel-Bundock 2021,
   * p. 124-125). La pente baisse justement à cette rangée.
   *
   * Rien n'est calculé ici : tout vient de ESCALIER (src/lib/data/seance8.js,
   * outils/seance8_data.R). Le graphe d'à côté est un schéma (nos
   * hypothèses), dessiné par Goa sur la diapo.
   */
  import { ESCALIER } from '$lib/data/seance8.js';

  let { marque = false } = $props();
  const f = (v) => v.toFixed(3).replace('.', ',');
</script>

<div class="visuel m11e">
  <p class="m11e-tete">Séance 8 · pente de la scolarité</p>
  <table>
    <tbody>
      {#each ESCALIER.modeles as m (m.ajout)}
        <tr class:marque={marque && m.ajout === '+ revenu'}>
          <td class="m11e-aj">{m.ajout === 'seule' ? 'scolarité seule' : m.ajout}</td>
          <td class="m11e-b">{f(m.b)}</td>
        </tr>
      {/each}
    </tbody>
  </table>
  <p class="m11e-cap">CES 2025 · les mêmes personnes à chaque rangée</p>
</div>

<style>
  .m11e { display: flex; flex-direction: column; gap: 0.4em; min-width: 16em; }
  .m11e-tete { margin: 0; font-weight: 700; font-size: 0.95em; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.3em; }
  table { border-collapse: collapse; width: 100%; font-size: 1.05em; }
  td { padding: 0.32em 0.4em; border-bottom: 1px solid var(--dk-filet); }
  .m11e-b { text-align: right; font-weight: 700; font-variant-numeric: tabular-nums; }
  tr.marque td { color: var(--dk-accent); border-bottom: 3px solid var(--dk-accent); }
  .m11e-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
</style>
