<script>
  /**
   * Un tableau de régression publié, recomposé dans le style du deck (les
   * trois filets de TabPublie) : la variable expliquée en tête, une ligne par
   * variable (coefficient, étoiles, puis la parenthèse dessous), le pied
   * (N, R²...) et les notes de l'article. Composant muet : il ne compte pas
   * les clics. ClEtude lui dit quoi surligner (prop `cle`).
   *
   * Les nombres arrivent déjà écrits, en chaînes, tels que dans l'article
   * (ClEtude.svelte, chaque ligne y cite sa page). Rien n'est recalculé ni
   * arrondi ici.
   *
   *   t     — { y, ysous, lignes: [{ nom, sous, b, et, par, cle, ellipse }],
   *            (`sous` : l'unité, sous le nom, sur la ligne de la parenthèse)
   *            pied: [[nom, valeur]], notes: [..] }
   *   cle   — vrai : la ligne marquée `cle` passe au rouge, le reste au gris.
   */
  let { t, cle = false } = $props();
</script>

<table class="cl-tab" class:cl-actif={cle}>
  <thead>
    <tr>
      <th class="cl-vide"></th>
      <th class="cl-y">{t.y}{#if t.ysous}<br /><span class="cl-sous">{t.ysous}</span>{/if}</th>
    </tr>
  </thead>
  <tbody>
    {#each t.lignes as l}
      {#if l.ellipse}
        <tr class="cl-ellipse"><th colspan="2">{l.nom}</th></tr>
      {:else}
        <tr class="cl-b" class:cl-on={l.cle}>
          <th class="cl-nom">{l.nom}</th>
          <td>{l.b}<span class="cl-et">{l.et ?? ''}</span></td>
        </tr>
        {#if l.par || l.sous}
          <tr class="cl-se" class:cl-on={l.cle}>
            <th class="cl-nom cl-sous">{l.sous ?? ''}</th>
            <td>{l.par ?? ''}<span class="cl-et"></span></td>
          </tr>
        {/if}
      {/if}
    {/each}
  </tbody>
  {#if t.pied?.length}
    <tbody class="cl-pied">
      {#each t.pied as p}
        <tr><th class="cl-nom">{p[0]}</th><td>{p[1]}<span class="cl-et"></span></td></tr>
      {/each}
    </tbody>
  {/if}
  <tfoot>
    <tr>
      <td colspan="2">
        {#each t.notes as n, i}{#if i}<br />{/if}{n}{/each}
      </td>
    </tr>
  </tfoot>
</table>

<style>
  /* Les filets d'un tableau d'article, comme TabPublie : trois traits pleins. */
  .cl-tab { border-collapse: collapse; width: auto; font-variant-numeric: tabular-nums; line-height: 1.2; color: var(--dk-encre); }
  .cl-tab th, .cl-tab td { font-family: var(--dk-mono); font-size: 1em; font-weight: 400; letter-spacing: 0; text-transform: none; color: var(--dk-encre); border: 0; padding: 0.1em 0.7em; transition: color 0.3s, background-color 0.3s; }
  .cl-tab .cl-y, .cl-tab .cl-vide { border-top: 2px solid var(--dk-encre); border-bottom: 2px solid var(--dk-encre); padding-top: 0.35em; padding-bottom: 0.35em; }
  .cl-tab .cl-y { text-align: right; font-weight: 600; }
  .cl-tab .cl-sous { font-weight: 400; font-size: 0.8em; color: var(--dk-gris); }
  .cl-tab .cl-nom { text-align: left; padding-right: 1.6em; white-space: nowrap; }
  .cl-tab td { text-align: right; white-space: nowrap; }
  .cl-tab .cl-b td, .cl-tab .cl-b th { padding-top: 0.4em; }
  .cl-tab .cl-se td { color: var(--dk-gris); }
  .cl-tab .cl-ellipse th { text-align: left; padding-top: 0.4em; font-size: 0.8em; color: var(--dk-gris); font-style: italic; }
  .cl-et { display: inline-block; width: 2.1em; text-align: left; padding-left: 0.12em; }
  .cl-tab .cl-pied tr:first-child th, .cl-tab .cl-pied tr:first-child td { border-top: 2px solid var(--dk-encre); padding-top: 0.35em; }
  .cl-tab .cl-pied tr:last-child th, .cl-tab .cl-pied tr:last-child td { padding-bottom: 0.35em; }
  .cl-tab tbody:not(.cl-pied) tr:last-child td, .cl-tab tbody:not(.cl-pied) tr:last-child th { padding-bottom: 0.35em; }
  .cl-tab tfoot td { border-top: 2px solid var(--dk-encre); text-align: left; font-size: 0.62em; color: var(--dk-gris); padding: 0.5em 0.7em 0; line-height: 1.5; white-space: normal; }

  /* Le surlignage : la ligne qu'on lit passe au rouge, le reste se retire. */
  .cl-actif th, .cl-actif td, .cl-actif .cl-sous { color: var(--dk-gris-2); }
  .cl-tab.cl-actif .cl-on th, .cl-tab.cl-actif .cl-on td, .cl-actif .cl-on .cl-sous { color: var(--dk-accent); }
  .cl-tab.cl-actif .cl-b.cl-on td { font-weight: 600; }
  .cl-tab.cl-actif .cl-on td, .cl-tab.cl-actif .cl-on th { background: rgba(198, 16, 46, 0.08); }
</style>
